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
