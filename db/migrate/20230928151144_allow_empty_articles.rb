class AllowEmptyArticles < ActiveRecord::Migration[6.1]
  def change
    change_column_null :articles, :body, true
  end
end
