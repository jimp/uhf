require File.dirname(__FILE__) + '/../spec_helper'

describe PartialsController do
  describe "route generation" do

    it "should map { :controller => 'partials', :action => 'index' } to /partials" do
      route_for(:controller => "partials", :action => "index").should == "/partials"
    end
  
    it "should map { :controller => 'partials', :action => 'new' } to /partials/new" do
      route_for(:controller => "partials", :action => "new").should == "/partials/new"
    end
  
    it "should map { :controller => 'partials', :action => 'show', :id => 1 } to /partials/1" do
      route_for(:controller => "partials", :action => "show", :id => 1).should == "/partials/1"
    end
  
    it "should map { :controller => 'partials', :action => 'edit', :id => 1 } to /partials/1/edit" do
      route_for(:controller => "partials", :action => "edit", :id => 1).should == "/partials/1/edit"
    end
  
    it "should map { :controller => 'partials', :action => 'update', :id => 1} to /partials/1" do
      route_for(:controller => "partials", :action => "update", :id => 1).should == "/partials/1"
    end
  
    it "should map { :controller => 'partials', :action => 'destroy', :id => 1} to /partials/1" do
      route_for(:controller => "partials", :action => "destroy", :id => 1).should == "/partials/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'partials', action => 'index' } from GET /partials" do
      params_from(:get, "/partials").should == {:controller => "partials", :action => "index"}
    end
  
    it "should generate params { :controller => 'partials', action => 'new' } from GET /partials/new" do
      params_from(:get, "/partials/new").should == {:controller => "partials", :action => "new"}
    end
  
    it "should generate params { :controller => 'partials', action => 'create' } from POST /partials" do
      params_from(:post, "/partials").should == {:controller => "partials", :action => "create"}
    end
  
    it "should generate params { :controller => 'partials', action => 'show', id => '1' } from GET /partials/1" do
      params_from(:get, "/partials/1").should == {:controller => "partials", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'partials', action => 'edit', id => '1' } from GET /partials/1;edit" do
      params_from(:get, "/partials/1/edit").should == {:controller => "partials", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'partials', action => 'update', id => '1' } from PUT /partials/1" do
      params_from(:put, "/partials/1").should == {:controller => "partials", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'partials', action => 'destroy', id => '1' } from DELETE /partials/1" do
      params_from(:delete, "/partials/1").should == {:controller => "partials", :action => "destroy", :id => "1"}
    end
  end
end