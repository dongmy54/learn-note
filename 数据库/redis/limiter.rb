require 'redis'

class RequestLimiter
  def initialize(max_requests: 20, period: 600)
    @max_requests = max_requests
    @period = period # 默认十分钟20个请求
  end

  # 限制最近period秒内请求次数
  def limit_requests_per_period(key)
    current_time = Time.current.to_f
    lua_script = <<-LUA
      local key = KEYS[1]
      local current_time = tonumber(ARGV[1])
      local period = tonumber(ARGV[2])
      local max_requests = tonumber(ARGV[3])
      redis.call('zremrangebyscore', key, 0, current_time - period)
      local count = redis.call('zcard', key)
      if count < max_requests then
        redis.call('zadd', key, current_time, current_time)
        redis.call('expire', key, period)
        return 1
      else
        return 0
      end
    LUA

    result = $redis.eval(lua_script, keys: [key], argv: [current_time, @period, @max_requests])
    result == 1
  end

  # 限制在period秒内只能有一次请求
  def ensure_single_request_within_period(key, timeout)
    # 确保在指定的timeout内，只能有一次成功请求
    !!$redis.set(key, 1, nx: true, ex: timeout)
  end
end


limiter = RequestLimiter.new(max_requests: 20, period: 600)

period_key = "Reservation_#{current_user.id}_limit_requests_per_period"
limiter.limit_requests_per_period(period_key) # 返回true可以执行




