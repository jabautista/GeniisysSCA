CREATE OR REPLACE PACKAGE BODY CPI.GICLR262_PKG
AS
/*
** Created By: Roy Encela
** Date Created: 05.15.2013
** Reference By: GICLR262
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

   FUNCTION get_giclr262_details (
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
      v_detail.comp_name := cf_comp_nameformula;
      v_detail.comp_address := cf_comp_addformula;
      v_detail.date_type :=
         cf_datetypeformula (p_as_of_date,
                             p_from_date,
                             p_to_date,
                             p_as_of_ldate,
                             p_from_ldate,
                             p_to_ldate
                            );

      FOR i IN (SELECT   b.vessel_cd,
                         b.vessel_cd || ' - ' || a.vessel_name vessel,
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
         v_exist := FALSE;
         v_detail.vessel_cd := i.vessel_cd;
         v_detail.vessel := i.vessel;
         v_detail.assured_name := i.assured_name;
         v_detail.loss_date := TO_CHAR (i.loss_date, 'MM-DD-YYYY');
         v_detail.clm_file_date := TO_CHAR (i.clm_file_date, 'MM-DD-YYYY');
         v_detail.item := i.item;
         v_detail.claim_number := i.claim_number;
         v_detail.policy_number := i.policy_number;
         v_detail.exp_pd_formula := cf_exp_paidformula (i.claim_id, i.item_no);
         v_detail.exp_res_formula := cf_exp_res_formula (i.claim_id, i.item_no);
         v_detail.los_pd_formula := cf_los_paidformula (i.claim_id, i.item_no);
         v_detail.los_res_formula := cf_los_res_formula (i.claim_id, i.item_no);
         PIPE ROW (v_detail);
      END LOOP;

      IF v_exist
      THEN
         PIPE ROW (v_detail);
      END IF;
      RETURN;
   END get_giclr262_details;
--   FUNCTION get_header (
--      p_vessel_cd    VARCHAR2,
--      p_search_by    NUMBER,
--      p_as_of_date   VARCHAR2,
--      p_from_date    VARCHAR2,
--      p_to_date      VARCHAR2
--   )
--      RETURN header_tab PIPELINED
--   AS
--      v_header   header_type;
--      v_tot_expaid NUMBER(15,2) := 0;
--      v_tot_expres NUMBER(15,2) := 0;
--      v_tot_lospaid NUMBER(15,2) := 0;
--      v_tot_losres NUMBER(15,2) := 0;
--      CURSOR c1 IS SELECT b.claim_id f_claim_id, b.item_no f_item_no
--                     FROM gicl_vessel_v1 b, giis_vessel a, gicl_clm_item c, gicl_claims d
--                    WHERE b.vessel_cd = a.vessel_cd
--                      AND ( b.claim_id  = c.claim_id AND
--                            b.item_no = c.item_no AND
--                            c.claim_id = d.claim_id)
--                      AND b.vessel_cd  =  p_vessel_cd
--                      AND CHECK_USER_PER_LINE(b.LINE_CD,b.ISS_CD,'GICLS262')=1
--                     AND ( (p_search_by = 1 AND ((trunc(d.clm_file_date) >= TO_DATE(p_from_date, 'MM-DD-YYYY') AND trunc(d.clm_file_date) <= TO_DATE(p_to_date, 'MM-DD-YYYY'))
--                                                     OR trunc(d.clm_file_date) <= TO_DATE(p_as_of_date, 'MM-DD-YYYY'))) OR
--                            (p_search_by = 2 AND ((trunc(d.loss_date) >= TO_DATE(p_from_date, 'MM-DD-YYYY') AND trunc(d.loss_date) <= TO_DATE(p_to_date, 'MM-DD-YYYY'))
--                                                     OR trunc(d.loss_date) <= TO_DATE(p_as_of_date, 'MM-DD-YYYY'))))
--                    ORDER BY b.vessel_cd;
--   BEGIN
--      v_header.f_comp_name := cf_comp_nameformula;
--      v_header.f_comp_address := cf_comp_addformula;
    --      v_header.f_date_type := cf_datetypeformula (p_search_by, TO_DATE(p_as_of_date, 'MM-DD-YYYY'), TO_DATE(p_from_date, 'MM-DD-YYYY'), TO_DATE(p_to_date, 'MM-DD-YYYY'));
--
--      FOR ii IN c1
--      LOOP
--          v_tot_expaid := v_tot_expaid + cf_exp_paidformula(ii.f_claim_id, ii.f_item_no);
--          v_tot_expres := v_tot_expres + cf_exp_res_formula(ii.f_claim_id, ii.f_item_no);
--          v_tot_lospaid := v_tot_lospaid + cf_los_paidformula(ii.f_claim_id, ii.f_item_no);
--          v_tot_losres := v_tot_losres + cf_los_res_formula(ii.f_claim_id, ii.f_item_no);
--      END LOOP;
--
--      v_header.f_exp_paidformula := v_tot_expaid;
--      v_header.f_exp_res_formula := v_tot_expres;
--      v_header.f_los_paidformula := v_tot_lospaid;
--      v_header.f_los_res_formula := v_tot_losres;
--
--      SELECT vessel_cd || ' - ' || vessel_name
--        INTO v_header.f_vessel
--        FROM giis_vessel
--       WHERE vessel_cd = p_vessel_cd;
--
--      PIPE ROW (v_header);
--      RETURN;
--   END get_header;

--  FUNCTION get_details(
--    p_vessel_cd giis_vessel.vessel_cd%TYPE,
--    p_search_by    NUMBER,
--    p_as_of_date   VARCHAR2,
--    p_from_date    VARCHAR2,
--    p_to_date      VARCHAR2
--  )RETURN detail_tab PIPELINED
--  AS
--    CURSOR c1 IS SELECT b.vessel_cd||'-'||a.vessel_name f_vessel,
--        b.line_cd f_line_cd, b.iss_cd f_iss_cd, b.claim_id f_claim_id,
--        b.assured_name f_assured_name, d.loss_date f_loss_date,
--        d.clm_file_date f_clm_file_date, b.item_no f_item_no,
--        b.item_no||'-'|| c.item_title f_item,
--        b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy,'09'))|| '-'||LTRIM(TO_CHAR(b.clm_seq_no,'0000009')) f_Claim_Number,
--        b.line_cd||'-'||b.subline_cd||'-'||b.pol_iss_cd||'-'||LTRIM(TO_CHAR(b.issue_yy,'09'))||'-'||LTRIM(TO_CHAR(b.pol_seq_no,'0000009'))||'-'||LTRIM(TO_CHAR(b.renew_no,'09')) f_Policy_Number
--    FROM gicl_vessel_v1 b, giis_vessel a, gicl_clm_item c, gicl_claims d
--    WHERE b.vessel_cd = a.vessel_cd
--      AND ( b.claim_id  = c.claim_id AND
--            b.item_no = c.item_no AND
--            c.claim_id = d.claim_id)
--      AND b.vessel_cd  =  p_vessel_cd
--      AND CHECK_USER_PER_LINE(b.LINE_CD,b.ISS_CD,'GICLS262')=1
--      AND ( (p_search_by = 1 AND ((trunc(d.clm_file_date) >= TO_DATE(p_from_date, 'MM-DD-YYYY') AND trunc(d.clm_file_date) <= TO_DATE(p_to_date, 'MM-DD-YYYY'))
--                                                     OR trunc(d.clm_file_date) <= TO_DATE(p_as_of_date, 'MM-DD-YYYY'))) OR
--                            (p_search_by = 2 AND ((trunc(d.loss_date) >= TO_DATE(p_from_date, 'MM-DD-YYYY') AND trunc(d.loss_date) <= TO_DATE(p_to_date, 'MM-DD-YYYY'))
--                                                     OR trunc(d.loss_date) <= TO_DATE(p_as_of_date, 'MM-DD-YYYY'))))
--ORDER BY b.vessel_cd;
--    xc detail_type;
--  BEGIN
--    FOR i IN c1 LOOP
--        xc.f_vessel := i.f_vessel;
--        xc.f_line_cd := i.f_line_cd;
--        xc.f_iss_cd := i.f_iss_cd;
--        xc.f_claim_id := i.f_claim_id;
--        xc.f_assured_name := i.f_assured_name;
--        xc.f_loss_date := i.f_loss_date;
--        xc.f_clm_file_date := i.f_clm_file_date;
--        xc.f_item_no := i.f_item_no;
--        xc.f_item := i.f_item;
--        xc.f_claim_number := i.f_claim_number;
--        xc.f_policy_number := i.f_policy_number;
--        xc.f_cf_los_res := cf_los_res_formula(i.f_claim_id, i.f_item_no);
--        xc.f_cf_los_paid := cf_los_paidformula(i.f_claim_id, i.f_item_no);
--        xc.f_cf_exp_res := cf_exp_res_formula(i.f_claim_id, i.f_item_no);
--        xc.f_cf_exp_paid := cf_exp_paidformula(i.f_claim_id, i.f_item_no);
--        PIPE ROW(xc);
--    END LOOP;
--  END;
END GICLR262_PKG;
/


