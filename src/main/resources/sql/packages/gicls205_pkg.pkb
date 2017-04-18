CREATE OR REPLACE PACKAGE BODY CPI.GICLS205_PKG
   /*
   **  Created by        : bonok
   **  Date Created      : 08.22.2013
   **  Reference By      : GICLS205 - LOSS RATIO DETAILS
   **
   */
AS
   FUNCTION get_gicl_loss_ratio_ext(
      p_session_id          gicl_loss_ratio_ext.session_id%TYPE,
      p_prnt_option         VARCHAR2
   ) RETURN gicl_loss_ratio_ext_tab PIPELINED AS
      lr_ext                gicl_loss_ratio_ext_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM gicl_loss_ratio_ext
                 WHERE session_id = p_session_id)
      LOOP
         IF p_prnt_option = '1' THEN
            FOR rec IN (SELECT line_name
                          FROM giis_line
                         WHERE line_cd = i.line_cd)
            LOOP
               lr_ext.display := i.line_cd||' - '||rec.line_name;
            END LOOP;
            lr_ext.display_label := 'Line';
         ELSIF p_prnt_option = '2' THEN
            FOR rec IN (SELECT subline_name
                          FROM giis_subline
                         WHERE subline_cd = i.subline_cd)
            LOOP
               lr_ext.display := i.subline_cd||' - '||rec.subline_name;
            END LOOP;
            lr_ext.display_label := 'Subline';
         ELSIF p_prnt_option = '3' THEN
            FOR rec IN (SELECT iss_name
                          FROM giis_issource
                         WHERE iss_cd = i.iss_cd)
            LOOP
               lr_ext.display := i.iss_cd||' - '||rec.iss_name;
            END LOOP;
            lr_ext.display_label := 'Issuing Source';
         ELSIF p_prnt_option = '4' THEN   
            FOR rec IN (SELECT intm_name
                          FROM giis_intermediary
                         WHERE intm_no = i.intm_no)
            LOOP
               lr_ext.display := TO_CHAR(i.intm_no)||' - '||rec.intm_name;
            END LOOP;
            lr_ext.display_label := 'Intermediary';
         ELSIF p_prnt_option = '5' THEN
            FOR rec IN (SELECT assd_name
                          FROM giis_assured
                         WHERE assd_no = i.assd_no)
            LOOP
               lr_ext.display := TO_CHAR(i.assd_no)||' - '||rec.assd_name;
            END LOOP;
            lr_ext.display_label := 'Assured';
         ELSIF p_prnt_option = '6' THEN
            FOR rec IN (SELECT peril_name
                          FROM giis_peril  
                         WHERE peril_cd = i.peril_cd
                           AND line_cd = i.line_cd)
            LOOP
               lr_ext.display := TO_CHAR(i.peril_cd)||' - '||rec.peril_name;
            END LOOP;
            lr_ext.display_label := 'Peril';
         END IF;
      
         lr_ext.loss_paid_amt := NVL(i.loss_paid_amt,0);
         lr_ext.curr_prem_amt := NVL(i.curr_prem_amt,0);
         lr_ext.prev_loss_res := NVL(i.prev_loss_res,0);
         lr_ext.curr_loss_res := NVL(i.curr_loss_res,0);
         lr_ext.curr_prem_res := NVL(i.curr_prem_res,0); 
         lr_ext.prev_prem_res := NVL(i.prev_prem_res,0);
         lr_ext.premium_earned := NVL((NVL(i.curr_prem_amt,0) + (NVL(i.prev_prem_res,0)) - (NVL(i.curr_prem_res,0))), 0); -- Dren Niebres 07.12.2016 SR-21428
         --lr_ext.premium_earned := NVL((NVL(i.curr_prem_amt,0) + (NVL(i.prev_prem_amt,0) * .4) - (NVL(i.curr_prem_amt,0) * .4)), 0); -- Dren Niebres 07.12.2016 SR-21428
         lr_ext.losses_incurred := NVL((NVL(i.loss_paid_amt,0) + NVL(i.curr_loss_res,0) - NVL(i.prev_loss_res,0)), 0);

         IF NVL(lr_ext.premium_earned, 0) != 0 THEN
            lr_ext.loss_ratio := NVL((lr_ext.losses_incurred / lr_ext.premium_earned) * 100, 0);
         END IF;
         
         PIPE ROW(lr_ext);
      END LOOP;
   END;   
   
   FUNCTION get_lr_curr_prem_prl(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN lr_curr_prem_prl_tab PIPELINED AS
      lr_curr_prem_prl      lr_curr_prem_prl_type;
   BEGIN
      FOR i IN (SELECT session_id, policy_id, assd_no, line_cd, iss_cd, subline_cd, peril_cd, SUM(prem_amt) prem_amt 
                  FROM gicl_lratio_curr_prem_ext
                 WHERE session_id = p_session_id
                 GROUP BY session_id, policy_id, assd_no, line_cd, iss_cd, subline_cd, peril_cd)
      LOOP
         FOR rec IN (SELECT get_policy_no(i.policy_id) policy_no,
                            endt_iss_cd, endt_yy, endt_seq_no, incept_date, expiry_date, tsi_amt,
                            issue_date, acct_ent_date, TO_CHAR(TO_DATE(booking_mth,'MONTH'),'MON')||' '||TO_CHAR(booking_year) booking_date           
                       FROM gipi_polbasic
                      WHERE policy_id = i.policy_id)
         LOOP
            lr_curr_prem_prl.policy_no := rec.policy_no;
            lr_curr_prem_prl.incept_date := TO_CHAR(rec.incept_date,'MM-DD-RRRR');
            lr_curr_prem_prl.expiry_date := TO_CHAR(rec.expiry_date,'MM-DD-RRRR');
            lr_curr_prem_prl.tsi_amt := rec.tsi_amt;
            
            IF p_prnt_date = 1 THEN
    	       lr_curr_prem_prl.nbt_date := TO_CHAR(rec.issue_date,'MM-DD-RRRR');
            ELSIF p_prnt_date = 3 THEN
    	       lr_curr_prem_prl.nbt_date := TO_CHAR(rec.acct_ent_date,'MM-DD-RRRR');
            ELSIF p_prnt_date = 4 THEN
    	       lr_curr_prem_prl.nbt_date := rec.booking_date;
            END IF;
            
            FOR ass IN (SELECT assd_name 
                          FROM giis_assured
                         WHERE assd_no = i.assd_no)
            LOOP
               lr_curr_prem_prl.nbt_assured := ass.assd_name;
            END LOOP;  
  
            FOR rec IN (SELECT peril_name
                          FROM giis_peril  
                         WHERE peril_cd = i.peril_cd  
                           AND line_cd = i.line_cd)
            LOOP
  	           lr_curr_prem_prl.nbt_peril_name := rec.peril_name;
            END LOOP;  
         END LOOP;
         
         lr_curr_prem_prl.prem_amt := i.prem_amt;
         
         PIPE ROW(lr_curr_prem_prl);
      END LOOP;
   END;   
   
   FUNCTION get_lr_curr_prem_intm(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN lr_curr_prem_intm_tab PIPELINED AS
      lr_curr_prem_intm     lr_curr_prem_intm_type;
   BEGIN
      FOR i IN (SELECT session_id, policy_id, assd_no, line_cd, iss_cd, subline_cd, SUM(prem_amt) prem_amt, intm_no 
                  FROM gicl_lratio_curr_prem_ext
                 WHERE session_id = p_session_id
                 GROUP BY session_id, policy_id, assd_no, line_cd, iss_cd, subline_cd, intm_no)
      LOOP
         FOR rec IN (SELECT get_policy_no(i.policy_id) policy_no,
                            endt_iss_cd, endt_yy, endt_seq_no, incept_date, expiry_date, tsi_amt,
                            issue_date, acct_ent_date, TO_CHAR(TO_DATE(booking_mth,'MONTH'),'MON')||' '||TO_CHAR(booking_year) booking_date           
                       FROM gipi_polbasic
                      WHERE policy_id = i.policy_id)
         LOOP
            lr_curr_prem_intm.policy_no := rec.policy_no;
            lr_curr_prem_intm.nbt_incept_date := TO_CHAR(rec.incept_date,'MM-DD-RRRR');
            lr_curr_prem_intm.nbt_expiry_date := TO_CHAR(rec.expiry_date,'MM-DD-RRRR');
            lr_curr_prem_intm.nbt_tsi_amt := rec.tsi_amt;
            
            IF p_prnt_date = 1 THEN
    	       lr_curr_prem_intm.nbt_date := TO_CHAR(rec.issue_date,'MM-DD-RRRR');
            ELSIF p_prnt_date = 3 THEN
    	       lr_curr_prem_intm.nbt_date := TO_CHAR(rec.acct_ent_date,'MM-DD-RRRR');               
            ELSIF p_prnt_date = 4 THEN
    	       lr_curr_prem_intm.nbt_date := rec.booking_date;
            END IF;
         END LOOP;
         
         lr_curr_prem_intm.prem_amt := i.prem_amt;
         
         FOR ass IN (SELECT assd_name 
                       FROM giis_assured
                      WHERE assd_no = i.assd_no)
         LOOP
            lr_curr_prem_intm.nbt_assured := ass.assd_name;
         END LOOP;  
  
         FOR rec IN (SELECT intm_name
                       FROM giis_intermediary
                      WHERE intm_no = i.intm_no)
         LOOP
            lr_curr_prem_intm.nbt_intm := rec.intm_name;
         END LOOP;    
         
         PIPE ROW(lr_curr_prem_intm);
      END LOOP;
   END;
   
   FUNCTION get_lr_curr_prem(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN lr_curr_prem_tab PIPELINED AS
      lr_curr_prem          lr_curr_prem_type;
   BEGIN
      FOR i IN (SELECT session_id, policy_id, assd_no, line_cd, iss_cd, subline_cd, SUM(prem_amt) prem_amt 
                  FROM gicl_lratio_curr_prem_ext
                 WHERE session_id = p_session_id
                 GROUP BY session_id, policy_id, assd_no, line_cd, iss_cd, subline_cd)
      LOOP
         FOR rec IN (SELECT get_policy_no(i.policy_id) policy_no,
                            endt_iss_cd, endt_yy, endt_seq_no, incept_date, expiry_date, tsi_amt,
                            issue_date, acct_ent_date, TO_CHAR(TO_DATE(booking_mth,'MONTH'),'MON')||' '||TO_CHAR(booking_year) booking_date           
                       FROM gipi_polbasic
                      WHERE policy_id = i.policy_id)
         LOOP
            lr_curr_prem.policy_no := rec.policy_no;
            lr_curr_prem.nbt_incept_date := TO_CHAR(rec.incept_date,'MM-DD-RRRR');
            lr_curr_prem.nbt_expiry_date := TO_CHAR(rec.expiry_date,'MM-DD-RRRR');
            lr_curr_prem.nbt_tsi_amt := rec.tsi_amt;
            
            IF p_prnt_date = 1 THEN
    	       lr_curr_prem.nbt_date := TO_CHAR(rec.issue_date,'MM-DD-RRRR');
            ELSIF p_prnt_date = 3 THEN
    	       lr_curr_prem.nbt_date := TO_CHAR(rec.acct_ent_date,'MM-DD-RRRR');
            ELSIF p_prnt_date = 4 THEN
    	       lr_curr_prem.nbt_date := rec.booking_date;
            END IF;
         END LOOP;
         
         lr_curr_prem.prem_amt := i.prem_amt;
         
         FOR ass IN (SELECT assd_name 
                       FROM giis_assured
                      WHERE assd_no = i.assd_no)
         LOOP
            lr_curr_prem.nbt_assured := ass.assd_name;
         END LOOP;  
         
         PIPE ROW(lr_curr_prem);
      END LOOP;
   END;
   
   FUNCTION get_lr_prev_prem_prl(
      p_session_id          gicl_lratio_prev_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN lr_curr_prem_prl_tab PIPELINED AS
      lr_prev_prem_prl      lr_curr_prem_prl_type;
   BEGIN
      FOR i IN (SELECT session_id, policy_id, assd_no, line_cd, iss_cd, subline_cd, peril_cd, SUM(prem_amt) prem_amt 
                  FROM gicl_lratio_prev_prem_ext
                 WHERE session_id = p_session_id
                 GROUP BY session_id, policy_id, assd_no, line_cd, iss_cd, subline_cd, peril_cd)
      LOOP
         FOR rec IN (SELECT get_policy_no(i.policy_id) policy_no,
                            endt_iss_cd, endt_yy, endt_seq_no, incept_date, expiry_date, tsi_amt,
                            issue_date, acct_ent_date, TO_CHAR(TO_DATE(booking_mth,'MONTH'),'MON')||' '||TO_CHAR(booking_year) booking_date           
                       FROM gipi_polbasic
                      WHERE policy_id = i.policy_id)
         LOOP
            lr_prev_prem_prl.policy_no := rec.policy_no;
            lr_prev_prem_prl.incept_date := TO_CHAR(rec.incept_date,'MM-DD-RRRR');
            lr_prev_prem_prl.expiry_date := TO_CHAR(rec.expiry_date,'MM-DD-RRRR');
            lr_prev_prem_prl.tsi_amt := rec.tsi_amt;
            
            IF p_prnt_date = 1 THEN
    	       lr_prev_prem_prl.nbt_date := TO_CHAR(rec.issue_date,'MM-DD-RRRR');
            ELSIF p_prnt_date = 3 THEN
    	       lr_prev_prem_prl.nbt_date := TO_CHAR(rec.acct_ent_date,'MM-DD-RRRR');
            ELSIF p_prnt_date = 4 THEN
    	       lr_prev_prem_prl.nbt_date := rec.booking_date;
            END IF;
            
            FOR ass IN (SELECT assd_name 
                          FROM giis_assured
                         WHERE assd_no = i.assd_no)
            LOOP
               lr_prev_prem_prl.nbt_assured := ass.assd_name;
            END LOOP;  
  
            FOR rec IN (SELECT peril_name
                          FROM giis_peril  
                         WHERE peril_cd = i.peril_cd  
                           AND line_cd = i.line_cd)
            LOOP
  	           lr_prev_prem_prl.nbt_peril_name := rec.peril_name;
            END LOOP;  
         END LOOP;
         
         lr_prev_prem_prl.prem_amt := i.prem_amt;
         
         PIPE ROW(lr_prev_prem_prl);
      END LOOP;
   END;  
   
   FUNCTION get_lr_prev_prem_intm(
      p_session_id          gicl_lratio_prev_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN lr_curr_prem_intm_tab PIPELINED AS
      lr_prev_prem_intm     lr_curr_prem_intm_type;
   BEGIN
      FOR i IN (SELECT session_id, policy_id, assd_no, line_cd, iss_cd, subline_cd, SUM(prem_amt) prem_amt, intm_no 
                  FROM gicl_lratio_prev_prem_ext
                 WHERE session_id = p_session_id
                 GROUP BY session_id, policy_id, assd_no, line_cd, iss_cd, subline_cd, intm_no)
      LOOP
         FOR rec IN (SELECT get_policy_no(i.policy_id) policy_no,
                            endt_iss_cd, endt_yy, endt_seq_no, incept_date, expiry_date, tsi_amt,
                            issue_date, acct_ent_date, TO_CHAR(TO_DATE(booking_mth,'MONTH'),'MON')||' '||TO_CHAR(booking_year) booking_date           
                       FROM gipi_polbasic
                      WHERE policy_id = i.policy_id)
         LOOP
            lr_prev_prem_intm.policy_no := rec.policy_no;
            lr_prev_prem_intm.nbt_incept_date := TO_CHAR(rec.incept_date,'MM-DD-RRRR');
            lr_prev_prem_intm.nbt_expiry_date := TO_CHAR(rec.expiry_date,'MM-DD-RRRR');
            lr_prev_prem_intm.nbt_tsi_amt := rec.tsi_amt;
            
            IF p_prnt_date = 1 THEN
    	       lr_prev_prem_intm.nbt_date := TO_CHAR(rec.issue_date,'MM-DD-RRRR');
            ELSIF p_prnt_date = 3 THEN
    	       lr_prev_prem_intm.nbt_date := TO_CHAR(rec.acct_ent_date,'MM-DD-RRRR');
            ELSIF p_prnt_date = 4 THEN
    	       lr_prev_prem_intm.nbt_date := rec.booking_date;
            END IF;
         END LOOP;
         
         lr_prev_prem_intm.prem_amt := i.prem_amt;
         
         FOR ass IN (SELECT assd_name 
                       FROM giis_assured
                      WHERE assd_no = i.assd_no)
         LOOP
            lr_prev_prem_intm.nbt_assured := ass.assd_name;
         END LOOP;  
  
         FOR rec IN (SELECT intm_name
                       FROM giis_intermediary
                      WHERE intm_no = i.intm_no)
         LOOP
            lr_prev_prem_intm.nbt_intm := rec.intm_name;
         END LOOP;    
         
         PIPE ROW(lr_prev_prem_intm);
      END LOOP;
   END; 
   
   FUNCTION get_lr_prev_prem(
      p_session_id          gicl_lratio_prev_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN lr_curr_prem_tab PIPELINED AS
      lr_prev_prem          lr_curr_prem_type;
   BEGIN
      FOR i IN (SELECT session_id, policy_id, assd_no, line_cd, iss_cd, subline_cd, SUM(prem_amt) prem_amt 
                  FROM gicl_lratio_prev_prem_ext
                 WHERE session_id = p_session_id
                 GROUP BY session_id, policy_id, assd_no, line_cd, iss_cd, subline_cd)
      LOOP
         FOR rec IN (SELECT get_policy_no(i.policy_id) policy_no,
                            endt_iss_cd, endt_yy, endt_seq_no, incept_date, expiry_date, tsi_amt,
                            issue_date, acct_ent_date, TO_CHAR(TO_DATE(booking_mth,'MONTH'),'MON')||' '||TO_CHAR(booking_year) booking_date           
                       FROM gipi_polbasic
                      WHERE policy_id = i.policy_id)
         LOOP
            lr_prev_prem.policy_no := rec.policy_no;
            lr_prev_prem.nbt_incept_date := TO_CHAR(rec.incept_date,'MM-DD-RRRR');
            lr_prev_prem.nbt_expiry_date := TO_CHAR(rec.expiry_date,'MM-DD-RRRR');
            lr_prev_prem.nbt_tsi_amt := rec.tsi_amt;
            
            IF p_prnt_date = 1 THEN
    	       lr_prev_prem.nbt_date := TO_CHAR(rec.issue_date,'MM-DD-RRRR');
            ELSIF p_prnt_date = 3 THEN
    	       lr_prev_prem.nbt_date := TO_CHAR(rec.acct_ent_date,'MM-DD-RRRR');
            ELSIF p_prnt_date = 4 THEN
    	       lr_prev_prem.nbt_date := rec.booking_date;
            END IF;
         END LOOP;
         
         lr_prev_prem.prem_amt := i.prem_amt;
         
         FOR ass IN (SELECT assd_name 
                       FROM giis_assured
                      WHERE assd_no = i.assd_no)
         LOOP
            lr_prev_prem.nbt_assured := ass.assd_name;
         END LOOP;  
         
         PIPE ROW(lr_prev_prem);
      END LOOP;
   END;
   
   FUNCTION get_lr_curr_os_prl(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE
   ) RETURN lr_os_prl_tab PIPELINED AS
      lr_curr_os_prl        lr_os_prl_type;
   BEGIN
      FOR i IN (SELECT line_cd, assd_no, session_id, claim_id, peril_cd, SUM(os_amt) os_amt 
                  FROM gicl_lratio_curr_os_ext
                 WHERE session_id = p_session_id
                 GROUP BY claim_id, session_id,assd_no,line_cd,peril_cd)
      LOOP
         lr_curr_os_prl.os_amt := i.os_amt;
      
         FOR rec IN (SELECT line_cd||'-'||subline_cd||'-'||iss_cd||'-'||LTRIM(TO_CHAR(clm_yy, '09'))||'-'||LTRIM(TO_CHAR(clm_seq_no, '0000009')) claim_no,
                            dsp_loss_date, clm_file_date
                       FROM gicl_claims
                      WHERE claim_id = i.claim_id)
         LOOP
            lr_curr_os_prl.nbt_claim_no := rec.claim_no;
            lr_curr_os_prl.nbt_loss_date := TO_CHAR(rec.dsp_loss_date,'MM-DD-RRRR');
            lr_curr_os_prl.nbt_file_date := TO_CHAR(rec.clm_file_date,'MM-DD-RRRR');
         END LOOP;

         FOR ass IN (SELECT assd_name 
                       FROM giis_assured
                      WHERE assd_no = i.assd_no)
         LOOP
            lr_curr_os_prl.nbt_assured := ass.assd_name;
         END LOOP;
  
         FOR rec IN (SELECT peril_name
                       FROM giis_peril  
                      WHERE peril_cd = i.peril_cd
                        AND line_cd = i.line_cd)
         LOOP
  	        lr_curr_os_prl.nbt_peril_name := rec.peril_name;
         END LOOP;
         
         PIPE ROW(lr_curr_os_prl);
      END LOOP;
   END;
   
   FUNCTION get_lr_curr_os_intm(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE
   ) RETURN lr_os_intm_tab PIPELINED AS
      lr_curr_os_intm       lr_os_intm_type;
   BEGIN
      FOR i IN (SELECT line_cd, assd_no, SUM(os_amt) os_amt, session_id, claim_id , intm_no 
                  FROM gicl_lratio_curr_os_ext
                 WHERE session_id = p_session_id
                 GROUP BY claim_id, session_id, assd_no, line_cd, intm_no)
      LOOP
         lr_curr_os_intm.os_amt := i.os_amt;
      
         FOR rec IN (SELECT line_cd||'-'||subline_cd||'-'||iss_cd||'-'||LTRIM(TO_CHAR(clm_yy, '09'))||'-'||LTRIM(TO_CHAR(clm_seq_no, '0000009')) claim_no,
                            dsp_loss_date, clm_file_date
                       FROM gicl_claims
                      WHERE claim_id = i.claim_id)
         LOOP
            lr_curr_os_intm.nbt_claim_no := rec.claim_no;
            lr_curr_os_intm.nbt_loss_date := TO_CHAR(rec.dsp_loss_date,'MM-DD-RRRR');
            lr_curr_os_intm.nbt_file_date := TO_CHAR(rec.clm_file_date,'MM-DD-RRRR');
         END LOOP;

         FOR ass IN (SELECT assd_name 
                       FROM giis_assured
                      WHERE assd_no = i.assd_no)
         LOOP
            lr_curr_os_intm.nbt_assured := ass.assd_name;
         END LOOP;
  
         FOR rec IN (SELECT intm_name
                       FROM giis_intermediary
                      WHERE intm_no = i.intm_no)
         LOOP
            lr_curr_os_intm.nbt_intm := rec.intm_name;
         END LOOP;
         
         PIPE ROW(lr_curr_os_intm); 
      END LOOP;
   END;
   
   FUNCTION get_lr_curr_os(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE
   ) RETURN lr_os_tab PIPELINED AS
      lr_curr_os            lr_os_type;
   BEGIN
      FOR i IN (SELECT line_cd, assd_no, SUM(os_amt) os_amt, session_id, claim_id 
                  FROM gicl_lratio_curr_os_ext
                 WHERE session_id = p_session_id
                 GROUP BY claim_id, session_id,assd_no,line_cd)
      LOOP
         lr_curr_os.os_amt := i.os_amt;
      
         FOR rec IN (SELECT line_cd||'-'||subline_cd||'-'||iss_cd||'-'||LTRIM(TO_CHAR(clm_yy, '09'))||'-'||LTRIM(TO_CHAR(clm_seq_no, '0000009')) claim_no,
                            dsp_loss_date, clm_file_date
                       FROM gicl_claims
                      WHERE claim_id = i.claim_id)
         LOOP
            lr_curr_os.nbt_claim_no := rec.claim_no;
            lr_curr_os.nbt_loss_date := TO_CHAR(rec.dsp_loss_date,'MM-DD-RRRR');
            lr_curr_os.nbt_file_date := TO_CHAR(rec.clm_file_date,'MM-DD-RRRR');
         END LOOP;

         FOR ass IN (SELECT assd_name 
                       FROM giis_assured
                      WHERE assd_no = i.assd_no)
         LOOP
            lr_curr_os.nbt_assured := ass.assd_name;
         END LOOP;
         
         PIPE ROW(lr_curr_os);
      END LOOP;
   END;
   
   FUNCTION get_lr_prev_os_prl(
      p_session_id          gicl_lratio_prev_prem_ext.session_id%TYPE
   ) RETURN lr_os_prl_tab PIPELINED AS
      lr_prev_os_prl        lr_os_prl_type;
   BEGIN
      FOR i IN (SELECT line_cd, assd_no, SUM(os_amt) os_amt, session_id, claim_id, peril_cd 
                  FROM gicl_lratio_prev_os_ext
                 WHERE session_id = p_session_id
                 GROUP BY claim_id, session_id, assd_no, line_cd, peril_cd)
      LOOP
         lr_prev_os_prl.os_amt := i.os_amt;
      
         FOR rec IN (SELECT line_cd||'-'||subline_cd||'-'||iss_cd||'-'||LTRIM(TO_CHAR(clm_yy, '09'))||'-'||LTRIM(TO_CHAR(clm_seq_no, '0000009')) claim_no,
                            dsp_loss_date, clm_file_date
                       FROM gicl_claims
                      WHERE claim_id = i.claim_id)
         LOOP
            lr_prev_os_prl.nbt_claim_no := rec.claim_no;
            lr_prev_os_prl.nbt_loss_date := TO_CHAR(rec.dsp_loss_date,'MM-DD-RRRR');
            lr_prev_os_prl.nbt_file_date := TO_CHAR(rec.clm_file_date,'MM-DD-RRRR');
         END LOOP;

         FOR rec IN (SELECT peril_name      
                       FROM giis_peril
                      WHERE line_cd = i.line_cd
                        AND peril_cd = i.peril_cd)
         LOOP
            lr_prev_os_prl.nbt_peril_name := rec.peril_name;
         END LOOP;

         FOR ass IN (SELECT assd_name 
                       FROM giis_assured
                      WHERE assd_no = i.assd_no)
         LOOP
            lr_prev_os_prl.nbt_assured := ass.assd_name;
         END LOOP;
         
         PIPE ROW(lr_prev_os_prl);
      END LOOP;
   END;
   
   FUNCTION get_lr_prev_os_intm(
      p_session_id          gicl_lratio_prev_prem_ext.session_id%TYPE
   ) RETURN lr_os_intm_tab PIPELINED AS
      lr_prev_os_intm       lr_os_intm_type;
   BEGIN
      FOR i IN (SELECT line_cd, assd_no, SUM(os_amt) os_amt, session_id, claim_id , intm_no 
                  FROM gicl_lratio_prev_os_ext
                 WHERE session_id = p_session_id
                 GROUP BY claim_id, session_id, assd_no, line_cd, intm_no)
      LOOP
         lr_prev_os_intm.os_amt := i.os_amt;
      
         FOR rec IN (SELECT line_cd||'-'||subline_cd||'-'||iss_cd||'-'||LTRIM(TO_CHAR(clm_yy, '09'))||'-'||LTRIM(TO_CHAR(clm_seq_no, '0000009')) claim_no,
                            dsp_loss_date, clm_file_date
                       FROM gicl_claims
                      WHERE claim_id = i.claim_id)
         LOOP
            lr_prev_os_intm.nbt_claim_no := rec.claim_no;
            lr_prev_os_intm.nbt_loss_date := TO_CHAR(rec.dsp_loss_date,'MM-DD-RRRR');
            lr_prev_os_intm.nbt_file_date := TO_CHAR(rec.clm_file_date,'MM-DD-RRRR');
         END LOOP;

         FOR ass IN (SELECT assd_name 
                       FROM giis_assured
                      WHERE assd_no = i.assd_no)
         LOOP
            lr_prev_os_intm.nbt_assured := ass.assd_name;
         END LOOP;
  
         FOR rec IN (SELECT intm_name
                       FROM giis_intermediary
                      WHERE intm_no = i.intm_no)
         LOOP
            lr_prev_os_intm.nbt_intm := rec.intm_name;
         END LOOP;
         
         PIPE ROW(lr_prev_os_intm); 
      END LOOP;
   END;       
   
   FUNCTION get_lr_prev_os(
      p_session_id          gicl_lratio_prev_prem_ext.session_id%TYPE
   ) RETURN lr_os_tab PIPELINED AS
      lr_prev_os            lr_os_type;
   BEGIN
      FOR i IN (SELECT line_cd, assd_no, SUM(os_amt) os_amt, session_id, claim_id 
                  FROM gicl_lratio_prev_os_ext
                 WHERE session_id = p_session_id
                 GROUP BY claim_id, session_id, assd_no, line_cd)
      LOOP
         lr_prev_os.os_amt := i.os_amt;
      
         FOR rec IN (SELECT line_cd||'-'||subline_cd||'-'||iss_cd||'-'||LTRIM(TO_CHAR(clm_yy, '09'))||'-'||LTRIM(TO_CHAR(clm_seq_no, '0000009')) claim_no,
                            dsp_loss_date, clm_file_date
                       FROM gicl_claims
                      WHERE claim_id = i.claim_id)
         LOOP
            lr_prev_os.nbt_claim_no := rec.claim_no;
            lr_prev_os.nbt_loss_date := TO_CHAR(rec.dsp_loss_date,'MM-DD-RRRR');
            lr_prev_os.nbt_file_date := TO_CHAR(rec.clm_file_date,'MM-DD-RRRR');
         END LOOP;

         FOR ass IN (SELECT assd_name 
                       FROM giis_assured
                      WHERE assd_no = i.assd_no)
         LOOP
            lr_prev_os.nbt_assured := ass.assd_name;
         END LOOP;
         
         PIPE ROW(lr_prev_os);
      END LOOP;
   END;
   
   FUNCTION get_lr_loss_paid_prl(
      p_session_id          gicl_lratio_loss_paid_ext.session_id%TYPE
   ) RETURN lr_loss_paid_prl_tab PIPELINED AS
      lr_loss_paid_prl      lr_loss_paid_prl_type;
   BEGIN
      FOR i IN (SELECT claim_id, session_id, assd_no, line_cd, iss_cd, subline_cd, SUM(loss_paid) loss_paid, peril_cd 
                  FROM gicl_lratio_loss_paid_ext
                 WHERE session_id = p_session_id
                 GROUP BY claim_id, session_id, assd_no, line_cd, iss_cd, subline_cd, peril_cd)
      LOOP
         lr_loss_paid_prl.loss_paid := i.loss_paid;
      
         FOR rec IN (SELECT line_cd||'-'||subline_cd||'-'||iss_cd||'-'||LTRIM(TO_CHAR(clm_yy, '09'))||'-'||LTRIM(TO_CHAR(clm_seq_no, '0000009')) claim,
                            dsp_loss_date
                       FROM gicl_claims
                      WHERE claim_id = i.claim_id)
         LOOP
            lr_loss_paid_prl.nbt_claim_no := rec.claim;
            lr_loss_paid_prl.nbt_loss_date := TO_CHAR(rec.dsp_loss_date,'MM-DD-RRRR');
         END LOOP;

         FOR rec IN (SELECT peril_name      
                       FROM giis_peril
                      WHERE peril_cd = i.peril_cd
                        AND line_cd = i.line_cd)
         LOOP
            lr_loss_paid_prl.nbt_peril_name := rec.peril_name;
         END LOOP;

         FOR ass IN (SELECT assd_name
                       FROM giis_assured
                      WHERE assd_no = i.assd_no)
         LOOP
            lr_loss_paid_prl.nbt_assured := ass.assd_name;
         END LOOP;
         
         PIPE ROW(lr_loss_paid_prl);
      END LOOP;
   END;
   
   FUNCTION get_lr_loss_paid_intm(
      p_session_id          gicl_lratio_loss_paid_ext.session_id%TYPE
   ) RETURN lr_loss_paid_intm_tab PIPELINED AS
      lr_loss_paid_intm      lr_loss_paid_intm_type;
   BEGIN
      FOR i IN (SELECT claim_id, session_id, assd_no, line_cd, iss_cd, subline_cd, SUM(loss_paid) loss_paid, intm_no 
                  FROM gicl_lratio_loss_paid_ext
                 WHERE session_id = p_session_id
                 GROUP BY claim_id, session_id, assd_no, line_cd, iss_cd, subline_cd, intm_no)
      LOOP
         lr_loss_paid_intm.loss_paid := i.loss_paid;
      
         FOR rec IN (SELECT line_cd||'-'||subline_cd||'-'||iss_cd||'-'||LTRIM(TO_CHAR(clm_yy, '09'))||'-'||LTRIM(TO_CHAR(clm_seq_no, '0000009')) claim,
                            dsp_loss_date
                       FROM gicl_claims
                      WHERE claim_id = i.claim_id)
         LOOP
            lr_loss_paid_intm.nbt_claim_no := rec.claim;
            lr_loss_paid_intm.nbt_loss_date := TO_CHAR(rec.dsp_loss_date,'MM-DD-RRRR');
         END LOOP;

         FOR ass IN (SELECT assd_name
                       FROM giis_assured
                      WHERE assd_no = i.assd_no)
         LOOP
            lr_loss_paid_intm.nbt_assured := ass.assd_name;
         END LOOP;

         FOR rec IN (SELECT intm_name
                       FROM giis_intermediary
                      WHERE intm_no = i.intm_no)
         LOOP
            lr_loss_paid_intm.nbt_intm := rec.intm_name;
         END LOOP;
         
         PIPE ROW(lr_loss_paid_intm);     
      END LOOP;
   END; 
   
   FUNCTION get_lr_loss_paid(
      p_session_id          gicl_lratio_loss_paid_ext.session_id%TYPE
   ) RETURN lr_loss_paid_tab PIPELINED AS
      lr_loss_paid          lr_loss_paid_type;
   BEGIN
      FOR i IN (SELECT claim_id, session_id, assd_no, line_cd, iss_cd, subline_cd, SUM(loss_paid) loss_paid 
                  FROM gicl_lratio_loss_paid_ext
                 WHERE session_id = p_session_id
                 GROUP BY claim_id, session_id, assd_no, line_cd, iss_cd, subline_cd)
      LOOP
         lr_loss_paid.loss_paid := i.loss_paid;
         
         FOR rec IN (SELECT line_cd||'-'||subline_cd||'-'||iss_cd||'-'||LTRIM(TO_CHAR(clm_yy, '09'))||'-'||LTRIM(TO_CHAR(clm_seq_no, '0000009')) claim_no,
                            dsp_loss_date
                       FROM gicl_claims
                      WHERE claim_id = i.claim_id)
         LOOP
            lr_loss_paid.nbt_claim_no := rec.claim_no;
            lr_loss_paid.nbt_loss_date := TO_CHAR(rec.dsp_loss_date,'MM-DD-RRRR');
         END LOOP;

         FOR ass IN (SELECT assd_name
                       FROM giis_assured
                      WHERE assd_no = i.assd_no)
         LOOP
            lr_loss_paid.nbt_assured := ass.assd_name;
         END LOOP;
         
         PIPE ROW(lr_loss_paid);
      END LOOP;
   END;
   
   FUNCTION get_lr_curr_rec_prl(
      p_session_id          gicl_lratio_curr_recovery_ext.session_id%TYPE
   ) RETURN lr_rec_prl_tab PIPELINED AS
      lr_curr_rec_prl       lr_rec_prl_type;
   BEGIN
      FOR i IN (SELECT session_id, recovery_id, assd_no, line_cd, iss_cd, subline_cd, SUM(recovered_amt) recovered_amt, peril_cd 
                  FROM gicl_lratio_curr_recovery_ext
                 WHERE session_id = p_session_id
                 GROUP BY session_id, recovery_id, assd_no, line_cd, iss_cd, subline_cd, peril_cd)
      LOOP
         lr_curr_rec_prl.recovered_amt := i.recovered_amt;
         
         FOR rec IN (SELECT b.line_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009')) recovery,
                            a.dsp_loss_date, b.rec_type_cd 
                       FROM gicl_claims a, gicl_clm_recovery b
                      WHERE b.recovery_id = i.recovery_id
                        AND a.claim_id = b.claim_id)
         LOOP
            lr_curr_rec_prl.nbt_rec_no := rec.recovery;
            lr_curr_rec_prl.nbt_date_recovered := TO_CHAR(rec.dsp_loss_date,'MM-DD-RRRR');
            
            FOR type IN (SELECT rec_type_desc     
                           FROM giis_recovery_type
                          WHERE rec_type_cd = rec.rec_type_cd)
            LOOP
               lr_curr_rec_prl.nbt_rec_type := type.rec_type_desc;
            END LOOP;
         END LOOP;

         FOR ass IN (SELECT assd_name
                       FROM giis_assured
                      WHERE assd_no = i.assd_no)
         LOOP
            lr_curr_rec_prl.nbt_assured := ass.assd_name;
         END LOOP;
  
         FOR rec IN (SELECT peril_name      
                       FROM giis_peril
                      WHERE peril_cd = i.peril_cd
                        AND line_cd = i.line_cd)
         LOOP
            lr_curr_rec_prl.nbt_peril_name := rec.peril_name;
         END LOOP;
         
         PIPE ROW(lr_curr_rec_prl);
      END LOOP;
   END;
   
   FUNCTION get_lr_curr_rec_intm(
      p_session_id          gicl_lratio_curr_recovery_ext.session_id%TYPE
   ) RETURN lr_rec_intm_tab PIPELINED AS
      lr_curr_rec_intm      lr_rec_intm_type;
   BEGIN
      FOR i IN (SELECT session_id, recovery_id, assd_no, line_cd, iss_cd, subline_cd, SUM(recovered_amt) recovered_amt, intm_no 
                  FROM gicl_lratio_curr_recovery_ext
                 WHERE session_id = p_session_id
                 GROUP BY session_id, recovery_id, assd_no, line_cd, iss_cd, subline_cd, intm_no)
      LOOP
         lr_curr_rec_intm.recovered_amt := i.recovered_amt;
      
         FOR rec IN (SELECT b.line_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009')) recovery,
                            a.dsp_loss_date, b.rec_type_cd 
                       FROM gicl_claims a, gicl_clm_recovery b
                      WHERE b.recovery_id = i.recovery_id
                        AND a.claim_id = b.claim_id)
         LOOP
            lr_curr_rec_intm.nbt_rec_no := rec.recovery;
            lr_curr_rec_intm.nbt_date_recovered := TO_CHAR(rec.dsp_loss_date,'MM-DD-RRRR');
            
            FOR type IN (SELECT rec_type_desc     
                           FROM giis_recovery_type
                          WHERE rec_type_cd = rec.rec_type_cd)
            LOOP
               lr_curr_rec_intm.nbt_rec_type := type.rec_type_desc;
            END LOOP;
         END LOOP;

         FOR ass IN (SELECT assd_name
                       FROM giis_assured
                      WHERE assd_no = i.assd_no)
         LOOP
            lr_curr_rec_intm.nbt_assured := ass.assd_name;
         END LOOP;
  
         FOR rec IN (SELECT intm_name
                       FROM giis_intermediary
                      WHERE intm_no = i.intm_no)
         LOOP
            lr_curr_rec_intm.nbt_intm := rec.intm_name;
         END LOOP;
         
         PIPE ROW(lr_curr_rec_intm);     
      END LOOP;
   END;
   
   FUNCTION get_lr_curr_rec(
      p_session_id          gicl_lratio_curr_recovery_ext.session_id%TYPE
   ) RETURN lr_rec_tab PIPELINED AS
      lr_curr_rec           lr_rec_type;
   BEGIN
      FOR i IN (SELECT session_id, recovery_id, assd_no, line_cd, iss_cd, subline_cd, SUM(recovered_amt) recovered_amt 
                  FROM gicl_lratio_curr_recovery_ext
                 WHERE session_id = p_session_id
                 GROUP BY session_id, recovery_id, assd_no, line_cd, iss_cd, subline_cd)
      LOOP
         lr_curr_rec.recovered_amt := i.recovered_amt; 
      
         FOR rec IN (SELECT b.line_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009')) recovery,
                            a.dsp_loss_date, b.rec_type_cd 
                       FROM gicl_claims a, gicl_clm_recovery b
                      WHERE b.recovery_id = i.recovery_id
                        AND a.claim_id = b.claim_id)
         LOOP
            lr_curr_rec.nbt_rec_no := rec.recovery;
            lr_curr_rec.nbt_date_recovered := TO_CHAR(rec.dsp_loss_date,'MM-DD-RRRR');
            
            FOR type IN (SELECT rec_type_desc     
                           FROM giis_recovery_type
                          WHERE rec_type_cd = rec.rec_type_cd)
            LOOP
               lr_curr_rec.nbt_rec_type := type.rec_type_desc;
            END LOOP;
         END LOOP;

         FOR ass IN (SELECT assd_name
                       FROM giis_assured
                      WHERE assd_no = i.assd_no)
         LOOP
            lr_curr_rec.nbt_assured := ass.assd_name;
         END LOOP;
         
         PIPE ROW(lr_curr_rec);
      END LOOP;
   END;
   
   FUNCTION get_lr_prev_rec_prl(
      p_session_id          gicl_lratio_prev_recovery_ext.session_id%TYPE
   ) RETURN lr_rec_prl_tab PIPELINED AS
      lr_prev_rec_prl       lr_rec_prl_type;
   BEGIN
      FOR i IN (SELECT session_id, recovery_id, assd_no, line_cd, iss_cd, subline_cd, SUM(recovered_amt) recovered_amt, peril_cd 
                  FROM gicl_lratio_prev_recovery_ext
                 WHERE session_id = p_session_id
                 GROUP BY session_id, recovery_id, assd_no, line_cd, iss_cd, subline_cd, peril_cd)
      LOOP
         lr_prev_rec_prl.recovered_amt := i.recovered_amt;
         
         FOR rec IN (SELECT b.line_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009')) recovery,
                            a.dsp_loss_date, b.rec_type_cd
                       FROM gicl_claims a, gicl_clm_recovery b
                      WHERE b.recovery_id = i.recovery_id
                        AND a.claim_id = b.claim_id)
         LOOP
            lr_prev_rec_prl.nbt_rec_no := rec.recovery;
            lr_prev_rec_prl.nbt_date_recovered := TO_CHAR(rec.dsp_loss_date,'MM-DD-RRRR');
    
            FOR type IN (SELECT rec_type_desc     
                           FROM giis_recovery_type
                          WHERE rec_type_cd = rec.rec_type_cd)
            LOOP
               lr_prev_rec_prl.nbt_rec_type := type.rec_type_desc;
            END LOOP;
         END LOOP;

         FOR ass IN (SELECT assd_name 
                       FROM giis_assured
                      WHERE assd_no = i.assd_no)
         LOOP
            lr_prev_rec_prl.nbt_assured := ass.assd_name;
         END LOOP;
  
         FOR rec IN (SELECT peril_name      
                       FROM giis_peril
                      WHERE peril_cd = i.peril_cd
                        AND line_cd = i.line_cd)
         LOOP
            lr_prev_rec_prl.nbt_peril_name := rec.peril_name;
         END LOOP;
         
         PIPE ROW(lr_prev_rec_prl);
      END LOOP;
   END;
   
   FUNCTION get_lr_prev_rec_intm(
      p_session_id          gicl_lratio_prev_recovery_ext.session_id%TYPE
   ) RETURN lr_rec_intm_tab PIPELINED AS 
      lr_prev_rec_intm      lr_rec_intm_type;
   BEGIN
      FOR i IN (SELECT session_id, recovery_id, assd_no, line_cd, iss_cd, subline_cd, SUM(recovered_amt) recovered_amt, intm_no 
                  FROM gicl_lratio_prev_recovery_ext
                 WHERE session_id = p_session_id
                 GROUP BY session_id, recovery_id, assd_no, line_cd, iss_cd, subline_cd, intm_no)
      LOOP
         lr_prev_rec_intm.recovered_amt := i.recovered_amt;
         
         FOR rec IN (SELECT b.line_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009')) recovery,
                            a.dsp_loss_date, b.rec_type_cd
                       FROM gicl_claims a, gicl_clm_recovery b
                      WHERE b.recovery_id = i.recovery_id
                        AND a.claim_id = b.claim_id)
         LOOP
            lr_prev_rec_intm.nbt_rec_no := rec.recovery;
            lr_prev_rec_intm.nbt_date_recovered := TO_CHAR(rec.dsp_loss_date,'MM-DD-RRRR');
    
            FOR type IN (SELECT rec_type_desc     
                           FROM giis_recovery_type
                          WHERE rec_type_cd = rec.rec_type_cd)
            LOOP
               lr_prev_rec_intm.nbt_rec_type := type.rec_type_desc;
            END LOOP;
         END LOOP;

         FOR ass IN (SELECT assd_name 
                       FROM giis_assured
                      WHERE assd_no = i.assd_no)
         LOOP
            lr_prev_rec_intm.nbt_assured := ass.assd_name;
         END LOOP;
  
         FOR rec IN (SELECT intm_name
                       FROM giis_intermediary
                      WHERE intm_no = i.intm_no)
         LOOP
            lr_prev_rec_intm.nbt_intm := rec.intm_name;
         END LOOP;
         
         PIPE ROW(lr_prev_rec_intm);   
      END LOOP;
   END;
   
   FUNCTION get_lr_prev_rec(
      p_session_id          gicl_lratio_prev_recovery_ext.session_id%TYPE
   ) RETURN lr_rec_tab PIPELINED AS 
      lr_prev_rec           lr_rec_type;
   BEGIN
      FOR i IN (SELECT session_id, recovery_id, assd_no, line_cd, iss_cd, subline_cd, SUM(recovered_amt) recovered_amt 
                  FROM gicl_lratio_prev_recovery_ext
                 WHERE session_id = p_session_id
                 GROUP BY session_id, recovery_id, assd_no, line_cd, iss_cd, subline_cd)
      LOOP
         lr_prev_rec.recovered_amt := i.recovered_amt;
         
         FOR rec IN (SELECT b.line_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009')) recovery,
                            a.dsp_loss_date, b.rec_type_cd
                       FROM gicl_claims a, gicl_clm_recovery b
                      WHERE b.recovery_id = i.recovery_id
                        AND a.claim_id = b.claim_id)
         LOOP
            lr_prev_rec.nbt_rec_no := rec.recovery;
            lr_prev_rec.nbt_date_recovered := TO_CHAR(rec.dsp_loss_date,'MM-DD-RRRR');
    
            FOR type IN (SELECT rec_type_desc     
                           FROM giis_recovery_type
                          WHERE rec_type_cd = rec.rec_type_cd)
            LOOP
               lr_prev_rec.nbt_rec_type := type.rec_type_desc;
            END LOOP;
         END LOOP;

         FOR ass IN (SELECT assd_name 
                       FROM giis_assured
                      WHERE assd_no = i.assd_no)
         LOOP
            lr_prev_rec.nbt_assured := ass.assd_name;
         END LOOP;
         
         PIPE ROW(lr_prev_rec);
      END LOOP;
   END;
END GICLS205_PKG;
/


