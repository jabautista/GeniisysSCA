DROP PROCEDURE CPI.DELETE_DIST_WORKING_TABLES_2;

CREATE OR REPLACE PROCEDURE CPI.DELETE_DIST_WORKING_TABLES_2
(p_dist_no       IN      GIUW_POL_DIST.dist_no%TYPE,
 p_par_type      IN      GIPI_PARLIST.par_type%TYPE,
 p_pol_flag      IN      GIPI_POLBASIC.pol_flag%TYPE) 
 
IS

/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 2, 2011
**  Reference By : GIUWS016 - One-Risk Distribution by TSI/Prem (Group)
**  Description  : Delete existing records related to the current DIST_NO from the 
**                 distribution and RI working tables.
**                 Distribution tables affected:
**                      GIUW_WPERILDS  and DTL, GIUW_WITEMPERILDS and DTL, GIUW_WITEMDS and DTL
**      				,and GIUW_WPOLICYDS and DTL.
** 				   RI tables affected:
**      				GIRI_WBINDER_PERIL, GIRI_WBINDER, GIRI_WFRPERIL, GIRI_WFRPS_RI and
**      				GIRI_WDISTFRPS
*/

  v_dist_no            GIUW_POL_DIST.dist_no%TYPE;

BEGIN
  v_dist_no := p_dist_no;
  DELETE GIUW_WPERILDS_DTL
   WHERE dist_no = v_dist_no;
  DELETE GIUW_WPERILDS
   WHERE dist_no = v_dist_no;
  DELETE GIUW_WITEMPERILDS_DTL
   WHERE dist_no = v_dist_no;
  DELETE GIUW_WITEMPERILDS
   WHERE dist_no = v_dist_no;
  DELETE GIUW_WITEMDS_DTL
   WHERE dist_no = v_dist_no;
   
  IF p_par_type='E' OR p_pol_flag='2' THEN
       NULL;
  ELSE      
     DELETE GIUW_WITEMDS
       WHERE dist_no = v_dist_no;
  END IF;
  
  DELETE GIUW_WPOLICYDS_DTL
   WHERE dist_no = v_dist_no;
  FOR c1 IN (SELECT frps_yy, frps_seq_no
               FROM GIRI_WDISTFRPS
              WHERE dist_no = v_dist_no)
  LOOP
    FOR c2 IN (SELECT pre_binder_id
                 FROM GIRI_WFRPS_RI
                WHERE frps_yy     = c1.frps_yy 
                  AND frps_seq_no = c1.frps_seq_no) 
    LOOP
      DELETE GIRI_WBINDER_PERIL
       WHERE pre_binder_id = c2.pre_binder_id; 
      DELETE GIRI_WBINDER
       WHERE pre_binder_id = c2.pre_binder_id;
    END LOOP;
    
    DELETE GIRI_WFRPERIL
     WHERE frps_yy     = c1.frps_yy
       AND frps_seq_no = c1.frps_seq_no;
    DELETE GIRI_WFRPS_RI
     WHERE frps_yy     = c1.frps_yy
       AND frps_seq_no = c1.frps_seq_no;
       
  END LOOP;
  
  DELETE GIRI_WDISTFRPS
   WHERE dist_no = v_dist_no;
  
  IF p_par_type='E' OR p_pol_flag='2' THEN
       NULL;
  ELSE      
       DELETE GIUW_WPOLICYDS
         WHERE dist_no = v_dist_no;
  END IF;
    
END;
/


