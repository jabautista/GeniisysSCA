DROP PROCEDURE CPI.PRINTER_VALIDATION;

CREATE OR REPLACE PROCEDURE CPI.printer_validation (
   p_printer_name   IN       VARCHAR2,
   p_no_of_copies   IN       NUMBER,
   p_message        OUT      VARCHAR2,
   p_boolean        OUT      BOOLEAN
)
IS
BEGIN
   IF p_printer_name IS NULL AND p_no_of_copies IS NULL
   THEN
      p_boolean := TRUE;
      p_message := 'Enter values for printer and number of copies.';
   ELSIF p_printer_name IS NULL
   THEN
      p_boolean := TRUE;
      p_message := 'Enter value for printer.';
   ELSIF p_no_of_copies IS NULL
   THEN
      p_boolean := TRUE;
      p_message := 'Enter value for number of copies.';
   ELSE
      p_boolean := FALSE;
   END IF;
END;
/


