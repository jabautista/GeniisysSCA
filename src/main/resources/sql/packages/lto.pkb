CREATE OR REPLACE PACKAGE BODY CPI.LTO AS
    PROCEDURE MAIN_LTO(
      v_date      varchar2,
      v_lto       varchar2,             --  lto / nlto
      v_basis     varchar2,             --  acct_ent_date/issue_date/eff_date/bk_date
      v_iss_cd    varchar2,             --  ri business included/excluded
      v_zone      varchar2,
      v_zone_type varchar2,
      v_date_from date,
      v_date_to   date,
      v_user      varchar2,
      v_sys       date
  )
    AS
      v_subline giis_parameters.param_value_v%type;
      v_line    giis_parameters.param_value_v%type;
      v_count   number;
    BEGIN
      DELETE
      FROM gixx_lto_stat
      WHERE user = v_user;
      COMMIT;
           IF v_basis in ('AD', 'ID', 'ED') THEN
                    LTO_BD_AD(v_date,v_basis,v_date_from, v_date_to, v_zone,v_zone_type, v_iss_cd, v_user, v_sys);
           ELSE
                    LTO_BD_BD(v_date,v_basis,v_date_from, v_date_to, v_zone,v_zone_type, v_iss_cd, v_user, v_sys);
           END IF;
     END;
      PROCEDURE LTO_BD_AD(
        v_date        varchar2,
        v_basis       varchar2,
        v_date_from   date,
        v_date_to     date,
        v_zone       varchar2,
        v_zone_type   varchar2,
        v_iss_cd      varchar2,
        v_user        varchar2,
        v_sys         date)
      AS
         v_prem gipi_polbasic.prem_amt%type;
         v_subline giis_parameters.param_value_v%type;
         v_line    giis_parameters.param_value_v%type;
         v_desc    giis_mc_subline_type.subline_type_desc%type;
         v_peril_stat_name varchar2(50);
      --   v_name    giis_mc_subline_type.subline_type_desc%type;
           v_name    cg_ref_codes.rv_meaning%type;
      BEGIN
        FOR C IN (SELECT a.param_value_v lto,
                   b.param_value_v   line
                FROM giis_parameters a,
                     giis_parameters b
                WHERE a.param_name = 'LAND TRANS. OFFICE'
                AND  b.param_name = 'MOTOR CAR')
        LOOP
            v_subline := c.lto;
            v_line    := c.line;
        END LOOP;
          FOR C IN (SELECT  rv_meaning name
                       FROM cg_ref_codes
                       WHERE rv_domain = 'GIIS_PERIL.ZONE_TYPE'
                       AND RV_LOW_VALUE = DECODE(v_zone_type, 'null',rv_low_value,v_zone_type))
            LOOP
                v_peril_stat_name := c.name;
                 FOR SUB IN (SELECT subline_type_desc
                              FROM giis_mc_subline_type
                              WHERE subline_cd = v_subline)
                  LOOP
                      INSERT INTO GIXX_LTO_STAT
                      (PERIL_STAT_NAME,
                       SUBLINE,
                       USER_ID,
                       LAST_UPDATE)
                      VALUES
                      (v_peril_stat_name,
                       sub.subline_type_desc,
                       v_user,
                       v_sys);
                  END LOOP;
            END LOOP;
            COMMIT;
            FOR  C1 in (SELECT
                         a.line_cd,
                         a.subline_cd,
                         a.iss_cd,
                         a.issue_yy,
                         a.pol_seq_no,
                         a.renew_no,
                         b.item_no,
                         f.subline_type_cd,
                         f.subline_type_desc,
                         g.zone_type,
                         b.coverage_cd,
                         sum(c.prem_amt * b.currency_rt)prem_amt
                      from  gipi_itmperil c,
                            (select peril_cd, zone_type
                            from giis_peril
                            where zone_type = decode(v_zone_type, 'null',zone_type, v_zone_type)
                            and line_cd = v_line)g,
                            gipi_polbasic a,
                            gipi_item b,
                            gipi_vehicle d,
                            giis_mc_subline_type f
                      WHERE a.policy_id = b.policy_id
                      AND b.policy_id = c.policy_id
                      AND b.item_no = c.item_no
                      AND b.policy_id = d.policy_id
                      AND a.iss_cd <> decode(v_iss_cd, 'T', '**','RI')
                      AND b.item_no = d.item_no
                      AND d.subline_cd = f.subline_cd
                      AND d.subline_type_cd = f.subline_type_cd
                      AND c.peril_cd = g.peril_cd
                      AND (a.pol_flag = '1' or
                           a.pol_flag = '2' or
                           a.pol_flag = '3')
                      AND a.dist_flag = '3'
                      AND b.coverage_cd IN (1,2)
                      AND  decode(v_basis,'AD',trunc(A.ACCT_ENT_DATE),
                                          'ID',trunc(A.ISSUE_DATE),
                                          'ED',trunc(A.EFF_DATE))
                      >=  decode(v_basis,'AD',trunc(v_date_from),
                                         'ID',trunc(v_date_from),
                                         'ED',trunc(v_date_from))
                      AND   decode(v_basis,'AD',trunc(A.ACCT_ENT_DATE),
                                           'ID',trunc(A.ISSUE_DATE),
                                           'ED',trunc(A.EFF_DATE))
                          <=  decode(v_basis,'AD',trunc(v_date_to),
                                             'ID',trunc(v_date_to),
                                             'ED',trunc(v_date_to))
                     --AND a.subline_cd = v_subline
                      GROUP BY  a.line_cd,
                                a.subline_cd,
                                a.iss_cd ,
                                a.issue_yy,
                                a.pol_seq_no,
                                a.renew_no,
                                b.item_no,
                                g.zone_type,
                                b.coverage_cd,
                                f.subline_type_cd,
                                f.subline_type_desc)
            LOOP
               v_prem := c1.prem_amt;
               dbms_output.put_line(c1.prem_amt || 'prem_amt');
               /*FOR  cnt in (SELECT COUNT (DISTINCT
                                          a.line_cd ||
                                          a.subline_cd ||
                                          a.iss_cd ||
                                          to_char(a.issue_yy) ||
                                          to_char(a.pol_seq_no) ||
                                          to_char(a.renew_no))policy,
                                          b.item_no,
                                          f.subline_type_cd,
                                          f.subline_type_desc,
                                          g.zone_type,
                                          b.coverage_cd
                      from gipi_itmperil c,
                           (select peril_cd, zone_type
                            from giis_peril
                            where zone_type = decode(v_zone_type, 'null',zone_type, v_zone_type)
                            and line_cd = v_line)g,
                            gipi_polbasic a,
                            gipi_item b,
                            gipi_vehicle d,
                            giis_mc_subline_type f
                      WHERE a.policy_id = b.policy_id
                      AND b.policy_id = c.policy_id
                      AND b.item_no = c.item_no
                      AND b.policy_id = d.policy_id
                      AND a.iss_cd <> decode(v_iss_cd, 'T', '**','RI')
                      AND b.item_no = d.item_no
                      AND d.subline_cd = f.subline_cd
                      AND d.subline_type_cd = f.subline_type_cd
                      AND c.peril_cd = g.peril_cd
                      AND (a.pol_flag = '1' or
                           a.pol_flag = '2' or
                           a.pol_flag = '3')
                      AND a.dist_flag = '3'
                      AND b.coverage_cd IN (1,2)
                      AND  decode(v_basis,'AD',trunc(A.ACCT_ENT_DATE),
                                          'ID',trunc(A.ISSUE_DATE),
                                          'ED',trunc(A.EFF_DATE))
                      >=  decode(v_basis,'AD',trunc(v_date_from),
                                         'ID',trunc(v_date_from),
                                         'ED',trunc(v_date_from))
                      AND   decode(v_basis,'AD',trunc(A.ACCT_ENT_DATE),
                                           'ID',trunc(A.ISSUE_DATE),
                                           'ED',trunc(A.EFF_DATE))
                          <=  decode(v_basis,'AD',trunc(v_date_to),
                                             'ID',trunc(v_date_to),
                                             'ED',trunc(v_date_to))
                       --AND a.subline_cd = v_subline
                      GROUP BY  a.line_cd,
                                a.subline_cd,
                                a.iss_cd ,
                                a.issue_yy,
                                a.pol_seq_no,
                                a.renew_no,
                                b.item_no,
                                g.zone_type,
                                b.coverage_cd,
                                f.subline_type_cd,
                                f.subline_type_desc) */
            --LOOP
               IF c1.coverage_cd = 1 and v_zone_type <> 'null'  THEN
                   UPDATE GIXX_LTO_STAT
                   SET peril_stat_name = v_peril_stat_name;
                   COMMIT;
                     UPDATE GIXX_LTO_STAT
                     SET mla_cnt  = NVL(mla_cnt,0) + 1
                     WHERE peril_stat_name = v_peril_stat_name
                     AND subline = c1.subline_type_cd;
                     COMMIT;
                     --dbms_output.put_line( cnt.policy ||'cov1mla_cnt');
                ELSIF c1.coverage_cd = 2 and v_zone_type <> 'null'  THEN
                   UPDATE GIXX_LTO_STAT
                   SET peril_stat_name = v_peril_stat_name;
                   COMMIT;
                     UPDATE GIXX_LTO_STAT
                     SET outside_mla_cnt  = NVL(outside_mla_cnt,0) + 1
                     WHERE peril_stat_name = v_peril_stat_name
                     AND subline = c1.subline_type_cd;
                     --dbms_output.put_line(cnt.policy || 'cov2mla_cnt');
                     COMMIT;
                ELSIF c1.coverage_cd = 1 and v_zone_type = 'null' THEN   --v_zone_type null
                       SELECT  rv_meaning name
                       INTO v_name
                       FROM cg_ref_codes
                       WHERE rv_domain = 'GIIS_PERIL.ZONE_TYPE'
                       AND RV_LOW_VALUE = c1.zone_type;
                       UPDATE GIXX_LTO_STAT
                       SET mla_cnt =  NVL(mla_cnt,0) + 1
                       WHERE peril_stat_name = v_name
                       AND subline = c1.subline_type_desc;
                       COMMIT;
                ELSIF c1.coverage_cd = 2 and v_zone_type = 'null' THEN   --v_zone_type null
                       SELECT  rv_meaning name
                       INTO v_name
                       FROM cg_ref_codes
                       WHERE rv_domain = 'GIIS_PERIL.ZONE_TYPE'
                       AND RV_LOW_VALUE = c1.zone_type;
                       UPDATE GIXX_LTO_STAT
                       SET outside_mla_cnt =  NVL(outside_mla_cnt,0) + 1
                       WHERE peril_stat_name = v_name
                       AND subline = c1.subline_type_desc;
                       COMMIT;
               END IF;
            --END LOOP;
                IF c1.coverage_cd = 1 and v_zone_type <> 'null'  THEN
                   UPDATE GIXX_LTO_STAT
                   SET peril_stat_name = v_peril_stat_name;
                   COMMIT;
                     UPDATE GIXX_LTO_STAT
                     SET mla_prem  = NVL(mla_prem,0) + NVL(c1.prem_amt,0)
                     WHERE peril_stat_name = v_peril_stat_name
                     AND subline = c1.subline_type_cd;
                     --dbms_output.put_line(c1.prem_amt || 'cov1mla_prem');
                     COMMIT;
                ELSIF c1.coverage_cd = 2 and v_zone_type <> 'null'  THEN
                   UPDATE GIXX_LTO_STAT
                   SET peril_stat_name = v_peril_stat_name;
                   COMMIT;
                     UPDATE GIXX_LTO_STAT
                     SET outside_mla_prem  = NVL(outside_mla_prem,0) + NVL(c1.prem_amt,0)
                     WHERE peril_stat_name = v_peril_stat_name
                     AND subline = c1.subline_type_cd;
                    --dbms_output.put_line(c1.prem_amt || 'cov2mla_prem');
                     COMMIT;
                ELSIF c1.coverage_cd = 1 and v_zone_type = 'null' THEN   --v_zone_type null
                       SELECT  rv_meaning name
                       INTO v_name
                       FROM cg_ref_codes
                       WHERE rv_domain = 'GIIS_PERIL.ZONE_TYPE'
                       AND RV_LOW_VALUE = c1.zone_type;
                       UPDATE GIXX_LTO_STAT
                       SET mla_prem =  NVL(mla_prem,0) + NVL(c1.prem_amt,0)
                       WHERE peril_stat_name = v_name
                       AND subline = c1.subline_type_desc;
                       COMMIT;
                ELSIF c1.coverage_cd = 2 and v_zone_type = 'null' THEN   --v_zone_type null
                       SELECT  rv_meaning name
                       INTO v_name
                       FROM cg_ref_codes
                       WHERE rv_domain = 'GIIS_PERIL.ZONE_TYPE'
                       AND RV_LOW_VALUE = c1.zone_type;
                       UPDATE GIXX_LTO_STAT
                       SET outside_mla_prem =  NVL(outside_mla_prem,0) + NVL(c1.prem_amt,0)
                       WHERE peril_stat_name = v_name
                       AND subline = c1.subline_type_desc;
                       COMMIT;
               END IF;
      END LOOP;
    END;
 -----BY DATE/BOOKING DATE
      PROCEDURE LTO_BD_BD(
        v_date        varchar2,
        v_basis       varchar2,
        v_date_from   date,
        v_date_to     date,
        v_zone       varchar2,
        v_zone_type   varchar2,
        v_iss_cd      varchar2,
        v_user        varchar2,
        v_sys         date)
      AS
         v_prem gipi_polbasic.prem_amt%type;
         v_subline giis_parameters.param_value_v%type;
         v_line    giis_parameters.param_value_v%type;
         v_desc    giis_mc_subline_type.subline_type_desc%type;
         v_peril_stat_name varchar2(50);
         v_name    giis_mc_subline_type.subline_type_desc%type;
         v_from varchar2(20);
         v_to varchar2(20);
      BEGIN
        FOR C IN (SELECT a.param_value_v lto,
                   b.param_value_v   line
                FROM giis_parameters a,
                     giis_parameters b
                WHERE a.param_name = 'LAND TRANS. OFFICE'
                AND  b.param_name = 'MOTOR CAR')
        LOOP
            v_subline := c.lto;
            v_line    := c.line;
        END LOOP;
          FOR C IN (SELECT  rv_meaning name
                       FROM cg_ref_codes
                       WHERE rv_domain = 'GIIS_PERIL.ZONE_TYPE'
                       AND RV_LOW_VALUE = DECODE(v_zone_type, 'null',rv_low_value,v_zone_type))
            LOOP
                v_peril_stat_name := c.name;
                 FOR SUB IN (SELECT subline_type_desc
                              FROM giis_mc_subline_type
                              WHERE subline_cd = v_subline)
                  LOOP
                      INSERT INTO GIXX_LTO_STAT
                      (PERIL_STAT_NAME,
                       SUBLINE,
                       USER_ID,
                       LAST_UPDATE)
                      VALUES
                      (v_peril_stat_name,
                       sub.subline_type_desc,
                       v_user,
                       v_sys);
                  END LOOP;
            END LOOP;
            COMMIT;
         v_from := to_char(v_date_from,'DD-MON-YY');
         v_to :=   to_char(v_date_to,'DD-MON-YY');
        FOR R IN (SELECT policy_id
                  FROM gipi_polbasic a
                  WHERE  TO_DATE('01' || '-' || SUBSTR(BOOKING_MTH,1,3) || '-' || SUBSTR(TO_CHAR(BOOKING_YEAR),2,2),'DD-MON-YY') >=  TO_DATE(v_from,'DD-MON-YY')
                  AND TO_DATE('30' || '-' || SUBSTR(BOOKING_MTH,1,3) || '-' || SUBSTR(TO_CHAR(BOOKING_YEAR),2,2),'DD-MON-YY') <=  TO_DATE(v_to,'DD-MON-YY'))
        LOOP
            FOR  C1 in (SELECT
                         a.line_cd,
                         a.subline_cd,
                         a.iss_cd,
                         a.issue_yy,
                         a.pol_seq_no,
                         a.renew_no,
                         b.item_no,
                         f.subline_type_cd,
                         f.subline_type_desc,
                         g.zone_type,
                         b.coverage_cd,
                         sum(c.prem_amt * b.currency_rt)prem_amt
                      from  gipi_itmperil c,
                           (select peril_cd, zone_type
                            from giis_peril
                            where zone_type = decode(v_zone_type, 'null',zone_type, v_zone_type)
                            and line_cd = v_line)g,
                            gipi_polbasic a,
                            gipi_item b,
                            gipi_vehicle d,
                            giis_mc_subline_type f
                      WHERE a.policy_id = b.policy_id
                      AND b.policy_id = c.policy_id
                      AND b.item_no = c.item_no
                      AND b.policy_id = d.policy_id
                      AND a.iss_cd <> decode(v_iss_cd, 'T', '**','RI')
                      AND b.item_no = d.item_no
                      AND d.subline_cd = f.subline_cd
                      AND d.subline_type_cd = f.subline_type_cd
                      AND c.peril_cd = g.peril_cd
                      AND (a.pol_flag = '1' or
                           a.pol_flag = '2' or
                           a.pol_flag = '3')
                      AND a.dist_flag = '3'
                      AND b.coverage_cd IN (1,2)
                      AND r.policy_id = a.policy_id
                      --AND '01' || SUBSTR(A.BOOKING_MTH,1,3) || TO_CHAR(A.BOOKING_YEAR) >= '01'||to_char(v_date_from,'fmMONYYYY')
                      --AND '31' || SUBSTR(A.BOOKING_MTH,1,3) || TO_CHAR(A.BOOKING_YEAR) <= '31'||to_char(v_date_to,'fmMONYYYY')
                     --AND a.subline_cd = v_subline
                      GROUP BY  a.line_cd,
                                a.subline_cd,
                                a.iss_cd ,
                                a.issue_yy,
                                a.pol_seq_no,
                                a.renew_no,
                                b.item_no,
                                g.zone_type,
                                b.coverage_cd,
                                f.subline_type_cd,
                                f.subline_type_desc)
            LOOP
               v_prem := c1.prem_amt;
               /*FOR  cnt in (SELECT COUNT (DISTINCT
                                          a.line_cd ||
                                          a.subline_cd ||
                                          a.iss_cd ||
                                          to_char(a.issue_yy) ||
                                          to_char(a.pol_seq_no) ||
                                          to_char(a.renew_no))policy,
                                          b.item_no,
                                          f.subline_type_cd,
                                          f.subline_type_desc,
                                          g.zone_type,
                                          b.coverage_cd
                      from  gipi_itmperil c,
                           (select peril_cd, zone_type
                            from giis_peril
                            where zone_type = decode(v_zone_type, 'null',zone_type, v_zone_type)
                            and line_cd = v_line)g,
                            gipi_polbasic a,
                            gipi_item b,
                            gipi_vehicle d,
                            giis_mc_subline_type f
                      WHERE a.policy_id = b.policy_id
                      AND b.policy_id = c.policy_id
                      AND b.item_no = c.item_no
                      AND b.policy_id = d.policy_id
                      AND a.iss_cd <> decode(v_iss_cd, 'T', '**','RI')
                      AND b.item_no = d.item_no
                      AND d.subline_cd = f.subline_cd
                      AND d.subline_type_cd = f.subline_type_cd
                      AND c.peril_cd = g.peril_cd
                      AND (a.pol_flag = '1' or
                           a.pol_flag = '2' or
                           a.pol_flag = '3')
                      AND a.dist_flag = '3'
                      AND b.coverage_cd IN (1,2)
                      AND r.policy_id = a.policy_id
                      --AND '01' || SUBSTR(A.BOOKING_MTH,1,3) || TO_CHAR(A.BOOKING_YEAR) >= '01'||to_char(v_date_from,'fmMONYYYY')
                      --AND '31' || SUBSTR(A.BOOKING_MTH,1,3) || TO_CHAR(A.BOOKING_YEAR) <= '31'||to_char(v_date_to,'fmMONYYYY')
                       --AND a.subline_cd = v_subline
                      GROUP BY  a.line_cd,
                                a.subline_cd,
                                a.iss_cd ,
                                a.issue_yy,
                                a.pol_seq_no,
                                a.renew_no,
                                b.item_no,
                                g.zone_type,
                                b.coverage_cd,
                                f.subline_type_cd,
                                f.subline_type_desc) */
            --LOOP
               IF c1.coverage_cd = 1 and v_zone_type <> 'null'  THEN
                   UPDATE GIXX_LTO_STAT
                   SET peril_stat_name = v_peril_stat_name;
                   COMMIT;
                     UPDATE GIXX_LTO_STAT
                     SET mla_cnt  = NVL(mla_cnt,0) + 1
                     WHERE peril_stat_name = v_peril_stat_name
                     AND subline = c1.subline_type_cd;
                     COMMIT;
                ELSIF c1.coverage_cd = 2 and v_zone_type <> 'null'  THEN
                   UPDATE GIXX_LTO_STAT
                   SET peril_stat_name = v_peril_stat_name;
                   COMMIT;
                     UPDATE GIXX_LTO_STAT
                     SET outside_mla_cnt  = NVL(outside_mla_cnt,0) + 1
                     WHERE peril_stat_name = v_peril_stat_name
                     AND subline = c1.subline_type_cd;
                     COMMIT;
                ELSIF c1.coverage_cd = 1 and v_zone_type = 'null' THEN   --v_zone_type null
                       SELECT  rv_meaning name
                       INTO v_name
                       FROM cg_ref_codes
                       WHERE rv_domain = 'GIIS_PERIL.ZONE_TYPE'
                       AND RV_LOW_VALUE = c1.zone_type;
                       UPDATE GIXX_LTO_STAT
                       SET mla_cnt =  NVL(mla_cnt,0) + 1
                       WHERE peril_stat_name = v_name
                       AND subline = c1.subline_type_desc;
                       COMMIT;
                ELSIF c1.coverage_cd = 2 and v_zone_type = 'null' THEN   --v_zone_type null
                       SELECT  rv_meaning name
                       INTO v_name
                       FROM cg_ref_codes
                       WHERE rv_domain = 'GIIS_PERIL.ZONE_TYPE'
                       AND RV_LOW_VALUE = c1.zone_type;
                       UPDATE GIXX_LTO_STAT
                       SET outside_mla_cnt =  NVL(outside_mla_cnt,0) + 1
                       WHERE peril_stat_name = v_name
                       AND subline = c1.subline_type_desc;
                       COMMIT;
               END IF;
            --END LOOP;
                IF c1.coverage_cd = 1 and v_zone_type <> 'null'  THEN
                   UPDATE GIXX_LTO_STAT
                   SET peril_stat_name = v_peril_stat_name;
                   COMMIT;
                     UPDATE GIXX_LTO_STAT
                     SET mla_prem  = NVL(mla_prem,0) + NVL(c1.prem_amt,0)
                     WHERE peril_stat_name = v_peril_stat_name
                     AND subline = c1.subline_type_cd;
                     COMMIT;
                ELSIF c1.coverage_cd = 2 and v_zone_type <> 'null'  THEN
                   UPDATE GIXX_LTO_STAT
                   SET peril_stat_name = v_peril_stat_name;
                   COMMIT;
                     UPDATE GIXX_LTO_STAT
                     SET outside_mla_prem  = NVL(outside_mla_prem,0) + NVL(c1.prem_amt,0)
                     WHERE peril_stat_name = v_peril_stat_name
                     AND subline = c1.subline_type_cd;
                     COMMIT;
                ELSIF c1.coverage_cd = 1 and v_zone_type = 'null' THEN   --v_zone_type null
                       SELECT  rv_meaning name
                       INTO v_name
                       FROM cg_ref_codes
                       WHERE rv_domain = 'GIIS_PERIL.ZONE_TYPE'
                       AND RV_LOW_VALUE = c1.zone_type;
                       UPDATE GIXX_LTO_STAT
                       SET mla_prem =  NVL(mla_prem,0) + NVL(c1.prem_amt,0)
                       WHERE peril_stat_name = v_name
                       AND subline = c1.subline_type_desc;
                       COMMIT;
                ELSIF c1.coverage_cd = 2 and v_zone_type = 'null' THEN   --v_zone_type null
                       SELECT  rv_meaning name
                       INTO v_name
                       FROM cg_ref_codes
                       WHERE rv_domain = 'GIIS_PERIL.ZONE_TYPE'
                       AND RV_LOW_VALUE = c1.zone_type;
                       UPDATE GIXX_LTO_STAT
                       SET outside_mla_prem =  NVL(outside_mla_prem,0) + NVL(c1.prem_amt,0)
                       WHERE peril_stat_name = v_name
                       AND subline = c1.subline_type_desc;
                       COMMIT;
               END IF;
      END LOOP;
     END LOOP;
    END;
 END;
/


