list_from_medichecks_product_json <- function(medichecks_product_json){

  id <- as.character(medichecks_product_json$id)
  title <- medichecks_product_json$title
  handle <- medichecks_product_json$handle


  # Pre 22 December 2022
  #biomarkers <- medichecks_product_json$body_html |> 
  #  stringr::str_extract_all("\\|biomarkers[\\-a-z0-9]+?\\|", simplify=TRUE) |>
  #  stringr::str_remove("^\\|biomarkers\\-") |>
  #  stringr::str_remove("\\|$") |>
  #  unique()

  biomarkers <- purrr::possibly(get_biomarkers_for_medichecks_product, character(0))(handle)

  #stopifnot(length(biomarkers) >= 1)
  #stopifnot(length(biomarkers) <= 199)

  stopifnot(length(medichecks_product_json$variants) == 1)

  price <- medichecks_product_json$variants[[1]]$price
  available <- medichecks_product_json$variants[[1]]$available

  stopifnot(price |> stringr::str_detect("^\\d+\\.\\d{2}$"))

  price_pence <- price |> stringr::str_remove("\\.") |> as.integer()

  tags <- medichecks_product_json$tags |> stringr::str_split(",\\s*", simplify=TRUE)#

  venous_available <- dplyr::case_when(
    ("collection_method_blood_in-store" %in% tags) ~ TRUE,
    ("collection_method_blood_nurse-visit" %in% tags) ~ TRUE,
    ("collectionMethod%Venous" %in% tags) ~ TRUE
  )

  venous_only <- dplyr::case_when(
    ("collection_method_blood_delivery" %in% tags) ~ FALSE,
    ("collectionMethod%Finger prick" %in% tags) ~ FALSE,
    venous_available ~ TRUE,
    TRUE ~ NA
  )

  biomarkers_count <- tags |>
    purrr::keep(function(x){x |> stringr::str_detect("^info_biomarkers_\\d+$")}) |>
    stringr::str_extract("\\d+$") |> unlist() |> as.integer() |> max()

  turnaround_days <- tags |>
    purrr::keep(function(x){x |> stringr::str_detect("^info_results_\\d+$")}) |>
    stringr::str_extract("\\d+$") |> unlist() |> as.integer() |> max()

  list(
    id = id,
    title = title,
    handle = handle,
    biomarkers = biomarkers,
    biomarkers_count = biomarkers_count,
    turnaround_days = turnaround_days,
    price_pence = price_pence,
    venous_only = venous_only,
    venous_available = venous_available,
    available = available
  )
}
