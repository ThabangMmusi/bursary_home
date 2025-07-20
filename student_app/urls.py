from django.urls import path
from . import views

app_name = 'student_app'

urlpatterns = [
    path('', views.login_view, name='login'),
    path('magic-link-login/', views.magic_link_login_view, name='magic_link_login'),
    path('dashboard/', views.dashboard, name='dashboard'),
    path('complete-profile/', views.complete_profile_view, name='complete-profile'),
    path('applications/', views.applications_view, name='applications'),
    path('profile/', views.profile_view, name='profile'),
    path('logout/', views.logout_view, name='logout'),
]
