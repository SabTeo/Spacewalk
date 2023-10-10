class UniquenessConstraints < ActiveRecord::Migration[6.1]
  def change
    add_index :articles, :title, unique: true
    add_index :users, :username, unique: true
  end
end
