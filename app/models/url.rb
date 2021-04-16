require 'csv'

class Url < ApplicationRecord
    belongs_to :user

    validates :long_url, presence: true, length: { minimum: 10}, format: URI::regexp(%w[http https])
    validates :short_url, uniqueness: true
   
    def self.search(inquiry, uid)
        inquiry.strip!
        if inquiry.length < 8 
            return nil
        end
        # Users can enter any part of the short url, as long as the last 8 characters are present
        code = inquiry[-8..-1]
        inquiry = "https://shtnr/" + code
        return Url.where(user_id: uid).where(short_url: inquiry)
    end

    def self.to_csv
        attributes = %w{short_url long_url num_clicks}
    
        CSV.generate(headers: true) do |csv|
          csv << attributes
    
          all.each do |url|
            csv << attributes.map{ |attr| url.send(attr) }
          end
        end
      end
end
