class UsersController < ApiController
    # Просто для вывода пользователей
    def index
        @users = User.all

        render :index
    end

    # Вывод операций пользователя, за указанный период
    def operations
        # собираем параметры для запроса
        date_start = params[:date_start]
        date_end = params[:date_end]
        user_id = params[:id]

        # собираем парметры пагинации
        page = params[:page]
        @page_number = page && page[:number] ? page[:number].to_i : 1
        per_page = page && page[:size] ? page[:size].to_i : 10

        # валидация
        add_error(400, 'Ошибка валидации', 'Не указана начальная дата периода', 1) if date_start.nil?
        add_error(400, 'Ошибка валидации', 'Не указана конечная дата периода', 1) if date_end.nil?
        if user_id.nil?
            add_error(400, 'Ошибка валидации', 'Не указан ID пользователя', 1) 
        else 
            user_id = user_id.to_i if Integer(user_id) rescue add_error(400, 'Ошибка валидации', 'ID пользователя должен быть числом', 1)
        end

        # проверка на наличие ошибок и вывод операций
        if errors?
            render_errors()
        else
            @operations = Operation.where('user_id = ?', user_id)
                                   .where(operation_date: date_start..date_end)
                                   .order(:operation_date)
            # баланс на начало/конец периода
            @balance_start = @operations.first ? @operations.first.balance_before : 0
            @balance_end = @operations.last ? @operations.last.balance : 0

            @operations = @operations.page(@page_number).per(per_page)
            
            @meta_total_count = @operations.total_count
            @meta_count = @operations.size
            @meta_prev_page = @operations.prev_page
            @meta_next_page = @operations.next_page

            render 'operations/index'
        end
    end
end
