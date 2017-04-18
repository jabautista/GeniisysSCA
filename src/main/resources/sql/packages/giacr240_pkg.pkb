CREATE OR REPLACE PACKAGE BODY CPI.giacr240_pkg
AS
   FUNCTION get_giacr240_top_date (p_begin_date DATE, p_end_date DATE)
      RETURN VARCHAR2
   IS
      v_date   VARCHAR2 (100);
   BEGIN
      IF p_begin_date = p_end_date
      THEN
         v_date := TO_CHAR (p_begin_date, 'fmMONTH DD, YYYY');
      ELSE
         v_date :=
               'For the Period of '
            || TO_CHAR (p_begin_date, 'fmMONTH DD, YYYY')
            || ' to '
            || TO_CHAR (p_end_date, 'fmMONTH DD, YYYY');
      END IF;

      RETURN (v_date);
   END get_giacr240_top_date;

   FUNCTION get_giacr240_record (
      p_payee            VARCHAR2,
      p_branch           VARCHAR2,
      p_ouc_id           NUMBER,
      p_payee_class_cd   VARCHAR2,
      p_payee_no         NUMBER,
      p_sort_item        VARCHAR2,
      p_begin_date       VARCHAR2,
      p_end_date         VARCHAR2
   )
      RETURN giacr240_tab PIPELINED
   IS
      v_list         giacr240_type;
      v_not_exist    BOOLEAN       := TRUE;
      v_begin_date   DATE          := TO_DATE (p_begin_date, 'MM/DD/YYYY');
      v_end_date     DATE          := TO_DATE (p_end_date, 'MM/DD/YYYY');
   BEGIN
      v_list.comp_name := giisp.v ('COMPANY_NAME');
      v_list.comp_add := giacp.v ('COMPANY_ADDRESS');
      v_list.top_date := get_giacr240_top_date (v_begin_date, v_end_date);

      FOR i IN (SELECT ouc_id, ouc_name, branch_cd, branch_name,
                       payee_class_cd, class_desc,
                          payee_last_name
                       || ' '
                       || payee_first_name
                       || ' '
                       || payee_middle_name payee_name,
                       particulars, check_no, check_date, dv_amt
                  FROM giac_pd_checks_v
                 WHERE payee_class_cd =
                                       NVL (p_payee_class_cd, payee_class_cd)
                   AND payee_no = NVL (p_payee_no, payee_no)
                   AND TRUNC (check_date) >= NVL (v_begin_date, check_date)
                   AND TRUNC (check_date) <= NVL (v_end_date, check_date))
      LOOP
         v_not_exist := FALSE;
         v_list.ouc_id := i.ouc_id;
         v_list.ouc_name := i.ouc_name;
         v_list.branch_cd := i.branch_cd;
         v_list.branch_name := i.branch_name;
         v_list.payee_class_cd := i.payee_class_cd;
         v_list.class_desc := i.class_desc;
         v_list.payee_name := i.payee_name;
         v_list.particulars := i.particulars;
         v_list.check_no := i.check_no;
         v_list.check_date := i.check_date;
         v_list.dv_amt := i.dv_amt;
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.flag := 'T';
         PIPE ROW (v_list);
      END IF;
   END get_giacr240_record;
END;
/


