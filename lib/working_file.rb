#require_all './app/models'
#
def view_and_edit_jobs
  jobs = User.last.saved_jobs
  jobs.each_with_index do |job, index|
    puts "#{index + 1}. #{job.title}, id:#{job.id}"
    puts job.description
  end
  puts "Would you like to delete jobs from your list? (y/n)"
  input = gets.chomp
  if input.downcase == "y"
    puts "Would you like to delete all saved jobs? (y/n)"
    puts "Enter (y, n, menu)"
    input = gets.chomp
    if input.downcase == "y"
      User.last.saved_jobs.destroy_all
    elsif input.downcase == "n"
      puts "Which job would you like to delete?"
      puts "Enter job id"
      input = gets.chomp
      Job.find(input).destroy
    end
  end
end
#
#
# view_and_edit_jobs
