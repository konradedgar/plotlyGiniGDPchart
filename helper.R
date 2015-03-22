
# Data --------------------------------------------------------------------

# Download and view
toc <- getEurostatTOC()
utils::View(toc)

# Export to the Excel file
library(xlsx)
write.xlsx(toc, "toc.xlsx")