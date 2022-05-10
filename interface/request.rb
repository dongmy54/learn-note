require 'active_support'
require 'active_support/core_ext'
require 'rest-client'
require 'json'
require 'logger'


class BaseClient
  def initialize(**opts)
    opts = opts.with_indifferent_access
    raise 'base url must be defined' unless opts[:base_url]
    @options = {}
    @options[:base_url] = opts[:base_url]
    @options[:headers] = opts[:headers] || {'Content-Type' => 'application/json'}
    @options[:cookies] = opts[:cookies] || {}
    @options[:verify_ssl] = opts[:verify_ssl] || false
    @options[:timeout] = opts[:timeout] || 10
  end

  def request_url(path)
    "#{@options[:base_url]}/#{path}"
  end

  def request_params(method, path, params={}, options={})
    options = options.with_indifferent_access

    request_params = {
      method: method,
      url: request_url(path),
      cookies: @options[:cookies].merge(options[:cookies] || {}),
      verify_ssl: options[:verify_ssl] || @options[:verify_ssl],
      timeout: options[:timeout] || @options[:timeout],
    }

    if method.to_s == "get"
      request_params[:headers] = {params: params}
    else
      request_params[:headers] = @options[:headers].merge(options[:headers] || {})
      request_params[:payload] = params.to_json
    end
    request_params
  end

  def _http(method, path, params, options={})
    req_params = request_params(method, path, params, options={})
    print_req_info(req_params)
    begin
      res = RestClient::Request.execute(req_params)
      print_response(res)
    rescue RestClient::ExceptionWithResponse => e
      print_exception(e)
    rescue  RestClient::RequestTimeout => err
      print_exception(e)
    end
  end

  def print_req_info(req_params)
    "请求：#{req_params}"
  end

  # 响应信息
  def print_response(res)
    puts <<-EOF
    响应: ==========================================
      code: #{res.code}
      body: #{res.body}
    EOF
  end

  def print_exception(err)
    if err&.response
      print_response(err.response)
    end
    puts <<-EOF
    异常信息: ==========================================
      message: #{err.full_message}
      backtrace: #{err.backtrace.join("\n")}
    EOF
  end
end


client = BaseClient.new(base_url: "http://localhost:3000")
client._http(:get, '', {})


