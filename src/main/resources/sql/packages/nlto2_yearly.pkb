CREATE OR REPLACE PACKAGE BODY CPI.Nlto2_yearly AS
   PROCEDURE main_nlto2(
     v_date      VARCHAR2,
     v_lto       VARCHAR2,             --  lto / nlto
     v_basis     VARCHAR2,             --  acct_ent_date/issue_date/eff_date/bk_date
     v_iss_cd    VARCHAR2,             --  ri business included/excluded
     v_zone      VARCHAR2,
     v_zone_type NUMBER,
     v_year      NUMBER,
     v_user      VARCHAR2,
     v_sys       DATE
 )
   AS
     v_subline giis_parameters.param_value_v%TYPE;
     v_line    giis_parameters.param_value_v%TYPE;
   BEGIN
     DELETE
     FROM gixx_nlto_stat
     WHERE user_id = v_user;
     COMMIT;
     IF v_basis IN ('AD', 'ED','ID')  THEN
        nlto_by_ad(v_basis,v_year, v_zone,v_zone_type, v_iss_cd, v_user, v_sys);
     ELSE
        nlto_by_bd(v_year, v_zone,v_zone_type, v_iss_cd, v_user, v_sys);
     END IF;
    END;
    PROCEDURE nlto_by_ad(
       v_basis     VARCHAR2,
       v_year      NUMBER,
       v_zone       VARCHAR2,
       v_zone_type   NUMBER,
       v_iss_cd      VARCHAR2,
       v_user        VARCHAR2,
       v_sys         DATE)
     AS
        v_prem gipi_polbasic.prem_amt%TYPE;
        v_subline giis_parameters.param_value_v%TYPE;
        v_line    giis_parameters.param_value_v%TYPE;
        v_desc    giis_mc_subline_type.subline_type_desc%TYPE;
        v_peril_stat_name VARCHAR2(50);
        peril_name giis_peril.peril_name%TYPE;
        pc_count  gixx_nlto_stat.pc_count%TYPE :=0;
        pc_prem   gixx_nlto_stat.pc_prem%TYPE  :=0;
        mc_count  gixx_nlto_stat.mc_count%TYPE :=0;
        mc_prem   gixx_nlto_stat.mc_prem%TYPE  :=0;
        cv_count  gixx_nlto_stat.cv_count%TYPE :=0;
        cv_prem   gixx_nlto_stat.cv_prem%TYPE :=0;
        v_subline_mc gipi_polbasic.subline_cd%TYPE;
        v_subline_pc gipi_polbasic.subline_cd%TYPE;
        v_subline_cv gipi_polbasic.subline_cd%TYPE;
        v_policy_no VARCHAR2(50);
        policy_no VARCHAR2(50);
        v_switch VARCHAR2(1):='Y';
     BEGIN
        FOR c IN (SELECT a.param_value_v mc,
                         b.param_value_v pc,
                         c.param_value_v cv,
                         d.param_value_v   line
                   FROM giis_parameters a,
                        giis_parameters b,
                        giis_parameters c,
                        giis_parameters d
                   WHERE a.param_name = 'MOTORCYCLE'
                   AND b.param_name = 'PRIVATE CAR'
                   AND c.param_name = 'COMMERCIAL VEHICLE'
                   AND  d.param_name = 'MOTOR CAR')
        LOOP
             v_subline_mc  := c.mc;
             v_subline_pc  := c.pc;
             v_subline_cv  := c.cv;
             v_line        := c.line;
        END LOOP;
           dbms_output.put_line(v_subline_mc ||' MC');
           dbms_output.put_line(v_subline_pc || ' PC');
           dbms_output.put_line(v_subline_cv || ' CV');
           dbms_output.put_line(v_line || 'LINE');
           dbms_output.put_line(v_zone_type || 'VZONETYPE');
           IF v_zone_type <> 0 THEN
             FOR c IN (SELECT  peril_name
                       FROM giis_peril
                       WHERE line_cd = v_line)
             LOOP
                     INSERT INTO gixx_nlto_stat
                     (coverage,
                      peril_name,
                      user_id,
                      last_update)
                     VALUES
                     (v_zone_type,
                      c.peril_name,
                      v_user,
                      v_sys);
             END LOOP;
             COMMIT;
           ELSE
              FOR cov IN (SELECT coverage_desc coverage
                        FROM giis_coverage)
              LOOP
                  FOR c IN (SELECT  peril_name
                       FROM giis_peril
                       WHERE line_cd = v_line)
                  LOOP
                     INSERT INTO gixx_nlto_stat
                     (coverage,
                      peril_name,
                      user_id,
                      last_update)
                     VALUES
                     (cov.coverage,
                      c.peril_name,
                      v_user,
                      v_sys);
                   END LOOP;
              END LOOP;
           END IF;
           dbms_output.put_line('TESTING');
           COMMIT;
           FOR  c1 IN (SELECT
                        a.line_cd,
                        a.subline_cd,
                        a.iss_cd,
                        a.issue_yy,
                        a.pol_seq_no,
                        a.renew_no,
                        b.item_no,
                        SUM(c.prem_amt * b.currency_rt)prem_amt,
                        h.peril_name,
                        g.coverage_desc
                     FROM (SELECT coverage_cd, coverage_desc
                           FROM giis_coverage
                           WHERE coverage_cd = DECODE(v_zone_type,0,coverage_cd,v_zone_type))g,
                           gipi_polbasic a,
                           gipi_item b,
                           gipi_itmperil c,
                           gipi_vehicle d,
                           giis_mc_subline_type f,
                           giis_peril h
                     WHERE a.policy_id = b.policy_id
                     AND b.policy_id = c.policy_id
                     AND b.item_no = c.item_no
                     AND b.policy_id = d.policy_id
                     AND a.iss_cd <> DECODE(v_iss_cd, 'T', '**','RI')
                     AND b.item_no = d.item_no
                     AND d.subline_cd = f.subline_cd
                     AND d.subline_type_cd = f.subline_type_cd
                     AND b.coverage_cd = g.coverage_cd
                     AND a.line_cd = h.line_cd
                     AND c.peril_cd = h.peril_cd
                     AND (a.pol_flag = '1' OR
                          a.pol_flag = '2' OR
                          a.pol_flag = '3')
                     AND a.dist_flag = '3'
                     AND DECODE(v_basis,'AD',TO_CHAR(TRUNC(a.acct_ent_date),'YYYY'),
                                        'ID',TO_CHAR(TRUNC(a.issue_date),'YYYY'),
                                        'ED',TO_CHAR(TRUNC(a.eff_date),'YYYY'))
                        =  DECODE(v_basis,'AD',v_year,
                                           'ID',v_year,
                                           'ED',v_year)
                     AND (a.subline_cd IN (v_subline_pc, v_subline_mc, v_subline_cv)
                           OR (b.pack_subline_cd IN (v_subline_pc, v_subline_mc, v_subline_cv)
                               AND b.pack_line_cd = v_line))
                     GROUP BY  a.line_cd,
                               a.subline_cd,
                               a.iss_cd ,
                               a.issue_yy,
                               a.pol_seq_no,
                               a.renew_no,
                               b.item_no,
                               h.peril_name,
                               g.coverage_desc)
           LOOP
              v_prem := c1.prem_amt;
              dbms_output.put_line('TEST');
              IF v_zone_type <> 0 THEN
                  UPDATE gixx_nlto_stat
                  SET coverage = c1.coverage_desc;
                  COMMIT;
                  IF c1.subline_cd = v_subline_pc THEN
                    UPDATE gixx_nlto_stat
                    SET pc_prem  = NVL(pc_prem,0) + NVL(v_prem,0)
                    WHERE peril_name = c1.peril_name;
                    COMMIT;
                  ELSIF c1.subline_cd = v_subline_mc THEN
                    UPDATE gixx_nlto_stat
                    SET mc_prem  = NVL(mc_prem,0) + NVL(v_prem,0)
                    WHERE peril_name = c1.peril_name;
                    COMMIT;
                  ELSE
                    UPDATE gixx_nlto_stat
                    SET cv_prem  = NVL(cv_prem,0) + NVL(v_prem,0)
                    WHERE peril_name = c1.peril_name;
                    COMMIT;
                 END IF;
            ELSE    --v_zone_type 0
                  IF c1.subline_cd = v_subline_pc THEN
                        UPDATE gixx_nlto_stat
                        SET pc_prem  = NVL(pc_prem,0) + NVL(v_prem,0)
                        WHERE peril_name = c1.peril_name
                        AND coverage = c1.coverage_desc;
                  ELSIF c1.subline_cd = v_subline_mc THEN
                        UPDATE gixx_nlto_stat
                        SET mc_count = NVL(mc_count,0) + 1,
                            mc_prem  = NVL(mc_prem,0) + NVL(v_prem,0)
                        WHERE peril_name = c1.peril_name
                        AND coverage = c1.coverage_desc;
                  ELSE
                        UPDATE gixx_nlto_stat
                        SET cv_count = NVL(cv_count,0) + 1,
                            cv_prem  = NVL(cv_prem,0) + NVL(v_prem,0)
                        WHERE peril_name = c1.peril_name
                        AND coverage = c1.coverage_desc;
                  END IF;
               COMMIT;
            END IF;
       END LOOP;
              FOR  cnt IN (SELECT COUNT(DISTINCT
                                          a.line_cd ||
                                          a.subline_cd ||
                                          a.iss_cd ||
                                          TO_CHAR(a.issue_yy) ||
                                          TO_CHAR(a.pol_seq_no) ||
                                          TO_CHAR(a.renew_no)) cnt,
                                          a.subline_cd,
                                          g.coverage_desc
                     FROM (SELECT coverage_cd, coverage_desc
                           FROM giis_coverage
                           WHERE coverage_cd = DECODE(v_zone_type,0,coverage_cd,v_zone_type))g,
                           gipi_polbasic a,
                           gipi_item b,
                           gipi_itmperil c,
                           gipi_vehicle d,
                           giis_mc_subline_type f,
                           giis_peril h
                     WHERE a.policy_id = b.policy_id
                     AND b.policy_id = c.policy_id
                     AND b.item_no = c.item_no
                     AND b.policy_id = d.policy_id
                     AND a.iss_cd <> DECODE(v_iss_cd, 'T', '**','RI')
                     AND b.item_no = d.item_no
                     AND d.subline_cd = f.subline_cd
                     AND d.subline_type_cd = f.subline_type_cd
                     AND b.coverage_cd = g.coverage_cd
                     AND (a.pol_flag = '1' OR
                          a.pol_flag = '2' OR
                          a.pol_flag = '3')
                     AND a.dist_flag = '3'
                     AND a.line_cd = h.line_cd
                     AND c.peril_cd = h.peril_cd
                     AND DECODE(v_basis,'AD',TO_CHAR(TRUNC(a.acct_ent_date),'YYYY'),
                                        'ID',TO_CHAR(TRUNC(a.issue_date),'YYYY'),
                                        'ED',TO_CHAR(TRUNC(a.eff_date),'YYYY'))
                        =  DECODE(v_basis,'AD',v_year,
                                           'ID',v_year,
                                           'ED',v_year)
                     AND (a.subline_cd IN (v_subline_pc, v_subline_mc, v_subline_cv)
                           OR (b.pack_subline_cd IN (v_subline_pc, v_subline_mc, v_subline_cv)
                               AND b.pack_line_cd = v_line))
                     GROUP BY a.subline_cd, g.coverage_desc)
             LOOP
               IF v_zone_type  <> 0 THEN
                 IF cnt.subline_cd = v_subline_pc THEN
                     UPDATE gixx_nlto_stat
                     SET pc_count = cnt.cnt;
                     --where peril_name = cnt.peril_name;
                 ELSIF cnt.subline_cd = v_subline_mc THEN
                     UPDATE gixx_nlto_stat
                     SET mc_count = cnt.cnt;
                     --where peril_name = cnt.peril_name;
                 ELSE
                     UPDATE gixx_nlto_stat
                     SET cv_count = cnt.cnt;
                     --where peril_name = cnt.peril_name;
                 END IF;
                 COMMIT;
             ELSE
                IF cnt.subline_cd = v_subline_pc THEN
                     UPDATE gixx_nlto_stat
                     SET pc_count = cnt.cnt
                     --where peril_name = cnt.peril_name
                     WHERE coverage = cnt.coverage_desc;
                 ELSIF cnt.subline_cd = v_subline_mc THEN
                     UPDATE gixx_nlto_stat
                     SET mc_count = cnt.cnt
                     --where peril_name = cnt.peril_name
                     WHERE coverage = cnt.coverage_desc;
                 ELSE
                     UPDATE gixx_nlto_stat
                     SET cv_count = cnt.cnt
                     --where peril_name = cnt.peril_name
                     WHERE coverage = cnt.coverage_desc;
                 END IF;
                 COMMIT;
             END IF;
           END LOOP; --cnt
      COMMIT;
   END;
