######### Ensure required packages are installed before loading them ############
# install.packages(c("readr", "dplyr", "ggplot2", "lubridate", "ggmap", "gridExtra", "gt"))

# Load necessary libraries for data manipulation, visualization, and mapping
library(readr)       # For reading CSV files
library(dplyr)       # For data manipulation (filtering, summarizing, etc.)
library(ggplot2)     # For data visualization
library(lubridate)   # For working with date-time data
library(ggmap)       # For mapping and spatial visualization
library(gridExtra)   # For arranging multiple plots in a grid layout
library(gt)          # For creating enhanced tables

# Load the dataset from a CSV file
CTA_Case_1 <- read_csv("CTA Case 1.csv")

########## Analyze When Crashes Are Most Likely ###########

# Load necessary libraries (ensure they are installed before running)
# install.packages(c("readr", "dplyr", "ggplot2", "lubridate", "ggmap", "gridExtra", "gt"))

# Convert crash hour column to numeric format for analysis
CTA_Case_1 <- CTA_Case_1 %>%
  mutate(CRASH_HOUR = as.numeric(CRASH_HOUR))

# Aggregate the total number of crashes for each hour of the day
hourly_crashes <- CTA_Case_1 %>%
  group_by(CRASH_HOUR) %>%
  summarise(count = n())

# Convert numeric crash hour to AM/PM time format for better readability
hourly_crashes <- hourly_crashes %>%
  mutate(AM_PM = ifelse(CRASH_HOUR < 12, paste0(CRASH_HOUR, " AM"),
                        ifelse(CRASH_HOUR == 12, "12 PM",
                               paste0(CRASH_HOUR - 12, " PM"))))

# Convert the AM/PM column into a factor to ensure correct chronological order in plots
hourly_crashes$AM_PM <- factor(hourly_crashes$AM_PM, 
                               levels = c("12 AM", "1 AM", "2 AM", "3 AM", "4 AM", "5 AM", 
                                          "6 AM", "7 AM", "8 AM", "9 AM", "10 AM", "11 AM",
                                          "12 PM", "1 PM", "2 PM", "3 PM", "4 PM", "5 PM",
                                          "6 PM", "7 PM", "8 PM", "9 PM", "10 PM", "11 PM"))

# Remove any potential NA values that could interfere with plotting
hourly_crashes <- hourly_crashes %>%
  filter(!is.na(AM_PM))

# Identify key peak hours: fixed 8 AM and dynamically find the hour with the highest crashes
peak_hours <- hourly_crashes %>%
  filter(CRASH_HOUR %in% c(8, which.max(count)))  # Includes 8 AM and the highest crash hour

# Create a time-series line plot showing crash frequency by hour
ggplot(hourly_crashes, aes(x = AM_PM, y = count, group = 1)) +
  geom_line(color = "darkred", linewidth = 1.8) +  # Dark red line for clear trend visibility
  geom_point(color = "blue", size = 3) +  # Blue points to highlight data points
  geom_text(data = peak_hours, aes(label = scales::comma(count)), 
            nudge_y = max(hourly_crashes$count) * 0.03, size = 6, 
            color = "black", fontface = "bold") +  # Labels for key peak values
  theme_minimal(base_family = "Arial") +  # Clean, modern theme
  labs(
    title = "Traffic Crashes by Hour of the Day",
    subtitle = "Morning and evening rush hours see the most crashes",
    x = "Time of Day",
    y = "Number of Crashes"
  ) +
  scale_y_continuous(labels = scales::comma) +  # Format Y-axis labels with commas
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 18),  # Centered bold title
    plot.subtitle = element_text(hjust = 0.5, size = 14, color = "darkgray"),  # Subtitle styling
    axis.text = element_text(size = 12),  
    axis.title = element_text(size = 14, face = "bold"),
    panel.grid.major = element_blank(),  # Remove major grid lines for cleaner visualization
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(angle = 45, hjust = 1),  # Tilt x-axis labels for better readability
    axis.line = element_line(color = "black", linewidth = 1)  # Enhancing axis lines for clarity
  )

