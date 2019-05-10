require 'rails_helper'

RSpec.describe Link, type: :model do

  let(:gist_link) { Link.new(url: 'https://gist.github.com/averyvery/6e4576023b395de1aaf5') }
  let(:non_gist_link) { Link.new(url: 'https://google.com') }
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  it { should allow_value('http://google.com').for(:url) }
  it { should_not allow_value('google_com').for(:url) }

  it '#gist? should return true if url is url of GitHub Gist' do
    expect(gist_link).to be_gist
  end

  it '#gist? should return false if url is not url of GitHub Gist' do
    expect(non_gist_link).not_to be_gist
  end

  it '#gist_id should return GitHub Gist id if link url contains it' do
    expect(gist_link.gist_id).to eq('6e4576023b395de1aaf5')
  end

  it '#gist_id should return nil if link url does not contains GitHub Gist' do
    expect(non_gist_link.gist_id).to be_nil
  end
end
