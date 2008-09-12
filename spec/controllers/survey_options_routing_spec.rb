require File.dirname(__FILE__) + '/../spec_helper'

describe SurveyOptionsController do
  describe "route generation" do

    it "should map { :controller => 'survey_options', :action => 'index' } to /survey_options" do
      route_for(:controller => "survey_options", :action => "index").should == "/survey_options"
    end
  
    it "should map { :controller => 'survey_options', :action => 'new' } to /survey_options/new" do
      route_for(:controller => "survey_options", :action => "new").should == "/survey_options/new"
    end
  
    it "should map { :controller => 'survey_options', :action => 'show', :id => 1 } to /survey_options/1" do
      route_for(:controller => "survey_options", :action => "show", :id => 1).should == "/survey_options/1"
    end
  
    it "should map { :controller => 'survey_options', :action => 'edit', :id => 1 } to /survey_options/1/edit" do
      route_for(:controller => "survey_options", :action => "edit", :id => 1).should == "/survey_options/1/edit"
    end
  
    it "should map { :controller => 'survey_options', :action => 'update', :id => 1} to /survey_options/1" do
      route_for(:controller => "survey_options", :action => "update", :id => 1).should == "/survey_options/1"
    end
  
    it "should map { :controller => 'survey_options', :action => 'destroy', :id => 1} to /survey_options/1" do
      route_for(:controller => "survey_options", :action => "destroy", :id => 1).should == "/survey_options/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'survey_options', action => 'index' } from GET /survey_options" do
      params_from(:get, "/survey_options").should == {:controller => "survey_options", :action => "index"}
    end
  
    it "should generate params { :controller => 'survey_options', action => 'new' } from GET /survey_options/new" do
      params_from(:get, "/survey_options/new").should == {:controller => "survey_options", :action => "new"}
    end
  
    it "should generate params { :controller => 'survey_options', action => 'create' } from POST /survey_options" do
      params_from(:post, "/survey_options").should == {:controller => "survey_options", :action => "create"}
    end
  
    it "should generate params { :controller => 'survey_options', action => 'show', id => '1' } from GET /survey_options/1" do
      params_from(:get, "/survey_options/1").should == {:controller => "survey_options", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'survey_options', action => 'edit', id => '1' } from GET /survey_options/1;edit" do
      params_from(:get, "/survey_options/1/edit").should == {:controller => "survey_options", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'survey_options', action => 'update', id => '1' } from PUT /survey_options/1" do
      params_from(:put, "/survey_options/1").should == {:controller => "survey_options", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'survey_options', action => 'destroy', id => '1' } from DELETE /survey_options/1" do
      params_from(:delete, "/survey_options/1").should == {:controller => "survey_options", :action => "destroy", :id => "1"}
    end
  end
end