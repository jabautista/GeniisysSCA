CREATE OR REPLACE PACKAGE BODY CPI.gicls150_pkg
AS
/*
**  Created by   : Ildefonso Ellarina
**  Date Created : 4.25.2013
**  Reference By    : (GICLS150 - Table Maintenance Claim Payee)
**  Description  : Populate Claim Payee Class
*/
   FUNCTION get_clm_payee_class (
      p_payee_class_cd   giis_payee_class.payee_class_cd%TYPE,
      p_class_desc       giis_payee_class.class_desc%TYPE
   )
      RETURN clm_payee_class_tab PIPELINED
   IS
      v_list   clm_payee_class_type;
   BEGIN
      FOR i IN
         (SELECT   payee_class_cd, class_desc, payee_class_tag
              FROM giis_payee_class
             WHERE UPPER (payee_class_cd) LIKE
                               UPPER (NVL (p_payee_class_cd, payee_class_cd))
               AND UPPER (class_desc) LIKE
                                        UPPER (NVL (p_class_desc, class_desc))
          ORDER BY payee_class_cd)
      LOOP
         v_list.payee_class_cd := i.payee_class_cd;
         v_list.class_desc := i.class_desc;
         v_list.payee_class_tag := i.payee_class_tag;

         BEGIN
            IF i.payee_class_tag = 'S'
            THEN
               v_list.payee_class_tag_desc := 'SYSTEM GENERATED';
            ELSIF i.payee_class_tag = 'M'
            THEN
               v_list.payee_class_tag_desc := 'MANUAL';
            END IF;
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_clm_payee_class;

/*
**  Created by   : Ildefonso Ellarina
**  Date Created : 4.25.2013
**  Reference By    : (GICLS150 - Table Maintenance Claim Payee)
**  Description  : Populate Claim Payee Information
*/
   FUNCTION get_clm_payee_info (
      p_payee_class_cd   giis_payees.payee_class_cd%TYPE
   )
      RETURN clm_payee_info_tab PIPELINED
   IS
      v_list   clm_payee_info_type;
   BEGIN
      FOR i IN (SELECT   payee_no, payee_last_name, payee_first_name,
                         payee_middle_name, tin, mail_addr1, mail_addr2,
                         mail_addr3,
                         mail_addr1 ||' '|| mail_addr2
                         ||' '|| mail_addr3 mailing_address,
                         remarks, user_id, ref_payee_cd, contact_pers,
                         designation, cp_no, sun_no, globe_no, smart_no,
                         phone_no, fax_no, master_payee_no, allow_tag, 
                         last_update
                    FROM giis_payees
                   WHERE payee_class_cd = p_payee_class_cd
                ORDER BY payee_no)
      LOOP
         v_list.payee_no := i.payee_no;
         v_list.payee_last_name := i.payee_last_name;
         v_list.payee_first_name := i.payee_first_name;
         v_list.payee_middle_name := i.payee_middle_name;
         v_list.tin := i.tin;
         v_list.mail_addr1 := i.mail_addr1;
         v_list.mail_addr2 := i.mail_addr2;
         v_list.mail_addr3 := i.mail_addr3;
         v_list.mailing_address := i.mailing_address;
         v_list.remarks := i.remarks;
         v_list.user_id := i.user_id;
         v_list.ref_payee_cd := i.ref_payee_cd;
         v_list.contact_pers := i.contact_pers;
         v_list.designation := i.designation;
         v_list.cp_no := i.cp_no;
         v_list.sun_no := i.sun_no;
         v_list.globe_no := i.globe_no;
         v_list.smart_no := i.smart_no;
         v_list.phone_no := i.phone_no;
         v_list.fax_no := i.fax_no;
         v_list.master_payee_no := i.master_payee_no;        
         v_list.allow_tag := i.allow_tag;
         v_list.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-RRRR HH:MI:SS PM');
         v_list.master_payee_name := NULL;

         BEGIN
            FOR j IN (SELECT a.payee_last_name
                        FROM giis_payees a, giis_payee_class b
                       WHERE a.payee_class_cd = b.master_payee_class_cd
                         AND b.payee_class_cd = p_payee_class_cd
                         AND a.payee_no = i.master_payee_no)
            LOOP
               v_list.master_payee_name := j.payee_last_name;
            END LOOP;
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_clm_payee_info;

