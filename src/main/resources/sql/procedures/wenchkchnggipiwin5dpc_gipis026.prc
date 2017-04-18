DROP PROCEDURE CPI.WENCHKCHNGGIPIWIN5DPC_GIPIS026;

CREATE OR REPLACE PROCEDURE CPI.WENCHKCHNGGIPIWIN5DPC_GIPIS026(
	   	  		  			 P_CURRENCY_DESC  IN  GIIS_CURRENCY.CURRENCY_DESC%TYPE
							,P_PAR_ID	 	  IN  GIPI_WINVOICE.PAR_ID%TYPE
							,P_CD		 	  OUT GIIS_CURRENCY.MAIN_CURRENCY_CD%TYPE
							,P_SWITCH 		  OUT VARCHAR2 ) IS
BEGIN
FOR cd IN (
    SELECT main_currency_cd
      FROM giis_currency
     WHERE currency_desc = P_CURRENCY_DESC)
  LOOP
     P_CD := cd.main_currency_cd;
  END LOOP;
 FOR curr IN (
    SELECT currency_cd
      FROM gipi_winvoice
     WHERE par_id = P_PAR_ID)
  LOOP
    IF curr.currency_cd != P_CD THEN
       P_SWITCH := 'Y';
       EXIT;
	else
	p_switch := 'N'; --cris
	END IF;  
	    
  END LOOP;
END;
/


