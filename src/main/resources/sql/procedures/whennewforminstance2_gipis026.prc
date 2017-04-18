DROP PROCEDURE CPI.WHENNEWFORMINSTANCE2_GIPIS026;

CREATE OR REPLACE PROCEDURE CPI.Whennewforminstance2_Gipis026(
	   	  		  			 PG_CG$B240_PAR_ID  IN  GIPI_PARLIST.PACK_PAR_ID%TYPE
							,PV_LINE_CD		 	OUT GIPI_PARLIST.LINE_CD%TYPE
							,PV_OP_FLAG 	 	OUT GIIS_SUBLINE.OP_FLAG%TYPE ) IS						
BEGIN
  FOR line IN (SELECT line_cd
	             FROM gipi_parlist
	            WHERE pack_par_id = PG_CG$B240_PAR_ID) LOOP
	           PV_LINE_CD := line.line_cd;
  END LOOP;
  FOR op_flag IN (SELECT a.op_flag
	                FROM giis_subline A, gipi_wpolbas B
	               WHERE a.subline_cd = b. subline_cd 
	                 AND a.line_cd = b.line_cd
	                 AND b.pack_par_id = PG_CG$B240_PAR_ID) LOOP
	              PV_OP_FLAG := op_flag.op_flag ;
  END LOOP;
END;
/


