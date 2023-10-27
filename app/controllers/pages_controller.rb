class PagesController < ApplicationController
    def launches
        @display = []
        session.key?(:locale) ?  I18n.locale = session[:locale] :  I18n.locale = :it
        begin
            uri = URI('https://fdo.rocketlaunch.live/json/launches/next/5')
            response_string = Net::HTTP.get(uri)
            response = JSON.parse(response_string)
            response['result'].each do |launch|
                t = Time.at(launch['sort_date'].to_i) - Time.now
                display_name = launch.dig('vehicle', 'name') + ' | ' + launch['name']
                @display.append({name: display_name,
                                location: launch.dig('pad', 'location', 'name'),
                                country: '('+ launch.dig('pad', 'location', 'country')+')',
                                t0: Time.at(launch['sort_date'].to_i),
                                date: Time.at(launch['sort_date'].to_i).to_datetime, 
                                agency: launch.dig('provider', 'name') })
            end
        rescue
            flash[:notice] = 'Servizio non disponibile'
        end
    end

    def not_found
        respond_to do |format|
            format.html { render :template => '404', status: 404 }
        end
    end

    
end
