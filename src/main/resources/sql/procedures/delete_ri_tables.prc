DROP PROCEDURE CPI.DELETE_RI_TABLES;

CREATE OR REPLACE PROCEDURE CPI.DELETE_RI_TABLES(p_dist_no     IN giuw_wpolicyds.dist_no%TYPE,
                           p_dist_seq_no IN giuw_wpolicyds.dist_seq_no%TYPE) IS
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : April 05, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : DELETE_RI_TABLES program unit
  */
  
  FOR c1 IN (SELECT frps_yy, frps_seq_no, line_cd /* jhing 12.12.2014 added line_cd */
               FROM giri_wdistfrps
              WHERE dist_seq_no = p_dist_seq_no
                AND dist_no     = p_dist_no)
  LOOP
    FOR c2 IN (SELECT pre_binder_id
                 FROM giri_wfrps_ri
                WHERE frps_seq_no = c1.frps_seq_no
                  AND frps_yy     = c1.frps_yy
                  AND line_cd     = c1.line_cd /* jhing 12.12.2014 */ ) 
    LOOP
      DELETE giri_wbinder_peril
       WHERE pre_binder_id = c2.pre_binder_id; 
      DELETE giri_wbinder
       WHERE pre_binder_id = c2.pre_binder_id;
    END LOOP;
    DELETE giri_wfrperil
     WHERE frps_seq_no = c1.frps_seq_no
       AND frps_yy     = c1.frps_yy
       AND line_cd     = c1.line_cd /* jhing 12.12.2014 */ ;
    DELETE giri_wfrps_ri
     WHERE frps_seq_no = c1.frps_seq_no
       AND frps_yy     = c1.frps_yy
       AND line_cd     = c1.line_cd /* jhing 12.12.2014 */;
       
    -- jhing 12.12.2014 added code to delete giri_wfrps_peril_grp  
     DELETE giri_wfrps_peril_grp
     WHERE frps_seq_no = c1.frps_seq_no
       AND frps_yy     = c1.frps_yy
       AND line_cd     = c1.line_cd ;  
  END LOOP;
  DELETE giri_wdistfrps
   WHERE dist_seq_no = p_dist_seq_no
     AND dist_no     = p_dist_no;
END;
/


