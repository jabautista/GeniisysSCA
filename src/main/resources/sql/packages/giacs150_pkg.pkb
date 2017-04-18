CREATE OR REPLACE PACKAGE BODY CPI.GIACS150_PKG
AS
   PROCEDURE age_bills(
      p_cut_off         IN VARCHAR2,
      p_direct          IN VARCHAR2,
      p_reinsurance     IN VARCHAR2,
      p_user_id         IN GIIS_USERS.user_id%TYPE
   ) AS
      v_cut_off         DATE;
   BEGIN
      v_cut_off := TO_DATE(p_cut_off, 'mm-dd-yyyy');
   
      IF p_direct = 'Y' THEN
         --age_bills_direct(v_cut_off); --marco - 09.02.2014 - replaced 
         --age_bills_fc(v_cut_off);
         GIACS150_PKG.age_bills(v_cut_off, p_user_id);
      END IF;

      IF p_reinsurance = 'Y' THEN
         --age_bills_reinsurance(v_cut_off); --marco - 09.02.2014 - replaced
         GIACS150_PKG.age_bills_ri(v_cut_off, p_user_id);
      END IF;
   END age_bills;
   
   PROCEDURE age_bills_direct(
      p_cut_off         IN DATE
   ) AS
      counter           NUMBER := 0; 
      v_aging_id        giac_aging_parameters.aging_id%TYPE;
      v_over_due_tag    giac_aging_parameters.over_due_tag%TYPE;
      p_overdue         giac_aging_parameters.over_due_tag%TYPE := 'Y';
      p_not_overdue     giac_aging_parameters.over_due_tag%TYPE := 'N';
      
      CURSOR inv IS
      SELECT prem_seq_no,inst_no,iss_cd, ROUND(p_cut_off - due_date + 1) no_of_days
        FROM gipi_installment
       WHERE iss_cd <> 'RI'
         AND iss_cd  = DECODE(check_user_per_iss_cd_acctg(NULL, iss_cd, 'GIACS150'), 1, iss_cd, NULL);
   BEGIN
      FOR rec in inv 
      LOOP
         counter := counter + 1 ;
       
         DECLARE
            CURSOR param1 IS
            SELECT a.aging_id, a.over_due_tag
              FROM giac_aging_parameters a,gipi_invoice b
             WHERE ABS(rec.no_of_days) BETWEEN a.min_no_days and a.max_no_days
               AND over_due_tag = p_overdue
               AND gibr_branch_cd = rec.iss_cd;

            CURSOR param2 IS
            SELECT a.aging_id, a.over_due_tag
              FROM giac_aging_parameters a,gipi_invoice b
             WHERE ABS(rec.no_of_days) BETWEEN a.min_no_days and a.max_no_days
               AND over_due_tag = p_not_overdue
               AND gibr_branch_cd = rec.iss_cd;
         
         BEGIN                    
            IF rec.no_of_days > 0 THEN
               OPEN param1;
              FETCH param1 INTO v_aging_id, v_over_due_tag;
              CLOSE param1;
            ELSE
               OPEN param2;
              FETCH param2 INTO v_aging_id, v_over_due_tag;
              CLOSE param2;
            END IF;
 
            UPDATE giac_aging_soa_details
               SET gagp_aging_id = v_aging_id
             WHERE  balance_amt_due <> 0
               AND inst_no = rec.inst_no 
               AND iss_cd = rec.iss_cd
               AND prem_seq_no = rec.prem_seq_no;
         END;
      END LOOP;
   END age_bills_direct;
   
   PROCEDURE age_bills_fc(
      p_cut_off         IN DATE
   ) AS
      counter           NUMBER := 0  ;
      v_aging_id        giac_aging_parameters.aging_id%TYPE;
      v_over_due_tag    giac_aging_parameters.over_due_tag%TYPE;
      p_overdue         giac_aging_parameters.over_due_tag%TYPE := 'Y';
      p_not_overdue     giac_aging_parameters.over_due_tag%TYPE := 'N';
      
      CURSOR inv IS
      SELECT prem_seq_no,inst_no,iss_cd, ROUND(p_cut_off - due_date + 1) no_of_days
        FROM gipi_installment
       WHERE iss_cd <> 'RI'
         AND iss_cd = DECODE(check_user_per_iss_cd_acctg(NULL, iss_cd, 'GIACS150'), 1, iss_cd, NULL);
   BEGIN
      FOR rec IN inv LOOP
       counter := counter + 1 ;

      DECLARE
         CURSOR param1 IS
            SELECT a.aging_id, a.over_due_tag
              FROM giac_aging_parameters a,gipi_invoice b
             WHERE ABS(rec.no_of_days) BETWEEN a.min_no_days and a.max_no_days
               AND over_due_tag = p_overdue
               AND gibr_branch_cd = rec.iss_cd;

         CURSOR param2 IS
            SELECT a.aging_id, a.over_due_tag
              FROM giac_aging_parameters a,gipi_invoice b
             WHERE ABS(rec.no_of_days) BETWEEN a.min_no_days and a.max_no_days
               AND over_due_tag = p_not_overdue
               AND gibr_branch_cd = rec.iss_cd;
         
         BEGIN 
            IF rec.no_of_days > 0 THEN
               OPEN param1;
              FETCH param1 into v_aging_id, v_over_due_tag;
              CLOSE param1;
            ELSE
               OPEN param2;
              FETCH param2 into v_aging_id, v_over_due_tag;
              CLOSE param2;
            END IF;
 
            UPDATE giac_aging_fc_soa_details
               SET gagp_aging_id = v_aging_id
             WHERE  balance_amt_due <> 0
               AND inst_no = rec.inst_no 
               AND iss_cd = rec.iss_cd
               AND prem_seq_no = rec.prem_seq_no;
         END;
      END LOOP;
   END age_bills_fc;
   
   PROCEDURE age_bills_reinsurance(
      p_cut_off         IN DATE
   ) AS
      counter           NUMBER := 0;
      v_aging_id        giac_aging_parameters.aging_id%TYPE;
      v_over_due_tag    giac_aging_parameters.over_due_tag%TYPE;
      p_overdue         giac_aging_parameters.over_due_tag%TYPE := 'Y';
      p_not_overdue     giac_aging_parameters.over_due_tag%TYPE := 'N';

      CURSOR inv IS
      SELECT prem_seq_no,inst_no,iss_cd, ROUND(p_cut_off - due_date + 1) no_of_days
        FROM gipi_installment
       WHERE iss_cd = 'RI';
   BEGIN
      FOR rec in inv LOOP
         counter := counter + 1 ;

         DECLARE
            CURSOR param1 IS
            SELECT a.aging_id, a.over_due_tag
              FROM giac_aging_parameters a,gipi_invoice b
             WHERE ABS(rec.no_of_days) BETWEEN a.min_no_days and a.max_no_days
               AND over_due_tag = p_overdue
               AND gibr_branch_cd = rec.iss_cd;

            CURSOR param2 IS
            SELECT a.aging_id, a.over_due_tag
              FROM giac_aging_parameters a,gipi_invoice b
             WHERE ABS(rec.no_of_days) BETWEEN a.min_no_days and a.max_no_days
               AND over_due_tag = p_not_overdue
               AND gibr_branch_cd = rec.iss_cd;
         BEGIN
            IF rec.no_of_days > 0 THEN
               OPEN param1;
              FETCH param1 into v_aging_id, v_over_due_tag;
              CLOSE param1;
            ELSE
               OPEN param2;
              FETCH param2 into v_aging_id, v_over_due_tag;
              CLOSE param2;
            END IF;
 
            UPDATE giac_aging_ri_soa_details
               SET gagp_aging_id = v_aging_id
             WHERE  balance_due <> 0
               AND inst_no = rec.inst_no 
               AND prem_seq_no = rec.prem_seq_no;
         END;
     
      END LOOP;
   END age_bills_reinsurance;
   
   --marco - 09.02.2014
   PROCEDURE age_bills(
      p_cut_off         IN DATE,
      p_user_id         IN GIIS_USERS.user_id%TYPE
   )
   IS
      v_aging_id        giac_aging_parameters.aging_id%TYPE;
      v_over_due_tag    giac_aging_parameters.over_due_tag%TYPE;
   BEGIN
      FOR rec IN(SELECT prem_seq_no, inst_no, iss_cd, ROUND(p_cut_off - due_date + 1) no_of_days
                   FROM gipi_installment
                  WHERE iss_cd <> 'RI'
                    AND check_user_per_iss_cd_acctg2(NULL, iss_cd, 'GIACS150', p_user_id) = 1)
      LOOP
         IF rec.no_of_days > 0 THEN
            BEGIN
               SELECT a.aging_id, a.over_due_tag
                 INTO v_aging_id, v_over_due_tag
                 FROM giac_aging_parameters a
                WHERE ABS(rec.no_of_days) BETWEEN a.min_no_days and a.max_no_days
                  AND over_due_tag = 'Y'
                  AND gibr_branch_cd = rec.iss_cd;
            EXCEPTION
               WHEN OTHERS THEN
                  v_aging_id := NULL;
                  v_over_due_tag := NULL;
            END;
         ELSE
            BEGIN
               SELECT a.aging_id, a.over_due_tag
                 INTO v_aging_id, v_over_due_tag
                 FROM giac_aging_parameters a
                WHERE ABS(rec.no_of_days) BETWEEN a.min_no_days and a.max_no_days
                  AND over_due_tag = 'N'
                  AND gibr_branch_cd = rec.iss_cd;
            EXCEPTION
               WHEN OTHERS THEN
                  v_aging_id := NULL;
                  v_over_due_tag := NULL;
            END;
         END IF;
         
         UPDATE giac_aging_soa_details
            SET gagp_aging_id = v_aging_id
          WHERE inst_no = rec.inst_no
            AND iss_cd = rec.iss_cd
            AND prem_seq_no = rec.prem_seq_no
            AND balance_amt_due <> 0;
            
         UPDATE giac_aging_fc_soa_details
            SET gagp_aging_id = v_aging_id
          WHERE inst_no = rec.inst_no
            AND iss_cd = rec.iss_cd
            AND prem_seq_no = rec.prem_seq_no
            AND balance_amt_due <> 0;
      END LOOP;
   END;
   
   --marco - 09.02.2014
   PROCEDURE age_bills_ri(
      p_cut_off         IN DATE,
      p_user_id         IN GIIS_USERS.user_id%TYPE
   )
   IS
      v_aging_id        giac_aging_parameters.aging_id%TYPE;
      v_over_due_tag    giac_aging_parameters.over_due_tag%TYPE;
      v_access          NUMBER := check_user_per_iss_cd_acctg2(NULL, 'RI', 'GIACS150', p_user_id);
   BEGIN
      FOR rec IN(SELECT prem_seq_no, inst_no, iss_cd, ROUND(p_cut_off - due_date + 1) no_of_days
                   FROM gipi_installment
                  WHERE iss_cd = 'RI'
                    AND v_access = 1)
      LOOP
         IF rec.no_of_days > 0 THEN
            BEGIN
               SELECT a.aging_id, a.over_due_tag
                 INTO v_aging_id, v_over_due_tag
                 FROM giac_aging_parameters a
                WHERE gibr_branch_cd = rec.iss_cd
                  AND over_due_tag = 'Y'
                  AND ABS(rec.no_of_days) BETWEEN a.min_no_days and a.max_no_days;
            EXCEPTION
               WHEN OTHERS THEN
                  v_aging_id := NULL;
                  v_over_due_tag := NULL;
            END;
         ELSE
            BEGIN
               SELECT a.aging_id, a.over_due_tag
                 INTO v_aging_id, v_over_due_tag
                 FROM giac_aging_parameters a
                WHERE gibr_branch_cd = rec.iss_cd
                  AND over_due_tag = 'N'
                  AND ABS(rec.no_of_days) BETWEEN a.min_no_days and a.max_no_days;
            EXCEPTION
               WHEN OTHERS THEN
                  v_aging_id := NULL;
                  v_over_due_tag := NULL;
            END;
         END IF;
         
         UPDATE giac_aging_ri_soa_details
            SET gagp_aging_id = v_aging_id
          WHERE inst_no = rec.inst_no 
            AND prem_seq_no = rec.prem_seq_no
            AND balance_due <> 0;
      END LOOP;
   END;
   
END GIACS150_PKG;
/


