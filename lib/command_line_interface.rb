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

def search_arbitrary_criteria
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
