CREATE OR REPLACE PACKAGE BODY CPI.gicl_claims_hist_pkg
AS
   FUNCTION get_claim_item_reserve (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN gicl_clm_item_reserve_tab PIPELINED
   IS
      v_item_res   gicl_clm_item_reserve_type;
   BEGIN
      FOR gcr IN (SELECT a.*, b.line_cd
                    FROM gicl_clm_reserve a, gicl_claims b
                   WHERE a.claim_id = p_claim_id AND a.claim_id = b.claim_id)
      LOOP
         v_item_res.claim_id := gcr.claim_id;
         v_item_res.item_no := gcr.item_no;
         v_item_res.grouped_item_no := gcr.grouped_item_no;
         v_item_res.peril_cd := gcr.peril_cd;
         v_item_res.loss_reserve := gcr.loss_reserve;
         v_item_res.expense_reserve := gcr.expense_reserve;

         BEGIN
            SELECT get_gpa_item_title (p_claim_id,
                                       gcr.line_cd,
                                       gcr.item_no,
                                       gcr.grouped_item_no
                                      )
              INTO v_item_res.item_title
              FROM DUAL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         BEGIN
            SELECT get_peril_name (gcr.line_cd, gcr.peril_cd)
              INTO v_item_res.peril_name
              FROM DUAL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         PIPE ROW (v_item_res);
      END LOOP;
   END;

   FUNCTION get_claim_loss_exp_hist (
      p_claim_id          gicl_claims.claim_id%TYPE,
      p_item_no           gicl_clm_reserve.item_no%TYPE,
      p_peril_cd          gicl_clm_reserve.peril_cd%TYPE,
      p_grouped_item_no   gicl_clm_reserve.grouped_item_no%TYPE
   )
      RETURN gicl_clm_loss_exp_tab PIPELINED
   IS
      v_item_hist   gicl_clm_loss_exp_type;
   BEGIN
      FOR i IN (SELECT gcle.claim_id, gcle.item_no, gcle.grouped_item_no,
                       gcle.peril_cd, hist_seq_no, item_stat_cd, dist_sw,
                       paid_amt, net_amt, advise_amt, gcle.payee_type,
                       gcle.payee_cd, gcle.payee_class_cd
                  FROM gicl_clm_loss_exp gcle, gicl_loss_exp_payees glep
                 WHERE gcle.claim_id = glep.claim_id
                   AND gcle.item_no = glep.item_no
                   AND gcle.peril_cd = glep.peril_cd
                   AND gcle.payee_cd = glep.payee_cd
                   AND gcle.payee_type = glep.payee_type
                   AND gcle.payee_class_cd = glep.payee_class_cd
                   AND gcle.claim_id = p_claim_id
                   AND gcle.item_no = p_item_no
                   AND gcle.peril_cd = p_peril_cd
                   AND gcle.grouped_item_no = p_grouped_item_no)
      LOOP
         v_item_hist.claim_id := i.claim_id;
         v_item_hist.item_no := i.item_no;
         v_item_hist.grouped_item_no := i.grouped_item_no;
         v_item_hist.peril_cd := i.peril_cd;         
         v_item_hist.hist_seq_no := i.hist_seq_no;
         v_item_hist.item_stat_cd := i.item_stat_cd;
         v_item_hist.dist_sw := i.dist_sw;
         v_item_hist.paid_amt := i.paid_amt;
         v_item_hist.net_amt := i.net_amt;
         v_item_hist.advise_amt := i.advise_amt;
         v_item_hist.payee_type := i.payee_type;
         v_item_hist.payee_cd := i.payee_cd;
         v_item_hist.payee_class_cd := i.payee_class_cd;

         BEGIN
            SELECT DECODE (a.payee_first_name,
                           NULL, payee_last_name,
                              a.payee_last_name
                           || ', '
                           || a.payee_first_name
                           || ' '
                           || a.payee_middle_name
                          )
              INTO v_item_hist.payee_name
              FROM giis_payees a
             WHERE a.payee_class_cd = i.payee_class_cd
               AND a.payee_no = i.payee_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         PIPE ROW (v_item_hist);
      END LOOP;
   END;
END;
/


