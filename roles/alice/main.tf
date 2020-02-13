module "alice" {
  source    = "tf.example.com/prodege/aws-keypair/aws"
  version   = "2.0.20"
  key_count = 1
  tags = {
    name = "alice"
  }
}
