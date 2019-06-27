require 'rails_helper'

RSpec.describe NewAnswerNotifyJob, type: :job do
  let(:service) { double 'Service::NewAnswerNotify' }
  let(:answer) { create(:answer) }

  before do
    allow(Services::NewAnswerNotify).to receive(:new).and_return(service)
  end

  it 'calls Service::NewAnswerNotify#send_notify' do
    expect(service).to receive(:send_notify)
    NewAnswerNotifyJob.perform_now(answer, answer.question.author)
  end
end
