require File.dirname(__FILE__) + '/../spec_helper'

describe CommentsController, "#route_for" do

  it "should map { :controller => 'comments', :action => 'index' } to /comments" do
    route_for(:controller => "comments", :action => "index").should == "/comments"
  end
  
  it "should map { :controller => 'comments', :action => 'new' } to /comments/new" do
    route_for(:controller => "comments", :action => "new").should == "/comments/new"
  end
  
  it "should map { :controller => 'comments', :action => 'show', :id => 1 } to /comments/1" do
    route_for(:controller => "comments", :action => "show", :id => 1).should == "/comments/1"
  end
  
  it "should map { :controller => 'comments', :action => 'edit', :id => 1 } to /comments/1/edit" do
    route_for(:controller => "comments", :action => "edit", :id => 1).should == "/comments/1/edit"
  end
  
  it "should map { :controller => 'comments', :action => 'update', :id => 1} to /comments/1" do
    route_for(:controller => "comments", :action => "update", :id => 1).should == "/comments/1"
  end
  
  it "should map { :controller => 'comments', :action => 'destroy', :id => 1} to /comments/1" do
    route_for(:controller => "comments", :action => "destroy", :id => 1).should == "/comments/1"
  end

  it "should map { :controller => 'comments', :action => 'approve', :id => 1} to /comments/1/approve" do
    route_for(:controller => "comments", :action => "approve", :id => 1).should == "/comments/1/approve"
  end

  it "should map { :controller => 'comments', :action => 'disapprove', :id => 1} to /comments/1/disapprove" do
    route_for(:controller => "comments", :action => "disapprove", :id => 1).should == "/comments/1/disapprove"
  end

  it "should map { :controller => 'comments', :action => 'spam', :id => 1} to /comments/1/spam" do
    route_for(:controller => "comments", :action => "spam", :id => 1).should == "/comments/1/spam"
  end

  it "should map { :controller => 'comments', :action => 'ham', :id => 1} to /comments/1/ham" do
    route_for(:controller => "comments", :action => "ham", :id => 1).should == "/comments/1/ham"
  end

  it "should map { :controller => 'comments', :action => 'index', :filter => 'spam'} to /comments/spam" do
    route_for(:controller => "comments", :action => "index", :filter => 'spam').should == "/comments/spam"
  end

  it "should map { :controller => 'comments', :action => 'index', :filter => 'unapproved'} to /comments/unapproved" do
    route_for(:controller => "comments", :action => "index", :filter => 'unapproved').should == "/comments/unapproved"
  end
end

describe CommentsController, "handling GET /comments" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @comment = mock_model(Comment)
    Comment.stub!(:find).and_return([@comment])
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
  
  it "should find all comments" do
    Comment.should_receive(:paginate).and_return([@comment])
    do_get
  end
  
  it "should assign the found comments for the view" do
    do_get
    assigns[:comments].should == [@comment]
  end
end

describe CommentsController, "handling GET /comments/spam" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @comment = mock_model(Comment)
    Comment.stub!(:spam_list).and_return([@comment])
  end
  
  def do_get
    get :index, :filter=>'spam'
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should render index template" do
    do_get
    response.should render_template('index')
  end
  
  it "should find all comments" do
    Comment.should_receive(:spam_list).and_return([@comment])
    do_get
  end
  
  it "should assign the found comments for the view" do
    do_get
    assigns[:comments].should == [@comment]
  end
end

describe CommentsController, "handling GET /comments/unapproved" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @comment = mock_model(Comment)
    Comment.stub!(:unapproved).and_return([@comment])
  end
  
  def do_get
    get :index, :filter=>'unapproved'
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should render index template" do
    do_get
    response.should render_template('index')
  end
  
  it "should find all comments" do
    Comment.should_receive(:unapproved).and_return([@comment])
    do_get
  end
  
  it "should assign the found comments for the view" do
    do_get
    assigns[:comments].should == [@comment]
  end
end

describe CommentsController, "handling GET /comments.xml" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @comment = mock_model(Comment, :to_xml => "XML")
    Comment.stub!(:paginate).and_return(@comment)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should find all comments" do
    do_get
  end
  
  it "should render the found comments as xml" do
    @comment.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe CommentsController, "handling GET /comments/1" do

  before do
    @comment = mock_model(Comment)
    Comment.stub!(:find).and_return(@comment)
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
  
  it "should find the comment requested" do
    Comment.should_receive(:find).with("1").and_return(@comment)
    do_get
  end
  
  it "should assign the found comment for the view" do
    do_get
    assigns[:comment].should equal(@comment)
  end
end

describe CommentsController, "handling GET /comments/1.xml" do

  before do
    @comment = mock_model(Comment, :to_xml => "XML")
    Comment.stub!(:find).and_return(@comment)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should find the comment requested" do
    Comment.should_receive(:find).with("1").and_return(@comment)
    do_get
  end
  
  it "should render the found comment as xml" do
    @comment.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe CommentsController, "handling GET /comments/new" do

  before do
    @comment = mock_model(Comment)
    Comment.stub!(:new).and_return(@comment)
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
  
  it "should create an new comment" do
    Comment.should_receive(:new).and_return(@comment)
    do_get
  end
  
  it "should not save the new comment" do
    @comment.should_not_receive(:save)
    do_get
  end
  
  it "should assign the new comment for the view" do
    do_get
    assigns[:comment].should equal(@comment)
  end
