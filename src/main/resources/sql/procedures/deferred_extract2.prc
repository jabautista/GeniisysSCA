DROP PROCEDURE CPI.DEFERRED_EXTRACT2;

CREATE OR REPLACE PROCEDURE CPI.Deferred_Extract2(p_year NUMBER, p_mm NUMBER, p_method NUMBER) IS
  v_exists   NUMBER;
  v_month    NUMBER;
  v_def_comm_entry   VARCHAR2(1) := Giacp.v('DEF_COMM_PROD_ENTRY'); -- an identifier to know what factors will be used for the monthly computation,
                                                                    -- of commission income and commission expense, if Y, then factors which have Y def_tag
                                                                    -- otherwise, factors that do not have def_tag
                                                                    -- : alfie
                                                                    
  v_start_date       DATE := TO_DATE(Giacp.v('24TH_METHOD_START_DATE'),'MM-YYYY');
  v_year    NUMBER; --mikel 02.15.2012
/*
** Created by:   Vincent
** Date Created: 062205
** Description:  Extracts data required for the monthly computation of 24th Method
*/

/* Modified by:    Alfie
** Date Modified:  06082010
** Description:    Handles the additional factors for monthly computation of 24th Method, additional factors spans up to 13 months
*/
BEGIN
  v_exists := 0;

  /* Check for previous extract */
  FOR chk IN (SELECT gen_tag
                FROM GIAC_DEFERRED_EXTRACT
               WHERE YEAR = p_year
                 AND mm   = p_mm
                 AND procedure_id = p_method)
  LOOP
    /* Delete previous extract if records have been extracted before */
 --delete records from main tables
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
 --delete records from detail tables
    DELETE FROM GIAC_DEFERRED_GROSS_PREM_DTL
     WHERE extract_year = p_year
       AND extract_mm   = p_mm
       AND procedure_id = p_method;
    DELETE FROM GIAC_DEFERRED_RI_PREM_CEDE_DTL
     WHERE extract_year = p_year
       AND extract_mm   = p_mm
       AND procedure_id = p_method;
    DELETE FROM GIAC_DEFERRED_COMM_INCOME_DTL
     WHERE extract_year = p_year
       AND extract_mm   = p_mm
       AND procedure_id = p_method;
    DELETE FROM GIAC_DEFERRED_COMM_EXPENSE_DTL
     WHERE extract_year = p_year
       AND extract_mm   = p_mm
       AND procedure_id = p_method;
    v_exists := 1;
    EXIT;
  END LOOP;

  IF v_exists = 0 THEN
    INSERT INTO GIAC_DEFERRED_EXTRACT
      (YEAR,    mm,      procedure_id,
    gen_tag, user_id, last_extract)
    VALUES
   (p_year,  p_mm,    p_method,
    'N',     USER,    SYSDATE);
  ELSE
    UPDATE GIAC_DEFERRED_EXTRACT
       SET gen_tag      = 'N',
           user_id      = USER,
           last_extract = SYSDATE,
           last_compute = NULL
     WHERE YEAR = p_year
       AND mm   = p_mm
       AND procedure_id = p_method;
  END IF;

  --extract records for the previous months which fall on the previous year
  --modified by mikel 02.15.2012; no records will be extracted if the param date was fall on DECEMBER
  IF NVL(v_def_comm_entry,'N') != 'Y' THEN --added condition: alfie
    v_month := p_mm + 1;
    /* added by mikel 02.15.2012 */
    v_year  := p_year - 1; 
      IF v_month = 13 THEN
            v_month := 1;
            v_year  := p_year;
      END IF;   
    -- end mikel 02.15.2012         
    FOR rec IN 1..ABS(p_mm - 12)
    LOOP
