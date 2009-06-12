require 'test_helper'

class PortraitsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:portraits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create portrait" do
    assert_difference('Portrait.count') do
      post :create, :portrait => { }
    end

    assert_redirected_to portrait_path(assigns(:portrait))
  end

  test "should show portrait" do
    get :show, :id => portraits(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => portraits(:one).to_param
    assert_response :success
  end

  test "should update portrait" do
    put :update, :id => portraits(:one).to_param, :portrait => { }
    assert_redirected_to portrait_path(assigns(:portrait))
  end

  test "should destroy portrait" do
    assert_difference('Portrait.count', -1) do
      delete :destroy, :id => portraits(:one).to_param
    end

    assert_redirected_to portraits_path
  end
end
