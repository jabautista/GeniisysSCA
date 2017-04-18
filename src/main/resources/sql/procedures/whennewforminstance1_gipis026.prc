DROP PROCEDURE CPI.WHENNEWFORMINSTANCE1_GIPIS026;

CREATE OR REPLACE PROCEDURE CPI.WHENNEWFORMINSTANCE1_GIPIS026(
	   	  		  			 PG_PACK_PAR_ID  IN  GIPI_PACK_PARLIST.PACK_PAR_ID%TYPE
							,PV_LINE_CD		 OUT GIPI_PACK_PARLIST.LINE_CD%TYPE
							,PV_OP_FLAG 	 OUT GIIS_SUBLINE.OP_FLAG%TYPE ) IS						
BEGIN
  FOR line IN (SELECT line_cd
	             FROM gipi_pack_parlist
	            WHERE pack_par_id = PG_PACK_PAR_ID) LOOP
	           PV_LINE_CD := line.line_cd;
  END LOOP;
  FOR op_flag IN (SELECT a.op_flag
	                FROM giis_subline A, gipi_pack_wpolbas B
	               WHERE a.subline_cd = b. subline_cd 
	                 AND a.line_cd = b.line_cd
	                 AND b.pack_par_id = PG_pack_par_id) LOOP
	              PV_OP_FLAG := op_flag.op_flag ;
  END LOOP;
END;
/


