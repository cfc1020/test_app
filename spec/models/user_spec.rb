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

  describe 'create user' do
    it 'create valid user' do
      @user.save!
    end
  end

  describe 'user validations' do
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

    it 'should add authentication_token when validated' do
      user = FactoryGirl.create(:user)
      user.valid?
      expect(user.authentication_token).to be_present
    end
  end

  it { should respond_to(:username) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:ensure_authentication_token) }

  describe 'user asscociations' do
    it { should have_many(:reports) }
  end

  describe "when email address or username is already taken" do
    before { @user.save }
    before(:each) { @user2 = FactoryGirl.create(:user) }
    subject { @user2 }

    describe "with same email" do
      before { @user2.email = @user.email }

      it { should be_invalid }

      it 'case sensitive' do
        @user2.email.swapcase!

        should be_invalid
      end
    end

    describe "with same username" do
      before { @user2.username = @user.username }

      it { should be_invalid }

      it 'case sensitive' do
        subject.username.swapcase!

        should be_invalid
      end
    end
  end
end
