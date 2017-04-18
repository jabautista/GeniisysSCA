DROP FUNCTION CPI.DISPLAY_ASSURED;

CREATE OR REPLACE FUNCTION CPI.Display_Assured (v_assd_no   GIIS_ASSURED.assd_no%TYPE)
RETURN VARCHAR2 AS
/* Created By: Ken 06/23/2006 */
/*INSERT INTO cpi.giis_parameters
   (PARAM_TYPE, PARAM_NAME, PARAM_VALUE_N, REMARKS, USER_ID, LAST_UPDATE)
 VALUES
   ('N', 'ASSURED_NAME_ORDER_POLICY', 1, '1 - Last Name First / 2 - First Name First', USER, SYSDATE);
--COMMIT;*/
   v_param_value   GIIS_PARAMETERS.param_value_n%TYPE;
   v_designation   GIIS_ASSURED.designation%TYPE;
   v_assd_name     GIIS_ASSURED.assd_name%TYPE;
   v_assd_name2    GIIS_ASSURED.assd_name2%TYPE;
   v_fname         GIIS_ASSURED.first_name%TYPE;
   v_mname         VARCHAR2(5);
   v_lname         GIIS_ASSURED.last_name%TYPE;
   v_name          VARCHAR2 (550);
   v_suffix        VARCHAR2(10); -- bonok :: 12.16.2015 :: UCPB SR 21197
BEGIN
   --check parameters
   FOR A IN (SELECT param_value_n
               FROM GIIS_PARAMETERS
              WHERE param_name = 'ASSURED_NAME_ORDER'/*'DISPLAY_ASSURED'*/)  --edited by d.alcantara, 08/15/2011
   LOOP
      v_param_value := A.param_value_n;
   END LOOP;
   --assured
   FOR b IN (SELECT designation, assd_name, assd_name2, first_name, last_name,
                    DECODE(middle_initial, NULL, '' , middle_initial || '.') middle_initial, 
                    DECODE(suffix, NULL, '', suffix || ' ') suffix
               FROM GIIS_ASSURED
              WHERE assd_no = v_assd_no)
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
            v_name := v_lname || ', ' || v_fname || ' ' || v_suffix || v_mname; -- edited by: Nica 10/13/2011 to add suffix
         END IF;
      ELSE
         IF v_fname IS NULL THEN
             IF v_assd_name2 IS NULL THEN
               v_name := v_designation || ' ' || v_assd_name;
            ELSE
               v_name := v_designation || ' ' || v_assd_name || CHR(10) || v_assd_name2;
            END IF;
         ELSE
            v_name := v_designation || ' ' || v_lname || ', ' || v_fname || ' '|| v_suffix || v_mname;
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
               v_name := v_fname || ' ' || v_lname || ' ' || v_assd_name2; -- analyn 07.08.2009 added ||' ' || v_assd_name2
            ELSE
               v_name := v_fname || ' ' || v_mname|| ' ' || v_lname || ' ' || v_assd_name2; -- analyn 07.08.2009 added ||' ' || v_assd_name2
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
               v_name := v_designation || ' ' || v_fname || ' ' || v_lname || ' ' || v_suffix;
            ELSE
               v_name := v_designation || ' ' || v_fname || ' ' || v_mname|| ' ' || v_lname || ' ' || v_suffix;
            END IF;
         END IF;
      END IF;
   END IF;
   --
  RETURN (v_name);
END;
/


