// ==================== The Correct v2 Syntax ====================
// For callable functions
const {onCall, HttpsError} = require("firebase-functions/v2/https");

const {logger} = require("firebase-functions");
const admin = require("firebase-admin");
const {VertexAI} = require("@google-cloud/vertexai");
// ===================================================================

admin.initializeApp();
const db = admin.firestore();
const storage = admin.storage();

// =============================================================================
// Process Document with Generative AI
// =============================================================================
exports.processDocumentExtraction = onCall(
    {timeoutSeconds: 120, memory: "1GiB", region: "us-central1"},
    async (request) => {
      // ... (The rest of this function code is correct and unchanged)
      if (!request.auth) {
        throw new HttpsError(
            "unauthenticated",
            "The function must be called while authenticated.",
        );
      }
      const userId = request.auth.uid;
      const {documentType, documentUrl, userId: dataUserId} = request.data;
      if (userId !== dataUserId) {
        throw new HttpsError("permission-denied", "User ID mismatch.");
      }
      if (!documentType || !documentUrl) {
        throw new HttpsError(
            "invalid-argument",
            "Missing required parameters: documentType or documentUrl.",
        );
      }
      if (!["id_document", "academic_document"].includes(documentType)) {
        throw new HttpsError(
            "invalid-argument",
            "Invalid documentType. Must be 'id_document' or "+
            "'academic_document'.",
        );
      }
      try {
        const vertexAI = new VertexAI({
          project: process.env.GCLOUD_PROJECT,
          location: "us-central1",
        });
        const model = "gemini-1.5-pro-001";
        const generativeModel = vertexAI.getGenerativeModel({model});
        const urlParts = documentUrl.split("/o/")[1].split("?")[0];
        const filePath = decodeURIComponent(urlParts);
        const file = storage.bucket().file(filePath);
        const [metadata] = await file.getMetadata();
        const [fileBuffer] = await file.download();
        const filePart = {
          inlineData: {
            mimeType: metadata.contentType,
            data: fileBuffer.toString("base64"),
          },
        };
        let promptText = "";
        if (documentType === "id_document") {
          promptText =
            `Extract the first name and last name from this ID document. ` +
            `Provide the response as a valid JSON object with the format: ` +
            `{"name": "...", "surname": "..."}. If a field cannot be found, ` +
            `use null as its value.`;
        } else if (documentType === "academic_document") {
          promptText =
            "From this academic document, extract a list of subjects (with "+
            "name, final mark from 0-100, and if they passed (true/false)) " +
            "and calculate the GPA. Provide the response as a valid JSON "+
            "object with the format: {\"subjects\": [{\"name\": \"...\", " +
            "\"mark\": ..., \"passed\": ...}], \"gpa\": ...}. If a field "+
            "cannot be found, use null as its value.";
        }
        const prompt = {text: promptText};
        const result = await generativeModel.generateContent({
          contents: [{role: "user", parts: [filePart, prompt]}],
        });
        const responseText = result.response.candidates[0]
            .content.parts[0].text;
        const cleanedText = responseText.replace(/```json\n|```/g, "").trim();
        let extractedData;
        try {
          extractedData = JSON.parse(cleanedText);
        } catch (parseError) {
          throw new HttpsError("internal", "AI response could not be parsed.");
        }
        const userRef = db.collection("users").doc(userId);
        const detailsRef = userRef.collection("details").doc("profile_details");
        const userUpdateData = {role: "student"};
        const detailsUpdateData = {};
        if (documentType === "id_document") {
          userUpdateData.name = extractedData.name || null;
          userUpdateData.surname = extractedData.surname || null;
          detailsUpdateData["documents.id_document_url"] = documentUrl;
        } else {
          detailsUpdateData["academics.subjects"] =
           extractedData.subjects || [];
          detailsUpdateData["academics.gpa"] = extractedData.gpa || null;
          detailsUpdateData["documents.academic_document_url"] = documentUrl;
        }
        await Promise.all([
          userRef.set(userUpdateData, {merge: true}),
          detailsRef.set(detailsUpdateData, {merge: true}),
        ]);
        return {status: "success", message: "Document processed."};
      } catch (error) {
        logger.error(`Error processing document for user ${userId}:`, error);
        if (error instanceof HttpsError) {
          throw error;
        }
        throw new HttpsError("internal", "An unexpected error occurred.");
      }
    },
);
