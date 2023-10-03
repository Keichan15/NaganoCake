class Order < ApplicationRecord
  enum payment_method: { credit_card: 0, transfer: 1 }
  enum status: { awaiting_payment: 0, payment_confirmation: 1, under_manufacture: 2, preparing_to_ship: 3, already_shipped: 4 }

  belongs_to :customer
  has_many :order_details, dependent: :destroy

  default_scope -> { order(created_at: :desc) }

  def are_all_details_completed?
    (order_details.completed_production.count == order_details.count) ? true : false # 製作ステータスが"製作完了"の数と注文詳細のレコードの数が一緒なら

    # if order_details.completed_production.count == order_details.count
    #   true
    # else
    #   false
    # end
    # と同じ!
  end

  def address_display
    '〒' + postal_code + ' ' + address + ' ' + name
  end
end
