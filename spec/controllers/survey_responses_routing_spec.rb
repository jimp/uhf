require File.dirname(__FILE__) + '/../spec_helper'

describe SurveyResponsesController do
  describe "route generation" do

    it "should map { :controller => 'survey_responses', :action => 'index' } to /survey_responses" do
      route_for(:controller => "survey_responses", :action => "index").should == "/survey_responses"
    end
  
    it "should map { :controller => 'survey_responses', :action => 'new' } to /survey_responses/new" do
      route_for(:controller => "survey_responses", :action => "new").should == "/survey_responses/new"
    end
  
    it "should map { :controller => 'survey_responses', :action => 'show', :id => 1 } to /survey_responses/1" do
      route_for(:controller => "survey_responses", :action => "show", :id => 1).should == "/survey_responses/1"
    end
  
    it "should map { :controller => 'survey_responses', :action => 'edit', :id => 1 } to /survey_responses/1/edit" do
      route_for(:controller => "survey_responses", :action => "edit", :id => 1).should == "/survey_responses/1/edit"
    end
  
    it "should map { :controller => 'survey_responses', :action => 'update', :id => 1} to /survey_responses/1" do
      route_for(:controller => "survey_responses", :action => "update", :id => 1).should == "/survey_responses/1"
    end
  
    it "should map { :controller => 'survey_responses', :action => 'destroy', :id => 1} to /survey_responses/1" do
      route_for(:controller => "survey_responses", :action => "destroy", :id => 1).should == "/survey_responses/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'survey_responses', action => 'index' } from GET /survey_responses" do
      params_from(:get, "/survey_responses").should == {:controller => "survey_responses", :action => "index"}
    end
  
    it "should generate params { :controller => 'survey_responses', action => 'new' } from GET /survey_responses/new" do
      params_from(:get, "/survey_responses/new").should == {:controller => "survey_responses", :action => "new"}
    end
  
    it "should generate params { :controller => 'survey_responses', action => 'create' } from POST /survey_responses" do
      params_from(:post, "/survey_responses").should == {:controller => "survey_responses", :action => "create"}
    end
  
    it "should generate params { :controller => 'survey_responses', action => 'show', id => '1' } from GET /survey_responses/1" do
      params_from(:get, "/survey_responses/1").should == {:controller => "survey_responses", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'survey_responses', action => 'edit', id => '1' } from GET /survey_responses/1;edit" do
      params_from(:get, "/survey_responses/1/edit").should == {:controller => "survey_responses", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'survey_responses', action => 'update', id => '1' } from PUT /survey_responses/1" do
      params_from(:put, "/survey_responses/1").should == {:controller => "survey_responses", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'survey_responses', action => 'destroy', id => '1' } from DELETE /survey_responses/1" do
      params_from(:delete, "/survey_responses/1").should == {:controller => "survey_responses", :action => "destroy", :id => "1"}
    end
  end
end