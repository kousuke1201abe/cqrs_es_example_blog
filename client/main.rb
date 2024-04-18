require 'webrick'
require 'faraday'
require 'json'

class Servlet < WEBrick::HTTPServlet::AbstractServlet
    def initialize(server, query_conn, command_conn)
        super(server, query_conn, command_conn)
        @query_conn = query_conn
        @command_conn = command_conn
    end

    def do_GET(req, res)
        path = req.path.split('/')
        case path[1]
        when "articles"
            case path[-1]
            when "index"
                response = @query_conn.get do |r|
                    r.url '/articles/index'
                end
                @articles = JSON.parse(response.body)["result"]
                @executor_id = req.query["executor_id"]
                res.body = ERB.new(File.read('pages/articles/index.html.erb')).result(binding)
            when "new"
                @executor_id = req.query["executor_id"]
                res.body = ERB.new(File.read('pages/articles/new.html.erb')).result(binding)
            when "edit"
                response = @query_conn.get do |r|
                    r.url "/articles/#{path[-2]}"
                end
                @executor_id = req.query["executor_id"]
                @article = JSON.parse(response.body)
                res.body = ERB.new(File.read('pages/articles/edit.html.erb')).result(binding)
            when "published"
                @executor_id = req.query["executor_id"]
                res.body = ERB.new(File.read('pages/articles/published.html.erb')).result(binding)
            else
                response = @query_conn.get do |r|
                    r.url "/articles/#{path[-1]}"
                end
                @executor_id = req.query["executor_id"]
                @article = JSON.parse(response.body)
                res.body = ERB.new(File.read('pages/articles/show.html.erb')).result(binding)
            end
        end
    end

    def do_POST(req, res)
        path = req.path.split('/')
        case path[1]
        when "articles"
            case path[-1]
            when "publish_request"
                @response = @command_conn.post do |r|
                    r.url '/articles/publish_request'
                    r.body = req.query.to_json
                end
                res.set_redirect(WEBrick::HTTPStatus::MovedPermanently, "/articles/published?executor_id=#{req.query["executor_id"]}")
            when "title_change_request"
                @command_conn.post do |r|
                    r.url '/articles/title_change_request'
                    r.body = req.query.to_json
                end
                response = @query_conn.get do |r|
                    r.url "/articles/#{req.query["article_id"]}"
                end
                @executor_id = req.query["executor_id"]
                @article = JSON.parse(response.body)
                @article["title"] = req.query["title"]
                res.body = ERB.new(File.read('pages/articles/edit.html.erb')).result(binding)
            when "thumbnail_change_request"
                @response = @command_conn.post do |r|
                    r.url '/articles/thumbnail_change_request'
                    r.body = req.query.to_json
                end
                response = @query_conn.get do |r|
                    r.url "/articles/#{req.query["article_id"]}"
                end
                @executor_id = req.query["executor_id"]
                @article = JSON.parse(response.body)
                @article["thumbnail"] = req.query["thumbnail"]
                res.body = ERB.new(File.read('pages/articles/edit.html.erb')).result(binding)
            when "text_change_request"
                @response = @command_conn.post do |r|
                    r.url '/articles/text_change_request'
                    r.body = req.query.to_json
                end
                response = @query_conn.get do |r|
                    r.url "/articles/#{req.query["article_id"]}"
                end
                @executor_id = req.query["executor_id"]
                @article = JSON.parse(response.body)
                @article["text"] = req.query["text"]
                res.body = ERB.new(File.read('pages/articles/edit.html.erb')).result(binding)
            when "bookmark_request"
                @command_conn.post do |r|
                    r.url '/articles/bookmark_request'
                    r.body = req.query.to_json
                end
                response = @query_conn.get do |r|
                    r.url "/articles/#{req.query["article_id"]}"
                end
                @executor_id = req.query["executor_id"]
                @article = JSON.parse(response.body)
                if @article["bookmarkers"].nil?
                    @article["bookmarkers"] = req.query["executor_id"]
                else
                    @article["bookmarkers"] = @article["bookmarkers"] + ",#{req.query["executor_id"]}"
                end
                res.body = ERB.new(File.read('pages/articles/show.html.erb')).result(binding)
            when "unbookmark_request"
                @command_conn.post do |r|
                    r.url '/articles/unbookmark_request'
                    r.body = req.query.to_json
                end
                response = @query_conn.get do |r|
                    r.url "/articles/#{req.query["article_id"]}"
                end
                @executor_id = req.query["executor_id"]
                @article = JSON.parse(response.body)
                bookmarkers_arr = @article["bookmarkers"].split(",")
                bookmarkers_arr.delete(req.query["executor_id"])
                @article["bookmarkers"] = bookmarkers_arr.join(",")
                res.body = ERB.new(File.read('pages/articles/show.html.erb')).result(binding)
            end
        end
    end
end

query_conn = Faraday::Connection.new(:url => 'http://query_api:3001')
command_conn = Faraday::Connection.new(:url => 'http://command_api:3000')
WEBrick::HTTPServlet::FileHandler.add_handler("erb", WEBrick::HTTPServlet::ERBHandler)
server = WEBrick::HTTPServer.new({
    DocumentRoot:   './',
    BindAddress:    '0.0.0.0',
    Port:           4000,
})
server.mount('/', Servlet, query_conn, command_conn)
server.start
