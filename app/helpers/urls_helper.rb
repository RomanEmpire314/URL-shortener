module UrlsHelper
    def generate_short_url
        short_url = "https://shtnr/" + rand(36**8).to_s(36)
        while Url.where(short_url: short_url).exists?
            short_url = "https://shtnr/" + rand(36**8).to_s(36)
        end
        return short_url
    end

    # Clean up the long url to remove whitespace and www
    def clean_up(long_url)
        return long_url.strip
    end

    # def get_8_letters(short_url)
        
    # end
end
