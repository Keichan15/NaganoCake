class Public::OrdersController < ApplicationController
  before_action :ensure_cart_items, only: [:new, :confirm, :create]
  def new
    @order = Order.new
  end

  def confirm # ※まだ保存はしていない, あくまでデータを送っているだけ!(saveする必要なし！)
    @order = Order.new(order_params)
    @cart_items = current_customer.cart_items.all
    @total = @cart_items.inject(0){ | sum, item | sum + item.subtotal}
    @order.shipping_cost = 800
    @order.total_payment = @order.shipping_cost + @total # 請求金額計算(送料 + カート内商品の合計)
    # @order.payment_method = params[:order][:payment_method]

    if params[:order][:address_option] == "0" # ご自身の住所 選択時
      @order.postal_code = current_customer.postal_code
      @order.address = current_customer.address
      @order.name = current_customer.last_name + current_customer.first_name
    elsif params[:order][:address_option] == "1" # 配送先の登録済住所から選択 選択時
      @address = Address.find(params[:order][:address_id])
      @order.postal_code = @address.postal_code
      @order.address = @address.address
      @order.name = @address.name
    elsif params[:order][:address_option] == "2" # 新しいお届け先 選択時
    end
  end

  def complete
  end

  def create
    @order = Order.new(order_params)
    @order.customer_id = current_customer.id
    @order.save # ここで初めて指定した各情報を保存

    current_customer.cart_items.each do |cart_item| #注文詳細モデル(order_details)に各注文商品を保存
      @order_detail = OrderDetail.new
      @order_detail.order_id = @order.id
      @order_detail.item_id = cart_item.item_id
      @order_detail.price = cart_item.subtotal
      @order_detail.amount = cart_item.amount
      @order_detail.save
    end
    current_customer.cart_items.destroy_all # カート内商品を全て削除
    redirect_to orders_complete_path
  end

  def index
  end

  def show
  end


  private

  def order_params
    params.require(:order).permit(:customer_id, :postal_code, :address, :name, :shipping_cost, :total_payment, :payment_method)
  end

  def ensure_cart_items
    @cart_items = current_customer.cart_items
    redirect_to cart_items_path unless @cart_items.exists? # カート内商品が存在していなければ一覧へリダイレクト
  end
end
