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
  context 'test validations' do
    it 'test name validation' do
      expect(User.new).to_not be_valid
    end
  end
end
