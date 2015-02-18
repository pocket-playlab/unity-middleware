require 'json'

# Unity's built-in http library does not return response headers or status
# code. If the `X-Unity-Response` header is set, this middleware wraps the
# response status code, headers and body inside a json object in the response
# body. It also sets the response status code to 200, as unity cannot handle
# non-200 responses properly.
class UnityResponse

  HEADER = 'HTTP_X_UNITY_RESPONSE'.freeze

  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, response = @app.call(env)
    return [status, headers, response] unless bool env[HEADER]

    body = response.to_enum.reduce(:+)
    unless headers.fetch('Content-Type', '').start_with?('application/json')
      body = JSON.dump body
    end

    response = [%Q({"status":#{status},"headers":#{JSON.dump(headers)},"body":#{body}})]
    return [200, { 'Content-Type' => 'application/json' }, response]
  end

  private

  def bool(string)
    string && string =~ /^(true|1)$/i
  end

end
