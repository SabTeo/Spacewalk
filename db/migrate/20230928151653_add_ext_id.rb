class AddExtId < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :ext_id, :integer 
  end
end
