DROP PROCEDURE CPI.DEFERRED_EXTRACT2_PRIOR_DTL;

CREATE OR REPLACE PROCEDURE CPI.Deferred_Extract2_Prior_Dtl(p_ext_year           NUMBER,
                                                  p_ext_mm             NUMBER,
                                                  p_year               NUMBER,
                                                  p_mm                 NUMBER,
                                                  p_method             NUMBER) IS

  v_iss_cd_ri        GIPI_POLBASIC.iss_cd%TYPE;--holds param value of the parameter 'ISS_CD_RI' in giis_parameters
  v_iss_cd_rv        GIPI_POLBASIC.iss_cd%TYPE;--holds param value of the parameter 'ISS_CD_RV' in giis_parameters
  v_paramdate        VARCHAR2(1) := 'A';
  v_mm_year          VARCHAR2(7);
  v_mm_year_mn1      VARCHAR2(7);
  v_mm_year_mn2      VARCHAR2(7);
  v_exclude_mn       VARCHAR2(1) := NVL(Giacp.v('EXCLUDE_MARINE_24TH'),'N');
  v_mn               GIIS_PARAMETERS.param_value_v%TYPE;--totel--2/11/2008
  v_mn_24th_comp     VARCHAR2(1) := Giacp.v('MARINE_COMPUTATION_24TH');
  v_start_date       DATE := TO_DATE(giacp.v('24TH_METHOD_START_DATE'),'MM-YYYY');

/*
** Created by:   Alfie
** Date Created: 06302011
** Description:  Extracts detailed data required for the monthly computation of 24th Method: (Prior Acct Ent Date)
*/

