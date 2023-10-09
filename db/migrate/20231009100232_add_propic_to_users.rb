class AddPropicToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :propic, :string
  end
end
