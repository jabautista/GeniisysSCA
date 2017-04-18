CREATE OR REPLACE PACKAGE BODY CPI.GICLS262_PKG
AS
   FUNCTION get_vessel_lov
      RETURN vessel_lov_tab PIPELINED
   IS
      v_vessel   vessel_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.vessel_cd, a.vessel_name
                           FROM giis_vessel a, gicl_hull_dtl b
                          WHERE a.vessel_cd = b.vessel_cd)
      LOOP
         v_vessel.vessel_cd := i.vessel_cd;
         v_vessel.vessel_name := i.vessel_name;
         PIPE ROW (v_vessel);
      END LOOP;

      RETURN;
   END get_vessel_lov;

   FUNCTION populate_per_vessel_details (
      p_vessel_cd    giis_vessel.vessel_cd%TYPE,
      p_search_by    NUMBER,
      p_as_of_date   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_user_id      VARCHAR2
   )
      RETURN clm_list_per_vessel_tab PIPELINED
   IS
      v_record   clm_list_per_vessel_type;
   BEGIN
      FOR i IN
         (SELECT   a.vessel_cd, a.claim_id, a.item_no, a.item_title,
                   a.dry_date, a.dry_place, b.line_cd, b.subline_cd,
                   b.issue_yy, b.pol_seq_no, b.renew_no, b.pol_iss_cd,
                   b.clm_yy, b.clm_seq_no, b.iss_cd, b.loss_date,
                   b.assured_name, b.clm_stat_cd, b.clm_file_date,
                   c.clm_stat_desc,
                      b.line_cd
                   || '-'
                   || b.subline_cd
                   || '-'
                   || b.iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (b.clm_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (b.clm_seq_no, '0000009')) claim_number,
                      b.line_cd
                   || '-'
                   || b.subline_cd
                   || '-'
                   || b.pol_iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (b.issue_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (b.pol_seq_no, '0000009'))
                   || '-'
                   || LTRIM (TO_CHAR (b.renew_no, '09')) policy_number
              FROM gicl_hull_dtl a, gicl_claims b, giis_clm_stat c
             WHERE a.vessel_cd = p_vessel_cd
               AND a.claim_id = b.claim_id
               AND b.clm_stat_cd = c.clm_stat_cd
               AND a.claim_id IN (
                      SELECT DISTINCT claim_id
                                 FROM gicl_claims
                                WHERE check_user_per_line2 (b.line_cd,
                                                            b.iss_cd,
                                                            'GICLS262',
                                                            p_user_id
                                                           ) = 1)
               AND (       DECODE (p_search_by,
                                   1, TRUNC (b.clm_file_date),
                                   2, TRUNC (b.loss_date)
                                  ) >= TO_DATE (p_from_date, 'MM-DD-YYYY')
                       AND (DECODE (p_search_by,
                                    1, TRUNC (b.clm_file_date),
                                    2, TRUNC (b.loss_date)
                                   ) <= TO_DATE (p_to_date, 'MM-DD-YYYY')
                           )
                    OR (DECODE (p_search_by,
                                1, TRUNC (b.clm_file_date),
                                2, TRUNC (b.loss_date)
                               ) <= TO_DATE (p_as_of_date, 'MM-DD-YYYY')
                       )
                   )
          ORDER BY a.claim_id)
      LOOP
         v_record.claim_id := i.claim_id;
         v_record.vessel_cd := i.vessel_cd;
         v_record.item_no := i.item_no;
         v_record.item_title := i.item_title;
         v_record.dry_date := i.dry_date;
         v_record.dry_place := i.dry_place;
         v_record.loss_date := i.loss_date;
         v_record.assured_name := i.assured_name;
         v_record.clm_file_date := i.clm_file_date;
         v_record.clm_stat_desc := i.clm_stat_desc;
         v_record.claim_number := i.claim_number;
         v_record.policy_number := i.policy_number;

         BEGIN
            SELECT nvl(SUM (loss_reserve), 0) lo_rsrv, nvl(SUM (expense_reserve), 0) exp_rsrv,
                   nvl(SUM (losses_paid), 0) lo_pd, nvl(SUM (expenses_paid), 0) exp_pd
              INTO v_record.los_res_amt, v_record.exp_res_amt,
                   v_record.los_paid_amt, v_record.exp_paid_amt
              FROM gicl_clm_reserve
             WHERE claim_id = i.claim_id AND item_no = i.item_no;
         END;
         
         BEGIN
         SELECT NVL (SUM (a.loss_reserve), 0) lo_rsrv,
               NVL (SUM (a.expense_reserve), 0) exp_rsrv,
               NVL (SUM (a.losses_paid), 0) lo_pd,
               NVL (SUM (a.expenses_paid), 0) exp_pd
            INTO v_record.tot_loss_res_amt, v_record.tot_exp_res_amt, v_record.tot_loss_pd_amt, v_record.tot_exp_pd_amt
          FROM gicl_clm_reserve a, gicl_hull_dtl b
         WHERE a.claim_id = b.claim_id
           AND a.item_no = b.item_no
           AND b.vessel_cd = i.vessel_cd;
           END;

         PIPE ROW (v_record);
      END LOOP;
   END populate_per_vessel_details;
END GICLS262_PKG;
/


