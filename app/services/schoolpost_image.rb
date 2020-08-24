require "net/http"
require 'open-uri'
require 'fileutils'
class SchoolpostImage
    def get
        time = Time.new
        time = time - 10.day
        path = Rails.root.join('public', 'schoolposts')
        Dir.mkdir(path) unless Dir.exist?(path)
        Dir.mkdir(path.join('images')) unless Dir.exist?(path.join('images'))
        # posts = Schoolpost.includes(:catalog).where("publishdate >= ? AND catalogs.update_everyday = true", time.strftime("%Y-%m-%d"))
        catalogs = Catalog.includes(:schoolposts).where(update_everyday: true)
        catalogs.each do |catalog|
            catalog.try(:schoolposts).each do |post|
                break if post.publishdate < time
                begin
                    url = URI(post.link)
                    response = Net::HTTP.get(url)
                    source = Nokogiri::HTML(response)
                    postimages = source.xpath("//div[@class='ptcontent clearfix floatholder']//img")
                    path = Rails.root.join('public', 'schoolposts', 'images', post.id.to_s)
                    postimages.each do |postimage|
                        Dir.mkdir(path) unless Dir.exist?(path)
                        begin
                            postimagename = postimage['src'].split('/')
                            postimagename = postimagename[postimagename.count - 1]
                            File.open(path + postimagename, "wb") do |file|
                                file.write open("http://www.clvsc.tyc.edu.tw" + postimage['src']).read
                            end
                            Schoolpostimage.find_or_create_by(name: postimagename,link: "http://www.clvsc.tyc.edu.tw" + postimage['src'],schoolpost_id: post.id)
                        rescue
                            p "------錯誤------"
                            p "http://www.clvsc.tyc.edu.tw" + postimage['src']
                        end
                    end
                rescue
                    p "------錯誤------"
                    p "編號:" + post.id.to_s
                end
            end
        end
    end
end