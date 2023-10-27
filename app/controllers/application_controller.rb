class ApplicationController < ActionController::Base
    #rescue_from Exception, with: :display_500
    rescue_from ActionController::RoutingError, with: :not_found
    rescue_from ::ActionController::InvalidAuthenticityToken, with: :redirect_home
    after_action :check_for_redirect

    def not_found
        respond_to do |format|
            format.html { render :template => '404', status: 404 }
        end
    end
    
    def redirect_home
        respond_to do |format|
            format.html { redirect_to articles_path, notice: 'Qualcosa non ha funzionato' }
        end
    end

    private

    def display_500
        respond_to do |format|
            format.html { render :template => '/public/500', status: 500 }
        end
    end

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
