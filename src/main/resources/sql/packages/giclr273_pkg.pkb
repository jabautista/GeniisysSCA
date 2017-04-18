CREATE OR REPLACE PACKAGE BODY CPI.giclr273_pkg
AS
   FUNCTION get_rec_list (
      p_as_of_date      VARCHAR2,    
      p_from_date       VARCHAR2,
      p_to_date         VARCHAR2,
      p_as_of_ldate     VARCHAR2,    
      p_from_ldate      VARCHAR2,
      p_to_ldate        VARCHAR2,
      p_user_id         VARCHAR2
   )
      RETURN rec_tab PIPELINED
   IS
      v_list    rec_type;
      v_print   BOOLEAN := TRUE;
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_list.company_name
           FROM giac_parameters
          WHERE param_name = 'COMPANY_NAME';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            v_list.company_name := NULL;
      END;

      BEGIN
         SELECT param_value_v
           INTO v_list.company_address
           FROM giis_parameters
          WHERE param_name = 'COMPANY_ADDRESS';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            v_list.company_address := NULL;
      END;

      BEGIN
         IF p_as_of_date IS NOT NULL THEN
            v_list.date_type := ('Claim File Date As of ' || TO_CHAR (TO_DATE(p_as_of_date,'MM-DD-YYYY'), 'fmMonth DD, RRRR'));
         ELSIF p_from_date IS NOT NULL AND p_to_date IS NOT NULL THEN
            v_list.date_type := ('Claim File Date From ' || TO_CHAR (TO_DATE(p_from_date,'MM-DD-YYYY'), 'fmMonth DD, RRRR') || ' To ' || TO_CHAR (TO_DATE(p_to_date,'MM-DD-YYYY'), 'fmMonth DD, RRRR'));
         ELSIF p_as_of_ldate IS NOT NULL THEN
            v_list.date_type := ('Loss Date As of ' || TO_CHAR (TO_DATE(p_as_of_ldate,'MM-DD-YYYY'), 'fmMonth DD, RRRR'));
         ELSIF p_from_ldate IS NOT NULL AND p_to_ldate IS NOT NULL THEN
            v_list.date_type := ('Loss Date From ' || TO_CHAR (TO_DATE(p_from_ldate,'MM-DD-YYYY'), 'fmMonth DD, RRRR') || ' To ' || TO_CHAR (TO_DATE(p_to_ldate,'MM-DD-YYYY'), 'fmMonth DD, RRRR'));
         END IF;
      END;
      
      FOR a IN (SELECT TRIM (line_cd 
                             || '-' || subline_cd 
                             || '-' || iss_cd 
                             || '-' || TO_CHAR (clm_yy, '09') 
                             || '-' || TO_CHAR (clm_seq_no, '0999999')) AS claim_number,
                       TRIM (line_cd 
                             || '-' || subline_cd 
                             || '-' || pol_iss_cd 
                             || '-' || TO_CHAR (issue_yy, '09') 
                             || '-' || TO_CHAR (pol_seq_no, '0999999') 
                             || '-' || TO_CHAR (renew_no, '09')
                            ) AS policy_number,
                       claim_id, assd_no, assured_name,  
                       NVL (loss_res_amt, 0) AS loss_res_amt, NVL (exp_res_amt, 0) AS exp_res_amt,
                       NVL (loss_pd_amt, 0) AS loss_pd_amt, NVL (exp_pd_amt, 0) AS exp_pd_amt,
                       (SELECT clm_stat_cd || ' - ' ||clm_stat_desc --added statcd for SR-5629 
                          FROM giis_clm_stat
                         WHERE clm_stat_cd = a.clm_stat_cd) clm_stat_cd, 
                       (SELECT SUM (paid_amt)
                          FROM gicl_clm_loss_exp
                         WHERE claim_id = a.claim_id 
                           AND ex_gratia_sw = 'Y' 
                           AND NVL (cancel_sw, 'N') <> 'Y') ex_gratia_payt
                  FROM gicl_claims a
                 WHERE EXISTS (SELECT claim_id
                                 FROM gicl_clm_loss_exp b
                                WHERE ex_gratia_sw = 'Y' AND NVL (cancel_sw, 'N') <> 'Y' 
                                  AND a.claim_id = b.claim_id 
                                  AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS273', p_user_id) = 1)
                   AND (   (   TRUNC (a.clm_file_date) >= TO_DATE (p_from_date, 'MM-DD-YYYY') AND TRUNC (a.clm_file_date) <= TO_DATE (p_to_date, 'MM-DD-YYYY')
                            OR TRUNC (a.clm_file_date) <= TO_DATE (p_as_of_date, 'MM-DD-YYYY')
                           )
                        OR (   TRUNC (a.loss_date) >= TO_DATE (p_from_ldate, 'MM-DD-YYYY') AND TRUNC (a.loss_date) <= TO_DATE (p_to_ldate, 'MM-DD-YYYY')
                            OR TRUNC (a.loss_date) <= TO_DATE (p_as_of_ldate, 'MM-DD-YYYY')
                           )
                       )
               )
      LOOP
         v_print               := FALSE;
         v_list.claim_no       := a.claim_number;
         v_list.policy_no      := a.policy_number;
         v_list.assd_name      := a.assured_name;
         v_list.clm_stat_cd    := a.clm_stat_cd;
         v_list.loss_res_amt   := a.loss_res_amt;
         v_list.exp_res_amt    := a.exp_res_amt;
         v_list.loss_pd_amt    := a.loss_pd_amt;
         v_list.exp_pd_amt     := a.exp_pd_amt;
         v_list.ex_gratia_payt := a.ex_gratia_payt;
         PIPE ROW (v_list);
      END LOOP;
      
      IF v_print
      THEN
         v_list.v_print := 'TRUE';
         PIPE ROW (v_list);
      END IF;
   END;
END;
/


