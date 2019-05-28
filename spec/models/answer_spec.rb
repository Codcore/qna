require 'rails_helper'

RSpec.describe Answer, type: :model do
  let!(:author)   { create(:user) }
  let!(:question) { create(:question, author: author) }
  let!(:reward)   { create(:reward, question: question) }
  let!(:author_answer)  { create(:answer, question: question, author: author) }
  let(:another_answer) { create(:answer, question: question) }

  it { should belong_to(:question) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:commentaries).dependent(:destroy) }

  it { should accept_nested_attributes_for :links }

  it { should validate_presence_of :body }

  it 'should have many attached files' do
    expect(Answer.new.files).to be_an_instance_of ActiveStorage::Attached::Many
  end

  context '#best_solution!' do

    it 'should set correctly answer as a best solution' do
      author_answer.best_solution!

      expect(author_answer).to be_best_solution
    end

    it 'should set correctly as a best solution only one answer of question' do
      author_answer.best_solution!
      expect(another_answer).to_not be_best_solution
    end

    it 'should re-set correctly another answer as a best solution' do
      author_answer.best_solution!
      another_answer.best_solution!
      another_answer.reload

      expect(another_answer).to be_best_solution
    end

    it 'should set previous best solution answer as a non-best solution' do
      author_answer.best_solution!
      another_answer.best_solution!
      author_answer.reload

      expect(author_answer).to_not be_best_solution
    end

    it 'should set reward for author if reward is present for question' do
      author_answer.best_solution!
      author.reload
      expect(author.rewards.first).to eq reward
    end
  end

  it_behaves_like 'votable'
end
