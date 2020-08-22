require "net/http"
require 'open-uri'
require 'fileutils'
class SchoolpostInfo

    def get
        catalogs = Catalog.all
        catalogs.each do |catalog|
            url = URI(catalog.link)
            response = Net::HTTP.get(url)
            source = Nokogiri::HTML(response)
            posts = source.xpath("//span[contains(@class,'ptname')]")
            posts.each do |post|
                link = post.xpath("./a/@href").text
                schoolpost = Schoolpost.find_or_initialize_by(link: link)
                schoolpost.title = post.xpath("./a").text
                schoolpost.catalog_id = catalog.id
                begin
                    schoolpost.publishdate = Time.parse(post.xpath("../span[contains(@class,'date')]").text).to_date
                rescue
                    "無日期"
                end
                schoolpost.save
            end
        end
        return Schoolpost.all.includes(:catalog)
    end
end