/*
**  Created by   : Ildefonso Ellarina
**  Date Created : 4.25.2013
**  Reference By    : (GICLS150 - Table Maintenance Claim Payee)
**  Description  : Show Master Payee LOV
*/
   FUNCTION get_master_payee_lov_list (
      p_payee_class_cd   giis_payee_class.payee_class_cd%TYPE
   )
      RETURN clm_master_payee_lov_tab PIPELINED
   IS
      v_list   clm_master_payee_lov_type;
   BEGIN
      FOR i IN (SELECT   a.payee_no, a.payee_last_name payee
                    FROM giis_payees a, giis_payee_class b
                   WHERE a.payee_class_cd = b.master_payee_class_cd
                     AND b.payee_class_cd = p_payee_class_cd
                ORDER BY payee_last_name)
      LOOP
         v_list.payee_no := i.payee_no;
         v_list.payee := i.payee;
         PIPE ROW (v_list);
      END LOOP;
   END get_master_payee_lov_list;

/*
**  Created by   : Ildefonso Ellarina
**  Date Created : 4.25.2013
**  Reference By    : (GICLS150 - Table Maintenance Claim Payee)
**  Description  : Populate Bank Account History Fields
*/
   FUNCTION get_bank_acct_hstry_field (
      p_payee_class_cd   giis_payee_bank_acct_hist.payee_class_cd%TYPE,
      p_payee_no         giis_payee_bank_acct_hist.payee_no%TYPE
   )
      RETURN clm_bank_acct_hstry_field_tab PIPELINED
   IS
      v_list   clm_bank_acct_hstry_field_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.FIELD
                           FROM giis_payee_bank_acct_hist a
                          WHERE a.payee_class_cd = p_payee_class_cd
                            AND a.payee_no = p_payee_no
                       ORDER BY a.FIELD ASC)
      LOOP
         v_list.FIELD := i.FIELD;
         PIPE ROW (v_list);
      END LOOP;
   END get_bank_acct_hstry_field;

/*
**  Created by   : Ildefonso Ellarina
**  Date Created : 4.25.2013
**  Reference By    : (GICLS150 - Table Maintenance Claim Payee)
**  Description  : Populate Bank Account History Values
*/
   FUNCTION get_bank_acct_hstry_value (
      p_payee_class_cd   giis_payee_bank_acct_hist.payee_class_cd%TYPE,
      p_payee_no         giis_payee_bank_acct_hist.payee_no%TYPE,
      p_field            giis_payee_bank_acct_hist.FIELD%TYPE
   )
      RETURN clm_bank_acct_hstry_value_tab PIPELINED
   IS
      v_list   clm_bank_acct_hstry_value_type;
   BEGIN
      FOR i IN (SELECT   a.FIELD, a.old_value, a.new_value, a.user_id,
                         a.last_update
                    FROM giis_payee_bank_acct_hist a
                   WHERE a.payee_class_cd = p_payee_class_cd
                     AND a.payee_no = p_payee_no
                     AND a.FIELD = p_field
                ORDER BY a.FIELD, a.last_update ASC)
      LOOP
         v_list.old_value := i.old_value;
         v_list.new_value := i.new_value;
         v_list.user_id := i.user_id;
         v_list.last_update :=
                            TO_CHAR (i.last_update, 'MM/DD/RRRR HH:MI:SS PM');
         PIPE ROW (v_list);
      END LOOP;
   END get_bank_acct_hstry_value;

