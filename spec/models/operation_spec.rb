# == Schema Information
#
# Table name: operations
#
#  id             :bigint           not null, primary key
#  balance        :decimal(, )      default(0.0)
#  name           :string           not null
#  op_type        :integer          default(1)
#  operation_date :datetime
#  total          :decimal(, )      default(0.0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint
#
# Indexes
#
#  index_operations_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Operation, type: :model do
  context 'test operation validates' do
    it 'test name validates' do
      expect(Operation.new).to_not be_valid
    end
  end

  context "test balance_before with INCOME and EXPENDITURE operations" do
    it "get balance_before from INCOME operation" do
      operation = Operation.new(
        name: 'Зачисление зарплаты',
        op_type: Operation::INCOME,
        operation_date: DateTime.now,
        total: 2000.0,
        balance: 4000.0
      )
      expect(operation.balance_before).to eq 2000
    end

    it "get balance_before from EXPENDITURE operation" do
      operation = Operation.new(
        name: 'Покупка бензина АИ-92',
        op_type: Operation::EXPENDITURE,
        operation_date: DateTime.now,
        total: 2000.0,
        balance: 1000.0
      )
      expect(operation.balance_before).to eq 3000
    end
  end

  context "test after_create callbacks" do
    it 'test change_user_balance callback' do
      user = User.create(
        name: 'Тестовый Тест Тестович',
        balance: 1000.0
      )

      operation = Operation.create(
        name: 'Покупка продуктов',
        op_type: Operation::EXPENDITURE,
        operation_date: DateTime.now,
        total: 500.0,
        user: user
      )

      expect(user.balance).to eq 500.0
    end
  end

  context 'test before_create callbacks' do
    it 'test calc_user_balance with INCOME operation' do
      user = User.create(
        name: 'Тестовый Тест Тестович',
        balance: 1000.0
      )

      operation = Operation.create(
        name: 'Денежный перевод',
        op_type: Operation::INCOME,
        operation_date: DateTime.now,
        total: 500.0,
        user: user
      )

      expect(operation.balance).to eq 1500.0
    end

    it 'test calc_user_balance with EXPENDITURE operation' do
      user = User.create(
        name: 'Тестовый Тест Тестович',
        balance: 1000.0
      )

      operation = Operation.create(
        name: 'Покупка в магазине',
        op_type: Operation::EXPENDITURE,
        operation_date: DateTime.now,
        total: 500.0,
        user: user
      )

      expect(operation.balance).to eq 500.0
    end

    it 'test calc_user_balance with EXPENDITURE operation but raise Exception' do
      user = User.create(
        name: 'Тестовый Тест Тестович',
        balance: 1000.0
      )

      expect {
        operation = Operation.create(
          name: 'Покупка в магазине',
          op_type: Operation::EXPENDITURE,
          operation_date: DateTime.now,
          total: 1500.0,
          user: user
        )
      }.to raise_error { |error| 
        expect(error).to be_a(BalanceHandler::BalanceIsLessThanZeroException)
        expect(error.message).to eq 'Недостаточно средств.'
        expect(error.code).to eq 101
      }
    end
  end
end
