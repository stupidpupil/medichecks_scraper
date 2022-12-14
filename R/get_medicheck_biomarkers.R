get_medicheck_biomarkers <- function(){

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
		"Clotting Status"

	) |> stringr::str_replace_all(" ", "+")

	biomarkers <- tibble::tibble()

	for (c in categories) {
		url <- paste0(base_url, c)

		category_info <- jsonlite::read_json(url)

		new_rows <- category_info$children |> 
			tibble::tibble() |>  
			tidyr::unnest_wider(1) |> 
			dplyr::select(shopify_page_handle, name, description) |> 
			dplyr::filter(!is.na(shopify_page_handle)) |>
			dplyr::rename(biomarker_handle = shopify_page_handle) |>
			dplyr::mutate(category = category_info$category$name)

		biomarkers <- biomarkers |>
			dplyr::bind_rows(new_rows)
	}	


	biomarkers <- biomarkers |> 
		dplyr::mutate(biomarker_handle = biomarker_handle |> stringr::str_remove("^biomarkers\\-"))

	return(biomarkers)
}