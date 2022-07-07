resource "null_resource" "user-data-script" {
  provisioner "local-exec" {
    command = "sed -i -e \"s|DOCUMENTDB_ENDPOINT|${var.DOCDB_ENDPOINT}|\" ${path.module}/${var.ENV}-userdata.sh"
  }
}
