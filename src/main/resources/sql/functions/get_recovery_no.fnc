DROP FUNCTION CPI.GET_RECOVERY_NO;

CREATE OR REPLACE FUNCTION CPI.get_recovery_no (p_recovery_id IN gicl_clm_recovery.recovery_id%TYPE)
RETURN VARCHAR2 AS
/* created by judyann 12162002
** used in sorting records by recovery number
*/
 CURSOR r (p_recovery_id IN gicl_clm_recovery.recovery_id%TYPE) IS
     SELECT line_cd||'-'||iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009')) RECOVERY
       FROM gicl_clm_recovery
      WHERE recovery_id = p_recovery_id;
     p_recovery_no  VARCHAR2(100);
 BEGIN
   OPEN r (p_recovery_id);
   FETCH r INTO p_recovery_no;
   IF r%FOUND THEN
     CLOSE r;
     RETURN p_recovery_no;
   ELSE
     CLOSE r;
     RETURN NULL;
   END IF;
 END;
/