########## Analyze Where Crashes Are Most Likely to Happen ########

# Load necessary libraries (ensure they are installed before running)
# install.packages(c("readr", "dplyr", "ggplot2", "lubridate", "ggmap", "gridExtra", "gt"))

# Load required library for Stadia Maps API
register_stadiamaps(key = "2d9c524e-aa9e-4711-a771-3eb89d1f979d")  # API key for accessing map tiles

# MAP 1: Full Chicago View
# This retrieves a base map covering a wider area of Chicago using Stadia Maps
chicago_map <- get_stadiamap(
  bbox = c(left = -87.75, bottom = 41.75, right = -87.55, top = 42.05),  # Defines map boundaries
  zoom = 13,  # Zoom level to capture city-wide crashes
  maptype = "stamen_terrain"  # Map style
)

# MAP 2: Expanded Loop Area (Includes More Clustered Points)
# This focuses on the Loop and nearby areas with a slightly larger boundary
loop_map <- get_stadiamap(
  bbox = c(left = -87.65, bottom = 41.87, right = -87.60, top = 41.92),  
  zoom = 14,  # More zoomed-in to focus on high-density crash locations
  maptype = "stamen_terrain"
)

# Identify Top Crash Locations Across Chicago
top_crash_locations <- CTA_Case_1 %>%
  filter(LATITUDE > 41.75 & LATITUDE < 42.05,  # Filter to only Chicago area
         LONGITUDE > -87.75 & LONGITUDE < -87.55) %>%
  group_by(LATITUDE, LONGITUDE) %>%
  summarise(crash_count = n()) %>%
  arrange(desc(crash_count)) %>%  # Sort locations by number of crashes
  head(10)  # Get the top 10 crash hotspots

# Identify Top Crash Locations in The Loop + Extended Area
loop_crash_locations <- top_crash_locations %>%
  filter(LATITUDE > 41.87 & LATITUDE < 41.92,  
         LONGITUDE > -87.65 & LONGITUDE < -87.60)  # Further filter to Loop area

# Remove points inside the white-out zone from the full Chicago map
top_crash_locations_filtered <- top_crash_locations %>%
  filter(!(LATITUDE > 41.87 & LATITUDE < 41.92 &  
             LONGITUDE > -87.65 & LONGITUDE < -87.60))  # Exclude Loop points from full map

# MAP 1: Full Chicago (With Expanded White-Out Box)
chicago_plot <- ggmap(chicago_map) +
  annotate("rect", xmin = -87.65, xmax = -87.60, ymin = 41.87, ymax = 41.92, 
           fill = "white", alpha = 0.1, color = "black", linetype = "dashed") +  # Dashed white-out area
  geom_point(data = top_crash_locations_filtered, aes(x = LONGITUDE, y = LATITUDE, color = "Crash Sites"), 
             size = 2, alpha = 0.9, show.legend = TRUE) +  # Make crash location dots red and add to legend
  geom_text(data = top_crash_locations_filtered, aes(x = LONGITUDE, y = LATITUDE, label = crash_count),
            vjust = -1, hjust = 0.5, size = 3, fontface = "bold", color = "black") +  # Display crash counts
  scale_color_manual(values = c("Crash Sites" = "red")) +  # Define legend color
  labs(title = "Chicago Traffic Crash Hotspots",
       subtitle = "Top 10 high-risk locations based on crash frequency",
       color = "Legend") +  # Add color legend
  theme_minimal(base_family = "Arial") +
  theme(axis.text = element_blank(), 
        axis.title = element_blank(),  # Remove Latitude/Longitude labels
        axis.ticks = element_blank(),
        plot.title = element_text(hjust = 0.5, face = "bold", size = 18),
        plot.subtitle = element_text(hjust = 0.5, size = 14, color = "darkgray"),
        legend.position = "bottom")  # Place legend at bottom for clarity

