locals {
  #project_id      = var.project_id
  project_id = lower(trimspace(var.project_id))
  
  project_prefix  = join("-",slice(split("-",local.project_id),0,2))
  environment     = element(split("-",var.project_id),2)
  #bucket_name     = local.project_prefix-"${var.bucket_name}"
  bucket_name     = "${local.project_prefix}-${var.bucket_name}"
  #service_account = (local.environment == "sbx") ? ["serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"] : ["serviceAccount:private@${local.project_id}.iam.gserviceaccount.com","serviceAccount:public@${local.project_id}.iam.gserviceaccount.com"]
  service_account = lower(trimspace(var.service_account))
}


resource "google_storage_bucket" "default" {
  name          = local.bucket_name
  project       = local.project_id
  location      = var.location
  storage_class = var.storage_class

  labels        = {
    "created-by" = "${var.created_by}"
    "project_id" = local.project_id
  }

  versioning {
    enabled = var.versioning
  }
}  

/**********************************************
  -Add the default compute service account access
************************************************/

# resource "google_storage_bucket_iam_member" "compute-svc-account" {
#   count   = length("${local.service_account}")
#   bucket  = google_storage_bucket.default.name
#   role    = "roles/storage.object${var.bucket_role}"
#   member  = "${element(local.service_account,count.index)}"
# }

resource "google_storage_bucket_iam_member" "admins" {
  count   = "${var.bucket_admins  != "" ? length(var.bucket_admins) : 0}"
  bucket  = google_storage_bucket.default.name
  role    = "roles/storage.objectAdmin"
  member  = "${element(var.bucket_admins,count.index)}"
}

resource "google_storage_bucket_iam_member" "viewers" {
  count   = "${var.bucket_viewers != "" ? length(var.bucket_viewers) : 0}"
  bucket  = google_storage_bucket.default.name
  role    = "roles/storage.objectViewer"
  member  = "${element(var.bucket_viewers,count.index)}"
}

resource "google_storage_bucket_iam_member" "creators" {
  count   = "${var.bucket_creators  != "" ? length(var.bucket_creators) : 0}"
  bucket  = google_storage_bucket.default.name
  role    = "roles/storage.objectCreator"
  member  = "${element(var.bucket_creators,count.index)}"
}

//TODO:  add the lifecyle as default 
//       add the logging bucket eabled by default - send to rileys' log infra??

/* 
  lifecycle_rule {
    action {
      type = "SetStorageClass"
      storage_class = "COLDLINE"
    }
    condition {
      with_state = "LIVE"
      age = var.coldline_age
    }
  }
  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      with_state = "LIVE"
      matches_storage_class = ["COLDLINE"]
      age = var.delete_age
    }
*/
