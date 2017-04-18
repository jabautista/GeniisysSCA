DROP PROCEDURE CPI.VALIDATE_EXISTING_WORKING_DIST;

CREATE OR REPLACE PROCEDURE CPI.VALIDATE_EXISTING_WORKING_DIST(
	   	  		  	p_dist_no 			IN  giuw_pol_dist.dist_no%TYPE,
					p_par_id		    IN  GIPI_PARLIST.par_id%TYPE,
					p_line_cd			IN  gipi_parlist.line_cd%TYPE,
					p_iss_cd			IN  gipi_wpolbas.iss_cd%TYPE
					) 
		IS
  v_hdr_sw   VARCHAR2(1); --field that used as a switch to determing if records rexist in header table
  v_dtl_sw   VARCHAR2(1); --field that used as a switch to determing if records rexist in header table
  v_subline_cd	gipi_wpolbas.subline_cd%TYPE;		
  v_pack		gipi_wpolbas.pack_pol_flag%TYPE;	
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : April 05, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : VALIDATE_EXISTING_WORKING_DIST program unit
  */
  FOR wpol IN (SELECT subline_cd, pack_pol_flag
  	  	   	     FROM gipi_wpolbas
				WHERE par_id = p_par_id)
  LOOP
    v_subline_cd := wpol.subline_cd;
	v_pack	 	 := wpol.pack_pol_flag;
  END LOOP;	
  
	v_hdr_sw := 'N';
  --check if there are records in giuw_wpolicyds
  FOR A IN (SELECT dist_no, dist_seq_no
              FROM giuw_wpolicyds
             WHERE dist_no = p_dist_no)
  LOOP 	
  	v_hdr_sw := 'Y';
  	v_dtl_sw := 'N';
  	--check if there are records corresponding records in giuw_wpolicyds_dtl		
  	-- for every record in giuw_wpolicyds	
  	FOR B IN (SELECT '1'
  	            FROM giuw_wpolicyds_dtl
  	           WHERE dist_no = a.dist_no
  	             AND dist_seq_no = a.dist_seq_no)
  	LOOP            
  		v_dtl_sw := 'Y';
  		EXIT;
  	END LOOP;	 
  	IF v_dtl_sw = 'N' THEN
  		 EXIT; 
  	END IF;
  END LOOP;
  IF v_hdr_sw = 'N' or v_dtl_sw = 'N' THEN  --records not existing
  	 --delete first all existing data in preliminary dist. table 
  	 DELETE_DIST_WORKING_TABLES(p_dist_no);                      
  	 --recreate data in preliminary dist. table 
     CREATE_PAR_DISTRIBUTION_RECS
     (p_dist_no    , p_par_id , p_line_cd , 
     v_subline_cd , p_iss_cd , v_pack);
  ELSE
 	   v_hdr_sw := 'N';
     --check if there are records in giuw_witemds
     FOR A IN (SELECT dist_no, dist_seq_no, item_no
                 FROM giuw_witemds
                WHERE dist_no = p_dist_no)
     LOOP 	
  	   v_hdr_sw := 'Y';
  	   v_dtl_sw := 'N';
  	   --check if there are records corresponding records in giuw_witemds_dtl		
  	   -- for every record in giuw_witemds	
  	   FOR B IN (SELECT '1'
  	               FROM giuw_witemds_dtl
  	              WHERE dist_no = a.dist_no
  	                AND dist_seq_no = a.dist_seq_no
  	                AND item_no = a.item_no)
  	   LOOP            
  		   v_dtl_sw := 'Y';
  		   EXIT;
  	   END LOOP;	 
  	   IF v_dtl_sw = 'N' THEN
  	      EXIT;
  	   END IF;
     END LOOP;
     IF v_hdr_sw = 'N' or v_dtl_sw = 'N' THEN --records not existing
  	    --delete first all existing data in preliminary dist. table 
  	    DELETE_DIST_WORKING_TABLES(p_dist_no);                      
  	    --recreate data in preliminary dist. table 
        CREATE_PAR_DISTRIBUTION_RECS
        (p_dist_no    , p_par_id , p_line_cd , 
        v_subline_cd , p_iss_cd , v_pack);
     ELSE
        v_hdr_sw := 'N';
        --check if there are records in giuw_witemperilds
        FOR A IN (SELECT t1.dist_no, t1.dist_seq_no, t1.item_no, t1.peril_cd
                    FROM giuw_witemperilds t1
                   WHERE t1.dist_no  = p_dist_no)
        LOOP 	
  	      v_hdr_sw := 'Y';
  	      v_dtl_sw := 'N';
  	      --check if there are records corresponding records in giuw_witemperilds_dtl		
  	      -- for every record in giuw_witemperilds	
  	      FOR B IN (SELECT '1'
  	                  FROM giuw_witemperilds_dtl
  	                 WHERE dist_no = a.dist_no
        	             AND dist_seq_no = a.dist_seq_no
  	                   AND item_no = a.item_no
  	                   AND peril_cd = a.peril_cd)
  	      LOOP            
  		      v_dtl_sw := 'Y';
  		      EXIT;
  	      END LOOP;	 
  	      IF v_dtl_sw = 'N' THEN
  	         EXIT;
  	      END IF;
        END LOOP;
        IF v_hdr_sw = 'N' or v_dtl_sw = 'N' THEN--records not existing
  	      --delete first all existing data in preliminary dist. table 
  	      DELETE_DIST_WORKING_TABLES(p_dist_no);                      
  	      --recreate data in preliminary dist. table 
          CREATE_PAR_DISTRIBUTION_RECS
          (p_dist_no    , p_par_id , p_line_cd , 
          v_subline_cd , p_iss_cd , v_pack);
        ELSE
           v_hdr_sw := 'N';
           --check if there are records in giuw_wperilds
           FOR A IN (SELECT t1.dist_no, t1.dist_seq_no, t1.peril_cd
                       FROM giuw_wperilds t1
                      WHERE t1.dist_no  = p_dist_no)
           LOOP 	
  	         v_hdr_sw := 'Y';
  	         v_dtl_sw := 'N';
  	         --check if there are records corresponding records in giuw_wperilds_dtl		
  	         -- for every record in giuw_wperilds	
  	         FOR B IN (SELECT '1'
  	                     FROM giuw_wperilds_dtl
  	                    WHERE dist_no = a.dist_no
  	                      AND dist_seq_no = a.dist_seq_no
  	                      AND peril_cd = a.peril_cd)
  	         LOOP            
  		         v_dtl_sw := 'Y';
  		         EXIT;
  	         END LOOP;	 
  	         IF v_dtl_sw = 'N' THEN
  	            EXIT;
  	         END IF;
           END LOOP;
           IF v_hdr_sw = 'N' or v_dtl_sw = 'N' THEN --records not existing
  	          --delete first all existing data in preliminary dist. table 
  	          DELETE_DIST_WORKING_TABLES(p_dist_no);                      
  	          --recreate data in preliminary dist. table 
              CREATE_PAR_DISTRIBUTION_RECS
              (p_dist_no    , p_par_id , p_line_cd , 
              v_subline_cd , p_iss_cd , v_pack);
           END IF;
        END IF;   
     END IF; 
  END IF;
END;
/


