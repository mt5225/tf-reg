module "alice" {
  source = "tf.example.com/prodege/aws-keypair/aws"
  version = "2.0.20"
  name    = "${var.environment}-keypair"
}