BEGIN
  --added by totel--2/11/2008--@fpac--for tuning purpose
  SELECT Giisp.v('LINE_CODE_MN')
    INTO v_mn
    FROM dual;
  --end--totel--2/11/2008

  v_iss_cd_ri     := Giisp.v('ISS_CD_RI');
  v_iss_cd_rv     := Giisp.v('ISS_CD_RV');
  v_paramdate     := Giacp.v('24TH_METHOD_PARAMDATE');
  --v_mm_year       := LPAD(TO_CHAR(p_mm),2,'0') || '-' || TO_CHAR(p_year);
  v_mm_year_mn1   := TO_CHAR(TO_DATE(LPAD(TO_CHAR(p_ext_mm),2,'0') || '-' || TO_CHAR(p_ext_year), 'MM-YYYY') - 1, 'MM') || '-' ||
                     TO_CHAR(TO_DATE(LPAD(TO_CHAR(p_ext_mm),2,'0') || '-' || TO_CHAR(p_ext_year), 'MM-YYYY') - 1, 'YYYY');
  v_mm_year_mn2   := LPAD(TO_CHAR(p_ext_mm),2,'0') || '-' || TO_CHAR(p_ext_year);

  --GROSS PREMIUMS
  FOR gross IN(
    SELECT NVL(b.cred_branch,a.iss_cd) iss_cd,
               b.line_cd,
               SUM(DECODE(TO_CHAR(b.spld_acct_ent_date,'MM-YYYY'), v_mm_year, -1, 1)
                 * a.prem_amt * a.currency_rt) premium,
               DECODE(v_paramdate, 'A', p_year, 'E', --TO_NUMBER(TO_CHAR(b.eff_date,'YYYY'))) grp_year,
                 DECODE(SIGN(LAST_DAY(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'))-LAST_DAY(TRUNC(b.eff_date))),-1,p_ext_year,TO_NUMBER(TO_CHAR(b.eff_date,'YYYY')))) grp_year,
               DECODE(v_paramdate, 'A', p_mm, 'E', --TO_NUMBER(TO_CHAR(b.eff_date,'MM'))) grp_mm commented by alfie: 06/30/2011: to add a row for advance booking policies
                 DECODE(SIGN(LAST_DAY(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'))-LAST_DAY(TRUNC(b.eff_date))),-1,99,TO_NUMBER(TO_CHAR(b.eff_date,'MM')))) grp_mm
          FROM GIPI_INVOICE a,
               GIPI_POLBASIC b
         WHERE a.policy_id = b.policy_id
           AND DECODE(v_start_date, NULL, SYSDATE, b.acct_ent_date) >= DECODE(v_start_date, NULL, SYSDATE, v_start_date)
           AND ((v_paramdate = 'E' AND TRUNC(b.eff_date) > LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'|| p_ext_year,'MM-YYYY'), -12))
                        /*AND TRUNC(b.eff_date) BETWEEN ADD_MONTHS(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'),-11) AND LAST_DAY(TO_DATE(v_mm_year,'MM-YYYY'))*/
                               )
                 OR
                 v_paramdate = 'A')
           /*AND (TO_CHAR(b.acct_ent_date,'MM-YYYY') = v_mm_year
                OR
                TO_CHAR(b.spld_acct_ent_date,'MM-YYYY') = v_mm_year)*/   -- judyann 04182008
           AND (a.acct_ent_date <= LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'||p_ext_year,'MM-YYYY'), -12))
                OR
                a.spoiled_acct_ent_date <= LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'||p_ext_year,'MM-YYYY'), -12)))
           AND b.reg_policy_sw = 'Y'
           AND ((v_exclude_mn = 'Y' AND
                b.line_cd <> v_mn)
                OR
                (v_exclude_mn = 'N' AND v_mn_24th_comp = '1' AND
                  (b.line_cd = v_mn AND
                    ((v_paramdate = 'A' AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2))
                     OR
                     (v_paramdate = 'E' /*AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2)*/ AND (TO_CHAR(b.eff_date,'MM-YYYY') IN (v_mm_year_mn1, v_mm_year_mn2)
                                                                                           OR
                                                                                           TRUNC(b.eff_date) > LAST_DAY(TO_DATE (p_ext_mm|| '-'|| p_ext_year,'MM-YYYY')))))
                  OR
                  b.line_cd <> v_mn)
                  OR v_mn_24th_comp = '2' AND b.line_cd = b.line_cd))
     GROUP BY NVL(b.cred_branch,a.iss_cd), b.line_cd,
           DECODE(v_paramdate, 'A', p_year, 'E', --TO_NUMBER(TO_CHAR(b.eff_date,'YYYY'))) grp_year,
             DECODE(SIGN(LAST_DAY(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'))-LAST_DAY(TRUNC(b.eff_date))),-1,p_ext_year,TO_NUMBER(TO_CHAR(b.eff_date,'YYYY')))),
           DECODE(v_paramdate, 'A', p_mm, 'E', --commented by alfie: 06/30/2011: to add a row for advance booking policies
             DECODE(SIGN(LAST_DAY(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'))-LAST_DAY(TRUNC(b.eff_date))),-1,99,TO_NUMBER(TO_CHAR(b.eff_date,'MM'))))
    )
  LOOP
    UPDATE GIAC_DEFERRED_GROSS_PREM_DTL gprem_dtl
       SET gprem_dtl.prem_amt = gprem_dtl.prem_amt + gross.premium
     WHERE gprem_dtl.extract_year = p_ext_year AND
           gprem_dtl.extract_mm   = p_ext_mm AND
           gprem_dtl.YEAR = gross.grp_year AND
           gprem_dtl.mm = gross.grp_mm AND
           gprem_dtl.iss_cd = gross.iss_cd AND
           gprem_dtl.line_cd = gross.line_cd AND
           gprem_dtl.procedure_id = p_method;
    IF SQL%NOTFOUND THEN
      INSERT INTO GIAC_DEFERRED_GROSS_PREM_DTL
        (extract_year,   extract_mm,    YEAR,            mm,            iss_cd,
         line_cd,        procedure_id,  prem_amt,        user_id,       last_update)
      VALUES
        (p_ext_year,     p_ext_mm,      gross.grp_year,  gross.grp_mm,  gross.iss_cd,
         gross.line_cd,  p_method,      gross.premium,   USER,          SYSDATE);
    END IF;
  END LOOP;
  
  --RI PREMIUMS CEDED AND COMMISSION INCOME
  --Treaty
  --Premiums
  FOR ri_prem1 IN (
    SELECT NVL(b.cred_branch,b.iss_cd) iss_cd,
           a.line_cd,
           SUM(NVL(a.premium_amt,0)) premium,
           --sum(nvl(a.commission_amt,0)) commission,
           NVL(c.acct_trty_type,0) acct_trty_type,
           DECODE(v_paramdate, 'A', p_year, 'E', --TO_NUMBER(TO_CHAR(b.eff_date,'YYYY'))) grp_year,
              DECODE(SIGN(LAST_DAY(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'))-LAST_DAY(TRUNC(b.eff_date))),-1,p_ext_year,TO_NUMBER(TO_CHAR(b.eff_date,'YYYY')))) grp_year,
           DECODE(v_paramdate, 'A', p_mm, 'E', --TO_NUMBER(TO_CHAR(b.eff_date,'MM'))) grp_mm commented by alfie: 06/30/2011: to add a row for advance booking policies
              DECODE(SIGN(LAST_DAY(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'))-LAST_DAY(TRUNC(b.eff_date))),-1,99,TO_NUMBER(TO_CHAR(b.eff_date,'MM')))) grp_mm
      FROM GIAC_TREATY_CESSIONS a,
           GIPI_POLBASIC b,
           GIIS_DIST_SHARE c
     WHERE a.policy_id = b.policy_id
       --AND a.cession_year = p_year
       --AND a.cession_mm = p_mm
       AND DECODE(v_start_date, NULL, SYSDATE, LAST_DAY(TO_DATE(a.cession_mm||'-'||a.cession_year,'MM-YYYY'))) >= DECODE(v_start_date, NULL, SYSDATE, v_start_date)
       AND LAST_DAY(TO_DATE(a.cession_mm||'-'||a.cession_year,'MM-YYYY')) <= LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'||p_ext_year,'MM-YYYY'), -12))
       AND a.line_cd = c.line_cd
       AND a.share_cd = c.share_cd
       AND ((v_paramdate = 'E' AND TRUNC(b.eff_date) > LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'|| p_ext_year,'MM-YYYY'), -12))
                )
             OR
             v_paramdate = 'A')
       AND b.reg_policy_sw = 'Y'
       AND ((v_exclude_mn = 'Y' AND
            b.line_cd <> v_mn)
            OR
            (v_exclude_mn = 'N' AND v_mn_24th_comp = '1' AND
              (b.line_cd = v_mn AND
                ((v_paramdate = 'A' AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2))
                 OR
                 (v_paramdate = 'E' /*AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2)*/ AND (TO_CHAR(b.eff_date,'MM-YYYY') IN (v_mm_year_mn1, v_mm_year_mn2)
                                                                                           OR 
                                                                                           TRUNC(b.eff_date) > LAST_DAY(TO_DATE (p_ext_mm|| '-'|| p_ext_year,'MM-YYYY')))))
              OR
              b.line_cd <> v_mn)
              OR v_mn_24th_comp = '2' AND b.line_cd = b.line_cd))
     GROUP BY NVL(b.cred_branch,b.iss_cd), a.line_cd, c.acct_trty_type,
           DECODE(v_paramdate, 'A', p_year, 'E',
             DECODE(SIGN(LAST_DAY(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'))-LAST_DAY(TRUNC(b.eff_date))),-1,p_ext_year,TO_NUMBER(TO_CHAR(b.eff_date,'YYYY')))),
           DECODE(v_paramdate, 'A', p_mm, 'E',
             DECODE(SIGN(LAST_DAY(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'))-LAST_DAY(TRUNC(b.eff_date))),-1,99,TO_NUMBER(TO_CHAR(b.eff_date,'MM'))))
    )
  LOOP
    UPDATE GIAC_DEFERRED_RI_PREM_CEDE_DTL ri_prem_dtl
       SET ri_prem_dtl.dist_prem = ri_prem_dtl.dist_prem + ri_prem1.premium
     WHERE ri_prem_dtl.extract_year = p_ext_year AND
           ri_prem_dtl.extract_mm   = p_ext_mm AND
           ri_prem_dtl.YEAR = ri_prem1.grp_year AND
           ri_prem_dtl.mm = ri_prem1.grp_mm AND
           ri_prem_dtl.iss_cd = ri_prem1.iss_cd AND
           ri_prem_dtl.line_cd = ri_prem1.line_cd AND
           ri_prem_dtl.procedure_id = p_method AND
           ri_prem_dtl.share_type = '2' AND
           ri_prem_dtl.acct_trty_type = ri_prem1.acct_trty_type;
    IF SQL%NOTFOUND THEN
      INSERT INTO GIAC_DEFERRED_RI_PREM_CEDE_DTL
        (extract_year,      extract_mm,    YEAR,               mm,                       iss_cd,
         line_cd,           procedure_id,  share_type,         acct_trty_type,           dist_prem,
         user_id,           last_update)
      VALUES
        (p_ext_year,        p_ext_mm,      ri_prem1.grp_year,  ri_prem1.grp_mm,          ri_prem1.iss_cd,
         ri_prem1.line_cd,  p_method,      '2',                ri_prem1.acct_trty_type,  ri_prem1.premium,
         USER,              SYSDATE);
    END IF;
  END LOOP;
  
  --Comm Income
  FOR ri_comm1 IN (
    SELECT NVL(b.cred_branch,b.iss_cd) iss_cd,
           a.line_cd,
           SUM(NVL(a.commission_amt,0)) commission,
           NVL(c.acct_trty_type,0) acct_trty_type,
           a.ri_cd,
           DECODE(v_paramdate, 'A', p_year, 'E',
             DECODE(SIGN(LAST_DAY(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'))-LAST_DAY(TRUNC(b.eff_date))),-1,p_ext_year,TO_NUMBER(TO_CHAR(b.eff_date,'YYYY')))) grp_year,
           DECODE(v_paramdate, 'A', p_mm, 'E', --TO_NUMBER(TO_CHAR(b.eff_date,'MM'))) grp_mm commented by alfie: 06/30/2011: to add a row for advance booking policies
             DECODE(SIGN(LAST_DAY(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'))-LAST_DAY(TRUNC(b.eff_date))),-1,99,TO_NUMBER(TO_CHAR(b.eff_date,'MM')))) grp_mm
      FROM GIAC_TREATY_CESSIONS a,
           GIPI_POLBASIC b,
           GIIS_DIST_SHARE c
     WHERE NVL(a.policy_id,a.policy_id) = b.policy_id --totel--2/11/2008--@fpac--tune--added NVL
       --AND a.cession_year = p_year
       --AND a.cession_mm = p_mm
       AND DECODE(v_start_date, NULL, SYSDATE, LAST_DAY(TO_DATE(a.cession_mm||'-'||a.cession_year,'MM-YYYY'))) >= DECODE(v_start_date, NULL, SYSDATE, v_start_date)
       AND LAST_DAY(TO_DATE(a.cession_mm||'-'||a.cession_year,'MM-YYYY')) <= LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'||p_ext_year,'MM-YYYY'), -12))
       AND a.line_cd = c.line_cd
       AND a.share_cd = c.share_cd
       AND ((v_paramdate = 'E' AND TRUNC(b.eff_date) > LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'|| p_ext_year,'MM-YYYY'), -12))
                 /*AND TRUNC(b.eff_date) BETWEEN ADD_MONTHS(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'),-11) AND LAST_DAY(TO_DATE(v_mm_year,'MM-YYYY'))*/
                )
             OR
             v_paramdate = 'A')
       AND b.reg_policy_sw = 'Y'
           AND ((v_exclude_mn = 'Y' AND
                b.line_cd <> v_mn)
                OR
                (v_exclude_mn = 'N' AND v_mn_24th_comp = '1' AND
                  (b.line_cd = v_mn AND
                    ((v_paramdate = 'A' AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2))
                     OR
                     (v_paramdate = 'E' /*AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2)*/ AND (TO_CHAR(b.eff_date,'MM-YYYY') IN (v_mm_year_mn1, v_mm_year_mn2)
                                                                                               OR 
                                                                                               TRUNC(b.eff_date) > LAST_DAY(TO_DATE (p_ext_mm|| '-'|| p_ext_year,'MM-YYYY')))))
                  OR
                  b.line_cd <> v_mn)
                  OR v_mn_24th_comp = '2' AND b.line_cd = b.line_cd))
     GROUP BY NVL(b.cred_branch,b.iss_cd), a.line_cd, c.acct_trty_type, a.ri_cd,
           DECODE(v_paramdate, 'A', p_year, 'E', --TO_NUMBER(TO_CHAR(b.eff_date,'YYYY'))) grp_year,
             DECODE(SIGN(LAST_DAY(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'))-LAST_DAY(TRUNC(b.eff_date))),-1,p_ext_year,TO_NUMBER(TO_CHAR(b.eff_date,'YYYY')))),
           DECODE(v_paramdate, 'A', p_mm, 'E', --TO_NUMBER(TO_CHAR(b.eff_date,'MM'))) grp_mm commented by alfie: 06/30/2011: to add a row for advance booking policies
             DECODE(SIGN(LAST_DAY(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'))-LAST_DAY(TRUNC(b.eff_date))),-1,99,TO_NUMBER(TO_CHAR(b.eff_date,'MM'))))
    )
  LOOP
    UPDATE GIAC_DEFERRED_COMM_INCOME_DTL comm_inc_dtl
       SET comm_inc_dtl.comm_income = comm_inc_dtl.comm_income + ri_comm1.commission
     WHERE comm_inc_dtl.extract_year = p_ext_year AND
           comm_inc_dtl.extract_mm   = p_ext_mm AND
           comm_inc_dtl.YEAR = ri_comm1.grp_year AND
           comm_inc_dtl.mm = ri_comm1.grp_mm AND
           comm_inc_dtl.iss_cd = ri_comm1.iss_cd AND
           comm_inc_dtl.line_cd = ri_comm1.line_cd AND
           comm_inc_dtl.procedure_id = p_method AND
           comm_inc_dtl.share_type = '2' AND
           comm_inc_dtl.acct_trty_type = ri_comm1.acct_trty_type AND
     comm_inc_dtl.ri_cd = ri_comm1.ri_cd;
    IF SQL%NOTFOUND THEN
      INSERT INTO GIAC_DEFERRED_COMM_INCOME_DTL
        (extract_year,      extract_mm,    YEAR,               mm,                       iss_cd,
         line_cd,           procedure_id,  share_type,         acct_trty_type,           ri_cd,
         comm_income,
         user_id,           last_update)
      VALUES
        (p_ext_year,        p_ext_mm,      ri_comm1.grp_year,  ri_comm1.grp_mm,          ri_comm1.iss_cd,
         ri_comm1.line_cd,  p_method,      '2',                ri_comm1.acct_trty_type,  ri_comm1.ri_cd,
         ri_comm1.commission,
         USER, SYSDATE);
    END IF;
  END LOOP;

  --Facultative
  --Premiums
      FOR ri_prem2 IN (
        SELECT NVL(e.cred_branch,e.iss_cd) iss_cd,
               a.line_cd,
               SUM(DECODE(TO_CHAR(a.acc_rev_date,'MM-YYYY'), v_mm_year, -1, 1)
                 * a.ri_prem_amt * c.currency_rt) premium,
               --sum(nvl(decode(to_char(a.acc_rev_date,'MM-YYYY'), v_mm_year, -1, 1)
               --  * a.ri_comm_amt * c.currency_rt, 0)) commission,
               DECODE(v_paramdate, 'A', p_year, 'E', --TO_NUMBER(TO_CHAR(b.eff_date,'YYYY'))) grp_year,
                 DECODE(SIGN(LAST_DAY(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'))-LAST_DAY(TRUNC(e.eff_date))),-1,p_ext_year,TO_NUMBER(TO_CHAR(e.eff_date,'YYYY')))) grp_year,
               DECODE(v_paramdate, 'A', p_mm, 'E', --TO_NUMBER(TO_CHAR(b.eff_date,'MM'))) grp_mm commented by alfie: 06/30/2011: to add a row for advance booking policies
                 DECODE(SIGN(LAST_DAY(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'))-LAST_DAY(TRUNC(e.eff_date))),-1,99,TO_NUMBER(TO_CHAR(e.eff_date,'MM')))) grp_mm
          FROM GIRI_BINDER a,
               GIRI_FRPS_RI b,
               GIRI_DISTFRPS c,
               GIUW_POL_DIST d,
               GIPI_POLBASIC e
         WHERE a.fnl_binder_id = b. fnl_binder_id
           AND b.line_cd = c.line_cd
           AND b.frps_yy = c.frps_yy
           AND b.frps_seq_no = c.frps_seq_no
           AND c.dist_no = d.dist_no
           AND d.policy_id = e.policy_id
           AND (DECODE(v_start_date, NULL, SYSDATE, a.acc_ent_date) >= DECODE(v_start_date, NULL, SYSDATE, v_start_date)
                OR
                DECODE(v_start_date, NULL, SYSDATE, a.acc_rev_date) >= DECODE(v_start_date, NULL, SYSDATE, v_start_date))
           AND ((a.acc_ent_date <= LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'||p_ext_year,'MM-YYYY'), -12))
                    AND (DECODE(a.acc_ent_date, LAST_DAY(TO_DATE (p_ext_mm||'-'||p_ext_year, 'MM-YYYY')), a.acc_ent_date,
                            a.acc_rev_date) <= LAST_DAY(TO_DATE (p_ext_mm||'-'||p_ext_year, 'MM-YYYY'))
                         OR a.acc_rev_date IS NULL))
                OR
                a.acc_rev_date <= LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'||p_ext_year,'MM-YYYY'), -12)))
           AND (DECODE(a.acc_rev_date, NULL, sysdate,a.acc_rev_date) = DECODE(a.acc_rev_date, NULL,sysdate, LAST_DAY(TO_DATE (v_mm_year, 'MM-YYYY')))
                OR
                DECODE(a.acc_rev_date, NULL, sysdate,a.acc_rev_date) > DECODE(a.acc_rev_date, NULL,sysdate, LAST_DAY(TO_DATE (p_ext_mm||'-'||p_ext_year, 'MM-YYYY')))
                )  
           AND ((v_paramdate = 'E' AND TRUNC(e.eff_date) > LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'|| p_ext_year,'MM-YYYY'), -12))
                    /*AND TRUNC(e.eff_date) BETWEEN ADD_MONTHS(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'),-11) AND LAST_DAY(TO_DATE(v_mm_year,'MM-YYYY'))*/
                        )
                 OR
                 v_paramdate = 'A')
           AND e.reg_policy_sw = 'Y'
           AND ((v_exclude_mn = 'Y' AND
                e.line_cd <> v_mn)
                OR
                (v_exclude_mn = 'N' AND v_mn_24th_comp = '1' AND
                  (e.line_cd = v_mn AND
                    ((v_paramdate = 'A' AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2))
                     OR
                     (v_paramdate = 'E' /*AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2)*/ AND (TO_CHAR(e.eff_date,'MM-YYYY') IN (v_mm_year_mn1, v_mm_year_mn2)
                                                                                               OR
                                                                                               TRUNC(E.eff_date) > LAST_DAY(TO_DATE (p_ext_mm|| '-'|| p_ext_year,'MM-YYYY')))))
                  OR
                  e.line_cd <> v_mn)
                  OR v_mn_24th_comp = '2' AND e.line_cd = e.line_cd))
         GROUP BY NVL(e.cred_branch,e.iss_cd), a.line_cd,
               DECODE(v_paramdate, 'A', p_year, 'E', --TO_NUMBER(TO_CHAR(b.eff_date,'YYYY'))) grp_year,
                 DECODE(SIGN(LAST_DAY(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'))-LAST_DAY(TRUNC(e.eff_date))),-1,p_ext_year,TO_NUMBER(TO_CHAR(e.eff_date,'YYYY')))),
               DECODE(v_paramdate, 'A', p_mm, 'E', --TO_NUMBER(TO_CHAR(b.eff_date,'MM'))) grp_mm commented by alfie: 06/30/2011: to add a row for advance booking policies
                 DECODE(SIGN(LAST_DAY(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'))-LAST_DAY(TRUNC(e.eff_date))),-1,99,TO_NUMBER(TO_CHAR(e.eff_date,'MM'))))
        )
      LOOP
             --insert into trace_table (col1, col2, col3) values (v_mm_year, ri_prem2.line_cd||','||ri_prem2.iss_cd||','||ri_prem2.grp_mm||','||ri_prem2.grp_year,ri_prem2.premium);
        UPDATE GIAC_DEFERRED_RI_PREM_CEDE_DTL ri_prem_dtl
           SET ri_prem_dtl.dist_prem = ri_prem_dtl.dist_prem + ri_prem2.premium
         WHERE ri_prem_dtl.extract_year = p_ext_year AND
               ri_prem_dtl.extract_mm   = p_ext_mm AND
               ri_prem_dtl.YEAR = ri_prem2.grp_year AND
               ri_prem_dtl.mm = ri_prem2.grp_mm AND
               ri_prem_dtl.iss_cd = ri_prem2.iss_cd AND
               ri_prem_dtl.line_cd = ri_prem2.line_cd AND
               ri_prem_dtl.procedure_id = p_method AND
               ri_prem_dtl.share_type = '3' AND
               ri_prem_dtl.acct_trty_type = 0;
        IF SQL%NOTFOUND THEN
          INSERT INTO GIAC_DEFERRED_RI_PREM_CEDE_DTL
            (extract_year,      extract_mm,        YEAR,          mm,
             iss_cd,            line_cd,           procedure_id,  share_type,
             dist_prem,         user_id,           last_update)
          VALUES
            (p_ext_year,        p_ext_mm,          ri_prem2.grp_year,        ri_prem2.grp_mm,
             ri_prem2.iss_cd,   ri_prem2.line_cd,  p_method,      '3',
             ri_prem2.premium,  USER,              SYSDATE);
        END IF;
      END LOOP;

  --Comm Income
  FOR ri_comm2 IN (
    SELECT NVL(e.cred_branch,e.iss_cd) iss_cd,
           a.line_cd,
           a.ri_cd,
           SUM(NVL(DECODE(TO_CHAR(a.acc_rev_date,'MM-YYYY'), v_mm_year, -1, 1)
             * a.ri_comm_amt * c.currency_rt, 0)) commission,
           DECODE(v_paramdate, 'A', p_year, 'E', --TO_NUMBER(TO_CHAR(b.eff_date,'YYYY'))) grp_year,
             DECODE(SIGN(LAST_DAY(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'))-LAST_DAY(TRUNC(e.eff_date))),-1,p_ext_year,TO_NUMBER(TO_CHAR(e.eff_date,'YYYY')))) grp_year,
           DECODE(v_paramdate, 'A', p_mm, 'E', --TO_NUMBER(TO_CHAR(b.eff_date,'MM'))) grp_mm commented by alfie: 06/30/2011: to add a row for advance booking policies
             DECODE(SIGN(LAST_DAY(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'))-LAST_DAY(TRUNC(e.eff_date))),-1,99,TO_NUMBER(TO_CHAR(e.eff_date,'MM')))) grp_mm
      FROM GIRI_BINDER a,
           GIRI_FRPS_RI b,
           GIRI_DISTFRPS c,
           GIUW_POL_DIST d,
           GIPI_POLBASIC e
     WHERE a.fnl_binder_id = b. fnl_binder_id
       AND b.line_cd = c.line_cd
       AND b.frps_yy = c.frps_yy
       AND b.frps_seq_no = c.frps_seq_no
       AND c.dist_no = d.dist_no
       AND d.policy_id = e.policy_id
       AND (DECODE(v_start_date, NULL, SYSDATE, a.acc_ent_date) >= DECODE(v_start_date, NULL, SYSDATE, v_start_date)
     --  AND (a.acc_ent_date <= LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'||p_ext_year,'MM-YYYY'), -12))
   --         OR
   --         a.acc_rev_date <= LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'||p_ext_year,'MM-YYYY'), -12)))
          OR
            DECODE (v_start_date, NULL, SYSDATE, a.acc_rev_date) >= DECODE (v_start_date, NULL, SYSDATE, v_start_date))
       AND ((a.acc_ent_date <= LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'||p_ext_year,'MM-YYYY'), -12))
                    AND (DECODE(a.acc_ent_date, LAST_DAY(TO_DATE (p_ext_mm||'-'||p_ext_year, 'MM-YYYY')), a.acc_ent_date,
                            a.acc_rev_date) <= LAST_DAY(TO_DATE (p_ext_mm||'-'||p_ext_year, 'MM-YYYY'))
                         OR a.acc_rev_date IS NULL))
                OR
                a.acc_rev_date <= LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'||p_ext_year,'MM-YYYY'), -12)))
       AND (DECODE(a.acc_rev_date, NULL, sysdate,a.acc_rev_date) = DECODE(a.acc_rev_date, NULL,sysdate, LAST_DAY(TO_DATE (v_mm_year, 'MM-YYYY')))
                OR
                DECODE(a.acc_rev_date, NULL, sysdate,a.acc_rev_date) > DECODE(a.acc_rev_date, NULL,sysdate, LAST_DAY(TO_DATE (p_ext_mm||'-'||p_ext_year, 'MM-YYYY')))
                )      
       AND ((v_paramdate = 'E' AND TRUNC(e.eff_date) > LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'|| p_ext_year,'MM-YYYY'), -12))
                /*AND TRUNC(e.eff_date) BETWEEN ADD_MONTHS(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'),-11) AND LAST_DAY(TO_DATE(v_mm_year,'MM-YYYY'))*/
                )
             OR
             v_paramdate = 'A')
       AND e.reg_policy_sw = 'Y'
       AND ((v_exclude_mn = 'Y' AND
            e.line_cd <> v_mn)
            OR
            (v_exclude_mn = 'N' AND v_mn_24th_comp = '1' AND
              (e.line_cd = v_mn AND
                ((v_paramdate = 'A' AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2))
                 OR
                 (v_paramdate = 'E' /*AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2)*/ AND (TO_CHAR(e.eff_date,'MM-YYYY') IN (v_mm_year_mn1, v_mm_year_mn2)
                                                                                           OR 
                                                                                           TRUNC(e.eff_date) > LAST_DAY(TO_DATE (p_ext_mm|| '-'|| p_ext_year,'MM-YYYY')))))
              OR
              e.line_cd <> v_mn)
              OR v_mn_24th_comp = '2' AND e.line_cd = e.line_cd))
     GROUP BY NVL(e.cred_branch,e.iss_cd), a.line_cd, a.ri_cd,
           DECODE(v_paramdate, 'A', p_year, 'E', --TO_NUMBER(TO_CHAR(b.eff_date,'YYYY'))) grp_year,
             DECODE(SIGN(LAST_DAY(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'))-LAST_DAY(TRUNC(e.eff_date))),-1,p_ext_year,TO_NUMBER(TO_CHAR(e.eff_date,'YYYY')))),
           DECODE(v_paramdate, 'A', p_mm, 'E', --TO_NUMBER(TO_CHAR(b.eff_date,'MM'))) grp_mm commented by alfie: 06/30/2011: to add a row for advance booking policies
             DECODE(SIGN(LAST_DAY(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'))-LAST_DAY(TRUNC(e.eff_date))),-1,99,TO_NUMBER(TO_CHAR(e.eff_date,'MM'))))
    )
  LOOP
    UPDATE GIAC_DEFERRED_COMM_INCOME_DTL comm_inc_dtl
       SET comm_inc_dtl.comm_income = comm_inc_dtl.comm_income + ri_comm2.commission
     WHERE comm_inc_dtl.extract_year = p_ext_year AND
           comm_inc_dtl.extract_mm   = p_ext_mm AND
           comm_inc_dtl.YEAR = ri_comm2.grp_year AND
           comm_inc_dtl.mm = ri_comm2.grp_mm AND
           comm_inc_dtl.iss_cd = ri_comm2.iss_cd AND
           comm_inc_dtl.line_cd = ri_comm2.line_cd AND
           comm_inc_dtl.procedure_id = p_method AND
           comm_inc_dtl.share_type = '3' AND
           comm_inc_dtl.acct_trty_type = 0 AND
     comm_inc_dtl.ri_cd = ri_comm2.ri_cd;
    IF SQL%NOTFOUND THEN
      INSERT INTO GIAC_DEFERRED_COMM_INCOME_DTL
        (extract_year,         extract_mm,        YEAR,          mm,
         iss_cd,               line_cd,           procedure_id,  share_type,
         ri_cd,
         comm_income,          user_id,           last_update)
      VALUES
        (p_ext_year,           p_ext_mm,          ri_comm2.grp_year, ri_comm2.grp_mm,
         ri_comm2.iss_cd,      ri_comm2.line_cd,  p_method,          '3',
         ri_comm2.ri_cd,
         ri_comm2.commission,  USER,              SYSDATE);
    END IF;
  END LOOP;


  --COMMISSION EXPENSE
  --Direct Extract
  FOR expdi IN (
    SELECT iss_cd, line_cd, intm_no,
           SUM(comm_expense) comm_expense,
           DECODE(v_paramdate, 'A', p_year, 'E', --TO_NUMBER(TO_CHAR(b.eff_date,'YYYY'))) grp_year,
             DECODE(SIGN(LAST_DAY(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'))-LAST_DAY(TRUNC(eff_date))),-1,p_ext_year,TO_NUMBER(TO_CHAR(eff_date,'YYYY')))) grp_year,
           DECODE(v_paramdate, 'A', p_mm, 'E', --TO_NUMBER(TO_CHAR(b.eff_date,'MM'))) grp_mm commented by alfie: 06/30/2011: to add a row for advance booking policies
             DECODE(SIGN(LAST_DAY(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'))-LAST_DAY(TRUNC(eff_date))),-1,99,TO_NUMBER(TO_CHAR(eff_date,'MM')))) grp_mm
      FROM (SELECT NVL(b.cred_branch,a.iss_cd) iss_cd, --SELECT stmnt for unmodified commissions
                   b.line_cd,
                      d.intrmdry_intm_no intm_no,
                   /*d.commission_amt
                     * DECODE(TO_CHAR(b.spld_acct_ent_date,'MM-YYYY'), v_mm_year, -1, 1)
                     * a.currency_rt comm_expense*/   -- judyann 04182008
                   d.commission_amt
                     * DECODE(TO_CHAR(a.spoiled_acct_ent_date,'MM-YYYY'), v_mm_year, -1, 1)
                     * a.currency_rt comm_expense, b.eff_date
              FROM GIPI_INVOICE a,
                   GIPI_POLBASIC b,
                   GIPI_COMM_INVOICE d
             WHERE a.iss_cd = d.iss_cd
               AND a.prem_seq_no = d.prem_seq_no
               AND a.policy_id = d.policy_id
               AND a.policy_id = b.policy_id
               AND DECODE(v_start_date, NULL, SYSDATE, a.acct_ent_date) >= DECODE(v_start_date, NULL, SYSDATE, v_start_date)
               AND ((v_paramdate = 'E' AND TRUNC(b.eff_date) > LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'|| p_ext_year,'MM-YYYY'), -12))
                        /*AND TRUNC(b.eff_date) BETWEEN ADD_MONTHS(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'),-11) AND LAST_DAY(TO_DATE(v_mm_year,'MM-YYYY'))*/
                            )
                     OR
                     v_paramdate = 'A')
               /*AND (TO_CHAR(b.acct_ent_date,'MM-YYYY') = v_mm_year
                    OR
                    TO_CHAR(b.spld_acct_ent_date,'MM-YYYY') = v_mm_year)*/   -- judyann 04182008
               AND (a.acct_ent_date <= LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'||p_ext_year,'MM-YYYY'), -12))
                    OR
                    a.spoiled_acct_ent_date <= LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'||p_ext_year,'MM-YYYY'), -12)))
               AND b.iss_cd NOT IN (v_iss_cd_ri, v_iss_cd_rv)
               AND b.reg_policy_sw = 'Y'
               AND ((v_exclude_mn = 'Y' AND
                    b.line_cd <> v_mn)
                    OR
                    (v_exclude_mn = 'N' AND v_mn_24th_comp = '1' AND
                      (b.line_cd = v_mn AND
                        ((v_paramdate = 'A' AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2))
                         OR
                         (v_paramdate = 'E' /*AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2)*/ AND (TO_CHAR(b.eff_date,'MM-YYYY') IN (v_mm_year_mn1, v_mm_year_mn2)
                                                                                                    OR 
                                                                                                    TRUNC(b.eff_date) > LAST_DAY(TO_DATE (p_ext_mm|| '-'|| p_ext_year,'MM-YYYY')))))
                      OR
                      b.line_cd <> v_mn)
                      OR v_mn_24th_comp = '2' AND b.line_cd = b.line_cd))
               AND NOT EXISTS (SELECT 'X'
                                 FROM GIAC_PREV_COMM_INV g, GIAC_NEW_COMM_INV h
                                WHERE g.fund_cd = h.fund_cd
                                  AND g.branch_cd = h.branch_cd
                                  AND g.comm_rec_id = h.comm_rec_id
                                  AND g.intm_no = h.intm_no
                                  AND TO_CHAR(g.acct_ent_date, 'MM-YYYY') = v_mm_year
                                  AND h.acct_ent_date > LAST_DAY(TO_DATE(v_mm_year, 'MM-YYYY'))
                                  AND h.tran_flag = 'P'
                                  AND h.iss_cd = d.iss_cd
                                  AND h.prem_seq_no = d.prem_seq_no)
            UNION ALL
            --SELECT stmnt for comms modified in the succeeding months
            SELECT NVL(b.cred_branch,a.iss_cd) iss_cd,
                   b.line_cd,
                      c.intm_no,
                   /*c.commission_amt
                     * DECODE(TO_CHAR(b.spld_acct_ent_date,'MM-YYYY'), v_mm_year, -1, 1)
                     * a.currency_rt comm_expense*/    -- judyann 04182008
                   c.commission_amt
                     * DECODE(TO_CHAR(a.spoiled_acct_ent_date,'MM-YYYY'), v_mm_year, -1, 1)
                     * a.currency_rt comm_expense, b.eff_date
              FROM GIPI_INVOICE a,
                   GIPI_POLBASIC b,
                   GIAC_PREV_COMM_INV c,
                   GIAC_NEW_COMM_INV d
             WHERE a.policy_id = b.policy_id
               AND a.iss_cd = d.iss_cd
               AND a.prem_seq_no = d.prem_seq_no
               AND a.policy_id = d.policy_id
               AND ((v_paramdate = 'E' AND TRUNC(b.eff_date) > LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'|| p_ext_year,'MM-YYYY'), -12))
                        /*AND TRUNC(b.eff_date) BETWEEN ADD_MONTHS(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'),-11) AND LAST_DAY(TO_DATE(v_mm_year,'MM-YYYY'))*/
                        )
                     OR
                     v_paramdate = 'A')
               AND DECODE(v_start_date, NULL, SYSDATE, a.acct_ent_date) >= DECODE(v_start_date, NULL, SYSDATE, v_start_date)
               /*AND (TO_CHAR(b.acct_ent_date,'MM-YYYY') = v_mm_year
                    OR
                    TO_CHAR(b.spld_acct_ent_date,'MM-YYYY') = v_mm_year)*/   -- judyann 04182008
               AND (a.acct_ent_date <= LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'||p_ext_year,'MM-YYYY'), -12))
                    OR
                    a.spoiled_acct_ent_date <= LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'||p_ext_year,'MM-YYYY'), -12)))
               AND b.iss_cd NOT IN (v_iss_cd_ri, v_iss_cd_rv)
               AND b.reg_policy_sw = 'Y'
               AND ((v_exclude_mn = 'Y' AND
                    b.line_cd <> v_mn)
                    OR
                    (v_exclude_mn = 'N' AND v_mn_24th_comp = '1' AND
                      (b.line_cd = v_mn AND
                        ((v_paramdate = 'A' AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2))
                         OR
                         (v_paramdate = 'E' /*AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2)*/ AND (TO_CHAR(b.eff_date,'MM-YYYY') IN (v_mm_year_mn1, v_mm_year_mn2)
                                                                                                    OR 
                                                                                                    TRUNC(b.eff_date) > LAST_DAY(TO_DATE (p_ext_mm|| '-'|| p_ext_year,'MM-YYYY')))))
                      OR
                      b.line_cd <> v_mn)
                      OR v_mn_24th_comp = '2' AND b.line_cd = b.line_cd))
               AND c.fund_cd = d.fund_cd
               AND c.branch_cd = d.branch_cd
               AND c.comm_rec_id = d.comm_rec_id
               AND c.intm_no = d.intm_no
               AND TO_CHAR(c.acct_ent_date, 'MM-YYYY') = v_mm_year
               AND d.acct_ent_date > LAST_DAY(TO_DATE(v_mm_year, 'MM-YYYY'))
               AND d.tran_flag = 'P'
               AND c.comm_rec_id = (SELECT MIN(g.comm_rec_id)
                                      FROM GIAC_PREV_COMM_INV g, GIAC_NEW_COMM_INV h
                                     WHERE g.fund_cd = h.fund_cd
                                       AND g.branch_cd = h.branch_cd
                                       AND g.comm_rec_id = h.comm_rec_id
                                       AND g.intm_no = h.intm_no
                                       AND TO_CHAR(g.acct_ent_date, 'MM-YYYY') = v_mm_year
                                       AND h.acct_ent_date > LAST_DAY(TO_DATE(v_mm_year, 'MM-YYYY'))
                                       AND h.tran_flag = 'P'
                                       AND h.iss_cd = d.iss_cd
                                       AND h.prem_seq_no = d.prem_seq_no
                                       AND h.intm_no = d.intm_no)
            UNION ALL
            --SELECT stmnt for comms modified within selected month
            SELECT NVL(b.cred_branch,a.iss_cd) iss_cd,
                   b.line_cd,
                   d.intm_no,
                   (d.commission_amt * a.currency_rt) comm_expense, b.eff_date
              FROM GIPI_INVOICE a,
                   GIPI_POLBASIC b,
                   GIAC_NEW_COMM_INV d
             WHERE a.policy_id = b.policy_id
               AND a.iss_cd = d.iss_cd
               AND a.prem_seq_no = d.prem_seq_no
               AND a.policy_id = d.policy_id
               AND ((v_paramdate = 'E' AND TRUNC(b.eff_date) > LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'|| p_ext_year,'MM-YYYY'), -12))
                        /*AND TRUNC(b.eff_date) BETWEEN ADD_MONTHS(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'),-11) AND LAST_DAY(TO_DATE(v_mm_year,'MM-YYYY'))*/
                        )
                     OR
                     v_paramdate = 'A')
               AND b.iss_cd NOT IN (v_iss_cd_ri, v_iss_cd_rv)
               AND b.reg_policy_sw = 'Y'
               AND ((v_exclude_mn = 'Y' AND
                    b.line_cd <> v_mn)
                    OR
                    (v_exclude_mn = 'N' AND v_mn_24th_comp = '1' AND
                      (b.line_cd = v_mn AND
                        ((v_paramdate = 'A' AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2))
                         OR
                         (v_paramdate = 'E' /*AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2)*/ AND (TO_CHAR(b.eff_date,'MM-YYYY') IN (v_mm_year_mn1, v_mm_year_mn2)
                                                                                                    OR 
                                                                                                    TRUNC(b.eff_date) > LAST_DAY(TO_DATE (p_ext_mm|| '-'|| p_ext_year,'MM-YYYY')))))
                      OR
                      b.line_cd <> v_mn)
                      OR v_mn_24th_comp = '2' AND b.line_cd = b.line_cd))
               AND DECODE(v_start_date, NULL, SYSDATE, d.acct_ent_date) >= DECODE(v_start_date, NULL, SYSDATE, v_start_date)
               AND d.acct_ent_date <= LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'||p_ext_year,'MM-YYYY'), -12))
               AND NVL(d.delete_sw,'N') = 'N'
               AND d.tran_flag = 'P'
               /*AND d.comm_rec_id = (SELECT MAX(e.comm_rec_id)
                                      FROM GIAC_NEW_COMM_INV e
                                     WHERE TO_CHAR(e.acct_ent_date,'MM-YYYY') = v_mm_year
                                       AND NVL(e.delete_sw,'N') = 'N'
                                       AND e.tran_flag = 'P'
                                       AND e.iss_cd = d.iss_cd
                                       AND e.prem_seq_no = d.prem_seq_no)*/ -- commented by judyann 08202009; should include all modified comm records of taken-up policies
            UNION ALL   /* added by judyann 08202009; should include reversals of modified commissions */
            --SELECT stmnt for reversal of comms modified within selected month
            SELECT NVL(b.cred_branch,a.iss_cd) iss_cd,
                   b.line_cd,
                   d.intm_no,
                   ((c.commission_amt * a.currency_rt)*-1) comm_expense, b.eff_date
              FROM GIPI_INVOICE a,
                   GIPI_POLBASIC b,
                   GIAC_PREV_COMM_INV c,
                   GIAC_NEW_COMM_INV d
             WHERE a.policy_id = b.policy_id
               AND a.iss_cd = d.iss_cd
               AND a.prem_seq_no = d.prem_seq_no
               AND a.policy_id = d.policy_id
               AND c.comm_rec_id = d.comm_rec_id
               AND ((v_paramdate = 'E' AND TRUNC(b.eff_date) > LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'|| p_ext_year,'MM-YYYY'), -12))
                        /*AND TRUNC(b.eff_date) BETWEEN ADD_MONTHS(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'),-11) AND LAST_DAY(TO_DATE(v_mm_year,'MM-YYYY'))*/
                        )
                     OR
                     v_paramdate = 'A')
               AND b.iss_cd NOT IN (v_iss_cd_ri, v_iss_cd_rv)
               AND b.reg_policy_sw = 'Y'
               AND ((v_exclude_mn = 'Y' AND
                    b.line_cd <> v_mn)
                    OR
                    (v_exclude_mn = 'N' AND v_mn_24th_comp = '1' AND
                      (b.line_cd = v_mn AND
                        ((v_paramdate = 'A' AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2))
                         OR
                         (v_paramdate = 'E' /*AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2)*/ AND (TO_CHAR(b.eff_date,'MM-YYYY') IN (v_mm_year_mn1, v_mm_year_mn2)
                                                                                                    OR 
                                                                                                    TRUNC(b.eff_date) > LAST_DAY(TO_DATE (p_ext_mm|| '-'|| p_ext_year,'MM-YYYY')))))
                      OR
                      b.line_cd <> v_mn)
                      OR v_mn_24th_comp = '2' AND b.line_cd = b.line_cd))
               AND DECODE(v_start_date, NULL, SYSDATE, d.acct_ent_date) >= DECODE(v_start_date, NULL, SYSDATE, v_start_date)
               AND d.acct_ent_date <= LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'||p_ext_year,'MM-YYYY'), -12))
               AND NVL(d.delete_sw,'N') = 'N'
               AND d.tran_flag = 'P')
     GROUP BY iss_cd, line_cd, intm_no,
           DECODE(v_paramdate, 'A', p_year, 'E', --TO_NUMBER(TO_CHAR(b.eff_date,'YYYY'))) grp_year,
             DECODE(SIGN(LAST_DAY(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'))-LAST_DAY(TRUNC(eff_date))),-1,p_ext_year,TO_NUMBER(TO_CHAR(eff_date,'YYYY')))),
           DECODE(v_paramdate, 'A', p_mm, 'E', --TO_NUMBER(TO_CHAR(b.eff_date,'MM'))) grp_mm commented by alfie: 06/30/2011: to add a row for advance booking policies
             DECODE(SIGN(LAST_DAY(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'))-LAST_DAY(TRUNC(eff_date))),-1,99,TO_NUMBER(TO_CHAR(eff_date,'MM')))),
            intm_no
    )
  LOOP
    UPDATE GIAC_DEFERRED_COMM_EXPENSE_DTL comm_exp_dtl
       SET comm_exp_dtl.comm_expense = comm_exp_dtl.comm_expense + expdi.comm_expense
     WHERE comm_exp_dtl.extract_year = p_ext_year AND
           comm_exp_dtl.extract_mm   = p_ext_mm AND
           comm_exp_dtl.YEAR = expdi.grp_year AND
           comm_exp_dtl.mm = expdi.grp_mm AND
           comm_exp_dtl.iss_cd = expdi.iss_cd AND
           comm_exp_dtl.line_cd = expdi.line_cd AND
            comm_exp_dtl.intm_ri = expdi.intm_no AND
           comm_exp_dtl.procedure_id = p_method;
    IF SQL%NOTFOUND THEN
      INSERT INTO GIAC_DEFERRED_COMM_EXPENSE_DTL
        (extract_year,   extract_mm,    YEAR,                mm,            iss_cd,
         line_cd,        procedure_id,  comm_expense,        intm_ri,
         user_id,       last_update)
      VALUES
        (p_ext_year,     p_ext_mm,      expdi.grp_year,      expdi.grp_mm,  expdi.iss_cd,
         expdi.line_cd,  p_method,      expdi.comm_expense,  expdi.intm_no,
         USER,          SYSDATE);
    END IF;
  END LOOP;

  --RI extract
  FOR expri IN (
    SELECT iss_cd, line_cd,
           ri_cd,
           SUM(comm_expense) comm_expense,
           DECODE(v_paramdate, 'A', p_year, 'E', --TO_NUMBER(TO_CHAR(b.eff_date,'YYYY'))) grp_year,
             DECODE(SIGN(LAST_DAY(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'))-LAST_DAY(TRUNC(eff_date))),-1,p_ext_year,TO_NUMBER(TO_CHAR(eff_date,'YYYY')))) grp_year,
           DECODE(v_paramdate, 'A', p_mm, 'E', --TO_NUMBER(TO_CHAR(b.eff_date,'MM'))) grp_mm commented by alfie: 06/30/2011: to add a row for advance booking policies
             DECODE(SIGN(LAST_DAY(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'))-LAST_DAY(TRUNC(eff_date))),-1,99,TO_NUMBER(TO_CHAR(eff_date,'MM')))) grp_mm
      FROM (SELECT NVL(b.cred_branch,a.iss_cd) iss_cd,--SELECT stmnt for unmodified commissions
                   b.line_cd,
                      c.ri_cd,
                   /*a.ri_comm_amt
                     * DECODE(TO_CHAR(b.spld_acct_ent_date,'MM-YYYY'), v_mm_year, -1, 1)
                     * a.currency_rt comm_expense*/   -- judyann 04182008
                   a.ri_comm_amt
                     * DECODE(TO_CHAR(a.spoiled_acct_ent_date,'MM-YYYY'), v_mm_year, -1, 1)
                     * a.currency_rt comm_expense, b.eff_date
              FROM GIPI_INVOICE a,
                   GIPI_POLBASIC b,
                   GIRI_INPOLBAS c
             WHERE a.policy_id = b.policy_id
               AND b.policy_id = c.policy_id
               AND ((v_paramdate = 'E' AND TRUNC(b.eff_date) > LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'|| p_ext_year,'MM-YYYY'), -12))
                        /*AND TRUNC(b.eff_date) BETWEEN ADD_MONTHS(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'),-11) AND LAST_DAY(TO_DATE(v_mm_year,'MM-YYYY'))*/
                        )
                     OR
                     v_paramdate = 'A')
               /*AND (TO_CHAR(b.acct_ent_date,'MM-YYYY') = v_mm_year
                    OR
                    TO_CHAR(b.spld_acct_ent_date,'MM-YYYY') = v_mm_year)*/   -- judyann 04182008
               AND DECODE(v_start_date, NULL, SYSDATE, a.acct_ent_date) >= DECODE(v_start_date, NULL, SYSDATE, v_start_date)
               AND (a.acct_ent_date <= LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'||p_ext_year,'MM-YYYY'), -12))
                    OR
                    a.spoiled_acct_ent_date <= LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'||p_ext_year,'MM-YYYY'), -12)))
               AND b.iss_cd IN (v_iss_cd_ri, v_iss_cd_rv)
               AND b.reg_policy_sw = 'Y'
               AND ((v_exclude_mn = 'Y' AND
                    b.line_cd <> v_mn)
                    OR
                    (v_exclude_mn = 'N' AND v_mn_24th_comp = '1' AND
                      (b.line_cd = v_mn AND
                        ((v_paramdate = 'A' AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2))
                         OR
                         (v_paramdate = 'E' /*AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2)*/ AND (TO_CHAR(b.eff_date,'MM-YYYY') IN (v_mm_year_mn1, v_mm_year_mn2)
                                                                                                    OR 
                                                                                                    TRUNC(b.eff_date) > LAST_DAY(TO_DATE (p_ext_mm|| '-'|| p_ext_year,'MM-YYYY')))))
                      OR
                      b.line_cd <> v_mn)
                      OR v_mn_24th_comp = '2' AND b.line_cd = b.line_cd))
               AND NOT EXISTS (SELECT 'X'
                                 FROM GIAC_RI_COMM_HIST c
                                WHERE c.policy_id = b.policy_id
                                  AND c.acct_ent_date <= LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'||p_ext_year,'MM-YYYY'), -12))
                                  AND LAST_DAY(TRUNC(c.post_date)) > LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'||p_ext_year,'MM-YYYY'), -12)))
            UNION ALL
            --SELECT stmnt for comms modified in the succeeding months
            SELECT NVL(b.cred_branch,a.iss_cd) iss_cd,
                   b.line_cd,
                   d.ri_cd,
                   /*c.old_ri_comm_amt
                     * DECODE(TO_CHAR(b.spld_acct_ent_date,'MM-YYYY'), v_mm_year, -1, 1)
                     * a.currency_rt comm_expense*/
                   c.old_ri_comm_amt
                     * DECODE(TO_CHAR(a.spoiled_acct_ent_date,'MM-YYYY'), v_mm_year, -1, 1)
                     * a.currency_rt comm_expense, b.eff_date
              FROM GIPI_INVOICE a,
                   GIAC_RI_COMM_HIST c,
                   GIPI_POLBASIC b,
                   GIRI_INPOLBAS d
             WHERE a.policy_id = b.policy_id
               AND b.policy_id = c.policy_id
               AND b.policy_id = d.policy_id
               AND TO_CHAR(c.acct_ent_date,'MM-YYYY') = v_mm_year
               AND LAST_DAY(TRUNC(c.post_date)) > LAST_DAY(TO_DATE(v_mm_year, 'MM-YYYY'))
               AND ((v_paramdate = 'E' AND TRUNC(b.eff_date) > LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'|| p_ext_year,'MM-YYYY'), -12))
                            /*AND TRUNC(b.eff_date) BETWEEN ADD_MONTHS(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'),-11) AND LAST_DAY(TO_DATE(v_mm_year,'MM-YYYY'))*/
                            )
                     OR
                     v_paramdate = 'A')
               /*AND (TO_CHAR(b.acct_ent_date,'MM-YYYY') = v_mm_year
                    OR
                    TO_CHAR(b.spld_acct_ent_date,'MM-YYYY') = v_mm_year)*/   -- judyann 04182008
               AND DECODE(v_start_date, NULL, SYSDATE, c.acct_ent_date) >= DECODE(v_start_date, NULL, SYSDATE, v_start_date)
               AND (a.acct_ent_date <= LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'||p_ext_year,'MM-YYYY'), -12))
                    OR
                    a.spoiled_acct_ent_date <= LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'||p_ext_year,'MM-YYYY'), -12)))
               AND b.iss_cd IN (v_iss_cd_ri, v_iss_cd_rv)
               AND b.reg_policy_sw = 'Y'
               AND ((v_exclude_mn = 'Y' AND
                    b.line_cd <> v_mn)
                    OR
                    (v_exclude_mn = 'N' AND v_mn_24th_comp = '1' AND
                      (b.line_cd = v_mn AND
                        ((v_paramdate = 'A' AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2))
                         OR
                         (v_paramdate = 'E' /*AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2)*/ AND (TO_CHAR(b.eff_date,'MM-YYYY') IN (v_mm_year_mn1, v_mm_year_mn2)
                                                                                                    OR 
                                                                                                    TRUNC(b.eff_date) > LAST_DAY(TO_DATE (p_ext_mm|| '-'|| p_ext_year,'MM-YYYY')))))
                      OR
                      b.line_cd <> v_mn)
                      OR v_mn_24th_comp = '2' AND b.line_cd = b.line_cd))
               AND c.tran_id_rev = (SELECT MIN(tran_id_rev)
                                      FROM GIAC_RI_COMM_HIST d
                                     WHERE d.policy_id = b.policy_id
                                       AND d.acct_ent_date <= LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'||p_ext_year,'MM-YYYY'), -12))
                                       AND LAST_DAY(TRUNC(d.post_date)) > LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'||p_ext_year,'MM-YYYY'), -12)))
            UNION ALL
            --SELECT stmnt for comms modified within selected month
            SELECT NVL(b.cred_branch,a.iss_cd) iss_cd,
                   b.line_cd,
                   d.ri_cd,
                   /*c.new_ri_comm_amt
                     * DECODE(TO_CHAR(b.spld_acct_ent_date,'MM-YYYY'), v_mm_year, -1, 1)
                     * a.currency_rt comm_expense*/   -- judyann 04182008
                   c.new_ri_comm_amt
                     * DECODE(TO_CHAR(a.spoiled_acct_ent_date,'MM-YYYY'), v_mm_year, -1, 1)
                     * a.currency_rt comm_expense, b.eff_date
              FROM GIPI_INVOICE a,
                   GIAC_RI_COMM_HIST c,
                   GIPI_POLBASIC b,
                   GIRI_INPOLBAS d
             WHERE a.policy_id = b.policy_id
               AND b.policy_id = c.policy_id
               AND b.policy_id = d.policy_id
               AND DECODE(v_start_date, NULL, SYSDATE, b.acct_ent_date) >= DECODE(v_start_date, NULL, SYSDATE, v_start_date)
               AND c.post_date <= LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'||p_ext_year,'MM-YYYY'), -12))
               AND ((v_paramdate = 'E' AND TRUNC(b.eff_date) > LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'|| p_ext_year,'MM-YYYY'), -12))
                        /*AND TRUNC(b.eff_date) BETWEEN ADD_MONTHS(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'),-11) AND LAST_DAY(TO_DATE(v_mm_year,'MM-YYYY'))*/
                            )
                     OR
                     v_paramdate = 'A')
               AND b.iss_cd IN (v_iss_cd_ri, v_iss_cd_rv)
               AND b.reg_policy_sw = 'Y'
               AND ((v_exclude_mn = 'Y' AND
                    b.line_cd <> v_mn)
                    OR
                    (v_exclude_mn = 'N' AND v_mn_24th_comp = '1' AND
                      (b.line_cd = v_mn AND
                        ((v_paramdate = 'A' AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2))
                         OR
                         (v_paramdate = 'E' /*AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2)*/ AND (TO_CHAR(b.eff_date,'MM-YYYY') IN (v_mm_year_mn1, v_mm_year_mn2)
                                                                                                    OR 
                                                                                                    TRUNC(b.eff_date) > LAST_DAY(TO_DATE (p_ext_mm|| '-'|| p_ext_year,'MM-YYYY')))))
                      OR
                      b.line_cd <> v_mn)
                      OR v_mn_24th_comp = '2' AND b.line_cd = b.line_cd))
               AND c.tran_id = (SELECT MAX(tran_id)
                                  FROM GIAC_RI_COMM_HIST d
                                 WHERE d.policy_id = b.policy_id
                                   AND d.post_date <= LAST_DAY(ADD_MONTHS(TO_DATE (p_ext_mm|| '-'||p_ext_year,'MM-YYYY'), -12))))
     GROUP BY iss_cd, line_cd, ri_cd,
            DECODE(v_paramdate, 'A', p_year, 'E', --TO_NUMBER(TO_CHAR(b.eff_date,'YYYY'))) grp_year,
              DECODE(SIGN(LAST_DAY(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'))-LAST_DAY(TRUNC(eff_date))),-1,p_ext_year,TO_NUMBER(TO_CHAR(eff_date,'YYYY')))),
            DECODE(v_paramdate, 'A', p_mm, 'E', --TO_NUMBER(TO_CHAR(b.eff_date,'MM'))) grp_mm commented by alfie: 06/30/2011: to add a row for advance booking policies
              DECODE(SIGN(LAST_DAY(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'))-LAST_DAY(TRUNC(eff_date))),-1,99,TO_NUMBER(TO_CHAR(eff_date,'MM'))))
    )
  LOOP
    UPDATE GIAC_DEFERRED_COMM_EXPENSE_DTL comm_exp_dtl
       SET comm_exp_dtl.comm_expense = comm_exp_dtl.comm_expense + expri.comm_expense
     WHERE comm_exp_dtl.extract_year = p_ext_year AND
           comm_exp_dtl.extract_mm   = p_ext_mm AND
           comm_exp_dtl.YEAR = expri.grp_year AND
           comm_exp_dtl.mm = expri.grp_mm AND
           comm_exp_dtl.iss_cd = expri.iss_cd AND
           comm_exp_dtl.line_cd = expri.line_cd AND
     comm_exp_dtl.intm_ri = expri.ri_cd AND
           comm_exp_dtl.procedure_id = p_method;
    IF SQL%NOTFOUND THEN
      INSERT INTO GIAC_DEFERRED_COMM_EXPENSE_DTL
        (extract_year,   extract_mm,    YEAR,                mm,            iss_cd,
         line_cd,        procedure_id,  comm_expense,        intm_ri,
         user_id,       last_update)
      VALUES
        (p_ext_year,     p_ext_mm,      expri.grp_year,      expri.grp_mm,  expri.iss_cd,
         expri.line_cd,  p_method,      expri.comm_expense,  expri.ri_cd,
         USER,          SYSDATE);
    END IF;
  END LOOP;
  
END Deferred_Extract2_Prior_Dtl;
/


