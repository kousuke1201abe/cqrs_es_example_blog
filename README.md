## 起動方法
1. `docker-compose up -d` でコンテナを起動します
2. `curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json"  http://localhost:8083/connectors -d @connector.json` を実行します
3. `http://localhost:4000/articles/index?executor_id={任意のid}` にアクセスしてください

## イベントストリームを見る場合
`docker-compose exec kafka kafka-console-consumer.sh --bootstrap-server local-kafka:9092 --from-beginning --topic debezium_cdc_topic.cqrs_es_example_blog_write_database.events`

## アーキテクチャ
<img width="939" alt="アーキテクチャ" src="https://github.com/kousuke1201abe/cqrs_es_example_blog/assets/50360629/cf1f75d5-531e-41b6-a2b2-8e11eb584802">
