CREATE OR REPLACE PACKAGE BODY CPI.giuts029_pkg
AS
   PROCEDURE new_form_instance (
      p_allowed_media_type      OUT   giis_parameters.param_value_v%TYPE,
      p_allowed_size_per_file   OUT   giis_parameters.param_value_n%TYPE,
      p_allowed_size_per_item   OUT   giis_parameters.param_value_n%TYPE
   )
   AS
   BEGIN
      FOR i IN (SELECT rv_low_value
                  FROM cg_ref_codes
                 WHERE rv_domain = 'GICL_PICTURES.FILE_EXT')
      LOOP
         p_allowed_media_type :=
                               p_allowed_media_type || i.rv_low_value || ', ';
      END LOOP;
   END;

   FUNCTION get_giuts029_pol_lov (
      p_user_id       giis_users.user_id%TYPE,
      p_line_cd       gipi_polbasic.line_cd%TYPE,
      p_subline_cd    gipi_polbasic.subline_cd%TYPE,
      p_iss_cd        gipi_polbasic.iss_cd%TYPE,
      p_issue_yy      gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no      gipi_polbasic.renew_no%TYPE,
      p_endt_iss_cd   gipi_polbasic.endt_iss_cd%TYPE,
      p_endt_yy       gipi_polbasic.endt_yy%TYPE,
      p_endt_seq_no   gipi_polbasic.endt_seq_no%TYPE
   )
      RETURN pol_tab PIPELINED
   AS
      v_rec   pol_type;
   BEGIN
      FOR i IN (SELECT a.policy_id, b.assd_name, line_cd, subline_cd, iss_cd,
                       issue_yy, pol_seq_no, renew_no, endt_iss_cd, endt_yy,
                       endt_seq_no
                  FROM gipi_polbasic a, giis_assured b
                 WHERE a.assd_no = b.assd_no
                   AND pol_flag NOT IN ('4', '5')
                   AND subline_cd IN (SELECT subline_cd
                                        FROM giis_subline
                                       WHERE op_flag = 'N')
                   AND line_cd = p_line_cd
                   AND subline_cd = NVL (p_subline_cd, subline_cd)
                   AND iss_cd = NVL (p_iss_cd, iss_cd)
                   AND issue_yy = NVL (p_issue_yy, issue_yy)
                   AND pol_seq_no = NVL (p_pol_seq_no, pol_seq_no)
                   AND renew_no = NVL (p_renew_no, renew_no)
                   AND endt_iss_cd = NVL (p_endt_iss_cd, endt_iss_cd)
                   AND endt_yy = NVL (p_endt_yy, endt_yy)
                   AND endt_seq_no = NVL (p_endt_seq_no, endt_seq_no)
                   AND check_user_per_iss_cd2 (a.line_cd,
                                               a.iss_cd,
                                               'GIUTS029',
                                               p_user_id
                                              ) = 1)
      LOOP
         v_rec.policy_id := i.policy_id;
         v_rec.line_cd := i.line_cd;
         v_rec.subline_cd := i.subline_cd;
         v_rec.iss_cd := i.iss_cd;
         v_rec.issue_yy := i.issue_yy;
         v_rec.pol_seq_no := TO_CHAR (i.pol_seq_no, '0999999');
         v_rec.renew_no := TO_CHAR (i.renew_no, '09');

         IF i.endt_seq_no <> 0
         THEN
            v_rec.endt_iss_cd := i.endt_iss_cd;
            v_rec.endt_yy := i.endt_yy;
            v_rec.endt_seq_no := i.endt_seq_no;
         ELSE
            v_rec.endt_iss_cd := NULL;
            v_rec.endt_yy := NULL;
            v_rec.endt_seq_no := NULL;
         END IF;

         v_rec.policy_no := get_policy_no (i.policy_id);
         v_rec.assd_name := i.assd_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_items (
      p_policy_id    gipi_item.policy_id%TYPE,
      p_item_no      gipi_item.item_no%TYPE,
      p_item_title   gipi_item.item_title%TYPE
   )
      RETURN item_tab PIPELINED
   AS
      v_rec   item_type;
   BEGIN
      FOR i IN (SELECT item_no, item_title, item_desc, item_desc2
                  FROM gipi_item
                 WHERE policy_id = p_policy_id
                   AND item_no = NVL (p_item_no, item_no)
                   AND item_title LIKE NVL (p_item_title, '%'))
      LOOP
         v_rec.item_no := i.item_no;
         v_rec.item_title := i.item_title;
         v_rec.item_desc := i.item_desc;
         v_rec.item_desc2 := i.item_desc2;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_attachments (
      p_policy_id   gipi_item.policy_id%TYPE,
      p_item_no     gipi_item.item_no%TYPE
   )
      RETURN attachment_tab PIPELINED
   AS
      v_rec   attachment_type;
   BEGIN
      FOR i IN (SELECT policy_id, item_no, file_name, remarks
                  FROM gipi_pictures
                 WHERE policy_id = p_policy_id AND item_no = p_item_no)
      LOOP
         v_rec.policy_id := i.policy_id;
         v_rec.item_no := i.item_no;
         v_rec.file_name := i.file_name;
         v_rec.file_name2 :=
            SUBSTR (i.file_name,
                    INSTR (i.file_name, '/', -1) + 1,
                    LENGTH (i.file_name)
                   );
         v_rec.remarks := i.remarks;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_attachment_list(
       p_policy_id     gipi_item.policy_id%TYPE,
       p_item_no       gipi_item.item_no%TYPE
   )
     RETURN attachment_list_tab PIPELINED
   AS
     v_rec  attachment_list_type;
   BEGIN
     FOR i IN (SELECT policy_id, item_no, file_name
                 FROM gipi_pictures
                WHERE policy_id = p_policy_id AND item_no = p_item_no)
     LOOP
        v_rec.policy_id := i.policy_id;
        v_rec.item_no := i.item_no;
        v_rec.file_name := i.file_name;
        
        PIPE ROW (v_rec);
     END LOOP;
   END;

   PROCEDURE set_attachments (
      p_policy_id   gipi_pictures.policy_id%TYPE,
      p_item_no     gipi_pictures.item_no%TYPE,
      p_file_name   gipi_pictures.file_name%TYPE,
      p_remarks     gipi_pictures.remarks%TYPE
   )
   IS
      v_file_ext    VARCHAR2 (5);
      v_file_type   cg_ref_codes.rv_high_value%TYPE;
   BEGIN
      SELECT SUBSTR (p_file_name,
                     INSTR (p_file_name, '.', -1),
                     LENGTH (p_file_name)
                    )
        INTO v_file_ext
        FROM DUAL;

      --added by steven 08.04.2014 - base on the test case
      FOR i IN (SELECT rv_high_value
                  FROM cg_ref_codes
                 WHERE rv_domain = 'GICL_PICTURES.FILE_EXT'
                   AND UPPER (rv_low_value) = UPPER (v_file_ext))
      LOOP
         v_file_type := i.rv_high_value;
         EXIT;
      END LOOP;

      MERGE INTO gipi_pictures
         USING DUAL
         ON (    policy_id = p_policy_id
             AND item_no = p_item_no
             AND file_name = p_file_name)
         WHEN NOT MATCHED THEN
            INSERT (policy_id, item_no, file_name, remarks, file_type,
                    file_ext, create_user, create_date)
            VALUES (p_policy_id, p_item_no, p_file_name, p_remarks,
                    NVL (v_file_type, 'P'), v_file_ext,
                    giis_users_pkg.app_user, SYSDATE)
                                                                  --added by steven 07.30.2014
         -- hardcoded file type, differenct approach in viewing files with geniisys web
      WHEN MATCHED THEN
            UPDATE
               SET remarks = p_remarks
            ;
   END;

   PROCEDURE del_attachments (
      p_policy_id   gipi_pictures.policy_id%TYPE,
      p_item_no     gipi_pictures.item_no%TYPE,
      p_file_name   gipi_pictures.file_name%TYPE
   )
   IS
   BEGIN
      DELETE FROM gipi_pictures
            WHERE policy_id = p_policy_id
              AND item_no = p_item_no
              AND file_name = p_file_name;
   END;

   PROCEDURE val_add_rec (
      p_policy_id   gipi_pictures.policy_id%TYPE,
      p_item_no     gipi_pictures.item_no%TYPE,
      p_file_name   gipi_pictures.file_name%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM gipi_pictures
                 WHERE policy_id = p_policy_id
                   AND item_no = p_item_no
                   AND file_name = p_file_name)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same file_name.'
            );
      END IF;
   END;
END;
/