/*
**  Created by   : Ildefonso Ellarina
**  Date Created : 4.25.2013
**  Reference By    : (GICLS150 - Table Maintenance Claim Payee)
**  Description  : Populate Approval of Bank Account Details
*/
   FUNCTION get_bank_acct_approvals (
      p_payee_class_cd   giis_payees.payee_class_cd%TYPE
   )
      RETURN clm_payee_info_tab PIPELINED
   IS
      v_list   clm_payee_info_type;
   BEGIN
      FOR i IN (SELECT   payee_no, payee_last_name, bank_cd, bank_branch,
                         bank_acct_name, bank_acct_no, bank_acct_type,
                         bank_acct_app_date, bank_acct_app_tag,
                         bank_acct_app_user
                    FROM giis_payees
                   WHERE bank_acct_app_tag <> 'Y'
                     AND payee_class_cd = p_payee_class_cd
                ORDER BY payee_no)
      LOOP
         v_list.payee_no := i.payee_no;
         v_list.payee_last_name := i.payee_last_name;
         v_list.bank_cd := i.bank_cd;
         v_list.bank_branch := i.bank_branch;
         v_list.bank_acct_type := i.bank_acct_type;
         v_list.bank_acct_name := i.bank_acct_name;
         v_list.bank_acct_no := i.bank_acct_no;
         v_list.bank_name := NULL;
         v_list.bank_acct_typ := NULL;
         v_list.bank_acct_app_tag := i.bank_acct_app_tag;
         v_list.bank_acct_app_user := NVL (i.bank_acct_app_user, ' ');
         v_list.bank_acct_app_date :=
            NVL (TO_CHAR (i.bank_acct_app_date, 'MM/DD/RRRR HH:MI:SS AM'),
                 ' '
                );

         BEGIN
            FOR j IN (SELECT bank_name
                        FROM giac_banks
                       WHERE bank_cd = i.bank_cd)
            LOOP
               v_list.bank_name := j.bank_name;
            END LOOP;
         END;

         BEGIN
            FOR j IN (SELECT rv_meaning
                        FROM cg_ref_codes
                       WHERE rv_domain = 'GIAC_BANK_ACCOUNTS.BANK_ACCT_TYPE'
                         AND rv_low_value = i.bank_acct_type)
            LOOP
               v_list.bank_acct_typ := j.rv_meaning;
            END LOOP;
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_bank_acct_approvals;

/*
**  Created by   : Ildefonso Ellarina
**  Date Created : 4.25.2013
**  Reference By    : (GICLS150 - Table Maintenance Claim Payee)
**  Description  : Validate Mobile Prefix
*/
   FUNCTION validate_mobile_no_prefix (p_field VARCHAR2)
      RETURN NUMBER
   IS
   BEGIN
      IF INSTR (SUBSTR (p_field, 1, LENGTH (p_field) - 7), '09') = 1
      THEN
         RETURN (11);
      ELSIF INSTR (SUBSTR (p_field, 1, LENGTH (p_field) - 7), '639') = 1
      THEN
         RETURN (12);
      ELSIF INSTR (SUBSTR (p_field, 1, LENGTH (p_field) - 7), '+639') = 1
      THEN
         RETURN (13);
      ELSE
         RETURN (NULL);
      END IF;
   END validate_mobile_no_prefix;

/*
**  Created by   : Ildefonso Ellarina
**  Date Created : 4.25.2013
**  Reference By    : (GICLS150 - Table Maintenance Claim Payee)
**  Description  : This procedure checks the entered cell number if it is a valid smart, sun, or globe no
*/
   FUNCTION validate_mobile_number (
      p_param   IN   VARCHAR2,
      p_field   IN   VARCHAR2,
      p_ctype   IN   VARCHAR2
   )
      RETURN validate_mobile_no_tab PIPELINED
   IS
      v_list            validate_mobile_no_type;
      v_length          NUMBER
                          := gicls150_pkg.validate_mobile_no_prefix (p_field);
      --checks if the prefix given is valid starts with either 09, or 639 or +639
      v_prefix          VARCHAR2 (50)
         := (SUBSTR (p_field,
                     NVL (INSTR (SUBSTR (p_field, 1, LENGTH (p_field) - 7),
                                 '9'),
                          0
                         ),
                     3
                    )
            );                                        --input cell no's prefix
      v_prefix_motype   VARCHAR2 (50);       --passes the valid smart prefixes
      v_flag            BOOLEAN;
      --serves as flag to check if the input cell no is valid
      v_val             VARCHAR2 (50)           := NULL;
      --checking of character
      a                 NUMBER;
   BEGIN
      IF INSTR (p_field, '+') = 1
      THEN
         a := 2;
      ELSE
         a := 1;
      END IF;

      FOR i IN a .. LENGTH (p_field)
      LOOP
         v_val := SUBSTR (p_field, i, 1);

         IF ASCII (v_val) NOT BETWEEN 48 AND 57
         THEN
            v_list.MESSAGE := 'Invalid mobile number.';
            PIPE ROW (v_list);
            RETURN;
         END IF;
      END LOOP;

      IF LENGTH (p_field) <> v_length
      THEN
         v_list.MESSAGE := 'Invalid ' || p_ctype || ' mobile number.';
         PIPE ROW (v_list);
         RETURN;
      ELSE
         SELECT param_value_v
           INTO v_prefix_motype
           FROM giis_parameters
          WHERE param_name LIKE p_param;

         --retrieves the possible prefixes of globe/sun/smart lines
         LOOP
            IF NOT (v_prefix = SUBSTR (v_prefix_motype, 1, 3))
            THEN
               v_flag := FALSE;
