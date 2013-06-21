class Gist
  # gists:latest_timestamp      => latest_timestamp
  # gists:language:#{lang_name} => Set of gist ids
  # gists:gist:#{id}            => hash of values ()

  ATTRIBUTES = [:id, :updated_at, :username, :gravatar_url, :html_url]


  def self.latest_timestamp
    time = REDIS.get(redis_key(:latest_timestamp))
    time.to_time.utc if time.present?
  end

  def self.latest_timestamp= time
    raise ArgumentError, "Time must respond to utc" unless time.respond_to? :utc
    if latest_timestamp.nil? || time > latest_timestamp
      REDIS.set redis_key(:latest_timestamp), time.utc.to_s
    end
  end

  def self.create_from_github hash
    # persist values
    gist              = Gist.find(hash[:id])
    gist.id           = hash[:id]
    gist.updated_at   = hash[:updated_at]
    gist.username     = hash[:owner][:login]        if hash[:owner].present?
    gist.gravatar_url = hash[:owner][:gravatar_url] if hash[:owner].present?
    gist.html_url     = hash[:html_url]


    # Remove from all language sets


    # Add gist to language sets
    hash[:file].try(:each) do |filename, data|
      Language.find(data[:language]).add gist
    end

    # update latest timestamp
    latest_timestamp = Time.parse(gist.updated_at)
  end

  def self.find id
    self.new redis_key("gist:#{id}")
  end

  def initialize key
    @key = key
  end

  def attributes
    @attributes ||= Hash[ATTRIBUTES.zip(REDIS.hmget(@key, ATTRIBUTES))]
  end

  ATTRIBUTES.each do |var|
    define_method(var) do
      attributes[var]
    end

    define_method("#{var}=") do |val|
      REDIS.hset(@key, var, val)
      attributes[var] = val
    end
  end


  private

  def self.redis_key(key)
    "gists:#{key}"
  end

end