CREATE OR REPLACE PACKAGE CPI.Dh_Util IS
   FUNCTION spell (x IN NUMBER) RETURN VARCHAR2;
   FUNCTION check_protect (x IN NUMBER, currency IN VARCHAR2, print_dv IN BOOLEAN) RETURN VARCHAR2;
   FUNCTION check_protect2(x IN NUMBER, currency IN VARCHAR2, print_dv IN BOOLEAN) RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES(spell,wnds);
   PRAGMA RESTRICT_REFERENCES(check_protect,wnds);
END;
/

