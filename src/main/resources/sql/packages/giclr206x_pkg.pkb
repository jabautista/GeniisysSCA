CREATE OR REPLACE PACKAGE BODY CPI.giclr206x_pkg
AS
   FUNCTION get_main (
      p_session_id   VARCHAR2,
      p_claim_id     VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2
   )
      RETURN main_tab PIPELINED
   IS
      v_list main_type;
      v_counter NUMBER := 1;
      v_buss_source_name giis_intm_type.intm_desc%TYPE;
      v_source_name giis_intermediary.intm_name%TYPE;
      v_iss_name giis_issource.iss_name%TYPE;
      v_line_name giis_line.line_name%TYPE;
      v_subline_name giis_subline.subline_name%TYPE;
      v_row_count NUMBER := 1;
      v_losses_paid NUMBER;
      v_report_title giis_reports.report_title%TYPE;
      v_date_range VARCHAR2 (100);
   BEGIN
   
      BEGIN
         SELECT report_title
           INTO v_report_title
           FROM giis_reports
          WHERE report_id = 'GICLR206X';
      EXCEPTION WHEN NO_DATA_FOUND THEN
         v_report_title := NULL;        
      END;
      
      BEGIN
         SELECT 'from '|| TO_CHAR(TO_DATE(p_from_date, 'mm-dd-yyyy'),'fmMonth DD, YYYY')||
                ' to '|| TO_CHAR(TO_DATE(p_to_date, 'mm-dd-yyyy'),'fmMonth DD, YYYY')
           INTO v_date_range
           FROM dual;
      EXCEPTION WHEN OTHERS THEN
         v_date_range := NULL;      
      END;
   
      FOR i IN (SELECT DISTINCT DECODE (a.iss_cd, 'RI', 'RI', 'DI') iss_type,
                       DECODE (a.iss_cd, 'RI', 'RI', b.intm_type) buss_source_type,
                       a.iss_cd, a.buss_source, a.line_cd, a.subline_cd, a.loss_year
                  FROM gicl_res_brdrx_ds_extr a,
                       giis_intermediary b,
                       giis_dist_share c
                 WHERE a.session_id = p_session_id
                   AND a.line_cd = c.line_cd
                   AND a.grp_seq_no = c.share_cd
                   AND c.share_type = giacp.v ('XOL_TRTY_SHARE_TYPE')
                   AND a.buss_source = b.intm_no(+)
                   AND a.claim_id = NVL (p_claim_id, a.claim_id)
                   AND NVL (a.losses_paid, 0) <> 0
                   AND a.grp_seq_no NOT IN (1, 999)
              ORDER BY a.line_cd, subline_cd)
              
      LOOP
         v_list.buss_source_type := i.buss_source_type;
         v_list.iss_type := i.iss_type;
         v_list.buss_source := i.buss_source;
         v_list.iss_cd := i.iss_cd;
         v_list.line_cd := i.line_cd;
         v_list.subline_cd := i.subline_cd;
         v_list.loss_year := i.loss_year;
         v_list.company_name := giacp.v('COMPANY_NAME');
         v_list.company_address := giacp.v('COMPANY_ADDRESS');
         v_list.report_title := v_report_title;
         v_list.date_range := v_date_range;
         
         
         BEGIN
            SELECT intm_desc
              INTO v_list.buss_source_name
              FROM giis_intm_type
             WHERE intm_type = i.buss_source_type;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.buss_source_name := 'REINSURER ';
            WHEN OTHERS
            THEN
               v_list.buss_source_name := NULL;
         END;
         
         BEGIN
            IF i.iss_type = 'RI'
            THEN
               BEGIN
                  SELECT ri_name
                    INTO v_list.source_name
                    FROM giis_reinsurer
                   WHERE ri_cd = i.buss_source;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     v_list.source_name := NULL;
               END;
            ELSE
               BEGIN
                  SELECT intm_name
                    INTO v_list.source_name
                    FROM giis_intermediary
                   WHERE intm_no = i.buss_source;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     v_list.source_name := NULL;
               END;
            END IF;
         END;
         
         BEGIN
            SELECT iss_name
              INTO v_list.iss_name
              FROM giis_issource
             WHERE iss_cd = i.iss_cd;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_list.iss_name := NULL;
         END;
         
         BEGIN
            SELECT line_name
              INTO v_list.line_name
              FROM giis_line
             WHERE line_cd = i.line_cd;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_list.line_name := NULL;
         END;
         
         BEGIN
            SELECT subline_name
              INTO v_list.subline_name
              FROM giis_subline
             WHERE subline_cd = i.subline_cd AND line_cd = i.line_cd;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_list.subline_name := NULL;
         END;
         
         
         
         FOR c IN (SELECT    DISTINCT a.grp_seq_no, b.trty_name
                        FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                       WHERE a.session_id = p_session_id
                         AND a.claim_id = NVL (p_claim_id, a.claim_id)
                         AND a.grp_seq_no NOT IN (1, 999)
                         AND a.buss_source = i.buss_source
                         AND a.iss_cd = i.iss_cd
                         AND a.line_cd = i.line_cd
                         AND a.subline_cd = i.subline_cd -- Added by Jerome Bautista 08.05.2015 SR 18821
                         AND a.loss_year = i.loss_year
                         AND b.share_cd = a.grp_seq_no
                         AND b.line_cd = a.line_cd
                         AND b.share_type = giacp.v('XOL_TRTY_SHARE_TYPE') -- Added by Jerome Bautista 08.03.2015 SR 18821
                    ORDER BY a.grp_seq_no)
         LOOP
         
            BEGIN
               SELECT SUM (NVL (a.losses_paid, 0))
                 INTO v_losses_paid
                 FROM gicl_res_brdrx_ds_extr a
                WHERE a.session_id = p_session_id
                  AND a.claim_id = NVL (p_claim_id, a.claim_id)
                  AND a.grp_seq_no NOT IN (1, 999)
                  AND a.buss_source = i.buss_source
                  AND a.iss_cd = i.iss_cd
                  AND a.line_cd = i.line_cd
                  AND a.subline_cd = i.subline_cd -- Added by Jerome Bautista 08.05.2015 SR 18821
                  AND a.loss_year = i.loss_year
                  AND a.grp_seq_no = c.grp_seq_no;
            END;
         
            IF v_counter = 5 THEN
               v_counter := 1;
            END IF;   
          
            IF v_counter = 1 THEN
               v_list.col1 := c.trty_name;
               v_list.tot1 := v_losses_paid;
               v_counter := v_counter + 1;
            ELSIF v_counter = 2 THEN
               v_list.col2 := c.trty_name;
               v_list.tot2 := v_losses_paid;
               v_counter := v_counter + 1;
            ELSIF v_counter = 3 THEN
               v_list.col3 := c.trty_name;
               v_list.tot3 := v_losses_paid;
               v_counter := v_counter + 1;
            ELSIF v_counter = 4 THEN
               v_list.col4 := c.trty_name;
               v_list.tot4 := v_losses_paid;
               v_counter := v_counter + 1;      
            END IF;
            
            IF v_counter = 5 THEN
               v_list.loss_year_dummy := i.loss_year || '_' || v_row_count;
               v_row_count := v_row_count + 1;
               PIPE ROW(v_list);
               v_list.col1 := NULL;
               v_list.col2 := NULL;
               v_list.col3 := NULL;
               v_list.col4 := NULL;
               v_list.tot1 := NULL;
               v_list.tot2 := NULL;
               v_list.tot3 := NULL;
               v_list.tot4 := NULL;
               
            END IF;
         END LOOP;                    
         
         IF v_counter != 5 THEN
            v_list.loss_year_dummy := i.loss_year || '_' || v_row_count;
            PIPE ROW(v_list);
            v_list.col1 := NULL;
            v_list.col2 := NULL;
            v_list.col3 := NULL;
            v_list.col4 := NULL;
            v_list.tot1 := NULL;
            v_list.tot2 := NULL;
            v_list.tot3 := NULL;
            v_list.tot4 := NULL;
         END IF;
         
         v_row_count := 1;
         v_counter := 1;
      END LOOP;
      
      
      IF v_list.company_name IS NULL THEN
         v_list.company_name := giacp.v('COMPANY_NAME');
         v_list.company_address := giacp.v('COMPANY_ADDRESS');
         v_list.report_title := v_report_title;
         v_list.date_range := v_date_range;
         PIPE ROW(v_list);
      END IF;
      
      
   END get_main;
   
   FUNCTION get_details (
      p_session_id    VARCHAR2,
      p_claim_id      VARCHAR2,
      p_buss_source   VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_line_cd       VARCHAR2,
      p_loss_year     VARCHAR2
   )
      RETURN details_tab PIPELINED
   IS
      v_list details_type;
   BEGIN
