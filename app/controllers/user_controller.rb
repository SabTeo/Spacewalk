class UserController < ApplicationController

    def edit_profile
        @user = User.find(current_user.id)
        if !can? :edit, @user then redirect_to  edit_user_registration_path end
        if !params[:image].nil?
            @user.image = params[:image]
            @user.save
        end
        if !params[:username].nil? and params[:username]!=current_user.username
            @user.username = params[:username].strip
            @user.save
        end
        notice = ''
        if @user.errors.any? 
            @user.errors.full_messages.each do |message|
                notice += message
            end
            respond_to do |format|
                format.html { redirect_to edit_user_registration_url, status: :unprocessable_entity, notice: notice }
                format.json { render :template => 'users/registrations/edit', json: @user.errors, status: :unprocessable_entity }
            end
            return
        end
        respond_to do |format|
            format.html { redirect_to edit_user_registration_url, notice: notice}
            format.json { render :template => 'users/registrations/edit', status: :ok, location: edit_user_registration }
        end

    end


end
