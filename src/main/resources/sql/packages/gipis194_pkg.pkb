CREATE OR REPLACE PACKAGE BODY CPI.gipis194_pkg
AS
   FUNCTION get_motor_type_lov 
      RETURN motor_type_tab PIPELINED
   AS
      v_list   motor_type_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT  a.motor_type_desc, b.subline_cd, b.mot_type
              FROM giis_motortype a, gipi_vehicle b
             WHERE a.type_cd = b.mot_type)
      LOOP
         v_list.motor_type_desc := i.motor_type_desc;
         v_list.subline_cd := i.subline_cd;
         v_list.mot_type := i.mot_type;
         PIPE ROW (v_list);
      END LOOP;
   END;

   FUNCTION get_subline_cd_lov (
      p_nbt_motor_desc   giis_motortype.motor_type_desc%TYPE,
      p_keyword          VARCHAR2
   )
      RETURN subline_cd_tab PIPELINED
   AS
   BEGIN
      NULL;
   END;

   FUNCTION get_motor_type_list (
      p_mot_type     gipi_vehicle.mot_type%TYPE,
      p_subline_cd   gipi_vehicle.subline_cd%TYPE,
      p_as_of_date   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_date_type    VARCHAR2)
      RETURN motor_type_list_tab PIPELINED
   AS
      v_list   motor_type_list_type;
   BEGIN
      IF p_date_type = '1'
      THEN
         FOR i IN (SELECT   a.item_no, get_policy_no (a.policy_id) policy_no,
                            a.item_title, a.tsi_amt, a.prem_amt, b.motor_no,
                            b.serial_no, b.plate_no, b.mot_type,
                            b.subline_cd, c.policy_id, c.eff_date,
                            c.incept_date, c.expiry_date, c.issue_date,
                            c.assd_no,c.line_cd,c.iss_cd
                       FROM gipi_item a, gipi_vehicle b, gipi_polbasic c
                      WHERE a.policy_id = b.policy_id
                        AND a.item_no = b.item_no
                        AND a.policy_id = c.policy_id
                        AND b.policy_id = c.policy_id
                        AND b.mot_type = p_mot_type
                        AND b.subline_cd = p_subline_cd
                        AND (TRUNC (incept_date) >=
                                           TO_DATE (p_from_date, 'mm-dd-yyyy')
                                AND TRUNC (incept_date) <=
                                             TO_DATE (p_to_date, 'mm-dd-yyyy')
                             OR TRUNC (incept_date) <=
                                          TO_DATE (p_as_of_date, 'mm-dd-yyyy')
                            )
                   ORDER BY a.item_no)
         LOOP
            v_list.item_no := i.item_no;
            v_list.item_title := i.item_title;
            v_list.plate_no := i.plate_no;
            v_list.motor_no := i.motor_no;
            v_list.serial_no := i.serial_no;
            v_list.tsi_amt := i.tsi_amt;
            v_list.prem_amt := i.prem_amt;
            v_list.policy_no := i.policy_no;
            v_list.eff_date := i.eff_date;
            v_list.incept_date := i.incept_date;
            v_list.expiry_date := i.expiry_date;
            v_list.issue_date := i.issue_date;
            v_list.line_cd := i.line_cd;
            v_list.iss_cd := i.iss_cd;

            FOR v IN (SELECT assd_name
                        FROM giis_assured
                       WHERE assd_no = i.assd_no)
            LOOP
               v_list.assured := v.assd_name;
               EXIT;
            END LOOP;

            FOR cred IN (SELECT DISTINCT cred_branch
                                    FROM gipi_polbasic a, gipi_item b
                                   WHERE 1 = 1
                                     AND a.policy_id = b.policy_id
                                     AND iss_cd IS NOT NULL
                                     AND b.policy_id = i.policy_id)
            LOOP
               v_list.cred_branch := cred.cred_branch;
               EXIT;
            END LOOP;

            PIPE ROW (v_list);
         END LOOP;
      ELSIF p_date_type = '2'
      THEN
         FOR i IN (SELECT   a.item_no, get_policy_no (a.policy_id) policy_no,
                            a.item_title, a.tsi_amt, a.prem_amt, b.motor_no,
                            b.serial_no, b.plate_no, b.mot_type,
                            b.subline_cd, c.policy_id, c.eff_date,
                            c.incept_date, c.expiry_date, c.issue_date,
                            c.assd_no, c.line_cd, c.iss_cd
                       FROM gipi_item a, gipi_vehicle b, gipi_polbasic c
                      WHERE a.policy_id = b.policy_id
                        AND a.item_no = b.item_no
                        AND a.policy_id = c.policy_id
                        AND b.policy_id = c.policy_id
                        AND b.mot_type = p_mot_type
                        AND b.subline_cd = p_subline_cd
                        AND (       TRUNC (eff_date) >=
                                           TO_DATE (p_from_date, 'mm-dd-yyyy')
                                AND TRUNC (eff_date) <=
                                             TO_DATE (p_to_date, 'mm-dd-yyyy')
                             OR TRUNC (eff_date) <=
                                          TO_DATE (p_as_of_date, 'mm-dd-yyyy')
                            )
                   ORDER BY a.item_no)
         LOOP
            v_list.item_no := i.item_no;
            v_list.item_title := i.item_title;
            v_list.plate_no := i.plate_no;
            v_list.motor_no := i.motor_no;
            v_list.serial_no := i.serial_no;
            v_list.tsi_amt := i.tsi_amt;
            v_list.prem_amt := i.prem_amt;
            v_list.policy_no := i.policy_no;
            v_list.eff_date := i.eff_date;
            v_list.incept_date := i.incept_date;
            v_list.expiry_date := i.expiry_date;
            v_list.issue_date := i.issue_date;
            v_list.line_cd := i.line_cd;
            v_list.iss_cd := i.iss_cd;

            FOR v IN (SELECT assd_name
                        FROM giis_assured
                       WHERE assd_no = i.assd_no)
            LOOP
               v_list.assured := v.assd_name;
            END LOOP;

            FOR cred IN (SELECT DISTINCT cred_branch
                                    FROM gipi_polbasic a, gipi_item b
                                   WHERE 1 = 1
                                     AND a.policy_id = b.policy_id
                                     AND iss_cd IS NOT NULL
                                     AND b.policy_id = i.policy_id)
            LOOP
               v_list.cred_branch := cred.cred_branch;
            END LOOP;

            PIPE ROW (v_list);
         END LOOP;
      ELSIF p_date_type = '3'
      THEN
         FOR i IN (SELECT   a.item_no, get_policy_no (a.policy_id) policy_no,
                            a.item_title, a.tsi_amt, a.prem_amt, b.motor_no,
                            b.serial_no, b.plate_no, b.mot_type,
                            b.subline_cd, c.policy_id, c.eff_date,
                            c.incept_date, c.expiry_date, c.issue_date,
                            c.assd_no, c.line_cd, c.iss_cd
                       FROM gipi_item a, gipi_vehicle b, gipi_polbasic c
                      WHERE a.policy_id = b.policy_id
                        AND a.item_no = b.item_no
                        AND a.policy_id = c.policy_id
                        AND b.policy_id = c.policy_id
                        AND b.mot_type = p_mot_type
                        AND b.subline_cd = p_subline_cd
                        AND (       TRUNC (issue_date) >=
                                           TO_DATE (p_from_date, 'mm-dd-yyyy')
                                AND TRUNC (issue_date) <=
                                             TO_DATE (p_to_date, 'mm-dd-yyyy')
                             OR TRUNC (issue_date) <=
                                          TO_DATE (p_as_of_date, 'mm-dd-yyyy')
                            )
                   ORDER BY a.item_no)
         LOOP
            v_list.item_no := i.item_no;
            v_list.item_title := i.item_title;
            v_list.plate_no := i.plate_no;
            v_list.motor_no := i.motor_no;
            v_list.serial_no := i.serial_no;
            v_list.tsi_amt := i.tsi_amt;
            v_list.prem_amt := i.prem_amt;
            v_list.policy_no := i.policy_no;
            v_list.eff_date := i.eff_date;
            v_list.incept_date := i.incept_date;
            v_list.expiry_date := i.expiry_date;
            v_list.issue_date := i.issue_date;
            v_list.line_cd := i.line_cd;
            v_list.iss_cd := i.iss_cd;

            FOR v IN (SELECT assd_name
                        FROM giis_assured
                       WHERE assd_no = i.assd_no)
            LOOP
               v_list.assured := v.assd_name;
            END LOOP;

            FOR cred IN (SELECT DISTINCT cred_branch
                                    FROM gipi_polbasic a, gipi_item b
                                   WHERE 1 = 1
                                     AND a.policy_id = b.policy_id
                                     AND iss_cd IS NOT NULL
                                     AND b.policy_id = i.policy_id)
            LOOP
               v_list.cred_branch := cred.cred_branch;
            END LOOP;

            PIPE ROW (v_list);
         END LOOP;
      END IF;
   END;
END;
/