--                 FOR i IN(SELECT DISTINCT claim_no, policy_no, incept_date, expiry_date, loss_date, assd_no,
--                      claim_id
--                 FROM gicl_res_brdrx_extr
--                WHERE session_id = p_session_id
--                  AND session_id = session_id
--                  AND brdrx_record_id = brdrx_record_id
--                  AND claim_id = NVL (p_claim_id, claim_id)
--                  AND buss_source LIKE NVL(p_buss_source, '%')
--                  AND iss_cd LIKE NVL(p_iss_cd, '%')
--                  AND line_cd = p_line_cd
--                  AND loss_year = p_loss_year
--                  AND NVL (losses_paid, 0) <> 0
--             ORDER BY claim_no, claim_id, assd_no, claim_no, policy_no)  --Commented out by: Jerome Bautista 04.21.2015, replaced by code below.

       FOR i in (SELECT DISTINCT a.claim_no, a.policy_no, a.incept_date, a.expiry_date, a.loss_date, a.assd_no,
                      a.claim_id 
                 FROM gicl_res_brdrx_extr a,
                      gicl_res_brdrx_ds_extr b,
                      giis_dist_share c
                WHERE a.session_id = p_session_id
                  AND a.session_id = b.session_id
                  AND a.brdrx_record_id = b.brdrx_record_id
                  AND a.claim_id = NVL (p_claim_id, a.claim_id)
                  AND b.grp_seq_no = c.share_cd
                  AND a.buss_source LIKE NVL(p_buss_source, '%')
                  AND a.iss_cd LIKE NVL(p_iss_cd, '%')
                  AND a.line_cd = p_line_cd
                  AND a.loss_year = p_loss_year
                  AND c.share_type = giacp.v ('XOL_TRTY_SHARE_TYPE')
                  AND NVL (a.losses_paid, 0) <> 0
             ORDER BY claim_no, claim_id, assd_no, claim_no, policy_no) --Added by Jerome Bautista 6.19.2015 SR 18821
      LOOP
