require 'rails_helper'

shared_examples_for 'votable' do
  let(:model)   { described_class }
  let!(:subject) { create(model.to_s.underscore.to_sym) }
  let!(:author)    { create(:user) }

  describe "#up_vote!" do
    it 'should increase score if it is first vote for subject' do
      expect {  subject.up_vote!(author) }.to change(subject, :score).by(1)
    end

    it 'should not increase score if user votes up second time same subject' do
      subject.up_vote!(author)
      expect {  subject.up_vote!(author) }.not_to change(subject, :score)
    end

    it 'should reset vote if user votes up after user voted down same subject' do
      subject.down_vote!(author)

      expect { subject.up_vote!(author) }.to change(subject.votes, :count ).by(-1)
    end
  end

  describe "#down_vote!" do
    it 'should increase score' do
      expect {  subject.down_vote!(author) }.to change(subject, :score).by(-1)
    end

    it 'should not increase score if user votes up second time same subject' do
      subject.down_vote!(author)
      expect {  subject.down_vote!(author) }.not_to change(subject, :score)
    end

    it 'should reset vote if user votes down after user voted up same subject' do
      subject.up_vote!(author)

      expect { subject.down_vote!(author) }.to change(subject.votes, :count ).by(-1)
    end
  end
end