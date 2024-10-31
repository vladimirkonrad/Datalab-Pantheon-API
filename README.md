# Project Overview

This is a simple project to fetch data from the ERP database, Datalab-Pantheon, written in Next.js.

## New Feature

The project now includes a new API endpoint that fetches data using the stored procedure `iw_DnevniPazar`.

### Fetching Data

The API can now execute two procedures:
- **`iw_DnevniPazar 0`**: Fetches the initial dataset.
- **`iw_DnevniPazar 1`**: Fetches the secondary dataset.

### Overview of the Procedure

The provided SQL procedure, `iw_DnevniPazar`, is designed to generate a report of current market transactions based on retail sales (referred to as "maloprodajama") from a database. Here's a breakdown of its components and functionality:

1. **Input Parameter**:
   - `@OnlySum bit`: A bit flag that determines whether to return detailed results or just a summary.

2. **Variable Declaration**:
   - `@danas smalldatetime`: A variable to store the current date.

3. **Procedure Logic**:
   - The procedure begins by setting the `@danas` variable to the current date using `GETDATE()`.

4. **Data Selection**:
   - A `SELECT` statement retrieves data from multiple joined tables (`the_Move`, `the_MoveItem`, `tPA_SetDocType`, `tHE_SetItem`, `tHE_SetTax`, and `vHE_MoveItemDistKeyItem`) and stores the results in a temporary table called `#temp`.
   - The `WHERE` clause filters the records based on specific document types, item sets, and the invoice date, ensuring that only relevant transactions for the current day are included.

5. **Data Update**:
   - An `UPDATE` statement modifies the `Naziv` (name) field in the `#temp` table for specific market points (`MP`) based on their values. For example:
     - If `MP` is '32Q', it changes `Naziv` to 'MP Pancevo'.
     - If `MP` is '32H', it changes it to 'MP Cacak'.

6. **Conditional Result Set**:
   - If `@OnlySum` is `0`, the procedure returns detailed results, including:
     - Count of transactions (`BrojRacuna`)
     - Total amount (`Pazar`) grouped by market point (`MP`) and name (`Naziv`).
   - If `@OnlySum` is `1`, it returns only the total amount (`Pazar`) without the detailed breakdown.

### Summary

In essence, this procedure is used to generate a report of daily market transactions, allowing users to either view detailed transaction counts and amounts or just the total amount based on the input parameter. The use of temporary tables and conditional logic makes it flexible for different reporting needs.

You can access this functionality through the `/api/getDnevniPazar` endpoint.
