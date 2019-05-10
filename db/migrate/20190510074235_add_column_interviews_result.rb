class AddColumnInterviewsResult < ActiveRecord::Migration[5.2]
  def change
    add_column :interviews, :result, :string
  end
end
