library(RJDBC)

drv <- JDBC("org.postgresql.Driver", "C:/sql_workbench/postgresql-8.4-703.jdbc4.jar")

# drv <- JDBC("org.postgresql.Driver", "C:/sql_workbench/postgresql-9.3-1102.jdbc4.jar") # also works

conn <- dbConnect (drv, "jdbc:postgresql://10.100.148.32:5432/dodobase", "fsu", "fsurocks")

tlist<-dbGetTables(conn) # gives the list of things in the dodobase

# grab data, syntax = (server connection, schema.table)
soil_biomass <- dbReadTable(conn, "biomass_neon.soil_pit_biomass")
soil_horizons <- dbReadTable(conn, "biomass_neon.soil_pit_horizons")
soil_methods <- dbReadTable(conn, "biomass_neon.soil_pit_methods")
soil_properties <- dbReadTable(conn, "biomass_neon.soil_pit_properties")


head(test)

# test query
test2 <- dbGetQuery(conn, "SELECT tag_id FROM mammals_neon.rmnp_2012_captures WHERE ear_tag_replaced Is Not Null")

? dbReadTable

# read one of the soil tables
dbReadTable(conn, "biomass_neon.soil_pit_properties")

? JDBC
