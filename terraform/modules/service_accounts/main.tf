resource "google_service_account" "service_account" {
  account_id   = var.service_account_name
  display_name = "Service Account"
  project = var.project
}


resource "google_project_iam_member" "project" {
  project = var.project
  role = "roles/owner"

  member = "serviceAccount:${google_service_account.service_account.email}"
  
}


resource "google_service_account_iam_binding" "admin-account-iam" {
  service_account_id = google_service_account.service_account.name
  role = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${var.project}.svc.id.goog[cnrm-system/cnrm-controller-manager]"
  ]
}
