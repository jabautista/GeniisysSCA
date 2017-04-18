CREATE OR REPLACE PACKAGE BODY CPI.gipir946f_pkg
AS
   /*
   **  Created by   :  Alvin Azarraga
   **  Date Created : 05.31.2012
   **  Reference By : MARINE_CARGO_CERTIFICATE_RSIC
   **  Description  :
   */
   FUNCTION cf_iss_nameformula (p_iss_cd giis_issource.iss_cd%TYPE)
      RETURN CHAR
   IS
      v_iss_name   VARCHAR2 (50);
   BEGIN
      BEGIN
         SELECT iss_name
           INTO v_iss_name
           FROM giis_issource
          WHERE iss_cd = p_iss_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
         THEN
            NULL;
      END;

      RETURN (p_iss_cd || ' - ' || v_iss_name);
   END;

   FUNCTION cf_iss_titleformula (p_iss_param VARCHAR2)
      RETURN CHAR
   IS
   BEGIN
      IF p_iss_param = 1
      THEN
         RETURN ('Crediting Branch :');
      ELSIF p_iss_param = 2
      THEN
         RETURN ('Issue Source     :');
      ELSE
         RETURN NULL;
      END IF;
   END;

   FUNCTION cf_subline_nameformula (
      p_subline_cd   giis_subline.subline_cd%TYPE,
      p_line_cd      giis_subline.line_cd%TYPE
   )
      RETURN CHAR
   IS
   BEGIN
      FOR c IN (SELECT subline_name
                  FROM giis_subline
                 WHERE subline_cd = p_subline_cd AND line_cd = p_line_cd)
      LOOP
         RETURN (c.subline_name);
      END LOOP;
   END;

   FUNCTION cf_ref_intmformula (p_intm_no giis_intermediary.intm_no%TYPE)
      RETURN CHAR
   IS
      v_ref_intm   VARCHAR2 (10);
   BEGIN
      FOR intm IN (SELECT ref_intm_cd
                     FROM giis_intermediary
                    WHERE intm_no = p_intm_no)
      LOOP
         v_ref_intm := intm.ref_intm_cd;
         EXIT;
      END LOOP;

      RETURN (v_ref_intm);
   END;

   FUNCTION cf_intmformula (
      p_ref_intm_cd   giis_intermediary.ref_intm_cd%TYPE,
      p_intm_no       giis_intermediary.intm_no%TYPE,
      p_intm_name     giis_intermediary.intm_name%TYPE
   )
      RETURN CHAR
   IS
      v_intm   VARCHAR2 (275);
   BEGIN
      v_intm := p_ref_intm_cd || '/' || p_intm_no || ' ' || p_intm_name;
      RETURN (v_intm);
   END;

   FUNCTION get_gipir946f (
      p_scope        gipi_uwreports_ext.SCOPE%TYPE,
      p_iss_param    NUMBER,
      p_iss_cd       gipi_uwreports_ext.iss_cd%TYPE,
      p_line_cd      gipi_uwreports_ext.line_cd%TYPE,
      p_subline_cd   gipi_uwreports_ext.subline_cd%TYPE,
      p_user_id      gipi_uwreports_ext.user_id%TYPE -- marco - 02.05.2013 - added parameter
   )
      RETURN get_gipir946f_tab PIPELINED
   AS
      det   get_gipir946f_type;
   BEGIN
      FOR i IN (SELECT   DECODE (p_iss_param,
                                 1, a.cred_branch,
                                 a.iss_cd
                                ) iss_cd,
                         b.intm_no, a.line_cd, a.line_name, a.subline_cd,
                         a.intm_name,
                         SUM (DECODE (a.peril_type, 'B', a.tsi_amt, 0)
                             ) tsi_basic,
                         SUM (a.tsi_amt) tsi_amt, SUM (a.prem_amt) prem_amt,
                         b.ref_intm_cd
                    FROM gipi_uwreports_peril_ext a, giis_intermediary b
                   WHERE a.iss_cd <> giacp.v ('RI_ISS_CD')
                     AND a.user_id = p_user_id
                     AND a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                            NVL (p_iss_cd,
                                 DECODE (p_iss_param,
                                         1, a.cred_branch,
                                         a.iss_cd
                                        )
                                )
                     AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
                     AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                          OR (p_scope = 1 AND endt_seq_no = 0)
                          OR (p_scope = 2 AND endt_seq_no > 0)
                         )
                     AND a.intm_no = b.intm_no
					 /* added security rights control by robert 01.02.14*/
					 AND check_user_per_iss_cd2 (a.line_cd,DECODE (p_iss_param,1, a.cred_branch,a.iss_cd),'GIPIS901A', p_user_id) =1
					 AND check_user_per_line2 (a.line_cd,DECODE (p_iss_param,1, a.cred_branch,a.iss_cd),'GIPIS901A', p_user_id) = 1
					 /* robert 01.02.14 end of added code */
                GROUP BY b.intm_no,
                         b.intm_no,
                         DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd),
                         b.intm_no,
                         a.line_cd,
                         a.line_name,
                         a.subline_cd,
                         a.intm_no,
                         a.intm_name,
                         b.ref_intm_cd
                ORDER BY b.ref_intm_cd)
      LOOP
         det.iss_cd := i.iss_cd;
         det.line_cd := i.line_cd;
         det.line_name := i.line_name;
         det.subline_cd := i.subline_cd;
         det.intm_name := i.intm_name;
         det.tsi_basic := i.tsi_basic;
         det.tsi_amt := i.tsi_amt;
         det.prem_amt := i.prem_amt;
         det.ref_intm_cd := i.ref_intm_cd;
         det.subline_name :=
               gipir946f_pkg.cf_subline_nameformula (i.subline_cd, i.line_cd);
         det.iss_name := gipir946f_pkg.cf_iss_nameformula (i.iss_cd);
         det.iss_title := gipir946f_pkg.cf_iss_titleformula (p_iss_param);
         det.ref_intm := gipir946f_pkg.cf_ref_intmformula (i.intm_no);
         det.intm :=
            gipir946f_pkg.cf_intmformula (i.ref_intm_cd,
                                          i.intm_no,
                                          i.intm_name
                                         );
         PIPE ROW (det);
      END LOOP;

      RETURN;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END get_gipir946f;

   FUNCTION populate_gipir946f (
        p_scope         gipi_uwreports_ext.SCOPE%TYPE,
        p_user_id       gipi_uwreports_ext.user_id%TYPE -- marco - 02.05.2013 - added parameter
   )
      RETURN populate_gipir946f_tab PIPELINED
   AS
      det              populate_gipir946f_type;
      v_param_date     NUMBER (1);
      v_from_date      DATE;
      v_to_date        DATE;
      v_heading3       VARCHAR2 (150);
      v_company_name   VARCHAR2 (150);
      v_based_on       VARCHAR2 (100);
      v_scope          NUMBER (1);
      v_policy_label   VARCHAR2 (200);
      v_address        VARCHAR2 (500);
   BEGIN
      BEGIN
         SELECT DISTINCT param_date, from_date, TO_DATE
                    INTO v_param_date, v_from_date, v_to_date
                    FROM gipi_uwreports_peril_ext
                   WHERE user_id = p_user_id;

         IF v_param_date IN (1, 2, 4)
         THEN
            IF v_from_date = v_to_date
            THEN
               v_heading3 :=
                          'For ' || TO_CHAR (v_from_date, 'fmMonth dd, yyyy');
            ELSE
               v_heading3 :=
                     'For the period of '
                  || TO_CHAR (v_from_date, 'fmMonth dd, yyyy')
                  || ' to '
                  || TO_CHAR (v_to_date, 'fmMonth dd, yyyy');
            END IF;
         ELSE
            IF v_from_date = v_to_date
            THEN
               v_heading3 :=
                     'For the month of '
                  || TO_CHAR (v_from_date, 'fmMonth, yyyy');
            ELSE
               v_heading3 :=
                     'For the period of '
                  || TO_CHAR (v_from_date, 'fmMonth, yyyy')
                  || ' to '
                  || TO_CHAR (v_to_date, 'fmMonth, yyyy');
            END IF;
         END IF;
      END;

      BEGIN
         SELECT param_value_v
           INTO v_company_name
           FROM giis_parameters
          WHERE UPPER (param_name) = 'COMPANY_NAME';
      END;

      BEGIN
         SELECT param_date
           INTO v_param_date
           FROM gipi_uwreports_peril_ext
          WHERE user_id = p_user_id
            AND ROWNUM = 1;

         IF v_param_date = 1
         THEN
            v_based_on := 'Based on Issue Date';
         ELSIF v_param_date = 2
         THEN
            v_based_on := 'Based on Inception Date';
         ELSIF v_param_date = 3
         THEN
            v_based_on := 'Based on Booking month - year';
         ELSIF v_param_date = 4
         THEN
            v_based_on := 'Based on Acctg Entry Date';
         END IF;

         v_scope := p_scope;

         IF v_scope = 1
         THEN
            v_policy_label := v_based_on || ' / ' || 'Policies Only';
         ELSIF v_scope = 2
         THEN
            v_policy_label := v_based_on || ' / ' || 'Endorsements Only';
         ELSIF v_scope = 3
         THEN
            v_policy_label :=
                           v_based_on || ' / ' || 'Policies and Endorsements';
         END IF;

         BEGIN
            SELECT param_value_v
              INTO v_address
              FROM giis_parameters
             WHERE param_name = 'COMPANY_ADDRESS';
         END;
      END;

      det.param_date := v_param_date;
      det.from_date := v_from_date;
      det.TO_DATE := v_to_date;
      det.heading3 := v_heading3;
      det.company_name := v_company_name;
      det.based_on := v_based_on;
      det.SCOPE := v_scope;
      det.policy_label := v_policy_label;
      det.company_address := v_address;
      PIPE ROW (det);
   END;
END gipir946f_pkg;
/


