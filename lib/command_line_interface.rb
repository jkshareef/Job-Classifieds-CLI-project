require_all './app/models'
require 'word_wrap/core_ext'
require 'catpix'

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
    elsif input == "6" && !User.last.interviews.empty?
      view_interviews
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
  `-----------------------'".colorize(:green)]
  end
  table.style.width = 84
  table.align_column(0, :center)
  puts table
end

def welcome_message
  table = Terminal::Table.new do |t|
    t << ["In order for us to find the jobs best suited to you, we will ask you to quickly create a profile.".fit]
  end
  # table.style.width = 84
  table.align_column(0, :center)
  table.title = "Hello job seeker! Welcome to SMARTER CLASSIFIEDS!.".fit
  puts table
end

def gets_user_data

  new_user = User.create

  print "Enter your name: "
  new_user.update(name: gets.chomp)
  print "Enter your skills: "
  new_user.update(skills: gets.chomp)
  print "Enter Experience: "
  new_user.update(experience: gets.chomp)
  print "Enter default search location: "
  new_user.update(location: gets.chomp)
  puts ' '
end

def menu
  if User.last.interviews.empty?
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
    end
    table.title = "=====MENU=====".colorize(:green)
    table.align_column(0, :left)
    puts table
    puts
    print "Please select an option by reference number or 'quit' to exit: "
    puts
  else
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
      t.add_row [("6. View Interview Requests").colorize(:background => :green)]
      t << :separator
    end
    table.title = "=====MENU=====".colorize(:green)
    table.align_column(0, :left)
    puts table
    print "Please select an option by reference number or 'quit' to exit: "
    puts
    table = Terminal::Table.new do |t|
      t << ['Congratulations, an Employer Has Reviewed Your Application and Would Like to Schedule an Interview! View Your Interviews Page to See All Scheduled Interviews'.colorize(:yellow).fit]
    end
    table.align_column(0, :center)
    puts table
  end
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
     # table.style.width = 84
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
(or multiple jobs) to your job list, please enter the 'Job Number'."
  puts ' '
  print "Would you like to save any of the jobs listed above? please enter 'yes' if you would like
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
            table = Terminal::Table.new do |t|
              t << ["Would you like to Apply to this job (y/n)?".fit]
            end
              table.style.width = 84
              table.align_column(0, :center)
            puts table
            input = gets.chomp
            if input.downcase == "y"
              add_to_saved_jobs(job_number)
              add_to_interviews(job_number)
              break
            end
            puts "Would you like to Save this Job for later (y/n)?"
            input = gets.chomp
            if input.downcase == "y"
              add_to_saved_jobs(job_number)
              break
            end
          else
            print "Whoops! that's not a valid input. Please enter a valid command: ".colorize(:red)
            job_number = gets.chomp
          end
        end

        print "Curent level of interest on a scale of 1-10: "
        job_rating = gets.chomp
        loop do
          if !(1..10).to_a.include?(job_rating.to_i)
            print "Please enter a value between 1 and 10: ".colorize(:red)
            job_rating = gets.chomp
          elsif job_rating.to_i.to_s == job_rating
            add_interest_rating(job_rating)
            break
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
          print "Whoops! that's not a valid input. Please enter a valid command: ".colorize(:red)
        end
      end
    else
      print "Whoops! that's not a valid input. Please enter a valid command: ".colorize(:red)
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

def add_to_interviews(num)
  interview = Interview.create
  interview.user = User.last
  interview.job = Job.find(num)
  User.last.interviews << interview
  Job.find(num).interviews << interview
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
      puts ' '
      table = Terminal::Table.new do |t|
        t << [saved_job.job.description.fit]
      end
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
            print "That job has been removed!"
            puts ' '
            print "Please enter another job number or enter 'menu' to be redirected: "
          elsif input.to_i.to_s == input && !SavedJob.exists?(job_id: input, user_id: User.last.id)
            print "Whoops! it looks like you don't currently have that job saved.
Please enter a valid job number: ".colorize(:red)
          else
            print "Whoops! that's not a valid input. Please enter a valid command: ".colorize(:red)
          end
        end
      end
    end
  end
end

def view_profile
  puts "\nHere is your current profile...\nName: #{User.last.name}\nSkills: #{User.last.skills}\nExperience: #{User.last.experience}\nLocation: #{User.last.location}"
end

def update_profile
  table = Terminal::Table.new do |t|
    t << ["1. Skills: #{User.last.skills}".fit]
    t << :separator
    t.add_row ["2. Experience: #{User.last.experience}".fit]
    t << :separator
    t.add_row ["3. Default Search Location: #{User.last.location}".fit]
  end
  table.style.width = 84
  table.align_column(0, :left)
  table.title = "=====Current Profile=====".fit.colorize(:green)
  puts table
  print "Please enter the number associated with the category you would like to update or type 'exit' to exit: "

  input = gets.chomp
  if input == "1"
    print "Please enter please enter the full updated list of skills or 'exit' to exit: "
    puts ' '
    user_input = gets.chomp
    if user_input != "exit"
      User.last.update(skills: user_input)
      view_profile
      puts ' '
      puts "Your skills have been updated!"
      puts ' '
    else
      puts "Your profile has not been updated."
      puts ' '
    end
  elsif input == "2"
    puts "Please enter current experience level in years to update experience or type 'exit' to exit:"
    puts ' '
    user_input = gets.chomp
    if user_input != "exit"
      User.last.update(experience: user_input)
      view_profile
      puts ' '
      puts "Your experience has been updated!"
      puts ' '
    else
      puts "Your profile has not been updated."
      puts ' '
    end
  elsif input == "3"
    puts "Please update your default search location or type 'exit' to exit:"
    puts ' '
    user_input = gets.chomp
    if user_input != "exit"
      User.last.update(location: user_input)
      view_profile
      puts ' '
      puts "Your location has been updated!"
      puts ' '
    else
      puts "Your profile has not been updated."
      puts ' '
    end
  else
    puts "Your profile has not been updated."
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

def view_interviews
  interviews = User.last.interviews
  id_list = interviews.map {|interview| interview.job.id}
  interviews.each_with_index do |interview, index|
    puts "\n------------------------------------------------------------------------------------\n"
    puts "Interview ##{index+1} #{interview.job.company} Job Id Number: #{interview.job.id}\n"
    puts "Job Title: #{interview.job.title}"
    puts "Scheduled Date: #{Faker::Date.between(Date.today, 10.days.from_now)}\n"
    table = Terminal::Table.new do |t|
      t << [interview.job.description.fit]
    end
    puts table
  end
    table = Terminal::Table.new do |t|
      t << ["An interview is a technical phone screening, You may choose to begin the Interview at any time by entering the Job Id Number or type 'exit'".colorize(:yellow).fit]
    end
    puts table
    loop do
      input = gets.chomp
      if input.downcase == 'exit'
        break
      elsif id_list.include?(input.to_i)
        run_interview(input.to_i)
      else
        puts "Please enter a valid job number or type 'exit'"
      end
    end
  end

  def run_interview(job_id)
    images = ['./images/little_pug.jpeg', './images/white_lab_suit.jpeg']
    selected_image = images.sample
    Catpix::print_image selected_image,
    :limit_x => 1.0,
    :limit_y => 0.6,
    :center_x => true,
    :center_y => false,
    :bg => "black",
    :bg_fill => false,
    :resolution => "high"
    interview_welcome(job_id)
    array = Joke.get_choices
    prompt = TTY::Prompt.new
    prompt.select("Choose Your Joke Wisely") do |menu|
      menu.choice "#{array[0]['setup']}......#{array[0]['punchline']}".fit
      menu.choice "#{array[1]['setup']}......#{array[1]['punchline']}".fit
      menu.choice "#{array[2]['setup']}......#{array[2]['punchline']}".fit
      menu.choice "#{array[3]['setup']}......#{array[3]['punchline']}".fit
    end
  end

  def interview_welcome(job_id)
    puts "Welcome to #{Job.find(job_id).company}, We are so happy to have you here..."
    sleep(2)
    puts "I'm going to be frank with you. You are a no-brainer hire..."
    sleep(2)
    puts "What is most important here at #{Job.find(job_id).company} is to keep it light..."
    sleep(2)
    puts "If you can tell us a really great programming joke the job is yours!"
    sleep(5)
  end