-------------------
-------------------
-------------------
    PROCEDURE nlto_by_bd(
       v_year      NUMBER,
       v_zone       VARCHAR2,
       v_zone_type   NUMBER,
       v_iss_cd      VARCHAR2,
       v_user        VARCHAR2,
       v_sys         DATE)
     AS
        v_prem gipi_polbasic.prem_amt%TYPE;
        v_subline giis_parameters.param_value_v%TYPE;
        v_line    giis_parameters.param_value_v%TYPE;
        v_desc    giis_mc_subline_type.subline_type_desc%TYPE;
        v_peril_stat_name VARCHAR2(50);
        peril_name giis_peril.peril_name%TYPE;
        pc_count  gixx_nlto_stat.pc_count%TYPE :=0;
        pc_prem   gixx_nlto_stat.pc_prem%TYPE  :=0;
        mc_count  gixx_nlto_stat.mc_count%TYPE :=0;
        mc_prem   gixx_nlto_stat.mc_prem%TYPE  :=0;
        cv_count  gixx_nlto_stat.cv_count%TYPE :=0;
        cv_prem   gixx_nlto_stat.cv_prem%TYPE :=0;
        v_subline_mc gipi_polbasic.subline_cd%TYPE;
        v_subline_pc gipi_polbasic.subline_cd%TYPE;
        v_subline_cv gipi_polbasic.subline_cd%TYPE;
        v_policy_no VARCHAR2(50);
        policy_no VARCHAR2(50);
        v_switch VARCHAR2(1):='Y';
     BEGIN
        FOR c IN (SELECT a.param_value_v mc,
                         b.param_value_v pc,
                         c.param_value_v cv,
                         d.param_value_v   line
                   FROM giis_parameters a,
                        giis_parameters b,
                        giis_parameters c,
                        giis_parameters d
                   WHERE a.param_name = 'MOTORCYCLE'
                   AND b.param_name = 'PRIVATE CAR'
                   AND c.param_name = 'COMMERCIAL VEHICLE'
                   AND  d.param_name = 'MOTOR CAR')
        LOOP
             v_subline_mc  := c.mc;
             v_subline_pc  := c.pc;
             v_subline_cv  := c.cv;
             v_line        := c.line;
        END LOOP;
           dbms_output.put_line(v_subline_mc ||' MC');
           dbms_output.put_line(v_subline_pc || ' PC');
           dbms_output.put_line(v_subline_cv || ' CV');
           dbms_output.put_line(v_line || 'LINE');
           dbms_output.put_line(v_zone_type || 'VZONETYPE');
           IF v_zone_type <> 0 THEN
             FOR c IN (SELECT  peril_name
                       FROM giis_peril
                       WHERE line_cd = v_line)
             LOOP
                     INSERT INTO gixx_nlto_stat
                     (coverage,
                      peril_name,
                      user_id,
                      last_update)
                     VALUES
                     (v_zone_type,
                      c.peril_name,
                      v_user,
                      v_sys);
             END LOOP;
             COMMIT;
           ELSE
              FOR cov IN (SELECT coverage_desc coverage
                        FROM giis_coverage)
              LOOP
                  FOR c IN (SELECT  peril_name
                       FROM giis_peril
                       WHERE line_cd = v_line)
                  LOOP
                     INSERT INTO gixx_nlto_stat
                     (coverage,
                      peril_name,
                      user_id,
                      last_update)
                     VALUES
                     (cov.coverage,
                      c.peril_name,
                      v_user,
                      v_sys);
                   END LOOP;
              END LOOP;
           END IF;
           dbms_output.put_line('TESTING');
           COMMIT;
           FOR  c1 IN (SELECT
                        a.line_cd,
                        a.subline_cd,
                        a.iss_cd,
                        a.issue_yy,
                        a.pol_seq_no,
                        a.renew_no,
                        b.item_no,
                        SUM(c.prem_amt * b.currency_rt)prem_amt,
                        h.peril_name,
                        g.coverage_desc
                     FROM (SELECT coverage_cd, coverage_desc
                           FROM giis_coverage
                           WHERE coverage_cd = DECODE(v_zone_type,0,coverage_cd,v_zone_type))g,
                           gipi_polbasic a,
                           gipi_item b,
                           gipi_itmperil c,
                           gipi_vehicle d,
                           giis_mc_subline_type f,
                           giis_peril h
                     WHERE a.policy_id = b.policy_id
                     AND b.policy_id = c.policy_id
                     AND b.item_no = c.item_no
                     AND b.policy_id = d.policy_id
                     AND a.iss_cd <> DECODE(v_iss_cd, 'T', '**','RI')
                     AND b.item_no = d.item_no
                     AND d.subline_cd = f.subline_cd
                     AND d.subline_type_cd = f.subline_type_cd
                     AND b.coverage_cd = g.coverage_cd
                     AND a.line_cd = h.line_cd
                     AND c.peril_cd = h.peril_cd
                     AND (a.pol_flag = '1' OR
                          a.pol_flag = '2' OR
                          a.pol_flag = '3')
                     AND a.dist_flag = '3'
                     AND a.booking_year = v_year
                     AND (a.subline_cd IN (v_subline_pc, v_subline_mc, v_subline_cv)
                           OR (b.pack_subline_cd IN (v_subline_pc, v_subline_mc, v_subline_cv)
                               AND b.pack_line_cd = v_line))
                     GROUP BY  a.line_cd,
                               a.subline_cd,
                               a.iss_cd ,
                               a.issue_yy,
                               a.pol_seq_no,
                               a.renew_no,
                               b.item_no,
                               h.peril_name,
                               g.coverage_desc)
           LOOP
              v_prem := c1.prem_amt;
              dbms_output.put_line('TEST');
                           IF v_zone_type <> 0 THEN
                  UPDATE gixx_nlto_stat
                  SET coverage = c1.coverage_desc;
                  COMMIT;
                  IF c1.subline_cd = v_subline_pc THEN
                    UPDATE gixx_nlto_stat
                    SET pc_prem  = NVL(pc_prem,0) + NVL(v_prem,0)
                    WHERE peril_name = c1.peril_name;
                    COMMIT;
                  ELSIF c1.subline_cd = v_subline_mc THEN
                    UPDATE gixx_nlto_stat
                    SET mc_prem  = NVL(mc_prem,0) + NVL(v_prem,0)
                    WHERE peril_name = c1.peril_name;
                    COMMIT;
                  ELSE
                    UPDATE gixx_nlto_stat
                    SET cv_prem  = NVL(cv_prem,0) + NVL(v_prem,0)
                    WHERE peril_name = c1.peril_name;
                    COMMIT;
                 END IF;
            ELSE    --v_zone_type 0
                  IF c1.subline_cd = v_subline_pc THEN
                        UPDATE gixx_nlto_stat
                        SET pc_prem  = NVL(pc_prem,0) + NVL(v_prem,0)
                        WHERE peril_name = c1.peril_name
                        AND coverage = c1.coverage_desc;
                  ELSIF c1.subline_cd = v_subline_mc THEN
                        UPDATE gixx_nlto_stat
                        SET  mc_prem  = NVL(mc_prem,0) + NVL(v_prem,0)
                        WHERE peril_name = c1.peril_name
                        AND coverage = c1.coverage_desc;
                  ELSE
                        UPDATE gixx_nlto_stat
                        SET cv_prem  = NVL(cv_prem,0) + NVL(v_prem,0)
                        WHERE peril_name = c1.peril_name
                        AND coverage = c1.coverage_desc;
                  END IF;
               COMMIT;
             END IF;
       END LOOP;
            FOR  cnt IN (SELECT COUNT(DISTINCT
                                          a.line_cd ||
                                          a.subline_cd ||
                                          a.iss_cd ||
                                          TO_CHAR(a.issue_yy) ||
                                          TO_CHAR(a.pol_seq_no) ||
                                          TO_CHAR(a.renew_no)) cnt,
                                          h.peril_name,
                                          a.subline_cd,
                                          g.coverage_desc
                     FROM (SELECT coverage_cd, coverage_desc
                           FROM giis_coverage
                           WHERE coverage_cd = DECODE(v_zone_type,0,coverage_cd,v_zone_type))g,
                           gipi_polbasic a,
                           gipi_item b,
                           gipi_itmperil c,
                           gipi_vehicle d,
                           giis_mc_subline_type f,
                           giis_peril h
                     WHERE a.policy_id = b.policy_id
                     AND b.policy_id = c.policy_id
                     AND b.item_no = c.item_no
                     AND b.policy_id = d.policy_id
                     AND a.iss_cd <> DECODE(v_iss_cd, 'T', '**','RI')
                     AND b.item_no = d.item_no
                     AND d.subline_cd = f.subline_cd
                     AND d.subline_type_cd = f.subline_type_cd
                     AND b.coverage_cd = g.coverage_cd
                     AND (a.pol_flag = '1' OR
                          a.pol_flag = '2' OR
                          a.pol_flag = '3')
                     AND a.dist_flag = '3'
                     AND a.line_cd = h.line_cd
                     AND c.peril_cd = h.peril_cd
                     AND a.booking_year = v_year
                     AND (a.subline_cd IN (v_subline_pc, v_subline_mc, v_subline_cv)
                           OR (b.pack_subline_cd IN (v_subline_pc, v_subline_mc, v_subline_cv)
                               AND b.pack_line_cd = v_line))
                     GROUP BY a.subline_cd, g.coverage_desc)
             LOOP
               IF v_zone_type  <> 0 THEN
                 IF cnt.subline_cd = v_subline_pc THEN
                     UPDATE gixx_nlto_stat
                     SET pc_count = cnt.cnt;
                     --where peril_name = cnt.peril_name;
                 ELSIF cnt.subline_cd = v_subline_mc THEN
                     UPDATE gixx_nlto_stat
                     SET mc_count = cnt.cnt;
                     --where peril_name = cnt.peril_name;
                 ELSE
                     UPDATE gixx_nlto_stat
                     SET cv_count = cnt.cnt;
                     --where peril_name = cnt.peril_name;
                 END IF;
                 COMMIT;
             ELSE
                IF cnt.subline_cd = v_subline_pc THEN
                     UPDATE gixx_nlto_stat
                     SET pc_count = cnt.cnt
                     --where peril_name = cnt.peril_name
                     WHERE coverage = cnt.coverage_desc;
                 ELSIF cnt.subline_cd = v_subline_mc THEN
                     UPDATE gixx_nlto_stat
                     SET mc_count = cnt.cnt
                     --where peril_name = cnt.peril_name
                      WHERE coverage = cnt.coverage_desc;
                 ELSE
                     UPDATE gixx_nlto_stat
                     SET cv_count = cnt.cnt
                     --where peril_name = cnt.peril_name
                      WHERE coverage = cnt.coverage_desc;
                 END IF;
                 COMMIT;
             END IF;
           END LOOP; --cnt
      COMMIT;
   END;
END;
/
DROP PACKAGE CPI.NLTO2_YEARLY;

