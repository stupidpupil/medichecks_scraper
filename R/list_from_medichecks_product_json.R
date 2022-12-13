list_from_medichecks_product_json <- function(medichecks_product_json){

  id <- as.character(medichecks_product_json$id)
  title <- medichecks_product_json$title
  handle <- medichecks_product_json$handle

  biomarkers <- medichecks_product_json$body_html |> 
    stringr::str_extract_all("\\|biomarkers[\\-a-z0-9]+?\\|", simplify=TRUE) |>
    stringr::str_remove("^\\|biomarkers\\-") |>
    stringr::str_remove("\\|$") |>
    unique()

  #stopifnot(length(biomarkers) >= 1)
  #stopifnot(length(biomarkers) <= 199)

  stopifnot(length(medichecks_product_json$variants) == 1)

  price <- medichecks_product_json$variants[[1]]$price

  stopifnot(price |> stringr::str_detect("^\\d+\\.\\d{2}$"))

  price_pence <- price |> stringr::str_remove("\\.") |> as.integer()

  tags <- medichecks_product_json$tags |> stringr::str_split(",\\s*", simplify=TRUE)

  venous_only <- dplyr::case_when(
    !("escmed|Sample Type|Blood" %in% tags) ~ NA,
    ("collectionMethod%Finger prick" %in% tags) ~ FALSE,
    ("collectionMethod%Venous" %in% tags) ~ TRUE,
    TRUE ~ NA
  )

  list(
    id = id,
    title = title,
    handle = handle,
    biomarkers = biomarkers,
    price_pence = price_pence,
    venous_only = venous_only
  )
}
