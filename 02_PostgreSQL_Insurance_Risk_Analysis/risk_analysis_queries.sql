-- ============================================================
-- INSURANCE RISK ANALYSIS - POSTGRESQL PROJECT
-- ============================================================

-- ============================================================
-- 1. MODEL BAZINDA POLİÇE VE HASAR ANALİZİ
-- ============================================================
SELECT 
    v.model,
    COUNT(p.policy_id) AS total_policies,
    COUNT(CASE WHEN p.claim_status = '1' THEN 1 END) AS total_claims,
    ROUND(
        COUNT(CASE WHEN p.claim_status = '1' THEN 1 END) * 100.0 
        / COUNT(p.policy_id), 
        2
    ) AS claim_rate_percentage
FROM policies p
JOIN vehicles v 
    ON p.vehicle_id = v.vehicle_id
GROUP BY v.model
ORDER BY claim_rate_percentage DESC;


-- ============================================================
-- 2. ARAÇ YAŞINA GÖRE RİSK SEGMENTASYON ANALİZİ
-- ============================================================
SELECT
    CASE 
        WHEN v.vehicle_age <= 5 THEN 'New'
        WHEN v.vehicle_age <= 10 THEN 'Moderate'
        ELSE 'Old' 
    END AS vehicle_age_group,
    COUNT(p.policy_id) AS total_policies,
    COUNT(CASE WHEN p.claim_status = '1' THEN 1 END) AS total_claims,
    ROUND(
        COUNT(CASE WHEN p.claim_status = '1' THEN 1 END) * 100.0 
        / COUNT(p.policy_id), 
        2
    ) AS claim_rate_percentage
FROM policies p
JOIN vehicles v 
    ON p.vehicle_id = v.vehicle_id
GROUP BY vehicle_age_group
ORDER BY claim_rate_percentage DESC;


-- ============================================================
-- 3. WINDOW FUNCTION VE CTE İLE İLERİ SEVİYE RİSK SIRALAMASI
-- ============================================================
WITH engine_risk AS (
    SELECT
        v.engine_type,
        COUNT(p.policy_id) AS total_policies,
        COUNT(CASE WHEN p.claim_status = '1' THEN 1 END) AS total_claims,
        ROUND(
            COUNT(CASE WHEN p.claim_status = '1' THEN 1 END) * 100.0 
            / COUNT(p.policy_id), 
            2
        ) AS claim_rate_percentage
    FROM policies p
    JOIN vehicles v 
        ON p.vehicle_id = v.vehicle_id
    GROUP BY v.engine_type
)
SELECT
    engine_type,
    total_policies,
    total_claims,
    claim_rate_percentage,
    RANK() OVER (
        ORDER BY claim_rate_percentage DESC
    ) AS risk_rank
FROM engine_risk
ORDER BY risk_rank;
