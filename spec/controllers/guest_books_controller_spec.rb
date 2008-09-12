require File.dirname(__FILE__) + '/../spec_helper'

describe GuestBooksController do
  describe "handling GET /guest_books" do

    before(:each) do
      @guest_book = mock_model(GuestBook)
      GuestBook.stub!(:find).and_return([@guest_book])
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
  
    it "should find all guest_books" do
      GuestBook.should_receive(:find).with(:all).and_return([@guest_book])
      do_get
    end
  
    it "should assign the found guest_books for the view" do
      do_get
      assigns[:guest_books].should == [@guest_book]
    end
  end

  describe "handling GET /guest_books.xml" do

    before(:each) do
      @guest_book = mock_model(GuestBook, :to_xml => "XML")
      GuestBook.stub!(:find).and_return(@guest_book)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should find all guest_books" do
      GuestBook.should_receive(:find).with(:all).and_return([@guest_book])
      do_get
    end
  
    it "should render the found guest_books as xml" do
      @guest_book.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /guest_books/1" do

    before(:each) do
      @guest_book = mock_model(GuestBook)
      GuestBook.stub!(:find).and_return(@guest_book)
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
  
    it "should find the guest_book requested" do
      GuestBook.should_receive(:find).with("1").and_return(@guest_book)
      do_get
    end
  
    it "should assign the found guest_book for the view" do
      do_get
      assigns[:guest_book].should equal(@guest_book)
    end
  end

  describe "handling GET /guest_books/1.xml" do

    before(:each) do
      @guest_book = mock_model(GuestBook, :to_xml => "XML")
      GuestBook.stub!(:find).and_return(@guest_book)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should find the guest_book requested" do
      GuestBook.should_receive(:find).with("1").and_return(@guest_book)
      do_get
    end
  
    it "should render the found guest_book as xml" do
      @guest_book.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /guest_books/new" do

    before(:each) do
      @guest_book = mock_model(GuestBook)
      GuestBook.stub!(:new).and_return(@guest_book)
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
  
    it "should create an new guest_book" do
      GuestBook.should_receive(:new).and_return(@guest_book)
      do_get
    end
  
    it "should not save the new guest_book" do
      @guest_book.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new guest_book for the view" do
      do_get
      assigns[:guest_book].should equal(@guest_book)
    end
  end

  describe "handling GET /guest_books/1/edit" do

    before(:each) do
      @guest_book = mock_model(GuestBook)
      GuestBook.stub!(:find).and_return(@guest_book)
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
  
    it "should find the guest_book requested" do
      GuestBook.should_receive(:find).and_return(@guest_book)
      do_get
    end
  
    it "should assign the found GuestBook for the view" do
      do_get
      assigns[:guest_book].should equal(@guest_book)
    end
  end

  describe "handling POST /guest_books" do

    before(:each) do
      @guest_book = mock_model(GuestBook, :to_param => "1")
      GuestBook.stub!(:new).and_return(@guest_book)
    end
    
    describe "with successful save" do
  
      def do_post
        @guest_book.should_receive(:save).and_return(true)
        post :create, :guest_book => {}
      end
  
      it "should create a new guest_book" do
        GuestBook.should_receive(:new).with({}).and_return(@guest_book)
        do_post
      end

      it "should redirect to the new guest_book" do
        do_post
        response.should redirect_to(guest_book_url("1"))
      end
      
    end
    
    describe "with failed save" do

      def do_post
        @guest_book.should_receive(:save).and_return(false)
        post :create, :guest_book => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /guest_books/1" do

    before(:each) do
      @guest_book = mock_model(GuestBook, :to_param => "1")
      GuestBook.stub!(:find).and_return(@guest_book)
    end
    
    describe "with successful update" do

      def do_put
        @guest_book.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the guest_book requested" do
        GuestBook.should_receive(:find).with("1").and_return(@guest_book)
        do_put
      end

      it "should update the found guest_book" do
        do_put
        assigns(:guest_book).should equal(@guest_book)
      end

      it "should assign the found guest_book for the view" do
        do_put
        assigns(:guest_book).should equal(@guest_book)
      end

      it "should redirect to the guest_book" do
        do_put
        response.should redirect_to(guest_book_url("1"))
      end

    end
    
    describe "with failed update" do

      def do_put
        @guest_book.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /guest_books/1" do

    before(:each) do
      @guest_book = mock_model(GuestBook, :destroy => true)
      GuestBook.stub!(:find).and_return(@guest_book)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the guest_book requested" do
      GuestBook.should_receive(:find).with("1").and_return(@guest_book)
      do_delete
    end
  
    it "should call destroy on the found guest_book" do
      @guest_book.should_receive(:destroy)
      do_delete
    end
  
    it "should redirect to the guest_books list" do
      do_delete
      response.should redirect_to(guest_books_url)
    end
  end
end