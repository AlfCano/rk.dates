# Golden Rules of RKWard Plugin Development (Revised & Expanded)
# This script creates the "rk.dates" plugin package from a single source file.

local({
  # =========================================================================================
  # Package Definition and Metadata
  # =========================================================================================
  require(rkwarddev)
  rkwarddev.required("0.8-1")

  package_about <- rk.XML.about(
    name = "rk.dates",
    author = person(
      given = "Alfonso",
      family = "Cano Robles",
      email = "alfonso.cano@correo.buap.mx",
      role = c("aut", "cre")
    ),
    about = list(
      desc = "An RKWard plugin package for transforming dates and times to POSIX R format.",
      version = "0.0.1",
      url = "https://github.com/AlfCano/rk.dates",
      license = "GPL (>= 3)"
    )
  )

  # =========================================================================================
  # UI Definition
  # =========================================================================================

  var_selector <- rk.XML.varselector(id.name = "var_selector", label = "Select an object")

  input_varslot <- rk.XML.varslot(
    label = "Data vector to convert",
    source = "var_selector",
    required = TRUE,
    id.name = "input_vector"
  )

  # CORRECTED: Dropdown now has distinct, accurate options for each format.
  origin_dropdown <- rk.XML.dropdown(
    label = "Original format of the data",
    id.name = "origin_format",
    options = list(
      "Excel (numeric)" = list(val = "excel", chk = TRUE),
      "SPSS (numeric datetime)" = list(val = "spss"),
      "Stata (numeric datetime in milliseconds)" = list(val = "stata"),
      "SAS (numeric datetime)" = list(val = "sas"),
      "R numeric (seconds since 1970-01-01)" = list(val = "r_numeric"),
      "R character (e.g., '2025-11-21 15:30:00')" = list(val = "r_character"),
      "R Date object" = list(val = "r_date")
    )
  )

  save_obj <- rk.XML.saveobj(
    label = "Save result as",
    initial = "posix_dates",
    chk = TRUE,
    id.name = "save_result"
  )

  preview_button <- rk.XML.preview(mode = "data")

  main_dialog <- rk.XML.dialog(
    label = "Convert to R Date-Time (POSIXct)",
    child = rk.XML.row(
      var_selector,
      rk.XML.col(
        input_varslot,
        origin_dropdown,
        save_obj,
        preview_button
      )
    )
  )

  # =========================================================================================
  # JavaScript Logic
  # =========================================================================================

  # CORRECTED: The switch statement now has accurate R code for each specific format.
  js_common_logic <- '
    var input_vec = getValue("input_vector");
    var origin_format = getValue("origin_format");
    var r_command = "";

    if(input_vec){
      switch(origin_format){
        case "excel":
          // openxlsx handles the different Excel epoch systems (1900/1904)
          r_command = "openxlsx::convertToDateTime(" + input_vec + ")";
          break;
        case "spss":
          // SPSS datetime is seconds from midnight, October 14, 1582.
          r_command = "as.POSIXct(as.numeric(" + input_vec + "), origin=\\"1582-10-14\\", tz=\\"UTC\\")";
          break;
        case "stata":
          // Stata datetime is *milliseconds* from 1960-01-01, so we must divide by 1000.
          r_command = "as.POSIXct(as.numeric(" + input_vec + ") / 1000, origin=\\"1960-01-01\\", tz=\\"UTC\\")";
          break;
        case "sas":
          // SAS datetime is seconds from 1960-01-01.
          r_command = "as.POSIXct(as.numeric(" + input_vec + "), origin=\\"1960-01-01\\", tz=\\"UTC\\")";
          break;
        case "r_numeric":
          // R/Unix default is seconds from 1970-01-01 (the epoch).
          r_command = "as.POSIXct(as.numeric(" + input_vec + "), origin=\\"1970-01-01\\")";
          break;
        case "r_character":
        case "r_date":
          // as.POSIXct can handle standard character formats and existing Date objects directly.
          r_command = "as.POSIXct(" + input_vec + ")";
          break;
      }
    }
  '

  js_calculate <- paste(js_common_logic, 'if(r_command){ echo("posix_dates <- " + r_command + ";\\n"); }')
  js_preview <- paste(js_common_logic, 'if(r_command){ echo("preview_data <- data.frame(Result=" + r_command + ");\\n"); }')

  js_printout <- '
    var save_name = getValue("save_result.objectname");
    echo("rk.header(\\"Date Conversion Results\\")\\n");
    if(getValue("save_result.active")){
      echo("rk.header(\\"Result saved to object: " + save_name + "\\", level=3)\\n");
    }
  '

  # =========================================================================================
  # Final Plugin Skeleton Call
  # =========================================================================================

  rk.plugin.skeleton(
    about = package_about,
    path = ".",
    xml = list(dialog = main_dialog),
    js = list(
      require = "openxlsx",
      calculate = js_calculate,
      preview = js_preview,
      printout = js_printout
    ),
    pluginmap = list(
      name = "Convert to R Date-Time",
      hierarchy = list("data")
    ),
    create = c("pmap", "xml", "js", "desc", "about"),
    load = TRUE,
    overwrite = TRUE,
    show = FALSE
  )

  cat("\\n'rk.dates' plugin package created successfully.\\n\\nTo complete installation:\\n\\n")
  cat("  # In RKWard's R console, run:\n")
  cat("  rk.updatePluginMessages(plugin.dir=\"rk.dates\")\n\n")
  cat("  # Then, also in the R console, run:\n")
  cat("  devtools::install(\"rk.dates\")\n")

})
