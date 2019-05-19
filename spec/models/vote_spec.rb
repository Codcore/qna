require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:author).class_name('User').with_foreign_key('user_id') }
  it { should belong_to(:votable) }

  it { should define_enum_for(:vote).
          with_values(down: -1, up: 1).
          backed_by_column_of_type(:integer).
          with_suffix
  }

  it { should validate_presence_of :vote }
end
