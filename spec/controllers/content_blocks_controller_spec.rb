require File.dirname(__FILE__) + '/../spec_helper'

describe 'Routes for the ContentBlocksController should' do
  controller_name :content_blocks

  it "should map with blockable" do
    route_for(:controller => 'content_blocks', :action => 'index', :blockable_id => 1, :blockable_type => 'Page').should == '/page/1/content_blocks'
  end
=begin
  it "map { :controller => 'content_blocks', :action => 'index' } to /content_blocks" do
    route_for(:controller => 'content_blocks', :action => 'index').should == '/content_blocks'
  end
  
  it "map { :controller => 'content_blocks', :action => 'new' } to /content_blocks/new" do
    route_for(:controller => 'content_blocks', :action => 'new').should == '/content_blocks/new'
  end
  
  it "map { :controller => 'content_blocks', :action => 'show', :id => 1 } to /content_blocks/1" do
    route_for(:controller => 'content_blocks', :action => 'show', :id => 1).should == '/content_blocks/1'
  end
  
  it "map { :controller => 'content_blocks', :action => 'edit', :id => 1 } to /content_blocks/1/edit" do
    route_for(:controller => 'content_blocks', :action => 'edit', :id => 1).should == '/content_blocks/1/edit'
  end
  
  it "map { :controller => 'content_blocks', :action => 'update', :id => 1} to /content_blocks/1" do
    route_for(:controller => 'content_blocks', :action => 'update', :id => 1).should == '/content_blocks/1'
  end
  
  it "map { :controller => 'content_blocks', :action => 'destroy', :id => 1} to /content_blocks/1" do
    route_for(:controller => 'content_blocks', :action => 'destroy', :id => 1).should == '/content_blocks/1'
  end
=end
end

describe 'Requesting /content_blocks using GET' do
  controller_name :content_blocks

  setup do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @content_block = mock_model(ContentBlock, :group=>'main')
    ContentBlock.stub!(:find).and_return(@content_block)
  end
  
  def do_get
    get :index
  end
  
  it 'should be successful' do
    do_get
    response.should be_success
  end

  it 'should render index.rhtml' do
    do_get
    response.should render_template(:index)
  end
  
  it 'should find all content_blocks' do
    ContentBlock.should_receive(:find).with(:all).and_return([@content_block])
    do_get
  end
  
  it 'should assign the found content_blocks for the view' do
    do_get
    assigns[:content_blocks].should equal(@content_block)
  end
end

describe 'Requesting /content_blocks/1 using GET' do
  controller_name :content_blocks

  setup do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @content_block = mock_model(ContentBlock, :group=>'main')
    ContentBlock.stub!(:find).and_return(@content_block)
  end
  
  def do_get
    get :show, :id => '1'
  end

  it 'should be successful' do
    do_get
    response.should be_success
  end
  
  it 'should render show.rhtml' do
    do_get
    response.should render_template(:show)
  end
  
  it 'should find the content_block requested' do
    ContentBlock.should_receive(:find).with('1').and_return(@content_block)
    do_get
  end
  
  it 'should assign the found content_block for the view' do
    do_get
    assigns[:content_block].should equal(@content_block)
  end
end

describe 'Requesting /content_blocks/new using GET' do
  controller_name :content_blocks

  setup do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @content_block = mock_model(ContentBlock)
    ContentBlock.stub!(:new).and_return(@content_block)
  end
  
  def do_get
    get :new
  end

  it 'should be successful' do
    do_get
    response.should be_success
  end
  
  it 'should render new.rhtml' do
    do_get
    response.should render_template(:new)
  end
  
  it 'should create an new content_block' do
    ContentBlock.should_receive(:new).and_return(@content_block)
    do_get
  end
  
  it 'should not save the new content_block' do
    @content_block.should_not_receive(:save)
    do_get
  end
  
  it 'should assign the new content_block for the view' do
    do_get
    assigns[:content_block].should be(@content_block)
  end
end

