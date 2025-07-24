from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login
from provider_app.forms import ProviderAuthenticationForm

def login_view(request):
    if request.method == 'POST':
        form = ProviderAuthenticationForm(request.POST)
        if form.is_valid():
            email = form.cleaned_data.get('username')
            # This is a placeholder for a real user authentication
            # You should replace this with your actual user model and logic
            user = authenticate(request, username=email, password='magiclink') # Placeholder
            if user is not None:
                login(request, user)
                return redirect('provider_app:dashboard') # Redirect to a provider dashboard
            else:
                form.add_error(None, "Invalid login link or user does not exist.")
    else:
        form = ProviderAuthenticationForm()
    return render(request, 'provider_app/login.html', {'form': form})

def dashboard(request):
    return render(request, 'provider_app/dashboard.html')

def applications_view(request):
    return render(request, 'provider_app/applications.html')

def profile_view(request):
    return render(request, 'provider_app/profile.html')

def logout_view(request):
    return redirect('provider_app:login')
