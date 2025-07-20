from django.core.management.base import BaseCommand
from bursary.models import Student

class Command(BaseCommand):
    help = 'Populates the database with initial data'

    def handle(self, *args, **options):
        # Create some students
        Student.objects.create(first_name='John', last_name='Doe', email='john.doe@example.com')
        Student.objects.create(first_name='Jane', last_name='Doe', email='jane.doe@example.com')

        self.stdout.write(self.style.SUCCESS('Successfully populated the database.'))