describe 'Requesting /content_blocks/1/edit using GET' do
  controller_name :content_blocks

  setup do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @content_block = mock_model(ContentBlock, :group=>'main')
    @content_block.stub!("group=")
    ContentBlock.stub!(:find).and_return(@content_block)
  end
  
  def do_get
    get :edit, :id => '1'
  end

  it 'should be successful' do
    do_get
    response.should be_success
  end
  
  it 'should render edit.rhtml' do
    do_get
    response.should render_template(:edit)
  end
  
  it 'should find the content_block requested' do
    ContentBlock.should_receive(:find).and_return(@content_block)
    do_get
  end
  
  it 'should assign the found ContentBlock for the view' do
    do_get
    assigns[:content_block].should equal(@content_block)
  end
end

describe 'Requesting /content_blocks using POST' do
  controller_name :content_blocks

  setup do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @content_block = mock_model(ContentBlock, :to_param => '1', :save => true)
    @content_blocks = mock_model(ContentBlock, :build=>@content_block)
    @page = mock_model(Page, :path=>'path', :content_blocks=>@content_blocks)
    Page.stub!(:find).and_return(@page)
    ContentBlock.stub!(:new).and_return(@content_block)
  end
  
  def do_post
    post :create, :content_block => {:name => 'ContentBlock'}, :page_id=>1
  end
  
  it 'should create a new content_block' do
    #ContentBlock.should_receive(:new).with({'name' => 'ContentBlock'}).and_return(@content_block)
    do_post
  end

  it 'should redirect to the new content_block' do
    do_post
    response.should redirect_to('http://test.host/path')
  end
end

describe 'Requesting /content_blocks/1 using PUT' do
  controller_name :content_blocks

  setup do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @page = mock_model(Page, :path=>'path')
    @content_block = mock_model(ContentBlock, :to_param => '1', :update_attributes => true, :text=>'some text', :title=>'some title', :markup=>'HTML', :id=>1)
    ContentBlock.stub!(:find).and_return(@content_block)
    Page.stub!(:find).and_return(@page)
  end
  
  def do_update
    put :update, :id => '1', :page_id=>1
  end

  def do_xhr
    xhr :put, :update, :id => '1', :page_id=>1
  end
  
  it 'should find the content_block requested' do
    ContentBlock.should_receive(:find).with('1').and_return(@content_block)
    Page.should_receive(:find).and_return(@page)
    do_update
  end

  it 'should update the found content_block' do
    @content_block.should_receive(:update_attributes)
    do_update
    assigns(:content_block).should equal(@content_block)
  end

  it 'should assign the found content_block for the view' do
    do_update
    assigns(:content_block).should equal(@content_block)
  end

  it 'should redirect to the content_block' do
    do_update
    response.should be_redirect
    response.redirect_url.should == 'http://test.host/path'
  end

  it 'should update the content block using ajax and a name' do
#    @content_block.should_receive(:name).and_return 'some name', 'some name'
    do_xhr
    response.body.should =~ /content_block_1/
    # this is broken currently - uncomment when rspec is fixed
    # response.should render_template_rjs(:page, 'content_block_1', :replace,)/content_block_1/
  end

  it 'should update the content block using ajax without a name' do
#    @content_block.should_receive(:name).and_return nil
#    @content_block.should_receive(:controller).and_return 'controller'
#    @content_block.should_receive(:action).and_return 'action'
#    @content_block.should_receive(:position).and_return 0
    do_xhr
    response.body.should =~ /content_block_1/
    # this is broken currently - uncomment when rspec is fixed
    # response.should render_template_rjs(:page, 'content_block_1', :replace,)/content_block_1/
  end

end

describe 'Requesting /content_blocks/1 using DELETE' do
  controller_name :content_blocks

  setup do
    controller.stub!(:current_user).and_return(mock_admin_user)
    controller.stub!(:logged_in?).and_return(true)
    @page=mock_model(Page, :path=>'path')
    @content_block = mock_model(ContentBlock, :destroy => true, :page=>@page)
    ContentBlock.stub!(:find).and_return(@content_block)
  end
  
  def do_delete
    delete :destroy, :id => '1'
  end

  it 'should find the content_block requested' do
    ContentBlock.should_receive(:find).with('1').and_return(@content_block)
    do_delete
  end
  
  it 'should call destroy on the found content_block' do
    @content_block.should_receive(:destroy)
    do_delete
  end
  
  it 'should redirect to the content_blocks list' do
    do_delete
    response.should redirect_to('http://test.host/path')
  end
end