CREATE OR REPLACE PACKAGE BODY CPI.gicls204_pkg
 /*
**  Created by        : bonok
**  Date Created      : 08.01.2013
**  Reference By      : GICLS204 - LOSS RATIO
**
*/
AS
   FUNCTION get_line_gicls204_lov (p_iss_cd giis_issource.iss_cd%TYPE, p_module_id giis_modules.module_id%TYPE, p_user_id giis_users.user_id%TYPE)
      RETURN line_gicls204_lov_tab PIPELINED
   AS
      res   line_gicls204_lov_type;
   BEGIN
      IF p_iss_cd IS NULL
      THEN
          FOR i IN (SELECT   line_name, line_cd
                        FROM giis_line a
                       WHERE a.line_cd IN (
                                             SELECT line_cd
                                               FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                           )
                    ORDER BY line_name)
          LOOP
             res.line_cd := i.line_cd;
             res.line_name := i.line_name;
             PIPE ROW (res);
          END LOOP;      
      ELSE      
          FOR i IN (SELECT   line_name, line_cd
                        FROM giis_line a
                       WHERE (a.line_cd, p_iss_cd) IN (
                                                 SELECT line_cd, branch_cd
                                                   FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                )
                    ORDER BY line_name)
          LOOP
             res.line_cd := i.line_cd;
             res.line_name := i.line_name;
             PIPE ROW (res);
          END LOOP;
      END IF;
   END;

   FUNCTION get_subline_gicls204_lov (p_line_cd giis_subline.line_cd%TYPE)
      RETURN subline_gicls204_lov_tab PIPELINED
   AS
      res   subline_gicls204_lov_type;
   BEGIN
      FOR i IN (SELECT   subline_cd, subline_name
                    FROM giis_subline
                   WHERE line_cd = NVL (p_line_cd, line_cd)
                ORDER BY subline_cd)
      LOOP
         res.subline_cd := i.subline_cd;
         res.subline_name := i.subline_name;
         PIPE ROW (res);
      END LOOP;
   END;

   FUNCTION get_iss_gicls204_lov (p_line_cd giis_line.line_cd%TYPE, p_module_id giis_modules.module_id%TYPE, p_user_id giis_users.user_id%TYPE)
      RETURN iss_gicls204_lov_tab PIPELINED
   AS
      res   iss_gicls204_lov_type;
   BEGIN
      IF p_line_cd IS NOT NULL
      THEN
          FOR i IN (SELECT   iss_cd, iss_name
                        FROM giis_issource a
                       WHERE (p_line_cd, a.iss_cd) IN (
                                                   SELECT line_cd, branch_cd
                                                       FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                   )
                    ORDER BY iss_name)
          LOOP
             res.iss_cd := i.iss_cd;
             res.iss_name := i.iss_name;
             PIPE ROW (res);
          END LOOP;      
      ELSE
          FOR i IN (SELECT   iss_cd, iss_name
                        FROM giis_issource a
                       WHERE iss_cd IN (
                                         SELECT branch_cd
                                           FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                        )
                    ORDER BY iss_name)
          LOOP
             res.iss_cd := i.iss_cd;
             res.iss_name := i.iss_name;
             PIPE ROW (res);
          END LOOP;
      END IF;
   END;

   FUNCTION get_intm_gicls204_lov
      RETURN intm_gicls204_lov_tab PIPELINED
   AS
      res   intm_gicls204_lov_type;
   BEGIN
      FOR i IN (SELECT   intm_no, intm_name
                    FROM giis_intermediary
                ORDER BY intm_name)
      LOOP
         res.intm_no := i.intm_no;
         res.intm_name := i.intm_name;
         PIPE ROW (res);
      END LOOP;
   END;

   FUNCTION get_assd_gicls204_lov
      RETURN assd_gicls204_lov_tab PIPELINED
   AS
      res   assd_gicls204_lov_type;
   BEGIN
      FOR i IN (SELECT   assd_no, assd_name
                    FROM giis_assured
                ORDER BY assd_name)
      LOOP
         res.assd_no := i.assd_no;
         res.assd_name := i.assd_name;
         PIPE ROW (res);
      END LOOP;
   END;

   FUNCTION get_peril_gicls204_lov (p_line_cd giis_peril.line_cd%TYPE)
      RETURN peril_gicls204_lov_tab PIPELINED
   AS
      res   peril_gicls204_lov_type;
   BEGIN
      FOR i IN (SELECT   peril_cd, peril_name
                    FROM giis_peril
                   WHERE line_cd = NVL (p_line_cd, line_cd)
                ORDER BY peril_name)
      LOOP
         res.peril_cd := i.peril_cd;
         res.peril_name := i.peril_name;
         PIPE ROW (res);
      END LOOP;
   END;

   FUNCTION validate_assd_no_gicls204 (p_assd_no giis_assured.assd_no%TYPE)
      RETURN VARCHAR2
   AS
      v_assd_name   giis_assured.assd_name%TYPE;
   BEGIN
      SELECT assd_name
        INTO v_assd_name
        FROM giis_assured
       WHERE assd_no = p_assd_no;

      RETURN v_assd_name;
   END;

   FUNCTION validate_peril_cd_gicls204 (p_line_cd giis_peril.line_cd%TYPE, p_peril_cd giis_peril.peril_cd%TYPE)
      RETURN VARCHAR2
   AS
      v_peril_name   giis_peril.peril_name%TYPE;
   BEGIN
      SELECT peril_name
        INTO v_peril_name
        FROM giis_peril
       WHERE line_cd = p_line_cd AND peril_cd = p_peril_cd;

      RETURN v_peril_name;
   END;

   FUNCTION get_session_id
      RETURN NUMBER
   IS
      v_session_id   gicl_lratio_curr_prem_ext.session_id%TYPE;
   BEGIN
      FOR s IN (SELECT loss_ratio_session_id_s.NEXTVAL session_id
                  FROM DUAL)
      LOOP
         v_session_id := s.session_id;
         EXIT;
      END LOOP;

      RETURN v_session_id;
   END;

   PROCEDURE extract_gicls204 (
      p_assd_no             IN giis_assured.assd_no%TYPE,
      p_date                IN gipi_polbasic.issue_date%TYPE,
      p_date_24th           IN VARCHAR2,
      p_extract_cat         IN VARCHAR2,
      p_extract_proc        IN VARCHAR2,
      p_intm_no             IN giis_intermediary.intm_no%TYPE,
      p_iss_cd              IN giis_issource.iss_cd%TYPE,
      p_issue_option        IN VARCHAR2,
      p_line_cd             IN giis_line.line_cd%TYPE,
      p_peril_cd            IN giis_peril.peril_cd%TYPE,
      p_prnt_date           IN VARCHAR2,
      p_prnt_option         IN VARCHAR2,
      p_subline_cd          IN giis_subline.subline_cd%TYPE,
      p_user_id             IN giis_users.user_id%TYPE,
      p_cnt                 OUT NUMBER,
      p_curr_24             OUT VARCHAR2,
      p_curr1_24            OUT VARCHAR2,
      p_curr_os_sw          OUT VARCHAR2,
      p_curr_prem_sw        OUT VARCHAR2,
      p_loss_paid_sw        OUT VARCHAR2,
      p_prev_24             OUT VARCHAR2,
      p_prev1_24            OUT VARCHAR2,
      p_prev_os_sw          OUT VARCHAR2,
      p_prev_prem_sw        OUT VARCHAR2,
      p_prev_rec_sw         OUT VARCHAR2,
      p_prev_year            OUT VARCHAR2,
      p_curr_rec_sw         OUT VARCHAR2,
      p_session_id          OUT NUMBER
   )
   IS
      v_cnt             NUMBER                                      := 0;
      v_session_id      gicl_lratio_curr_prem_ext.session_id%TYPE;
      v_date            gipi_polbasic.issue_date%TYPE;
      v_date1           VARCHAR2(12);
      v_curr1_date      gipi_polbasic.issue_date%TYPE;
      v_curr2_date      gipi_polbasic.issue_date%TYPE;
      v_prev1_date      gipi_polbasic.issue_date%TYPE;
      v_prev2_date      gipi_polbasic.issue_date%TYPE;
      v_prev_year       VARCHAR2 (4);
      v_line_cd         giis_line.line_cd%TYPE;
      v_ast             VARCHAR2 (1)                                := '*';
      v_cprem_exists    VARCHAR2 (1)                                := 'N';
      v_pprem_exists    VARCHAR2 (1)                                := 'N';
      v_lpaid_exists    VARCHAR2 (1)                                := 'N';
      v_cos_exists      VARCHAR2 (1)                                := 'N';
      v_pos_exists      VARCHAR2 (1)                                := 'N';
      v_crec_exists     VARCHAR2 (1)                                := 'N';
      v_prec_exists     VARCHAR2 (1)                                := 'N';
      v_book_recovery   VARCHAR2 (1)                                := giisp.v ('BOOK_RECOVERY_LRATIO');
   BEGIN
      v_session_id := get_session_id;

      IF p_extract_proc = 'S' THEN
         v_date := p_date;
         v_curr1_date := TO_DATE ('01-01-' || TO_CHAR (v_date, 'YYYY'), 'MM-DD-YYYY');
         v_curr2_date := TRUNC (v_date);
         v_prev_year := TO_CHAR (TO_NUMBER (TO_CHAR (v_date, 'YYYY')) - 1);
         v_prev1_date := TO_DATE ('01-01-' || v_prev_year, 'MM-DD-YYYY');
         v_prev2_date := TO_DATE ('12-31-' || v_prev_year, 'MM-DD-YYYY');
      ELSE
         v_date1 := TO_CHAR(LAST_DAY(TO_DATE(p_date_24th, 'mm-yyyy')),'mm-dd-yyyy');
         v_date := LAST_DAY(TO_DATE(p_date_24th, 'mm-yyyy'));
         
         FOR c IN (SELECT param_value_v
                     FROM giis_parameters
                    WHERE param_name = 'LINE_CODE_MN')
         LOOP
            v_line_cd := c.param_value_v;
            EXIT;
         END LOOP;

         SELECT (LAST_DAY (TO_DATE (TO_CHAR (v_date, 'mm-yyyy'), 'mm-yyyy'))), (TO_DATE (TO_CHAR (ADD_MONTHS (v_date, -11), 'mm-yyyy'), 'mm-yyyy')),
                (LAST_DAY (TO_DATE (TO_CHAR (ADD_MONTHS (v_date, -12), 'mm-yyyy'), 'mm-yyyy'))
                ), (TO_DATE (TO_CHAR (ADD_MONTHS (v_date, -23), 'mm-yyyy'), 'mm-yyyy'))
           INTO v_curr2_date, v_curr1_date,
                v_prev2_date, v_prev1_date
           FROM DUAL;

         p_curr_24 := v_curr2_date;
         p_curr1_24 := v_curr1_date;
         p_prev_24 := v_prev2_date;
         p_prev1_24 := v_prev1_date;

         IF NVL (p_line_cd, v_line_cd) = v_line_cd THEN
            pop_gicl_24th_tab_mn (v_date1, v_session_id, p_user_id);
         END IF;

         IF NVL (p_line_cd, v_ast) <> v_line_cd THEN
            pop_gicl_24th_tab (v_date1, v_session_id, p_user_id);
         END IF;
      END IF;

      lratio_extract_premium(p_line_cd, p_subline_cd, p_iss_cd, p_intm_no, p_assd_no, p_peril_cd,
                             v_session_id, p_prnt_date, p_issue_option, v_curr1_date, v_curr2_date,
                             v_prev1_date, v_prev2_date, v_cprem_exists, v_pprem_exists, p_extract_cat,
                             p_prnt_option, p_user_id);

      lratio_extract_losses_paid(p_line_cd, p_subline_cd, p_iss_cd, p_intm_no, p_assd_no, p_peril_cd,
                                 v_session_id, p_prnt_date, p_issue_option, v_curr1_date, v_curr2_date,
                                 v_lpaid_exists, p_extract_cat, p_prnt_option, p_user_id);

      lratio_extract_os(p_line_cd, p_subline_cd, p_iss_cd, p_intm_no, p_assd_no, p_peril_cd,
                        v_session_id, p_prnt_date, p_issue_option, v_curr1_date, v_curr2_date, 
                        v_prev1_date, v_prev2_date, v_cos_exists, v_pos_exists, p_extract_cat,
                        p_prnt_option, p_user_id); --drenx                        

      lratio_extract_recovery(p_line_cd, p_subline_cd, p_iss_cd, p_intm_no, p_assd_no, p_peril_cd,
                              v_session_id, p_prnt_date, p_issue_option, v_curr1_date, v_curr2_date,
                              v_prev1_date, v_prev2_date, v_crec_exists, v_prec_exists, p_extract_cat,
                              p_prnt_option, p_user_id);


      IF p_prnt_option = 1 THEN
         lratio_extract_by_line (p_line_cd, p_subline_cd, p_iss_cd, p_peril_cd, p_intm_no, p_assd_no, v_session_id, p_date, v_cnt, p_extract_proc, p_user_id, p_date);
      ELSIF p_prnt_option = 2 THEN
         lratio_extract_by_subline (p_line_cd, p_iss_cd, p_peril_cd, p_intm_no, p_assd_no, v_session_id, p_date, v_cnt, p_extract_proc, p_user_id, p_date);
      ELSIF p_prnt_option = 3 THEN
         lratio_extract_by_iss_cd (p_line_cd, p_subline_cd, p_peril_cd, p_intm_no, p_assd_no, v_session_id, p_date, v_cnt, p_extract_proc, p_user_id, p_date);
      ELSIF p_prnt_option = 4 THEN
         lratio_extract_by_intermediary (p_line_cd, p_subline_cd, p_iss_cd, p_peril_cd, p_assd_no, v_session_id, p_date, v_cnt, p_extract_proc, p_user_id, p_date);
      ELSIF p_prnt_option = 5 THEN
         lratio_extract_by_assured (p_line_cd, p_subline_cd, p_iss_cd, p_peril_cd, p_intm_no, v_session_id, p_date, v_cnt, p_extract_proc, p_user_id, p_date);
      ELSIF p_prnt_option = 6 THEN
         lratio_extract_by_peril (p_line_cd, p_subline_cd, p_iss_cd, p_intm_no, p_assd_no, v_session_id, p_date, v_cnt, p_extract_proc, p_user_id, p_date); -- Dren Niebres 07.12.2016 SR-21428
      END IF;      

      p_session_id := v_session_id;
      p_cnt := v_cnt;
      p_loss_paid_sw := v_lpaid_exists;
      p_curr_prem_sw := v_cprem_exists;
      p_prev_prem_sw := v_pprem_exists;
      p_curr_os_sw := v_cos_exists;
      p_prev_os_sw := v_pos_exists;
      p_curr_rec_sw := v_crec_exists;
      p_prev_rec_sw := v_prec_exists;
      p_prev_year := v_prev_year;
      p_curr_24 := TO_CHAR(v_curr2_date, 'mm-dd-yyyy');
      p_curr1_24 := TO_CHAR(v_curr1_date, 'mm-dd-yyyy');
      p_prev_24 := TO_CHAR(v_prev2_date, 'mm-dd-yyyy');
      p_prev1_24 := TO_CHAR(v_prev1_date, 'mm-dd-yyyy'); 
   END;

   PROCEDURE pop_gicl_24th_tab_mn (p_date IN VARCHAR2, p_session_id IN gicl_loss_ratio_ext.session_id%TYPE, p_user_id IN giis_users.user_id%TYPE)
   AS
      v_date     DATE                           := TO_DATE (p_date, 'mm-dd-yyyy');
      v_mm       gicl_24th_tab.col_mm%TYPE;
      v_month    gicl_24th_tab.col_month%TYPE;
      v_factor   gicl_24th_tab.factor%TYPE;
      v_fact     NUMBER (2)                     := 11;
      ctr        NUMBER (2)                     := 0;
   BEGIN
      DELETE FROM gicl_24th_tab_mn
            WHERE user_id = p_user_id;

      --COMMIT;
      FOR k IN 0 .. 11
      LOOP
         ctr := ctr + 1;

         IF k < 2 THEN
            DBMS_OUTPUT.put_line (TO_CHAR (ADD_MONTHS (v_date, -k), 'Month') || ' ' || v_fact || '/' || '24');
            v_mm := TO_NUMBER (TO_CHAR (ADD_MONTHS (v_date, -k), 'mm'), 99);
            v_month := TO_CHAR (ADD_MONTHS (v_date, -k), 'Month');
            v_factor := 1;
         ELSE
            v_mm := TO_NUMBER (TO_CHAR (ADD_MONTHS (v_date, -k), 'mm'), 99);
            v_month := TO_CHAR (ADD_MONTHS (v_date, -k), 'Month');
            v_factor := 0;
         END IF;

         INSERT INTO gicl_24th_tab_mn
                     (col_mm, col_month, factor, row_mm, session_id, user_id
                     )
              VALUES (v_mm, v_month, v_factor, ctr, p_session_id, p_user_id
                     );
      END LOOP;
   END;

   PROCEDURE pop_gicl_24th_tab (p_date IN VARCHAR2, p_session_id IN gicl_loss_ratio_ext.session_id%TYPE, p_user_id IN giis_users.user_id%TYPE)
   AS
      v_date     DATE                           := TO_DATE (p_date, 'mm-dd-yyyy');
      v_mm       gicl_24th_tab.col_mm%TYPE;
      v_month    gicl_24th_tab.col_month%TYPE;
      v_factor   gicl_24th_tab.factor%TYPE;
      v_fact     NUMBER (2)                     := 23;
      ctr        NUMBER (2)                     := 0;
   BEGIN
      DELETE FROM gicl_24th_tab
            WHERE user_id = p_user_id;

      --COMMIT;
      FOR k IN 0 .. 11
      LOOP
         ctr := ctr + 1;
         DBMS_OUTPUT.put_line (TO_CHAR (ADD_MONTHS (v_date, -k), 'Month') || ' ' || v_fact || '/' || '24');
         v_mm := TO_NUMBER (TO_CHAR (ADD_MONTHS (v_date, -k), 'mm'), 99);
         v_month := TO_CHAR (ADD_MONTHS (v_date, -k), 'Month');
         v_factor := v_fact / 24;

         INSERT INTO gicl_24th_tab
                     (col_mm, col_month, factor, row_mm, session_id, user_id
                     )
              VALUES (v_mm, v_month, v_factor, ctr, p_session_id, p_user_id
                     );

         v_fact := v_fact - 2;
      END LOOP;
   END;

   PROCEDURE lratio_extract_premium2 (
      p_line_cd             giis_line.line_cd%TYPE,
      p_subline_cd          giis_subline.subline_cd%TYPE,
      p_iss_cd              giis_issource.iss_cd%TYPE,
      p_peril_cd            giis_peril.peril_cd%TYPE,
      p_session_id          gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param          NUMBER,
      p_issue_param         NUMBER,
      p_curr1_date          gipi_polbasic.issue_date%TYPE,
      p_curr2_date          gipi_polbasic.issue_date%TYPE,
      p_prev1_date          gipi_polbasic.issue_date%TYPE,
      p_prev2_date          gipi_polbasic.issue_date%TYPE,
      p_prev_year           VARCHAR2,
      p_curr_exists   OUT   VARCHAR2,
      p_prev_exists   OUT   VARCHAR2,
      p_ext_proc            VARCHAR2,
      p_extract_cat         VARCHAR2,
      p_user_id             giis_users.user_id%TYPE
   )
   AS
      TYPE policy_id_tab IS TABLE OF gipi_polbasic.policy_id%TYPE;

      TYPE curr_prem_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE assd_no_tab IS TABLE OF giis_assured.assd_no%TYPE;

      TYPE peril_cd_tab IS TABLE OF giis_peril.peril_cd%TYPE;

      TYPE line_cd_tab IS TABLE OF giis_line.line_cd%TYPE;

      TYPE subline_cd_tab IS TABLE OF giis_subline.subline_cd%TYPE;

      TYPE iss_cd_tab IS TABLE OF giis_issource.iss_cd%TYPE;

      TYPE date24_tab IS TABLE OF VARCHAR2 (10);

      vv_policy_id    policy_id_tab;
      vv_prem         curr_prem_tab;
      vv_assd_no      assd_no_tab;
      vv_line_cd      line_cd_tab;
      vv_subline_cd   subline_cd_tab;
      vv_iss_cd       iss_cd_tab;
      vv_peril_cd     peril_cd_tab;
      vv_date24       date24_tab;
   BEGIN
      p_curr_exists := 'N';
      p_prev_exists := 'N';

      BEGIN
         DELETE      gicl_lratio_curr_prem_ext
               WHERE user_id = p_user_id;

         BEGIN
            SELECT d.policy_id, d.line_cd, d.subline_cd, d.iss_cd, c.peril_cd,
                   get_latest_assured_no (d.line_cd, d.subline_cd, d.iss_cd, d.issue_yy, d.pol_seq_no, d.renew_no, p_curr1_date, p_curr2_date) assd_no, (c.prem_amt * b.currency_rt) prem_amt,
                   TO_CHAR (d.acct_ent_date, 'MM-DD-YYYY') dt
            BULK COLLECT INTO vv_policy_id, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_peril_cd,
                   vv_assd_no, vv_prem,
                   vv_date24
              FROM gipi_polbasic d,
                   (SELECT   a.policy_id, a.item_no, a.peril_cd, DECODE (p_extract_cat, 'G', a.prem_amt, SUM (c.dist_prem)) prem_amt
                        FROM gipi_itmperil a, giuw_pol_dist b, giuw_itemperilds_dtl c
                       WHERE 1 = 1 AND a.policy_id = b.policy_id AND b.dist_no = c.dist_no AND a.item_no = c.item_no AND a.peril_cd = c.peril_cd AND c.share_cd = 1
                    GROUP BY a.policy_id, a.item_no, a.peril_cd, a.prem_amt) c,
                   (SELECT currency_rt, policy_id, item_no
                      FROM gipi_item
                     WHERE policy_id > 0 AND item_no > 0) b
             WHERE d.policy_id = c.policy_id
               AND d.line_cd = NVL (p_line_cd, d.line_cd)
               AND d.subline_cd = NVL (p_subline_cd, d.subline_cd)
               AND d.iss_cd = NVL (p_iss_cd, d.iss_cd)
               AND c.peril_cd = NVL (p_peril_cd, c.peril_cd)
               AND TRUNC (d.acct_ent_date) >= p_curr1_date
               AND TRUNC (d.acct_ent_date) <= p_curr2_date
               AND d.pol_flag IN ('1', '2', '3', '4', 'X')
               AND c.prem_amt <> 0
               AND b.policy_id = c.policy_id
               AND b.item_no = c.item_no;

            IF SQL%FOUND THEN
               p_curr_exists := 'Y';
               FORALL i IN vv_policy_id.FIRST .. vv_policy_id.LAST
                  INSERT INTO gicl_lratio_curr_prem_ext
                              (session_id, assd_no, policy_id, line_cd, subline_cd, iss_cd, peril_cd, prem_amt, user_id,
                               date_for_24th
                              )
                       VALUES (p_session_id, vv_assd_no (i), vv_policy_id (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), vv_prem (i), p_user_id,
                               TO_DATE (vv_date24 (i), 'MM-DD-YYYY')
                              );
               vv_assd_no.DELETE;
               vv_policy_id.DELETE;
               vv_prem.DELETE;
               vv_line_cd.DELETE;
               vv_subline_cd.DELETE;
               vv_iss_cd.DELETE;
               vv_peril_cd.DELETE;
               vv_date24.DELETE;
            END IF;
         END;

         BEGIN
            SELECT d.policy_id, d.line_cd, d.subline_cd, d.iss_cd, c.peril_cd,
                   get_latest_assured_no (d.line_cd, d.subline_cd, d.iss_cd, d.issue_yy, d.pol_seq_no, d.renew_no, p_curr1_date, p_curr2_date) assd_no, (c.prem_amt * b.currency_rt) prem_amt,
                   TO_CHAR (d.spld_acct_ent_date, 'MM-DD-YYYY') dt
            BULK COLLECT INTO vv_policy_id, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_peril_cd,
                   vv_assd_no, vv_prem,
                   vv_date24
              FROM gipi_polbasic d,
                   (SELECT   a.policy_id, a.item_no, a.peril_cd, DECODE (p_extract_cat, 'G', a.prem_amt, SUM (c.dist_prem)) prem_amt
                        FROM gipi_itmperil a, giuw_pol_dist b, giuw_itemperilds_dtl c
                       WHERE 1 = 1 AND a.policy_id = b.policy_id AND b.dist_no = c.dist_no AND a.item_no = c.item_no AND a.peril_cd = c.peril_cd AND c.share_cd = 1
                    GROUP BY a.policy_id, a.item_no, a.peril_cd, a.prem_amt) c,
                   (SELECT currency_rt, policy_id, item_no
                      FROM gipi_item
                     WHERE policy_id > 0 AND item_no > 0) b
             WHERE d.policy_id = c.policy_id
               AND d.line_cd = NVL (p_line_cd, d.line_cd)
               AND d.subline_cd = NVL (p_subline_cd, d.subline_cd)
               AND d.iss_cd = NVL (p_iss_cd, d.iss_cd)
               AND c.peril_cd = NVL (p_peril_cd, c.peril_cd)
               AND TRUNC (d.spld_acct_ent_date) >= p_curr1_date
               AND TRUNC (d.spld_acct_ent_date) <= p_curr2_date
               AND d.pol_flag IN ('1', '2', '3', '4', 'X')
               AND c.prem_amt <> 0
               AND b.policy_id = c.policy_id
               AND b.item_no = c.item_no;

            IF SQL%FOUND THEN
               p_curr_exists := 'Y';
               FORALL i IN vv_policy_id.FIRST .. vv_policy_id.LAST
                  INSERT INTO gicl_lratio_curr_prem_ext
                              (session_id, assd_no, policy_id, line_cd, subline_cd, iss_cd, peril_cd, prem_amt, user_id, spld_sw,
                               date_for_24th
                              )
                       VALUES (p_session_id, vv_assd_no (i), vv_policy_id (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), -vv_prem (i), p_user_id, 'Y',
                               TO_DATE (vv_date24 (i), 'MM-DD-YYYY')
                              );
               vv_assd_no.DELETE;
               vv_policy_id.DELETE;
               vv_prem.DELETE;
               vv_line_cd.DELETE;
               vv_subline_cd.DELETE;
               vv_iss_cd.DELETE;
               vv_peril_cd.DELETE;
               vv_date24.DELETE;
            END IF;
         END;

         FOR del_spld IN (SELECT a.policy_id
                            FROM gicl_lratio_curr_prem_ext a, gicl_lratio_curr_prem_ext b
                           WHERE a.session_id = p_session_id AND a.session_id = b.session_id AND a.policy_id = b.policy_id AND NVL (a.spld_sw, 'N') = 'Y' AND NVL (b.spld_sw, 'N') = 'N')
         LOOP
            DELETE      gicl_lratio_curr_prem_ext
                  WHERE policy_id = del_spld.policy_id AND session_id = p_session_id;
         END LOOP;
      END;

      BEGIN
         DELETE      gicl_lratio_prev_prem_ext
               WHERE user_id = p_user_id;

         BEGIN
            SELECT d.policy_id, d.line_cd, d.subline_cd, d.iss_cd, c.peril_cd,
                   get_latest_assured_no (d.line_cd, d.subline_cd, d.iss_cd, d.issue_yy, d.pol_seq_no, d.renew_no, p_prev1_date, p_prev2_date) assd_no, (c.prem_amt * b.currency_rt) prem_amt,
                   TO_CHAR (d.acct_ent_date, 'MM-DD-YYYY')
            BULK COLLECT INTO vv_policy_id, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_peril_cd,
                   vv_assd_no, vv_prem,
                   vv_date24
              FROM gipi_polbasic d,
                   (SELECT   a.policy_id, a.item_no, a.peril_cd, DECODE (p_extract_cat, 'G', a.prem_amt, SUM (c.dist_prem)) prem_amt
                        FROM gipi_itmperil a, giuw_pol_dist b, giuw_itemperilds_dtl c
                       WHERE 1 = 1 AND a.policy_id = b.policy_id AND b.dist_no = c.dist_no AND a.item_no = c.item_no AND a.peril_cd = c.peril_cd AND c.share_cd = 1
                    GROUP BY a.policy_id, a.item_no, a.peril_cd, a.prem_amt) c,
                   (SELECT currency_rt, policy_id, item_no
                      FROM gipi_item
                     WHERE policy_id > 0 AND item_no > 0) b
             WHERE d.policy_id = c.policy_id
               AND d.line_cd = NVL (p_line_cd, d.line_cd)
               AND d.subline_cd = NVL (p_subline_cd, d.subline_cd)
               AND d.iss_cd = NVL (p_iss_cd, d.iss_cd)
               AND c.peril_cd = NVL (p_peril_cd, c.peril_cd)
               AND c.prem_amt <> 0
               AND b.policy_id = c.policy_id
               AND b.item_no = c.item_no
               AND ((p_ext_proc = 'S' AND TO_CHAR (d.acct_ent_date, 'YYYY') = p_prev_year) OR (p_ext_proc = 'M' AND TRUNC (d.acct_ent_date) >= p_prev1_date AND TRUNC (d.acct_ent_date) <= p_prev2_date))
               AND d.pol_flag IN ('1', '2', '3', '4', 'X');

            IF SQL%FOUND THEN
               p_prev_exists := 'Y';
               FORALL i IN vv_policy_id.FIRST .. vv_policy_id.LAST
                  INSERT INTO gicl_lratio_prev_prem_ext
                              (session_id, assd_no, policy_id, line_cd, subline_cd, iss_cd, peril_cd, prem_amt, user_id,
                               date_for_24th
                              )
                       VALUES (p_session_id, vv_assd_no (i), vv_policy_id (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), vv_prem (i), p_user_id,
                               TO_DATE (vv_date24 (i), 'MM-DD-YYYY')
                              );
               vv_assd_no.DELETE;
               vv_policy_id.DELETE;
               vv_prem.DELETE;
               vv_line_cd.DELETE;
               vv_subline_cd.DELETE;
               vv_iss_cd.DELETE;
               vv_peril_cd.DELETE;
               vv_date24.DELETE;
            END IF;
         END;

         BEGIN
            SELECT d.policy_id, d.line_cd, d.subline_cd, d.iss_cd, c.peril_cd,
                   get_latest_assured_no (d.line_cd, d.subline_cd, d.iss_cd, d.issue_yy, d.pol_seq_no, d.renew_no, p_prev1_date, p_prev2_date) assd_no, (c.prem_amt * b.currency_rt) prem_amt,
                   TO_CHAR (d.spld_acct_ent_date, 'MM-DD-YYYY')
            BULK COLLECT INTO vv_policy_id, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_peril_cd,
                   vv_assd_no, vv_prem,
                   vv_date24
              FROM gipi_polbasic d,
                   (SELECT   a.policy_id, a.item_no, a.peril_cd, DECODE (p_extract_cat, 'G', a.prem_amt, SUM (c.dist_prem)) prem_amt
                        FROM gipi_itmperil a, giuw_pol_dist b, giuw_itemperilds_dtl c
                       WHERE 1 = 1 AND a.policy_id = b.policy_id AND b.dist_no = c.dist_no AND a.item_no = c.item_no AND a.peril_cd = c.peril_cd AND c.share_cd = 1
                    GROUP BY a.policy_id, a.item_no, a.peril_cd, a.prem_amt) c,
                   (SELECT currency_rt, policy_id, item_no
                      FROM gipi_item
                     WHERE policy_id > 0 AND item_no > 0) b
             WHERE d.policy_id = c.policy_id
               AND d.line_cd = NVL (p_line_cd, d.line_cd)
               AND d.subline_cd = NVL (p_subline_cd, d.subline_cd)
               AND d.iss_cd = NVL (p_iss_cd, d.iss_cd)
               AND c.peril_cd = NVL (p_peril_cd, c.peril_cd)
               AND c.prem_amt <> 0
               AND b.policy_id = c.policy_id
               AND b.item_no = c.item_no
               AND (   (p_ext_proc = 'S' AND TO_CHAR (d.spld_acct_ent_date, 'YYYY') = p_prev_year)
                    OR (p_ext_proc = 'M' AND TRUNC (d.spld_acct_ent_date) >= p_prev1_date AND TRUNC (d.spld_acct_ent_date) <= p_prev2_date)
                   )
               AND d.pol_flag IN ('1', '2', '3', '4', 'X');

            IF SQL%FOUND THEN
               p_prev_exists := 'Y';
               FORALL i IN vv_policy_id.FIRST .. vv_policy_id.LAST
                  INSERT INTO gicl_lratio_prev_prem_ext
                              (session_id, assd_no, policy_id, line_cd, subline_cd, iss_cd, peril_cd, prem_amt, user_id, spld_sw,
                               date_for_24th
                              )
                       VALUES (p_session_id, vv_assd_no (i), vv_policy_id (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), -vv_prem (i), p_user_id, 'Y',
                               TO_DATE (vv_date24 (i), 'MM-DD-YYYY')
                              );
            END IF;
         END;

         FOR del_spld IN (SELECT a.policy_id
                            FROM gicl_lratio_prev_prem_ext a, gicl_lratio_prev_prem_ext b
                           WHERE a.session_id = p_session_id AND a.session_id = b.session_id AND a.policy_id = b.policy_id AND NVL (a.spld_sw, 'N') = 'Y' AND NVL (b.spld_sw, 'N') = 'N')
         LOOP
            DELETE      gicl_lratio_prev_prem_ext
                  WHERE policy_id = del_spld.policy_id AND session_id = p_session_id;
         END LOOP;
      END;
   END;

   PROCEDURE lratio_extract_premium3 (
      p_line_cd             giis_line.line_cd%TYPE,
      p_subline_cd          giis_subline.subline_cd%TYPE,
      p_iss_cd              giis_issource.iss_cd%TYPE,
      p_peril_cd            giis_peril.peril_cd%TYPE,
      p_session_id          gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param          NUMBER,
      p_issue_param         NUMBER,
      p_curr1_date          gipi_polbasic.issue_date%TYPE,
      p_curr2_date          gipi_polbasic.issue_date%TYPE,
      p_prev1_date          gipi_polbasic.issue_date%TYPE,
      p_prev2_date          gipi_polbasic.issue_date%TYPE,
      p_prev_year           VARCHAR2,
      p_curr_exists   OUT   VARCHAR2,
      p_prev_exists   OUT   VARCHAR2,
      p_ext_proc            VARCHAR2,
      p_extract_cat         VARCHAR2,
      p_user_id             giis_users.user_id%TYPE
   )
   AS
      TYPE policy_id_tab IS TABLE OF gipi_polbasic.policy_id%TYPE;

      TYPE curr_prem_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE assd_no_tab IS TABLE OF giis_assured.assd_no%TYPE;

      TYPE peril_cd_tab IS TABLE OF giis_peril.peril_cd%TYPE;

      TYPE line_cd_tab IS TABLE OF giis_line.line_cd%TYPE;

      TYPE subline_cd_tab IS TABLE OF giis_subline.subline_cd%TYPE;

      TYPE iss_cd_tab IS TABLE OF giis_issource.iss_cd%TYPE;

      TYPE date24_tab IS TABLE OF VARCHAR2 (10);

      vv_policy_id    policy_id_tab;
      vv_prem         curr_prem_tab;
      vv_assd_no      assd_no_tab;
      vv_line_cd      line_cd_tab;
      vv_subline_cd   subline_cd_tab;
      vv_iss_cd       iss_cd_tab;
      vv_peril_cd     peril_cd_tab;
      vv_date24       date24_tab;
   BEGIN
      p_curr_exists := 'N';
      p_prev_exists := 'N';

      BEGIN
         DELETE      gicl_lratio_curr_prem_ext
               WHERE user_id = p_user_id;

         SELECT d.policy_id, d.line_cd, d.subline_cd, d.iss_cd, c.peril_cd,
                get_latest_assured_no (d.line_cd, d.subline_cd, d.iss_cd, d.issue_yy, d.pol_seq_no, d.renew_no, p_curr1_date, p_curr2_date) assd_no, (c.prem_amt * b.currency_rt) prem_amt,
                TO_CHAR (TRUNC (DECODE (p_date_param, 1, d.issue_date, 2, d.eff_date, 4, LAST_DAY (TO_DATE (UPPER (d.booking_mth) || ' 1,' || TO_CHAR (d.booking_year), 'FMMONTH DD,YYYY')), SYSDATE)),
                         'MM-DD-YYYY'
                        )
         BULK COLLECT INTO vv_policy_id, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_peril_cd,
                vv_assd_no, vv_prem,
                vv_date24
           FROM gipi_polbasic d,
                (SELECT   a.policy_id, a.item_no, a.peril_cd, DECODE (p_extract_cat, 'G', a.prem_amt, SUM (c.dist_prem)) prem_amt
                     FROM gipi_itmperil a, giuw_pol_dist b, giuw_itemperilds_dtl c
                    WHERE 1 = 1 AND a.policy_id = b.policy_id AND b.dist_no = c.dist_no AND a.item_no = c.item_no AND a.peril_cd = c.peril_cd AND c.share_cd = 1
                 GROUP BY a.policy_id, a.item_no, a.peril_cd, a.prem_amt) c,
                (SELECT currency_rt, policy_id, item_no
                   FROM gipi_item
                  WHERE policy_id > 0 AND item_no > 0) b
          WHERE d.line_cd = NVL (p_line_cd, d.line_cd)
            AND d.subline_cd = NVL (p_subline_cd, d.subline_cd)
            AND d.iss_cd = NVL (p_iss_cd, d.iss_cd)
            AND c.peril_cd = NVL (p_peril_cd, c.peril_cd)
            AND c.prem_amt <> 0
            AND TRUNC (DECODE (p_date_param, 1, d.issue_date, 2, d.eff_date, 4, LAST_DAY (TO_DATE (UPPER (d.booking_mth) || ' 1,' || TO_CHAR (d.booking_year), 'FMMONTH DD,YYYY')), SYSDATE)) >=
                                                                                                                                                                                            p_curr1_date
            AND TRUNC (DECODE (p_date_param, 1, d.issue_date, 2, d.eff_date, 4, LAST_DAY (TO_DATE (UPPER (d.booking_mth) || ' 1,' || TO_CHAR (d.booking_year), 'FMMONTH DD,YYYY')), SYSDATE)) <=
                                                                                                                                                                                            p_curr2_date
            AND d.pol_flag IN ('1', '2', '3', '4', 'X')
            AND b.policy_id = c.policy_id
            AND b.item_no = c.item_no
            AND d.policy_id = c.policy_id;

         IF SQL%FOUND THEN
            p_curr_exists := 'Y';
            FORALL i IN vv_policy_id.FIRST .. vv_policy_id.LAST
               INSERT INTO gicl_lratio_curr_prem_ext
                           (session_id, assd_no, policy_id, line_cd, subline_cd, iss_cd, peril_cd, prem_amt, user_id, date_for_24th
                           )
                    VALUES (p_session_id, vv_assd_no (i), vv_policy_id (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), vv_prem (i), p_user_id, TO_DATE (vv_date24 (i), 'MM-DD-YYYY')
                           );
            vv_assd_no.DELETE;
            vv_policy_id.DELETE;
            vv_prem.DELETE;
            vv_line_cd.DELETE;
            vv_subline_cd.DELETE;
            vv_iss_cd.DELETE;
            vv_peril_cd.DELETE;
            vv_date24.DELETE;
         END IF;
      END;

      BEGIN
         DELETE      gicl_lratio_prev_prem_ext
               WHERE user_id = p_user_id;

         SELECT d.policy_id, d.line_cd, d.subline_cd, d.iss_cd, c.peril_cd,
                get_latest_assured_no (d.line_cd, d.subline_cd, d.iss_cd, d.issue_yy, d.pol_seq_no, d.renew_no, p_prev1_date, p_prev2_date) assd_no, (c.prem_amt * b.currency_rt) prem_amt,
                TO_CHAR (TRUNC (DECODE (p_date_param, 1, d.issue_date, 2, d.eff_date, 4, LAST_DAY (TO_DATE (UPPER (d.booking_mth) || ' 1,' || TO_CHAR (d.booking_year), 'FMMONTH DD,YYYY')), SYSDATE)),
                         'MM-DD-YYYY'
                        )
         BULK COLLECT INTO vv_policy_id, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_peril_cd,
                vv_assd_no, vv_prem,
                vv_date24
           FROM gipi_polbasic d,
                (SELECT   a.policy_id, a.item_no, a.peril_cd, DECODE (p_extract_cat, 'G', a.prem_amt, SUM (c.dist_prem)) prem_amt
                     FROM gipi_itmperil a, giuw_pol_dist b, giuw_itemperilds_dtl c
                    WHERE 1 = 1 AND a.policy_id = b.policy_id AND b.dist_no = c.dist_no AND a.item_no = c.item_no AND a.peril_cd = c.peril_cd AND c.share_cd = 1
                 GROUP BY a.policy_id, a.item_no, a.peril_cd, a.prem_amt) c,
                (SELECT currency_rt, policy_id, item_no
                   FROM gipi_item
                  WHERE policy_id > 0 AND item_no > 0) b
          WHERE d.line_cd = NVL (p_line_cd, d.line_cd)
            AND d.subline_cd = NVL (p_subline_cd, d.subline_cd)
            AND d.iss_cd = NVL (p_iss_cd, d.iss_cd)
            AND c.peril_cd = NVL (p_peril_cd, c.peril_cd)
            AND c.prem_amt <> 0
            AND (   (p_ext_proc = 'S' AND DECODE (p_date_param, 1, TO_CHAR (d.issue_date, 'YYYY'), 2, TO_CHAR (d.eff_date, 'YYYY'), 4, TO_CHAR (d.booking_year), TO_CHAR (SYSDATE, 'YYYY')) =
                                                                                                                                                                                             p_prev_year
                    )
                 OR (    p_ext_proc = 'M'
                     AND TRUNC (DECODE (p_date_param, 1, d.issue_date, 2, d.eff_date, 4, LAST_DAY (TO_DATE (UPPER (d.booking_mth) || ' 1,' || TO_CHAR (d.booking_year), 'FMMONTH DD,YYYY')), SYSDATE)) >=
                                                                                                                                                                                            p_prev1_date
                     AND TRUNC (DECODE (p_date_param, 1, d.issue_date, 2, d.eff_date, 4, LAST_DAY (TO_DATE (UPPER (d.booking_mth) || ' 1,' || TO_CHAR (d.booking_year), 'FMMONTH DD,YYYY')), SYSDATE)) <=
                                                                                                                                                                                            p_prev2_date
                    )
                )
            AND d.pol_flag IN ('1', '2', '3', '4', 'X')
            AND c.policy_id = b.policy_id
            AND c.item_no = b.item_no
            AND d.policy_id = c.policy_id;

         IF SQL%FOUND THEN
            p_prev_exists := 'Y';
            FORALL i IN vv_policy_id.FIRST .. vv_policy_id.LAST
               INSERT INTO gicl_lratio_prev_prem_ext
                           (session_id, assd_no, policy_id, line_cd, subline_cd, iss_cd, peril_cd, prem_amt, user_id, date_for_24th
                           )
                    VALUES (p_session_id, vv_assd_no (i), vv_policy_id (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), vv_prem (i), p_user_id, TO_DATE (vv_date24 (i), 'MM-DD-YYYY')
                           );
         END IF;
      END;
   END;

   PROCEDURE lratio_extract_premium2_assd (
      p_line_cd             giis_line.line_cd%TYPE,
      p_subline_cd          giis_subline.subline_cd%TYPE,
      p_iss_cd              giis_issource.iss_cd%TYPE,
      p_peril_cd            giis_peril.peril_cd%TYPE,
      p_assd_no             giis_assured.assd_no%TYPE,
      p_session_id          gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param          NUMBER,
      p_issue_param         NUMBER,
      p_curr1_date          gipi_polbasic.issue_date%TYPE,
      p_curr2_date          gipi_polbasic.issue_date%TYPE,
      p_prev1_date          gipi_polbasic.issue_date%TYPE,
      p_prev2_date          gipi_polbasic.issue_date%TYPE,
      p_prev_year           VARCHAR2,
      p_curr_exists   OUT   VARCHAR2,
      p_prev_exists   OUT   VARCHAR2,
      p_ext_proc            VARCHAR2,
      p_extract_cat         VARCHAR2,
      p_user_id             giis_users.user_id%TYPE
   )
   AS
      TYPE policy_id_tab IS TABLE OF gipi_polbasic.policy_id%TYPE;

      TYPE curr_prem_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE line_cd_tab IS TABLE OF giis_line.line_cd%TYPE;

      TYPE subline_cd_tab IS TABLE OF giis_subline.subline_cd%TYPE;

      TYPE iss_cd_tab IS TABLE OF giis_issource.iss_cd%TYPE;

      TYPE peril_cd_tab IS TABLE OF giis_peril.peril_cd%TYPE;

      TYPE date24_tab IS TABLE OF VARCHAR2 (10);

      vv_policy_id    policy_id_tab;
      vv_prem         curr_prem_tab;
      vv_line_cd      line_cd_tab;
      vv_subline_cd   subline_cd_tab;
      vv_iss_cd       iss_cd_tab;
      vv_peril_cd     peril_cd_tab;
      vv_date24       date24_tab;
   BEGIN
      p_curr_exists := 'N';
      p_prev_exists := 'N';

      BEGIN
         DELETE      gicl_lratio_curr_prem_ext
               WHERE user_id = p_user_id;

         BEGIN
            SELECT   d.policy_id, d.line_cd, d.subline_cd, d.iss_cd, c.peril_cd, SUM (c.prem_amt * b.currency_rt) prem_amt, TO_CHAR (d.acct_ent_date, 'MM-DD-YYYY')
            BULK COLLECT INTO vv_policy_id, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_peril_cd, vv_prem, vv_date24
                FROM gipi_polbasic d,
                     (SELECT   a.policy_id, a.item_no, a.peril_cd, DECODE (p_extract_cat, 'G', a.prem_amt, SUM (c.dist_prem)) prem_amt
                          FROM gipi_itmperil a, giuw_pol_dist b, giuw_itemperilds_dtl c
                         WHERE 1 = 1 AND a.policy_id = b.policy_id AND b.dist_no = c.dist_no AND a.item_no = c.item_no AND a.peril_cd = c.peril_cd AND c.share_cd = 1
                      GROUP BY a.policy_id, a.item_no, a.peril_cd, a.prem_amt) c,
                     (SELECT currency_rt, policy_id, item_no
                        FROM gipi_item) b
               WHERE d.policy_id = c.policy_id
                 AND d.line_cd = NVL (p_line_cd, d.line_cd)
                 AND d.subline_cd = NVL (p_subline_cd, d.subline_cd)
                 AND d.iss_cd = NVL (p_iss_cd, d.iss_cd)
                 AND c.peril_cd = NVL (p_peril_cd, c.peril_cd)
                 AND TRUNC (d.acct_ent_date) >= p_curr1_date
                 AND TRUNC (d.acct_ent_date) <= p_curr2_date
                 AND d.pol_flag IN ('1', '2', '3', '4', 'X')
                 AND get_latest_assured_no (d.line_cd, d.subline_cd, d.iss_cd, d.issue_yy, d.pol_seq_no, d.renew_no, p_curr1_date, p_curr2_date) = p_assd_no
                 AND c.policy_id = b.policy_id
                 AND c.item_no = b.item_no
                 AND c.prem_amt <> 0
            GROUP BY d.policy_id, d.line_cd, d.subline_cd, d.iss_cd, c.peril_cd, TO_CHAR (d.acct_ent_date, 'MM-DD-YYYY');

            IF SQL%FOUND THEN
               p_curr_exists := 'Y';
               FORALL i IN vv_policy_id.FIRST .. vv_policy_id.LAST
                  INSERT INTO gicl_lratio_curr_prem_ext
                              (session_id, assd_no, policy_id, line_cd, subline_cd, iss_cd, peril_cd, prem_amt, user_id,
                               date_for_24th
                              )
                       VALUES (p_session_id, p_assd_no, vv_policy_id (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), vv_prem (i), p_user_id,
                               TO_DATE (vv_date24 (i), 'MM-DD-YYYY')
                              );
               vv_policy_id.DELETE;
               vv_prem.DELETE;
               vv_line_cd.DELETE;
               vv_subline_cd.DELETE;
               vv_iss_cd.DELETE;
               vv_peril_cd.DELETE;
               vv_date24.DELETE;
            END IF;
         END;

         BEGIN
            SELECT   d.policy_id, d.line_cd, d.subline_cd, d.iss_cd, c.peril_cd, SUM (c.prem_amt * b.currency_rt) prem_amt, TO_CHAR (d.spld_acct_ent_date, 'MM-DD-YYYY')
            BULK COLLECT INTO vv_policy_id, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_peril_cd, vv_prem, vv_date24
                FROM gipi_polbasic d,
                     (SELECT   a.policy_id, a.item_no, a.peril_cd, DECODE (p_extract_cat, 'G', a.prem_amt, SUM (c.dist_prem)) prem_amt
                          FROM gipi_itmperil a, giuw_pol_dist b, giuw_itemperilds_dtl c
                         WHERE 1 = 1 AND a.policy_id = b.policy_id AND b.dist_no = c.dist_no AND a.item_no = c.item_no AND a.peril_cd = c.peril_cd AND c.share_cd = 1
                      GROUP BY a.policy_id, a.item_no, a.peril_cd, a.prem_amt) c,
                     (SELECT currency_rt, policy_id, item_no
                        FROM gipi_item) b
               WHERE d.policy_id = c.policy_id
                 AND d.line_cd = NVL (p_line_cd, d.line_cd)
                 AND d.subline_cd = NVL (p_subline_cd, d.subline_cd)
                 AND d.iss_cd = NVL (p_iss_cd, d.iss_cd)
                 AND c.peril_cd = NVL (p_peril_cd, c.peril_cd)
                 AND TRUNC (d.spld_acct_ent_date) >= p_curr1_date
                 AND TRUNC (d.spld_acct_ent_date) <= p_curr2_date
                 AND d.pol_flag IN ('1', '2', '3', '4', 'X')
                 AND get_latest_assured_no (d.line_cd, d.subline_cd, d.iss_cd, d.issue_yy, d.pol_seq_no, d.renew_no, p_curr1_date, p_curr2_date) = p_assd_no
                 AND c.policy_id = b.policy_id
                 AND c.item_no = b.item_no
                 AND c.prem_amt <> 0
            GROUP BY d.policy_id, d.line_cd, d.subline_cd, d.iss_cd, c.peril_cd, TO_CHAR (d.spld_acct_ent_date, 'MM-DD-YYYY');

            IF SQL%FOUND THEN
               p_curr_exists := 'Y';
               FORALL i IN vv_policy_id.FIRST .. vv_policy_id.LAST
                  INSERT INTO gicl_lratio_curr_prem_ext
                              (session_id, assd_no, policy_id, line_cd, subline_cd, iss_cd, peril_cd, prem_amt, spld_sw, user_id,
                               date_for_24th
                              )
                       VALUES (p_session_id, p_assd_no, vv_policy_id (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), -vv_prem (i), 'Y', p_user_id,
                               TO_DATE (vv_date24 (i), 'MMM-DD-YYYY')
                              );
               vv_policy_id.DELETE;
               vv_prem.DELETE;
               vv_line_cd.DELETE;
               vv_subline_cd.DELETE;
               vv_iss_cd.DELETE;
               vv_peril_cd.DELETE;
               vv_date24.DELETE;
            END IF;
         END;

         FOR del_spld IN (SELECT a.policy_id
                            FROM gicl_lratio_curr_prem_ext a, gicl_lratio_curr_prem_ext b
                           WHERE a.session_id = p_session_id AND a.session_id = b.session_id AND a.policy_id = b.policy_id AND NVL (a.spld_sw, 'N') = 'Y' AND NVL (b.spld_sw, 'N') = 'N')
         LOOP
            DELETE      gicl_lratio_curr_prem_ext
                  WHERE policy_id = del_spld.policy_id AND session_id = p_session_id;
         END LOOP;
      END;

      BEGIN
         DELETE      gicl_lratio_prev_prem_ext
               WHERE user_id = p_user_id;

         BEGIN
            SELECT   d.policy_id, d.line_cd, d.subline_cd, d.iss_cd, c.peril_cd, SUM (c.prem_amt * b.currency_rt) prem_amt, TO_CHAR (d.acct_ent_date, 'MM-DD-YYYY')
            BULK COLLECT INTO vv_policy_id, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_peril_cd, vv_prem, vv_date24
                FROM gipi_polbasic d,
                     (SELECT   a.policy_id, a.item_no, a.peril_cd, DECODE (p_extract_cat, 'G', a.prem_amt, SUM (c.dist_prem)) prem_amt
                          FROM gipi_itmperil a, giuw_pol_dist b, giuw_itemperilds_dtl c
                         WHERE 1 = 1 AND a.policy_id = b.policy_id AND b.dist_no = c.dist_no AND a.item_no = c.item_no AND a.peril_cd = c.peril_cd AND c.share_cd = 1
                      GROUP BY a.policy_id, a.item_no, a.peril_cd, a.prem_amt) c,
                     (SELECT currency_rt, policy_id, item_no
                        FROM gipi_item) b
               WHERE d.policy_id = c.policy_id
                 AND d.line_cd = NVL (p_line_cd, d.line_cd)
                 AND d.subline_cd = NVL (p_subline_cd, d.subline_cd)
                 AND d.iss_cd = NVL (p_iss_cd, d.iss_cd)
                 AND c.peril_cd = NVL (p_peril_cd, c.peril_cd)
                 AND ((p_ext_proc = 'S' AND TO_CHAR (d.acct_ent_date, 'YYYY') = p_prev_year)
                      OR (p_ext_proc = 'M' AND TRUNC (d.acct_ent_date) >= p_prev1_date AND TRUNC (d.acct_ent_date) <= p_prev2_date)
                     )
                 AND d.pol_flag IN ('1', '2', '3', '4', 'X')
                 AND get_latest_assured_no (d.line_cd, d.subline_cd, d.iss_cd, d.issue_yy, d.pol_seq_no, d.renew_no, p_prev1_date, p_prev2_date) = p_assd_no
                 AND c.policy_id = b.policy_id
                 AND c.item_no = b.item_no
                 AND c.prem_amt <> 0
            GROUP BY d.policy_id, d.line_cd, d.subline_cd, d.iss_cd, c.peril_cd, TO_CHAR (d.acct_ent_date, 'MM-DD-YYYY');

            IF SQL%FOUND THEN
               p_prev_exists := 'Y';
               FORALL i IN vv_policy_id.FIRST .. vv_policy_id.LAST
                  INSERT INTO gicl_lratio_prev_prem_ext
                              (session_id, assd_no, policy_id, line_cd, subline_cd, iss_cd, peril_cd, prem_amt, user_id,
                               date_for_24th
                              )
                       VALUES (p_session_id, p_assd_no, vv_policy_id (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), vv_prem (i), p_user_id,
                               TO_DATE (vv_date24 (i), 'MM-DD-YYYY')
                              );
               vv_policy_id.DELETE;
               vv_prem.DELETE;
               vv_line_cd.DELETE;
               vv_subline_cd.DELETE;
               vv_iss_cd.DELETE;
               vv_peril_cd.DELETE;
               vv_date24.DELETE;
            END IF;
         END;

         BEGIN
            SELECT   d.policy_id, d.line_cd, d.subline_cd, d.iss_cd, c.peril_cd, SUM (c.prem_amt * b.currency_rt) prem_amt, TO_CHAR (d.spld_acct_ent_date, 'MM-DD-YYYY')
            BULK COLLECT INTO vv_policy_id, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_peril_cd, vv_prem, vv_date24
                FROM gipi_polbasic d,
                     (SELECT   a.policy_id, a.item_no, a.peril_cd, DECODE (p_extract_cat, 'G', a.prem_amt, SUM (c.dist_prem)) prem_amt
                          FROM gipi_itmperil a, giuw_pol_dist b, giuw_itemperilds_dtl c
                         WHERE 1 = 1 AND a.policy_id = b.policy_id AND b.dist_no = c.dist_no AND a.item_no = c.item_no AND a.peril_cd = c.peril_cd AND c.share_cd = 1
                      GROUP BY a.policy_id, a.item_no, a.peril_cd, a.prem_amt) c,
                     (SELECT currency_rt, policy_id, item_no
                        FROM gipi_item) b
               WHERE d.policy_id = c.policy_id
                 AND d.line_cd = NVL (p_line_cd, d.line_cd)
                 AND d.subline_cd = NVL (p_subline_cd, d.subline_cd)
                 AND d.iss_cd = NVL (p_iss_cd, d.iss_cd)
                 AND c.peril_cd = NVL (p_peril_cd, c.peril_cd)
                 AND (   (p_ext_proc = 'S' AND TO_CHAR (d.spld_acct_ent_date, 'YYYY') = p_prev_year)
                      OR (p_ext_proc = 'M' AND TRUNC (d.spld_acct_ent_date) >= p_prev1_date AND TRUNC (d.spld_acct_ent_date) <= p_prev2_date)
                     )
                 AND d.pol_flag IN ('1', '2', '3', '4', 'X')
                 AND get_latest_assured_no (d.line_cd, d.subline_cd, d.iss_cd, d.issue_yy, d.pol_seq_no, d.renew_no, p_prev1_date, p_prev2_date) = p_assd_no
                 AND c.policy_id = b.policy_id
                 AND c.item_no = b.item_no
                 AND c.prem_amt <> 0
            GROUP BY d.policy_id, d.line_cd, d.subline_cd, d.iss_cd, c.peril_cd, TO_CHAR (d.spld_acct_ent_date, 'MM-DD-YYYY');

            IF SQL%FOUND THEN
               p_prev_exists := 'Y';
               FORALL i IN vv_policy_id.FIRST .. vv_policy_id.LAST
                  INSERT INTO gicl_lratio_prev_prem_ext
                              (session_id, assd_no, policy_id, line_cd, subline_cd, iss_cd, peril_cd, prem_amt, spld_sw, user_id,
                               date_for_24th
                              )
                       VALUES (p_session_id, p_assd_no, vv_policy_id (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), -vv_prem (i), 'Y', p_user_id,
                               TO_DATE (vv_date24 (i), 'MM-DD-YYYY')
                              );
            END IF;
         END;

         FOR del_spld IN (SELECT a.policy_id
                            FROM gicl_lratio_prev_prem_ext a, gicl_lratio_prev_prem_ext b
                           WHERE a.session_id = p_session_id AND a.session_id = b.session_id AND a.policy_id = b.policy_id AND NVL (a.spld_sw, 'N') = 'Y' AND NVL (b.spld_sw, 'N') = 'N')
         LOOP
            DELETE      gicl_lratio_prev_prem_ext
                  WHERE policy_id = del_spld.policy_id AND session_id = p_session_id;
         END LOOP;
      END;
   END;

   PROCEDURE lratio_extract_premium_assd (
      p_line_cd             giis_line.line_cd%TYPE,
      p_subline_cd          giis_subline.subline_cd%TYPE,
      p_iss_cd              giis_issource.iss_cd%TYPE,
      p_peril_cd            giis_peril.peril_cd%TYPE,
      p_assd_no             giis_assured.assd_no%TYPE,
      p_session_id          gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param          NUMBER,
      p_issue_param         NUMBER,
      p_curr1_date          gipi_polbasic.issue_date%TYPE,
      p_curr2_date          gipi_polbasic.issue_date%TYPE,
      p_prev1_date          gipi_polbasic.issue_date%TYPE,
      p_prev2_date          gipi_polbasic.issue_date%TYPE,
      p_prev_year           VARCHAR2,
      p_curr_exists   OUT   VARCHAR2,
      p_prev_exists   OUT   VARCHAR2,
      p_ext_proc            VARCHAR2,
      p_extract_cat         VARCHAR2,
      p_user_id             giis_users.user_id%TYPE
   )
   AS
      TYPE policy_id_tab IS TABLE OF gipi_polbasic.policy_id%TYPE;

      TYPE curr_prem_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE peril_cd_tab IS TABLE OF giis_peril.peril_cd%TYPE;

      TYPE line_cd_tab IS TABLE OF giis_line.line_cd%TYPE;

      TYPE subline_cd_tab IS TABLE OF giis_subline.subline_cd%TYPE;

      TYPE iss_cd_tab IS TABLE OF giis_issource.iss_cd%TYPE;

      TYPE date24_tab IS TABLE OF VARCHAR2 (10);

      vv_policy_id    policy_id_tab;
      vv_prem         curr_prem_tab;
      vv_line_cd      line_cd_tab;
      vv_subline_cd   subline_cd_tab;
      vv_iss_cd       iss_cd_tab;
      vv_peril_cd     peril_cd_tab;
      vv_date24       date24_tab;
   BEGIN
      p_curr_exists := 'N';
      p_prev_exists := 'N';

      BEGIN
         DELETE      gicl_lratio_curr_prem_ext
               WHERE user_id = p_user_id;

         SELECT   d.policy_id, d.line_cd, d.subline_cd, d.iss_cd, c.peril_cd, SUM (c.prem_amt * b.currency_rt) prem_amt,
                  TO_CHAR (TRUNC (DECODE (p_date_param, 1, d.issue_date, 2, d.eff_date, 4, LAST_DAY (TO_DATE (UPPER (d.booking_mth) || ' 1,' || TO_CHAR (d.booking_year), 'FMMONTH DD,YYYY')), SYSDATE)),
                           'MM-DD-YYYY'
                          )
         BULK COLLECT INTO vv_policy_id, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_peril_cd, vv_prem,
                  vv_date24
             FROM gipi_polbasic d,
                  (SELECT   a.policy_id, a.item_no, a.peril_cd, DECODE (p_extract_cat, 'G', a.prem_amt, SUM (c.dist_prem)) prem_amt
                       FROM gipi_itmperil a, giuw_pol_dist b, giuw_itemperilds_dtl c
                      WHERE 1 = 1 AND a.policy_id = b.policy_id AND b.dist_no = c.dist_no AND a.item_no = c.item_no AND a.peril_cd = c.peril_cd AND c.share_cd = 1
                   GROUP BY a.policy_id, a.item_no, a.peril_cd, a.prem_amt) c,
                  (SELECT currency_rt, policy_id, item_no
                     FROM gipi_item) b
            WHERE d.policy_id = c.policy_id
              AND d.line_cd = NVL (p_line_cd, d.line_cd)
              AND d.subline_cd = NVL (p_subline_cd, d.subline_cd)
              AND d.iss_cd = NVL (p_iss_cd, d.iss_cd)
              AND c.peril_cd = NVL (p_peril_cd, c.peril_cd)
              AND TRUNC (DECODE (p_date_param, 1, d.issue_date, 2, d.eff_date, 4, LAST_DAY (TO_DATE (UPPER (d.booking_mth) || ' 1,' || TO_CHAR (d.booking_year), 'FMMONTH DD,YYYY')), SYSDATE)) >=
                                                                                                                                                                                            p_curr1_date
              AND TRUNC (DECODE (p_date_param, 1, d.issue_date, 2, d.eff_date, 4, LAST_DAY (TO_DATE (UPPER (d.booking_mth) || ' 1,' || TO_CHAR (d.booking_year), 'FMMONTH DD,YYYY')), SYSDATE)) <=
                                                                                                                                                                                            p_curr2_date
              AND d.pol_flag IN ('1', '2', '3', '4', 'X')
              AND get_latest_assured_no (d.line_cd, d.subline_cd, d.iss_cd, d.issue_yy, d.pol_seq_no, d.renew_no, p_curr1_date, p_curr2_date) = p_assd_no
              AND c.policy_id = b.policy_id
              AND c.item_no = b.item_no
              AND c.prem_amt <> 0
         GROUP BY d.policy_id,
                  d.line_cd,
                  d.subline_cd,
                  d.iss_cd,
                  c.peril_cd,
                  TO_CHAR (TRUNC (DECODE (p_date_param, 1, d.issue_date, 2, d.eff_date, 4, LAST_DAY (TO_DATE (UPPER (d.booking_mth) || ' 1,' || TO_CHAR (d.booking_year), 'FMMONTH DD,YYYY')), SYSDATE)),
                           'MM-DD-YYYY'
                          );

         IF SQL%FOUND THEN
            p_curr_exists := 'Y';
            FORALL i IN vv_policy_id.FIRST .. vv_policy_id.LAST
               INSERT INTO gicl_lratio_curr_prem_ext
                           (session_id, assd_no, policy_id, line_cd, subline_cd, iss_cd, peril_cd, prem_amt, user_id, date_for_24th
                           )
                    VALUES (p_session_id, p_assd_no, vv_policy_id (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), vv_prem (i), p_user_id, TO_DATE (vv_date24 (i), 'MM-DD-YYYY')
                           );
            vv_policy_id.DELETE;
            vv_prem.DELETE;
            vv_line_cd.DELETE;
            vv_subline_cd.DELETE;
            vv_iss_cd.DELETE;
            vv_peril_cd.DELETE;
            vv_date24.DELETE;
         END IF;
      END;

      BEGIN
         DELETE      gicl_lratio_prev_prem_ext
               WHERE user_id = p_user_id;

         SELECT   d.policy_id, d.line_cd, d.subline_cd, d.iss_cd, c.peril_cd, SUM (c.prem_amt * b.currency_rt) prem_amt,
                  TO_CHAR (TRUNC (DECODE (p_date_param, 1, d.issue_date, 2, d.eff_date, 4, LAST_DAY (TO_DATE (UPPER (d.booking_mth) || ' 1,' || TO_CHAR (d.booking_year), 'FMMONTH DD,YYYY')), SYSDATE)),
                           'MM-DD-YYYY'
                          )
         BULK COLLECT INTO vv_policy_id, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_peril_cd, vv_prem,
                  vv_date24
             FROM gipi_polbasic d,
                  (SELECT   a.policy_id, a.item_no, a.peril_cd, DECODE (p_extract_cat, 'G', a.prem_amt, SUM (c.dist_prem)) prem_amt
                       FROM gipi_itmperil a, giuw_pol_dist b, giuw_itemperilds_dtl c
                      WHERE 1 = 1 AND a.policy_id = b.policy_id AND b.dist_no = c.dist_no AND a.item_no = c.item_no AND a.peril_cd = c.peril_cd AND c.share_cd = 1
                   GROUP BY a.policy_id, a.item_no, a.peril_cd, a.prem_amt) c,
                  (SELECT currency_rt, policy_id, item_no
                     FROM gipi_item) b
            WHERE d.policy_id = c.policy_id
              AND d.line_cd = NVL (p_line_cd, d.line_cd)
              AND d.subline_cd = NVL (p_subline_cd, d.subline_cd)
              AND d.iss_cd = NVL (p_iss_cd, d.iss_cd)
              AND c.peril_cd = NVL (p_peril_cd, c.peril_cd)
              AND (   (    p_ext_proc = 'S'
                       AND DECODE (p_date_param, 1, TO_CHAR (d.issue_date, 'YYYY'), 2, TO_CHAR (d.eff_date, 'YYYY'), 4, TO_CHAR (d.booking_year), TO_CHAR (SYSDATE, 'YYYY')) = p_prev_year
                      )
                   OR (    p_ext_proc = 'M'
                       AND TRUNC (DECODE (p_date_param, 1, d.issue_date, 2, d.eff_date, 4, LAST_DAY (TO_DATE (UPPER (d.booking_mth) || ' 1,' || TO_CHAR (d.booking_year), 'FMMONTH DD,YYYY')), SYSDATE)) >=
                                                                                                                                                                                            p_prev1_date
                       AND TRUNC (DECODE (p_date_param, 1, d.issue_date, 2, d.eff_date, 4, LAST_DAY (TO_DATE (UPPER (d.booking_mth) || ' 1,' || TO_CHAR (d.booking_year), 'FMMONTH DD,YYYY')), SYSDATE)) <=
                                                                                                                                                                                            p_prev2_date
                      )
                  )
              AND d.pol_flag IN ('1', '2', '3', '4', 'X')
              AND get_latest_assured_no (d.line_cd, d.subline_cd, d.iss_cd, d.issue_yy, d.pol_seq_no, d.renew_no, p_prev1_date, p_prev2_date) = p_assd_no
              AND c.policy_id = b.policy_id
              AND c.item_no = b.item_no
              AND c.prem_amt <> 0
         GROUP BY d.policy_id,
                  d.line_cd,
                  d.subline_cd,
                  d.iss_cd,
                  c.peril_cd,
                  TO_CHAR (TRUNC (DECODE (p_date_param, 1, d.issue_date, 2, d.eff_date, 4, LAST_DAY (TO_DATE (UPPER (d.booking_mth) || ' 1,' || TO_CHAR (d.booking_year), 'FMMONTH DD,YYYY')), SYSDATE)),
                           'MM-DD-YYYY'
                          );

         IF SQL%FOUND THEN
            p_prev_exists := 'Y';
            FORALL i IN vv_policy_id.FIRST .. vv_policy_id.LAST
               INSERT INTO gicl_lratio_prev_prem_ext
                           (session_id, assd_no, policy_id, line_cd, subline_cd, iss_cd, peril_cd, prem_amt, user_id, date_for_24th
                           )
                    VALUES (p_session_id, p_assd_no, vv_policy_id (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), vv_prem (i), p_user_id, TO_DATE (vv_date24 (i), 'MM-DD-YYYY')
                           );
         END IF;
      END;
   END;

   PROCEDURE lratio_extract_losses_paid3 (
      p_line_cd             giis_line.line_cd%TYPE,
      p_subline_cd          giis_subline.subline_cd%TYPE,
      p_iss_cd              giis_issource.iss_cd%TYPE,
      p_peril_cd            giis_peril.peril_cd%TYPE,
      p_assd_no             giis_assured.assd_no%TYPE,
      p_session_id          gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param          NUMBER,
      p_issue_param         NUMBER,
      p_curr1_date          gipi_polbasic.issue_date%TYPE,
      p_curr2_date          gipi_polbasic.issue_date%TYPE,
      p_exists        OUT   VARCHAR2,
      p_extract_cat         VARCHAR2,
      p_user_id             giis_users.user_id%TYPE
   )
   AS
      TYPE paid_amt_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE assd_no_tab IS TABLE OF giis_assured.assd_no%TYPE;

      TYPE claim_id_tab IS TABLE OF gicl_claims.claim_id%TYPE;

      TYPE peril_cd_tab IS TABLE OF giis_peril.peril_cd%TYPE;

      TYPE line_cd_tab IS TABLE OF giis_line.line_cd%TYPE;

      TYPE subline_cd_tab IS TABLE OF giis_subline.subline_cd%TYPE;

      TYPE iss_cd_tab IS TABLE OF giis_issource.iss_cd%TYPE;

      vv_claim_id     claim_id_tab;
      vv_paid_amt     paid_amt_tab;
      vv_assd_no      assd_no_tab;
      vv_peril_cd     peril_cd_tab;
      vv_line_cd      line_cd_tab;
      vv_subline_cd   subline_cd_tab;
      vv_iss_cd       iss_cd_tab;
   BEGIN
      DELETE      gicl_lratio_loss_paid_ext
            WHERE user_id = p_user_id;

      p_exists := 'N';

      SELECT   b.claim_id, b.assd_no, b.line_cd, b.subline_cd, b.iss_cd, a.peril_cd, SUM (a.loss_paid) loss_paid
      BULK COLLECT INTO vv_claim_id, vv_assd_no, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_peril_cd, vv_paid_amt
          FROM (SELECT   a.claim_id, a.peril_cd, a.tran_id, a.date_paid, a.cancel_tag,
                         DECODE (p_extract_cat, 'G', NVL (NVL (SUM (a.losses_paid), 0) + NVL (SUM (a.expenses_paid), 0), 0), SUM (c.shr_le_adv_amt)) loss_paid
                    FROM gicl_clm_res_hist a, gicl_clm_loss_exp b, gicl_loss_exp_ds c
                   WHERE 1 = 1
                     AND a.claim_id = b.claim_id
                     AND a.item_no = b.item_no
                     AND a.peril_cd = b.peril_cd
                     AND a.tran_id = b.tran_id
                     AND b.claim_id = c.claim_id
                     AND b.clm_loss_id = c.clm_loss_id
                     AND c.share_type = 1
                     AND c.negate_tag IS NULL
                GROUP BY a.claim_id, a.peril_cd, a.tran_id, a.date_paid, a.cancel_tag) a,
               gicl_claims b
         WHERE 1 = 1
           AND b.line_cd = NVL (p_line_cd, b.line_cd)
           AND b.subline_cd = NVL (p_subline_cd, b.subline_cd)
           AND DECODE (p_issue_param, 1, b.iss_cd, b.pol_iss_cd) = NVL (p_iss_cd, DECODE (p_issue_param, 1, b.iss_cd, b.pol_iss_cd))
           AND a.peril_cd = NVL (p_peril_cd, a.peril_cd)
           AND b.assd_no = NVL (p_assd_no, b.assd_no)
           AND a.claim_id = b.claim_id
           AND tran_id IS NOT NULL
           AND NVL (cancel_tag, 'N') = 'N'
           AND TRUNC (date_paid) >= p_curr1_date
           AND TRUNC (date_paid) <= p_curr2_date
      GROUP BY b.claim_id, b.assd_no, b.line_cd, b.subline_cd, b.iss_cd, a.peril_cd;

      IF SQL%FOUND THEN
         p_exists := 'Y';
         FORALL i IN vv_claim_id.FIRST .. vv_claim_id.LAST
            INSERT INTO gicl_lratio_loss_paid_ext
                        (session_id, assd_no, peril_cd, line_cd, subline_cd, iss_cd, claim_id, loss_paid, user_id
                        )
                 VALUES (p_session_id, vv_assd_no (i), vv_peril_cd (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_claim_id (i), vv_paid_amt (i), p_user_id
                        );
      END IF;
   END;

   PROCEDURE lratio_extract_os3 (
      p_line_cd             giis_line.line_cd%TYPE,
      p_subline_cd          giis_subline.subline_cd%TYPE,
      p_iss_cd              giis_issource.iss_cd%TYPE,
      p_peril_cd            giis_peril.peril_cd%TYPE,
      p_assd_no             giis_assured.assd_no%TYPE,
      p_session_id          gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param          NUMBER,
      p_issue_param         NUMBER,
      p_curr1_date          gipi_polbasic.issue_date%TYPE,
      p_curr2_date          gipi_polbasic.issue_date%TYPE,
      p_prev1_date          gipi_polbasic.issue_date%TYPE,
      p_prev2_date          gipi_polbasic.issue_date%TYPE,
      p_curr_exists   OUT   VARCHAR2,
      p_prev_exists   OUT   VARCHAR2,
      p_extract_cat         VARCHAR2,
      p_user_id             giis_users.user_id%TYPE
   )
   AS
      TYPE os_amt_tab IS TABLE OF gicl_clm_res_hist.losses_paid%TYPE;                                                                                                    --gipi_polbasic.prem_amt%TYPE;

      TYPE assd_no_tab IS TABLE OF giis_assured.assd_no%TYPE;

      TYPE claim_id_tab IS TABLE OF gicl_claims.claim_id%TYPE;

      TYPE peril_cd_tab IS TABLE OF giis_peril.peril_cd%TYPE;

      TYPE line_cd_tab IS TABLE OF giis_line.line_cd%TYPE;

      TYPE subline_cd_tab IS TABLE OF giis_subline.subline_cd%TYPE;

      TYPE iss_cd_tab IS TABLE OF giis_issource.iss_cd%TYPE;

      vv_claim_id     claim_id_tab;
      vv_os           os_amt_tab;
      vv_assd_no      assd_no_tab;
      vv_peril_cd     peril_cd_tab;
      vv_line_cd      line_cd_tab;
      vv_subline_cd   subline_cd_tab;
      vv_iss_cd       iss_cd_tab;
   BEGIN
      p_curr_exists := 'N';
      p_prev_exists := 'N';

      BEGIN
         DELETE      gicl_lratio_curr_os_ext
               WHERE user_id = p_user_id;

         BEGIN
            SELECT   d.claim_id, d.assd_no, a.peril_cd, d.line_cd, d.subline_cd, d.iss_cd, NVL (SUM ((NVL (a.loss_reserve, 0) * NVL (a.convert_rate, 1)) - NVL (c.losses_paid, 0)), 0)
            BULK COLLECT INTO vv_claim_id, vv_assd_no, vv_peril_cd, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_os
                FROM (SELECT   aa.claim_id, aa.clm_res_hist_id, aa.item_no, aa.peril_cd, DECODE (p_extract_cat, 'G', aa.loss_reserve, SUM (bb.shr_loss_res_amt)) loss_reserve, aa.convert_rate
                          FROM gicl_clm_res_hist aa, gicl_reserve_ds bb
                         WHERE aa.claim_id = bb.claim_id AND aa.clm_res_hist_id = bb.clm_res_hist_id AND bb.share_type = 1
                      GROUP BY aa.claim_id, aa.clm_res_hist_id, aa.item_no, aa.peril_cd, aa.convert_rate, aa.loss_reserve) a,
                     (SELECT b1.claim_id, b1.clm_res_hist_id, b1.item_no, b1.peril_cd
                        FROM gicl_clm_res_hist b1, gicl_item_peril b2
                       WHERE tran_id IS NULL
                         AND b2.claim_id = b1.claim_id
                         AND b2.item_no = b1.item_no
                         AND b2.peril_cd = b1.peril_cd
                         AND TRUNC (NVL (b2.close_date, p_curr2_date + 365)) > TRUNC (p_curr2_date)) b,
                     (SELECT   aa.claim_id, aa.item_no, aa.peril_cd, DECODE (p_extract_cat, 'G', SUM (aa.losses_paid), SUM (bb.shr_le_adv_amt)) losses_paid
                          FROM gicl_clm_res_hist aa, gicl_clm_loss_exp cc, gicl_loss_exp_ds bb
                         WHERE 1 = 1
                           AND aa.claim_id = cc.claim_id
                           AND aa.advice_id = cc.advice_id
                           AND bb.claim_id = cc.claim_id
                           AND bb.clm_loss_id = cc.clm_loss_id
                           AND cc.payee_type = 'L'
                           AND aa.tran_id IS NOT NULL
                           AND bb.share_type = 1
                           AND NVL (aa.cancel_tag, 'N') = 'N'
                           AND TRUNC (date_paid) <= TRUNC (p_curr2_date)
                      GROUP BY aa.claim_id, aa.item_no, aa.peril_cd) c,
                     gicl_claims d
               WHERE 1 = 1
                 AND d.line_cd = NVL (p_line_cd, d.line_cd)
                 AND d.subline_cd = NVL (p_subline_cd, d.subline_cd)
                 AND d.assd_no = NVL (p_assd_no, d.assd_no)
                 AND a.peril_cd = NVL (p_peril_cd, a.peril_cd)
                 AND DECODE (p_issue_param, 1, d.iss_cd, d.pol_iss_cd) = NVL (p_iss_cd, DECODE (p_issue_param, 1, d.iss_cd, d.pol_iss_cd))
                 AND a.claim_id = d.claim_id
                 AND a.claim_id = b.claim_id
                 AND a.clm_res_hist_id = b.clm_res_hist_id
                 AND b.claim_id = c.claim_id(+)
                 AND b.item_no = c.item_no(+)
                 AND b.peril_cd = c.peril_cd(+)
                 AND NVL (a.loss_reserve, 0) > NVL (c.losses_paid, 0)
                 AND a.clm_res_hist_id =
                        (SELECT MAX (a2.clm_res_hist_id)
                           FROM gicl_clm_res_hist a2
                          WHERE a2.claim_id = a.claim_id
                            AND a2.item_no = a.item_no
                            AND a2.peril_cd = a.peril_cd
                            AND TO_DATE (NVL (a2.booking_month, TO_CHAR (d.clm_file_date, 'FMMONTH')) || ' 01, ' || TO_CHAR (NVL (a2.booking_year, TO_CHAR (d.clm_file_date, 'YYYY'))),
                                         'FMMONTH DD, YYYY'
                                        ) <= TRUNC (p_curr2_date)
                            AND tran_id IS NULL)
            GROUP BY d.claim_id, d.assd_no, a.peril_cd, d.line_cd, d.subline_cd, d.iss_cd;

            IF SQL%FOUND THEN
               p_curr_exists := 'Y';
               FORALL i IN vv_claim_id.FIRST .. vv_claim_id.LAST
                  INSERT INTO gicl_lratio_curr_os_ext
                              (session_id, assd_no, claim_id, line_cd, subline_cd, iss_cd, peril_cd, os_amt, user_id
                              )
                       VALUES (p_session_id, vv_assd_no (i), vv_claim_id (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), vv_os (i), p_user_id
                              );
               vv_assd_no.DELETE;
               vv_claim_id.DELETE;
               vv_peril_cd.DELETE;
               vv_os.DELETE;
               vv_line_cd.DELETE;
               vv_subline_cd.DELETE;
               vv_iss_cd.DELETE;
            END IF;
         END;

         BEGIN
            SELECT   d.claim_id, d.assd_no, a.peril_cd, d.line_cd, d.subline_cd, d.iss_cd, NVL (SUM ((NVL (a.expense_reserve, 0) * NVL (a.convert_rate, 1)) - NVL (c.exp_paid, 0)), 0) expense
            BULK COLLECT INTO vv_claim_id, vv_assd_no, vv_peril_cd, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_os
                FROM (SELECT   aa.claim_id, aa.clm_res_hist_id, aa.item_no, aa.peril_cd, DECODE (p_extract_cat, 'G', aa.expense_reserve, SUM (bb.shr_exp_res_amt)) expense_reserve, aa.convert_rate
                          FROM gicl_clm_res_hist aa, gicl_reserve_ds bb
                         WHERE aa.claim_id = bb.claim_id AND aa.clm_res_hist_id = bb.clm_res_hist_id AND bb.share_type = 1
                      GROUP BY aa.claim_id, aa.clm_res_hist_id, aa.item_no, aa.peril_cd, aa.convert_rate, aa.expense_reserve) a,
                     (SELECT b1.claim_id, b1.clm_res_hist_id, b1.item_no, b1.peril_cd
                        FROM gicl_clm_res_hist b1, gicl_item_peril b2
                       WHERE tran_id IS NULL
                         AND b2.claim_id = b1.claim_id
                         AND b2.item_no = b1.item_no
                         AND b2.peril_cd = b1.peril_cd
                         AND TRUNC (NVL (b2.close_date2, p_curr2_date + 365)) > TRUNC (p_curr2_date)) b,
                     (SELECT   aa.claim_id, aa.item_no, aa.peril_cd, DECODE (p_extract_cat, 'G', SUM (aa.expenses_paid), SUM (bb.shr_le_adv_amt)) exp_paid
                          FROM gicl_clm_res_hist aa, gicl_clm_loss_exp cc, gicl_loss_exp_ds bb
                         WHERE 1 = 1
                           AND aa.claim_id = cc.claim_id
                           AND aa.advice_id = cc.advice_id
                           AND bb.claim_id = cc.claim_id
                           AND bb.clm_loss_id = cc.clm_loss_id
                           AND cc.payee_type = 'E'
                           AND aa.tran_id IS NOT NULL
                           AND bb.share_type = 1
                           AND NVL (aa.cancel_tag, 'N') = 'N'
                           AND TRUNC (date_paid) <= TRUNC (p_curr2_date)
                      GROUP BY aa.claim_id, aa.item_no, aa.peril_cd) c,
                     gicl_claims d
               WHERE 1 = 1
                 AND d.line_cd = NVL (p_line_cd, d.line_cd)
                 AND d.subline_cd = NVL (p_subline_cd, d.subline_cd)
                 AND DECODE (p_issue_param, 1, d.iss_cd, d.pol_iss_cd) = NVL (p_iss_cd, DECODE (p_issue_param, 1, d.iss_cd, d.pol_iss_cd))
                 AND d.assd_no = NVL (p_assd_no, d.assd_no)
                 AND a.peril_cd = NVL (p_peril_cd, a.peril_cd)
                 AND a.claim_id = d.claim_id
                 AND a.claim_id = b.claim_id
                 AND a.clm_res_hist_id = b.clm_res_hist_id
                 AND b.claim_id = c.claim_id(+)
                 AND b.item_no = c.item_no(+)
                 AND b.peril_cd = c.peril_cd(+)
                 AND NVL (a.expense_reserve, 0) > NVL (c.exp_paid, 0)
                 AND a.clm_res_hist_id =
                        (SELECT MAX (a2.clm_res_hist_id)
                           FROM gicl_clm_res_hist a2
                          WHERE a2.claim_id = a.claim_id
                            AND a2.item_no = a.item_no
                            AND a2.peril_cd = a.peril_cd
                            AND TO_DATE (NVL (a2.booking_month, TO_CHAR (d.clm_file_date, 'FMMONTH')) || ' 01, ' || TO_CHAR (NVL (a2.booking_year, TO_CHAR (d.clm_file_date, 'YYYY'))),
                                         'FMMONTH DD, YYYY'
                                        ) <= TRUNC (p_curr2_date)
                            AND tran_id IS NULL)
            GROUP BY d.claim_id, d.assd_no, a.peril_cd, d.line_cd, d.subline_cd, d.iss_cd;

            IF SQL%FOUND THEN
               p_curr_exists := 'Y';
               FORALL i IN vv_claim_id.FIRST .. vv_claim_id.LAST
                  INSERT INTO gicl_lratio_curr_os_ext
                              (session_id, assd_no, claim_id, line_cd, subline_cd, iss_cd, peril_cd, os_amt, user_id
                              )
                       VALUES (p_session_id, vv_assd_no (i), vv_claim_id (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), vv_os (i), p_user_id
                              );
               vv_assd_no.DELETE;
               vv_claim_id.DELETE;
               vv_peril_cd.DELETE;
               vv_os.DELETE;
               vv_line_cd.DELETE;
               vv_subline_cd.DELETE;
               vv_iss_cd.DELETE;
            END IF;
         END;
      END;

      BEGIN
         DELETE      gicl_lratio_prev_os_ext
               WHERE user_id = p_user_id;

         BEGIN
            SELECT   d.claim_id, d.assd_no, a.peril_cd, d.line_cd, d.subline_cd, d.iss_cd, NVL (SUM ((NVL (a.loss_reserve, 0) * NVL (a.convert_rate, 1)) - NVL (c.losses_paid, 0)), 0) loss
            BULK COLLECT INTO vv_claim_id, vv_assd_no, vv_peril_cd, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_os
                FROM (SELECT   aa.claim_id, aa.clm_res_hist_id, aa.item_no, aa.peril_cd, DECODE (p_extract_cat, 'G', aa.loss_reserve, SUM (bb.shr_loss_res_amt)) loss_reserve, aa.convert_rate
                          FROM gicl_clm_res_hist aa, gicl_reserve_ds bb
                         WHERE aa.claim_id = bb.claim_id AND aa.clm_res_hist_id = bb.clm_res_hist_id AND bb.share_type = 1
                      GROUP BY aa.claim_id, aa.clm_res_hist_id, aa.item_no, aa.peril_cd, aa.convert_rate, aa.loss_reserve) a,
                     (SELECT b1.claim_id, b1.clm_res_hist_id, b1.item_no, b1.peril_cd
                        FROM gicl_clm_res_hist b1, gicl_item_peril b2
                       WHERE tran_id IS NULL
                         AND b2.claim_id = b1.claim_id
                         AND b2.item_no = b1.item_no
                         AND b2.peril_cd = b1.peril_cd
                         AND TRUNC (NVL (b2.close_date, p_curr2_date + 365)) > TRUNC (p_prev2_date)) b,
                     (SELECT   aa.claim_id, aa.item_no, aa.peril_cd, DECODE (p_extract_cat, 'G', SUM (aa.losses_paid), SUM (bb.shr_le_adv_amt)) losses_paid
                          FROM gicl_clm_res_hist aa, gicl_clm_loss_exp cc, gicl_loss_exp_ds bb
                         WHERE 1 = 1
                           AND aa.claim_id = cc.claim_id
                           AND aa.advice_id = cc.advice_id
                           AND bb.claim_id = cc.claim_id
                           AND bb.clm_loss_id = cc.clm_loss_id
                           AND cc.payee_type = 'L'
                           AND aa.tran_id IS NOT NULL
                           AND bb.share_type = 1
                           AND NVL (aa.cancel_tag, 'N') = 'N'
                           AND TRUNC (date_paid) <= p_prev2_date
                      GROUP BY aa.claim_id, aa.item_no, aa.peril_cd) c,
                     gicl_claims d
               WHERE 1 = 1
                 AND d.line_cd = NVL (p_line_cd, d.line_cd)
                 AND d.subline_cd = NVL (p_subline_cd, d.subline_cd)
                 AND DECODE (p_issue_param, 1, d.iss_cd, d.pol_iss_cd) = NVL (p_iss_cd, DECODE (p_issue_param, 1, d.iss_cd, d.pol_iss_cd))
                 AND d.assd_no = NVL (p_assd_no, d.assd_no)
                 AND a.peril_cd = NVL (p_peril_cd, a.peril_cd)
                 AND a.claim_id = d.claim_id
                 AND a.claim_id = b.claim_id
                 AND a.clm_res_hist_id = b.clm_res_hist_id
                 AND b.claim_id = c.claim_id(+)
                 AND b.item_no = c.item_no(+)
                 AND b.peril_cd = c.peril_cd(+)
                 AND NVL (a.loss_reserve, 0) > NVL (c.losses_paid, 0)
                 AND a.clm_res_hist_id =
                        (SELECT MAX (a2.clm_res_hist_id)
                           FROM gicl_clm_res_hist a2
                          WHERE a2.claim_id = a.claim_id
                            AND a2.item_no = a.item_no
                            AND a2.peril_cd = a.peril_cd
                            AND TO_DATE (NVL (a2.booking_month, TO_CHAR (d.clm_file_date, 'FMMONTH')) || ' 01, ' || TO_CHAR (NVL (a2.booking_year, TO_CHAR (d.clm_file_date, 'YYYY'))),
                                         'FMMONTH DD, YYYY'
                                        ) <= TRUNC (p_prev2_date)
                            AND tran_id IS NULL)
            GROUP BY d.claim_id, d.assd_no, a.peril_cd, d.line_cd, d.subline_cd, d.iss_cd;

            IF SQL%FOUND THEN
               p_prev_exists := 'Y';
               FORALL i IN vv_claim_id.FIRST .. vv_claim_id.LAST
                  INSERT INTO gicl_lratio_prev_os_ext
                              (session_id, assd_no, claim_id, line_cd, subline_cd, iss_cd, peril_cd, os_amt, user_id
                              )
                       VALUES (p_session_id, vv_assd_no (i), vv_claim_id (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), vv_os (i), p_user_id
                              );
               vv_assd_no.DELETE;
               vv_claim_id.DELETE;
               vv_peril_cd.DELETE;
               vv_os.DELETE;
               vv_line_cd.DELETE;
               vv_subline_cd.DELETE;
               vv_iss_cd.DELETE;
            END IF;
         END;

         BEGIN
            SELECT   d.claim_id, d.assd_no, a.peril_cd, d.line_cd, d.subline_cd, d.iss_cd, NVL (SUM ((NVL (a.expense_reserve, 0) * NVL (a.convert_rate, 1)) - NVL (c.exp_paid, 0)), 0) expense
            BULK COLLECT INTO vv_claim_id, vv_assd_no, vv_peril_cd, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_os
                FROM (SELECT   aa.claim_id, aa.clm_res_hist_id, aa.item_no, aa.peril_cd, DECODE (p_extract_cat, 'G', aa.expense_reserve, SUM (bb.shr_exp_res_amt)) expense_reserve, aa.convert_rate
                          FROM gicl_clm_res_hist aa, gicl_reserve_ds bb
                         WHERE aa.claim_id = bb.claim_id AND aa.clm_res_hist_id = bb.clm_res_hist_id AND bb.share_type = 1
                      GROUP BY aa.claim_id, aa.clm_res_hist_id, aa.item_no, aa.peril_cd, aa.convert_rate, aa.expense_reserve) a,
                     (SELECT b1.claim_id, b1.clm_res_hist_id, b1.item_no, b1.peril_cd
                        FROM gicl_clm_res_hist b1, gicl_item_peril b2
                       WHERE tran_id IS NULL
                         AND b2.claim_id = b1.claim_id
                         AND b2.item_no = b1.item_no
                         AND b2.peril_cd = b1.peril_cd
                         AND TRUNC (NVL (b2.close_date2, p_curr2_date + 365)) > TRUNC (p_prev2_date)) b,
                     (SELECT   aa.claim_id, aa.item_no, aa.peril_cd, DECODE (p_extract_cat, 'G', SUM (aa.expenses_paid), SUM (bb.shr_le_adv_amt)) exp_paid
                          FROM gicl_clm_res_hist aa, gicl_clm_loss_exp cc, gicl_loss_exp_ds bb
                         WHERE 1 = 1
                           AND aa.claim_id = cc.claim_id
                           AND aa.advice_id = cc.advice_id
                           AND bb.claim_id = cc.claim_id
                           AND bb.clm_loss_id = cc.clm_loss_id
                           AND cc.payee_type = 'E'
                           AND aa.tran_id IS NOT NULL
                           AND bb.share_type = 1
                           AND NVL (aa.cancel_tag, 'N') = 'N'
                           AND TRUNC (date_paid) <= p_prev2_date
                      GROUP BY aa.claim_id, aa.item_no, aa.peril_cd) c,
                     gicl_claims d
               WHERE 1 = 1
                 AND d.line_cd = NVL (p_line_cd, d.line_cd)
                 AND d.subline_cd = NVL (p_subline_cd, d.subline_cd)
                 AND DECODE (p_issue_param, 1, d.iss_cd, d.pol_iss_cd) = NVL (p_iss_cd, DECODE (p_issue_param, 1, d.iss_cd, d.pol_iss_cd))
                 AND d.assd_no = NVL (p_assd_no, d.assd_no)
                 AND a.peril_cd = NVL (p_peril_cd, a.peril_cd)
                 AND a.claim_id = d.claim_id
                 AND a.claim_id = b.claim_id
                 AND a.clm_res_hist_id = b.clm_res_hist_id
                 AND b.claim_id = c.claim_id(+)
                 AND b.item_no = c.item_no(+)
                 AND b.peril_cd = c.peril_cd(+)
                 AND NVL (a.expense_reserve, 0) > NVL (c.exp_paid, 0)
                 AND a.clm_res_hist_id =
                        (SELECT MAX (a2.clm_res_hist_id)
                           FROM gicl_clm_res_hist a2
                          WHERE a2.claim_id = a.claim_id
                            AND a2.item_no = a.item_no
                            AND a2.peril_cd = a.peril_cd
                            AND TO_DATE (NVL (a2.booking_month, TO_CHAR (d.clm_file_date, 'FMMONTH')) || ' 01, ' || TO_CHAR (NVL (a2.booking_year, TO_CHAR (d.clm_file_date, 'YYYY'))),
                                         'FMMONTH DD, YYYY'
                                        ) <= TRUNC (p_prev2_date)
                            AND tran_id IS NULL)
            GROUP BY d.claim_id, d.assd_no, a.peril_cd, d.line_cd, d.subline_cd, d.iss_cd;

            IF SQL%FOUND THEN
               p_prev_exists := 'Y';
               FORALL i IN vv_claim_id.FIRST .. vv_claim_id.LAST
                  INSERT INTO gicl_lratio_prev_os_ext
                              (session_id, assd_no, claim_id, line_cd, subline_cd, iss_cd, peril_cd, os_amt, user_id
                              )
                       VALUES (p_session_id, vv_assd_no (i), vv_claim_id (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), vv_os (i), p_user_id
                              );
            END IF;
         END;
      END;
   END;

   PROCEDURE lratio_extract_recovery3 (
      p_line_cd             giis_line.line_cd%TYPE,
      p_subline_cd          giis_subline.subline_cd%TYPE,
      p_iss_cd              giis_issource.iss_cd%TYPE,
      p_peril_cd            giis_peril.peril_cd%TYPE,
      p_assd_no             giis_assured.assd_no%TYPE,
      p_session_id          gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param          NUMBER,
      p_issue_param         NUMBER,
      p_curr1_date          gipi_polbasic.issue_date%TYPE,
      p_curr2_date          gipi_polbasic.issue_date%TYPE,
      p_prev1_date          gipi_polbasic.issue_date%TYPE,
      p_prev2_date          gipi_polbasic.issue_date%TYPE,
      p_curr_exists   OUT   VARCHAR2,
      p_prev_exists   OUT   VARCHAR2,
      p_extract_cat         VARCHAR2,
      p_user_id             giis_users.user_id%TYPE
   )
   AS
      TYPE rec_amt_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE assd_no_tab IS TABLE OF giis_assured.assd_no%TYPE;

      TYPE rec_id_tab IS TABLE OF gicl_clm_recovery.recovery_id%TYPE;

      TYPE line_cd_tab IS TABLE OF giis_line.line_cd%TYPE;

      TYPE subline_cd_tab IS TABLE OF giis_subline.subline_cd%TYPE;

      TYPE iss_cd_tab IS TABLE OF giis_issource.iss_cd%TYPE;

      TYPE peril_cd_tab IS TABLE OF giis_peril.peril_cd%TYPE;

      vv_rec_id       rec_id_tab;
      vv_rec_amt      rec_amt_tab;
      vv_assd_no      assd_no_tab;
      vv_line_cd      line_cd_tab;
      vv_subline_cd   subline_cd_tab;
      vv_iss_cd       iss_cd_tab;
      vv_peril_cd     peril_cd_tab;
   BEGIN
      p_curr_exists := 'N';
      p_prev_exists := 'N';
      p_curr_exists := 'Y';

      BEGIN
         DELETE      gicl_lratio_prev_recovery_ext
               WHERE user_id = p_user_id;

         SELECT   b.assd_no, a.recovery_id, line_cd, subline_cd, iss_cd, peril_cd, SUM (NVL (recovered_amt, 0) * (NVL (c.recoverable_amt, 0) / get_rec_amt (c.recovery_id))) recovered_amt
         BULK COLLECT INTO vv_assd_no, vv_rec_id, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_peril_cd, vv_rec_amt
             FROM (SELECT aa.claim_id, aa.recovery_id, aa.tran_date, aa.cancel_tag,
                          DECODE (p_extract_cat, 'G', aa.recovered_amt, DECODE (aa.dist_sw, 'Y', bb.shr_recovery_amt, aa.recovered_amt)) recovered_amt
                     FROM gicl_recovery_payt aa, gicl_recovery_ds bb
                    WHERE 1 = 1 AND aa.recovery_id = bb.recovery_id(+) AND aa.recovery_payt_id = bb.recovery_payt_id(+) AND bb.share_type(+) = 1 AND NVL (bb.negate_tag, 'N') = 'N') a,
                  gicl_claims b,
                  gicl_clm_recovery_dtl c
            WHERE 1 = 1
              AND b.line_cd = NVL (p_line_cd, b.line_cd)
              AND b.subline_cd = NVL (p_subline_cd, b.subline_cd)
              AND DECODE (p_issue_param, 1, b.iss_cd, b.pol_iss_cd) = NVL (p_iss_cd, DECODE (p_issue_param, 1, b.iss_cd, b.pol_iss_cd))
              AND b.assd_no = NVL (p_assd_no, b.assd_no)
              AND c.peril_cd = NVL (p_peril_cd, c.peril_cd)
              AND a.claim_id = b.claim_id
              AND a.recovery_id = c.recovery_id
              AND a.claim_id = c.claim_id
              AND NVL (cancel_tag, 'N') = 'N'
              AND TRUNC (tran_date) >= p_prev1_date
              AND TRUNC (tran_date) <= p_prev2_date
         GROUP BY b.assd_no, a.recovery_id, line_cd, subline_cd, iss_cd, peril_cd;

         IF SQL%FOUND THEN
            p_prev_exists := 'Y';
            FORALL i IN vv_rec_id.FIRST .. vv_rec_id.LAST
               INSERT INTO gicl_lratio_prev_recovery_ext
                           (session_id, recovery_id, assd_no, line_cd, subline_cd, iss_cd, peril_cd, recovered_amt, user_id
                           )
                    VALUES (p_session_id, vv_rec_id (i), vv_assd_no (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), vv_rec_amt (i), p_user_id
                           );
            vv_rec_id.DELETE;
            vv_assd_no.DELETE;
            vv_rec_amt.DELETE;
            vv_line_cd.DELETE;
            vv_subline_cd.DELETE;
            vv_iss_cd.DELETE;
            vv_peril_cd.DELETE;
         END IF;
      END;

      BEGIN
         DELETE      gicl_lratio_curr_recovery_ext
               WHERE user_id = p_user_id;

         SELECT   b.assd_no, a.recovery_id, line_cd, subline_cd, iss_cd, peril_cd, SUM (NVL (recovered_amt, 0) * (NVL (c.recoverable_amt, 0) / get_rec_amt (c.recovery_id))) recovered_amt
         BULK COLLECT INTO vv_assd_no, vv_rec_id, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_peril_cd, vv_rec_amt
             FROM (SELECT aa.claim_id, aa.recovery_id, aa.tran_date, aa.cancel_tag,
                          DECODE (p_extract_cat, 'G', aa.recovered_amt, DECODE (aa.dist_sw, 'Y', bb.shr_recovery_amt, aa.recovered_amt)) recovered_amt
                     FROM gicl_recovery_payt aa, gicl_recovery_ds bb
                    WHERE 1 = 1 AND aa.recovery_id = bb.recovery_id(+) AND aa.recovery_payt_id = bb.recovery_payt_id(+) AND bb.share_type(+) = 1 AND NVL (bb.negate_tag, 'N') = 'N') a,
                  gicl_claims b,
                  gicl_clm_recovery_dtl c
            WHERE 1 = 1
              AND b.line_cd = NVL (p_line_cd, b.line_cd)
              AND b.subline_cd = NVL (p_subline_cd, b.subline_cd)
              AND DECODE (p_issue_param, 1, b.iss_cd, b.pol_iss_cd) = NVL (p_iss_cd, DECODE (p_issue_param, 1, b.iss_cd, b.pol_iss_cd))
              AND b.assd_no = NVL (p_assd_no, b.assd_no)
              AND c.peril_cd = NVL (p_peril_cd, c.peril_cd)
              AND a.claim_id = b.claim_id
              AND a.recovery_id = c.recovery_id
              AND a.claim_id = c.claim_id
              AND NVL (cancel_tag, 'N') = 'N'
              AND TRUNC (tran_date) >= p_curr1_date
              AND TRUNC (tran_date) <= p_curr2_date
         GROUP BY b.assd_no, a.recovery_id, line_cd, subline_cd, iss_cd, peril_cd;

         IF SQL%FOUND THEN
            p_curr_exists := 'Y';
            FORALL i IN vv_rec_id.FIRST .. vv_rec_id.LAST
               INSERT INTO gicl_lratio_curr_recovery_ext
                           (session_id, recovery_id, assd_no, line_cd, subline_cd, iss_cd, peril_cd, recovered_amt, user_id
                           )
                    VALUES (p_session_id, vv_rec_id (i), vv_assd_no (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), vv_rec_amt (i), p_user_id
                           );
         END IF;
      END;
   END;

   PROCEDURE lratio_extract_recovery2 (
      p_line_cd             giis_line.line_cd%TYPE,
      p_subline_cd          giis_subline.subline_cd%TYPE,
      p_iss_cd              giis_issource.iss_cd%TYPE,
      p_peril_cd            giis_peril.peril_cd%TYPE,
      p_assd_no             giis_assured.assd_no%TYPE,
      p_session_id          gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param          NUMBER,
      p_issue_param         NUMBER,
      p_curr1_date          gipi_polbasic.issue_date%TYPE,
      p_curr2_date          gipi_polbasic.issue_date%TYPE,
      p_prev1_date          gipi_polbasic.issue_date%TYPE,
      p_prev2_date          gipi_polbasic.issue_date%TYPE,
      p_curr_exists   OUT   VARCHAR2,
      p_prev_exists   OUT   VARCHAR2,
      p_extract_cat         VARCHAR2,
      p_user_id             giis_users.user_id%TYPE
   )
   AS
      TYPE rec_amt_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE assd_no_tab IS TABLE OF giis_assured.assd_no%TYPE;

      TYPE rec_id_tab IS TABLE OF gicl_clm_recovery.recovery_id%TYPE;

      TYPE line_cd_tab IS TABLE OF giis_line.line_cd%TYPE;

      TYPE subline_cd_tab IS TABLE OF giis_subline.subline_cd%TYPE;

      TYPE iss_cd_tab IS TABLE OF giis_issource.iss_cd%TYPE;

      TYPE peril_cd_tab IS TABLE OF giis_peril.peril_cd%TYPE;

      vv_rec_id       rec_id_tab;
      vv_rec_amt      rec_amt_tab;
      vv_assd_no      assd_no_tab;
      vv_line_cd      line_cd_tab;
      vv_subline_cd   subline_cd_tab;
      vv_iss_cd       iss_cd_tab;
      vv_peril_cd     peril_cd_tab;
   BEGIN
      p_curr_exists := 'N';
      p_prev_exists := 'N';
      p_curr_exists := 'Y';

      BEGIN
         DELETE      gicl_lratio_prev_recovery_ext
               WHERE user_id = p_user_id;

         SELECT   b.assd_no, a.recovery_id, line_cd, subline_cd, iss_cd, peril_cd, SUM (NVL (recovered_amt, 0) * (NVL (c.recoverable_amt, 0) / get_rec_amt (c.recovery_id))) recovered_amt
         BULK COLLECT INTO vv_assd_no, vv_rec_id, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_peril_cd, vv_rec_amt
             FROM (SELECT aa.claim_id, aa.recovery_id, aa.tran_date, aa.cancel_tag,
                          DECODE (p_extract_cat, 'G', aa.recovered_amt, DECODE (aa.dist_sw, 'Y', bb.shr_recovery_amt, aa.recovered_amt)) recovered_amt
                     FROM gicl_recovery_payt aa, gicl_recovery_ds bb
                    WHERE 1 = 1 AND aa.recovery_id = bb.recovery_id(+) AND aa.recovery_payt_id = bb.recovery_payt_id(+) AND bb.share_type(+) = 1 AND NVL (bb.negate_tag, 'N') = 'N') a,
                  gicl_claims b,
                  gicl_clm_recovery_dtl c
            WHERE 1 = 1
              AND b.line_cd = NVL (p_line_cd, b.line_cd)
              AND b.subline_cd = NVL (p_subline_cd, b.subline_cd)
              AND DECODE (p_issue_param, 1, b.iss_cd, b.pol_iss_cd) = NVL (p_iss_cd, DECODE (p_issue_param, 1, b.iss_cd, b.pol_iss_cd))
              AND b.assd_no = NVL (p_assd_no, b.assd_no)
              AND c.peril_cd = NVL (p_peril_cd, c.peril_cd)
              AND a.claim_id = b.claim_id
              AND a.recovery_id = c.recovery_id
              AND a.claim_id = c.claim_id
              AND NVL (cancel_tag, 'N') = 'N'
              AND TO_NUMBER (TO_CHAR (TRUNC (b.loss_date), 'YYYY')) = TO_NUMBER (TO_CHAR (TRUNC (tran_date), 'YYYY'))
              AND TRUNC (tran_date) >= p_prev1_date
              AND TRUNC (tran_date) <= p_prev2_date
         GROUP BY b.assd_no, a.recovery_id, line_cd, subline_cd, iss_cd, peril_cd;

         IF SQL%FOUND THEN
            p_prev_exists := 'Y';
            FORALL i IN vv_rec_id.FIRST .. vv_rec_id.LAST
               INSERT INTO gicl_lratio_prev_recovery_ext
                           (session_id, recovery_id, assd_no, line_cd, subline_cd, iss_cd, peril_cd, recovered_amt, user_id
                           )
                    VALUES (p_session_id, vv_rec_id (i), vv_assd_no (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), vv_rec_amt (i), p_user_id
                           );
            vv_rec_id.DELETE;
            vv_assd_no.DELETE;
            vv_rec_amt.DELETE;
            vv_line_cd.DELETE;
            vv_subline_cd.DELETE;
            vv_iss_cd.DELETE;
            vv_peril_cd.DELETE;
         END IF;
      END;

      BEGIN
         DELETE      gicl_lratio_curr_recovery_ext
               WHERE user_id = p_user_id;

         SELECT   b.assd_no, a.recovery_id, line_cd, subline_cd, iss_cd, peril_cd, SUM (NVL (recovered_amt, 0) * (NVL (c.recoverable_amt, 0) / get_rec_amt (c.recovery_id))) recovered_amt
         BULK COLLECT INTO vv_assd_no, vv_rec_id, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_peril_cd, vv_rec_amt
             FROM (SELECT aa.claim_id, aa.recovery_id, aa.tran_date, aa.cancel_tag,
                          DECODE (p_extract_cat, 'G', aa.recovered_amt, DECODE (aa.dist_sw, 'Y', bb.shr_recovery_amt, aa.recovered_amt)) recovered_amt
                     FROM gicl_recovery_payt aa, gicl_recovery_ds bb
                    WHERE 1 = 1 AND aa.recovery_id = bb.recovery_id(+) AND aa.recovery_payt_id = bb.recovery_payt_id(+) AND bb.share_type(+) = 1 AND NVL (bb.negate_tag, 'N') = 'N') a,
                  gicl_claims b,
                  gicl_clm_recovery_dtl c
            WHERE 1 = 1
              AND b.line_cd = NVL (p_line_cd, b.line_cd)
              AND b.subline_cd = NVL (p_subline_cd, b.subline_cd)
              AND DECODE (p_issue_param, 1, b.iss_cd, b.pol_iss_cd) = NVL (p_iss_cd, DECODE (p_issue_param, 1, b.iss_cd, b.pol_iss_cd))
              AND b.assd_no = NVL (p_assd_no, b.assd_no)
              AND c.peril_cd = NVL (p_peril_cd, c.peril_cd)
              AND a.claim_id = b.claim_id
              AND a.recovery_id = c.recovery_id
              AND a.claim_id = c.claim_id
              AND NVL (cancel_tag, 'N') = 'N'
              AND TO_NUMBER (TO_CHAR (TRUNC (b.loss_date), 'YYYY')) = TO_NUMBER (TO_CHAR (TRUNC (tran_date), 'YYYY'))
              AND TRUNC (tran_date) >= p_curr1_date
              AND TRUNC (tran_date) <= p_curr2_date
         GROUP BY b.assd_no, a.recovery_id, line_cd, subline_cd, iss_cd, peril_cd;

         IF SQL%FOUND THEN
            p_curr_exists := 'Y';
            FORALL i IN vv_rec_id.FIRST .. vv_rec_id.LAST
               INSERT INTO gicl_lratio_curr_recovery_ext
                           (session_id, recovery_id, assd_no, line_cd, subline_cd, iss_cd, peril_cd, recovered_amt, user_id
                           )
                    VALUES (p_session_id, vv_rec_id (i), vv_assd_no (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), vv_rec_amt (i), p_user_id
                           );
         END IF;
      END;
   END;

   PROCEDURE lratio_extract_premium_intm2 (
      p_line_cd             giis_line.line_cd%TYPE,
      p_subline_cd          giis_subline.subline_cd%TYPE,
      p_iss_cd              giis_issource.iss_cd%TYPE,
      p_peril_cd            giis_peril.peril_cd%TYPE,
      p_intm_no             giis_intermediary.intm_no%TYPE,
      p_session_id          gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param          NUMBER,
      p_issue_param         NUMBER,
      p_curr1_date          gipi_polbasic.issue_date%TYPE,
      p_curr2_date          gipi_polbasic.issue_date%TYPE,
      p_prev1_date          gipi_polbasic.issue_date%TYPE,
      p_prev2_date          gipi_polbasic.issue_date%TYPE,
      p_prev_year           VARCHAR2,
      p_curr_exists   OUT   VARCHAR2,
      p_prev_exists   OUT   VARCHAR2,
      p_ext_proc            VARCHAR2,
      p_extract_cat         VARCHAR2,
      p_user_id             giis_users.user_id%TYPE
   )
   AS
      TYPE policy_id_tab IS TABLE OF gipi_polbasic.policy_id%TYPE;

      TYPE curr_prem_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE assd_no_tab IS TABLE OF giis_assured.assd_no%TYPE;

      TYPE peril_cd_tab IS TABLE OF giis_peril.peril_cd%TYPE;

      TYPE line_cd_tab IS TABLE OF giis_line.line_cd%TYPE;

      TYPE subline_cd_tab IS TABLE OF giis_subline.subline_cd%TYPE;

      TYPE iss_cd_tab IS TABLE OF giis_issource.iss_cd%TYPE;

      TYPE intm_no_tab IS TABLE OF giis_intermediary.intm_no%TYPE;

      TYPE date24_tab IS TABLE OF VARCHAR2 (10);

      vv_policy_id    policy_id_tab;
      vv_prem         curr_prem_tab;
      vv_assd_no      assd_no_tab;
      vv_line_cd      line_cd_tab;
      vv_subline_cd   subline_cd_tab;
      vv_iss_cd       iss_cd_tab;
      vv_peril_cd     peril_cd_tab;
      vv_intm_no      intm_no_tab;
      vv_date24       date24_tab;
   BEGIN
      p_curr_exists := 'N';
      p_prev_exists := 'N';

      BEGIN
         DELETE      gicl_lratio_curr_prem_ext
               WHERE user_id = p_user_id;

         BEGIN
            SELECT d.policy_id, c.intrmdry_intm_no, d.line_cd, d.subline_cd, d.iss_cd, c.peril_cd,
                   get_latest_assured_no (d.line_cd, d.subline_cd, d.iss_cd, d.issue_yy, d.pol_seq_no, d.renew_no, p_curr1_date, p_curr2_date) assd_no, (c.premium_amt * b.currency_rt) prem_amt,
                   TO_CHAR (d.acct_ent_date, 'MM-DD-YYYY')
            BULK COLLECT INTO vv_policy_id, vv_intm_no, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_peril_cd,
                   vv_assd_no, vv_prem,
                   vv_date24
              FROM gipi_polbasic d,
                   (SELECT   a.policy_id, a.iss_cd, a.prem_seq_no, a.intrmdry_intm_no, a.peril_cd, DECODE (p_extract_cat,
                                                                                                           'G', a.premium_amt,
                                                                                                           SUM (d.dist_prem) * (b.share_percentage / 100)
                                                                                                          ) premium_amt
                        FROM gipi_comm_inv_peril a, gipi_comm_invoice b, giuw_pol_dist c, giuw_perilds_dtl d
                       WHERE 1 = 1
                         AND a.policy_id = b.policy_id
                         AND a.iss_cd = b.iss_cd
                         AND a.prem_seq_no = b.prem_seq_no
                         AND a.intrmdry_intm_no = b.intrmdry_intm_no
                         AND a.policy_id = c.policy_id
                         AND c.dist_no = d.dist_no
                         AND a.peril_cd = d.peril_cd
                         AND d.share_cd = 1
                    GROUP BY a.policy_id, a.iss_cd, a.prem_seq_no, a.intrmdry_intm_no, a.peril_cd, a.premium_amt, b.share_percentage) c,
                   gipi_invoice b
             WHERE d.policy_id = c.policy_id
               AND d.line_cd = NVL (p_line_cd, d.line_cd)
               AND d.subline_cd = NVL (p_subline_cd, d.subline_cd)
               AND d.iss_cd = NVL (p_iss_cd, d.iss_cd)
               AND c.peril_cd = NVL (p_peril_cd, c.peril_cd)
               AND TRUNC (d.acct_ent_date) >= p_curr1_date
               AND TRUNC (d.acct_ent_date) <= p_curr2_date
               AND d.pol_flag IN ('1', '2', '3', '4', 'X')
               AND c.intrmdry_intm_no = NVL (p_intm_no, c.intrmdry_intm_no)
               AND c.policy_id = b.policy_id
               AND c.iss_cd = b.iss_cd
               AND c.prem_seq_no = b.prem_seq_no
               AND c.premium_amt <> 0;

            IF SQL%FOUND THEN
               p_curr_exists := 'Y';
               FORALL i IN vv_policy_id.FIRST .. vv_policy_id.LAST
                  INSERT INTO gicl_lratio_curr_prem_ext
                              (session_id, assd_no, policy_id, line_cd, subline_cd, iss_cd, peril_cd, prem_amt, intm_no, user_id,
                               date_for_24th
                              )
                       VALUES (p_session_id, vv_assd_no (i), vv_policy_id (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), vv_prem (i), vv_intm_no (i), p_user_id,
                               TO_DATE (vv_date24 (i), 'MM-DD-YYYY')
                              );
               vv_assd_no.DELETE;
               vv_policy_id.DELETE;
               vv_prem.DELETE;
               vv_line_cd.DELETE;
               vv_subline_cd.DELETE;
               vv_iss_cd.DELETE;
               vv_intm_no.DELETE;
               vv_date24.DELETE;
               vv_peril_cd.DELETE;
            END IF;
         END;

         BEGIN
            SELECT d.policy_id, c.intrmdry_intm_no, d.line_cd, d.subline_cd, d.iss_cd, c.peril_cd,
                   get_latest_assured_no (d.line_cd, d.subline_cd, d.iss_cd, d.issue_yy, d.pol_seq_no, d.renew_no, p_curr1_date, p_curr2_date) assd_no, (c.premium_amt * b.currency_rt) prem_amt,
                   TO_CHAR (d.spld_acct_ent_date, 'MM-DD-YYYY')
            BULK COLLECT INTO vv_policy_id, vv_intm_no, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_peril_cd,
                   vv_assd_no, vv_prem,
                   vv_date24
              FROM gipi_polbasic d,
                   (SELECT   a.policy_id, a.iss_cd, a.prem_seq_no, a.intrmdry_intm_no, a.peril_cd, DECODE (p_extract_cat,
                                                                                                           'G', a.premium_amt,
                                                                                                           SUM (d.dist_prem) * (b.share_percentage / 100)
                                                                                                          ) premium_amt
                        FROM gipi_comm_inv_peril a, gipi_comm_invoice b, giuw_pol_dist c, giuw_perilds_dtl d
                       WHERE 1 = 1
                         AND a.policy_id = b.policy_id
                         AND a.iss_cd = b.iss_cd
                         AND a.prem_seq_no = b.prem_seq_no
                         AND a.intrmdry_intm_no = b.intrmdry_intm_no
                         AND a.policy_id = c.policy_id
                         AND c.dist_no = d.dist_no
                         AND a.peril_cd = d.peril_cd
                         AND d.share_cd = 1
                    GROUP BY a.policy_id, a.iss_cd, a.prem_seq_no, a.intrmdry_intm_no, a.peril_cd, a.premium_amt, b.share_percentage) c,
                   gipi_invoice b
             WHERE d.policy_id = c.policy_id
               AND d.line_cd = NVL (p_line_cd, d.line_cd)
               AND d.subline_cd = NVL (p_subline_cd, d.subline_cd)
               AND d.iss_cd = NVL (p_iss_cd, d.iss_cd)
               AND c.peril_cd = NVL (p_peril_cd, c.peril_cd)
               AND TRUNC (d.spld_acct_ent_date) >= p_curr1_date
               AND TRUNC (d.spld_acct_ent_date) <= p_curr2_date
               AND d.pol_flag IN ('1', '2', '3', '4', 'X')
               AND c.intrmdry_intm_no = NVL (p_intm_no, c.intrmdry_intm_no)
               AND c.policy_id = b.policy_id
               AND c.iss_cd = b.iss_cd
               AND c.prem_seq_no = b.prem_seq_no
               AND c.premium_amt <> 0;

            IF SQL%FOUND THEN
               p_curr_exists := 'Y';
               FORALL i IN vv_policy_id.FIRST .. vv_policy_id.LAST
                  INSERT INTO gicl_lratio_curr_prem_ext
                              (session_id, assd_no, policy_id, spld_sw, line_cd, subline_cd, iss_cd, peril_cd, prem_amt, intm_no, user_id,
                               date_for_24th
                              )
                       VALUES (p_session_id, vv_assd_no (i), vv_policy_id (i), 'Y', vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), vv_prem (i), vv_intm_no (i), p_user_id,
                               TO_DATE (vv_date24 (i), 'MM-DD-YYYY')
                              );
               vv_assd_no.DELETE;
               vv_policy_id.DELETE;
               vv_prem.DELETE;
               vv_line_cd.DELETE;
               vv_subline_cd.DELETE;
               vv_iss_cd.DELETE;
               vv_intm_no.DELETE;
               vv_peril_cd.DELETE;
               vv_date24.DELETE;
            END IF;
         END;
      END;

      FOR del_spld IN (SELECT a.policy_id
                         FROM gicl_lratio_curr_prem_ext a, gicl_lratio_curr_prem_ext b
                        WHERE a.session_id = p_session_id AND a.session_id = b.session_id AND a.policy_id = b.policy_id AND NVL (a.spld_sw, 'N') = 'Y' AND NVL (b.spld_sw, 'N') = 'N')
      LOOP
         DELETE      gicl_lratio_curr_prem_ext
               WHERE policy_id = del_spld.policy_id AND session_id = p_session_id;
      END LOOP;

      BEGIN
         DELETE      gicl_lratio_prev_prem_ext
               WHERE user_id = p_user_id;

         BEGIN
            SELECT d.policy_id, c.intrmdry_intm_no, d.line_cd, d.subline_cd, d.iss_cd, c.peril_cd,
                   get_latest_assured_no (d.line_cd, d.subline_cd, d.iss_cd, d.issue_yy, d.pol_seq_no, d.renew_no, p_prev1_date, p_prev2_date) assd_no, (c.premium_amt * b.currency_rt) prem_amt,
                   TO_CHAR (d.acct_ent_date, 'MM-DD-YYYY')
            BULK COLLECT INTO vv_policy_id, vv_intm_no, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_peril_cd,
                   vv_assd_no, vv_prem,
                   vv_date24
              FROM gipi_polbasic d,
                   (SELECT   a.policy_id, a.iss_cd, a.prem_seq_no, a.intrmdry_intm_no, a.peril_cd, DECODE (p_extract_cat,
                                                                                                           'G', a.premium_amt,
                                                                                                           SUM (d.dist_prem) * (b.share_percentage / 100)
                                                                                                          ) premium_amt
                        FROM gipi_comm_inv_peril a, gipi_comm_invoice b, giuw_pol_dist c, giuw_perilds_dtl d
                       WHERE 1 = 1
                         AND a.policy_id = b.policy_id
                         AND a.iss_cd = b.iss_cd
                         AND a.prem_seq_no = b.prem_seq_no
                         AND a.intrmdry_intm_no = b.intrmdry_intm_no
                         AND a.policy_id = c.policy_id
                         AND c.dist_no = d.dist_no
                         AND a.peril_cd = d.peril_cd
                         AND d.share_cd = 1
                    GROUP BY a.policy_id, a.iss_cd, a.prem_seq_no, a.intrmdry_intm_no, a.peril_cd, a.premium_amt, b.share_percentage) c,
                   gipi_invoice b
             WHERE d.policy_id = c.policy_id
               AND d.line_cd = NVL (p_line_cd, d.line_cd)
               AND d.subline_cd = NVL (p_subline_cd, d.subline_cd)
               AND d.iss_cd = NVL (p_iss_cd, d.iss_cd)
               AND c.peril_cd = NVL (p_peril_cd, c.peril_cd)
               AND ((p_ext_proc = 'S' AND TO_CHAR (d.acct_ent_date, 'YYYY') = p_prev_year) OR (p_ext_proc = 'M' AND TRUNC (d.acct_ent_date) >= p_prev1_date AND TRUNC (d.acct_ent_date) <= p_prev2_date))
               AND d.pol_flag IN ('1', '2', '3', '4', 'X')
               AND c.intrmdry_intm_no = NVL (p_intm_no, c.intrmdry_intm_no)
               AND b.policy_id = c.policy_id
               AND b.iss_cd = c.iss_cd
               AND b.prem_seq_no = c.prem_seq_no
               AND c.premium_amt <> 0;

            IF SQL%FOUND THEN
               p_prev_exists := 'Y';
               FORALL i IN vv_policy_id.FIRST .. vv_policy_id.LAST
                  INSERT INTO gicl_lratio_prev_prem_ext
                              (session_id, assd_no, policy_id, line_cd, subline_cd, iss_cd, peril_cd, prem_amt, intm_no, user_id,
                               date_for_24th
                              )
                       VALUES (p_session_id, vv_assd_no (i), vv_policy_id (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), vv_prem (i), vv_intm_no (i), p_user_id,
                               TO_DATE (vv_date24 (i), 'MM-DD-YYYY')
                              );
               vv_assd_no.DELETE;
               vv_policy_id.DELETE;
               vv_prem.DELETE;
               vv_line_cd.DELETE;
               vv_subline_cd.DELETE;
               vv_iss_cd.DELETE;
               vv_intm_no.DELETE;
               vv_date24.DELETE;
               vv_peril_cd.DELETE;
            END IF;
         END;

         BEGIN
            SELECT d.policy_id, c.intrmdry_intm_no, d.line_cd, d.subline_cd, d.iss_cd, c.peril_cd,
                   get_latest_assured_no (d.line_cd, d.subline_cd, d.iss_cd, d.issue_yy, d.pol_seq_no, d.renew_no, p_prev1_date, p_prev2_date) assd_no, (c.premium_amt * b.currency_rt) prem_amt,
                   TO_CHAR (d.spld_acct_ent_date, 'MM-DD-YYYY')
            BULK COLLECT INTO vv_policy_id, vv_intm_no, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_peril_cd,
                   vv_assd_no, vv_prem,
                   vv_date24
              FROM gipi_polbasic d,
                   (SELECT   a.policy_id, a.iss_cd, a.prem_seq_no, a.intrmdry_intm_no, a.peril_cd, DECODE (p_extract_cat,
                                                                                                           'G', a.premium_amt,
                                                                                                           SUM (d.dist_prem) * (b.share_percentage / 100)
                                                                                                          ) premium_amt
                        FROM gipi_comm_inv_peril a, gipi_comm_invoice b, giuw_pol_dist c, giuw_perilds_dtl d
                       WHERE 1 = 1
                         AND a.policy_id = b.policy_id
                         AND a.iss_cd = b.iss_cd
                         AND a.prem_seq_no = b.prem_seq_no
                         AND a.intrmdry_intm_no = b.intrmdry_intm_no
                         AND a.policy_id = c.policy_id
                         AND c.dist_no = d.dist_no
                         AND a.peril_cd = d.peril_cd
                         AND d.share_cd = 1
                    GROUP BY a.policy_id, a.iss_cd, a.prem_seq_no, a.intrmdry_intm_no, a.peril_cd, a.premium_amt, b.share_percentage) c,
                   gipi_invoice b
             WHERE d.policy_id = c.policy_id
               AND d.line_cd = NVL (p_line_cd, d.line_cd)
               AND d.subline_cd = NVL (p_subline_cd, d.subline_cd)
               AND d.iss_cd = NVL (p_iss_cd, d.iss_cd)
               AND c.peril_cd = NVL (p_peril_cd, c.peril_cd)
               AND (   (p_ext_proc = 'S' AND TO_CHAR (d.spld_acct_ent_date, 'YYYY') = p_prev_year)
                    OR (p_ext_proc = 'M' AND TRUNC (d.spld_acct_ent_date) >= p_prev1_date AND TRUNC (d.spld_acct_ent_date) <= p_prev2_date)
                   )
               AND d.pol_flag IN ('1', '2', '3', '4', 'X')
               AND c.intrmdry_intm_no = NVL (p_intm_no, c.intrmdry_intm_no)
               AND c.policy_id = b.policy_id
               AND c.iss_cd = b.iss_cd
               AND c.prem_seq_no = b.prem_seq_no
               AND c.premium_amt <> 0;

            IF SQL%FOUND THEN
               p_prev_exists := 'Y';
               FORALL i IN vv_policy_id.FIRST .. vv_policy_id.LAST
                  INSERT INTO gicl_lratio_prev_prem_ext
                              (session_id, assd_no, policy_id, spld_sw, line_cd, subline_cd, iss_cd, peril_cd, prem_amt, intm_no, user_id,
                               date_for_24th
                              )
                       VALUES (p_session_id, vv_assd_no (i), vv_policy_id (i), 'Y', vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), -vv_prem (i), vv_intm_no (i), p_user_id,
                               TO_DATE (vv_date24 (i), 'MM-DD-YYYY')
                              );
            END IF;
         END;

         FOR del_spld IN (SELECT a.policy_id
                            FROM gicl_lratio_prev_prem_ext a, gicl_lratio_prev_prem_ext b
                           WHERE a.session_id = p_session_id AND a.session_id = b.session_id AND a.policy_id = b.policy_id AND NVL (a.spld_sw, 'N') = 'Y' AND NVL (b.spld_sw, 'N') = 'N')
         LOOP
            DELETE      gicl_lratio_prev_prem_ext
                  WHERE policy_id = del_spld.policy_id AND session_id = p_session_id;
         END LOOP;
      END;
   END;

   PROCEDURE lratio_extract_premium_intm (
      p_line_cd             giis_line.line_cd%TYPE,
      p_subline_cd          giis_subline.subline_cd%TYPE,
      p_iss_cd              giis_issource.iss_cd%TYPE,
      p_peril_cd            giis_peril.peril_cd%TYPE,
      p_intm_no             giis_intermediary.intm_no%TYPE,
      p_session_id          gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param          NUMBER,
      p_issue_param         NUMBER,
      p_curr1_date          gipi_polbasic.issue_date%TYPE,
      p_curr2_date          gipi_polbasic.issue_date%TYPE,
      p_prev1_date          gipi_polbasic.issue_date%TYPE,
      p_prev2_date          gipi_polbasic.issue_date%TYPE,
      p_prev_year           VARCHAR2,
      p_curr_exists   OUT   VARCHAR2,
      p_prev_exists   OUT   VARCHAR2,
      p_ext_proc            VARCHAR2,
      p_extract_cat         VARCHAR2,
      p_user_id             giis_users.user_id%TYPE
   )
   AS
      TYPE policy_id_tab IS TABLE OF gipi_polbasic.policy_id%TYPE;

      TYPE curr_prem_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE assd_no_tab IS TABLE OF giis_assured.assd_no%TYPE;

      TYPE peril_cd_tab IS TABLE OF giis_peril.peril_cd%TYPE;

      TYPE line_cd_tab IS TABLE OF giis_line.line_cd%TYPE;

      TYPE subline_cd_tab IS TABLE OF giis_subline.subline_cd%TYPE;

      TYPE iss_cd_tab IS TABLE OF giis_issource.iss_cd%TYPE;

      TYPE intm_no_tab IS TABLE OF giis_intermediary.intm_no%TYPE;

      TYPE date24_tab IS TABLE OF VARCHAR2 (10);

      vv_policy_id    policy_id_tab;
      vv_prem         curr_prem_tab;
      vv_assd_no      assd_no_tab;
      vv_line_cd      line_cd_tab;
      vv_subline_cd   subline_cd_tab;
      vv_iss_cd       iss_cd_tab;
      vv_intm_no      intm_no_tab;
      vv_date24       date24_tab;
      vv_peril_cd     peril_cd_tab;
   BEGIN                                                                                                                                                                                          --main
      p_curr_exists := 'N';
      p_prev_exists := 'N';

      BEGIN                                                                                                                   --select all records from gipi_polbasic for all valid current year policy
         --delete records in extract table gicl_lratio_curr_prem_ext for the current user
         DELETE      gicl_lratio_curr_prem_ext
               WHERE user_id = p_user_id;

         SELECT d.policy_id, c.intrmdry_intm_no, d.line_cd, d.subline_cd, d.iss_cd, c.peril_cd,
                get_latest_assured_no (d.line_cd, d.subline_cd, d.iss_cd, d.issue_yy, d.pol_seq_no, d.renew_no, p_curr1_date, p_curr2_date) assd_no, (c.premium_amt * b.currency_rt) prem_amt,
                TO_CHAR (TRUNC (DECODE (p_date_param, 1, d.issue_date, 2, d.eff_date, 4, LAST_DAY (TO_DATE (UPPER (d.booking_mth) || ' 1,' || TO_CHAR (d.booking_year), 'FMMONTH DD,YYYY')), SYSDATE)),
                         'MM-DD-YYYY'
                        )
         BULK COLLECT INTO vv_policy_id, vv_intm_no, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_peril_cd,
                vv_assd_no, vv_prem,
                vv_date24
           FROM gipi_polbasic d,
                
                --gipi_comm_inv_peril c, -- Udel 12212011 replaced by the SELECT statement below
                (SELECT   a.policy_id, a.iss_cd, a.prem_seq_no, a.intrmdry_intm_no, a.peril_cd, DECODE (p_extract_cat, 'G', a.premium_amt, SUM (d.dist_prem) * (b.share_percentage / 100)) premium_amt
                     FROM gipi_comm_inv_peril a, gipi_comm_invoice b, giuw_pol_dist c, giuw_perilds_dtl d
                    WHERE 1 = 1
                      AND a.policy_id = b.policy_id
                      AND a.iss_cd = b.iss_cd
                      AND a.prem_seq_no = b.prem_seq_no
                      AND a.intrmdry_intm_no = b.intrmdry_intm_no
                      AND a.policy_id = c.policy_id
                      AND c.dist_no = d.dist_no
                      AND a.peril_cd = d.peril_cd
                      AND d.share_cd = 1
                 GROUP BY a.policy_id, a.iss_cd, a.prem_seq_no, a.intrmdry_intm_no, a.peril_cd, a.premium_amt, b.share_percentage) c,
                gipi_invoice b
          WHERE d.policy_id = c.policy_id
            AND d.line_cd = NVL (p_line_cd, d.line_cd)
            AND d.subline_cd = NVL (p_subline_cd, d.subline_cd)
            AND d.iss_cd = NVL (p_iss_cd, d.iss_cd)
            AND c.peril_cd = NVL (p_peril_cd, c.peril_cd)
            AND TRUNC (DECODE (p_date_param, 1, d.issue_date, 2, d.eff_date, 4, LAST_DAY (TO_DATE (UPPER (d.booking_mth) || ' 1,' || TO_CHAR (d.booking_year), 'FMMONTH DD,YYYY')), SYSDATE)) >=
                                                                                                                                                                                            p_curr1_date
            AND TRUNC (DECODE (p_date_param, 1, d.issue_date, 2, d.eff_date, 4, LAST_DAY (TO_DATE (UPPER (d.booking_mth) || ' 1,' || TO_CHAR (d.booking_year), 'FMMONTH DD,YYYY')), SYSDATE)) <=
                                                                                                                                                                                            p_curr2_date
            AND d.pol_flag IN ('1', '2', '3', '4', 'X')
            AND c.intrmdry_intm_no = NVL (p_intm_no, c.intrmdry_intm_no)
            AND c.policy_id = b.policy_id
            AND c.iss_cd = b.iss_cd
            AND c.prem_seq_no = b.prem_seq_no
            AND c.premium_amt <> 0;

         /*GROUP BY d.policy_id,       c.intrmdry_intm_no,     d.line_cd,
                  d.subline_cd,      d.iss_cd,               c.peril_cd,
                     Get_Latest_Assured_No(d.line_cd,
                                        d.subline_cd,
                                        d.iss_cd,
                                        d.issue_yy,
                                        d.pol_seq_no,
                                        d.renew_no,
                                        p_curr1_date,
                                        p_curr2_date),
              TO_CHAR(TRUNC(DECODE(p_date_param, 1, d.issue_date,
                                          2, d.eff_date,
                                          4, LAST_DAY(TO_DATE(UPPER(d.booking_mth)||' 1,'||TO_CHAR(d.booking_year),'FMMONTH DD,YYYY')),SYSDATE)),'MM-DD-YYYY');*/
         --INSERT RECORD ON TABLE GICL_LRATIO_CURR_PREM_EXT
         IF SQL%FOUND THEN
            p_curr_exists := 'Y';
            FORALL i IN vv_policy_id.FIRST .. vv_policy_id.LAST
               INSERT INTO gicl_lratio_curr_prem_ext
                           (session_id, assd_no, policy_id, line_cd, subline_cd, iss_cd, peril_cd, prem_amt, intm_no, user_id,
                            date_for_24th
                           )
                    VALUES (p_session_id, vv_assd_no (i), vv_policy_id (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), vv_prem (i), vv_intm_no (i), p_user_id,
                            TO_DATE (vv_date24 (i), 'MM-DD-YYYY')
                           );
            --AFTER INSERT REFRESH ARRAYS BY DELETING DATA
            vv_assd_no.DELETE;
            vv_policy_id.DELETE;
            vv_prem.DELETE;
            vv_line_cd.DELETE;
            vv_subline_cd.DELETE;
            vv_iss_cd.DELETE;
            vv_peril_cd.DELETE;
            vv_intm_no.DELETE;
            vv_date24.DELETE;
         END IF;
      END;                                                                                                                     --SELECT ALL RECORDS FROM GIPI_POLBASIC FOR ALL VALID CURRENT YEAR POLICY

      BEGIN                                                                                                                   --SELECT ALL RECORDS FROM GIPI_POLBASIC FOR ALL VALID PREVIOUS YEAR POLICY
         --DELETE RECORDS IN EXTRACT TABLE GICL_LRATIO_PREV_PREM_EXT FOR THE CURRENT USER
         DELETE      gicl_lratio_prev_prem_ext
               WHERE user_id = p_user_id;

         SELECT d.policy_id, c.intrmdry_intm_no, d.line_cd, d.subline_cd, d.iss_cd, c.peril_cd,
                get_latest_assured_no (d.line_cd, d.subline_cd, d.iss_cd, d.issue_yy, d.pol_seq_no, d.renew_no, p_prev1_date, p_prev2_date) assd_no, (c.premium_amt * b.currency_rt) prem_amt,
                TO_CHAR (TRUNC (DECODE (p_date_param, 1, d.issue_date, 2, d.eff_date, 4, LAST_DAY (TO_DATE (UPPER (d.booking_mth) || ' 1,' || TO_CHAR (d.booking_year), 'FMMONTH DD,YYYY')), SYSDATE)),
                         'MM-DD-YYYY'
                        )
         BULK COLLECT INTO vv_policy_id, vv_intm_no, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_peril_cd,
                vv_assd_no, vv_prem,
                vv_date24
           FROM gipi_polbasic d,
                
                --gipi_comm_inv_peril c, -- Udel 12212011 replaced by the SELECT statement below
                (SELECT   a.policy_id, a.iss_cd, a.prem_seq_no, a.intrmdry_intm_no, a.peril_cd, DECODE (p_extract_cat, 'G', a.premium_amt, SUM (d.dist_prem) * (b.share_percentage / 100)) premium_amt
                     FROM gipi_comm_inv_peril a, gipi_comm_invoice b, giuw_pol_dist c, giuw_perilds_dtl d
                    WHERE 1 = 1
                      AND a.policy_id = b.policy_id
                      AND a.iss_cd = b.iss_cd
                      AND a.prem_seq_no = b.prem_seq_no
                      AND a.intrmdry_intm_no = b.intrmdry_intm_no
                      AND a.policy_id = c.policy_id
                      AND c.dist_no = d.dist_no
                      AND a.peril_cd = d.peril_cd
                      AND d.share_cd = 1
                 GROUP BY a.policy_id, a.iss_cd, a.prem_seq_no, a.intrmdry_intm_no, a.peril_cd, a.premium_amt, b.share_percentage) c,
                gipi_invoice b
          WHERE d.policy_id = c.policy_id
            AND d.line_cd = NVL (p_line_cd, d.line_cd)
            AND d.subline_cd = NVL (p_subline_cd, d.subline_cd)
            AND d.iss_cd = NVL (p_iss_cd, d.iss_cd)
            AND c.peril_cd = NVL (p_peril_cd, c.peril_cd)
            AND (   (p_ext_proc = 'S' AND DECODE (p_date_param, 1, TO_CHAR (d.issue_date, 'YYYY'), 2, TO_CHAR (d.eff_date, 'YYYY'), 4, TO_CHAR (d.booking_year), TO_CHAR (SYSDATE, 'YYYY')) =
                                                                                                                                                                                             p_prev_year
                    )
                 OR (    p_ext_proc = 'M'
                     AND TRUNC (DECODE (p_date_param, 1, d.issue_date, 2, d.eff_date, 4, LAST_DAY (TO_DATE (UPPER (d.booking_mth) || ' 1,' || TO_CHAR (d.booking_year), 'FMMONTH DD,YYYY')), SYSDATE)) >=
                                                                                                                                                                                            p_prev1_date
                     AND TRUNC (DECODE (p_date_param, 1, d.issue_date, 2, d.eff_date, 4, LAST_DAY (TO_DATE (UPPER (d.booking_mth) || ' 1,' || TO_CHAR (d.booking_year), 'FMMONTH DD,YYYY')), SYSDATE)) <=
                                                                                                                                                                                            p_prev2_date
                    )
                )
            AND d.pol_flag IN ('1', '2', '3', '4', 'X')
            AND c.intrmdry_intm_no = NVL (p_intm_no, c.intrmdry_intm_no)
            AND c.policy_id = b.policy_id
            AND c.iss_cd = b.iss_cd
            AND c.prem_seq_no = b.prem_seq_no
            AND c.premium_amt <> 0;

         /*GROUP BY d.policy_id,       c.intrmdry_intm_no,     d.line_cd,
                  d.subline_cd,      d.iss_cd,               c.peril_cd,
                  Get_Latest_Assured_No(d.line_cd,
                                        d.subline_cd,
                                        d.iss_cd,
                                        d.issue_yy,
                                        d.pol_seq_no,
                                        d.renew_no,
                                        p_prev1_date,
                                        p_prev2_date),
                  TO_CHAR(TRUNC(DECODE(p_date_param, 1, d.issue_date,
                                          2, d.eff_date,
                                          4, LAST_DAY(TO_DATE(UPPER(d.booking_mth)||' 1,'||TO_CHAR(d.booking_year),'FMMONTH DD,YYYY')),SYSDATE)),'MM-DD-YYYY');*/
         --INSERT RECORD ON TABLE GICL_LRATIO_PREV_PREM_EXT
         IF SQL%FOUND THEN
            p_prev_exists := 'Y';
            FORALL i IN vv_policy_id.FIRST .. vv_policy_id.LAST
               INSERT INTO gicl_lratio_prev_prem_ext
                           (session_id, assd_no, policy_id, line_cd, subline_cd, iss_cd, peril_cd, prem_amt, intm_no, user_id,
                            date_for_24th
                           )
                    VALUES (p_session_id, vv_assd_no (i), vv_policy_id (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), vv_prem (i), vv_intm_no (i), p_user_id,
                            TO_DATE (vv_date24 (i), 'MM-DD-YYYY')
                           );
         END IF;
      END;                                                                                                                    --SELECT ALL RECORDS FROM GIPI_POLBASIC FOR ALL VALID PREVIOUS YEAR POLICY
   END;                                                                                                                                                                                           --MAIN

   PROCEDURE lratio_extract_prem_intm2_assd (
      p_line_cd             giis_line.line_cd%TYPE,
      p_subline_cd          giis_subline.subline_cd%TYPE,
      p_iss_cd              giis_issource.iss_cd%TYPE,
      p_peril_cd            giis_peril.peril_cd%TYPE,
      p_intm_no             giis_intermediary.intm_no%TYPE,
      p_assd_no             giis_assured.assd_no%TYPE,
      p_session_id          gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param          NUMBER,
      p_issue_param         NUMBER,
      p_curr1_date          gipi_polbasic.issue_date%TYPE,
      p_curr2_date          gipi_polbasic.issue_date%TYPE,
      p_prev1_date          gipi_polbasic.issue_date%TYPE,
      p_prev2_date          gipi_polbasic.issue_date%TYPE,
      p_prev_year           VARCHAR2,
      p_curr_exists   OUT   VARCHAR2,
      p_prev_exists   OUT   VARCHAR2,
      p_ext_proc            VARCHAR2,
      p_extract_cat         VARCHAR2,
      p_user_id             giis_users.user_id%TYPE
   )
   AS
      TYPE policy_id_tab IS TABLE OF gipi_polbasic.policy_id%TYPE;

      TYPE curr_prem_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE peril_cd_tab IS TABLE OF giis_peril.peril_cd%TYPE;

      TYPE line_cd_tab IS TABLE OF giis_line.line_cd%TYPE;

      TYPE subline_cd_tab IS TABLE OF giis_subline.subline_cd%TYPE;

      TYPE iss_cd_tab IS TABLE OF giis_issource.iss_cd%TYPE;

      TYPE intm_no_tab IS TABLE OF giis_intermediary.intm_no%TYPE;

      TYPE date24_tab IS TABLE OF VARCHAR2 (10);

      vv_policy_id    policy_id_tab;
      vv_prem         curr_prem_tab;
      vv_line_cd      line_cd_tab;
      vv_subline_cd   subline_cd_tab;
      vv_iss_cd       iss_cd_tab;
      vv_peril_cd     peril_cd_tab;
      vv_intm_no      intm_no_tab;
      vv_date24       date24_tab;
   BEGIN                                                                                                                                                                                          --main
      p_curr_exists := 'N';
      p_prev_exists := 'N';

      BEGIN                                                                                                                                                    -- extract current year premiums written
         --delete records in extract table gicl_lratio_curr_prem_ext for the current user
         DELETE      gicl_lratio_curr_prem_ext
               WHERE user_id = p_user_id;

         BEGIN                                                                                                                                       --select all records from gipi_polbasic for record
            --with accounting entry date within the current year
            SELECT   d.policy_id, d.line_cd, d.subline_cd, d.iss_cd, c.peril_cd, c.intrmdry_intm_no, SUM (c.premium_amt * b.currency_rt) prem_amt, TO_CHAR (d.acct_ent_date, 'MM-DD-YYYY')
            BULK COLLECT INTO vv_policy_id, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_peril_cd, vv_intm_no, vv_prem, vv_date24
                FROM gipi_polbasic d,
                     
                     --gipi_comm_inv_peril c, -- Udel 12212011 replaced by the SELECT statement below
                     (SELECT   a.policy_id, a.iss_cd, a.prem_seq_no, a.intrmdry_intm_no, a.peril_cd,
                               DECODE (p_extract_cat, 'G', a.premium_amt, SUM (d.dist_prem) * (b.share_percentage / 100)) premium_amt
                          FROM gipi_comm_inv_peril a, gipi_comm_invoice b, giuw_pol_dist c, giuw_perilds_dtl d
                         WHERE 1 = 1
                           AND a.policy_id = b.policy_id
                           AND a.iss_cd = b.iss_cd
                           AND a.prem_seq_no = b.prem_seq_no
                           AND a.intrmdry_intm_no = b.intrmdry_intm_no
                           AND a.policy_id = c.policy_id
                           AND c.dist_no = d.dist_no
                           AND a.peril_cd = d.peril_cd
                           AND d.share_cd = 1
                      GROUP BY a.policy_id, a.iss_cd, a.prem_seq_no, a.intrmdry_intm_no, a.peril_cd, a.premium_amt, b.share_percentage) c,
                     gipi_invoice b
               WHERE d.policy_id = c.policy_id
                 AND d.line_cd = NVL (p_line_cd, d.line_cd)
                 AND d.subline_cd = NVL (p_subline_cd, d.subline_cd)
                 AND d.iss_cd = NVL (p_iss_cd, d.iss_cd)
                 AND c.peril_cd = NVL (p_peril_cd, c.peril_cd)
                 AND TRUNC (d.acct_ent_date) >= p_curr1_date
                 AND TRUNC (d.acct_ent_date) <= p_curr2_date
                 AND d.pol_flag IN ('1', '2', '3', '4', 'X')
                 AND c.intrmdry_intm_no = NVL (p_intm_no, c.intrmdry_intm_no)
                 AND get_latest_assured_no (d.line_cd, d.subline_cd, d.iss_cd, d.issue_yy, d.pol_seq_no, d.renew_no, p_curr1_date, p_curr2_date) = p_assd_no
                 AND c.policy_id = b.policy_id
                 AND c.iss_cd = b.iss_cd
                 AND c.prem_seq_no = b.prem_seq_no
                 AND c.premium_amt <> 0
            GROUP BY d.policy_id, d.line_cd, d.subline_cd, d.iss_cd, c.peril_cd, c.intrmdry_intm_no, TO_CHAR (d.acct_ent_date, 'MM-DD-YYYY');

            --insert record on table gicl_lratio_curr_prem_ext
            IF SQL%FOUND THEN
               p_curr_exists := 'Y';
               FORALL i IN vv_policy_id.FIRST .. vv_policy_id.LAST
                  INSERT INTO gicl_lratio_curr_prem_ext
                              (session_id, assd_no, policy_id, line_cd, subline_cd, iss_cd, peril_cd, intm_no, prem_amt, user_id,
                               date_for_24th
                              )
                       VALUES (p_session_id, p_assd_no, vv_policy_id (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), vv_intm_no (i), vv_prem (i), p_user_id,
                               TO_DATE (vv_date24 (i), 'MM-DD-YYYY')
                              );
               --after insert refresh arrays by deleting data
               vv_policy_id.DELETE;
               vv_prem.DELETE;
               vv_line_cd.DELETE;
               vv_subline_cd.DELETE;
               vv_iss_cd.DELETE;
               vv_intm_no.DELETE;
               vv_date24.DELETE;
               vv_peril_cd.DELETE;
            END IF;
         END;                                                                                                                                         --select all records from gipi_polbasic for record

         --with accounting entry date within the current year
         BEGIN                                                                                                                                        --select all records from gipi_polbasic for record
            --with spoiled accounting entry date within the current year
            SELECT   d.policy_id, d.line_cd, d.subline_cd, d.iss_cd, c.peril_cd, c.intrmdry_intm_no, SUM (c.premium_amt * b.currency_rt) prem_amt, TO_CHAR (d.spld_acct_ent_date, 'MM-DD-YYYY')
            BULK COLLECT INTO vv_policy_id, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_peril_cd, vv_intm_no, vv_prem, vv_date24
                FROM gipi_polbasic d,
                     
                     --gipi_comm_inv_peril c, -- Udel 12212011 replaced by the SELECT statement below
                     (SELECT   a.policy_id, a.iss_cd, a.prem_seq_no, a.intrmdry_intm_no, a.peril_cd,
                               DECODE (p_extract_cat, 'G', a.premium_amt, SUM (d.dist_prem) * (b.share_percentage / 100)) premium_amt
                          FROM gipi_comm_inv_peril a, gipi_comm_invoice b, giuw_pol_dist c, giuw_perilds_dtl d
                         WHERE 1 = 1
                           AND a.policy_id = b.policy_id
                           AND a.iss_cd = b.iss_cd
                           AND a.prem_seq_no = b.prem_seq_no
                           AND a.intrmdry_intm_no = b.intrmdry_intm_no
                           AND a.policy_id = c.policy_id
                           AND c.dist_no = d.dist_no
                           AND a.peril_cd = d.peril_cd
                           AND d.share_cd = 1
                      GROUP BY a.policy_id, a.iss_cd, a.prem_seq_no, a.intrmdry_intm_no, a.peril_cd, a.premium_amt, b.share_percentage) c,
                     gipi_invoice b
               WHERE d.policy_id = c.policy_id
                 AND d.line_cd = NVL (p_line_cd, d.line_cd)
                 AND d.subline_cd = NVL (p_subline_cd, d.subline_cd)
                 AND d.iss_cd = NVL (p_iss_cd, d.iss_cd)
                 AND c.peril_cd = NVL (p_peril_cd, c.peril_cd)
                 AND TRUNC (d.spld_acct_ent_date) >= p_curr1_date
                 AND TRUNC (d.spld_acct_ent_date) <= p_curr2_date
                 AND d.pol_flag IN ('1', '2', '3', '4', 'X')
                 AND c.intrmdry_intm_no = NVL (p_intm_no, c.intrmdry_intm_no)
                 AND get_latest_assured_no (d.line_cd, d.subline_cd, d.iss_cd, d.issue_yy, d.pol_seq_no, d.renew_no, p_curr1_date, p_curr2_date) = p_assd_no
                 AND c.policy_id = b.policy_id
                 AND c.iss_cd = b.iss_cd
                 AND c.prem_seq_no = b.prem_seq_no
                 AND c.premium_amt <> 0
            GROUP BY d.policy_id, d.line_cd, d.subline_cd, d.iss_cd, c.peril_cd, c.intrmdry_intm_no, TO_CHAR (d.spld_acct_ent_date, 'MM-DD-YYYY');

            --insert record on table gicl_lratio_curr_prem_ext
            IF SQL%FOUND THEN
               p_curr_exists := 'Y';
               FORALL i IN vv_policy_id.FIRST .. vv_policy_id.LAST
                  INSERT INTO gicl_lratio_curr_prem_ext
                              (session_id, assd_no, policy_id, spld_sw, line_cd, subline_cd, iss_cd, peril_cd, intm_no, prem_amt, user_id,
                               date_for_24th
                              )
                       VALUES (p_session_id, p_assd_no, vv_policy_id (i), 'Y', vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), vv_intm_no (i), -vv_prem (i), p_user_id,
                               TO_DATE (vv_date24 (i), 'MM-DD-YYYY')
                              );
               --after insert refresh arrays by deleting data
               vv_policy_id.DELETE;
               vv_prem.DELETE;
               vv_line_cd.DELETE;
               vv_subline_cd.DELETE;
               vv_iss_cd.DELETE;
               vv_intm_no.DELETE;
               vv_date24.DELETE;
               vv_peril_cd.DELETE;
            END IF;
         END;                                                                                                                               --select all records from gipi_polbasic for record
                                                                                                                                            --with spoiled accounting entry date within the current year

           -- delete records in table gicl_lratio_curr_prem_ext if accounting entry date
         -- and spoiled accounting entry date is within the current date parameter
         FOR del_spld IN (SELECT a.policy_id
                            FROM gicl_lratio_curr_prem_ext a, gicl_lratio_curr_prem_ext b
                           WHERE a.session_id = p_session_id AND a.session_id = b.session_id AND a.policy_id = b.policy_id AND NVL (a.spld_sw, 'N') = 'Y' AND NVL (b.spld_sw, 'N') = 'N')
         LOOP
            DELETE      gicl_lratio_curr_prem_ext
                  WHERE policy_id = del_spld.policy_id AND session_id = p_session_id;
         END LOOP;
      END;                                                                                                                                                      -- extract current year premiums written

      BEGIN                                                                                                                                                    -- extract previous year premiums written
         --delete records in extract table gicl_lratio_prev_prem_ext for the current user
         DELETE      gicl_lratio_prev_prem_ext
               WHERE user_id = p_user_id;

         BEGIN                                                                                                                                       --select all records from gipi_polbasic for record
            --with accounting entry date within the previous year
            SELECT   d.policy_id, d.line_cd, d.subline_cd, d.iss_cd, c.peril_cd, c.intrmdry_intm_no, SUM (c.premium_amt * b.currency_rt) prem_amt, TO_CHAR (d.acct_ent_date, 'MM-DD-YYYY')
            BULK COLLECT INTO vv_policy_id, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_peril_cd, vv_intm_no, vv_prem, vv_date24
                FROM gipi_polbasic d,
                     
                     --gipi_comm_inv_peril c, -- Udel 12212011 replaced by the SELECT statement below
                     (SELECT   a.policy_id, a.iss_cd, a.prem_seq_no, a.intrmdry_intm_no, a.peril_cd,
                               DECODE (p_extract_cat, 'G', a.premium_amt, SUM (d.dist_prem) * (b.share_percentage / 100)) premium_amt
                          FROM gipi_comm_inv_peril a, gipi_comm_invoice b, giuw_pol_dist c, giuw_perilds_dtl d
                         WHERE 1 = 1
                           AND a.policy_id = b.policy_id
                           AND a.iss_cd = b.iss_cd
                           AND a.prem_seq_no = b.prem_seq_no
                           AND a.intrmdry_intm_no = b.intrmdry_intm_no
                           AND a.policy_id = c.policy_id
                           AND c.dist_no = d.dist_no
                           AND a.peril_cd = d.peril_cd
                           AND d.share_cd = 1
                      GROUP BY a.policy_id, a.iss_cd, a.prem_seq_no, a.intrmdry_intm_no, a.peril_cd, a.premium_amt, b.share_percentage) c,
                     gipi_invoice b
               WHERE d.policy_id = c.policy_id
                 AND d.line_cd = NVL (p_line_cd, d.line_cd)
                 AND d.subline_cd = NVL (p_subline_cd, d.subline_cd)
                 AND d.iss_cd = NVL (p_iss_cd, d.iss_cd)
                 AND c.peril_cd = NVL (p_peril_cd, c.peril_cd)
                 --AND TO_CHAR(d.acct_ent_date,'YYYY') = p_prev_year
                 AND ((p_ext_proc = 'S' AND TO_CHAR (d.acct_ent_date, 'YYYY') = p_prev_year)
                      OR (p_ext_proc = 'M' AND TRUNC (d.acct_ent_date) >= p_prev1_date AND TRUNC (d.acct_ent_date) <= p_prev2_date)
                     )
                 AND d.pol_flag IN ('1', '2', '3', '4', 'X')
                 AND c.intrmdry_intm_no = NVL (p_intm_no, c.intrmdry_intm_no)
                 AND get_latest_assured_no (d.line_cd, d.subline_cd, d.iss_cd, d.issue_yy, d.pol_seq_no, d.renew_no, p_prev1_date, p_prev2_date) = p_assd_no
                 AND c.policy_id = b.policy_id
                 AND c.iss_cd = b.iss_cd
                 AND c.prem_seq_no = b.prem_seq_no
                 AND c.premium_amt <> 0
            GROUP BY d.policy_id, d.line_cd, d.subline_cd, d.iss_cd, c.peril_cd, c.intrmdry_intm_no, TO_CHAR (d.acct_ent_date, 'MM-DD-YYYY');

            --insert record on table gicl_lratio_prev_prem_ext
            IF SQL%FOUND THEN
               p_prev_exists := 'Y';
               FORALL i IN vv_policy_id.FIRST .. vv_policy_id.LAST
                  INSERT INTO gicl_lratio_prev_prem_ext
                              (session_id, assd_no, policy_id, line_cd, subline_cd, iss_cd, peril_cd, intm_no, prem_amt, user_id,
                               date_for_24th
                              )
                       VALUES (p_session_id, p_assd_no, vv_policy_id (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), vv_intm_no (i), vv_prem (i), p_user_id,
                               TO_DATE (vv_date24 (i), 'MM-DD-YYYY')
                              );
               --after insert refresh arrays by deleting data
               vv_policy_id.DELETE;
               vv_prem.DELETE;
               vv_line_cd.DELETE;
               vv_subline_cd.DELETE;
               vv_iss_cd.DELETE;
               vv_intm_no.DELETE;
               vv_date24.DELETE;
               vv_peril_cd.DELETE;
            END IF;
         END;                                                                                                                                         --select all records from gipi_polbasic for record

         --with accounting entry date within the previous year
         BEGIN                                                                                                                                        --select all records from gipi_polbasic for record
            --with spoiled accounting entry date within the previous year
            SELECT   d.policy_id, d.line_cd, d.subline_cd, d.iss_cd, c.peril_cd, c.intrmdry_intm_no, SUM (c.premium_amt * b.currency_rt) prem_amt, TO_CHAR (d.spld_acct_ent_date, 'MM-DD-YYYY')
            BULK COLLECT INTO vv_policy_id, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_peril_cd, vv_intm_no, vv_prem, vv_date24
                FROM gipi_polbasic d,
                     
                     --gipi_comm_inv_peril c, -- Udel 12212011 replaced by the SELECT statement below
                     (SELECT   a.policy_id, a.iss_cd, a.prem_seq_no, a.intrmdry_intm_no, a.peril_cd,
                               DECODE (p_extract_cat, 'G', a.premium_amt, SUM (d.dist_prem) * (b.share_percentage / 100)) premium_amt
                          FROM gipi_comm_inv_peril a, gipi_comm_invoice b, giuw_pol_dist c, giuw_perilds_dtl d
                         WHERE 1 = 1
                           AND a.policy_id = b.policy_id
                           AND a.iss_cd = b.iss_cd
                           AND a.prem_seq_no = b.prem_seq_no
                           AND a.intrmdry_intm_no = b.intrmdry_intm_no
                           AND a.policy_id = c.policy_id
                           AND c.dist_no = d.dist_no
                           AND a.peril_cd = d.peril_cd
                           AND d.share_cd = 1
                      GROUP BY a.policy_id, a.iss_cd, a.prem_seq_no, a.intrmdry_intm_no, a.peril_cd, a.premium_amt, b.share_percentage) c,
                     gipi_invoice b
               WHERE d.policy_id = c.policy_id
                 AND d.line_cd = NVL (p_line_cd, d.line_cd)
                 AND d.subline_cd = NVL (p_subline_cd, d.subline_cd)
                 AND d.iss_cd = NVL (p_iss_cd, d.iss_cd)
                 AND c.peril_cd = NVL (p_peril_cd, peril_cd)
                 --AND TO_CHAR(d.spld_acct_ent_date,'YYYY') = p_prev_year
                 AND (   (p_ext_proc = 'S' AND TO_CHAR (d.spld_acct_ent_date, 'YYYY') = p_prev_year)
                      OR (p_ext_proc = 'M' AND TRUNC (d.spld_acct_ent_date) >= p_prev1_date AND TRUNC (d.spld_acct_ent_date) <= p_prev2_date)
                     )
                 AND d.pol_flag IN ('1', '2', '3', '4', 'X')
                 AND c.intrmdry_intm_no = NVL (p_intm_no, c.intrmdry_intm_no)
                 AND get_latest_assured_no (d.line_cd, d.subline_cd, d.iss_cd, d.issue_yy, d.pol_seq_no, d.renew_no, p_prev1_date, p_prev2_date) = p_assd_no
                 AND c.policy_id = b.policy_id
                 AND c.iss_cd = b.iss_cd
                 AND c.prem_seq_no = b.prem_seq_no
                 AND c.premium_amt <> 0
            GROUP BY d.policy_id, d.line_cd, d.subline_cd, d.iss_cd, c.peril_cd, c.intrmdry_intm_no, TO_CHAR (d.spld_acct_ent_date, 'MM-DD-YYYY');

            --insert record on table gicl_lratio_prev_prem_ext
            IF SQL%FOUND THEN
               p_prev_exists := 'Y';
               FORALL i IN vv_policy_id.FIRST .. vv_policy_id.LAST
                  INSERT INTO gicl_lratio_prev_prem_ext
                              (session_id, assd_no, policy_id, spld_sw, line_cd, subline_cd, iss_cd, peril_cd, intm_no, prem_amt, user_id,
                               date_for_24th
                              )
                       VALUES (p_session_id, p_assd_no, vv_policy_id (i), 'Y', vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), vv_intm_no (i), -vv_prem (i), p_user_id,
                               TO_DATE (vv_date24 (i), 'MM-DD-YYYY')
                              );
            END IF;
         END;                                                                                                                                         --select all records from gipi_polbasic for record

               --with spoiled accounting entry date within the previous year
           -- delete records in table gicl_lratio_prev_prem_ext if accounting entry date
         -- and spoiled accounting entry date is within the previous date parameter
         FOR del_spld IN (SELECT a.policy_id
                            FROM gicl_lratio_prev_prem_ext a, gicl_lratio_prev_prem_ext b
                           WHERE a.session_id = p_session_id AND a.session_id = b.session_id AND a.policy_id = b.policy_id AND NVL (a.spld_sw, 'N') = 'Y' AND NVL (b.spld_sw, 'N') = 'N')
         LOOP
            DELETE      gicl_lratio_prev_prem_ext
                  WHERE policy_id = del_spld.policy_id AND session_id = p_session_id;
         END LOOP;
      END;                                                                                                                                                     -- extract previous year premiums written
   END;

   PROCEDURE lratio_extract_prem_intm_assd (
      p_line_cd             giis_line.line_cd%TYPE,
      p_subline_cd          giis_subline.subline_cd%TYPE,
      p_iss_cd              giis_issource.iss_cd%TYPE,
      p_peril_cd            giis_peril.peril_cd%TYPE,
      p_intm_no             giis_intermediary.intm_no%TYPE,
      p_assd_no             giis_assured.assd_no%TYPE,
      p_session_id          gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param          NUMBER,
      p_issue_param         NUMBER,
      p_curr1_date          gipi_polbasic.issue_date%TYPE,
      p_curr2_date          gipi_polbasic.issue_date%TYPE,
      p_prev1_date          gipi_polbasic.issue_date%TYPE,
      p_prev2_date          gipi_polbasic.issue_date%TYPE,
      p_prev_year           VARCHAR2,
      p_curr_exists   OUT   VARCHAR2,
      p_prev_exists   OUT   VARCHAR2,
      p_ext_proc            VARCHAR2,
      p_extract_cat         VARCHAR2,
      p_user_id             giis_users.user_id%TYPE
   )
   AS
      TYPE policy_id_tab IS TABLE OF gipi_polbasic.policy_id%TYPE;

      TYPE curr_prem_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE peril_cd_tab IS TABLE OF giis_peril.peril_cd%TYPE;

      TYPE line_cd_tab IS TABLE OF giis_line.line_cd%TYPE;

      TYPE subline_cd_tab IS TABLE OF giis_subline.subline_cd%TYPE;

      TYPE iss_cd_tab IS TABLE OF giis_issource.iss_cd%TYPE;

      TYPE intm_no_tab IS TABLE OF giis_intermediary.intm_no%TYPE;

      TYPE date24_tab IS TABLE OF VARCHAR2 (10);

      vv_policy_id    policy_id_tab;
      vv_prem         curr_prem_tab;
      vv_line_cd      line_cd_tab;
      vv_subline_cd   subline_cd_tab;
      vv_iss_cd       iss_cd_tab;
      vv_intm_no      intm_no_tab;
      vv_date24       date24_tab;
      vv_peril_cd     peril_cd_tab;
   BEGIN
      p_curr_exists := 'N';
      p_prev_exists := 'N';

      BEGIN                                                                                                                                                    -- extract current year premiums written
         --delete records in extract table for the current user
         DELETE      gicl_lratio_curr_prem_ext
               WHERE user_id = p_user_id;

         --select all records from gipi_polbasic for record
         --with accounting entry date within the current year
         SELECT   d.policy_id, d.line_cd, d.subline_cd, d.iss_cd, c.peril_cd, c.intrmdry_intm_no, SUM (c.premium_amt * b.currency_rt) prem_amt,
                  TO_CHAR (TRUNC (DECODE (p_date_param, 1, d.issue_date, 2, d.eff_date, 4, LAST_DAY (TO_DATE (UPPER (d.booking_mth) || ' 1,' || TO_CHAR (d.booking_year), 'FMMONTH DD,YYYY')), SYSDATE)),
                           'MM-DD-YYYY'
                          )
         BULK COLLECT INTO vv_policy_id, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_peril_cd, vv_intm_no, vv_prem,
                  vv_date24
             FROM gipi_polbasic d,
                  
                  --gipi_comm_inv_peril c, -- Udel 12212011 replaced by the SELECT statement below
                  (SELECT   a.policy_id, a.iss_cd, a.prem_seq_no, a.intrmdry_intm_no, a.peril_cd, DECODE (p_extract_cat,
                                                                                                          'G', a.premium_amt,
                                                                                                          SUM (d.dist_prem) * (b.share_percentage / 100)
                                                                                                         ) premium_amt
                       FROM gipi_comm_inv_peril a, gipi_comm_invoice b, giuw_pol_dist c, giuw_perilds_dtl d
                      WHERE 1 = 1
                        AND a.policy_id = b.policy_id
                        AND a.iss_cd = b.iss_cd
                        AND a.prem_seq_no = b.prem_seq_no
                        AND a.intrmdry_intm_no = b.intrmdry_intm_no
                        AND a.policy_id = c.policy_id
                        AND c.dist_no = d.dist_no
                        AND a.peril_cd = d.peril_cd
                        AND d.share_cd = 1
                   GROUP BY a.policy_id, a.iss_cd, a.prem_seq_no, a.intrmdry_intm_no, a.peril_cd, a.premium_amt, b.share_percentage) c,
                  gipi_invoice b
            WHERE d.policy_id = c.policy_id
              AND d.line_cd = NVL (p_line_cd, d.line_cd)
              AND d.subline_cd = NVL (p_subline_cd, d.subline_cd)
              AND d.iss_cd = NVL (p_iss_cd, d.iss_cd)
              AND c.peril_cd = NVL (p_peril_cd, c.peril_cd)
              AND get_latest_assured_no (d.line_cd, d.subline_cd, d.iss_cd, d.issue_yy, d.pol_seq_no, d.renew_no, p_curr1_date, p_curr2_date) = p_assd_no
              AND TRUNC (DECODE (p_date_param, 1, d.issue_date, 2, d.eff_date, 4, LAST_DAY (TO_DATE (UPPER (d.booking_mth) || ' 1,' || TO_CHAR (d.booking_year), 'FMMONTH DD,YYYY')), SYSDATE)) >=
                                                                                                                                                                                            p_curr1_date
              AND TRUNC (DECODE (p_date_param, 1, d.issue_date, 2, d.eff_date, 4, LAST_DAY (TO_DATE (UPPER (d.booking_mth) || ' 1,' || TO_CHAR (d.booking_year), 'FMMONTH DD,YYYY')), SYSDATE)) <=
                                                                                                                                                                                            p_curr2_date
              AND d.pol_flag IN ('1', '2', '3', '4', 'X')
              AND c.intrmdry_intm_no = NVL (p_intm_no, c.intrmdry_intm_no)
              AND c.policy_id = b.policy_id
              AND c.iss_cd = b.iss_cd
              AND c.prem_seq_no = b.prem_seq_no
              AND c.premium_amt <> 0
         GROUP BY d.policy_id,
                  d.line_cd,
                  d.subline_cd,
                  d.iss_cd,
                  c.peril_cd,
                  c.intrmdry_intm_no,
                  TO_CHAR (TRUNC (DECODE (p_date_param, 1, d.issue_date, 2, d.eff_date, 4, LAST_DAY (TO_DATE (UPPER (d.booking_mth) || ' 1,' || TO_CHAR (d.booking_year), 'FMMONTH DD,YYYY')), SYSDATE)),
                           'MM-DD-YYYY'
                          );

         --insert record on table gicl_lratio_curr_prem_ext
         IF SQL%FOUND THEN
            p_curr_exists := 'Y';
            FORALL i IN vv_policy_id.FIRST .. vv_policy_id.LAST
               INSERT INTO gicl_lratio_curr_prem_ext
                           (session_id, assd_no, policy_id, line_cd, subline_cd, iss_cd, peril_cd, intm_no, prem_amt, user_id,
                            date_for_24th
                           )
                    VALUES (p_session_id, p_assd_no, vv_policy_id (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), vv_intm_no (i), vv_prem (i), p_user_id,
                            TO_DATE (vv_date24 (i), 'MM-DD-YYYY')
                           );
            --after insert refresh arrays by deleting data
            vv_policy_id.DELETE;
            vv_prem.DELETE;
            vv_line_cd.DELETE;
            vv_subline_cd.DELETE;
            vv_iss_cd.DELETE;
            vv_intm_no.DELETE;
            vv_date24.DELETE;
            vv_peril_cd.DELETE;
         END IF;
      END;                                                                                                                                                      -- extract current year premiums written

      BEGIN                                                                                                                                                    -- extract previous year premiums written
         --delete records in extract table for the current user
         DELETE      gicl_lratio_prev_prem_ext
               WHERE user_id = p_user_id;

         --select all records from gipi_polbasic for record
         --with accounting entry date within the previous year
         SELECT   d.policy_id, d.line_cd, d.subline_cd, d.iss_cd, c.peril_cd, c.intrmdry_intm_no, SUM (c.premium_amt * b.currency_rt) prem_amt,
                  TO_CHAR (TRUNC (DECODE (p_date_param, 1, d.issue_date, 2, d.eff_date, 4, LAST_DAY (TO_DATE (UPPER (d.booking_mth) || ' 1,' || TO_CHAR (d.booking_year), 'FMMONTH DD,YYYY')), SYSDATE)),
                           'MM-DD-YYYY'
                          )
         BULK COLLECT INTO vv_policy_id, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_peril_cd, vv_intm_no, vv_prem,
                  vv_date24
             FROM gipi_polbasic d,
                  
                  --gipi_comm_inv_peril c, -- Udel 12212011 replaced by the SELECT statement below
                  (SELECT   a.policy_id, a.iss_cd, a.prem_seq_no, a.intrmdry_intm_no, a.peril_cd, DECODE (p_extract_cat,
                                                                                                          'G', a.premium_amt,
                                                                                                          SUM (d.dist_prem) * (b.share_percentage / 100)
                                                                                                         ) premium_amt
                       FROM gipi_comm_inv_peril a, gipi_comm_invoice b, giuw_pol_dist c, giuw_perilds_dtl d
                      WHERE 1 = 1
                        AND a.policy_id = b.policy_id
                        AND a.iss_cd = b.iss_cd
                        AND a.prem_seq_no = b.prem_seq_no
                        AND a.intrmdry_intm_no = b.intrmdry_intm_no
                        AND a.policy_id = c.policy_id
                        AND c.dist_no = d.dist_no
                        AND a.peril_cd = d.peril_cd
                        AND d.share_cd = 1
                   GROUP BY a.policy_id, a.iss_cd, a.prem_seq_no, a.intrmdry_intm_no, a.peril_cd, a.premium_amt, b.share_percentage) c,
                  gipi_invoice b
            WHERE d.policy_id = c.policy_id
              AND d.line_cd = NVL (p_line_cd, d.line_cd)
              AND d.subline_cd = NVL (p_subline_cd, d.subline_cd)
              AND d.iss_cd = NVL (p_iss_cd, d.iss_cd)
              AND c.peril_cd = NVL (p_peril_cd, c.peril_cd)
              AND get_latest_assured_no (d.line_cd, d.subline_cd, d.iss_cd, d.issue_yy, d.pol_seq_no, d.renew_no, p_prev1_date, p_prev2_date) = p_assd_no
              --AND DECODE(p_date_param, 1, TO_CHAR(d.issue_date,'YYYY'),
              --                         2, TO_CHAR(d.eff_date,'YYYY'),
              --                         4, TO_CHAR(d.booking_year), TO_CHAR(SYSDATE,'YYYY'))
              --                             = p_prev_year
              AND (   (    p_ext_proc = 'S'
                       AND DECODE (p_date_param, 1, TO_CHAR (d.issue_date, 'YYYY'), 2, TO_CHAR (d.eff_date, 'YYYY'), 4, TO_CHAR (d.booking_year), TO_CHAR (SYSDATE, 'YYYY')) = p_prev_year
                      )
                   OR (    p_ext_proc = 'M'
                       AND TRUNC (DECODE (p_date_param, 1, d.issue_date, 2, d.eff_date, 4, LAST_DAY (TO_DATE (UPPER (d.booking_mth) || ' 1,' || TO_CHAR (d.booking_year), 'FMMONTH DD,YYYY')), SYSDATE)) >=
                                                                                                                                                                                            p_prev1_date
                       AND TRUNC (DECODE (p_date_param, 1, d.issue_date, 2, d.eff_date, 4, LAST_DAY (TO_DATE (UPPER (d.booking_mth) || ' 1,' || TO_CHAR (d.booking_year), 'FMMONTH DD,YYYY')), SYSDATE)) <=
                                                                                                                                                                                            p_prev2_date
                      )
                  )
              AND d.pol_flag IN ('1', '2', '3', '4', 'X')
              AND c.intrmdry_intm_no = NVL (p_intm_no, c.intrmdry_intm_no)
              AND c.policy_id = b.policy_id
              AND c.iss_cd = b.iss_cd
              AND c.prem_seq_no = b.prem_seq_no
              AND c.premium_amt <> 0
         GROUP BY d.policy_id,
                  d.line_cd,
                  d.subline_cd,
                  d.iss_cd,
                  c.peril_cd,
                  c.intrmdry_intm_no,
                  TO_CHAR (TRUNC (DECODE (p_date_param, 1, d.issue_date, 2, d.eff_date, 4, LAST_DAY (TO_DATE (UPPER (d.booking_mth) || ' 1,' || TO_CHAR (d.booking_year), 'FMMONTH DD,YYYY')), SYSDATE)),
                           'MM-DD-YYYY'
                          );

         --insert record on table gicl_lratio_prev_prem_ext
         IF SQL%FOUND THEN
            p_prev_exists := 'Y';
            FORALL i IN vv_policy_id.FIRST .. vv_policy_id.LAST
               INSERT INTO gicl_lratio_prev_prem_ext
                           (session_id, assd_no, policy_id, line_cd, subline_cd, iss_cd, peril_cd, intm_no, prem_amt, user_id,
                            date_for_24th
                           )
                    VALUES (p_session_id, p_assd_no, vv_policy_id (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), vv_intm_no (i), vv_prem (i), p_user_id,
                            TO_DATE (vv_date24 (i), 'MM-DD-YYYY')
                           );
         END IF;
      END;                                                                                                                                                     -- extract previous year premiums written
   END;

   PROCEDURE lratio_extract_loss_paid_intm (
      p_line_cd             giis_line.line_cd%TYPE,
      p_subline_cd          giis_subline.subline_cd%TYPE,
      p_iss_cd              giis_issource.iss_cd%TYPE,
      p_intm_no             giis_intermediary.intm_no%TYPE,
      p_assd_no             giis_assured.assd_no%TYPE,
      p_session_id          gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param          NUMBER,
      p_issue_param         NUMBER,
      p_curr1_date          gipi_polbasic.issue_date%TYPE,
      p_curr2_date          gipi_polbasic.issue_date%TYPE,
      p_exists        OUT   VARCHAR2,
      p_extract_cat         VARCHAR2,
      p_user_id             giis_users.user_id%TYPE
   )
   AS
      TYPE paid_amt_tab IS TABLE OF gicl_clm_res_hist.losses_paid%TYPE;                                                                                                  --gipi_polbasic.prem_amt%TYPE;

      TYPE assd_no_tab IS TABLE OF giis_assured.assd_no%TYPE;

      TYPE claim_id_tab IS TABLE OF gicl_claims.claim_id%TYPE;

      TYPE peril_cd_tab IS TABLE OF giis_peril.peril_cd%TYPE;

      TYPE line_cd_tab IS TABLE OF giis_line.line_cd%TYPE;

      TYPE subline_cd_tab IS TABLE OF giis_subline.subline_cd%TYPE;

      TYPE iss_cd_tab IS TABLE OF giis_issource.iss_cd%TYPE;

      TYPE intm_no_tab IS TABLE OF giis_intermediary.intm_no%TYPE;

      vv_claim_id     claim_id_tab;
      vv_paid_amt     paid_amt_tab;
      vv_assd_no      assd_no_tab;
      vv_peril_cd     peril_cd_tab;
      vv_line_cd      line_cd_tab;
      vv_subline_cd   subline_cd_tab;
      vv_iss_cd       iss_cd_tab;
      vv_intm_no      intm_no_tab;
   BEGIN
      --delete records in extract table gicl_lratio_loss_paid_ext for the current user
      DELETE      gicl_lratio_loss_paid_ext
            WHERE user_id = p_user_id;

      p_exists := 'N';

      --retrieve all paid claim for the current year
      --transactions must not be cancelled
      SELECT   b.claim_id, b.assd_no, b.line_cd, b.subline_cd, b.iss_cd, a.peril_cd, c.intm_no,
                                                                                               --NVL(SUM(NVL(losses_paid,0)+ NVL(expenses_paid,0)),0) loss_paid
                                                                                               a.loss_paid
      BULK COLLECT INTO vv_claim_id, vv_assd_no, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_peril_cd, vv_intm_no, vv_paid_amt
          FROM                                                                                                            --gicl_clm_res_hist a, -- Udel 12222011 replaced by the SELECT statement below
               (SELECT   a.claim_id, a.item_no, a.peril_cd, a.tran_id, a.date_paid, a.cancel_tag,
                         DECODE (p_extract_cat, 'G', NVL (NVL (SUM (a.losses_paid), 0) + NVL (SUM (a.expenses_paid), 0), 0), SUM (c.shr_le_adv_amt)) loss_paid
                    FROM gicl_clm_res_hist a, gicl_clm_loss_exp b, gicl_loss_exp_ds c
                   WHERE 1 = 1
                     AND a.claim_id = b.claim_id
                     AND a.item_no = b.item_no
                     AND a.peril_cd = b.peril_cd
                     AND a.tran_id = b.tran_id
                     AND b.claim_id = c.claim_id
                     AND b.clm_loss_id = c.clm_loss_id
                     AND c.share_type = 1
                     AND c.negate_tag IS NULL
                GROUP BY a.claim_id, a.item_no, a.peril_cd, a.tran_id, a.date_paid, a.cancel_tag) a,
               gicl_claims b,
               gicl_intm_itmperil c
         WHERE 1 = 1
           AND b.line_cd = NVL (p_line_cd, b.line_cd)
           AND b.subline_cd = NVL (p_subline_cd, b.subline_cd)
           AND DECODE (p_issue_param, 1, b.iss_cd, b.pol_iss_cd) = NVL (p_iss_cd, DECODE (p_issue_param, 1, b.iss_cd, b.pol_iss_cd))
           AND b.assd_no = NVL (p_assd_no, b.assd_no)
           AND a.claim_id = b.claim_id
           AND tran_id IS NOT NULL
           AND NVL (cancel_tag, 'N') = 'N'
           AND a.claim_id = c.claim_id
           AND a.item_no = c.item_no
           AND a.peril_cd = c.peril_cd
           AND TRUNC (date_paid) >= p_curr1_date
           AND TRUNC (date_paid) <= p_curr2_date
           AND c.intm_no = NVL (p_intm_no, c.intm_no)
      GROUP BY b.claim_id, b.assd_no, b.line_cd, b.subline_cd, b.iss_cd, a.peril_cd, c.intm_no, a.loss_paid;

      --INSERT RECORD ON TABLE GICL_LRATIO_LOSS_PAID_EXT
      IF SQL%FOUND THEN
         p_exists := 'Y';
         FORALL i IN vv_claim_id.FIRST .. vv_claim_id.LAST
            INSERT INTO gicl_lratio_loss_paid_ext
                        (session_id, assd_no, peril_cd, intm_no, line_cd, subline_cd, iss_cd, claim_id, loss_paid, user_id
                        )
                 VALUES (p_session_id, vv_assd_no (i), vv_peril_cd (i), vv_intm_no (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_claim_id (i), vv_paid_amt (i), p_user_id
                        );
      END IF;
   END;

   PROCEDURE lratio_extract_os_intm (
      p_line_cd             giis_line.line_cd%TYPE,
      p_subline_cd          giis_subline.subline_cd%TYPE,
      p_iss_cd              giis_issource.iss_cd%TYPE,
      p_intm_no             giis_intermediary.intm_no%TYPE,
      p_assd_no             giis_assured.assd_no%TYPE,
      p_session_id          gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param          NUMBER,
      p_issue_param         NUMBER,
      p_curr1_date          gipi_polbasic.issue_date%TYPE,
      p_curr2_date          gipi_polbasic.issue_date%TYPE,
      p_prev1_date          gipi_polbasic.issue_date%TYPE,
      p_prev2_date          gipi_polbasic.issue_date%TYPE,
      p_curr_exists   OUT   VARCHAR2,
      p_prev_exists   OUT   VARCHAR2,
      p_extract_cat         VARCHAR2,
      p_user_id             giis_users.user_id%TYPE
   )
   AS
      TYPE os_amt_tab IS TABLE OF gicl_clm_res_hist.losses_paid%TYPE;                                                                                                    --gipi_polbasic.prem_amt%TYPE;

      TYPE assd_no_tab IS TABLE OF giis_assured.assd_no%TYPE;

      TYPE claim_id_tab IS TABLE OF gicl_claims.claim_id%TYPE;

      TYPE peril_cd_tab IS TABLE OF giis_peril.peril_cd%TYPE;

      TYPE line_cd_tab IS TABLE OF giis_line.line_cd%TYPE;

      TYPE subline_cd_tab IS TABLE OF giis_subline.subline_cd%TYPE;

      TYPE iss_cd_tab IS TABLE OF giis_issource.iss_cd%TYPE;

      TYPE intm_no_tab IS TABLE OF giis_intermediary.intm_no%TYPE;

      vv_claim_id     claim_id_tab;
      vv_os           os_amt_tab;
      vv_assd_no      assd_no_tab;
      vv_peril_cd     peril_cd_tab;
      vv_line_cd      line_cd_tab;
      vv_subline_cd   subline_cd_tab;
      vv_iss_cd       iss_cd_tab;
      vv_intm_no      intm_no_tab;
   BEGIN                                                                                                                                                                                          --main
      p_curr_exists := 'N';
      p_prev_exists := 'N';

      BEGIN                                                                                                                                                          --extract current outstanding loss
         --delete records in extract table gicl_lratio_curr_os_ext for the current user
         DELETE      gicl_lratio_curr_os_ext
               WHERE user_id = p_user_id;

         BEGIN                                                                                                                    --retrieve all records with outstanding loss reserve for current year
            --all records with loss payment less than the loss reserve will be retrived
            SELECT   d.claim_id, d.assd_no, a.peril_cd, d.line_cd, d.subline_cd, d.iss_cd, e.intm_no,
                     SUM (((NVL (a.loss_reserve, 0) * NVL (a.convert_rate, 1)) - NVL (c.losses_paid, 0)) * (e.shr_intm_pct / 100)) loss
            BULK COLLECT INTO vv_claim_id, vv_assd_no, vv_peril_cd, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_intm_no,
                     vv_os
                FROM                                                                                                       --gicl_clm_res_hist a,-- Udel 12222011 replaced by the SELECT statement below
                     (SELECT   aa.claim_id, aa.clm_res_hist_id, aa.item_no, aa.peril_cd, DECODE (p_extract_cat, 'G', aa.loss_reserve, SUM (bb.shr_loss_res_amt)) loss_reserve, aa.convert_rate
                          FROM gicl_clm_res_hist aa, gicl_reserve_ds bb
                         WHERE aa.claim_id = bb.claim_id AND aa.clm_res_hist_id = bb.clm_res_hist_id AND bb.share_type = 1
                      GROUP BY aa.claim_id, aa.clm_res_hist_id, aa.item_no, aa.peril_cd, aa.convert_rate, aa.loss_reserve) a,
                     (SELECT b1.claim_id, b1.clm_res_hist_id, b1.item_no, b1.peril_cd
                        FROM gicl_clm_res_hist b1, gicl_item_peril b2
                       WHERE tran_id IS NULL
                         AND b2.claim_id = b1.claim_id
                         AND b2.item_no = b1.item_no
                         AND b2.peril_cd = b1.peril_cd
                         AND TRUNC (NVL (b2.close_date, p_curr2_date + 365)) > TRUNC (p_curr2_date)) b,
                     
--             (SELECT claim_id, item_no, peril_cd,
--                     SUM(losses_paid) losses_paid
--                FROM gicl_clm_res_hist
--                WHERE 1 = 1
--                  AND tran_id IS NOT NULL
--                  AND NVL(cancel_tag,'N') = 'N'
--                  AND TRUNC(date_paid) <= TRUNC(p_curr2_date)
--             GROUP BY claim_id, item_no, peril_cd ) c, -- Udel 12222011 replaced by the SELECT statement below
                     (SELECT   aa.claim_id, aa.item_no, aa.peril_cd, DECODE (p_extract_cat, 'G', SUM (aa.losses_paid), SUM (bb.shr_le_adv_amt)) losses_paid
                          FROM gicl_clm_res_hist aa, gicl_clm_loss_exp cc, gicl_loss_exp_ds bb
                         WHERE 1 = 1
                           AND aa.claim_id = cc.claim_id
                           AND aa.advice_id = cc.advice_id
                           AND bb.claim_id = cc.claim_id
                           AND bb.clm_loss_id = cc.clm_loss_id
                           AND cc.payee_type = 'L'
                           AND aa.tran_id IS NOT NULL
                           AND bb.share_type = 1
                           AND NVL (aa.cancel_tag, 'N') = 'N'
                           AND TRUNC (date_paid) <= TRUNC (p_curr2_date)
                      GROUP BY aa.claim_id, aa.item_no, aa.peril_cd) c,
                     gicl_claims d,
                     gicl_intm_itmperil e
               WHERE 1 = 1
                 AND d.line_cd = NVL (p_line_cd, d.line_cd)
                 AND d.subline_cd = NVL (p_subline_cd, d.subline_cd)
                 AND d.assd_no = NVL (p_assd_no, d.assd_no)
                 AND DECODE (p_issue_param, 1, d.iss_cd, d.pol_iss_cd) = NVL (p_iss_cd, DECODE (p_issue_param, 1, d.iss_cd, d.pol_iss_cd))
                 AND a.claim_id = d.claim_id
                 AND a.claim_id = b.claim_id
                 AND a.clm_res_hist_id = b.clm_res_hist_id
                 AND b.claim_id = c.claim_id(+)
                 AND b.item_no = c.item_no(+)
                 AND b.peril_cd = c.peril_cd(+)
                 AND d.claim_id = e.claim_id
                 AND b.item_no = e.item_no
                 AND b.peril_cd = e.peril_cd
                 AND e.intm_no = NVL (p_intm_no, e.intm_no)
                 AND NVL (a.loss_reserve, 0) > NVL (c.losses_paid, 0)
                 AND a.clm_res_hist_id =
                        (SELECT MAX (a2.clm_res_hist_id)
                           FROM gicl_clm_res_hist a2
                          WHERE a2.claim_id = a.claim_id
                            AND a2.item_no = a.item_no
                            AND a2.peril_cd = a.peril_cd
                            AND TO_DATE (NVL (a2.booking_month, TO_CHAR (d.clm_file_date, 'FMMONTH')) || ' 01, ' || TO_CHAR (NVL (a2.booking_year, TO_CHAR (d.clm_file_date, 'YYYY'))),
                                         'FMMONTH DD, YYYY'
                                        ) <= TRUNC (p_curr2_date)
                            AND tran_id IS NULL)
            --AND TRUNC(NVL(close_date, p_curr2_date +365)) > p_curr2_date
            GROUP BY d.claim_id, d.assd_no, a.peril_cd, d.line_cd, d.subline_cd, d.iss_cd, e.intm_no;

            --insert record on table gicl_lratio_curr_os_ext
            IF SQL%FOUND THEN
               p_curr_exists := 'Y';
               FORALL i IN vv_claim_id.FIRST .. vv_claim_id.LAST
                  INSERT INTO gicl_lratio_curr_os_ext
                              (session_id, assd_no, claim_id, intm_no, line_cd, subline_cd, iss_cd, peril_cd, os_amt, user_id
                              )
                       VALUES (p_session_id, vv_assd_no (i), vv_claim_id (i), vv_intm_no (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), vv_os (i), p_user_id
                              );
               --after insert refresh arrays by deleting data
               vv_claim_id.DELETE;
               vv_assd_no.DELETE;
               vv_peril_cd.DELETE;
               vv_os.DELETE;
               vv_line_cd.DELETE;
               vv_subline_cd.DELETE;
               vv_iss_cd.DELETE;
               vv_intm_no.DELETE;
            END IF;
         END;                                                                                                                      --retrieve all records with outstanding loss reserve for current year

         BEGIN                                                                                                                  --retrieve all records with outstanding expense reserve for current year
            --all records with expense payment less than the expense reserve will be retrived
            SELECT   d.claim_id, d.assd_no, a.peril_cd, d.line_cd, d.subline_cd, d.iss_cd, e.intm_no,
                     SUM (((NVL (a.expense_reserve, 0) * NVL (a.convert_rate, 1)) - NVL (c.exp_paid, 0)) * (e.shr_intm_pct / 100)) loss
            BULK COLLECT INTO vv_claim_id, vv_assd_no, vv_peril_cd, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_intm_no,
                     vv_os
                FROM                                                                                                      --gicl_clm_res_hist a, -- Udel 12222011 replaced by the SELECT statement below
                     (SELECT   aa.claim_id, aa.clm_res_hist_id, aa.item_no, aa.peril_cd, DECODE (p_extract_cat, 'G', aa.expense_reserve, SUM (bb.shr_exp_res_amt)) expense_reserve, aa.convert_rate
                          FROM gicl_clm_res_hist aa, gicl_reserve_ds bb
                         WHERE aa.claim_id = bb.claim_id AND aa.clm_res_hist_id = bb.clm_res_hist_id AND bb.share_type = 1
                      GROUP BY aa.claim_id, aa.clm_res_hist_id, aa.item_no, aa.peril_cd, aa.convert_rate, aa.expense_reserve) a,
                     (SELECT b1.claim_id, b1.clm_res_hist_id, b1.item_no, b1.peril_cd
                        FROM gicl_clm_res_hist b1, gicl_item_peril b2
                       WHERE tran_id IS NULL
                         AND b2.claim_id = b1.claim_id
                         AND b2.item_no = b1.item_no
                         AND b2.peril_cd = b1.peril_cd
                         AND TRUNC (NVL (b2.close_date2, p_curr2_date + 365)) > TRUNC (p_curr2_date)) b,
                     
--             (SELECT claim_id, item_no, peril_cd,
--                     SUM(losses_paid) losses_paid,
--                     SUM(expenses_paid) exp_paid
--                FROM gicl_clm_res_hist
--                WHERE 1 = 1
--                  AND tran_id IS NOT NULL
--                  AND NVL(cancel_tag,'N') = 'N'
--                  AND TRUNC(date_paid) <= TRUNC(p_curr2_date)
--             GROUP BY claim_id, item_no, peril_cd ) c, -- Udel 12222011 replaced by the SELECT statement below
                     (SELECT   aa.claim_id, aa.item_no, aa.peril_cd, DECODE (p_extract_cat, 'G', SUM (aa.expenses_paid), SUM (bb.shr_le_adv_amt)) exp_paid
                          FROM gicl_clm_res_hist aa, gicl_clm_loss_exp cc, gicl_loss_exp_ds bb
                         WHERE 1 = 1
                           AND aa.claim_id = cc.claim_id
                           AND aa.advice_id = cc.advice_id
                           AND bb.claim_id = cc.claim_id
                           AND bb.clm_loss_id = cc.clm_loss_id
                           AND cc.payee_type = 'E'
                           AND aa.tran_id IS NOT NULL
                           AND bb.share_type = 1
                           AND NVL (aa.cancel_tag, 'N') = 'N'
                           AND TRUNC (date_paid) <= TRUNC (p_curr2_date)
                      GROUP BY aa.claim_id, aa.item_no, aa.peril_cd) c,
                     gicl_claims d,
                     gicl_intm_itmperil e
               WHERE 1 = 1
                 AND d.line_cd = NVL (p_line_cd, d.line_cd)
                 AND d.subline_cd = NVL (p_subline_cd, d.subline_cd)
                 AND DECODE (p_issue_param, 1, d.iss_cd, d.pol_iss_cd) = NVL (p_iss_cd, DECODE (p_issue_param, 1, d.iss_cd, d.pol_iss_cd))
                 AND d.assd_no = NVL (p_assd_no, d.assd_no)
                 AND a.claim_id = d.claim_id
                 AND a.claim_id = b.claim_id
                 AND a.clm_res_hist_id = b.clm_res_hist_id
                 AND b.claim_id = c.claim_id(+)
                 AND b.item_no = c.item_no(+)
                 AND b.peril_cd = c.peril_cd(+)
                 AND d.claim_id = e.claim_id
                 AND b.item_no = e.item_no
                 AND b.peril_cd = e.peril_cd
                 AND e.intm_no = NVL (p_intm_no, e.intm_no)
                 AND NVL (a.expense_reserve, 0) > NVL (c.exp_paid, 0)
                 AND a.clm_res_hist_id =
                        (SELECT MAX (a2.clm_res_hist_id)
                           FROM gicl_clm_res_hist a2
                          WHERE a2.claim_id = a.claim_id
                            AND a2.item_no = a.item_no
                            AND a2.peril_cd = a.peril_cd
                            AND TO_DATE (NVL (a2.booking_month, TO_CHAR (d.clm_file_date, 'FMMONTH')) || ' 01, ' || TO_CHAR (NVL (a2.booking_year, TO_CHAR (d.clm_file_date, 'YYYY'))),
                                         'FMMONTH DD, YYYY'
                                        ) <= TRUNC (p_curr2_date)
                            AND tran_id IS NULL)
            --AND TRUNC(NVL(close_date, p_curr2_date +365)) > p_curr2_date
            GROUP BY d.claim_id, d.assd_no, a.peril_cd, d.line_cd, d.subline_cd, d.iss_cd, e.intm_no;

            --insert record on table gicl_lratio_curr_os_ext
            IF SQL%FOUND THEN
               p_curr_exists := 'Y';
               FORALL i IN vv_claim_id.FIRST .. vv_claim_id.LAST
                  INSERT INTO gicl_lratio_curr_os_ext
                              (session_id, assd_no, claim_id, intm_no, line_cd, subline_cd, iss_cd, peril_cd, os_amt, user_id
                              )
                       VALUES (p_session_id, vv_assd_no (i), vv_claim_id (i), vv_intm_no (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), vv_os (i), p_user_id
                              );
               --after insert refresh arrays by deleting data
               vv_claim_id.DELETE;
               vv_assd_no.DELETE;
               vv_peril_cd.DELETE;
               vv_os.DELETE;
               vv_line_cd.DELETE;
               vv_subline_cd.DELETE;
               vv_iss_cd.DELETE;
               vv_intm_no.DELETE;
            END IF;
         END;                                                                                                                   --retrieve all records with outstanding expense reserve for current year
      END;                                                                                                                                                            --extract current outstanding loss

      BEGIN                                                                                                                                                          --extract previous outstanding loss
         --delete records in extract table gicl_lratio_prev_os_ext for the current user
         DELETE      gicl_lratio_prev_os_ext
               WHERE user_id = p_user_id;

         BEGIN                                                                                                                   --retrieve all records with outstanding loss reserve for previous year
            --all records with loss payment less than the loss reserve will be retrived
            SELECT   d.claim_id, d.assd_no, a.peril_cd, d.line_cd, d.subline_cd, d.iss_cd, e.intm_no,
                     SUM (((NVL (a.loss_reserve, 0) * NVL (a.convert_rate, 1)) - NVL (c.losses_paid, 0)) * (e.shr_intm_pct / 100)) loss
            BULK COLLECT INTO vv_claim_id, vv_assd_no, vv_peril_cd, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_intm_no,
                     vv_os
                FROM                                                                                                      --gicl_clm_res_hist a, -- Udel 12222011 replaced by the SELECT statement below
                     (SELECT   aa.claim_id, aa.clm_res_hist_id, aa.item_no, aa.peril_cd, DECODE (p_extract_cat, 'G', aa.loss_reserve, SUM (bb.shr_loss_res_amt)) loss_reserve, aa.convert_rate
                          FROM gicl_clm_res_hist aa, gicl_reserve_ds bb
                         WHERE aa.claim_id = bb.claim_id AND aa.clm_res_hist_id = bb.clm_res_hist_id AND bb.share_type = 1
                      GROUP BY aa.claim_id, aa.clm_res_hist_id, aa.item_no, aa.peril_cd, aa.convert_rate, aa.loss_reserve) a,
                     (SELECT b1.claim_id, b1.clm_res_hist_id, b1.item_no, b1.peril_cd
                        FROM gicl_clm_res_hist b1, gicl_item_peril b2
                       WHERE tran_id IS NULL
                         AND b2.claim_id = b1.claim_id
                         AND b2.item_no = b1.item_no
                         AND b2.peril_cd = b1.peril_cd
                         AND TRUNC (NVL (b2.close_date, p_curr2_date + 365)) > TRUNC (p_prev2_date)) b,
                     
                 /*AND TO_CHAR(NVL(b2.close_date, p_curr2_date + 365),'YYYY')
                     > p_prev_year) b,*/
--             (SELECT claim_id, item_no, peril_cd,
--                     SUM(losses_paid) losses_paid,
--                     SUM(expenses_paid) exp_paid
--                FROM gicl_clm_res_hist
--               WHERE 1 = 1
--                 AND tran_id IS NOT NULL
--                 AND NVL(cancel_tag,'N') = 'N'
--                 AND TRUNC(date_paid) <= TRUNC(p_prev2_date)
--              GROUP BY claim_id, item_no, peril_cd ) c, -- Udel 12222011 replaced by the SELECT statement below
                     (SELECT   aa.claim_id, aa.item_no, aa.peril_cd, DECODE (p_extract_cat, 'G', SUM (aa.losses_paid), SUM (bb.shr_le_adv_amt)) losses_paid
                          FROM gicl_clm_res_hist aa, gicl_clm_loss_exp cc, gicl_loss_exp_ds bb
                         WHERE 1 = 1
                           AND aa.claim_id = cc.claim_id
                           AND aa.advice_id = cc.advice_id
                           AND bb.claim_id = cc.claim_id
                           AND bb.clm_loss_id = cc.clm_loss_id
                           AND cc.payee_type = 'L'
                           AND aa.tran_id IS NOT NULL
                           AND bb.share_type = 1
                           AND NVL (aa.cancel_tag, 'N') = 'N'
                           AND TRUNC (date_paid) <= p_prev2_date
                      GROUP BY aa.claim_id, aa.item_no, aa.peril_cd) c,
                     gicl_claims d,
                     gicl_intm_itmperil e
               WHERE 1 = 1
                 AND d.line_cd <> 'RI'
                 AND d.line_cd = NVL (p_line_cd, d.line_cd)
                 AND d.subline_cd = NVL (p_subline_cd, d.subline_cd)
                 AND DECODE (p_issue_param, 1, d.iss_cd, d.pol_iss_cd) = NVL (p_iss_cd, DECODE (p_issue_param, 1, d.iss_cd, d.pol_iss_cd))
                 AND d.assd_no = NVL (p_assd_no, d.assd_no)
                 AND a.claim_id = d.claim_id
                 AND a.claim_id = b.claim_id
                 AND a.clm_res_hist_id = b.clm_res_hist_id
                 AND b.claim_id = c.claim_id(+)
                 AND b.item_no = c.item_no(+)
                 AND b.peril_cd = c.peril_cd(+)
                 AND d.claim_id = e.claim_id
                 AND b.item_no = e.item_no
                 AND b.peril_cd = e.peril_cd
                 AND e.intm_no = NVL (p_intm_no, e.intm_no)
                 AND NVL (a.loss_reserve, 0) > NVL (c.losses_paid, 0)
                 AND a.clm_res_hist_id =
                        (SELECT MAX (a2.clm_res_hist_id)
                           FROM gicl_clm_res_hist a2
                          WHERE a2.claim_id = a.claim_id
                            AND a2.item_no = a.item_no
                            AND a2.peril_cd = a.peril_cd
                            /*AND NVL(a2.booking_year,TO_NUMBER(TO_CHAR(d.clm_file_date,'YYYY')))
                                <= TO_NUMBER(p_prev_year)*/
                            AND TO_DATE (NVL (a2.booking_month, TO_CHAR (d.clm_file_date, 'FMMONTH')) || ' 01, ' || TO_CHAR (NVL (a2.booking_year, TO_CHAR (d.clm_file_date, 'YYYY'))),
                                         'FMMONTH DD, YYYY'
                                        ) <= TRUNC (p_prev2_date)
                            AND tran_id IS NULL)
            /*AND TO_CHAR(NVL(d.close_date, p_curr2_date + 365),'YYYY')
                > p_prev_year*/
            --AND TRUNC(NVL(close_date, p_curr2_date +365)) > p_prev2_date
            GROUP BY d.claim_id, d.assd_no, a.peril_cd, d.line_cd, d.subline_cd, d.iss_cd, e.intm_no;

            --insert record on table gicl_lratio_prev_os_ext
            IF SQL%FOUND THEN
               p_prev_exists := 'Y';
               FORALL i IN vv_claim_id.FIRST .. vv_claim_id.LAST
                  INSERT INTO gicl_lratio_prev_os_ext
                              (session_id, assd_no, claim_id, intm_no, line_cd, subline_cd, iss_cd, peril_cd, os_amt, user_id
                              )
                       VALUES (p_session_id, vv_assd_no (i), vv_claim_id (i), vv_intm_no (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), vv_os (i), p_user_id
                              );
               --after insert refresh arrays by deleting data
               vv_claim_id.DELETE;
               vv_assd_no.DELETE;
               vv_peril_cd.DELETE;
               vv_os.DELETE;
               vv_line_cd.DELETE;
               vv_subline_cd.DELETE;
               vv_iss_cd.DELETE;
               vv_intm_no.DELETE;
            END IF;
         END;                                                                                                                     --retrieve all records with outstanding loss reserve for previous year

         BEGIN                                                                                                                 --retrieve all records with outstanding expense reserve for previous year
            --all records with expense payment less than the expense reserve will be retrived
            SELECT   d.claim_id, d.assd_no, a.peril_cd, d.line_cd, d.subline_cd, d.iss_cd, e.intm_no,
                     SUM (((NVL (a.expense_reserve, 0) * NVL (a.convert_rate, 1)) - NVL (c.exp_paid, 0)) * (e.shr_intm_pct / 100)) loss
            BULK COLLECT INTO vv_claim_id, vv_assd_no, vv_peril_cd, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_intm_no,
                     vv_os
                FROM                                                                                                      --gicl_clm_res_hist a, -- Udel 12222011 replaced by the SELECT statement below
                     (SELECT   aa.claim_id, aa.clm_res_hist_id, aa.item_no, aa.peril_cd, DECODE (p_extract_cat, 'G', aa.expense_reserve, SUM (bb.shr_exp_res_amt)) expense_reserve, aa.convert_rate
                          FROM gicl_clm_res_hist aa, gicl_reserve_ds bb
                         WHERE aa.claim_id = bb.claim_id AND aa.clm_res_hist_id = bb.clm_res_hist_id AND bb.share_type = 1
                      GROUP BY aa.claim_id, aa.clm_res_hist_id, aa.item_no, aa.peril_cd, aa.convert_rate, aa.expense_reserve) a,
                     (SELECT b1.claim_id, b1.clm_res_hist_id, b1.item_no, b1.peril_cd
                        FROM gicl_clm_res_hist b1, gicl_item_peril b2
                       WHERE tran_id IS NULL
                         AND b2.claim_id = b1.claim_id
                         AND b2.item_no = b1.item_no
                         AND b2.peril_cd = b1.peril_cd
                         AND TRUNC (NVL (b2.close_date2, p_curr2_date + 365)) > TRUNC (p_prev2_date)) b,
                     
                   /*AND TO_CHAR(NVL(b2.close_date, p_curr2_date + 365),'YYYY')
                       > p_prev_year) b,*/
--                   (SELECT claim_id, item_no, peril_cd,
--                           SUM(losses_paid) losses_paid,
--                           SUM(expenses_paid) exp_paid
--                      FROM gicl_clm_res_hist
--                     WHERE 1 = 1
--                       AND tran_id IS NOT NULL
--                       AND NVL(cancel_tag,'N') = 'N'
--                       AND TRUNC(date_paid) <= TRUNC(p_prev2_date)
--                   GROUP BY claim_id, item_no, peril_cd ) c, -- Udel 12222011 replaced by the SELECT statement below
                     (SELECT   aa.claim_id, aa.item_no, aa.peril_cd, DECODE (p_extract_cat, 'G', SUM (aa.expenses_paid), SUM (bb.shr_le_adv_amt)) exp_paid
                          FROM gicl_clm_res_hist aa, gicl_clm_loss_exp cc, gicl_loss_exp_ds bb
                         WHERE 1 = 1
                           AND aa.claim_id = cc.claim_id
                           AND aa.advice_id = cc.advice_id
                           AND bb.claim_id = cc.claim_id
                           AND bb.clm_loss_id = cc.clm_loss_id
                           AND cc.payee_type = 'E'
                           AND aa.tran_id IS NOT NULL
                           AND bb.share_type = 1
                           AND NVL (aa.cancel_tag, 'N') = 'N'
                           AND TRUNC (date_paid) <= p_prev2_date
                      GROUP BY aa.claim_id, aa.item_no, aa.peril_cd) c,
                     gicl_claims d,
                     gicl_intm_itmperil e
               WHERE 1 = 1
                 AND d.line_cd = NVL (p_line_cd, d.line_cd)
                 AND d.subline_cd = NVL (p_subline_cd, d.subline_cd)
                 AND DECODE (p_issue_param, 1, d.iss_cd, d.pol_iss_cd) = NVL (p_iss_cd, DECODE (p_issue_param, 1, d.iss_cd, d.pol_iss_cd))
                 AND d.assd_no = NVL (p_assd_no, d.assd_no)
                 AND a.claim_id = d.claim_id
                 AND a.claim_id = b.claim_id
                 AND a.clm_res_hist_id = b.clm_res_hist_id
                 AND b.claim_id = c.claim_id(+)
                 AND b.item_no = c.item_no(+)
                 AND b.peril_cd = c.peril_cd(+)
                 AND d.claim_id = e.claim_id
                 AND b.item_no = e.item_no
                 AND b.peril_cd = e.peril_cd
                 AND e.intm_no = NVL (p_intm_no, e.intm_no)
                 AND NVL (a.expense_reserve, 0) > NVL (c.exp_paid, 0)
                 AND a.clm_res_hist_id =
                        (SELECT MAX (a2.clm_res_hist_id)
                           FROM gicl_clm_res_hist a2
                          WHERE a2.claim_id = a.claim_id
                            AND a2.item_no = a.item_no
                            AND a2.peril_cd = a.peril_cd
                            /*AND NVL(a2.booking_year,TO_NUMBER(TO_CHAR(d.clm_file_date,'YYYY')))
                                <= TO_NUMBER(p_prev_year)*/
                            AND TO_DATE (NVL (a2.booking_month, TO_CHAR (d.clm_file_date, 'FMMONTH')) || ' 01, ' || TO_CHAR (NVL (a2.booking_year, TO_CHAR (d.clm_file_date, 'YYYY'))),
                                         'FMMONTH DD, YYYY'
                                        ) <= TRUNC (p_prev2_date)
                            AND tran_id IS NULL)
/*               AND TO_CHAR(NVL(d.close_date, p_curr2_date + 365),'YYYY')
                       > p_prev_year*/--AND TRUNC(NVL(close_date2, p_curr2_date +365)) > p_prev2_date
            GROUP BY d.claim_id, d.assd_no, a.peril_cd, d.line_cd, d.subline_cd, d.iss_cd, e.intm_no;

            --insert record on table gicl_lratio_prev_os_ext
            IF SQL%FOUND THEN
               p_prev_exists := 'Y';
               FORALL i IN vv_claim_id.FIRST .. vv_claim_id.LAST
                  INSERT INTO gicl_lratio_prev_os_ext
                              (session_id, assd_no, claim_id, intm_no, line_cd, subline_cd, iss_cd, peril_cd, os_amt, user_id
                              )
                       VALUES (p_session_id, vv_assd_no (i), vv_claim_id (i), vv_intm_no (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), vv_os (i), p_user_id
                              );
            END IF;
         END;                                                                                                                  --retrieve all records with outstanding expense reserve for previous year
      END;                                                                                                                                                           --extract previous outstanding loss
   END;

   PROCEDURE lratio_extract_recovery_intm (
      p_line_cd             giis_line.line_cd%TYPE,
      p_subline_cd          giis_subline.subline_cd%TYPE,
      p_iss_cd              giis_issource.iss_cd%TYPE,
      p_peril_cd            giis_peril.peril_cd%TYPE,
      p_intm_no             giis_intermediary.intm_no%TYPE,
      p_assd_no             giis_assured.assd_no%TYPE,
      p_session_id          gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param          NUMBER,
      p_issue_param         NUMBER,
      p_curr1_date          gipi_polbasic.issue_date%TYPE,
      p_curr2_date          gipi_polbasic.issue_date%TYPE,
      p_prev1_date          gipi_polbasic.issue_date%TYPE,
      p_prev2_date          gipi_polbasic.issue_date%TYPE,
      p_curr_exists   OUT   VARCHAR2,
      p_prev_exists   OUT   VARCHAR2,
      p_extract_cat         VARCHAR2,
      p_user_id             giis_users.user_id%TYPE
   )
   AS
      TYPE rec_amt_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE assd_no_tab IS TABLE OF giis_assured.assd_no%TYPE;

      TYPE intm_no_tab IS TABLE OF giis_intermediary.intm_no%TYPE;

      TYPE rec_id_tab IS TABLE OF gicl_clm_recovery.recovery_id%TYPE;

      TYPE line_cd_tab IS TABLE OF giis_line.line_cd%TYPE;

      TYPE subline_cd_tab IS TABLE OF giis_subline.subline_cd%TYPE;

      TYPE iss_cd_tab IS TABLE OF giis_issource.iss_cd%TYPE;

      TYPE peril_cd_tab IS TABLE OF giis_peril.peril_cd%TYPE;

      vv_rec_id       rec_id_tab;
      vv_rec_amt      rec_amt_tab;
      vv_assd_no      assd_no_tab;
      vv_line_cd      line_cd_tab;
      vv_subline_cd   subline_cd_tab;
      vv_iss_cd       iss_cd_tab;
      vv_intm_no      intm_no_tab;
      vv_peril_cd     peril_cd_tab;
   BEGIN                                                                                                                                                                                          --main
      p_curr_exists := 'N';
      p_prev_exists := 'N';

      BEGIN                                                                                                                                                     --extract previous year recovery amount
         --delete records in extract table gicl_lratio_prev_recovery_ext for the current user
         DELETE      gicl_lratio_prev_recovery_ext
               WHERE user_id = p_user_id;

         --retrieved all valid recovery record for previous year
         SELECT   b.assd_no, a.recovery_id, line_cd, subline_cd, iss_cd, d.peril_cd, c.intm_no,
                  SUM (NVL (recovered_amt, 0) * (NVL (d.recoverable_amt, 0) / get_rec_amt (d.recovery_id)) * (NVL (c.premium_amt, 0) / get_intm_prem (c.claim_id))) recovered_amt
         BULK COLLECT INTO vv_assd_no, vv_rec_id, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_peril_cd, vv_intm_no,
                  vv_rec_amt
             FROM                                                                                                        --gicl_recovery_payt a, -- Udel 12222011 replaced by the SELECT statement below
                  (SELECT aa.claim_id, aa.recovery_id, aa.tran_date, aa.cancel_tag,
                          DECODE (p_extract_cat, 'G', aa.recovered_amt, DECODE (aa.dist_sw, 'Y', bb.shr_recovery_amt, aa.recovered_amt)) recovered_amt
                     FROM gicl_recovery_payt aa, gicl_recovery_ds bb
                    WHERE 1 = 1 AND aa.recovery_id = bb.recovery_id(+) AND aa.recovery_payt_id = bb.recovery_payt_id(+) AND bb.share_type(+) = 1 AND NVL (bb.negate_tag, 'N') = 'N') a,
                  gicl_claims b,
                  gicl_intm_itmperil c,
                  gicl_clm_recovery_dtl d
            WHERE 1 = 1
              AND b.line_cd = NVL (p_line_cd, b.line_cd)
              AND b.subline_cd = NVL (p_subline_cd, b.subline_cd)
              AND DECODE (p_issue_param, 1, b.iss_cd, b.pol_iss_cd) = NVL (p_iss_cd, DECODE (p_issue_param, 1, b.iss_cd, b.pol_iss_cd))
              AND b.assd_no = NVL (p_assd_no, b.assd_no)
              AND d.peril_cd = NVL (p_peril_cd, d.peril_cd)
              AND a.claim_id = b.claim_id
              AND b.claim_id = c.claim_id
              AND a.recovery_id = d.recovery_id
              AND c.claim_id = d.claim_id
              AND c.intm_no = NVL (p_intm_no, c.intm_no)
              AND NVL (cancel_tag, 'N') = 'N'
--       AND TO_NUMBER(TO_CHAR(TRUNC(tran_date), 'YYYY'))<= TO_NUMBER(p_prev_year)
              AND TRUNC (tran_date) >= p_prev1_date
              AND TRUNC (tran_date) <= p_prev2_date
         GROUP BY b.assd_no, a.recovery_id, line_cd, subline_cd, iss_cd, d.peril_cd, c.intm_no;

         --insert record in table gicl_lratio_prev_recovery_ext
         IF SQL%FOUND THEN
            p_prev_exists := 'Y';
            FORALL i IN vv_rec_id.FIRST .. vv_rec_id.LAST
               INSERT INTO gicl_lratio_prev_recovery_ext
                           (session_id, recovery_id, assd_no, line_cd, subline_cd, iss_cd, peril_cd, recovered_amt, intm_no, user_id
                           )
                    VALUES (p_session_id, vv_rec_id (i), vv_assd_no (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), vv_rec_amt (i), vv_intm_no (i), p_user_id
                           );
            --after insert refresh arrays by deleting data
            vv_rec_id.DELETE;
            vv_assd_no.DELETE;
            vv_intm_no.DELETE;
            vv_rec_amt.DELETE;
            vv_line_cd.DELETE;
            vv_subline_cd.DELETE;
            vv_iss_cd.DELETE;
            vv_peril_cd.DELETE;
         END IF;
      END;

      BEGIN
         --delete records in extract table gicl_lratio_curr_recovery_ext for the current user
         DELETE      gicl_lratio_curr_recovery_ext
               WHERE user_id = p_user_id;

         --retrieved all valid recovery record for current year
         SELECT   b.assd_no, a.recovery_id, line_cd, subline_cd, iss_cd, d.peril_cd, c.intm_no,
                  SUM (NVL (recovered_amt, 0) * (NVL (d.recoverable_amt, 0) / get_rec_amt (d.recovery_id)) * (NVL (c.premium_amt, 0) / get_intm_prem (c.claim_id))) recovered_amt
         BULK COLLECT INTO vv_assd_no, vv_rec_id, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_peril_cd, vv_intm_no,
                  vv_rec_amt
             FROM                                                                                                        --gicl_recovery_payt a, -- Udel 12222011 replaced by the SELECT statement below
                  (SELECT aa.claim_id, aa.recovery_id, aa.tran_date, aa.cancel_tag,
                          DECODE (p_extract_cat, 'G', aa.recovered_amt, DECODE (aa.dist_sw, 'Y', bb.shr_recovery_amt, aa.recovered_amt)) recovered_amt
                     FROM gicl_recovery_payt aa, gicl_recovery_ds bb
                    WHERE 1 = 1 AND aa.recovery_id = bb.recovery_id(+) AND aa.recovery_payt_id = bb.recovery_payt_id(+) AND bb.share_type(+) = 1 AND NVL (bb.negate_tag, 'N') = 'N') a,
                  gicl_claims b,
                  gicl_intm_itmperil c,
                  gicl_clm_recovery_dtl d
            WHERE 1 = 1
              AND b.line_cd = NVL (p_line_cd, b.line_cd)
              AND b.subline_cd = NVL (p_subline_cd, b.subline_cd)
              AND DECODE (p_issue_param, 1, b.iss_cd, b.pol_iss_cd) = NVL (p_iss_cd, DECODE (p_issue_param, 1, b.iss_cd, b.pol_iss_cd))
              AND b.assd_no = NVL (p_assd_no, b.assd_no)
              AND d.peril_cd = NVL (p_peril_cd, d.peril_cd)
              AND a.claim_id = b.claim_id
              AND b.claim_id = c.claim_id
              AND a.recovery_id = d.recovery_id
              AND a.claim_id = d.claim_id
              AND c.intm_no = NVL (p_intm_no, c.intm_no)
              AND NVL (cancel_tag, 'N') = 'N'
              AND TRUNC (tran_date) >= p_curr1_date
              AND TRUNC (tran_date) <= p_curr2_date
         GROUP BY b.assd_no, a.recovery_id, line_cd, subline_cd, iss_cd, d.peril_cd, c.intm_no;

         --insert record in table gicl_lratio_curr_recovery_ext
         IF SQL%FOUND THEN
            p_curr_exists := 'Y';
            FORALL i IN vv_rec_id.FIRST .. vv_rec_id.LAST
               INSERT INTO gicl_lratio_curr_recovery_ext
                           (session_id, recovery_id, assd_no, line_cd, subline_cd, iss_cd, peril_cd, recovered_amt, intm_no, user_id
                           )
                    VALUES (p_session_id, vv_rec_id (i), vv_assd_no (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), vv_rec_amt (i), vv_intm_no (i), p_user_id
                           );
         END IF;
      END;
   END;

   PROCEDURE lratio_extract_recovery_intm2 (
      p_line_cd             giis_line.line_cd%TYPE,
      p_subline_cd          giis_subline.subline_cd%TYPE,
      p_iss_cd              giis_issource.iss_cd%TYPE,
      p_peril_cd            giis_peril.peril_cd%TYPE,
      p_intm_no             giis_intermediary.intm_no%TYPE,
      p_assd_no             giis_assured.assd_no%TYPE,
      p_session_id          gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param          NUMBER,
      p_issue_param         NUMBER,
      p_curr1_date          gipi_polbasic.issue_date%TYPE,
      p_curr2_date          gipi_polbasic.issue_date%TYPE,
      p_prev1_date          gipi_polbasic.issue_date%TYPE,
      p_prev2_date          gipi_polbasic.issue_date%TYPE,
      p_curr_exists   OUT   VARCHAR2,
      p_prev_exists   OUT   VARCHAR2,
      p_extract_cat         VARCHAR2,
      p_user_id             giis_users.user_id%TYPE
   )
   AS
      TYPE rec_amt_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;

      TYPE assd_no_tab IS TABLE OF giis_assured.assd_no%TYPE;

      TYPE intm_no_tab IS TABLE OF giis_intermediary.intm_no%TYPE;

      TYPE rec_id_tab IS TABLE OF gicl_clm_recovery.recovery_id%TYPE;

      TYPE line_cd_tab IS TABLE OF giis_line.line_cd%TYPE;

      TYPE subline_cd_tab IS TABLE OF giis_subline.subline_cd%TYPE;

      TYPE iss_cd_tab IS TABLE OF giis_issource.iss_cd%TYPE;

      TYPE peril_cd_tab IS TABLE OF giis_peril.peril_cd%TYPE;

      vv_rec_id       rec_id_tab;
      vv_rec_amt      rec_amt_tab;
      vv_assd_no      assd_no_tab;
      vv_line_cd      line_cd_tab;
      vv_subline_cd   subline_cd_tab;
      vv_iss_cd       iss_cd_tab;
      vv_intm_no      intm_no_tab;
      vv_peril_cd     peril_cd_tab;
   BEGIN                                                                                                                                                                                          --main
      p_curr_exists := 'N';
      p_prev_exists := 'N';

      BEGIN                                                                                                                                                     --extract previous year recovery amount
         --delete records in extract table gicl_lratio_prev_recovery_ext for the current user
         DELETE      gicl_lratio_prev_recovery_ext
               WHERE user_id = p_user_id;

         --retrieved all valid recovery record for previous year
         SELECT   b.assd_no, a.recovery_id, line_cd, subline_cd, iss_cd, d.peril_cd, c.intm_no,
                  SUM (NVL (recovered_amt, 0) * (NVL (d.recoverable_amt, 0) / get_rec_amt (d.recovery_id)) * (NVL (c.premium_amt, 0) / get_intm_prem (c.claim_id))) recovered_amt
         BULK COLLECT INTO vv_assd_no, vv_rec_id, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_peril_cd, vv_intm_no,
                  vv_rec_amt
             FROM                                                                                                        --gicl_recovery_payt a, -- Udel 12222011 replaced by the SELECT statement below
                  (SELECT aa.claim_id, aa.recovery_id, aa.tran_date, aa.cancel_tag,
                          DECODE (p_extract_cat, 'G', aa.recovered_amt, DECODE (aa.dist_sw, 'Y', bb.shr_recovery_amt, aa.recovered_amt)) recovered_amt
                     FROM gicl_recovery_payt aa, gicl_recovery_ds bb
                    WHERE 1 = 1 AND aa.recovery_id = bb.recovery_id(+) AND aa.recovery_payt_id = bb.recovery_payt_id(+) AND bb.share_type(+) = 1 AND NVL (bb.negate_tag, 'N') = 'N') a,
                  gicl_claims b,
                  gicl_intm_itmperil c,
                  gicl_clm_recovery_dtl d
            WHERE 1 = 1
              AND b.line_cd = NVL (p_line_cd, b.line_cd)
              AND b.subline_cd = NVL (p_subline_cd, b.subline_cd)
              AND DECODE (p_issue_param, 1, b.iss_cd, b.pol_iss_cd) = NVL (p_iss_cd, DECODE (p_issue_param, 1, b.iss_cd, b.pol_iss_cd))
              AND b.assd_no = NVL (p_assd_no, b.assd_no)
              AND d.peril_cd = NVL (p_peril_cd, d.peril_cd)
              AND a.claim_id = b.claim_id
              AND b.claim_id = c.claim_id
              AND d.recovery_id = a.recovery_id
              AND d.claim_id = a.claim_id
              AND c.intm_no = NVL (p_intm_no, c.intm_no)
              AND NVL (cancel_tag, 'N') = 'N'
              AND TO_NUMBER (TO_CHAR (TRUNC (b.loss_date), 'YYYY')) = TO_NUMBER (TO_CHAR (TRUNC (tran_date), 'YYYY'))
              --AND TO_NUMBER(TO_CHAR(TRUNC(tran_date), 'YYYY'))<= TO_NUMBER(p_prev_year)\
              AND TRUNC (tran_date) >= p_prev1_date
              AND TRUNC (tran_date) <= p_prev2_date
         GROUP BY b.assd_no, a.recovery_id, line_cd, subline_cd, iss_cd, d.peril_cd, c.intm_no;

         --insert record in table gicl_lratio_prev_recovery_ext
         IF SQL%FOUND THEN
            p_prev_exists := 'Y';
            FORALL i IN vv_rec_id.FIRST .. vv_rec_id.LAST
               INSERT INTO gicl_lratio_prev_recovery_ext
                           (session_id, recovery_id, assd_no, line_cd, subline_cd, iss_cd, peril_cd, recovered_amt, intm_no, user_id
                           )
                    VALUES (p_session_id, vv_rec_id (i), vv_assd_no (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), vv_rec_amt (i), vv_intm_no (i), p_user_id
                           );
            --after insert refresh arrays by deleting data
            vv_rec_id.DELETE;
            vv_assd_no.DELETE;
            vv_intm_no.DELETE;
            vv_rec_amt.DELETE;
            vv_line_cd.DELETE;
            vv_subline_cd.DELETE;
            vv_iss_cd.DELETE;
            vv_peril_cd.DELETE;
         END IF;
      END;

      BEGIN
         --delete records in extract table gicl_lratio_curr_recovery_ext for the current user
         DELETE      gicl_lratio_curr_recovery_ext
               WHERE user_id = p_user_id;

         --retrieved all valid recovery record for current year
         SELECT   b.assd_no, a.recovery_id, line_cd, subline_cd, iss_cd, d.peril_cd, c.intm_no,
                  SUM (NVL (recovered_amt, 0) * (NVL (d.recoverable_amt, 0) / get_rec_amt (d.recovery_id)) * (NVL (c.premium_amt, 0) / get_intm_prem (c.claim_id))) recovered_amt
         BULK COLLECT INTO vv_assd_no, vv_rec_id, vv_line_cd, vv_subline_cd, vv_iss_cd, vv_peril_cd, vv_intm_no,
                  vv_rec_amt
             FROM                                                                                                        --gicl_recovery_payt a, -- Udel 12222011 replaced by the SELECT statement below
                  (SELECT aa.claim_id, aa.recovery_id, aa.tran_date, aa.cancel_tag,
                          DECODE (p_extract_cat, 'G', aa.recovered_amt, DECODE (aa.dist_sw, 'Y', bb.shr_recovery_amt, aa.recovered_amt)) recovered_amt
                     FROM gicl_recovery_payt aa, gicl_recovery_ds bb
                    WHERE 1 = 1 AND aa.recovery_id = bb.recovery_id(+) AND aa.recovery_payt_id = bb.recovery_payt_id(+) AND bb.share_type(+) = 1 AND NVL (bb.negate_tag, 'N') = 'N') a,
                  gicl_claims b,
                  gicl_intm_itmperil c,
                  gicl_clm_recovery_dtl d
            WHERE 1 = 1
              AND b.line_cd = NVL (p_line_cd, b.line_cd)
              AND b.subline_cd = NVL (p_subline_cd, b.subline_cd)
              AND DECODE (p_issue_param, 1, b.iss_cd, b.pol_iss_cd) = NVL (p_iss_cd, DECODE (p_issue_param, 1, b.iss_cd, b.pol_iss_cd))
              AND b.assd_no = NVL (p_assd_no, b.assd_no)
              AND d.peril_cd = NVL (p_peril_cd, d.peril_cd)
              AND a.claim_id = b.claim_id
              AND b.claim_id = c.claim_id
              AND a.recovery_id = d.recovery_id
              AND a.claim_id = d.claim_id
              AND c.intm_no = NVL (p_intm_no, c.intm_no)
              AND NVL (cancel_tag, 'N') = 'N'
              AND TO_NUMBER (TO_CHAR (TRUNC (b.loss_date), 'YYYY')) = TO_NUMBER (TO_CHAR (TRUNC (tran_date), 'YYYY'))
              AND TRUNC (tran_date) >= p_curr1_date
              AND TRUNC (tran_date) <= p_curr2_date
         GROUP BY b.assd_no, a.recovery_id, line_cd, subline_cd, iss_cd, d.peril_cd, c.intm_no;

         --insert record in table gicl_lratio_curr_recovery_ext
         IF SQL%FOUND THEN
            p_curr_exists := 'Y';
            FORALL i IN vv_rec_id.FIRST .. vv_rec_id.LAST
               INSERT INTO gicl_lratio_curr_recovery_ext
                           (session_id, recovery_id, assd_no, line_cd, subline_cd, iss_cd, peril_cd, recovered_amt, intm_no, user_id
                           )
                    VALUES (p_session_id, vv_rec_id (i), vv_assd_no (i), vv_line_cd (i), vv_subline_cd (i), vv_iss_cd (i), vv_peril_cd (i), vv_rec_amt (i), vv_intm_no (i), p_user_id
                           );
         END IF;
      END;
   END;

   PROCEDURE lratio_extract_by_line (
      p_line_cd            giis_line.line_cd%TYPE,
      p_subline_cd         giis_subline.subline_cd%TYPE,
      p_iss_cd             giis_issource.iss_cd%TYPE,
      p_peril_cd           giis_peril.peril_cd%TYPE,
      p_intm_no            giis_intermediary.intm_no%TYPE,
      p_assd_no            giis_assured.assd_no%TYPE,
      p_session_id         gicl_loss_ratio_ext.session_id%TYPE,
      p_loss_date          gicl_claims.loss_date%TYPE,
      p_counter      OUT   NUMBER,
      p_ext_proc           VARCHAR2,
      p_user_id            giis_users.user_id%TYPE,
      p_date               gipi_polbasic.issue_date%TYPE -- Dren Niebres 07.12.2016 SR-21428
   )
   AS
      v_exists          VARCHAR2 (1);
      v_line_cd         giis_line.line_cd%TYPE;                                                                                                                                       --Jerome 08042005
      v_ast             VARCHAR2 (1)                             := '*';                                                                                                              --Jerome 08042005
      v_prev_prem_res   gicl_loss_ratio_ext.prev_prem_amt%TYPE;
      v_curr_prem_res   gicl_loss_ratio_ext.prev_prem_amt%TYPE;
   BEGIN
      p_counter := 0;

      FOR curr_prem IN (SELECT   line_cd, NVL (SUM (prem_amt), 0) prem
                            FROM gicl_lratio_curr_prem_ext
                           WHERE session_id = p_session_id 
                           AND (line_cd, iss_cd) IN (
                                                     SELECT line_cd, branch_cd
                                                       FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                    )
                           --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                       --angelo092407
                        GROUP BY line_cd)
      LOOP
         INSERT INTO gicl_loss_ratio_ext
                     (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, curr_prem_amt, user_id
                     )
              VALUES (p_session_id, curr_prem.line_cd, p_subline_cd, p_iss_cd, p_peril_cd, p_loss_date, p_assd_no, p_intm_no, curr_prem.prem, p_user_id
                     );

         p_counter := p_counter + 1;
      END LOOP;

      FOR prev_prem IN (SELECT   line_cd, NVL (SUM (prem_amt), 0) prem
                          FROM gicl_lratio_prev_prem_ext
                         WHERE session_id = p_session_id 
                           AND (line_cd, iss_cd) IN (
                                                     SELECT line_cd, branch_cd
                                                       FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                    )                           
--                           AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                        --angelo092407
                        GROUP BY line_cd)
      LOOP
         v_exists := 'N';

         FOR chk_exists IN (SELECT '1'
                              FROM gicl_loss_ratio_ext
                             WHERE session_id = p_session_id
                               AND (line_cd, iss_cd) IN (
                                                     SELECT line_cd, branch_cd
                                                       FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                    )                         
                             --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                     --angelo092407
                               AND line_cd = prev_prem.line_cd)
         LOOP
            UPDATE gicl_loss_ratio_ext
               SET prev_prem_amt = NVL (prev_prem_amt, 0) + prev_prem.prem
             WHERE session_id = p_session_id AND line_cd = prev_prem.line_cd;

            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N' THEN
            p_counter := p_counter + 1;

            INSERT INTO gicl_loss_ratio_ext
                        (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, prev_prem_amt, user_id
                        )
                 VALUES (p_session_id, prev_prem.line_cd, p_subline_cd, p_iss_cd, p_peril_cd, p_loss_date, p_assd_no, p_intm_no, prev_prem.prem, p_user_id
                        );
         END IF;
      END LOOP;

      --current loss
      FOR curr_loss IN (SELECT   line_cd, NVL (SUM (os_amt), 0) loss
                            FROM gicl_lratio_curr_os_ext
                           WHERE session_id = p_session_id 
                           AND (line_cd, iss_cd) IN (
                                                     SELECT line_cd, branch_cd
                                                       FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                    )                           
                           --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                        --angelo092407
                        GROUP BY line_cd)
      LOOP
         v_exists := 'N';

         FOR chk_exists IN (SELECT '1'
                              FROM gicl_loss_ratio_ext
                             WHERE session_id = p_session_id 
                               AND (line_cd, iss_cd) IN (
                                                     SELECT line_cd, branch_cd
                                                       FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                    ) 
                             --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                     --angelo092407
                               AND line_cd = curr_loss.line_cd
                           )
         LOOP
            UPDATE gicl_loss_ratio_ext
               SET curr_loss_res = NVL (curr_loss_res, 0) + curr_loss.loss
             WHERE session_id = p_session_id AND line_cd = curr_loss.line_cd;

            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N' THEN
            p_counter := p_counter + 1;

            INSERT INTO gicl_loss_ratio_ext
                        (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, curr_loss_res, user_id
                        )
                 VALUES (p_session_id, curr_loss.line_cd, p_subline_cd, p_iss_cd, p_peril_cd, p_loss_date, p_assd_no, p_intm_no, curr_loss.loss, p_user_id
                        );
         END IF;
      END LOOP;

      --previous loss
      FOR prev_loss IN (SELECT   line_cd, NVL (SUM (os_amt), 0) loss
                            FROM gicl_lratio_prev_os_ext
                           WHERE session_id = p_session_id 
                           AND (line_cd, iss_cd) IN (
                                                     SELECT line_cd, branch_cd
                                                       FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                    )
                           --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                        --angelo092407
                        GROUP BY line_cd)
      LOOP
         v_exists := 'N';

         FOR chk_exists IN (SELECT '1'
                              FROM gicl_loss_ratio_ext
                             WHERE session_id = p_session_id 
                               AND (line_cd, iss_cd) IN (
                                                     SELECT line_cd, branch_cd
                                                       FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                    ) 
                             --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                     --angelo092407
                               AND line_cd = prev_loss.line_cd)
         LOOP
            UPDATE gicl_loss_ratio_ext
               SET prev_loss_res = NVL (prev_loss_res, 0) + prev_loss.loss
             WHERE session_id = p_session_id AND line_cd = prev_loss.line_cd;

            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N' THEN
            p_counter := p_counter + 1;

            INSERT INTO gicl_loss_ratio_ext
                        (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, prev_loss_res, user_id
                        )
                 VALUES (p_session_id, prev_loss.line_cd, p_subline_cd, p_iss_cd, p_peril_cd, p_loss_date, p_assd_no, p_intm_no, prev_loss.loss, p_user_id
                        );
         END IF;
      END LOOP;

      --losses paid
      FOR losses IN (SELECT   line_cd, NVL (SUM (loss_paid), 0) loss_paid
                         FROM gicl_lratio_loss_paid_ext
                        WHERE session_id = p_session_id 
                          AND (line_cd, iss_cd) IN (
                                                     SELECT line_cd, branch_cd
                                                       FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                    )
                          --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                           --angelo092407
                     GROUP BY line_cd)
      LOOP
         v_exists := 'N';

         FOR chk_exists IN (SELECT '1'
                              FROM gicl_loss_ratio_ext
                             WHERE session_id = p_session_id 
                               AND (line_cd, iss_cd) IN (
                                                     SELECT line_cd, branch_cd
                                                       FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                    ) 
                             --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                     --angelo092407
                               AND line_cd = losses.line_cd)
         LOOP
            UPDATE gicl_loss_ratio_ext
               SET loss_paid_amt = NVL (loss_paid_amt, 0) + losses.loss_paid
             WHERE session_id = p_session_id AND line_cd = losses.line_cd;

            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N' THEN
            p_counter := p_counter + 1;

            INSERT INTO gicl_loss_ratio_ext
                        (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, loss_paid_amt, user_id
                        )
                 VALUES (p_session_id, losses.line_cd, p_subline_cd, p_iss_cd, p_peril_cd, p_loss_date, p_assd_no, p_intm_no, losses.loss_paid, p_user_id
                        );
         END IF;
      END LOOP;

      --current recovery
      FOR curr_rec IN (SELECT   line_cd, NVL (SUM (recovered_amt), 0) RECOVERY
                           FROM gicl_lratio_curr_recovery_ext
                          WHERE session_id = p_session_id 
                           AND (line_cd, iss_cd) IN (
                                                     SELECT line_cd, branch_cd
                                                       FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                    )
                            --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                         --angelo092407
                       GROUP BY line_cd)
      LOOP
         v_exists := 'N';

         FOR chk_exists IN (SELECT '1'
                              FROM gicl_loss_ratio_ext
                             WHERE session_id = p_session_id 
                               AND (line_cd, iss_cd) IN (
                                                     SELECT line_cd, branch_cd
                                                       FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                    ) 
                               --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                     --angelo092407
                                   AND line_cd = curr_rec.line_cd)
         LOOP
            UPDATE gicl_loss_ratio_ext
               SET curr_loss_res = NVL (curr_loss_res, 0) - curr_rec.RECOVERY
             WHERE session_id = p_session_id AND line_cd = curr_rec.line_cd;

            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N' THEN
            p_counter := p_counter + 1;

            INSERT INTO gicl_loss_ratio_ext
                        (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, curr_loss_res, user_id
                        )
                 VALUES (p_session_id, curr_rec.line_cd, p_subline_cd, p_iss_cd, p_peril_cd, p_loss_date, p_assd_no, p_intm_no, -curr_rec.RECOVERY, p_user_id
                        );
         END IF;
      END LOOP;

      --current recovery
      FOR prev_rec IN (SELECT   line_cd, NVL (SUM (recovered_amt), 0) RECOVERY
                           FROM gicl_lratio_prev_recovery_ext
                          WHERE session_id = p_session_id 
                            AND (line_cd, iss_cd) IN (
                                                     SELECT line_cd, branch_cd
                                                       FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                    )
                            --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                         --angelo092407
                       GROUP BY line_cd)
      LOOP
         v_exists := 'N';

         FOR chk_exists IN (SELECT '1'
                              FROM gicl_loss_ratio_ext
                             WHERE session_id = p_session_id 
                               AND (line_cd, iss_cd) IN (
                                                     SELECT line_cd, branch_cd
                                                       FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                    ) 
                               --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                     --angelo092407
                               AND line_cd = prev_rec.line_cd)
         LOOP
            UPDATE gicl_loss_ratio_ext
               SET prev_loss_res = NVL (prev_loss_res, 0) - prev_rec.RECOVERY
             WHERE session_id = p_session_id AND line_cd = prev_rec.line_cd;

            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N' THEN
            p_counter := p_counter + 1;

            INSERT INTO gicl_loss_ratio_ext
                        (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, prev_loss_res, user_id, intm_no
                        )
                 VALUES (p_session_id, prev_rec.line_cd, p_subline_cd, p_iss_cd, p_peril_cd, p_loss_date, p_assd_no, -prev_rec.RECOVERY, p_user_id, p_intm_no
                        );
         END IF;
      END LOOP;

      FOR prem_res IN (SELECT line_cd, prev_prem_amt, curr_prem_amt
                         FROM gicl_loss_ratio_ext
                        WHERE session_id = p_session_id 
                          AND (line_cd, iss_cd) IN (
                                                     SELECT line_cd, branch_cd
                                                       FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                    )                                                    
                          --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1
                       )
      LOOP
         v_prev_prem_res := 0;
         v_curr_prem_res := 0;

         IF p_ext_proc = 'S' THEN
            v_prev_prem_res := NVL (prem_res.prev_prem_amt, 0) * .4;
            v_curr_prem_res := NVL (prem_res.curr_prem_amt, 0) * .4;
         ELSE
            FOR c IN (SELECT param_value_v
                        FROM giis_parameters
                       WHERE param_name = 'LINE_CODE_MN')
            LOOP
               v_line_cd := c.param_value_v;
               EXIT;
            END LOOP;

            IF NVL (prem_res.curr_prem_amt, 0) <> 0 THEN
               IF prem_res.line_cd = v_line_cd THEN                                                                                                                                   --Jerome 08052005
                  FOR curr_prem IN (SELECT   line_cd, ROUND (SUM (prem * factor), 2) prem
                                        FROM (SELECT   b.line_cd, NVL (SUM (b.prem_amt), 0) prem, factor
                                                  FROM gicl_24th_tab_mn a, gicl_lratio_curr_prem_ext b, gipi_polbasic c
                                                 WHERE 1 = 1
                                                   AND col_mm = TO_NUMBER (TO_CHAR (date_for_24th, 'MM'), 99)
                                                   AND a.session_id = p_session_id
                                                   AND a.session_id = b.session_id
                                                   AND b.line_cd = prem_res.line_cd
                                                   AND (b.line_cd, b.iss_cd) IN (
                                                                             SELECT line_cd, branch_cd
                                                                               FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                                            ) 
                                                   --AND check_user_per_iss_cd2 (b.line_cd, b.iss_cd, 'GICLS204', p_user_id) = 1                                                            --angelo092407
                                              --AND b.line_cd = NVL(p_line_cd,b.line_cd)
                                                   AND b.policy_id = c.policy_id
                                                   AND c.expiry_date > p_date -- Dren Niebres 07.12.2016 SR-21428                                                 
                                              GROUP BY b.line_cd, factor)
                                    GROUP BY line_cd)
                  LOOP
                     v_curr_prem_res := v_curr_prem_res + NVL (curr_prem.prem, 0);
                  END LOOP;
               END IF;

               IF prem_res.line_cd <> v_line_cd THEN
                  FOR curr_prem IN (SELECT   line_cd, ROUND (SUM (prem * factor), 2) prem
                                        FROM (SELECT   b.line_cd, NVL (SUM (b.prem_amt), 0) prem, factor
                                                  FROM gicl_24th_tab a, gicl_lratio_curr_prem_ext b, gipi_polbasic c
                                                 WHERE 1 = 1
                                                   AND col_mm = TO_NUMBER (TO_CHAR (date_for_24th, 'MM'), 99)
                                                   AND a.session_id = p_session_id
                                                   AND a.session_id = b.session_id
                                                   AND b.line_cd = prem_res.line_cd
                                                   AND (b.line_cd, b.iss_cd) IN (
                                                                             SELECT line_cd, branch_cd
                                                                               FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                                            ) 
                                                   --AND check_user_per_iss_cd2 (b.line_cd, b.iss_cd, 'GICLS204', p_user_id) = 1                                                            --angelo092407
                                              --AND b.line_cd = NVL(p_line_cd,b.line_cd)
                                                   AND b.policy_id = c.policy_id
                                                   AND c.expiry_date > p_date -- Dren Niebres 07.12.2016 SR-21428                                               
                                              GROUP BY b.line_cd, factor)
                                    GROUP BY line_cd)
                  LOOP
                     v_curr_prem_res := v_curr_prem_res + NVL (curr_prem.prem, 0);
                  END LOOP;
               END IF;
            END IF;
         END IF;

         IF NVL (prem_res.curr_prem_amt, 0) <> 0 THEN
            IF prem_res.line_cd = v_line_cd THEN                                                                                                                                      --Jerome 08052005
               FOR prev_prem IN (SELECT   line_cd, ROUND (SUM (prem * factor), 2) prem
                                     FROM (SELECT   line_cd, NVL (SUM (prem_amt), 0) prem, factor
                                               FROM gicl_24th_tab_mn a, gicl_lratio_prev_prem_ext b
                                              WHERE 1 = 1
                                                AND col_mm = TO_NUMBER (TO_CHAR (date_for_24th, 'MM'), 99)
                                                AND a.session_id = p_session_id
                                                AND a.session_id = b.session_id
                                                AND line_cd = prem_res.line_cd
                                                AND (b.line_cd, b.iss_cd) IN (
                                                                         SELECT line_cd, branch_cd
                                                                           FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                                        ) 
                                                --AND check_user_per_iss_cd2 (b.line_cd, b.iss_cd, 'GICLS204', p_user_id) = 1                                                               --angelo092407
                                           --AND b.line_cd = NVL(p_line_cd,b.line_cd)
                                           GROUP BY line_cd, factor)
                                 GROUP BY line_cd)
               LOOP
                  v_prev_prem_res := v_prev_prem_res + NVL (prev_prem.prem, 0);
               END LOOP;
            END IF;

            IF prem_res.line_cd <> v_line_cd THEN
               FOR prev_prem IN (SELECT   line_cd, ROUND (SUM (prem * factor), 2) prem
                                     FROM (SELECT   line_cd, NVL (SUM (prem_amt), 0) prem, factor
                                               FROM gicl_24th_tab a, gicl_lratio_prev_prem_ext b
                                              WHERE 1 = 1
                                                AND col_mm = TO_NUMBER (TO_CHAR (date_for_24th, 'MM'), 99)
                                                AND a.session_id = p_session_id
                                                AND a.session_id = b.session_id
                                                AND line_cd = prem_res.line_cd
                                                AND (b.line_cd, b.iss_cd) IN (
                                                                         SELECT line_cd, branch_cd
                                                                           FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                                        ) 
                                                --AND check_user_per_iss_cd2 (b.line_cd, b.iss_cd, 'GICLS204', p_user_id) = 1
                                                                                                                                                                    --angelo092407
                                           --AND b.line_cd = NVL(p_line_cd,b.line_cd)
                                           GROUP BY line_cd, factor)
                                 GROUP BY line_cd)
               LOOP
                  v_prev_prem_res := v_prev_prem_res + NVL (prev_prem.prem, 0);
               END LOOP;
            END IF;
         END IF;

         UPDATE gicl_loss_ratio_ext
            SET prev_prem_res = v_prev_prem_res,
                curr_prem_res = v_curr_prem_res
          WHERE session_id = p_session_id AND line_cd = prem_res.line_cd;
      END LOOP;
   END;

   PROCEDURE lratio_extract_by_subline (
      p_line_cd            giis_line.line_cd%TYPE,
      p_iss_cd             giis_issource.iss_cd%TYPE,
      p_peril_cd           giis_peril.peril_cd%TYPE,
      p_intm_no            giis_intermediary.intm_no%TYPE,
      p_assd_no            giis_assured.assd_no%TYPE,
      p_session_id         gicl_loss_ratio_ext.session_id%TYPE,
      p_loss_date          gicl_claims.loss_date%TYPE,
      p_counter      OUT   NUMBER,
      p_ext_proc           VARCHAR2,
      p_user_id            giis_users.user_id%TYPE,
      p_date               gipi_polbasic.issue_date%TYPE -- Dren Niebres 07.12.2016 SR-21428
   )
   AS
      v_exists          VARCHAR2 (1);
      v_line_cd         giis_line.line_cd%TYPE;                                                                                                                                      -- Jerome 08042005
      v_ast             VARCHAR2 (1)                             := '*';                                                                                                              --Jerome 08042005
      v_prev_prem_res   gicl_loss_ratio_ext.prev_prem_amt%TYPE;
      v_curr_prem_res   gicl_loss_ratio_ext.prev_prem_amt%TYPE;
   BEGIN
      p_counter := 0;

      FOR curr_prem IN (SELECT   subline_cd, NVL (SUM (prem_amt), 0) prem
                            FROM gicl_lratio_curr_prem_ext
                           WHERE session_id = p_session_id
                             AND (line_cd, iss_cd) IN (
                                                       SELECT line_cd, branch_cd
                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                       )                           
                             --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                       --angelo092507
                        GROUP BY subline_cd)
      LOOP
         INSERT INTO gicl_loss_ratio_ext
                     (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, curr_prem_amt, user_id
                     )
              VALUES (p_session_id, p_line_cd, curr_prem.subline_cd, p_iss_cd, p_peril_cd, p_loss_date, p_assd_no, p_intm_no, curr_prem.prem, p_user_id
                     );

         p_counter := p_counter + 1;
      END LOOP;

      --previous pemium
      FOR prev_prem IN (SELECT   subline_cd, NVL (SUM (prem_amt), 0) prem
                            FROM gicl_lratio_prev_prem_ext
                           WHERE session_id = p_session_id 
                             AND (line_cd, iss_cd) IN (
                                                       SELECT line_cd, branch_cd
                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                       )                                                           
                             --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                        --angelo092507
                        GROUP BY subline_cd)
      LOOP
         v_exists := 'N';

         FOR chk_exists IN (SELECT '1'
                              FROM gicl_loss_ratio_ext
                             WHERE session_id = p_session_id AND subline_cd = prev_prem.subline_cd)
         LOOP
            UPDATE gicl_loss_ratio_ext
               SET prev_prem_amt = NVL (prev_prem_amt, 0) + prev_prem.prem
             WHERE session_id = p_session_id AND subline_cd = prev_prem.subline_cd;

            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N' THEN
            p_counter := p_counter + 1;

            INSERT INTO gicl_loss_ratio_ext
                        (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, prev_prem_amt, user_id
                        )
                 VALUES (p_session_id, p_line_cd, prev_prem.subline_cd, p_iss_cd, p_peril_cd, p_loss_date, p_assd_no, p_intm_no, prev_prem.prem, p_user_id
                        );
         END IF;
      END LOOP;

      --current loss
      FOR curr_loss IN (SELECT   subline_cd, NVL (SUM (os_amt), 0) loss
                            FROM gicl_lratio_curr_os_ext
                           WHERE session_id = p_session_id
                             AND (line_cd, iss_cd) IN (
                                                       SELECT line_cd, branch_cd
                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                       )                               
                             --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                        --angelo092507
                        GROUP BY subline_cd)
      LOOP
         v_exists := 'N';

         FOR chk_exists IN (SELECT '1'
                              FROM gicl_loss_ratio_ext
                             WHERE session_id = p_session_id 
                               -- removed check_user_per_iss_cd2 here because security was already checked in the outer loop                                                       )
                               --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                     --angelo092507
                                   AND subline_cd = curr_loss.subline_cd)
         LOOP
            UPDATE gicl_loss_ratio_ext
               SET curr_loss_res = NVL (curr_loss_res, 0) + curr_loss.loss
             WHERE session_id = p_session_id AND subline_cd = curr_loss.subline_cd;

            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N' THEN
            p_counter := p_counter + 1;

            INSERT INTO gicl_loss_ratio_ext
                        (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, curr_loss_res, user_id
                        )
                 VALUES (p_session_id, p_line_cd, curr_loss.subline_cd, p_iss_cd, p_peril_cd, p_loss_date, p_assd_no, p_intm_no, curr_loss.loss, p_user_id
                        );
         END IF;
      END LOOP;

      --previous loss
      FOR prev_loss IN (SELECT   subline_cd, NVL (SUM (os_amt), 0) loss
                            FROM gicl_lratio_prev_os_ext
                           WHERE session_id = p_session_id
                             AND (line_cd, iss_cd) IN (
                                                       SELECT line_cd, branch_cd
                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                       )                               
                             --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                        --angelo092507
                        GROUP BY subline_cd)
      LOOP
         v_exists := 'N';

         FOR chk_exists IN (SELECT '1'
                              FROM gicl_loss_ratio_ext
                             WHERE session_id = p_session_id 
                            -- removed check_user_per_iss_cd2 here because security was already checked in the outer loop
                               --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                     --angelo092507
                               AND subline_cd = prev_loss.subline_cd)
         LOOP
            UPDATE gicl_loss_ratio_ext
               SET prev_loss_res = NVL (prev_loss_res, 0) + prev_loss.loss
             WHERE session_id = p_session_id AND subline_cd = prev_loss.subline_cd;

            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N' THEN
            p_counter := p_counter + 1;

            INSERT INTO gicl_loss_ratio_ext
                        (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, prev_loss_res, user_id
                        )
                 VALUES (p_session_id, p_line_cd, prev_loss.subline_cd, p_iss_cd, p_peril_cd, p_loss_date, p_assd_no, p_intm_no, prev_loss.loss, p_user_id
                        );
         END IF;
      END LOOP;

      --losses paid
      FOR losses IN (SELECT   subline_cd, NVL (SUM (loss_paid), 0) loss_paid
                         FROM gicl_lratio_loss_paid_ext
                        WHERE session_id = p_session_id
                          AND (line_cd, iss_cd) IN (
                                                   SELECT line_cd, branch_cd
                                                     FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                   )                            
                          --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                           --angelo092507
                     GROUP BY subline_cd)
      LOOP
         v_exists := 'N';

         FOR chk_exists IN (SELECT '1'
                              FROM gicl_loss_ratio_ext
                             WHERE session_id = p_session_id 
                            -- removed check_user_per_iss_cd2 here because security was already checked in the outer loop                                 
                               --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                     --angelo092507
                               AND subline_cd = losses.subline_cd)
         LOOP
            UPDATE gicl_loss_ratio_ext
               SET loss_paid_amt = NVL (loss_paid_amt, 0) + losses.loss_paid
             WHERE session_id = p_session_id AND subline_cd = losses.subline_cd;

            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N' THEN
            p_counter := p_counter + 1;

            INSERT INTO gicl_loss_ratio_ext
                        (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, loss_paid_amt, user_id
                        )
                 VALUES (p_session_id, p_line_cd, losses.subline_cd, p_iss_cd, p_peril_cd, p_loss_date, p_assd_no, p_intm_no, losses.loss_paid, p_user_id
                        );
         END IF;
      END LOOP;

      --current recovery
      FOR curr_rec IN (SELECT   subline_cd, NVL (SUM (recovered_amt), 0) RECOVERY
                           FROM gicl_lratio_curr_recovery_ext
                          WHERE session_id = p_session_id 
                            AND (line_cd, iss_cd) IN (
                                                       SELECT line_cd, branch_cd
                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                       )   
                            --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                         --angelo092507
                       GROUP BY subline_cd)
      LOOP
         v_exists := 'N';

         FOR chk_exists IN (SELECT '1'
                              FROM gicl_loss_ratio_ext
                             WHERE session_id = p_session_id 
                              -- removed check_user_per_iss_cd2 here because security was already checked in the outer loop 
                               --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                     --angelo092507
                                   AND subline_cd = curr_rec.subline_cd)
         LOOP
            UPDATE gicl_loss_ratio_ext
               SET curr_loss_res = NVL (curr_loss_res, 0) - curr_rec.RECOVERY
             WHERE session_id = p_session_id AND subline_cd = curr_rec.subline_cd;

            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N' THEN
            p_counter := p_counter + 1;

            INSERT INTO gicl_loss_ratio_ext
                        (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, curr_loss_res, user_id
                        )
                 VALUES (p_session_id, p_line_cd, curr_rec.subline_cd, p_iss_cd, p_peril_cd, p_loss_date, p_assd_no, p_intm_no, -curr_rec.RECOVERY, p_user_id
                        );
         END IF;
      END LOOP;

      --current recovery
      FOR prev_rec IN (SELECT   subline_cd, NVL (SUM (recovered_amt), 0) RECOVERY
                           FROM gicl_lratio_prev_recovery_ext
                          WHERE session_id = p_session_id 
                            AND (line_cd, iss_cd) IN (
                                                       SELECT line_cd, branch_cd
                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                       )   
                            --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                         --angelo092507
                       GROUP BY subline_cd)
      LOOP
         v_exists := 'N';

         FOR chk_exists IN (SELECT '1'
                              FROM gicl_loss_ratio_ext
                             WHERE session_id = p_session_id 
                            -- removed check_user_per_iss_cd2 here because security was already checked in the outer loop                                 
                               --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                     --angelo092507
                               AND subline_cd = prev_rec.subline_cd)
         LOOP
            UPDATE gicl_loss_ratio_ext
               SET prev_loss_res = NVL (prev_loss_res, 0) - prev_rec.RECOVERY
             WHERE session_id = p_session_id AND subline_cd = prev_rec.subline_cd;

            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N' THEN
            p_counter := p_counter + 1;

            INSERT INTO gicl_loss_ratio_ext
                        (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, prev_loss_res, user_id, intm_no
                        )
                 VALUES (p_session_id, p_line_cd, prev_rec.subline_cd, p_iss_cd, p_peril_cd, p_loss_date, p_assd_no, -prev_rec.RECOVERY, p_user_id, p_intm_no
                        );
         END IF;
      END LOOP;

      FOR prem_res IN (SELECT subline_cd, prev_prem_amt, curr_prem_amt
                         FROM gicl_loss_ratio_ext
                        WHERE session_id = p_session_id 
                          AND (line_cd, iss_cd) IN (
                                                       SELECT line_cd, branch_cd
                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                       )   
                      --   AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1 /*angelo092507*/
                      )
      LOOP
         v_prev_prem_res := 0;
         v_curr_prem_res := 0;

         IF p_ext_proc = 'S' THEN
            v_prev_prem_res := NVL (prem_res.prev_prem_amt, 0) * .4;
            v_curr_prem_res := NVL (prem_res.curr_prem_amt, 0) * .4;
         ELSE
            FOR c IN (SELECT param_value_v
                        FROM giis_parameters
                       WHERE param_name = 'LINE_CODE_MN')
            LOOP
               v_line_cd := c.param_value_v;
               EXIT;
            END LOOP;

            IF NVL (prem_res.curr_prem_amt, 0) <> 0 THEN
               IF NVL (p_line_cd, v_line_cd) = v_line_cd THEN                                                                                                                         --Jerome 08052005
                  FOR curr_prem IN (SELECT   subline_cd, ROUND (SUM (prem * factor), 2) prem
                                        FROM (SELECT   b.subline_cd, NVL (SUM (b.prem_amt), 0) prem, factor
                                                  FROM gicl_24th_tab_mn a, gicl_lratio_curr_prem_ext b, gipi_polbasic c
                                                 WHERE 1 = 1
                                                   AND col_mm = TO_NUMBER (TO_CHAR (date_for_24th, 'MM'), 99)
                                                   AND a.session_id = p_session_id
                                                   AND a.session_id = b.session_id
                                                   AND (b.line_cd, b.iss_cd) IN (
                                                                               SELECT line_cd, branch_cd
                                                                                 FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                                               )                                                   
                                                   --AND check_user_per_iss_cd2 (b.line_cd, b.iss_cd, 'GICLS204', p_user_id) = 1                                                            --angelo092507
                                                   AND b.subline_cd = prem_res.subline_cd
                                                   AND b.line_cd = NVL (p_line_cd, b.line_cd)
                                                   AND b.policy_id = c.policy_id
                                                   AND c.expiry_date > p_date -- Dren Niebres 07.12.2016 SR-21428                                                       
                                              GROUP BY b.subline_cd, factor)
                                    GROUP BY subline_cd)
                  LOOP
                     v_curr_prem_res := v_curr_prem_res + NVL (curr_prem.prem, 0);
                  END LOOP;
               ELSIF NVL (p_line_cd, v_line_cd) <> v_line_cd THEN
                  FOR curr_prem IN (SELECT   subline_cd, ROUND (SUM (prem * factor), 2) prem
                                        FROM (SELECT   b.subline_cd, NVL (SUM (b.prem_amt), 0) prem, factor
                                                  FROM gicl_24th_tab a, gicl_lratio_curr_prem_ext b, gipi_polbasic c
                                                 WHERE 1 = 1
                                                   AND col_mm = TO_NUMBER (TO_CHAR (date_for_24th, 'MM'), 99)
                                                   AND a.session_id = p_session_id
                                                   AND a.session_id = b.session_id
                                                   AND (b.line_cd, b.iss_cd) IN (
                                                                               SELECT line_cd, branch_cd
                                                                                 FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                                               )   
                                                   --AND check_user_per_iss_cd2 (b.line_cd, b.iss_cd, 'GICLS204', p_user_id) = 1                                                            --angelo092507
                                                   AND b.subline_cd = prem_res.subline_cd
                                                   AND b.line_cd = NVL (p_line_cd, b.line_cd)
                                                   AND b.policy_id = c.policy_id
                                                   AND c.expiry_date > p_date -- Dren Niebres 07.12.2016 SR-21428                                                       
                                              GROUP BY b.subline_cd, factor)
                                    GROUP BY subline_cd)
                  LOOP
                     v_curr_prem_res := v_curr_prem_res + NVL (curr_prem.prem, 0);
                  END LOOP;
               END IF;
            END IF;
         END IF;

         IF NVL (prem_res.curr_prem_amt, 0) <> 0 THEN
            IF NVL (p_line_cd, v_line_cd) = v_line_cd THEN                                                                                                                            --Jerome 08052005
               FOR prev_prem IN (SELECT   subline_cd, ROUND (SUM (prem * factor), 2) prem
                                     FROM (SELECT   subline_cd, NVL (SUM (prem_amt), 0) prem, factor
                                               FROM gicl_24th_tab_mn a, gicl_lratio_prev_prem_ext b
                                              WHERE 1 = 1
                                                AND col_mm = TO_NUMBER (TO_CHAR (date_for_24th, 'MM'), 99)
                                                AND a.session_id = p_session_id
                                                AND a.session_id = b.session_id
                                                AND (b.line_cd, b.iss_cd) IN (
                                                                           SELECT line_cd, branch_cd
                                                                             FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                                           )   
                                                --AND check_user_per_iss_cd2 (b.line_cd, b.iss_cd, 'GICLS204', p_user_id) = 1                                                               --angelo092507
                                                AND subline_cd = prem_res.subline_cd
                                                AND b.line_cd = NVL (p_line_cd, b.line_cd)
                                           GROUP BY subline_cd, factor)
                                 GROUP BY subline_cd)
               LOOP
                  v_prev_prem_res := v_prev_prem_res + NVL (prev_prem.prem, 0);
               END LOOP;
            ELSIF NVL (p_line_cd, v_line_cd) <> v_line_cd THEN
               FOR prev_prem IN (SELECT   subline_cd, ROUND (SUM (prem * factor), 2) prem
                                     FROM (SELECT   subline_cd, NVL (SUM (prem_amt), 0) prem, factor
                                               FROM gicl_24th_tab a, gicl_lratio_prev_prem_ext b
                                              WHERE 1 = 1
                                                AND col_mm = TO_NUMBER (TO_CHAR (date_for_24th, 'MM'), 99)
                                                AND a.session_id = p_session_id
                                                AND a.session_id = b.session_id
                                                AND (b.line_cd, b.iss_cd) IN (
                                                                       SELECT line_cd, branch_cd
                                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                                       )   
                                                --AND check_user_per_iss_cd2 (b.line_cd, b.iss_cd, 'GICLS204', p_user_id) = 1                                                               --angelo092507
                                                AND subline_cd = prem_res.subline_cd
                                                AND b.line_cd = NVL (p_line_cd, b.line_cd)                                          
                                           GROUP BY subline_cd, factor)
                                 GROUP BY subline_cd)
               LOOP
                  v_prev_prem_res := v_prev_prem_res + NVL (prev_prem.prem, 0);
               END LOOP;
            END IF;
         END IF;

         UPDATE gicl_loss_ratio_ext
            SET prev_prem_res = v_prev_prem_res,
                curr_prem_res = v_curr_prem_res
          WHERE session_id = p_session_id AND subline_cd = prem_res.subline_cd;
      END LOOP;
   END;

   PROCEDURE lratio_extract_by_iss_cd (
      p_line_cd            giis_line.line_cd%TYPE,
      p_subline_cd         giis_subline.subline_cd%TYPE,
      p_peril_cd           giis_peril.peril_cd%TYPE,
      p_intm_no            giis_intermediary.intm_no%TYPE,
      p_assd_no            giis_assured.assd_no%TYPE,
      p_session_id         gicl_loss_ratio_ext.session_id%TYPE,
      p_loss_date          gicl_claims.loss_date%TYPE,
      p_counter      OUT   NUMBER,
      p_ext_proc           VARCHAR2,
      p_user_id            giis_users.user_id%TYPE,
      p_date               gipi_polbasic.issue_date%TYPE -- Dren Niebres 07.12.2016 SR-21428
   )
   AS
      v_exists          VARCHAR2 (1);
      v_line_cd         giis_line.line_cd%TYPE;                                                                                                                                       --Jerome 08042005
      v_ast             VARCHAR2 (1)                             := '*';                                                                                                              --Jerome 08042005
      v_prev_prem_res   gicl_loss_ratio_ext.prev_prem_amt%TYPE;
      v_curr_prem_res   gicl_loss_ratio_ext.prev_prem_amt%TYPE;
   BEGIN
      p_counter := 0;

      FOR curr_prem IN (SELECT   iss_cd, NVL (SUM (prem_amt), 0) prem
                            FROM gicl_lratio_curr_prem_ext
                           WHERE session_id = p_session_id 
                             AND (line_cd, iss_cd) IN (
                                                   SELECT line_cd, branch_cd
                                                     FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                   )  
                             --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                       --angelo092507
                        GROUP BY iss_cd)
      LOOP
         INSERT INTO gicl_loss_ratio_ext
                     (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, curr_prem_amt, user_id
                     )
              VALUES (p_session_id, p_line_cd, p_subline_cd, curr_prem.iss_cd, p_peril_cd, p_loss_date, p_assd_no, p_intm_no, curr_prem.prem, p_user_id
                     );

         p_counter := p_counter + 1;
      END LOOP;

      FOR prev_prem IN (SELECT   iss_cd, NVL (SUM (prem_amt), 0) prem
                            FROM gicl_lratio_prev_prem_ext
                           WHERE session_id = p_session_id 
                             AND (line_cd, iss_cd) IN (
                                                   SELECT line_cd, branch_cd
                                                     FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                   )
                             --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                        --angelo092507
                        GROUP BY iss_cd)
      LOOP
         v_exists := 'N';

         FOR chk_exists IN (SELECT '1'
                              FROM gicl_loss_ratio_ext
                             WHERE session_id = p_session_id 
                               AND (line_cd, iss_cd) IN (
                                                   SELECT line_cd, branch_cd
                                                     FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                   )
                               --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                     --angelo092507
                                   AND iss_cd = prev_prem.iss_cd)
         LOOP
            UPDATE gicl_loss_ratio_ext
               SET prev_prem_amt = NVL (prev_prem_amt, 0) + prev_prem.prem
             WHERE session_id = p_session_id AND iss_cd = prev_prem.iss_cd;

            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N' THEN
            p_counter := p_counter + 1;

            INSERT INTO gicl_loss_ratio_ext
                        (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, prev_prem_amt, user_id
                        )
                 VALUES (p_session_id, p_line_cd, p_subline_cd, prev_prem.iss_cd, p_peril_cd, p_loss_date, p_assd_no, p_intm_no, prev_prem.prem, p_user_id
                        );
         END IF;
      END LOOP;

      --current loss
      FOR curr_loss IN (SELECT   iss_cd, NVL (SUM (os_amt), 0) loss
                            FROM gicl_lratio_curr_os_ext
                           WHERE session_id = p_session_id 
                             AND (line_cd, iss_cd) IN (
                                                   SELECT line_cd, branch_cd
                                                     FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                   )
                             --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                        --angelo092507
                        GROUP BY iss_cd)
      LOOP
         v_exists := 'N';

         FOR chk_exists IN (SELECT '1'
                              FROM gicl_loss_ratio_ext
                             WHERE session_id = p_session_id 
                               AND (line_cd, iss_cd) IN (
                                                   SELECT line_cd, branch_cd
                                                     FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                   )
                               --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                     --angelo092507
                                   AND iss_cd = curr_loss.iss_cd)
         LOOP
            UPDATE gicl_loss_ratio_ext
               SET curr_loss_res = NVL (curr_loss_res, 0) + curr_loss.loss
             WHERE session_id = p_session_id AND iss_cd = curr_loss.iss_cd;

            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N' THEN
            p_counter := p_counter + 1;

            INSERT INTO gicl_loss_ratio_ext
                        (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, curr_loss_res, user_id
                        )
                 VALUES (p_session_id, p_line_cd, p_subline_cd, curr_loss.iss_cd, p_peril_cd, p_loss_date, p_assd_no, p_intm_no, curr_loss.loss, p_user_id
                        );
         END IF;
      END LOOP;

      --previous loss
      FOR prev_loss IN (SELECT   iss_cd, NVL (SUM (os_amt), 0) loss
                            FROM gicl_lratio_prev_os_ext
                           WHERE session_id = p_session_id 
                             AND (line_cd, iss_cd) IN (
                                                   SELECT line_cd, branch_cd
                                                     FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                   )
                             --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                        --angelo092507
                        GROUP BY iss_cd)
      LOOP
         v_exists := 'N';

         FOR chk_exists IN (SELECT '1'
                              FROM gicl_loss_ratio_ext
                             WHERE session_id = p_session_id 
                               AND (line_cd, iss_cd) IN (
                                                   SELECT line_cd, branch_cd
                                                     FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                   )
                               --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                     --angelo092507
                                   AND iss_cd = prev_loss.iss_cd)
         LOOP
            UPDATE gicl_loss_ratio_ext
               SET prev_loss_res = NVL (prev_loss_res, 0) + prev_loss.loss
             WHERE session_id = p_session_id AND iss_cd = prev_loss.iss_cd;

            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N' THEN
            p_counter := p_counter + 1;

            INSERT INTO gicl_loss_ratio_ext
                        (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, prev_loss_res, user_id
                        )
                 VALUES (p_session_id, p_line_cd, p_subline_cd, prev_loss.iss_cd, p_peril_cd, p_loss_date, p_assd_no, p_intm_no, prev_loss.loss, p_user_id
                        );
         END IF;
      END LOOP;

      --losses paid
      FOR losses IN (SELECT   iss_cd, NVL (SUM (loss_paid), 0) loss_paid
                         FROM gicl_lratio_loss_paid_ext
                        WHERE session_id = p_session_id 
                          AND (line_cd, iss_cd) IN (
                                                   SELECT line_cd, branch_cd
                                                     FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                   )
                          --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                           --angelo092507
                     GROUP BY iss_cd)
      LOOP
         v_exists := 'N';

         FOR chk_exists IN (SELECT '1'
                              FROM gicl_loss_ratio_ext
                             WHERE session_id = p_session_id 
                               AND (line_cd, iss_cd) IN (
                                                   SELECT line_cd, branch_cd
                                                     FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                   )
                               --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                     --angelo092507
                                   AND iss_cd = losses.iss_cd)
         LOOP
            UPDATE gicl_loss_ratio_ext
               SET loss_paid_amt = NVL (loss_paid_amt, 0) + losses.loss_paid
             WHERE session_id = p_session_id AND iss_cd = losses.iss_cd;

            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N' THEN
            p_counter := p_counter + 1;

            INSERT INTO gicl_loss_ratio_ext
                        (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, loss_paid_amt, user_id
                        )
                 VALUES (p_session_id, p_line_cd, p_subline_cd, losses.iss_cd, p_peril_cd, p_loss_date, p_assd_no, p_intm_no, losses.loss_paid, p_user_id
                        );
         END IF;
      END LOOP;

      --current recovery
      FOR curr_rec IN (SELECT   iss_cd, NVL (SUM (recovered_amt), 0) RECOVERY
                           FROM gicl_lratio_curr_recovery_ext
                          WHERE session_id = p_session_id 
                            AND (line_cd, iss_cd) IN (
                                                   SELECT line_cd, branch_cd
                                                     FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                   )
                            --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                         --angelo092507
                       GROUP BY iss_cd)
      LOOP
         v_exists := 'N';

         FOR chk_exists IN (SELECT '1'
                              FROM gicl_loss_ratio_ext
                             WHERE session_id = p_session_id 
                               AND (line_cd, iss_cd) IN (
                                                   SELECT line_cd, branch_cd
                                                     FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                   )
                               --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                     --angelo092507
                                   AND iss_cd = curr_rec.iss_cd)
         LOOP
            UPDATE gicl_loss_ratio_ext
               SET curr_loss_res = NVL (curr_loss_res, 0) - curr_rec.RECOVERY
             WHERE session_id = p_session_id AND iss_cd = curr_rec.iss_cd;

            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N' THEN
            p_counter := p_counter + 1;

            INSERT INTO gicl_loss_ratio_ext
                        (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, curr_loss_res, user_id
                        )
                 VALUES (p_session_id, p_line_cd, p_subline_cd, curr_rec.iss_cd, p_peril_cd, p_loss_date, p_assd_no, p_intm_no, -curr_rec.RECOVERY, p_user_id
                        );
         END IF;
      END LOOP;

      --current recovery
      FOR prev_rec IN (SELECT   iss_cd, NVL (SUM (recovered_amt), 0) RECOVERY
                           FROM gicl_lratio_prev_recovery_ext
                          WHERE session_id = p_session_id 
                            AND (line_cd, iss_cd) IN (
                                                   SELECT line_cd, branch_cd
                                                     FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                   )
                            --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                         --angelo092507
                       GROUP BY iss_cd)
      LOOP
         v_exists := 'N';

         FOR chk_exists IN (SELECT '1'
                              FROM gicl_loss_ratio_ext
                             WHERE session_id = p_session_id 
                               AND (line_cd, iss_cd) IN (
                                                   SELECT line_cd, branch_cd
                                                     FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                   )
                               --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                     --angelo092507
                                   AND iss_cd = prev_rec.iss_cd)
         LOOP
            UPDATE gicl_loss_ratio_ext
               SET prev_loss_res = NVL (prev_loss_res, 0) - prev_rec.RECOVERY
             WHERE session_id = p_session_id AND iss_cd = prev_rec.iss_cd;

            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N' THEN
            p_counter := p_counter + 1;

            INSERT INTO gicl_loss_ratio_ext
                        (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, prev_loss_res, user_id, intm_no
                        )
                 VALUES (p_session_id, p_line_cd, p_subline_cd, prev_rec.iss_cd, p_peril_cd, p_loss_date, p_assd_no, -prev_rec.RECOVERY, p_user_id, p_intm_no
                        );
         END IF;
      END LOOP;

      FOR prem_res IN (SELECT iss_cd, prev_prem_amt, curr_prem_amt
                         FROM gicl_loss_ratio_ext
                        WHERE session_id = p_session_id 
                          AND (line_cd, iss_cd) IN (
                                                   SELECT line_cd, branch_cd
                                                     FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                   )
                          --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                           --angelo092507
                       )
      LOOP
         v_prev_prem_res := 0;
         v_curr_prem_res := 0;

         IF p_ext_proc = 'S' THEN
            v_prev_prem_res := NVL (prem_res.prev_prem_amt, 0) * .4;
            v_curr_prem_res := NVL (prem_res.curr_prem_amt, 0) * .4;
         ELSE
            FOR c IN (SELECT param_value_v
                        FROM giis_parameters
                       WHERE param_name = 'LINE_CODE_MN')
            LOOP
               v_line_cd := c.param_value_v;
               EXIT;
            END LOOP;

            IF NVL (prem_res.curr_prem_amt, 0) <> 0 THEN
               IF NVL (p_line_cd, v_line_cd) = v_line_cd THEN                                                                                                                         --Jerome 08052005
                  FOR curr_prem IN (SELECT   iss_cd, ROUND (SUM (prem * factor), 2) prem
                                        FROM (SELECT   b.iss_cd, NVL (SUM (b.prem_amt), 0) prem, factor
                                                  FROM gicl_24th_tab_mn a, gicl_lratio_curr_prem_ext b, gipi_polbasic c
                                                 WHERE 1 = 1
                                                   AND col_mm = TO_NUMBER (TO_CHAR (date_for_24th, 'MM'), 99)
                                                   AND a.session_id = p_session_id
                                                   AND a.session_id = b.session_id
                                                   AND (b.line_cd, b.iss_cd) IN (
                                                                           SELECT line_cd, branch_cd
                                                                             FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                                           )
                                                   --AND check_user_per_iss_cd2 (b.line_cd, b.iss_cd, 'GICLS204', p_user_id) = 1                                                            --angelo092507
                                                   AND b.iss_cd = prem_res.iss_cd
                                                   AND b.line_cd = v_line_cd
                                                   AND b.policy_id = c.policy_id
                                                   AND c.expiry_date > p_date -- Dren Niebres 07.12.2016 SR-21428                                                      
                                              GROUP BY b.iss_cd, factor)
                                    GROUP BY iss_cd)
                  LOOP
                     v_curr_prem_res := v_curr_prem_res + NVL (curr_prem.prem, 0);
                  END LOOP;
               END IF;

               IF NVL (p_line_cd, v_line_cd) <> v_line_cd THEN
                  FOR curr_prem IN (SELECT   iss_cd, ROUND (SUM (prem * factor), 2) prem
                                        FROM (SELECT   b.iss_cd, NVL (SUM (b.prem_amt), 0) prem, factor
                                                  FROM gicl_24th_tab a, gicl_lratio_curr_prem_ext b, gipi_polbasic c
                                                 WHERE 1 = 1
                                                   AND col_mm = TO_NUMBER (TO_CHAR (date_for_24th, 'MM'), 99)
                                                   AND a.session_id = p_session_id
                                                   AND a.session_id = b.session_id
                                                   AND (b.line_cd, b.iss_cd) IN (
                                                                           SELECT line_cd, branch_cd
                                                                             FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                                           )
                                                   --AND check_user_per_iss_cd2 (b.line_cd, b.iss_cd, 'GICLS204', p_user_id) = 1                                                            --angelo092507
                                                   AND b.iss_cd = prem_res.iss_cd
                                                   AND b.line_cd <> v_line_cd
                                                   AND b.policy_id = c.policy_id
                                                   AND c.expiry_date > p_date -- Dren Niebres 07.12.2016 SR-21428                                                          
                                              GROUP BY b.iss_cd, factor)
                                    GROUP BY iss_cd)
                  LOOP
                     v_curr_prem_res := v_curr_prem_res + NVL (curr_prem.prem, 0);
                  END LOOP;
               END IF;
            END IF;
         END IF;

         IF NVL (prem_res.curr_prem_amt, 0) <> 0 THEN
            IF NVL (p_line_cd, v_line_cd) = v_line_cd THEN                                                                                                                            --Jerome 08052005
               FOR prev_prem IN (SELECT   iss_cd, ROUND (SUM (prem * factor), 2) prem
                                     FROM (SELECT   iss_cd, NVL (SUM (prem_amt), 0) prem, factor
                                               FROM gicl_24th_tab_mn a, gicl_lratio_prev_prem_ext b
                                              WHERE 1 = 1
                                                AND col_mm = TO_NUMBER (TO_CHAR (date_for_24th, 'MM'), 99)
                                                AND a.session_id = p_session_id
                                                AND a.session_id = b.session_id
                                                AND (b.line_cd, b.iss_cd) IN (
                                                                       SELECT line_cd, branch_cd
                                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                                       )
                                                --AND check_user_per_iss_cd2 (b.line_cd, b.iss_cd, 'GICLS204', p_user_id) = 1                                                               --angelo092507
                                                AND iss_cd = prem_res.iss_cd
                                                AND b.line_cd = v_line_cd
                                           GROUP BY iss_cd, factor)
                                 GROUP BY iss_cd)
               LOOP
                  v_prev_prem_res := v_prev_prem_res + NVL (prev_prem.prem, 0);
               END LOOP;
            END IF;

            IF NVL (p_line_cd, v_line_cd) <> v_line_cd THEN
               FOR prev_prem IN (SELECT   iss_cd, ROUND (SUM (prem * factor), 2) prem
                                     FROM (SELECT   iss_cd, NVL (SUM (prem_amt), 0) prem, factor
                                               FROM gicl_24th_tab a, gicl_lratio_prev_prem_ext b
                                              WHERE 1 = 1
                                                AND col_mm = TO_NUMBER (TO_CHAR (date_for_24th, 'MM'), 99)
                                                AND a.session_id = p_session_id
                                                AND a.session_id = b.session_id
                                                AND (b.line_cd, b.iss_cd) IN (
                                                                       SELECT line_cd, branch_cd
                                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                                       )
                                                --AND check_user_per_iss_cd2 (b.line_cd, b.iss_cd, 'GICLS204', p_user_id) = 1                                                               --angelo092507
                                                AND iss_cd = prem_res.iss_cd
                                                AND b.line_cd <> v_line_cd
                                           GROUP BY iss_cd, factor)
                                 GROUP BY iss_cd)
               LOOP
                  v_prev_prem_res := v_prev_prem_res + NVL (prev_prem.prem, 0);
               END LOOP;
            END IF;
         END IF;

         UPDATE gicl_loss_ratio_ext
            SET prev_prem_res = v_prev_prem_res,
                curr_prem_res = v_curr_prem_res
          WHERE session_id = p_session_id AND iss_cd = prem_res.iss_cd;
      END LOOP;
   END;

   PROCEDURE lratio_extract_by_intermediary (
      p_line_cd            giis_line.line_cd%TYPE,
      p_subline_cd         giis_subline.subline_cd%TYPE,
      p_iss_cd             giis_issource.iss_cd%TYPE,
      p_peril_cd           giis_peril.peril_cd%TYPE,
      p_assd_no            giis_assured.assd_no%TYPE,
      p_session_id         gicl_loss_ratio_ext.session_id%TYPE,
      p_loss_date          gicl_claims.loss_date%TYPE,
      p_counter      OUT   NUMBER,
      p_ext_proc           VARCHAR2,
      p_user_id            giis_users.user_id%TYPE,
      p_date               gipi_polbasic.issue_date%TYPE -- Dren Niebres 07.12.2016 SR-21428
   )
   AS
      v_exists          VARCHAR2 (1);
      v_line_cd         giis_line.line_cd%TYPE;                                                                                                                                       --Jerome 08042005
      v_ast             VARCHAR2 (1)                             := '*';                                                                                                              --Jerome 08042005
      v_prev_prem_res   gicl_loss_ratio_ext.prev_prem_amt%TYPE;
      v_curr_prem_res   gicl_loss_ratio_ext.prev_prem_amt%TYPE;
   BEGIN
      p_counter := 0;

      FOR curr_prem IN (SELECT   intm_no, NVL (SUM (prem_amt), 0) prem
                            FROM gicl_lratio_curr_prem_ext
                           WHERE session_id = p_session_id 
                             AND (line_cd, iss_cd) IN (
                                                   SELECT line_cd, branch_cd
                                                     FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                   )
                             --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                       --angelo092507
                        GROUP BY intm_no)
      LOOP
         INSERT INTO gicl_loss_ratio_ext
                     (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, curr_prem_amt, user_id
                     )
              VALUES (p_session_id, p_line_cd, p_subline_cd, p_iss_cd, p_peril_cd, p_loss_date, p_assd_no, curr_prem.intm_no, curr_prem.prem, p_user_id
                     );

         p_counter := p_counter + 1;
      END LOOP;

      --previous pemium
      FOR prev_prem IN (SELECT   intm_no, NVL (SUM (prem_amt), 0) prem
                            FROM gicl_lratio_prev_prem_ext
                           WHERE session_id = p_session_id 
                             AND (line_cd, iss_cd) IN (
                                                   SELECT line_cd, branch_cd
                                                     FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                   )
                             --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                        --angelo092507
                        GROUP BY intm_no)
      LOOP
         v_exists := 'N';

         FOR chk_exists IN (SELECT '1'
                              FROM gicl_loss_ratio_ext
                             WHERE session_id = p_session_id 
                               AND (line_cd, iss_cd) IN (
                                                   SELECT line_cd, branch_cd
                                                     FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                   )
                               --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                     --angelo092507
                                   AND intm_no = prev_prem.intm_no)
         LOOP
            UPDATE gicl_loss_ratio_ext
               SET prev_prem_amt = NVL (prev_prem_amt, 0) + prev_prem.prem
             WHERE session_id = p_session_id AND intm_no = prev_prem.intm_no;

            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N' THEN
            p_counter := p_counter + 1;

            INSERT INTO gicl_loss_ratio_ext
                        (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, prev_prem_amt, user_id
                        )
                 VALUES (p_session_id, p_line_cd, p_subline_cd, p_iss_cd, p_peril_cd, p_loss_date, p_assd_no, prev_prem.intm_no, prev_prem.prem, p_user_id
                        );
         END IF;
      END LOOP;

      --current loss
      FOR curr_loss IN (SELECT   intm_no, NVL (SUM (os_amt), 0) loss
                            FROM gicl_lratio_curr_os_ext
                           WHERE session_id = p_session_id 
                             AND (line_cd, iss_cd) IN (
                                                   SELECT line_cd, branch_cd
                                                     FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                   )
                             --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                        --angelo092507
                        GROUP BY intm_no)
      LOOP
         v_exists := 'N';

         FOR chk_exists IN (SELECT '1'
                              FROM gicl_loss_ratio_ext
                             WHERE session_id = p_session_id 
                               AND (line_cd, iss_cd) IN (
                                                   SELECT line_cd, branch_cd
                                                     FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                   )
                               --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                     --angelo092507
                                   AND intm_no = curr_loss.intm_no)
         LOOP
            UPDATE gicl_loss_ratio_ext
               SET curr_loss_res = NVL (curr_loss_res, 0) + curr_loss.loss
             WHERE session_id = p_session_id AND intm_no = curr_loss.intm_no;

            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N' THEN
            p_counter := p_counter + 1;

            INSERT INTO gicl_loss_ratio_ext
                        (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, curr_loss_res, user_id
                        )
                 VALUES (p_session_id, p_line_cd, p_subline_cd, p_iss_cd, p_peril_cd, p_loss_date, p_assd_no, curr_loss.intm_no, curr_loss.loss, p_user_id
                        );
         END IF;
      END LOOP;

      --previous loss
      FOR prev_loss IN (SELECT   intm_no, NVL (SUM (os_amt), 0) loss
                            FROM gicl_lratio_prev_os_ext
                           WHERE session_id = p_session_id 
                             AND (line_cd, iss_cd) IN (
                                                   SELECT line_cd, branch_cd
                                                     FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                   )
                             --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                        --angelo092507
                        GROUP BY intm_no)
      LOOP
         v_exists := 'N';

         FOR chk_exists IN (SELECT '1'
                              FROM gicl_loss_ratio_ext
                             WHERE session_id = p_session_id 
                               AND (line_cd, iss_cd) IN (
                                                   SELECT line_cd, branch_cd
                                                     FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                   )
                               --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                     --angelo092507
                                   AND intm_no = prev_loss.intm_no)
         LOOP
            UPDATE gicl_loss_ratio_ext
               SET prev_loss_res = NVL (prev_loss_res, 0) + prev_loss.loss
             WHERE session_id = p_session_id AND intm_no = prev_loss.intm_no;

            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N' THEN
            p_counter := p_counter + 1;

            INSERT INTO gicl_loss_ratio_ext
                        (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, prev_loss_res, user_id
                        )
                 VALUES (p_session_id, p_line_cd, p_subline_cd, p_iss_cd, p_peril_cd, p_loss_date, p_assd_no, prev_loss.intm_no, prev_loss.loss, p_user_id
                        );
         END IF;
      END LOOP;

      --losses paid
      FOR losses IN (SELECT   intm_no, NVL (SUM (loss_paid), 0) loss_paid
                         FROM gicl_lratio_loss_paid_ext
                        WHERE session_id = p_session_id 
                          AND (line_cd, iss_cd) IN (
                                                   SELECT line_cd, branch_cd
                                                     FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                   )
                          --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                           --angelo092507
                     GROUP BY intm_no)
      LOOP
         v_exists := 'N';

         FOR chk_exists IN (SELECT '1'
                              FROM gicl_loss_ratio_ext
                             WHERE session_id = p_session_id 
                               AND (line_cd, iss_cd) IN (
                                                   SELECT line_cd, branch_cd
                                                     FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                   )
                               --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                     --angelo092507
                                   AND intm_no = losses.intm_no)
         LOOP
            UPDATE gicl_loss_ratio_ext
               SET loss_paid_amt = NVL (loss_paid_amt, 0) + losses.loss_paid
             WHERE session_id = p_session_id AND intm_no = losses.intm_no;

            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N' THEN
            p_counter := p_counter + 1;

            INSERT INTO gicl_loss_ratio_ext
                        (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, loss_paid_amt, user_id
                        )
                 VALUES (p_session_id, p_line_cd, p_subline_cd, p_iss_cd, p_peril_cd, p_loss_date, p_assd_no, losses.intm_no, losses.loss_paid, p_user_id
                        );
         END IF;
      END LOOP;

      --current recovery
      FOR curr_rec IN (SELECT   intm_no, NVL (SUM (recovered_amt), 0) RECOVERY
                           FROM gicl_lratio_curr_recovery_ext
                          WHERE session_id = p_session_id 
                             AND (line_cd, iss_cd) IN (
                                                   SELECT line_cd, branch_cd
                                                     FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                   )                            
                            --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                         --angelo092507
                       GROUP BY intm_no)
      LOOP
         v_exists := 'N';

         FOR chk_exists IN (SELECT '1'
                              FROM gicl_loss_ratio_ext
                             WHERE session_id = p_session_id 
                               AND (line_cd, iss_cd) IN (
                                                   SELECT line_cd, branch_cd
                                                     FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                   )
                               --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                     --angelo092507
                                   AND intm_no = curr_rec.intm_no)
         LOOP
            UPDATE gicl_loss_ratio_ext
               SET curr_loss_res = NVL (curr_loss_res, 0) - curr_rec.RECOVERY
             WHERE session_id = p_session_id AND intm_no = curr_rec.intm_no;

            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N' THEN
            p_counter := p_counter + 1;

            INSERT INTO gicl_loss_ratio_ext
                        (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, curr_loss_res, user_id
                        )
                 VALUES (p_session_id, p_line_cd, p_subline_cd, p_iss_cd, p_peril_cd, p_loss_date, p_assd_no, curr_rec.intm_no, -curr_rec.RECOVERY, p_user_id
                        );
         END IF;
      END LOOP;

      --current recovery
      FOR prev_rec IN (SELECT   intm_no, NVL (SUM (recovered_amt), 0) RECOVERY
                           FROM gicl_lratio_prev_recovery_ext
                          WHERE session_id = p_session_id 
                            AND (line_cd, iss_cd) IN (
                                                   SELECT line_cd, branch_cd
                                                     FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                   )
                            --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                         --angelo092507
                       GROUP BY intm_no)
      LOOP
         v_exists := 'N';

         FOR chk_exists IN (SELECT '1'
                              FROM gicl_loss_ratio_ext
                             WHERE session_id = p_session_id AND intm_no = prev_rec.intm_no)
         LOOP
            UPDATE gicl_loss_ratio_ext
               SET prev_loss_res = NVL (prev_loss_res, 0) - prev_rec.RECOVERY
             WHERE session_id = p_session_id AND intm_no = prev_rec.intm_no;

            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N' THEN
            p_counter := p_counter + 1;

            INSERT INTO gicl_loss_ratio_ext
                        (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, prev_loss_res, user_id
                        )
                 VALUES (p_session_id, p_line_cd, p_subline_cd, p_iss_cd, p_peril_cd, p_loss_date, p_assd_no, prev_rec.intm_no, -prev_rec.RECOVERY, p_user_id
                        );
         END IF;
      END LOOP;

      FOR prem_res IN (SELECT intm_no, prev_prem_amt, curr_prem_amt
                         FROM gicl_loss_ratio_ext
                        WHERE session_id = p_session_id 
                          AND (line_cd, iss_cd) IN (
                                                   SELECT line_cd, branch_cd
                                                     FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                   )
                          --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                           --angelo092507
                                                                                                                               )
      LOOP
         v_prev_prem_res := 0;
         v_curr_prem_res := 0;

         IF p_ext_proc = 'S' THEN
            v_prev_prem_res := NVL (prem_res.prev_prem_amt, 0) * .4;
            v_curr_prem_res := NVL (prem_res.curr_prem_amt, 0) * .4;
         ELSE
            FOR c IN (SELECT param_value_v
                        FROM giis_parameters
                       WHERE param_name = 'LINE_CODE_MN')
            LOOP
               v_line_cd := c.param_value_v;
               EXIT;
            END LOOP;

            IF NVL (prem_res.curr_prem_amt, 0) <> 0 THEN
               IF NVL (p_line_cd, v_line_cd) = v_line_cd THEN                                                                                                                         --Jerome 08052005
                  FOR curr_prem IN (SELECT   intm_no, ROUND (SUM (prem * factor), 2) prem
                                        FROM (SELECT   b.intm_no, NVL (SUM (b.prem_amt), 0) prem, factor
                                                  FROM gicl_24th_tab_mn a, gicl_lratio_curr_prem_ext b, gipi_polbasic c
                                                 WHERE 1 = 1
                                                   AND col_mm = TO_NUMBER (TO_CHAR (date_for_24th, 'MM'), 99)
                                                   AND a.session_id = p_session_id
                                                   AND a.session_id = b.session_id
                                                   AND (b.line_cd, b.iss_cd) IN (
                                                                       SELECT line_cd, branch_cd
                                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                                       )
                                                   --AND check_user_per_iss_cd2 (b.line_cd, b.iss_cd, 'GICLS204', p_user_id) = 1                                                            --angelo092507
                                                   AND b.intm_no = prem_res.intm_no
                                                   AND b.line_cd = v_line_cd
                                                   AND b.policy_id = c.policy_id
                                                   AND c.expiry_date > p_date -- Dren Niebres 07.12.2016 SR-21428                                                      
                                              GROUP BY b.intm_no, factor)
                                    GROUP BY intm_no)
                  LOOP
                     v_curr_prem_res := v_curr_prem_res + NVL (curr_prem.prem, 0);
                  END LOOP;
               END IF;

               IF NVL (p_line_cd, v_line_cd) <> v_line_cd THEN
                  FOR curr_prem IN (SELECT   intm_no, ROUND (SUM (prem * factor), 2) prem
                                        FROM (SELECT   b.intm_no, NVL (SUM (b.prem_amt), 0) prem, factor
                                                  FROM gicl_24th_tab a, gicl_lratio_curr_prem_ext b, gipi_polbasic c
                                                 WHERE 1 = 1
                                                   AND col_mm = TO_NUMBER (TO_CHAR (date_for_24th, 'MM'), 99)
                                                   AND a.session_id = p_session_id
                                                   AND a.session_id = b.session_id
                                                   AND (b.line_cd, b.iss_cd) IN (
                                                                       SELECT line_cd, branch_cd
                                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                                       )
                                                   --AND check_user_per_iss_cd2 (b.line_cd, b.iss_cd, 'GICLS204', p_user_id) = 1                                                            --angelo092507
                                                   AND b.intm_no = prem_res.intm_no
                                                   AND b.line_cd <> v_line_cd
                                                   AND b.policy_id = c.policy_id
                                                   AND c.expiry_date > p_date -- Dren Niebres 07.12.2016 SR-21428                                                   
                                              GROUP BY b.intm_no, factor)
                                    GROUP BY intm_no)
                  LOOP
                     v_curr_prem_res := v_curr_prem_res + NVL (curr_prem.prem, 0);
                  END LOOP;
               END IF;
            END IF;
         END IF;

         IF NVL (prem_res.curr_prem_amt, 0) <> 0 THEN
            IF NVL (p_line_cd, v_line_cd) = v_line_cd THEN                                                                                                                            --Jerome 08052005
               FOR prev_prem IN (SELECT   intm_no, ROUND (SUM (prem * factor), 2) prem
                                     FROM (SELECT   intm_no, NVL (SUM (prem_amt), 0) prem, factor
                                               FROM gicl_24th_tab_mn a, gicl_lratio_prev_prem_ext b
                                              WHERE 1 = 1
                                                AND col_mm = TO_NUMBER (TO_CHAR (date_for_24th, 'MM'), 99)
                                                AND a.session_id = p_session_id
                                                AND a.session_id = b.session_id
                                                AND (b.line_cd, b.iss_cd) IN (
                                                                       SELECT line_cd, branch_cd
                                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                                       )
                                                --AND check_user_per_iss_cd2 (b.line_cd, b.iss_cd, 'GICLS204', p_user_id) = 1                                                               --angelo092507
                                                AND intm_no = prem_res.intm_no
                                                AND b.line_cd = v_line_cd
                                           GROUP BY intm_no, factor)
                                 GROUP BY intm_no)
               LOOP
                  v_prev_prem_res := v_prev_prem_res + NVL (prev_prem.prem, 0);
               END LOOP;
            END IF;

            IF NVL (p_line_cd, v_line_cd) <> v_line_cd THEN
               FOR prev_prem IN (SELECT   intm_no, ROUND (SUM (prem * factor), 2) prem
                                     FROM (SELECT   intm_no, NVL (SUM (prem_amt), 0) prem, factor
                                               FROM gicl_24th_tab a, gicl_lratio_prev_prem_ext b
                                              WHERE 1 = 1
                                                AND col_mm = TO_NUMBER (TO_CHAR (date_for_24th, 'MM'), 99)
                                                AND a.session_id = p_session_id
                                                AND a.session_id = b.session_id
                                                AND (b.line_cd, b.iss_cd) IN (
                                                                           SELECT line_cd, branch_cd
                                                                             FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                                           )
                                                --AND check_user_per_iss_cd2 (b.line_cd, b.iss_cd, 'GICLS204', p_user_id) = 1                                                               --angelo092507
                                                AND intm_no = prem_res.intm_no
                                                AND b.line_cd <> v_line_cd
                                           GROUP BY intm_no, factor)
                                 GROUP BY intm_no)
               LOOP
                  v_prev_prem_res := v_prev_prem_res + NVL (prev_prem.prem, 0);
               END LOOP;
            END IF;
         END IF;

         UPDATE gicl_loss_ratio_ext
            SET prev_prem_res = v_prev_prem_res,
                curr_prem_res = v_curr_prem_res
          WHERE session_id = p_session_id AND intm_no = prem_res.intm_no;
      END LOOP;
   END;

   PROCEDURE lratio_extract_by_assured (
      p_line_cd            giis_line.line_cd%TYPE,
      p_subline_cd         giis_subline.subline_cd%TYPE,
      p_iss_cd             giis_issource.iss_cd%TYPE,
      p_peril_cd           giis_peril.peril_cd%TYPE,
      p_intm_no            giis_intermediary.intm_no%TYPE,
      p_session_id         gicl_loss_ratio_ext.session_id%TYPE,
      p_loss_date          gicl_claims.loss_date%TYPE,
      p_counter      OUT   NUMBER,
      p_ext_proc           VARCHAR2,
      p_user_id            giis_users.user_id%TYPE,
      p_date               gipi_polbasic.issue_date%TYPE -- Dren Niebres 07.12.2016 SR-21428
   )
   AS
      v_exists          VARCHAR2 (1);
      v_line_cd         giis_line.line_cd%TYPE;                                                                                                                                        --Jerom 08032005
      v_ast             VARCHAR2 (1)                             := '*';                                                                                                              --Jerome 08042005
      v_prev_prem_res   gicl_loss_ratio_ext.prev_prem_amt%TYPE;
      v_curr_prem_res   gicl_loss_ratio_ext.prev_prem_amt%TYPE;
   BEGIN
      p_counter := 0;

      FOR curr_prem IN (SELECT   assd_no, NVL (SUM (prem_amt), 0) prem
                            FROM gicl_lratio_curr_prem_ext
                           WHERE session_id = p_session_id 
                             AND (line_cd, iss_cd) IN (
                                                       SELECT line_cd, branch_cd
                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                       )
                             --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                       --angelo092507
                        GROUP BY assd_no)
      LOOP
         INSERT INTO gicl_loss_ratio_ext
                     (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, curr_prem_amt, user_id
                     )
              VALUES (p_session_id, p_line_cd, p_subline_cd, p_iss_cd, p_peril_cd, p_loss_date, curr_prem.assd_no, p_intm_no, curr_prem.prem, p_user_id
                     );

         p_counter := p_counter + 1;
      END LOOP;

      --previous pemium
      FOR prev_prem IN (SELECT   assd_no, NVL (SUM (prem_amt), 0) prem
                            FROM gicl_lratio_prev_prem_ext
                           WHERE session_id = p_session_id 
                             AND (line_cd, iss_cd) IN (
                                                       SELECT line_cd, branch_cd
                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                       )
                             --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                        --angelo092507
                        GROUP BY assd_no)
      LOOP
         v_exists := 'N';

         FOR chk_exists IN (SELECT '1'
                              FROM gicl_loss_ratio_ext
                             WHERE session_id = p_session_id 
                               AND (line_cd, iss_cd) IN (
                                                       SELECT line_cd, branch_cd
                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                       )
                               --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                     --angelo092507
                                   AND assd_no = prev_prem.assd_no)
         LOOP
            UPDATE gicl_loss_ratio_ext
               SET prev_prem_amt = NVL (prev_prem_amt, 0) + prev_prem.prem
             WHERE session_id = p_session_id AND assd_no = prev_prem.assd_no;

            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N' THEN
            p_counter := p_counter + 1;

            INSERT INTO gicl_loss_ratio_ext
                        (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, prev_prem_amt, user_id
                        )
                 VALUES (p_session_id, p_line_cd, p_subline_cd, p_iss_cd, p_peril_cd, p_loss_date, prev_prem.assd_no, p_intm_no, prev_prem.prem, p_user_id
                        );
         END IF;
      END LOOP;

      --current loss
      FOR curr_loss IN (SELECT   assd_no, NVL (SUM (os_amt), 0) loss
                            FROM gicl_lratio_curr_os_ext
                           WHERE session_id = p_session_id 
                             AND (line_cd, iss_cd) IN (
                                                       SELECT line_cd, branch_cd
                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                       )
                             --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                        --angelo092507
                        GROUP BY assd_no)
      LOOP
         v_exists := 'N';

         FOR chk_exists IN (SELECT '1'
                              FROM gicl_loss_ratio_ext
                             WHERE session_id = p_session_id 
                               AND (line_cd, iss_cd) IN (
                                                       SELECT line_cd, branch_cd
                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                       )
                               --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                     --angelo092507
                                   AND assd_no = curr_loss.assd_no)
         LOOP
            UPDATE gicl_loss_ratio_ext
               SET curr_loss_res = NVL (curr_loss_res, 0) + curr_loss.loss
             WHERE session_id = p_session_id AND assd_no = curr_loss.assd_no;

            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N' THEN
            p_counter := p_counter + 1;

            INSERT INTO gicl_loss_ratio_ext
                        (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, curr_loss_res, user_id
                        )
                 VALUES (p_session_id, p_line_cd, p_subline_cd, p_iss_cd, p_peril_cd, p_loss_date, curr_loss.assd_no, p_intm_no, curr_loss.loss, p_user_id
                        );
         END IF;
      END LOOP;

      --previous loss
      FOR prev_loss IN (SELECT   assd_no, NVL (SUM (os_amt), 0) loss
                            FROM gicl_lratio_prev_os_ext
                           WHERE session_id = p_session_id 
                             AND (line_cd, iss_cd) IN (
                                                       SELECT line_cd, branch_cd
                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                       )
                             --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                        --angelo092507
                        GROUP BY assd_no)
      LOOP
         v_exists := 'N';

         FOR chk_exists IN (SELECT '1'
                              FROM gicl_loss_ratio_ext
                             WHERE session_id = p_session_id 
                               AND (line_cd, iss_cd) IN (
                                                       SELECT line_cd, branch_cd
                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                       )
                               --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                     --angelo092507
                                   AND assd_no = prev_loss.assd_no)
         LOOP
            UPDATE gicl_loss_ratio_ext
               SET prev_loss_res = NVL (prev_loss_res, 0) + prev_loss.loss
             WHERE session_id = p_session_id AND assd_no = prev_loss.assd_no;

            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N' THEN
            p_counter := p_counter + 1;

            INSERT INTO gicl_loss_ratio_ext
                        (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, prev_loss_res, user_id
                        )
                 VALUES (p_session_id, p_line_cd, p_subline_cd, p_iss_cd, p_peril_cd, p_loss_date, prev_loss.assd_no, p_intm_no, prev_loss.loss, p_user_id
                        );
         END IF;
      END LOOP;

      --losses paid
      FOR losses IN (SELECT   assd_no, NVL (SUM (loss_paid), 0) loss_paid
                         FROM gicl_lratio_loss_paid_ext
                        WHERE session_id = p_session_id 
                          AND (line_cd, iss_cd) IN (
                                                       SELECT line_cd, branch_cd
                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                       )
                          --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                           --angelo092507
                     GROUP BY assd_no)
      LOOP
         v_exists := 'N';

         FOR chk_exists IN (SELECT '1'
                              FROM gicl_loss_ratio_ext
                             WHERE session_id = p_session_id 
                               AND (line_cd, iss_cd) IN (
                                                       SELECT line_cd, branch_cd
                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                       )
                               --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                     --angelo092507
                                   AND assd_no = losses.assd_no)
         LOOP
            UPDATE gicl_loss_ratio_ext
               SET loss_paid_amt = NVL (loss_paid_amt, 0) + losses.loss_paid
             WHERE session_id = p_session_id AND assd_no = losses.assd_no;

            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N' THEN
            p_counter := p_counter + 1;

            INSERT INTO gicl_loss_ratio_ext
                        (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, loss_paid_amt, user_id
                        )
                 VALUES (p_session_id, p_line_cd, p_subline_cd, p_iss_cd, p_peril_cd, p_loss_date, losses.assd_no, p_intm_no, losses.loss_paid, p_user_id
                        );
         END IF;
      END LOOP;

      --current recovery
      FOR curr_rec IN (SELECT   assd_no, NVL (SUM (recovered_amt), 0) RECOVERY
                           FROM gicl_lratio_curr_recovery_ext
                          WHERE session_id = p_session_id 
                            AND (line_cd, iss_cd) IN (
                                                       SELECT line_cd, branch_cd
                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                       )
                            --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                         --angelo092507
                       GROUP BY assd_no)
      LOOP
         v_exists := 'N';

         FOR chk_exists IN (SELECT '1'
                              FROM gicl_loss_ratio_ext
                             WHERE session_id = p_session_id 
                               AND (line_cd, iss_cd) IN (
                                                       SELECT line_cd, branch_cd
                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                       )
                               --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                     --angelo092507
                                   AND assd_no = curr_rec.assd_no)
         LOOP
            UPDATE gicl_loss_ratio_ext
               SET curr_loss_res = NVL (curr_loss_res, 0) - curr_rec.RECOVERY
             WHERE session_id = p_session_id AND assd_no = curr_rec.assd_no;

            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N' THEN
            p_counter := p_counter + 1;

            INSERT INTO gicl_loss_ratio_ext
                        (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, curr_loss_res, user_id
                        )
                 VALUES (p_session_id, p_line_cd, p_subline_cd, p_iss_cd, p_peril_cd, p_loss_date, curr_rec.assd_no, p_intm_no, -curr_rec.RECOVERY, p_user_id
                        );
         END IF;
      END LOOP;

      --current recovery
      FOR prev_rec IN (SELECT   assd_no, NVL (SUM (recovered_amt), 0) RECOVERY
                           FROM gicl_lratio_prev_recovery_ext
                          WHERE session_id = p_session_id 
                            AND (line_cd, iss_cd) IN (
                                                       SELECT line_cd, branch_cd
                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                       )
                            --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                         --angelo092507
                       GROUP BY assd_no)
      LOOP
         v_exists := 'N';

         FOR chk_exists IN (SELECT '1'
                              FROM gicl_loss_ratio_ext
                             WHERE session_id = p_session_id 
                               AND (line_cd, iss_cd) IN (
                                                       SELECT line_cd, branch_cd
                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                       )
                               --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                     --angelo092507
                                   AND assd_no = prev_rec.assd_no)
         LOOP
            UPDATE gicl_loss_ratio_ext
               SET prev_loss_res = NVL (prev_loss_res, 0) - prev_rec.RECOVERY
             WHERE session_id = p_session_id AND assd_no = prev_rec.assd_no;

            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N' THEN
            p_counter := p_counter + 1;

            INSERT INTO gicl_loss_ratio_ext
                        (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, prev_loss_res, user_id
                        )
                 VALUES (p_session_id, p_line_cd, p_subline_cd, p_iss_cd, p_peril_cd, p_loss_date, prev_rec.assd_no, p_intm_no, -prev_rec.RECOVERY, p_user_id
                        );
         END IF;
      END LOOP;

      FOR prem_res IN (SELECT assd_no, prev_prem_amt, curr_prem_amt
                         FROM gicl_loss_ratio_ext
                        WHERE session_id = p_session_id 
                          AND (line_cd, iss_cd) IN (
                                                   SELECT line_cd, branch_cd
                                                     FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                   )                      
                            --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                           --angelo092507
                      )
      LOOP
         v_prev_prem_res := 0;
         v_curr_prem_res := 0;

         IF p_ext_proc = 'S' THEN
            v_prev_prem_res := NVL (prem_res.prev_prem_amt, 0) * .4;
            v_curr_prem_res := NVL (prem_res.curr_prem_amt, 0) * .4;
         ELSE
            FOR c IN (SELECT param_value_v
                        FROM giis_parameters
                       WHERE param_name = 'LINE_CODE_MN')
            LOOP
               v_line_cd := c.param_value_v;
               EXIT;
            END LOOP;

            IF NVL (prem_res.curr_prem_amt, 0) <> 0 THEN
               IF NVL (p_line_cd, v_line_cd) = v_line_cd THEN                                                                                   --Jerome 08052005 handling current years premium for MN
                  FOR curr_prem IN (SELECT   assd_no, ROUND (SUM (prem * factor), 2) prem
                                        FROM (SELECT   b.assd_no, NVL (SUM (b.prem_amt), 0) prem, factor
                                                  FROM gicl_24th_tab_mn a, gicl_lratio_curr_prem_ext b, gipi_polbasic c
                                                 WHERE 1 = 1
                                                   AND col_mm = TO_NUMBER (TO_CHAR (date_for_24th, 'MM'), 99)
                                                   AND a.session_id = p_session_id
                                                   AND a.session_id = b.session_id
                                                   AND (b.line_cd, b.iss_cd) IN (
                                                                           SELECT line_cd, branch_cd
                                                                             FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                                           )
                                                   --AND check_user_per_iss_cd2 (b.line_cd, b.iss_cd, 'GICLS204', p_user_id) = 1                                                            --angelo092507
                                                   AND b.line_cd = v_line_cd
                                                   AND b.assd_no = prem_res.assd_no
                                                   AND b.policy_id = c.policy_id
                                                   AND c.expiry_date > p_date -- Dren Niebres 07.12.2016 SR-21428                                                      
                                              GROUP BY b.assd_no, factor)
                                    GROUP BY assd_no)
                  LOOP
                     v_curr_prem_res := v_curr_prem_res + NVL (curr_prem.prem, 0);
                  END LOOP;
               END IF;

               IF NVL (p_line_cd, v_ast) <> v_line_cd THEN
                  FOR curr_prem IN (SELECT   assd_no, ROUND (SUM (prem * factor), 2) prem
                                        FROM (SELECT   b.assd_no, NVL (SUM (b.prem_amt), 0) prem, factor
                                                  FROM gicl_24th_tab a, gicl_lratio_curr_prem_ext b, gipi_polbasic c
                                                 WHERE 1 = 1
                                                   AND col_mm = TO_NUMBER (TO_CHAR (date_for_24th, 'MM'), 99)
                                                   AND a.session_id = p_session_id
                                                   AND a.session_id = b.session_id
                                                   AND (b.line_cd, b.iss_cd) IN (
                                                                           SELECT line_cd, branch_cd
                                                                             FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                                           )
                                                   --AND check_user_per_iss_cd2 (b.line_cd, b.iss_cd, 'GICLS204', p_user_id) = 1                                                            --angelo092507
                                                   AND b.line_cd <> v_line_cd
                                                   AND b.assd_no = prem_res.assd_no
                                                   AND b.policy_id = c.policy_id
                                                   AND c.expiry_date > p_date -- Dren Niebres 07.12.2016 SR-21428                                                       
                                              GROUP BY b.assd_no, factor)
                                    GROUP BY assd_no)
                  LOOP
                     v_curr_prem_res := v_curr_prem_res + NVL (curr_prem.prem, 0);
                  END LOOP;
               END IF;
            END IF;
         END IF;

         IF NVL (prem_res.prev_prem_amt, 0) <> 0 THEN
            IF NVL (p_line_cd, v_line_cd) = v_line_cd THEN                                                                                      --Jerome 08052005 handling current years premium for MN
               FOR prev_prem IN (SELECT   assd_no, ROUND (SUM (prem * factor), 2) prem
                                     FROM (SELECT   assd_no, NVL (SUM (prem_amt), 0) prem, factor
                                               FROM gicl_24th_tab_mn a, gicl_lratio_prev_prem_ext b
                                              WHERE 1 = 1
                                                AND col_mm = TO_NUMBER (TO_CHAR (date_for_24th, 'MM'), 99)
                                                AND a.session_id = p_session_id
                                                AND a.session_id = b.session_id
                                                AND (line_cd, iss_cd) IN (
                                                                           SELECT line_cd, branch_cd
                                                                             FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                                           )
                                                --AND check_user_per_iss_cd2 (b.line_cd, b.iss_cd, 'GICLS204', p_user_id) = 1                                                               --angelo092507
                                                AND b.line_cd = v_line_cd
                                                AND assd_no = prem_res.assd_no
                                           GROUP BY assd_no, factor)
                                 GROUP BY assd_no)
               LOOP
                  v_prev_prem_res := v_prev_prem_res + NVL (prev_prem.prem, 0);
               END LOOP;
            END IF;

            IF NVL (p_line_cd, v_ast) <> v_line_cd THEN
               FOR prev_prem IN (SELECT   assd_no, ROUND (SUM (prem * factor), 2) prem
                                     FROM (SELECT   assd_no, NVL (SUM (prem_amt), 0) prem, factor
                                               FROM gicl_24th_tab a, gicl_lratio_prev_prem_ext b
                                              WHERE 1 = 1
                                                AND col_mm = TO_NUMBER (TO_CHAR (date_for_24th, 'MM'), 99)
                                                AND a.session_id = p_session_id
                                                AND a.session_id = b.session_id
                                                AND (line_cd, iss_cd) IN (
                                                                           SELECT line_cd, branch_cd
                                                                             FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                                           )
                                                --AND check_user_per_iss_cd2 (b.line_cd, b.iss_cd, 'GICLS204', p_user_id) = 1                                                               --angelo092507
                                                AND b.line_cd <> v_line_cd
                                                AND assd_no = prem_res.assd_no
                                           GROUP BY assd_no, factor)
                                 GROUP BY assd_no)
               LOOP
                  v_prev_prem_res := v_prev_prem_res + NVL (prev_prem.prem, 0);
               END LOOP;
            END IF;
         END IF;

         UPDATE gicl_loss_ratio_ext
            SET prev_prem_res = v_prev_prem_res,
                curr_prem_res = v_curr_prem_res
          WHERE session_id = p_session_id AND assd_no = prem_res.assd_no;
      END LOOP;
   END;

   PROCEDURE lratio_extract_by_peril (
      p_line_cd            giis_line.line_cd%TYPE,
      p_subline_cd         giis_subline.subline_cd%TYPE,
      p_iss_cd             giis_issource.iss_cd%TYPE,
      p_intm_no            giis_intermediary.intm_no%TYPE,
      p_assd_no            giis_assured.assd_no%TYPE,
      p_session_id         gicl_loss_ratio_ext.session_id%TYPE,
      p_loss_date          gicl_claims.loss_date%TYPE,
      p_counter      OUT   NUMBER,
      p_ext_proc           VARCHAR2,
      p_user_id            giis_users.user_id%TYPE,
      p_date               gipi_polbasic.issue_date%TYPE -- Dren Niebres 07.12.2016 SR-21428
   )
   AS
      v_exists          VARCHAR2 (1);
      v_line_cd         giis_line.line_cd%TYPE;                                                                                                                                       --Jerome 08042005
      v_ast             VARCHAR2 (1)                             := '*';                                                                                                              --Jerome 08042005
      v_prev_prem_res   gicl_loss_ratio_ext.prev_prem_amt%TYPE;
      v_curr_prem_res   gicl_loss_ratio_ext.prev_prem_amt%TYPE;
   BEGIN
      p_counter := 0;

      FOR curr_prem IN (SELECT   peril_cd, NVL (SUM (prem_amt), 0) prem
                            FROM gicl_lratio_curr_prem_ext
                           WHERE session_id = p_session_id 
                             AND (line_cd, iss_cd) IN (
                                                       SELECT line_cd, branch_cd
                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                       )
                             --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                       --angelo092507
                        GROUP BY peril_cd)
      LOOP
         INSERT INTO gicl_loss_ratio_ext
                     (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, curr_prem_amt, user_id
                     )
              VALUES (p_session_id, p_line_cd, p_subline_cd, p_iss_cd, curr_prem.peril_cd, p_loss_date, p_assd_no, p_intm_no, curr_prem.prem, p_user_id
                     );

         p_counter := p_counter + 1;
      END LOOP;

      FOR prev_prem IN (SELECT   peril_cd, NVL (SUM (prem_amt), 0) prem
                            FROM gicl_lratio_prev_prem_ext
                           WHERE session_id = p_session_id 
                             AND (line_cd, iss_cd) IN (
                                                       SELECT line_cd, branch_cd
                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                       )
                             --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                        --angelo092507
                        GROUP BY peril_cd)
      LOOP
         v_exists := 'N';

         FOR chk_exists IN (SELECT '1'
                              FROM gicl_loss_ratio_ext
                             WHERE session_id = p_session_id 
                               AND (line_cd, iss_cd) IN (
                                                       SELECT line_cd, branch_cd
                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                       )
                               --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                     --angelo092507
                                   AND peril_cd = prev_prem.peril_cd)
         LOOP
            UPDATE gicl_loss_ratio_ext
               SET prev_prem_amt = NVL (prev_prem_amt, 0) + prev_prem.prem
             WHERE session_id = p_session_id AND peril_cd = prev_prem.peril_cd;

            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N' THEN
            p_counter := p_counter + 1;

            INSERT INTO gicl_loss_ratio_ext
                        (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, prev_prem_amt, user_id
                        )
                 VALUES (p_session_id, p_line_cd, p_subline_cd, p_iss_cd, prev_prem.peril_cd, p_loss_date, p_assd_no, p_intm_no, prev_prem.prem, p_user_id
                        );
         END IF;
      END LOOP;

      --current loss
      FOR curr_loss IN (SELECT   peril_cd, NVL (SUM (os_amt), 0) loss
                            FROM gicl_lratio_curr_os_ext
                           WHERE session_id = p_session_id 
                             AND (line_cd, iss_cd) IN (
                                                       SELECT line_cd, branch_cd
                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                       )
                             --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                        --angelo092507
                        GROUP BY peril_cd)
      LOOP
         v_exists := 'N';

         FOR chk_exists IN (SELECT '1'
                              FROM gicl_loss_ratio_ext
                             WHERE session_id = p_session_id 
                               AND (line_cd, iss_cd) IN (
                                                       SELECT line_cd, branch_cd
                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                       )
                               --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                     --angelo092507
                                   AND peril_cd = curr_loss.peril_cd)
         LOOP
            UPDATE gicl_loss_ratio_ext
               SET curr_loss_res = NVL (curr_loss_res, 0) + curr_loss.loss
             WHERE session_id = p_session_id AND peril_cd = curr_loss.peril_cd;

            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N' THEN
            p_counter := p_counter + 1;

            INSERT INTO gicl_loss_ratio_ext
                        (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, curr_loss_res, user_id
                        )
                 VALUES (p_session_id, p_line_cd, p_subline_cd, p_iss_cd, curr_loss.peril_cd, p_loss_date, p_assd_no, p_intm_no, curr_loss.loss, p_user_id
                        );
         END IF;
      END LOOP;

      --previous loss
      FOR prev_loss IN (SELECT   peril_cd, NVL (SUM (os_amt), 0) loss
                            FROM gicl_lratio_prev_os_ext
                           WHERE session_id = p_session_id 
                             AND (line_cd, iss_cd) IN (
                                                       SELECT line_cd, branch_cd
                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                       )
                             --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                        --angelo092507
                        GROUP BY peril_cd)
      LOOP
         v_exists := 'N';

         FOR chk_exists IN (SELECT '1'
                              FROM gicl_loss_ratio_ext
                             WHERE session_id = p_session_id 
                               AND (line_cd, iss_cd) IN (
                                                       SELECT line_cd, branch_cd
                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                       )
                               --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                     --angelo092507
                                   AND peril_cd = prev_loss.peril_cd)
         LOOP
            UPDATE gicl_loss_ratio_ext
               SET prev_loss_res = NVL (prev_loss_res, 0) + prev_loss.loss
             WHERE session_id = p_session_id AND peril_cd = prev_loss.peril_cd;

            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N' THEN
            p_counter := p_counter + 1;

            INSERT INTO gicl_loss_ratio_ext
                        (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, prev_loss_res, user_id
                        )
                 VALUES (p_session_id, p_line_cd, p_subline_cd, p_iss_cd, prev_loss.peril_cd, p_loss_date, p_assd_no, p_intm_no, prev_loss.loss, p_user_id
                        );
         END IF;
      END LOOP;

      --losses paid
      FOR losses IN (SELECT   peril_cd, NVL (SUM (loss_paid), 0) loss_paid
                         FROM gicl_lratio_loss_paid_ext
                        WHERE session_id = p_session_id 
                          AND (line_cd, iss_cd) IN (
                                                   SELECT line_cd, branch_cd
                                                     FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                   )
                          --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                           --angelo092507
                     GROUP BY peril_cd)
      LOOP
         v_exists := 'N';

         FOR chk_exists IN (SELECT '1'
                              FROM gicl_loss_ratio_ext
                             WHERE session_id = p_session_id 
                               AND (line_cd, iss_cd) IN (
                                                       SELECT line_cd, branch_cd
                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                       )
                               --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                     --angelo092507
                                   AND peril_cd = losses.peril_cd)
         LOOP
            UPDATE gicl_loss_ratio_ext
               SET loss_paid_amt = NVL (loss_paid_amt, 0) + losses.loss_paid
             WHERE session_id = p_session_id AND peril_cd = losses.peril_cd;

            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N' THEN
            p_counter := p_counter + 1;

            INSERT INTO gicl_loss_ratio_ext
                        (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, loss_paid_amt, user_id
                        )
                 VALUES (p_session_id, p_line_cd, p_subline_cd, p_iss_cd, losses.peril_cd, p_loss_date, p_assd_no, p_intm_no, losses.loss_paid, p_user_id
                        );
         END IF;
      END LOOP;

      --current recovery
      FOR curr_rec IN (SELECT   peril_cd, NVL (SUM (recovered_amt), 0) RECOVERY
                           FROM gicl_lratio_curr_recovery_ext
                          WHERE session_id = p_session_id 
                            AND (line_cd, iss_cd) IN (
                                                       SELECT line_cd, branch_cd
                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                       )
                            --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                         --angelo092507
                       GROUP BY peril_cd)
      LOOP
         v_exists := 'N';

         FOR chk_exists IN (SELECT '1'
                              FROM gicl_loss_ratio_ext
                             WHERE session_id = p_session_id 
                               AND (line_cd, iss_cd) IN (
                                                       SELECT line_cd, branch_cd
                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                       )
                               --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                     --angelo092507
                                   AND peril_cd = curr_rec.peril_cd)
         LOOP
            UPDATE gicl_loss_ratio_ext
               SET curr_loss_res = NVL (curr_loss_res, 0) - curr_rec.RECOVERY
             WHERE session_id = p_session_id AND peril_cd = curr_rec.peril_cd;

            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N' THEN
            p_counter := p_counter + 1;

            INSERT INTO gicl_loss_ratio_ext
                        (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, intm_no, curr_loss_res, user_id
                        )
                 VALUES (p_session_id, p_line_cd, p_subline_cd, p_iss_cd, curr_rec.peril_cd, p_loss_date, p_assd_no, p_intm_no, -curr_rec.RECOVERY, p_user_id
                        );
         END IF;
      END LOOP;

      --current recovery
      FOR prev_rec IN (SELECT   peril_cd, NVL (SUM (recovered_amt), 0) RECOVERY
                           FROM gicl_lratio_prev_recovery_ext
                          WHERE session_id = p_session_id 
                            AND (line_cd, iss_cd) IN (
                                                       SELECT line_cd, branch_cd
                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                       )
                            --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                         --angelo092507
                       GROUP BY peril_cd)
      LOOP
         v_exists := 'N';

         FOR chk_exists IN (SELECT '1'
                              FROM gicl_loss_ratio_ext
                             WHERE session_id = p_session_id 
                               AND (line_cd, iss_cd) IN (
                                                       SELECT line_cd, branch_cd
                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                       )
                               --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                     --angelo092507
                                   AND peril_cd = prev_rec.peril_cd)
         LOOP
            UPDATE gicl_loss_ratio_ext
               SET prev_loss_res = NVL (prev_loss_res, 0) - prev_rec.RECOVERY
             WHERE session_id = p_session_id AND peril_cd = prev_rec.peril_cd;

            v_exists := 'Y';
         END LOOP;

         IF v_exists = 'N' THEN
            p_counter := p_counter + 1;

            INSERT INTO gicl_loss_ratio_ext
                        (session_id, line_cd, subline_cd, iss_cd, peril_cd, loss_ratio_date, assd_no, prev_loss_res, user_id, intm_no
                        )
                 VALUES (p_session_id, p_line_cd, p_subline_cd, p_iss_cd, prev_rec.peril_cd, p_loss_date, p_assd_no, -prev_rec.RECOVERY, p_user_id, p_intm_no
                        );
         END IF;
      END LOOP;

      FOR prem_res IN (SELECT peril_cd, prev_prem_amt, curr_prem_amt
                         FROM gicl_loss_ratio_ext
                        WHERE session_id = p_session_id 
                          AND (line_cd, iss_cd) IN (
                                                       SELECT line_cd, branch_cd
                                                         FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                       )
                          --AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS204', p_user_id) = 1                                                           --angelo092507
                       )
      LOOP
         v_prev_prem_res := 0;
         v_curr_prem_res := 0;

         IF p_ext_proc = 'S' THEN
            v_prev_prem_res := NVL (prem_res.prev_prem_amt, 0) * .4;
            v_curr_prem_res := NVL (prem_res.curr_prem_amt, 0) * .4;
         ELSE
            FOR c IN (SELECT param_value_v
                        FROM giis_parameters
                       WHERE param_name = 'LINE_CODE_MN')
            LOOP
               v_line_cd := c.param_value_v;
               EXIT;
            END LOOP;

            IF NVL (prem_res.curr_prem_amt, 0) <> 0 THEN
               IF NVL (p_line_cd, v_line_cd) = v_line_cd THEN                                                                                                                         --Jerome 08052005
                  FOR curr_prem IN (SELECT   peril_cd, ROUND (SUM (prem * factor), 2) prem
                                        FROM (SELECT   b.peril_cd, NVL (SUM (b.prem_amt), 0) prem, factor
                                                  FROM gicl_24th_tab_mn a, gicl_lratio_curr_prem_ext b, gipi_polbasic c
                                                 WHERE 1 = 1
                                                   AND col_mm = TO_NUMBER (TO_CHAR (date_for_24th, 'MM'), 99)
                                                   AND a.session_id = p_session_id
                                                   AND a.session_id = b.session_id
                                                   AND (b.line_cd, b.iss_cd) IN (
                                                                           SELECT line_cd, branch_cd
                                                                             FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                                           )
                                                   --AND check_user_per_iss_cd2 (b.line_cd, b.iss_cd, 'GICLS204', p_user_id) = 1                                                            --angelo092507
                                                   AND b.peril_cd = prem_res.peril_cd
                                                   AND b.line_cd = NVL (p_line_cd, b.line_cd)
                                                   AND b.policy_id = c.policy_id
                                                   AND c.expiry_date > p_date -- Dren Niebres 07.12.2016 SR-21428                                                       
                                              GROUP BY b.peril_cd, factor)
                                    GROUP BY peril_cd)
                  LOOP
                     v_curr_prem_res := v_curr_prem_res + NVL (curr_prem.prem, 0);
                  END LOOP;
               ELSIF NVL (p_line_cd, v_line_cd) <> v_line_cd THEN
                  FOR curr_prem IN (SELECT   peril_cd, ROUND (SUM (prem * factor), 2) prem
                                        FROM (SELECT   b.peril_cd, NVL (SUM (b.prem_amt), 0) prem, factor
                                                  FROM gicl_24th_tab a, gicl_lratio_curr_prem_ext b, gipi_polbasic c
                                                 WHERE 1 = 1
                                                   AND col_mm = TO_NUMBER (TO_CHAR (date_for_24th, 'MM'), 99)
                                                   AND a.session_id = p_session_id
                                                   AND a.session_id = b.session_id
                                                   AND (b.line_cd, b.iss_cd) IN (
                                                                           SELECT line_cd, branch_cd
                                                                             FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                                           )
                                                   --AND check_user_per_iss_cd2 (b.line_cd, b.iss_cd, 'GICLS204', p_user_id) = 1                                                            --angelo092507
                                                   AND b.peril_cd = prem_res.peril_cd
                                                   AND b.line_cd = NVL (p_line_cd, b.line_cd)
                                                   AND b.policy_id = c.policy_id
                                                   AND c.expiry_date > p_date -- Dren Niebres 07.12.2016 SR-21428                                                     
                                              GROUP BY b.peril_cd, factor)
                                    GROUP BY peril_cd)
                  LOOP
                     v_curr_prem_res := v_curr_prem_res + NVL (curr_prem.prem, 0);
                  END LOOP;
               END IF;
            END IF;
         END IF;

         IF NVL (prem_res.curr_prem_amt, 0) <> 0 THEN
            IF NVL (p_line_cd, v_line_cd) = v_line_cd THEN                                                                                                                            --Jerome 08052005
               FOR prev_prem IN (SELECT   peril_cd, ROUND (SUM (prem * factor), 2) prem
                                     FROM (SELECT   peril_cd, NVL (SUM (prem_amt), 0) prem, factor
                                               FROM gicl_24th_tab_mn a, gicl_lratio_prev_prem_ext b
                                              WHERE 1 = 1
                                                AND col_mm = TO_NUMBER (TO_CHAR (date_for_24th, 'MM'), 99)
                                                AND a.session_id = p_session_id
                                                AND a.session_id = b.session_id
                                                AND (b.line_cd, b.iss_cd) IN (
                                                                           SELECT line_cd, branch_cd
                                                                             FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                                           )
                                                --AND check_user_per_iss_cd2 (b.line_cd, b.iss_cd, 'GICLS204', p_user_id) = 1                                                               --angelo092507
                                                AND peril_cd = prem_res.peril_cd
                                                AND b.line_cd = NVL (p_line_cd, b.line_cd)
                                           GROUP BY peril_cd, factor)
                                 GROUP BY peril_cd)
               LOOP
                  v_prev_prem_res := v_prev_prem_res + NVL (prev_prem.prem, 0);
               END LOOP;
            ELSIF NVL (p_line_cd, v_line_cd) <> v_line_cd THEN
               FOR prev_prem IN (SELECT   peril_cd, ROUND (SUM (prem * factor), 2) prem
                                     FROM (SELECT   peril_cd, NVL (SUM (prem_amt), 0) prem, factor
                                               FROM gicl_24th_tab a, gicl_lratio_prev_prem_ext b
                                              WHERE 1 = 1
                                                AND col_mm = TO_NUMBER (TO_CHAR (date_for_24th, 'MM'), 99)
                                                AND a.session_id = p_session_id
                                                AND a.session_id = b.session_id
                                                AND (b.line_cd, b.iss_cd) IN (
                                                                           SELECT line_cd, branch_cd
                                                                             FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                                           )
                                                --AND check_user_per_iss_cd2 (b.line_cd, b.iss_cd, 'GICLS204', p_user_id) = 1                                                               --angelo092507
                                                AND peril_cd = prem_res.peril_cd
                                                AND b.line_cd = NVL (p_line_cd, b.line_cd)
                                           GROUP BY peril_cd, factor)
                                 GROUP BY peril_cd)
               LOOP
                  v_prev_prem_res := v_prev_prem_res + NVL (prev_prem.prem, 0);
               END LOOP;
            END IF;
         END IF;

         UPDATE gicl_loss_ratio_ext
            SET prev_prem_res = v_prev_prem_res,
                curr_prem_res = v_curr_prem_res
          WHERE session_id = p_session_id AND peril_cd = prem_res.peril_cd;
      END LOOP;
   END;
   
   PROCEDURE get_detail_report_date(
      p_date               IN OUT VARCHAR2,
      p_extract_proc       IN VARCHAR2,
      p_curr1_date        OUT VARCHAR2,
      p_curr2_date        OUT VARCHAR2,
      p_prev_year         OUT VARCHAR2,
      p_curr_year         OUT VARCHAR2,
      p_prev1_date        OUT VARCHAR2,
      p_prev2_date        OUT VARCHAR2
   ) AS
      v_date                gipi_polbasic.issue_date%TYPE;
   BEGIN
      IF p_extract_proc = 'S' THEN
         v_date := TO_DATE(p_date, 'mm/dd/yyyy');
      ELSE
         v_date := LAST_DAY(TO_DATE(p_date, 'mm-yyyy'));
      END IF;
      
      p_curr1_date := TO_CHAR(TO_DATE('01-01-' || TO_CHAR (v_date, 'YYYY'), 'MM-DD-YYYY'),'mm-dd-yyyy');
      p_curr2_date := TO_CHAR(TRUNC (v_date),'mm-dd-yyyy');
      p_prev_year := TO_CHAR (TO_NUMBER (TO_CHAR (v_date, 'YYYY')) - 1);
      p_curr_year := TO_CHAR (TO_NUMBER (TO_CHAR (v_date, 'YYYY')));
      p_prev1_date := TO_CHAR(TO_DATE('01-01-' || p_prev_year, 'MM-DD-YYYY'),'mm-dd-yyyy');
      p_prev2_date := TO_CHAR(TO_DATE('12-31-' || p_prev_year, 'MM-DD-YYYY'),'mm-dd-yyyy');
      p_date := TO_CHAR(v_date, 'mm-dd-yyyy');
   END;
   
   PROCEDURE LRATIO_EXTRACT_LOSSES_PAID (
      p_line_cd             gicl_claims.line_cd%TYPE,
      p_subline_cd          gicl_claims.subline_cd%TYPE,
      p_iss_cd              gicl_claims.iss_cd%TYPE,
      p_intm_no             gicl_intm_itmperil.intm_no%TYPE,
      p_assd_no             gicl_claims.assd_no%TYPE,
      p_peril_cd            gicl_clm_res_hist.peril_cd%TYPE,
      p_session_id          gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param          NUMBER,
      p_issue_param         NUMBER,
      p_curr1_date          DATE,       --First Day of As Of Date parameter minus 11 months(24th Method) / First Day of the year based on the year of parameter (Straight)
      p_curr2_date          DATE,       --Last Day of As Of Date parameter(24th Method) / As Of Date parameter (Straight)
      p_exists        OUT   VARCHAR2,
      p_extract_cat         VARCHAR2,   --Extract Amount By : G-GROSS or N-NET
      p_print_option        NUMBER,     --Print Report By:   4-Per Intermediary
      p_user_id             VARCHAR2) 
   AS
      TYPE paid_amt_tab    IS TABLE OF gicl_clm_res_hist.losses_paid%TYPE;
      TYPE assd_no_tab     IS TABLE OF giis_assured.assd_no%TYPE;
      TYPE claim_id_tab    IS TABLE OF gicl_claims.claim_id%TYPE;
      TYPE peril_cd_tab    IS TABLE OF giis_peril.peril_cd%TYPE;
      TYPE line_cd_tab     IS TABLE OF giis_line.line_cd%TYPE;
      TYPE subline_cd_tab  IS TABLE OF giis_subline.subline_cd%TYPE;
      TYPE iss_cd_tab      IS TABLE OF giis_issource.iss_cd%TYPE;
      TYPE intm_no_tab     IS TABLE OF giis_intermediary.intm_no%TYPE;
       
      vv_claim_id          claim_id_tab;
      vv_paid_amt          paid_amt_tab;
      vv_assd_no           assd_no_tab;
      vv_peril_cd          peril_cd_tab;
      vv_line_cd           line_cd_tab;
      vv_subline_cd        subline_cd_tab;
      vv_iss_cd            iss_cd_tab;
      vv_intm_no           intm_no_tab;
   BEGIN
      --delete records in extract table gicl_lratio_loss_paid_ext for the current user
      DELETE FROM gicl_lratio_loss_paid_ext
       WHERE user_id = p_user_id;
   p_exists := 'N';
   
   --retrieve all paid claim for the current year
    SELECT a.claim_id, a.assd_no, 
           a.line_cd, a.subline_cd, 
           a.iss_cd, b.peril_cd, 
           b.intm_no, (b.losses_paid + b.expenses_paid) paid_amt
    BULK COLLECT
    INTO vv_claim_id,   vv_assd_no,
         vv_line_cd,    vv_subline_cd,
         vv_iss_cd,     vv_peril_cd,
         vv_intm_no,    vv_paid_amt
    FROM gicl_claims a,
             (SELECT   a.claim_id, a.peril_cd, d.intm_no,
                       SUM (DECODE(GICLS202_EXTRACTION_PKG.CHECK_CLOSE_DATE1(2, a.claim_id, a.item_no, a.peril_cd, p_curr2_date), 0, 0,
                              DECODE (a.dist_sw, NULL, NVL (a.convert_rate, 1) * NVL (a.losses_paid, 0), 0)) * NVL(d.shr_intm_pct, 100)/100 
                              * GET_REVERSAL(a.tran_id, p_curr1_date, p_curr2_date) * f.shr_pct/100) losses_paid,
                       SUM (DECODE(GICLS202_EXTRACTION_PKG.CHECK_CLOSE_DATE2(2, a.claim_id, a.item_no, a.peril_cd, p_curr2_date), 0, 0, 
                              DECODE (a.dist_sw, NULL, NVL (a.convert_rate, 1) * NVL (a.expenses_paid, 0), 0)) * NVL(d.shr_intm_pct, 100)/100
                              * GET_REVERSAL(a.tran_id, p_curr1_date, p_curr2_date) * f.shr_pct/100) expenses_paid
                  FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_claims c, 
                       (SELECT claim_id, item_no, peril_cd, intm_no, shr_intm_pct
                          FROM gicl_intm_itmperil
                         WHERE p_print_option = 4
                            OR p_intm_no IS NOT NULL) d, giac_acctrans e, 
                       (SELECT DISTINCT claim_id, item_no, peril_cd, clm_res_hist_id, grouped_item_no, 
                               DECODE(p_extract_cat, 'G', 100, shr_pct) shr_pct --multiply 100 if extraction is Gross else multiply share of Net Retention only
                          FROM gicl_reserve_ds
                         WHERE NVL (negate_tag, 'N') <> 'Y'
                           AND DECODE(p_extract_cat, 'G', 1, share_type) = 1) f --if extraction amount is based on Gross retrieve all records otherwise retrieve records of Net Retention only
                 WHERE a.claim_id = b.claim_id
                   AND a.item_no = b.item_no
                   AND a.peril_cd = b.peril_cd
                   AND a.claim_id = c.claim_id
                   AND b.claim_id = d.claim_id (+)
                   AND b.item_no = d.item_no (+)
                   AND b.peril_cd = d.peril_cd (+)
                   AND (c.line_cd, c.iss_cd) IN (
                                             SELECT line_cd, branch_cd
                                               FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                            ) 
                   --AND check_user_per_iss_cd2(c.line_cd, c.iss_cd, 'GICLS204', p_user_id) = 1
                   AND ((TRUNC(a.date_paid) BETWEEN p_curr1_date AND p_curr2_date) 
                        OR (DECODE(GET_REVERSAL(a.tran_id, p_curr1_date, p_curr2_date), 1, 0, 1) = 1))
                   AND (DECODE (a.cancel_tag, 'Y', TRUNC (a.cancel_date), p_curr2_date + 1) > p_curr2_date
                        OR (DECODE(GET_REVERSAL(a.tran_id, p_curr1_date, p_curr2_date), 1, 0, 1) = 1))
                   AND (GICLS202_EXTRACTION_PKG.CHECK_CLOSE_DATE1(2, a.claim_id, a.item_no, a.peril_cd, p_curr2_date) = 1
                       OR GICLS202_EXTRACTION_PKG.CHECK_CLOSE_DATE2(2, a.claim_id, a.item_no, a.peril_cd, p_curr2_date) = 1)
                   AND b.peril_cd = NVL (p_peril_cd, b.peril_cd)
                   AND DECODE(p_intm_no, NULL, 1, d.intm_no) = NVL(p_intm_no, 1)
                   AND a.tran_id IS NOT NULL
                   AND a.tran_id = e.tran_id
                   AND e.tran_flag != 'D'
                   AND a.claim_id = f.claim_id
                   AND a.item_no = f.item_no
                   AND a.peril_cd = f.peril_cd
                   AND a.grouped_item_no = f.grouped_item_no
              GROUP BY a.claim_id,
                       a.peril_cd,
                       d.intm_no) b
       WHERE 
         a.line_cd = NVL (p_line_cd, a.line_cd)
         AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
         AND a.claim_id = b.claim_id
         AND DECODE (p_issue_param, 1, a.iss_cd, 2, a.pol_iss_cd, 1) = NVL (p_iss_cd, DECODE (p_issue_param, 1, a.iss_cd, 2, a.pol_iss_cd, 1))
         AND (b.losses_paid + b.expenses_paid) != 0;
    
    IF SQL% FOUND THEN
     p_exists := 'Y';
     FORALL i IN vv_claim_id.FIRST..vv_claim_id.LAST
       INSERT INTO gicl_lratio_loss_paid_ext
         (session_id,      assd_no,          peril_cd,      intm_no,
          line_cd,         subline_cd,       iss_cd,        
          claim_id,        loss_paid,        user_id)
       VALUES
         (p_session_id,    vv_assd_no(i),    vv_peril_cd(i), vv_intm_no(i),
          vv_line_cd(i),   vv_subline_cd(i), vv_iss_cd(i),   
          vv_claim_id(i),  vv_paid_amt(i),   p_user_id);
    END IF;
      vv_claim_id.DELETE;
      vv_paid_amt.DELETE;
      vv_assd_no.DELETE;
      vv_peril_cd.DELETE;
      vv_line_cd.DELETE;
      vv_subline_cd.DELETE;
      vv_iss_cd.DELETE;
      vv_intm_no.DELETE;
   
  END;
  
  PROCEDURE LRATIO_EXTRACT_OS (
      p_line_cd             gicl_claims.line_cd%TYPE,
      p_subline_cd          gicl_claims.subline_cd%TYPE,
      p_iss_cd              gicl_claims.iss_cd%TYPE,
      p_intm_no             gicl_intm_itmperil.intm_no%TYPE,
      p_assd_no             gicl_claims.assd_no%TYPE,
      p_peril_cd            gicl_clm_res_hist.peril_cd%TYPE,
      p_session_id          gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param          NUMBER,
      p_issue_param         NUMBER,
      p_curr1_date          DATE,       --First Day of As Of Date parameter minus 11 months(24th Method) / First Day of the year based on the year of parameter (Straight)
      p_curr2_date          DATE,       --Last Day of As Of Date parameter(24th Method) / As Of Date parameter (Straight)
      p_prev1_date          DATE,       --p_curr1_date minus 1 year
      p_prev2_date          DATE,       --p_curr2_date minus 1 year
      p_curr_exists    OUT  VARCHAR2,
      p_prev_exists    OUT  VARCHAR2,
      p_extract_cat         VARCHAR2,   --Extract Amount By : G-GROSS or N-NET
      p_print_option        NUMBER,     --Print Report By:   4-Per Intermediary
      p_user_id             VARCHAR2)
   AS
      TYPE os_amt_tab      IS TABLE OF gicl_clm_res_hist.losses_paid%TYPE; --gipi_polbasic.prem_amt%TYPE;
      TYPE assd_no_tab     IS TABLE OF giis_assured.assd_no%TYPE;
      TYPE claim_id_tab    IS TABLE OF gicl_claims.claim_id%TYPE;
      TYPE peril_cd_tab    IS TABLE OF giis_peril.peril_cd%TYPE;
      TYPE line_cd_tab     IS TABLE OF giis_line.line_cd%TYPE;
      TYPE subline_cd_tab  IS TABLE OF giis_subline.subline_cd%TYPE;
      TYPE iss_cd_tab      IS TABLE OF giis_issource.iss_cd%TYPE;
      TYPE intm_no_tab     IS TABLE OF giis_intermediary.intm_no%TYPE;
      
      vv_claim_id          claim_id_tab;
      vv_os                os_amt_tab;
      vv_assd_no           assd_no_tab;
      vv_peril_cd          peril_cd_tab;
      vv_line_cd           line_cd_tab;
      vv_subline_cd        subline_cd_tab;
      vv_iss_cd            iss_cd_tab;
      vv_intm_no           intm_no_tab;
      --variables to be used when entered parameter is already taken up
      v_exist              VARCHAR2(1);
      v_posted             VARCHAR2(1);
   BEGIN
      p_curr_exists := 'N';
      p_prev_exists := 'N';
      
      BEGIN
            SELECT DISTINCT 'x' 
              INTO v_exist
              FROM gicl_take_up_hist a, giac_acctrans b
             WHERE a.acct_tran_id = b.tran_id 
               AND a.iss_cd = b.gibr_branch_cd
               AND a.iss_cd = NVL(p_iss_cd,a.iss_cd)  
               AND TRUNC(b.tran_date) = p_curr2_date
               AND b.tran_flag <> 'D';
                       
             v_posted := 'N';  
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
            v_exist := NULL;
      END;
      
      IF v_exist IS NOT NULL THEN --if already taken up
          BEGIN
               SELECT DISTINCT 'Y' 
                 INTO v_posted
                 FROM gicl_take_up_hist a, giac_acctrans b
                WHERE a.acct_tran_id = b.tran_id 
                  AND a.iss_cd = b.gibr_branch_cd
                  AND a.iss_cd = NVL(p_iss_cd,a.iss_cd)  
                  AND TRUNC(b.tran_date) = p_curr2_date  
                  AND TRUNC(b.posting_date) = p_curr2_date;
                      
          EXCEPTION
               WHEN NO_DATA_FOUND THEN
                 v_posted := 'N';  
          END;
           
          BEGIN 
            --extract current year outstanding
            --delete records in extract table gicl_lratio_curr_os_ext for the current user
            DELETE gicl_lratio_curr_os_ext
             WHERE user_id = p_user_id;
          
            SELECT a.claim_id,        a.assd_no,
                   b.peril_cd,        a.line_cd,
                   a.subline_cd,      a.iss_cd,
                   b.intm_no,         (os_loss + os_expense) outstanding
              BULK COLLECT
              INTO vv_claim_id,       vv_assd_no,
                   vv_peril_cd,       vv_line_cd,
                   vv_subline_cd,     vv_iss_cd,
                   vv_intm_no,        vv_os
              FROM gicl_claims a,
                   (SELECT a.claim_id, a.peril_cd, f.intm_no,
                           SUM(d.os_loss * NVL(f.shr_intm_pct,100)/100 * g.shr_pct/100) os_loss, 
                           SUM(d.os_expense * NVL(f.shr_intm_pct,100)/100 * g.shr_pct/100) os_expense
                      FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_claims c, gicl_take_up_hist d, giac_acctrans e,
                           (SELECT claim_id, item_no, peril_cd, intm_no, shr_intm_pct
                              FROM gicl_intm_itmperil
                             WHERE p_print_option = 4
                                OR p_intm_no IS NOT NULL) f, 
                           (SELECT DISTINCT claim_id, item_no, peril_cd, clm_res_hist_id, grouped_item_no, 
                                   DECODE(p_extract_cat, 'G', 100, shr_pct) shr_pct --multiply 100 if extraction is Gross else multiply share of Net Retention only
                              FROM gicl_reserve_ds
                             WHERE DECODE(p_extract_cat, 'G', 1, share_type) = 1) g --if extraction amount is based on Gross retrieve all records otherwise retrieve records of Net Retention only
                     WHERE a.claim_id = b.claim_id
                       AND a.item_no = b.item_no
                       AND a.peril_cd = b.peril_cd
                       AND a.claim_id = c.claim_id
                       AND a.claim_id = d.claim_id
                       AND a.clm_res_hist_id     = d.clm_res_hist_id
                       AND d.acct_tran_id        = e.tran_id  
                       AND (c.line_cd, c.iss_cd) IN (
                                             SELECT line_cd, branch_cd
                                               FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                            ) 
                       --AND check_user_per_iss_cd2(c.line_cd, c.iss_cd, 'GICLS204', p_user_id) = 1
                       AND TO_DATE (   NVL (a.booking_month, TO_CHAR (p_curr2_date, 'FMMONTH'))
                                    || ' 01, '
                                    || NVL (TO_CHAR (a.booking_year, '0999'),TO_CHAR (p_curr2_date, 'YYYY')), 'FMMONTH DD, YYYY'
                                   ) <= p_curr2_date
                       AND DECODE(v_posted,'Y',TRUNC(e.posting_date),TRUNC(e.tran_date)) = p_curr2_date
                       AND e.tran_flag = DECODE(v_posted,'Y','P','C') 
                       AND (NVL(d.os_loss,0) + NVL(d.os_expense,0)) > 0
                       AND b.claim_id = f.claim_id (+)
                       AND b.item_no = f.item_no (+)
                       AND b.peril_cd = f.peril_cd (+)
                       AND DECODE(p_intm_no, NULL, 1, f.intm_no) = NVL(p_intm_no, 1)
                       AND a.claim_id = g.claim_id
                       AND a.item_no = g.item_no
                       AND a.peril_cd = g.peril_cd
                       AND a.grouped_item_no = g.grouped_item_no
                       AND a.clm_res_hist_id = g.clm_res_hist_id
                     GROUP BY a.claim_id, a.peril_cd, f.intm_no) b
               WHERE a.line_cd = NVL (p_line_cd, a.line_cd)
                 AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
                 AND b.peril_cd = NVL (p_peril_cd, b.peril_cd)
                 AND a.claim_id = b.claim_id
                 AND DECODE (p_issue_param, 1, a.iss_cd, 2, a.pol_iss_cd, 1) = NVL (p_iss_cd, DECODE (p_issue_param, 1, a.iss_cd, 2, a.pol_iss_cd, 1));
              
             IF SQL%FOUND THEN
               p_curr_exists := 'Y';
                 FORALL i IN vv_claim_id.first..vv_claim_id.last
                     INSERT INTO gicl_lratio_curr_os_ext
                     (session_id,          assd_no,            claim_id,
                      line_cd,             subline_cd,         iss_cd,
                      peril_cd,            intm_no,            os_amt,             user_id)
                   VALUES
                     (p_session_id,        vv_assd_no(i),      vv_claim_id(i),
                      vv_line_cd(i),       vv_subline_cd(i),   vv_iss_cd(i),
                      vv_peril_cd(i),      vv_intm_no(i),      vv_os(i),           p_user_id);
                   
                 vv_assd_no.DELETE;
                 vv_claim_id.DELETE;
                 vv_peril_cd.DELETE;
                 vv_os.DELETE;
                 vv_line_cd.DELETE;
                 vv_subline_cd.DELETE;
                 vv_iss_cd.DELETE;
                 vv_intm_no.DELETE;
                 
             END IF;  
          END;
         
          BEGIN 
            --extract previous year outstanding
            --delete records in extract table gicl_lratio_prev_os_ext for the current user
            DELETE gicl_lratio_prev_os_ext
             WHERE user_id = p_user_id;
             
              SELECT a.claim_id,        a.assd_no,
                   b.peril_cd,        a.line_cd,
                   a.subline_cd,      a.iss_cd,
                   b.intm_no,         (os_loss + os_expense) outstanding
              BULK COLLECT
              INTO vv_claim_id,       vv_assd_no,
                   vv_peril_cd,       vv_line_cd,
                   vv_subline_cd,     vv_iss_cd,
                   vv_intm_no,        vv_os
              FROM gicl_claims a,
                   (SELECT a.claim_id, a.peril_cd, f.intm_no,
                           SUM(d.os_loss * NVL(f.shr_intm_pct,100)/100 * g.shr_pct/100) os_loss, 
                           SUM(d.os_expense * NVL(f.shr_intm_pct,100)/100 * g.shr_pct/100) os_expense
                      FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_claims c, gicl_take_up_hist d, giac_acctrans e,
                           (SELECT claim_id, item_no, peril_cd, intm_no, shr_intm_pct
                              FROM gicl_intm_itmperil
                             WHERE p_print_option = 4
                                OR p_intm_no IS NOT NULL) f, 
                           (SELECT DISTINCT claim_id, item_no, peril_cd, clm_res_hist_id, grouped_item_no, 
                                   DECODE(p_extract_cat, 'G', 100, shr_pct) shr_pct --multiply 100 if extraction is Gross else multiply share of Net Retention only
                              FROM gicl_reserve_ds
                             WHERE DECODE(p_extract_cat, 'G', 1, share_type) = 1) g --if extraction amount is based on Gross retrieve all records otherwise retrieve records of Net Retention only
                     WHERE a.claim_id = b.claim_id
                       AND a.item_no = b.item_no
                       AND a.peril_cd = b.peril_cd
                       AND a.claim_id = c.claim_id
                       AND a.claim_id = d.claim_id
                       AND a.clm_res_hist_id     = d.clm_res_hist_id
                       AND d.acct_tran_id        = e.tran_id  
                       AND (c.line_cd, c.iss_cd) IN (
                                             SELECT line_cd, branch_cd
                                               FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                            ) 
                       --AND check_user_per_iss_cd2(c.line_cd, c.iss_cd, 'GICLS204', p_user_id) = 1
                       AND TO_DATE (   NVL (a.booking_month, TO_CHAR (p_prev2_date, 'FMMONTH')) 
                                    || ' 01, '
                                    || NVL (TO_CHAR (a.booking_year, '0999'),TO_CHAR (p_prev2_date, 'YYYY')), 'FMMONTH DD, YYYY'
                                   ) <= p_prev2_date
                       AND DECODE(v_posted,'Y',TRUNC(e.posting_date),TRUNC(e.tran_date)) = p_prev2_date
                       AND e.tran_flag = DECODE(v_posted,'Y','P','C') 
                       AND (NVL(d.os_loss,0) + NVL(d.os_expense,0)) > 0
                       AND b.claim_id = f.claim_id (+)
                       AND b.item_no = f.item_no (+)
                       AND b.peril_cd = f.peril_cd (+)
                       AND DECODE(p_intm_no, NULL, 1, f.intm_no) = NVL(p_intm_no, 1)
                       AND a.claim_id = g.claim_id
                       AND a.item_no = g.item_no
                       AND a.peril_cd = g.peril_cd
                       AND a.grouped_item_no = g.grouped_item_no
                       AND a.clm_res_hist_id = g.clm_res_hist_id
                     GROUP BY a.claim_id, a.peril_cd, f.intm_no) b
               WHERE a.line_cd = NVL (p_line_cd, a.line_cd)
                 AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
                 AND b.peril_cd = NVL (p_peril_cd, b.peril_cd)
                 AND a.claim_id = b.claim_id
                 AND DECODE (p_issue_param, 1, a.iss_cd, 2, a.pol_iss_cd, 1) = NVL (p_iss_cd, DECODE (p_issue_param, 1, a.iss_cd, 2, a.pol_iss_cd, 1));
              
             IF SQL%FOUND THEN
               p_prev_exists := 'Y';
                 FORALL i IN vv_claim_id.first..vv_claim_id.last
                     INSERT INTO gicl_lratio_prev_os_ext
                     (session_id,          assd_no,            claim_id,
                      line_cd,             subline_cd,         iss_cd,
                      peril_cd,            intm_no,            os_amt,             user_id)
                   VALUES
                     (p_session_id,        vv_assd_no(i),      vv_claim_id(i),
                      vv_line_cd(i),       vv_subline_cd(i),   vv_iss_cd(i),
                      vv_peril_cd(i),      vv_intm_no(i),      vv_os(i),           p_user_id);
                   
                 vv_assd_no.DELETE;
                 vv_claim_id.DELETE;
                 vv_peril_cd.DELETE;
                 vv_os.DELETE;
                 vv_line_cd.DELETE;
                 vv_subline_cd.DELETE;
                 vv_iss_cd.DELETE;
                 vv_intm_no.DELETE;
                 
             END IF;
          END;        
      
      ELSE --not taken up
      
          BEGIN 
            --extract current year outstanding
            --delete records in extract table gicl_lratio_curr_os_ext for the current user
            DELETE gicl_lratio_curr_os_ext
             WHERE user_id = p_user_id;
          
              SELECT a.claim_id,        a.assd_no,
                     b.peril_cd,        a.line_cd,
                     a.subline_cd,      a.iss_cd,
                     b.intm_no, ((b.loss_reserve - b.losses_paid) + (b.expense_reserve - b.expenses_paid)) outstanding
                BULK COLLECT
                INTO vv_claim_id,       vv_assd_no,
                     vv_peril_cd,       vv_line_cd,
                     vv_subline_cd,     vv_iss_cd,
                     vv_intm_no,        vv_os
                FROM gicl_claims a,
                     (SELECT   a.claim_id, a.peril_cd, d.intm_no,
                               SUM (DECODE(GICLS202_EXTRACTION_PKG.CHECK_CLOSE_DATE1(1, a.claim_id, a.item_no, a.peril_cd, p_curr2_date), 0, 0, 
                                      DECODE (a.dist_sw, 'Y', NVL (a.convert_rate, 1) * NVL (a.loss_reserve, 0), 0)) * NVL(d.shr_intm_pct,100)/100 * f.shr_pct/100) loss_reserve,
                               SUM (DECODE(GICLS202_EXTRACTION_PKG.CHECK_CLOSE_DATE1(1, a.claim_id, a.item_no, a.peril_cd, p_curr2_date), 0, 0,
                                      DECODE (a.dist_sw, NULL, NVL (a.convert_rate, 1) * NVL (a.losses_paid, 0), 0)) * NVL(d.shr_intm_pct,100)/100 * f.shr_pct/100) losses_paid,
                               SUM (DECODE(GICLS202_EXTRACTION_PKG.CHECK_CLOSE_DATE2(1, a.claim_id, a.item_no, a.peril_cd, p_curr2_date), 0, 0, 
                                      DECODE (a.dist_sw, 'Y', NVL (a.convert_rate, 1) * NVL (a.expense_reserve, 0), 0)) * NVL(d.shr_intm_pct,100)/100 * f.shr_pct/100) expense_reserve,
                               SUM (DECODE(GICLS202_EXTRACTION_PKG.CHECK_CLOSE_DATE2(1, a.claim_id, a.item_no, a.peril_cd, p_curr2_date), 0, 0, 
                                      DECODE (a.dist_sw, NULL, NVL (a.convert_rate, 1) * NVL (a.expenses_paid, 0), 0)) * NVL(d.shr_intm_pct,100)/100  * f.shr_pct/100) expenses_paid
                          FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_claims c, 
                               (SELECT claim_id, item_no, peril_cd, intm_no, shr_intm_pct
                                  FROM gicl_intm_itmperil
                                 WHERE p_print_option = 4
                                    OR p_intm_no IS NOT NULL) d, 
                               (SELECT DISTINCT claim_id, item_no, peril_cd, clm_res_hist_id, grouped_item_no, 
                                       DECODE(p_extract_cat, 'G', 100, shr_pct) shr_pct --multiply 100 if extraction is Gross else multiply share of Net Retention only
                                  FROM gicl_reserve_ds
                                 WHERE NVL (negate_tag, 'N') <> 'Y'
                                   AND DECODE(p_extract_cat, 'G', 1, share_type) = 1) f --if extraction amount is based on Gross retrieve all records otherwise retrieve records of Net Retention only
                         WHERE a.claim_id = b.claim_id
                           AND a.item_no = b.item_no
                           AND a.peril_cd = b.peril_cd
                           AND a.claim_id = c.claim_id
                           AND b.claim_id = d.claim_id (+)
                           AND b.item_no = d.item_no (+)
                           AND b.peril_cd = d.peril_cd (+)
                           AND (c.line_cd, c.iss_cd) IN (
                                             SELECT line_cd, branch_cd
                                               FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                            ) 
                           --AND check_user_per_iss_cd2(c.line_cd, c.iss_cd, 'GICLS204', p_user_id) = 1
                           AND TO_DATE (   NVL (a.booking_month, TO_CHAR (p_curr2_date, 'FMMONTH'))
                                        || ' 01, '
                                        || NVL (TO_CHAR (a.booking_year, '0999'), TO_CHAR (p_curr2_date, 'YYYY')), 'FMMONTH DD, YYYY'
                                       ) <= p_curr2_date                            
                           AND TRUNC(NVL(a.date_paid, p_curr2_date)) <= p_curr2_date
                           AND DECODE (a.cancel_tag, 'Y', TRUNC (a.cancel_date), p_curr2_date + 1) > p_curr2_date
                           AND (GICLS202_EXTRACTION_PKG.CHECK_CLOSE_DATE1(1, a.claim_id, a.item_no, a.peril_cd, p_curr2_date) = 1
                               OR GICLS202_EXTRACTION_PKG.CHECK_CLOSE_DATE2(1, a.claim_id, a.item_no, a.peril_cd, p_curr2_date) = 1)
                           AND b.peril_cd = NVL (p_peril_cd, b.peril_cd)
                           AND DECODE(p_intm_no, NULL, 1, d.intm_no) = NVL(p_intm_no, 1)
                           AND a.claim_id = f.claim_id
                           AND a.item_no = f.item_no
                           AND a.peril_cd = f.peril_cd
                           AND a.grouped_item_no = f.grouped_item_no
                      GROUP BY a.claim_id,
                               a.peril_cd,
                               d.intm_no) b
               WHERE 
                 a.line_cd = NVL (p_line_cd, a.line_cd)
                 AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
                 AND a.claim_id = b.claim_id
                 AND DECODE (p_issue_param, 1, a.iss_cd, 2, a.pol_iss_cd, 1) = NVL (p_iss_cd, DECODE (p_issue_param, 1, a.iss_cd, 2, a.pol_iss_cd, 1))
                 AND ((b.loss_reserve - b.losses_paid) + (b.expense_reserve - b.expenses_paid)) > 0;
              
             IF SQL%FOUND THEN
               p_curr_exists := 'Y';
                 FORALL i IN vv_claim_id.first..vv_claim_id.last
                     INSERT INTO gicl_lratio_curr_os_ext
                     (session_id,          assd_no,            claim_id,
                      line_cd,             subline_cd,         iss_cd,
                      peril_cd,            intm_no,            os_amt,             user_id)
                   VALUES
                     (p_session_id,        vv_assd_no(i),      vv_claim_id(i),
                      vv_line_cd(i),       vv_subline_cd(i),   vv_iss_cd(i),
                      vv_peril_cd(i),      vv_intm_no(i),      vv_os(i),           p_user_id);
                   
                 vv_assd_no.DELETE;
                 vv_claim_id.DELETE;
                 vv_peril_cd.DELETE;
                 vv_os.DELETE;
                 vv_line_cd.DELETE;
                 vv_subline_cd.DELETE;
                 vv_iss_cd.DELETE;
                 vv_intm_no.DELETE;
                 
             END IF;  
          END;
         
          BEGIN 
            --extract previous year outstanding
            --delete records in extract table gicl_lratio_prev_os_ext for the current user
            DELETE gicl_lratio_prev_os_ext
             WHERE user_id = p_user_id;
             
              SELECT a.claim_id,        a.assd_no,
                     b.peril_cd,        a.line_cd,
                     a.subline_cd,      a.iss_cd,
                     b.intm_no, ((b.loss_reserve - b.losses_paid) + (b.expense_reserve - b.expenses_paid)) outstanding
                BULK COLLECT
                INTO vv_claim_id,       vv_assd_no,
                     vv_peril_cd,       vv_line_cd,
                     vv_subline_cd,     vv_iss_cd,
                     vv_intm_no,        vv_os
                FROM gicl_claims a,
                     (SELECT   a.claim_id, a.peril_cd, d.intm_no,
                               SUM (DECODE(GICLS202_EXTRACTION_PKG.CHECK_CLOSE_DATE1(1, a.claim_id, a.item_no, a.peril_cd, p_prev2_date), 0, 0, 
                                      DECODE (a.dist_sw, 'Y', NVL (a.convert_rate, 1) * NVL (a.loss_reserve, 0), 0)) * NVL(d.shr_intm_pct,100)/100 * f.shr_pct/100) loss_reserve,
                               SUM (DECODE(GICLS202_EXTRACTION_PKG.CHECK_CLOSE_DATE1(1, a.claim_id, a.item_no, a.peril_cd, p_prev2_date), 0, 0,
                                      DECODE (a.dist_sw, NULL, NVL (a.convert_rate, 1) * NVL (a.losses_paid, 0), 0)) * NVL(d.shr_intm_pct,100)/100 * f.shr_pct/100) losses_paid,
                               SUM (DECODE(GICLS202_EXTRACTION_PKG.CHECK_CLOSE_DATE2(1, a.claim_id, a.item_no, a.peril_cd, p_prev2_date), 0, 0, 
                                      DECODE (a.dist_sw, 'Y', NVL (a.convert_rate, 1) * NVL (a.expense_reserve, 0), 0)) * NVL(d.shr_intm_pct,100)/100 * f.shr_pct/100) expense_reserve,
                               SUM (DECODE(GICLS202_EXTRACTION_PKG.CHECK_CLOSE_DATE2(1, a.claim_id, a.item_no, a.peril_cd, p_prev2_date), 0, 0, 
                                      DECODE (a.dist_sw, NULL, NVL (a.convert_rate, 1) * NVL (a.expenses_paid, 0), 0)) * NVL(d.shr_intm_pct,100)/100  * f.shr_pct/100) expenses_paid
                          FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_claims c, 
                               (SELECT claim_id, item_no, peril_cd, intm_no, shr_intm_pct
                                  FROM gicl_intm_itmperil
                                 WHERE p_print_option = 4
                                    OR p_intm_no IS NOT NULL) d, 
                               (SELECT DISTINCT claim_id, item_no, peril_cd, clm_res_hist_id, grouped_item_no, 
                                       DECODE(p_extract_cat, 'G', 100, shr_pct) shr_pct --multiply 100 if extraction is Gross else multiply share of Net Retention only
                                  FROM gicl_reserve_ds
                                 WHERE NVL (negate_tag, 'N') <> 'Y'
                                   AND DECODE(p_extract_cat, 'G', 1, share_type) = 1) f --if extraction amount is based on Gross retrieve all records otherwise retrieve records of Net Retention only
                         WHERE a.claim_id = b.claim_id
                           AND a.item_no = b.item_no
                           AND a.peril_cd = b.peril_cd
                           AND a.claim_id = c.claim_id
                           AND b.claim_id = d.claim_id (+)
                           AND b.item_no = d.item_no (+)
                           AND b.peril_cd = d.peril_cd (+)
                           AND (c.line_cd, c.iss_cd) IN (
                                                         SELECT line_cd, branch_cd
                                                           FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                                        )                            
                           --AND check_user_per_iss_cd2(c.line_cd, c.iss_cd, 'GICLS204', p_user_id) = 1
                           AND TO_DATE (   NVL (a.booking_month, TO_CHAR (p_prev2_date, 'FMMONTH'))
                                        || ' 01, '
                                        || NVL (TO_CHAR (a.booking_year, '0999'), TO_CHAR (p_prev2_date, 'YYYY')), 'FMMONTH DD, YYYY'
                                       ) <= p_prev2_date                            
                           AND TRUNC(NVL(a.date_paid, p_prev2_date)) <= p_prev2_date
                           AND DECODE (a.cancel_tag, 'Y', TRUNC (a.cancel_date), p_prev2_date + 1) > p_prev2_date
                           AND (GICLS202_EXTRACTION_PKG.CHECK_CLOSE_DATE1(1, a.claim_id, a.item_no, a.peril_cd, p_prev2_date) = 1
                               OR GICLS202_EXTRACTION_PKG.CHECK_CLOSE_DATE2(1, a.claim_id, a.item_no, a.peril_cd, p_prev2_date) = 1)
                           AND b.peril_cd = NVL (p_peril_cd, b.peril_cd)
                           AND DECODE(p_intm_no, NULL, 1, d.intm_no) = NVL(p_intm_no, 1)
                           AND a.claim_id = f.claim_id
                           AND a.item_no = f.item_no
                           AND a.peril_cd = f.peril_cd
                           AND a.grouped_item_no = f.grouped_item_no
                      GROUP BY a.claim_id,
                               a.peril_cd,
                               d.intm_no) b
               WHERE 
                 a.line_cd = NVL (p_line_cd, a.line_cd)
                 AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
                 AND a.claim_id = b.claim_id
                 AND DECODE (p_issue_param, 1, a.iss_cd, 2, a.pol_iss_cd, 1) = NVL (p_iss_cd, DECODE (p_issue_param, 1, a.iss_cd, 2, a.pol_iss_cd, 1))
                 AND ((b.loss_reserve - b.losses_paid) + (b.expense_reserve - b.expenses_paid)) > 0;
              
             IF SQL%FOUND THEN
               p_prev_exists := 'Y';
                 FORALL i IN vv_claim_id.first..vv_claim_id.last
                     INSERT INTO gicl_lratio_prev_os_ext
                     (session_id,          assd_no,            claim_id,
                      line_cd,             subline_cd,         iss_cd,
                      peril_cd,            intm_no,            os_amt,             user_id)
                   VALUES
                     (p_session_id,        vv_assd_no(i),      vv_claim_id(i),
                      vv_line_cd(i),       vv_subline_cd(i),   vv_iss_cd(i),
                      vv_peril_cd(i),      vv_intm_no(i),      vv_os(i),           p_user_id);
                   
                 vv_assd_no.DELETE;
                 vv_claim_id.DELETE;
                 vv_peril_cd.DELETE;
                 vv_os.DELETE;
                 vv_line_cd.DELETE;
                 vv_subline_cd.DELETE;
                 vv_iss_cd.DELETE;
                 vv_intm_no.DELETE;
                 
             END IF;
          END;   
      END IF;
        
   END LRATIO_EXTRACT_OS;

   PROCEDURE LRATIO_EXTRACT_RECOVERY (
      p_line_cd             gicl_claims.line_cd%TYPE,
      p_subline_cd          gicl_claims.subline_cd%TYPE,
      p_iss_cd              gicl_claims.iss_cd%TYPE,
      p_intm_no             gicl_intm_itmperil.intm_no%TYPE,
      p_assd_no             gicl_claims.assd_no%TYPE,
      p_peril_cd            gicl_clm_res_hist.peril_cd%TYPE,
      p_session_id          gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param          NUMBER,
      p_issue_param         NUMBER,
      p_curr1_date          DATE,       --First Day of As Of Date parameter minus 11 months(24th Method) / First Day of the year based on the year of parameter (Straight)
      p_curr2_date          DATE,       --Last Day of As Of Date parameter(24th Method) / As Of Date parameter (Straight)
      p_prev1_date          DATE,       --p_curr1_date minus 1 year
      p_prev2_date          DATE,       --p_curr2_date minus 1 year
      p_curr_exists    OUT  VARCHAR2,
      p_prev_exists    OUT  VARCHAR2,
      p_extract_cat         VARCHAR2,   --Extract Amount By : G-GROSS or N-NET
      p_print_option        NUMBER,     --Print Report By:   4-Per Intermediary
      p_user_id             VARCHAR2)
   AS
      TYPE rec_amt_tab     IS TABLE OF gipi_polbasic.prem_amt%TYPE;
      TYPE assd_no_tab     IS TABLE OF giis_assured.assd_no%TYPE;
      TYPE rec_id_tab      IS TABLE OF gicl_clm_recovery.recovery_id%TYPE;
      TYPE line_cd_tab     IS TABLE OF giis_line.line_cd%TYPE;
      TYPE subline_cd_tab  IS TABLE OF giis_subline.subline_cd%TYPE;
      TYPE iss_cd_tab      IS TABLE OF giis_issource.iss_cd%TYPE;
      TYPE peril_cd_tab    IS TABLE OF giis_peril.peril_cd%TYPE;
      TYPE intm_no_tab     IS TABLE OF giis_intermediary.intm_no%TYPE;
      
      vv_rec_id            rec_id_tab;
      vv_rec_amt           rec_amt_tab;
      vv_assd_no           assd_no_tab;
      vv_line_cd           line_cd_tab;
      vv_subline_cd        subline_cd_tab;
      vv_iss_cd            iss_cd_tab;
      vv_peril_cd          peril_cd_tab;
      vv_intm_no           intm_no_tab;
   BEGIN
      p_curr_exists := 'N';
      p_prev_exists := 'N';
      
      BEGIN 
      --extract previous year recovery amount
      --delete records in extract table gicl_lratio_prev_recovery_ext for the current user
        DELETE gicl_lratio_prev_recovery_ext
         WHERE user_id = p_user_id;
         
         SELECT d.assd_no, b.recovery_id, d.line_cd,
                d.subline_cd, d.iss_cd, c.peril_cd,
                SUM(NVL(b.recovered_amt,0) * (NVL(c.recoverable_amt,0) / Get_Rec_Amt(c.recovery_id)) * NVL(f.share_pct, 100)/100 * NVL(g.shr_intm_pct,100)/100) recovered_amt,
                g.intm_no 
           BULK COLLECT
           INTO vv_assd_no,    vv_rec_id,     vv_line_cd,
                vv_subline_cd, vv_iss_cd,     vv_peril_cd,
                vv_rec_amt, vv_intm_no
           FROM gicl_clm_recovery a, gicl_recovery_payt b, gicl_clm_recovery_dtl c,
                gicl_claims d, gicl_clm_loss_exp e,
                (SELECT DISTINCT recovery_id, recovery_payt_id, 
                        DECODE(p_extract_cat, 'G', 100, share_pct) share_pct --multiply 100 if extraction is Gross else multiply share of Net Retention only
                   FROM gicl_recovery_ds
                  WHERE NVL (negate_tag, 'N') <> 'Y'
                    AND DECODE(p_extract_cat, 'G', 1, share_type) = 1) f, --if extraction amount is based on Gross retrieve all records otherwise retrieve records of Net Retention only
                (SELECT claim_id, item_no, peril_cd, intm_no, shr_intm_pct
                   FROM gicl_intm_itmperil
                  WHERE p_print_option = 4
                     OR p_intm_no IS NOT NULL) g   
          WHERE NVL(b.cancel_tag, 'N') = 'N' 
            AND a.claim_id = b.claim_id 
            AND b.claim_id = c.claim_id 
            AND a.recovery_id = b.recovery_id 
            AND b.recovery_id = c.recovery_id 
            AND b.claim_id = d.claim_id 
            AND TRUNC(b.tran_date) BETWEEN p_prev1_date AND p_prev2_date
            AND c.claim_id = e.claim_id
            AND c.clm_loss_id = e.clm_loss_id
            AND (d.line_cd, d.iss_cd) IN (
                                         SELECT line_cd, branch_cd
                                           FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                        )            
            --AND check_user_per_iss_cd2(d.line_cd, d.iss_cd, 'GICLS204', p_user_id) = 1
            AND d.line_cd = NVL(p_line_cd, d.line_cd)
            AND d.subline_cd = NVL(p_subline_cd, d.subline_cd)
            AND DECODE (p_issue_param, 1, d.iss_cd, 2, d.pol_iss_cd, 1) = NVL (p_iss_cd, DECODE (p_issue_param, 1, d.iss_cd, 2, d.pol_iss_cd, 1))  
            AND d.assd_no = NVL(p_assd_no, d.assd_no) 
            AND c.peril_cd = NVL(p_peril_cd, c.peril_cd)  
            AND b.recovery_id = f.recovery_id (+)
            AND b.recovery_payt_id = f.recovery_payt_id(+)  
            --retrieve parameter that will determine if loss recovery will be considered for loss ratio, depending on their value: 'Y' for yes; 'N' for no; 'S' for booking if loss date is the same year as recovery date
            AND DECODE(GIISP.V('BOOK_RECOVERY_LRATIO'), 'Y', 1, 'S', TO_CHAR(TRUNC(d.loss_date),'YYYY'), 1) = DECODE(GIISP.V('BOOK_RECOVERY_LRATIO'), 'Y', 1, 'S', TO_CHAR(TRUNC(b.tran_date),'YYYY'), 0)     
            AND c.claim_id = g.claim_id (+)
            AND c.item_no = g.item_no (+)
            AND c.peril_cd = g.peril_cd (+)  
            AND DECODE(p_intm_no, NULL, 1, g.intm_no) = NVL(p_intm_no, 1)              
          GROUP BY d.assd_no, b.recovery_id, d.line_cd,
                d.subline_cd, d.iss_cd, c.peril_cd, g.intm_no;
                
         IF SQL%FOUND THEN
         p_prev_exists := 'Y';
           FORALL i IN vv_rec_id.first..vv_rec_id.last
             INSERT INTO gicl_lratio_prev_recovery_ext
               (session_id,     recovery_id,     assd_no,
                line_cd,        subline_cd,      iss_cd,
                peril_cd,       recovered_amt,   intm_no,   user_id)
             VALUES
               (p_session_id,   vv_rec_id(i),     vv_assd_no(i),
                vv_line_cd(i),  vv_subline_cd(i), vv_iss_cd(i),
                vv_peril_cd(i), vv_rec_amt(i),    vv_intm_no(i),    p_user_id);
           
           vv_rec_id.DELETE;
           vv_assd_no.DELETE;
           vv_rec_amt.DELETE;
           vv_line_cd.DELETE;
           vv_subline_cd.DELETE;
           vv_iss_cd.DELETE;
           vv_peril_cd.DELETE;
           vv_intm_no.DELETE;
           
         END IF;       
      END;
      
      BEGIN 
      --extract current year recovery amount
      --delete records in extract table for the current user
        DELETE gicl_lratio_curr_recovery_ext
         WHERE user_id = p_user_id;
         
          SELECT d.assd_no, b.recovery_id, d.line_cd,
                d.subline_cd, d.iss_cd, c.peril_cd,
                SUM(NVL(b.recovered_amt,0) * (NVL(c.recoverable_amt,0) / Get_Rec_Amt(c.recovery_id)) * NVL(f.share_pct, 100)/100 * NVL(g.shr_intm_pct,100)/100) recovered_amt,
                g.intm_no 
           BULK COLLECT
           INTO vv_assd_no,    vv_rec_id,     vv_line_cd,
                vv_subline_cd, vv_iss_cd,     vv_peril_cd,
                vv_rec_amt, vv_intm_no
           FROM gicl_clm_recovery a, gicl_recovery_payt b, gicl_clm_recovery_dtl c,
                gicl_claims d, gicl_clm_loss_exp e,
                (SELECT DISTINCT recovery_id, recovery_payt_id, 
                        DECODE(p_extract_cat, 'G', 100, share_pct) share_pct --multiply 100 if extraction is Gross else multiply share of Net Retention only
                   FROM gicl_recovery_ds
                  WHERE NVL (negate_tag, 'N') <> 'Y'
                    AND DECODE(p_extract_cat, 'G', 1, share_type) = 1) f, --if extraction amount is based on Gross retrieve all records otherwise retrieve records of Net Retention only
                (SELECT claim_id, item_no, peril_cd, intm_no, shr_intm_pct
                   FROM gicl_intm_itmperil
                  WHERE p_print_option = 4
                     OR p_intm_no IS NOT NULL) g   
          WHERE NVL(b.cancel_tag, 'N') = 'N' 
            AND a.claim_id = b.claim_id 
            AND b.claim_id = c.claim_id 
            AND a.recovery_id = b.recovery_id 
            AND b.recovery_id = c.recovery_id 
            AND b.claim_id = d.claim_id 
            AND TRUNC(b.tran_date) BETWEEN p_curr1_date AND p_curr2_date
            AND c.claim_id = e.claim_id
            AND c.clm_loss_id = e.clm_loss_id
            AND (d.line_cd, d.iss_cd) IN (
                                         SELECT line_cd, branch_cd
                                           FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                        )            
            --AND check_user_per_iss_cd2(d.line_cd, d.iss_cd, 'GICLS204', p_user_id) = 1
            AND d.line_cd = NVL(p_line_cd, d.line_cd)
            AND d.subline_cd = NVL(p_subline_cd, d.subline_cd)
            AND DECODE (p_issue_param, 1, d.iss_cd, 2, d.pol_iss_cd, 1) = NVL (p_iss_cd, DECODE (p_issue_param, 1, d.iss_cd, 2, d.pol_iss_cd, 1))  
            AND d.assd_no = NVL(p_assd_no, d.assd_no) 
            AND c.peril_cd = NVL(p_peril_cd, c.peril_cd)  
            AND b.recovery_id = f.recovery_id (+)
            AND b.recovery_payt_id = f.recovery_payt_id(+)  
            --retrieve parameter that will determine if loss recovery will be considered for loss ratio, depending on their value: 'Y' for yes; 'N' for no; 'S' for booking if loss date is the same year as recovery date
            AND DECODE(GIISP.V('BOOK_RECOVERY_LRATIO'), 'Y', 1, 'S', TO_CHAR(TRUNC(d.loss_date),'YYYY'), 1) = DECODE(GIISP.V('BOOK_RECOVERY_LRATIO'), 'Y', 1, 'S', TO_CHAR(TRUNC(b.tran_date),'YYYY'), 0)     
            AND c.claim_id = g.claim_id (+)
            AND c.item_no = g.item_no (+)
            AND c.peril_cd = g.peril_cd (+)  
            AND DECODE(p_intm_no, NULL, 1, g.intm_no) = NVL(p_intm_no, 1)              
          GROUP BY d.assd_no, b.recovery_id, d.line_cd,
                d.subline_cd, d.iss_cd, c.peril_cd, g.intm_no;
                
         IF SQL%FOUND THEN
         p_curr_exists := 'Y';
           FORALL i IN vv_rec_id.first..vv_rec_id.last
             INSERT INTO gicl_lratio_curr_recovery_ext
               (session_id,     recovery_id,     assd_no,
                line_cd,        subline_cd,      iss_cd,
                peril_cd,       recovered_amt,   intm_no,   user_id)
             VALUES
               (p_session_id,   vv_rec_id(i),     vv_assd_no(i),
                vv_line_cd(i),  vv_subline_cd(i), vv_iss_cd(i),
                vv_peril_cd(i), vv_rec_amt(i),    vv_intm_no(i),    p_user_id);
           
           vv_rec_id.DELETE;
           vv_assd_no.DELETE;
           vv_rec_amt.DELETE;
           vv_line_cd.DELETE;
           vv_subline_cd.DELETE;
           vv_iss_cd.DELETE;
           vv_peril_cd.DELETE;
           vv_intm_no.DELETE;
           
         END IF;       
      END;
   END LRATIO_EXTRACT_RECOVERY;
   
   PROCEDURE lratio_extract_premium(
      p_line_cd             gicl_claims.line_cd%TYPE,
      p_subline_cd          gicl_claims.subline_cd%TYPE,
      p_iss_cd              gicl_claims.iss_cd%TYPE,
      p_intm_no             gicl_intm_itmperil.intm_no%TYPE,
      p_assd_no             gicl_claims.assd_no%TYPE,
      p_peril_cd            gicl_clm_res_hist.peril_cd%TYPE,
      p_session_id          gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param          NUMBER,
      p_issue_param         NUMBER,
      p_curr1_date          gipi_polbasic.issue_date%TYPE,       --First Day of As Of Date parameter minus 11 months(24th Method) / First Day of the year based on the year of parameter (Straight)
      p_curr2_date          gipi_polbasic.issue_date%TYPE,       --Last Day of As Of Date parameter(24th Method) / As Of Date parameter (Straight)
      p_prev1_date          gipi_polbasic.issue_date%TYPE,       --p_curr1_date minus 1 year
      p_prev2_date          gipi_polbasic.issue_date%TYPE,       --p_curr2_date minus 1 year
      p_curr_exists    OUT  VARCHAR2,
      p_prev_exists    OUT  VARCHAR2,
      p_extract_cat         VARCHAR2,   --Extract Amount By : G-GROSS or N-NET
      p_print_option        NUMBER,     --Print Report By:   4-Per Intermediary
      p_user_id             giis_users.user_id%TYPE
   ) AS 
      TYPE policy_id_tab   IS TABLE OF gipi_polbasic.policy_id%TYPE;
      TYPE curr_prem_tab   IS TABLE OF gipi_polbasic.prem_amt%TYPE;
      TYPE assd_no_tab     IS TABLE OF giis_assured.assd_no%TYPE;
      TYPE line_cd_tab     IS TABLE OF giis_line.line_cd%TYPE;
      TYPE subline_cd_tab  IS TABLE OF giis_subline.subline_cd%TYPE;
      TYPE iss_cd_tab      IS TABLE OF giis_issource.iss_cd%TYPE;
      TYPE peril_cd_tab    IS TABLE OF giis_peril.peril_cd%TYPE;
      TYPE intm_no_tab     IS TABLE OF giis_intermediary.intm_no%TYPE;
      TYPE date24_tab      IS TABLE OF VARCHAR2(10);
      
      vv_policy_id         policy_id_tab;
      vv_prem              curr_prem_tab;
      vv_assd_no           assd_no_tab;
      vv_line_cd           line_cd_tab;
      vv_subline_cd        subline_cd_tab;
      vv_iss_cd            iss_cd_tab;
      vv_peril_cd          peril_cd_tab;
      vv_intm_no           intm_no_tab;
      vv_date24            date24_tab;
   BEGIN
      p_curr_exists := 'N';
      p_prev_exists := 'N';
      BEGIN 
        --extract current year premiums written
        --delete records in extract table for the current user
        DELETE gicl_lratio_curr_prem_ext
         WHERE user_id = p_user_id;
         
            SELECT b.policy_id, b.line_cd, b.subline_cd, b.iss_cd, g.peril_cd, d.assd_no,
                   SUM(NVL(g.dist_prem * e.currency_rt, 0) * NVL(c.shr_pct,100)/100 * DECODE(p_date_param, 3, GET_MULTIPLIER(a.acct_ent_date, a.acct_neg_date, p_curr1_date, p_curr2_date), 1)) prem_amt,
                   /*TO_CHAR (TRUNC (DECODE (p_date_param, -- Dren Niebres 07.12.2016 SR-21428 - Start
                                           1, b.issue_date,
                                           2, b.eff_date,
                                           3, b.acct_ent_date,
                                           4, LAST_DAY (TO_DATE (UPPER (b.booking_mth)
                                                                 || ' 1,'
                                                                 || TO_CHAR (b.booking_year),
                                                                 'FMMONTH DD,YYYY')
                                                       ),
                                           SYSDATE
                                          )
                                  ),'MM-DD-YYYY'
                           ),*/
                   TO_CHAR (TRUNC (b.incept_date),'MM-DD-YYYY'),  -- Dren Niebres 07.12.2016 SR-21428 - End
                   c.intm_no
              BULK COLLECT INTO vv_policy_id,  vv_line_cd, vv_subline_cd, vv_iss_cd, vv_peril_cd,   
                                vv_assd_no,    
                                vv_prem,       
                                vv_date24, vv_intm_no
              FROM gipi_polbasic b, giuw_pol_dist a, giuw_perilds_dtl g, gipi_invoice e,
                   (SELECT DISTINCT intrmdry_intm_no intm_no, iss_cd, prem_seq_no, share_percentage shr_pct  
                      FROM gipi_comm_invoice
                     WHERE p_print_option = 4
                        OR p_intm_no IS NOT NULL) c,
                   (SELECT b.policy_id,
                           get_latest_assured_no (b.line_cd,
                                                b.subline_cd,
                                                b.iss_cd,
                                                b.issue_yy,
                                                b.pol_seq_no,
                                                b.renew_no,
                                                p_curr1_date,
                                                p_curr2_date
                                               ) assd_no
                     FROM gipi_polbasic b) d
             WHERE a.policy_id = b.policy_id           
               AND a.policy_id = d.policy_id
               AND g.dist_no = a.dist_no
               AND a.policy_id = e.policy_id
               AND (b.pol_flag != '5' OR DECODE (p_date_param, 3, 1, 0) = 1)
               AND NVL (b.endt_type, 'A') = 'A'
               AND ((a.dist_flag = 3 AND b.dist_flag = 3) OR p_date_param = 3)
               AND (   TRUNC (b.issue_date) BETWEEN p_curr1_date AND p_curr2_date
                    OR DECODE (p_date_param, 1, 0, 1) = 1
                   )
               AND (   TRUNC (b.eff_date) BETWEEN p_curr1_date AND p_curr2_date
                    OR DECODE (p_date_param, 2, 0, 1) = 1
                   )
               AND (   LAST_DAY (TO_DATE (NVL (e.multi_booking_mm, b.booking_mth)
                                          || ','
                                          || TO_CHAR (NVL (e.multi_booking_yy,
                                                           b.booking_year
                                                          )
                                                     ),
                                          'FMMONTH,YYYY'
                                         )
                                ) BETWEEN LAST_DAY (p_curr1_date) AND LAST_DAY (p_curr2_date)
                    OR DECODE (p_date_param, 4, 0, 1) = 1
                   )
               AND (   (   TRUNC (a.acct_ent_date) BETWEEN p_curr1_date AND p_curr2_date
                        OR (    (TRUNC (a.acct_neg_date) BETWEEN p_curr1_date AND p_curr2_date
                                )
                            AND p_date_param = 3
                           )
                       )
                    OR DECODE (p_date_param, 3, 0, 1) = 1
                   )
               AND b.line_cd = NVL (p_line_cd, b.line_cd)
               AND b.subline_cd = NVL (p_subline_cd, b.subline_cd)
               AND b.iss_cd = NVL (p_iss_cd, b.iss_cd)
               AND g.peril_cd = NVL (p_peril_cd, g.peril_cd)
               AND a.item_grp = e.item_grp
               AND a.takeup_seq_no = e.takeup_seq_no
               --AND DECODE (p_assd_no, NULL, 1, d.assd_no) = NVL (p_assd_no, 1)
               AND (d.assd_no = p_assd_no OR p_assd_no IS NULL)
               AND DECODE(p_extract_cat, 'G', 1, share_cd) = 1 --if extraction amount is based on Gross retrieve all records otherwise retrieve records of Net Retention only
               --AND DECODE(p_intm_no, NULL, 1, c.intm_no) = NVL(p_intm_no, 1)
               AND (c.intm_no = p_intm_no OR p_intm_no IS NULL)
               AND e.iss_cd = c.iss_cd (+)
               AND e.prem_seq_no = c.prem_seq_no (+)
               AND (b.line_cd, b.iss_cd) IN (
                                             SELECT line_cd, branch_cd
                                               FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                            )   
               --AND check_user_per_iss_cd2(b.line_cd, b.iss_cd, 'GICLS204', p_user_id) = 1
             GROUP BY b.policy_id, b.line_cd, b.subline_cd, b.iss_cd, g.peril_cd, d.assd_no,
                    TO_CHAR (TRUNC (b.incept_date),'MM-DD-YYYY'), -- Dren Niebres 07.12.2016 SR-21428 
                    c.intm_no;

         IF SQL%FOUND THEN
            p_curr_exists := 'Y';
            FORALL i IN vv_policy_id.first..vv_policy_id.last
               INSERT INTO gicl_lratio_curr_prem_ext
               (session_id,     assd_no,          policy_id,
                line_cd,        subline_cd,       iss_cd, 
                peril_cd,       prem_amt,         user_id, 
                date_for_24th,  intm_no)
               VALUES
               (p_session_id,   vv_assd_no(i),    vv_policy_id(i),
                vv_line_cd(i),  vv_subline_cd(i), vv_iss_cd(i), 
                vv_peril_cd(i), vv_prem(i),       p_user_id, 
                TO_DATE(vv_date24(i),'MM-DD-YYYY'), vv_intm_no(i));
           
           vv_assd_no.DELETE;
           vv_policy_id.DELETE;
           vv_prem.DELETE;
           vv_line_cd.DELETE;
           vv_subline_cd.DELETE;
           vv_iss_cd.DELETE;
           vv_peril_cd.DELETE;
           vv_date24.DELETE;
           vv_intm_no.DELETE;
           
         END IF;
      END;   
      
      BEGIN 
        --extract previous year premiums written
        --delete records in extract table for the current user
        DELETE gicl_lratio_prev_prem_ext
         WHERE user_id = p_user_id;
         
            SELECT b.policy_id, b.line_cd, b.subline_cd, b.iss_cd, g.peril_cd, d.assd_no,
                   SUM(NVL(g.dist_prem * e.currency_rt, 0) * NVL(c.shr_pct,100)/100 * DECODE(p_date_param, 3, GET_MULTIPLIER(a.acct_ent_date, a.acct_neg_date, p_prev1_date, p_prev2_date), 1)) prem_amt,
                   TO_CHAR (TRUNC (DECODE (p_date_param,
                                           1, b.issue_date,
                                           2, b.eff_date,
                                           3, b.acct_ent_date,
                                           4, LAST_DAY (TO_DATE (UPPER (b.booking_mth)
                                                                 || ' 1,'
                                                                 || TO_CHAR (b.booking_year),
                                                                 'FMMONTH DD,YYYY')
                                                       ),
                                           SYSDATE
                                          )
                                  ),'MM-DD-YYYY'
                           ), c.intm_no
              BULK COLLECT INTO vv_policy_id,  vv_line_cd, vv_subline_cd, vv_iss_cd, vv_peril_cd,   
                                vv_assd_no,    
                                vv_prem,       
                                vv_date24, vv_intm_no
              FROM gipi_polbasic b, giuw_pol_dist a, giuw_perilds_dtl g, gipi_invoice e,
                   (SELECT DISTINCT intrmdry_intm_no intm_no, iss_cd, prem_seq_no, share_percentage shr_pct  
                      FROM gipi_comm_invoice
                     WHERE p_print_option = 4
                        OR p_intm_no IS NOT NULL) c,
                   (SELECT b.policy_id,
                           get_latest_assured_no (b.line_cd,
                                                b.subline_cd,
                                                b.iss_cd,
                                                b.issue_yy,
                                                b.pol_seq_no,
                                                b.renew_no,
                                                p_curr1_date,
                                                p_curr2_date
                                               ) assd_no
                     FROM gipi_polbasic b) d
             WHERE a.policy_id = b.policy_id
               AND a.policy_id = d.policy_id
               AND g.dist_no = a.dist_no
               AND a.policy_id = e.policy_id
               AND (b.pol_flag != '5' OR DECODE (p_date_param, 3, 1, 0) = 1)
               AND NVL (b.endt_type, 'A') = 'A'
               AND ((a.dist_flag = 3 AND b.dist_flag = 3) OR p_date_param = 3)
               AND (   TRUNC (b.issue_date) BETWEEN p_prev1_date AND p_prev2_date
                    OR DECODE (p_date_param, 1, 0, 1) = 1
                   )
               AND (   TRUNC (b.eff_date) BETWEEN p_prev1_date AND p_prev2_date
                    OR DECODE (p_date_param, 2, 0, 1) = 1
                   )
               AND (   LAST_DAY (TO_DATE (NVL (e.multi_booking_mm, b.booking_mth)
                                          || ','
                                          || TO_CHAR (NVL (e.multi_booking_yy,
                                                           b.booking_year
                                                          )
                                                     ),
                                          'FMMONTH,YYYY'
                                         )
                                ) BETWEEN LAST_DAY (p_prev1_date) AND LAST_DAY (p_prev2_date)
                    OR DECODE (p_date_param, 4, 0, 1) = 1
                   )
               AND (   (   TRUNC (a.acct_ent_date) BETWEEN p_prev1_date AND p_prev2_date
                        OR (    (TRUNC (a.acct_neg_date) BETWEEN p_prev1_date AND p_prev2_date
                                )
                            AND p_date_param = 3
                           )
                       )
                    OR DECODE (p_date_param, 3, 0, 1) = 1
                   )
               AND b.line_cd = NVL (p_line_cd, b.line_cd)
               AND b.subline_cd = NVL (p_subline_cd, b.subline_cd)
               AND b.iss_cd = NVL (p_iss_cd, b.iss_cd)
               AND g.peril_cd = NVL (p_peril_cd, g.peril_cd)
               AND a.item_grp = e.item_grp
               AND a.takeup_seq_no = e.takeup_seq_no
               --AND DECODE(p_assd_no, NULL, 1, d.assd_no) = NVL(p_assd_no, 1) 
               AND (d.assd_no = p_assd_no OR p_assd_no IS NULL)
               AND DECODE(p_extract_cat, 'G', 1, share_cd) = 1 --if extraction amount is based on Gross retrieve all records otherwise retrieve records of Net Retention only
               --AND DECODE(p_intm_no, NULL, 1, c.intm_no) = NVL(p_intm_no, 1)
               AND (c.intm_no = p_intm_no OR p_intm_no IS NULL)
               AND e.iss_cd = c.iss_cd (+)
               AND e.prem_seq_no = c.prem_seq_no (+)
               AND (b.line_cd, b.iss_cd) IN (
                                             SELECT line_cd, branch_cd
                                               FROM TABLE (security_access.get_branch_line('CL', 'GICLS204', p_user_id))
                                            )
               --AND check_user_per_iss_cd2(b.line_cd, b.iss_cd, 'GICLS204', p_user_id) = 1
             GROUP BY b.policy_id, b.line_cd, b.subline_cd, b.iss_cd, g.peril_cd, d.assd_no,
                   TO_CHAR (TRUNC (DECODE (p_date_param,
                                           1, b.issue_date,
                                           2, b.eff_date,
                                           3, b.acct_ent_date,
                                           4, LAST_DAY (TO_DATE (UPPER (b.booking_mth)
                                                                 || ' 1,'
                                                                 || TO_CHAR (b.booking_year),
                                                                 'FMMONTH DD,YYYY')
                                                       ),
                                           SYSDATE
                                          )
                                  ),'MM-DD-YYYY'
                           ), c.intm_no;

        IF SQL%FOUND THEN
        p_prev_exists := 'Y';
           FORALL i IN vv_policy_id.first..vv_policy_id.last
             INSERT INTO gicl_lratio_prev_prem_ext
               (session_id,     assd_no,          policy_id,
                line_cd,        subline_cd,       iss_cd, 
                peril_cd,       prem_amt,         user_id, 
                date_for_24th,  intm_no)
             VALUES
               (p_session_id,   vv_assd_no(i),    vv_policy_id(i),
                vv_line_cd(i),  vv_subline_cd(i), vv_iss_cd(i), 
                vv_peril_cd(i), vv_prem(i),       p_user_id, 
                TO_DATE(vv_date24(i),'MM-DD-YYYY'), vv_intm_no(i));
           
           vv_assd_no.DELETE;
           vv_policy_id.DELETE;
           vv_prem.DELETE;
           vv_line_cd.DELETE;
           vv_subline_cd.DELETE;
           vv_iss_cd.DELETE;
           vv_peril_cd.DELETE;
           vv_date24.DELETE;
           vv_intm_no.DELETE;
           
        END IF;
      END;   
   END;
   
   FUNCTION get_reversal(
      p_tran_id            IN gicl_clm_res_hist.tran_id%TYPE,
      p_from_date          IN DATE,
      p_to_date            IN DATE
   ) RETURN NUMBER IS
      v_multiplier NUMBER(1) := 1;
   BEGIN
     --return negative amount if posting date or tran date of reversal is between parameter date by MAC 07/17/2013.
      FOR i IN (SELECT DISTINCT 1
                  FROM giac_reversals a, giac_acctrans b
                 WHERE a.reversing_tran_id = b.tran_id 
                   AND a.gacc_tran_id = p_tran_id
                   AND TRUNC(tran_date) BETWEEN p_from_date AND p_to_date)
      LOOP
        v_multiplier := -1; 
      END LOOP;
      
      RETURN (v_multiplier);
   END;
   
   FUNCTION get_multiplier(
      p_acct_ent_date   IN DATE,
      p_acct_neg_date   IN DATE,
      p_from_date       IN DATE,
      p_to_date         IN DATE
   ) RETURN NUMBER IS
   BEGIN
      IF TRUNC (p_acct_ent_date) BETWEEN p_from_date AND p_to_date AND TRUNC (p_acct_neg_date) BETWEEN p_from_date AND p_to_date THEN
         RETURN (0);
      ELSIF TRUNC (p_acct_ent_date) BETWEEN p_from_date AND p_to_date THEN
         RETURN (1);
      ELSIF TRUNC (p_acct_neg_date) BETWEEN p_from_date AND p_to_date THEN
         RETURN (-1);
      END IF;
              
      RETURN(1);
   END;
END gicls204_pkg;
/
