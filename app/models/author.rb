require 'digest/md5'

class Author < Struct.new(:line)

  extend ActiveSupport::Memoizable

  EmailExp = %r~\A([^<]+)<([^>]+)>\z~

  def matches?
    line.match EmailExp
  end

  alias_method :has_email?, :matches?
  alias_method :has_name?, :matches?

  def email
    if m = matches?
      m[2].strip
    end
  end

  def name
    if m = matches?
      m[1].strip
    end
  end

  def gravatar_url
    "http://www.gravatar.com/avatar/#{gravarar_hash}.png?r=#{gravatar_rating}"
  end

  def rating
    self.class.gravatar_rating
  end

  def health
    (100.0 * ProjectUpdate.by_author(line).ok.count / 
             ProjectUpdate.by_author(line).results.count
    ).to_i
  rescue FloatDomainError
    0
  end

  memoize :health

  cattr_accessor :gravatar_rating
  self.gravatar_rating = 'x'

  protected
  def gravarar_hash
    Digest::MD5.hexdigest(email.downcase)
  end
  
end
