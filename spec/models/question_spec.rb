require 'rails_helper'

RSpec.describe Question, type: :model do
  subject! { create(:question) }
  let(:another_question) { create(:question) }

  let!(:answer_1) { create(:answer, question: subject) }
  let!(:answer_2) { create(:answer, question: subject) }
  let!(:answer_3) { create(:answer, question: another_question) }

  it { should have_many( :answers).dependent(:destroy)}

  it { should validate_presence_of :title }
  it { should validate_uniqueness_of :title }
  it { should validate_presence_of :body }

  it 'should set correctly best solution answer' do
    subject.best_solution_answer = answer_1

    expect(subject.best_solution_answer).to eq answer_1
    expect(answer_1.best_solution).to eq true

    subject.best_solution_answer = answer_2
    answer_1.reload

    expect(subject.best_solution_answer).to eq answer_2
    expect(answer_2.best_solution).to eq true
    expect(answer_1.best_solution).to eq false
  end

  it 'should not set as best_solution_answer answer from another question' do
    subject.best_solution_answer = answer_3
    expect(subject.best_solution_answer).to eq nil
  end
end
