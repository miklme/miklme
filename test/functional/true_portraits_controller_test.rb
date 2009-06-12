require 'test_helper'

class TruePortraitsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:true_portraits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create true_portrait" do
    assert_difference('TruePortrait.count') do
      post :create, :true_portrait => { }
    end

    assert_redirected_to true_portrait_path(assigns(:true_portrait))
  end

  test "should show true_portrait" do
    get :show, :id => true_portraits(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => true_portraits(:one).to_param
    assert_response :success
  end

  test "should update true_portrait" do
    put :update, :id => true_portraits(:one).to_param, :true_portrait => { }
    assert_redirected_to true_portrait_path(assigns(:true_portrait))
  end

  test "should destroy true_portrait" do
    assert_difference('TruePortrait.count', -1) do
      delete :destroy, :id => true_portraits(:one).to_param
    end

    assert_redirected_to true_portraits_path
  end
end
