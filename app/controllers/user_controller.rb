class UserController < ApplicationController

    def edit_profile
        @user = User.find(current_user.id)
        modified = false
        if !can? :edit, @user
            respond_to do |format|
                format.html { redirect_to articles_url, status: 403 }
            end
            return
        end
        if !params[:image].nil?  and params[:image]!=current_user.image
            @user.image = params[:image]
            @user.save
            modified = true
        end
        if !params[:username].nil? and params[:username]!=current_user.username
            @user.username = params[:username].strip
            @user.save
            modified = true
        end
        notice = ''
        if @user.errors.any?
            @user.errors.full_messages.each do |message|
                notice += message
            end
            respond_to do |format|
                format.html { redirect_to edit_user_registration_url, notice: notice }
            end
        else
            if modified then notice = 'modifica avvenuta con successo' end
            respond_to do |format|
                format.html { redirect_to edit_user_registration_url, notice: notice}
            end
        end
    end


end
