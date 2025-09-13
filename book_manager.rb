require 'csv'
require_relative 'error/field_does_not_exist'
require_relative 'error/book_does_not_exist'
require_relative 'error/book_already_exists'
require_relative 'error/book_is_unavailable'
require_relative 'book'

class BookManager
  @@csv_file = ""

  #sets the csv file path
  def self.set_csv(csv_file_path)
    if File.file?(csv_file_path)
      @@csv_file = csv_file_path
      @@book_list = update_temp_store
    else
      raise Errno::ENOENT
    end
  end

  def self.update_temp_store
      book_list = []

      CSV.foreach(@@csv_file, headers: true) do |row|
        book_list.push(Book.new(row["book_id"], row["title"], row["author"], row["availability"]))
      end

      book_list
  end

  def self.save_to_csv
    CSV.open(@@csv_file, "wb") do |csv|

      csv << ["book_id", "title", "author", "availability"]

      @@book_list.each do |book|
        csv << [book.book_id, book.title, book.author, book.availability]
      end
    end
  end

  def self.get_book_list

    #Simple for loop
    #for book in @@book_list
    # puts book.id
    #end

    @@book_list.each do |book|
      puts book.to_s
    end
  end

  def self.borrow(book_id)
    book = BookManager.find_book(book_id)
    if book.availability == "available"
      book.availability = "unavailable"
      save_to_csv
    else
      raise BookIsUnavailable.new("Book is currently being borrowed!")
    end
  end

  def self.return(book_id)
    book = BookManager.find_book(book_id)
    if book.availability == "unavailable"
      book.availability = "available"
      save_to_csv
    else
      raise BookIsUnavailable.new("Book is not currently being borrowed!")
    end
  end

  def self.add_book(book_id, title, author, availability)
    begin
      BookManager.find_book(book_id)
      raise BookAlreadyExists.new("Book with id already exists!")
    rescue BookDoesNotExist => e
      @@book_list << Book.new(book_id, title, author, availability)
      save_to_csv
    end
  end

  def self.find_book(book_id)
    @@book_list.each do |book|
      if book.book_id == book_id
        return book
      end
    end

    raise BookDoesNotExist.new("Cannot find the specified book!")
  end

  def self.find_books_by_title(title)

    book_list = []

    @@book_list.each do |book|
      if book.title == title
        book_list << book
      end
    end

    book_list
  end

  def self.find_books_by_author(author)

    book_list = []

    @@book_list.each do |book|
      if book.author == author
        book_list << book
      end
    end

    book_list
  end

  def self.remove_book(book_id)
    @@book_list.delete(find_book(book_id))
    save_to_csv
  end

  def self.update_book(book_id, field_name, updated_value)
    book = find_book(book_id)

    case field_name.downcase
    when "id"
      book.book_id = updated_value
    when "title"
      book.title = updated_value
    when "author"
      book.author = updated_value
    when "availability"
      book.availability = updated_value
    else
      raise FieldDoesNotExist.new("Cannot find the specified field!")
    end
    save_to_csv
  end

end