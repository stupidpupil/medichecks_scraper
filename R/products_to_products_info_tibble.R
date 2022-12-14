products_to_products_info_tibble <- function(products){
  
  products_info_tibble <- products |> 
    purrr::map(function(p){list(product_handle = p$handle, title=p$title, price_pence = p$price_pence, venous_only = p$venous_only)}) |> 
    purrr::map_dfr(function(x) {purrr::flatten(x)}) |>
    dplyr::mutate(venous_only = dplyr::if_else(!venous_only, 0, 1)) |>
    dplyr::left_join(products_to_products_biomarkers_matrix(products), by="product_handle")
}