require File.dirname(__FILE__) + '/../spec_helper'

describe SurveyQuestionsController do
  describe "route generation" do

    it "should map { :controller => 'survey_questions', :action => 'index' } to /survey_questions" do
      route_for(:controller => "survey_questions", :action => "index").should == "/survey_questions"
    end
  
    it "should map { :controller => 'survey_questions', :action => 'new' } to /survey_questions/new" do
      route_for(:controller => "survey_questions", :action => "new").should == "/survey_questions/new"
    end
  
    it "should map { :controller => 'survey_questions', :action => 'show', :id => 1 } to /survey_questions/1" do
      route_for(:controller => "survey_questions", :action => "show", :id => 1).should == "/survey_questions/1"
    end
  
    it "should map { :controller => 'survey_questions', :action => 'edit', :id => 1 } to /survey_questions/1/edit" do
      route_for(:controller => "survey_questions", :action => "edit", :id => 1).should == "/survey_questions/1/edit"
    end
  
    it "should map { :controller => 'survey_questions', :action => 'update', :id => 1} to /survey_questions/1" do
      route_for(:controller => "survey_questions", :action => "update", :id => 1).should == "/survey_questions/1"
    end
  
    it "should map { :controller => 'survey_questions', :action => 'destroy', :id => 1} to /survey_questions/1" do
      route_for(:controller => "survey_questions", :action => "destroy", :id => 1).should == "/survey_questions/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'survey_questions', action => 'index' } from GET /survey_questions" do
      params_from(:get, "/survey_questions").should == {:controller => "survey_questions", :action => "index"}
    end
  
    it "should generate params { :controller => 'survey_questions', action => 'new' } from GET /survey_questions/new" do
      params_from(:get, "/survey_questions/new").should == {:controller => "survey_questions", :action => "new"}
    end
  
    it "should generate params { :controller => 'survey_questions', action => 'create' } from POST /survey_questions" do
      params_from(:post, "/survey_questions").should == {:controller => "survey_questions", :action => "create"}
    end
  
    it "should generate params { :controller => 'survey_questions', action => 'show', id => '1' } from GET /survey_questions/1" do
      params_from(:get, "/survey_questions/1").should == {:controller => "survey_questions", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'survey_questions', action => 'edit', id => '1' } from GET /survey_questions/1;edit" do
      params_from(:get, "/survey_questions/1/edit").should == {:controller => "survey_questions", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'survey_questions', action => 'update', id => '1' } from PUT /survey_questions/1" do
      params_from(:put, "/survey_questions/1").should == {:controller => "survey_questions", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'survey_questions', action => 'destroy', id => '1' } from DELETE /survey_questions/1" do
      params_from(:delete, "/survey_questions/1").should == {:controller => "survey_questions", :action => "destroy", :id => "1"}
    end
  end
end