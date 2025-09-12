class BookIsUnavailable < StandardError
  def initialize(msg)
    super(msg)
  end
end