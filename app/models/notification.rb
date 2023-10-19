class Notification < ApplicationRecord
    belongs_to :admin, class_name: "User", foreign_key: :admin_id
    belongs_to :proposal
end
