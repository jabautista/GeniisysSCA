CREATE OR REPLACE PACKAGE BODY CPI.giclr204e_pkg
AS
   /*
     **  Created by   : Michael John R. Malicad
     **  Date Created : 07.16.2013
     **  Reference By : GICLR204E
     **  Description  : LOSS RATIO DETAILED BY ASSURED
     */
   FUNCTION cf_company_name
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

   FUNCTION cf_company_address
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

   FUNCTION cf_line_name (p_line_cd VARCHAR2)
      RETURN VARCHAR2
   IS
      v_line   VARCHAR2 (25);
   BEGIN
      BEGIN
         SELECT '-     ' || line_name
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

   FUNCTION cf_subline_name (p_line_cd VARCHAR2, p_subline_cd VARCHAR2)
      RETURN VARCHAR2
   IS
      v_subline   giis_subline.subline_name%TYPE;
   BEGIN
      BEGIN
         SELECT '-     ' || subline_name
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

   FUNCTION cf_iss_name (p_iss_cd VARCHAR2)
      RETURN VARCHAR2
   IS
      v_iss   VARCHAR2 (50);
   BEGIN
      BEGIN
         SELECT '-     ' || iss_name
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

   FUNCTION cf_intm_name (p_intm_no NUMBER)
      RETURN VARCHAR2
   IS
      v_intm   giis_intermediary.intm_name%TYPE;
   BEGIN
      BEGIN
         SELECT '-     ' || intm_name
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

   FUNCTION cf_assd_name (p_assd_no NUMBER)
      RETURN VARCHAR2
   IS
      v_assd   giis_assured.assd_name%TYPE;
   BEGIN
      BEGIN
         SELECT assd_name
           INTO v_assd
           FROM giis_assured
          WHERE assd_no = p_assd_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      RETURN v_assd;
   END;

   FUNCTION get_giclr204e_record (
      p_assd_no      NUMBER,
      p_intm_no      NUMBER,
      p_iss_cd       VARCHAR2,
      p_line_cd      VARCHAR2,
      p_session_id   NUMBER,
      p_subline_cd   VARCHAR2,
      p_date         VARCHAR2
   )
      RETURN giclr204e_record_tab PIPELINED
   IS
      v_rec   giclr204e_record_type;
      mjm     BOOLEAN               := TRUE;
   BEGIN
      v_rec.company_name := cf_company_name;
      v_rec.company_address := cf_company_address;
      v_rec.line_name := cf_line_name (p_line_cd);
      v_rec.subline_name := cf_subline_name (p_line_cd, p_subline_cd);
      v_rec.iss_name := cf_iss_name (p_iss_cd);
      v_rec.intm_name := cf_intm_name (p_intm_no);
      v_rec.as_of_date := TO_CHAR(TO_DATE(p_date, 'mm-dd-yyyy'), 'fmMonth dd, yyyy');

      FOR i IN (SELECT   a.assd_no, a.line_cd, a.loss_ratio_date,
                         NVL(a.curr_prem_amt, 0) curr_prem_amt, 
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
         mjm := FALSE;
         v_rec.assd_no := i.assd_no;
         v_rec.line_cd := i.line_cd;
         v_rec.loss_ratio_date := i.loss_ratio_date;
         v_rec.curr_prem_amt := i.curr_prem_amt;
         v_rec.prem_res_cy := i.prem_res_cy;
         v_rec.prem_res_py := i.prem_res_py;
         v_rec.loss_paid_amt := i.loss_paid_amt;
         v_rec.curr_loss_res := i.curr_loss_res;
         v_rec.prev_loss_res := i.prev_loss_res;
         v_rec.premiums_earned := i.premiums_earned;
         v_rec.losses_incurred := i.losses_incurred;
         v_rec.assd_name := cf_assd_name (i.assd_no);
         PIPE ROW (v_rec);
      END LOOP;

--      IF mjm = TRUE
--      THEN
--         v_rec.mjm := '1';
--         PIPE ROW (v_rec);
--      END IF;
   END get_giclr204e_record;
END giclr204e_pkg;
/


