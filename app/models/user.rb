class User < ActiveRecord::Base
  has_many :jobs, through: :saved_jobs

end
