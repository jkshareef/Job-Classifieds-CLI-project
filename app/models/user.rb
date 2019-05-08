class User < ActiveRecord::Base
  has_many :jobs, through: :saved_jobs
  has_many :saved_jobs


end
