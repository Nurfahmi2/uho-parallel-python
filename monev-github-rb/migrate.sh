# paralel
bundle exec sequel -m ./db/migrations sqlite://db/student_dashboard.db --echo
# OS 
bundle exec sequel -m ./db/migrations sqlite://db/os_dashboard.db --echo
