DROP PROCEDURE CPI.TRANSMIT_ENABLE_SCRIPTS;

CREATE OR REPLACE PROCEDURE CPI.transmit_enable_scripts(v_en IN VARCHAR2)  AS
 v_stmt   VARCHAR2(500);
/* created by ajel echano 042402
 * used by the transmittal modules and geniisys banner screens
 * text (enable trigger scripts) inserted into gitr_en_scripts are selected
 * and executed inside a for loop
 */
BEGIN
 FOR cur IN(
   SELECT text
     FROM gitr_en_scripts)
 LOOP
  v_stmt := cur.text;
  IF v_en = 'D' THEN
   EXECUTE IMMEDIATE (v_stmt||' DISABLE');
  ELSIF v_en = 'E' THEN
   EXECUTE IMMEDIATE (v_stmt||' ENABLE');
  END IF;
 END LOOP;
END;
/

DROP PROCEDURE CPI.TRANSMIT_ENABLE_SCRIPTS;
