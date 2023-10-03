class Admin::OrderDetailsController < ApplicationController

  def update
    @order = Order.find(params[:order_id]) # 該当注文データを代入
    @order_detail = @order.order_details.find(params[:id]) # 該当注文の注文詳細テーブルに保存されているレコードを取得
    if @order_detail.update(order_detail_params) && @order_detail.under_manufacture?
      @order.under_manufacture!
    elsif @order.are_all_details_completed?
      @order.preparing_to_ship!
    end
    redirect_back(fallback_location: root_path)

    # ↓ 6行目から元々記載していた記述
    # sum = 0
    # @order_detail.update(order_details_params)

    # if @order_detail.making_status == "under_manufacture"
    #   @order.status = "under_manufacture"
    #   @order.update(status: @order.status)
    # end

    # @order.order_details.each do |order_detail|
    #   if order_detail.making_status == "completed_production"
    #     sum += 1
    #   end
    # end

    # if sum == @order.order_details.size
    #   @order.status = "preparing_to_ship"
    #   @order.update(status: @order.status)
    # end
  end

  private

  def order_detail_params
    params.require(:order_detail).permit(:making_status)
  end
end
