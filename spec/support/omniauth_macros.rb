module OmniauthMacros
  def mock_github_auth_hash
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
                                                                    'provider' => 'twitter',
                                                                    'uid' => '123545',
                                                                    'info' => { 'email' => 'mocked@email.com' }
                                                                })
  end

  def mock_google_auth_hash
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
                                                                    'provider' => 'google_oauth2',
                                                                    'uid' => '123545',
                                                                    'info' => { 'email' => 'mocked@email.com' }
                                                                })
  end
end