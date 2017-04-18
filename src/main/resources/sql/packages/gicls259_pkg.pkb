CREATE OR REPLACE PACKAGE BODY CPI.gicls259_pkg
AS
   FUNCTION get_clm_list_per_payee (
      p_user_id          giis_users.user_id%TYPE,
      p_payee_cd         giis_payees.payee_no%TYPE,
      p_payee_class_cd   giis_payee_class.payee_class_cd%TYPE
   )
      RETURN clm_list_per_payee_tab PIPELINED
   IS
      v_list   clm_list_per_payee_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.claim_id, a.line_cd, a.subline_cd,
                                a.iss_cd, a.clm_yy, a.clm_seq_no,
                                a.pol_iss_cd, a.issue_yy, a.pol_seq_no,
                                a.renew_no,
                                get_claim_number (a.claim_id) claim_number,
								a.line_cd||'-'|| a.subline_cd||'-'|| a.pol_iss_cd ||'-'||LTRIM(TO_CHAR( a.issue_yy,'09')) || '-' ||LTRIM(TO_CHAR( a.pol_seq_no,'0000009')) || '-'||LTRIM(TO_CHAR( a.renew_no,'09')) policy_number,
                                a.assured_name, a.clm_file_date, a.loss_date,
                                b.payee_class_cd, b.payee_cd
                                --, b.payee_type
                           FROM gicl_claims a,
                                gicl_clm_loss_exp b,
                                giis_payee_class c,
                                giis_payees d
                          WHERE a.claim_id = b.claim_id
                            AND b.payee_cd = d.payee_no
                            AND b.payee_class_cd = d.payee_class_cd
                            AND check_user_per_line2 (a.line_cd,
                                                      a.iss_cd,
                                                      'GICLS259',
                                                      p_user_id
                                                     ) = 1
                            AND d.payee_class_cd = p_payee_class_cd
                            AND d.payee_no = p_payee_cd
                       ORDER BY a.line_cd,
                                a.subline_cd,
                                a.iss_cd,
                                a.clm_yy,
                                a.clm_seq_no,
                                a.pol_iss_cd,
                                a.issue_yy,
                                a.pol_seq_no,
                                a.renew_no)
      LOOP
         v_list.claim_number := i.claim_number;
         v_list.policy_number := i.policy_number;
         v_list.assured_name := i.assured_name;
         v_list.clm_file_date := i.clm_file_date;
         v_list.loss_date := i.loss_date;
		 v_list.claim_id := i.claim_id;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_clm_list_per_payee;

   FUNCTION get_gicls259_details (
      p_claim_id         gicl_claims.claim_id%TYPE,
      p_payee_cd         giis_payees.payee_no%TYPE,
      p_payee_class_cd   giis_payee_class.payee_class_cd%TYPE
   )
      RETURN per_payee_dtl_tab PIPELINED
   AS
      v_list   per_payee_dtl_type;
   BEGIN
      FOR i IN (SELECT   a.item_no,
                         get_gpa_item_title (a.claim_id,
                                             b.line_cd,
                                             a.item_no,
                                             a.grouped_item_no
                                            ) dsp_item,
                         a.peril_cd,
                         get_peril_name (b.line_cd, a.peril_cd) dsp_peril,
                         a.hist_seq_no, a.paid_amt, a.net_amt, a.advise_amt,
                         a.item_stat_cd, a.advice_id
                    FROM gicl_clm_loss_exp a, gicl_claims b
                   WHERE a.claim_id = p_claim_id
                     AND b.claim_id = a.claim_id
                     AND a.payee_cd = p_payee_cd
                     AND a.payee_class_cd = p_payee_class_cd
                     AND NVL (a.cancel_sw, 'N') = 'N'
                ORDER BY a.item_no, a.peril_cd, a.hist_seq_no)
      LOOP
         v_list.item_no := i.item_no;
         v_list.dsp_item := i.dsp_item;
         v_list.peril_cd := i.peril_cd;
         v_list.dsp_peril := i.dsp_peril;
         v_list.hist_seq_no := i.hist_seq_no;
         v_list.paid_amt := i.paid_amt;
         v_list.net_amt := i.net_amt;
         v_list.advice_amt := i.advise_amt;

         FOR r IN (SELECT clm_stat_desc
                     FROM giis_clm_stat
                    WHERE clm_stat_cd = i.item_stat_cd)
         LOOP
            v_list.dsp_status := INITCAP (r.clm_stat_desc);
         END LOOP;

         -- populate advice_no field
         BEGIN
            SELECT    line_cd
                   || '-'
                   || iss_cd
                   || '-'
                   || TO_CHAR (advice_year)
                   || '-'
                   || LTRIM (TO_CHAR (advice_seq_no, '000009'))
              INTO v_list.nbt_advice_no
              FROM gicl_advice
             WHERE advice_id = i.advice_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.nbt_advice_no := '--';
         END;
		 PIPE ROW (v_list);
      END LOOP;
   END get_gicls259_details;
END;
/


