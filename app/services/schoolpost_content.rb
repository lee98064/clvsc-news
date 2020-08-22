require "net/http"
require 'open-uri'
require 'fileutils'
class SchoolpostContent
    def get
        path = Rails.root.join('public', 'schoolposts')
        Dir.mkdir(path) unless Dir.exist?(path)
        Dir.mkdir(path.join('files')) unless Dir.exist?(path.join('files'))
        posts = Schoolpost.where("id > 82 and id < 87")
        posts.each do |post|
            url = URI(post.link)
            response = Net::HTTP.get(url)
            source = Nokogiri::HTML(response)
            post.content = source.xpath("//div[@class='ptcontent clearfix floatholder']").to_html
            postfiles = source.xpath("//div[@class='module module-ptattach pt_style1']/div[@class='md_middle' and 2]/div[@class='mm_03' and 1]/div[@class='mm_02' and 1]/div[1]//span//a")
            postimages = source.xpath("//div[@class='ptcontent clearfix floatholder']//img")
            path = Rails.root.join('public', 'schoolposts', 'files', post.id.to_s)
            postfiles.each do |postfile|
                Dir.mkdir(path) unless Dir.exist?(path)
                begin
                    if postfile['href'] == "javascript:void(0)"
                        filelink = postfile['onfocus'].split("'")[3]
                    else
                        filelink = postfile['href']
                    end
                    File.open(path + postfile.text, "wb") do |file|
                        file.write open("http://www.clvsc.tyc.edu.tw" + filelink).read
                    end
                    Schoolpostfile.find_or_create_by(name: postfile.text, schoolpost_id: post.id, link: "http://www.clvsc.tyc.edu.tw" + postfile['href'])
                rescue
                    p "------錯誤------"
                    p "http://www.clvsc.tyc.edu.tw" + postfile['href']
                end
           end
           path = Rails.root.join('public', 'schoolposts', 'images')
           Dir.mkdir(path) unless Dir.exist?(path)
           postimages.each do |postimage|
                Dir.mkdir(path.join(post.id.to_s)) unless Dir.exist?(path.join(post.id.to_s))
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
            post.save
        end
    end
end