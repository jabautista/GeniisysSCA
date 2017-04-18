DROP PROCEDURE CPI.DELETE_DIST_WORK_TABLES;

CREATE OR REPLACE PROCEDURE CPI.DELETE_DIST_WORK_TABLES (p_par_id GIPI_WITEM.par_id%TYPE) AS

  /*
  **  Created by :       Veronica V. Raymundo
  **  Date Created:      10.22.2010
  **  Reference By:     (GIPIS025 - Bill Grouping)
  **  Description:      Delete existing records related to the current PAR_ID from the 
  **                    distribution and RI working tables.
  **                    Distribution tables affected:
  **                            GIUW_WPERILDS  and DTL, GIUW_WITEMPERILDS and DTL, GIUW_WITEMDS and DTL
  **                           ,and GIUW_WPOLICYDS and DTL.
  **                    RI tables affected:
  **                           GIRI_WBINDER_PERIL, GIRI_WBINDER, GIRI_WFRPERIL, GIRI_WFRPS_RI and
  **                           GIRI_WDISTFRPS
  */

BEGIN
FOR c1 IN (SELECT dist_no
               FROM giuw_pol_dist
              WHERE dist_flag IN ('1','2')
                AND par_id = p_par_id)
  LOOP
    DELETE giuw_wperilds_dtl
     WHERE dist_no = c1.dist_no;
    DELETE giuw_wperilds
     WHERE dist_no = c1.dist_no;
    DELETE giuw_witemperilds_dtl
     WHERE dist_no = c1.dist_no;
    DELETE giuw_witemperilds
     WHERE dist_no = c1.dist_no;
    DELETE giuw_witemds_dtl
     WHERE dist_no = c1.dist_no;
    DELETE giuw_witemds
     WHERE dist_no = c1.dist_no;
    DELETE giuw_wpolicyds_dtl
     WHERE dist_no = c1.dist_no;
    FOR c2 IN (SELECT frps_yy, frps_seq_no
                 FROM giri_wdistfrps
                WHERE dist_no = c1.dist_no)
    LOOP
      FOR c3 IN (SELECT pre_binder_id
                   FROM giri_wfrps_ri
                  WHERE frps_yy     = c2.frps_yy 
                    AND frps_seq_no = c2.frps_seq_no) 
      LOOP
        DELETE giri_wbinder_peril
         WHERE pre_binder_id = c3.pre_binder_id; 
        DELETE giri_wbinder
         WHERE pre_binder_id = c3.pre_binder_id;
      END LOOP;
      DELETE giri_wfrperil
       WHERE frps_yy     = c2.frps_yy
         AND frps_seq_no = c2.frps_seq_no;
      DELETE giri_wfrps_ri
       WHERE frps_yy     = c2.frps_yy
         AND frps_seq_no = c2.frps_seq_no;
    END LOOP;
    DELETE giri_wdistfrps
     WHERE dist_no = c1.dist_no;
    DELETE giuw_wpolicyds
     WHERE dist_no = c1.dist_no;
  END LOOP;
   
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
       
END DELETE_DIST_WORK_TABLES;
/