# MAP 2: Expanded Loop Area (Showing Detailed Crash Locations)
loop_plot <- ggmap(loop_map) +
  geom_point(data = loop_crash_locations, aes(x = LONGITUDE, y = LATITUDE, color = "Crash Sites"), 
             size = 2, alpha = 0.9, show.legend = TRUE) +  # Make crash location dots red and add to legend
  geom_text(data = loop_crash_locations, aes(x = LONGITUDE, y = LATITUDE, label = crash_count),
            vjust = -1, hjust = 0.5, size = 4, fontface = "bold", color = "black") +  # Display crash counts
  scale_color_manual(values = c("Crash Sites" = "red")) +  # Define legend color
  labs(title = "Traffic Crash Hotspots near The Loop",
       subtitle = "Zoomed-in view of downtown Chicago crashes",
       color = "Legend") +  # Add legend title
  theme_minimal(base_family = "Arial") +
  theme(axis.text = element_blank(), 
        axis.title = element_blank(),  
        axis.ticks = element_blank(),
        plot.title = element_text(hjust = 0.5, face = "bold", size = 18),
        plot.subtitle = element_text(hjust = 0.5, size = 14, color = "darkgray"),
        legend.position = "bottom")  # Place legend at bottom for clarity

# Combine Both Maps in One Figure
grid.arrange(chicago_plot, loop_plot, ncol = 2)

########## Analyze What Types of Crashes Are Most Likely ##############

# Load necessary libraries (ensure they are installed before running)
# install.packages(c("readr", "dplyr", "ggplot2", "lubridate", "ggmap", "gridExtra", "gt"))

# Define a function to generate a gt table
get_top_5 <- function(data, column_name, title, column_label) {
  data %>%
    filter(!(!!sym(column_name) %in% c("UNKNOWN", "OTHER", "UNABLE TO DETERMINE", "NOT APPLICABLE"))) %>%
    group_by(!!sym(column_name)) %>%
    summarise(Total_Crashes = n()) %>%
    arrange(desc(Total_Crashes)) %>%
    head(5) %>%
    gt() %>%
    tab_header(
      title = title,
      subtitle = "Based on reported crash incidents"
    ) %>%
    cols_label(
      !!sym(column_name) := column_label,
      Total_Crashes = "Number of Crashes"
    ) %>%
    fmt_number(columns = Total_Crashes, sep_mark = ",")
}

# Generate and print tables
tables <- list(
  get_top_5(CTA_Case_1, "PRIM_CONTRIBUTORY_CAUSE", "Top 5 Primary Contributing Causes of Crashes", "Contributing Cause"),
  get_top_5(CTA_Case_1, "FIRST_CRASH_TYPE", "Top 5 Most Common Crash Types", "Crash Type"),
  get_top_5(CTA_Case_1, "ROADWAY_SURFACE_COND", "Top 5 Roadway Surface Conditions During Crashes", "Road Condition"),
  get_top_5(CTA_Case_1, "LIGHTING_CONDITION", "Top 5 Lighting Conditions During Crashes", "Lighting Condition"),
  get_top_5(CTA_Case_1, "WEATHER_CONDITION", "Top 5 Weather Conditions During Crashes", "Weather Condition"),
  get_top_5(CTA_Case_1, "STREET_NAME", "Top 5 Streets with the Most Crashes", "Street Name"),
  get_top_5(CTA_Case_1, "POSTED_SPEED_LIMIT", "Top 5 Speed Limits with the Most Crashes", "Speed Limit (MPH)")
)

# Print each table sequentially 
for (table in tables) {
  print(table)
} ### ONCE RAN, USE BACK ARROW TO SEE EACH TABLE IN VIEWER, NOT PLOT

########## Finalization & Logging ##########################

# Log environment details for reproducibility
# This helps track package versions and dependencies for future debugging or reruns
session_info <- capture.output(sessionInfo())
writeLines(session_info, "session_info.txt")  # Save session info to a file

# Print completion message with a time stamp for tracking execution time
completion_time <- Sys.time()
message(paste("Data processing and visualization complete. Script finished on:", completion_time))

# Save completion time to a log file for tracking execution history
writeLines(paste("Script completed successfully on:", completion_time), "script_log.txt")
