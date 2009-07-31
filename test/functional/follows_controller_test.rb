require 'test_helper'

class FollowsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:follows)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create follows" do
    assert_difference('Follows.count') do
      post :create, :follows => { }
    end

    assert_redirected_to follows_path(assigns(:follows))
  end

  test "should show follows" do
    get :show, :id => follows(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => follows(:one).to_param
    assert_response :success
  end

  test "should update follows" do
    put :update, :id => follows(:one).to_param, :follows => { }
    assert_redirected_to follows_path(assigns(:follows))
  end

  test "should destroy follows" do
    assert_difference('Follows.count', -1) do
      delete :destroy, :id => follows(:one).to_param
    end

    assert_redirected_to follows_path
  end
end
