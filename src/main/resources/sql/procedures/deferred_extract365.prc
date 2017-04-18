DROP PROCEDURE CPI.DEFERRED_EXTRACT365;

CREATE OR REPLACE PROCEDURE CPI.deferred_extract365 (
   p_year     NUMBER,
   p_mm       NUMBER,
   p_method   NUMBER
)
IS
   v_exists           NUMBER;
   v_month            NUMBER;
   --v_def_comm_entry   VARCHAR2 (1) := giacp.v ('DEF_COMM_PROD_ENTRY');
   v_start_date       DATE := TO_DATE (giacp.v ('24TH_METHOD_START_DATE'), 'MM-YYYY'); 
   v_year             NUMBER;
   
   invalid_month      EXCEPTION;
   PRAGMA EXCEPTION_INIT (invalid_month, -1843);
   
   --mikel 02.06.2013
   v_start_yr         NUMBER := SUBSTR (giacp.v ('24TH_METHOD_START_DATE'), 4, 4);
   v_start_mm         NUMBER := SUBSTR (giacp.v ('24TH_METHOD_START_DATE'), 1, 2);
   v_tot_months       NUMBER;
   
/*
** Created by:   Mikel
** Date Created: 08.28.2012
** Description:  Extracts detailed data required for the daily computation of 1/365 Method
*/
BEGIN
   v_exists := 0;
   
   /* Check for previous extract */
   FOR chk IN (SELECT gen_tag
                 FROM giac_deferred_extract
                WHERE YEAR = p_year AND mm = p_mm AND procedure_id = p_method)
   LOOP
   
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
           
      /* Delete previous extract if records have been extracted before */
      DELETE FROM giac_deferred_gross_prem_pol
            WHERE extract_year = p_year 
              AND extract_mm = p_mm
              AND procedure_id = p_method;
              
      DELETE FROM giac_deferred_ri_prem_cede_pol
            WHERE extract_year = p_year 
              AND extract_mm = p_mm
              AND procedure_id = p_method;        
      
      DELETE FROM giac_deferred_comm_income_pol
            WHERE extract_year = p_year 
              AND extract_mm = p_mm
              AND procedure_id = p_method; 
              
      DELETE FROM giac_deferred_comm_expense_pol
            WHERE extract_year = p_year 
              AND extract_mm = p_mm
              AND procedure_id = p_method; 
                    
      v_exists := 1;
      EXIT;
   END LOOP;

   IF v_exists = 0
   THEN
      INSERT INTO giac_deferred_extract
                  (YEAR, mm, procedure_id, gen_tag, user_id, last_extract)
           VALUES (p_year, p_mm, p_method, 'N', USER, SYSDATE);
   ELSE
      UPDATE giac_deferred_extract
         SET gen_tag = 'N',
             user_id = USER,
             last_extract = SYSDATE,
             last_compute = NULL
       WHERE YEAR = p_year AND mm = p_mm AND procedure_id = p_method;
   END IF;

      /*BEGIN
         v_month := SUBSTR (TO_CHAR (ADD_MONTHS (TO_DATE (p_mm || '-' || p_year, 'MM-YYYY'), -12), 'mm-yyyy'), 1, 2);
         v_year := SUBSTR (TO_CHAR (ADD_MONTHS (TO_DATE (p_mm || '-' || p_year, 'MM-YYYY'), -12), 'mm-yyyy'), 4, 4);
         FOR rec IN 1 .. 13
         LOOP
            IF v_month = 13 THEN
               v_month := 1;
               v_year := v_year + 1;
            END IF;

            IF v_start_date <= LAST_DAY (TO_DATE (v_month || '-' || (v_year), 'MM-YYYY'))
            THEN
               IF v_month > p_mm AND v_year = p_year THEN
                  EXIT;
               ELSIF v_year > p_year THEN
                  EXIT;
               ELSE
             
                  deferred_extract365_dtl (p_year, p_mm, v_year, v_month, p_method);
                  
               END IF;
            END IF;
                v_month := v_month + 1;
         END LOOP;
      END;*/ 
      -- mikel 02.06.2013; to extract policies with more than 1 year term. 
      BEGIN
        /*IF p_year = v_start_yr THEN
             v_tot_months := (p_mm - v_start_mm) + 1;
        ELSE
            v_tot_months := ((p_year - v_start_yr) * 12) + p_mm;
        END IF;*/
        
        v_tot_months := MONTHS_BETWEEN (LAST_DAY (TO_DATE (p_mm || '-' || p_year, 'MM-YYYY')),
                        LAST_DAY (v_start_date))  + 1;
                        
        v_month := v_start_mm;
        v_year  := v_start_yr;
        
        FOR rec IN 1 .. v_tot_months
        LOOP
           IF v_month = 13 THEN
               v_month := 1;
               v_year := v_year + 1;
           END IF;
           deferred_extract365_dtl (p_year, p_mm, v_year, v_month, p_method);
           v_month := v_month + 1;
        END LOOP;    
      END;  
   
  --to extract policies from prior acct ent date 
  IF Giacp.v('24TH_METHOD_PARAMDATE') = 'E' THEN
      IF v_start_date <= LAST_DAY(TO_DATE(p_mm||'-'||(p_year),'MM-YYYY')) THEN
        deferred_extract365_prior_dtl(p_year,p_mm, p_year, 99, p_method);
      END IF;
  END IF;
   
   /* insert records in detail tables to the main tables */
  FOR gross IN (SELECT iss_cd,
                       line_cd,
                       SUM(prem_amt) prem_amt
                  FROM giac_deferred_gross_prem_pol
                 WHERE extract_year = p_year
                   AND extract_mm   = p_mm
                   AND procedure_id = p_method
     GROUP BY iss_cd, line_cd)
  LOOP
    INSERT INTO giac_deferred_gross_prem
                (YEAR, mm, iss_cd, line_cd, procedure_id,
                 prem_amt, user_id, last_update
                )
         VALUES (p_year, p_mm, gross.iss_cd, gross.line_cd, p_method,
                 gross.prem_amt, USER, SYSDATE
                );
  END LOOP;
  
  FOR ri_prem IN 
    (SELECT   iss_cd, line_cd, share_type, acct_trty_type,
              SUM (dist_prem) dist_prem
         FROM giac_deferred_ri_prem_cede_pol
        WHERE extract_year = p_year
          AND extract_mm = p_mm
          AND procedure_id = p_method
     GROUP BY iss_cd, line_cd, share_type, acct_trty_type)
  LOOP
    
    INSERT INTO giac_deferred_ri_prem_ceded
                (YEAR, mm, iss_cd, line_cd, procedure_id,
                 share_type, acct_trty_type, dist_prem,
                 user_id, last_update
                )
         VALUES (p_year, p_mm, ri_prem.iss_cd, ri_prem.line_cd, p_method,
                 ri_prem.share_type, ri_prem.acct_trty_type, ri_prem.dist_prem,
                 USER, SYSDATE
                );
  END LOOP;
  
  FOR comm IN 
    (SELECT   iss_cd, line_cd, share_type, acct_trty_type, ri_cd,
              SUM (comm_income) comm_income
         FROM giac_deferred_comm_income_pol
        WHERE extract_year = p_year
          AND extract_mm = p_mm
          AND procedure_id = p_method
     GROUP BY iss_cd, line_cd, share_type, acct_trty_type, ri_cd)
  LOOP
    INSERT INTO giac_deferred_comm_income
                (YEAR, mm, iss_cd, line_cd, procedure_id,
                 share_type, acct_trty_type, ri_cd,
                 comm_income, user_id, last_update
                )
         VALUES (p_year, p_mm, comm.iss_cd, comm.line_cd, p_method,
                 comm.share_type, comm.acct_trty_type, comm.ri_cd,
                 comm.comm_income, USER, SYSDATE
                );
  END LOOP;

  FOR expen IN 
    (SELECT   iss_cd, line_cd, intm_ri, SUM (comm_expense) comm_expense
         FROM giac_deferred_comm_expense_pol
        WHERE extract_year = p_year
          AND extract_mm = p_mm
          AND procedure_id = p_method
     GROUP BY iss_cd, line_cd, intm_ri)
  LOOP
    INSERT INTO giac_deferred_comm_expense
                (YEAR, mm, iss_cd, line_cd, intm_ri,
                 procedure_id, comm_expense, user_id, last_update
                )
         VALUES (p_year, p_mm, expen.iss_cd, expen.line_cd, expen.intm_ri,
                 p_method, expen.comm_expense, USER, SYSDATE
                );
  END LOOP;
  
END deferred_extract365;
/


