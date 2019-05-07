class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :skills
      t.integer :experience
      t.string :location
    end 
  end
end
