require 'rails_helper'

RSpec.describe Commentary, type: :model do
  it { should belong_to(:author).class_name('User').with_foreign_key('user_id')}
  it { should belong_to :commentable }
  it { should validate_presence_of :body }
  it { should validate_length_of :body }
end
