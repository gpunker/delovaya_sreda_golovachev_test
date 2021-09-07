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
#
class Operation < ApplicationRecord
    validates :name, presence: true
end
