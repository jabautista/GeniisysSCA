CREATE OR REPLACE PACKAGE BODY CPI.gicls261_pkg
AS
/* Created by : Aliza Garza
 * Date Created: 06.04.2013
 * Reference By: GICLS261 - Claim Payment Inquiry
 * Description: Package for Claim Payment Queries
 *
*/
   FUNCTION get_clmpol_lov (
      p_module_id    VARCHAR2,
      p_userid       VARCHAR2,
      p_line_cd      gicl_claims.line_cd%TYPE,
      p_subline_cd   gicl_claims.subline_cd%TYPE,
      p_iss_cd       gicl_claims.iss_cd%TYPE,
      p_pol_iss_cd   gicl_claims.iss_cd%TYPE,
      p_clm_yy       gicl_claims.issue_yy%TYPE,
      p_issue_yy     gicl_claims.issue_yy%TYPE,
      p_clm_seq_no   gicl_claims.clm_seq_no%TYPE,
      p_pol_seq_no   gicl_claims.clm_seq_no%TYPE,
      p_renew_no     gicl_claims.renew_no%TYPE,
      p_claim_id     gicl_claims.claim_id%TYPE,
      --added by MarkS SR-5833 11.9.2016 optimization
      p_find_text            VARCHAR2,
      p_order_by             VARCHAR2,
      p_asc_desc_flag      VARCHAR2,
      p_from                 NUMBER,
      p_to                   NUMBER,
      p_clm_line_cd        VARCHAR2,
      p_clm_subline_cd     VARCHAR2,
      p_assured_name       VARCHAR2
      --end
   )
      RETURN clmpol_lov_tab PIPELINED
   IS
      v_clmpollist   clmpol_lov_type;
      --added by MarkS SR-5833 11.9.2016 optimization
      TYPE cur_type IS REF CURSOR;
      c        cur_type;
      v_rec   clmpol_lov_type;
      v_sql   VARCHAR2(32767);
      --end
   BEGIN
   
