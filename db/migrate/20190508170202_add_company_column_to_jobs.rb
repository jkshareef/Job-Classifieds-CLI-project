class AddCompanyColumnToJobs < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :company, :string
  end
end
