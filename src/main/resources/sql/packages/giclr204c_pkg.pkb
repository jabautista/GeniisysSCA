CREATE OR REPLACE PACKAGE BODY CPI.giclr204c_pkg
AS
/*
   ** Created by : Ariel P. Ignas Jr
   ** Date Created : 08.01.2013
   ** Reference By : GICLR204C
   ** Description : LOSS RATIO BY ISSUING SOURCE
   */
   FUNCTION cf_issourceformula (p_iss_cd VARCHAR2)
      RETURN VARCHAR2
   IS
      v_iss   giis_issource.iss_name%TYPE;
   BEGIN
      BEGIN
         SELECT iss_name
           INTO v_iss
           FROM giis_issource
          WHERE iss_cd = p_iss_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RETURN (NULL);
      END;

      RETURN (p_iss_cd || ' - ' || v_iss);
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

   FUNCTION cf_line_nameformula (p_line_cd VARCHAR2)
      RETURN VARCHAR2
   IS
      v_line   VARCHAR2 (25);
   BEGIN
      BEGIN
         SELECT '-   ' || line_name
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

   FUNCTION cf_subline_nameformula (p_line_cd VARCHAR2, p_subline_cd VARCHAR2)
      RETURN VARCHAR2
   IS
      v_subline   giis_subline.subline_name%TYPE;
   BEGIN
      BEGIN
         SELECT '-   ' || subline_name
           INTO v_subline
           FROM giis_subline
          WHERE line_cd = p_line_cd AND subline_cd = p_subline_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      RETURN (v_subline);
   END;

   FUNCTION cf_iss_nameformula (p_iss_cd VARCHAR2)
      RETURN VARCHAR2
   IS
      v_iss   VARCHAR2 (50);
   BEGIN
      BEGIN
         SELECT '-   ' || iss_name
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

   FUNCTION cf_intm_nameformula (p_intm_no NUMBER)
      RETURN VARCHAR2
   IS
      v_intm   giis_intermediary.intm_name%TYPE;
   BEGIN
      BEGIN
         SELECT '-   ' || intm_name
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

   FUNCTION cf_loss_ratioformula (
      p_losses_incurred   NUMBER,
      p_premiums_earned   NUMBER
   )
      RETURN NUMBER
   IS
      v_ratio   NUMBER(16,2);
   BEGIN
      IF NVL (p_premiums_earned, 0) != 0
      THEN
         v_ratio := NVL((p_losses_incurred / p_premiums_earned) * 100, 0);
      ELSE
         v_ratio := 0;
      END IF;

      RETURN (v_ratio);
   END;

   FUNCTION get_giclr204c_record (
      p_session_id   NUMBER,
      p_date         VARCHAR2,
      p_assd_no      NUMBER,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_iss_cd       VARCHAR2,
      p_intm_no      NUMBER
   )
      RETURN giclr204c_record_tab PIPELINED
   IS
      v_list   giclr204c_record_type;
      v_test   BOOLEAN               := TRUE;
   BEGIN
      v_list.cf_company_nameformula := cf_company_nameformula;
      v_list.cf_company_addressformula := cf_company_addressformula;
      v_list.cf_1formula := 'As of ' || TO_CHAR(TO_DATE(p_date, 'mm-dd-yyyy'), 'fmMonth DD, YYYY');
      v_list.cf_assd_nameformula := cf_assd_nameformula (p_assd_no);
      v_list.cf_line_nameformula := cf_line_nameformula (p_line_cd);
      v_list.cf_subline_nameformula :=
                             cf_subline_nameformula (p_line_cd, p_subline_cd);
      v_list.cf_iss_nameformula := cf_iss_nameformula (p_iss_cd);
      v_list.cf_intm_nameformula := cf_intm_nameformula (p_intm_no);

      FOR i IN (SELECT   a.iss_cd, a.loss_ratio_date, a.curr_prem_amt,
                         NVL (a.curr_prem_res, 0) prem_res_cy,
                         NVL (a.prev_prem_res, 0) prem_res_py, loss_paid_amt,
                         a.curr_loss_res, a.prev_loss_res,
                         (  NVL (a.curr_prem_amt, 0)
                          + NVL (a.prev_prem_res, 0)
                          - NVL (a.curr_prem_res, 0)
                         ) premiums_earned,
                         (  NVL (a.loss_paid_amt, 0)
                          + NVL (a.curr_loss_res, 0)
                          - NVL (a.prev_loss_res, 0)
                         ) losses_incurred
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
         v_test := FALSE;
         v_list.iss_cd := i.iss_cd;
         v_list.loss_ratio_date := i.loss_ratio_date;
         v_list.curr_prem_amt := NVL (i.curr_prem_amt, 0);
         v_list.prem_res_cy := i.prem_res_cy;
         v_list.prem_res_py := i.prem_res_py;
         v_list.loss_paid_amt := NVL (i.loss_paid_amt, 0);
         v_list.curr_loss_res := NVL (i.curr_loss_res, 0);
         v_list.prev_loss_res := NVL (i.prev_loss_res, 0);
         v_list.premiums_earned := i.premiums_earned;
         v_list.losses_incurred := i.losses_incurred;
         v_list.cf_issourceformula := cf_issourceformula (i.iss_cd);
         v_list.cf_loss_ratioformula :=
                  cf_loss_ratioformula (i.losses_incurred, i.premiums_earned);
         PIPE ROW (v_list);
      END LOOP;

      IF v_test = TRUE
      THEN
         v_list.v_test := '1';
         PIPE ROW (v_list);
      END IF;
   END get_giclr204c_record;
END;
/


