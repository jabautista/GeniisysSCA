CREATE OR REPLACE PACKAGE BODY CPI.NLTO2 AS
   PROCEDURE MAIN_NLTO2(
     v_date      varchar2,
     v_lto       varchar2,             --  lto / nlto
     v_basis     varchar2,             --  acct_ent_date/issue_date/eff_date/bk_date
     v_iss_cd    varchar2,             --  ri business included/excluded
     v_zone      varchar2,
     v_zone_type NUMBER,
     v_year      number,
     v_user      varchar2,
     v_sys       date
 )
   AS
     v_subline giis_parameters.param_value_v%type;
     v_line    giis_parameters.param_value_v%type;
   BEGIN
     DELETE
     FROM GIXX_NLTO_STAT
     WHERE USER_ID = V_USER;
     COMMIT;
     IF v_basis in ('AD', 'ED','ID')  THEN
        NLTO_BY_AD(v_basis,v_year, v_zone,v_zone_type, v_iss_cd, v_user, v_sys);
     ELSE
        NLTO_BY_BD(v_year, v_zone,v_zone_type, v_iss_cd, v_user, v_sys);
     END IF;
    END;
    PROCEDURE NLTO_BY_AD(
       v_basis     varchar2,
       v_year      number,
       v_zone       varchar2,
       v_zone_type   number,
       v_iss_cd      varchar2,
       v_user        varchar2,
       v_sys         date)
     AS
        v_prem gipi_polbasic.prem_amt%type;
        v_subline giis_parameters.param_value_v%type;
        v_line    giis_parameters.param_value_v%type;
        v_desc    giis_mc_subline_type.subline_type_desc%type;
        v_peril_stat_name varchar2(50);
        peril_name giis_peril.peril_name%type;
        pc_count  gixx_nlto_stat.pc_count%type :=0;
        pc_prem   gixx_nlto_stat.pc_prem%type  :=0;
        mc_count  gixx_nlto_stat.mc_count%type :=0;
        mc_prem   gixx_nlto_stat.mc_prem%type  :=0;
        cv_count  gixx_nlto_stat.cv_count%type :=0;
        cv_prem   gixx_nlto_stat.cv_prem%type :=0;
        v_subline_mc gipi_polbasic.subline_cd%type;
        v_subline_pc gipi_polbasic.subline_cd%type;
        v_subline_cv gipi_polbasic.subline_cd%type;
        v_policy_no varchar2(50);
        policy_no varchar2(50);
        v_switch varchar2(1):='Y';
     BEGIN
        FOR C IN (SELECT a.param_value_v MC,
                         b.param_value_v PC,
                         c.param_value_v CV,
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
           DBMS_OUTPUT.PUT_LINE(V_SUBLINE_MC ||' MC');
           DBMS_OUTPUT.PUT_LINE(V_SUBLINE_PC || ' PC');
           DBMS_OUTPUT.PUT_LINE(V_SUBLINE_CV || ' CV');
           DBMS_OUTPUT.PUT_LINE(V_LINE || 'LINE');
           DBMS_OUTPUT.PUT_LINE(V_ZONE_TYPE || 'VZONETYPE');
           IF v_zone_type <> 0 THEN
             FOR C IN (SELECT  peril_name
                       FROM giis_peril
                       WHERE line_cd = v_line)
             LOOP
                     INSERT INTO GIXX_NLTO_STAT
                     (COVERAGE,
                      PERIL_NAME,
                      USER_ID,
                      LAST_UPDATE)
                     VALUES
                     (v_zone_type,
                      c.peril_name,
                      v_user,
                      v_sys);
             END LOOP;
             COMMIT;
           ELSE
              FOR COV IN (SELECT coverage_desc coverage
                        from giis_coverage)
              LOOP
                  FOR C IN (SELECT  peril_name
                       FROM giis_peril
                       WHERE line_cd = v_line)
                  LOOP
                     INSERT INTO GIXX_NLTO_STAT
                     (COVERAGE,
                      PERIL_NAME,
                      USER_ID,
                      LAST_UPDATE)
                     VALUES
                     (cov.coverage,
                      c.peril_name,
                      v_user,
                      v_sys);
                   END LOOP;
              END LOOP;
           END IF;
           DBMS_OUTPUT.PUT_LINE('TESTING');
           COMMIT;
           FOR  C1 in (SELECT
                        a.line_cd,
                        a.subline_cd,
                        a.iss_cd,
                        a.issue_yy,
                        a.pol_seq_no,
                        a.renew_no,
                        b.item_no,
                        sum(c.prem_amt * b.currency_rt)prem_amt,
                        h.peril_name,
                        g.coverage_desc
                     from (select coverage_cd, coverage_desc
                           from giis_coverage
                           where coverage_cd = decode(v_zone_type,0,coverage_cd,v_zone_type))g,
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
                     AND a.iss_cd <> decode(v_iss_cd, 'T', '**','RI')
                     AND b.item_no = d.item_no
                     AND d.subline_cd = f.subline_cd
                     AND d.subline_type_cd = f.subline_type_cd
                     AND b.coverage_cd = g.coverage_cd
                     AND a.line_cd = h.line_cd
                     AND c.peril_cd = h.peril_cd
                     AND (a.pol_flag = '1' or
                          a.pol_flag = '2' or
                          a.pol_flag = '3')
                     AND a.dist_flag = '3'
                     AND decode(v_basis,'AD',to_char(trunc(A.ACCT_ENT_DATE),'YYYY'),
                                        'ID',to_char(trunc(A.ISSUE_DATE),'YYYY'),
                                        'ED',to_char(trunc(A.EFF_DATE),'YYYY'))
                        =  decode(v_basis,'AD',v_year,
                                           'ID',v_year,
                                           'ED',v_year)
                     AND (a.subline_cd in (v_subline_pc, v_subline_mc, v_subline_cv)
                           or (b.pack_subline_cd in (v_subline_pc, v_subline_mc, v_subline_cv)
                               and b.pack_line_cd = v_line))
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
              DBMS_OUTPUT.PUT_LINE('TEST');
              IF v_zone_type <> 0 THEN
                  UPDATE GIXX_NLTO_STAT
                  SET coverage = c1.coverage_desc;
                  COMMIT;
                  IF c1.subline_cd = v_subline_pc THEN
                    UPDATE GIXX_NLTO_STAT
                    SET pc_prem  = NVL(pc_prem,0) + NVL(v_prem,0)
                    WHERE peril_name = C1.peril_name;
                    COMMIT;
                  ELSIF c1.subline_cd = v_subline_mc THEN
                    UPDATE GIXX_NLTO_STAT
                    SET mc_prem  = NVL(mc_prem,0) + NVL(v_prem,0)
                    WHERE peril_name = c1.peril_name;
                    COMMIT;
                  ELSE
                    UPDATE GIXX_NLTO_STAT
                    SET cv_prem  = NVL(cv_prem,0) + NVL(v_prem,0)
                    WHERE peril_name = c1.peril_name;
                    COMMIT;
                 END IF;
            ELSE    --v_zone_type 0
                  IF c1.subline_cd = v_subline_pc THEN
                        UPDATE GIXX_NLTO_STAT
                        SET pc_prem  = NVL(pc_prem,0) + NVL(v_prem,0)
                        WHERE peril_name = c1.peril_name
                        AND coverage = c1.coverage_desc;
                  ELSIF c1.subline_cd = v_subline_mc THEN
                        UPDATE GIXX_NLTO_STAT
                        SET mc_count = NVL(mc_count,0) + 1,
                            mc_prem  = NVL(mc_prem,0) + NVL(v_prem,0)
                        WHERE peril_name = c1.peril_name
                        AND coverage = c1.coverage_desc;
                  ELSE
                        UPDATE GIXX_NLTO_STAT
                        SET cv_count = NVL(cv_count,0) + 1,
                            cv_prem  = NVL(cv_prem,0) + NVL(v_prem,0)
                        WHERE peril_name = c1.peril_name
                        AND coverage = c1.coverage_desc;
                  END IF;
               COMMIT;
            END IF;
       END LOOP;
              FOR  cnt in (SELECT COUNT(DISTINCT
                                          a.line_cd ||
                                          a.subline_cd ||
                                          a.iss_cd ||
                                          TO_CHAR(a.issue_yy) ||
                                          TO_CHAR(a.pol_seq_no) ||
                                          TO_CHAR(a.renew_no)) cnt,
                                          a.subline_cd,
                                          g.coverage_desc
                     from (select coverage_cd, coverage_desc
                           from giis_coverage
                           where coverage_cd = decode(v_zone_type,0,coverage_cd,v_zone_type))g,
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
                     AND a.iss_cd <> decode(v_iss_cd, 'T', '**','RI')
                     AND b.item_no = d.item_no
                     AND d.subline_cd = f.subline_cd
                     AND d.subline_type_cd = f.subline_type_cd
                     AND b.coverage_cd = g.coverage_cd
                     AND (a.pol_flag = '1' or
                          a.pol_flag = '2' or
                          a.pol_flag = '3')
                     AND a.dist_flag = '3'
                     AND a.line_cd = h.line_cd
                     AND c.peril_cd = h.peril_cd
                     AND decode(v_basis,'AD',to_char(trunc(A.ACCT_ENT_DATE),'YYYY'),
                                        'ID',to_char(trunc(A.ISSUE_DATE),'YYYY'),
                                        'ED',to_char(trunc(A.EFF_DATE),'YYYY'))
                        =  decode(v_basis,'AD',v_year,
                                           'ID',v_year,
                                           'ED',v_year)
                     AND (a.subline_cd in (v_subline_pc, v_subline_mc, v_subline_cv)
                           or (b.pack_subline_cd in (v_subline_pc, v_subline_mc, v_subline_cv)
                               and b.pack_line_cd = v_line))
                     GROUP BY a.subline_cd, g.coverage_desc)
             LOOP
               IF v_zone_type  <> 0 THEN
                 IF cnt.subline_cd = v_subline_pc THEN
                     UPDATE GIXX_NLTO_STAT
                     SET pc_count = cnt.cnt;
                     --WHERE PERIL_NAME = cnt.peril_name;
                 ELSIF cnt.subline_cd = v_subline_mc THEN
                     UPDATE GIXX_NLTO_STAT
                     SET mc_count = cnt.cnt;
                     --WHERE PERIL_NAME = cnt.peril_name;
                 ELSE
                     UPDATE GIXX_NLTO_STAT
                     SET cv_count = cnt.cnt;
                     --WHERE PERIL_NAME = cnt.peril_name;
                 END IF;
                 COMMIT;
             ELSE
                IF cnt.subline_cd = v_subline_pc THEN
                     UPDATE GIXX_NLTO_STAT
                     SET pc_count = cnt.cnt
                     --WHERE PERIL_NAME = cnt.peril_name
                     WHERE coverage = cnt.coverage_desc;
                 ELSIF cnt.subline_cd = v_subline_mc THEN
                     UPDATE GIXX_NLTO_STAT
                     SET mc_count = cnt.cnt
                     --WHERE PERIL_NAME = cnt.peril_name
                     WHERE coverage = cnt.coverage_desc;
                 ELSE
                     UPDATE GIXX_NLTO_STAT
                     SET cv_count = cnt.cnt
                     --WHERE PERIL_NAME = cnt.peril_name
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
    PROCEDURE NLTO_BY_BD(
       v_year      number,
       v_zone       varchar2,
       v_zone_type   number,
       v_iss_cd      varchar2,
       v_user        varchar2,
       v_sys         date)
     AS
        v_prem gipi_polbasic.prem_amt%type;
        v_subline giis_parameters.param_value_v%type;
        v_line    giis_parameters.param_value_v%type;
        v_desc    giis_mc_subline_type.subline_type_desc%type;
        v_peril_stat_name varchar2(50);
        peril_name giis_peril.peril_name%type;
        pc_count  gixx_nlto_stat.pc_count%type :=0;
        pc_prem   gixx_nlto_stat.pc_prem%type  :=0;
        mc_count  gixx_nlto_stat.mc_count%type :=0;
        mc_prem   gixx_nlto_stat.mc_prem%type  :=0;
        cv_count  gixx_nlto_stat.cv_count%type :=0;
        cv_prem   gixx_nlto_stat.cv_prem%type :=0;
        v_subline_mc gipi_polbasic.subline_cd%type;
        v_subline_pc gipi_polbasic.subline_cd%type;
        v_subline_cv gipi_polbasic.subline_cd%type;
        v_policy_no varchar2(50);
        policy_no varchar2(50);
        v_switch varchar2(1):='Y';
     BEGIN
        FOR C IN (SELECT a.param_value_v MC,
                         b.param_value_v PC,
                         c.param_value_v CV,
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
           DBMS_OUTPUT.PUT_LINE(V_SUBLINE_MC ||' MC');
           DBMS_OUTPUT.PUT_LINE(V_SUBLINE_PC || ' PC');
           DBMS_OUTPUT.PUT_LINE(V_SUBLINE_CV || ' CV');
           DBMS_OUTPUT.PUT_LINE(V_LINE || 'LINE');
           DBMS_OUTPUT.PUT_LINE(V_ZONE_TYPE || 'VZONETYPE');
           IF v_zone_type <> 0 THEN
             FOR C IN (SELECT  peril_name
                       FROM giis_peril
                       WHERE line_cd = v_line)
             LOOP
                     INSERT INTO GIXX_NLTO_STAT
                     (COVERAGE,
                      PERIL_NAME,
                      USER_ID,
                      LAST_UPDATE)
                     VALUES
                     (v_zone_type,
                      c.peril_name,
                      v_user,
                      v_sys);
             END LOOP;
             COMMIT;
           ELSE
              FOR COV IN (SELECT coverage_desc coverage
                        from giis_coverage)
              LOOP
                  FOR C IN (SELECT  peril_name
                       FROM giis_peril
                       WHERE line_cd = v_line)
                  LOOP
                     INSERT INTO GIXX_NLTO_STAT
                     (COVERAGE,
                      PERIL_NAME,
                      USER_ID,
                      LAST_UPDATE)
                     VALUES
                     (cov.coverage,
                      c.peril_name,
                      v_user,
                      v_sys);
                   END LOOP;
              END LOOP;
           END IF;
           DBMS_OUTPUT.PUT_LINE('TESTING');
           COMMIT;
           FOR  C1 in (SELECT
                        a.line_cd,
                        a.subline_cd,
                        a.iss_cd,
                        a.issue_yy,
                        a.pol_seq_no,
                        a.renew_no,
                        b.item_no,
                        sum(c.prem_amt * b.currency_rt)prem_amt,
                        h.peril_name,
                        g.coverage_desc
                     from (select coverage_cd, coverage_desc
                           from giis_coverage
                           where coverage_cd = decode(v_zone_type,0,coverage_cd,v_zone_type))g,
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
                     AND a.iss_cd <> decode(v_iss_cd, 'T', '**','RI')
                     AND b.item_no = d.item_no
                     AND d.subline_cd = f.subline_cd
                     AND d.subline_type_cd = f.subline_type_cd
                     AND b.coverage_cd = g.coverage_cd
                     AND a.line_cd = h.line_cd
                     AND c.peril_cd = h.peril_cd
                     AND (a.pol_flag = '1' or
                          a.pol_flag = '2' or
                          a.pol_flag = '3')
                     AND a.dist_flag = '3'
                     AND a.booking_year = v_year
                     AND (a.subline_cd in (v_subline_pc, v_subline_mc, v_subline_cv)
                           or (b.pack_subline_cd in (v_subline_pc, v_subline_mc, v_subline_cv)
                               and b.pack_line_cd = v_line))
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
              DBMS_OUTPUT.PUT_LINE('TEST');
                           IF v_zone_type <> 0 THEN
                  UPDATE GIXX_NLTO_STAT
                  SET coverage = c1.coverage_desc;
                  COMMIT;
                  IF c1.subline_cd = v_subline_pc THEN
                    UPDATE GIXX_NLTO_STAT
                    SET pc_prem  = NVL(pc_prem,0) + NVL(v_prem,0)
                    WHERE peril_name = C1.peril_name;
                    COMMIT;
                  ELSIF c1.subline_cd = v_subline_mc THEN
                    UPDATE GIXX_NLTO_STAT
                    SET mc_prem  = NVL(mc_prem,0) + NVL(v_prem,0)
                    WHERE peril_name = c1.peril_name;
                    COMMIT;
                  ELSE
                    UPDATE GIXX_NLTO_STAT
                    SET cv_prem  = NVL(cv_prem,0) + NVL(v_prem,0)
                    WHERE peril_name = c1.peril_name;
                    COMMIT;
                 END IF;
            ELSE    --v_zone_type 0
                  IF c1.subline_cd = v_subline_pc THEN
                        UPDATE GIXX_NLTO_STAT
                        SET pc_prem  = NVL(pc_prem,0) + NVL(v_prem,0)
                        WHERE peril_name = c1.peril_name
                        AND coverage = c1.coverage_desc;
                  ELSIF c1.subline_cd = v_subline_mc THEN
                        UPDATE GIXX_NLTO_STAT
                        SET  mc_prem  = NVL(mc_prem,0) + NVL(v_prem,0)
                        WHERE peril_name = c1.peril_name
                        AND coverage = c1.coverage_desc;
                  ELSE
                        UPDATE GIXX_NLTO_STAT
                        SET cv_prem  = NVL(cv_prem,0) + NVL(v_prem,0)
                        WHERE peril_name = c1.peril_name
                        AND coverage = c1.coverage_desc;
                  END IF;
               COMMIT;
             END IF;
       END LOOP;
            FOR  cnt in (SELECT COUNT(DISTINCT
                                          a.line_cd ||
                                          a.subline_cd ||
                                          a.iss_cd ||
                                          TO_CHAR(a.issue_yy) ||
                                          TO_CHAR(a.pol_seq_no) ||
                                          TO_CHAR(a.renew_no)) cnt,
                                          h.peril_name,
                                          a.subline_cd,
                                          g.coverage_desc
                     from (select coverage_cd, coverage_desc
                           from giis_coverage
                           where coverage_cd = decode(v_zone_type,0,coverage_cd,v_zone_type))g,
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
                     AND a.iss_cd <> decode(v_iss_cd, 'T', '**','RI')
                     AND b.item_no = d.item_no
                     AND d.subline_cd = f.subline_cd
                     AND d.subline_type_cd = f.subline_type_cd
                     AND b.coverage_cd = g.coverage_cd
                     AND (a.pol_flag = '1' or
                          a.pol_flag = '2' or
                          a.pol_flag = '3')
                     AND a.dist_flag = '3'
                     AND a.line_cd = h.line_cd
                     AND c.peril_cd = h.peril_cd
                     AND a.booking_year = v_year
                     AND (a.subline_cd in (v_subline_pc, v_subline_mc, v_subline_cv)
                           or (b.pack_subline_cd in (v_subline_pc, v_subline_mc, v_subline_cv)
                               and b.pack_line_cd = v_line))
                     GROUP BY a.subline_cd, g.coverage_desc)
             LOOP
               IF v_zone_type  <> 0 THEN
                 IF cnt.subline_cd = v_subline_pc THEN
                     UPDATE GIXX_NLTO_STAT
                     SET pc_count = cnt.cnt;
                     --WHERE PERIL_NAME = cnt.peril_name;
                 ELSIF cnt.subline_cd = v_subline_mc THEN
                     UPDATE GIXX_NLTO_STAT
                     SET mc_count = cnt.cnt;
                     --WHERE PERIL_NAME = cnt.peril_name;
                 ELSE
                     UPDATE GIXX_NLTO_STAT
                     SET cv_count = cnt.cnt;
                     --WHERE PERIL_NAME = cnt.peril_name;
                 END IF;
                 COMMIT;
             ELSE
                IF cnt.subline_cd = v_subline_pc THEN
                     UPDATE GIXX_NLTO_STAT
                     SET pc_count = cnt.cnt
                     --WHERE PERIL_NAME = cnt.peril_name
                     WHERE coverage = cnt.coverage_desc;
                 ELSIF cnt.subline_cd = v_subline_mc THEN
                     UPDATE GIXX_NLTO_STAT
                     SET mc_count = cnt.cnt
                     --WHERE PERIL_NAME = cnt.peril_name
                      WHERE coverage = cnt.coverage_desc;
                 ELSE
                     UPDATE GIXX_NLTO_STAT
                     SET cv_count = cnt.cnt
                     --WHERE PERIL_NAME = cnt.peril_name
                      WHERE coverage = cnt.coverage_desc;
                 END IF;
                 COMMIT;
             END IF;
           END LOOP; --cnt
      COMMIT;
   END;
END;
/


