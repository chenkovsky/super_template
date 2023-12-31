
class TrimSqlInlineTemplate < SuperTemplate::Base
  def initialize(limit: 10)
    @limit = limit
  end
  strip_trailing_whitespace
  attr_reader :limit
  template :erb, <<~ERB
    SELECT * FROM <%= limit %>
  ERB
end
