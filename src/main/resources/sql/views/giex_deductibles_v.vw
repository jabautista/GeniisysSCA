DROP VIEW CPI.GIEX_DEDUCTIBLES_V;

/* Formatted on 2015/05/15 10:41 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giex_deductibles_v (policy_id,
                                                     deductible_text,
                                                     is_package
                                                    )
AS
   SELECT DISTINCT z.policy_id, z.deductible_text, 'N' is_package
              FROM (SELECT a.policy_id, deductible_text
                      FROM gipi_polbasic a,
                           giex_old_group_deductibles b,
                           giis_deductible_desc c
                     WHERE a.policy_id = b.policy_id
                       AND b.line_cd = c.line_cd
                       AND b.subline_cd = c.subline_cd
                       AND b.ded_deductible_cd = c.deductible_cd
                       AND NOT EXISTS (SELECT 1
                                         FROM giex_new_group_deductibles
                                        WHERE policy_id = a.policy_id)
                    UNION ALL
                    SELECT a.policy_id, deductible_text
                      FROM gipi_polbasic a,
                           giex_new_group_deductibles b,
                           giis_deductible_desc c
                     WHERE a.policy_id = b.policy_id
                       AND b.line_cd = c.line_cd
                       AND b.subline_cd = c.subline_cd
                       AND b.ded_deductible_cd = c.deductible_cd) z
             WHERE z.policy_id IN (SELECT policy_id
                                     FROM giex_expiry
                                    WHERE pack_policy_id IS NULL)
   UNION
   SELECT a.pack_policy_id policy_id, b.deductible_text, 'Y' is_package
     FROM giex_pack_expiry a,
          (SELECT gp.policy_id, deductible_text
             FROM gipi_polbasic gp,
                  giex_old_group_deductibles gogd,
                  giis_deductible_desc gdd
            WHERE gp.policy_id = gogd.policy_id
              AND gogd.line_cd = gdd.line_cd
              AND gogd.subline_cd = gdd.subline_cd
              AND gogd.ded_deductible_cd = gdd.deductible_cd
              AND NOT EXISTS (SELECT 1
                                FROM giex_new_group_deductibles
                               WHERE policy_id = gp.policy_id)
           UNION ALL
           SELECT a.policy_id, deductible_text
             FROM gipi_polbasic a,
                  giex_new_group_deductibles b,
                  giis_deductible_desc c
            WHERE a.policy_id = b.policy_id
              AND b.line_cd = c.line_cd
              AND b.subline_cd = c.subline_cd
              AND b.ded_deductible_cd = c.deductible_cd) b
    WHERE b.policy_id IN (SELECT policy_id
                            FROM giex_expiry
                           WHERE pack_policy_id = a.pack_policy_id);


