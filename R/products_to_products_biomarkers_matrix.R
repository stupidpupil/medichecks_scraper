products_to_products_biomarkers_matrix <- function(products){
  all_biomarkers <- products |> 
    purrr::map(function(p){p$biomarkers}) |> 
    unlist() |> unique() |> sort()


  products_biomarkers_lookup <- tibble::tibble()

  for (product in products) {
    products_biomarkers_lookup <- products_biomarkers_lookup |>
      dplyr::bind_rows(tibble::tibble(
        product_handle = product$handle,
        biomarker = product$biomarkers,
        included = 1L
      ))
  }    


  return(products_biomarkers_lookup |> tidyr::pivot_wider(names_from = biomarker, values_from = included, values_fill = 0L) )
}
