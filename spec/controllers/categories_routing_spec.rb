require File.dirname(__FILE__) + '/../spec_helper'

describe CategoriesController do
  describe "route generation" do

    it "should map { :controller => 'categories', :action => 'index' } to /categories" do
      route_for(:controller => "categories", :action => "index").should == "/categories"
    end
  
    it "should map { :controller => 'categories', :action => 'new' } to /categories/new" do
      route_for(:controller => "categories", :action => "new").should == "/categories/new"
    end
  
    it "should map { :controller => 'categories', :action => 'show', :id => 1 } to /categories/1" do
      route_for(:controller => "categories", :action => "show", :id => 1).should == "/categories/1"
    end
  
    it "should map { :controller => 'categories', :action => 'edit', :id => 1 } to /categories/1/edit" do
      route_for(:controller => "categories", :action => "edit", :id => 1).should == "/categories/1/edit"
    end
  
    it "should map { :controller => 'categories', :action => 'update', :id => 1} to /categories/1" do
      route_for(:controller => "categories", :action => "update", :id => 1).should == "/categories/1"
    end
  
    it "should map { :controller => 'categories', :action => 'destroy', :id => 1} to /categories/1" do
      route_for(:controller => "categories", :action => "destroy", :id => 1).should == "/categories/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'categories', action => 'index' } from GET /categories" do
      params_from(:get, "/categories").should == {:controller => "categories", :action => "index"}
    end
  
    it "should generate params { :controller => 'categories', action => 'new' } from GET /categories/new" do
      params_from(:get, "/categories/new").should == {:controller => "categories", :action => "new"}
    end
  
    it "should generate params { :controller => 'categories', action => 'create' } from POST /categories" do
      params_from(:post, "/categories").should == {:controller => "categories", :action => "create"}
    end
  
    it "should generate params { :controller => 'categories', action => 'show', id => '1' } from GET /categories/1" do
      params_from(:get, "/categories/1").should == {:controller => "categories", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'categories', action => 'edit', id => '1' } from GET /categories/1;edit" do
      params_from(:get, "/categories/1/edit").should == {:controller => "categories", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'categories', action => 'update', id => '1' } from PUT /categories/1" do
      params_from(:put, "/categories/1").should == {:controller => "categories", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'categories', action => 'destroy', id => '1' } from DELETE /categories/1" do
      params_from(:delete, "/categories/1").should == {:controller => "categories", :action => "destroy", :id => "1"}
    end
  end
end