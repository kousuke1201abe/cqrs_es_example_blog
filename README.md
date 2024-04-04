## 使い方
1. `docker-compose up -d` でコンテナを起動します
2. `curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json"  http://localhost:8083/connectors -d @connector.json` を実行します

## アーキテクチャ
<img width="939" alt="アーキテクチャ" src="https://github.com/kousuke1201abe/cqrs_es_example_blog/assets/50360629/3ee8ab28-55b0-4fa3-ab6b-3bebba1c5be4">
