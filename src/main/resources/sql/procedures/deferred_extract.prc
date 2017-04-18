DROP PROCEDURE CPI.DEFERRED_EXTRACT;

CREATE OR REPLACE PROCEDURE CPI.Deferred_Extract(p_year NUMBER, p_mm NUMBER, p_method NUMBER) IS  
  v_exists          NUMBER;
  v_excluded_line   VARCHAR2(4) := 'NONE';--Vincent 021705 holds value of line_cd to be excluded in select stmts
  v_user_id         VARCHAR2(8) := NVL(giis_users_pkg.app_user, USER);     --added by Gzelle 05.31.2013, replaced all USER with v_user_id
BEGIN
/* Modified by:   Vincent
** Date Modified: 013105
** Modification:  added codes for acct_trty_type to insert values
**   in tables giac_deferred_ri_prem_ceded and giac_deferred_comm_income per
**   treaty type
*/

  v_exists := 0;

  --Vincent 021705: get value of excluded line_cd
  FOR rec IN (SELECT DECODE(Giacp.v('EXCLUDE_MARINE_24TH'), 'Y', Giisp.v('LINE_CODE_MN'), 'N', 'NONE') excl_line
                FROM dual)
  LOOP
    v_excluded_line := rec.excl_line;
    EXIT;
  END LOOP;
  --

   /* Check for previous extract */
  FOR chk IN (SELECT gen_tag
                FROM GIAC_DEFERRED_EXTRACT
               WHERE YEAR = p_year
                 AND mm   = p_mm
                 AND procedure_id = p_method)
  LOOP
    /* Delete previous extract if records have been extracted before */
    DELETE FROM GIAC_DEFERRED_GROSS_PREM
     WHERE YEAR = p_year
       AND mm   = p_mm
       AND procedure_id = p_method;
    DELETE FROM GIAC_DEFERRED_RI_PREM_CEDED
     WHERE YEAR = p_year
       AND mm   = p_mm
       AND procedure_id = p_method;
    DELETE FROM GIAC_DEFERRED_COMM_INCOME
     WHERE YEAR = p_year
       AND mm   = p_mm
       AND procedure_id = p_method;
    DELETE FROM GIAC_DEFERRED_COMM_EXPENSE
     WHERE YEAR = p_year
       AND mm   = p_mm
       AND procedure_id = p_method;
    v_exists := 1;
    EXIT;
  END LOOP;

  IF v_exists = 0 THEN
    INSERT INTO GIAC_DEFERRED_EXTRACT
      (YEAR,
       mm,
       procedure_id,
       gen_tag,
       user_id,
       last_extract)
    VALUES
      (p_year,
       p_mm,
       p_method,
       'N',
       v_user_id,   
       SYSDATE);
  ELSE
    UPDATE GIAC_DEFERRED_EXTRACT
       SET gen_tag      = 'N',
           user_id      = v_user_id,    
           last_extract = SYSDATE,
           last_compute = NULL
     WHERE YEAR = p_year
       AND mm   = p_mm
       AND procedure_id = p_method;
  END IF;

  /* Extract Gross Premium *//* GROSS_PREMIUM_CURSOR */
  FOR gross IN (SELECT NVL(b.cred_branch,a.iss_cd) iss_cd,
                       b.line_cd,
                       /*SUM(DECODE(TO_CHAR(b.spld_acct_ent_date,'MM-YYYY'),LPAD(TO_CHAR(p_mm),2,'0') || '-' || TO_CHAR(p_year),
                       a.prem_amt * a.currency_rt*-1,a.prem_amt * a.currency_rt)) premium*/   -- judyann 04182008
                       SUM(DECODE(TO_CHAR(a.spoiled_acct_ent_date,'MM-YYYY'),LPAD(TO_CHAR(p_mm),2,'0') || '-' || TO_CHAR(p_year),
                       a.prem_amt * a.currency_rt*-1,a.prem_amt * a.currency_rt)) premium
                  FROM GIPI_INVOICE a,
                       GIPI_POLBASIC b
                 WHERE a.policy_id = b.policy_id
                   /*AND (TO_CHAR(b.acct_ent_date,'MM-YYYY') = LPAD(TO_CHAR(p_mm),2,'0') || '-' || TO_CHAR(p_year)
                        OR TO_CHAR(b.spld_acct_ent_date,'MM-YYYY') = LPAD(TO_CHAR(p_mm),2,'0') || '-' || TO_CHAR(p_year))*/   -- judyann 04182008
                   AND (TO_CHAR(a.acct_ent_date,'MM-YYYY') = LPAD(TO_CHAR(p_mm),2,'0') || '-' || TO_CHAR(p_year)
                        OR TO_CHAR(a.spoiled_acct_ent_date,'MM-YYYY') = LPAD(TO_CHAR(p_mm),2,'0') || '-' || TO_CHAR(p_year))
                   AND b.reg_policy_sw = 'Y'
                   AND b.line_cd <> v_excluded_line
                 GROUP BY NVL(b.cred_branch,a.iss_cd), b.line_cd)
  LOOP
    INSERT INTO GIAC_DEFERRED_GROSS_PREM
      (YEAR,
       mm,
       iss_cd,
       line_cd,
       procedure_id,
       prem_amt,
       user_id,
       last_update)
    VALUES
      (p_year,
       p_mm,
       gross.iss_cd,
       gross.line_cd,
       p_method,
       gross.premium,
       v_user_id,  
       SYSDATE);
  END LOOP;

  /* RI PREMIUMS CEDED *//* RI_PREMIUMS_CURSOR */
  FOR ri_prem1 IN (SELECT NVL(b.cred_branch,b.iss_cd) iss_cd,
                          a.line_cd,
                          SUM(NVL(a.premium_amt,0)) premium,
                          SUM(NVL(a.commission_amt,0)) commission,
                          NVL(c.acct_trty_type,0) acct_trty_type--added by Vincent 013105
                     FROM GIAC_TREATY_CESSIONS a,
                          GIPI_POLBASIC b,
                          GIIS_DIST_SHARE c--added by Vincent 013105
                    WHERE a.policy_id = b.policy_id
                      AND a.cession_year = p_year
                      AND a.cession_mm = p_mm
                      AND a.line_cd = c.line_cd--added by Vincent 013105
                      AND a.share_cd = c.share_cd--added by Vincent 013105
                      AND b.iss_cd NOT IN (SELECT param_value_v
                                             FROM GIIS_PARAMETERS
                                            WHERE param_name IN ('ISS_CD_RI','ISS_CD_RV'))
                      AND b.reg_policy_sw = 'Y'
                      AND b.line_cd <> v_excluded_line
                    GROUP BY NVL(b.cred_branch,b.iss_cd), a.line_cd,
                          c.acct_trty_type--added by Vincent 013105
                  )
  LOOP
    INSERT INTO GIAC_DEFERRED_RI_PREM_CEDED
      (YEAR,
       mm,
       iss_cd,
       line_cd,
       procedure_id,
       share_type,
       dist_prem,
       user_id,
       last_update,
       acct_trty_type)--added by Vincent 013105
    VALUES
	  (p_year,
       p_mm,
       ri_prem1.iss_cd,
       ri_prem1.line_cd,
       p_method,
       '2',
       ri_prem1.premium,
       v_user_id, 
       SYSDATE,
       ri_prem1.acct_trty_type);--added by Vincent 013105
    INSERT INTO GIAC_DEFERRED_COMM_INCOME
      (YEAR,
       mm,
       iss_cd,
       line_cd,
       procedure_id,
       share_type,
       comm_income,
       user_id,
       last_update,
       acct_trty_type)--added by Vincent 013105
    VALUES
      (p_year,
       p_mm,
       ri_prem1.iss_cd,
       ri_prem1.line_cd,
       p_method,
       '2',
       ri_prem1.commission,
       v_user_id, 
       SYSDATE,
       ri_prem1.acct_trty_type);--added by Vincent 013105
  END LOOP;

  FOR ri_prem2 IN (SELECT NVL(e.cred_branch,e.iss_cd) iss_cd,
                          a.line_cd,
                          SUM(DECODE(TO_CHAR(a.acc_rev_date,'MM-YYYY'),LPAD(TO_CHAR(p_mm),2,'0') || '-' || TO_CHAR(p_year),a.ri_prem_amt * c.currency_rt*-1,a.ri_prem_amt * c.currency_rt)) premium,
                          SUM(NVL(DECODE(TO_CHAR(a.acc_rev_date,'MM-YYYY'),LPAD(TO_CHAR(p_mm),2,'0') || '-' || TO_CHAR(p_year),a.ri_comm_amt * c.currency_rt*-1,a.ri_comm_amt * c.currency_rt),0)) commission --Vincent 072905: added nvl
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
                      AND e.iss_cd NOT IN (SELECT param_value_v
                                             FROM GIIS_PARAMETERS
                                            WHERE param_name IN ('ISS_CD_RI','ISS_CD_RV'))
                      AND (TO_CHAR(a.acc_ent_date,'MM-YYYY') = LPAD(TO_CHAR(p_mm),2,'0') || '-' || TO_CHAR(p_year)
                           OR TO_CHAR(a.acc_rev_date,'MM-YYYY') = LPAD(TO_CHAR(p_mm),2,'0') || '-' || TO_CHAR(p_year))
                      AND e.reg_policy_sw = 'Y'
                      AND e.line_cd <> v_excluded_line
                    GROUP BY NVL(e.cred_branch,e.iss_cd), a.line_cd)
  LOOP
    INSERT INTO GIAC_DEFERRED_RI_PREM_CEDED
      (YEAR,
       mm,
       iss_cd,
       line_cd,
       procedure_id,
       share_type,
       dist_prem,
       user_id,
       last_update)
    VALUES
      (p_year,
       p_mm,
       ri_prem2.iss_cd,
       ri_prem2.line_cd,
       p_method,
       '3',
       ri_prem2.premium,
       v_user_id, 
       SYSDATE);
    INSERT INTO GIAC_DEFERRED_COMM_INCOME
      (YEAR,
       mm,
       iss_cd,
       line_cd,
       procedure_id,
       share_type,
       comm_income,
       user_id,
       last_update)
    VALUES
      (p_year,
       p_mm,
       ri_prem2.iss_cd,
       ri_prem2.line_cd,
       p_method,
       '3',
       ri_prem2.commission,
       v_user_id,   
       SYSDATE);
  END LOOP;

  /* RI Premium Retroceded *//* RETRO_PREMIUMS_CURSOR */
  FOR retro1 IN (SELECT NVL(b.cred_branch,b.iss_cd) iss_cd,
                        a.line_cd,
                        SUM(NVL(a.premium_amt,0)) premium,
                        SUM(NVL(a.commission_amt,0)) commission,
                        NVL(acct_trty_type, 0) acct_trty_type--added by Vincent 013105
                   FROM GIAC_TREATY_CESSIONS a,
                        GIPI_POLBASIC b,
                        GIIS_DIST_SHARE c--added by Vincent 013105
                  WHERE a.policy_id = b.policy_id
                    AND a.cession_year = p_year
                    AND a.cession_mm = p_mm
                    AND a.line_cd = c.line_cd--added by Vincent 013105
                    AND a.share_cd = c.share_cd--added by Vincent 013105
                    AND b.iss_cd IN (SELECT param_value_v
                                       FROM GIIS_PARAMETERS
                                      WHERE param_name IN ('ISS_CD_RI','ISS_CD_RV'))
                    AND b.reg_policy_sw = 'Y'
                    AND b.line_cd <> v_excluded_line
                  GROUP BY NVL(b.cred_branch,b.iss_cd), a.line_cd,
                        c.acct_trty_type--added by Vincent 013105
                )
  LOOP
    INSERT INTO GIAC_DEFERRED_RI_PREM_CEDED
      (YEAR,
       mm,
       iss_cd,
       line_cd,
       procedure_id,
       share_type,
       dist_prem,
       user_id,
       last_update,
       acct_trty_type)
    VALUES
      (p_year,
       p_mm,
       retro1.iss_cd,
       retro1.line_cd,
       p_method,
       '2',
       retro1.premium,
       v_user_id,  
       SYSDATE,
       retro1.acct_trty_type);
    INSERT INTO GIAC_DEFERRED_COMM_INCOME
      (YEAR,
       mm,
       iss_cd,
       line_cd,
       procedure_id,
       share_type,
       comm_income,
       user_id,
       last_update,
       acct_trty_type)
    VALUES
      (p_year,
       p_mm,
       retro1.iss_cd,
       retro1.line_cd,
       p_method,
       '2',
       retro1.commission,
       v_user_id,  
       SYSDATE,
       retro1.acct_trty_type);
  END LOOP;

  FOR retro2 IN (SELECT NVL(e.cred_branch,e.iss_cd) iss_cd,
                        a.line_cd,
                        SUM(DECODE(TO_CHAR(a.acc_rev_date,'MM-YYYY'),LPAD(TO_CHAR(p_mm),2,'0') || '-' || TO_CHAR(p_year),a.ri_prem_amt * c.currency_rt*-1,a.ri_prem_amt * c.currency_rt)) premium,
                        SUM(NVL(DECODE(TO_CHAR(a.acc_rev_date,'MM-YYYY'),LPAD(TO_CHAR(p_mm),2,'0') || '-' || TO_CHAR(p_year),a.ri_comm_amt * c.currency_rt*-1,a.ri_comm_amt * c.currency_rt),0)) commission --Vincent 072905: added nvl
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
                    AND e.iss_cd IN (SELECT param_value_v
                                       FROM GIIS_PARAMETERS
                                      WHERE param_name IN ('ISS_CD_RI','ISS_CD_RV'))
                    AND (TO_CHAR(a.acc_ent_date,'MM-YYYY') = LPAD(TO_CHAR(p_mm),2,'0') || '-' || TO_CHAR(p_year)
                         OR TO_CHAR(a.acc_rev_date,'MM-YYYY') = LPAD(TO_CHAR(p_mm),2,'0') || '-' || TO_CHAR(p_year))
                    AND e.reg_policy_sw = 'Y'
                    AND e.line_cd <> v_excluded_line
                  GROUP BY NVL(e.cred_branch,e.iss_cd), a.line_cd)
  LOOP
    INSERT INTO GIAC_DEFERRED_RI_PREM_CEDED
      (YEAR,
       mm,
       iss_cd,
       line_cd,
       procedure_id,
       share_type,
       dist_prem,
       user_id,
       last_update)
    VALUES
      (p_year,
       p_mm,
       retro2.iss_cd,
       retro2.line_cd,
       p_method,
       '3',
       retro2.premium,
       v_user_id, 
       SYSDATE);
    INSERT INTO GIAC_DEFERRED_COMM_INCOME
      (YEAR,
       mm,
       iss_cd,
       line_cd,
       procedure_id,
       share_type,
       comm_income,
       user_id,
       last_update)
    VALUES
      (p_year,
       p_mm,
       retro2.iss_cd,
       retro2.line_cd,
       p_method,
       '3',
       retro2.commission,
       v_user_id,   
       SYSDATE);
  END LOOP;

  /* COMMISSION EXPENSE */
  /* Direct extract         *//* DIRECT_COMM_EXPENSE_CURSOR */
