CREATE OR REPLACE PACKAGE BODY CPI.giis_cosignor_res_pkg
AS
   FUNCTION get_cosignor_list (p_assd_no giis_cosignor_res.assd_no%TYPE)
      RETURN cosignor_res_tab PIPELINED
   IS
      v_cos   cosignor_res_type;
   BEGIN
      FOR i IN (SELECT   cosign_name, designation, cosign_id, assd_no
                    FROM giis_cosignor_res
                   WHERE assd_no = p_assd_no
                ORDER BY cosign_name)
      LOOP
         v_cos.cosign_name := i.cosign_name;
         v_cos.designation := i.designation;
         v_cos.cosign_id := i.cosign_id;
         v_cos.assd_no := i.assd_no;
         PIPE ROW (v_cos);
      END LOOP;

      RETURN;
   END get_cosignor_list;

   FUNCTION get_cosignor_res (p_assd_no giis_cosignor_res.assd_no%TYPE)
      RETURN cosignor_res_tab2 PIPELINED
   IS
      v_cosign   cosignor_res_type2;
   BEGIN
      FOR a IN (SELECT   cosign_name, cosign_id, designation, cosign_res_no,
                         cosign_res_place, a.control_type_cd, b.control_type_desc,
                         TO_CHAR (cosign_res_date,
                                  'MM-DD-YYYY'
                                 ) cosign_res_date,
                         a.user_id, TO_CHAR (a.last_update,
                                  'MM-DD-YYYY HH:MI:SS AM'
                                 ) last_update,
                         a.remarks, address
                    FROM giis_cosignor_res a, giis_control_type b
                   WHERE assd_no = p_assd_no
                     AND a.control_type_cd = b.control_type_cd(+)
                ORDER BY cosign_id,
                         assd_no,
                         cosign_name,
                         designation,
                         cosign_res_no,
                         cosign_res_place,
                         cosign_res_date)
      LOOP
         v_cosign.cosign_name       := a.cosign_name;
         v_cosign.designation       := a.designation;
         v_cosign.cosign_id         := a.cosign_id;
         v_cosign.cosign_res_no     := a.cosign_res_no;
         v_cosign.cosign_res_place  := a.cosign_res_place;
         v_cosign.cosign_res_date   := a.cosign_res_date;
         v_cosign.user_id           := a.user_id;
         v_cosign.last_update       := a.last_update;
         v_cosign.remarks           := a.remarks;
         v_cosign.address           := a.address;
        v_cosign.control_type_cd    := a.control_type_cd;
         v_cosign.control_type_desc := a.control_type_desc;
         PIPE ROW (v_cosign);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_cosignor (
      p_cosign_name        giis_cosignor_res.cosign_name%TYPE,
      p_designation        giis_cosignor_res.designation%TYPE,
      p_cosign_id          giis_cosignor_res.cosign_id%TYPE,
      p_cosign_res_no      giis_cosignor_res.cosign_res_no%TYPE,
      p_cosign_res_place   giis_cosignor_res.cosign_res_place%TYPE,
      p_cosign_res_date    VARCHAR2,       --giis_prin_signtry.issue_date%TYPE
      p_user_id            giis_cosignor_res.user_id%TYPE,
      p_remarks            giis_cosignor_res.remarks%TYPE,
      p_address            giis_cosignor_res.address%TYPE,
      p_assd_no            giis_prin_signtry.assd_no%TYPE,
      p_control_type_cd    giis_cosignor_res.control_type_cd%TYPE
   )
   IS
        v_cosign_id_exists  VARCHAR(1);
        v_cosign_name_exists    VARCHAR(1);
   BEGIN
   
      BEGIN
        SELECT 1
          INTO v_cosign_id_exists
          FROM giis_cosignor_res
         WHERE cosign_id = p_cosign_id;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_cosign_id_exists := 0;
      END;
   
      SELECT COUNT(*)
        INTO v_cosign_name_exists
        FROM giis_cosignor_res
       WHERE assd_no = p_assd_no
         AND cosign_name = p_cosign_name;
       
      IF v_cosign_id_exists = 0  THEN
        IF v_cosign_name_exists = 0 THEN
            INSERT INTO giis_cosignor_res(cosign_id, cosign_name, designation, cosign_res_no,
                    cosign_res_place, cosign_res_date, user_id, remarks,
                    address, last_update, assd_no, control_type_cd)
            VALUES (cosignor_res_cosign_id_seq.NEXTVAL, p_cosign_name, p_designation,
                    p_cosign_res_no, p_cosign_res_place, p_cosign_res_date,
                    p_user_id, p_remarks, p_address, SYSDATE, p_assd_no, p_control_type_cd);
        END IF;
      ELSE 
        FOR i IN (SELECT *
                    FROM giis_cosignor_res
                   WHERE cosign_id = p_cosign_id)
        LOOP
            IF i.cosign_id = p_cosign_id THEN
                IF i.cosign_name = p_cosign_name THEN
                     UPDATE giis_cosignor_res
               SET cosign_name      = p_cosign_name, 
                   designation      = p_designation,
                   cosign_res_no    = p_cosign_res_no,
                   cosign_res_place = p_cosign_res_place,
                   cosign_res_date  = p_cosign_res_date,
                   user_id          = p_user_id,
                   remarks          = p_remarks,
                   address          = p_address,
                   last_update      = SYSDATE,
                   control_type_cd  = p_control_type_cd
                      WHERE cosign_id = p_cosign_id;
                ELSE
                    IF v_cosign_name_exists = 0 THEN
                        UPDATE giis_cosignor_res
                           SET cosign_name      = p_cosign_name, 
                               designation      = p_designation,
                               cosign_res_no    = p_cosign_res_no,
                               cosign_res_place = p_cosign_res_place,
                               cosign_res_date  = p_cosign_res_date,
                               user_id          = p_user_id,
                               remarks          = p_remarks,
                               address          = p_address,
                               last_update      = SYSDATE,
                               control_type_cd  = p_control_type_cd
                         WHERE cosign_id = p_cosign_id;
                    END IF;
                END IF;
            END IF;
        END LOOP;                    
      END IF;
   END;
END giis_cosignor_res_pkg;
/** Modified code to prevent saving the same Co-Signatory names. Halley 09.30.2013 **/
/


