require File.dirname(__FILE__) + '/../spec_helper'

describe CategoriesController do
  describe "handling GET /categories" do

    before(:each) do
      @category = mock_model(Category)
      Category.stub!(:find).and_return([@category])
    end
  
    def do_get
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render index template" do
      do_get
      response.should render_template('index')
    end
  
    it "should find all categories" do
      Category.should_receive(:find).with(:all).and_return([@category])
      do_get
    end
  
    it "should assign the found categories for the view" do
      do_get
      assigns[:categories].should == [@category]
    end
  end

  describe "handling GET /categories.xml" do

    before(:each) do
      @category = mock_model(Category, :to_xml => "XML")
      Category.stub!(:find).and_return(@category)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should find all categories" do
      Category.should_receive(:find).with(:all).and_return([@category])
      do_get
    end
  
    it "should render the found categories as xml" do
      @category.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /categories/1" do

    before(:each) do
      @category = mock_model(Category)
      Category.stub!(:find).and_return(@category)
    end
  
    def do_get
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render show template" do
      do_get
      response.should render_template('show')
    end
  
    it "should find the category requested" do
      Category.should_receive(:find).with("1").and_return(@category)
      do_get
    end
  
    it "should assign the found category for the view" do
      do_get
      assigns[:category].should equal(@category)
    end
  end

  describe "handling GET /categories/1.xml" do

    before(:each) do
      @category = mock_model(Category, :to_xml => "XML")
      Category.stub!(:find).and_return(@category)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should find the category requested" do
      Category.should_receive(:find).with("1").and_return(@category)
      do_get
    end
  
    it "should render the found category as xml" do
      @category.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /categories/new" do

    before(:each) do
      @category = mock_model(Category)
      Category.stub!(:new).and_return(@category)
    end
  
    def do_get
      get :new
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render new template" do
      do_get
      response.should render_template('new')
    end
  
    it "should create an new category" do
      Category.should_receive(:new).and_return(@category)
      do_get
    end
  
    it "should not save the new category" do
      @category.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new category for the view" do
      do_get
      assigns[:category].should equal(@category)
    end
  end

  describe "handling GET /categories/1/edit" do

    before(:each) do
      @category = mock_model(Category)
      Category.stub!(:find).and_return(@category)
    end
  
    def do_get
      get :edit, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end
  
    it "should find the category requested" do
      Category.should_receive(:find).and_return(@category)
      do_get
    end
  
    it "should assign the found Category for the view" do
      do_get
      assigns[:category].should equal(@category)
    end
  end

  describe "handling POST /categories" do

    before(:each) do
      @category = mock_model(Category, :to_param => "1")
      Category.stub!(:new).and_return(@category)
    end
    
    describe "with successful save" do
  
      def do_post
        @category.should_receive(:save).and_return(true)
        post :create, :category => {}
      end
  
      it "should create a new category" do
        Category.should_receive(:new).with({}).and_return(@category)
        do_post
      end

      it "should redirect to the new category" do
        do_post
        response.should redirect_to(category_url("1"))
      end
      
    end
    
    describe "with failed save" do

      def do_post
        @category.should_receive(:save).and_return(false)
        post :create, :category => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /categories/1" do

    before(:each) do
      @category = mock_model(Category, :to_param => "1")
      Category.stub!(:find).and_return(@category)
    end
    
    describe "with successful update" do

      def do_put
        @category.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the category requested" do
        Category.should_receive(:find).with("1").and_return(@category)
        do_put
      end

      it "should update the found category" do
        do_put
        assigns(:category).should equal(@category)
      end

      it "should assign the found category for the view" do
        do_put
        assigns(:category).should equal(@category)
      end

      it "should redirect to the category" do
        do_put
        response.should redirect_to(category_url("1"))
      end

    end
    
    describe "with failed update" do

      def do_put
        @category.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /categories/1" do

    before(:each) do
      @category = mock_model(Category, :destroy => true)
      Category.stub!(:find).and_return(@category)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the category requested" do
      Category.should_receive(:find).with("1").and_return(@category)
      do_delete
    end
  
    it "should call destroy on the found category" do
      @category.should_receive(:destroy)
      do_delete
    end
  
    it "should redirect to the categories list" do
      do_delete
      response.should redirect_to(categories_url)
    end
  end
end