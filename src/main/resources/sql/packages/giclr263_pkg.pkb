CREATE OR REPLACE PACKAGE BODY CPI.giclr263_pkg
AS
   FUNCTION get_giclr263_details (
      p_as_of_fdate   VARCHAR2,
      p_as_of_ldate   VARCHAR2,
      p_comp          VARCHAR2,
      p_from_fdate    VARCHAR2,
      p_from_ldate    VARCHAR2,
      p_make_cd       VARCHAR2,
      p_to_fdate      VARCHAR2,
      p_to_ldate      VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN get_giclr263_tab PIPELINED
   IS
      v_list   get_giclr263_type;
   BEGIN
      FOR i IN (SELECT   a.claim_id,
                         (LTRIM (TO_CHAR (c.make_cd)) || '-' || c.make) make,
                         (   LTRIM (TO_CHAR (e.car_company_cd))
                          || '-'
                          || e.car_company
                         ) car_company,
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (a.clm_seq_no, '0000009'))
                                                                claim_number,
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
                         || LTRIM (TO_CHAR (a.renew_no, '09')) policy_number,
                         (   LTRIM (TO_CHAR (b.item_no, '00009'))
                          || '-'
                          || b.item_title
                         ) item,
                         d.assd_name assured_name, --a.assured_name,   --kenneth 08282015 SR 4871
                         c.make_cd, b.plate_no,
                         a.dsp_loss_date, a.clm_file_date, a.loss_date
                    FROM gicl_claims a,
                         gicl_motor_car_dtl b,
                         giis_mc_make c,
                         giis_assured d,  --kenneth 08282015 SR 4871
                         giis_mc_car_company e
                   WHERE a.claim_id = b.claim_id
                     AND a.assd_no = d.assd_no  --kenneth 08282015 SR 4871
                     AND b.motcar_comp_cd = e.car_company_cd
                     AND c.make_cd = b.make_cd
                     AND e.car_company_cd = c.car_company_cd
                     AND c.make_cd = p_make_cd
                     AND e.car_company_cd = p_comp
                     AND (   (       TRUNC (a.clm_file_date) >=
                                          TO_DATE (p_from_fdate, 'MM-DD-YYYY')
                                 AND TRUNC (a.clm_file_date) <=
                                            TO_DATE (p_to_fdate, 'MM-DD-YYYY')
                              OR TRUNC (a.clm_file_date) <=
                                         TO_DATE (p_as_of_fdate, 'MM-DD-YYYY')
                             )
                          OR (       TRUNC (a.loss_date) >=
                                          TO_DATE (p_from_ldate, 'MM-DD-YYYY')
                                 AND TRUNC (a.loss_date) <=
                                            TO_DATE (p_to_ldate, 'MM-DD-YYYY')
                              OR TRUNC (a.loss_date) <=
                                         TO_DATE (p_as_of_ldate, 'MM-DD-YYYY')
                             )
                         )
                     AND check_user_per_line2 (line_cd,
                                               iss_cd,
                                               'GICLS263',
                                               p_user_id
                                              ) = 1
                GROUP BY c.make,
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (a.clm_seq_no, '0000009')),
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
                         || LTRIM (TO_CHAR (a.renew_no, '09')),
                         c.make_cd,
                         c.car_company_cd,
                         b.claim_id,
                            LTRIM (TO_CHAR (b.item_no, '00009'))
                         || '-'
                         || b.item_title,
                         b.plate_no,
                         a.dsp_loss_date,
                         d.assd_name, --a.assured_name,  --kenneth 08282015 SR 4871
                         e.car_company,
                         a.claim_id,
                            LTRIM (TO_CHAR (c.make_cd, '000000000009'))
                         || '-'
                         || c.make,
                            LTRIM (TO_CHAR (e.car_company_cd))
                         || '-'
                         || e.car_company,
                         a.clm_file_date,
                         a.loss_date
                ORDER BY claim_number, policy_number)
      LOOP
         v_list.comp_name := giisp.v ('COMPANY_NAME');
         v_list.comp_add := giisp.v ('COMPANY_ADDRESS');
         v_list.make := i.make;
         v_list.car_company := i.car_company;
         v_list.claim_number := i.claim_number;
         v_list.policy_number := i.policy_number;
         v_list.assured_name := i.assured_name;
         v_list.loss_date := i.loss_date;
         v_list.clm_file_date := i.clm_file_date;
         v_list.item := i.item;
         v_list.plate_no := i.plate_no;

         BEGIN
            IF p_as_of_fdate IS NOT NULL
            THEN
               v_list.date_type :=
                     'Claim File Date As Of '
                  || TO_CHAR (TO_DATE (p_as_of_fdate, 'mm/dd/yyyy'),
                              'fmMonth DD, RRRR'
                             );
            ELSIF p_from_fdate IS NOT NULL
            THEN
               v_list.date_type :=
                     'Claim File Date From '
                  || TO_CHAR (TO_DATE (p_from_fdate, 'mm/dd/yyyy'),
                              'Month DD, RRRR'
                             )
                  || ' To '
                  || TO_CHAR (TO_DATE (p_to_fdate, 'mm/dd/yyyy'),
                              'Month DD, RRRR'
                             );
            ELSIF p_as_of_ldate IS NOT NULL
            THEN
               v_list.date_type :=
                     'Loss Date As Of '
                  || TO_CHAR (TO_DATE (p_as_of_ldate, 'mm/dd/yyyy'),
                              'fmMonth DD, RRRR'
                             );
            ELSIF p_from_ldate IS NOT NULL
            THEN
               v_list.date_type :=
                     'Loss Date From '
                  || TO_CHAR (TO_DATE (p_from_ldate, 'mm/dd/yyyy'),
                              'Month DD, RRRR'
                             )
                  || ' To '
                  || TO_CHAR (TO_DATE (p_to_ldate, 'mm/dd/yyyy'),
                              'Month DD, RRRR'
                             );
            END IF;
         END;

         BEGIN
            SELECT SUM (a.convert_rate * a.loss_reserve)
              INTO v_list.cf_loss_reserve
              FROM gicl_clm_reserve a, gicl_motor_car_dtl b
             WHERE b.make_cd = i.make_cd
               AND b.item_no = a.item_no
               AND a.claim_id = i.claim_id
               AND a.claim_id = b.claim_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.cf_loss_reserve := 0;
         END;

         BEGIN
            SELECT SUM (a.losses_paid)
              INTO v_list.cf_loss_paid
              FROM gicl_clm_reserve a, gicl_motor_car_dtl b
             WHERE b.make_cd = i.make_cd
               AND b.item_no = a.item_no
               AND a.claim_id = i.claim_id
               AND a.claim_id = b.claim_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.cf_loss_paid := 0;
         END;

         BEGIN
            SELECT SUM (a.convert_rate * a.expense_reserve)
              INTO v_list.cf_exp_reserve
              FROM gicl_clm_reserve a, gicl_motor_car_dtl b
             WHERE b.make_cd = i.make_cd
               AND b.item_no = a.item_no
               AND a.claim_id = i.claim_id
               AND a.claim_id = b.claim_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.cf_exp_reserve := 0;
         END;

         BEGIN
            SELECT SUM (a.expenses_paid)
              INTO v_list.cf_exp_paid
              FROM gicl_clm_reserve a, gicl_motor_car_dtl b
             WHERE b.make_cd = i.make_cd
               AND b.item_no = a.item_no
               AND a.claim_id = b.claim_id
               AND a.claim_id = i.claim_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.cf_exp_paid := 0;
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_giclr263_details;
END;
/
