
Very simple project to fetch data from the ERP database, Datalab-Pantheon, writen in NextJS.


## New Feature

This project now includes a new API endpoint that fetches data using the stored procedure `iw_DnevniPazar`. 

### Fetching Data

The API can now execute two procedures:
- `iw_DnevniPazar 0`: Fetches the initial dataset.
- `iw_DnevniPazar 1`: Fetches the secondary dataset.

You can access this functionality through the `/api/getDnevniPazar` endpoint.
