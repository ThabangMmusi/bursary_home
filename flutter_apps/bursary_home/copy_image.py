
import shutil
import os

source_path = "C:/devs/django/bursary_home/static/images/boy white.png"
destination_path = "C:/devs/django/bursary_home/flutter_apps/bursary_home/student_app/assets/images/boy white.png"

try:
    shutil.copy(source_path, destination_path)
    print(f"Successfully copied {source_path} to {destination_path}")
except FileNotFoundError:
    print(f"Error: Source file not found at {source_path}")
except Exception as e:
    print(f"An error occurred: {e}")
