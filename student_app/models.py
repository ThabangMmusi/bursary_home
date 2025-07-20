from django.db import models
from django.contrib.auth.models import User
from django.utils import timezone

class Bursary(models.Model):
    ACADEMIC_LEVEL_CHOICES = [
        ('UG', 'Undergraduate'),
        ('PG', 'Postgraduate'),
        ('PHD', 'Doctorate'),
    ]
    
    name = models.CharField(max_length=200)
    description = models.TextField()
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    deadline = models.DateField()
    academic_level = models.CharField(max_length=3, choices=ACADEMIC_LEVEL_CHOICES)
    field_of_study = models.CharField(max_length=100)
    gpa_requirement = models.DecimalField(max_digits=3, decimal_places=2, null=True, blank=True)
    nationality = models.CharField(max_length=100, null=True, blank=True)
    residency = models.CharField(max_length=100, null=True, blank=True)
    gender = models.CharField(max_length=20, null=True, blank=True)
    ethnicity = models.CharField(max_length=100, null=True, blank=True)
    disability_status = models.BooleanField(default=False)
    first_gen_student = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name_plural = "Bursaries"

    def __str__(self):
        return self.name

class Student(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    student_number = models.CharField(max_length=20, blank=True, null=True) # Made optional for initial creation
    date_of_birth = models.DateField(blank=True, null=True)
    current_institution = models.CharField(max_length=100, blank=True, null=True)
    study_program = models.CharField(max_length=100, blank=True, null=True)
    academic_year = models.IntegerField(blank=True, null=True)
    average_grade = models.FloatField(blank=True, null=True)
    contact_number = models.CharField(max_length=20, blank=True, null=True)
    registration_date = models.DateTimeField(default=timezone.now)
    
    # File fields for documents
    id_document = models.FileField(upload_to='user_documents/', blank=True, null=True) # Remains optional
    academic_records = models.FileField(upload_to='user_documents/', blank=False, null=False) # Explicitly not blank/null
    proof_of_registration = models.FileField(upload_to='user_documents/', blank=False, null=False) # Changed to not blank/null
    financial_documents = models.FileField(upload_to='user_documents/', blank=True, null=True)

    # Fields to be populated by AI (examples)
    extracted_full_name = models.CharField(max_length=255, blank=True, null=True)
    extracted_id_number = models.CharField(max_length=50, blank=True, null=True)
    extracted_date_of_birth = models.DateField(blank=True, null=True)
    extracted_previous_institution = models.CharField(max_length=255, blank=True, null=True)
    extracted_grades_summary = models.TextField(blank=True, null=True)
    # Add more extracted fields as needed

    profile_status = models.CharField(max_length=20, default='Incomplete') # e.g., Incomplete, Pending AI, Verified

    def is_profile_complete(self):
        """Checks if essential profile information and documents are present."""
        # Define what constitutes a complete profile.
        # Now checking for academic_records and proof_of_registration.
        required_docs = bool(self.academic_records and self.proof_of_registration)
        
        # Basic check for some key textual data fields that should be filled (either by user or AI)
        # These are examples; adjust based on what you deem essential for a "complete" profile before dashboard access.
        essential_text_data = all([
            self.student_number,
            self.date_of_birth,
            self.current_institution,
            self.study_program,
            self.academic_year is not None, # Check for None as 0 could be a valid year in some contexts
            self.average_grade is not None,
            self.contact_number
        ])
        
        # A profile might be considered complete enough for dashboard access if 
        # required documents are uploaded and essential textual data is present.
        # The `profile_status` (e.g., 'Verified') could be a more definitive check later on.
        return required_docs and essential_text_data

    def __str__(self):
        return f"{self.user.first_name} {self.user.last_name} - {self.student_number}"

class LoginToken(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    token = models.CharField(max_length=64, unique=True)
    created_at = models.DateTimeField(auto_now_add=True)
    expires_at = models.DateTimeField()

    def is_expired(self):
        return timezone.now() > self.expires_at

    def __str__(self):
        return f"Token for {self.user.username}"
