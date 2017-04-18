CREATE OR REPLACE PACKAGE BODY CPI.giclr204d_pkg
AS
/*
** Created by   : Paolo J. Santos
** Date Created : 08.01.2013
** Reference By : giclr204d
** Description  : Lost Ratio By Intermediary */
   FUNCTION cf_loss_ratioformula (
      p_premiums_earned   NUMBER,
      p_losses_incurred   NUMBER
   )
      RETURN NUMBER
   IS
      v_ratio   NUMBER;
   BEGIN
      IF NVL (p_premiums_earned, 0) != 0
      THEN
         v_ratio := (p_losses_incurred / p_premiums_earned) * 100;
      ELSE
         v_ratio := 0;
      END IF;

      RETURN (v_ratio);
   END;

   FUNCTION cf_ref_noformula (p_ref_intm_cd VARCHAR2, p_intm_no NUMBER)
      RETURN VARCHAR2
   IS
      v_ref   VARCHAR2 (30);
   BEGIN
      BEGIN
         SELECT DECODE (p_ref_intm_cd,
                        NULL, TO_CHAR (p_intm_no),
                        TO_CHAR (p_intm_no) || ' / ' || p_ref_intm_cd
                       )
           INTO v_ref
           FROM DUAL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_ref := NULL;
      END;

      RETURN (v_ref);
   END;

   FUNCTION cf_intm_nameformula (p_intm_no NUMBER)
      RETURN VARCHAR2
   IS
      v_intm   giis_intermediary.intm_name%TYPE;
   BEGIN
      BEGIN
         SELECT intm_name
           INTO v_intm
           FROM giis_intermediary
          WHERE intm_no = p_intm_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      RETURN (v_intm);
   END;

   FUNCTION cf_iss_nameformula (p_iss_cd VARCHAR2)
      RETURN VARCHAR2
   IS
      v_iss   VARCHAR2 (50);
   BEGIN
      BEGIN
         SELECT iss_name
           INTO v_iss
           FROM giis_issource
          WHERE iss_cd = p_iss_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      RETURN (v_iss);
   END;

   FUNCTION cf_subline_nameformula (p_line_cd VARCHAR2, p_subline_cd VARCHAR2)
      RETURN VARCHAR2
   IS
      v_subline   giis_subline.subline_name%TYPE;
   BEGIN
      BEGIN
         SELECT subline_name
           INTO v_subline
           FROM giis_subline
          WHERE line_cd = p_line_cd 
            AND subline_cd = p_subline_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      RETURN (v_subline);
   END;

   FUNCTION cf_line_nameformula (p_line_cd VARCHAR2)
      RETURN VARCHAR2
   IS
      v_line   VARCHAR2 (25);
   BEGIN
      BEGIN
         SELECT line_name
           INTO v_line
           FROM giis_line
          WHERE line_cd = p_line_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      RETURN (v_line);
   END;

   FUNCTION cf_company_addressformula
      RETURN VARCHAR2
   IS
      v_address   giis_parameters.param_value_v%TYPE;
   BEGIN
      SELECT param_value_v
        INTO v_address
        FROM giis_parameters
       WHERE param_name = 'COMPANY_ADDRESS';

      RETURN (v_address);
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
         RETURN (v_address);
   END;

   FUNCTION cf_company_nameformula
      RETURN VARCHAR2
   IS
      v_company   giis_parameters.param_value_v%TYPE;
   BEGIN
      SELECT param_value_v
        INTO v_company
        FROM giis_parameters
       WHERE param_name = 'COMPANY_NAME';

      RETURN (v_company);
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
         RETURN (v_company);
   END;

   FUNCTION cf_assd_nameformula (p_assd_no NUMBER)
      RETURN VARCHAR2
   IS
      v_name   giis_assured.assd_name%TYPE;
   BEGIN
      SELECT assd_name
        INTO v_name
        FROM giis_assured
       WHERE assd_no = p_assd_no;

      RETURN (v_name);
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
         RETURN NULL;
   END;

   FUNCTION cf_1formula (p_date DATE)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN ('As of ' || TO_CHAR (p_date, 'fmMonth DD, YYYY'));
   END;
   
   FUNCTION cf_overall_loss_ratio(
      p_losses_incurred       NUMBER,
      p_premiums_earned       NUMBER
   ) RETURN NUMBER IS
      v_loss_ratio NUMBER(16,2);
   BEGIN
      IF p_premiums_earned =0 THEN
         RETURN (0);
      ELSE
         v_loss_ratio := (p_losses_incurred / p_premiums_earned) * 100;
         RETURN(v_loss_ratio); 
      END IF;
   END;

   FUNCTION get_giclr204d_record (
      p_session_id   NUMBER,
      p_date         VARCHAR2,
      p_assd_no      NUMBER,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_iss_cd       VARCHAR2,
      p_intm_no      NUMBER
   )
      RETURN giclr204d_record_tab PIPELINED
   IS
      v_list   giclr204d_record_type;
      pjs      BOOLEAN               := TRUE;
   BEGIN
      v_list.cf_company_address := cf_company_addressformula;
      v_list.cf_line_name := cf_line_nameformula (p_line_cd);

      FOR i IN (SELECT   a.intm_no, a.loss_ratio_date, a.curr_prem_amt,
                         NVL (a.curr_prem_res, 0) prem_res_cy,
                         NVL (a.prev_prem_res, 0) prem_res_py,
                         a.loss_paid_amt, a.curr_loss_res, a.prev_loss_res,
                         (  NVL (a.curr_prem_amt, 0)
                          + NVL (a.prev_prem_res, 0)
                          - NVL (a.curr_prem_res, 0)
                         ) premiums_earned,
                         (  NVL (a.loss_paid_amt, 0)
                          + NVL (a.curr_loss_res, 0)
                          - NVL (a.prev_loss_res, 0)
                         ) losses_incurred,
                         b.ref_intm_cd, b.intm_name
                    FROM gicl_loss_ratio_ext a, giis_intermediary b
                   WHERE a.session_id = p_session_id
                         AND a.intm_no = b.intm_no
                ORDER BY get_loss_ratio (a.session_id,
                                         a.line_cd,
                                         a.subline_cd,
                                         a.iss_cd,
                                         a.peril_cd,
                                         a.intm_no,
                                         a.assd_no
                                        ) DESC)
      LOOP
         pjs := FALSE;
         v_list.loss_ratio_date := i.loss_ratio_date;
         v_list.curr_prem_amt := NVL (i.curr_prem_amt, 0);
         v_list.prem_res_cy := NVL (i.prem_res_cy, 0);
         v_list.prem_res_py := NVL (i.prem_res_py, 0);
         v_list.loss_paid_amt := NVL (i.loss_paid_amt, 0);
         v_list.curr_loss_res := NVL (i.curr_loss_res, 0);
         v_list.prev_loss_res := NVL (i.prev_loss_res, 0);
         v_list.premiums_earned := NVL (i.premiums_earned, 0);
         v_list.losses_incurred := NVL (i.losses_incurred, 0);
         v_list.ref_intm_cd := i.ref_intm_cd;
         v_list.intm_name := i.intm_name;
         v_list.p_session_id := p_session_id;
         v_list.cf_assd_name := cf_assd_nameformula (p_assd_no);
         --v_list.cf_1 := cf_1formula (p_date);
         v_list.cf_company_name := cf_company_nameformula;
         v_list.cf_subline_name := cf_subline_nameformula (p_line_cd, p_subline_cd);
         v_list.cf_iss_name := cf_iss_nameformula (p_iss_cd);
         v_list.cf_intm_name := cf_intm_nameformula (p_intm_no);
         v_list.cf_overall_loss_ratio := cf_overall_loss_ratio(v_list.losses_incurred, v_list.premiums_earned);
         v_list.cf_1 := 'As of '|| TO_CHAR(TO_DATE(p_date, 'mm-dd-yyyy'), 'fmMonth DD, YYYY');
         v_list.cf_ref_no := cf_ref_noformula (i.ref_intm_cd, i.intm_no);
         v_list.cf_loss_ratio :=
                  cf_loss_ratioformula (i.premiums_earned, i.losses_incurred);
         PIPE ROW (v_list);
      END LOOP;

--      IF pjs = TRUE
--      THEN
--         v_list.pjs := '1';
--         PIPE ROW (v_list);
--      END IF;
   END get_giclr204d_record;
END;
/


