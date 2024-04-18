require 'webrick'
require 'mysql2'
require 'json'

class Servlet < WEBrick::HTTPServlet::AbstractServlet
    def initialize(server, mysql_client)
        super(server, mysql_client)
        @mysql_client = mysql_client
    end

    def do_GET(req, res)
        path = req.path.split('/')
        case path[1]
        when "articles"
            case path[-1]
            when "index"
                results = @mysql_client.query("select articles.id, articles.title, articles.text, articles.thumbnail, articles.author_id, group_concat(bookmarks.executor_id) AS bookmarkers from articles left join bookmarks on bookmarks.article_id = articles.id group by articles.id", :as => :hash)
            
                res.body = {result: results.map {|row| row.to_h} }.to_json.to_s
                return
            else
                statement = @mysql_client.prepare("select articles.id, articles.title, articles.text, articles.thumbnail, articles.author_id, group_concat(bookmarks.executor_id) AS bookmarkers from articles left join bookmarks on bookmarks.article_id = articles.id where articles.id = ? group by articles.id")
                result = statement.execute(path[-1])
                row = result.first
                unless row
                    raise "not found error"
                end

                res.body = row.to_json.to_s
                return
            end
        end
    end
end

mysql_client = Mysql2::Client.new(
    host:     "mysql_read",
    username: "root",
    password: "password",
    port: 3306,
    database: "cqrs_es_example_blog_read_database"
)

server = WEBrick::HTTPServer.new({
    DocumentRoot:   './',
    BindAddress:    '0.0.0.0',
    Port:           3001,
})
server.mount('/', Servlet, mysql_client)
server.start
