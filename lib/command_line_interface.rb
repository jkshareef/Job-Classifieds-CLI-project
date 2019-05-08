require_all './app/models'

def welcome_message
  puts "Hello job seeker! Welcome to SMARTER CLASSIFIDES!

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
  puts
  puts "Please select from the following options:"
  puts "1. Search for jobs by skillset"
  puts "2. Search for jobs by custom criteria"
  puts "3. View and edit saved jobs"
  puts "4. Update your profile"
  puts "5. Exit program"
  gets.chomp
end

def run
  computer_ascii
  welcome_message
  gets_user_data
  menu
  puts "Please select an option using the number"
  input = gets.chomp
  until input == 5
    if num == 1
      auto_search
      menu
    elsif num == 2
      search_arbitrary_criteria
      menu
    # elsif num == 3
    #   #view and edit jobs
    #   menu
    # elsif num == 4
    #   #update profile
    #   menu
    end
    puts "Please select an option using the number"
    input = gets.chomp
  end
  exit_program
end

def view_and_edit_jobs
  jobs = User.last.saved_jobs
  jobs.each_with_index do |job, index|
    puts "#{index + 1}. #{job.title}"
    puts job.description
  end
  puts "Would you like to delete jobs from your list?"
  input = gets.chomp
  if input.downcase == "yes" || "y"
    puts "Which job would you like to delete?"
    puts "1. Enter job number"
  end
end

def exit_program
  puts "Goodbye!"
  true
end

 def auto_search

  ### Searches Job Database and returns positions for any match to user location and either a keyword match form the users skills with either the job title or job description
#
   results = Job.all.select { |job|
     (skill_match_title?(job) || skill_match_description?(job)) && location_match?(job)
   }
#
#
#   ### Uses the results of the search and
#   #1. Creates a new SavedJob for each result
#   #2. Associates the user to the SavedJob
#   #3. Associates the job to the SavedJob
#   #4. Adds the SavedJob to both User and Job
#
   results.each do |job|
     print "Job #{job.id}."
   #  print job.company
     print job.title
     print job.position_type
     print job.description
#
#     # search_result = SavedJob.create
#     # search_result.user = self
#     # search_result.job = job_object
#     # self.saved_jobs << search_result
#     # job_object.saved_jobs << search_result
  end
end
#
def search_arbitrary_criteria
  print "Please enter keywords for your search separated by spaces: "
  keywords = gets.chomp.split(' ')

  results = Job.all.select { |job|
    (keywords.scan(/\w+/).any? {|word| job.title.include?(word)} || keywords.scan(/\w+/).any? {|word| job.description.include?(word)}) && location_match?(job)
  }

  results.each do |job|
    print "Job #{job.id}."
  #  print job.company
    print job.title
    print job.position_type
    print job.description
 end
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



def skill_match_title?(job)
  ### Helper file, splits user skills string into words in an array and searches job title for any match to each individual word
  User.last.skills.scan(/\w+/).any? {|word| job.title.include?(word)}
end

def skill_match_description?(job)
    ### Helper file, splits user skills string into words in an array and searches job description for any match to each individual word
  User.last.skills.scan(/\w+/).any? {|word| job.description.include?(word)}
end

def location_match?(job)
    ### Helper file, compares location of user and of job
  job.location.downcase == User.last.location.downcase
end
