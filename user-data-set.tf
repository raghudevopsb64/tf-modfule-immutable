resource "null_resource" "user-data-script" {
  triggers = {
    abc = timestamp()
  }
  provisioner "local-exec" {
    command = "sed -i -e 's|DOCUMENTDB_ENDPOINT|${var.DOCDB_ENDPOINT}|' ${path.module}/${var.ENV}-userdata.sh"
  }
  provisioner "local-exec" {
    command = "cat ${path.module}/${var.ENV}-userdata.sh"
  }
}
