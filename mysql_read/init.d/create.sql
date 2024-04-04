USE cqrs_es_example_blog_read_database;

CREATE TABLE articles (
  id VARCHAR(255) NOT NULL PRIMARY KEY,
  text TEXT NOT NULL,
  title VARCHAR(255) NOT NULL,
  thumbnail VARCHAR(255) NOT NULL,
  author_id VARCHAR(255) NOT NULL
);

CREATE TABLE bookmarks (
  id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
  article_id VARCHAR(255) NOT NULL,
  executor_id VARCHAR(255) NOT NULL,
  UNIQUE KEY idx_executor_id_article_id (executor_id, article_id),
  CONSTRAINT fk_bookmarks_articles
    FOREIGN KEY (article_id)
      REFERENCES articles (id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
);