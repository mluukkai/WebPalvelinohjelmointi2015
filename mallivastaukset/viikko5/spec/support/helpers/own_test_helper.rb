module OwnTestHelper

  def sign_in(credentials)
    visit signin_path
    fill_in('username', with:credentials[:username])
    fill_in('password', with:credentials[:password])
    click_button('Log in')
  end

  def create_beer_with_rating(score, user, brewery=nil, style=nil)
    brewery ||= FactoryGirl.create(:brewery)
    if style.nil?
      style = FactoryGirl.create(:style)
    elsif style.is_a? String
      style = FactoryGirl.create(:style, name: style)
    end

    beer = FactoryGirl.create(:beer, brewery: brewery, style: style)
    FactoryGirl.create(:rating, score: score, beer: beer, user: user)
    beer
  end

  def create_beers_with_ratings(*scores, user, brewery, style)
    scores.each do |score|
      create_beer_with_rating(score, user, brewery)
    end
  end

end