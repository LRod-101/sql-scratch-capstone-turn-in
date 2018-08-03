/* Question 1 */

/*A1*/
SELECT COUNT(DISTINCT utm_campaign)
FROM page_visits
UNION
SELECT DISTINCT utm_campaign
FROM page_visits;

/*A2*/
SELECT COUNT (DISTINCT utm_source)
FROM page_visits
UNION
SELECT DISTINCT utm_source
FROM page_visits;

/*A3*/
SELECT DISTINCT utm_campaign, utm_source
FROM page_visits;

/*B*/
SELECT DISTINCT page_name
FROM page_visits;

/*Question 2*/

/*A*/
WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id
),
ft_attr AS (
  SELECT ft.user_id,
    ft.first_touch_at,
    pv.utm_campaign
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
)
SELECT ft_attr.utm_campaign,
       COUNT(*)
FROM ft_attr
GROUP BY 1
ORDER BY 2 DESC;

/*or*/

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id
),
ft_attr AS (
  SELECT ft.user_id,
    ft.first_touch_at,
    pv.utm_campaign, pv.utm_source
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
)
SELECT ft_attr.utm_campaign, ft_attr.utm_source,
       COUNT(*)
FROM ft_attr
GROUP BY 1,2
ORDER BY 3 DESC;

/*B*/
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id
),
lt_attr AS (
  SELECT lt.user_id,
    lt.last_touch_at,
    pv.utm_campaign
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_campaign,
       COUNT(*)
FROM lt_attr
GROUP BY 1
ORDER BY 2 DESC;

/*or*/

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id
),
lt_attr AS (
  SELECT lt.user_id,
    lt.last_touch_at,
    pv.utm_campaign, pv.utm_source
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_campaign, lt_attr.utm_source,
       COUNT(*)
FROM lt_attr
GROUP BY 1,2
ORDER BY 3 DESC;

/*C*/
WITH buyers AS (
  SELECT page_name, user_id
	FROM page_visits
	WHERE page_name = '4 - purchase'
	Group BY user_id)
SELECT COUNT(user_id) as 'USERS WHO MADE A PURCHASE'
FROM buyers;

/*D*/
WITH last_touch AS (
    SELECT user_id, page_name,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    WHERE  page_visits.page_name = '4 - purchase'
    GROUP BY user_id
),
lt_attr AS (
  SELECT lt.user_id,
    lt.last_touch_at,
    pv.utm_campaign, pv.utm_source
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_campaign, lt_attr.utm_source,
       COUNT(*)
FROM lt_attr
GROUP BY 1,2
ORDER BY 3 DESC;