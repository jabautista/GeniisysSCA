DROP PROCEDURE CPI.CHECK_INSTNO;

CREATE OR REPLACE PROCEDURE CPI.check_instno (
   p_prem_seq_no         gipi_installment.prem_seq_no%TYPE,
   p_iss_cd              gipi_installment.iss_cd%TYPE,
   p_inst_no   			 gipi_installment.inst_no%TYPE,
   p_rec_count      OUT   NUMBER,
   p_message       OUT   VARCHAR2
)
IS
BEGIN
   p_message := ' ';
  
   BEGIN
   IF p_inst_no = 0 THEN
      SELECT COUNT (*)
        INTO p_rec_count
        FROM gipi_installment b150
       WHERE b150.iss_cd = p_iss_cd 
	   		 AND b150.prem_seq_no = p_prem_seq_no;
   ELSE
   	   SELECT COUNT (*)
        INTO p_rec_count
        FROM gipi_installment b150
       WHERE b150.iss_cd = p_iss_cd 
	   		 AND b150.prem_seq_no = p_prem_seq_no
			 AND inst_no = p_inst_no;
   END IF;		 
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
	  	 p_rec_count := 0;
         p_message := 'Installment(s) for this bill does not exist';
   END;
   
END;
/


