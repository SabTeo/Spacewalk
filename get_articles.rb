#ENV["SSL_CERT_PATH"] = "/etc/ssl" 

#req = Net::HTTP.new('https://api.spaceflightnewsapi.net')
#req.ca_path = "/etc/ssl" 
#response_string = req.get('/v4/articles/')

#Script da eseguire periodicamente per inserire le 10 notizie più recenti nel database

uri = URI('https://api.spaceflightnewsapi.net/v4/articles/')
response_string = Net::HTTP.get(uri)
response = JSON.parse response_string
articles = response['results']
articles.each do |article|
    #per vedere se funziona senza db commentare tutto il seguito e decommentare questa
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