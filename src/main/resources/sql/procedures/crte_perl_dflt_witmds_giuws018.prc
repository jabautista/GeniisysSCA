DROP PROCEDURE CPI.CRTE_PERL_DFLT_WITMDS_GIUWS018;

CREATE OR REPLACE PROCEDURE CPI.CRTE_PERL_DFLT_WITMDS_GiUWS018(p_dist_no     IN giuw_pol_dist.dist_no%TYPE,
                                    p_dist_seq_no IN giuw_wpolicyds.dist_seq_no%TYPE) IS
  v_dist_spct            giuw_witemds_dtl.dist_spct%TYPE;
  v_ann_dist_spct               giuw_witemds_dtl.ann_dist_spct%TYPE;
  v_allied_dist_prem            giuw_witemds_dtl.dist_prem%TYPE;
  v_dist_prem                   giuw_witemds_dtl.dist_prem%TYPE;
BEGIN
  FOR c1 IN (  SELECT line_cd     line_cd      ,
                      item_no     item_no      ,
                      share_cd    share_cd     ,
                      dist_grp    dist_grp
                 FROM giuw_witemperilds_dtl
                WHERE dist_no     = p_dist_no
                  AND dist_seq_no = p_dist_seq_no
             GROUP BY item_no, line_cd, share_cd, dist_grp)
  LOOP
    FOR c2 IN (  SELECT SUM(DECODE(A170.peril_type, 'B', 
                                   a.dist_tsi, 0))        dist_tsi     ,
                        SUM(a.dist_prem)                  dist_prem    ,
                        SUM(DECODE(A170.peril_type, 'B',
                                   a.ann_dist_tsi, 0))    ann_dist_tsi
                   FROM giuw_witemperilds_dtl a, giis_peril A170
                  WHERE A170.peril_cd   = a.peril_cd
                    AND A170.line_cd    = a.line_cd
                    AND a.dist_grp      = c1.dist_grp
                    AND a.share_cd      = c1.share_cd
                    AND a.line_cd       = c1.line_cd
                    AND a.item_no       = c1.item_no
                    AND a.dist_seq_no   = p_dist_seq_no                    
                    AND a.dist_no       = p_dist_no)
    LOOP
      FOR c3 IN (SELECT tsi_amt , prem_amt    , ann_tsi_amt ,
                        item_no
                   FROM giuw_witemds
                  WHERE item_no     = c1.item_no
                    AND dist_seq_no = p_dist_seq_no
                    AND dist_no     = p_dist_no)
      LOOP

        /* Divide the individual TSI/Premium with the total TSI/Premium
        ** and multiply it by 100 to arrive at the correct percentage for
        ** the breakdown. */
        IF c3.tsi_amt != 0 THEN
           v_dist_spct  := ROUND(c2.dist_tsi/c3.tsi_amt, 9) * 100;
        ELSE
           v_dist_spct  := ROUND(c2.dist_prem/c3.prem_amt, 9) * 100;
        END IF;
        IF c3.ann_tsi_amt != 0 THEN
           v_ann_dist_spct := ROUND(c2.ann_dist_tsi/c3.ann_tsi_amt, 9) * 100;
        ELSE
             v_ann_dist_spct := v_dist_spct;
        END IF;      

        INSERT INTO  giuw_witemds_dtl
                    (dist_no         , dist_seq_no   , item_no         ,
                     line_cd         , share_cd      , dist_spct       ,
                     dist_tsi        , dist_prem     , ann_dist_spct   ,
                     ann_dist_tsi    , dist_grp)
             VALUES (p_dist_no       , p_dist_seq_no , c3.item_no      , 
                     c1.line_cd      , c1.share_cd   , v_dist_spct     ,
                     c2.dist_tsi     , c2.dist_prem  , v_ann_dist_spct ,
                     c2.ann_dist_tsi , c1.dist_grp);
      END LOOP;
      EXIT;
    END LOOP;
  END LOOP;
END;
/


