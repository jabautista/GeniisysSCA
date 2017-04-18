DROP PROCEDURE CPI.ADJUST_PACK_WINV_TAX_GIPIS026;

CREATE OR REPLACE PROCEDURE CPI.ADJUST_PACK_WINV_TAX_GIPIS026 (
	   	  p_pack_par_id GIPI_PARLIST.PACK_PAR_ID%TYPE
		  )
IS
  v_line_cd giis_line.line_cd%TYPE;
BEGIN
	FOR c1 IN (SELECT line_cd
	             FROM gipi_pack_parlist
	            WHERE pack_par_id = p_pack_par_id)
	LOOP
		v_line_cd := c1.line_cd;
	END LOOP;		
	DELETE GIPI_PACK_WINV_TAX
	 WHERE pack_par_id = p_pack_par_id;
	FOR gwt1 IN (SELECT item_grp, tax_cd, SUM(tax_amt) tax_amt, SUM(rate) rate, takeup_seq_no --added by steven 1.28.2013; "takeup_seq_no" cause of error nung SR 0012043. wala kasing ini-insert na take-up sequence number.
		      	   FROM GIPI_WINV_TAX A
				      WHERE EXISTS (SELECT 1
					                    FROM GIPI_PARLIST gp
					 		               WHERE gp.par_id = A.par_id
								               AND gp.pack_par_id = p_pack_par_id)
				      GROUP BY item_grp, tax_cd, takeup_seq_no)
	LOOP
	  FOR gwt2 IN (SELECT line_cd, tax_allocation, fixed_tax_allocation, iss_cd, tax_id
	 	             FROM GIPI_WINV_TAX A
		            WHERE EXISTS (SELECT 1
		                            FROM GIPI_PARLIST gp
					                     WHERE gp.par_id = A.par_id
						                     AND gp.pack_par_id = p_pack_par_id)
					        AND A.item_grp = gwt1.item_grp
					        AND A.tax_cd = gwt1.tax_cd)
	  LOOP
	    INSERT INTO GIPI_PACK_WINV_TAX(pack_par_id, item_grp, tax_cd, line_cd, tax_allocation, fixed_tax_allocation, iss_cd, tax_amt, tax_id, rate, takeup_seq_no)
		                        VALUES(p_pack_par_id, gwt1.item_grp, gwt1.tax_cd, v_line_cd, gwt2.tax_allocation, gwt2.fixed_tax_allocation, gwt2.iss_cd, gwt1.tax_amt, gwt2.tax_id, gwt1.rate, gwt1.takeup_seq_no); --added by steven 1.28.2013
	    EXIT;
	  END LOOP;
	END LOOP;  
END;
/


