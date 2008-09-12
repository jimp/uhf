require File.dirname(__FILE__) + '/../../spec_helper'

describe "/guest_books/edit.html.erb" do
  include GuestBooksHelper
  
  before do
    @guest_book = mock_model(GuestBook)
    @guest_book.stub!(:name).and_return("MyString")
    @guest_book.stub!(:comment).and_return("MyString")
    assigns[:guest_book] = @guest_book
  end

  it "should render edit form" do
    render "/guest_books/edit.html.erb"
    
    response.should have_tag("form[action=#{guest_book_path(@guest_book)}][method=post]") do
      with_tag('input#guest_book_name[name=?]', "guest_book[name]")
      with_tag('input#guest_book_comment[name=?]', "guest_book[comment]")
    end
  end
end


