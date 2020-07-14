require "uri"
require "net/http"
require 'json'

def request(url_address,api_key)
  #Ingresa la url_address
  url = URI("#{url_address}&api_key=#{api_key}")
  
  https = Net::HTTP.new(url.host, url.port);
  https.use_ssl = true

  request = Net::HTTP::Get.new(url)

  response = https.request(request)
  #Retornamos el response del body analizado por el JSON.
  #JSON.parse---> transforma el string del response en otro tipo de estructura de texto (Estructura de texto plano que pueden guardar objetos literales o Array[Hash])
  return JSON.parse(response.read_body)
end

def build_web_page(hash)
  image = [] 
  hash['photos'].each do |img|
    image.push("\t<li><img src='#{img['img_src']}'></li>")
  end
  page_init = "<html>\n<head>\t\n<title>Api Nasa</title>\n</head>\n<body>\n<h1>Fotos del Mars Rover Curiosity</h1>\t\n<h3>Día Solar 120</h3>\n<ul>\n"
  page_end = "\n</ul>\n</body>\n</html>"
  page = "#{page_init}#{image.join("\n")}#{page_end}"
  File.write('index.html',page)
end

def photos_count(hash)
  photos_for_camera = {}
  cameras = hash['photos'].map{|photo| photo['camera']['name']}
  keys = cameras.uniq()
  keys.each do |key|
    quantity = cameras.count(key)
    photos_for_camera[key] = quantity
  end
  return photos_for_camera
end


#API key de la nasa
api_key_nasa = 'RjgXMs8tnj48OHKNnmZiwFA5SvPN22a7KmVjq5oc'
#URL del API de la Nasa para consultar las fotos del mars rovers
url_nasa = 'https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=120'

data = request(url_nasa,api_key_nasa)
build_web_page(data)
print photos_count(data)