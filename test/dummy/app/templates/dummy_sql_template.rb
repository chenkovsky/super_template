class DummySqlTemplate < SuperTemplate::Base
  def initialize(limit: 10)
    @limit = limit
  end
  attr_reader :limit
end
