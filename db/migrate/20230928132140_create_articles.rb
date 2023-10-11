class CreateArticles < ActiveRecord::Migration[6.1]

  def change
    create_table :users do |t|
      t.string :name
      t.timestamps
    end

    create_table :articles do |t|
      t.string :title,  null: false
      t.string :img_url
      t.string :body,  null: false
      t.boolean :local,  null: false
      t.string :url
      t.string :news_site
      t.datetime :published_at

      t.timestamps
    end

  end
end
