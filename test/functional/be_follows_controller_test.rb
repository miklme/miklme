require 'test_helper'

class BeFollowsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:be_follows)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create be_follow" do
    assert_difference('BeFollow.count') do
      post :create, :be_follow => { }
    end

    assert_redirected_to be_follow_path(assigns(:be_follow))
  end

  test "should show be_follow" do
    get :show, :id => be_follows(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => be_follows(:one).to_param
    assert_response :success
  end

  test "should update be_follow" do
    put :update, :id => be_follows(:one).to_param, :be_follow => { }
    assert_redirected_to be_follow_path(assigns(:be_follow))
  end

  test "should destroy be_follow" do
    assert_difference('BeFollow.count', -1) do
      delete :destroy, :id => be_follows(:one).to_param
    end

    assert_redirected_to be_follows_path
  end
end
