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
require 'rails_helper'

RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
