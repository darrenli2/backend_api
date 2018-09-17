require 'rails_helper'

RSpec.describe User, type: :model do
  it "returns errors if email is invalid" do
    user = User.new(email: 'abc')
    user.save
    expect(user.errors.messages[:email]).to eq(["is invalid"])
  end

  it "returns errors if password is blank" do
    user = User.new(email: 'abc@m.com')
    user.save
    expect(user.errors.messages[:password]).to eq(["can't be blank"])
  end

  it "returns errors if password is too short" do
    user = User.new(email: 'abc@a.com', password: 'as')
    user.save
    expect(user.errors.messages[:password]).to eq(["is too short (minimum is 6 characters)"])
  end

  it "returns errors if password is too long" do
    user = User.new(email: 'abc@a.com', password: 'sasasdsadsassasasdsadsassasasdsadsassasasdsadsassasasdsadsassasasdsadsassasasdsadsassasasdsadsassasasdsadsassasasdsadsassasasdsadsassasasdsadsas')
    user.save
    expect(user.errors.messages[:password]).to eq(["is too long (maximum is 128 characters)"])
  end

  it "returns errors if password confirmation is missing" do
    user = User.new(email: 'abc@a.com', password: 'password')
    user.save
    expect(user.errors.messages[:password_confirmation]).to eq(["can't be blank"])
  end

  it "returns errors if password and password_confirmation don't match" do
    user = User.new(email: 'abc@a.com', password: 'password', password_confirmation: 'dsds')
    user.save
    expect(user.errors.messages[:password_confirmation]).to eq(["doesn't match Password"])
  end

  it "creates a user with valid email ,password and password_confirmation" do
    user = User.new(email: 'abc@a.com', password: 'password', password_confirmation: 'password')
    expect(user.save).to eq(true)
  end
end
