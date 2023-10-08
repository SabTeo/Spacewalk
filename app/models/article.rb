class Article < ActiveRecord::Base
    has_many :comments 

    def self.get_supported_languages()
        {   'Italiano' => 'IT',
            'English' => 'EN',
            'Deutsch' => 'DE',
            'Español' => 'ES',
            'Français' => 'FR',
            '日本語' => 'JA',
            'Русский язык' => 'RU',
            '简体字' => 'ZH'
        }
    end


    #inserisce AL MASSIMO 10 articoli piu recenti nel database, eseguita non piu di una volta ogni 3 ore 
    def self.update_articles 
        if Rails.cache.read('up_to_date').nil?
              uri = URI('https://api.spaceflightnewsapi.net/v4/articles/')
              response_string = Net::HTTP.get(uri)
              response = JSON.parse response_string
              articles = response['results']
              articles.each do |article|
                  #puts(article['id'].to_s + ' | ' + article['title'])
                  if Article.exists?(ext_id: article['id'])
                      break
                  else     
                      art = Article.create({
                        :ext_id => article['id'],
                        :title => article['title'],
                        :img_url => article['image_url'],
                        :body => nil,
                        :local => false,
                        :author_id => nil,
                        :url => article['url'],
                        :news_site => article['news_site'],
                        :published_at => article['published_at']
                      })
                  end
              end
            Rails.cache.write('up_to_date', 'true', expires_in: 3.hours)
            #flash[:notice] = 'updated'
        else
          #flash[:notice] = 'not updated'
        end
    end
  
end