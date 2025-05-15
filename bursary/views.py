from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login, logout # Added logout
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from .models import Bursary, Student
from django.utils import timezone
from decimal import Decimal
from .decorators import profile_complete_required # Added
import time # for simulating AI processing
# Choose the appropriate signup form:
# from django.contrib.auth.forms import UserCreationForm # If only username/password
from .forms import CustomUserCreationForm, CustomAuthenticationForm # Import your custom forms

# --- Secure Signup View using Forms ---
def signup_view(request):
    if request.user.is_authenticated:
        messages.info(request, "You are already logged in.")
        return redirect('dashboard')

    if request.method == 'POST':
        # Use the appropriate form (CustomUserCreationForm handles more fields)
        form = CustomUserCreationForm(request.POST)
        if form.is_valid():
            try:
                user = form.save() # This handles hashing and saving user + custom fields

                # Optional: Create Student profile immediately after signup
                # Student.objects.get_or_create(user=user) # Safely create if not exists

                messages.success(request, f'Account created successfully for {user.username}! Please log in.')
                return redirect('login') # Redirect to login after successful signup

            except Exception as e:
                messages.error(request, "An unexpected error occurred during signup. Please try again.")
                # Log the error e for debugging purposes
                print(f"Signup Error: {e}")
                # Fall through to render the form again
        else:
            # Form is invalid, add a general error message.
            # Specific field errors are already attached to the form object.
            messages.error(request, 'Registration failed. Please correct the errors below.')
            # Fall through to render the form with errors
    else:
        # GET request: Create a blank form
        form = CustomUserCreationForm()

    return render(request, 'signup.html', {'form': form})


# --- Secure Login View using AuthenticationForm ---
def login_view(request):
    if request.user.is_authenticated:
        return redirect('dashboard')

    # Determine where to redirect after successful login
    # Get 'next' from POST data first (if form includes it), then GET param
    next_url = request.POST.get('next') or request.GET.get('next', '') or 'dashboard' # Default to dashboard


    if request.method == 'POST':
        # Use Django's built-in AuthenticationForm or your custom one
        # Pass 'request' for AuthenticationForm context
        form = CustomAuthenticationForm(request, data=request.POST)

        if form.is_valid():
            # form.is_valid() calls authenticate() and checks credentials
            user = form.get_user() # Get the authenticated user object

            # Check if user is active (redundant check as authenticate usually does this, but safe)
            if user is not None and user.is_active:
                login(request, user) # Log the user in (creates session)

                # --- Post-login logic (Profile check) ---
                try:
                    student, created = Student.objects.get_or_create(user=user)
                    if created:
                         messages.info(request, "Welcome! Let's complete your profile.")
                         return redirect('profile') # Force new users to profile page
                    elif not student.is_profile_complete():
                         messages.info(request, "Please complete your profile before proceeding.")
                         return redirect('profile')
                    else:
                        # Profile exists and is complete, redirect to intended destination
                        messages.success(request, f"Welcome back, {user.username}!")
                        return redirect(next_url)

                except Exception as e:
                     # Handle potential errors during profile check/creation
                     messages.error(request, "There was an issue accessing your profile. Please contact support.")
                     print(f"Profile check/create error for {user.username}: {e}")
                     # Log the user out maybe? Or redirect to a safe page?
                     # logout(request)
                     return redirect('login') # Redirect back to login for now
                     
            else:
                 # This case might be covered by form.is_valid() errors,
                 # but can catch inactive users if authenticate allows them initially.
                 messages.error(request, 'Your account is inactive or credentials invalid.')

        else:
            # Form is invalid (e.g., wrong password, user not found)
            # AuthenticationForm adds non_field_errors for "invalid credentials"
            messages.error(request, 'Login failed. Please check your username and password.')
            # Fall through to render the form with errors

    else:
        # GET request: Create a blank form
        form = CustomAuthenticationForm(request)

    # Pass the form and 'next' URL to the template
    context = {
        'form': form,
        'next': next_url # Pass next_url for the hidden input in the template
    }
    return render(request, 'login.html', context)

