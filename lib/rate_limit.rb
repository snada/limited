module RateLimit
  def self.check_rate(limit, expiration, identifier, scope)
    key = "#{identifier}/#{scope}"
    now = Time.now.to_i

    entry = Rails.cache.fetch(key, expires_in: expiration) do
      { requests: 0, created_at: now }
    end

    time = (entry[:created_at] + expiration.to_i) - now

    if entry[:requests] > limit
      { expired: true, time: time }
    else
      Rails.cache.write(
        key,
        entry.merge({ requests: entry[:requests] + 1 }),
        { expires_in: time }
      )
      { expired: false, time: time }
    end
  end
end
