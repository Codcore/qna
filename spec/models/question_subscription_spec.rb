require 'rails_helper'

RSpec.describe QuestionSubscription do
  it { should belong_to(:question) }
  it { should belong_to(:user) }
end