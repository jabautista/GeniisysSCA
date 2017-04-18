DROP PROCEDURE CPI.GIPIS060_CREATE_DISTRIBUTION_1;

CREATE OR REPLACE PROCEDURE CPI.GIPIS060_CREATE_DISTRIBUTION_1(p_par_id  IN NUMBER,
                              p_dist_no IN NUMBER,
							  p_message OUT VARCHAR2,
							  p_message_2 OUT VARCHAR2)
IS
	/*
	**  Created by   :  Emman
	**  Date Created :  06.24.10
	**  Reference By : (GIPIS060 - Endt Item Info)
	**  Description  : Procedure to create distribution. Part 2.
	**				   Checks the confirmations first before proceeding.
	*/  
  varray_cnt	 NUMBER:=0;
  dist_exist     VARCHAR2(1);  
  pi_dist_no     giuw_pol_dist.dist_no%TYPE;
  b_exist        NUMBER;
/*main*/
BEGIN
  p_message := 'SUCCESS';
  p_message_2 := 'SUCCESS';
  
  FOR array_loop IN (SELECT sum(tsi_amt     * currency_rt) tsi_amt,
		sum(ann_tsi_amt * currency_rt) ann_tsi_amt,
		sum(prem_amt    * currency_rt) prem_amt,
		item_grp
	FROM gipi_witem
	WHERE par_id = p_par_id
    GROUP BY item_grp)
  LOOP
	varray_cnt := varray_cnt + 1;
  END LOOP;
  
  IF varray_cnt = 0 THEN
    p_message := 'NO_ITEMS';
	RETURN;
  END IF;
  
  FOR x IN (SELECT dist_no
              FROM giuw_pol_dist
             WHERE par_id = p_par_id)
  LOOP
    pi_dist_no := x.dist_no;
    dist_exist := 'Y';
    BEGIN--2--
      SELECT    distinct 1
        INTO    b_exist
        FROM    giuw_policyds
       WHERE    dist_no  =  pi_dist_no;
    
        IF  sql%FOUND THEN
	      p_message := 'REC_EXISTS_IN_POST_POL_TAB';
	    END IF;
	END;--2--
	
	BEGIN --3--
	  SELECT   distinct 1
		INTO   b_exist
		FROM   giuw_wpolicyds
	   WHERE   dist_no  =  pi_dist_no;
		    
		    IF  sql%FOUND THEN
				p_message_2 := 'DISTRIBUTION';
			END IF;
	END; --3--
	END LOOP;
END;
/


