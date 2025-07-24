from django import forms
from student_app.forms import CustomAuthenticationForm

class ProviderAuthenticationForm(CustomAuthenticationForm):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.fields['username'].widget = forms.EmailInput(attrs={'autofocus': True, 'placeholder': 'bursary.provider@example.com'})
