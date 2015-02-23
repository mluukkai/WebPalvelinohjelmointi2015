require 'rails_helper'
include OwnTestHelper

RSpec.describe User, :type => :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with too sort pasword" do
    user = User.create username:"Pekka", password:"k0e", password_confirmation:"k0e"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with pasword contaning only letters" do
    user = User.create username:"Pekka", password:"letters", password_confirmation:"letters"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer:beer, user:user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beer_with_rating(10, user)
      best = create_beer_with_rating(25, user)
      create_beer_with_rating(7, user)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "rated breweries" do
    let(:user){ FactoryGirl.create(:user) }

    it "has method for determining the list" do
      expect(user).to respond_to(:rated_breweries)
    end

    it "without ratings does not have one" do
      expect(user.rated_breweries).to eq([])
    end

    it "contain all the breweries of rated beers" do
      brewery = FactoryGirl.create(:brewery)
      create_beer_with_rating(10, user, brewery)
      brewery2 = FactoryGirl.create(:brewery)
      create_beer_with_rating(20, user, brewery2)

      expect(user.rated_breweries).to match_array([brewery, brewery2])
    end
  end

  describe "rated styles" do
    let(:user){ FactoryGirl.create(:user) }

    it "has method for determining the list" do
      expect(user).to respond_to(:rated_styles)
    end

    it "without ratings does not have one" do
      expect(user.rated_styles).to eq([])
    end

    it "contain all the styles of rated beers" do
      brewery = FactoryGirl.create(:brewery)
      style1 = FactoryGirl.create(:style)
      style2 = FactoryGirl.create(:style, name:"IPA")

      create_beer_with_rating(10, user, brewery, style1)
      create_beer_with_rating(10, user, brewery, style1)
      create_beer_with_rating(10, user, brewery, style2)

      expect(user.rated_styles).to match_array([style1, style2])
    end
  end

  describe "rating of brewery" do
    let(:user){ FactoryGirl.create(:user) }

    it "has method for determining it" do
      expect(user).to respond_to(:rating_of_brewery)
    end

    it "if one rating, returns the value" do
      brewery = FactoryGirl.create(:brewery, name:"Koff")
      create_beer_with_rating(10, user, brewery)
      brewery2 = FactoryGirl.create(:brewery)
      create_beer_with_rating(20, user, brewery2)

      expect(user.rating_of_brewery(brewery)).to eq(10)
    end

    it "if many ratings, returns their average" do
      brewery = FactoryGirl.create(:brewery, name:"Koff")
      create_beer_with_rating(10, user, brewery)
      create_beer_with_rating(20, user, brewery)
      brewery2 = FactoryGirl.create(:brewery)
      create_beer_with_rating(30, user, brewery2)

      expect(user.rating_of_brewery(brewery)).to eq(15)
    end
  end

  describe "rating of style" do
    let(:user){ FactoryGirl.create(:user) }

    it "has method for determining it" do
      expect(user).to respond_to(:rating_of_style)
    end

    it "if one rating, returns the value" do
      brewery = FactoryGirl.create(:brewery)
      style1 = FactoryGirl.create(:style)
      style2 = FactoryGirl.create(:style, name:"IPA")

      create_beer_with_rating(10, user, brewery, style1)
      brewery2 = FactoryGirl.create(:brewery)
      create_beer_with_rating(20, user, brewery2, style2)

      expect(user.rating_of_style(style1)).to eq(10)
    end

    it "if many ratings, returns their average" do
      brewery = FactoryGirl.create(:brewery)
      style1 = FactoryGirl.create(:style)
      style2 = FactoryGirl.create(:style, name:"IPA")

      create_beer_with_rating(10, user, brewery, style1)
      create_beer_with_rating(20, user, brewery, style1)
      create_beer_with_rating(30, user, brewery, style2)

      expect(user.rating_of_style(style1)).to eq(15)
    end
  end

  describe "favorite brewery" do
    let(:user){ FactoryGirl.create(:user) }

    it "has method for determining it" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the brewery of the only rated if only one rating" do
      brewery = FactoryGirl.create(:brewery, name:"Koff")
      create_beer_with_rating(10, user, brewery)

      expect(user.favorite_brewery).to eq(brewery)
    end

    it "is the brewery with the highest rating average" do
      brewery = FactoryGirl.create(:brewery, name:"Koff")
      create_beer_with_rating(10, user, brewery)
      create_beer_with_rating(20, user, brewery)

      brewery2 = FactoryGirl.create(:brewery, name:"Sierra Nevada")
      create_beer_with_rating(30, user, brewery2)
      create_beer_with_rating(25, user, brewery2)

      brewery3 = FactoryGirl.create(:brewery, name:"Hartwall")
      create_beer_with_rating(15, user, brewery3)
      create_beer_with_rating(12, user, brewery3)

      expect(user.favorite_brewery).to eq(brewery2)
    end
  end

describe "favorite style" do
    let(:user){ FactoryGirl.create(:user) }

    it "has method for determining it" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the style of the only rated if only one rating" do
      style = FactoryGirl.create(:style)

      brewery = FactoryGirl.create(:brewery, name:"Koff")
      create_beer_with_rating(10, user, brewery, style)

      expect(user.favorite_style).to eq(style)
    end

    it "is the style with the highest rating average" do
      style1 = FactoryGirl.create(:style)
      style2 = FactoryGirl.create(:style, name:"IPA")
      style3 = FactoryGirl.create(:style, name:"Pils")

      brewery = FactoryGirl.create(:brewery, name:"Koff")
      create_beer_with_rating(10, user, brewery, style1)
      create_beer_with_rating(25, user, brewery, style2)

      brewery2 = FactoryGirl.create(:brewery, name:"Sierra Nevada")
      create_beer_with_rating(30, user, brewery2, style1)
      create_beer_with_rating(20, user, brewery2, style2)

      brewery3 = FactoryGirl.create(:brewery, name:"Hartwall")
      create_beer_with_rating(15, user, brewery3, style3)
      create_beer_with_rating(12, user, brewery3, style1)

      expect(user.favorite_style).to eq(style2)
    end
  end
end
