CREATE OR REPLACE PACKAGE BODY CPI.CSV_CLM_PER_VESSEL_GICLR262
AS
/*
**  Created by   : Dren Niebres 
**  Date Created : 03.09.2016
**  Reference By : GICLR253 - Claim Listing per Vessel
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
      p_as_of_date    VARCHAR2,
      p_from_date     VARCHAR2,
      p_to_date       VARCHAR2,
      p_as_of_ldate   VARCHAR2,
      p_from_ldate    VARCHAR2,
      p_to_ldate      VARCHAR2
   )
      RETURN VARCHAR2
   IS
   v_date_type VARCHAR2(100);
   BEGIN
      IF p_as_of_date IS NOT NULL
      THEN
         v_date_type := 'Claim File Date As of '
                 || TO_CHAR (TO_DATE (p_as_of_date, 'MM-DD-YYYY'),
                             'fmMonth DD, RRRR'
                            );
      ELSIF p_from_date IS NOT NULL AND p_to_date IS NOT NULL
      THEN
          v_date_type := 'Claim File Date From '
                 || TO_CHAR (TO_DATE (p_from_date, 'MM-DD-YYYY'),
                             'fmMonth DD, RRRR'
                            )
                 || ' To '
                 || TO_CHAR (TO_DATE (p_to_date, 'MM-DD-YYYY'),
                             'fmMonth DD, RRRR'
                            );
      ELSIF p_as_of_ldate IS NOT NULL
      THEN
         v_date_type := 'Loss Date As of '
                 || TO_CHAR (TO_DATE (p_as_of_ldate, 'MM-DD-YYYY'),
                             'fmMonth DD, RRRR'
                            );
      ELSIF p_from_ldate IS NOT NULL AND p_to_ldate IS NOT NULL
      THEN
          v_date_type := 'Loss Date From '
                 || TO_CHAR (TO_DATE (p_from_ldate, 'MM-DD-YYYY'),
                             'fmMonth DD, RRRR'
                            )
                 || ' To '
                 || TO_CHAR (TO_DATE (p_to_ldate, 'MM-DD-YYYY'),
                             'fmMonth DD, RRRR'
                            );
      END IF;
      RETURN(v_date_type);
   END;

   FUNCTION cf_exp_paidformula (
      p_claim_id   gicl_clm_reserve.claim_id%TYPE,
      p_item_no    gicl_clm_reserve.item_no%TYPE
   )
      RETURN NUMBER
   IS
      v_exp_paid   gicl_clm_reserve.loss_reserve%TYPE;
   BEGIN
      SELECT SUM (expenses_paid) expenses_paid
        INTO v_exp_paid
        FROM gicl_clm_reserve
       WHERE claim_id = p_claim_id AND item_no = p_item_no;

      RETURN (NVL (v_exp_paid, 0));
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN (0);
   END;

   FUNCTION cf_exp_res_formula (
      p_claim_id   gicl_clm_reserve.claim_id%TYPE,
      p_item_no    gicl_clm_reserve.item_no%TYPE
   )
      RETURN NUMBER
   IS
      v_exp_res   gicl_clm_reserve.loss_reserve%TYPE;
   BEGIN
      SELECT SUM (expense_reserve) expense_reserve
        INTO v_exp_res
        FROM gicl_clm_reserve
       WHERE claim_id = p_claim_id AND item_no = p_item_no;

      RETURN (NVL (v_exp_res, 0));
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN (0);
   END;

   FUNCTION cf_los_paidformula (
      p_claim_id   gicl_clm_reserve.claim_id%TYPE,
      p_item_no    gicl_clm_reserve.item_no%TYPE
   )
      RETURN NUMBER
   IS
      v_los_paid   gicl_clm_reserve.losses_paid%TYPE;
   BEGIN
      SELECT SUM (losses_paid) expense_reserve
        INTO v_los_paid
        FROM gicl_clm_reserve
       WHERE claim_id = p_claim_id AND item_no = p_item_no;

      RETURN (NVL (v_los_paid, 0));
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN (0);
   END;

   FUNCTION cf_los_res_formula (
      p_claim_id   gicl_clm_reserve.claim_id%TYPE,
      p_item_no    gicl_clm_reserve.item_no%TYPE
   )
      RETURN NUMBER
   IS
      v_los_res   gicl_clm_reserve.loss_reserve%TYPE;
   BEGIN
      SELECT SUM (loss_reserve) loss_reserve
        INTO v_los_res
        FROM gicl_clm_reserve
       WHERE claim_id = p_claim_id AND item_no = p_item_no;

      RETURN (NVL (v_los_res, 0));
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN (0);
   END;

   FUNCTION csv_giclr262 (
      p_vessel_cd     giis_vessel.vessel_cd%TYPE,
      p_as_of_date    VARCHAR2,
      p_from_date     VARCHAR2,
      p_to_date       VARCHAR2,
      p_as_of_ldate   VARCHAR2,
      p_from_ldate    VARCHAR2,
      p_to_ldate      VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN giclr262_pkg_details_tab PIPELINED
   AS
      v_detail   giclr262_pkg_details_type;
      v_exist    BOOLEAN                   := TRUE;
   BEGIN
      FOR i IN (SELECT   b.vessel_cd || ' - ' || a.vessel_name vessel,
                         b.claim_id, b.assured_name, d.loss_date,
                         d.clm_file_date, b.item_no,
                         b.item_no || ' - ' || c.item_title item,
                            b.line_cd
                         || '-'
                         || b.subline_cd
                         || '-'
                         || b.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (b.clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.clm_seq_no, '0000009'))
                                                                 claim_number,
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
                    FROM gicl_vessel_v1 b,
                         giis_vessel a,
                         gicl_clm_item c,
                         gicl_claims d
                   WHERE b.vessel_cd = a.vessel_cd
                     AND (    b.claim_id = c.claim_id
                          AND b.item_no = c.item_no
                          AND c.claim_id = d.claim_id
                         )
                     AND b.vessel_cd = p_vessel_cd
                     AND check_user_per_line2 (b.line_cd,
                                               b.iss_cd,
                                               'GICLS262',
                                               p_user_id
                                              ) = 1
                     AND (   (       TRUNC (d.clm_file_date) >=
                                           TO_DATE (p_from_date, 'MM-DD-YYYY')
                                 AND TRUNC (d.clm_file_date) <=
                                             TO_DATE (p_to_date, 'MM-DD-YYYY')
                              OR TRUNC (d.clm_file_date) <=
                                          TO_DATE (p_as_of_date, 'MM-DD-YYYY')
                             )
                          OR (       TRUNC (d.loss_date) >=
                                          TO_DATE (p_from_ldate, 'MM-DD-YYYY')
                                 AND TRUNC (d.loss_date) <=
                                            TO_DATE (p_to_ldate, 'MM-DD-YYYY')
                              OR TRUNC (d.loss_date) <=
                                         TO_DATE (p_as_of_ldate, 'MM-DD-YYYY')
                             )
                         )
                ORDER BY b.claim_id)
      LOOP     
         v_detail.vessel := i.vessel;      
         v_detail.claim_number := i.claim_number;
         v_detail.policy_number := i.policy_number;
         v_detail.assured := i.assured_name;
         v_detail.item_title := i.item;
         v_detail.loss_date := TO_CHAR (i.loss_date, 'MM-DD-YYYY');
         v_detail.claim_file_date := TO_CHAR (i.clm_file_date, 'MM-DD-YYYY'); 
         v_detail.loss_reserve := cf_los_res_formula (i.claim_id, i.item_no);
         v_detail.losses_paid := cf_los_paidformula (i.claim_id, i.item_no);
         v_detail.expense_reserve := cf_exp_res_formula (i.claim_id, i.item_no);
         v_detail.expenses_paid := cf_exp_paidformula (i.claim_id, i.item_no);
         v_exist := FALSE;         
         PIPE ROW (v_detail);
      END LOOP;

      IF v_exist
      THEN
         PIPE ROW (v_detail);
      END IF;
      RETURN;
   END csv_giclr262;
END CSV_CLM_PER_VESSEL_GICLR262;
/


