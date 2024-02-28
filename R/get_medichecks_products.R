get_medichecks_products <- function(page_idx_range = 1L:4L){

  base_url <- "https://medichecks.com/collections/all/products.json?fields=id,handle,body_html,tags,variants&limit=250"


  products <- list()

  for (page_idx in page_idx_range) {
    url_with_page <- paste0(base_url, "&page=", page_idx) # At some point this will probably stop working as they catch-up with Shopify's API

    new_products <- jsonlite::read_json(url_with_page)$products

    new_products <- new_products |> 
      purrr::discard(function(p){p$product_type %in% c("Gift Cards", "Collection Method", "Clinic", "")})

    new_products <- new_products |>
      purrr::map(function(p){Sys.sleep(0.1); list_from_medichecks_product_json(p)})

    products <- c(products, new_products)
  }


  return(products)
}
