DROP PROCEDURE CPI.CREATE_GRP_DFLT_DIST_GIUWS018;

CREATE OR REPLACE PROCEDURE CPI.CREATE_GRP_DFLT_DIST_GIUWS018
        (p_dist_no        IN giuw_wpolicyds.dist_no%TYPE,
         p_dist_seq_no    IN giuw_wpolicyds.dist_seq_no%TYPE,
         p_dist_flag      IN giuw_wpolicyds.dist_flag%TYPE,
         p_policy_tsi     IN giuw_wpolicyds.tsi_amt%TYPE,
         p_policy_premium IN giuw_wpolicyds.prem_amt%TYPE,
         p_policy_ann_tsi IN giuw_wpolicyds.ann_tsi_amt%TYPE,
         p_item_grp       IN giuw_wpolicyds.item_grp%TYPE,
         p_line_cd        IN giis_line.line_cd%TYPE,
         p_rg_count       IN OUT NUMBER,
         p_default_type   IN giis_default_dist.default_type%TYPE,
         p_currency_rt    IN gipi_item.currency_rt%TYPE,
         p_policy_id      IN gipi_polbasic.policy_id%TYPE,
         p_default_no     in giis_default_dist.default_no%TYPE) IS
         
         v_peril_cd          giis_peril.peril_cd%TYPE;
         v_peril_tsi         giuw_wperilds.tsi_amt%TYPE      := 0;
         v_peril_premium     giuw_wperilds.prem_amt%TYPE     := 0;
         v_peril_ann_tsi     giuw_wperilds.ann_tsi_amt%TYPE  := 0;
         v_exist             VARCHAR2(1)                     := 'N';
         v_insert_sw         VARCHAR2(1)                     := 'N';
         v_dist_flag         gipi_polbasic.dist_flag%TYPE;
         dist_cnt            NUMBER;
         dist_max            giuw_pol_dist.dist_no%type;
         v_tsi_amt           giuw_pol_dist.tsi_amt%type;
         v_prem_amt          giuw_pol_dist.prem_amt%type;
         v_ann_tsi_amt       giuw_pol_dist.ann_tsi_amt%type;
         v_exist2            VARCHAR2(1)                     := 'N';
    
  /* Updates the amounts of the previously processed PERIL_CD
  ** while looping inside cursor C3.  After which, the records
  ** for table GIUW_WPERILDS_DTL are also created.
  ** NOTE:  This is a LOCAL PROCEDURE BODY called below. */
  PROCEDURE  UPD_CREATE_WPERIL_DTL_DATA IS

  BEGIN

    UPDATE giuw_wperilds
       SET tsi_amt     = v_peril_tsi     ,
           prem_amt    = v_peril_premium ,
           ann_tsi_amt = v_peril_ann_tsi
     WHERE peril_cd    = v_peril_cd
       AND line_cd     = p_line_cd
       AND dist_seq_no = p_dist_seq_no
       AND dist_no     = p_dist_no;

    CREATE_GRP_DFLT_WPERILDS
      (p_dist_no       , p_dist_seq_no , p_line_cd       ,
       v_peril_cd      , v_peril_tsi   , v_peril_premium ,
       v_peril_ann_tsi , p_rg_count    , p_default_no);
  END;
  
  BEGIN

        SELECT count(*), max(dist_no)
          INTO dist_cnt, dist_max
          FROM giuw_pol_dist
         WHERE policy_id = p_policy_id
           AND item_grp = p_item_grp; 
        
        IF dist_cnt = 0 AND dist_max IS NULL THEN
            SELECT count(*), max(dist_no)
              INTO dist_cnt, dist_max
              FROM giuw_pol_dist
             WHERE policy_id = p_policy_id
               AND item_grp IS NULL
               AND DIST_FLAG NOT IN (3,4,5);--VJP 041210
        END IF;
        
      /* Create records in table GIUW_WPOLICYDS and GIUW_WPOLICYDS_DTL for the specified DIST_SEQ_NO. */
        IF p_dist_no = dist_max THEN
             FOR x IN (SELECT SUM(NVL(DECODE(c.peril_type,'B',a.tsi_amt,0),0)) tsi_amt, 
                              SUM(NVL(a.prem_amt,0) - (ROUND((NVL(a.prem_amt,0)/dist_cnt),2) * (dist_cnt - 1))) prem_amt, 
                              SUM(NVL(DECODE(c.peril_type,'B',a.ann_tsi_amt,0),0)) ann_tsi_amt
                         FROM gipi_itmperil a, gipi_item b, giis_peril c
                        WHERE a.policy_id = b.policy_id
                          AND a.item_no   = b.item_no
                          AND a.policy_id = p_policy_id
                          AND b.item_grp  = p_item_grp
                          AND a.peril_cd  = c.peril_cd
                          AND c.line_cd   = p_line_cd)
             LOOP
                  v_tsi_amt        := x.tsi_amt;
                  v_prem_amt       := x.prem_amt;
                  v_ann_tsi_amt    := x.ann_tsi_amt;
             END LOOP;
             
        ELSE
            FOR x IN (SELECT SUM(ROUND((NVL(DECODE(c.peril_type,'B',a.tsi_amt,0),0)),2)) tsi_amt, 
                             SUM(ROUND((NVL(a.prem_amt,0)/dist_cnt),2)) prem_amt, 
                             SUM(ROUND((NVL(DECODE(c.peril_type,'B',a.ann_tsi_amt,0),0)),2)) ann_tsi_amt
                        FROM gipi_itmperil a, gipi_item b, giis_peril c
                       WHERE a.policy_id = b.policy_id
                         AND a.item_no   = b.item_no
                         AND a.policy_id = p_policy_id
                         AND b.item_grp  = p_item_grp
                         AND a.peril_cd  = c.peril_cd
                         AND c.line_cd   = p_line_cd)
            LOOP
                 v_tsi_amt       := x.tsi_amt;
                 v_prem_amt      := x.prem_amt;
                 v_ann_tsi_amt   := x.ann_tsi_amt;
            END LOOP;
        END IF;
      ----------------------------------------
       INSERT INTO  giuw_wpolicyds
            (dist_no  ,dist_seq_no  , dist_flag    ,
            tsi_amt   ,prem_amt     , ann_tsi_amt  ,
            item_grp)
       VALUES 
           (p_dist_no , p_dist_seq_no , p_dist_flag   ,
            v_tsi_amt , v_prem_amt    , v_ann_tsi_amt ,
            p_item_grp);

       GIUW_POL_DIST_FINAL_PKG.CRTE_GRP_DFLT_WPOLICYDS_GWS010
        (p_dist_no    , p_dist_seq_no    , p_line_cd        ,
         v_tsi_amt    , v_prem_amt       , v_ann_tsi_amt    ,
         p_rg_count   , p_default_type   , p_currency_rt    ,
         p_policy_id  , p_item_grp       , p_default_no);

       /* Get the amounts for each item in table GIPI_ITEM in preparation
       ** for data insertion to its corresponding distribution tables. */
       
       FOR a IN (SELECT dist_flag
                   FROM giuw_pol_dist
                  WHERE policy_id = (SELECT policy_id
                                       FROM giuw_pol_dist
                                      WHERE dist_no = p_dist_no)
                    AND dist_flag = 5) 
       LOOP
          v_dist_flag := a.dist_flag;                              
       END LOOP;
      
       IF v_dist_flag = 5 THEN
          FOR c2 IN (SELECT c.item_no, a.tsi_amt , (a.prem_amt - SUM(c.dist_prem)) prem_amt , a.ann_tsi_amt
                       FROM gipi_item a, giuw_itemperilds_dtl c
                      WHERE EXISTS( SELECT '1'
                                      FROM gipi_itmperil b
                                     WHERE b.policy_id = a.policy_id
                                       AND b.item_no   = a.item_no)
                                       AND a.item_no     = c.item_no
                                       AND a.item_grp    = p_item_grp
                                       AND a.policy_id   = p_policy_id
                                       AND c.dist_seq_no = p_dist_seq_no
                                       AND c.dist_no IN (SELECT dist_no
                                                           FROM giuw_pol_dist
                                                          WHERE policy_id = p_policy_id
                                                            AND dist_flag IN (2,3))
                   GROUP BY c.item_no, a.tsi_amt, a.prem_amt, a.ann_tsi_amt)
          LOOP
            /* Create records in table GIUW_WITEMDS and GIUW_WITEMDS_DTL
            ** for the specified DIST_SEQ_NO. */
            INSERT INTO  giuw_witemds
                (dist_no   , dist_seq_no   , item_no    ,
                 tsi_amt   , prem_amt      , ann_tsi_amt)
            VALUES 
                (p_dist_no , p_dist_seq_no , c2.item_no ,
                 c2.tsi_amt , c2.prem_amt  , c2.ann_tsi_amt);
            
            CREATE_GRP_DFLT_WITEMDS
            (p_dist_no      , p_dist_seq_no , c2.item_no  ,
             p_line_cd      , c2.tsi_amt    , c2.prem_amt ,
             c2.ann_tsi_amt , p_rg_count    , p_default_no);

          END LOOP;

          /* Initialize the value of the variables
          ** in preparation for processing the new
          ** DIST_SEQ_NO. */
          v_peril_cd      := NULL;
          v_peril_tsi     := 0;
          v_peril_premium := 0;
          v_peril_ann_tsi := 0;   
          v_exist         := 'N';

          /* Get the amounts for each combination of the ITEM_NO and the PERIL_CD
          ** in table GIPI_ITMPERIL in preparation for data insertion to 
          ** distribution tables GIUW_WITEMPERILDS, GIUW_WITEMPERILDS_DTL,
          ** GIUW_WPERILDS and GIUW_WPERILDS_DTL. */
          FOR c3 IN (SELECT B380.tsi_amt      itmperil_tsi                                               ,
                           (B380.prem_amt - SUM(c150.dist_prem)) itmperil_premium ,
                            B380.ann_tsi_amt  itmperil_ann_tsi                                           ,
                            B380.item_no      item_no                                                    ,
                            B380.peril_cd     peril_cd                                                          
                       FROM gipi_itmperil B380, gipi_item B340, giuw_itemperilds_dtl C150
                      WHERE B380.item_no     = B340.item_no
                        AND B380.policy_id   = B340.policy_id
                        AND B340.item_no     = C150.item_no
                        AND B380.peril_cd    = C150.peril_cd
                        AND B380.line_cd     = C150.line_cd
                        AND B340.policy_id   = p_policy_id
                        AND C150.dist_seq_no = p_dist_seq_no
                        AND B340.item_grp       = p_item_grp
                        AND C150.dist_no IN (SELECT dist_no
                                               FROM giuw_pol_dist
                                              WHERE policy_id = p_policy_id
                                                AND dist_flag IN (2,3))
                   GROUP BY B380.tsi_amt, B380.ann_tsi_amt, B380.item_no, B380.peril_cd, B380.prem_amt
                   ORDER BY B380.peril_cd)
          LOOP
            v_exist     := 'Y';

            /* Create records in table GIUW_WITEMPERILDS and GIUW_WITEMPERILDS_DTL
            ** for the specified DIST_SEQ_NO. */
            INSERT INTO  giuw_witemperilds  
                (dist_no             , dist_seq_no   , item_no         ,
                 peril_cd            , line_cd       , tsi_amt         ,
                 prem_amt            , ann_tsi_amt)
            VALUES 
               (p_dist_no           , p_dist_seq_no , c3.item_no      ,
                c3.peril_cd         , p_line_cd     , c3.itmperil_tsi , 
                c3.itmperil_premium , c3.itmperil_ann_tsi);
        
            CREATE_GRP_DFLT_WITEMPERILDS
               (p_dist_no           , p_dist_seq_no       , c3.item_no      ,
                p_line_cd           , c3.peril_cd         , c3.itmperil_tsi ,
                c3.itmperil_premium , c3.itmperil_ann_tsi , p_rg_count      ,
                p_default_no);

            /* Create the newly processed PERIL_CD in table
            ** GIUW_WPERILDS. */
            IF v_peril_cd IS NULL THEN
               v_peril_cd     := c3.peril_cd;
               v_insert_sw    := 'Y';
            END IF;

            /* Check if the value of the previously processed
            ** PERIL_CD is equal to the one currently processed.
            ** Should the two be unequal, then the amounts of
            ** the previously processed PERIL_CD must be updated
            ** to reflect the true value of each field for the
            ** specified PERIL_CD.  After the amounts of the specified
            ** PERIL_CD have been updated, then that's the time to
            ** create the records in table GIUW_WPERILDS_DTL.
            ** On the other hand, if the value of the two PERIL_CDs
            ** are equal, then the amounts of the currently processed
            ** record is added along with the amounts of the previously
            ** processed records of the same PERIL_CD.  Such amounts
            ** shall be used later on when the two PERIL_CDs become
            ** unequal. */
            IF v_peril_cd != c3.peril_cd THEN

              /* Updates the amounts of the previously processed PERIL_CD.
              ** After which, the records for table GIUW_WPERILDS_DTL are
              ** also created. */
              UPD_CREATE_WPERIL_DTL_DATA;

              /* Assigns the new PERIL_CD to the V_PERIL_CD
              ** variable in preparation for data creation
              ** in table GIUW_WPERILDS. */
              v_peril_cd      := c3.peril_cd;
              v_peril_tsi     := c3.itmperil_tsi;
              v_peril_premium := c3.itmperil_premium;
              v_peril_ann_tsi := c3.itmperil_ann_tsi;
              v_insert_sw     := 'Y';

            ELSIF v_peril_cd = c3.peril_cd THEN
               v_peril_tsi     := v_peril_tsi     + c3.itmperil_tsi;
               v_peril_premium := v_peril_premium + c3.itmperil_premium;
               v_peril_ann_tsi := v_peril_ann_tsi + c3.itmperil_ann_tsi;
            END IF;
            
            IF v_insert_sw = 'Y' THEN
               INSERT INTO  giuw_wperilds  
                  (dist_no   , dist_seq_no   , peril_cd         ,
                   line_cd   , tsi_amt       , prem_amt         ,
                   ann_tsi_amt)
               VALUES 
                 (p_dist_no , p_dist_seq_no , v_peril_cd       ,
                  p_line_cd , v_peril_tsi   , v_peril_premium  ,
                  v_peril_ann_tsi);
               
               v_insert_sw     := 'N';
            END IF;
          END LOOP;
          
          IF v_exist = 'Y' THEN
             /* Updates the amounts of the last processed PERIL_CD.
             ** After which, its corresponding records for table 
             ** GIUW_WPERILDS_DTL are also created.
             ** NOTE:  This was done so, because the last processed
             **        PERIL_CD is no longer handled by the C3 loop. */
             UPD_CREATE_WPERIL_DTL_DATA;
          END IF;

      ELSE -- dist_flag
            /* Create records in table GIUW_WITEMDS and GIUW_WITEMDS_DTL for the specified DIST_SEQ_NO. */
          FOR c2 IN (SELECT a.item_no     , a.tsi_amt , a.prem_amt ,a.ann_tsi_amt
                       FROM gipi_item a
                      WHERE exists(SELECT '1'
                                     FROM gipi_itmperil b
                                    WHERE b.policy_id = a.policy_id
                                      AND b.item_no = a.item_no)
                        AND a.item_grp  = p_item_grp
                        AND a.policy_id = p_policy_id)
          LOOP
              IF p_dist_no = dist_max THEN
                  FOR x IN (SELECT SUM(NVL(DECODE(c.peril_type,'B',a.tsi_amt,0),0)  /*beth - (ROUND((NVL(DECODE(c.peril_type,'B',a.tsi_amt,0),0)/dist_cnt),2) * (dist_cnt - 1))*/) tsi_amt, 
                                   SUM(NVL(a.prem_amt,0) - (ROUND((NVL(a.prem_amt,0)/dist_cnt),2) * (dist_cnt - 1))) prem_amt, 
                                   SUM(NVL(DECODE(c.peril_type,'B',a.ann_tsi_amt,0),0) /*beth- (ROUND((NVL(DECODE(c.peril_type,'B',a.ann_tsi_amt,0),0)/dist_cnt),2) * (dist_cnt - 1))*/) ann_tsi_amt
                              FROM gipi_itmperil a, gipi_item b, giis_peril c
                             WHERE a.policy_id  = b.policy_id
                               AND a.item_no = b.item_no
                               AND a.policy_id  = p_policy_id
                               AND a.item_no = c2.item_no
                               AND a.peril_cd  = c.peril_cd
                               AND c.line_cd   = p_line_cd)
                   LOOP
                       v_tsi_amt            := x.tsi_amt;
                       v_prem_amt        := x.prem_amt;
                       v_ann_tsi_amt    := x.ann_tsi_amt;
                   END LOOP;
              ELSE
                   FOR x IN (SELECT SUM(ROUND((NVL(DECODE(c.peril_type,'B',a.tsi_amt,0),0)/*beth/dist_cnt*/),2)) tsi_amt, 
                                    SUM(ROUND((NVL(a.prem_amt,0)/dist_cnt),2)) prem_amt, 
                                    SUM(ROUND((NVL(DECODE(c.peril_type,'B',a.ann_tsi_amt,0),0)/*beth/dist_cnt*/),2)) ann_tsi_amt
                               FROM gipi_itmperil a, gipi_item b, giis_peril c
                              WHERE a.policy_id  = b.policy_id
                                AND a.item_no = b.item_no
                                AND a.policy_id  = p_policy_id
                                AND a.item_no = c2.item_no
                                AND a.peril_cd = c.peril_cd
                                AND c.line_cd = p_line_cd)
                   LOOP
                       v_tsi_amt     := x.tsi_amt;
                       v_prem_amt     := x.prem_amt;
                       v_ann_tsi_amt := x.ann_tsi_amt;
                   END LOOP;
              END IF;
          
              INSERT INTO  giuw_witemds
                (dist_no        , dist_seq_no   , item_no        ,
                 tsi_amt        , prem_amt      , ann_tsi_amt)
              VALUES 
                (p_dist_no      , p_dist_seq_no , c2.item_no     ,
                 v_tsi_amt      , v_prem_amt    , v_ann_tsi_amt );

              CREATE_GRP_DFLT_WITEMDS
                (p_dist_no      , p_dist_seq_no , c2.item_no  ,
                 p_line_cd      , v_tsi_amt     , v_prem_amt  ,
                 v_ann_tsi_amt  ,p_rg_count     , p_default_no);
          END LOOP;

        /* Initialize the value of the variables
        ** in preparation for processing the new
        ** DIST_SEQ_NO. */
        v_peril_cd      := NULL;
        v_peril_tsi     := 0;
        v_peril_premium := 0;
        v_peril_ann_tsi := 0;   
        v_exist         := 'N';

        /* Get the amounts for each combination of the ITEM_NO and the PERIL_CD
        ** in table GIPI_ITMPERIL in preparation for data insertion to 
        ** distribution tables GIUW_WITEMPERILDS, GIUW_WITEMPERILDS_DTL,
        ** GIUW_WPERILDS and GIUW_WPERILDS_DTL. */
        FOR c3 IN (SELECT B380.tsi_amt     itmperil_tsi     ,
                          B380.prem_amt    itmperil_premium ,
                          B380.ann_tsi_amt itmperil_ann_tsi ,
                          B380.item_no     item_no          ,
                          B380.peril_cd    peril_cd
                     FROM gipi_itmperil B380, gipi_item B340
                    WHERE B380.item_no   = B340.item_no
                      AND B380.policy_id = B340.policy_id
                      AND B340.item_grp  = p_item_grp
                      AND B340.policy_id = p_policy_id
                 ORDER BY B380.peril_cd)
        LOOP
          v_exist     := 'Y';
                
                IF p_dist_no = dist_max THEN
                    v_tsi_amt        := NVL(c3.itmperil_tsi,0)     /*beth- (ROUND((NVL(c3.itmperil_tsi,0)/dist_cnt),2) * (dist_cnt - 1))*/;
                    v_prem_amt       := NVL(c3.itmperil_premium,0) - (ROUND((NVL(c3.itmperil_premium,0)/dist_cnt),2) * (dist_cnt - 1));
                    v_ann_tsi_amt    := NVL(c3.itmperil_ann_tsi,0) /*beth- (ROUND((NVL(c3.itmperil_ann_tsi,0)/dist_cnt),2) * (dist_cnt - 1))*/;
                ELSE
                    v_tsi_amt        := ROUND((NVL(c3.itmperil_tsi,0)    /*beth/dist_cnt*/),2);
                    v_prem_amt       := ROUND((NVL(c3.itmperil_premium,0)/dist_cnt),2);
                    v_ann_tsi_amt    := ROUND((NVL(c3.itmperil_ann_tsi,0)/*beth/dist_cnt*/),2);
                END IF;
          /* Create records in table GIUW_WITEMPERILDS and GIUW_WITEMPERILDS_DTL
          ** for the specified DIST_SEQ_NO. */
          INSERT INTO  giuw_witemperilds  
            (dist_no             , dist_seq_no   , item_no         ,
             peril_cd            , line_cd       , tsi_amt         ,
             prem_amt            , ann_tsi_amt)
          VALUES 
            (p_dist_no           , p_dist_seq_no , c3.item_no      ,
             c3.peril_cd         , p_line_cd     , v_tsi_amt       ,
             v_prem_amt          , v_ann_tsi_amt );
                             
          CREATE_GRP_DFLT_WITEMPERILDS
            (p_dist_no           , p_dist_seq_no       , c3.item_no      ,
             p_line_cd           , c3.peril_cd         , v_tsi_amt       ,
             v_prem_amt          , v_ann_tsi_amt       ,p_rg_count       ,
             p_default_no);
        END LOOP;

            /* Create the newly processed PERIL_CD in table GIUW_WPERILDS. */
        FOR c4 IN (SELECT B380.tsi_amt     itmperil_tsi     ,
                          B380.prem_amt    itmperil_premium ,
                          B380.ann_tsi_amt itmperil_ann_tsi ,
                          B380.peril_cd    peril_cd
                     FROM gipi_itmperil B380, gipi_item B340
                    WHERE B380.item_no   = B340.item_no
                      AND B380.policy_id = B340.policy_id
                      AND B340.item_grp  = p_item_grp
                      AND B340.policy_id = p_policy_id
                    ORDER BY B380.peril_cd)
            LOOP       
              IF p_dist_no = dist_max THEN
                c4.itmperil_tsi      := NVL(c4.itmperil_tsi,0)     /*beth- (ROUND((NVL(c4.itmperil_tsi,0)/dist_cnt),2) * (dist_cnt - 1))*/;
                c4.itmperil_premium     := NVL(c4.itmperil_premium,0) - (ROUND((NVL(c4.itmperil_premium,0)/dist_cnt),2) * (dist_cnt - 1));
                c4.itmperil_ann_tsi  := NVL(c4.itmperil_ann_tsi,0) /*beth- (ROUND((NVL(c4.itmperil_ann_tsi,0)/dist_cnt),2) * (dist_cnt - 1))*/;
              ELSE
                c4.itmperil_tsi      := c4.itmperil_tsi /*beth/ dist_cnt*/;
                c4.itmperil_premium  := c4.itmperil_premium / dist_cnt;
                c4.itmperil_ann_tsi  := c4.itmperil_ann_tsi /*beth/ dist_cnt*/;
              END IF;
              
              FOR x IN (SELECT '1' 
                          FROM giuw_wperilds
                         WHERE dist_no = p_dist_no
                           AND dist_seq_no = p_dist_seq_no
                           AND peril_cd = c4.peril_cd)
              LOOP
                  v_exist2 := 'Y';
                  EXIT;
              END LOOP;
              
              IF v_exist2 = 'N' THEN
                  INSERT INTO giuw_wperilds  
                        (dist_no   , dist_seq_no   , peril_cd         ,
                         line_cd   , tsi_amt       , prem_amt         ,
                         ann_tsi_amt)
                  VALUES 
                        (p_dist_no , p_dist_seq_no , c4.peril_cd       ,
                         p_line_cd , c4.itmperil_tsi   , c4.itmperil_premium  ,
                         c4.itmperil_ann_tsi);          
              END IF;
              
              v_peril_cd         := c4.peril_cd;
              v_peril_tsi        := c4.itmperil_tsi;
              v_peril_premium    := c4.itmperil_premium;
              v_peril_ann_tsi    := c4.itmperil_ann_tsi;

              UPD_CREATE_WPERIL_DTL_DATA;                   
            END LOOP;
       END IF;
  END;
/


