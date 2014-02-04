require 'spec_helper'

describe "PasswordResets" do
    
    subject { page }
    let(:user) { FactoryGirl.create(:user) }

  it "emails user when requesting password reset" do  
    visit root_path
    click_link "password"
    fill_in "Email", :with => user.email
    click_button "Reset Password"
    current_path.should eq(root_path)
    page.should have_content("Email sent")
    last_email.to.should == [user.email]
  end

   it "does not email invalid user when requesting password reset" do
    visit root_path
    click_link "password"
    fill_in "Email", :with => "nobody@example.com"
    click_button "Reset Password"
    current_path.should eq(root_path)
    page.should have_content("Email sent")
    last_email.should be_nil
  end
  
  it "updates the user password when confirmation matches" do
    user.remember_token_sent_at = 1.hour.ago
    user.remember_token = "remember"
    user.save
    visit edit_password_reset_path(user.remember_token)
    fill_in "Password", :with => "foobar"
    click_button "Update Password"
    page.should have_content("Password confirmation doesn't match Password")
    fill_in "Password", :with => "foobar"
    fill_in "Password confirmation", :with => "foobar"
    click_button "Update Password"
    page.should have_content("Password has been reset")
  end

  it "reports when password token has expired" do
    user.remember_token_sent_at = 5.hour.ago
    user.remember_token = "remember"
    user.save
    visit edit_password_reset_path(user.remember_token)
    fill_in "Password", :with => "foobar"
    fill_in "Password confirmation", :with => "foobar"
    click_button "Update Password"
    page.should have_content("Password reset has expired")
  end

  it "raises record not found when password token is invalid" do
    lambda {
      visit edit_password_reset_path("invalid")
    }.should raise_exception(ActiveRecord::RecordNotFound)
  end
end