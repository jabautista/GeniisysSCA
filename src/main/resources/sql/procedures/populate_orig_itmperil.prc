DROP PROCEDURE CPI.POPULATE_ORIG_ITMPERIL;

CREATE OR REPLACE PROCEDURE CPI.POPULATE_ORIG_ITMPERIL(
	   	  		  p_par_id	     GIPI_PARLIST.par_id%TYPE
	   	  		  )
	   IS
v_exists	NUMBER:=0;
BEGIN
    /*
	**  Created by		: Jerome Orio
	**  Date Created 	: 03.08.2010
	**  Reference By 	: (GIPIS143 - Discount/Surcharge)
	**  Description 	: POPULATE_ORIG_ITMPERIL program unit
	*/
     DELETE FROM GIPI_ORIG_COMM_INV_PERIL
       WHERE  par_id  = p_par_id;
     DELETE FROM GIPI_ORIG_COMM_INVOICE
       WHERE  par_id  = p_par_id;
     DELETE FROM GIPI_ORIG_INVPERL
       WHERE  par_id  = p_par_id;
     DELETE FROM GIPI_ORIG_INV_TAX
       WHERE  par_id  = p_par_id;
     DELETE FROM GIPI_ORIG_INVOICE
       WHERE  par_id  = p_par_id;
     DELETE FROM GIPI_ORIG_ITMPERIL
       WHERE  par_id  = p_par_id;
     DELETE FROM GIPI_CO_INSURER
       WHERE  par_id  = p_par_id;
     DELETE FROM GIPI_MAIN_CO_INS
       WHERE  par_id  = p_par_id;
BEGIN
	SELECT 1
	  INTO v_exists
		FROM GIPI_CO_INSURER
	 WHERE par_id = p_par_id;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
	v_exists := 0;
	WHEN TOO_MANY_ROWS THEN
	v_exists := 1;
END;	
		 	IF v_exists = 1 THEN
			 	FOR A IN(SELECT item_no, line_cd, peril_cd, rec_flag,
	      		            prem_rt, DECODE(prem_rt,0,0,((prem_amt/prem_rt) * 100))prem_amt,
	                  		DECODE(prem_rt,0,0,((tsi_amt/prem_rt) * 100))tsi_amt
	             		 FROM GIPI_WITMPERL
	            		WHERE par_id = p_par_id)
	      LOOP
	      	INSERT INTO GIPI_ORIG_ITMPERIL(par_id,       item_no,      line_cd,    peril_cd, 
	                                       rec_flag,     prem_rt,      prem_amt,   tsi_amt)
	                                VALUES(p_par_id,     A.item_no,    A.line_cd,  A.peril_cd,
	                                       A.rec_flag,   A.prem_rt,    A.prem_amt, A.tsi_amt);
	      END LOOP;
      ELSE
			 	FOR A IN(SELECT item_no, line_cd, peril_cd, rec_flag,
	      		            prem_rt, prem_amt,tsi_amt
	             		 FROM GIPI_WITMPERL
	            		WHERE par_id = p_par_id)
	      LOOP
	      	INSERT INTO GIPI_ORIG_ITMPERIL(par_id,       item_no,      line_cd,    peril_cd, 
	                                       rec_flag,     prem_rt,      prem_amt,   tsi_amt)
	                                VALUES(p_par_id,     A.item_no,    A.line_cd,  A.peril_cd,
	                                       A.rec_flag,   A.prem_rt,    A.prem_amt, A.tsi_amt);
	      END LOOP;      	
      END IF;
   
END;
/


