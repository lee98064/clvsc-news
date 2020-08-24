require "net/http"
require 'open-uri'
require 'fileutils'
class SchoolpostContent
    def get
        time = Time.new
        time = time - 10.day
        # posts = Schoolpost.where("publishdate >= ?", time.strftime("%Y-%m-%d"))
        catalogs = Catalog.includes(:schoolposts).where(update_everyday: true)
        catalogs.each do |catalog|
            catalog.try(:schoolposts).each do |post|
                break if post.publishdate < time
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
end