done = false
uri = URI('https://api.spaceflightnewsapi.net/v4/articles/')
count = 0
while !done and count < 20 #massimo 20 per non scaricare tutto il db remoto in caso il db locale sia vuoto
    response_string = Net::HTTP.get(uri)
    response = JSON.parse response_string
    articles = response['results']
    articles.each do |article|
        if Article.exists?(ext_id: article['id'])
            done = true
            break
        else    
            art = Article.new({
                :ext_id => article['id'],
                :title => article['title'],
                :img_url => article['image_url'],
                :body => nil,
                :author_id => nil,
                :url => article['url'],
                :news_site => article['news_site'],
                :published_at => article['published_at']
            })
            if art.save
                count += 1
            end
            if art.errors.any?
                art.errors.full_messages.each do |msg|
                    puts(msg)
                end
                done = true
                break
            end
        end   
    end
    uri = URI(response['next'])
end
puts("inserted #{count} articles at " + DateTime.now.to_s)