--         v_list.brdrx_record_id := i.brdrx_record_id;
         v_list.claim_no := i.claim_no;
         v_list.policy_no := i.policy_no;
         v_list.incept_date := i.incept_date;
         v_list.expiry_date := i.expiry_date;
         v_list.loss_date := i.loss_date;
         v_list.claim_id := i.claim_id;
         
         BEGIN
            SELECT assd_name
              INTO v_list.assd_name
              FROM giis_assured
             WHERE assd_no = i.assd_no;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_list.assd_name := NULL;     
         END;
         
         PIPE ROW(v_list);
      END LOOP;         
   END get_details;
   
   
   FUNCTION get_g_item (
      p_session_id    VARCHAR2,
      p_claim_id      VARCHAR2,
      p_buss_source   VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_line_cd       VARCHAR2,
      p_loss_year     VARCHAR2
   )
      RETURN g_item_tab PIPELINED
   IS
      v_list g_item_type;
   BEGIN
      FOR i IN (SELECT DISTINCT claim_id, item_no, grouped_item_no
                  FROM gicl_res_brdrx_extr
                 WHERE session_id = p_session_id
                   AND claim_id = p_claim_id
                   AND buss_source LIKE NVL(p_buss_source, '%')
                   AND iss_cd LIKE NVL(p_iss_cd, '%')
                   AND line_cd = p_line_cd
                   AND loss_year = p_loss_year
                   AND NVL (losses_paid, 0) <> 0)
      LOOP
         v_list.item_no := i.item_no;
         v_list.grouped_item_no := i.grouped_item_no;
         v_list.item_title := get_gpa_item_title(i.claim_id, p_line_cd, i.item_no, nvl(i.grouped_item_no, 0));
         
         PIPE ROW(v_list); 
      END LOOP;         
   END get_g_item;
   
   FUNCTION get_g_peril (
      p_session_id    VARCHAR2,
      p_claim_id      VARCHAR2,
      p_buss_source   VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_line_cd       VARCHAR2,
      p_loss_year     VARCHAR2,
      p_item_no       VARCHAR2,
      p_intm_break    VARCHAR2,
      p_paid_date     VARCHAR2,
      p_from_date     VARCHAR2,
      p_to_date       VARCHAR2
   )
      RETURN g_peril_tab PIPELINED
   IS
      v_list g_peril_type;
   BEGIN
