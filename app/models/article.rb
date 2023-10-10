class Article < ActiveRecord::Base
    has_many :comments
    validates :title, uniqueness: true

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


    #inserisce TUTTI gli articoli piu recenti nel database, eseguita non piu di una volta ogni 3 ore 
    def self.update_articles 
        if Rails.cache.read('up_to_date').nil?
            done = false
            i = 0 #indice di sicurezza per non scaricare tutto il db remoto
            uri = URI('https://api.spaceflightnewsapi.net/v4/articles/')
            while !done and i < 50
                response_string = Net::HTTP.get(uri)
                response = JSON.parse response_string
                articles = response['results']
                articles.each do |article|
                    if Article.exists?(ext_id: article['id'])
                        done = true
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
                uri = URI(response['next'])
                i += 10 
            end
            Rails.cache.write('up_to_date', 'true', expires_in: 3.hours)
            #flash[:notice] = 'updated'
        else
          #flash[:notice] = 'not updated'
        end
    end
  
end