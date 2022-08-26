# Migration

### Copying data from kenya emr etl tables to production tables
(Tambach - location_id = 94)
1. Migrate patient demographics
2. Migrate visit types
3. Migrate encounter types
4. Migrate locations
5. What about forms
6. Select data from etl table and stop in memory in an array. 
    a) For each table/map create a visit and an encounter
    b) The for each column, get conceptId and obs column to insert, construct obs table insert statements

1. Create patients - Tambach
2. List of enrollment encounters - for each encounter, retrieve patient, create visit, create an encounter, create obs one by one from the encounter map


1. Resolve person id using patient uuid x
2. Insert into visit   
`insert into visit (null,x,{visit_type_id},enrollmentData.visit_date_started,enrollmentData.visit_date_stopped,null,{location_id},{creator},enrollmentData.visit_date_created,{changed_by},enrollmentData.visit_date_changed,{voided},{voided_by},enrollmentData.visit_date_voided,enrollmentData.visit_void_reason,null); `
3. Insert into encounter
`insert into encounter (null,{encounter_type},x,{location_id},{form_id},enrollmentData.visit_date,{creator},enrollmentData.date_created,null,null,null,null,null,{changed_by},enrollmentData.date_last_modified,visit_id_x)`
4. Insert into obs
`insert into obs (person_id,concept_id,encounter_id,order_id,obs_datetime,location_id,obs_group_id,accession_number,value_group_id,obj.columnToInsert,value_coded_name_id,comments,creator,date_created,status) value (obj.person_id,obj.conceptID,encounter_id,null,obj.visit_date,location_id,null,null,null,obj.columnName,null,null,creator,date_created,obj.status)`


## Assumptions
1. Using encounter datetime as obs datetime for all obs
2. What about grouped observations?
3. 



