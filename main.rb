require_relative 'error/field_does_not_exist'
require_relative 'error/book_does_not_exist'
require_relative 'error/book_already_exists'
require_relative 'error/book_is_unavailable'
require_relative 'book'
require_relative 'book_manager'

BookManager.set_csv"res/books.csv"

BookManager.get_book_list