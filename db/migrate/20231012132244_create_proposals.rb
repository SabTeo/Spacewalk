class CreateProposals < ActiveRecord::Migration[6.1]
  def change
    create_table :proposals do |t|
      t.string :title,  null: false
      t.string :img_url
      t.string :body,  null: false
      t.integer :status
      t.string :message
      t.datetime :submittes_at
      t.references 'user'

      t.timestamps
    end
  end
end
