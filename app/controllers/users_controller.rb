class UsersController < ApplicationController
    def index
        @users = User.all

        render :index
    end

    def operations
        date_start = params[:date_start]
        date_end = params[:date_end]
        user_id = params[:id]

        @operations = Operation.where('user_id = ?', user_id) #.where(operation_date: date_start..)

        render 'operations/index'
    end
end
