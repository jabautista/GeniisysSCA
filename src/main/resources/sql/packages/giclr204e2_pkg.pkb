CREATE OR REPLACE PACKAGE BODY CPI.GICLR204E2_PKG
AS
   FUNCTION get_company_details
   RETURN company_details_tab PIPELINED AS
      co                    company_details_type;
   BEGIN
      co.company_name    := giisp.v('COMPANY_NAME');
      co.company_address := giisp.v('COMPANY_ADDRESS');

      PIPE ROW (co);
   END;
   
   FUNCTION get_curr_prem(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN prem_details_tab PIPELINED AS
      cp                    prem_details_type;
   BEGIN
      FOR i IN (SELECT b.assd_no, get_policy_no(a.policy_id) policy_no, a.endt_iss_cd, a.endt_yy, a.endt_seq_no, 
                       a.incept_date, a.expiry_date, a.tsi_amt, SUM(b.prem_amt) sum_prem_amt, c.assd_name, a.policy_id
                  FROM gipi_polbasic a, gicl_lratio_curr_prem_ext b, giis_assured c
                 WHERE b.policy_id = a.policy_id
                   AND b.assd_no = c.assd_no(+)
                   AND b.session_id = p_session_id
                 GROUP BY b.assd_no, get_policy_no(a.policy_id), a.endt_iss_cd, a.endt_yy, a.endt_seq_no, 
                          a.incept_date, a.expiry_date, a.tsi_amt, c.assd_name, a.policy_id
                 ORDER BY 1, 2)
      LOOP
         cp.assd_no := i.assd_no;
         cp.policy_no := i.policy_no;
         cp.endt_iss_cd := i.endt_iss_cd;
         cp.endt_yy := i.endt_yy;
         cp.endt_seq_no := i.endt_seq_no;          
         cp.incept_date := i.incept_date;
         cp.expiry_date := i.expiry_date;           
         cp.tsi_amt := i.tsi_amt;           
         cp.sum_prem_amt := i.sum_prem_amt;           
         cp.assd_name := i.assd_name;          
         cp.policy_id := i.policy_id;
         
         IF p_prnt_date = '1' THEN
            cp.date_label := 'Issue Date';
            
            FOR rec IN (SELECT issue_date
  	                      FROM gipi_polbasic
  	                     WHERE policy_id = i.policy_id)
  	        LOOP
  	           cp.cf_date := TO_CHAR(rec.issue_date,'MM-DD-RRRR');
  	        END LOOP;
         ELSIF p_prnt_date = '3' THEN 
            cp.date_label := 'Acct Ent Date';
            
            FOR rec IN (SELECT acct_ent_date
  	                      FROM gipi_polbasic
  	                     WHERE policy_id = i.policy_id)
  	        LOOP
  	           cp.cf_date := TO_CHAR(rec.acct_ent_date,'MM-DD-RRRR');
  	        END LOOP;
         ELSIF p_prnt_date = '4' THEN
            cp.date_label := 'Booking Date';
            
            FOR rec IN (SELECT booking_mth||' '||TO_CHAR(booking_year) booking_date
  	                      FROM gipi_polbasic
  	                     WHERE policy_id = i.policy_id)
  	        LOOP
  	           cp.cf_date := rec.booking_date;  	   
  	        END LOOP;
         END IF;
         
         PIPE ROW(cp);
      END LOOP;
   END;
   
   FUNCTION get_prev_prem(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN prem_details_tab PIPELINED AS
      pp                    prem_details_type;
   BEGIN
      FOR i IN (SELECT b.assd_no, get_policy_no(a.policy_id) policy_no, a.endt_iss_cd, a.endt_yy, a.endt_seq_no, 
                       a.incept_date, a.expiry_date, a.tsi_amt, SUM(b.prem_amt) sum_prem_amt, c.assd_name, a.policy_id
                  FROM gipi_polbasic a, gicl_lratio_prev_prem_ext b, giis_assured c
                 WHERE b.policy_id = a.policy_id
                   AND b.assd_no = c.assd_no(+)
                   AND b.session_id = p_session_id
                 GROUP BY b.assd_no, get_policy_no(a.policy_id), a.endt_iss_cd, a.endt_yy, a.endt_seq_no, 
                          a.incept_date, a.expiry_date, a.tsi_amt, c.assd_name, a.policy_id
                 ORDER BY 1, 2)
      LOOP
         pp.assd_no := i.assd_no;
         pp.policy_no := i.policy_no;
         pp.endt_iss_cd := i.endt_iss_cd;
         pp.endt_yy := i.endt_yy;
         pp.endt_seq_no := i.endt_seq_no;          
         pp.incept_date := i.incept_date;
         pp.expiry_date := i.expiry_date;           
         pp.tsi_amt := i.tsi_amt;           
         pp.sum_prem_amt := i.sum_prem_amt;           
         pp.assd_name := i.assd_name;          
         pp.policy_id := i.policy_id;
         
         IF p_prnt_date = '1' THEN
            pp.date_label := 'Issue Date';
            
            FOR rec IN (SELECT issue_date
  	                      FROM gipi_polbasic
  	                     WHERE policy_id = i.policy_id)
  	        LOOP
  	           pp.cf_date := TO_CHAR(rec.issue_date,'MM-DD-RRRR');
  	        END LOOP;
         ELSIF p_prnt_date = '3' THEN 
            pp.date_label := 'Acct Ent Date';
            
            FOR rec IN (SELECT acct_ent_date
  	                      FROM gipi_polbasic
  	                     WHERE policy_id = i.policy_id)
  	        LOOP
  	           pp.cf_date := TO_CHAR(rec.acct_ent_date,'MM-DD-RRRR');
  	        END LOOP;
         ELSIF p_prnt_date = '4' THEN
            pp.date_label := 'Booking Date';
            
            FOR rec IN (SELECT booking_mth||' '||TO_CHAR(booking_year) booking_date
  	                      FROM gipi_polbasic
  	                     WHERE policy_id = i.policy_id)
  	        LOOP
  	           pp.cf_date := rec.booking_date;  	   
  	        END LOOP;
         END IF;
         
         PIPE ROW(pp);
      END LOOP;
   END;
   
   FUNCTION get_curr_os(
      p_session_id          gicl_lratio_curr_os_ext.session_id%TYPE
   ) RETURN os_details_tab PIPELINED AS
      co                    os_details_type;
   BEGIN
      FOR i IN (SELECT a.assd_no, d.assd_name, a.claim_id, SUM(os_amt) sum_os_amt, b.dsp_loss_date, b.clm_file_date, 
                       b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009')) claim_no
                  FROM gicl_lratio_curr_os_ext a, gicl_claims b, giis_assured d
                 WHERE a.session_id = p_session_id
                   AND a.claim_id = b.claim_id 
                   AND a.assd_no = d.assd_no
                 GROUP BY a.assd_no, d.assd_name, a.claim_id, b.dsp_loss_date, b.clm_file_date,
                          b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009')) 
                 ORDER BY 1, 6)
      LOOP
         co.assd_no := i.assd_no;
         co.assd_name := i.assd_name;
         co.claim_id := i.claim_id;
         co.sum_os_amt := i.sum_os_amt;
         co.dsp_loss_date := i.dsp_loss_date;
         co.clm_file_date := i.clm_file_date;
         co.claim_no := i.claim_no;
         
         PIPE ROW(co);
      END LOOP;
   END;
   
   FUNCTION get_prev_os(
      p_session_id          gicl_lratio_prev_os_ext.session_id%TYPE
   ) RETURN os_details_tab PIPELINED AS
      po                    os_details_type;
   BEGIN
      FOR i IN (SELECT a.assd_no, d.assd_name, a.claim_id, SUM(os_amt) sum_os_amt, b.dsp_loss_date, b.clm_file_date, 
                       b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009'))  claim_no
                  FROM gicl_lratio_prev_os_ext a, gicl_claims b, giis_assured d
                 WHERE a.session_id = p_session_id
                   AND a.claim_id = b.claim_id 
                   AND a.assd_no = d.assd_no
                 GROUP BY a.assd_no, d.assd_name, a.claim_id, b.dsp_loss_date, b.clm_file_date,
                          b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009')) 
                 ORDER BY 1, 6)
      LOOP
         po.assd_no := i.assd_no;
         po.assd_name := i.assd_name;
         po.claim_id := i.claim_id;
         po.sum_os_amt := i.sum_os_amt;
         po.dsp_loss_date := i.dsp_loss_date;
         po.clm_file_date := i.clm_file_date;
         po.claim_no := i.claim_no;
         
         PIPE ROW(po);
      END LOOP;
   END;
   
   FUNCTION get_loss_paid(
      p_session_id          gicl_lratio_loss_paid_ext.session_id%TYPE
   ) RETURN loss_paid_details_tab PIPELINED AS
      lp                    loss_paid_details_type;
   BEGIN
      FOR i IN (SELECT a.assd_no, c.assd_name, b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009'))  claim_no,
                       b.dsp_loss_date, SUM(a.loss_paid) sum_loss_paid
                  FROM gicl_lratio_loss_paid_ext a, gicl_claims b, giis_assured c
                 WHERE a.session_id = p_session_id
                   AND a.assd_no = c.assd_no
                   AND a.claim_id = b.claim_id
                 GROUP BY a.assd_no, c.assd_name, b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009')),
                          b.dsp_loss_date
                 ORDER BY 1, 3)
      LOOP
         lp.assd_no := i.assd_no;
         lp.assd_name := i.assd_name;
         lp.claim_no := i.claim_no;
         lp.dsp_loss_date := i.dsp_loss_date;
         lp.sum_loss_paid := i.sum_loss_paid;
         
         PIPE ROW(lp);
      END LOOP;
   END;                
   
   FUNCTION get_curr_rec(
      p_session_id          gicl_lratio_curr_recovery_ext.session_id%TYPE
   ) RETURN rec_details_tab PIPELINED AS
      cr                    rec_details_type;
   BEGIN
      FOR i IN (SELECT a.assd_no, b.assd_name, d.rec_type_desc, SUM(a.recovered_amt) sum_recovered_amt, e.dsp_loss_date,       
                       c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009')) recovery_no
                  FROM gicl_lratio_curr_recovery_ext a, giis_assured b, gicl_clm_recovery c, giis_recovery_type d, gicl_claims e
                 WHERE a.assd_no = b.assd_no
                   AND a.recovery_id = c.recovery_id
                   AND c.rec_type_cd = d.rec_type_cd
                   AND c.claim_id = e.claim_id
                   AND a.session_id = p_session_id
                 GROUP BY a.assd_no, b.assd_name, d.rec_type_desc, e.dsp_loss_date, 
                          c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009'))
                 ORDER BY 1, 5)
      LOOP
         cr.assd_no := i.assd_no;
         cr.assd_name := i.assd_name;
         cr.rec_type_desc := i.rec_type_desc;
         cr.sum_recovered_amt := i.sum_recovered_amt;
         cr.dsp_loss_date := i.dsp_loss_date;
         cr.recovery_no := i.recovery_no;
         
         PIPE ROW(cr);
      END LOOP;
   END;
   
   FUNCTION get_prev_rec(
      p_session_id          gicl_lratio_prev_recovery_ext.session_id%TYPE
   ) RETURN rec_details_tab PIPELINED AS
      pr                    rec_details_type;
   BEGIN
      FOR i IN (SELECT a.assd_no, b.assd_name, d.rec_type_desc, SUM(a.recovered_amt) sum_recovered_amt, e.dsp_loss_date, 
                       c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009')) recovery_no
                  FROM gicl_lratio_prev_recovery_ext a, giis_assured b, gicl_clm_recovery c, giis_recovery_type d, gicl_claims e
                 WHERE a.assd_no = b.assd_no
                   AND a.recovery_id = c.recovery_id
                   AND c.rec_type_cd = d.rec_type_cd
                   AND c.claim_id = e.claim_id
                   AND a.session_id = p_session_id
                 GROUP BY a.assd_no, b.assd_name, d.rec_type_desc, e.dsp_loss_date, 
                          c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009'))
                 ORDER BY 1, 5)
      LOOP
         pr.assd_no := i.assd_no;
         pr.assd_name := i.assd_name;
         pr.rec_type_desc := i.rec_type_desc;
         pr.sum_recovered_amt := i.sum_recovered_amt;
         pr.dsp_loss_date := i.dsp_loss_date;
         pr.recovery_no := i.recovery_no;
         
         PIPE ROW(pr);
      END LOOP;
   END;
   
END;
/


