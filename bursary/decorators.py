from django.shortcuts import redirect
from django.urls import reverse
from .models import Student

def profile_complete_required(view_func):
    def _wrapped_view(request, *args, **kwargs):
        if not request.user.is_authenticated:
            return redirect('login')  # Or your login URL name

        try:
            student = request.user.student
            if not student.is_profile_complete():
                # You might want to add a message here
                # messages.info(request, "Please complete your profile to access this page.")
                return redirect('profile')  # Or your profile completion URL name
        except Student.DoesNotExist:
            # This case might happen if a user exists but has no student profile yet.
            # messages.info(request, "Please create your student profile.")
            return redirect('profile') # Or your profile creation URL name
            
        return view_func(request, *args, **kwargs)
    return _wrapped_view
