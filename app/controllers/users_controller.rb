class UsersController < ApiController
    def index
        @users = User.all

        render :index
    end

    # Вывод операций пользователя, за указанный период
    def operations
        date_start = params[:date_start]
        date_end = params[:date_end]
        user_id = params[:id]

        add_error(400, 'Ошибка валидации', 'Не указана начальная дата периода', 1) if date_start.nil?
        add_error(400, 'Ошибка валидации', 'Не указана конечная дата периода', 1) if date_end.nil?
        if user_id.nil?
            add_error(400, 'Ошибка валидации', 'Не указан ID пользователя', 1) 
        else 
            user_id = user_id.to_i if Integer(user_id) rescue add_error(400, 'Ошибка валидации', 'ID пользователя должен быть числом', 1)
        end

        if errors?
            render_errors()
        else
            @operations = Operation.where('user_id = ?', user_id).where(operation_date: date_start..date_end).order(:operation_date)
            render 'operations/index'
        end
    end
end
