class GuestBooksController < ApplicationController
  before_filter :login_required, :except => [:new, :create, :created]
  # GET /guest_books
  # GET /guest_books.xml
  def index
    @guest_books = GuestBook.find(:all, :order=>'created_at desc')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @guest_books }
    end
  end

  # GET /guest_books/1
  # GET /guest_books/1.xml
  def show
    @guest_book = GuestBook.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @guest_book }
    end
  end

  # GET /guest_books/new
  # GET /guest_books/new.xml
  def new
    @guest_book = GuestBook.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @guest_book }
    end
  end

  # GET /guest_books/1/edit
  def edit
    @guest_book = GuestBook.find(params[:id])
  end

  # POST /guest_books
  # POST /guest_books.xml
  def create
    @guest_book = GuestBook.new(params[:guest_book])

    respond_to do |format|
      if @guest_book.save
        flash[:notice] = 'Thank you for signing the guestbook'
        # format.html { redirect_to(@guest_book) }
        format.html { render :action => "created" }
        format.xml  { render :xml => @guest_book, :status => :created, :location => @guest_book }
      else
        flash[:notice] = @guest_book.errors[:name] || @guest_book.errors[:comment]
        flash[:notice] = @guest_book.errors[:name] + '<br/>'+  @guest_book.errors[:comment] if @guest_book.errors[:name] && @guest_book.errors[:comment]
        format.html { render :action => "new" }
        format.xml  { render :xml => @guest_book.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /guest_books/1
  # PUT /guest_books/1.xml
  def update
    @guest_book = GuestBook.find(params[:id])

    respond_to do |format|
      if @guest_book.update_attributes(params[:guest_book])
        flash[:notice] = 'GuestBook was successfully updated.'
        format.html { redirect_to(@guest_book) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @guest_book.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /guest_books/1
  # DELETE /guest_books/1.xml
  def destroy
    @guest_book = GuestBook.find(params[:id])
    @guest_book.destroy

    respond_to do |format|
      format.html { redirect_to(guest_books_url) }
      format.xml  { head :ok }
    end
  end
end