--entered cell number did not satisfy the given possible prefixes of a mobile co.
            ELSIF v_prefix = SUBSTR (v_prefix_motype, 1, 3)
            THEN
               v_flag := TRUE;
            --entered cell number satisfies the given possible prefixes of a mobile co.
            END IF;

            v_prefix_motype :=
                         SUBSTR (v_prefix_motype, 5, LENGTH (v_prefix_motype));
            EXIT WHEN v_prefix_motype IS NULL OR v_flag = TRUE;
         END LOOP;

         IF v_flag = FALSE
         THEN
            IF p_ctype <> 'Default'
            THEN
               IF p_ctype = 'Sun'
               THEN
                  v_list.MESSAGE := 'Invalid ' || p_ctype || ' mobile number.';
                  v_list.def_check := 2;
                  PIPE ROW (v_list);
                  RETURN;
               ELSIF p_ctype = 'Globe'
               THEN
                  v_list.MESSAGE := 'Invalid ' || p_ctype || ' mobile number.';
                  v_list.def_check := 2;
                  PIPE ROW (v_list);
                  RETURN;
               ELSIF p_ctype = 'Smart'
               THEN
                  v_list.MESSAGE := 'Invalid ' || p_ctype || ' mobile number.';
                  v_list.def_check := 2;
                  PIPE ROW (v_list);
                  RETURN;
               END IF;
            ELSIF p_ctype = 'Default'
            THEN
               v_list.def_check := 0;
            END IF;
         ELSIF v_flag = TRUE
         THEN
            v_list.def_check := 1;
         END IF;
      END IF;

      PIPE ROW (v_list);
      RETURN;
   END validate_mobile_number;

