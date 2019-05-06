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

  it 'should have one attached file' do
    expect(Question.new.file).to be_an_instance_of ActiveStorage::Attached::One
  end
end
