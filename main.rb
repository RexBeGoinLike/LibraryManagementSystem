require_relative 'error/field_does_not_exist'
require_relative 'error/book_does_not_exist'
require_relative 'error/book_already_exists'
require_relative 'error/book_is_unavailable'
require_relative 'book'
require_relative 'book_manager'

begin
  BookManager.set_csv("res/books.csv")
  puts "============================================="
  puts "--- Welcome to Library Management System ---"
  puts "============================================="
rescue Errno::ENOENT
  puts "CSV file not found."
  exit
end

def display_menu
  puts "What do you want to do? "
  puts "1. List all books"
  puts "2. Borrow a book"
  puts "3. Return a book"
  puts "4. Add a book"
  puts "5. Remove a book"
  puts "6. Update book details"
  puts "7. Search by title"
  puts "8. Search by author"
  puts "9. Exit"
  puts "======================="
  print "Select a number: "
end

while true do
  display_menu
  choice = gets.chomp

  case choice
  when "1"
    puts "\nBook List:"
    BookManager.get_book_list

  when "2"
    print "Enter book ID to borrow: "
    id = gets.chomp
    begin
      BookManager.borrow(id)
      puts "Book borrowed successfully!"
    rescue BookDoesNotExist => e
      puts "Book not found: #{e.message}"
    rescue BookIsUnavailable => e
      puts "Book is unavailable: #{e.message}"
    rescue => e
      puts "Unexpected error: #{e.message}"
    end

  when "3"
    print "Enter book ID to return: "
    id = gets.chomp
    begin
      BookManager.return(id)
      puts "Book returned successfully!"
    rescue BookDoesNotExist => e
      puts "Book not found: #{e.message}"
    rescue BookIsUnavailable => e
      puts "Book is not currently borrowed: #{e.message}"
    rescue => e
      puts "Unexpected error: #{e.message}"
    end

  when "4"
    print "Enter new book ID: "
    id = gets.chomp
    print "Enter book title: "
    title = gets.chomp
    print "Enter author: "
    author = gets.chomp
    print "Enter availability (available/unavailable): "
    availability = gets.chomp.downcase

    unless %w[available unavailable].include?(availability)
      puts "Please use 'available' or 'unavailable'."
      next
    end

    begin
      BookManager.add_book(id, title, author, availability)
      puts "Book added successfully!"
    rescue BookAlreadyExists => e
      puts "Book already exists: #{e.message}"
    rescue => e
      puts "Unexpected error: #{e.message}"
    end

  when "5"
    print "Enter book ID to remove: "
    id = gets.chomp
    begin
      BookManager.remove_book(id)
      puts "Book removed successfully!"
    rescue BookDoesNotExist => e
      puts "Book not found: #{e.message}"
    rescue => e
      puts "Unexpected error: #{e.message}"
    end

  when "6"
    print "Enter book ID to update: "
    id = gets.chomp
    print "Which field do you want to update? (id, title, author, availability): "
    field = gets.chomp.downcase
    print "Enter the new value: "
    value = gets.chomp

    if field == "availability" && !%w[available unavailable].include?(value.downcase)
      puts "Please use 'available' or 'unavailable'."
      next
    end

    begin
      BookManager.update_book(id, field, value)
      puts "Book updated successfully!"
    rescue BookDoesNotExist => e
      puts "Book not found: #{e.message}"
    rescue FieldDoesNotExist => e
      puts "Field error: #{e.message}"
    rescue => e
      puts "Unexpected error: #{e.message}"
    end

  when "7"
    print "Enter title to search: "
    title = gets.chomp
    results = BookManager.find_books_by_title(title)
    if results.empty?
      puts "No books found with that title."
    else
      puts "\nBooks matching title:"
      results.each { |book| puts book.to_s }
    end

  when "8"
    print "Enter author to search: "
    author = gets.chomp
    results = BookManager.find_books_by_author(author)
    if results.empty?
      puts "No books found by that author."
    else
      puts "\nBooks by author:"
      results.each { |book| puts book.to_s }
    end

  when "9"
    puts "\nExiting Book Manager. Bye bye!"
    break

  else
    puts "Invalid option. Please enter a number from 1 to 9."
  end
end