--            for i in (SELECT tsi_amt, line_cd, peril_cd, intm_no, NVL(losses_paid,0) paid_losses,
--                       clm_loss_id, brdrx_record_id, claim_id, item_no, grouped_item_no
--                  FROM gicl_res_brdrx_extr
--                 WHERE session_id = p_session_id
--                   AND claim_id = p_claim_id
--                   AND item_no = p_item_no
--                   AND buss_source LIKE NVL(p_buss_source, '%')
--                   AND iss_cd LIKE NVL(p_iss_cd, '%')
--                   AND line_cd = p_line_cd
--                   AND loss_year = p_loss_year
--                   AND NVL (losses_paid, 0) <> 0) -- Commented out by Jerome Bautista replaced by code below - SR 18821

       FOR i in (SELECT DISTINCT a.tsi_amt, a.line_cd, a.peril_cd, a.intm_no, NVL(a.losses_paid,0) paid_losses,
                       a.clm_loss_id, a.brdrx_record_id, a.claim_id, a.item_no, a.grouped_item_no
                 FROM gicl_res_brdrx_extr a,
                      gicl_res_brdrx_ds_extr b,
                      giis_dist_share c
                WHERE a.session_id = p_session_id
                  AND a.session_id = b.session_id
                  AND a.brdrx_record_id = b.brdrx_record_id
                  AND a.claim_id = NVL (p_claim_id, a.claim_id)
                  AND b.grp_seq_no = c.share_cd
                  AND a.buss_source LIKE NVL(p_buss_source, '%')
                  AND a.iss_cd LIKE NVL(p_iss_cd, '%')
                  AND a.line_cd = p_line_cd
                  AND a.loss_year = p_loss_year
                  AND c.share_type = giacp.v ('XOL_TRTY_SHARE_TYPE')
                  AND NVL (a.losses_paid, 0) <> 0) -- End of addition Jerome Bautista 06.19.2015 - SR 18821
      LOOP
         v_list.tsi_amt := i.tsi_amt;
         v_list.peril_cd := i.peril_cd;
         v_list.intm_ri := giclr206x_pkg.cf_intm_riformula(p_claim_id, p_intm_break, p_session_id, p_item_no, i.peril_cd, i.intm_no);
