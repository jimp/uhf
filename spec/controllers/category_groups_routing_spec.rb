require File.dirname(__FILE__) + '/../spec_helper'

describe CategoryGroupsController do
  describe "route generation" do

    it "should map { :controller => 'category_groups', :action => 'index' } to /category_groups" do
      route_for(:controller => "category_groups", :action => "index").should == "/category_groups"
    end
  
    it "should map { :controller => 'category_groups', :action => 'new' } to /category_groups/new" do
      route_for(:controller => "category_groups", :action => "new").should == "/category_groups/new"
    end
  
    it "should map { :controller => 'category_groups', :action => 'show', :id => 1 } to /category_groups/1" do
      route_for(:controller => "category_groups", :action => "show", :id => 1).should == "/category_groups/1"
    end
  
    it "should map { :controller => 'category_groups', :action => 'edit', :id => 1 } to /category_groups/1/edit" do
      route_for(:controller => "category_groups", :action => "edit", :id => 1).should == "/category_groups/1/edit"
    end
  
    it "should map { :controller => 'category_groups', :action => 'update', :id => 1} to /category_groups/1" do
      route_for(:controller => "category_groups", :action => "update", :id => 1).should == "/category_groups/1"
    end
  
    it "should map { :controller => 'category_groups', :action => 'destroy', :id => 1} to /category_groups/1" do
      route_for(:controller => "category_groups", :action => "destroy", :id => 1).should == "/category_groups/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'category_groups', action => 'index' } from GET /category_groups" do
      params_from(:get, "/category_groups").should == {:controller => "category_groups", :action => "index"}
    end
  
    it "should generate params { :controller => 'category_groups', action => 'new' } from GET /category_groups/new" do
      params_from(:get, "/category_groups/new").should == {:controller => "category_groups", :action => "new"}
    end
  
    it "should generate params { :controller => 'category_groups', action => 'create' } from POST /category_groups" do
      params_from(:post, "/category_groups").should == {:controller => "category_groups", :action => "create"}
    end
  
    it "should generate params { :controller => 'category_groups', action => 'show', id => '1' } from GET /category_groups/1" do
      params_from(:get, "/category_groups/1").should == {:controller => "category_groups", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'category_groups', action => 'edit', id => '1' } from GET /category_groups/1;edit" do
      params_from(:get, "/category_groups/1/edit").should == {:controller => "category_groups", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'category_groups', action => 'update', id => '1' } from PUT /category_groups/1" do
      params_from(:put, "/category_groups/1").should == {:controller => "category_groups", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'category_groups', action => 'destroy', id => '1' } from DELETE /category_groups/1" do
      params_from(:delete, "/category_groups/1").should == {:controller => "category_groups", :action => "destroy", :id => "1"}
    end
  end
end