#Script da eseguire periodicamente per inserire AL MASSIMO 10 notizie più recenti non presenti nel database
uri = URI('https://api.spaceflightnewsapi.net/v4/articles/')
response_string = Net::HTTP.get(uri)
response = JSON.parse response_string
articles = response['results']
articles.each do |article|
    if Article.exists?(ext_id: article['id'])
        break
    else
        #puts(article['id'].to_s + ' | ' + article['title'] + ' | ' + + article['id'].to_s)     
        art = Article.create!({
          :ext_id => article['id'],
          :title => article['title'],
          :img_url => article['image_url'],
          :body => nil,
          :author_id => nil,
          :url => article['url'],
          :news_site => article['news_site'],
          :published_at => article['published_at']
        })
    end
end
