require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'John Doe',
                     email: 'john@email.com',
                     password: 'foobar',
                     password_confirmation: 'foobar')
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'name should be present' do
    @user.name = '          '
    assert_not @user.valid?
  end

  test 'email should be present' do
    @user.email = '        '
    assert_not @user.valid?
  end

  test 'name should not be too long' do
    @user.name = 'a' * 51
    assert @user.invalid?
  end

  test 'email should not be too long' do
    @user.email = 'a' * 256 + '@email.com'
    assert @user.invalid?
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w[user@example.com
                         USER@foo.COM
                         A_US-ER@foo.bar.org
                         first.last@foo.jp
                         alice+bob@baz.cn]

    valid_addresses.each do |address|
      @user.email = address
      assert @user.valid?, "#{address} should be valid"
    end
  end

  test 'email validation should reject invalid addresses' do
    invalid_addresses = %w[user@example,com
                           user_at_foo.COM
                           user.name@example.foo@bar_baz.com
                           foo@bar+baz.com]

    invalid_addresses.each do |address|
      @user.email = address
      assert @user.invalid?, "#{address} should be invalid"
    end
  end

  test 'email addresses should be unique' do
    duplicate_user = @user.dup
    @user.save
    assert duplicate_user.invalid?
  end

  test 'email addresses should be save as lower-case' do
    mixed_case_email = 'Foo@ExAMPle.CoM'

    @user.email = mixed_case_email
    @user.save

    assert_equal mixed_case_email.downcase, @user.email
  end

  test 'password should be present (nonblank)' do
    @user.password = @user.password_confirmation = ' ' * 6
    assert @user.invalid?
  end

  test 'password should have a minimum length' do
    @user.password = @user.password_confirmation = 'a' * 5
    assert @user.invalid?
  end

  test 'associated microposts should be destroyed' do
    @user.save
    @user.microposts.create!(content: 'Lorem ipsum')

    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test 'should follow and unfollow a user' do
    michael = users(:michael)
    archer = users(:archer)

    assert_not michael.following? archer

    michael.follow archer
    assert michael.following? archer
    assert archer.followers.include? michael

    michael.unfollow archer
    assert_not michael.following? archer
  end
end