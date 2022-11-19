# S3 bucket
resource "aws_s3_bucket" "lb_logs" {
  bucket = "my-tf-test-bucket"

}

resource "aws_s3_bucket_acl" "lb_logs" {
  bucket = aws_s3_bucket.lb_logs.id
  acl    = "private"
}
