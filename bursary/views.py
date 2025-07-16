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
        'current_date': current_date,
        'current_page': 'dashboard'
    })

@login_required
def applications_view(request):
    # Dummy application data with statuses
    applications = [
        {
            'id': 1,
            'name': 'Engineering Excellence Scholarship',
            'provider': 'Tech Solutions Inc.',
            'field_of_study': 'Engineering',
            'gpa_requirement': '3.5+',
            'deadline': timezone.now().date() + timezone.timedelta(days=10),
            'status': 'Pending',
            'progress': 70,
        },
        {
            'id': 2,
            'name': 'Computer Science Future Leaders',
            'provider': 'Global Innovations',
            'field_of_study': 'Computer Science',
            'gpa_requirement': '3.0+',
            'deadline': timezone.now().date() + timezone.timedelta(days=5),
            'status': 'Approved',
            'progress': 100,
        },
        {
            'id': 3,
            'name': 'Business Innovation Grant',
            'provider': 'Enterprise Fund',
            'field_of_study': 'Business',
            'gpa_requirement': '3.2+',
            'deadline': timezone.now().date() - timezone.timedelta(days=2),
            'status': 'Rejected',
            'progress': 40,
        },
        {
            'id': 4,
            'name': 'Medical Sciences Excellence',
            'provider': 'Health Foundation',
            'field_of_study': 'Medical Sciences',
            'gpa_requirement': '3.8+',
            'deadline': timezone.now().date() + timezone.timedelta(days=20),
            'status': 'Pending',
            'progress': 85,
        },
    ]
    return render(request, 'applications.html', {'current_page': 'applications', 'applications': applications})

@login_required
def profile_view(request):
    return render(request, 'profile.html', {'current_page': 'profile'})

@login_required
@profile_complete_required
def complete_profile_view(request):
    try:
        student = request.user.student
    except Student.DoesNotExist:
        student = Student.objects.create(user=request.user)

    if request.method == 'POST':
        time.sleep(2)

        if request.FILES.get('id_document'):
            student.id_document = request.FILES['id_document']
        if request.FILES.get('academic_records'):
            student.academic_records = request.FILES['academic_records']
        if request.FILES.get('proof_of_registration'):
            student.proof_of_registration = request.FILES['proof_of_registration']
        if request.FILES.get('financial_documents'):
            student.financial_documents = request.FILES['financial_documents']
        
        student.save()

        if student.proof_of_registration and student.academic_records:
            student.extracted_full_name = f"{request.user.first_name} {request.user.last_name}" if request.user.first_name else request.user.username
            student.extracted_id_number = "ID123456789"
            student.extracted_date_of_birth = student.date_of_birth if student.date_of_birth else timezone.now().date() - timezone.timedelta(days=365*20)
            student.extracted_previous_institution = "Sample University"
            student.extracted_grades_summary = "Achieved good grades in Math and Science."
            student.profile_status = "Pending AI"
            
            student.student_number = student.student_number or "SN00001"
            student.date_of_birth = student.date_of_birth or (timezone.now().date() - timezone.timedelta(days=365*20))
            student.current_institution = student.current_institution or "Current University"
            student.study_program = student.study_program or "Computer Science"
            student.academic_year = student.academic_year or 1
            student.average_grade = student.average_grade or 75.0
            student.contact_number = student.contact_number or "0123456789"
            
            student.save()
            messages.success(request, "Documents uploaded! Our AI is processing them. You will be redirected to review.")
            if student.is_profile_complete():
                return redirect('dashboard')
            else:
                messages.info(request, "Profile updated, but some information might still be pending AI processing or requires review.")
        else:
            messages.error(request, "Please upload the required ID and Academic documents.")
        
        return redirect('complete-profile')

    return render(request, 'complete_profile.html', {'student': student})

@login_required
@profile_complete_required
def complete_profile_view(request):
    try:
        student = request.user.student
    except Student.DoesNotExist:
        student = Student.objects.create(user=request.user)

    if request.method == 'POST':
        time.sleep(2)

        if request.FILES.get('id_document'):
            student.id_document = request.FILES['id_document']
        if request.FILES.get('academic_records'):
            student.academic_records = request.FILES['academic_records']
        if request.FILES.get('proof_of_registration'):
            student.proof_of_registration = request.FILES['proof_of_registration']
        if request.FILES.get('financial_documents'):
            student.financial_documents = request.FILES['financial_documents']
        
        student.save()

        if student.proof_of_registration and student.academic_records:
            student.extracted_full_name = f"{request.user.first_name} {request.user.last_name}" if request.user.first_name else request.user.username
            student.extracted_id_number = "ID123456789"
            student.extracted_date_of_birth = student.date_of_birth if student.date_of_birth else timezone.now().date() - timezone.timedelta(days=365*20)
            student.extracted_previous_institution = "Sample University"
            student.extracted_grades_summary = "Achieved good grades in Math and Science."
            student.profile_status = "Pending AI"
            
            student.student_number = student.student_number or "SN00001"
            student.date_of_birth = student.date_of_birth or (timezone.now().date() - timezone.timedelta(days=365*20))
            student.current_institution = student.current_institution or "Current University"
            student.study_program = student.study_program or "Computer Science"
            student.academic_year = student.academic_year or 1
            student.average_grade = student.average_grade or 75.0
            student.contact_number = student.contact_number or "0123456789"
            
            student.save()
            messages.success(request, "Documents uploaded! Our AI is processing them. You will be redirected to review.")
            if student.is_profile_complete():
                return redirect('dashboard')
            else:
                messages.info(request, "Profile updated, but some information might still be pending AI processing or requires review.")
        else:
            messages.error(request, "Please upload the required ID and Academic documents.")
        
        return redirect('complete-profile')

    return render(request, 'complete_profile.html', {'student': student})

def logout_view(request):
    logout(request)
    messages.info(request, "You have been successfully logged out.")
    return redirect('login')