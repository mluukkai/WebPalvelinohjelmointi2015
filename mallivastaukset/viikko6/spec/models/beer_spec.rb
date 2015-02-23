require 'rails_helper'

RSpec.describe Beer, :type => :model do
  it "is saved with name and style" do
    style = Style.new name: "Lager"
    beer = Beer.create name: "Karhu", style: style

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "is not saved without a name" do
    style = Style.new name: "Lager"
    beer = Beer.create style: style

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved without a style" do
    beer = Beer.create name: "Karhu"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end
