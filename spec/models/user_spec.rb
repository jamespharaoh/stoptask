require "spec_helper"

describe User do

  it "is valid with valid fields" do
    user = User.new :username => "dangermouse", :password => "topsecret", :email => "dm@stoptask.com"
    user.should be_valid
  end

  it "is not valid with a bad username" do
    user = User.new :username => "!", :password => "topsecret", :email => "dm@stoptask.com"
    user.should_not be_valid
  end

  it "is not valid with a bad email" do
    user = User.new :username => "dangermouse", :password => "topsecret", :email => "@"
    user.should_not be_valid
  end

  it "is not valid without a password" do
    user = User.new :username => "dangermouse", :email => "dm@stoptask.com"
    user.should_not be_valid
  end

  it "has a random password salt" do
    user = User.new :username => "dangermouse", :password => "topsecret", :email => "dm@stoptask.com"
    user.password_salt.should match /^[a-z]{16}$/
  end

  it "has a valid password hash" do
    user = User.new :username => "dangermouse", :password => "topsecret", :email => "dm@stoptask.com"
    expected_hash = Digest::SHA1.hexdigest "#{user.password_salt}:topsecret"
    user.password_hash.should eq expected_hash
  end

  it "is invalid without a unique username" do
    user_1 = User.new :username => "dangermouse", :password => "topsecret", :email => "dm1@stoptask.com"
    user_1.save
    user_2 = User.new :username => "dangermouse", :password => "topsecret", :email => "dm2@stoptask.com"
    user_2.should_not be_valid
  end

  it "is invalid without a unique email" do
    user_1 = User.new :username => "dangermouse_1", :password => "topsecret", :email => "dm@stoptask.com"
    user_1.save
    user_2 = User.new :username => "dangermouse_2", :password => "topsecret", :email => "dm@stoptask.com"
    user_2.should_not be_valid
  end

  it "always returns a nil password" do
    user = User.new :username => "dangermouse", :password => "topsecret", :email => "dm@stoptask.com"
    user.password.should be_nil
  end

  describe "#check_password" do

    it "returns false if there is no password set" do
      user = User.new :username => "dangermouse", :email => "dm@stoptask.com"
      user.check_password("topsecret").should be_false
    end

    it "returns false if the password doesn't match" do
      user = User.new :username => "dangermouse", :password => "topsecret", :email => "dm@stoptask.com"
      user.check_password("fifi").should be_false
    end

    it "returns false if the password matches" do
      user = User.new :username => "dangermouse", :password => "topsecret", :email => "dm@stoptask.com"
      user.check_password("topsecret").should be_true
    end

  end

end
