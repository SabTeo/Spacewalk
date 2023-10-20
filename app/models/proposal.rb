class Proposal < ActiveRecord::Base
    belongs_to :user
    has_many :notifications, dependent: :destroy

    validates :title, presence: true
    validates :body, presence: true
    #validates :img_url,
    #        format: {
    #          with: URI.regexp(%w[http https]),
    #          message: "L'URL dell'immagine non è valido, deve iniziare con http"
    #        }
end