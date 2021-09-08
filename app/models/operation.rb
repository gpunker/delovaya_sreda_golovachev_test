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
class Operation < ApplicationRecord
    # Доходы
    INCOME = 1
    # Расходы
    EXPENDITURE = 2

    validates :name, presence: true

    belongs_to :user

    before_create :calc_user_balance
    after_create :change_user_balance

    # Изменение баланса пользователя, в зависимости от типа операции (дохода/расхода)
    #
    # @return [User] объект пользователя с измененным балансом
    def change_user_balance
        if op_type == INCOME
            user.balance = user.balance + total
        else
            user.balance = user.balance - total
        end
        user.save!
    end

    # Изменение расчет баланса пользователя на момент операции (дохода/расхода)
    #
    # @return nil
    def calc_user_balance
        if op_type == INCOME
            self.balance = user.balance + total
        else
            self.balance = user.balance - total
        end

        # предусмотреть вывод исключения если у пользователя не хватает средств
        raise BalanceHandler::BalanceIsLessThanZeroException if self.balance < 0.0
    end
end
