CREATE OR REPLACE PACKAGE BODY CPI.gicls263_pkg
AS
   FUNCTION get_make_lov_list (p_user_id VARCHAR2)
      RETURN get_make_lov_tab PIPELINED
   IS
      v_list   get_make_lov_type;
   BEGIN
      FOR i IN (SELECT   a.make_cd, a.make, b.car_company, a.car_company_cd
                    FROM giis_mc_make a, giis_mc_car_company b
                   WHERE a.car_company_cd = b.car_company_cd
                ORDER BY make_cd)
      LOOP
         v_list.make_cd := i.make_cd;
         v_list.make := i.make;
         v_list.car_company := i.car_company;
         v_list.car_company_cd := i.car_company_cd;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_make_lov_list;

   FUNCTION get_make_details (
      p_make_cd          NUMBER,
      p_car_company_cd   NUMBER,
      p_user_id          giis_users.user_id%TYPE,
      p_search_by        VARCHAR2,
      p_as_of_date       VARCHAR2,
      p_from_date        VARCHAR2,
      p_to_date          VARCHAR2
   )
      RETURN get_make_details_tab PIPELINED
   IS
      v_list    get_make_details_type;
      line_cd   giis_line.line_cd%TYPE      := NULL;
      iss_cd    giis_issource.iss_cd%TYPE   := NULL;
   BEGIN
      FOR i IN
         (SELECT   a.claim_id, a.item_no,
                   a.item_title, a.plate_no,
                      c.line_cd
                   || '-'
                   || c.subline_cd
                   || '-'
                   || c.iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (c.issue_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (c.pol_seq_no, '0999999'))
                   || '-'
                   || LTRIM (TO_CHAR (c.renew_no, '09')) policy_no,
                   c.line_cd, c.subline_cd, c.iss_cd, c.issue_yy, c.pol_seq_no, c.renew_no,
                   c.clm_yy, c.clm_seq_no, c.pol_iss_cd, c.assd_no,
                   c.loss_date, c.clm_file_date, d.assd_name,
                   e.clm_stat_desc, a.motcar_comp_cd, a.make_cd
              FROM gicl_motor_car_dtl a,
                   gicl_claims c,
                   giis_assured d,
                   giis_clm_stat e
             WHERE c.claim_id = a.claim_id
               AND c.assd_no = d.assd_no
               AND c.clm_stat_cd = e.clm_stat_cd
               AND a.claim_id IN (
                      SELECT claim_id
                        FROM gicl_claims
                       WHERE check_user_per_line2 (line_cd,
                                                   iss_cd,
                                                   'GICLS263',
                                                   p_user_id
                                                  ) = 1)
               AND a.make_cd = p_make_cd
               AND a.motcar_comp_cd = p_car_company_cd
               AND ((       (DECODE (p_search_by,
                                    'lossDate', TO_DATE (c.loss_date),
                                    'claimFileDate', TO_DATE (c.clm_file_date)
                                   ) >= TO_DATE (p_from_date, 'MM-DD-YYYY')
                           )
                       AND (DECODE (p_search_by,
                                    'lossDate', TO_DATE (c.loss_date),
                                    'claimFileDate', TO_DATE (c.clm_file_date)
                                   ) <= TO_DATE (p_to_date, 'MM-DD-YYYY')
                           ))
                    OR (DECODE (p_search_by,
                                'lossDate', TO_DATE (c.loss_date),
                                'claimFileDate', TO_DATE (c.clm_file_date)
                               ) <= TO_DATE (p_as_of_date, 'MM-DD-YYYY')
                       )
                  ) 
          GROUP BY a.claim_id,
                   a.item_no,
                   a.item_title,
                   a.plate_no,
                   c.line_cd,
                   c.clm_yy,
                   c.clm_seq_no,
                   c.pol_iss_cd,
                   c.assd_no,
                   c.renew_no,
                   c.loss_date,
                   c.clm_file_date,
                   d.assd_name,
                   e.clm_stat_desc,
                   c.subline_cd,
                   c.iss_cd,
                   c.issue_yy,
                   c.pol_seq_no,
                   a.motcar_comp_cd,
                   a.make_cd
          ORDER BY a.claim_id DESC)
      LOOP
         v_list.claim_id := i.claim_id;
         v_list.item_no := i.item_no;
         v_list.item_title := i.item_title;
         v_list.plate_no := i.plate_no;
         v_list.claim_number := get_claim_number (i.claim_id);
         --v_list.policy_no := i.policy_no;
         v_list.policy_no := get_policy_no(get_policy_id(i.line_cd, i.subline_cd, i.pol_iss_cd, i.issue_yy, i.pol_seq_no, i.renew_no));
         v_list.assd_name := i.assd_name;
         v_list.clm_stat_desc := i.clm_stat_desc;
         v_list.loss_date := i.loss_date;
         v_list.clm_file_date := i.clm_file_date;

         BEGIN
            FOR b IN (SELECT SUM (a.convert_rate * NVL (a.loss_reserve, 0)
                                 ) loss_reserve,
                             SUM (NVL (a.losses_paid, 0)) losses_paid,
                             SUM (a.convert_rate * NVL (a.expense_reserve, 0)
                                 ) exp_reserve,
                             SUM (NVL (a.expenses_paid, 0)) exp_paid
                        FROM gicl_clm_reserve a
                       WHERE a.claim_id = i.claim_id
                             AND a.item_no = i.item_no)
            LOOP
               v_list.loss_res_amt := NVL (b.loss_reserve, 0);
               v_list.loss_paid_amt := NVL (b.losses_paid, 0);
               v_list.exp_res_amt := NVL (b.exp_reserve, 0);
               v_list.exp_paid_amt := NVL (b.exp_paid, 0);
            END LOOP;
         END;     

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_make_details;
END;
/


