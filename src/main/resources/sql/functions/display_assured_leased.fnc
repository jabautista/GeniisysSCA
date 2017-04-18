DROP FUNCTION CPI.DISPLAY_ASSURED_LEASED;

CREATE OR REPLACE FUNCTION CPI.Display_Assured_Leased (v_acct_of_cd   gixx_polbasic.acct_of_cd%TYPE)
RETURN VARCHAR2 AS
/* Created By: Ken 06/23/2006 */
/*INSERT INTO cpi.giis_parameters
   (PARAM_TYPE, PARAM_NAME, PARAM_VALUE_N, REMARKS, USER_ID, LAST_UPDATE)
 VALUES
   ('N', 'ASSURED_NAME_ORDER_POLICY', 1, '1 - Last Name First / 2 - First Name First', USER, SYSDATE);
--COMMIT;*/
--Added to CPI dbase by ohwver 06302006--
   v_param_value   giis_parameters.param_value_n%TYPE;
   v_designation   giis_assured.designation%TYPE;
   v_assd_name     giis_assured.assd_name%TYPE;
   v_assd_name2    giis_assured.assd_name2%TYPE;
   v_fname         giis_assured.first_name%TYPE;
   v_mname         giis_assured.middle_initial%TYPE;
   v_lname         giis_assured.last_name%TYPE;
   v_name          VARCHAR2 (550);
   v_suffix        giis_assured.suffix%TYPE;
BEGIN
   --check parameters
   FOR A IN (SELECT param_value_n
               FROM giis_parameters
              WHERE param_name = 'DISPLAY_ASSURED')
   LOOP
      v_param_value := A.param_value_n;
   END LOOP;
   --assured
   FOR b IN (SELECT x.designation, x.assd_name, x.assd_name2, x.first_name, x.middle_initial, x.last_name,
                    DECODE(x.suffix, NULL, '', x. suffix || ' ') suffix
               FROM giis_assured x, gixx_polbasic y
              WHERE y.acct_of_cd > 0
                AND y.acct_of_cd = v_acct_of_cd
                AND x.assd_no = y.acct_of_cd)
   LOOP
      v_designation := b.designation;
      v_assd_name := b.assd_name;
      v_assd_name2 := b.assd_name2;
      v_fname := b.first_name;
      v_mname := b.middle_initial;
      v_lname := b.last_name;
      v_suffix := b.suffix;
   END LOOP;
   --
   IF v_param_value = 1 THEN -- 1-Last Name First
      IF v_designation IS NULL THEN
         IF v_fname IS NULL THEN
             IF v_assd_name2 IS NULL THEN
               v_name := v_assd_name;
            ELSE
               v_name := v_assd_name || CHR(10) || v_assd_name2;
            END IF;
         ELSE
            v_name := v_lname || ', ' || v_fname || ' ' || v_suffix || v_mname;
         END IF;
      ELSE
         IF v_fname IS NULL THEN
            IF v_assd_name2 IS NULL THEN
               v_name := v_designation || ' ' || v_assd_name;
            ELSE
               v_name := v_designation || ' ' || v_assd_name || CHR(10) || v_assd_name2;
            END IF;
         ELSE
            v_name := v_designation || ' ' || v_lname || ', ' || v_fname || ' ' || v_suffix || v_mname;
         END IF;
      END IF;
   ELSIF v_param_value = 2 THEN -- 2-First Name First
      IF v_designation IS NULL THEN
         IF v_fname IS NULL THEN
             IF v_assd_name2 IS NULL THEN
               v_name := v_assd_name;
            ELSE
               v_name := v_assd_name || CHR(10) || v_assd_name2;
            END IF;
         ELSE
            IF v_mname IS NULL THEN
               v_name := v_fname || ' ' || v_lname;
            ELSE
               v_name := v_fname || ' ' || v_mname || ' ' || v_lname || ' '|| v_suffix;
            END IF;
         END IF;
      ELSE
         IF v_fname IS NULL THEN
             IF v_assd_name2 IS NULL THEN
               v_name := v_designation || ' ' || v_assd_name;
            ELSE
               v_name := v_designation || ' ' || v_assd_name || CHR(10) || v_assd_name2;
            END IF;
         ELSE
            IF v_mname IS NULL THEN
               v_name := v_designation || ' ' || v_fname || ' ' || v_lname;
            ELSE
               v_name := v_designation || ' ' || v_fname || ' ' || v_mname || ' ' || v_lname || ' ' || v_suffix;
            END IF;
         END IF;
      END IF;
   END IF;
   --
  RETURN (v_name);
END;
/


