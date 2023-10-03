class Admin::ItemsController < ApplicationController
  def index
    @items = Item.all
  end

  def new
    @item = Item.new
    @genres = Genre.all
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to admin_item_path(@item)
    else
      render :new
    end
  end

  def show # 研修要件に無い部分
    @item = Item.find(params[:id])
  end

  def edit # 研修要件に無い部分
    @item = Item.find(params[:id])
    @genres = Genre.all
  end

  def update # 研修要件に無い部分
    @item = Item.find(params[:id])
    if @item.update(item_params)
      redirect_to admin_item_path(@item.id)
    else
      render :edit
    end
  end

  # 商品検索機能(部分一致) 新たにsearchアクションを定義
  def search
    if params[:name].present?
      @items = Item.where('name LIKE ?', "%#{params[:name]}%")
    else
      @items = Item.all
    end
  end

  private

  def item_params
    params.require(:item).permit(:genre_id, :name, :introduction, :price, :is_active, :image, :content)
  end
end
