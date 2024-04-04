## 起動方法
1. `docker-compose up -d` でコンテナを起動します
2. `curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json"  http://localhost:8083/connectors -d @connector.json` を実行します

## command API
### 記事投稿
`curl -X POST -H "Content-Type: application/json" -d '{"title":"タイトル", "thumbnail":"https://example.com/example.png", "text": "テキスト", "executor_id": "executor_id"}' http://localhost:3000/articles/publish_request`

### タイトル変更
`curl -X POST -H "Content-Type: application/json" -d '{"article_id": "xxxx", "title": "タイトル", "executor_id": "executor_id"}' http://localhost:3000/articles/title_change_request`

### サムネイル変更
`curl -X POST -H "Content-Type: application/json" -d '{"article_id": "xxxx", "thumbnail": "https://example.com/example.png", "executor_id": "executor_id"}' http://localhost:3000/articles/thumbnail_change_request`

### テキスト変更
`curl -X POST -H "Content-Type: application/json" -d '{"article_id": "xxxx", "text":" テキスト", "executor_id": "executor_id"}' http://localhost:3000/articles/text_change_request`

### お気に入り登録
`curl -X POST -H "Content-Type: application/json" -d '{"article_id": "xxxx", "executor_id": "executor_id"}' http://localhost:3000/articles/bookmark_request`

### お気に入り解除
`curl -X POST -H "Content-Type: application/json" -d '{"article_id": "xxxx", "executor_id": "executor_id"}' http://localhost:3000/articles/unbookmark_request`

## query API
### 記事一覧
`curl localhost:3001/articles/index | jq .`

## イベントストリームを見る場合
`docker-compose exec kafka kafka-console-consumer.sh --bootstrap-server local-kafka:9092 --from-beginning --topic debezium_cdc_topic.cqrs_es_example_blog_write_database.events`

## アーキテクチャ
<img width="939" alt="アーキテクチャ" src="https://github.com/kousuke1201abe/cqrs_es_example_blog/assets/50360629/3ee8ab28-55b0-4fa3-ab6b-3bebba1c5be4">
