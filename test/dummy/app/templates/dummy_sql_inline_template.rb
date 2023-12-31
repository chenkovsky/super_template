
class DummySqlInlineTemplate < SuperTemplate::Base
  def initialize(limit: 10)
    @limit = limit
  end
  attr_reader :limit
  template :erb, <<~ERB
    SELECT * FROM <%= limit %>
  ERB
end
