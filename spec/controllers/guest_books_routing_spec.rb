require File.dirname(__FILE__) + '/../spec_helper'

describe GuestBooksController do
  describe "route generation" do

    it "should map { :controller => 'guest_books', :action => 'index' } to /guest_books" do
      route_for(:controller => "guest_books", :action => "index").should == "/guest_books"
    end
  
    it "should map { :controller => 'guest_books', :action => 'new' } to /guest_books/new" do
      route_for(:controller => "guest_books", :action => "new").should == "/guest_books/new"
    end
  
    it "should map { :controller => 'guest_books', :action => 'show', :id => 1 } to /guest_books/1" do
      route_for(:controller => "guest_books", :action => "show", :id => 1).should == "/guest_books/1"
    end
  
    it "should map { :controller => 'guest_books', :action => 'edit', :id => 1 } to /guest_books/1/edit" do
      route_for(:controller => "guest_books", :action => "edit", :id => 1).should == "/guest_books/1/edit"
    end
  
    it "should map { :controller => 'guest_books', :action => 'update', :id => 1} to /guest_books/1" do
      route_for(:controller => "guest_books", :action => "update", :id => 1).should == "/guest_books/1"
    end
  
    it "should map { :controller => 'guest_books', :action => 'destroy', :id => 1} to /guest_books/1" do
      route_for(:controller => "guest_books", :action => "destroy", :id => 1).should == "/guest_books/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'guest_books', action => 'index' } from GET /guest_books" do
      params_from(:get, "/guest_books").should == {:controller => "guest_books", :action => "index"}
    end
  
    it "should generate params { :controller => 'guest_books', action => 'new' } from GET /guest_books/new" do
      params_from(:get, "/guest_books/new").should == {:controller => "guest_books", :action => "new"}
    end
  
    it "should generate params { :controller => 'guest_books', action => 'create' } from POST /guest_books" do
      params_from(:post, "/guest_books").should == {:controller => "guest_books", :action => "create"}
    end
  
    it "should generate params { :controller => 'guest_books', action => 'show', id => '1' } from GET /guest_books/1" do
      params_from(:get, "/guest_books/1").should == {:controller => "guest_books", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'guest_books', action => 'edit', id => '1' } from GET /guest_books/1;edit" do
      params_from(:get, "/guest_books/1/edit").should == {:controller => "guest_books", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'guest_books', action => 'update', id => '1' } from PUT /guest_books/1" do
      params_from(:put, "/guest_books/1").should == {:controller => "guest_books", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'guest_books', action => 'destroy', id => '1' } from DELETE /guest_books/1" do
      params_from(:delete, "/guest_books/1").should == {:controller => "guest_books", :action => "destroy", :id => "1"}
    end
  end
end