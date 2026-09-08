/* 
Explaining CTEs:
1) cleaned_events - taking only the columns I need from the raw_events table,
    as well as picking the right date format.
2) first_session and first_purchase - getting the first daily session_start and purchase
    events for each user.
3) time_to_conversion - joining first_session and first_purchase CTEs and subtracting the
    timestamps to get the time of funnel conversion and converted the timestamps 
    (which are in microseconds) to seconds and minutes. I've also set a rank column 
    which indicates whether it was the first purchase by the user.
4) final query - joined time_to_conversion CTE with several additional categorical variables from 
    cleaned_events CTE. Created clear categorical columns, describing traffic_source, purchase_type,
    and conversion_speed.
*/

WITH cleaned_events AS (
    SELECT 
        user_pseudo_id AS user_id,
        event_name,
        PARSE_DATE('%Y%m%d', event_date) AS session_date,
        event_timestamp,
        category,
        medium,
        country,
        purchase_revenue_in_usd AS revenue_usd
    FROM `turing_data_analytics.raw_events`
),

first_session AS (
    SELECT
        user_id,
        session_date,
        MIN(event_timestamp) AS time_session_start
    FROM cleaned_events
    WHERE event_name = "session_start"
    GROUP BY user_id, session_date
),

first_purchase AS (
    SELECT
        user_id,
        session_date,
        MIN(event_timestamp) AS time_purchase
    FROM cleaned_events
    WHERE event_name = "purchase"
    GROUP BY user_id, session_date
),

time_to_conversion AS (
    SELECT 
        fs.session_date,
        fs.user_id,
        fs.time_session_start,
        fp.time_purchase,
        TIMESTAMP_DIFF(
            TIMESTAMP_MICROS(fp.time_purchase),
            TIMESTAMP_MICROS(fs.time_session_start),
            SECOND
        ) AS conversion_seconds,
        TIMESTAMP_DIFF(
            TIMESTAMP_MICROS(fp.time_purchase),
            TIMESTAMP_MICROS(fs.time_session_start),
            MINUTE
        ) AS conversion_minutes,
        RANK () OVER (
            PARTITION BY fs.user_id ORDER BY fs.session_date
            ) AS rank_purchase_by_user
    FROM first_session fs
    INNER JOIN first_purchase fp
        ON fs.user_id = fp.user_id
        AND fs.session_date = fp.session_date
    WHERE fp.time_purchase > fs.time_session_start
)

SELECT 
    ttc.session_date,
    ttc.user_id,
    purchase.category,
    purchase.country,
    CASE
        WHEN session.medium = "organic" THEN "organic"
        WHEN session.medium = "referral" THEN "referral"
        WHEN session.medium = "cpc" THEN "advertising"
        WHEN session.medium = "(data deleted)" THEN "unknown"
        WHEN session.medium = "(none)" THEN "direct"
        ELSE "other"
        END AS traffic_source,
    ttc.time_session_start,
    ttc.time_purchase,
    ttc.conversion_seconds,
    ttc.conversion_minutes,
    CASE 
        WHEN ttc.conversion_minutes < 5 THEN "very_fast"
        WHEN ttc.conversion_minutes < 10 THEN "fast"
        WHEN ttc.conversion_minutes < 60 THEN "regular"
        WHEN ttc.conversion_minutes < 180 THEN "slow"
        ELSE "very_slow"
        END AS conversion_speed,
    CASE 
        WHEN ttc.rank_purchase_by_user = 1 THEN "first_buy"
        ELSE "repeat_buy"
        END AS purchase_type,
    purchase.revenue_usd
FROM time_to_conversion ttc
INNER JOIN cleaned_events session
    ON session.user_id = ttc.user_id
    AND session.session_date = ttc.session_date
    AND session.event_timestamp = ttc.time_session_start
    AND session.event_name = "session_start"
INNER JOIN cleaned_events purchase
    ON purchase.user_id = ttc.user_id
    AND purchase.session_date = ttc.session_date
    AND purchase.event_timestamp = ttc.time_purchase
    AND purchase.event_name = "purchase"
ORDER BY session_date, user_id;


