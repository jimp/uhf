require File.dirname(__FILE__) + '/../../spec_helper'

describe "/guest_books/show.html.erb" do
  include GuestBooksHelper
  
  before(:each) do
    @guest_book = mock_model(GuestBook)
    @guest_book.stub!(:name).and_return("MyString")
    @guest_book.stub!(:comment).and_return("MyString")

    assigns[:guest_book] = @guest_book
  end

  it "should render attributes in <p>" do
    render "/guest_books/show.html.erb"
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
  end
end

