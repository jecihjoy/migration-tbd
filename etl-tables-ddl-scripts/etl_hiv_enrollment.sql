drop table etl.amrs_etl_hiv_enrollment;

create table etl.amrs_etl_hiv_enrollment(
uuid char(38) ,
patient_uuid VARCHAR(255) NOT NULL,
visit_id INT(11) DEFAULT NULL,
visit_date_started VARCHAR(255) NOT NULL,
visit_date_stopped VARCHAR(255) NOT NULL,
visit_date_created VARCHAR(255) NOT NULL,
visit_date_changed VARCHAR(255) NOT NULL,
visit_date_voided VARCHAR(255) NOT NULL,
visit_void_reason VARCHAR(255) NOT NULL,
visit_date VARCHAR(255) NOT NULL,
location_id INT(11) DEFAULT NULL,
encounter_id INT(11),
encounter_provider INT(11),
patient_type INT(11),
date_first_enrolled_in_care DATE,
entry_point INT(11),
transfer_in_date VARCHAR(255) NOT NULL,
facility_transferred_from VARCHAR(255),
district_transferred_from VARCHAR(255),
date_started_art_at_transferring_facility DATE,
date_confirmed_hiv_positive VARCHAR(255) NOT NULL,
facility_confirmed_hiv_positive VARCHAR(255),
previous_regimen VARCHAR(255),
arv_status INT(11),
ever_on_pmtct INT(11),
ever_on_pep INT(11),
ever_on_prep INT(11),
ever_on_haart INT(11),
name_of_treatment_supporter VARCHAR(255),
relationship_of_treatment_supporter INT(11),
treatment_supporter_telephone VARCHAR(100),
treatment_supporter_address VARCHAR(100),
in_school INT(11) DEFAULT NULL,
orphan INT(11) DEFAULT NULL,
date_of_discontinuation DATETIME,
discontinuation_reason INT(11),
date_created DATETIME NOT NULL,
date_last_modified DATETIME,
voided INT(11),
CONSTRAINT unique_uuid UNIQUE(uuid),
index(patient_uuid),
index(visit_id),
index(visit_date),
index(date_started_art_at_transferring_facility),
index(arv_status),
index(date_confirmed_hiv_positive),
index(entry_point),
index(transfer_in_date),
index(date_first_enrolled_in_care),
index(entry_point, transfer_in_date, visit_date, patient_uuid)

);