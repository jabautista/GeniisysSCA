DROP PROCEDURE CPI.VALIDATE_EXISTING_DIST_REC;

CREATE OR REPLACE PROCEDURE CPI.VALIDATE_EXISTING_DIST_REC (
	   	  p_policy_id giuw_pol_dist.policy_id%TYPE,
		  p_dist_no	  GIUW_POL_DIST.dist_no%TYPE,
		  p_message	  IN OUT VARCHAR2
)
IS
  v_hdr_sw   VARCHAR2(1); --field that used as a switch to determine if records exist in header table
  v_dtl_sw   VARCHAR2(1); --field that used as a switch to determine if records exist in detail table
BEGIN	
  FOR A IN (SELECT b340.item_grp,         SUM(b340.prem_amt) prem, 
                   SUM(b340.tsi_amt) tsi, SUM(b340.ann_tsi_amt) ann_tsi
              FROM gipi_item b340
             WHERE b340.policy_id = p_policy_id
          GROUP BY b340.item_grp)
  LOOP
    v_hdr_sw := 'N';
    FOR B IN (SELECT SUM(c110.prem_amt) prem, SUM(c110.tsi_amt) tsi,
                     SUM(c110.ann_tsi_amt) ann_tsi
                FROM giuw_wpolicyds c110
               WHERE dist_no = p_dist_no
                 AND item_grp = a.item_grp)
    LOOP
      IF NVL(a.prem,0) = NVL(b.prem,0) AND 
     	   NVL(a.tsi,0) = NVL(b.tsi,0) /*AND
    	   NVL(a.ann_tsi,0) = NVL(b.ann_tsi,0)*/ THEN
    	   v_hdr_sw := 'Y';
      END IF;	  
    END LOOP;	
    IF v_hdr_sw = 'N' THEN
    	 p_message := 'There was an error encountered in distribution records, '||
                 'to correct this error please recreate using ' ||
  	             'Set-Up Groups For Distribution(Item).';
       EXIT;
    END IF;
  END LOOP;
  --if records in giuw_wpolicyds exists then check for the existance of records 
  --on other distribution tables 	
  IF v_hdr_sw = 'Y' THEN  
     --get all existing dist_seq_no  from giuw_wpolicyds
     FOR SEQ IN (SELECT c110.dist_seq_no, c110.tsi_amt,
                        c110.ann_tsi_amt, c110.prem_amt
                   FROM giuw_wpolicyds c110
                  WHERE c110.dist_no = p_dist_no)
     LOOP 	
       v_dtl_sw := 'N';
       --check if there are corresponding records in giuw_wpolicyds_dtl		
       -- for every record in giuw_wpolicyds	
       FOR B IN (SELECT SUM(NVL(dist_tsi,0))  dist_tsi,
  	                    SUM(NVL(dist_prem,0)) dist_prem,
                        SUM(NVL(ann_dist_tsi,0)) ann_dist_tsi
  	               FROM giuw_wpolicyds_dtl c130
  	              WHERE c130.dist_no = p_dist_no
  	                AND c130.dist_seq_no = seq.dist_seq_no)
       LOOP            
  	     IF NVL(seq.tsi_amt,0) = NVL(b.dist_tsi,0) AND 
  	     		NVL(seq.ann_tsi_amt,0) = NVL(b.ann_dist_tsi,0) AND
  	      	NVL(seq.prem_amt,0) = NVL(b.dist_prem,0) THEN
  		      v_dtl_sw := 'Y';  		
  	     END IF;   
  	     EXIT;
       END LOOP;
       IF v_dtl_sw = 'N' THEN
       	  p_message := 'There was an error encountered in distribution records, '||
                    'to correct this error please recreate using ' ||
  	                'Set-Up Groups For Distribution(Item).';
          EXIT;
       END IF;
       v_hdr_sw := 'N';
       --get all item_no from giuw_witemds for the dist_seq_no retrieved from giuw_wpolicyds
       FOR ITEM IN (SELECT item_no, dist_seq_no
                      FROM giuw_witemds c040
                     WHERE c040.dist_no = p_dist_no
                       AND c040.dist_seq_no = seq.dist_seq_no)
       LOOP 	
         v_hdr_sw := 'Y';
         --check for records in giuw_witemds_dtl for each item_no in giuw_witemds	
         v_dtl_sw := 'N';
         --check if there are corresponding records in giuw_witemds_dtl		
         -- for every record in giuw_witemds	    
         FOR B IN (SELECT '1'
                     FROM giuw_witemds_dtl c050
                    WHERE c050.dist_no = p_dist_no
                      AND c050.dist_seq_no = seq.dist_seq_no
                      AND c050.item_no = item.item_no)
         LOOP            
  	       v_dtl_sw := 'Y';
  	       EXIT;
         END LOOP;	 
         IF v_dtl_sw = 'N' THEN
            p_message := 'There was an error encountered in distribution records, '||
                      'to correct this error please recreate using ' ||
  	                  'Set-Up Groups For Distribution(Item).';
         END IF;    
       END LOOP;  
     END LOOP;
  END IF;     
  --check for records in giuw_witemperilds for each item_no in giuw_witemds	
  --get all peril_cd from table gipi_itmperil for 
  --each item_no retrieved in giuw_witemds       	    
  FOR PERL IN (SELECT peril_cd, item_no
                 FROM gipi_itmperil	b380
                WHERE policy_id = p_policy_id)                           
               --   AND item_no   = item.item_no)
  LOOP                
    --check if there are records in giuw_witemperilds for 
    --every record in gipi_itmperil 	               
    v_hdr_sw := 'N';
    FOR A IN (SELECT '1'
                FROM giuw_witemperilds c060
               WHERE c060.dist_no = p_dist_no
               --  AND c060.dist_seq_no = seq.dist_seq_no
                 AND c060.item_no    = perl.item_no
                 AND c060.peril_cd   = perl.peril_cd)
    LOOP 	
      v_hdr_sw := 'Y';
      v_dtl_sw := 'N';
      --check if there are records corresponding records in giuw_witemperilds_dtl		
      -- for every record in giuw_witemperilds	
      FOR B IN (SELECT '1'
                  FROM giuw_witemperilds_dtl c070
  	               WHERE c070.dist_no = p_dist_no
                 --    AND c070.dist_seq_no = seq.dist_seq_no
  	                 AND c070.item_no = perl.item_no
  	                 AND c070.peril_cd = perl.peril_cd)
      LOOP            
        v_dtl_sw := 'Y';
  	    EXIT;
      END LOOP;	 
      IF v_dtl_sw = 'N' THEN
         p_message := 'There was an error encountered in distribution records, '||
                   'to correct this error please recreate using ' ||
                   'Set-Up Groups For Distribution(Item).';
      END IF;             
    END LOOP;
    IF v_hdr_sw = 'N' THEN
    	 p_message := 'There was an error encountered in distribution records, '||
                 'to correct this error please recreate using ' ||
  	             'Set-Up Groups For Distribution(Item).';
    END IF;	  
  END LOOP;
  IF v_hdr_sw = 'N' THEN
     p_message := 'There was an error encountered in distribution records, '||
               'to correct this error please recreate using ' ||
               'Set-Up Groups For Distribution(Item).';
  END IF;
    --  END LOOP;
  --END LOOP;
  --get all combination of dist_no, dist_seq_no and peril_cd from giuw_wwitemperilds
  FOR perl IN(SELECT DISTINCT c060.peril_cd peril_cd, c060.dist_seq_no
                FROM giuw_witemperilds c060
               WHERE c060.dist_no = p_dist_no)
  LOOP
    v_hdr_sw := 'N';     
    --check if there are records in giuw_wperilds for every combination
    --of peril, dist_no and dist_seq_no	
    FOR A IN (SELECT c090.dist_no, c090.dist_seq_no, c090.peril_cd
                FROM giuw_wperilds c090
               WHERE c090.dist_no     = p_dist_no
                 AND c090.dist_seq_no = perl.dist_seq_no
                 AND c090.peril_cd     = perl.peril_cd)
    LOOP 	
      v_hdr_sw := 'Y';
  	  v_dtl_sw := 'N';
  	  --check if there are records corresponding records in giuw_wperilds_dtl		
  	  -- for every record in giuw_wperilds	
  	  FOR B IN (SELECT '1'
  	              FROM giuw_wperilds_dtl c100
  	             WHERE c100.dist_no = a.dist_no
  	               AND c100.dist_seq_no = a.dist_seq_no
  	               AND c100.peril_cd = a.peril_cd)
  	  LOOP            
  		  v_dtl_sw := 'Y';
  		  EXIT;
  	  END LOOP;	 
  	  IF v_dtl_sw = 'N' THEN
         p_message := 'There was an error encountered in distribution records, '||
                   'to correct this error please recreate using ' ||
     	             'Set-Up Groups For Distribution(Item).';
   	  END IF;
    END LOOP;
    IF v_hdr_sw = 'N' THEN
       p_message := 'There was an error encountered in distribution records, '||
                 'to correct this error please recreate using ' ||
  	             'Set-Up Groups For Distribution(Item).';
    END IF;
  END LOOP;  
END VALIDATE_EXISTING_DIST_REC;
/


