class Book

  attr_accessor :book_id, :availability, :title, :author

  def initialize(book_id, title, author, availability)
    @book_id = book_id
    @title = title
    @author = author
    @availability = availability
  end

  def to_s
    "=======================\n
Book ID: #{@book_id}\nTitle: #{@title}\nAuthor: #{@author}\nAvailability: #{@availability}\n
======================="
  end
end

