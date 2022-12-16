get_medichecks_biomarkers <- function(){

	base_url <- "https://medichecks-production.pwaify.com/api/public/biomarker-category?name="

	categories = c(
		"Kidney Health",
		"Liver Health",
		"Proteins",
		"Cholesterol Status",
		"Inflammation",
		"Muscle Health",
		"Iron Status",
		"Hormones",
		"Thyroid Hormones",
		"Diabetes",
		"Autoimmunity",
		"Heart Health",
		"Vitamins",
		"Minerals",
		"Omega fatty acids",
		"Gout Risk",
		"Adrenal Hormones",
		"Immunity",
		"Prostate",
		"Haematology",
		"Red Blood Cells",
		"White Blood Cells",
		"Clotting Status",
		"Trace Elements"

	) |> stringr::str_replace_all(" ", "+")

	biomarkers <- tibble::tibble()

	for (c in categories) {
		url <- paste0(base_url, c)

		category_info <- jsonlite::read_json(url)

		new_rows <- category_info$children |> 
			tibble::tibble() |>  
			tidyr::unnest_wider(1) |> 
			dplyr::select(shopify_page_handle, name, description, short_description) |> 
			dplyr::filter(!is.na(shopify_page_handle)) |>
			dplyr::rename(biomarker_handle = shopify_page_handle) |>
			dplyr::mutate(category = category_info$category$name)

		biomarkers <- biomarkers |>
			dplyr::bind_rows(new_rows)
	}	


	try_to_get_first_paragraph_of_description <- function(desc){
		ret <- purrr::possibly(
			function(desc){desc |> 
				xml2::read_html() |> 
				rvest::html_node("p") |> 
				rvest::html_text2()},
			NA_character_)(desc)

		return(ret)
	}

	biomarkers <- biomarkers |> 
		dplyr::mutate(
			biomarker_handle = biomarker_handle |> stringr::str_remove("^biomarkers\\-"),
			short_description = dplyr::if_else(
				is.na(short_description) | stringr::str_length(short_description) == 0, 
				description |> try_to_get_first_paragraph_of_description(), 
				short_description)
		) |>
		dplyr::select(-description) 

	return(biomarkers)
}