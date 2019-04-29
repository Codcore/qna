require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, author: user) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it 'should determine if user is an author of resource' do
    expect(user.authorized_for?(question)).to eq true
    expect(another_user.authorized_for?(question)).to eq false
  end
end
