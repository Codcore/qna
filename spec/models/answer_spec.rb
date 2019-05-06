require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:question) { create(:question) }
  let(:subject) { create(:answer, question: question) }
  let(:another_answer) { create(:answer, question: question) }


  it { should belong_to(:question) }

  it { should validate_presence_of :body }

  it '#best_solution! should set correctly answer as a best solution' do
    subject.best_solution!

    expect(subject).to be_best_solution
  end

  it '#best_solution! should set correctly as a best solution only one answer of question' do
    subject.best_solution!
    expect(another_answer).to_not be_best_solution
  end

  it '#best_solution! should re-set correctly another answer as a best solution' do
    subject.best_solution!
    another_answer.best_solution!
    another_answer.reload

    expect(another_answer).to be_best_solution
  end

  it '#best_solution! should set previous best solution answer as a non-best solution' do
    subject.best_solution!
    another_answer.best_solution!
    subject.reload

    expect(subject).to_not be_best_solution
  end
end
