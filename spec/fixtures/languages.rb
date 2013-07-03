LANGUAGE_FIXTURES ||= {
  'Ruby'   => [1, 2, 3],
  'Python' => [2, 3, 4],
  'Text'   => [1, 2, 3, 4, 5],
  'C/C++'  => [3, 4, 5, 6]
}

REDIS.multi do
  LANGUAGE_FIXTURES.each do |lang, ids|
    REDIS.sadd "languages:language:#{lang}", ids
  end
end

# REDIS.keys("languages:language:*").each do |lang|
#   puts  "#{lang} => #{REDIS.smembers(lang).inspect}"
# end