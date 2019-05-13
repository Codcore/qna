require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should validate_presence_of :name }
  it { should belong_to :question }
  it { should belong_to(:user).optional }

  it 'should have one attached image' do
    expect(Reward.new.image).to be_an_instance_of ActiveStorage::Attached::One
  end

  it 'should validate attached image' do
    expect(Reward.new(name: 'Reward without image')).not_to be_valid
  end
end
