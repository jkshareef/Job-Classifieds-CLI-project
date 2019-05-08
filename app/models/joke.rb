class Joke < ActiveRecord::Base


  def self.get_choices
    response_string = RestClient.get("https://official-joke-api.appspot.com/jokes/programming/ten")
    response_hash = JSON.parse(response_string)
    four_array = [response_hash[0..3]].flatten
  end
end
