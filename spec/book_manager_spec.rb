#require rspec/autorun

describe BookManager do

  context "when testing the set_csv method" do
    it "receives an invalid file path as a parameter" do
      expect{BookManager.set_csv("res/non_existent_file.csv")}.to raise_error(Errno::ENOENT)
    end
  end


  context "when testing the update_temp_store method" do
    it "displays the book list" do
      BookManager.set_csv("res/books.csv")
      expect(BookManager.update_temp_store).not_to be_nil
    end
  end

  context "when testing the borrow and return method" do

    it "finds a valid book to borrow/return" do
      BookManager.set_csv("res/books.csv")
      BookManager.borrow("1")
      BookManager.return("1")
    end

    it "attempts to borrow/return a book that is already being borrowed/returned" do
      BookManager.set_csv("res/books.csv")
      expect{BookManager.return("1")}.to raise_error(BookIsUnavailable)
      expect{BookManager.borrow("3")}.to raise_error(BookIsUnavailable)
    end

    it "attempts to borrow/return a book that does not exist" do
      BookManager.set_csv("res/books.csv")
      expect{BookManager.borrow("invalid")}.to raise_error(BookDoesNotExist)
      expect{BookManager.return("invalid")}.to raise_error(BookDoesNotExist)
    end
  end

  context "when testing the add_book method" do
    it "successfully adds a book" do
      BookManager.set_csv("res/books.csv")
      BookManager.add_book("4", "Book 4", "The Beast", unavailable)
      expect(BookManager.find_book("4")).not_to be_nil
    end

    it "finds another book with the same id" do
      BookManager.set_csv("res/books.csv")
      expect{BookManager.add_book("1", "Book 2", "The Beast", unavailable)}.to raise_error(BookAlreadyExists)
    end
  end

  context "when testing the find_book method" do
    it "receives a parameter that matches an existing book" do
      BookManager.set_csv("res/books.csv")
      expect(BookManager.find_book("1")).not_to be_nil
    end

    it "receives a parameter that does not match an existing book" do
      BookManager.set_csv("res/books.csv")
      expect{BookManager.find_book("invalid")}.to raise_error(BookDoesNotExist)
    end
  end

  context "when testing the remove_book method" do
    it "receives attempts to remove a book that does not exist" do
      BookManager.set_csv("res/books.csv")
      expect{BookManager.remove_book("invalid")}.to raise_error(BookDoesNotExist)
    end

    it "successfully removes the book from the list" do
      BookManager.set_csv("res/books.csv")
      BookManager.remove_book("1")
      expect{BookManager.find_book("1")}.to raise_error(BookDoesNotExist)
    end
  end

  context "when testing the update_book method" do
    it "cannot find the id of the specified book" do
      BookManager.set_csv("res/books.csv")
      expect{BookManager.update_book("invalid", "title", "Updated Title")}.to raise_error(BookDoesNotExist)
    end

    it "the specified field is invalid" do
      BookManager.set_csv("res/books.csv")
      expect{BookManager.update_book("1", "Invalid Field", "Updated Title")}.to raise_error(FieldDoesNotExist)
    end
  end
end

