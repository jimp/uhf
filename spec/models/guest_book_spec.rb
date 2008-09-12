require File.dirname(__FILE__) + '/../spec_helper'

describe GuestBook do
  before(:each) do
    @guest_book = GuestBook.new
  end

  it "should be valid" do
    @guest_book.should be_valid
  end
end
