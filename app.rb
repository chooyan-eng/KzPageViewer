require 'net/http'
require 'uri'
require 'kconv'

pages = []
def request_to(path, pages)
  url = URI.parse('https://www.nta.go.jp/')
  resp = Net::HTTP.get(url.host, path)
  title = resp.match(/<title>(.+?)<\/title>/)
  
  unless title.nil? then
    pages.push(path)
    puts("{title: \"" + title[1].toutf8 + "\", url: \"https://www.nta.go.jp" + path + "\"},")
  else
    puts('no title,' + path)
  end

  links = resp.scan(/href=\"(\/.+?\.htm)/)
  unless links.nil? then
    links.each do |link|
      next if pages.include? link[0]

      sleep 1
      request_to(link[0], pages)
    end 
  end 
end

request_to('/', pages)
