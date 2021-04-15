class Url < ApplicationRecord
    belongs_to :user

    validates :long_url, presence: true, length: { minimum: 10}, format: URI::regexp(%w[http https])
    validates :short_url, uniqueness: true
   
    def self.search(inquiry, uid)
        inquiry.strip!
        if inquiry.length < 8 
            return nil
        end
        # Get the last 8 letters of the string
        code = inquiry[-8..-1]
        inquiry = "https://shtnr/" + code
        return Url.where(user_id: uid).where(short_url: inquiry)
    end
end
