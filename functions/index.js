const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { GoogleGenerativeAI } = require('@google/generative-ai');

// Initialize Firebase Admin SDK
admin.initializeApp();
const db = admin.firestore();

// Initialize Google Generative AI
let genAI;
try {
    const geminiApiKey = functions.config().gemini.api_key;
    if (!geminiApiKey) {
        throw new Error('Gemini API key not configured. Run: firebase functions:config:set gemini.api_key="YOUR_API_KEY"');
    }
    genAI = new GoogleGenerativeAI(geminiApiKey);
} catch (error) {
    functions.logger.error('Failed to initialize Google Generative AI:', error);
    // This error will prevent the function from being deployed or run correctly
    // Consider how to handle this gracefully, e.g., by returning an error to the client
}

exports.processDocumentExtraction = functions.https.onCall(async (data, context) => {
    // 1. Authentication and Authorization
    if (!context.auth) {
        throw new functions.https.HttpsError('unauthenticated', 'The function must be called while authenticated.');
    }
    const userId = context.auth.uid; // Use authenticated user ID for security

    // 2. Extract input data
    const { documentType, documentUrl } = data; // userRole removed

    // 3. Validate input data
    if (!documentType || !documentUrl) {
        throw new functions.https.HttpsError('invalid-argument', 'Missing required parameters: documentType or documentUrl.');
    }
    if (userId !== data.userId) { // Ensure the userId passed from client matches authenticated user
        throw new functions.https.HttpsError('permission-denied', 'User ID mismatch.');
    }
    if (!['id_document', 'academic_document'].includes(documentType)) {
        throw new functions.https.HttpsError('invalid-argument', 'Invalid documentType. Must be "id_document" or "academic_document".');
    }

    if (!genAI) {
        throw new functions.https.HttpsError('internal', 'Generative AI not initialized due to missing API key.');
    }

    const model = genAI.getGenerativeModel({ model: "gemini-1.5-pro" });

    try {
        let extractedData = {};
        let prompt = "";
        let fileBuffer;
        let mimeType;

        // Fetch file from Firebase Storage using the provided URL
        const storage = admin.storage();
        const bucket = storage.bucket(); // Gets the default bucket

        // Extract file path from the documentUrl
        const urlParts = documentUrl.split('/o/')[1].split('?')[0];
        const filePath = decodeURIComponent(urlParts);

        const file = bucket.file(filePath);

        // Get file metadata to determine mimeType
        const [metadata] = await file.getMetadata();
        mimeType = metadata.contentType;

        // Download the file content
        [fileBuffer] = await file.download();

        // Prepare parts for Gemini API
        parts.push({
            inlineData: {
                mimeType: mimeType,
                data: fileBuffer.toString('base64') // Convert buffer to base64 string
            }
        });

        if (documentType === 'id_document') {
            prompt = "Extract the name (first name) and surname (last name) from this ID document in JSON format: {name: '...', surname: '...'}. Ensure high accuracy.";
        } else if (documentType === 'academic_document') {
            prompt = "Extract a list of modules/subjects (each with name, marks (0-100), level (1-7), passed (true/false)) and calculate the GPA from this academic document in JSON format: {subjects: [...], gpa: ...}.";
        }

        const result = await model.generateContent({
            contents: [{ parts: [...parts, { text: prompt }] }]
        });
        const response = await result.response;
        const extractedText = response.text();

        functions.logger.log('Gemini Raw Response:', extractedText);

        // Attempt to parse the JSON response from Gemini
        try {
            extractedData = JSON.parse(extractedText);
        } catch (parseError) {
            functions.logger.error('Failed to parse Gemini response as JSON:', parseError);
            throw new functions.https.HttpsError('internal', 'AI response could not be parsed.');
        }

        // Firestore Update Logic
        const userRef = db.collection('users').doc(userId);
        const detailsRef = userRef.collection('details').doc('profile_details');

        if (documentType === 'id_document') {
            // Update main user document, setting role to 'student' by default
            await userRef.set({
                name: extractedData.name || null,
                surname: extractedData.surname || null,
                role: 'student' // Set role to student by default
            }, { merge: true });

            // Update documents sub-document
            await detailsRef.set({
                documents: {
                    id_document_url: documentUrl
                }
            }, { merge: true });

        } else if (documentType === 'academic_document') {
            // Update main user document to ensure role is 'student' (idempotent)
            await userRef.set({
                role: 'student'
            }, { merge: true });

            // Update academics sub-document
            await detailsRef.set({
                academics: {
                    subjects: extractedData.subjects || [],
                    gpa: extractedData.gpa || null
                }
            }, { merge: true });

            // Update documents sub-document
            await detailsRef.set({
                documents: {
                    academic_document_url: documentUrl
                }
            }, { merge: true });
        }

        return { status: 'success', message: 'Document processed and profile updated.' };

    } catch (error) {
        functions.logger.error('Error processing document:', error);
        if (error instanceof functions.https.HttpsError) {
            throw error;
        }
        throw new functions.https.HttpsError('internal', 'An unexpected error occurred.', error.message);
    }
});