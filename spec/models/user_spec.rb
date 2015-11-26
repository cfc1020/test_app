# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  username               :string(255)      not null
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  authentication_token   :string(255)      not null
#

require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryGirl.create(:user)
  end

  subject { @user }

  describe 'save user' do
    it 'create and save valid user' do
      @user.save!
    end
  end

  describe 'user validation' do
    it { should be_valid }

    it { should validate_length_of(:username).
         is_at_least(5).
         is_at_most(255) }
    it { should validate_length_of(:email).
         is_at_least(5).
         is_at_most(255) }

    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:email) }


    it 'validates email address' do
      should_not allow_value("qwerty@mail").for(:email)
      should_not allow_value("qwerty@.com").for(:email)
      should_not allow_value("@dsaads.com").for(:email)
    end
  end

  describe 'user asscociation' do
    it { should have_many(:reports) }
  end
end
