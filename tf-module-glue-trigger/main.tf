resource "aws_glue_trigger" "jdbc-crawler-s3-trigger" {
  name = "crawler-jdbc-DB-trigger"
  type = "ON_DEMAND"

  actions {
    crawler_name = aws_glue_crawler.jdbc-crawler[0].name
  }
}