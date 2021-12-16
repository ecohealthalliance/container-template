#' Upload files or folders to AWS
#'
#' @param path The path to the file(s) or folder(s) to be uploaded
#' @param bucket The name of the bucket to be uploaded to
#' @param key The key or name for the file or folder to take in the bucket.
#'   Should end with "/" for folders. Use "" to upload files in folder without
#'   top-level folder.
#' @param prefix A prefix to prepend to the file or folder keys. Generally
#'   should end with "/"
#' @param check Whether to check if the exact file already exists in the bucket
#'   and skip uploading. Defaults to TRUE
#' @param error Whether error out if the file is missing, folder is empty, or
#'   system environment variables are missing. Otherwise a message will print
#'   but an empty list will be returned.
#'
#' @return A list, each element being having the key and etag (hash) of uploaded
#'   files
aws_s3_upload <- function(path, bucket, key = basename(path), prefix = "",
                          check = TRUE, error = FALSE) {
  
  if (any(Sys.getenv(c("AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY", "AWS_REGION")) == "")) {
    msg <- paste(
      "AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY`, `AWS_REGION` environment
       variables must all be set to upload to AWS, probably in the .env file"
    )
    if (error) {
      stop(msg)
    } else {
      warning(msg)
      return(list())
    }
  }
  
  if (length(path) > 1) {
    stopifnot(length(path) == length(key))
    out <- mapply(aws_s3_upload, path = path, key = key,
                  MoreArgs = list(bucket = bucket, prefix = prefix, check = check, error = error),
                  SIMPLIFY = FALSE)
    return(Reduce(c, unname(out), list()))
    
  }
  
  if (!file.exists(path)) {
    if (error) {
      stop("File not found.")
    } else {
      message("No file found. No upload, returning empty list")
      return(list())
    }
  }
  
  svc <- paws::s3()
  if (file.exists(path) && !dir.exists(path)) {
    out <- list(aws_s3_upload_single(path, paste0(key, prefix), bucket, check, svc))
  } else if (file.exists(path) && dir.exists(path)) {
    files <- list.files(path, recursive = TRUE, full.names = TRUE, all.files = TRUE)
    
    if (!length(files)) {
      if (error) {
        stop("Directory empty.")
      } else {
        message("Directory empty. No upload, returning empty list")
        return(list())
      }
    }
    
    keys <- paste0(prefix, gsub(paste0("^", basename(path), "/?"), key, files))
    
    out <- mapply(aws_s3_upload_single,
                  path = files, key = keys,
                  MoreArgs = list(bucket = bucket, check = check, svc = svc),
                  SIMPLIFY = FALSE
    ) |>
      unname()
  }
  
  out
}

aws_s3_upload_single <- function(path, key = basename(path), bucket,
                                 check = TRUE, svc = s3()) {
  if (check) {
    local_hash <- paste0('"', tools::md5sum(path), '"')
    s3_obj <- svc$list_objects_v2(Bucket = bucket, Prefix = key)$Contents |>
      purrr::keep(~ .x$Key == key) |>
      unlist(FALSE)
    
    if (!is.null(s3_obj) && s3_obj$ETag == local_hash) {
      return(list(key = s3_obj$Key, etag = s3_obj$ETag))
    }
    
    resp <- svc$put_object(
      Body = path,
      Bucket = bucket,
      Key = key
    )
    return(list(key = key, etag = resp$ETag))
  }
}
