class BookAlreadyExists < StandardError
  def initialize(msg)
    super(msg)
  end
end