// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!

function preview(){
	
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
          r_command = "as.POSIXct(as.numeric(" + input_vec + "), origin=\"1582-10-14\", tz=\"UTC\")";
          break;
        case "stata":
          // Stata datetime is *milliseconds* from 1960-01-01, so we must divide by 1000.
          r_command = "as.POSIXct(as.numeric(" + input_vec + ") / 1000, origin=\"1960-01-01\", tz=\"UTC\")";
          break;
        case "sas":
          // SAS datetime is seconds from 1960-01-01.
          r_command = "as.POSIXct(as.numeric(" + input_vec + "), origin=\"1960-01-01\", tz=\"UTC\")";
          break;
        case "r_numeric":
          // R/Unix default is seconds from 1970-01-01 (the epoch).
          r_command = "as.POSIXct(as.numeric(" + input_vec + "), origin=\"1970-01-01\")";
          break;
        case "r_character":
        case "r_date":
          // as.POSIXct can handle standard character formats and existing Date objects directly.
          r_command = "as.POSIXct(" + input_vec + ")";
          break;
      }
    }
   if(r_command){ echo("preview_data <- data.frame(Result=" + r_command + ");\n"); }
}

function preprocess(is_preview){
	// add requirements etc. here
	if(is_preview) {
		echo("if(!base::require(openxlsx)){stop(" + i18n("Preview not available, because package openxlsx is not installed or cannot be loaded.") + ")}\n");
	} else {
		echo("require(openxlsx)\n");
	}
}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

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
          r_command = "as.POSIXct(as.numeric(" + input_vec + "), origin=\"1582-10-14\", tz=\"UTC\")";
          break;
        case "stata":
          // Stata datetime is *milliseconds* from 1960-01-01, so we must divide by 1000.
          r_command = "as.POSIXct(as.numeric(" + input_vec + ") / 1000, origin=\"1960-01-01\", tz=\"UTC\")";
          break;
        case "sas":
          // SAS datetime is seconds from 1960-01-01.
          r_command = "as.POSIXct(as.numeric(" + input_vec + "), origin=\"1960-01-01\", tz=\"UTC\")";
          break;
        case "r_numeric":
          // R/Unix default is seconds from 1970-01-01 (the epoch).
          r_command = "as.POSIXct(as.numeric(" + input_vec + "), origin=\"1970-01-01\")";
          break;
        case "r_character":
        case "r_date":
          // as.POSIXct can handle standard character formats and existing Date objects directly.
          r_command = "as.POSIXct(" + input_vec + ")";
          break;
      }
    }
   if(r_command){ echo("posix_dates <- " + r_command + ";\n"); }
}

function printout(is_preview){
	// read in variables from dialog


	// printout the results
	if(!is_preview) {
		new Header(i18n("Convert to R Date-Time results")).print();	
	}
    var save_name = getValue("save_result.objectname");
    echo("rk.header(\"Date Conversion Results\")\n");
    if(getValue("save_result.active")){
      echo("rk.header(\"Result saved to object: " + save_name + "\", level=3)\n");
    }
  
	if(!is_preview) {
		//// save result object
		// read in saveobject variables
		var saveResult = getValue("save_result");
		var saveResultActive = getValue("save_result.active");
		var saveResultParent = getValue("save_result.parent");
		// assign object to chosen environment
		if(saveResultActive) {
			echo(".GlobalEnv$" + saveResult + " <- posix_dates\n");
		}	
	}

}

