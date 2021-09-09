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
end