--   added By MarkS 11.9.2016 SR5833 optimization

   v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (SELECT gc.claim_id, gc.line_cd, gc.subline_cd, gc.iss_cd, gc.pol_iss_cd, gc.clm_yy, 
                                           gc.issue_yy, gc.clm_seq_no, gc.pol_seq_no, gc.renew_no,(SELECT clm_stat_desc
                                                                                                    FROM giis_clm_stat
                                                                                                   WHERE clm_stat_cd = gc.clm_stat_cd) clm_stat_desc, 
                                           gc.dsp_loss_date, (SELECT loss_cat_des FROM giis_loss_ctgry
                                                              WHERE line_cd = gc.line_cd AND loss_cat_cd = gc.loss_cat_cd) loss_cat_des, 
                                           (SELECT assd_name FROM giis_assured WHERE assd_no = gc.assd_no) assd_name
                                        FROM gicl_claims gc 
                                        WHERE
                                        EXISTS (SELECT ''X'' FROM TABLE (security_access.get_branch_line (''CL'','''|| p_module_id ||''' ,'''|| p_userid ||''' ))
                                                WHERE LINE_CD= gc.line_cd and BRANCH_CD = gc.iss_cd) ';   
   IF p_line_cd IS NOT NULL THEN
        v_sql := v_sql || ' AND UPPER(line_cd) LIKE UPPER('''|| p_line_cd ||''') ';
    END  IF;
    
    IF p_subline_cd IS NOT NULL THEN
        v_sql := v_sql || ' AND UPPER(subline_cd) LIKE UPPER('''|| p_subline_cd ||''') ';
    END  IF;
    
    IF p_clm_line_cd IS NOT NULL THEN
        v_sql := v_sql || ' AND UPPER(line_cd) LIKE UPPER('''|| p_clm_line_cd ||''') ';
    END  IF;
    
    IF p_clm_subline_cd IS NOT NULL THEN
        v_sql := v_sql || ' AND UPPER(subline_cd) LIKE UPPER('''|| p_clm_subline_cd ||''') ';
    END  IF;
    
    IF p_iss_cd IS NOT NULL THEN
        v_sql := v_sql || ' AND UPPER(iss_cd) LIKE UPPER('''|| p_iss_cd ||''') ';
    END  IF;
    
    IF p_pol_iss_cd IS NOT NULL THEN
        v_sql := v_sql || ' AND UPPER(pol_iss_cd) LIKE UPPER('''|| p_pol_iss_cd ||''') ';
    END  IF;
    
    IF p_issue_yy IS NOT NULL THEN
        v_sql := v_sql || ' AND issue_yy LIKE '|| p_pol_iss_cd ||' ';
    END  IF;
    
    IF p_clm_yy IS NOT NULL THEN
        v_sql := v_sql || ' AND clm_yy LIKE '|| p_clm_yy ||' ';
    END  IF;
    
    IF p_clm_seq_no IS NOT NULL THEN
        v_sql := v_sql || ' AND clm_seq_no LIKE '|| p_clm_seq_no ||' ';
    END  IF;
    
    IF p_pol_seq_no IS NOT NULL THEN
        v_sql := v_sql || ' AND pol_seq_no LIKE '|| p_pol_seq_no ||' ';
    END  IF;
    
    IF p_renew_no IS NOT NULL THEN
        v_sql := v_sql || ' AND renew_no LIKE '|| p_renew_no ||' ';
    END  IF;
    
    IF p_claim_id IS NOT NULL THEN
        v_sql := v_sql || ' AND claim_id LIKE '|| p_claim_id ||' ';
    END  IF;
    
    IF p_assured_name IS NOT NULL THEN
        v_sql := v_sql || ' AND UPPER(assd_name) LIKE UPPER('''|| p_assured_name ||''') ';
    END  IF;
    IF p_find_text IS NOT NULL
      THEN
        v_sql := v_sql || ' AND ((SELECT assd_name FROM giis_assured WHERE assd_no = gc.assd_no) LIKE UPPER('''||p_find_text||''')
                              OR gc.line_cd LIKE UPPER('''||p_find_text||''')
                              OR gc.subline_cd LIKE UPPER('''||p_find_text||''')
                              OR gc.iss_cd LIKE UPPER('''||p_find_text||''')
                              OR gc.clm_yy LIKE UPPER('''||p_find_text||''')
                              OR gc.clm_seq_no LIKE UPPER('''||p_find_text||''')
                             )';
    END IF;                             
    IF p_order_by IS NOT NULL
      THEN
        IF p_order_by = 'claimNo'
        THEN
          v_sql := v_sql || ' ORDER BY line_cd, subline_cd, iss_cd, clm_yy, clm_seq_no '; 
        ELSIF p_order_by = 'policyNo'
        THEN
          v_sql := v_sql || ' ORDER BY line_cd, subline_cd, pol_iss_cd, issue_yy, pol_seq_no, renew_no ';
        ELSIF p_order_by = 'assuredName'
        THEN
          v_sql := v_sql || ' ORDER BY assd_name ';
        END IF;
        
        IF p_asc_desc_flag IS NOT NULL
        THEN
           v_sql := v_sql || p_asc_desc_flag;
        ELSE
           v_sql := v_sql || ' ASC';
        END IF;    
    END IF;                                    
   v_sql := v_sql ||             ' ) innersql ';                       
   v_sql := v_sql ||     ' ) outersql
                         ) mainsql
                    WHERE rownum_ BETWEEN '|| p_from ||' AND ' || p_to; 
                    
    OPEN c FOR v_sql;
    LOOP
         FETCH c INTO v_rec.count_, 
                      v_rec.rownum_,
                      v_rec.claim_id,
                      v_rec.line_cd,
                      v_rec.subline_cd,
                      v_rec.iss_cd,
                      v_rec.pol_iss_cd,
                      v_rec.clm_yy,
                      v_rec.issue_yy,
                      v_rec.clm_seq_no,
                      v_rec.pol_seq_no,
                      v_rec.renew_no,
                      v_rec.clm_stat_desc,
                      v_rec.dsp_loss_date,
                      v_rec.loss_cat_des,
                      v_rec.assd_name
                      ;                            
         EXIT WHEN c%NOTFOUND;
        PIPE ROW (v_rec);
    END LOOP;
      
    CLOSE c;
    RETURN; 
    --commented out MarkS 11.9.2016 SR5833 optimization
   ------------------------------
--      FOR i IN (SELECT gc.claim_id, gc.line_cd, gc.subline_cd, gc.iss_cd, gc.pol_iss_cd, gc.clm_yy, gc.issue_yy, gc.clm_seq_no, gc.pol_seq_no, gc.renew_no, gc.clm_stat_cd, gc.dsp_loss_date,
--                       gc.loss_date, gc.loss_cat_cd, gc.assd_no
--                  FROM gicl_claims gc
--                 WHERE 
--                   EXISTS (SELECT 'X' FROM TABLE (security_access.get_branch_line ('CL',p_module_id ,p_userid ))
--                                                                WHERE LINE_CD= gc.line_cd and BRANCH_CD = gc.iss_cd) -- added By MarkS 11.9.2016 SR5833 optimization
--                 --AND check_user_per_line2 (gc.line_cd, gc.iss_cd, p_module_id, p_userid) = 1 --commented out By MarkS 11.9.2016 SR5833 optimization
--                   AND gc.claim_id      = NVL (p_claim_id, gc.claim_id)
--                   AND gc.line_cd       = NVL (p_line_cd, gc.line_cd)
--                   AND gc.subline_cd    = NVL (p_subline_cd, gc.subline_cd)
--                   AND gc.iss_cd        = NVL (p_iss_cd, gc.iss_cd)
--                   AND gc.pol_iss_cd    = NVL (p_pol_iss_cd, gc.pol_iss_cd)
--                   AND gc.clm_yy        = NVL (p_clm_yy, gc.clm_yy)
--                   AND gc.clm_seq_no    = NVL (p_clm_seq_no, gc.clm_seq_no)
--                   AND gc.pol_seq_no    = NVL (p_pol_seq_no, gc.pol_seq_no)
--                   AND gc.renew_no      = NVL (p_renew_no, gc.renew_no)
--                   AND gc.claim_id      = NVL (p_claim_id, gc.claim_id))
--      LOOP
--         v_clmpollist.claim_id := i.claim_id;
--         v_clmpollist.line_cd := i.line_cd;
--         v_clmpollist.subline_cd := i.subline_cd;
--         v_clmpollist.iss_cd := i.iss_cd;
--         v_clmpollist.clm_yy := i.clm_yy;
--         v_clmpollist.clm_seq_no := i.clm_seq_no;
--         v_clmpollist.pol_iss_cd := i.pol_iss_cd;
--         v_clmpollist.issue_yy := i.issue_yy;
--         v_clmpollist.pol_seq_no := i.pol_seq_no;
--         v_clmpollist.renew_no := i.renew_no;
--         v_clmpollist.dsp_loss_date := i.dsp_loss_date;

--         FOR x IN (SELECT *
--                     FROM giis_assured
--                    WHERE assd_no = i.assd_no)
--         LOOP
--            v_clmpollist.assd_name := x.assd_name;
--         END LOOP;

--         FOR x IN (SELECT *
--                     FROM giis_clm_stat
--                    WHERE clm_stat_cd = i.clm_stat_cd)
--         LOOP
--            v_clmpollist.clm_stat_desc := x.clm_stat_desc;
--         END LOOP;

--         FOR x IN (SELECT *
--                     FROM giis_loss_ctgry
--                    WHERE line_cd = i.line_cd AND loss_cat_cd = i.loss_cat_cd)
--         LOOP
--            v_clmpollist.loss_cat_des := x.loss_cat_des;
--         END LOOP;

--         PIPE ROW (v_clmpollist);
--      END LOOP;

--      RETURN;
   END get_clmpol_lov;

   FUNCTION get_clm_payment (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN clm_payment_tab PIPELINED
   IS
      v_clmpaytlist   clm_payment_type;
   BEGIN
      FOR i IN (SELECT gcle.claim_id, gcle.advice_id, gcle.clm_loss_id, gcle.item_no, gcle.peril_cd, gp.peril_sname, gcle.payee_type, gcle.payee_class_cd, gcle.payee_cd, gcle.tran_date, gcle.net_amt,
                       gcle.paid_amt, TO_CHAR (gci.item_title) item_title, NVL(tran_id,0) tran_id,
                          payee_last_name
                       || DECODE (payee_first_name, NULL, NULL, ', ' || payee_first_name)
                       || DECODE (payee_middle_name, NULL, NULL, ' ' || SUBSTR (payee_middle_name, 1, 1) || '.') payee_name,
                       gcle.item_no ||' - ' ||TO_CHAR(gci.item_title) item,
                       gcle.peril_cd||' - ' || gp.peril_sname peril,
                       gcle.payee_type|| ' - ' || gcle.payee_class_cd || ' - ' ||gcle.payee_cd|| ' - ' || payee_last_name
                       || DECODE (payee_first_name, NULL, NULL, ', ' || payee_first_name)   
                       || DECODE (payee_middle_name, NULL, NULL, ' ' || SUBSTR (payee_middle_name, 1, 1) || '.') payee
                  FROM gicl_claims gi, gicl_clm_loss_exp gcle, gicl_clm_item gci, giis_peril gp, giis_payees gpy
                 WHERE gcle.claim_id = gci.claim_id
                   AND gi.claim_id = gcle.claim_id
                   AND gcle.item_no = gci.item_no
                   AND gcle.peril_cd = gp.peril_cd
                   AND gi.line_cd = gp.line_cd
                   AND gcle.payee_class_cd = gpy.payee_class_cd
                   AND gcle.payee_cd = gpy.payee_no
                   AND gcle.claim_id = p_claim_id
                   AND gcle.advice_id IS NOT NULL)
      LOOP
         v_clmpaytlist.claim_id := i.claim_id;
         v_clmpaytlist.advice_id := i.advice_id;
         v_clmpaytlist.clm_loss_id := i.clm_loss_id;
         v_clmpaytlist.item_no := i.item_no;
         v_clmpaytlist.item_title := TO_CHAR (i.item_title);
         v_clmpaytlist.peril_cd := i.peril_cd;
         v_clmpaytlist.peril_sname := i.peril_sname;
         v_clmpaytlist.payee_type := i.payee_type;
         v_clmpaytlist.payee_class_cd := i.payee_class_cd;
         v_clmpaytlist.payee_cd := i.payee_cd;
         v_clmpaytlist.payee_name := i.payee_name;
         v_clmpaytlist.tran_date := i.tran_date;
         v_clmpaytlist.net_amt := i.net_amt;
         v_clmpaytlist.paid_amt := i.paid_amt;
         v_clmpaytlist.tran_id := i.tran_id;
         v_clmpaytlist.item := i.item;
         v_clmpaytlist.peril := i.peril;
         v_clmpaytlist.payee := i.payee;
         PIPE ROW (v_clmpaytlist);
      END LOOP;

      RETURN;
   END get_clm_payment;

   FUNCTION get_clm_adv (p_advice_id gicl_clm_loss_exp.advice_id%TYPE, p_clm_loss_id gicl_clm_loss_exp.clm_loss_id%TYPE)
      RETURN clm_payment_adv_tab PIPELINED
   IS
      v_clmpaytlist   clm_payment_adv_type;
   BEGIN
      FOR i IN (SELECT ga.claim_id, ga.advice_id, ga.line_cd || '-' || ga.iss_cd || '-' || ga.advice_year || '-' || TO_CHAR (ga.advice_seq_no, '000000') advice_no, ga.batch_csr_id, gcle.clm_loss_id,
                       NVL(gcle.tran_id,0) tran_id, gcle.tran_date
                  FROM gicl_advice ga, gicl_clm_loss_exp gcle
                 WHERE ga.advice_id = gcle.advice_id AND ga.advice_id = p_advice_id AND gcle.clm_loss_id = p_clm_loss_id)
      LOOP
         v_clmpaytlist.advice_no := i.advice_no;
         v_clmpaytlist.tran_id := i.tran_id;
         v_clmpaytlist.date_paid := i.tran_date;

         IF (i.batch_csr_id IS NOT NULL) THEN
            FOR bcsr IN (SELECT fund_cd || '-' || iss_cd || '-' || batch_year || '-' || TO_CHAR (batch_seq_no, '000000') batch_no
                           FROM gicl_batch_csr
                          WHERE batch_csr_id = batch_csr_id)
            LOOP
               v_clmpaytlist.batch_no := bcsr.batch_no;
            END LOOP;
         END IF;

         /*FOR tran IN (SELECT tran_class, tran_class_no, tran_date, particulars, tran_id, tran_class || '-' || TO_CHAR (tran_class_no, '0000000000') tran_no
                        FROM giac_acctrans a, giac_direct_claim_payts b
                       WHERE a.tran_id = b.gacc_tran_id AND b.claim_id = i.claim_id AND b.clm_loss_id = i.clm_loss_id AND tran_flag != 'D') */ --comment out by Aliza G. 20160122 to be replaced by code below SR 21445 
         FOR tran IN (SELECT tran_class, tran_class_no, tran_date, particulars, tran_id,
                             tran_class || '-' || TO_CHAR (tran_class_no, '0000000000') tran_no
                            FROM giac_acctrans a, giac_inw_claim_payts c
                        WHERE tran_flag != 'D'
                            AND a.tran_id  (+)= c.gacc_tran_id
                            AND c.claim_id = i.claim_id
                            AND c.clm_loss_id = i.clm_loss_id   
                        UNION
                      SELECT tran_class, tran_class_no, tran_date, particulars, tran_id,
                             tran_class || '-' || TO_CHAR (tran_class_no, '0000000000') tran_no
                            FROM giac_acctrans a, giac_direct_claim_payts b
                        WHERE a.tran_id  (+)= b.gacc_tran_id
                            AND tran_flag != 'D'   
                            AND b.claim_id = i.claim_id
                            AND b.clm_loss_id = i.clm_loss_id)                                     
         LOOP
            IF tran.tran_class = 'COL' THEN
               FOR c IN (SELECT or_pref_suf || '-' || TO_CHAR (or_no, '0000000000') or_no, or_date, particulars
                           FROM giac_order_of_payts
                          WHERE gacc_tran_id = i.tran_id)
               LOOP
                  v_clmpaytlist.ref_no := c.or_no;
                  v_clmpaytlist.ref_date := c.or_date;
                  v_clmpaytlist.particulars := c.particulars;
               END LOOP;
            ELSIF tran.tran_class = 'DV' THEN
               FOR r IN (SELECT a.document_cd || '-' || a.branch_cd || '-' || a.line_cd || '-' || a.doc_year || '-' || TO_CHAR (a.doc_mm, '00') || '-' || TO_CHAR (a.doc_seq_no, '000000') csr_no,
                                particulars
                           FROM giac_payt_requests a, giac_payt_requests_dtl b
                          WHERE a.ref_id = b.gprq_ref_id AND b.tran_id = tran.tran_id)
               LOOP
                  v_clmpaytlist.csr_no := r.csr_no;

                  FOR d IN (SELECT dv_pref || '-' || TO_CHAR (dv_no, '0000000000') dv_no, dv_date, particulars
                              FROM giac_disb_vouchers
                             WHERE gacc_tran_id = tran.tran_id)
                  LOOP
                     v_clmpaytlist.ref_no := d.dv_no;
                     v_clmpaytlist.ref_date := d.dv_date;
                     v_clmpaytlist.particulars := d.particulars;

                     FOR chk IN (SELECT check_pref_suf || '-' || TO_CHAR (check_no, '0000000000') check_no, check_date
                                   FROM giac_chk_disbursement
                                  WHERE gacc_tran_id = tran.tran_id)
                     LOOP
                        v_clmpaytlist.refcheck_no := chk.check_no;
                        v_clmpaytlist.chck_date := chk.check_date;
                     END LOOP;
                  END LOOP;

                  FOR i IN (SELECT gcri.check_pref_suf, gcri.check_no, gcri.check_release_date, 
                            gcri.check_released_by, gcri.user_id, gcri.check_received_by, 
                            gcri.or_no, gcri.or_date,gcri.last_update
                              FROM giac_chk_release_info gcri
                             WHERE gcri.gacc_tran_id = tran.tran_id)
                  LOOP
                     v_clmpaytlist.check_pref_suf := i.check_pref_suf;
                     v_clmpaytlist.check_no := i.check_no;
                     v_clmpaytlist.check_release_date := i.check_release_date;
                     v_clmpaytlist.check_released_by := i.check_released_by;
                     v_clmpaytlist.user_id := i.user_id;
                     v_clmpaytlist.check_received_by := i.check_received_by;
                     v_clmpaytlist.or_no := i.or_no;
                     v_clmpaytlist.or_date := i.or_date;
                     v_clmpaytlist.last_update := i.last_update;
                  END LOOP;
               END LOOP;
            ELSIF tran.tran_class = 'JV' THEN
               v_clmpaytlist.ref_no := tran.tran_no;
               v_clmpaytlist.ref_date := tran.tran_date;
               v_clmpaytlist.particulars := tran.particulars;
            END IF;
         END LOOP;

         PIPE ROW (v_clmpaytlist);
      END LOOP;

      RETURN;
   END get_clm_adv;

   FUNCTION get_clmline_lov (p_module_id VARCHAR2, p_userid VARCHAR2, p_line_cd VARCHAR2)
      RETURN clmline_lov_tab PIPELINED
   IS
      v_clmlinelist   clmline_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT gl.line_cd, gl.line_name
                  FROM giis_line gl, gicl_claims gc
                 WHERE gl.line_cd = gc.line_cd
                 AND EXISTS (SELECT 'X' FROM TABLE (security_access.get_branch_line ('CL',p_module_id ,p_userid ))
                                                                WHERE LINE_CD= gc.line_cd and BRANCH_CD = gc.iss_cd) -- added By MarkS 11.9.2016 SR5833 optimization
                 --AND check_user_per_line2 (gc.line_cd, gc.iss_cd, p_module_id, p_userid) = 1 --commented out By MarkS 11.9.2016 SR5833 optimization
                 AND gl.line_cd = NVL(p_line_cd,gl.line_cd))
      LOOP
         v_clmlinelist.line_cd := i.line_cd;
         v_clmlinelist.line_name := i.line_name;
         PIPE ROW (v_clmlinelist);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_clmsubline_lov (p_module_id VARCHAR2, p_userid VARCHAR2, p_line_cd giis_line.line_cd%TYPE, p_subline_cd giis_subline.subline_cd%TYPE)
      RETURN clmsubline_lov_tab PIPELINED
   IS
      v_clmsublinelist   clmsubline_lov_type;
   BEGIN
      FOR i IN (SELECT gs.subline_cd, gs.subline_name,gs.line_cd
                  FROM giis_subline gs
                 WHERE check_user_per_line2 (line_cd, NULL, p_module_id, p_userid) = 1  
                   AND gs.subline_cd = NVL(p_subline_cd,gs.subline_cd)
                   AND gs.line_cd = NVL(p_line_cd,gs.line_cd))
      LOOP
         v_clmsublinelist.subline_cd    := i.subline_cd;
         v_clmsublinelist.subline_name  := i.subline_name;
         v_clmsublinelist.line_cd       := i.line_cd;
         PIPE ROW (v_clmsublinelist);
      END LOOP;
    
      RETURN;
   END;

   FUNCTION get_clmisscd_lov (p_module_id VARCHAR2, p_userid VARCHAR2, p_iss_cd giis_issource.iss_cd%TYPE, p_line_cd VARCHAR2)
      RETURN clmisscd_lov_tab PIPELINED
   IS
      v_clmisslist   clmisscd_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT gi.iss_cd, gi.iss_name
                  FROM giis_issource gi, gicl_claims gc
                  WHERE gi.iss_cd = gc.iss_cd
                  AND gi.iss_cd = NVL(p_iss_cd,gi.iss_cd)
                  AND gc.line_cd = NVL(p_line_cd, gc.line_cd)
                  AND check_user_per_iss_cd2 (LINE_CD, gi.iss_cd, p_module_id, p_userid) = 1
               )
      LOOP
         v_clmisslist.iss_cd := i.iss_cd;
         v_clmisslist.iss_name := i.iss_name;
         PIPE ROW (v_clmisslist);
      END LOOP;

      RETURN;
   END;
   
   FUNCTION get_policy_lov (
      p_module_id    VARCHAR2,
      p_userid       VARCHAR2,
      p_line_cd      gicl_claims.line_cd%TYPE,
      p_subline_cd   gicl_claims.subline_cd%TYPE,
      p_iss_cd       gicl_claims.iss_cd%TYPE,
      p_issue_yy     gicl_claims.issue_yy%TYPE,
      p_pol_seq_no   gicl_claims.clm_seq_no%TYPE,
      p_renew_no     gicl_claims.renew_no%TYPE
   )
      RETURN policy_lov_tab PIPELINED
   IS
      v_list   policy_lov_type;
   BEGIN
      FOR i IN (SELECT distinct line_cd, subline_cd, pol_iss_cd,LTRIM (TO_CHAR (issue_yy, '09')) issue_yy, LTRIM (TO_CHAR (pol_seq_no, '0999999')) pol_seq_no, LTRIM (TO_CHAR (renew_no, '09')) renew_no,
                line_cd||' - '||subline_cd||' - '||pol_iss_cd||' - '||LTRIM (TO_CHAR (issue_yy, '09'))||' - '||LTRIM (TO_CHAR (pol_seq_no, '0999999'))||' - '||LTRIM (TO_CHAR (renew_no, '09'))
                policy_no,assured_name
                    FROM gicl_claims
                WHERE line_cd   = NVL(p_line_cd,line_cd)
                AND subline_cd  = NVL(p_subline_cd,subline_cd)
                AND pol_iss_cd      = NVL(p_iss_cd,iss_cd)
                AND issue_yy    = NVL(p_issue_yy,issue_yy)
                AND pol_seq_no  = NVL(p_pol_seq_no,pol_seq_no)
                AND renew_no    = NVL(p_renew_no,renew_no)
                AND check_user_per_iss_cd2 (line_cd, iss_cd, p_module_id, p_userid) = 1
               )
      LOOP
         v_list.line_cd := i.line_cd;
         v_list.subline_cd := i.subline_cd;
         v_list.pol_iss_cd := i.pol_iss_cd;
         v_list.issue_yy := i.issue_yy;
         v_list.pol_seq_no := i.pol_seq_no;
         v_list.renew_no := i.renew_no;
         v_list.policy_no := i.policy_no;
         v_list.assured_name := i.assured_name;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_policy_lov;
   
   FUNCTION check_release_info (p_tran_id VARCHAR2)
      RETURN check_release_tab PIPELINED
   IS
      v_list   check_release_type;
   BEGIN
      FOR i IN (SELECT gacc_tran_id, check_pref_suf, check_no, check_release_date, check_released_by, check_received_by, or_no, or_date, last_update
                FROM giac_chk_release_info
                WHERE gacc_tran_id = p_tran_id)
      LOOP
         v_list.tran_id           := i.gacc_tran_id;
         v_list.check_pref_suf    := i.check_pref_suf;    
         v_list.check_no          := i.check_no;          
         v_list.check_release_date:= i.check_release_date;
         v_list.check_released_by := i.check_released_by; 
         v_list.check_received_by := i.check_received_by; 
         v_list.or_no             := i.or_no;             
         v_list.or_date           := i.or_date;           
         v_list.last_update       := i.last_update;       
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END check_release_info;
   
   --added by john dolon 7.19.2013
   FUNCTION validate_entries(
        p_line_cd       VARCHAR2,
        p_subline_cd    VARCHAR2,
        p_clmline_cd    VARCHAR2,
        p_clmsubline_cd VARCHAR2,
        p_iss_cd        VARCHAR2,
        p_pol_iss_cd    VARCHAR2,
        p_clm_yy        VARCHAR2,
        p_issue_yy      VARCHAR2,
        p_clm_seq_no    VARCHAR2,
        p_pol_seq_no    VARCHAR2,
        p_renew_no      VARCHAR2
    )
    RETURN VARCHAR2
    IS
        v_temp_x    VARCHAR2(1);
        BEGIN   
        
        SELECT(SELECT DISTINCT 'X'
                FROM gicl_claims gc
                 WHERE gc.line_cd       = NVL (p_line_cd, gc.line_cd)
                   AND gc.subline_cd    = NVL (p_subline_cd, gc.subline_cd)
                   AND gc.line_cd       = NVL (p_clmline_cd, gc.line_cd)
                   AND gc.subline_cd    = NVL (p_clmsubline_cd, gc.subline_cd)
                   AND gc.iss_cd        = NVL (p_iss_cd, gc.iss_cd)
                   AND gc.pol_iss_cd    = NVL (p_pol_iss_cd, gc.pol_iss_cd)
                   AND gc.clm_yy        = NVL (p_clm_yy, gc.clm_yy)
                   AND gc.issue_yy      = NVL (p_issue_yy, gc.issue_yy)
                   AND gc.clm_seq_no    = NVL (p_clm_seq_no, gc.clm_seq_no)
                   AND gc.pol_seq_no    = NVL (p_pol_seq_no, gc.pol_seq_no)
                   AND gc.renew_no      = NVL (p_renew_no, gc.renew_no)
              )
       INTO v_temp_x
       FROM DUAL;
            IF v_temp_x IS NOT NULL
                THEN
                    RETURN '1';
                ELSE
                    RETURN '0';
            END IF;
       END;
END;
/
