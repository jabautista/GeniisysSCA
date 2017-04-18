DROP FUNCTION CPI.MODULUS_10;

CREATE OR REPLACE FUNCTION CPI.modulus_10 (p_modulus_input IN VARCHAR2)
   RETURN VARCHAR2
IS
   v_firstcheckdigit    VARCHAR2 (10);
   v_secondcheckdigit   VARCHAR2 (10);
   v_productSum         NUMBER        := 0;
   v_final              NUMBER        := 0;
   v_final2             NUMBER        := 0;
BEGIN
   v_firstcheckdigit := SUBSTR (p_modulus_input, 1, 7);
   v_firstcheckdigit := REPLACE (v_firstcheckdigit, '-');
   v_secondcheckdigit := SUBSTR (p_modulus_input, 9, 15);

   FOR i IN 1 .. 6
   LOOP
      IF MOD (i, 2) = 1
      THEN
         v_productSum :=
                v_productSum
                + (TO_NUMBER (SUBSTR (v_firstcheckdigit, i, 1)) * 3);
      ELSIF MOD (i, 2) = 0
      THEN
         v_productSum :=
                v_productSum
                + (TO_NUMBER (SUBSTR (v_firstcheckdigit, i, 1)) * 1);
      END IF;
   END LOOP;
   IF MOD (v_productSum, 10) != 0 THEN
   v_final := 10 - MOD (v_productSum, 10);
   ELSE
   v_final := 0;
   END IF;
   v_productSum := 0;

   FOR j IN 1 .. 7
   LOOP
      IF MOD (j, 2) = 1
      THEN
         v_productSum :=
               v_productSum
               + (TO_NUMBER (SUBSTR (v_secondcheckdigit, j, 1)) * 3);
      ELSIF MOD (j, 2) = 0
      THEN
         v_productSum :=
               v_productSum
               + (TO_NUMBER (SUBSTR (v_secondcheckdigit, j, 1)) * 1);
      END IF;
   END LOOP;
   IF MOD (v_productSum, 10) != 0 THEN
   v_final2 := 10 - MOD (v_productSum, 10);
   ELSE
   v_final2 := 0;
   END IF;
   RETURN v_final || v_final2;
END modulus_10;
/


