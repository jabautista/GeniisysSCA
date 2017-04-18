CREATE OR REPLACE PACKAGE BODY CPI.giacr093_pkg
AS
   FUNCTION get_giacr093_company_name
      RETURN CHAR
   IS
      v_company   VARCHAR2 (500);
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_company
           FROM giac_parameters
          WHERE param_name = 'COMPANY_NAME';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RETURN ('CPI INSURANCE CORP.');
      END;

      RETURN (v_company);
   END get_giacr093_company_name;

   FUNCTION get_giacr093_company_address
      RETURN CHAR
   IS
      v_address   VARCHAR2 (500);
   BEGIN
      SELECT param_value_v
        INTO v_address
        FROM giis_parameters
       WHERE param_name = 'COMPANY_ADDRESS';

      RETURN (v_address);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
         RETURN (v_address);
   END get_giacr093_company_address;

   FUNCTION get_giacr093_title (p_pdc CHARACTER)
      RETURN CHARACTER
   IS
      v_title   VARCHAR2 (200);
   BEGIN
      IF p_pdc = 'R'
      THEN
         v_title := ('POST-DATED CHECKS REGISTER');
      ELSIF p_pdc = 'O'
      THEN
         v_title := ('OUTSTANDING POST-DATED CHECKS');
      END IF;

      RETURN (v_title);
   END get_giacr093_title;

   FUNCTION get_giacr093_as_of (p_as_of DATE)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN ('Check Date as of ' || TO_CHAR (p_as_of, 'fmMonth DD, RRRR'));
   END get_giacr093_as_of;

   FUNCTION get_giacr093__cut_off (p_cut_off DATE)
      RETURN CHAR
   IS
   BEGIN
      RETURN ('O.R. Date as of ' || TO_CHAR (p_cut_off, 'fmMonth DD, RRRR'));
   END get_giacr093__cut_off;

   FUNCTION get_giacr093_records (
      p_as_of           DATE,
      p_begin_extract   VARCHAR2,
      p_branch_cd       VARCHAR2,
      p_cut_off         DATE,
      p_end_extract     VARCHAR2,
      p_pdc             CHARACTER,
      p_user_id         VARCHAR2
   )
      RETURN giacr093_record_tab PIPELINED
   IS
      v_list   giacr093_record_type;
   BEGIN
      FOR i IN
         (SELECT a.branch_cd branch,
                 DECODE (a.apdc_no,
                         NULL, 'UNDISTRIBUTED',
                         a.apdc_pref || '-' || LPAD (a.apdc_no, 10, '0')
                        ) apdc_no,
                 a.apdc_date apdcdate,--"DATE",         /*dean - added lpad to apdc_no*/
                 b.bank_sname bank,a.bank_cd,
                 a.bank_branch bank_branch, a.check_no check_no,
                 a.check_date checkdate, a.check_amt amount,
                 a.or_date or_date,
                 DECODE (a.or_pref_suf,
                         NULL, NULL,
                         a.or_pref_suf || '-' || LPAD (a.or_no, 10, '0')
                        ) or_no,
                 
                 /*dean - added decode and lpad to or_no and concatinated or_pref_suf*/
                 c.ref_apdc_no, c.payor                        --CAR 07292010
            FROM giac_pdc_ext a, giac_banks b, giac_apdc_payt c
           WHERE a.bank_cd = b.bank_cd
             AND a.as_of_date = p_as_of
             AND a.cut_off_date = p_cut_off
             AND a.user_id = p_user_id
             AND a.extract_date BETWEEN TO_DATE (p_begin_extract,
                                                 'MM/DD/RRRR HH:MI:SS AM'
                                                )
                                    AND TO_DATE (p_end_extract,
                                                 'MM/DD/RRRR HH:MI:SS AM'
                                                )
             AND a.apdc_id = c.apdc_id   -- CAR 07292010  
             ORDER BY a.branch_cd
             
            )
               
                                  
      LOOP
         v_list.branch_cd := i.branch;
         v_list.apdc_no     := i.apdc_no;
         v_list.apdcdate     :=i.apdcdate;
         v_list.bank_sname := i.bank;
         v_list.bank_branch := i.bank_branch;
         v_list.bank_cd     :=i.bank_cd;
         v_list.check_no := i.check_no;
         v_list.check_amt := i.amount;
         v_list.checkdate :=i.checkdate;
         v_list.or_date := i.or_date;
         v_list.or_no := i.or_no;
         v_list.ref_apdc_no := i.ref_apdc_no;
         v_list.payor := i.payor;
         v_list.company_name := get_giacr093_company_name;
         v_list.company_address := get_giacr093_company_address;
         v_list.title := get_giacr093_title (p_pdc);
         v_list.as_of := get_giacr093_as_of (p_as_of);
         v_list.cut_off := get_giacr093__cut_off (p_cut_off);

         FOR j IN (SELECT branch_cd, branch_name
                     FROM giac_branches
                    WHERE i.branch = branch_cd)
                   
         LOOP
            v_list.branch_name := j.branch_name;
            
            exit;
         END LOOP;

         PIPE ROW (v_list);
      END LOOP;
   --RETURN;
   END get_giacr093_records;
END;
/


