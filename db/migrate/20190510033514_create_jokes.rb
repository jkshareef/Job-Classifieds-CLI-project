class CreateJokes < ActiveRecord::Migration[5.2]
  def change
    create_table :jokes do |t|
      t.integer :user_id
      t.integer :job_id
      t.string :setup_punchline
    end
  end
end
