class PagesController < ApplicationController
    #controller per pagina lanci, login, logout, signup
    def launches
        @display = []
        begin
            uri = URI('https://fdo.rocketlaunch.live/json/launches/next/5')
            response_string = Net::HTTP.get(uri)
            @response = JSON.parse(response_string)
            @response['result'].each do |launch|
                t = Time.at(launch['sort_date'].to_i) - Time.now
                display_name = launch.dig('vehicle', 'name') + ' | ' + launch['name']
                @display.append({name: display_name,
                                location: launch.dig('pad', 'location', 'name') + ' ('+ launch.dig('pad', 'location', 'country')+')',
                                t0: Time.at(launch['sort_date'].to_i),
                                date: Time.at(launch['sort_date'].to_i).to_datetime }) 
            end
        rescue
            flash[:notice] = 'Servizio non disponibile'
        end
    end
end
