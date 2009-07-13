require 'test_helper'

class SearchedKeywordsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:searched_keywords)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create searched_keyword" do
    assert_difference('SearchedKeyword.count') do
      post :create, :searched_keyword => { }
    end

    assert_redirected_to searched_keyword_path(assigns(:searched_keyword))
  end

  test "should show searched_keyword" do
    get :show, :id => searched_keywords(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => searched_keywords(:one).to_param
    assert_response :success
  end

  test "should update searched_keyword" do
    put :update, :id => searched_keywords(:one).to_param, :searched_keyword => { }
    assert_redirected_to searched_keyword_path(assigns(:searched_keyword))
  end

  test "should destroy searched_keyword" do
    assert_difference('SearchedKeyword.count', -1) do
      delete :destroy, :id => searched_keywords(:one).to_param
    end

    assert_redirected_to searched_keywords_path
  end
end
