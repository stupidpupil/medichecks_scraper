```r
get_medichecks_products() |>
  products_to_products_info_tibble() |>
  readr::write_csv("products.csv")

get_medichecks_biomarkers() |>
  readr::write_csv("biomarkers.csv")

```

Sibling of [medichecks_optimiser](https://github.com/stupidpupil/medichecks_optimiser)
