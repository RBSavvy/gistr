class Gist
  # gists:latest_timestamp      => latest_timestamp


  def self.latest_timestamp
    time = REDIS.get(redis_key(:latest_timestamp))
    time.to_time.utc if time.present?
  end

  def self.latest_timestamp= time
    raise ArgumentError, "Time must respond to utc" unless time.respond_to? :utc
    if latest_timestamp().nil? || time > latest_timestamp()
      REDIS.set redis_key(:latest_timestamp), time.utc.to_s
    end
  end

  def self.create_from_github hash
    # Remove from all language sets
    Language.remove_gist_id hash[:id]

    # Add gist to language sets
    REDIS.pipelined do
      Hash(hash[:files]).each do |filename, data|
        if data[:language].present?
          language = Language.build(data[:language])
          language.add_gist_id hash[:id]
        end
      end
    end

    # update latest timestamp
    self.latest_timestamp = Time.parse(hash[:updated_at])
    true
  end


  private

  def self.redis_key(key)
    "gists:#{key}"
  end

end