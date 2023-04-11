get_medichecks_venous_collection_price_pence <- function(product_url_for_venous_collection_price_pence){

  if(missing(product_url_for_venous_collection_price_pence)){
  product_url_for_venous_collection_price_pence <- "https://www.medichecks.com/products/well-man-advanced-blood-test"
  }

  product_page <- rvest::read_html(product_url_for_venous_collection_price_pence)

  ret <- product_page |> 
    rvest::html_element("div[data-sku='PHLEB-CLINIC']") |> 
    rvest::html_text() |> stringr::str_match("£(\\d+)") |> 
    (\(x) x[[1,2]])() |> as.integer() |> (\(x) x*100L)()


  stopifnot(!is.na(ret))
  stopifnot(is.integer(ret))

  return(ret)
}