DROP PROCEDURE CPI.DELETE_CO_INS_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.Delete_Co_Ins_Gipis002
  (p_par_id NUMBER,
   B540_co_insurance_sw IN VARCHAR2) IS
BEGIN
   IF B540_co_insurance_sw = '3' THEN
     DELETE FROM GIPI_CO_INSURER
       WHERE  par_id  = p_par_id;
     DELETE FROM GIPI_MAIN_CO_INS
       WHERE  par_id  = p_par_id;
   ELSIF B540_co_insurance_sw = '2' THEN
     DELETE FROM GIPI_ORIG_INVPERL
       WHERE  par_id  = p_par_id;
     DELETE FROM GIPI_ORIG_INV_TAX
       WHERE  par_id  = p_par_id;
     DELETE FROM GIPI_ORIG_INVOICE
       WHERE  par_id  = p_par_id;
     DELETE FROM GIPI_ORIG_COMM_INVOICE
       WHERE  par_id  = p_par_id;
     DELETE FROM GIPI_ORIG_COMM_INV_PERIL
       WHERE  par_id  = p_par_id;
     DELETE FROM GIPI_ORIG_ITMPERIL
       WHERE  par_id  = p_par_id;
     DELETE FROM GIPI_CO_INSURER
       WHERE  par_id  = p_par_id;
     DELETE FROM GIPI_MAIN_CO_INS
       WHERE  par_id  = p_par_id;
   END IF; 
END;
/


