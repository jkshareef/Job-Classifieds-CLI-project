require_all './app/models'

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

def menu
  puts "=======MENU========="
  puts "1. Search for jobs by skillset"
  puts "2. Search for jobs by custom criteria"
  puts "3. View and edit saved jobs"
  puts "4. Update your profile"
  puts "5. Exit program"
  puts "Please select an option using the number:"
end

def run
  computer_ascii
  welcome_message
  gets_user_data
  menu
  input = gets.chomp
  until input == "5"
    if input == "1"
      binding.pry
      auto_search
    elsif input == "2"
      search_manual_entry
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

# def view_and_edit_jobs
#   jobs = User.last.saved_jobs
#   jobs.each_with_index do |job, index|
#     puts "#{index + 1}. #{job.title}"
#     puts job.description
#   end
#   puts "Would you like to delete jobs from your list?"
#   input = gets.chomp
#   if input.downcase == "yes" || "y"
#     puts "Which job would you like to delete?"
#     puts "1. Enter job number"
#   end
# end

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

def add_favorite(num)
  new_job = SavedJob.create
  new_job.user = User.last
  new_job.job = Job.find(num)
  User.last.saved_jobs << new_job
  Job.find(num).saved_jobs << new_job
end

def add_interest(rating)
  SavedJob.last.update(interest_level: rating)
end
