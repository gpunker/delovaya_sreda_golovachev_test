class ApiController < ApplicationController
    protected
    # Добавление ошибки в стек ошибок
    #
    # @param status [Integer] HTTP-статус ошибки
    # @param title [String] Заголовок ошибки
    # @param message [String] Сообщение ошибки
    # @param code [Integer] Код ошибки
    #
    # @return [Array] массив хэшей с ключами, переданными в сигнатуре метода
    def add_error(status, title, message, code=0)
        if @errors.nil?
            @errors = []
        end
        @errors.push({
            status: status,
            title: title,
            message: message,
            code: code
        })
    end

    # Рендер ошибок
    def render_errors
        render 'errors/errors', status: 400
    end

    # Проверка, есть ли ошибки в стеке
    #
    # @return [Boolean] true - если ошибки есть, false - если ошибок нет
    def errors?
        if @errors.nil? 
            return false
        end
            
        !@errors.empty?
    end
end