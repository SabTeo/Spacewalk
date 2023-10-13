class RemoveArticleLocalRedundancy < ActiveRecord::Migration[6.1]
  def change
    remove_column :articles, :local
  end
end
