DROP PROCEDURE CPI.POSTING_PROCESS_A;

CREATE OR REPLACE PROCEDURE CPI.posting_process_a (p_par_id IN gipi_parlist.par_id%TYPE, p_msg_alert OUT VARCHAR2, p_module_id giis_modules.module_id%TYPE DEFAULT NULL)
IS
   v_affecting      VARCHAR2 (1);
   v_line_cd        gipi_parlist.line_cd%TYPE;
   v_par_type       gipi_parlist.par_type%TYPE;
   v_subline_cd     gipi_wpolbas.subline_cd%TYPE;
   v_pol_stat       gipi_wpolbas.pol_flag%TYPE;
   v_iss_cd         gipi_wpolbas.iss_cd%TYPE;
   v_issue_yy       gipi_wpolbas.issue_yy%TYPE;
   v_pol_seq_no     gipi_wpolbas.pol_seq_no%TYPE;
   v_renew_no       gipi_wpolbas.renew_no%TYPE;
   v_ann_tsi_amt    gipi_wpolbas.ann_tsi_amt%TYPE;
   v_eff_date       gipi_wpolbas.eff_date%TYPE;
   v_par_seq_no     gipi_parlist.par_seq_no%TYPE;
   v_par_yy         gipi_parlist.par_yy%TYPE;
   v_pack           gipi_wpolbas.pack_pol_flag%TYPE;
   v_msg_alert      VARCHAR2 (32000);
   v_surety_cd      giis_parameters.param_value_v%TYPE;
   v_bank_ref_no    gipi_wpolbas.bank_ref_no%TYPE;
   v_bank_ref_no2   gipi_wpolbas.bank_ref_no%TYPE;
   v_ref_pol_no     gipi_wpolbas.ref_pol_no%TYPE;   --added by Gzelle 09082014
   v_load_tag       gipi_parlist.load_tag%TYPE; -- bonok :: 1.11.2017 :: for quick policy issuance
