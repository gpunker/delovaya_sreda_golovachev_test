require 'rails_helper'
require 'json'

RSpec.describe 'Users', type: :request do
    describe "GET /api/users" do
        it 'get all users' do
            user = User.create(
                name: 'Имя',
                balance: 1000.0
            )

            headers = { "ACCEPT" => "application/json" }
            get '/api/users', headers: headers

            expect(response).to have_http_status(:ok)

            body = JSON.parse(response.body)
            expect(body['data'][0]['type']).to eq 'users'
            expect(body['data'][0]['id'].nil?).to eq false
            expect(body['data'][0]['id'].is_a? Integer).to eq true
            expect(body['data'][0]['attributes']['name']).to eq 'Имя'
            expect(body['data'][0]['attributes']['balance']).to eq 1000.0
        end
    end

    describe "GET /api/users/:id/operations" do
        it 'get operations by user without errors' do
            user = User.create(
                name: 'Имя',
                balance: 1000.0
            )

            Operation.create([
                { name: 'Снятие наличных', op_type: Operation::EXPENDITURE, operation_date: DateTime.now, total: 200, user: user },
                { name: 'Зачисление зарплаты', op_type: Operation::INCOME, operation_date: DateTime.now + 1.days, total: 10000, user: user }
            ])


            headers = { "ACCEPT" => "application/json" }
            params = {
                date_start: DateTime.now - 10.days,
                date_end: DateTime.now + 10.days,
            }
            get "/api/users/#{user.id}/operations", params: params, headers: headers

            expect(response).to have_http_status(:ok)

            body = JSON.parse(response.body)
            expect(body['data'].count).to eq 2
            # первый элемент
            expect(body['data'][0]['type']).to eq 'operations'
            expect(body['data'][0]['id'].nil?).to eq false
            expect(body['data'][0]['id'].is_a? Integer).to eq true
            expect(body['data'][0]['attributes']['name']).to eq 'Снятие наличных'
            expect(body['data'][0]['attributes']['type']).to eq 2
            expect(body['data'][0]['attributes']['date'].nil?).to eq false
            expect(body['data'][0]['attributes']['sum']).to eq 200.0
            expect(body['data'][0]['attributes']['balance']).to eq 800.0

            # второй элемент
            expect(body['data'][1]['type']).to eq 'operations'
            expect(body['data'][1]['id'].nil?).to eq false
            expect(body['data'][1]['id'].is_a? Integer).to eq true
            expect(body['data'][1]['attributes']['name']).to eq 'Зачисление зарплаты'
            expect(body['data'][1]['attributes']['type']).to eq 1
            expect(body['data'][1]['attributes']['date'].nil?).to eq false
            expect(body['data'][1]['attributes']['sum']).to eq 10000.0
            expect(body['data'][1]['attributes']['balance']).to eq 10800.0

            # мета-информация
            # данные о балансе
            expect(body['meta']['balance']['balance_start']).to eq 1000.0
            expect(body['meta']['balance']['balance_end']).to eq 10800.0
            
            #данные о пагинации
            expect(body['meta']['page']['total']).to eq 2
            expect(body['meta']['page']['count']).to eq 2
            expect(body['meta']['page']['next_page']).to eq nil
            expect(body['meta']['page']['prev_page']).to eq nil
            expect(body['meta']['page']['current_page']).to eq 1
        end

        it 'get users operations with errors when operation dates did not accepted' do
            user = User.create(
                name: 'Имя',
                balance: 1000.0
            )

            Operation.create([
                { name: 'Снятие наличных', op_type: Operation::EXPENDITURE, operation_date: DateTime.now, total: 200, user: user },
                { name: 'Зачисление зарплаты', op_type: Operation::INCOME, operation_date: DateTime.now + 1.days, total: 10000, user: user }
            ])


            headers = { "ACCEPT" => "application/json" }
            # params = {
            #     date_start: DateTime.now - 10.days,
            #     date_end: DateTime.now + 10.days,
            # }
            get "/api/users/#{user.id}/operations", headers: headers

            expect(response).to have_http_status(:bad_request)
            
            body = JSON.parse(response.body)

            expect(body['errors'].nil?).to eq false
            expect(body['errors'].is_a? Array).to eq true
            expect(body['errors'].count).to eq 2
            # проверяем типы данных в первой ошибке
            expect(body['errors'][0]['status'].is_a? Integer).to eq true
            expect(body['errors'][0]['title'].is_a? String).to eq true
            expect(body['errors'][0]['message'].is_a? String).to eq true
            expect(body['errors'][0]['code'].is_a? Integer).to eq true

            # проверяем типы данных во второй ошибке
            expect(body['errors'][1]['status'].is_a? Integer).to eq true
            expect(body['errors'][1]['title'].is_a? String).to eq true
            expect(body['errors'][1]['message'].is_a? String).to eq true
            expect(body['errors'][1]['code'].is_a? Integer).to eq true
        end
    end
end