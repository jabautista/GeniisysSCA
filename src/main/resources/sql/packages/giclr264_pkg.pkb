CREATE OR REPLACE PACKAGE BODY CPI.giclr264_pkg
AS
/*
** Created By: Andrew Robes
** Date Created: 03.04.2013
** Reference By: GICLR264
** Description: Claim Listing per Color Report
*/
   FUNCTION cf_comp_nameformula
      RETURN VARCHAR2
   IS
      v_name   giis_parameters.param_value_v%TYPE;
   BEGIN
      SELECT param_value_v
        INTO v_name
        FROM giis_parameters
       WHERE param_name = 'COMPANY_NAME';

      RETURN (v_name);
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_name := '(NO EXISTING COMPANY_NAME IN GIIS_PARAMETERS)';
         RETURN (v_name);
      WHEN TOO_MANY_ROWS
      THEN
         v_name := '(TOO MANY VALUES FOR COMPANY_NAME IN GIIS_PARAMETER)';
         RETURN (v_name);
   END;

   FUNCTION cf_comp_addformula
      RETURN VARCHAR2
   IS
      v_add   giis_parameters.param_value_v%TYPE;
   BEGIN
      SELECT param_value_v
        INTO v_add
        FROM giis_parameters
       WHERE param_name = 'COMPANY_ADDRESS';

      RETURN (v_add);
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_add := '(NO EXISTING COMPANY_ADDRESS IN GIIS_PARAMETERS)';
         RETURN (v_add);
      WHEN TOO_MANY_ROWS
      THEN
         v_add := '(TOO MANY VALUES FOR COMPANY_ADDRESS IN GIIS_PARAMETERS)';
         RETURN (v_add);
   END;

   FUNCTION cf_datetypeformula (
      p_search_by    NUMBER,
      p_as_of_date   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2
   )
      RETURN VARCHAR2
   IS
   BEGIN
      IF p_search_by = 1 AND p_as_of_date IS NOT NULL
      THEN
         RETURN (   'Claim File Date As of '
                 || TO_CHAR (TO_DATE (p_as_of_date, 'MM-DD-RRRR'), 'fmMonth DD, RRRR')
                );
      ELSIF p_search_by = 1 AND p_from_date IS NOT NULL AND p_to_date IS NOT NULL
      THEN
         RETURN (   'Claim File Date From '
                 || TO_CHAR (TO_DATE (p_from_date, 'MM-DD-RRRR'), 'fmMonth DD, RRRR')
                 || ' To '
                 || TO_CHAR (TO_DATE (p_to_date, 'MM-DD-RRRR'), 'fmMonth DD, RRRR')
                );
      ELSIF p_search_by = 2 AND p_as_of_date IS NOT NULL
      THEN
         RETURN (   'Loss Date As of '
                 || TO_CHAR (TO_DATE (p_as_of_date, 'MM-DD-RRRR'), 'fmMonth DD, RRRR')
                );
      ELSIF p_search_by = 2 AND p_from_date IS NOT NULL AND p_to_date IS NOT NULL
      THEN
         RETURN (   'Loss Date From '
                 || TO_CHAR (TO_DATE (p_from_date, 'MM-DD-RRRR'), 'fmMonth DD, RRRR')
                 || ' To '
                 || TO_CHAR (TO_DATE (p_to_date, 'MM-DD-RRRR'), 'fmMonth DD, RRRR')
                );
      ELSE
         RETURN NULL;
      END IF;
   END;

   FUNCTION get_header (
      p_search_by    NUMBER,
      p_as_of_date   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2
   )
      RETURN header_tab PIPELINED
   AS
      v_header   header_type;
   BEGIN
      v_header.comp_name := cf_comp_nameformula;
      v_header.comp_address := cf_comp_addformula;
      v_header.date_type := cf_datetypeformula (p_search_by, p_as_of_date, p_from_date, p_to_date);
      PIPE ROW (v_header);
      RETURN;
   END get_header;

   FUNCTION cf_los_resformula (
      p_color_cd   giis_mc_color.color_cd%TYPE,
      p_claim_id   gicl_claims.claim_id%TYPE
   )
      RETURN NUMBER
   IS
      v_los_res   gicl_clm_reserve.loss_reserve%TYPE;
   BEGIN
      SELECT SUM (a.convert_rate * a.loss_reserve)
        INTO v_los_res
        FROM gicl_clm_reserve a, gicl_motor_car_dtl b
       WHERE b.color_cd = p_color_cd
         AND b.item_no = a.item_no
         AND a.claim_id = p_claim_id
         AND a.claim_id = b.claim_id;

      RETURN (NVL (v_los_res, 0));
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN (0);
   END;

   FUNCTION cf_los_paidformula (
      p_color_cd   giis_mc_color.color_cd%TYPE,
      p_claim_id   gicl_claims.claim_id%TYPE
   )
      RETURN NUMBER
   IS
      v_los_paid   gicl_clm_reserve.loss_reserve%TYPE;
   BEGIN
      SELECT SUM (a.losses_paid)
        INTO v_los_paid
        FROM gicl_clm_reserve a, gicl_motor_car_dtl b
       WHERE b.color_cd = p_color_cd
         AND b.item_no = a.item_no
         AND a.claim_id = p_claim_id
         AND a.claim_id = b.claim_id;

      RETURN (NVL (v_los_paid, 0));
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN (0);
   END;

   FUNCTION cf_exp_resformula (
      p_color_cd   giis_mc_color.color_cd%TYPE,
      p_claim_id   gicl_claims.claim_id%TYPE
   )
      RETURN NUMBER
   IS
      v_exp_res   gicl_clm_reserve.loss_reserve%TYPE;
   BEGIN
      SELECT SUM (a.convert_rate * a.expense_reserve)
        INTO v_exp_res
        FROM gicl_clm_reserve a, gicl_motor_car_dtl b
       WHERE b.color_cd = p_color_cd
         AND b.item_no = a.item_no
         AND a.claim_id = p_claim_id
         AND a.claim_id = b.claim_id;

      RETURN (NVL (v_exp_res, 0));
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN (0);
   END;

   FUNCTION cf_exp_paidformula (
      p_color_cd   giis_mc_color.color_cd%TYPE,
      p_claim_id   gicl_claims.claim_id%TYPE
   )
      RETURN NUMBER
   IS
      v_exp_paid   gicl_clm_reserve.loss_reserve%TYPE;
   BEGIN
      SELECT SUM (a.expenses_paid)
        INTO v_exp_paid
        FROM gicl_clm_reserve a, gicl_motor_car_dtl b
       WHERE b.color_cd = p_color_cd
         AND b.item_no = a.item_no
         AND a.claim_id = b.claim_id
         AND a.claim_id = p_claim_id;

      RETURN (NVL (v_exp_paid, 0));
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN (0);
   END;

   FUNCTION get_details (
      p_color_cd         giis_mc_color.color_cd%TYPE,
      p_basic_color_cd   giis_mc_color.basic_color_cd%TYPE,
      p_user_id          giis_users.user_id%TYPE,
      p_search_by        NUMBER,
      p_as_of_date       VARCHAR2,
      p_from_date        VARCHAR2,
      p_to_date          VARCHAR2
   )
      RETURN details_tab PIPELINED
   AS
      v_detail   details_type;
   BEGIN
      FOR i IN (SELECT   a.claim_id,
                         LTRIM (TO_CHAR (c.color_cd, '999999999999')) || '-' || c.color color,
                         c.basic_color_cd || '-' || c.basic_color basic_color,
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (a.clm_seq_no, '0000009')) claim_number,
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
                         a.assured_name,
                         LTRIM (TO_CHAR (b.item_no, '00009')) || '-' || b.item_title item_title,
                         b.plate_no, a.dsp_loss_date, c.color_cd
                    FROM gicl_claims a, gicl_motor_car_dtl b, gicl_clm_reserve d, giis_mc_color c
                   WHERE 1 = 1
                     AND check_user_per_line2 (line_cd, iss_cd, 'GICLS264', p_user_id) = 1
                     AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS264', p_user_id) = 1                     
                     AND (   TRUNC (DECODE (p_search_by, 1, a.clm_file_date, 2, a.dsp_loss_date)) <= TO_DATE (p_as_of_date, 'MM-DD-RRRR')
                          OR (    TRUNC (DECODE (p_search_by,
                                                 1, a.clm_file_date,
                                                 2, a.dsp_loss_date
                                                )
                                        ) >= TO_DATE (p_from_date, 'MM-DD-RRRR')
                              AND TRUNC (DECODE (p_search_by,
                                                 1, a.clm_file_date,
                                                 2, a.dsp_loss_date
                                                )
                                        ) <= TO_DATE (p_to_date, 'MM-DD-RRRR')
                             )
                         )
                     AND a.claim_id = b.claim_id
                     AND d.item_no = b.item_no
                     AND c.color_cd = b.color_cd
                     AND c.basic_color_cd = b.basic_color_cd
                     AND c.basic_color_cd = p_basic_color_cd
                     AND c.color_cd = p_color_cd
                GROUP BY    a.line_cd
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
                         a.assured_name,
                         LTRIM (TO_CHAR (b.item_no, '00009')) || '-' || b.item_title,
                         b.plate_no,
                         a.dsp_loss_date,
                         c.color_cd,
                         c.color,
                         c.basic_color_cd,
                         c.basic_color,
                         LTRIM (TO_CHAR (c.color_cd, '000000000009')) || '-' || c.color,
                         c.basic_color_cd || '-' || c.basic_color,
                         a.claim_id
                ORDER BY claim_number, policy_number)
      LOOP
         v_detail.claim_id := i.claim_id;
         v_detail.color := i.color;
         v_detail.basic_color := i.basic_color;
         v_detail.claim_number := i.claim_number;
         v_detail.policy_number := i.policy_number;
         v_detail.assd_name := i.assured_name;
         v_detail.item_title := i.item_title;
         v_detail.plate_no := i.plate_no;
         v_detail.dsp_loss_date := i.dsp_loss_date;
         v_detail.color_cd := i.color_cd;
         v_detail.expenses_paid := cf_exp_paidformula (i.color_cd, i.claim_id);
         v_detail.expense_reserve := cf_exp_resformula (i.color_cd, i.claim_id);
         v_detail.losses_paid := cf_los_paidformula (i.color_cd, i.claim_id);
         v_detail.loss_reserve := cf_los_resformula (i.color_cd, i.claim_id);
         PIPE ROW (v_detail);
      END LOOP;

      RETURN;
   END get_details;
END giclr264_pkg;
/


