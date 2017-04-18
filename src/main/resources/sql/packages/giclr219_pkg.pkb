CREATE OR REPLACE PACKAGE BODY CPI.giclr219_pkg
AS
/*
    **  Created by   :  Ildefonso Ellarina Jr
    **  Date Created : 07.29.2013
    **  Reference By : GICLR219 - OUTSTANDING LETTER OF AUTHORITY
    */
   FUNCTION get_details (
      p_start_dt      VARCHAR2,
      p_end_dt        VARCHAR2,
      p_as_of_dt      VARCHAR2,
      p_branch_cd     VARCHAR2,
      p_subline_cd    VARCHAR2,
      p_choice_date   VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN get_details_tab PIPELINED
   IS
      v_list   get_details_type;
      v_print  BOOLEAN := TRUE;
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_list.cf_company
           FROM giis_parameters
          WHERE param_name = 'COMPANY_NAME';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.cf_company := NULL;
      END;

      BEGIN
         SELECT param_value_v
           INTO v_list.cf_com_address
           FROM giac_parameters
          WHERE param_name = 'COMPANY_ADDRESS';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.cf_com_address := NULL;
      END;

      BEGIN
         IF p_start_dt IS NOT NULL
         THEN
            v_list.cf_date :=
               (   'from '
                || TO_CHAR (TO_DATE (p_start_dt, 'MM-DD-RRRR'),
                            'fmMonth DD, YYYY'
                           )
                || ' to '
                || TO_CHAR (TO_DATE (p_end_dt, 'MM-DD-RRRR'),
                            'fmMonth DD, YYYY'
                           )
               );
         ELSE
            v_list.cf_date :=
               (   'As of '
                || TO_CHAR (TO_DATE (p_as_of_dt, 'MM-DD-RRRR'),
                            'fmMonth DD, YYYY'
                           )
               );
         END IF;
      END;

      FOR i IN
         (SELECT   claim_number, loa_number, date_generated, payee,
                   SUM (loss_amount) loss_amount
              FROM (SELECT    a.line_cd
                           || '-'
                           || a.subline_cd
                           || '-'
                           || a.iss_cd
                           || '-'
                           || LTRIM (TO_CHAR (a.clm_yy, '09'))
                           || '-'
                           || LTRIM (TO_CHAR (a.clm_seq_no, '0000009'))
                                                                 claim_number,
                              c.subline_cd
                           || '-'
                           || c.iss_cd
                           || '-'
                           || LTRIM (TO_CHAR (c.loa_yy, '09'))
                           || '-'
                           || LTRIM (TO_CHAR (c.loa_seq_no, '0000009'))
                                                                   loa_number,
                              d.payee_last_name
                           || DECODE (d.payee_first_name, NULL, NULL, ',')
                           || NVL (d.payee_first_name, ' ')
                           || DECODE (d.payee_middle_name, NULL, NULL, ',')
                           || NVL (d.payee_middle_name, ' ') payee,
                           TRUNC (NVL (c.date_gen, c.last_update)
                                 ) date_generated,
                           e.paid_amt loss_amount
                      FROM gicl_claims a,
                           gicl_eval_loa c,
                           giis_payees d,
                           gicl_clm_loss_exp e,
                           giis_line f
                     WHERE NVL (f.menu_line_cd, a.line_cd) =
                                                      giisp.v ('LINE_CODE_MC')
                       AND a.line_cd = f.line_cd
                       AND a.claim_id = c.claim_id
                       AND c.claim_id = e.claim_id
                       AND c.clm_loss_id = e.clm_loss_id
                       AND d.payee_no = e.payee_cd
                       AND e.payee_class_cd = d.payee_class_cd
                       AND e.tran_id IS NULL
                       AND NVL (e.dist_sw, 'N') = 'Y'
                       AND a.iss_cd = NVL (p_branch_cd, a.iss_cd)
                       AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
                       AND (   (    TRUNC (DECODE (p_choice_date,
                                                   'CF', a.clm_file_date,
                                                   'LS', a.loss_date,
                                                   NVL (c.date_gen,
                                                        c.last_update
                                                       )
                                                  )
                                          ) >=
                                       TRUNC (TO_DATE (p_start_dt,
                                                       'MM-DD-RRRR'
                                                      )
                                             )
                                AND TRUNC (DECODE (p_choice_date,
                                                   'CF', a.clm_file_date,
                                                   'LS', a.loss_date,
                                                   NVL (c.date_gen,
                                                        c.last_update
                                                       )
                                                  )
                                          ) <=
                                       TRUNC (TO_DATE (p_end_dt, 'MM-DD-RRRR'))
                               )
                            OR TRUNC (DECODE (p_choice_date,
                                              'CF', a.clm_file_date,
                                              'LS', a.loss_date,
                                              NVL (c.date_gen, c.last_update)
                                             )
                                     ) <=
                                    TRUNC (TO_DATE (p_as_of_dt, 'MM-DD-RRRR'))
                           )
                       AND NVL (c.cancel_sw, 'N') = 'N'
                       AND check_user_per_iss_cd2 (giisp.v ('LINE_CODE_MC'),
                                                  a.iss_cd,
                                                  'GICLS219', p_user_id
                                                 ) = 1
                    UNION
                    SELECT    a.line_cd
                           || '-'
                           || a.subline_cd
                           || '-'
                           || a.iss_cd
                           || '-'
                           || LTRIM (TO_CHAR (a.clm_yy, '09'))
                           || '-'
                           || LTRIM (TO_CHAR (a.clm_seq_no, '0000009'))
                                                                 claim_number,
                              c.subline_cd
                           || '-'
                           || c.issue_cd
                           || '-'
                           || LTRIM (TO_CHAR (c.clm_yy, '09'))
                           || '-'
                           || LTRIM (TO_CHAR (c.loa_seq_no, '0000009'))
                                                                   loa_number,
                              d.payee_last_name
                           || DECODE (d.payee_first_name, NULL, NULL, ',')
                           || NVL (d.payee_first_name, ' ')
                           || DECODE (d.payee_middle_name, NULL, NULL, ',')
                           || NVL (d.payee_middle_name, ' ') payee,
                           TRUNC (NVL (c.date_gen, c.last_update)
                                 ) date_generated,
                           e.paid_amt loss_amount
                      FROM gicl_claims a,
                           gicl_loa c,
                           giis_payees d,
                           gicl_clm_loss_exp e,
                           giis_line f
                     WHERE NVL (f.menu_line_cd, a.line_cd) =
                                                      giisp.v ('LINE_CODE_MC')
                       AND a.line_cd = f.line_cd
                       AND a.claim_id = c.claim_id
                       AND c.claim_id = e.claim_id
                       AND c.payee_class_cd = e.payee_class_cd
                       AND c.advice_id = e.advice_id
                       AND d.payee_no = e.payee_cd
                       AND e.payee_class_cd = d.payee_class_cd
                       AND e.tran_id IS NULL
                       AND NVL (e.dist_sw, 'N') = 'Y'
                       AND a.iss_cd = NVL (p_branch_cd, a.iss_cd)
                       AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
                       AND (   (    TRUNC (DECODE (p_choice_date,
                                                   'CF', a.clm_file_date,
                                                   'LS', a.loss_date,
                                                   NVL (c.date_gen,
                                                        c.last_update
                                                       )
                                                  )
                                          ) >=
                                       TRUNC (TO_DATE (p_start_dt,
                                                       'MM-DD-RRRR'
                                                      )
                                             )
                                AND TRUNC (DECODE (p_choice_date,
                                                   'CF', a.clm_file_date,
                                                   'LS', a.loss_date,
                                                   NVL (c.date_gen,
                                                        c.last_update
                                                       )
                                                  )
                                          ) <=
                                       TRUNC (TO_DATE (p_end_dt, 'MM-DD-RRRR'))
                               )
                            OR TRUNC (DECODE (p_choice_date,
                                              'CF', a.clm_file_date,
                                              'LS', a.loss_date,
                                              NVL (c.date_gen, c.last_update)
                                             )
                                     ) <=
                                    TRUNC (TO_DATE (p_as_of_dt, 'MM-DD-RRRR'))
                           )
                       AND NVL (c.cancel_sw, 'N') = 'N'
                       AND check_user_per_iss_cd2 (giisp.v ('LINE_CODE_MC'),
                                                  a.iss_cd,
                                                  'GICLS219',p_user_id
                                                 ) = 1)
          GROUP BY claim_number, loa_number, date_generated, payee)
      LOOP
         v_print := FALSE;
         v_list.claim_number := i.claim_number;
         v_list.loa_number := i.loa_number;
         v_list.date_generated := i.date_generated;
         v_list.loss_amount := i.loss_amount;
         v_list.payee := i.payee;
         PIPE ROW (v_list);
      END LOOP;
      
      IF v_print
      THEN
         v_list.v_print := 'TRUE';
         PIPE ROW (v_list);
      END IF;

      RETURN;
   END get_details;
END giclr219_pkg;
/