BEGIN
   /*
   **  Created by   : Jerome Orio
   **  Date Created : March 24, 2010
   **  Reference By : (GIPIS055 - POST PAR)
   **  Description  : a part of Posting_process program unit
   *//*
    **  Modified by  : Andrew Robes
    **  Date Created : 04.13.2012
    **  Modification : Added validation for bank_ref_no
    */
    /*
    **  Modified by  : Gzelle
    **  Date Created : 09.04.2013
    **  Modification : Added p_module_id parameter to determine if procedure is called from Batch Posting.
    **              If called from Batch Posting, insert error to giis_post_error_log
    */    
   BEGIN
      SELECT a.param_value_v
        INTO v_surety_cd
        FROM giis_parameters a
       WHERE a.param_name = 'LINE_CODE_SU';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END;

   SELECT line_cd, par_type, par_seq_no, par_yy, load_tag
     INTO v_line_cd, v_par_type, v_par_seq_no, v_par_yy, v_load_tag
     FROM gipi_parlist
    WHERE par_id = p_par_id;

   SELECT subline_cd, pol_flag, iss_cd, issue_yy, pol_seq_no, renew_no, ann_tsi_amt, eff_date, pack_pol_flag,
          bank_ref_no, ref_pol_no
     INTO v_subline_cd, v_pol_stat, v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no, v_ann_tsi_amt, v_eff_date, v_pack,
          v_bank_ref_no, v_ref_pol_no
     FROM gipi_wpolbas
    WHERE par_id = p_par_id;

   /*added by Gzelle 09082014*/
   IF NVL (giisp.v ('REQUIRE_REF_POL_NO'), 'N') = 'Y'
   THEN
      IF v_par_type = 'P' AND v_ref_pol_no IS NULL
      THEN
         IF p_module_id = 'GIPIS207'
         THEN
            gipis207_pkg.pre_post_error2(p_par_id, 'Please provide a reference policy number for this PAR before posting the policy.', p_module_id);     
            p_msg_alert := 'Y';
         ELSE
            p_msg_alert := 'Please provide a reference policy number for this PAR before posting the policy.';
         END IF;
         RETURN;      
      END IF;   
   END IF;
   
   IF NVL(v_load_tag, 'XX') <> 'Q' THEN -- bonok :: 1.11.2017 :: for quick policy issuance.  if load_tag is Q, skip checking of REQUIRE_REF_NO
      IF NVL (giisp.v ('ORA2010_SW'), 'N') = 'Y' AND NVL (giisp.v ('REQUIRE_REF_NO'), 'N') = 'Y'
      THEN
         IF v_par_type = 'P' AND v_bank_ref_no IS NULL
         THEN                                                                   -- analyn 07/22/10 added v_par_type in the condition
            --gipis207_pkg.pre_post_error2(p_par_id, 'Please provide a bank reference number for this PAR before posting the policy.', p_module_id);  
            --p_msg_alert := 'Please provide a bank reference number for this PAR before posting the policy.';
            IF p_module_id = 'GIPIS207'
            THEN
               gipis207_pkg.pre_post_error2(p_par_id, 'Please provide a bank reference number for this PAR before posting the policy.', p_module_id);     
               p_msg_alert := 'Y';  
            ELSE
               p_msg_alert := 'Please provide a bank reference number for this PAR before posting the policy.';
            END IF;
            RETURN;
         ELSIF v_par_type = 'E'
         THEN                                                                                                      -- analyn 07/22/10
            FOR a IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                        FROM gipi_wpolbas
                       WHERE par_id = p_par_id)
            LOOP
               SELECT bank_ref_no
                 INTO v_bank_ref_no2
                 FROM gipi_polbasic
                WHERE line_cd = a.line_cd
                  AND subline_cd = a.subline_cd
                  AND iss_cd = a.iss_cd
                  AND issue_yy = a.issue_yy
                  AND pol_seq_no = a.pol_seq_no
                  AND renew_no = a.renew_no
                  AND endt_seq_no = 0;
            END LOOP;

            IF v_bank_ref_no2 IS NOT NULL AND v_bank_ref_no IS NULL
            THEN
               --gipis207_pkg.pre_post_error2(p_par_id, 'Please provide a bank reference number for this PAR before posting the policy.', p_module_id);  
               --p_msg_alert := 'Please provide a bank reference number for this PAR before posting the policy.';
               IF p_module_id = 'GIPIS207'
               THEN
                  gipis207_pkg.pre_post_error2(p_par_id, 'Please provide a bank reference number for this PAR before posting the policy.', p_module_id);     
                  p_msg_alert := 'Y';  
               ELSE
                  p_msg_alert := 'Please provide a bank reference number for this PAR before posting the policy.';
               END IF;
               RETURN;
            END IF;
         END IF;
      END IF;
   END IF; -- bonok :: 1.11.2017 :: for quick policy issuance.  if load_tag is Q, skip checking of REQUIRE_REF_NO

   IF v_par_type = 'E'
   THEN
      /* modified by bdarusin
      ** modified on jan312003
      ** shld use pol_iss_cd instead of iss_cd for policy_number */
      IF v_pol_stat = '4' OR v_ann_tsi_amt = 0
      THEN
         FOR a2 IN (SELECT claim_id
                      FROM gicl_claims
                     WHERE line_cd = v_line_cd
                       AND subline_cd = v_subline_cd
                       --AND iss_cd = :postpar.iss_cd   --bdarusin, jan312003
                       AND pol_iss_cd = v_iss_cd                                                             --bdarusin, jan312003
                       AND issue_yy = v_issue_yy
                       AND pol_seq_no = v_pol_seq_no
                       AND renew_no = v_renew_no
                       AND clm_stat_cd NOT IN ('CC', 'WD', 'DN', 'CD'))
         LOOP
            --gipis207_pkg.pre_post_error2(p_par_id, 'The policy has pending claims, cannot cancel policy.', p_module_id);  
            --p_msg_alert := 'The policy has pending claims, cannot cancel policy.';
            IF p_module_id = 'GIPIS207'
            THEN
               gipis207_pkg.pre_post_error2(p_par_id, 'The policy has pending claims, cannot cancel policy.', p_module_id);     
               p_msg_alert := 'Y';  
            ELSE
               p_msg_alert := 'The policy has pending claims, cannot cancel policy.';
            END IF;
         --SET_APPLICATION_PROPERTY(CURSOR_STYLE,'DEFAULT');
         --EXIT_FORM;
         END LOOP;
      END IF;

      /*Commented by iris bordey 08.28.2003*/
      /* modified by bdarusin
      ** modified on jan312003
      ** shld use pol_iss_cd instead of iss_cd for policy_number */
      update_pending_claims (v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no, v_eff_date);

      BEGIN
         FOR s IN (SELECT spld_flag
                     FROM gipi_polbasic
                    WHERE line_cd = v_line_cd
                      AND subline_cd = v_subline_cd
                      AND iss_cd = v_iss_cd
                      AND issue_yy = v_issue_yy
                      AND pol_seq_no = v_pol_seq_no
                      AND renew_no = v_renew_no
                      AND endt_seq_no = 0)
         LOOP
            IF s.spld_flag = 2
            THEN
                --gipis207_pkg.pre_post_error2(p_par_id, 'Policy has been tagged for spoilage, cannot post endorsement.', p_module_id);  
                --p_msg_alert := 'Policy has been tagged for spoilage, cannot post endorsement.';
                IF p_module_id = 'GIPIS207'
                THEN
                   gipis207_pkg.pre_post_error2(p_par_id, 'Policy has been tagged for spoilage, cannot post endorsement.', p_module_id);  
                   p_msg_alert := 'Y';     
                ELSE
                   p_msg_alert := 'Policy has been tagged for spoilage, cannot post endorsement.';
                END IF;
            --SET_APPLICATION_PROPERTY(CURSOR_STYLE,'DEFAULT');
            --EXIT_FORM;
            END IF;
         END LOOP;
      END;

      BEGIN
         FOR a IN (SELECT 1
                     FROM gipi_winvoice
                    WHERE par_id = p_par_id)
         LOOP
            v_affecting := 'A';
         END LOOP;

         IF v_affecting IS NULL
         THEN
            v_affecting := 'N';
         END IF;
      END;

      IF v_affecting = 'A'
      THEN
         IF v_msg_alert IS NULL
         THEN
            validate_par (p_par_id,
                          v_line_cd,
                          v_subline_cd,
                          v_iss_cd,
                          v_par_seq_no,
                          v_par_yy,
                          v_pack,
                          v_par_type,
                          v_pol_stat,
                          v_affecting,
                          v_msg_alert
                         );
         END IF;
      ELSIF v_affecting = 'N'
      THEN
         IF v_msg_alert IS NULL
         THEN
            validate_in_wpolbas (p_par_id, v_msg_alert);
         END IF;

         IF v_line_cd = v_surety_cd
         THEN
            IF v_msg_alert IS NULL
            THEN
               validate_wbond_basic (p_par_id, v_affecting, v_msg_alert);
            END IF;
         END IF;
      END IF;
   ELSE
      -- :postpar.par_type = 'P'
      IF v_msg_alert IS NULL
      THEN
         validate_par (p_par_id,
                       v_line_cd,
                       v_subline_cd,
                       v_iss_cd,
                       v_par_seq_no,
                       v_par_yy,
                       v_pack,
                       v_par_type,
                       v_pol_stat,
                       v_affecting,
                       v_msg_alert
                      );
      END IF;
   END IF;
   
   --gipis207_pkg.pre_post_error2(p_par_id, v_msg_alert, p_module_id);  
   --p_msg_alert := NVL (v_msg_alert, p_msg_alert);
   IF p_module_id = 'GIPIS207'
   THEN
      gipis207_pkg.pre_post_error2(p_par_id, v_msg_alert, p_module_id);
      p_msg_alert := NVL (v_msg_alert, p_msg_alert);
   ELSE
      p_msg_alert := NVL (v_msg_alert, p_msg_alert);
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
       --gipis207_pkg.pre_post_error2(p_par_id, 'No Data found in GIPI_PARLIST or GIPI_WPOLBAS', p_module_id);  
       --p_msg_alert := 'No Data found in GIPI_PARLIST or GIPI_WPOLBAS';
       IF p_module_id = 'GIPIS207'
       THEN
          gipis207_pkg.pre_post_error2(p_par_id, 'No Data found in GIPI_PARLIST or GIPI_WPOLBAS', p_module_id); 
          p_msg_alert := 'Y';    
       ELSE
          p_msg_alert := 'No Data found in GIPI_PARLIST or GIPI_WPOLBAS';
       END IF;
   WHEN TOO_MANY_ROWS
   THEN
       --gipis207_pkg.pre_post_error2(p_par_id,'Too Many Rows found in GIPI_PARLIST or GIPI_WPOLBAS', p_module_id);  
       --p_msg_alert := 'Too Many Rows found in GIPI_PARLIST or GIPI_WPOLBAS';
       IF p_module_id = 'GIPIS207'
       THEN
          gipis207_pkg.pre_post_error2(p_par_id,'Too Many Rows found in GIPI_PARLIST or GIPI_WPOLBAS', p_module_id);
          p_msg_alert := 'Y';
       ELSE
          p_msg_alert := 'Too Many Rows found in GIPI_PARLIST or GIPI_WPOLBAS';
       END IF;
END;
/


