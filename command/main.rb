require 'webrick'
require 'mysql2'
require './processor/article_processor.rb'
require './infrastructure/mysql/article_repository.rb'
require 'json'

class Servlet < WEBrick::HTTPServlet::AbstractServlet
    def initialize(server, processor)
        super(server, processor)
        @processor = processor
    end

    def do_POST(req, res)
        path = req.path.split('/')
        case path[1]
        when "articles"
            case path[-1]
            when "publish_request"
                begin
                    puts("publish_request started")
                    body = JSON.parse(req.body)
                    @processor.publish(body["title"], body["thumbnail"], body["text"], body["executor_id"])
                    res.status = 200
                    return
                rescue
                    res.status = 500
                    return
                end
            when "title_change_request"
                begin
                    puts("title_change_request started")
                    body = JSON.parse(req.body)
                    @processor.change_title(body["article_id"], body["title"], body["executor_id"])
                    res.status = 200
                    return
                rescue
                    res.status = 500
                    return
                end
            when "thumbnail_change_request"
                begin
                    puts("thumbnail_change_request started")
                    body = JSON.parse(req.body)
                    @processor.change_thumbnail(body["article_id"], body["thumbnail"], body["executor_id"])
                    res.status = 200
                    return
                rescue
                    res.status = 500
                    return
                end
            when "text_change_request"
                begin
                    puts("text_change_request started")
                    body = JSON.parse(req.body)
                    @processor.change_text(body["article_id"], body["text"], body["executor_id"])
                    res.status = 200
                    return
                rescue
                    res.status = 500
                    return
                end
            when "bookmark_request"
                begin
                    puts("bookmark_request started")
                    body = JSON.parse(req.body)
                    @processor.bookmark(body["article_id"], body["executor_id"])
                    res.status = 200
                    return
                rescue
                    res.status = 500
                    return
                end
            when "unbookmark_request"
                begin
                    puts("unbookmark_request started")
                    body = JSON.parse(req.body)
                    @processor.unbookmark(body["article_id"], body["executor_id"])
                    res.status = 200
                    return
                rescue
                    res.status = 500
                    return
                end
            end
        end

        res.status = 404
    end
end

server = WEBrick::HTTPServer.new({
    DocumentRoot:   './',
    BindAddress:    '0.0.0.0',
    Port:           3000,
})
server.mount('/', Servlet, ArticleProcessor.new(ArticleRepository.new))
server.start
