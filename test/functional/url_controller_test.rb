require 'test_helper'

class UrlControllerTest < ActionController::TestCase
  test "should get gen" do
    get :gen
    assert_response :success
  end

end
