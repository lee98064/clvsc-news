require "net/http"
require 'open-uri'
require 'fileutils'
class SchoolpostImage
    def get
        path = Rails.root.join('public', 'schoolposts')
        Dir.mkdir(path) unless Dir.exist?(path)
        Dir.mkdir(path.join('images')) unless Dir.exist?(path.join('images'))
        # posts = Schoolpost.where("publishdate >= '2020-06-01'")
        posts = Schoolpost.all
        posts.each do |post|
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