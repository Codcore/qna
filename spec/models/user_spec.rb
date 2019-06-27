require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, author: user) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many :rewards }
  it { should have_many :votes }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscribed_questions).through(:question_subscriptions) }
  it { should have_many(:question_subscriptions) }

  it 'should determine if user is an author of resource' do
    expect(user.authorized_for?(question)).to eq true
  end

  it 'should determine if user is not author of the resource' do
    expect(another_user.authorized_for?(question)).to eq false
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456')}
    let(:service) { double('Services::FindForOAuth') }

    it 'calls Services::FindForOauth' do
      expect(Services::FindForOAuth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
