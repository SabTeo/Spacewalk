class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.integer :admin_id
      t.integer :proposal_id

      t.timestamps
    end
  end
end
