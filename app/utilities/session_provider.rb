class SessionProvider
  def self.session=(hash)
    @hash = hash 
  end

  def self.session
    @hash || {}
  end

  def self.with_session(hash)
    self.session = hash
    yield 
  ensure
    self.session = {}
  end
end