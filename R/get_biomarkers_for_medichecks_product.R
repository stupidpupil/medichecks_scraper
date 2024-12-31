get_biomarkers_for_medichecks_product <- function(product_handle){
	base_url <-  "https://www.medichecks.com/products/"

	rvest::read_html(paste0(base_url, product_handle)) |> 	
		rvest::html_nodes("#block-bio_marker_WM3bDH p.mb-0") |>
		rvest::html_text2() |> 
		stringr::str_to_lower() |> 
		stringr::str_replace_all("[^a-z0-9]+","-") |> 
		stringr::str_replace_all("(^\\-|\\-$)","") |>
		purrr::discard(\(x) x == "learn-more")
}