--         v_list.dv_no := giclr206x_pkg.cf_dv_noformula(i.paid_losses, p_claim_id, i.clm_loss_id, p_paid_date, p_from_date, p_to_date);
         v_list.dv_no := gicls202_pkg.get_voucher_check_no(i.claim_id, i.item_no, i.peril_cd, i.grouped_item_no, TO_DATE(p_from_date, 'mm-dd-yyyy'), TO_DATE(p_to_date, 'mm-dd-yyyy'), p_paid_date, 'L')
               || chr(10) ||gicls202_pkg.get_voucher_check_no(i.claim_id, i.item_no, i.peril_cd, i.grouped_item_no, TO_DATE(p_from_date, 'mm-dd-yyyy'), TO_DATE(p_to_date, 'mm-dd-yyyy'), p_paid_date, 'E');
         v_list.brdrx_record_id := i.brdrx_record_id;
         
         
         BEGIN
            SELECT peril_name
              INTO v_list.peril_name
              FROM giis_peril
             WHERE peril_cd = i.peril_cd AND line_cd = i.line_cd;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_list.peril_name := NULL;
         END;
         
         PIPE ROW(v_list);
      END LOOP;
   END get_g_peril;
   
   FUNCTION get_paid_losses (
      p_session_id        VARCHAR2,
      p_claim_id          VARCHAR2,
      p_buss_source       VARCHAR2,
      p_iss_cd            VARCHAR2,
      p_line_cd           VARCHAR2,
      p_loss_year         VARCHAR2,
      p_brdrx_record_id   VARCHAR2
   )
      RETURN paid_losses_tab PIPELINED
   IS
      v_list paid_losses_type;
      v_counter NUMBER := 1;
      v_row_count NUMBER := 1;
      v_loss_year NUMBER(4);
      v_paid_losses gicl_res_brdrx_ds_extr.losses_paid%TYPE;
   BEGIN
      FOR i IN (SELECT DISTINCT a.grp_seq_no, loss_year
                  FROM gicl_res_brdrx_ds_extr a
                 WHERE a.session_id = p_session_id
--                   AND a.claim_id = NVL (p_claim_id, a.claim_id)
                   AND a.grp_seq_no NOT IN (1, 999)
                   AND a.buss_source = p_buss_source
                   AND a.iss_cd = p_iss_cd
                   AND a.line_cd = p_line_cd
                   AND a.loss_year = p_loss_year
                 ORDER BY a.grp_seq_no)
      LOOP
         
         BEGIN
            SELECT SUM(NVL (a.losses_paid, 0))
              INTO v_paid_losses
              FROM gicl_res_brdrx_ds_extr a
             WHERE a.session_id = p_session_id
               AND a.brdrx_record_id = p_brdrx_record_id
               AND a.grp_seq_no = i.grp_seq_no;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_paid_losses := NULL;         
         END;
         
         v_loss_year := i.loss_year;
         
         IF v_counter = 1 THEN
            v_list.col1 := v_paid_losses;
            v_counter := v_counter + 1;
         ELSIF v_counter = 2 THEN
            v_list.col2 := v_paid_losses;
            v_counter := v_counter + 1;  
         ELSIF v_counter = 3 THEN
            v_list.col3 := v_paid_losses;
            v_counter := v_counter + 1;
         ELSIF v_counter = 4 THEN
            v_list.col4 := v_paid_losses;
            v_counter := v_counter + 1;                                      
         END IF;
         
         IF v_counter = 5 THEN
            v_list.loss_year_dummy := i.loss_year || '_' || v_row_count;
            PIPE ROW(v_list);
            v_counter := 1;
            v_row_count := v_row_count + 1;
            v_list := NULL;
         END IF;
      
      
      END LOOP;
      
      IF v_counter != 1 THEN
         v_list.loss_year_dummy := v_loss_year || '_' || v_row_count;
         PIPE ROW(v_list);
      END IF;   
   END get_paid_losses;
   
   FUNCTION get_treaty (
      p_session_id        VARCHAR2,
      p_claim_id          VARCHAR2,
      p_buss_source       VARCHAR2,
      p_iss_cd            VARCHAR2,
      p_line_cd           VARCHAR2,
      p_loss_year         VARCHAR2      
   )
      RETURN treaty_tab PIPELINED
   IS
      v_list treaty_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.grp_seq_no, c.trty_name, a.ri_cd, d.ri_sname,
                       b.trty_shr_pct
                  FROM gicl_res_brdrx_rids_extr a,
                       giis_trty_panel b,
                       giis_dist_share c,
                       giis_reinsurer d
                 WHERE a.grp_seq_no NOT IN (1, 999)
                   AND a.session_id = p_session_id
                   AND a.claim_id = NVL (p_claim_id, a.claim_id)
                   AND a.buss_source = p_buss_source
                   AND a.iss_cd = p_iss_cd
                   AND a.line_cd = p_line_cd
                   AND a.loss_year = p_loss_year
                   AND a.line_cd = b.line_cd
                   AND a.grp_seq_no = b.trty_seq_no
                   AND a.ri_cd = b.ri_cd
                   AND NVL (a.losses_paid, 0) <> 0                   
                   AND c.share_cd = a.grp_seq_no
                   AND c.line_cd = a.line_cd
                   AND d.ri_cd = a.ri_cd
              ORDER BY a.grp_seq_no)
      LOOP
         v_list.grp_seq_no := i.grp_seq_no;
         v_list.trty_name := i.trty_name;
         v_list.ri_sname := i.ri_sname;
         v_list.trty_shr_pct := i.trty_shr_pct;
         v_list.ri_cd := i.ri_cd;
         
         BEGIN
            SELECT SUM(NVL (a.losses_paid, 0))
               INTO v_list.shr_amt
             FROM gicl_res_brdrx_rids_extr a
            WHERE a.grp_seq_no NOT IN (1, 999)
              AND a.session_id = p_session_id
              AND a.grp_seq_no = i.grp_seq_no
              AND a.ri_cd = i.ri_cd
              AND a.buss_source = p_buss_source
              AND a.iss_cd = p_iss_cd
              AND a.line_cd = p_line_cd
              AND a.loss_year = p_loss_year
              AND NVL (a.losses_paid, 0) <> 0
              GROUP BY a.grp_seq_no, a.ri_cd;
         END;
         
         PIPE ROW(v_list);
      END LOOP;
   END;      
   
