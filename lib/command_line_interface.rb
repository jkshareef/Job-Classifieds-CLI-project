require_all './app/models'

def run
  computer_ascii
  welcome_message
  gets_user_data
  menu
  input = gets.chomp.downcase
  until input == "quit"
    if input == "1"
      auto_search
      save_job_with_interest_rating
    elsif input == "2"
      search_manual_entry
      save_job_with_interest_rating
    # elsif input == "3"
    #   #view and edit jobs
    # elsif input == "4"
    #   #update profile
    end
    menu
    input = gets.chomp
  end
  exit_program
end

def computer_ascii
  puts "     ______________
    /             /|
   /             / |
  /____________ /  |
  | ___________ |  |
  ||           ||  |
  ||           ||  |
  ||           ||  |
  ||___________||  |
  |   _______   |  /
 /|  (_______)  | /
( |_____________|/
'\'
.=======================.
| ::::::::::::::::  ::: |
| ::::::::::::::[]  ::: |
|   -----------     ::: |
`-----------------------'"
end

def welcome_message
  puts "Hello job seeker! Welcome to SMARTER CLASSIFIEDS!

In order for us to find the jobs best suited to you, we will ask you to quickly create a
profile.

In order, we are going to ask you to enter your name, your skill-set (please enter all of
your skills separated by spaces), your experience in your current field (in years), and the
location in which you are searching for a job. "
end


def gets_user_data

  new_user = User.create()

  print "Name: "
  new_user.update(name: gets.chomp)
  print "Skills: "
  new_user.update(skills: gets.chomp)
  print "Experience: "
  new_user.update(experience: gets.chomp)
  print "Location: "
  new_user.update(location: gets.chomp)
  puts ' '
end

def menu
  puts "=======MENU========="
  puts "1. Search for jobs by skillset"
  puts "2. Search for jobs by custom criteria"
  puts "3. View and edit saved jobs"
  puts "4. Update your profile"
  print "Please select an option by reference number or 'quit' to exit: "
end

def exit_program
  puts "Goodbye!"
end

def auto_search
  keywords = User.last.skills.scan(/\w+/)

   results = Job.all.select { |job|
     (skill_match_title?(keywords, job) || skill_match_description?(keywords, job)) && location_match?(job)
   }

   results.each { |job|
     puts ' '
     print '---------------------------------------------------------------------------------------------'
     puts ' '
     puts "Job #{job.id}."
     puts ' '
     puts "<<<#{job.company}>>>"
     puts "--#{job.title}--"
     puts "..#{job.position_type}.."
     puts ' '
     puts job.description
   }
end

def search_manual_entry
  print "Please enter keywords for your search separated by spaces: "
  keywords = gets.chomp.split(' ').flatten

  results = Job.all.select { |job|
    (skill_match_title?(keywords, job) || skill_match_description?(keywords, job)) && location_match?(job)
  }

  results.each { |job|
    puts ' '
    print '---------------------------------------------------------------------------------------------'
    puts ' '
    puts "Job #{job.id}."
    puts ' '
    puts "<<<#{job.company}>>>"
    puts "--#{job.title}--"
    puts "..#{job.position_type}.."
    puts ' '
    puts job.description
  }
end

def skill_match_title?(keywords, job)
  keywords.any? {|word| job.title.include?(word)}
end

def skill_match_description?(keywords, job)
  keywords.any? {|word| job.description.include?(word)}
end

def location_match?(job)
  job.location.downcase == User.last.location.downcase
end

def save_job_with_interest_rating
  puts ' '
  puts '* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *'
  puts ' '
  puts "Above is a list of jobs based on your search criteria! In order to save a job
(or multiple jobs) to your job list, please enter the 'Job Number' and rate your
current level of interest in that listing!"

  i = 1

  while i == 1
    puts ' '
    print "Job Number: "
    job_number = gets.chomp
    print "Curent level of interest on a scale of 1-10: "
    job_rating = gets.chomp

    add_to_saved_jobs(job_number)
    add_interest_rating(job_rating)

    puts ' '
    print "Would you like to add another job? Please enter 'yes' or 'no': "
    status = gets.chomp

    if status.downcase == 'no'
      i = 0
    end
  end

  puts ' '
end

def add_to_saved_jobs(num)
  new_job = SavedJob.create
  new_job.user = User.last
  new_job.job = Job.find(num)
  User.last.saved_jobs << new_job
  Job.find(num).saved_jobs << new_job
end

def add_interest_rating(rating)
  SavedJob.last.update(interest_level: rating)
end
