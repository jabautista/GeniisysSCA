CREATE OR REPLACE PACKAGE BODY CPI.giclr266_pkg
AS
   FUNCTION get_giclr266_report (
      p_module_id       VARCHAR2,
      p_user_id         VARCHAR2,
      p_intm_no         NUMBER,
      p_search_by_opt   VARCHAR2,
      p_date_as_of      VARCHAR2,
      p_date_from       VARCHAR2,
      p_date_to         VARCHAR2
   )
      RETURN report_tab PIPELINED
   IS
      v_list   report_type;
   BEGIN
      FOR i IN
         (SELECT  DISTINCT a.claim_id, a.line_cd line_cd,
                             a.line_cd
                          || '-'
                          || a.subline_cd
                          || '-'
                          || a.pol_iss_cd
                          || '-'
                          || LTRIM (TO_CHAR (a.issue_yy, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (a.pol_seq_no, '0000009'))
                          || '-'
                          || LTRIM (TO_CHAR (a.renew_no, '09'))
                                                               policy_number,
                          a.assured_name, a.loss_date, a.clm_file_date
                     FROM giis_intermediary b,
                          gicl_intm_itmperil c,
                          gicl_claims a,
                          gicl_clm_item d,
                          giis_clm_stat e,
                          gicl_clm_res_hist f
                    WHERE c.intm_no = b.intm_no
                      AND a.claim_id = c.claim_id
                      AND a.claim_id = d.claim_id
                      AND a.claim_id = f.claim_id
                      AND c.item_no = d.item_no
                      AND a.clm_stat_cd = e.clm_stat_cd
                      AND c.intm_no = NVL (p_intm_no, c.intm_no)
                      AND c.peril_cd = f.peril_cd
                      AND c.item_no = f.item_no
                      AND check_user_per_line2 (a.line_cd,
                                                a.iss_cd,
                                                p_module_id,
                                                p_user_id
                                               ) = 1
                      AND (   (    (DECODE (p_search_by_opt,
                                            'lossDate', TRUNC(a.loss_date),
                                            'fileDate', TRUNC(clm_file_date)
                                           ) >=
                                           TO_DATE (p_date_from, 'MM-DD-YYYY')
                                   )
                               AND (DECODE (p_search_by_opt,
                                            'lossDate', TRUNC(a.loss_date),
                                            'fileDate', TRUNC(clm_file_date)
                                           ) <=
                                             TO_DATE (p_date_to, 'MM-DD-YYYY')
                                   )
                              )
                           OR (DECODE (p_search_by_opt,
                                       'lossDate', TRUNC(a.loss_date),
                                       'fileDate', TRUNC(clm_file_date)
                                      ) <=
                                          TO_DATE (p_date_as_of, 'MM-DD-YYYY')
                              )
                          ))
      LOOP
         v_list.line_cd := i.line_cd;
         v_list.claim_id := i.claim_id;
         v_list.claim_number := get_clm_no (i.claim_id);
         v_list.policy_number := i.policy_number;
         v_list.assured_name := i.assured_name;
         v_list.loss_date := i.loss_date;
         v_list.clm_file_date := i.clm_file_date;
         
         
         IF v_list.intm IS NULL THEN
             BEGIN
                SELECT  LTRIM(TO_CHAR (intm_no, '0009')) || '-' || intm_name
                  INTO v_list.intm
                  FROM giis_intermediary
                 WHERE intm_no = p_intm_no;    
             END;
         END IF;

         IF v_list.date_as_of IS NULL AND p_date_as_of IS NOT NULL
         THEN
            v_list.date_as_of :=
                  TRIM (TO_CHAR (TO_DATE (p_date_as_of, 'MM-DD-YYYY'),
                                 'Month')
                       )
               || TO_CHAR (TO_DATE (p_date_as_of, 'MM-DD-YYYY'), ' DD, YYYY');
         END IF;

         IF v_list.date_from IS NULL AND p_date_from IS NOT NULL
         THEN
            v_list.date_from :=
                  TRIM (TO_CHAR (TO_DATE (p_date_from, 'MM-DD-YYYY'), 'Month')
                       )
               || TO_CHAR (TO_DATE (p_date_from, 'MM-DD-YYYY'), ' DD, YYYY');
            v_list.date_to :=
                  TRIM (TO_CHAR (TO_DATE (p_date_to, 'MM-DD-YYYY'), 'Month'))
               || TO_CHAR (TO_DATE (p_date_to, 'MM-DD-YYYY'), ' DD, YYYY');
         END IF;

         IF v_list.company_name IS NULL
         THEN
            v_list.company_name := giisp.v ('COMPANY_NAME');
            v_list.company_address := giisp.v ('COMPANY_ADDRESS');
         END IF;

         PIPE ROW (v_list);
      END LOOP;
   END get_giclr266_report;

   FUNCTION get_item (p_intm_no NUMBER, p_claim_id NUMBER)
      RETURN item_tab PIPELINED
   IS
      v_list   item_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.item_no, b.item_title
                           FROM gicl_intm_itmperil a, gicl_clm_item b
                          WHERE a.intm_no = p_intm_no
                            AND a.claim_id = b.claim_id
                            AND a.item_no = b.item_no
                            AND a.claim_id = p_claim_id
                            ORDER BY a.item_no)
      LOOP
         v_list.item_no := i.item_no;
         v_list.item_title := LTRIM(TO_CHAR(i.item_no, '00009')) || '-' || i.item_title;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_item;

   FUNCTION get_details (p_intm_no NUMBER, p_claim_id NUMBER, p_line_cd VARCHAR)
      RETURN details_tab PIPELINED
   IS
      v_list   details_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.peril_cd, a.item_no, a.shr_intm_pct
                           FROM gicl_intm_itmperil a
                          WHERE a.intm_no = p_intm_no
                            AND a.claim_id = p_claim_id
                       ORDER BY a.peril_cd)
      LOOP
         v_list.shr_intm_pct := i.shr_intm_pct;

         BEGIN
            SELECT peril_cd || ' -' || peril_name
              INTO v_list.peril
              FROM giis_peril
             WHERE line_cd = p_line_cd AND peril_cd = i.peril_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.peril := i.peril_cd || ' -';
         END;
         
        BEGIN
            SELECT NVL(SUM (loss_reserve), 0)
              INTO v_list.loss_reserve
              FROM gicl_clm_reserve
             WHERE claim_id = p_claim_id
               AND item_no = i.item_no
               AND peril_cd = i.peril_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.loss_reserve := 0;
         END;
         
         BEGIN
            SELECT NVL(SUM (expense_reserve), 0)
              INTO v_list.expense_reserve
              FROM gicl_clm_reserve
             WHERE claim_id = p_claim_id
               AND item_no = i.item_no
               AND peril_cd = i.peril_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.expense_reserve := 0;
         END;
         
         BEGIN
            SELECT NVL(SUM (losses_paid), 0)
              INTO v_list.losses_paid
              FROM gicl_clm_reserve
             WHERE claim_id = p_claim_id
               AND item_no = i.item_no
               AND peril_cd = i.peril_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.losses_paid := 0;
         END;
         
         BEGIN
            SELECT NVL(SUM (expenses_paid), 0)
              INTO v_list.expenses_paid
              FROM gicl_clm_reserve
             WHERE claim_id = p_claim_id
               AND item_no = i.item_no
               AND peril_cd = i.peril_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.expenses_paid := 0;
         END;
         
--         BEGIN
--            SELECT SUM (NVL (loss_reserve, 0)), SUM (NVL (losses_paid, 0)),
--                   SUM (NVL (expense_reserve, 0)),
--                   SUM (NVL (expenses_paid, 0))
--              INTO v_list.loss_reserve, v_list.losses_paid,
--                   v_list.expense_reserve,
--                   v_list.expenses_paid
--              FROM gicl_clm_reserve
--             WHERE claim_id = p_claim_id
--               AND item_no = i.item_no
--               AND peril_cd = i.peril_cd;
--         EXCEPTION
--            WHEN NO_DATA_FOUND
--            THEN
--               v_list.loss_reserve := 0;
--               v_list.losses_paid := 0;
--               v_list.expense_reserve := 0;
--               v_list.expenses_paid := 0;
--         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_details;
END;
/


