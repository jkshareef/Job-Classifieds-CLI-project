class Job < ActiveRecord::Base
  has_many :interviews
  has_many :users, through: :interviews
  has_many :users, through: :saved_jobs
  has_many :saved_jobs
end
