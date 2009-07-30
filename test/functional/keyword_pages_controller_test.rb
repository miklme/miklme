require 'test_helper'

class KeywordPagesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:keyword_pages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create keyword_page" do
    assert_difference('KeywordPage.count') do
      post :create, :keyword_page => { }
    end

    assert_redirected_to keyword_page_path(assigns(:keyword_page))
  end

  test "should show keyword_page" do
    get :show, :id => keyword_pages(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => keyword_pages(:one).to_param
    assert_response :success
  end

  test "should update keyword_page" do
    put :update, :id => keyword_pages(:one).to_param, :keyword_page => { }
    assert_redirected_to keyword_page_path(assigns(:keyword_page))
  end

  test "should destroy keyword_page" do
    assert_difference('KeywordPage.count', -1) do
      delete :destroy, :id => keyword_pages(:one).to_param
    end

    assert_redirected_to keyword_pages_path
  end
end
