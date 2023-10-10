class AllowNullPublication < ActiveRecord::Migration[6.1]
  def change
    change_column_null :articles, :published_at, true
  end
end
