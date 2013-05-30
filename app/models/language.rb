class Language

  def self.find name
    self.new("languages:language:#{name}")
  end

  def self.all
    keys = REDIS.keys 'languages:language:*'
    keys.map {|k| self.new(key) }
  end



  def initialize(key)
    @key = key
  end

  def gists
    members.map do |id|
      Gist.find(id)
    end
  end

  def random_gist
    Gist.find(REDIS.srandmember @key)
  end

  def members
    REDIS.smembers @key
  end

  def add gist
    raise InvalidGist, "Gist id is invalid" if gist.id.empty?
    REDIS.sadd(@key, gist.id)
  end
  alias_method :<<, :add


end
