class PagesController < ApplicationController
    #controller per pagina lanci, login, logout, signup
    def launches
        uri = URI('https://fdo.rocketlaunch.live/json/launches/next/5')
        response_string = Net::HTTP.get(uri)
        @response = JSON.parse(response_string)
        @display = []
        @response['result'].each do |launch|
            t = Time.at(launch['sort_date'].to_i) - Time.now
            @display.append({name: launch['name'], t0: Time.at(launch['sort_date'].to_i) , date: Time.at(launch['sort_date'].to_i).to_datetime }) 
        end
    end
end
