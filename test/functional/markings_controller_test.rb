require 'test_helper'

class MarkingsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:markings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create marking" do
    assert_difference('Marking.count') do
      post :create, :marking => { }
    end

    assert_redirected_to marking_path(assigns(:marking))
  end

  test "should show marking" do
    get :show, :id => markings(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => markings(:one).to_param
    assert_response :success
  end

  test "should update marking" do
    put :update, :id => markings(:one).to_param, :marking => { }
    assert_redirected_to marking_path(assigns(:marking))
  end

  test "should destroy marking" do
    assert_difference('Marking.count', -1) do
      delete :destroy, :id => markings(:one).to_param
    end

    assert_redirected_to markings_path
  end
end
