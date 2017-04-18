CREATE OR REPLACE PACKAGE BODY CPI.gipi_coc_auth_pkg
AS
   FUNCTION get_coc_authentication (
      p_user_id   giis_users.user_id%TYPE,
      p_par_id    gipi_polbasic.par_id%TYPE,
      p_use_default_tin VARCHAR2
   )
      RETURN gipi_coc_auth_tab PIPELINED
   IS
      v_coc_auth     gipi_coc_auth_type;
      v_default_tin  giis_parameters.param_value_v%TYPE;
   BEGIN
      IF p_use_default_tin = 'Y'
      THEN
        SELECT GIISP.V('DEFAULT_COCAF_ASSD_TIN') 
          INTO v_default_tin
          FROM DUAL;
      END IF;
   
      FOR i IN (SELECT pol.policy_id, usr.cocaf_user, usr.cocaf_pwd,
                       itm.item_no, veh.reg_type,
                       giisp.v('COC_COMPANY_CODE') || veh.coc_serial_no coc_no,
                       veh.plate_no, veh.mv_file_no, veh.motor_no,
                       veh.serial_no,
                       TO_CHAR (pol.incept_date, 'MM/DD/YYYY') incept_date,
                       TO_CHAR (pol.expiry_date, 'MM/DD/YYYY') expiry_date,
                       veh.mv_type, veh.mv_prem_type, veh.tax_type,
                       asd.assd_name, asd.assd_tin
                  FROM gipi_polbasic pol,
                       giis_assured asd,
                       gipi_item itm,
                       gipi_itmperil prl,
                       gipi_vehicle veh,
                       giis_cocaf_users usr
                 WHERE pol.assd_no = asd.assd_no
                   AND pol.policy_id = itm.policy_id
                   AND itm.policy_id = prl.policy_id
                   AND itm.item_no = prl.item_no
                   AND veh.item_no = prl.item_no
                   AND veh.policy_id = prl.policy_id
                   AND NVL (prl.rec_flag, 'A') = 'A'                   
                   AND prl.peril_cd = giisp.n ('CTPL')
                   AND pol.par_id = p_par_id
                   AND usr.user_id = p_user_id)
      LOOP
         v_coc_auth.policy_id := i.policy_id;
         v_coc_auth.cocaf_user := i.cocaf_user;
         v_coc_auth.cocaf_pwd := i.cocaf_pwd;
         v_coc_auth.item_no := i.item_no;
         v_coc_auth.reg_type := i.reg_type;
         v_coc_auth.coc_no := i.coc_no;
         v_coc_auth.plate_no := i.plate_no;
         v_coc_auth.mv_file_no := i.mv_file_no;
         v_coc_auth.motor_no := i.motor_no;
         v_coc_auth.serial_no := i.serial_no;
         v_coc_auth.incept_date := i.incept_date;
         v_coc_auth.expiry_date := i.expiry_date;
         v_coc_auth.mv_type := i.mv_type;
         v_coc_auth.mv_prem_type := i.mv_prem_type;
         v_coc_auth.tax_type := i.tax_type;
         v_coc_auth.assd_name := i.assd_name;
         
         IF i.assd_tin IS NULL AND p_use_default_tin = 'Y'
         THEN
            v_coc_auth.assd_tin := v_default_tin;
         ELSE
            v_coc_auth.assd_tin := i.assd_tin;
         END IF;
         
         PIPE ROW (v_coc_auth);
      END LOOP;

      RETURN;
   END get_coc_authentication;

   FUNCTION get_pack_coc_authentication (
      p_user_id       giis_users.user_id%TYPE,
      p_pack_par_id   gipi_pack_parlist.pack_par_id%TYPE,
      p_use_default_tin VARCHAR2
   )
      RETURN gipi_coc_auth_tab PIPELINED
   IS
      v_coc_auth   gipi_coc_auth_type;
      v_default_tin  giis_parameters.param_value_v%TYPE;
   BEGIN
      IF p_use_default_tin = 'Y'
      THEN
        SELECT GIISP.V('DEFAULT_COCAF_ASSD_TIN') 
          INTO v_default_tin
          FROM DUAL;
      END IF;   
   
      BEGIN
         FOR i IN
            (SELECT pol.policy_id, usr.cocaf_user, usr.cocaf_pwd,
                    itm.item_no, veh.reg_type,
					giisp.v('COC_COMPANY_CODE') || veh.coc_serial_no coc_no,
                    veh.plate_no, veh.mv_file_no, veh.motor_no,
                    veh.serial_no,
                    TO_CHAR (pol.incept_date, 'MM/DD/YYYY') incept_date,
                    TO_CHAR (pol.expiry_date, 'MM/DD/YYYY') expiry_date,
                    veh.mv_type, veh.mv_prem_type, veh.tax_type,
                    asd.assd_name, asd.assd_tin
               FROM gipi_polbasic pol,
                    giis_assured asd,
                    gipi_item itm,
                    gipi_itmperil prl,
                    gipi_vehicle veh,
                    giis_cocaf_users usr
              WHERE pol.assd_no = asd.assd_no
                AND pol.policy_id = itm.policy_id
                AND itm.policy_id = prl.policy_id
                AND itm.item_no = prl.item_no
                AND veh.item_no = prl.item_no
                AND veh.policy_id = prl.policy_id
                AND NVL (prl.rec_flag, 'A') = 'A'
                AND prl.peril_cd = giisp.n ('CTPL')
                AND pol.policy_id IN (
                       SELECT b.policy_id
                         FROM gipi_pack_polbasic a, gipi_polbasic b
                        WHERE a.pack_par_id = p_pack_par_id
                          AND a.pack_policy_id = b.pack_policy_id
                          AND giis_line_pkg.get_menu_line_cd (b.line_cd) = 'MC'
                          AND gipi_parlist_pkg.get_pack_par_status (p_pack_par_id) NOT IN (98, 99))
                AND usr.user_id = p_user_id)
         LOOP
            v_coc_auth.policy_id := i.policy_id;
            v_coc_auth.cocaf_user := i.cocaf_user;
            v_coc_auth.cocaf_pwd := i.cocaf_pwd;
            v_coc_auth.item_no := i.item_no;
            v_coc_auth.reg_type := i.reg_type;
            v_coc_auth.coc_no := i.coc_no;
            v_coc_auth.plate_no := i.plate_no;
            v_coc_auth.mv_file_no := i.mv_file_no;
            v_coc_auth.motor_no := i.motor_no;
            v_coc_auth.serial_no := i.serial_no;
            v_coc_auth.incept_date := i.incept_date;
            v_coc_auth.expiry_date := i.expiry_date;
            v_coc_auth.mv_type := i.mv_type;
            v_coc_auth.mv_prem_type := i.mv_prem_type;
            v_coc_auth.tax_type := i.tax_type;
            v_coc_auth.assd_name := i.assd_name;
         
             IF i.assd_tin IS NULL AND p_use_default_tin = 'Y'
             THEN
                v_coc_auth.assd_tin := v_default_tin;
             ELSE
                v_coc_auth.assd_tin := i.assd_tin;
             END IF;
         
            PIPE ROW (v_coc_auth);
         END LOOP;
      END;
   END get_pack_coc_authentication;

   PROCEDURE set_coc_authentication (
      p_auth_no        gipi_coc_auth.auth_no%TYPE,
      p_cocaf_user     gipi_coc_auth.cocaf_user%TYPE,
      p_coc_no         gipi_coc_auth.coc_no%TYPE,
      p_err_msg        gipi_coc_auth.err_msg%TYPE,
      p_item_no        gipi_coc_auth.item_no%TYPE,
      p_policy_id      gipi_coc_auth.policy_id%TYPE,
      p_reg_date       gipi_coc_auth.reg_date%TYPE,
      p_last_user_id   gipi_coc_auth.last_user_id%TYPE
   )
   IS
   BEGIN
      MERGE INTO gipi_coc_auth
         USING DUAL
         ON (coc_no = p_coc_no)
         WHEN NOT MATCHED THEN
            INSERT (auth_no, cocaf_user, coc_no, err_msg, item_no,
                    last_update, last_user_id, policy_id, reg_date)
            VALUES (p_auth_no, p_cocaf_user, p_coc_no, p_err_msg, p_item_no,
                    SYSDATE, p_last_user_id, p_policy_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET auth_no = p_auth_no, cocaf_user = p_cocaf_user,
                   err_msg = p_err_msg, item_no = p_item_no,
                   last_update = SYSDATE, last_user_id = p_last_user_id,
                   policy_id = p_policy_id, reg_date = SYSDATE
            ;

     IF p_auth_no IS NOT NULL
     THEN
       UPDATE GIPI_VEHICLE
          SET coc_atcn = p_auth_no
        WHERE policy_id = p_policy_id
          AND item_no = p_item_no;          
     END IF;
     
   END set_coc_authentication;
END gipi_coc_auth_pkg;
/