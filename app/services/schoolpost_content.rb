require "net/http"
require 'open-uri'
require 'fileutils'
class SchoolpostContent
    def get
        time = Time.new
        time = time - 30.day
        posts = Schoolpost.where("publishdate >= ?", time.strftime("%Y-%m-%d"))
        posts.each do |post|
            begin
                url = URI(post.link)
                response = Net::HTTP.get(url)
                source = Nokogiri::HTML(response)
                post.content = source.xpath("//div[@class='ptcontent clearfix floatholder']").to_html
                post.save
            rescue
                p "------錯誤------"
                p "編號:" + post.id.to_s
            end
        end
    end
end