/*
**  Created by       :Fons Ellarina
**  Date Created    : 05.09.2013
**  Reference By    : (GICLS150 - Table Maintenance Claim Payee)
**  Description     : Insert or update record to giis_payees
*/
   PROCEDURE set_gicls150_claim_payee (p_rec giis_payees%ROWTYPE)
   IS
      v_payee_no   giis_payees.payee_no%TYPE;
   BEGIN
      BEGIN
         SELECT MAX (payee_no) + 1
           INTO v_payee_no
           FROM giis_payees
          WHERE payee_class_cd = p_rec.payee_class_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_payee_no := 1;
      END;

      MERGE INTO giis_payees
         USING DUAL
         ON (    payee_class_cd = p_rec.payee_class_cd
             AND payee_no = p_rec.payee_no)
         WHEN NOT MATCHED THEN
            INSERT (payee_class_cd, payee_no, payee_last_name, mail_addr1,
                    tin, allow_tag, payee_first_name, payee_middle_name,
                    mail_addr2, mail_addr3, contact_pers, designation,
                    phone_no, remarks, fax_no, cp_no, sun_no, smart_no,
                    globe_no, ref_payee_cd, master_payee_no, user_id, 
                    last_update)
            VALUES (p_rec.payee_class_cd, v_payee_no, p_rec.payee_last_name,
                    p_rec.mail_addr1, p_rec.tin, p_rec.allow_tag,
                    p_rec.payee_first_name, p_rec.payee_middle_name,
                    p_rec.mail_addr2, p_rec.mail_addr3, p_rec.contact_pers,
                    p_rec.designation, p_rec.phone_no, p_rec.remarks,
                    p_rec.fax_no, p_rec.cp_no, p_rec.sun_no, p_rec.smart_no,
                    p_rec.globe_no, p_rec.ref_payee_cd, p_rec.master_payee_no,
                    p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET payee_last_name = p_rec.payee_last_name,
                   mail_addr1 = p_rec.mail_addr1, tin = p_rec.tin,
                   allow_tag = p_rec.allow_tag,
                   payee_first_name = p_rec.payee_first_name,
                   payee_middle_name = p_rec.payee_middle_name,
                   mail_addr2 = p_rec.mail_addr2,
                   mail_addr3 = p_rec.mail_addr3,
                   contact_pers = p_rec.contact_pers,
                   designation = p_rec.designation, phone_no = p_rec.phone_no,
                   remarks = p_rec.remarks, fax_no = p_rec.fax_no,
                   cp_no = p_rec.cp_no, sun_no = p_rec.sun_no,
                   smart_no = p_rec.smart_no, globe_no = p_rec.globe_no,
                   ref_payee_cd = p_rec.ref_payee_cd,
                   master_payee_no = p_rec.master_payee_no,                   
                   user_id = p_rec.user_id,
                   last_update = SYSDATE
            ;
   END set_gicls150_claim_payee;

/*
**  Created by       :Fons Ellarina
**  Date Created    : 05.09.2013
**  Reference By    : (GICLS150 - Table Maintenance Claim Payee)
**  Description     :  Update Bank Account Details in giis_payees
*/
   PROCEDURE update_bank_acct_dtls (p_payees giis_payees%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_payees
         USING DUAL
         ON (    payee_class_cd = p_payees.payee_class_cd
             AND payee_no = p_payees.payee_no)
         WHEN MATCHED THEN
            UPDATE
               SET bank_cd = p_payees.bank_cd,
                   bank_branch = p_payees.bank_branch,
                   bank_acct_type = p_payees.bank_acct_type,
                   bank_acct_name = p_payees.bank_acct_name,
                   bank_acct_no = p_payees.bank_acct_no,
                   bank_acct_app_date = p_payees.bank_acct_app_date,
                   bank_acct_app_tag = p_payees.bank_acct_app_tag,
                   bank_acct_app_user = p_payees.bank_acct_app_user,
                   user_id = p_payees.user_id,
                   last_update = SYSDATE
            ;
   END update_bank_acct_dtls;

/*
**  Created by       :Fons Ellarina
**  Date Created    : 05.09.2013
**  Reference By    : (GICLS150 - Table Maintenance Claim Payee)
**  Description     :  Update Bank Account Details Approval Tag in giis_payees
*/
   PROCEDURE approve_bank_acct_dtls (
      p_payee_class_cd      giis_payees.payee_class_cd%TYPE,
      p_payee_no            giis_payees.payee_no%TYPE,
      p_bank_acct_app_tag   giis_payees.bank_acct_app_tag%TYPE,
      p_user_id             giis_payees.user_id%TYPE
   )
   IS
   BEGIN
      MERGE INTO giis_payees
         USING DUAL
         ON (payee_class_cd = p_payee_class_cd AND payee_no = p_payee_no)
         WHEN MATCHED THEN
            UPDATE
               SET bank_acct_app_date = SYSDATE,
                   bank_acct_app_tag = p_bank_acct_app_tag,
                   bank_acct_app_user = p_user_id,
                   user_id = p_user_id,
                   last_update = SYSDATE
            ;
       COMMIT;
   END approve_bank_acct_dtls;
   
    FUNCTION get_bank_acct_dtls (
      p_payee_class_cd   giis_payees.payee_class_cd%TYPE,
      p_payee_no         giis_payees.payee_no%TYPE
   )
      RETURN bank_acct_dtls_tab PIPELINED
   IS
      v_list   bank_acct_dtls_type;
   BEGIN
      FOR i IN (SELECT   bank_cd, bank_branch, bank_acct_type, bank_acct_name,
                         bank_acct_no, bank_acct_app_date, bank_acct_app_tag,
                         bank_acct_app_user
                   FROM giis_payees
                   WHERE payee_class_cd = p_payee_class_cd
                   AND payee_no = p_payee_no)
      LOOP
         v_list.bank_cd := i.bank_cd;
         v_list.bank_acct_type := i.bank_acct_type;
         v_list.bank_branch := i.bank_branch;
         v_list.bank_acct_name := i.bank_acct_name;
         v_list.bank_acct_no := i.bank_acct_no;
         v_list.bank_acct_app_date :=
                     TO_CHAR (i.bank_acct_app_date, 'MM/DD/RRRR HH:MI:SS PM');
         v_list.bank_acct_app_tag := i.bank_acct_app_tag;
         v_list.bank_acct_app_user := i.bank_acct_app_user;
         v_list.bank_name := NULL;
         v_list.bank_acct_typ := NULL;
         
         BEGIN
            FOR j IN (SELECT bank_name
                        FROM giac_banks
                       WHERE bank_cd = i.bank_cd)
            LOOP
               v_list.bank_name := j.bank_name;
            END LOOP;
         END;

         BEGIN
            FOR j IN (SELECT rv_meaning
                        FROM cg_ref_codes
                       WHERE rv_domain = 'GIAC_BANK_ACCOUNTS.BANK_ACCT_TYPE'
                         AND rv_low_value = i.bank_acct_type)
            LOOP
               v_list.bank_acct_typ := j.rv_meaning;
            END LOOP;
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_bank_acct_dtls;

END gicls150_pkg;
/


