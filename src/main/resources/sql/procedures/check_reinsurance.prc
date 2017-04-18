DROP PROCEDURE CPI.CHECK_REINSURANCE;

CREATE OR REPLACE PROCEDURE CPI.check_reinsurance (
    p_dist_no  IN NUMBER,
    p_line_cd  IN VARCHAR2
    ) 
IS
  /*
  **  Created by   : Robert John Virrey
  **  Date Created : August 4, 2011
  **  Reference By : (GIUTS002 - Distribution Negation)
  **  Description  : Check RI records; if there are existing records in RI then
  **                 update their reverse dates to the current date.
  */
  v_param_value_n      giis_parameters.param_value_n%TYPE;
  v_dist_no            giuw_policyds_dtl.dist_no%TYPE;
  v_dist_seq_no        giuw_policyds_dtl.dist_seq_no%TYPE;
  v_line_cd            giuw_policyds_dtl.line_cd%TYPE;
  v_share_cd           giuw_policyds_dtl.share_cd%TYPE;
  v_frps_yy            giri_distfrps.frps_yy%TYPE;
  v_frps_seq_no        giri_distfrps.frps_seq_no%TYPE;
  v_fnl_binder_id      giri_frps_ri.fnl_binder_id%TYPE;
  v_fnl_binder_id1     giri_binder.fnl_binder_id%TYPE;
BEGIN
  FOR A1 IN (
  SELECT param_value_n
    FROM giis_parameters 
   WHERE param_name = 'FACULTATIVE') LOOP
    v_param_value_n  :=  A1.param_value_n;
    EXIT;
  END LOOP;
  IF v_param_value_n IS NOT NULL THEN
      FOR A2 IN (
       SELECT a.dist_no      dist_no,
              a.dist_seq_no  dist_seq_no,
              a.line_cd      line_cd,
              a.share_cd     share_cd
         FROM giuw_policyds_dtl a,giuw_policyds b
        WHERE a.dist_no     = b.dist_no
          AND a.dist_seq_no = b.dist_seq_no
          AND a.line_cd     = p_line_cd
          AND a.dist_no     = p_dist_no
          AND a.share_cd    = v_param_value_n) LOOP
         v_dist_no     :=  A2.dist_no;
         v_dist_seq_no :=  A2.dist_seq_no;
         v_line_cd     :=  A2.line_cd;
         v_share_cd    :=  A2.share_cd;
         FOR A3 IN (
              SELECT frps_yy,frps_seq_no
                FROM giri_distfrps
               WHERE dist_no     = v_dist_no
                 AND dist_seq_no = v_dist_seq_no) LOOP
                v_frps_yy      :=  A3.frps_yy;
                v_frps_seq_no  :=  A3.frps_seq_no;
              FOR A4 IN (
                   SELECT fnl_binder_id
                     FROM giri_frps_ri
                    WHERE frps_yy     = v_frps_yy
                      AND frps_seq_no = v_frps_seq_no 
                      AND line_cd     = v_line_cd
                   ) LOOP
                     v_fnl_binder_id   :=  A4.fnl_binder_id;
                   --ASI 051499 update reverse_date of binders which are not yet reversed
                   FOR A5 IN(SELECT '1'
                               FROM giri_binder
                              WHERE fnl_binder_id = v_fnl_binder_id
                                AND reverse_date IS NULL)LOOP 
                       UPDATE giri_binder
                          SET reverse_date = SYSDATE
                        WHERE fnl_binder_id = v_fnl_binder_id;
                       EXIT;
                   END LOOP;
              END LOOP;
          END LOOP;   
      END LOOP;   
  END IF;
END;
/


