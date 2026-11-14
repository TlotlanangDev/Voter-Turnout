/* ============================================================================
   PROJECT: South Africa Provincial Voter Turnout Audit & Reconciliation
   AUTHOR:  [Your Name]
   PURPOSE: Validate reported provincial turnout percentages against the IEC 
            formula (% Turnout = Voter Turnout / (Registered + MEC7) * 100)
            and reconcile national benchmark figures.
   ============================================================================ */

-- ----------------------------------------------------------------------------
-- SECTION 1: SCHEMA SETUP & DATA INGESTION
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS sa_voter_turnout;

CREATE TABLE sa_voter_turnout (
    province VARCHAR(50) PRIMARY KEY,
    registered_voters INT NOT NULL,
    mec7_votes INT NOT NULL,
    voter_turnout INT NOT NULL,
    reported_turnout_pct DECIMAL(5, 2) NOT NULL
);

INSERT INTO sa_voter_turnout (province, registered_voters, mec7_votes, voter_turnout, reported_turnout_pct)
VALUES
    ('Eastern Cape', 3628934, 6046, 1787773, 49.18),
    ('Free State', 1533570, 488, 790377, 51.52),
    ('Gauteng', 6751064, 4734, 3619702, 53.58),
    ('KwaZulu-Natal', 6030969, 9033, 3251164, 53.83),
    ('Limpopo', 3037387, 1806, 1468338, 48.31),
    ('Mpumalanga', 2170139, 272, 1129314, 52.03),
    ('North West', 1907623, 1099, 928718, 48.66),
    ('Northern Cape', 710700, 232, 409888, 57.66),
    ('Western Cape', 3457253, 786, 1903630, 55.05);


-- ----------------------------------------------------------------------------
-- SECTION 2: FORMULA VERIFICATION & EXCEPTION FLAGGING
-- ----------------------------------------------------------------------------
SELECT 
    province,
    registered_voters,
    mec7_votes,
    (registered_voters + mec7_votes) AS total_eligible_base,
    voter_turnout,
    reported_turnout_pct,
    ROUND(
        (CAST(voter_turnout AS DECIMAL(18, 4)) / (registered_voters + mec7_votes)) * 100, 
        2
    ) AS recalculated_turnout_pct,
    CASE 
        WHEN ROUND((CAST(voter_turnout AS DECIMAL(18, 4)) / (registered_voters + mec7_votes)) * 100, 2) = reported_turnout_pct 
        THEN 'PASS'
        ELSE 'VARIANCE DETECTED'
    END AS audit_status
FROM sa_voter_turnout
ORDER BY recalculated_turnout_pct DESC;


-- ----------------------------------------------------------------------------
-- SECTION 3: NATIONAL TOTALS RECONCILIATION & BENCHMARKING
-- ----------------------------------------------------------------------------
WITH NationalSummary AS (
    SELECT 
        SUM(registered_voters) AS total_registered,
        SUM(mec7_votes) AS total_mec7,
        SUM(voter_turnout) AS total_turnout,
        ROUND(
            (CAST(SUM(voter_turnout) AS DECIMAL(18, 4)) / (SUM(registered_voters) + SUM(mec7_votes))) * 100, 
            2
        ) AS national_turnout_pct
    FROM sa_voter_turnout
)
SELECT 
    p.province,
    p.reported_turnout_pct AS province_pct,
    n.national_turnout_pct AS national_benchmark_pct,
    (p.reported_turnout_pct - n.national_turnout_pct) AS variance_from_national,
    ROUND((CAST(p.voter_turnout AS DECIMAL(18, 4)) / n.total_turnout) * 100, 2) AS share_of_national_votes_pct
FROM sa_voter_turnout p
CROSS JOIN NationalSummary n
ORDER BY variance_from_national DESC;
