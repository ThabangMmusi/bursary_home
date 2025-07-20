from django import forms
from django.contrib.auth.models import User

class CustomAuthenticationForm(forms.Form):
    """
    A custom form for passwordless login using email.
    """
    username = forms.EmailField(
        label="Email",
        widget=forms.EmailInput(attrs={'autofocus': True, 'placeholder': 'student.email@example.com'}),
    )