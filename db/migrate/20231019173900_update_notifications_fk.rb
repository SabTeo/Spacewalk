class UpdateNotificationsFk < ActiveRecord::Migration[6.1]
  def change
    remove_column :notifications, :admin_id
    add_reference :notifications, :admin, foreign_key: { to_table: :users }
    remove_column :notifications, :proposal_id
    add_reference :notifications, :proposal, foreign_key: true
    
  end
end
