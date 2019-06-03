require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'Guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Commentary }

    it { should_not be_able_to :manage, :all }
  end

  describe 'Admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'User' do
    let(:user) { create :user }
    let(:another_user) { create :user }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Commentary }

    it { should be_able_to :update, create(:question, author: user) }
    it { should_not be_able_to :update, create(:question, author: another_user) }

    it { should be_able_to :update, create(:answer, author: user) }
    it { should_not be_able_to :update, create(:answer, author: another_user) }

    it { should be_able_to :destroy, create(:answer, author: user) }
    it { should_not be_able_to :destroy, create(:answer, author: another_user) }

    it { should be_able_to :destroy, create(:question, author: user) }
    it { should_not be_able_to :destroy, create(:question, author: another_user) }

    it { should be_able_to :destroy, create(:commentary, author: user) }
    it { should_not be_able_to :destroy, create(:commentary, author: another_user) }

    it { should be_able_to :best_solution, create(:answer, question: create(:question, author: user)) }
    it { should_not be_able_to :best_solution, create(:answer) }

    it { should be_able_to :up_vote, create(:question) }
    it { should be_able_to :up_vote, create(:answer) }

    it { should be_able_to :down_vote, create(:question) }
    it { should be_able_to :down_vote, create(:answer) }
  end
end