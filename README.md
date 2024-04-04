## 使い方
1. `docker-compose up -d` でコンテナを起動します
2. `curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json"  http://localhost:8083/connectors -d @connector.json` を実行します
