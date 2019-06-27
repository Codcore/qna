require 'rails_helper'

RSpec.describe Services::NewAnswerNotify do
  let!(:author) { create(:user) }
  let!(:question) { create(:question, author: author) }
  let!(:answer) { create(:answer, question: question) }

  it "sends notify to answer's question user" do
    expect(NewAnswerNotifyMailer).to receive(:notify_email).with(answer).and_call_original
    subject.send_notify(answer)
  end
end