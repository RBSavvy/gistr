class Gist



  def self.latest_timestamp
    REDIS.get(redis_key(:latest_timestamp)).to_time.utc
  end

  def self.latest_timestamp= time
    raise ArgumentError, "Time must respond to utc" unless time.respond_to? :utc
    REDIS.set redis_key(:latest_timestamp), time.utc.to_s
  end

  private
  def self.redis_key(key)
    "gist:#{key}"
  end

end