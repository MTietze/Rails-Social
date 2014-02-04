require 'spec_helper'
 
describe UserMailer do
  
    let(:user) { FactoryGirl.create(:user) }

  describe 'new_follower' do
    let(:otheruser) { FactoryGirl.create(:user) }
    let(:mail) { UserMailer.new_follower(user, otheruser) }
 
    #ensure that the subject is correct
    it 'renders the subject' do
      mail.subject.should == 'New Follower'
    end
 
    #ensure that the receiver is correct
    it 'renders the receiver email' do
      mail.to.should == [user.email]
    end
 
    #ensure that the sender is correct
    it 'renders the sender email' do
      mail.from.should == ['maxwelltietze@gmail.com']
    end
 
    #ensure that the @user variable appears in the email body
    it 'assigns @user' do
      mail.body.encoded.should match(user.name)
    end
 
    #ensure that the @follower variable appears in the email body
    it 'assigns @follower' do
      mail.body.encoded.should match(otheruser.name)
    end
  end

  describe "password_reset" do
    let(:mail) { UserMailer.password_reset(user) }

    it "sends user password reset url" do
      mail.subject.should eq("Password Reset")
      mail.to.should eq([user.email])
      mail.from.should eq(["maxwelltietze@gmail.com"])
      mail.body.encoded.should match(edit_password_reset_path(user.remember_token))
    end
  end

  describe "confirm" do
    let(:mail) { UserMailer.confirm(user) }

    it "sends user confirmation url" do
      mail.subject.should eq("Confirm New User")
      mail.to.should eq([user.email])
      mail.from.should eq(["maxwelltietze@gmail.com"])
      mail.body.encoded.should match(confirm_user_path(user.remember_token))
    end
  end
end