CREATE DATABASE cqrs_es_example_blog_write_database;

USE cqrs_es_example_blog_write_database;

CREATE TABLE events (
  id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
  aggregate_id VARCHAR(255) NOT NULL,
  payload JSON NOT NULL,
  sequence_number INT NOT NULL,
  UNIQUE KEY idx_aggregate_id_sequence_number (aggregate_id, sequence_number)
);

CREATE TABLE snapshots (
  aggregate_id VARCHAR(255) NOT NULL PRIMARY KEY,
  payload JSON NOT NULL,
  version INT NOT NULL,
  UNIQUE KEY idx_aggregate_id_version (aggregate_id, version)
);