require "spec_helper"

describe UsersController do

  describe "GET index" do
    it "is successful" do
      get :index
      response.should be_success
    end
  end

  describe "GET register" do

    it "is successful" do
      get :register
      response.should be_success
    end

  end

  describe "POST register" do

    def user_fields
      {
        "username" => "dangermouse",
        "password" => "topsecret",
        "email" => "dangermouse@stoptask.com",
      }
    end

    let(:user_model) { mock_model(User).as_null_object }

    before do
      User.stub(:new).and_return(user_model)
    end

    it "creates a user" do
      User.should_receive(:new)
      post :register, :user => user_fields
    end

    it "saves the user" do
      user_model.should_receive(:save)
      post :register, :user => user_fields
    end

    it "flashes a message" do
      post :register, :user => user_fields
      flash[:notice].should eq "New user registered"
    end

    it "redirects to index" do
      post :register, :user => user_fields
      response.should redirect_to :action => :index
    end

  end

  describe "GET login" do
    it "is successful" do
      get :login
      response.should be_success
    end
  end

  describe "POST login" do

    before do
      user_params = {
        username: "dangermouse",
        password: "topsecret",
        email: "dm@stoptask.com",
      }
      user = User.new user_params
      user.save
    end

    context "with a non-existant user" do

      it "is successful" do
        post :login, "username" => "penfold", "password" => ""
        response.should be_success
      end

      it "flashes a message" do
        post :login, "username" => "penfold", "password" => ""
        flash[:notice].should eq "Username not recognised"
      end

    end

    context "with an invalid password" do

      it "is successful" do
        post :login, "username" => "dangermouse", "password" => "fifi"
        response.should be_success
      end

      it "flashes a message" do
        post :login, "username" => "dangermouse", "password" => "fifi"
        flash[:notice].should eq "Password incorrect"
      end

    end

    context "with correct details" do

      it "flashes a message" do
        post :login, "username" => "dangermouse", "password" => "topsecret"
        flash[:notice].should eq "Logged in successfully"
      end

      it "sets username in session" do
        post :login, "username" => "dangermouse", "password" => "topsecret"
        session[:username].should eq "dangermouse"
      end

      it "redirects to index" do
        post :login, "username" => "dangermouse", "password" => "topsecret"
        response.should redirect_to :action => :index
      end

    end
    
  end

end
