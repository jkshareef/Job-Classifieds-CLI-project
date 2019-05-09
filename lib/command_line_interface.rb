require_all './app/models'
require 'word_wrap/core_ext'

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
      return_value = search_manual_entry
      if return_value
        save_job_with_interest_rating
      end
    elsif input == "3"
      view_and_edit_jobs
    elsif input == "4"
     update_profile
    elsif input == "5"
      view_average_interest_of_saved_job
    end
    menu
    input = gets.chomp
  end
  exit_program
end

def computer_ascii
  table = Terminal::Table.new do |t|
    t << ["      ______________
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
  `-----------------------'".colorize(:yellow)]
  end
  table.style.width = 84
  table.align_column(0, :center)
  puts table
end

def welcome_message
  table = Terminal::Table.new do |t|
    t << ["In order for us to find the jobs best suited to you, we will ask you to quickly create a profile.".fit]
    t << :separator
    t.add_row ["We are going to ask you to enter your name, your skill-set (please enter all of your skills), your experience in your current field (in years), and the location in which you are searching for a job.".fit]
  end
  table.style.width = 84
  table.align_column(0, :center)
  table.title = "Hello job seeker! Welcome to SMARTER CLASSIFIEDS!.".fit
  puts table
end


def gets_user_data

  new_user = User.create

  puts ' '
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
  table = Terminal::Table.new do |t|
    t << ["1. Search for and save jobs by skillset"]
    t << :separator
    t.add_row ["2. Search for and save jobs by custom criteria"]
    t << :separator
    t.add_row ["3. View and edit saved jobs"]
    t << :separator
    t.add_row ["4. Update your profile"]
    t << :separator
    t.add_row ["5. View average interest in one of your saved jobs"]
    t << :separator
    t.add_row ["Please select an option by reference number or 'quit' to exit: "]
  end
  table.title = "=======MENU========="
  table.style.width = 84
  table.align_column(0, :center)
  puts table
  puts "\n"
end

def exit_program
  puts "Goodbye!"
end

def auto_search
  keywords = User.last.skills.split(/[^'’\p{L}\p{M}]+/)

   results = Job.all.select { |job|
     (skill_match_title?(keywords, job) || skill_match_description?(keywords, job)) && location_match(job)
   }

   results.each { |job|
     puts ' '
     print '------------------------------------------------------------------------------------'
     puts ' '
     puts "Job #{job.id}."
     puts ' '
     puts "<<<#{job.company}>>>"
     puts "--#{job.title}--"
     puts "..#{job.position_type}.."
     puts ' '
     puts "...#{job.location}..."
     puts
     table = Terminal::Table.new do |t|
       t << [job.description.fit]
     end
     table.style.width = 84
     puts table
   }
end

def search_manual_entry
  puts "Would you like to search by location? (y/n)"
  input = gets.chomp
  if input == "y"
    puts "Please enter a location:"
    location = gets.chomp
    results = Job.all.select { |job| location_match_arbitrary(job, location) }
    results.each { |job|
      puts ' '
      print '------------------------------------------------------------------------------------'
      puts ' '
      puts "Job #{job.id}."
      puts ' '
      puts "<<<#{job.company}>>>"
      puts "--#{job.title}--"
      puts "..#{job.position_type}.."
      puts ' '
      puts "...#{job.location}..."
      puts
      table = Terminal::Table.new do |t|
        t << [job.description.fit]
      end
      #table.style.width = 84
      puts table
    }
  elsif input == "n"
    puts "Would you like to search by skills? (y/n)"
    input = gets.chomp
    if input == "y"
      puts "Please enter skills:"
      skills = gets.chomp
      keywords = skills.split(/[^'’\p{L}\p{M}]+/)
      results = Job.all.select { |job|
        (skill_match_title?(keywords, job) || skill_match_description?(keywords, job)) }
      results.each { |job|
        puts ' '
        print '------------------------------------------------------------------------------------'
        puts ' '
        puts "Job #{job.id}."
        puts ' '
        puts "<<<#{job.company}>>>"
        puts "--#{job.title}--"
        puts "..#{job.position_type}.."
        puts ' '
        puts "...#{job.location}..."
        puts
        table = Terminal::Table.new do |t|
          t << [job.description.fit]
        end
        #table.style.width = 86
        puts table
      }
    elsif input == "n"
      puts "Would you like to search by location and skills? (y/n)"
      input = gets.chomp
      if input == "y"
        puts "Please enter a location:"
        location = gets.chomp
        puts "Please enter skills:"
        skills = gets.chomp
        keywords = skills.split(/[^'’\p{L}\p{M}]+/)

        results = Job.all.select { |job|
          (skill_match_title?(keywords, job) || skill_match_description?(keywords, job)) && location_match_arbitrary(job, location)
        }
        results.each { |job|
          puts ' '
          print '------------------------------------------------------------------------------------'
          puts ' '
          puts "Job #{job.id}."
          puts ' '
          puts "<<<#{job.company}>>>"
          puts "--#{job.title}--"
          puts "..#{job.position_type}.."
          puts ' '
          puts "...#{job.location}..."
          puts
          table = Terminal::Table.new do |t|
            t << [job.description.fit]
          end
          #table.style.width = 84
          puts table
        }
      elsif input == "n"
        false
      end
    end
  end


  # print "Please enter keywords for your search separated by spaces: "
  # keywords = gets.chomp.str.split(/[^'’\p{L}\p{M}]+/)
  #
  # results = Job.all.select { |job|
  #   (skill_match_title?(keywords, job) || skill_match_description?(keywords, job)) && location_match?(job)
  # }
  #
  # results.each { |job|
  #   puts ' '
  #   print '------------------------------------------------------------------------------------'
  #   puts ' '
  #   puts "Job #{job.id}."
  #   puts ' '
  #   puts "<<<#{job.company}>>>"
  #   puts "--#{job.title}--"
  #   puts "..#{job.position_type}.."
  #   puts ' '
  #   table = Terminal::Table.new do |t|
  #     t << [job.description.fit]
  #   end
  #   table.style.width = 84
  #   puts table
  # }
end

def skill_match_title?(keywords, job)
  keywords.any? {|word| job.title.downcase.include?(word.downcase)}
end

def skill_match_description?(keywords, job)
  keywords.any? {|word| job.description.downcase.include?(word.downcase)}
end

# def location_match?(job)
#   job.location.downcase == User.last.location.downcase
# end

def save_job_with_interest_rating
  puts ' '
  puts '* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *'
  puts ' '

  puts "Above is a list of jobs based on your search criteria! In order to Apply or Save a job
(or multiple jobs) to your job list, please enter the 'Job Number."
  puts ' '
  puts "Would you like to save any of the jobs listed above? please enter 'yes' if you would like
to save any and 'no' if you would like to be redirected back to menu: "

  search_desire = nil

  loop do
    if search_desire == 'no'
      break
    else
      search_desire = gets.chomp
    end
    if search_desire.downcase == 'no'
      break
    elsif search_desire.downcase == 'yes'

      loop do
        puts ' '
        print "Job Number: "
        job_number = gets.chomp
        loop do
          if job_number.to_i.to_s == job_number
            add_to_saved_jobs(job_number)
            break
          else
            print "Whoops! that's not a valid input. Please enter a valid command: "
            job_number = gets.chomp
          end
        end

        print "Curent level of interest on a scale of 1-10: "
        job_rating = gets.chomp
        loop do
          if job_rating.to_i.to_s == job_rating
            add_interest_rating(job_rating)
            break
          else
            print "Whoops! that's not a valid input. Please enter a valid command: "
            job_number = gets.chomp
          end
        end

        puts ' '
        print "Would you like to add another job? Please enter 'yes' or 'no': "
        status = gets.chomp

        if status.downcase == 'no'
          search_desire = 'no'
          break
        elsif status.downcase == 'yes'
        else
          print "Whoops! that's not a valid input. Please enter a valid command: "
        end
      end
    else
      print "Whoops! that's not a valid input. Please enter a valid command: "
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
      puts '------------------------------------------------------------------------------------'
      puts ' '
      puts "Job Number:#{saved_job.job.id}, #{saved_job.job.company}"
      puts ' '
      puts "Location: #{saved_job.job.location}"
      puts
      table = Terminal::Table.new do |t|
        t << [saved_job.job.description.fit]
      end
      table.style.width = 84
      puts table
    end
    puts ' '
    print "Would you like to delete some jobs from your saved list? Please enter 'yes' or 'no': ".fit 84
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
    puts ' '
    user_input = gets.chomp
    if user_input != "exit"
      User.last.update(skills: user_input)
      view_profile
      puts ' '
      puts "\nYour skills have been updated!"
      puts ' '
    else
      puts "\nYou didn't update your profile"
      puts ' '
    end
  elsif input == "2"
    puts "Please enter new experience level in years or type 'exit':"
    puts ' '
    user_input = gets.chomp
    if user_input != "exit"
      User.last.update(experience: user_input)
      view_profile
      puts ' '
      puts "Your experience has been updated!"
      puts ' '
    else
      puts "\nYou didn't update your profile"
      puts ' '
    end
  elsif input == "3"
    puts "Please enter your new location or type 'exit':"
    puts ' '
    user_input = gets.chomp
    if user_input != "exit"
      User.last.update(location: user_input)
      view_profile
      puts ' '
      puts "Your location has been updated!"
      puts ' '
    else
      puts "\nYou didn't update your profile"
      puts ' '
    end
  else
    puts "\nYou didn't update your profile"
    puts ' '
  end
end

def average_interest_level(job_num)
  job = Job.find(job_num)
  total = job.saved_jobs.sum {|saved_job| saved_job.interest_level}
  total.to_f / job.saved_jobs.length
end

def view_average_interest_of_saved_job
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
    input = nil
    while input != "exit" do
      puts ' '
      puts "Please enter a job id to view average interest level or type exit:"
      puts ' '
      input = gets.chomp
      if input != "exit"
        puts ' '
        puts "Average interest in this job is #{average_interest_level(input)}"
      end
    end
  end
end

def location_match(job)
  user_location = User.last.location.downcase
  job_location = job.location.downcase
  user_arr = user_location.split(/[\s,]+/)
  user_arr = user_arr.collect{|x| x.strip || x }
  user_location = user_arr.join
  job_arr = job_location.split(/[\s,]+/)
  job_arr = job_arr.collect{|x| x.strip || x }
  job_location = job_arr.join
  if user_location.include?(job_location) || job_location.include?(user_location)
    true
  else
    false
  end
end

def location_match_arbitrary(job, location)
  user_location = location.downcase
  job_location = job.location.downcase
  user_arr = user_location.split(/[\s,]+/)
  user_arr = user_arr.collect{|x| x.strip || x }
  user_location = user_arr.join
  job_arr = job_location.split(/[\s,]+/)
  job_arr = job_arr.collect{|x| x.strip || x }
  job_location = job_arr.join
  if user_location.include?(job_location) || job_location.include?(user_location)
    true
  else
    false
  end
end
