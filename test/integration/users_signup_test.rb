require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user:{ name: "",
                                        email:"user@invalid",
                                        password: "12345",
                                        password_confirmation: "1234"
                                      }
                                }
    end
    assert_template 'users/new'
    assert_select 'div.field_with_errors'
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user:{ name: "Example",
                                        email:"user@example.com",
                                        password: "password",
                                        password_confirmation: "password"
                                      }
                                }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
  end
end
