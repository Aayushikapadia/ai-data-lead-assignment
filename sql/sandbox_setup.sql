-- ============================================================
-- FITPULSE — BigQuery Sandbox Setup
-- Run these queries to create source tables with dummy data.
-- Replace project ID if needed.
-- ============================================================

-- ============================================================
-- 1. USERS
-- ============================================================
CREATE OR REPLACE TABLE `job-agent-488222.fitpulse_dev.users` AS
SELECT * FROM UNNEST([
  STRUCT('u001' AS user_id, 'organic' AS acquisition_source, 'ios' AS platform, 'US' AS country, TIMESTAMP('2024-06-15 10:00:00') AS registration_date),
  STRUCT('u002', 'paid_social', 'android', 'US', TIMESTAMP('2024-09-01 14:30:00')),
  STRUCT('u003', 'referral', 'ios', 'UK', TIMESTAMP('2024-11-20 08:00:00')),
  STRUCT('u004', 'organic', 'android', 'US', TIMESTAMP('2025-01-05 12:00:00')),
  STRUCT('u005', 'paid_search', 'ios', 'CA', TIMESTAMP('2025-02-10 09:15:00')),
  STRUCT('u006', 'organic', 'ios', 'US', TIMESTAMP('2025-02-20 16:00:00')),
  STRUCT('u007', 'paid_social', 'android', 'UK', TIMESTAMP('2025-03-01 11:00:00')),
  STRUCT('u008', 'referral', 'ios', 'US', TIMESTAMP('2025-03-05 08:30:00'))
]);

-- ============================================================
-- 2. APP SESSIONS
-- ============================================================
CREATE OR REPLACE TABLE `job-agent-488222.fitpulse_dev.app_sessions` AS
SELECT * FROM UNNEST([
  -- u001: power user, consistent daily sessions
  STRUCT('s001' AS session_id, 'u001' AS user_id, TIMESTAMP('2025-03-10 07:00:00') AS session_start, TIMESTAMP('2025-03-10 07:45:00') AS session_end),
  STRUCT('s002', 'u001', TIMESTAMP('2025-03-10 18:00:00'), TIMESTAMP('2025-03-10 18:30:00')),
  STRUCT('s003', 'u001', TIMESTAMP('2025-03-11 07:15:00'), TIMESTAMP('2025-03-11 08:00:00')),
  STRUCT('s004', 'u001', TIMESTAMP('2025-03-12 06:50:00'), TIMESTAMP('2025-03-12 07:40:00')),

  -- u002: moderate user
  STRUCT('s005', 'u002', TIMESTAMP('2025-03-10 12:00:00'), TIMESTAMP('2025-03-10 12:25:00')),
  STRUCT('s006', 'u002', TIMESTAMP('2025-03-11 12:10:00'), TIMESTAMP('2025-03-11 12:40:00')),

  -- u003: trial user, drops off
  STRUCT('s007', 'u003', TIMESTAMP('2025-03-10 09:00:00'), TIMESTAMP('2025-03-10 09:20:00')),
  STRUCT('s008', 'u003', TIMESTAMP('2025-03-10 15:00:00'), TIMESTAMP('2025-03-10 15:05:00')),

  -- u004: casual, one session
  STRUCT('s009', 'u004', TIMESTAMP('2025-03-10 20:00:00'), TIMESTAMP('2025-03-10 20:35:00')),

  -- u005: new user, exploring
  STRUCT('s010', 'u005', TIMESTAMP('2025-03-11 10:00:00'), TIMESTAMP('2025-03-11 10:50:00')),
  STRUCT('s011', 'u005', TIMESTAMP('2025-03-12 10:00:00'), TIMESTAMP('2025-03-12 10:30:00')),

  -- u006: bot/invalid session (under 10 seconds — should be filtered)
  STRUCT('s012', 'u006', TIMESTAMP('2025-03-10 03:00:00'), TIMESTAMP('2025-03-10 03:00:08')),

  -- u007: active new user
  STRUCT('s013', 'u007', TIMESTAMP('2025-03-10 14:00:00'), TIMESTAMP('2025-03-10 14:55:00')),
  STRUCT('s014', 'u007', TIMESTAMP('2025-03-11 14:00:00'), TIMESTAMP('2025-03-11 14:40:00')),
  STRUCT('s015', 'u007', TIMESTAMP('2025-03-12 14:00:00'), TIMESTAMP('2025-03-12 15:10:00')),

  -- u008: one-day wonder
  STRUCT('s016', 'u008', TIMESTAMP('2025-03-10 08:00:00'), TIMESTAMP('2025-03-10 08:15:00'))
]);

