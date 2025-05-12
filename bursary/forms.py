# In your_app/forms.py
from django import forms
from django.contrib.auth.forms import UserCreationForm, AuthenticationForm
from django.contrib.auth.models import User # Or your custom user model

class CustomUserCreationForm(UserCreationForm):
    """
    A custom form for user signup including email, first name, and last name.
    """
    email = forms.EmailField(
        required=True,
        help_text="Required. A valid email address is needed.",
        widget=forms.EmailInput(attrs={'autocomplete': 'email'})
    )
   
    class Meta(UserCreationForm.Meta):
        model = User # Ensure this points to your user model
        # Define ALL fields displayed on the form, including default ones + new ones
        fields = ('username', 'email') # Password fields handled by parent

    def save(self, commit=True):
        """
        Save the provided password in hashed format and save other fields.
        """
        user = super().save(commit=False) # Get user object without saving yet
        user.email = self.cleaned_data['email']
        if commit:
            user.save()
        return user

class CustomAuthenticationForm(AuthenticationForm):
    """
    Optional: Customize the login form if needed (e.g., add placeholders).
    For basic login, the default AuthenticationForm is usually sufficient.
    """
    username = forms.CharField(widget=forms.TextInput(
        attrs={'autofocus': True,
               'placeholder':'Username',
               'help_text':"Required. A valid email address is needed.",}))
    password = forms.CharField(strip=False, widget=forms.PasswordInput(attrs={'placeholder': 'Password', 'autocomplete': 'current-password'}))