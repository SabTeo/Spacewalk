class ApplicationController < ActionController::Base
    after_action :check_for_redirect

    #before_action :set_locale

    #def set_locale
    #    I18n.locale = :it
    #end
    private
    #auto redirect per risposte diverse da 3xx
    def check_for_redirect
        if response.body.include? "You are being"
        html_doc = Nokogiri::HTML(response.body)
        uri = html_doc.css('a').map { |link| link['href'] }.first
        response.body = "<script>
                             window.location.replace('#{uri}');
                        </script>
                        <noscript>
                            You are being <a href='#{uri}'>redirected<a>
                        </noscript>"           
        end
    end
end
