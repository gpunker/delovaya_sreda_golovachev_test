class OperationsController < ApiController
    # Создание новой операции
    def create
        parameters = operation_params

        if errors?
            return render_errors()
        end

        begin
            user = User.find(parameters[:user_id])

            @operation = Operation.create!(
                name: parameters[:name],
                op_type: parameters[:type],
                total: parameters[:total],
                operation_date: DateTime.now,
                user: user
            )

            render :show, status: :created
        rescue ActiveRecord::RecordNotFound
            add_error(404, 'Запись не найдена', "Пользователь с ID=#{parameters[:user_id]} не найден.", 3)
            render_errors()
        rescue BalanceHandler::BalanceIsLessThanZeroException => e
            add_error(400, 'Ошибка транзакции', e.message, e.code)
            render_errors()
        end
    end

    private
    # Сбор и валидация параметров операции
    def operation_params
        parameters = params.permit(:name, :type, :total, :user_id)

        # Валидация названия
        add_error(400, 'Ошибка валидации', 'Не указано название', 2) if parameters[:name].nil?

        # Валидация типа операции
        if parameters[:type].nil?
            add_error(400, 'Ошибка валидации', 'Не указан тип операции. 1 - доходы, 2 - расходы', 2) 
        elsif !parameters[:type].is_a? Integer
            add_error(400, 'Ошибка валидации', 'Тип операции должен быть числом', 2)
        elsif ![1, 2].include?(parameters[:type])
            add_error(400, 'Ошибка валидации', 'Тип операции должен быть либо 1 - доходы, либо 2 - расходы', 2) 
        end
        
        # Валидация суммы операции
        if parameters[:total].nil?
            add_error(400, 'Ошибка валидации', 'Не указана сумма операции', 2) 
        elsif !parameters[:total].is_a? Float
            add_error(400, 'Ошибка валидации', 'Сумма операции должна быть числом', 2) 
        elsif parameters[:total].to_f < 0
            add_error(400, 'Ошибка валидации', 'Сумма операции должна быть больше 0', 2) 
        end

        # Валидация id пользователя
        if parameters[:user_id].nil?
            add_error(400, 'Ошибка валидации', 'Не указан ID пользователя', 2) 
        elsif !parameters[:user_id].is_a? Integer
            add_error(400, 'Ошибка валидации', 'ID пользователя должен быть числом', 2)
        end

        return parameters
    end
end