/*   FOR expdi IN (SELECT nvl(b.cred_branch,a.iss_cd) iss_cd,
                        b.line_cd,
                      --  sum(decode(to_char(b.spld_acct_ent_date,'MM-YYYY'),lpad(to_char(p_mm),2,'0') || '-' || to_char(p_year),d.commission_amt * a.currency_rt*-1,d.commission_amt * a.currency_rt)) comm_expense   -- judyann 04182008
                        SUM(DECODE(TO_CHAR(a.spoiled_acct_ent_date,'MM-YYYY'),LPAD(TO_CHAR(p_mm),2,'0') || '-' || TO_CHAR(p_year),d.commission_amt * a.currency_rt*-1,d.commission_amt * a.currency_rt)) comm_expense
                   FROM GIPI_INVOICE a,
                        GIPI_POLBASIC b,
                        GIPI_COMM_INVOICE d
                  WHERE a.policy_id = b.policy_id
                    AND a.iss_cd = d.iss_cd
                    AND a.prem_seq_no = d.prem_seq_no
                    AND a.policy_id = d.policy_id
                    AND a.iss_cd NOT IN (SELECT param_value_v
                                           FROM GIIS_PARAMETERS
                                          WHERE param_name IN ('ISS_CD_RI','ISS_CD_RV'))
                    --AND (to_char(b.acct_ent_date,'MM-YYYY') = lpad(to_char(p_mm),2,'0') || '-' || to_char(p_year)
                    -- OR to_char(b.spld_acct_ent_date,'MM-YYYY') = lpad(to_char(p_mm),2,'0') || '-' || to_char(p_year))
                    AND (TO_CHAR(a.acct_ent_date,'MM-YYYY') = LPAD(TO_CHAR(p_mm),2,'0') || '-' || TO_CHAR(p_year)
                     OR TO_CHAR(a.spoiled_acct_ent_date,'MM-YYYY') = LPAD(TO_CHAR(p_mm),2,'0') || '-' || TO_CHAR(p_year))
					AND b.reg_policy_sw = 'Y'
					AND b.line_cd <> v_excluded_line
                  GROUP BY NVL(b.cred_branch,a.iss_cd), b.line_cd)*/--Vincent 081805: replaced by the SELECT stmt below

  --Vincent 081805: The following SELECT stmt checks if there are bills that were modified and returns the correct commission_amt to be used.
  --It also includes bills which were modified and has the same acct_ent_date in giac_new_comm_inv as the parameter date
  FOR expdi IN (SELECT iss_cd, line_cd, SUM(comm_expense) comm_expense
                  FROM (SELECT NVL(b.cred_branch,a.iss_cd) iss_cd,
                               b.line_cd,
                               NVL((SELECT e.commission_amt --this SELECT stmt returns the correct commission_amt to be used
                                      FROM GIAC_PREV_COMM_INV e, GIAC_NEW_COMM_INV f
                                     WHERE e.fund_cd = f.fund_cd
                                       AND e.branch_cd = f.branch_cd
                                       AND e.comm_rec_id = f.comm_rec_id
                                       AND e.intm_no = f.intm_no
                                       AND f.acct_ent_date > TO_DATE(LPAD(TO_CHAR(p_mm),2,'0') || '-' || TO_CHAR(p_year), 'MM-RRRR')
                                       AND e.acct_ent_date = LAST_DAY(TO_DATE(LPAD(TO_CHAR(p_mm),2,'0') || '-' || TO_CHAR(p_year), 'MM-RRRR'))
                                       AND f.iss_cd = d.iss_Cd
                                       AND f.prem_seq_no = d.prem_seq_no
                                       AND e.comm_rec_id = (SELECT MIN(g.comm_rec_id)
                                                              FROM GIAC_PREV_COMM_INV g, GIAC_NEW_COMM_INV h
                                                             WHERE g.fund_cd = h.fund_cd
                                                               AND g.branch_cd = h.branch_cd
                                                               AND g.comm_rec_id = h.comm_rec_id
                                                               AND g.intm_no = h.intm_no
                                                               AND h.acct_ent_date > TO_DATE(LPAD(TO_CHAR(p_mm),2,'0') || '-' || TO_CHAR(p_year), 'MM-RRRR')
                                                               AND g.acct_ent_date = LAST_DAY(TO_DATE(LPAD(TO_CHAR(p_mm),2,'0') || '-' || TO_CHAR(p_year), 'MM-RRRR'))
                                                               AND h.iss_cd = d.iss_Cd
                                                               AND h.prem_seq_no = d.prem_seq_no)),d.commission_amt)
                               --* DECODE(TO_CHAR(b.spld_acct_ent_date,'MM-YYYY'), LPAD(TO_CHAR(p_mm),2,'0') || '-' || TO_CHAR(p_year),-1,1)  -- judyann 04182008
                               * DECODE(TO_CHAR(a.spoiled_acct_ent_date,'MM-YYYY'), LPAD(TO_CHAR(p_mm),2,'0') || '-' || TO_CHAR(p_year),-1,1)
                               * a.currency_rt comm_expense
                          FROM GIPI_INVOICE a,
                               GIPI_POLBASIC b,
                               GIPI_COMM_INVOICE d
                         WHERE a.policy_id = b.policy_id
                           AND a.iss_cd = d.iss_cd
                           AND a.prem_seq_no = d.prem_seq_no
                           AND a.policy_id = d.policy_id
                           AND a.iss_cd NOT IN (SELECT param_value_v
                                                  FROM GIIS_PARAMETERS
                                                 WHERE param_name IN ('ISS_CD_RI','ISS_CD_RV'))
                           /*AND (TO_CHAR(b.acct_ent_date,'MM-YYYY') = LPAD(TO_CHAR(p_mm),2,'0') || '-' || TO_CHAR(p_year)
                                OR TO_CHAR(b.spld_acct_ent_date,'MM-YYYY') = LPAD(TO_CHAR(p_mm),2,'0') || '-' || TO_CHAR(p_year))*/   -- judyann 04182008
                           AND (TO_CHAR(a.acct_ent_date,'MM-YYYY') = LPAD(TO_CHAR(p_mm),2,'0') || '-' || TO_CHAR(p_year)
                                OR TO_CHAR(a.spoiled_acct_ent_date,'MM-YYYY') = LPAD(TO_CHAR(p_mm),2,'0') || '-' || TO_CHAR(p_year))
                           AND b.reg_policy_sw = 'Y'
                           AND b.line_cd <> v_excluded_line
                        UNION ALL
                        SELECT NVL(b.cred_branch,a.iss_cd) iss_cd,
                               b.line_cd,
                               d.commission_amt comm_expense
                          FROM GIPI_INVOICE a,
                               GIPI_POLBASIC b,
                               GIAC_NEW_COMM_INV d
                         WHERE a.policy_id = b.policy_id
                           AND a.iss_cd = d.iss_cd
                           AND a.prem_seq_no = d.prem_seq_no
                           AND a.policy_id = d.policy_id
                           AND a.iss_cd NOT IN (SELECT param_value_v
                                                  FROM GIIS_PARAMETERS
                                                 WHERE param_name IN ('ISS_CD_RI','ISS_CD_RV'))
                           AND b.reg_policy_sw = 'Y'
                           AND b.line_cd <> v_excluded_line
                           AND TO_CHAR(d.acct_ent_date,'MM-YYYY') = LPAD(TO_CHAR(p_mm),2,'0') || '-' || TO_CHAR(p_year)
                           AND NVL(d.delete_sw,'N') = 'N'
                           AND d.tran_flag = 'P')
                         GROUP BY iss_cd, line_cd)
  LOOP
    INSERT INTO GIAC_DEFERRED_COMM_EXPENSE
      (YEAR,
       mm,
       iss_cd,
       line_cd,
       procedure_id,
       comm_expense,
       user_id,
       last_update)
    VALUES (p_year,
            p_mm,
            expdi.iss_cd,
            expdi.line_cd,
            p_method,
            expdi.comm_expense,
            v_user_id,  
            SYSDATE);
  END LOOP;

  /* RI extract         *//* RI_COMM_EXPENSE_CURSOR */
  FOR expri IN (SELECT NVL(b.cred_branch,a.iss_cd) iss_cd,
                       b.line_cd,
                       /*SUM(NVL(DECODE(TO_CHAR(b.spld_acct_ent_date,'MM-YYYY'),LPAD(TO_CHAR(p_mm),2,'0') || '-' || TO_CHAR(p_year),a.ri_comm_amt * a.currency_rt*-1,a.ri_comm_amt * a.currency_rt),0)) comm_expense*/ --Vincent 072905: added nvl   -- judyann 04182008
                       SUM(NVL(DECODE(TO_CHAR(a.spoiled_acct_ent_date,'MM-YYYY'),LPAD(TO_CHAR(p_mm),2,'0') || '-' || TO_CHAR(p_year),a.ri_comm_amt * a.currency_rt*-1,a.ri_comm_amt * a.currency_rt),0)) comm_expense
                  FROM GIPI_INVOICE a,
                       GIPI_POLBASIC b
                 WHERE a.policy_id = b.policy_id
                   AND a.iss_cd IN (SELECT param_value_v
                                      FROM GIIS_PARAMETERS
                                     WHERE param_name IN ('ISS_CD_RI','ISS_CD_RV'))
                   /*AND (TO_CHAR(b.acct_ent_date,'MM-YYYY') = LPAD(TO_CHAR(p_mm),2,'0') || '-' || TO_CHAR(p_year)
                        OR TO_CHAR(b.spld_acct_ent_date,'MM-YYYY') = LPAD(TO_CHAR(p_mm),2,'0') || '-' || TO_CHAR(p_year))*/
                   AND (TO_CHAR(a.acct_ent_date,'MM-YYYY') = LPAD(TO_CHAR(p_mm),2,'0') || '-' || TO_CHAR(p_year)
                        OR TO_CHAR(a.spoiled_acct_ent_date,'MM-YYYY') = LPAD(TO_CHAR(p_mm),2,'0') || '-' || TO_CHAR(p_year))
                   AND b.reg_policy_sw = 'Y'
                   AND b.line_cd <> v_excluded_line
                 GROUP BY NVL(b.cred_branch,a.iss_cd), b.line_cd)
  LOOP
    INSERT INTO GIAC_DEFERRED_COMM_EXPENSE
      (YEAR,
       mm,
       iss_cd,
       line_cd,
       procedure_id,
       comm_expense,
       user_id,
       last_update)
    VALUES
      (p_year,
       p_mm,
       expri.iss_cd,
       expri.line_cd,
       p_method,
       expri.comm_expense,
       v_user_id,   
       SYSDATE);
  END LOOP;

  COMMIT;

END Deferred_Extract;
/


