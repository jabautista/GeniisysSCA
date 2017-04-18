DROP PROCEDURE CPI.GIUW016_CHK_IF_TO_RECRTE_DISTR;

CREATE OR REPLACE PROCEDURE CPI.GIUW016_CHK_IF_TO_RECRTE_DISTR
(p_dist_no           IN    GIUW_POL_DIST.dist_no%TYPE,
 p_par_type          IN    GIPI_POLBASIC_POL_DIST_V1.par_type%TYPE,
 p_pol_flag          IN    GIPI_POLBASIC_POL_DIST_V1.pol_flag%TYPE,
 wpolicyds_exist     OUT   VARCHAR2,
 wpolicyds_dtl_exist OUT   VARCHAR2)
 
IS

/*
**  Created by   : Veronica V. Raymundo
**  Date Created : July 29, 2011
**  Reference By : GIUWS016 - One-Risk Distribution TSI/Prem (Group)
**  Description  : Check for existence of records in giuw_wpolicyds
**                 and giuw_wpolicyds tables. If not existing, inform  
**                the user to re-create distribution records.
*/

  v_hdr_sw   VARCHAR2(1); 
  v_dtl_sw   VARCHAR2(1);
  
BEGIN
    v_hdr_sw := 'N';
    wpolicyds_exist     := 'Y';
    wpolicyds_dtl_exist := 'Y'; 

  --check if there are records in giuw_wpolicyds
  FOR A IN (SELECT dist_no, dist_seq_no
              FROM GIUW_WPOLICYDS
             WHERE dist_no = p_dist_no)
  LOOP     
      v_hdr_sw := 'Y';
      v_dtl_sw := 'N';
      
      --check if there are records corresponding records in giuw_wpolicyds_dtl        
      -- for every record in giuw_wpolicyds    
      FOR B IN (SELECT '1'
                  FROM GIUW_WPOLICYDS_DTL
                 WHERE dist_no = a.dist_no
                   AND dist_seq_no = a.dist_seq_no)
      LOOP            
          v_dtl_sw := 'Y';
          EXIT;
      END LOOP;
      
      
           
      IF v_dtl_sw = 'N' THEN
      
         IF p_par_type='E' OR p_pol_flag='2' THEN
              NULL;
         ELSE
              wpolicyds_exist     := 'Y';
              wpolicyds_dtl_exist := 'N';
              RETURN;
                           
                 /*MSG_ALERT('There was an error encountered in distribution records, '||
                   'to correct this error please recreate using ' ||
                   'Set-Up Groups For Distribution(Item).','I',FALSE);*/
         END IF;
         
      END IF;
  END LOOP;
  
  IF v_hdr_sw = 'N' THEN
     IF p_par_type='E' OR p_pol_flag='2' THEN
  	   	NULL;
     ELSE
        wpolicyds_exist     := 'N';
        wpolicyds_dtl_exist := 'N';
        RETURN;  	   	
     		/*MSG_ALERT('There was an error encountered in distribution records, '||
  	             'to correct this error please recreate using ' ||
  	             'Set-Up Groups For Distribution(Item).','I',FALSE);*/
     END IF;     
  END IF;
END;
/