@login_required
@profile_complete_required
def dashboard(request):
    # Check if we have any bursaries, if not create sample data
    if Bursary.objects.count() == 0:
        sample_bursaries = [
            {
                'name': 'Engineering Excellence Scholarship',
                'description': 'Full scholarship for outstanding engineering students with focus on innovation and research.',
                'amount': Decimal('120000.00'),
                'deadline': timezone.now().date() + timezone.timedelta(days=30),
                'academic_level': 'UG',
                'field_of_study': 'Engineering',
                'gpa_requirement': Decimal('3.5'),
            },
            {
                'name': 'Computer Science Future Leaders',
                'description': 'Supporting next-generation computer scientists and software developers.',
                'amount': Decimal('85000.00'),
                'deadline': timezone.now().date() + timezone.timedelta(days=45),
                'academic_level': 'UG',
                'field_of_study': 'Computer Science',
                'gpa_requirement': Decimal('3.0'),
            },
            {
                'name': 'Business Innovation Grant',
                'description': 'For ambitious business and economics students with entrepreneurial spirit.',
                'amount': Decimal('95000.00'),
                'deadline': timezone.now().date() + timezone.timedelta(days=60),
                'academic_level': 'UG',
                'field_of_study': 'Business',
                'gpa_requirement': Decimal('3.2'),
            },
            {
                'name': 'Medical Sciences Excellence',
                'description': 'Supporting future healthcare professionals and medical researchers.',
                'amount': Decimal('150000.00'),
                'deadline': timezone.now().date() + timezone.timedelta(days=90),
                'academic_level': 'UG',
                'field_of_study': 'Medical Sciences',
                'gpa_requirement': Decimal('3.8'),
            },
            {
                'name': 'Arts and Design Creativity',
                'description': 'For creative minds in visual arts, design, and digital media.',
                'amount': Decimal('75000.00'),
                'deadline': timezone.now().date() + timezone.timedelta(days=40),
                'academic_level': 'UG',
                'field_of_study': 'Arts & Design',
                'gpa_requirement': Decimal('3.0'),
            },
            {
                'name': 'Environmental Studies Fund',
                'description': 'Supporting students committed to environmental conservation and sustainability.',
                'amount': Decimal('90000.00'),
                'deadline': timezone.now().date() + timezone.timedelta(days=75),
                'academic_level': 'UG',
                'field_of_study': 'Environmental Science',
                'gpa_requirement': Decimal('3.3'),
            },
        ]

        for bursary_data in sample_bursaries:
            Bursary.objects.create(**bursary_data)

    bursaries = Bursary.objects.all()
    # Get student profile status for the dashboard message
    user_status = "Profile Incomplete" # Default
    try:
        student = request.user.student
        if student.profile_status == 'Verified':
            user_status = "Verified"
        elif student.profile_status == 'Pending AI' or student.is_profile_complete(): # if complete but not yet verified by admin
            user_status = "Pending Verification"
    except Student.DoesNotExist:
        pass # Handled by decorator, but good to be safe

    current_date = timezone.now()
    return render(request, 'dashboard.html', {
        'bursaries': bursaries, 
        'user_status': user_status,
        'current_date': current_date
    })

# def login_view(request):
#     # if request.user.is_authenticated:
#     #     return redirect('dashboard')

#     if request.method == 'POST':
#         username = request.POST.get('username')
#         password = request.POST.get('password')
        
#         if username and password:
#             user = authenticate(request, username=username, password=password)
#             if user is not None:
#                 if user.is_active:
#                     login(request, user)
#                     # Check if profile exists
#                     try:
#                         student = Student.objects.get(user=user)
#                         # Check if profile is complete before redirecting to dashboard or next_url
#                         if not student.is_profile_complete():
#                             messages.info(request, "Please complete your profile before proceeding.")
#                             return redirect('profile') 
                        
#                         next_url = request.GET.get('next', 'dashboard')
#                         return redirect(next_url)
#                     except Student.DoesNotExist:
#                         # If student profile doesn't exist, create one and redirect to profile page
#                         Student.objects.create(user=user) # Create a basic student profile
#                         messages.info(request, "Welcome! Please complete your profile.")
#                         return redirect('profile')
#                 else:
#                     messages.error(request, 'Your account is not active.')
#             else:
#                 messages.error(request, 'Invalid username or password.')
#         else:
#             messages.error(request, 'Please fill in both username and password.')
    
#     return render(request, 'login.html', {'next': request.GET.get('next', '')})

