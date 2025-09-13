require_relative '../book_manager'
BookManager.set_csv "res/books.csv"

#NOTE: Uncomment relevant blocks of code during presentation. The blocks of code are not part of the main program
# but will use components of it

=begin print statement
print "Hello World"
=end

=begin
float = 10.1
string = "Book"
integer = 1
boolean = true
$global_variable = "global"
array = [1, 2, 3]
hash = { "red" => 12, "green" => 13,  "blue" => 14}

puts float
puts string
puts integer
puts boolean
puts $global_variable
puts "-----"
puts array
puts "-----"

puts "Hash"
puts hash["red"]
=end

=begin if-statement
existing_book = BookManager.find_book "1"
if existing_book.book_id == "1"
  puts "The book id is 1"
else if existing_book.book_id == "2"
  puts "The book id is 2"
else
  puts "The book id is not 1 or 2"
=end

=begin unless statement
existing_book = BookManager.find_book "1"
unless existing_book.book_id == "1"
  puts "The book id is not 1"
else
  puts "The book id is 1"
end
=end

=begin switch case
existing_book = BookManager.find_book "1"
case existing_book.book_id
when "1"
  puts "The book id is 1"
else
  puts "The book id is not 1"
end
=end

=begin ternary
existing_book = BookManager.find_book "1"
puts (existing_book == "1") ? "The book id is 1" : "The book id is not 1"
=end

=begin while
i=0
list = BookManager.get_list
while i < 3
  puts list[i].to_s
  i += 1
end
=end

=begin until
i=0
list = BookManager.get_list
until i > 3
  puts list[i].to_s
  i += 1
end
=end

=begin for
list = BookManager.get_list
for i in 0..2
    puts list[i].to_s
end
=end

=begin each
list = BookManager.get_list
list.each do |book|
  puts book
end
=end

=begin access control
BookManager.save_to_csv #invalid call
#The method below works
#BookManager.get_book_list
#puts BookManager.@@book_list #attempting to access will not work
=end

=begin object instantiation
#Uncommenting will cause an error because to_s is an instance method
#Book.to_s
new_book = Book.new "1", "Book 1", "Author 1", "unavailable"
puts book.to_s
=end



