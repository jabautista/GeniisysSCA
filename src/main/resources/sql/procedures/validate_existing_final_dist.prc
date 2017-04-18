DROP PROCEDURE CPI.VALIDATE_EXISTING_FINAL_DIST;

CREATE OR REPLACE PROCEDURE CPI.VALIDATE_EXISTING_FINAL_DIST(
	   	  		  p_dist_no    IN  GIUW_POL_DIST.dist_no%TYPE,
				  p_MSG_ALERT  OUT VARCHAR2
				  ) 
 		IS
  v_hdr_sw   VARCHAR2(1); --field that used as a switch to determine if records exist in header table
  v_dtl_sw   VARCHAR2(1); --field that used as a switch to determine if records exist in detail table
BEGIN
	v_hdr_sw := 'N';
  --check if there are records in giuw_policyds
  FOR A IN (SELECT dist_no, dist_seq_no
              FROM GIUW_POLICYDS
             WHERE dist_no = p_dist_no)
  LOOP 	
  	v_hdr_sw := 'Y';
  	v_dtl_sw := 'N';
  	--check if there are records corresponding records in giuw_policyds_dtl		
  	-- for every record in giuw_policyds	
  	FOR B IN (SELECT '1'
  	            FROM GIUW_POLICYDS_DTL
  	           WHERE dist_no = a.dist_no
  	             AND dist_seq_no = a.dist_seq_no)
  	LOOP            
  		v_dtl_sw := 'Y';
  		EXIT;
  	END LOOP;	 
  	IF v_dtl_sw = 'N' THEN
  	   p_MSG_ALERT := 'There was an error encountered in distribution records, '||
  	             'to correct this error please recreate using ' ||
  	             'any Preliminary Distribution program.';
  	   --error_rtn;          
  	END IF;
  END LOOP;
  IF v_hdr_sw = 'N' THEN
     p_MSG_ALERT := 'There was an error encountered in distribution records, '||
  	           'to correct this error please recreate using ' ||
  	           'any Preliminary Distribution program.';
  	 --error_rtn;
  END IF;
  
 	v_hdr_sw := 'N';
  --check if there are records in giuw_itemds
  FOR A IN (SELECT dist_no, dist_seq_no, item_no
              FROM GIUW_ITEMDS
             WHERE dist_no = p_dist_no)
  LOOP 	
  	v_hdr_sw := 'Y';
  	v_dtl_sw := 'N';
  	--check if there are records corresponding records in giuw_itemds_dtl		
  	-- for every record in giuw_itemds	
  	FOR B IN (SELECT '1'
  	            FROM GIUW_ITEMDS_DTL
  	           WHERE dist_no = a.dist_no
  	             AND dist_seq_no = a.dist_seq_no
  	             AND item_no = a.item_no)
  	LOOP            
  		v_dtl_sw := 'Y';
  		EXIT;
  	END LOOP;	 
  	IF v_dtl_sw = 'N' THEN
  	   p_MSG_ALERT := 'There was an error encountered in distribution records, '||
  	             'to correct this error please recreate using ' ||
  	             'any Preliminary Distribution program.';
  	   --error_rtn;
  	END IF;
  END LOOP;
  IF v_hdr_sw = 'N' THEN
     p_MSG_ALERT := 'There was an error encountered in distribution records, '||
  	           'to correct this error please recreate using ' ||
  	           'any Preliminary Distribution program.';
  	 --error_rtn;
  END IF;
  
  v_hdr_sw := 'N';
  --check if there are records in giuw_itemperilds
  FOR A IN (SELECT t1.dist_no,  t1.dist_seq_no, t1.item_no, t1.peril_cd
              FROM GIUW_ITEMPERILDS t1
             WHERE t1.dist_no  = p_dist_no)
  LOOP 	
  	v_hdr_sw := 'Y';
  	v_dtl_sw := 'N';
  	--check if there are records corresponding records in giuw_itemperilds_dtl		
  	-- for every record in giuw_itemperilds	
  	FOR B IN (SELECT '1'
  	            FROM GIUW_ITEMPERILDS_DTL
  	           WHERE dist_no = a.dist_no
  	             AND dist_seq_no = a.dist_seq_no
  	             AND item_no = a.item_no
  	             AND peril_cd = a.peril_cd)
  	LOOP            
  		v_dtl_sw := 'Y';
  		EXIT;
  	END LOOP;	 
  	IF v_dtl_sw = 'N' THEN
  	   p_MSG_ALERT := 'There was an error encountered in distribution records, '||
  	             'to correct this error please recreate using ' ||
  	             'any Preliminary Distribution program.';
  	   --error_rtn;
  	END IF;
  END LOOP;
  IF v_hdr_sw = 'N' THEN
     p_MSG_ALERT := 'There was an error encountered in distribution records, '||
  	           'to correct this error please recreate using ' ||
  	           'any Preliminary Distribution program.';
  	 --error_rtn;
  END IF;
  
  v_hdr_sw := 'N';
  --check if there are records in giuw_perilds
  FOR A IN (SELECT t1.dist_no,  t1.dist_seq_no, t1.peril_cd
              FROM GIUW_PERILDS t1
             WHERE t1.dist_no  = p_dist_no)
  LOOP 	
  	v_hdr_sw := 'Y';
  	v_dtl_sw := 'N';
  	--check if there are records corresponding records in giuw_perilds_dtl		
  	-- for every record in giuw_perilds	
  	FOR B IN (SELECT '1'
  	            FROM GIUW_PERILDS_DTL
  	           WHERE dist_no = a.dist_no
  	             AND dist_seq_no = a.dist_seq_no
  	             AND peril_cd = a.peril_cd)
  	LOOP            
  		v_dtl_sw := 'Y';
  		EXIT;
  	END LOOP;	 
  	IF v_dtl_sw = 'N' THEN
  	   p_MSG_ALERT := 'There was an error encountered in distribution records, '||
  	             'to correct this error please recreate using ' ||
  	             'any Preliminary Distribution program.';
  	   --error_rtn;
  	END IF;
  END LOOP;
  IF v_hdr_sw = 'N' THEN
     p_MSG_ALERT := 'There was an error encountered in distribution records, '||
  	           'to correct this error please recreate using ' ||
  	           'any Preliminary Distribution program.';
  	 --error_rtn;
  END IF;
END;
/


