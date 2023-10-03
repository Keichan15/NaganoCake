class Public::HomesController < ApplicationController

  def top
    @genres = Genre.all
    reverse_items = Item.order(id: "DESC")
    @items = reverse_items.last(4)
  end
end
