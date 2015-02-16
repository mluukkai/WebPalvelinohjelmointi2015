require 'rails_helper'

describe "User" do
  before :each do
    FactoryGirl.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with:'Brian')
    fill_in('user_password', with:'Secret55')
    fill_in('user_password_confirmation', with:'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  it "when user has made ratings, favorite beer, style and brewery are shown on user page" do
    user = User.first
    brewery = FactoryGirl.create(:brewery, name:"Koff")
    create_beer_with_rating(10, user, brewery, "Ale")
    create_beer_with_rating(25, user, brewery, "IPA")

    brewery2 = FactoryGirl.create(:brewery, name:"Sierra Nevada")
    best = create_beer_with_rating(30, user, brewery2, "IPA")
    create_beer_with_rating(20, user, brewery2, "Lager")

    brewery3 = FactoryGirl.create(:brewery, name:"Hartwall")
    create_beer_with_rating(15, user, brewery3, "Pils")
    create_beer_with_rating(12, user, brewery3, "Lager")

    visit user_path(user.id)

    expect(page).to have_content 'Favorite brewery: Sierra Nevada'
    expect(page).to have_content 'Favorite style: IPA'
  end
end