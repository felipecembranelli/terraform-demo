/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "project_id" {
  description = "The project ID to deploy to"
  default = "mlb-local"
}

variable "service_account" {
  description = "service account used."
  default = "767754503635-compute@developer.gserviceaccount.com"
}

variable "bucket_name" {
  description = "The name of the bucket to create"
}

variable "storage_class" {
  description = "The Storage Class of the new bucket. Supported values include: MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE."
  default     = "MULTI_REGIONAL"
}

variable "versioning" {
  description = "Enable object versioning. True/False"
  default     = false
}
 
variable "labels" {
  description = "Labels to be attached to the buckets"
  default     = null
}

variable "bucket_role"  {
  description = "Default role for the service account access. Validate values are Viewer, Creator , Admin"
  default     = "Creator"
}

variable "location" {
  default = "US"
}
variable "bucket_admins" {
  description = "List of IAM-style bucket admins."
  default     = []
}

variable "bucket_creators" {
  description = "List of IAM-style bucket creators."
  default     = []
}

variable "bucket_viewers" {
  description = "List of IAM-style bucket viewers."
  default     = []
}

variable "created_by" {
  default = null
  
}
