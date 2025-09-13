require 'csv'
require 'rdoc'
require_relative 'error/field_does_not_exist'
require_relative 'error/book_does_not_exist'
require_relative 'error/book_already_exists'
require_relative 'error/book_is_unavailable'
require_relative 'book'

# Manager class for interfacing with the Book class.
# @!attribute csv_file specifies the path of the csv file to read from and store to.
# @!attribute book_list stores the list of books read from the csv file.
#
# Usage:
#   BookManager.set_csv "file.csv"
#   BookManager.borrow "4980"
#   BookManager.delete_book "4980"
class BookManager
  @@csv_file = ""

  # Sets the location (relative) of the csv file to be used by the manager class.
  # @!attribute csv_file specifies the path of the csv file to read from and store to.
  #
  # Usage:
  #   BookManager.set_csv "file.csv"
  #   BookManager.set_csv "res/file.csv"
  def self.set_csv(csv_file_path)
    if File.file?(csv_file_path)
      @@csv_file = csv_file_path
      @@book_list = update_temp_store
    else
      raise Errno::ENOENT
    end
  end

  #returns the @@book_list variable
  def self.get_list
    @@book_list
  end

  # @private method used to update the book_list array based on the csv_file attribute.
  private
  def self.update_temp_store
      book_list = []

      CSV.foreach(@@csv_file, headers: true) do |row|
        book_list.push(Book.new(row["book_id"], row["title"], row["author"], row["availability"]))
      end

      book_list
  end

  # @private method used to save the contents of the book_list array to the csv_file attribute.
  private
  def self.save_to_csv
    CSV.open(@@csv_file, "wb") do |csv|

      csv << ["book_id", "title", "author", "availability"]

      @@book_list.each do |book|
        csv << [book.book_id, book.title, book.author, book.availability]
      end
    end
  end

  # Puts (prints) the content of the book_list array which contains the list of the books read from the csv file.
  def self.get_book_list

    @@book_list.each do |book|
      puts book.to_s
    end
  end

  # Borrows a book.
  # @param book_id specifies the id of the book to be borrowed.
  # @raise BookIsUnavailable if the book is unavailable.
  #
  # Usage:
  #   BookManager.borrow "1"
  def self.borrow(book_id)
    book = BookManager.find_book(book_id)
    if book.availability == "available"
      book.availability = "unavailable"
      save_to_csv
    else
      raise BookIsUnavailable.new("Book is currently being borrowed!")
    end
  end

  # Returns a book that has been borrowed.
  # @param book_id specifies the id of the book to be returned.
  # @raise BookIsUnavailable if the book is still available.
  #
  # Usage:
  #   BookManager.return "1"
  def self.return(book_id)
    book = BookManager.find_book(book_id)
    if book.availability == "unavailable"
      book.availability = "available"
      save_to_csv
    else
      raise BookIsUnavailable.new("Book is not currently being borrowed!")
    end
  end

  # Adds a book to the system.
  # @param book_id specifies the id of the book.
  # @param title specifies the title of the book.
  # @param author specifies the author of the book.
  # @param availability specifies the availability of the book. "available" indicates that the book is not being borrowed while "unavailable" indicates that the book is being borrowed.
  # @raise BookAlreadyExists if a book with the same id already exists.
  #
  # Usage:
  #   BookManager.add_book "1","Book 1","Author 1","unavailable"
  def self.add_book(book_id, title, author, availability)
    begin
      BookManager.find_book(book_id)
      raise BookAlreadyExists.new("Book with id already exists!")
    rescue BookDoesNotExist => e
      @@book_list << Book.new(book_id, title, author, availability)
      save_to_csv
    end
  end

  # Finds a book based on the provided id.
  # @param book_id specifies the id of the book to be returned.
  # @raise BookDoesNotExist if the book that is being located does not exist.
  #
  # Usage:
  #   BookManager.find_book "1"
  def self.find_book(book_id)
    @@book_list.each do |book|
      if book.book_id == book_id
        return book
      end
    end

    raise BookDoesNotExist.new("Cannot find the specified book!")
  end

  # Finds a book or list of books on the provided title.
  # @param title specifies the title of the book to be located.
  #
  # Usage:
  #   BookManager.find_books_by_title "Book 1"
  def self.find_books_by_title(title)

    book_list = []

    @@book_list.each do |book|
      if book.title == title
        book_list << book
      end
    end

    book_list
  end

  # Finds a book or list of books based on the provided author.
  # @param author specifies the author of the book to be located.
  #
  # Usage:
  #   BookManager.find_books_by_author "Book 1"
  def self.find_books_by_author(author)

    book_list = []

    @@book_list.each do |book|
      if book.author == author
        book_list << book
      end
    end

    book_list
  end

  # Deletes a book based on the provided id.
  # @param book_id specifies the id of the book to be returned.
  # @raise BookDoesNotExist if the book that is being located does not exist.
  #
  # Usage:
  #   BookManager.remove "1"
  def self.remove_book(book_id)
    @@book_list.delete(find_book(book_id))
    save_to_csv
  end

  # Updates the specified field of a book.
  # @param book_id specifies the id of the book.
  # @param field_name specifies the field of the book to be edited.
  # @param updated_value specifies new value of the field.
  # @raise BookDoesNotExist if the book does not exist.
  # @raise FieldDoesNotExist if the specified field does not exist.
  #
  # Usage:
  #   BookManager.update_book "1","title","Book 2"
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