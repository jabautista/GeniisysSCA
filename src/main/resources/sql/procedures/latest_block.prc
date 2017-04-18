DROP PROCEDURE CPI.LATEST_BLOCK;

CREATE OR REPLACE PROCEDURE CPI.latest_block(p_line_cd      IN gipi_polbasic.line_cd%TYPE,
                         p_subline_cd   IN gipi_polbasic.line_cd%TYPE,
                         p_iss_cd       IN gipi_polbasic.iss_cd%TYPE,
                         p_issue_yy     IN gipi_polbasic.issue_yy%TYPE,
                         p_pol_seq_no   IN gipi_polbasic.pol_seq_no%TYPE,
                         p_renew_no     IN gipi_polbasic.renew_no%TYPE,
                         p_item_no      IN gipi_fireitem.item_no%TYPE,
                         v_block_no    OUT gipi_fireitem.block_no%TYPE,
                         v_district_no OUT gipi_fireitem.district_no%TYPE,
                         v_province_cd OUT giis_block.province_cd%TYPE,
                         v_city        OUT giis_block.city%TYPE,
                         v_block_id    OUT giis_block.block_id%TYPE,
                         v_risk_cd    OUT gipi_fireitem.risk_cd%TYPE) IS
  BEGIN
    FOR blk IN (SELECT z.block_no,     y.district_no,      z.province_cd,
                       z.city,         z.block_id,risk_cd
                  FROM gipi_polbasic x,
                       gipi_fireitem y,
                       giis_block z
                 WHERE x.line_cd    = p_line_cd
                   AND x.subline_cd = p_subline_cd
                   AND x.iss_cd     = p_iss_cd
                   AND x.issue_yy   = p_issue_yy
                   AND x.pol_seq_no = p_pol_seq_no
                   AND x.renew_no   = p_renew_no
                   AND x.pol_flag IN ('1','2','3','X')
                   AND NOT EXISTS(SELECT 'X'
                                    FROM gipi_polbasic m,
                                         gipi_fireitem  n
                                   WHERE m.line_cd    = p_line_cd
                                     AND m.subline_cd = p_subline_cd
                                     AND m.iss_cd     = p_iss_cd
                                     AND m.issue_yy   = p_issue_yy
                                     AND m.pol_seq_no = p_pol_seq_no
                                     AND m.renew_no   = p_renew_no
                                     AND m.pol_flag IN ('1','2','3','X')
                                     AND m.endt_seq_no > x.endt_seq_no
                                     AND nvl(m.back_stat,5) = 2
                                     AND m.policy_id  = n.policy_id
                                     AND n.item_no    = p_item_no
                                     AND (n.block_no IS NOT NULL
									   OR n.district_no IS NOT NULL))
                   AND x.policy_id  = y.policy_id
                   AND y.block_id   = z.block_id
                   AND y.item_no    = p_item_no
                   AND (y.block_no IS NOT NULL OR y.district_no IS NOT NULL)
              ORDER BY x.eff_date DESC)
    LOOP
      v_block_no    := blk.block_no;
      v_district_no := blk.district_no;
      v_province_cd := blk.province_cd;
      v_city        := blk.city;
      v_block_id    := blk.block_id;
            v_risk_Cd    := blk.risk_cd;
      EXIT;
    END LOOP;
  END;
/


