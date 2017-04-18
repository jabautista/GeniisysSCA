DROP FUNCTION CPI.SEQ_NEXTVAL_ON_DEMAND;

CREATE OR REPLACE FUNCTION CPI.seq_nextval_on_demand (p_seq_name IN VARCHAR2)
   RETURN NUMBER
IS
   v_seq_val   NUMBER;
/* To fixed the issue in MERGE
** the NEXTVALUE value is incremented for each row updated
** and for each row inserted,
** even if the sequence number is not actually used
** in the update or insert operation
** by Fons 11/26/2013.
*/
BEGIN
   EXECUTE IMMEDIATE 'select ' || p_seq_name || '.nextval from sys.dual'
                INTO v_seq_val;

   RETURN v_seq_val;
END seq_nextval_on_demand;
/


