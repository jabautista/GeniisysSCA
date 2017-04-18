CREATE OR REPLACE PACKAGE BODY CPI.giclr204b_pkg
AS
   FUNCTION get_giclr_204b_report (
      p_assd_no      NUMBER,
      p_date         VARCHAR2,
      p_intm_no      NUMBER,
      p_iss_cd       VARCHAR2,
      p_line_cd      VARCHAR2,
      p_session_id   NUMBER,
      p_subline_cd   VARCHAR2
   )
      RETURN report_tab PIPELINED
   IS
      v_list   report_type;
   BEGIN
      FOR i IN (SELECT   a.line_cd, a.subline_cd, a.loss_ratio_date,
                         NVL (a.curr_prem_amt, 0) curr_prem_amt,
                         NVL (a.curr_prem_res, 0) prem_res_cy,
                         NVL (a.prev_prem_res, 0) prem_res_py,
                         NVL (a.loss_paid_amt, 0) loss_paid_amt,
                         NVL (a.curr_loss_res, 0) curr_loss_res,
                         NVL (a.prev_loss_res, 0) prev_loss_res,
                         (  NVL (a.curr_prem_amt, 0)
                          + NVL (a.prev_prem_res, 0)
                          - NVL (a.curr_prem_res, 0)
                         ) premiums_earned,
                         (  NVL (a.loss_paid_amt, 0)
                          + NVL (a.curr_loss_res, 0)
                          - NVL (a.prev_loss_res, 0)
                         ) losses_incurred,
                         a.iss_cd, a.assd_no, a.intm_no
                    FROM gicl_loss_ratio_ext a
                   WHERE a.session_id = p_session_id
                ORDER BY get_loss_ratio (a.session_id,
                                         a.line_cd,
                                         a.subline_cd,
                                         a.iss_cd,
                                         a.peril_cd,
                                         a.intm_no,
                                         a.assd_no
                                        ) DESC)
      LOOP
         BEGIN
            SELECT param_value_v
              INTO v_list.company_name
              FROM giis_parameters
             WHERE param_name = 'COMPANY_NAME';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.company_name := '';
         END;

         BEGIN
            SELECT param_value_v
              INTO v_list.company_address
              FROM giis_parameters
             WHERE param_name = 'COMPANY_ADDRESS';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.company_address := '';
         END;

         BEGIN
            v_list.as_of :=
                  'As of '
               || TO_CHAR (TO_DATE (p_date, 'mm-dd-yyyy'), 'fmMonth DD, YYYY');
         END;

         BEGIN
            SELECT 'ASSURED               : ' || p_assd_no || ' - '
                   || assd_name
              INTO v_list.assd_name
              FROM giis_assured
             WHERE assd_no = p_assd_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.assd_name := '';
         END;

         BEGIN
            SELECT    'LINE                        : '
                   || p_line_cd
                   || ' - '
                   || line_name
              INTO v_list.line_name
              FROM giis_line
             WHERE line_cd = p_line_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.line_name := '';
         END;

         BEGIN
            SELECT 'ISSUING SOURCE : ' || p_iss_cd || ' - ' || iss_name
              INTO v_list.iss_name
              FROM giis_issource
             WHERE iss_cd = p_iss_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.iss_name := '';
         END;

         BEGIN
            SELECT 'INTERMEDIARY     : ' || p_intm_no || ' - ' || intm_name
              INTO v_list.intm_name
              FROM giis_intermediary
             WHERE intm_no = p_intm_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.intm_name := '';
         END;

         BEGIN
            SELECT i.subline_cd || ' - ' || subline_name
              INTO v_list.subline
              FROM giis_subline
             WHERE line_cd = p_line_cd AND subline_cd = i.subline_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.subline := NULL;
         END;

         v_list.loss_paid_amt := i.loss_paid_amt;
         v_list.curr_loss_res := i.curr_loss_res;
         v_list.prev_loss_res := i.prev_loss_res;
         v_list.curr_prem_amt := i.curr_prem_amt;
         v_list.prem_res_cy := i.prem_res_cy;
         v_list.prem_res_py := i.prem_res_py;
         v_list.losses_incurred := i.losses_incurred;
         v_list.premiums_earned := i.premiums_earned;

         IF NVL (i.premiums_earned, 0) != 0
         THEN
            v_list.loss_ratio :=
                                NVL((i.losses_incurred / i.premiums_earned) * 100, 0);
         ELSE
            v_list.loss_ratio := 0;                              
         END IF;

         PIPE ROW (v_list);
      END LOOP;
   END get_giclr_204b_report;
END;
/


