class Place
  include ActiveModel::Model

  attr_accessor :id, :name, :status, :reviewlink, :proxylink, :blogmap, :street, :city, :state, :zip, :country, :phone, :overall, :imagecount

  def self.rendered_fields
    [ :status, :street, :city, :zip, :country, :overall ]
  end
end