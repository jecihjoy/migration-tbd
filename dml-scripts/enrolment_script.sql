use etl;

desc etl.flat_hiv_summary_v15b;

select * from etl.amrs_etl_hiv_enrollment;


SELECT 
    fhs.uuid AS patient_uuid,
    fhs.encounter_datetime AS visit_date,
    e.date_created,
    CASE
        WHEN e.date_changed IS NOT NULL THEN e.date_changed
        ELSE e.date_created
    END AS date_last_modified,
    CASE
        WHEN
            enrollment_date = '1900-01-01'
                OR DATE(transfer_in_date) = DATE(e.encounter_datetime)
        THEN
            160563
        ELSE 164144
    END AS patient_type,
    enrollment_date AS date_first_enrolled_in_care,
    CASE
        WHEN o1.value_coded IS NULL THEN NULL
        WHEN o1.value_coded IN (2049 , 8227) THEN 159938
        WHEN o1.value_coded IN (2047 , 10862, 2177, 9258, 174, 9257) THEN 160539
        WHEN o1.value_coded = 2050 THEN 159937
        WHEN o1.value_coded IN (8349 , 1776) THEN 160536
        WHEN o1.value_coded = 8350 THEN 160537
        WHEN o1.value_coded = 10649 THEN 160541
        WHEN o1.value_coded = 1965 THEN 160542
        WHEN o1.value_coded = 2240 THEN 162050
        WHEN o1.value_coded = 9606 THEN 160551
        WHEN o1.value_coded = 5622 THEN 5622
    END AS entry_point,
    transfer_in_date,
    arv_first_regimen_start_date AS date_started_art_at_transferring_facility,
    hiv_start_date AS date_confirmed_hiv_positive,
    o2.value_coded AS arv_status
FROM
    etl.flat_hiv_summary_v15b fhs
        LEFT JOIN
    amrs.encounter e USING (encounter_id)
        LEFT JOIN
    amrs.obs o1 ON (o1.encounter_id = e.encounter_id
        AND o1.concept_id = 2051 and o1.voided = 0)
        LEFT JOIN
    amrs.obs o2 ON (o2.encounter_id = e.encounter_id
        AND o2.concept_id = 1633 and o1.voided = 0)
WHERE
    #fhs.uuid = '2a4af8a4-845a-440c-b5b4-5b0dbec3f344'
        fhs.encounter_type IN (1 , 3, 105) and fhs.location_id = 94
ORDER BY fhs.encounter_datetime DESC;

select * from etl.flat_hiv_summary_v15b  where uuid = '2a4af8a4-845a-440c-b5b4-5b0dbec3f344';

desc amrs.visit;

select * from etl.amrs_etl_hiv_enrollment;
drop table etl.amrs_etl_hiv_enrollment;


REPLACE into etl.amrs_etl_hiv_enrollment 
(patient_uuid,visit_date_started,visit_date_stopped,visit_date_created,visit_date_changed,visit_date_voided,visit_void_reason,visit_date,date_created,
date_last_modified,patient_type,date_first_enrolled_in_care,entry_point,transfer_in_date,date_started_art_at_transferring_facility,date_confirmed_hiv_positive,arv_status)
SELECT 
    fhs.uuid AS patient_uuid,
    v.date_started as visit_date_started,
    v.date_stopped as visit_date_stopped,
    v.date_created as visit_date_created,
    v.date_changed as visit_date_changed,
    v.date_voided as visit_date_voided,
    v.void_reason as visit_void_reason,
    fhs.encounter_datetime AS visit_date,
    e.date_created,
    CASE
        WHEN e.date_changed IS NOT NULL THEN e.date_changed
        ELSE e.date_created
    END AS date_last_modified,
    CASE
        WHEN
            enrollment_date = '1900-01-01'
                OR DATE(transfer_in_date) = DATE(e.encounter_datetime)
        THEN
            160563
        ELSE 164144
    END AS patient_type,
    enrollment_date AS date_first_enrolled_in_care,
    CASE
        WHEN o1.value_coded IS NULL THEN NULL
        WHEN o1.value_coded IN (2049 , 8227) THEN 159938
        WHEN o1.value_coded IN (2047 , 10862, 2177, 9258, 174, 9257) THEN 160539
        WHEN o1.value_coded = 2050 THEN 159937
        WHEN o1.value_coded IN (8349 , 1776) THEN 160536
        WHEN o1.value_coded = 8350 THEN 160537
        WHEN o1.value_coded = 10649 THEN 160541
        WHEN o1.value_coded = 1965 THEN 160542
        WHEN o1.value_coded = 2240 THEN 162050
        WHEN o1.value_coded = 9606 THEN 160551
        WHEN o1.value_coded = 5622 THEN 5622
    END AS entry_point,
    transfer_in_date,
    arv_first_regimen_start_date AS date_started_art_at_transferring_facility,
    hiv_start_date AS date_confirmed_hiv_positive,
    o2.value_coded AS arv_status
FROM
    etl.flat_hiv_summary_v15b fhs
        LEFT JOIN
    amrs.encounter e USING (encounter_id)
    left join amrs.visit v on v.visit_id = fhs.visit_id
        LEFT JOIN
    amrs.obs o1 ON (o1.encounter_id = e.encounter_id
        AND o1.concept_id = 2051 and o1.voided = 0)
        LEFT JOIN
    amrs.obs o2 ON (o2.encounter_id = e.encounter_id
        AND o2.concept_id = 1633 and o1.voided = 0)
WHERE
    fhs.location_id = 94
        AND fhs.encounter_type IN (1 , 3, 105)
ORDER BY fhs.encounter_datetime DESC;