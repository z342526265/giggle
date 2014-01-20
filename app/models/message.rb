class Message < ActiveRecord::Base

  belongs_to :messageable, polymorphic: true, counter_cache: true
  belongs_to :user

  validates :content, presence: true, length: { maximum: 250 }
  validates :messageable_type, inclusion: { in: %w(Product Evaluate),
                                            message: "%{value} is not a valid type" }

  TYPE_NAME = {"Product"=>"产品", "Evaluate"=>"评测"}

  def messageable_cn
    TYPE_NAME[self.messageable_type] 
  end

  def messageable_name
    case self.messageable_type
    when "Product"
      self.messageable.try(:name)
    when "Evaluate"
      self.messageable.try(:title)
    end
  end

  def self.per_page
    25
  end

  def self.message_search this_params
    message = Message.all
    products_ids = Product.where("name LIKE ?", "%#{this_params[:product]}%").map(&:id) if this_params[:product].present?
    evaluates_ids = Evaluate.where("title LIKE ?", "%#{this_params[:evaluate]}%").map(&:id) if this_params[:evaluate].present?
    users_ids = User.where("name LIKE ?", "%#{this_params[:user]}%").map(&:id) if this_params[:user].present?
    message = message.where("content LIKE ?", "%#{this_params[:content]}%") if this_params[:content].present?
    message = message.where("messageable_type = 'Product' AND messageable_id = ?", products_ids) if this_params[:product].present?
    message = message.where("messageable_type = 'Evaluate' AND messageable_id = ?", evaluates_ids) if this_params[:evaluate].present?
    message = message.where(user_id: users_ids) if this_params[:user].present?
    message = message.where(messageable_type: this_params[:sort]) if this_params[:sort].present?
    message
  end
end
