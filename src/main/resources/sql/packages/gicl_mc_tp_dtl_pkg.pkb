CREATE OR REPLACE PACKAGE BODY CPI.gicl_mc_tp_dtl_pkg
AS
   PROCEDURE save_gicl_mc_tp_dtl (
      p_claim_id             gicl_mc_tp_dtl.claim_id%TYPE,
      p_item_no              gicl_mc_tp_dtl.item_no%TYPE,
      p_payee_class_cd       gicl_mc_tp_dtl.payee_class_cd%TYPE,
      p_payee_no             gicl_mc_tp_dtl.payee_no%TYPE,
      p_tp_type              gicl_mc_tp_dtl.tp_type%TYPE,
      p_plate_no             gicl_mc_tp_dtl.plate_no%TYPE,
      p_model_year           gicl_mc_tp_dtl.model_year%TYPE,
      p_serial_no            gicl_mc_tp_dtl.serial_no%TYPE,
      p_motor_no             gicl_mc_tp_dtl.motor_no%TYPE,
      p_mot_type             gicl_mc_tp_dtl.mot_type%TYPE,
      p_motorcar_comp_cd     gicl_mc_tp_dtl.motorcar_comp_cd%TYPE,
      p_make_cd              gicl_mc_tp_dtl.make_cd%TYPE,
      p_series_cd            gicl_mc_tp_dtl.series_cd%TYPE,
      p_basic_color_cd       gicl_mc_tp_dtl.basic_color_cd%TYPE,
      p_color_cd             gicl_mc_tp_dtl.color_cd%TYPE,
      p_drvr_occ_cd          gicl_mc_tp_dtl.drvr_occ_cd%TYPE,
      p_drvr_name            gicl_mc_tp_dtl.drvr_name%TYPE,
      p_drvr_sex             gicl_mc_tp_dtl.drvr_sex%TYPE,
      p_drvr_age             gicl_mc_tp_dtl.drvr_age%TYPE,
      p_other_info           gicl_mc_tp_dtl.other_info%TYPE,
      p_user_id              gicl_mc_tp_dtl.user_id%TYPE,
      p_ri_cd                gicl_mc_tp_dtl.ri_cd%TYPE,
      p_drvr_add             gicl_mc_tp_dtl.drvr_add%TYPE,
      p_drvng_exp            gicl_mc_tp_dtl.drvng_exp%TYPE,
      p_nationality_cd       gicl_mc_tp_dtl.nationality_cd%TYPE,
      p_new_payee_class_cd   VARCHAR2,
      p_new_payee_no         NUMBER
   )
   IS
   BEGIN
      INSERT INTO gicl_mc_tp_dtl
                  (claim_id, item_no, payee_class_cd, payee_no,
                   tp_type, plate_no, model_year, serial_no,
                   motor_no, mot_type, motorcar_comp_cd, make_cd,
                   series_cd, basic_color_cd, color_cd, drvr_occ_cd,
                   drvr_name, drvr_sex, drvr_age, other_info,
                   user_id, ri_cd, drvr_add, drvng_exp,
                   nationality_cd
                  )
           VALUES (p_claim_id, p_item_no, p_payee_class_cd, p_payee_no,
                   p_tp_type, p_plate_no, p_model_year, p_serial_no,
                   p_motor_no, p_mot_type, p_motorcar_comp_cd, p_make_cd,
                   p_series_cd, p_basic_color_cd, p_color_cd, p_drvr_occ_cd,
                   p_drvr_name, p_drvr_sex, p_drvr_age, p_other_info,
                   p_user_id, p_ri_cd, p_drvr_add, p_drvng_exp,
                   p_nationality_cd
                  );
   END;

   PROCEDURE update_gicl_mc_tp_dtl (
      p_claim_id             gicl_mc_tp_dtl.claim_id%TYPE,
      p_item_no              gicl_mc_tp_dtl.item_no%TYPE,
      p_payee_class_cd       gicl_mc_tp_dtl.payee_class_cd%TYPE,
      p_payee_no             gicl_mc_tp_dtl.payee_no%TYPE,
      p_tp_type              gicl_mc_tp_dtl.tp_type%TYPE,
      p_plate_no             gicl_mc_tp_dtl.plate_no%TYPE,
      p_model_year           gicl_mc_tp_dtl.model_year%TYPE,
      p_serial_no            gicl_mc_tp_dtl.serial_no%TYPE,
      p_motor_no             gicl_mc_tp_dtl.motor_no%TYPE,
      p_mot_type             gicl_mc_tp_dtl.mot_type%TYPE,
      p_motorcar_comp_cd     gicl_mc_tp_dtl.motorcar_comp_cd%TYPE,
      p_make_cd              gicl_mc_tp_dtl.make_cd%TYPE,
      p_series_cd            gicl_mc_tp_dtl.series_cd%TYPE,
      p_basic_color_cd       gicl_mc_tp_dtl.basic_color_cd%TYPE,
      p_color_cd             gicl_mc_tp_dtl.color_cd%TYPE,
      p_drvr_occ_cd          gicl_mc_tp_dtl.drvr_occ_cd%TYPE,
      p_drvr_name            gicl_mc_tp_dtl.drvr_name%TYPE,
      p_drvr_sex             gicl_mc_tp_dtl.drvr_sex%TYPE,
      p_drvr_age             gicl_mc_tp_dtl.drvr_age%TYPE,
      p_other_info           gicl_mc_tp_dtl.other_info%TYPE,
      p_user_id              gicl_mc_tp_dtl.user_id%TYPE,
      p_ri_cd                gicl_mc_tp_dtl.ri_cd%TYPE,
      p_drvr_add             gicl_mc_tp_dtl.drvr_add%TYPE,
      p_drvng_exp            gicl_mc_tp_dtl.drvng_exp%TYPE,
      p_nationality_cd       gicl_mc_tp_dtl.nationality_cd%TYPE,
      p_new_payee_class_cd   VARCHAR2,
      p_new_payee_no         NUMBER
   )
   IS
   BEGIN
      UPDATE gicl_mc_tp_dtl
         SET payee_class_cd = p_new_payee_class_cd,
             payee_no = p_new_payee_no,
             tp_type = p_tp_type,
             plate_no = p_plate_no,
             model_year = p_model_year,
             serial_no = p_serial_no,
             motor_no = p_motor_no,
             mot_type = p_mot_type,
             motorcar_comp_cd = p_motorcar_comp_cd,
             make_cd = p_make_cd,
             series_cd = p_series_cd,
             basic_color_cd = p_basic_color_cd,
             color_cd = p_color_cd,
             drvr_occ_cd = p_drvr_occ_cd,
             drvr_name = p_drvr_name,
             drvr_sex = p_drvr_sex,
             drvr_age = p_drvr_age,
             other_info = p_other_info,
             user_id = p_user_id,
             ri_cd = p_ri_cd,
             drvr_add = p_drvr_add,
             drvng_exp = p_drvng_exp,
             nationality_cd = p_nationality_cd
       WHERE claim_id = p_claim_id
         AND item_no = p_item_no
         AND payee_class_cd = p_payee_class_cd
         AND payee_no = p_payee_no;
   END;

   PROCEDURE del_gicl_mc_tp_dtl (
      p_claim_id         gicl_mc_tp_dtl.claim_id%TYPE,
      p_item_no          gicl_mc_tp_dtl.item_no%TYPE,
      p_payee_class_cd   gicl_mc_tp_dtl.payee_class_cd%TYPE,
      p_payee_no         gicl_mc_tp_dtl.payee_no%TYPE
   )
   IS
   BEGIN
      DELETE FROM gicl_mc_tp_dtl
            WHERE claim_id = p_claim_id
              AND item_no = p_item_no
              AND payee_class_cd = p_payee_class_cd
              AND p_payee_no = payee_no;
   END;

   FUNCTION get_gicl_mc_tp_dtl (
      p_claim_id     gicl_mc_tp_dtl.claim_id%TYPE,
      p_item_no      gicl_mc_tp_dtl.item_no%TYPE,
      --   p_payee_class_cd   gicl_mc_tp_dtl.payee_class_cd%TYPE,
       --  p_payee_no         gicl_mc_tp_dtl.payee_no%TYPE,
      p_subline_cd   gicl_claims.subline_cd%TYPE
   )
      RETURN gicl_mc_tp_dtl_tab PIPELINED
   IS
      v_dtl   gicl_mc_tp_dtl_type;
   BEGIN
      FOR i IN
         (SELECT a.claim_id, a.item_no, a.payee_class_cd, a.payee_no,
                 a.tp_type, a.plate_no, a.model_year, a.serial_no,
                 a.motor_no, a.mot_type, a.motorcar_comp_cd, a.make_cd,
                 a.series_cd, a.basic_color_cd, a.color_cd, a.drvr_occ_cd,
                 a.drvr_name, a.drvr_age, a.drvr_sex, a.other_info, a.ri_cd,
                 a.last_update, a.drvr_add, a.drvng_exp, a.nationality_cd,
                 a.user_id,
                 (SELECT class_desc
                    FROM giis_payee_class
                   WHERE payee_class_cd = a.payee_class_cd) class_desc,
                 (SELECT    payee_last_name
                         || DECODE (payee_first_name,
                                    NULL, NULL,
                                    ',' || payee_first_name
                                   )
                         || DECODE (payee_middle_name,
                                    NULL, NULL,
                                    '' || payee_middle_name || '.'
                                   ) payee_name
                    FROM giis_payees
                   WHERE payee_no = a.payee_no
                     AND payee_class_cd = a.payee_class_cd) payee_name,
                 (SELECT motor_type_desc
                    FROM giis_motortype
                   WHERE type_cd = a.mot_type
                     AND subline_cd = p_subline_cd) motor_type_desc,
                 (SELECT ri_name
                    FROM giis_reinsurer
                   WHERE ri_cd = a.ri_cd) ri_name,
                 (SELECT DISTINCT basic_color
                             FROM giis_mc_color
                            WHERE basic_color_cd = a.basic_color_cd
							  AND color_cd = a.color_cd) basic_color,
                 (SELECT color
                    FROM giis_mc_color
                   WHERE color_cd = a.color_cd
				   	 AND basic_color_cd =
                                                 a.basic_color_cd) color,
                 (SELECT car_company
                    FROM giis_mc_car_company
                   WHERE car_company_cd = a.motorcar_comp_cd) car_company,
                 (SELECT make
                    FROM giis_mc_make
                   WHERE make_cd = a.make_cd
                     AND car_company_cd = a.motorcar_comp_cd) make,
                 (SELECT engine_series
                    FROM giis_mc_eng_series
                   WHERE make_cd = v_dtl.make_cd
                     AND series_cd = v_dtl.series_cd
                     AND car_company_cd = a.motorcar_comp_cd) engine_series,
                 (SELECT occ_desc
                    FROM gicl_drvr_occptn
                   WHERE drvr_occ_cd = a.drvr_occ_cd) occ_desc,
                 (SELECT nationality_desc
                    FROM giis_nationality
                   WHERE nationality_cd = a.nationality_cd) nationality_desc
            FROM gicl_mc_tp_dtl a
           WHERE claim_id = p_claim_id AND item_no = p_item_no)
      LOOP
         v_dtl.claim_id := i.claim_id;
         v_dtl.item_no := i.item_no;
         v_dtl.payee_class_cd := i.payee_class_cd;
         v_dtl.payee_no := i.payee_no;
         v_dtl.tp_type := i.tp_type;
         v_dtl.plate_no := i.plate_no;
         v_dtl.model_year := i.model_year;
         v_dtl.serial_no := i.serial_no;
         v_dtl.motor_no := i.motor_no;
         v_dtl.mot_type := i.mot_type;                       --v_dtl.mot_type
         v_dtl.motorcar_comp_cd := i.motorcar_comp_cd;
         v_dtl.make_cd := i.make_cd;
         v_dtl.series_cd := i.series_cd;
         v_dtl.basic_color_cd := i.basic_color_cd;
         v_dtl.color_cd := i.color_cd;
         v_dtl.drvr_occ_cd := i.drvr_occ_cd;
         v_dtl.drvr_name := i.drvr_name;
         v_dtl.drvr_age := i.drvr_age;
         v_dtl.drvr_sex := i.drvr_sex;
         v_dtl.other_info := i.other_info;
         v_dtl.user_id := i.user_id;
         v_dtl.ri_cd := i.ri_cd;
         v_dtl.last_update := i.last_update;
         v_dtl.drvr_add := i.drvr_add;
         v_dtl.drvng_exp := i.drvng_exp;
         v_dtl.nationality_cd := i.nationality_cd;
         v_dtl.class_desc := i.class_desc;
         v_dtl.payee_desc := i.payee_name;
         v_dtl.motor_type_desc := i.motor_type_desc;
         v_dtl.ri_name := i.ri_name;
         v_dtl.basic_color_desc := i.basic_color;
         v_dtl.color_desc := i.color;
         v_dtl.car_com_desc := i.car_company;
         v_dtl.make_desc := i.make;
         v_dtl.engine_series := i.engine_series;
         v_dtl.drvr_occ_desc := i.occ_desc;
         v_dtl.nationality_desc := i.nationality_desc;
         BEGIN
         SELECT DECODE (mail_addr1,
                         NULL, NULL,
                         ' ' || mail_addr1
                        )
               ||
   				 DECODE (mail_addr2,
                         NULL, NULL,
                         ',' || mail_addr2
                        )
               ||
   				 DECODE (mail_addr3,
                         NULL, NULL,
                         '' || mail_addr3 ||'.'
                         )payee_addr
                    INTO v_dtl.payee_add
                    FROM giis_payees
                   WHERE payee_no = i.payee_no
                     AND payee_class_cd = i.payee_class_cd;
         EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                v_dtl.payee_add := NULL;
         END;         
         PIPE ROW (v_dtl);
      END LOOP;
   END;

   FUNCTION get_gicls070_vehicle_info (
      p_claim_id         gicl_mc_tp_dtl.claim_id%TYPE,
      p_payee_class_cd   gicl_mc_tp_dtl.payee_class_cd%TYPE,
      p_payee_no         gicl_mc_tp_dtl.payee_no%TYPE,
      p_subline_cd       gicl_claims.subline_cd%TYPE
   )
      RETURN gicl_mc_tp_dtl_tab PIPELINED
   IS
      v_dtl   gicl_mc_tp_dtl_type;
   BEGIN
      FOR i IN (SELECT a.claim_id, a.item_no, a.payee_class_cd, a.payee_no,
                       a.tp_type, a.plate_no, a.model_year, a.serial_no,
                       a.motor_no, a.mot_type, a.make_cd, a.series_cd,
                       a.basic_color_cd, a.color_cd, a.drvr_occ_cd,
                       a.drvr_name, a.drvr_age, a.drvr_sex, a.other_info,
                       a.ri_cd, a.last_update, a.drvr_add, a.drvng_exp,
                       a.nationality_cd, a.user_id
                  FROM gicl_mc_tp_dtl a
                 WHERE claim_id = p_claim_id
                   AND payee_class_cd = p_payee_class_cd
                   AND payee_no = p_payee_no)
      LOOP
         v_dtl.claim_id := i.claim_id;
         v_dtl.item_no := i.item_no;
         v_dtl.payee_class_cd := i.payee_class_cd;
         v_dtl.payee_no := i.payee_no;
         v_dtl.tp_type := i.tp_type;
         v_dtl.plate_no := i.plate_no;
         v_dtl.model_year := i.model_year;
         v_dtl.serial_no := i.serial_no;
         v_dtl.motor_no := i.motor_no;
         v_dtl.mot_type := i.mot_type;                       --v_dtl.mot_type
         v_dtl.make_cd := i.make_cd;
         v_dtl.series_cd := i.series_cd;
         v_dtl.basic_color_cd := i.basic_color_cd;
         v_dtl.color_cd := i.color_cd;
         v_dtl.drvr_occ_cd := i.drvr_occ_cd;
         v_dtl.drvr_name := i.drvr_name;
         v_dtl.drvr_age := i.drvr_age;
         v_dtl.drvr_sex := i.drvr_sex;
         v_dtl.other_info :=i.other_info;
         v_dtl.user_id := i.user_id;
         v_dtl.ri_cd := i.ri_cd;
         v_dtl.last_update := i.last_update;
         v_dtl.drvr_add := i.drvr_add;
         v_dtl.drvng_exp := i.drvng_exp;
         v_dtl.nationality_cd := i.nationality_cd;

         BEGIN
            SELECT a.motorcar_comp_cd, b.car_company      --b.motcar_comp_desc
              INTO v_dtl.motorcar_comp_cd, v_dtl.car_com_desc
              FROM gicl_mc_tp_dtl a,
                   giis_mc_car_company b                  --gicl_motcar_comp b
             WHERE 1 = 1
               AND a.motorcar_comp_cd = b.car_company_cd    --b.motcar_comp_cd
               AND claim_id = p_claim_id
               AND payee_no = p_payee_no
               AND payee_class_cd = p_payee_class_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_dtl.motorcar_comp_cd := NULL;
               v_dtl.car_com_desc := NULL;
            WHEN TOO_MANY_ROWS
            THEN
               raise_application_error ('-20001',
                                        'error in retrieving company cd'
                                       );
         END;

         --motor type
         BEGIN
            SELECT motor_type_desc
              INTO v_dtl.motor_type_desc
              FROM giis_motortype
             WHERE type_cd = i.mot_type AND subline_cd = p_subline_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_dtl.motor_type_desc := NULL;
            WHEN TOO_MANY_ROWS
            THEN
               raise_application_error ('-20001',
                                        'err in retreiving motor_type_desc'
                                       );
         END;

         --color
         BEGIN
            SELECT basic_color, color
              INTO v_dtl.basic_color_desc, v_dtl.color_desc
              FROM giis_mc_color
             WHERE basic_color_cd = i.basic_color_cd AND color_cd = i.color_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_dtl.basic_color_desc := NULL;
               v_dtl.color_desc := NULL;
            WHEN TOO_MANY_ROWS
            THEN
               raise_application_error
                                   ('-20001',
                                    'err in retrieving basic color and color'
                                   );
         END;

         --make
         BEGIN
            SELECT make
              INTO v_dtl.make_desc
              FROM giis_mc_make
             WHERE 1 = 1
               AND make_cd = i.make_cd
               AND car_company_cd = v_dtl.motorcar_comp_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_dtl.make_desc := NULL;
            WHEN TOO_MANY_ROWS
            THEN
               raise_application_error ('-20001', 'err in retrieving make');
         END;

         --series
         BEGIN
            SELECT engine_series
              INTO v_dtl.engine_series
              FROM giis_mc_eng_series
             WHERE 1 = 1
               AND make_cd = i.make_cd
               AND series_cd = i.series_cd
               AND car_company_cd = v_dtl.motorcar_comp_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_dtl.engine_series := NULL;
            WHEN TOO_MANY_ROWS
            THEN
               raise_application_error ('-20001',
                                        'err in retrieving eng series'
                                       );
         END;

         BEGIN
            SELECT occ_desc
              INTO v_dtl.drvr_occ_desc
              FROM gicl_drvr_occptn
             WHERE drvr_occ_cd = i.drvr_occ_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_dtl.drvr_occ_desc := NULL;
            WHEN TOO_MANY_ROWS
            THEN
               raise_application_error ('-20001',
                                        'err in retrieving occupation'
                                       );
         END;

         PIPE ROW (v_dtl);
      END LOOP;
   END;
   
   /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.26.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Gets the list of GICL_MC_TP_DTL records
    **                  for LOA and CSL Printing
    */ 

    FUNCTION get_mc_tp_dtl_payee_list(p_claim_id IN GICL_CLAIMS.claim_id%TYPE)
     RETURN gicl_mc_tp_dtl_payee_tab PIPELINED AS

       v_tp_dtl   gicl_mc_tp_dtl_payee_type;
       
    BEGIN
        FOR i IN(SELECT a.payee_class_cd, a.payee_no,a.claim_id,a.item_no, 
                        b.payee_last_name||DECODE(b.payee_first_name,NULL,NULL,', '|| b.payee_first_name) ||
                        DECODE(b.payee_middle_name,NULL,NULL,' '|| b.payee_middle_name||'.')payee_name 
                   FROM GICL_MC_TP_DTL a, GIIS_PAYEES b 
                  WHERE 1=1 
                    AND a.payee_class_cd = b.payee_class_cd 
                    AND a.payee_no = b.payee_no
                    AND a.claim_id = p_claim_id)
        LOOP
            v_tp_dtl.payee_class_cd := i.payee_class_cd;
            v_tp_dtl.payee_no       := i.payee_no;
            v_tp_dtl.payee_name     := i.payee_name;
            v_tp_dtl.claim_id       := i.claim_id;
            v_tp_dtl.item_no        := i.item_no;
            PIPE ROW(v_tp_dtl);
        END LOOP;
    END get_mc_tp_dtl_payee_list;
	
	/*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 04.19.2013
    **  Reference By  : GICLS260 - Claim Information
    **  Description   : Gets the list of GICL_MC_TP_DTL records
    **                  for Third/Adverse Party of GICLS260
    */ 

    FUNCTION get_gicls260_mc_tp_dtl(p_claim_id     GICL_MC_TP_DTL.claim_id%TYPE,
                                    p_item_no      GICL_MC_TP_DTL.item_no%TYPE)
    RETURN gicls260_mc_tp_dtl_tab PIPELINED AS

       v_tp_dtl   gicls260_mc_tp_dtl_type;
       
    BEGIN
        FOR i IN(SELECT a.claim_id,a.item_no,a.payee_class_cd, a.payee_no, 
                        a.tp_type, b.mail_addr1 mail_addr,
						b.payee_last_name||DECODE(b.payee_first_name,NULL,NULL,', '|| b.payee_first_name) ||
                        DECODE(b.payee_middle_name,NULL,NULL,' '|| b.payee_middle_name||'.')payee_name 
                   FROM GICL_MC_TP_DTL a, GIIS_PAYEES b 
                  WHERE 1=1 
                    AND a.payee_class_cd = b.payee_class_cd 
                    AND a.payee_no = b.payee_no
                    AND a.claim_id = p_claim_id)
        LOOP
            v_tp_dtl.claim_id       := i.claim_id;
            v_tp_dtl.item_no        := i.item_no;
			v_tp_dtl.payee_class_cd := i.payee_class_cd;
			v_tp_dtl.class_desc     := NULL;
            v_tp_dtl.payee_no       := i.payee_no;
            v_tp_dtl.payee_name     := i.payee_name;
			v_tp_dtl.payee_address  := i.mail_addr;
			v_tp_dtl.tp_type        := i.tp_type;
			
			FOR c IN (SELECT class_desc
                        FROM giis_payee_class
                       WHERE payee_class_cd = i.payee_class_cd)
		    LOOP
				v_tp_dtl.class_desc  := c.class_desc;
			END LOOP;
           
            PIPE ROW(v_tp_dtl);
        END LOOP;
    END get_gicls260_mc_tp_dtl;
	
	/*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 04.19.2013
    **  Reference By  : GICLS260 - Claim Information
    **  Description   : Gets specific GICL_MC_TP_DTL record
    **                  for Third/Adverse Party of GICLS260
    */
	 
	FUNCTION get_gicls260_mc_tp_other_dtls (
      p_claim_id     	GICL_MC_TP_DTL.claim_id%TYPE,
      p_item_no      	GICL_MC_TP_DTL.item_no%TYPE,
      p_payee_class_cd  GICL_MC_TP_DTL.payee_class_cd%TYPE,
      p_payee_no        GICL_MC_TP_DTL.payee_no%TYPE,
	  p_subline_cd      GICL_CLAIMS.subline_cd%TYPE
    )
      RETURN gicl_mc_tp_dtl_tab PIPELINED AS
	
	v_dtl   gicl_mc_tp_dtl_type;
   
   BEGIN
		  FOR i IN (SELECT a.claim_id, a.item_no,  a.payee_class_cd, a.payee_no,
						   a.tp_type,  a.plate_no, a.model_year,     a.serial_no,
						   a.motor_no, a.mot_type, a.make_cd,        a.series_cd,
						   a.basic_color_cd, a.color_cd, a.drvr_occ_cd,
						   a.drvr_name, a.drvr_age, a.drvr_sex, a.other_info,
						   a.ri_cd, a.last_update, a.drvr_add, a.drvng_exp,
						   a.nationality_cd, a.user_id
					  FROM GICL_MC_TP_DTL a
					 WHERE claim_id = p_claim_id
					   AND item_no = p_item_no
					   AND payee_class_cd = p_payee_class_cd
					   AND payee_no = p_payee_no)
		  LOOP
			 v_dtl.claim_id 	  := i.claim_id;
			 v_dtl.item_no 		  := i.item_no;
			 v_dtl.payee_class_cd := i.payee_class_cd;
			 v_dtl.payee_no 	  := i.payee_no;
			 v_dtl.tp_type 		  := i.tp_type;
			 v_dtl.plate_no 	  := i.plate_no;
			 v_dtl.model_year 	  := i.model_year;
			 v_dtl.serial_no      := i.serial_no;
			 v_dtl.motor_no       := i.motor_no;
			 v_dtl.mot_type       := i.mot_type;                      
			 v_dtl.make_cd        := i.make_cd;
			 v_dtl.series_cd      := i.series_cd;
			 v_dtl.basic_color_cd := i.basic_color_cd;
			 v_dtl.color_cd 	  := i.color_cd;
			 v_dtl.drvr_occ_cd    := i.drvr_occ_cd;
			 v_dtl.drvr_name      := i.drvr_name;
			 v_dtl.drvr_age       := i.drvr_age;
			 v_dtl.drvr_sex       := i.drvr_sex;
			 v_dtl.other_info     := i.other_info;
			 v_dtl.user_id        := i.user_id;
			 v_dtl.ri_cd          := i.ri_cd;
			 v_dtl.last_update    := i.last_update;
			 v_dtl.drvr_add       := i.drvr_add;
			 v_dtl.drvng_exp      := i.drvng_exp;
			 v_dtl.nationality_cd := i.nationality_cd;
			 v_dtl.class_desc 	  := NULL;
			 v_dtl.payee_desc 	  := NULL;
			 
			 FOR c IN(SELECT DISTINCT class_desc
					   FROM giis_payee_class
					  WHERE payee_class_cd = i.payee_class_cd)
			 LOOP
				v_dtl.class_desc := c.class_desc;
			 END LOOP;
			 
			--payee_name
			 FOR a IN(SELECT payee_last_name payee
					    FROM giis_payees
					   WHERE payee_no = i.payee_no
						AND payee_class_cd = i.payee_class_cd)
			 LOOP
				v_dtl.payee_desc := a.payee;
			 END LOOP;
	
			 BEGIN
				SELECT a.motorcar_comp_cd, b.car_company
				  INTO v_dtl.motorcar_comp_cd, v_dtl.car_com_desc
				  FROM GICL_MC_TP_DTL a,
					   GIIS_MC_CAR_COMPANY b
				 WHERE 1 = 1
				   AND a.motorcar_comp_cd = b.car_company_cd
				   AND claim_id = p_claim_id
				   AND payee_no = p_payee_no
				   AND payee_class_cd = p_payee_class_cd;
			 EXCEPTION
				WHEN NO_DATA_FOUND THEN
				   v_dtl.motorcar_comp_cd := NULL;
				   v_dtl.car_com_desc := NULL;
			 END;
	
			 --motor type
			 BEGIN
				SELECT motor_type_desc
				  INTO v_dtl.motor_type_desc
				  FROM GIIS_MOTORTYPE
				 WHERE type_cd = i.mot_type 
				   AND subline_cd = p_subline_cd;
			 EXCEPTION
				WHEN NO_DATA_FOUND THEN
				   v_dtl.motor_type_desc := NULL;
			 END;
	
			 --color
			 BEGIN
				SELECT basic_color, color
				  INTO v_dtl.basic_color_desc, v_dtl.color_desc
				  FROM GIIS_MC_COLOR
				 WHERE basic_color_cd = i.basic_color_cd 
				   AND color_cd = i.color_cd;
			 EXCEPTION
				WHEN NO_DATA_FOUND THEN
				   v_dtl.basic_color_desc := NULL;
				   v_dtl.color_desc := NULL;
			 END;
	
			 --make
			 BEGIN
				SELECT make
				  INTO v_dtl.make_desc
				  FROM GIIS_MC_MAKE
				 WHERE 1 = 1
				   AND make_cd = i.make_cd
				   AND car_company_cd = v_dtl.motorcar_comp_cd;
			 EXCEPTION
				WHEN NO_DATA_FOUND THEN
				   v_dtl.make_desc := NULL;
			 END;
	
			 --series
			 BEGIN
				SELECT engine_series
				  INTO v_dtl.engine_series
				  FROM GIIS_MC_ENG_SERIES
				 WHERE 1 = 1
				   AND make_cd = i.make_cd
				   AND series_cd = i.series_cd
				   AND car_company_cd = v_dtl.motorcar_comp_cd;
			 EXCEPTION
				WHEN NO_DATA_FOUND THEN
				   v_dtl.engine_series := NULL;
			 END;
	
			 BEGIN
				SELECT occ_desc
				  INTO v_dtl.drvr_occ_desc
				  FROM GICL_DRVR_OCCPTN
				 WHERE drvr_occ_cd = i.drvr_occ_cd;
			 EXCEPTION
				WHEN NO_DATA_FOUND THEN
				   v_dtl.drvr_occ_desc := NULL;
			 END;
			 
			 BEGIN
				SELECT DISTINCT ri_name
				  INTO v_dtl.ri_name
				  FROM GIIS_REINSURER
				 WHERE ri_cd = i.ri_cd;
			 EXCEPTION
				WHEN NO_DATA_FOUND THEN
				   v_dtl.ri_name := NULL;
			 END;
	
			 PIPE ROW (v_dtl);
			 
		 END LOOP;
	END get_gicls260_mc_tp_other_dtls;
END;
/


