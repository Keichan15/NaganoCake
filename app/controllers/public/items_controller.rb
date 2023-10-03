class Public::ItemsController < ApplicationController
  def index
    @genres = Genre.all
    if params[:genre_id] # ジャンル検索機能の実装
      @genre = @genres.find(params[:genre_id]) #link_toのURLパラメータで拾ったジャンルID
      all_items = @genre.items
    else
      all_items = Item.where(is_active: true)
    end
    @items = all_items.page(params[:page])
    @all_items_count = all_items.count
  end

  def show
    @item = Item.find(params[:id])
    @cart_item = CartItem.new
    @genres = Genre.all
  end
end
