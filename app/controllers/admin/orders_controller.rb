class Admin::OrdersController < ApplicationController

  def index
    @orders = Order.all
  end

  def show
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(order_params) && @order.status_before_type_cast == 1 # @orderがアプデできて, かつ 注文ステータスが "入金確認" (1)になった時
      # before_type_castでinteger型にcastする
      @order.order_details.update_all(making_status: 1) # 注文詳細の全製作ステータスを "製作待ち" (1)に変更
    end
    redirect_back(fallback_location: root_path)
    ## 方法としてはアリだけど見栄え悪い
    ## if @order.status == "payment_confirmation" # もし注文ステータスが "入金確認" だったら
    ##  @order.order_details.each do |order_detail| # 注文詳細に保存されている全商品をeachで回す
    ##    order_detail.making_status = "awaiting_manufacture" # 製作ステータスを "製作待ち" に変更
    ##    order_detail.update(making_status: order_detail.making_status)
    ##  end
    ## end
  end

  private

  def order_params
    params.require(:order).permit(:status)
  end
end
