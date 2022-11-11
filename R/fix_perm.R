#' Fix permissions for files in shared projects.
#'
#' Uploading files (and other situations) sometimes cause broken file
#' permissions. This script restores the default ACLs (access control lists)
#' for those files.
fix_perm <- function(dir = '.') {
  # Get the default ACL for the project, stored in a temp file.
  default_acl <- system2("getfacl", args = c("--default", dir), stdout=TRUE)
  default_acl_file <- tempfile()
  cat(default_acl, file=default_acl_file, sep="\n")

  # Set all the ACLs to that default ACL.
  all_files <- list.files(
    dir, recursive = TRUE,
    all.files = TRUE, full.names = TRUE, include.dirs = TRUE)
  for (f in all_files) {
    #cat(paste("setfacl", c(paste0("--set-file=", default_acl_file), f)))
    args <- c(paste0("--set-file=", default_acl_file), f)
    system2("setfacl", args = args)
  }
  unlink(default_acl_file)
}