--      IF v_start_date <= LAST_DAY(TO_DATE(v_month||'-'||(p_year-1),'MM-YYYY')) THEN
      /*IF v_start_date <= LAST_DAY(TO_DATE(v_month||'-'||(v_year),'MM-YYYY')) THEN --mikel 02.15.2012
--        Deferred_Extract2_Dtl(p_year, p_mm, (p_year-1), v_month, p_method);
        Deferred_Extract2_Dtl(p_year, p_mm, (v_year), v_month, p_method); --mikel 02.15.2012
        --v_month := v_month + 1;
      END IF;*/         --commented out by albert 09032013
      Deferred_Extract2_Dtl(p_year, p_mm, (v_year), v_month, p_method);
      v_month := v_month + 1; --mikel 12.11.2012
    END LOOP;
  ELSE
    v_month := p_mm;
    FOR rec IN 1..ABS(p_mm - 13)
    LOOP
      /*IF v_start_date <= LAST_DAY(TO_DATE(v_month||'-'||(p_year-1),'MM-YYYY')) THEN
        Deferred_Extract2_Dtl(p_year, p_mm, (p_year-1), v_month, p_method);
        --v_month := v_month + 1;
      END IF;*/         --commented out by albert 09032013
      Deferred_Extract2_Dtl(p_year, p_mm, (p_year-1), v_month, p_method);
      v_month := v_month + 1; --mikel 12.11.2012
    END LOOP;
  END IF;

  --extract records for the months which fall on the current extract year
  v_month := 1;
  FOR rec IN 1..p_mm
  LOOP
    IF v_start_date <= LAST_DAY(TO_DATE(v_month||'-'||(p_year),'MM-YYYY')) THEN
      Deferred_Extract2_Dtl(p_year, p_mm, p_year, v_month, p_method);
      --v_month := v_month + 1;
    END IF;
   v_month := v_month + 1; --mikel 12.11.2012
  END LOOP;
  
  --Added by alfie, to extract policies from prior acct ent date
  v_month := p_mm; -- added by mikel 02.15.2012; extract records based on param month date. 
  
  /*IF Giacp.v('24TH_METHOD_PARAMDATE') = 'E' THEN
  IF v_start_date <= LAST_DAY(TO_DATE(v_month||'-'||(p_year),'MM-YYYY')) THEN
    Deferred_Extract2_Prior_Dtl(p_year,p_mm, p_year, 99, p_method);
  END IF;
  END IF;*/

  /* insert records in detail tables to the main tables */
  FOR gross IN (SELECT iss_cd,
                       line_cd,
                       SUM(prem_amt) prem_amt
                  FROM GIAC_DEFERRED_GROSS_PREM_DTL
                 WHERE extract_year = p_year
                   AND extract_mm   = p_mm
                   AND procedure_id = p_method
     GROUP BY iss_cd, line_cd)
  LOOP
    INSERT INTO GIAC_DEFERRED_GROSS_PREM
      (YEAR,         mm,             iss_cd,       line_cd,
       procedure_id, prem_amt,       user_id,      last_update)
    VALUES
   (p_year,       p_mm,           gross.iss_cd, gross.line_cd,
       p_method,     gross.prem_amt, USER,         SYSDATE);
  END LOOP;

  FOR ri_prem IN (SELECT iss_cd,
                         line_cd,
       share_type,
       acct_trty_type,
                         SUM(dist_prem) dist_prem
                    FROM GIAC_DEFERRED_RI_PREM_CEDE_DTL
                   WHERE extract_year = p_year
                     AND extract_mm   = p_mm
                     AND procedure_id = p_method
       GROUP BY iss_cd, line_cd, share_type, acct_trty_type)
  LOOP
    INSERT INTO GIAC_DEFERRED_RI_PREM_CEDED
      (YEAR,          mm,                  iss_cd,                  line_cd,
    procedure_id,  share_type,          acct_trty_type,          dist_prem,
    user_id,       last_update)
    VALUES
   (p_year,        p_mm,                ri_prem.iss_cd,          ri_prem.line_cd,
       p_method,      ri_prem.share_type,  ri_prem.acct_trty_type,  ri_prem.dist_prem,
    USER,          SYSDATE);
  END LOOP;

  FOR comm IN (SELECT iss_cd,
                      line_cd,
                      share_type,
       acct_trty_type,
       ri_cd,
                      SUM(comm_income) comm_income
                 FROM GIAC_DEFERRED_COMM_INCOME_DTL
                WHERE extract_year = p_year
                  AND extract_mm   = p_mm
                  AND procedure_id = p_method
       GROUP BY iss_cd, line_cd, share_type, acct_trty_type, ri_cd)
  LOOP
    INSERT INTO GIAC_DEFERRED_COMM_INCOME
      (YEAR,          mm,                  iss_cd,                  line_cd,
    procedure_id,  share_type,          acct_trty_type,          ri_cd,
    comm_income,
    user_id,       last_update)
    VALUES
   (p_year,        p_mm,                comm.iss_cd,             comm.line_cd,
       p_method,      comm.share_type,     comm.acct_trty_type,     comm.ri_cd,
    comm.comm_income,
    USER,          SYSDATE);
  END LOOP;

  FOR expen IN (SELECT iss_cd,
                       line_cd,
        intm_ri,
                       SUM(comm_expense) comm_expense
                  FROM GIAC_DEFERRED_COMM_EXPENSE_DTL
                 WHERE extract_year = p_year
                   AND extract_mm   = p_mm
                   AND procedure_id = p_method
     GROUP BY iss_cd, line_cd, intm_ri)
  LOOP
    INSERT INTO GIAC_DEFERRED_COMM_EXPENSE
      (YEAR,          mm,                  iss_cd,        line_cd,
    intm_ri,
       procedure_id,  comm_expense,        user_id,       last_update)
    VALUES
   (p_year,        p_mm,                expen.iss_cd,  expen.line_cd,
       expen.intm_ri,
    p_method,      expen.comm_expense,  USER,          SYSDATE);
  END LOOP;

  COMMIT;
END Deferred_Extract2;
/