-- ============================================================
-- 3. WORKOUT EVENTS
-- ============================================================
CREATE OR REPLACE TABLE `job-agent-488222.fitpulse_dev.workout_events` AS
SELECT * FROM UNNEST([
  -- u001: power user, completes everything, uses programs
  STRUCT('w001' AS workout_id, 'u001' AS user_id, 'strength' AS workout_type, 'p001' AS program_id, TIMESTAMP('2025-03-10 07:05:00') AS started_at, TIMESTAMP('2025-03-10 07:40:00') AS completed_at, 320.0 AS calories_burned),
  STRUCT('w002', 'u001', 'cardio', 'p001', TIMESTAMP('2025-03-10 18:05:00'), TIMESTAMP('2025-03-10 18:25:00'), 280.0),
  STRUCT('w003', 'u001', 'strength', 'p001', TIMESTAMP('2025-03-11 07:20:00'), TIMESTAMP('2025-03-11 07:55:00'), 310.0),
  STRUCT('w004', 'u001', 'yoga', CAST(NULL AS STRING), TIMESTAMP('2025-03-12 06:55:00'), TIMESTAMP('2025-03-12 07:30:00'), 150.0),

  -- u002: moderate, sometimes abandons
  STRUCT('w005', 'u002', 'cardio', CAST(NULL AS STRING), TIMESTAMP('2025-03-10 12:05:00'), TIMESTAMP('2025-03-10 12:20:00'), 200.0),
  STRUCT('w006', 'u002', 'strength', 'p002', TIMESTAMP('2025-03-11 12:15:00'), CAST(NULL AS TIMESTAMP), CAST(NULL AS FLOAT64)),

  -- u003: trial user, abandons workout
  STRUCT('w007', 'u003', 'cardio', CAST(NULL AS STRING), TIMESTAMP('2025-03-10 09:05:00'), CAST(NULL AS TIMESTAMP), CAST(NULL AS FLOAT64)),

  -- u004: casual, completes one
  STRUCT('w008', 'u004', 'yoga', CAST(NULL AS STRING), TIMESTAMP('2025-03-10 20:05:00'), TIMESTAMP('2025-03-10 20:30:00'), 120.0),

  -- u005: new user trying programs
  STRUCT('w009', 'u005', 'strength', 'p001', TIMESTAMP('2025-03-11 10:10:00'), TIMESTAMP('2025-03-11 10:45:00'), 290.0),
  STRUCT('w010', 'u005', 'cardio', 'p001', TIMESTAMP('2025-03-12 10:05:00'), TIMESTAMP('2025-03-12 10:25:00'), 250.0),

  -- u007: active, mixes types
  STRUCT('w011', 'u007', 'hiit', CAST(NULL AS STRING), TIMESTAMP('2025-03-10 14:10:00'), TIMESTAMP('2025-03-10 14:45:00'), 400.0),
  STRUCT('w012', 'u007', 'strength', 'p002', TIMESTAMP('2025-03-11 14:10:00'), TIMESTAMP('2025-03-11 14:35:00'), 280.0),
  STRUCT('w013', 'u007', 'cardio', CAST(NULL AS STRING), TIMESTAMP('2025-03-12 14:10:00'), CAST(NULL AS TIMESTAMP), CAST(NULL AS FLOAT64))
]);

