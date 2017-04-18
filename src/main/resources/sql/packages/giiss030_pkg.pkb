CREATE OR REPLACE PACKAGE BODY CPI.giiss030_pkg
AS
/*
**  Created by   : Ildefonso Ellarina
**  Date Created    : 09.16.2013
**  Reference By    : (GIISS030 - Underwriting - File Maintenance - Reinsurance - Reinsurer)
**  Description  : Populate Reinsurer List
*/
   FUNCTION get_rec_list (
      p_ri_cd      giis_reinsurer.ri_cd%TYPE,
      p_ri_sname   giis_reinsurer.ri_sname%TYPE,
      p_ri_name    giis_reinsurer.ri_name%TYPE
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT   ri_cd, local_foreign_sw, ri_status_cd, ri_sname,
                         ri_name, mail_address1, mail_address2,
                         mail_address3, bill_address1, bill_address2,
                         bill_address3, phone_no, fax_no, telex_no,
                         contact_pers, attention, int_tax_rt, pres_and_xos,
                         liscence_no, max_line_net_ret, max_net_ret,
                         tot_asset, tot_liab, tot_net_worth, capital_struc,
                         ri_type, eff_date, expiry_date, user_id,
                         last_update, remarks, cp_no, sun_no, smart_no,
                         globe_no, input_vat_rate, ri_tin, facilities
                    FROM giis_reinsurer
                   WHERE ri_cd = NVL (p_ri_cd, ri_cd)
                     AND UPPER (ri_sname) LIKE UPPER (NVL (p_ri_sname, '%'))
                     AND UPPER (ri_name) LIKE UPPER (NVL (p_ri_name, '%'))
                ORDER BY ri_cd)
      LOOP
         v_rec.ri_status_desc := NULL;
         v_rec.ri_cd := TRIM (TO_CHAR (i.ri_cd, '09999'));
         v_rec.local_foreign_sw := i.local_foreign_sw;
         v_rec.ri_status_cd := i.ri_status_cd;
         v_rec.ri_sname := i.ri_sname;
         v_rec.ri_name := i.ri_name;
         v_rec.mail_address1 := i.mail_address1;
         v_rec.mail_address2 := i.mail_address2;
         v_rec.mail_address3 := i.mail_address3;
         v_rec.bill_address1 := i.bill_address1;
         v_rec.bill_address2 := i.bill_address2;
         v_rec.bill_address3 := i.bill_address3;
         v_rec.phone_no := i.phone_no;
         v_rec.fax_no := i.fax_no;
         v_rec.telex_no := i.telex_no;
         v_rec.contact_pers := i.contact_pers;
         v_rec.attention := i.attention;
         v_rec.int_tax_rt := i.int_tax_rt;
         v_rec.pres_and_xos := i.pres_and_xos;
         v_rec.liscence_no := i.liscence_no;
         v_rec.max_line_net_ret := i.max_line_net_ret;
         v_rec.max_net_ret := i.max_net_ret;
         v_rec.tot_asset := i.tot_asset;
         v_rec.tot_liab := i.tot_liab;
         v_rec.tot_net_worth := i.tot_net_worth;
         v_rec.capital_struc := i.capital_struc;
         v_rec.ri_type := i.ri_type;
         v_rec.eff_date := TO_CHAR (i.eff_date, 'MM-DD-RRRR');
         v_rec.expiry_date := TO_CHAR (i.expiry_date, 'MM-DD-RRRR');
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                         TO_CHAR (i.last_update, 'MM-DD-RRRR    HH:MI:SS AM');
         v_rec.remarks := i.remarks;
         v_rec.cp_no := i.cp_no;
         v_rec.sun_no := i.sun_no;
         v_rec.smart_no := i.smart_no;
         v_rec.globe_no := i.globe_no;
         v_rec.input_vat_rate := i.input_vat_rate;
         v_rec.ri_tin := i.ri_tin;
         v_rec.facilities := i.facilities;
         v_rec.ri_status_desc := 202;

         BEGIN
            SELECT status_desc
              INTO v_rec.ri_status_desc
              FROM giis_ri_status
             WHERE status_cd = i.ri_status_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.ri_status_desc := NULL;
         END;

         BEGIN
            SELECT ri_type_desc
              INTO v_rec.ri_type_desc
              FROM giis_reinsurer_type
             WHERE ri_type = i.ri_type;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.ri_type_desc := NULL;
         END;

         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_rec_list;

   FUNCTION validate_mobile_prefix (p_field VARCHAR2)
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
         RETURN (0);
      END IF;
   END validate_mobile_prefix;

   FUNCTION validate_mobile_no (
      p_param   IN   VARCHAR2,
      p_field   IN   VARCHAR2,
      p_ctype   IN   VARCHAR2
   )
      RETURN mobile_no_tab PIPELINED
   IS
      v_list            mobile_no_type;
      v_length          NUMBER
                             := giiss030_pkg.validate_mobile_prefix (p_field);
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
      v_flag            BOOLEAN        := FALSE;
      --serves as flag to check if the input cell no is valid
      v_val             VARCHAR2 (50)  := NULL;
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
      --checks the entered cell no for invalid characters
      LOOP
         v_val := SUBSTR (p_field, i, 1);

         IF ASCII (v_val) NOT BETWEEN 48 AND 57
         THEN
            v_list.MESSAGE := 'Invalid mobile number.';
         END IF;
      END LOOP;

      IF LENGTH (p_field) <> v_length
      THEN
         v_list.MESSAGE := 'Invalid mobile number.';
      ELSE
         FOR i IN (SELECT INSTR (param_value_v, v_prefix)
                     FROM giis_parameters
                    WHERE param_name LIKE p_param
                      AND INSTR (param_value_v, v_prefix) <> 0)
         LOOP
            v_flag := TRUE;
