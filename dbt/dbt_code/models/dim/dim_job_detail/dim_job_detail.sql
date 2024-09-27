WITH src_job_detail AS (SELECT * FROM {{ ref('src_job_detail') }})

SELECT
{{dbt_utils.generate_surrogate_key(['id','headline'])}} AS job_detail_id,
{{ capitalize_first_letter_each_word('headline') }} AS headline,
description_text,
employment_type,
coalesce(duration, 'Not Available') AS duration,
salary_type,
coalesce(cast(scope_of_work_min as string), 'Not Available') AS scope_of_work_min,
coalesce(cast(scope_of_work_max as string), 'Not Available') AS scope_of_work_max,
occupation_field,
CASE 
    WHEN engineer_type_id = 1727433259.511136 THEN 'Rymdingenjör'
    WHEN engineer_type_id = 1727433309.497482 THEN 'Driftingenjör'
    WHEN engineer_type_id = 1727433321.8988202 THEN 'Automationsingenjör'
    WHEN engineer_type_id = 1727433333.781475 THEN 'Högskoleingenjör'
    WHEN engineer_type_id = 1727433341.364583 THEN 'Civilingenjör'
    WHEN engineer_type_id = 1727433360.482989 THEN 'Maskiningenjör'
    WHEN engineer_type_id = 1727433368.630014 THEN  'Miljöingenjör'

    ELSE 'Not Available'
END AS engineer_type
FROM src_job_detail
