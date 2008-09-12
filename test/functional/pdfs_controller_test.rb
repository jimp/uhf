require File.dirname(__FILE__) + '/../test_helper'

class PdfsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:pdfs)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_pdfs
    assert_difference('Pdfs.count') do
      post :create, :pdfs => { }
    end

    assert_redirected_to pdfs_path(assigns(:pdfs))
  end

  def test_should_show_pdfs
    get :show, :id => pdfs(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => pdfs(:one).id
    assert_response :success
  end

  def test_should_update_pdfs
    put :update, :id => pdfs(:one).id, :pdfs => { }
    assert_redirected_to pdfs_path(assigns(:pdfs))
  end

  def test_should_destroy_pdfs
    assert_difference('Pdfs.count', -1) do
      delete :destroy, :id => pdfs(:one).id
    end

    assert_redirected_to pdfs_path
  end
end