--entered cell number satisfies the given possible prefixes of a mobile network.
         END LOOP;

         IF v_flag = FALSE
         THEN
            IF p_ctype <> 'all'
            THEN
               v_list.def_check := 2;
               v_list.MESSAGE := 'Invalid ' || p_ctype || ' mobile number.';
            ELSIF p_ctype = 'all'
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
   END validate_mobile_no;

   FUNCTION get_max_ri_cd
      RETURN NUMBER
   IS
      v_max_ri_cd   NUMBER;
   BEGIN
      BEGIN
         SELECT MAX (ri_cd)
           INTO v_max_ri_cd
           FROM giis_reinsurer;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_max_ri_cd := 0;
      END;

      RETURN v_max_ri_cd;
   END;

   PROCEDURE val_add_rec (p_ri_name giis_reinsurer.ri_name%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_reinsurer a
                 WHERE a.ri_name = p_ri_name)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same ri_name.#'
            );
         RETURN;
      END IF;
   END;

      /*
   **  Created by   : Ildefonso Ellarina
   **  Date Created    : 09.20.2013
   **  Reference By    : (GIISS030 - Underwriting - File Maintenance - Reinsurance - Reinsurer)
   **  Description     : Insert or update record in giis_reinsurer
   */
   PROCEDURE set_rec (p_rec giis_reinsurer%ROWTYPE)
   IS
      v_ri_cd_next_val   NUMBER;
   BEGIN
      IF p_rec.ri_cd IS NULL
      THEN
         BEGIN
            SELECT reinsurer_ri_cd_s.NEXTVAL
              INTO v_ri_cd_next_val
              FROM DUAL;
         END;
      END IF;

      MERGE INTO giis_reinsurer
         USING DUAL
         ON (ri_cd = p_rec.ri_cd)
         WHEN NOT MATCHED THEN
            INSERT (ri_cd, local_foreign_sw, ri_status_cd, ri_sname, ri_name,
                    mail_address1, mail_address2, mail_address3,
                    bill_address1, bill_address2, bill_address3, phone_no,
                    fax_no, telex_no, contact_pers, attention, int_tax_rt,
                    pres_and_xos, liscence_no, max_line_net_ret, max_net_ret,
                    tot_asset, tot_liab, tot_net_worth, capital_struc,
                    ri_type, eff_date, expiry_date, remarks, cp_no, sun_no,
                    smart_no, globe_no, input_vat_rate, ri_tin, facilities)
            VALUES (v_ri_cd_next_val, p_rec.local_foreign_sw,
                    p_rec.ri_status_cd, p_rec.ri_sname, p_rec.ri_name,
                    p_rec.mail_address1, p_rec.mail_address2,
                    p_rec.mail_address3, p_rec.bill_address1,
                    p_rec.bill_address2, p_rec.bill_address3, p_rec.phone_no,
                    p_rec.fax_no, p_rec.telex_no, p_rec.contact_pers,
                    p_rec.attention, p_rec.int_tax_rt, p_rec.pres_and_xos,
                    p_rec.liscence_no, p_rec.max_line_net_ret,
                    p_rec.max_net_ret, p_rec.tot_asset, p_rec.tot_liab,
                    p_rec.tot_net_worth, p_rec.capital_struc, p_rec.ri_type,
                    p_rec.eff_date, p_rec.expiry_date, p_rec.remarks,
                    p_rec.cp_no, p_rec.sun_no, p_rec.smart_no, p_rec.globe_no,
                    p_rec.input_vat_rate, p_rec.ri_tin, p_rec.facilities)
         WHEN MATCHED THEN
            UPDATE
               SET local_foreign_sw = p_rec.local_foreign_sw,
                   ri_status_cd = p_rec.ri_status_cd,
                   ri_sname = p_rec.ri_sname, ri_name = p_rec.ri_name,
                   mail_address1 = p_rec.mail_address1,
                   mail_address2 = p_rec.mail_address2,
                   mail_address3 = p_rec.mail_address3,
                   bill_address1 = p_rec.bill_address1,
                   bill_address2 = p_rec.bill_address2,
                   bill_address3 = p_rec.bill_address3,
                   phone_no = p_rec.phone_no, fax_no = p_rec.fax_no,
                   telex_no = p_rec.telex_no,
                   contact_pers = p_rec.contact_pers,
                   attention = p_rec.attention, int_tax_rt = p_rec.int_tax_rt,
                   pres_and_xos = p_rec.pres_and_xos,
                   liscence_no = p_rec.liscence_no,
                   max_line_net_ret = p_rec.max_line_net_ret,
                   max_net_ret = p_rec.max_net_ret,
                   tot_asset = p_rec.tot_asset, tot_liab = p_rec.tot_liab,
                   tot_net_worth = p_rec.tot_net_worth,
                   capital_struc = p_rec.capital_struc,
                   ri_type = p_rec.ri_type, eff_date = p_rec.eff_date,
                   expiry_date = p_rec.expiry_date, remarks = p_rec.remarks,
                   cp_no = p_rec.cp_no, sun_no = p_rec.sun_no,
                   smart_no = p_rec.smart_no, globe_no = p_rec.globe_no,
                   input_vat_rate = p_rec.input_vat_rate,
                   ri_tin = p_rec.ri_tin, facilities = p_rec.facilities
            ;
   END set_rec;
END giiss030_pkg;
/


