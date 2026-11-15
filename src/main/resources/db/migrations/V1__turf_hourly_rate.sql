USE apex_turf;

SET @has_hourly_rate = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'turfs' AND column_name = 'hourly_rate'
);
SET @add_hourly_rate = IF(
    @has_hourly_rate = 0,
    'ALTER TABLE turfs ADD COLUMN hourly_rate DECIMAL(10,2) NOT NULL DEFAULT 0.00',
    'SELECT 1'
);
PREPARE add_hourly_rate_stmt FROM @add_hourly_rate;
EXECUTE add_hourly_rate_stmt;
DEALLOCATE PREPARE add_hourly_rate_stmt;
