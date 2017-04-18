CREATE OR REPLACE PACKAGE BODY CPI.giis_prin_signtry_pkg
AS
   FUNCTION get_signtry_list (p_assd_no giis_prin_signtry.assd_no%TYPE)
      RETURN prin_signtry_list_tab PIPELINED
   IS
      v_signtry   prin_signtry_list_type;
   BEGIN
      FOR i IN (SELECT   prin_signor, designation, prin_id
                    FROM giis_prin_signtry
                   WHERE assd_no = p_assd_no
                ORDER BY prin_signor)
      LOOP
         v_signtry.prin_signor := i.prin_signor;
         v_signtry.designation := i.designation;
         v_signtry.prin_id := i.prin_id;
         PIPE ROW (v_signtry);
      END LOOP;

      RETURN;
   END get_signtry_list;

   FUNCTION get_prin_signor (p_prin_id giis_prin_signtry.prin_id%TYPE)
      RETURN prin_signtry_list_tab PIPELINED
   IS
      v_prin   prin_signtry_list_type;
   BEGIN
      FOR i IN (SELECT prin_signor, designation
                  FROM giis_prin_signtry
                 WHERE prin_id = p_prin_id)
      LOOP
         v_prin.prin_signor := i.prin_signor;
         v_prin.designation := i.designation;
         PIPE ROW (v_prin);
      END LOOP;

      RETURN;
   END get_prin_signor;

   FUNCTION get_principal_signatories (
      p_assd_no   giis_prin_signtry.assd_no%TYPE
   )
      RETURN principal_signatories_tab PIPELINED
   IS
      v_prin   principal_signatories_type;
   BEGIN
      FOR a IN (SELECT   prin_id, prin_signor, res_cert, designation,
                         TO_CHAR (issue_date, 'MM-DD-YYYY') issue_date,
                         issue_place, a.user_id,
                         TO_CHAR (a.last_update,
                                  'MM-DD-YYYY HH:MI:SS AM'
                                 ) last_update,
                         a.remarks, address, a.control_type_cd,
                         b.control_type_desc, bond_sw, indem_sw, ack_sw,
                         cert_sw, ri_sw
                    FROM giis_prin_signtry a, giis_control_type b
                   WHERE assd_no = p_assd_no AND a.control_type_cd = b.control_type_cd(+)
                ORDER BY prin_id,
                         assd_no,
                         prin_signor,
                         designation,
                         res_cert,
                         issue_place,
                         issue_date)
      LOOP
         v_prin.prin_id := a.prin_id;
         v_prin.prin_signor := a.prin_signor;
         v_prin.res_cert := a.res_cert;
         v_prin.designation := a.designation;
         v_prin.issue_date := a.issue_date;
         v_prin.issue_place := a.issue_place;
         v_prin.user_id := a.user_id;
         v_prin.last_update := a.last_update;
         v_prin.remarks := a.remarks;
         v_prin.address := a.address;
         v_prin.control_type_cd := a.control_type_cd;
         v_prin.control_type_desc := a.control_type_desc;
         v_prin.bond_sw := a.bond_sw;
         v_prin.indem_sw := a.indem_sw;
         v_prin.ack_sw := a.ack_sw;
         v_prin.cert_sw := a.cert_sw;
         v_prin.ri_sw := a.ri_sw;
         PIPE ROW (v_prin);
      END LOOP;

      RETURN;
   END;

   FUNCTION validate_ctc_no (p_res_cert giis_prin_signtry.res_cert%TYPE)
      RETURN VARCHAR2
   IS
      v_exist   VARCHAR (1);
      v_dummy   VARCHAR (1);
   BEGIN
      FOR c IN (SELECT '1' DATA
                  FROM giis_principal_res a,
                       giis_prin_signtry b,
                       giis_cosignor_res c
                 WHERE a.principal_res_no = p_res_cert
                    OR b.res_cert = p_res_cert
                    OR c.cosign_res_no = p_res_cert)
      LOOP
         v_dummy := c.DATA;

         IF v_dummy IS NOT NULL
         THEN
            v_exist := 1;
         --msg_alert('CTC no. already exist in the database, it must be unique.','E',TRUE);
         END IF;
      END LOOP;

      RETURN v_exist;
   END;

   FUNCTION validate_ctc_no2 (
      p_id1         giis_prin_signtry.prin_id%TYPE,
      p_id2         giis_cosignor_res.cosign_id%TYPE,
      p_res_cert1   giis_prin_signtry.res_cert%TYPE,
      p_res_cert2   giis_cosignor_res.cosign_res_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_exist   VARCHAR2 (1);
      v_dummy   VARCHAR2 (15 BYTE);
   BEGIN
      v_exist := 0;

      IF p_id1 <> 0
      THEN
         FOR c IN (SELECT res_cert DATA
                     FROM giis_prin_signtry
                    WHERE prin_id <> p_id1)
         LOOP
            v_dummy := c.DATA;

            IF v_dummy = p_res_cert1
            THEN
               v_exist := 1;
            END IF;
         END LOOP;
      END IF;

      IF p_id2 <> 0
      THEN
         FOR d IN (SELECT cosign_res_no DATA
                     FROM giis_cosignor_res
                    WHERE cosign_id <> p_id2)
         LOOP
            v_dummy := d.DATA;

            IF v_dummy = p_res_cert2
            THEN
               v_exist := 1;
            END IF;
         END LOOP;
      END IF;

      RETURN v_exist;
   END;

   PROCEDURE set_principal_signatory (
      p_prin_signor       giis_prin_signtry.prin_signor%TYPE,
      p_designation       giis_prin_signtry.designation%TYPE,
      p_prin_id           giis_prin_signtry.prin_id%TYPE,
      p_res_cert          giis_prin_signtry.res_cert%TYPE,
      p_issue_place       giis_prin_signtry.issue_place%TYPE,
      p_issue_date        VARCHAR2,        --giis_prin_signtry.issue_date%TYPE
      p_user_id           giis_prin_signtry.user_id%TYPE,
      p_remarks           giis_prin_signtry.remarks%TYPE,
      p_address           giis_prin_signtry.address%TYPE,
      p_assd_no           giis_prin_signtry.assd_no%TYPE,
      p_control_type_cd   giis_prin_signtry.control_type_cd%TYPE,
      p_bond_sw           giis_prin_signtry.bond_sw%TYPE,
      p_indem_sw          giis_prin_signtry.indem_sw%TYPE,
      p_ack_sw            giis_prin_signtry.ack_sw%TYPE,
      p_cert_sw           giis_prin_signtry.cert_sw%TYPE,
      p_ri_sw             giis_prin_signtry.ri_sw%TYPE
   )
   IS
      v_prin_signor_exists   VARCHAR (1) := 0;
      v_prin_id_exists       VARCHAR (1);
   BEGIN
      BEGIN
         SELECT 1
           INTO v_prin_id_exists
           FROM giis_prin_signtry
          WHERE prin_id = p_prin_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_prin_id_exists := 0;
      END;

--remove by steven 05.29.2014
--      SELECT COUNT (*)
--        INTO v_prin_signor_exists
--        FROM giis_prin_signtry
--       WHERE assd_no = p_assd_no AND prin_signor = p_prin_signor;
      IF v_prin_id_exists = 0
      THEN
         IF v_prin_signor_exists = 0
         THEN
            INSERT INTO giis_prin_signtry
                        (prin_id, prin_signor,
                         designation, res_cert, issue_place,
                         issue_date, user_id, remarks, address,
                         last_update, assd_no, control_type_cd, bond_sw,
                         indem_sw, ack_sw, cert_sw, ri_sw
                        )
                 VALUES (prin_signtry_prin_id_s.NEXTVAL, p_prin_signor,
                         p_designation, p_res_cert, p_issue_place,
                         p_issue_date, p_user_id, p_remarks, p_address,
                         SYSDATE, p_assd_no, p_control_type_cd, p_bond_sw,
                         p_indem_sw, p_ack_sw, p_cert_sw, p_ri_sw
                        );
         END IF;
      ELSE
         FOR i IN (SELECT *
                     FROM giis_prin_signtry
                    WHERE prin_id = p_prin_id)
         LOOP
            IF i.prin_id = p_prin_id
            THEN
               IF i.prin_signor = p_prin_signor
               THEN
                  UPDATE giis_prin_signtry
                     SET prin_signor = p_prin_signor,
                         designation = p_designation,
                         res_cert = p_res_cert,
                         issue_place = p_issue_place,
                         issue_date = p_issue_date,
                         user_id = p_user_id,
                         remarks = p_remarks,
                         address = p_address,
                         last_update = SYSDATE,
                         control_type_cd = p_control_type_cd,
                         bond_sw = p_bond_sw,
                         indem_sw = p_indem_sw,
                         ack_sw = p_ack_sw,
                         cert_sw = p_cert_sw,
                         ri_sw = p_ri_sw
                   WHERE prin_id = p_prin_id;
               ELSE
                  IF v_prin_signor_exists = 0
                  THEN
                     UPDATE giis_prin_signtry
                        SET prin_signor = p_prin_signor,
                            designation = p_designation,
                            res_cert = p_res_cert,
                            issue_place = p_issue_place,
                            issue_date = p_issue_date,
                            user_id = p_user_id,
                            remarks = p_remarks,
                            address = p_address,
                            last_update = SYSDATE,
                            control_type_cd = p_control_type_cd,
                            bond_sw = p_bond_sw,
                            indem_sw = p_indem_sw,
                            ack_sw = p_ack_sw,
                            cert_sw = p_cert_sw,
                            ri_sw = p_ri_sw
                      WHERE prin_id = p_prin_id;
                  END IF;
               END IF;
            END IF;
         END LOOP;
      END IF;
   END;

   --added by steven 02.26.2014
   FUNCTION get_control_type_lov (p_keyword VARCHAR2)
      RETURN control_type_list_tab PIPELINED
   IS
      v_rec   control_type_list_type;
   BEGIN
      FOR i IN (SELECT   control_type_cd, control_type_desc
                    FROM giis_control_type
                   WHERE (   control_type_cd LIKE NVL (p_keyword, '%')
                          OR UPPER (control_type_desc) LIKE
                                                  UPPER (NVL (p_keyword, '%'))
                         )
                ORDER BY control_type_desc)
      LOOP
         v_rec.control_type_cd := i.control_type_cd;
         v_rec.control_type_desc := i.control_type_desc;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_assured (p_assd_no giis_assured.assd_no%TYPE)
      RETURN assured_names_list_tab PIPELINED
   IS
      v_rec   assured_names_list_type;
      v_def_control_type_cd      giis_parameters.param_value_n%TYPE := giisp.n ('DEFAULT_CTC_NO');
   BEGIN
      v_rec.def_control_type_cd := NULL;
      v_rec.def_control_type_desc := NULL;
      
      FOR j IN (SELECT control_type_desc
                  FROM giis_control_type
                 WHERE control_type_cd = v_def_control_type_cd)
      LOOP
         v_rec.def_control_type_cd := v_def_control_type_cd;
         v_rec.def_control_type_desc := j.control_type_desc;
         EXIT;
      END LOOP;
      
      FOR i IN (SELECT   a.assd_name, a.assd_no, a.mail_addr1, a.mail_addr2,
                         a.control_type_cd, a.mail_addr3, a.designation,
                         a.active_tag, a.user_id, a.industry_cd
                    FROM giis_assured a
                   WHERE NVL (a.active_tag, 'N') = 'Y'
                     AND a.assd_no = NVL (p_assd_no, a.assd_no)
                ORDER BY UPPER (a.assd_name) ASC)
      LOOP
         v_rec.assd_name := i.assd_name;
         v_rec.assd_no := i.assd_no;
         v_rec.mail_addr1 := i.mail_addr1;
         v_rec.mail_addr2 := i.mail_addr2;
         v_rec.mail_addr3 := i.mail_addr3;
         v_rec.designation := i.designation;
         v_rec.active_tag := i.active_tag;
         v_rec.user_id := i.user_id;
         v_rec.industry_cd := i.industry_cd;
         v_rec.control_type_desc := NULL;
         v_rec.control_type_cd := NULL;
         v_rec.principal_res_no := NULL;
         v_rec.principal_res_date := NULL;
         v_rec.principal_res_place := NULL;

         FOR j IN (SELECT m.principal_res_no, m.principal_res_date,
                          m.principal_res_place, m.control_type_cd, n.control_type_desc
                     FROM giis_principal_res m,
                          giis_control_type n
                    WHERE m.assd_no = i.assd_no
                      AND m.control_type_cd = n.control_type_cd)
         LOOP
            v_rec.control_type_desc := j.control_type_desc;
            v_rec.control_type_cd := j.control_type_cd;
            v_rec.principal_res_no := j.principal_res_no;
            v_rec.principal_res_date :=
                                  TO_CHAR (j.principal_res_date, 'MM-DD-YYYY');
            v_rec.principal_res_place := j.principal_res_place;
         END LOOP;
         
         PIPE ROW (v_rec);
      END LOOP;
   END;
END giis_prin_signtry_pkg;
/


