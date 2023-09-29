class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.string :text
      t.datetime :published_at
      t.references 'article'
      t.references 'user'
    
      t.timestamps
    end
  end
end
