require 'spec_helper'
require 'rack/lint'

describe UTF8Gatekeeper::Middleware do
  subject { described_class.new(app) }

  class FakeApp
    def call(env)
      [200, { 'Content-Type' => 'text/plain' }, [env['rack.input'].read]]
    end
  end

  let(:app) { FakeApp.new }

  let(:env) do
    {
      'PATH_INFO' => path_info,
      'QUERY_STRING' => query_string,
      'HTTP_REFERER' => http_referer,
      'HTTP_COOKIE' => http_cookie,
      'REQUEST_URI' => request_uri,
      'rack.input' => Rack::Lint::InputWrapper.new(StringIO.new(rack_input)),
      'CONTENT_TYPE' => content_type,
    }
  end

  let(:content_type) { 'application/x-www-form-urlencoded' }

  let(:path_info)    { 'foo/bar_baz' }
  let(:query_string) { 'foo=bar' }
  let(:http_cookie)  { 'foo=bar:watsit=whatever' }
  let(:http_referer) { 'http://example.com/blog' }
  let(:request_uri)  { 'foo-bar-whatever' }
  let(:rack_input)   { 'foo-foo-foo' }

  context 'with clean data' do
    it 'calls the app' do
      expect(subject.call(env)).to eq(
        [
          200,
          { 'Content-Type' => 'text/plain' },
          ['foo-foo-foo'],
        ],
      )
    end
  end

  context 'with garbage' do
    let(:garbage) { (100..1000).to_a.pack('c*').force_encoding('utf-8') }

    shared_examples 'error' do
      it 'returns a 400' do
        expect(subject.call(env).first).to eq 400
      end

      it 'sets content type header to text/plain' do
        expect(subject.call(env)[1]['Content-Type']).to eq 'text/plain'
      end

      it 'returns some useful body text' do
        expect(subject.call(env).last).to eq ['Sorry, you need to use valid UTF8 if you want this to work']
      end
    end

    context 'in PATH_INFO' do
      let(:path_info) { garbage }
      it_behaves_like 'error'
    end

    context 'in QUERY_STRING' do
      let(:query_string) { garbage }
      it_behaves_like 'error'
    end

    context 'in HTTP_REFERER' do
      let(:http_referer) { garbage }
      it_behaves_like 'error'
    end

    context 'in REQUEST_URI' do
      let(:request_uri) { garbage }
      it_behaves_like 'error'
    end

    context 'in HTTP_COOKIE' do
      let(:http_cookie) { garbage }
      it_behaves_like 'error'
    end

    context 'in rack.input' do
      let(:rack_input) { garbage }

      context 'when the CONTENT_TYPE is application/x-www-form-urlencoded' do
        it_behaves_like 'error'
      end

      context 'when the CONTENT_TYPE is multipart/form-data' do
        let(:content_type) { 'multipart/form-data' }

        it 'calls the app' do
          expect(subject.call(env)).to eq(
            [
              200,
              { 'Content-Type' => 'text/plain' },
              [garbage],
            ],
          )
        end
      end

      context 'when the CONTENT_TYPE is some/unknown-content-type' do
        let(:content_type) { 'some/unknown-content-type' }

        it 'calls the app' do
          expect(subject.call(env)).to eq(
            [
              200,
              { 'Content-Type' => 'text/plain' },
              [garbage],
            ],
          )
        end
      end
    end
  end
end
