一旦雑に curl で

curl -X POST -H "Content-Type: application/json" -d '{"title":"タイトル", "thumbnail":"https://pc-yougo.com/wp-content/uploads/2017/08/url.png", "text": "テキスト", "executor_id": "kosukeabe"}' http://localhost:3000/articles/publish_request

curl -X POST -H "Content-Type: application/json" -d ‘{“article_id:”"82948e97-4860-4ff7-ac88-629a18e458bb", "thumbnail":"https://pc-yougo.com/wp-content/uploads/2017/08/url.png", "text": "テキスト", "executor_id": "kosukeabe"}' http://localhost:3000/articles/title_change_request

curl -X POST -H "Content-Type: application/json" -d '{"article_id": "82948e97-4860-4ff7-ac88-629a18e458bb", "title":"タイトル2", "executor_id": "kosukeabe"}' http://localhost:3000/articles/title_change_request


curl -X POST -H "Content-Type: application/json" -d '{"article_id": "82948e97-4860-4ff7-ac88-629a18e458bb", "thumbnail":"https://pc-yougo.com/wp-content/uploads/2017/08/url.jpg", "executor_id": "kosukeabe"}' http://localhost:3000/articles/thumbnail_change_request

curl -X POST -H "Content-Type: application/json" -d '{"article_id": "82948e97-4860-4ff7-ac88-629a18e458bb", "text":"テキスト2", "executor_id": "kosukeabe"}' http://localhost:3000/articles/text_change_request


curl -X POST -H "Content-Type: application/json" -d '{"article_id": "82948e97-4860-4ff7-ac88-629a18e458bb", "executor_id": "kosukeabe2"}' http://localhost:3000/articles/bookmark_request

curl -X POST -H "Content-Type: application/json" -d '{"article_id": "82948e97-4860-4ff7-ac88-629a18e458bb", "executor_id": "kosukeabe2"}' http://localhost:3000/articles/unbookmark_request
