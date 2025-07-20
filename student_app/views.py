from django.shortcuts import render, redirect
from django.contrib.auth import login, logout
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.contrib.auth.models import User
from django.core.mail import send_mail
from django.urls import reverse
from django.utils import timezone
from datetime import timedelta
import uuid

from .models import Bursary, Student, LoginToken
from decimal import Decimal
from .decorators import profile_complete_required
import time
from .forms import CustomAuthenticationForm

# --- Passwordless Login View ---
def login_view(request):
    if request.user.is_authenticated:
        return redirect('student_app:dashboard')

    if request.method == 'POST':
        form = CustomAuthenticationForm(request.POST)
        if form.is_valid():
            email = form.cleaned_data['username'] # 'username' field is now email
            user, created = User.objects.get_or_create(email=email, defaults={'username': email}) # Use email as username

            # Generate a unique token
            token = uuid.uuid4().hex
            expires_at = timezone.now() + timedelta(minutes=15) # Token valid for 15 minutes
            LoginToken.objects.create(user=user, token=token, expires_at=expires_at)

            # Construct the magic link
            login_link = request.build_absolute_uri(reverse('student_app:magic_link_login') + f'?token={token}')

            # Send the email
            send_mail(
                'Your Login Link for Bursary Home',
                f'Click this link to log in: {login_link}',
                'noreply@bursaryhome.com', # From email
                [email],
                fail_silently=False,
            )

            messages.success(request, "A login link has been sent to your email address. Please check your inbox.")
            return render(request, 'student_app/login.html', {'form': form})
        else:
            messages.error(request, 'Please enter a valid email address.')
    else:
        form = CustomAuthenticationForm()

    return render(request, 'student_app/login.html', {'form': form})

# --- Magic Link Login View ---
def magic_link_login_view(request):
    token = request.GET.get('token')
    if not token:
        messages.error(request, "Invalid login link.")
        return redirect('student_app:login')

    try:
        login_token = LoginToken.objects.get(token=token)
    except LoginToken.DoesNotExist:
        messages.error(request, "Invalid or expired login link.")
        return redirect('student_app:login')

    if login_token.is_expired():
        login_token.delete() # Clean up expired token
        messages.error(request, "Login link has expired. Please request a new one.")
        return redirect('student_app:login')

    user = login_token.user
    login(request, user)
    login_token.delete() # Token used, delete it

    messages.success(request, f"Welcome back, {user.username}!")
    return redirect('student_app:dashboard')

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
    return render(request, 'student_app/dashboard.html', {
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
    return render(request, 'student_app/applications.html', {'current_page': 'applications', 'applications': applications})

@login_required
def profile_view(request):
    return render(request, 'student_app/profile.html', {'current_page': 'profile'})

@login_required
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
                return redirect('student_app:dashboard')
            else:
                messages.info(request, "Profile updated, but some information might still be pending AI processing or requires review.")
                return render(request, 'student_app/complete_profile.html', {'student': student}) # Render the page instead of redirecting
        else:
            messages.error(request, "Please upload the required ID and Academic documents.")
        
        return render(request, 'student_app/complete_profile.html', {'student': student})

    return render(request, 'student_app/complete_profile.html', {'student': student})

def logout_view(request):
    logout(request)
    messages.info(request, "You have been successfully logged out.")
    return redirect('student_app:login')