end

describe CommentsController, "handling GET /comments/1/edit" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @comment = mock_model(Comment)
    Comment.stub!(:find).and_return(@comment)
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
  
  it "should find the comment requested" do
    Comment.should_receive(:find).and_return(@comment)
    do_get
  end
  
  it "should assign the found Comment for the view" do
    do_get
    assigns[:comment].should equal(@comment)
  end
end

describe CommentsController, "handling POST /comments with Non Spam" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @comment = mock_model(Comment, :to_param => "1", :save => true, :approved_at=>true)
    @comment.stub!("approved_at=")
    @post = mock_model(Post, :url=>'/post_url')
    Comment.stub!(:new).and_return(@comment)
    @comment.stub!(:post).and_return(@post)
    @params = {}
  end
  
  def do_post
    post :create, :comment => @params
  end
  
  it "should create a new comment" do
    Comment.should_receive(:new).and_return(@comment)
    do_post
  end

  it "should redirect to the new comment" do
    do_post
    response.should redirect_to(comments_url)
  end
  
  it "should redirect to the comment" do
    put :create, {:id => "1", :comment=>{:name=>'jack'}, :post_id=>1}
    response.should redirect_to('/post_url')
  end
  
end

describe CommentsController, "handling PUT /comments/1" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @comment = mock_model(Comment, :to_param => "1", :update_attributes => true)
    @post = mock_model(Post, :url=>'/post_url')
    @comment.stub!(:post).and_return(@post)
    Comment.stub!(:find).and_return(@comment)
  end
  
  def do_update
    put :update, {:id => "1", :comment=>{:name=>'jack'}}
  end
  
  it "should find the comment requested" do
    Comment.should_receive(:find).with("1").and_return(@comment)
    do_update
  end

  it "should update the found comment" do
    @comment.should_receive(:update_attributes)
    do_update
    assigns(:comment).should equal(@comment)
  end

  it "should assign the found comment for the view" do
    do_update
    assigns(:comment).should equal(@comment)
  end

  it "should redirect to the comment" do
    do_update
    response.should redirect_to(comments_url)
  end

  it "should redirect to the comment" do
    put :update, {:id => "1", :comment=>{:name=>'jack'}, :post_id=>1}
    response.should redirect_to('/post_url')
  end
end

describe CommentsController, "handling DELETE /comments/1" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @comment = mock_model(Comment, :destroy => true)
    Comment.stub!(:find).and_return(@comment)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  it "should find the comment requested" do
    Comment.should_receive(:find).with("1").and_return(@comment)
    do_delete
  end
  
  it "should call destroy on the found comment" do
    @comment.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the comments list" do
    do_delete
    response.should redirect_to(comments_url)
  end
end

describe CommentsController, "handling POST /comments/1/spam" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @comment = mock_model(Comment, :update_attributes => true)
    Comment.stub!(:find).and_return(@comment)
  end
  
  def do_post
    post :spam, :id => "1"
  end

  it "should find the comment requested" do
    Comment.should_receive(:find).with("1").and_return(@comment)
    do_post
  end
  
  it "should call destroy on the found comment" do
    @comment.should_receive(:update_attributes)
    do_post
  end
  
  it "should redirect to the comments list" do
    do_post
    response.should redirect_to(comments_url)
  end
end

describe CommentsController, "handling POST /comments/1/ham" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @comment = mock_model(Comment, :update_attributes => true)
    Comment.stub!(:find).and_return(@comment)
  end
  
  def do_post
    post :ham, :id => "1"
  end

  it "should find the comment requested" do
    Comment.should_receive(:find).with("1").and_return(@comment)
    do_post
  end
  
  it "should call destroy on the found comment" do
    @comment.should_receive(:update_attributes)
    do_post
  end
  
  it "should redirect to the comments list" do
    do_post
    response.should redirect_to(comments_url)
  end
end

describe CommentsController, "handling POST /comments/1/approve" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @comment = mock_model(Comment, :update_attributes => true)
    Comment.stub!(:find).and_return(@comment)
  end
  
  def do_post
    post :approve, :id => "1"
  end

  it "should find the comment requested" do
    Comment.should_receive(:find).with("1").and_return(@comment)
    do_post
  end
  
  it "should call destroy on the found comment" do
    @comment.should_receive(:update_attributes)
    do_post
  end
  
  it "should redirect to the comments list" do
    do_post
    response.should redirect_to(comments_url)
  end
end

describe CommentsController, "handling POST /comments/1/disapprove" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @comment = mock_model(Comment, :update_attributes => true)
    Comment.stub!(:find).and_return(@comment)
  end
  
  def do_post
    post :disapprove, :id => "1"
  end

  it "should find the comment requested" do
    Comment.should_receive(:find).with("1").and_return(@comment)
    do_post
  end
  
  it "should call destroy on the found comment" do
    @comment.should_receive(:update_attributes)
    do_post
  end
  
  it "should redirect to the comments list" do
    do_post
    response.should redirect_to(comments_url)
  end
end