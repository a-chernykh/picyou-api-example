class HomeController < ApplicationController
  CRLF = "\r\n"
  URL = 'http://developer.picyou.dev:3000/api/v1/images.json'

  def index
  end

  def upload
    if params[:url].present?
      res = session[:access_token].post(URL, {'image[remote_file_url]' => params[:url], 'image[filter]' => params[:filter]})
    else
      file = params[:file]
      url = URI.parse(URL)
      Net::HTTP.new(url.host, url.port).start do |http|
        req = Net::HTTP::Post.new(url.request_uri)
        add_multipart_data(req, {'image[file]' => file, 'image[filter]' => params[:filter]})
        add_oauth(req)
        res = http.request(req)
      end
    end
    render :text => res.body
  end

  protected

  # Encodes the request as multipart
  def add_multipart_data(req, params)
    boundary = Time.now.to_i.to_s(16)
    req["Content-Type"] = "multipart/form-data; boundary=#{boundary}"
    body = ""
    params.each do |key,value|
      body << "--#{boundary}#{CRLF}"
      if value.respond_to?(:read)
        body << "Content-Disposition: form-data; name=\"#{key.to_s}\"; filename=\"photo.jpg\"#{CRLF}"
        body << "Content-Type: image/jpeg#{CRLF*2}"
        body << value.read
      else
        body << "Content-Disposition: form-data; name=\"#{key.to_s}\"#{CRLF*2}#{value}"
      end
      body << CRLF
    end
    body << "--#{boundary}--#{CRLF*2}"
    req.body = body
    req["Content-Length"] = req.body.size
  end

  # Uses the OAuth gem to add the signed Authorization header
  def add_oauth(req)
    consumer.sign!(req, session[:access_token])
  end
end
