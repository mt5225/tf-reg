resource "null_resource" "dummy" {
 provisioner "local-exec" {
    command = "echo"
  }
}