require File.dirname(__FILE__) + '/../../spec_helper'

describe "/guest_books/index.html.erb" do
  include GuestBooksHelper
  
  before(:each) do
    guest_book_98 = mock_model(GuestBook)
    guest_book_98.should_receive(:name).and_return("MyString")
    guest_book_98.should_receive(:comment).and_return("MyString")
    guest_book_99 = mock_model(GuestBook)
    guest_book_99.should_receive(:name).and_return("MyString")
    guest_book_99.should_receive(:comment).and_return("MyString")

    assigns[:guest_books] = [guest_book_98, guest_book_99]
  end

  it "should render list of guest_books" do
    render "/guest_books/index.html.erb"
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
  end
end

