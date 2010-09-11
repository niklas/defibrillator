require 'digest/md5'

class Author < Struct.new(:line)

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
    "http://www.gravatar.com/avatar/#{gravarar_hash}.png"
  end

  protected
  def gravarar_hash
    Digest::MD5.hexdigest(email.downcase)
  end
  
end