class Language
  NAMESPACE = 'languages:language'
  class NoLanguage < ActiveRecord::RecordNotFound; end

  attr_reader :key

  def self.all
    REDIS.keys(redis_key('*')).map do |lang|
      Language.new(lang)
    end
  end

  def self.find name
    key = REDIS.keys(redis_key(name)).first
    raise NoLanguage, "Language with #{name} not found" unless key.present?
    Language.new(key)
  end

  def self.remove_gist_id(id)
    self.all.each { |lang|
      REDIS.pipelined do
        lang.remove_gist_id(id)
      end
    }
    true
  end

  def self.build name
    Language.new redis_key(name)
  end

  def initialize(key)
    raise ArgumentError, "Language key must match languages:language:*" unless key.match(/^languages\:language\:\w+.*$/)
    @key = key
  end

  def name
    @name ||= self.key.split(':').last
  end

  def gist_ids
    REDIS.smembers(self.key).map &:to_i
  end

  def random_gist_id
    REDIS.srandmember(self.key).to_i
  end

  def add_gist_id(id)
    REDIS.sadd(self.key, id)
    true
  end

  def remove_gist_id(id)
    REDIS.srem(self.key, id)
    true
  end

  def gist_count
    REDIS.scard self.key
  end

  private
  def self.redis_key(name)
    "#{NAMESPACE}:#{name}"
  end
end
