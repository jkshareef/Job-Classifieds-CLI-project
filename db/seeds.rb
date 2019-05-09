def get_job_listings
  response_array = []
  i = 0
  loop do
    response_string = RestClient.get("https://jobs.github.com/positions.json?page=#{i}")
    response_hash = JSON.parse(response_string)
    i +=1
    if !response_hash.empty?
      response_array << response_hash
    else
      return response_array.flatten
    end
  end
end

def update_job_table
  get_job_listings.each do |hash|
    Job.create(title: hash['title'], company: hash['company'], position_type: hash['type'], description: strip_tags(hash['description']), url: hash['url'], created_at: hash['created_at'], company_url: hash['company_url'], location: hash['location'])
  end
end

def strip_tags s
  s.split(/\<.*?\>/)
   .map(&:strip)
   .reject(&:empty?)
   .join(' ')
   .gsub(/\s,/,',')
end


def fake_user_data
  positions = Job.all.size
  seekers = positions * 2
  seekers.times do
    seeker = User.new
    seeker.name = Faker::Name.unique.name
    seeker.skills = Skills.sample(8).join(' ')
    seeker.experience = rand(0..20)
    seeker.location = Locations.sample
    seeker.save
  end
end

def fake_add_to_saved_jobs_and_interviews(id)
  rand(1..3).times do
    job_num = rand(1..350)
    new_job = SavedJob.create
    new_job.user = User.find(id)
    new_job.job = Job.find(job_num)
    new_job.interest_level = rand(1..10)
    User.find(id).saved_jobs << new_job
    Job.find(job_num).saved_jobs << new_job
    interview = Interview.create
    interview.user = User.find(id)
    interview.job = Job.find(job_num)
    User.find(id).interviews << interview
    Job.find(job_num).interviews << interview
  end
end

def fake_user_actions
  User.all.each {|user| fake_add_to_saved_jobs_and_interviews(user.id)}
end



update_job_table
fake_user_data
fake_user_actions
