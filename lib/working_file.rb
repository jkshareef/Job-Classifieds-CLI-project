def view_and_edit_jobs
  if User.last.saved_jobs.empty? || User.last.saved_jobs == nil
    puts
    puts "****You do not have any saved jobs to view.****"
    puts
  else
    jobs = User.last.saved_jobs
    jobs.each_with_index do |saved_job, index|
      puts ' '
      print '---------------------------------------------------------------------------------------------'
      puts ' '
      puts "#{index + 1}. #{saved_job.job.company}"
      puts "id:#{saved_job.job.id}"
      puts
      puts saved_job.job.description
    end
    puts
    puts "Would you like to delete jobs from your list? (y/n)"
    input = gets.chomp
    if input.downcase == "y"
      puts
      puts "Would you like to delete all saved jobs?"
      puts
      puts "Enter (y, n, menu)"
      puts
      input = gets.chomp
      if input.downcase == "y"
        User.last.saved_jobs.destroy_all
      elsif input.downcase == "n"
        puts "Which job would you like to delete?"
        puts "Enter job id"
        input = gets.chomp
        SavedJob.find_by(job_id: input, user_id: User.last.id).destroy
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
