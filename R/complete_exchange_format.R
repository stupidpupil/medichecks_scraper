complete_exchange_format <- function(products_in_exchange_format){
  list(
    provider = list(
      name = jsonlite::unbox("Medichecks"),
      url = jsonlite::unbox("https://medichecks.com")
    ),
    products = products_in_exchange_format  ,
    last_updated = lubridate::now() |> lubridate::format_ISO8601(usetz=TRUE) |> jsonlite::unbox()
  )
}