--formulas

   FUNCTION cf_intm_riformula (
      p_claim_id     VARCHAR2,
      p_intm_break   VARCHAR2,
      p_session_id   VARCHAR2,
      p_item_no      VARCHAR2,
      p_peril_cd     VARCHAR2,
      p_intm_no      VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_pol_iss_cd   gicl_claims.pol_iss_cd%TYPE;
      v_intm_ri      VARCHAR2 (1000);
   BEGIN
      BEGIN
         SELECT pol_iss_cd
           INTO v_pol_iss_cd
           FROM gicl_claims
          WHERE claim_id = p_claim_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_pol_iss_cd := NULL;
      END;

      IF v_pol_iss_cd = giacp.v ('RI_ISS_CD')
      THEN
         BEGIN
            FOR r IN (SELECT a.ri_cd ri_cd, b.ri_name ri_name
                        FROM gicl_claims a, giis_reinsurer b
                       WHERE a.ri_cd = b.ri_cd AND a.claim_id = p_claim_id)
            LOOP
               v_intm_ri := TO_CHAR (r.ri_cd) || CHR (10) || r.ri_name;
            END LOOP;
         END;
      ELSE
         IF p_intm_break = 1
         THEN
            BEGIN
               FOR i IN (SELECT a.intm_no intm_no, b.intm_name intm_name,
                                b.ref_intm_cd ref_intm_cd
                           FROM gicl_res_brdrx_extr a, giis_intermediary b
                          WHERE a.intm_no = b.intm_no
                            AND a.session_id = p_session_id
                            AND a.claim_id = p_claim_id
                            AND a.item_no = p_item_no
                            AND a.peril_cd = p_peril_cd
                            AND a.intm_no = p_intm_no)
               LOOP
                  v_intm_ri :=
                        TO_CHAR (i.intm_no)
                     || '/'
                     || i.ref_intm_cd
                     || CHR (10)
                     || i.intm_name;
               END LOOP;
            END;
         ELSIF p_intm_break = 0
         THEN
            BEGIN
               FOR m IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                           FROM gicl_intm_itmperil a, giis_intermediary b
                          WHERE a.intm_no = b.intm_no
                            AND a.claim_id = p_claim_id
                            AND a.item_no = p_item_no
                            AND a.peril_cd = p_peril_cd)
               LOOP
                  v_intm_ri :=
                        TO_CHAR (m.intm_no)
                     || '/'
                     || m.ref_intm_cd
                     || CHR (10)
                     || m.intm_name
                     || CHR (10)
                     || v_intm_ri;
               END LOOP;
            END;
         END IF;
      END IF;

      RETURN (v_intm_ri);
   END cf_intm_riformula;
  

   FUNCTION cf_dv_noformula (
      p_paid_losses   VARCHAR2,
      p_claim_id      VARCHAR2,
      p_clm_loss_id   VARCHAR2,
      p_paid_date     VARCHAR2,
      p_from_date     VARCHAR2,
      p_to_date       VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_dv_no         VARCHAR2 (100);
      var_dv_no       VARCHAR2 (500);
      v_cancel_date   gicl_clm_res_hist.cancel_date%TYPE;
      v_loss          NUMBER;
   BEGIN
      FOR a IN (SELECT SIGN (p_paid_losses) losses_paid
                  FROM DUAL)
      LOOP
         v_loss := a.losses_paid;

         IF v_loss < 1
         THEN
            FOR v1 IN (SELECT DISTINCT    b.dv_pref
                                       || '-'
                                       || LTRIM (TO_CHAR (b.dv_no, '0999999999'))
                                                                          dv_no,
                                       TO_CHAR (a.cancel_date,
                                                'MM/DD/YYYY'
                                               ) cancel_date
                                  FROM gicl_clm_res_hist a,
                                       giac_disb_vouchers b,
                                       giac_acctrans c,
                                       giac_reversals d
                                 WHERE a.tran_id = b.gacc_tran_id
                                   AND a.tran_id = d.gacc_tran_id
                                   AND c.tran_id = d.reversing_tran_id
                                   AND a.claim_id = p_claim_id
                                   AND a.clm_loss_id = p_clm_loss_id
                              GROUP BY b.dv_pref, b.dv_no, a.cancel_date
                                HAVING SUM (NVL (a.losses_paid, 0)) > 0)
            LOOP
               v_dv_no := v1.dv_no || CHR (10) || 'cancelled ' || v1.cancel_date;

               IF var_dv_no IS NULL
               THEN
                  var_dv_no := v_dv_no;
               ELSE
                  var_dv_no := v_dv_no || CHR (10) || var_dv_no;
               END IF;
            END LOOP;
         ELSE
            FOR v2 IN (SELECT DISTINCT    b.dv_pref
                                       || '-'
                                       || LTRIM (TO_CHAR (b.dv_no, '0999999999'))
                                                                          dv_no
                                  FROM gicl_clm_res_hist a,
                                       giac_disb_vouchers b,
                                       giac_direct_claim_payts c,
                                       giac_acctrans d
                                 WHERE a.tran_id = d.tran_id
                                   AND b.gacc_tran_id = c.gacc_tran_id
                                   AND b.gacc_tran_id = d.tran_id
                                   AND a.claim_id = p_claim_id
                                   AND a.clm_loss_id = p_clm_loss_id
                                   AND DECODE (p_paid_date,
                                               1, TRUNC (a.date_paid),
                                               2, TRUNC (d.posting_date)
                                              ) BETWEEN TO_DATE(p_from_date, 'mm-dd-yyyy') AND TO_DATE(p_to_date, 'mm-dd-yyyy')
                              GROUP BY b.dv_pref, b.dv_no
                                HAVING SUM (NVL (a.losses_paid, 0)) > 0)
            LOOP
               v_dv_no := v2.dv_no;

               IF var_dv_no IS NULL
               THEN
                  var_dv_no := v_dv_no;
               ELSE
                  var_dv_no := v_dv_no || CHR (10) || var_dv_no;
               END IF;
            END LOOP;
         END IF;
      END LOOP;

      RETURN (var_dv_no);
   END cf_dv_noformula;   

END;
/


