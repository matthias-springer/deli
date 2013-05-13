require 'maglev_record'
require 'test_helper'
 
class WelcomeTest < ActionController::TestCase
  def setup
    @controller = WelcomeController.new
  end

  test "should get index" do
    get :index
    assert_response :success
  end
end
