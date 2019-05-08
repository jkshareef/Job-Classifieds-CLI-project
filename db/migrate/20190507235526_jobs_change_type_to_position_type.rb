class JobsChangeTypeToPositionType < ActiveRecord::Migration[5.2]
  def change
    rename_column :jobs, :type, :position_type
  end
end
