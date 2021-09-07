# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  balance    :decimal(, )      default(0.0)
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class User < ApplicationRecord
    validates :name, presence: true

    has_many :operations
end
