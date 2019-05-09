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
# binding.pry
update_job_table

# jamal = User.new
# jamal.name = 'Jamal Shareef'
# jamal.skills = "Full Stack Web Developer"
# jamal.experience = 4
# jamal.location = 'Port Coquitlam, BC'
# jamal.save
# jamal.auto_search
