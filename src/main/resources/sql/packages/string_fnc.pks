CREATE OR REPLACE PACKAGE CPI.STRING_FNC
IS
/**
    added by irwin Tabisora, 8.23.2012
	Description: Splits string to array depending on the delimiter.
*/
TYPE t_array IS TABLE OF VARCHAR2(50)
   INDEX BY BINARY_INTEGER;

FUNCTION SPLIT (p_in_string VARCHAR2, p_delim VARCHAR2) RETURN t_array;

END;
/


