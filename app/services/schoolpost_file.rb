require "net/http"
require 'open-uri'
require 'fileutils'
class SchoolpostFile

    def get
        time = Time.new
        time = time - 30.day
        path = Rails.root.join('public', 'schoolposts')
        Dir.mkdir(path) unless Dir.exist?(path)
        Dir.mkdir(path.join('files')) unless Dir.exist?(path.join('files'))
        posts = Schoolpost.where("publishdate >= ?", time.strftime("%Y-%m-%d"))
        posts.each do |post|
            begin
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
                        Schoolpostfile.find_or_create_by(name: postfile.text, schoolpost_id: post.id, link: "http://www.clvsc.tyc.edu.tw" + filelink)
                    rescue
                        p "------錯誤------"
                        p "http://www.clvsc.tyc.edu.tw" + postfile['href']
                    end
                end
            rescue
                p "------錯誤------"
                p "編號:" + post.id.to_s
            end
            
        end
    end
end