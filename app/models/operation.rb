# == Schema Information
#
# Table name: operations
#
#  id             :bigint           not null, primary key
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
    validates :name, presence: true

    belongs_to :user
end
