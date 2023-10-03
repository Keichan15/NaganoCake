class Public::CartItemsController < ApplicationController
  # before_action :correct_amount, only: [:create]
  def index
    @cart_items = current_customer.cart_items.all
    @total = @cart_items.inject(0){ | sum, item | sum + item.subtotal}
  end

  def create
    if params[:cart_item][:amount].empty? || !customer_signed_in?# 数量選択しなかった時(include_black: trueにしていた場合)
      redirect_back(fallback_location: root_path)
    else
      if current_customer.cart_items.find_by(item_id: params[:cart_item][:item_id])
        # 存在していた場合…
        @cart_item = current_customer.cart_items.find_by(item_id: params[:cart_item][:item_id])
        # 元々カートに登録されてる数量+フォームで選択した数量
        @cart_item.amount += cart_item_params[:amount].to_i
        @cart_item.update(amount: @cart_item.amount)
        redirect_to cart_items_path
      else
        # 存在しなかった場合…
        @cart_item = CartItem.new(cart_item_params)
        @cart_item.customer_id = current_customer.id
        @cart_item.save
        redirect_to cart_items_path
      end
    # 追加した商品がカート内に存在するかの判別
    end
  end

  def update
    @cart_item = CartItem.find(params[:id])
    @cart_item.amount = cart_item_params[:amount].to_i
    @cart_item.update(amount: @cart_item.amount)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    # 選択したカート内商品1つだけを削除
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    redirect_back(fallback_location: root_path)
  end

  def destroy_all
    # ログイン中顧客のカート内商品を全削除
    current_customer.cart_items.destroy_all
    redirect_back(fallback_location: root_path)
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:item_id, :amount)
  end

  # def correct_amount
  #   redirect_back(fallback_location: root_path) if params[:cart_item][:amount] == ""
  # end
end
