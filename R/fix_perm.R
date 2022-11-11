#' Fix permissions for files in shared projects.
#'
#' Uploading files (and other situations) sometimes cause broken file
#' permissions. This script restores the default ACLs (access control lists)
#' for those files.
fix_perm <- function(dir = NULL) {
  if (is.null(dir)) dir <- here::here()
  # Get the default ACL for the project, stored in a temp file.
  # NOTE: despite accepting an args *vector*, system2 PASSES ARGS THROUGH THE SHELL.
  # So we need to quote things.
  # See https://ro-che.info/articles/2020-12-11-r-system2
  default_acl <- system2("getfacl", args = c("--default", shQuote(dir)), stdout=TRUE)
  default_acl_file <- tempfile()
  cat(default_acl, file=default_acl_file, sep="\n")

  # Set all the ACLs to that default ACL.
  all_files <- list.files(
    dir, recursive = TRUE,
    all.files = TRUE, full.names = TRUE, include.dirs = TRUE)
  for (f in all_files) {
    args <- c(paste0("--set-file=", shQuote(default_acl_file)), shQuote(f))
    system2("setfacl", args = args)
  }
  unlink(default_acl_file)
}
