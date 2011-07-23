When /^I register for an account$/ do
  visit users_register_path
  fill_in "Username", :with => "dangermouse"
  fill_in "Email", :with => "dm@stoptask.com"
  fill_in "Password", :with => "topsecret"
  click_button "Register"
end

Then /^I should be able to log in$/ do
  visit users_login_path
  fill_in "Username", :with => "dangermouse"
  fill_in "Password", :with => "topsecret"
  click_button "Log in"
end
