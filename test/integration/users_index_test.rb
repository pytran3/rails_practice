require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin     = users(:michael)
    @non_admin = users(:archer)
  end

  test "index including pagination" do
    log_in_as(@non_admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', 2
    assert_match @non_admin.following.count.to_s, response.body
    assert_match @non_admin.followers.count.to_s, response.body
    User.paginate(page: 1).select {|u| u.activated?}.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.paginate(page: 1).select {|u| u.activated?}
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

  test "index with unactivated user" do
    log_in_as(@non_admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.paginate(page: 1).select {|u| !u.activated?}
    assert first_page_of_users.length > 0
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), 0
    end
  end
end