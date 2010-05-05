require 'test_helper'

class EvaluationCitationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:evaluation_citations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create evaluation_citation" do
    assert_difference('EvaluationCitation.count') do
      post :create, :evaluation_citation => { }
    end

    assert_redirected_to evaluation_citation_path(assigns(:evaluation_citation))
  end

  test "should show evaluation_citation" do
    get :show, :id => evaluation_citations(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => evaluation_citations(:one).to_param
    assert_response :success
  end

  test "should update evaluation_citation" do
    put :update, :id => evaluation_citations(:one).to_param, :evaluation_citation => { }
    assert_redirected_to evaluation_citation_path(assigns(:evaluation_citation))
  end

  test "should destroy evaluation_citation" do
    assert_difference('EvaluationCitation.count', -1) do
      delete :destroy, :id => evaluation_citations(:one).to_param
    end

    assert_redirected_to evaluation_citations_path
  end
end
