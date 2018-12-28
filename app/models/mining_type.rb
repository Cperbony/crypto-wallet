class MiningType < ApplicationRecord
  has_many :coins
  #class_name: "coin", foreign_key: "reference_id"
end
