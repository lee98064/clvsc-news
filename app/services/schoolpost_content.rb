require "net/http"
require 'open-uri'
require 'fileutils'
class SchoolpostContent
    def get
        posts = Schoolpost.where("publishdate >= '2020-06-01'")
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