class CreateSavedJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :saved_jobs do |t|
      t.integer :user_id
      t.integer :job_id
      t.integer :interest_level
    end 
  end
end
