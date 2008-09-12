require File.dirname(__FILE__) + '/../spec_helper'

describe PostsController, "#route_for" do

  it "should map { :controller => 'posts', :action => 'index' } to /posts" do
    route_for(:controller => "posts", :action => "index").should == "/posts"
  end
  
  it "should map { :controller => 'posts', :action => 'new' } to /posts/new" do
    route_for(:controller => "posts", :action => "new").should == "/posts/new"
  end
  
  it "should map { :controller => 'posts', :action => 'show', :id => 1 } to /posts/1" do
    route_for(:controller => "posts", :action => "show", :id => 1).should == "/posts/1"
  end
  
  it "should map { :controller => 'posts', :action => 'edit', :id => 1 } to /posts/1/edit" do
    route_for(:controller => "posts", :action => "edit", :id => 1).should == "/posts/1/edit"
  end
  
  it "should map { :controller => 'posts', :action => 'update', :id => 1} to /posts/1" do
    route_for(:controller => "posts", :action => "update", :id => 1).should == "/posts/1"
  end
  
  it "should map { :controller => 'posts', :action => 'destroy', :id => 1} to /posts/1" do
    route_for(:controller => "posts", :action => "destroy", :id => 1).should == "/posts/1"
  end
  
end

describe PostsController, "handling GET /posts" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @post = mock_model(Post)
    Post.stub!(:paginate).and_return([@post])
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
  
  it "should find all posts" do
    do_get
  end
  
  it "should assign the found posts for the view" do
    do_get
    assigns[:posts].should == [@post]
  end
end

describe PostsController, "handling GET /posts.xml" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @post = mock_model(Post, :to_xml => "XML")
    Post.stub!(:paginate).and_return(@post)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should find all posts" do
    do_get
  end
  
  it "should render the found posts as xml" do
    @post.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe PostsController, "handling GET /posts/1" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @post = mock_model(Post, :published_at=>Time.now)
    Post.stub!(:find).and_return(@post)
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
  
  it "should find the post requested" do
    Post.should_receive(:find).with("1").and_return(@post)
    do_get
  end
  
  it "should assign the found post for the view" do
    do_get
    assigns[:post].should equal(@post)
  end

end

describe PostsController, "handling GET /posts/1.xml" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)    
    @post = mock_model(Post, :to_xml => "XML")
    Post.stub!(:find).and_return(@post)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should find the post requested" do
    Post.should_receive(:find).with("1").and_return(@post)
    do_get
  end
  
  it "should render the found post as xml" do
    @post.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe PostsController, "handling GET /posts/new" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @post = mock_model(Post)
    Post.stub!(:new).and_return(@post)
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
  
  it "should create an new post" do
    Post.should_receive(:new).and_return(@post)
    do_get
  end
  
  it "should not save the new post" do
    @post.should_not_receive(:save)
    do_get
  end
  
  it "should assign the new post for the view" do
    do_get
    assigns[:post].should equal(@post)
  end
  
  it "should mark the published check box as false" do
    do_get
    assigns[:publish].should be_false
  end

end

describe PostsController, "handling GET /posts/1/edit" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)    
    @post = mock_model(Post)
    Post.stub!(:find).and_return(@post)
  end
  
  def do_get
    get :edit, :id => "1"
  end

  it "should be successful" do
    @post.should_receive(:published_at).and_return(nil)
    do_get
    response.should be_success
  end
  
  it "should render edit template" do
    @post.should_receive(:published_at).and_return(nil)
    do_get
    response.should render_template('edit')
  end
  
  it "should find the post requested" do
    Post.should_receive(:find).and_return(@post)
    @post.should_receive(:published_at).and_return(nil)
    do_get
  end
  
  it "should assign the found Post for the view" do
    @post.should_receive(:published_at).and_return(nil)
    do_get
    assigns[:post].should equal(@post)
  end
  
  it "should mark the published check box as false without a published_at date" do
    @post.should_receive(:published_at).and_return(nil)
    do_get
    assigns[:publish].should be_false
  end

  it "should mark the published check box as true with a published_at date" do
    @post.should_receive(:published_at).and_return(Time.now)
    do_get
    assigns[:publish].should be_true
  end

end

describe PostsController, "handling POST /posts" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @post = mock_model(Post, :to_param => "1")
    Post.stub!(:new).and_return(@post)
    @params = {}
  end
  
  def do_post
    post :create, :post => @params
  end
  
  it "should create a new post" do
    @post.should_receive(:save).and_return(true)
    Post.should_receive(:new).and_return(@post)
    do_post
  end

  it "should redirect to the new post" do
    @post.should_receive(:save).and_return(true)
    do_post
    response.should redirect_to(posts_url)
  end

  it "should mark the published check box as true with a a checked publish box" do
    @post.should_receive(:save).and_return(false)
    @params[:publish]="1"
    do_post
    assigns[:publish].should be_true
  end

  it "should mark the published check box as false with no checked publish box" do
    @post.should_receive(:save).and_return(false)
    @params[:publish]="0"
    do_post
    assigns[:publish].should be_false
  end

end

describe PostsController, "handling PUT /posts/1" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @post = mock_model(Post, :to_param => "1")
    Post.stub!(:find).and_return(@post)
    @params={}
  end
  
  def do_update
    put :update, {:id => "1", :post=>@params}
  end
  
  it "should find the post requested" do
    @post.should_receive(:update_attributes).and_return(true)
    Post.should_receive(:find).with("1").and_return(@post)
    do_update
  end

  it "should update the found post" do
    @post.should_receive(:update_attributes).and_return(true)
    do_update
    assigns(:post).should equal(@post)
  end

  it "should assign the found post for the view" do
    @post.should_receive(:update_attributes).and_return(true)
    do_update
    assigns(:post).should equal(@post)
  end

  it "should redirect to the post" do
    @post.should_receive(:update_attributes).and_return(true)
    do_update
    response.should redirect_to(posts_url)
  end
  
  it "should mark the published check box as true with a a checked publish box" do
    @post.should_receive(:update_attributes).and_return(false)
    @params[:publish]="1"
    do_update
    assigns[:publish].should be_true
  end

  it "should mark the published check box as false with no checked publish box" do
    @post.should_receive(:update_attributes).and_return(false)
    @params[:publish]="2"
    do_update
    assigns[:publish].should be_false
  end
  
end

describe PostsController, "handling DELETE /posts/1" do

  before do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @post = mock_model(Post, :destroy => true)
    Post.stub!(:find).and_return(@post)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  it "should find the post requested" do
    Post.should_receive(:find).with("1").and_return(@post)
    do_delete
  end
  
  it "should call destroy on the found post" do
    @post.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the posts list" do
    do_delete
    response.should redirect_to(posts_url)
  end
end
