class CreateJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :jobs do |t|
      t.string :title
      t.string :type
      t.string :description
      t.string :url
      t.string :created_at
      t.string :company_url
      t.string :location
    end
  end
end
