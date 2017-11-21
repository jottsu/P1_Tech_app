class Post < ApplicationRecord

  validates :title, presence: true, length: { maximum: 30 }
  validates :outline, presence: true, length: { maximum: 50 }
  validates :detail, presence: true, length: { maximum: 200 }
  validates :private_flag, presence: true
  validates :status, presence: true
  validates :num_of_planner, presence: true
  validates :num_of_engineer, presence: true
  validates :num_of_designer, presence: true
  validates :num_of_graphicer, presence: true

  belongs_to :template

end
