CREATE OR REPLACE PROCEDURE CPI.CREATE_PERIL_DFLT_WPOLICYDS(
	   	  		  			          p_dist_no     IN giuw_pol_dist.dist_no%TYPE,
                                      p_dist_seq_no IN giuw_wpolicyds.dist_seq_no%TYPE) IS
  v_dist_spct			giuw_wpolicyds_dtl.dist_spct%type;
  v_dist_spct1			giuw_wpolicyds_dtl.dist_spct1%type;
  v_ann_dist_spct       giuw_wpolicyds_dtl.ann_dist_spct%type;
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : April 05, 2010 
  **  Reference By : (GIPIS055 - POST PAR) 
  **  Description  : CREATE_PERIL_DFLT_WPOLICYDS program unit 
  */
  
  FOR c1 IN (  SELECT SUM(dist_tsi)     dist_tsi     ,
                      SUM(dist_prem)    dist_prem    ,
                      SUM(ann_dist_tsi) ann_dist_tsi ,
                      line_cd           line_cd      ,
                      share_cd          share_cd     ,
                      dist_grp          dist_grp,
                      dist_spct1
                 FROM giuw_witemds_dtl
                WHERE dist_no     = p_dist_no
                  AND dist_seq_no = p_dist_seq_no
             GROUP BY line_cd, share_cd, dist_grp, dist_spct1)
  LOOP
    FOR c2 IN (SELECT tsi_amt , prem_amt , ann_tsi_amt
                 FROM giuw_wpolicyds
                WHERE dist_seq_no = p_dist_seq_no
                  AND dist_no     = p_dist_no)
    LOOP

      /* Divide the individual TSI with the total TSI and multiply
      ** it by 100 to arrive at the correct percentage for the
      ** breakdown. */
      IF c2.tsi_amt != 0 THEN
         v_dist_spct     := ROUND(c1.dist_tsi/c2.tsi_amt, 9) * 100;
      ELSE
        IF c2.prem_amt != 0 THEN
          v_dist_spct     := ROUND(c1.dist_prem/c2.prem_amt, 9) * 100;
        ELSE
          v_dist_spct     := ROUND(c1.dist_prem/1, 9) * 100;
        END IF;         
      END IF;
      
      IF NVL(c1.dist_spct1, 0) <> 0 
      THEN
        IF c2.prem_amt != 0 THEN
          v_dist_spct1 := ROUND(c1.dist_prem/c2.prem_amt, 9) * 100;
        ELSE
          v_dist_spct1 := ROUND(c1.dist_prem/1, 9) * 100;
        END IF;        
      END IF;
      
      IF c2.ann_tsi_amt != 0 THEN
        v_ann_dist_spct := ROUND(c1.ann_dist_tsi/c2.ann_tsi_amt, 9) * 100;
      ELSE
        v_ann_dist_spct := 0;
      END IF; 
      INSERT INTO  giuw_wpolicyds_dtl
                  (dist_no         , dist_seq_no     , line_cd          ,
                   share_cd        , dist_spct       , dist_tsi         ,
                   dist_prem       , ann_dist_spct   , ann_dist_tsi     ,
                   dist_grp, dist_spct1)
           VALUES (p_dist_no       , p_dist_seq_no   , c1.line_cd       ,
                   c1.share_cd     , v_dist_spct     , c1.dist_tsi      ,
                   c1.dist_prem    , v_ann_dist_spct , c1.ann_dist_tsi  ,
                   c1.dist_grp, v_dist_spct1);
    END LOOP;
  END LOOP;
END; 
/