@login_required
def profile_completion(request):
    try:
        student = Student.objects.get(user=request.user)
        is_update = True
    except Student.DoesNotExist:
        student = None
        is_update = False

    if request.method == 'POST':
        # Get form data
        student_data = {
            'student_number': request.POST.get('studentNumber'),
            'date_of_birth': request.POST.get('dateOfBirth'),
            'current_institution': request.POST.get('currentInstitution'),
            'study_program': request.POST.get('studyProgram'),
            'academic_year': request.POST.get('academicYear'),
            'average_grade': request.POST.get('averageGrade'),
            'contact_number': request.POST.get('contactNumber'),
        }

        # Update user information
        request.user.first_name = request.POST.get('firstName')
        request.user.last_name = request.POST.get('lastName')
        request.user.save()

        if student:
            # Update existing student
            for key, value in student_data.items():
                setattr(student, key, value)
        else:
            # Create new student
            student = Student(user=request.user, **student_data)

        # Handle file uploads
        if 'academicRecords' in request.FILES:
            student.academic_records = request.FILES['academicRecords']
        if 'financialDocuments' in request.FILES:
            student.financial_documents = request.FILES['financialDocuments']

        student.save()
        messages.success(request, 'Profile updated successfully!')
        return redirect('dashboard')

    context = {
        'student': student,
        'is_update': is_update
    }
    return render(request, 'profile.html', context)

@login_required
def profile_view(request):
    try:
        student = request.user.student
    except Student.DoesNotExist:
        # If for some reason a student object wasn't created at login/signup
        student = Student.objects.create(user=request.user)

    if request.method == 'POST':
        # Simulate AI processing delay
        time.sleep(2) 

        # Handle file uploads
        if request.FILES.get('id_document'):
            student.id_document = request.FILES['id_document']
        if request.FILES.get('academic_records'):
            student.academic_records = request.FILES['academic_records']
        if request.FILES.get('proof_of_registration'):
            student.proof_of_registration = request.FILES['proof_of_registration']
        if request.FILES.get('financial_documents'):
            student.financial_documents = request.FILES['financial_documents']
        
        student.save() # Save files first

        # --- Placeholder for "gimin" AI processing --- 
        # In a real application, you would send the file paths or content to an AI service here.
        # For example: extracted_data = call_gimin_ai_service(student.id_document.path, student.academic_records.path)
        # Then, populate the student model with the extracted_data.

        # Simulate data extraction (replace with actual AI call)
        if student.proof_of_registration and student.academic_records:
            student.extracted_full_name = f"{request.user.first_name} {request.user.last_name}" if request.user.first_name else request.user.username
            student.extracted_id_number = "ID123456789" # Placeholder
            student.extracted_date_of_birth = student.date_of_birth if student.date_of_birth else timezone.now().date() - timezone.timedelta(days=365*20) # Placeholder
            student.extracted_previous_institution = "Sample University" # Placeholder
            student.extracted_grades_summary = "Achieved good grades in Math and Science." # Placeholder
            student.profile_status = "Pending AI" # Or "Pending Verification" if AI is synchronous and successful
            
            # For demonstration, let's assume some basic fields are also set via a form or AI
            student.student_number = student.student_number or "SN00001"
            student.date_of_birth = student.date_of_birth or (timezone.now().date() - timezone.timedelta(days=365*20))
            student.current_institution = student.current_institution or "Current University"
            student.study_program = student.study_program or "Computer Science"
            student.academic_year = student.academic_year or 1
            student.average_grade = student.average_grade or 75.0
            student.contact_number = student.contact_number or "0123456789"
            
            student.save()
            messages.success(request, "Documents uploaded! Our AI is processing them. You will be redirected to review.")
            # In a real scenario, you might redirect to a specific review page or the dashboard if is_profile_complete() is now true.
            if student.is_profile_complete():
                return redirect('dashboard') # Or a review page first
            else:
                # If still not complete (e.g. AI needs more info or manual review)
                messages.info(request, "Profile updated, but some information might still be pending AI processing or requires review.")
        else:
            messages.error(request, "Please upload the required ID and Academic documents.")
        
        return redirect('profile') # Stay on profile page to show messages or if not yet complete

    return render(request, 'profile.html', {'student': student})

def logout_view(request):
    logout(request)
    messages.info(request, "You have been successfully logged out.")
    return redirect('login')
