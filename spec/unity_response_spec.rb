require 'rack'
require './lib/unity_response'

describe UnityResponse do

  let(:response) do
    {
      status: 422,
      headers: {
        'Content-Type'  => 'application/json',
        'X-Some-Header' => 'this header is very important',
      },
      body: [JSON.dump({ 'foo' => 'bar' })],
    }
  end

  let(:middleware) do
    UnityResponse.new proc { response.values }
  end

  let(:env) do
    Rack::MockRequest.env_for.tap do |e|
      e[UnityResponse::HEADER] = '1'
    end
  end

  it 'should wrap the status, headers and body in a json object' do
    status, headers, body = middleware.call(env)
    expect(status).to eq 200
    expect(headers).to eq({ 'Content-Type' => 'application/json' })
    expect(JSON.parse(body.reduce(:+))).to eq({
      'status'  => response[:status],
      'headers' => response[:headers],
      'body'    => JSON.parse(response[:body].reduce(:+)),
    })
  end

  it 'should wrap non-json responses' do
    response[:headers]['Content-Type'] = 'text/plain'
    response[:body] = ['testing']
    status, headers, body = middleware.call(env)
    expect(status).to eq 200
    expect(headers).to eq({ 'Content-Type' => 'application/json' })
    expect(JSON.parse(body.reduce(:+))).to eq({
      'status'  => response[:status],
      'headers' => response[:headers],
      'body'    => response[:body].reduce(:+),
    })
  end

  it 'should not wrap the response if the request header is not given' do
    env.delete(UnityResponse::HEADER)
    expect(middleware.call(env)).to eq response.values
  end

  it 'should not wrap the response if the request header is set to false' do
    ['false', '0'].each do |val|
      env[UnityResponse::HEADER] = val
      expect(middleware.call(env)).to eq response.values
    end
  end

end
