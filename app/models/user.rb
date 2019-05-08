class User < ActiveRecord::Base
  has_many :jobs, through: :saved_jobs
  has_many :saved_jobs


#   def auto_search
#
#    ### Searches Job Database and returns positions for any match to user location and either a keyword match form the users skills with either the job title or job description
#  #
#     results = Job.all.select { |job|
#       (skill_match_title?(job) || skill_match_description?(job)) && location_match?(job)
#     }
#  #
#  #
#  #   ### Uses the results of the search and
#  #   #1. Creates a new SavedJob for each result
#  #   #2. Associates the user to the SavedJob
#  #   #3. Associates the job to the SavedJob
#  #   #4. Adds the SavedJob to both User and Job
#  #
#     results.each do |job|
#       print "Job #{job.id}."
#     #  print job.company
#       print job.title
#       print job.position_type
#       print job.description
#  #
#  #     # search_result = SavedJob.create
#  #     # search_result.user = self
#  #     # search_result.job = job
#  #     # self.saved_jobs << search_result
#  #     # job.saved_jobs << search_result
#    end
#  end
#
#
#  #
#  def search_arbitrary_criteria
#    print "Please enter keywords for your search separated by spaces: "
#    keywords = gets.chomp.split(' ')
#
#    results = Job.all.select { |job|
#      (keywords.scan(/\w+/).any? {|word| job.title.include?(word)} || keywords.scan(/\w+/).any? {|word| job.description.include?(word)}) && location_match?(job)
#    }
#
#    results.each do |job|
#      print "Job #{job.id}."
#    #  print job.company
#      print job.title
#      print job.position_type
#      print job.description
#   end
#  end
end
