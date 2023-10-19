class Proposal < ActiveRecord::Base
    belongs_to :user
    has_many :notifications, dependent: :destroy

    validates_length_of :title, :maximum => 20, :message => "Massimo 20 caratteri per il titolo"
    validates :body, presence: true
    validates :img_url,
            format: {
              with: URI.regexp(%w[http https]),
              message: "L'URL dell'immagine non è valido, deve iniziare con http"
            }
end