class User < ActiveRecord::Base
  has_many :jobs, through: :saved_jobs
  has_many :saved_jobs












  def auto_search

    ### Searches Job Database and returns positions for any match to user location and either a keyword match form the users skills with either the job title or job description

    results = Job.all.select {|job| (skill_match_title?(job) || skill_match_description?(job)) && location_match?(job)}


    ### Uses the results of the search and
    #1. Creates a new SavedJob for each result
    #2. Associates the user to the SavedJob
    #3. Associates the job to the SavedJob
    #4. Adds the SavedJob to both User and Job

    results.each do |job_object|
      search_result = SavedJob.create
      search_result.user = self
      search_result.job = job_object
      self.saved_jobs << search_result
      job_object.saved_jobs << search_result
    end
  end

  def skill_match_title?(job)
    ### Helper file, splits user skills string into words in an array and searches job title for any match to each individual word
    self.skills.scan(/\w+/).any? {|word| job.title.include?(word)}
  end

  def skill_match_description?(job)
      ### Helper file, splits user skills string into words in an array and searches job description for any match to each individual word
    self.skills.scan(/\w+/).any? {|word| job.description.include?(word)}
  end

  def location_match?(job)
      ### Helper file, compares location of user and of job
    job.location.downcase == self.location.downcase
  end
end
