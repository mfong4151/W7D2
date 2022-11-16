class SessionsController < ApplicationController

    def new
        render :new

    end

    def create 
        incoming_username = params[:user][:username]
        incoming_password = params[:user][:password]

        @user = User.find_user_by_credentials(incoming_username, incoming_password)

        if @user
            login(@user)
            redirect_to users_url
        else
            render :new

        end
    
    end

    def destroy
        logout
        redirect_to new_session_url
    end



end
