DROP PROCEDURE CPI.POPULATE_ORIG_ITMPERIL_2;

CREATE OR REPLACE PROCEDURE CPI.POPULATE_ORIG_ITMPERIL_2(
	   	  		  p_par_id	     IN GIPI_PARLIST.par_id%TYPE,
	   	  		  p_message		 OUT VARCHAR2)
	   IS
v_exists	NUMBER:=0;
BEGIN
    /*
	**  Created by		: Emman
	**  Date Created 	: 06.23.10
	**  Reference By 	: (GIPIS060 - Endt Item Info)
	**  Description 	: POPULATE_ORIG_ITMPERIL program unit. Different from another POPULATE_ORIG_ITMPERIL
	**					  of GIPIS143 in that there are no records inserted in GIPI_ORIG_ITMPERIL.
	**					  Calls Gipi_winvoice_pkg.create_gipi_winvoice instead
	*/
	p_message := 'N';
	FOR A3 IN (SELECT   distinct 1
       	   	     FROM   gipi_witmperl
      			WHERE   par_id   =  p_par_id) LOOP
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
		 p_message := 'Y';
		 Gipi_winvoice_pkg.create_gipi_winvoice(p_par_id);
		 EXIT;
	END LOOP;  
	
END;
/


