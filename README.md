
# rk.dates: An RKWard Plugin for Date/Time Conversion

![Version](https://img.shields.io/badge/Version-0.0.1-blue.svg)
![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)

This package provides a single, powerful RKWard plugin designed to convert various numeric and character representations of dates and times into R's standard `POSIXct` (date-time) format. It simplifies the often-tricky process of handling date/time data imported from other statistical software or sources.

## Features

The plugin provides a unified interface with the following capabilities, available under the `Data -> Dates and Times -> Convert to R Date-Time` menu in RKWard:

*   **Support for External Formats**: Directly convert numeric date/time values from common external sources, including:
    *   **Excel**: Reliably handles numeric dates using the `openxlsx` package.
    *   **SPSS**: Correctly converts numbers representing seconds since October 14, 1582.
    *   **Stata**: Correctly converts numbers representing *milliseconds* since January 1, 1960.
    *   **SAS**: Correctly converts numbers representing seconds since January 1, 1960.
*   **Clear Options for R's Native Types**:
    *   Promote R's `Date` objects (date-only) to full `POSIXct` objects (date with time).
    *   Handle standard, unambiguous character strings (e.g., "2025-11-21 15:30:00").
*   **Interactive Data Preview**: A **Preview** button allows you to see the result of the conversion *before* you click "Submit," ensuring you have selected the correct origin format for your data.
*   **User-Friendly Workflow**: A simple dropdown menu removes the need to remember the complex origin dates and time units (seconds vs. milliseconds) required for manual conversion in R code.

## Installation

### Requirements
*   A working installation of RKWard.
*   The R packages `openxlsx` and `devtools` (or `remotes`).

### Recommended Method: From GitHub

The easiest way to install the plugin is using R's `devtools` or `remotes` package.

```R
# If you don't have devtools or the required dependency, install them first:
# install.packages(c("devtools", "openxlsx"))

devtools::install_github("AlfCano/rk.dates")
```

After installation, restart RKWard, and the new menu entry will be available.

## Usage Example: Converting Excel Numeric Dates

This example demonstrates how to convert a column of numeric dates (as they are often imported or pasted from Excel) into a proper R date-time format.

**1. Prepare Sample Data**
First, create a sample data frame. The `Hora.de.inicio` and `Hora.de.finalización` columns contain numbers that represent date-times in Excel. Run this code in the RKWard console:

```R
dates <- data.frame(
  Hora.de.inicio = c(45238.42586, 45238.4259, 45238.42586, 45238.42672),
  Hora.de.finalización = c(45238.43712, 45238.43788, 45238.44131, 45238.44304)
)

```

You will now have a data frame named `dates` in your workspace.

**2. Open the Plugin**
Go to the RKWard menu: `Data -> Dates and Times -> Convert to R Date-Time`.

**3. Configure the Dialog**

*   **Data vector to convert**: From the object selector list on the left, choose `dates$Hora.de.inicio`.
*   **Original format of the data**: From the dropdown menu, select **Excel (numeric)**.
*   **Save result as**: `start_time_posix`.

**4. Preview the Result (Optional)**
Click the `Preview` button. A new pane will appear showing the converted date-times. For the first value (`45238.42586`), it should show something like `2023-11-10 10:13:14`. This confirms your settings are correct.

**5. Submit**
Click the `Submit` button. A new object named `start_time_posix` will be created in your workspace.

**6. Verify the Result (Optional)**
To confirm the new object is in the correct format, you can run the `str()` function in the R console:

```R
str(start_time_posix)

```

The output will show that it is a `POSIXct` object, which can now be used for time-based calculations and plotting.

## Author and License

*   **Author**: Alfonso Cano Robles, assisted by Gemini a LLM from Google.
*   **Email**: alfonso.cano@correo.buap.mx
*   **License**: GPL (>= 3)
