require 'rails_helper'

RSpec.describe "Operations", type: :request do
  describe "POST /api/operations" do
    it 'save new operation without errors' do
      user = User.create(name: 'Тестовый Тест Тестович', balance: 10000.0)

      params = {
        name: 'Покупка в магазине',
        type: 2,
        total: 200.0,
        user_id: user.id
      }

      headers = { "ACCEPT" => "application/json" }

      post '/api/operations', params: params, headers: headers, as: :json

      body = JSON.parse(response.body)
      expect(response).to have_http_status(:created)
      # проверяем тело ответа
      expect(body['data'].nil?).to eq false
      expect(body['data']['type']).to eq 'operations'
      expect(body['data']['id'].is_a? Integer).to eq true
      expect(body['data']['attributes'].nil?).to eq false
      expect(body['data']['attributes']['name']).to eq params[:name]
      expect(body['data']['attributes']['type']).to eq params[:type]
      expect(body['data']['attributes']['sum']).to eq params[:total]
      expect(body['data']['attributes']['date'].nil?).to eq false
      expect(body['data']['attributes']['date'].is_a? String).to eq true
      expect(body['data']['attributes']['balance'].is_a? Float).to eq true
      expect(body['data']['attributes']['balance']).to eq 9800.0
    end

    it 'save new operation and get ActiveRecord::RecordNotFound exception' do
      params = {
        name: 'Покупка в магазине',
        type: 2,
        total: 200.0,
        user_id: 9999999999
      }

      headers = { "ACCEPT" => "application/json" }

      post '/api/operations', params: params, headers: headers, as: :json

      body = JSON.parse(response.body)
      expect(response).to have_http_status(:bad_request)
      expect(body['errors'].is_a? Array).to eq true
      expect(body['errors'].count).to eq 1
      expect(body['errors'][0]['status']).to eq 404
      expect(body['errors'][0]['title']).to eq 'Запись не найдена'
      expect(body['errors'][0]['message'].is_a? String).to eq true
      expect(body['errors'][0]['message']).to eq "Пользователь с ID=#{params[:user_id]} не найден."
      expect(body['errors'][0]['code']).to eq 3
    end

    it 'save new operation and get BalanceHandler::BalanceIsLessThanZeroException exception' do
      user = User.create(name: 'Тестовый Тест Тестович', balance: 100.0)

      params = {
        name: 'Покупка в магазине',
        type: 2,
        total: 200.0,
        user_id: user.id
      }

      headers = { "ACCEPT" => "application/json" }

      post '/api/operations', params: params, headers: headers, as: :json

      body = JSON.parse(response.body)
      expect(response).to have_http_status(:bad_request)
      expect(body['errors'].is_a? Array).to eq true
      expect(body['errors'].count).to eq 1
      expect(body['errors'][0]['status']).to eq 400
      expect(body['errors'][0]['title']).to eq 'Ошибка транзакции'
      expect(body['errors'][0]['message'].is_a? String).to eq true
      expect(body['errors'][0]['message']).to eq 'Недостаточно средств.'
      expect(body['errors'][0]['code']).to eq 101
    end

    it 'save new operation and get validation errors with not present params' do
      params = {}
      headers = { "ACCEPT" => "application/json" }

      post '/api/operations', params: params, headers: headers, as: :json

      body = JSON.parse(response.body)
      expect(response).to have_http_status(:bad_request)
      expect(body['errors'].is_a? Array).to eq true
      expect(body['errors'].count).to eq 4
      # если не указано название операции
      expect(body['errors'][0]['status']).to eq 400
      expect(body['errors'][0]['title']).to eq 'Ошибка валидации'
      expect(body['errors'][0]['message'].is_a? String).to eq true
      expect(body['errors'][0]['message']).to eq 'Не указано название'
      expect(body['errors'][0]['code']).to eq 2

      # если не указан тип операции
      expect(body['errors'][1]['status']).to eq 400
      expect(body['errors'][1]['title']).to eq 'Ошибка валидации'
      expect(body['errors'][1]['message'].is_a? String).to eq true
      expect(body['errors'][1]['message']).to eq 'Не указан тип операции. 1 - доходы, 2 - расходы'
      expect(body['errors'][1]['code']).to eq 2

      # если не указана сумма операции
      expect(body['errors'][2]['status']).to eq 400
      expect(body['errors'][2]['title']).to eq 'Ошибка валидации'
      expect(body['errors'][2]['message'].is_a? String).to eq true
      expect(body['errors'][2]['message']).to eq 'Не указана сумма операции'
      expect(body['errors'][2]['code']).to eq 2

       # если не указан ID пользователя
       expect(body['errors'][3]['status']).to eq 400
       expect(body['errors'][3]['title']).to eq 'Ошибка валидации'
       expect(body['errors'][3]['message'].is_a? String).to eq true
       expect(body['errors'][3]['message']).to eq 'Не указан ID пользователя'
       expect(body['errors'][3]['code']).to eq 2
    end

    it 'save new operation and get validation errors that params must be a number' do
      params = {
        name: 'Покупка в магазине',
        type: '2',
        total: '200.0',
        user_id: '1'
      }
      headers = { "ACCEPT" => "application/json" }

      post '/api/operations', params: params, headers: headers, as: :json

      body = JSON.parse(response.body)
      expect(response).to have_http_status(:bad_request)
      expect(body['errors'].is_a? Array).to eq true
      expect(body['errors'].count).to eq 3

      # если тип операции передали как строку
      expect(body['errors'][0]['status']).to eq 400
      expect(body['errors'][0]['title']).to eq 'Ошибка валидации'
      expect(body['errors'][0]['message'].is_a? String).to eq true
      expect(body['errors'][0]['message']).to eq 'Тип операции должен быть числом'
      expect(body['errors'][0]['code']).to eq 2

      # если сумму операции передали как строку
      expect(body['errors'][1]['status']).to eq 400
      expect(body['errors'][1]['title']).to eq 'Ошибка валидации'
      expect(body['errors'][1]['message'].is_a? String).to eq true
      expect(body['errors'][1]['message']).to eq 'Сумма операции должна быть числом'
      expect(body['errors'][1]['code']).to eq 2

       # если ID пользователя передали как строку
       expect(body['errors'][2]['status']).to eq 400
       expect(body['errors'][2]['title']).to eq 'Ошибка валидации'
       expect(body['errors'][2]['message'].is_a? String).to eq true
       expect(body['errors'][2]['message']).to eq 'ID пользователя должен быть числом'
       expect(body['errors'][2]['code']).to eq 2
    end

    it 'save new operation and get validation errors that operation type is incorrect' do
      params = {
        name: 'Покупка в магазине',
        type: 3,
        total: 200.0,
        user_id: 1
      }
      headers = { "ACCEPT" => "application/json" }

      post '/api/operations', params: params, headers: headers, as: :json

      body = JSON.parse(response.body)
      expect(response).to have_http_status(:bad_request)
      expect(body['errors'].is_a? Array).to eq true
      expect(body['errors'].count).to eq 1

      # если тип операции передали как строку
      expect(body['errors'][0]['status']).to eq 400
      expect(body['errors'][0]['title']).to eq 'Ошибка валидации'
      expect(body['errors'][0]['message'].is_a? String).to eq true
      expect(body['errors'][0]['message']).to eq 'Тип операции должен быть либо 1 - доходы, либо 2 - расходы'
      expect(body['errors'][0]['code']).to eq 2
    end

    it 'save new operation and get validation errors that sum must be more than 0' do
      params = {
        name: 'Покупка в магазине',
        type: 2,
        total: -200.0,
        user_id: 1
      }
      headers = { "ACCEPT" => "application/json" }

      post '/api/operations', params: params, headers: headers, as: :json

      body = JSON.parse(response.body)
      expect(response).to have_http_status(:bad_request)
      expect(body['errors'].is_a? Array).to eq true
      expect(body['errors'].count).to eq 1

      # если тип операции передали как строку
      expect(body['errors'][0]['status']).to eq 400
      expect(body['errors'][0]['title']).to eq 'Ошибка валидации'
      expect(body['errors'][0]['message'].is_a? String).to eq true
      expect(body['errors'][0]['message']).to eq 'Сумма операции должна быть больше 0'
      expect(body['errors'][0]['code']).to eq 2
    end
  end
end
