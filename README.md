```r
get_medichecks_products() |>
  products_to_products_info_tibble() |>
  readr::write_csv("products.csv")

```