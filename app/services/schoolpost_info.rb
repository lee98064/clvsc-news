require "net/http"
require 'open-uri'
class SchoolpostInfo

    def get
        catalogs = Catalog.where(update_everyday: true)
        catalogs.each do |catalog|
            url = URI(catalog.link)
            begin
                response = Net::HTTP.get(url)
                source = Nokogiri::HTML(response)
                posts = source.xpath("//span[contains(@class,'ptname')]")
                nextpage = source.xpath("//a[contains(@class,'pagenum') and contains(text(),'下一頁')]")
                posts.each do |post|
                    link = post.xpath("./a/@href").text
                    title = post.xpath("./a").text
                    # schoolpost = Schoolpost.find_or_initialize_by(link: link)
                    schoolpost = Schoolpost.find_or_initialize_by(title: title)
                    schoolpost.title = title
                    schoolpost.catalog_id = catalog.id
                    begin
                        schoolpost.publishdate = Time.parse(post.xpath("../span[contains(@class,'date')]").text).to_date
                    rescue
                        "無日期"
                    end
                    schoolpost.save
                end
                url = URI(nextpage[0]['href']) unless nextpage.empty?
            end until nextpage.empty?
        end
        SchoolpostInfo.new.get
        SchoolpostImage.new.get
        SchoolpostFile.new.get
    end
end