-- ============================================================
-- 4. PUSH NOTIFICATIONS
-- ============================================================
CREATE OR REPLACE TABLE `job-agent-488222.fitpulse_dev.push_notifications` AS
SELECT * FROM UNNEST([
  -- u001: gets reminders, opens them
  STRUCT('n001' AS notification_id, 'u001' AS user_id, 'workout_reminder' AS notification_type, TIMESTAMP('2025-03-10 06:30:00') AS sent_at, TIMESTAMP('2025-03-10 06:30:00') AS delivered_at, TIMESTAMP('2025-03-10 06:45:00') AS opened_at),
  STRUCT('n002', 'u001', 'progress_update', TIMESTAMP('2025-03-11 20:00:00'), TIMESTAMP('2025-03-11 20:00:00'), TIMESTAMP('2025-03-11 20:10:00')),

  -- u002: gets reminders, sometimes ignores
  STRUCT('n003', 'u002', 'workout_reminder', TIMESTAMP('2025-03-10 11:30:00'), TIMESTAMP('2025-03-10 11:30:00'), TIMESTAMP('2025-03-10 11:45:00')),
  STRUCT('n004', 'u002', 'promo_offer', TIMESTAMP('2025-03-11 10:00:00'), TIMESTAMP('2025-03-11 10:00:00'), CAST(NULL AS TIMESTAMP)),

  -- u003: gets promo, doesn't open
  STRUCT('n005', 'u003', 'promo_offer', TIMESTAMP('2025-03-10 08:00:00'), TIMESTAMP('2025-03-10 08:00:00'), CAST(NULL AS TIMESTAMP)),
  STRUCT('n006', 'u003', 'workout_reminder', TIMESTAMP('2025-03-11 07:00:00'), TIMESTAMP('2025-03-11 07:00:00'), CAST(NULL AS TIMESTAMP)),

  -- u004: one promo
  STRUCT('n007', 'u004', 'promo_offer', TIMESTAMP('2025-03-10 19:00:00'), TIMESTAMP('2025-03-10 19:00:00'), TIMESTAMP('2025-03-10 19:30:00')),

  -- u005: workout reminders drive sessions
  STRUCT('n008', 'u005', 'workout_reminder', TIMESTAMP('2025-03-11 09:30:00'), TIMESTAMP('2025-03-11 09:30:00'), TIMESTAMP('2025-03-11 09:45:00')),
  STRUCT('n009', 'u005', 'workout_reminder', TIMESTAMP('2025-03-12 09:30:00'), TIMESTAMP('2025-03-12 09:30:00'), TIMESTAMP('2025-03-12 09:40:00')),
  STRUCT('n010', 'u005', 'progress_update', TIMESTAMP('2025-03-12 20:00:00'), TIMESTAMP('2025-03-12 20:00:00'), CAST(NULL AS TIMESTAMP)),

  -- u007: all notifications opened
  STRUCT('n011', 'u007', 'workout_reminder', TIMESTAMP('2025-03-10 13:30:00'), TIMESTAMP('2025-03-10 13:30:00'), TIMESTAMP('2025-03-10 13:35:00')),
  STRUCT('n012', 'u007', 'progress_update', TIMESTAMP('2025-03-11 20:00:00'), TIMESTAMP('2025-03-11 20:00:00'), TIMESTAMP('2025-03-11 20:05:00')),
  STRUCT('n013', 'u007', 'promo_offer', TIMESTAMP('2025-03-12 10:00:00'), TIMESTAMP('2025-03-12 10:00:00'), TIMESTAMP('2025-03-12 10:02:00'))
]);

-- ============================================================
-- 5. AD IMPRESSIONS (free users only)
-- ============================================================
CREATE OR REPLACE TABLE `job-agent-488222.fitpulse_dev.ad_impressions` AS
SELECT * FROM UNNEST([
  -- u003: free user, sees ads
  STRUCT('a001' AS ad_id, 'u003' AS user_id, TIMESTAMP('2025-03-10 09:10:00') AS timestamp, 0.012 AS revenue),
  STRUCT('a002', 'u003', TIMESTAMP('2025-03-10 09:15:00'), 0.008),

  -- u004: free user
  STRUCT('a003', 'u004', TIMESTAMP('2025-03-10 20:10:00'), 0.015),
  STRUCT('a004', 'u004', TIMESTAMP('2025-03-10 20:20:00'), 0.011),
  STRUCT('a005', 'u004', TIMESTAMP('2025-03-10 20:25:00'), 0.009),

  -- u007: free user, heavy usage = more ads
  STRUCT('a006', 'u007', TIMESTAMP('2025-03-10 14:20:00'), 0.013),
  STRUCT('a007', 'u007', TIMESTAMP('2025-03-10 14:40:00'), 0.010),
  STRUCT('a008', 'u007', TIMESTAMP('2025-03-11 14:20:00'), 0.014),
  STRUCT('a009', 'u007', TIMESTAMP('2025-03-12 14:30:00'), 0.012),
  STRUCT('a010', 'u007', TIMESTAMP('2025-03-12 14:50:00'), 0.011),

  -- u008: one-day free user
  STRUCT('a011', 'u008', TIMESTAMP('2025-03-10 08:10:00'), 0.007)
]);

-- ============================================================
-- 6. SUBSCRIPTION EVENTS
-- ============================================================
CREATE OR REPLACE TABLE `job-agent-488222.fitpulse_dev.subscription_events` AS
SELECT * FROM UNNEST([
  -- u001: long-time premium subscriber
  STRUCT('sub001' AS subscription_id, 'u001' AS user_id, 'conversion' AS event_type, 'monthly' AS plan_type, TIMESTAMP('2024-07-01 10:00:00') AS event_timestamp),

  -- u002: trial started, converted
  STRUCT('sub002', 'u002', 'trial_start', 'monthly', TIMESTAMP('2024-09-05 14:00:00')),
  STRUCT('sub003', 'u002', 'conversion', 'monthly', TIMESTAMP('2024-09-19 14:00:00')),

  -- u003: trial started, cancelled
  STRUCT('sub004', 'u003', 'trial_start', 'monthly', TIMESTAMP('2024-11-22 08:00:00')),
  STRUCT('sub005', 'u003', 'cancellation', 'monthly', TIMESTAMP('2024-12-01 08:00:00')),

  -- u005: trial starts during our window
  STRUCT('sub006', 'u005', 'trial_start', 'annual', TIMESTAMP('2025-03-11 11:00:00'))
]);
