require 'net/http'
module RESTMapper
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    def base_url url
        @BASE_URL = url
    end
    def fetch_from_internet req
      raise "No base_url specified" if @BASE_URL == nil
    	Net::HTTP.start(@BASE_URL) do |http|
    		return http.get(req).body
    	end
    end
    def get(name, url, defaults={},&block)
      self.class.send(:define_method,name.to_sym) do |values|
        newurl = url.dup
        values.each do |key,value|
          newurl.gsub!(':'+key.to_s,value.to_s.gsub(" ","%20"))
        end
        defaults.each do |key,value|
          newurl.gsub!(':'+key.to_s,value.to_s.gsub(" ","%20"))
        end
        result = self.fetch_from_internet(newurl)
        return block.call(result) if block
        return result
      end
    end 
         
  end
end