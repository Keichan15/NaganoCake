class OrderDetail < ApplicationRecord
  enum making_status: { cannot_be_started: 0, awaiting_manufacture: 1, under_manufacture: 2, completed_production: 3 }

  belongs_to :item
  belongs_to :order
end
