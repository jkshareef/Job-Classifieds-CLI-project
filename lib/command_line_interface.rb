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
    elsif input == "3"
      view_and_edit_jobs
    elsif input == "4"
     update_profile
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
  keywords.any? {|word| job.title.downcase.include?(word.downcase)}
end

def skill_match_description?(keywords, job)
  keywords.any? {|word| job.description.downcase.include?(word.downcase)}
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

def view_and_edit_jobs
  if User.last.saved_jobs.empty? || User.last.saved_jobs == nil
    puts ' '
    puts "****You do not have any saved jobs to view.****"
    puts ' '
  else
    jobs = User.last.saved_jobs
    jobs.each_with_index do |saved_job, index|
      puts ' '
      puts '-------------------------------------------------------------------------'
      puts ' '
      puts "Job Number:#{saved_job.job.id}, #{saved_job.job.company}"
      puts ' '
      puts saved_job.job.description
    end
    puts ' '
    print "Would you like to delete some jobs from your saved list? Please enter 'yes' or 'no': "
    input = gets.chomp
    if input.downcase == 'yes'
      puts ' '
      print "Would you like to remove *all* of your jobs? Please enter 'yes', 'no': "
      input = gets.chomp
      if input.downcase == 'yes'
        User.last.saved_jobs.destroy_all
      else
        puts ' '
        print "Please enter the job number for the job you *would* like to delete or enter 'menu' to be redirected: "

        loop do
          input = gets.chomp
          if input == 'menu'
            break
          elsif SavedJob.exists?(job_id: input, user_id: User.last.id)
            SavedJob.find_by(job_id: input, user_id: User.last.id).destroy
            print "Please enter another job number or enter 'menu' to be redirected: "
          else
            print "Whoops! that's not a valid input. Please enter a valid command: "
          end
        end
      end
    end
  end
end

def view_profile
  puts "\nHere is your current profile:\nName: #{User.last.name}\nSkills: #{User.last.skills}\nExperience: #{User.last.experience}\nLocation: #{User.last.location}"
end

def update_profile
  view_profile
  puts "\nYou can update your: \n 1. Skills \n 2. Experience \n 3. Location"
  puts
  puts "Please enter a number to update profile or type 'exit'"
  puts
  input = gets.chomp
  if input == "1"
    puts "Please enter new skills or type 'exit':"
    puts
    user_input = gets.chomp
    if user_input != "exit"
      User.last.update(skills: user_input)
      view_profile
      puts
      puts "\nYour skills have been updated!"
      puts
    else
      puts "\nYou didn't update your profile"
      puts
    end
  elsif input == "2"
    puts "Please enter new experience level in years or type 'exit':"
    puts
    user_input = gets.chomp
    if user_input != "exit"
      User.last.update(experience: user_input)
      view_profile
      puts
      puts "Your experience has been updated!"
      puts
    else
      puts "\nYou didn't update your profile"
      puts
    end
  elsif input == "3"
    puts "Please enter your new location or type 'exit':"
    puts
    user_input = gets.chomp
    if user_input != "exit"
      User.last.update(location: user_input)
      view_profile
      puts
      puts "Your location has been updated!"
      puts
    else
      puts "\nYou didn't update your profile"
      puts
    end
  else
    puts "\nYou didn't update your profile"
    puts
  end
end
