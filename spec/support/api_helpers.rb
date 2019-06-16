module ApiHelpers
  def json
    @json = JSON.parse(response.body)
  end

  def do_request(method, path, options ={})
    options[:headers] = {} if method == :post || :patch || :delete
    send method, path, options
  end
end