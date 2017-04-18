CREATE OR REPLACE PACKAGE BODY CPI.dist_by_peril AS
/* Author: Udel
** UW-SPECS-2011-00040
** (Special Distribution)
*/
PROCEDURE create_wdist(p_line_cd        IN  VARCHAR2,
                       p_dist_no        IN  VARCHAR2) IS
    v_spec_dist_sw  giis_line.special_dist_sw%TYPE;
BEGIN
/* This procedure will act as the 'main' procedure in
** using the Special Distribution enhancement.
** Other procedures of this package can't be used without
** calling this one.
*/
    BEGIN
    SELECT special_dist_sw
      INTO v_spec_dist_sw
      FROM giis_line
     WHERE line_cd = p_line_cd;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        v_spec_dist_sw := 'N';
    END;
    
    IF v_spec_dist_sw = 'Y' AND giisp.v('ENABLE_SPECIAL_DIST') = 'Y' THEN
        
        v_dist_no  := p_dist_no;
        v_line_cd  := p_line_cd;

        /* call package procedures that will update dist tables */
        upd_witemperilds_dtl;
        
        recompute_tsi(v_dist_no);
        
        upd_witemds_dtl;
        
        upd_wpolicyds_dtl;
    END IF;
END create_wdist;
PROCEDURE upd_witemperilds_dtl IS
    v_net_ret_exists BOOLEAN := FALSE;
    
    v_dist_tsi            giuw_witemperilds_dtl.dist_tsi%type;
      v_dist_prem                   giuw_witemperilds_dtl.dist_prem%type;  
      v_ann_dist_tsi                giuw_witemperilds_dtl.ann_dist_tsi%type;
BEGIN
    /* Update the table GIUW_WITEMPERILDS_DTL */
    
    -- This will loop through treaty records in table GIUW_WITEMPERILDS_DTL
    -- with peril codes not belong to that treaty.
    -- Their share percentage, premium amount, and tsi amount will be
    -- added to a existing record for NET RETENTION, if it exists. If not,
    -- will create one.
    FOR nat_perils IN (SELECT a.dist_no ,a.dist_seq_no ,a.item_no ,a.line_cd ,a.peril_cd ,a.share_cd
                             ,a.dist_spct ,a.dist_tsi ,a.dist_prem ,a.ann_dist_spct ,a.ann_dist_tsi
                         FROM giuw_witemperilds_dtl a, giis_dist_share b
                        WHERE 1=1
                          AND a.peril_cd NOT IN (SELECT peril_cd
                                                   FROM giis_trty_peril
                                                  WHERE line_cd = a.line_cd
                                                    AND trty_seq_no = a.share_cd)
                          AND a.line_cd = b.line_cd
                          and a.share_cd = b.share_cd
                          and a.dist_no = v_dist_no
                          AND b.share_type =2)
    LOOP
        v_net_ret_exists := FALSE;
        -- Check muna kung may NET RETENTION share.
        -- Kung meron, proceed sa pag-update. Kung wala, insert ng bagong record for NET RETENTION
        FOR m IN (SELECT 1
                    FROM giuw_witemperilds_dtl
                   WHERE dist_no      = nat_perils.dist_no
                     AND dist_seq_no  = nat_perils.dist_seq_no
                     AND item_no      = nat_perils.item_no
                     AND line_cd      = nat_perils.line_cd
                     AND peril_cd     = nat_perils.peril_cd
                     AND share_cd     = 1)
        LOOP
            v_net_ret_exists := TRUE;
            EXIT;
        END LOOP;
        
        IF v_net_ret_exists THEN
            UPDATE  giuw_witemperilds_dtl
               SET  dist_spct       = dist_spct     + nat_perils.dist_spct
                   ,dist_tsi        = dist_tsi      + nat_perils.dist_tsi
                   ,dist_prem       = dist_prem     + nat_perils.dist_prem
                   ,ann_dist_spct   = ann_dist_spct + nat_perils.ann_dist_spct
                   ,ann_dist_tsi    = ann_dist_tsi  + nat_perils.ann_dist_tsi
             WHERE dist_no      = nat_perils.dist_no
               AND dist_seq_no  = nat_perils.dist_seq_no
               AND item_no      = nat_perils.item_no
               AND line_cd      = nat_perils.line_cd
               AND peril_cd     = nat_perils.peril_cd
               AND share_cd     = 1;
        ELSE
            INSERT INTO giuw_witemperilds_dtl 
                        (dist_no         ,dist_seq_no    ,item_no
                        ,line_cd         ,peril_cd       ,share_cd
                        ,dist_spct       ,dist_tsi       ,dist_prem
                        ,ann_dist_spct   ,ann_dist_tsi   ,dist_grp)
                 VALUES (nat_perils.dist_no         ,nat_perils.dist_seq_no     ,nat_perils.item_no
                        ,nat_perils.line_cd         ,nat_perils.peril_cd        ,1
                        ,nat_perils.dist_spct       ,nat_perils.dist_tsi        ,nat_perils.dist_prem
                        ,nat_perils.ann_dist_spct   ,nat_perils.ann_dist_tsi    ,1);
        END IF;
               
           
        DELETE FROM giuw_witemperilds_dtl
         WHERE dist_no      = nat_perils.dist_no
           AND dist_seq_no  = nat_perils.dist_seq_no
           AND item_no      = nat_perils.item_no
           AND line_cd      = nat_perils.line_cd
           AND peril_cd     = nat_perils.peril_cd
           AND share_cd     = nat_perils.share_cd;
    END LOOP; /* End update GIUW_WITEMPERILDS_DTL */
    
    
    /* Update the table GIUW_WPERILDS_DTL */
    -- The same as in updating table giuw_witemperilds_dtl,
    -- but it's the table GIUW_WPERILDS_DTL that's being updated.
    FOR nat_perils IN (SELECT a.dist_no ,a.dist_seq_no ,a.line_cd ,a.peril_cd ,a.share_cd
                             ,a.dist_spct ,a.dist_tsi ,a.dist_prem ,a.ann_dist_spct ,a.ann_dist_tsi
                         FROM giuw_wperilds_dtl a, giis_dist_share b
                        WHERE 1=1
                          AND a.peril_cd NOT IN (SELECT peril_cd
                                                   FROM giis_trty_peril
                                                  WHERE line_cd     = a.line_cd
                                                    AND trty_seq_no = a.share_cd)
                          AND a.line_cd     = b.line_cd
                          and a.share_cd    = b.share_cd
                          and a.dist_no     = v_dist_no
                          AND b.share_type  = 2)
    LOOP
        v_net_ret_exists := FALSE;
        -- Check muna kung may NET RETENTION share.
        -- Kung meron, proceed sa pag-update. Kung wala, insert ng bagong record for NET RETENTION
        FOR m IN (SELECT 1
                    FROM giuw_wperilds_dtl
                   WHERE dist_no      = nat_perils.dist_no
                     AND dist_seq_no  = nat_perils.dist_seq_no
                     AND line_cd      = nat_perils.line_cd
                     AND peril_cd     = nat_perils.peril_cd
                     AND share_cd     = 1)
        LOOP
            v_net_ret_exists := TRUE;
            EXIT;
        END LOOP;
        
        IF v_net_ret_exists THEN
            UPDATE  giuw_wperilds_dtl
               SET  dist_spct       = dist_spct     + nat_perils.dist_spct
                   ,dist_tsi        = dist_tsi      + nat_perils.dist_tsi
                   ,dist_prem       = dist_prem     + nat_perils.dist_prem
                   ,ann_dist_spct   = ann_dist_spct + nat_perils.ann_dist_spct
                   ,ann_dist_tsi    = ann_dist_tsi  + nat_perils.ann_dist_tsi
             WHERE dist_no      = nat_perils.dist_no
               AND dist_seq_no  = nat_perils.dist_seq_no
               AND line_cd      = nat_perils.line_cd
               AND peril_cd     = nat_perils.peril_cd
               AND share_cd     = 1;
        ELSE
            INSERT INTO giuw_wperilds_dtl 
                        (dist_no         ,dist_seq_no    ,line_cd
                        ,peril_cd        ,share_cd       ,dist_spct
                        ,dist_tsi        ,dist_prem      ,ann_dist_spct
                        ,ann_dist_tsi    ,dist_grp)
                 VALUES (nat_perils.dist_no         ,nat_perils.dist_seq_no     ,nat_perils.line_cd
                        ,nat_perils.peril_cd        ,1                          ,nat_perils.dist_spct
                        ,nat_perils.dist_tsi        ,nat_perils.dist_prem       ,nat_perils.ann_dist_spct
                        ,nat_perils.ann_dist_tsi    ,1);
        END IF;
           
        DELETE FROM giuw_wperilds_dtl
         WHERE dist_no      = nat_perils.dist_no
           and dist_seq_no  = nat_perils.dist_seq_no
           and line_cd      = nat_perils.line_cd
           and peril_cd     = nat_perils.peril_cd
           and share_cd     = nat_perils.share_cd;
    END LOOP; /* End update GIUW_WPERILDS_DTL */
EXCEPTION
WHEN OTHERS THEN
    raise_application_error(-20100,'An error occured.'||chr(13)||sqlerrm);
END upd_witemperilds_dtl;
PROCEDURE upd_witemds_dtl IS
/* Modified by Udel 01202012
** Ignore the occurence of illegal distribution
**   if parameter ALLOW_DIFF_SHARE_DIST is set to Y.
*/
    v_dist_prem         giuw_witemds_dtl.dist_prem%TYPE;
    v_share_cd_exists   BOOLEAN := FALSE;
    v_dist_spct         giuw_witemds_dtl.dist_spct%TYPE;
    v_ann_dist_spct     giuw_witemds_dtl.ann_dist_spct%TYPE;
    v_par_type          gipi_parlist.par_type%TYPE;
    CURSOR il_dist IS
        SELECT DISTINCT share_cd
          FROM giuw_witemperilds_dtl
         WHERE dist_no = v_dist_no
        MINUS
        SELECT DISTINCT share_cd
          FROM giuw_witemperilds_dtl
         WHERE dist_no = v_dist_no
           AND peril_cd IN (SELECT peril_cd
                              FROM giis_peril
                             WHERE peril_type   = 'B'
                               AND line_cd      = v_line_cd);

BEGIN
    
    -- Check first if there is any illegal distribution
    -- occured when updating table GIUW_WITEMPERILDS_DTL
    FOR m IN il_dist
    LOOP
        IF NVL(giisp.v('ALLOW_DIFF_SHARE_DIST'), 'N') = 'N' THEN -- Udel 01202012
          RAISE_APPLICATION_ERROR(-20201, 'Illegal distribution occured.');
        ELSE
            /* added by cherrie | 03292012
             * to add share_cd of allied peril that is not in the basic peril/s 
             */
            FOR c IN ( SELECT  dist_no ,dist_seq_no 
                               ,item_no ,line_cd ,share_cd
                         FROM giuw_witemperilds_dtl a
                        WHERE 1=1
                          AND dist_no  = v_dist_no
                          AND share_cd = m.share_cd
                        GROUP BY share_cd, item_No, dist_no, dist_seq_no, line_cd )
             LOOP
                FOR basic IN (SELECT DISTINCT peril_cd
                                      FROM giuw_witemperilds_dtl
                                     WHERE dist_no = v_dist_no
                                       AND peril_cd IN (SELECT peril_cd
                                                          FROM giis_peril
                                                         WHERE peril_type   = 'B'
                                                           AND line_cd      = 'FI'))
                LOOP
                    INSERT INTO giuw_witemperilds_dtl
                                (dist_no, dist_seq_no,
                                 item_no, line_cd,
                                 peril_cd, share_cd, dist_spct,
                                 dist_tsi, dist_prem,
                                 ann_dist_spct, ann_dist_tsi, dist_grp
                                 )
                         VALUES (c.dist_no, c.dist_seq_no,
                                 c.item_no, c.line_cd,
                                 basic.peril_cd, c.share_cd, 0,
                                 0, 0, 0, 0, 1
                                 );
                 END LOOP;            
              END LOOP;
              --end cherrie 03292012
        END IF;
    END LOOP;
    
    -- Delete records in GIUW_WITEMDS_DTL that do not exist in table GUIW_WITEMPERILDS_DTL
    -- (Just to be sure na malinis talaga ang giuw_witemds_dtl) 
    FOR obs_rec IN (SELECT dist_no, dist_seq_no, item_no, line_cd, share_cd
                      FROM giuw_witemds_dtl a
                     WHERE dist_no = v_dist_no
                       AND NOT EXISTS (SELECT DISTINCT 1 FROM giuw_witemperilds_dtl
                                        WHERE dist_no       = a.dist_no
                                          AND dist_seq_no   = a.dist_seq_no
                                          AND item_no       = a.item_No
                                          AND line_cd       = a.line_cd
                                          AND share_cd      = a.share_cd))
    LOOP
        DELETE FROM giuw_witemds_dtl
         WHERE dist_no      = obs_rec.dist_no
           AND dist_seq_no  = obs_rec.dist_seq_no
           AND item_no      = obs_rec.item_no
           AND line_cd      = obs_rec.line_cd
           AND share_cd     = obs_rec.share_cd;
    END LOOP;
    
    -- Udel 01052012 get par type
    SELECT par_type
      INTO v_par_type
      FROM gipi_parlist
     WHERE par_id IN (SELECT par_id
                        FROM giuw_pol_dist
                       WHERE dist_no = v_dist_no);
    
    -- This will loop through recomputed tsi amount, premium amount, and percentage share records
    -- for update of table GIUW_WITEMDS_DTL based on the updated giuw_witemperilds_dtl.
    FOR itmperl IN (SELECT  a.dist_no ,a.dist_seq_no ,a.item_no ,a.line_cd ,a.share_cd
                           ,b.tsi_amt
                           ,SUM(a.dist_spct) dist_spct
                           ,SUM(a.dist_tsi) dist_tsi
                           ,b.ann_tsi_amt 
                           ,SUM(a.ann_dist_tsi) ann_dist_tsi
                           ,b.prem_amt
                      FROM giuw_witemperilds_dtl a, giuw_witemds b
                     WHERE 1=1
                       and a.dist_no = b.dist_no
                       and a.dist_seq_no = b.dist_seq_no
                       and a.item_no = b.item_no
                       and a.dist_no  = v_dist_no
                       AND a.peril_cd IN (SELECT peril_cd
                                          FROM giis_peril
                                         WHERE peril_type   = 'B'
                                           AND line_cd      = v_line_cd)
                 GROUP BY a.share_cd, a.item_No, a.dist_no, a.dist_seq_no, a.line_cd, b.tsi_amt, b.ann_tsi_amt, b.prem_amt)
    LOOP
        -- Get computed premium amount for the current record.
        SELECT SUM(dist_prem)
          INTO v_dist_prem
          FROM giuw_witemperilds_dtl
         WHERE dist_no      = itmperl.dist_no
           AND dist_seq_no  = itmperl.dist_seq_no
           AND item_no      = itmperl.item_no
           AND line_cd      = itmperl.line_cd
           AND share_cd     = itmperl.share_cd;
        
        -- Get distribution percentage
        IF itmperl.tsi_amt != 0 THEN
           v_dist_spct     := ROUND(itmperl.dist_tsi/itmperl.tsi_amt, 14) * 100;--comment by VPS 010212,replaced by code below, this will resolve SR 8685
           --v_dist_spct     := ROUND(itmperl.dist_tsi/itmperl.tsi_amt, 9) * 100;
        ELSIF itmperl.prem_amt != 0 THEN
           IF v_par_type = 'E' THEN -- Udel 01052012 to handle endorsements with 0 TSI and premium
              v_dist_spct := itmperl.dist_spct;
           ELSE
              v_dist_spct     := ROUND(v_dist_prem/itmperl.prem_amt, 14) * 100;--comment by VPS 010212,replaced by code below, this will resolve SR 8685
              --v_dist_spct     := ROUND(v_dist_prem/itmperl.prem_amt, 9) * 100;
           END IF;
        ELSIF v_par_type = 'E' THEN
           v_dist_spct := itmperl.dist_spct;
        ELSE
           v_dist_spct := 0;
        END IF;
        IF itmperl.ann_tsi_amt != 0 THEN 
           v_ann_dist_spct := ROUND(itmperl.ann_dist_tsi/itmperl.ann_tsi_amt, 14) * 100;--comment by VPS 010212,replaced by code below, this will resolve SR 8685
           --v_ann_dist_spct := ROUND(itmperl.ann_dist_tsi/itmperl.ann_tsi_amt, 9) * 100;
        ELSE
           v_ann_dist_spct := 0;
        END IF;   
        
           
        -- Check if the corresponding record for giuw_witemperilds_dtl in table giuw_witemds_dtl exists.
        v_share_cd_exists := FALSE;
        FOR m IN (SELECT 1
                    FROM giuw_witemds_dtl
                   WHERE dist_no        = itmperl.dist_no
                     AND dist_seq_no    = itmperl.dist_seq_no
                     AND item_no        = itmperl.item_no
                     AND line_cd        = itmperl.line_cd
                     AND share_cd       = itmperl.share_cd)
        LOOP
            v_share_cd_exists := TRUE;
            EXIT;
        END LOOP;
        
        IF v_share_cd_exists THEN
            UPDATE giuw_witemds_dtl
               SET dist_spct        = v_dist_spct
                  ,dist_tsi         = itmperl.dist_tsi
                  ,dist_prem        = v_dist_prem
                  ,ann_dist_spct    = v_ann_dist_spct
                  ,ann_dist_tsi     = itmperl.ann_dist_tsi
             WHERE dist_no      = itmperl.dist_no
               AND dist_seq_no  = itmperl.dist_seq_no
               AND item_no      = itmperl.item_no
               AND line_cd      = itmperl.line_cd
               AND share_cd     = itmperl.share_cd;
        ELSIF NOT v_share_cd_exists AND itmperl.share_cd = 1 THEN
            -- Current record is for NET RETENTION and it doesn't exists in GIUW_WITEMDS_DTL 
            INSERT INTO giuw_witemds_dtl
                        (dist_no      ,dist_seq_no   ,item_no
                        ,line_cd      ,share_cd      ,dist_spct
                        ,dist_tsi     ,dist_prem     ,ann_dist_spct
                        ,ann_dist_tsi ,dist_grp)
                 VALUES (itmperl.dist_no      ,itmperl.dist_seq_no    ,itmperl.item_no
                        ,itmperl.line_cd      ,itmperl.share_cd       ,v_dist_spct
                        ,itmperl.dist_tsi     ,v_dist_prem            ,v_ann_dist_spct
                        ,itmperl.ann_dist_tsi ,1);
        ELSE
            --------------------------------------------------------------------------------------
            -- A record other than for NET RETENTION doesn't exists in GIUW_WITEMDS_DTL.
            -- Supposedly, ang kelangan lang i-insert is for NET RETENTION record
            -- since 'yun lang ang iniinsert sa giuw_witemperilds_dtl gamit ang package na 'to.
            -- Kung pumasok man dito, it means merong records na wala ang witemds_dtl
            -- na meron sa witemperilds_dtl other than NET RETENTION (share_cd = 1)
            --------------------------------------------------------------------------------------
            RAISE_APPLICATION_ERROR(-20202, 'Inconsistent distribution. Please recreate items.');
        END IF; 
    END LOOP;
END upd_witemds_dtl;
PROCEDURE upd_wpolicyds_dtl IS
    v_share_cd_exists   BOOLEAN := FALSE;
    v_dist_spct         NUMBER; --giuw_witemds_dtl.dist_spct%TYPE; --Udel 01202012 to fix ora 65502
    v_ann_dist_spct     giuw_witemds_dtl.ann_dist_spct%TYPE;
    v_par_type          gipi_parlist.par_type%TYPE;
BEGIN
    -- Delete records in GIUW_WPOLICYDS_DTL that do not exist in table GUIW_WITEMDS_DTL
    -- (Just to be sure na malinis talaga ang giuw_wpolicyds_dtl) 
    FOR obs_rec IN (SELECT dist_no, dist_seq_no, line_cd, share_cd
                      FROM giuw_wpolicyds_dtl a
                     WHERE dist_no = v_dist_no
                       AND NOT EXISTS (SELECT DISTINCT 1 FROM giuw_witemds_dtl
                                        WHERE dist_no       = a.dist_no
                                          AND dist_seq_no   = a.dist_seq_no
                                          AND line_cd       = a.line_cd
                                          AND share_cd      = a.share_cd))
    LOOP
        DELETE FROM giuw_wpolicyds_dtl
         WHERE dist_no      = obs_rec.dist_no
           AND dist_seq_no  = obs_rec.dist_seq_no
           AND line_cd      = obs_rec.line_cd
           AND share_cd     = obs_rec.share_cd;
    END LOOP;
    
    -- Udel 01052012 get par type
    SELECT par_type
      INTO v_par_type
      FROM gipi_parlist
     WHERE par_id IN (SELECT par_id
                        FROM giuw_pol_dist
                       WHERE dist_no = v_dist_no);
    
    -- Update the table GIUW_WPOLICYDS_DTL based on recomputed amounts on giuw_witemds_dtl
    FOR itm IN (SELECT a.dist_no ,a.dist_seq_no ,a.line_cd ,a.share_cd
                      ,b.tsi_amt --,a.dist_spct --SUM(a.dist_spct) dist_spct--vjps 01.30.2011 | commented by cherrie 03232012
                      ,SUM(a.dist_tsi) dist_tsi ,SUM(a.dist_prem) dist_prem
                      ,b.ann_tsi_amt
                      ,SUM(a.ann_dist_tsi) ann_dist_tsi
                      ,b.prem_amt
                  FROM giuw_witemds_dtl a, giuw_wpolicyds b
                 WHERE 1 = 1
                   AND a.dist_no       = b.dist_no
                   AND a.dist_seq_no   = b.dist_seq_no
                   AND a.dist_no       = v_dist_no
                 GROUP BY a.share_cd, a.dist_seq_no, a.line_cd, a.share_cd, a.dist_no, b.tsi_amt, b.ann_tsi_amt, b.prem_amt) --a.dist_spct,
    LOOP
        -- Get distribution percentage
        --added by cherrie | 03232012
        IF itm.tsi_amt != 0 OR itm.prem_amt != 0 THEN
           -- Added by Marvin 09272012 To handle ORA-01476: divisor is equal to zero
           IF itm.tsi_amt = 0 THEN
             v_dist_spct     := ROUND(itm.dist_prem/itm.prem_amt, 14) * 100;
           ELSIF itm.prem_amt = 0 THEN
             v_dist_spct     := ROUND(itm.dist_tsi/itm.tsi_amt, 14) * 100;
           END IF;
           -- End by Marvin 09272012
        ELSE
            v_dist_spct := 0;
        END IF;
        
        IF itm.ann_tsi_amt != 0 THEN 
           v_ann_dist_spct := ROUND(itm.ann_dist_tsi/itm.ann_tsi_amt, 14) * 100;
        ELSE   
           v_ann_dist_spct := 0;
        END IF;
        --end cherrie
        /* commented by cherrie | 03232012
        IF itm.tsi_amt != 0 THEN
           v_dist_spct     := ROUND(itm.dist_tsi/itm.tsi_amt, 14) * 100;--comment by VPS 010212,replaced by code below, this will resolve SR 8685
           --v_dist_spct     := ROUND(itm.dist_tsi/itm.tsi_amt, 9) * 100;
        ELSIF itm.prem_amt != 0 THEN
           IF v_par_type = 'E' THEN -- Udel 01052012 to handle endorsements with 0 TSI and premium
              v_dist_spct := itm.dist_spct;
           ELSE
              v_dist_spct     := ROUND(itm.dist_prem/itm.prem_amt, 14) * 100;--comment by VPS 010212,replaced by code below, this will resolve SR 8685
              --v_dist_spct     := ROUND(itm.dist_prem/itm.prem_amt, 9) * 100;
           END IF;
        ELSIF v_par_type = 'E' THEN
           v_dist_spct := itm.dist_spct;
        ELSE
           v_dist_spct := 0;
        END IF;
        IF itm.ann_tsi_amt != 0 THEN 
           v_ann_dist_spct := ROUND(itm.ann_dist_tsi/itm.ann_tsi_amt, 14) * 100;--comment by VPS 010212,replaced by code below, this will resolve SR 8685
           --v_ann_dist_spct := ROUND(itm.ann_dist_tsi/itm.ann_tsi_amt, 9) * 100;
        ELSE   
           v_ann_dist_spct := 0;
        END IF;
        */
        
        -- Check if the corresponding record for giuw_witemds_dtl in table giuw_wpolicyds_dtl exists.
        v_share_cd_exists := FALSE;
        FOR m IN (SELECT 1
                    FROM giuw_wpolicyds_dtl
                   WHERE dist_no        = itm.dist_no
                     AND dist_seq_no    = itm.dist_seq_no
                     AND line_cd        = itm.line_cd
                     AND share_cd       = itm.share_cd)
        LOOP
            v_share_cd_exists := TRUE;
            EXIT;
        END LOOP;
        
        IF v_share_cd_exists THEN
            UPDATE giuw_wpolicyds_dtl
               SET dist_spct        = v_dist_spct
                  ,dist_tsi         = itm.dist_tsi
                  ,dist_prem        = itm.dist_prem
                  ,ann_dist_spct    = v_ann_dist_spct
                  ,ann_dist_tsi     = itm.ann_dist_tsi
             WHERE dist_no      = itm.dist_no
               AND dist_seq_no  = itm.dist_seq_no
               AND line_cd      = itm.line_cd
               AND share_cd     = itm.share_cd;
        ELSIF NOT v_share_cd_exists AND itm.share_cd = 1 THEN
            -- Current record is for NET RETENTION and it doesn't exists in GIUW_WPOLICYDS_DTL 
            INSERT INTO giuw_wpolicyds_dtl
                        (dist_no      ,dist_seq_no   ,line_cd
                        ,share_cd     ,dist_spct     ,dist_tsi
                        ,dist_prem    ,ann_dist_spct ,ann_dist_tsi
                        ,dist_grp)
                 VALUES (itm.dist_no      ,itm.dist_seq_no  ,itm.line_cd
                        ,itm.share_cd     ,v_dist_spct      ,itm.dist_tsi
                        ,itm.dist_prem    ,v_ann_dist_spct  ,itm.ann_dist_tsi
                        ,1);
        ELSE
            -- A record other than for NET RETENTION doesn't exists in GIUW_WPOLICYDS_DTL.
            RAISE_APPLICATION_ERROR(-20301, 'Inconsistent distribution. Please recreate items.');
        END IF; 
    END LOOP;
END upd_wpolicyds_dtl;
PROCEDURE recompute_tsi(p_dist_no NUMBER) IS
BEGIN
    -- Adjust discrepancy per item, peril
    FOR proc IN 1..2 LOOP
    -- There are two procedures to be executed
    -- First is to check wether the sum of tsi amount in detail table
    -- is equal to tsi amount in master table
    -- Second is, if there is any discrepancy, the tsi amount of retention share
    -- will be adjusted to correct the tsi amount. 
        FOR aa IN (SELECT a.dist_no ,a.dist_seq_No ,a.item_No ,a.peril_cd ,a.line_cd ,tsi_amt 
                         ,SUM(dist_tsi) dist_tsi 
                     FROM giuw_witemperilds a, giuw_witemperilds_dtl b
                    WHERE a.dist_no     = p_dist_no
                      AND b.dist_no     = a.dist_no
                      AND b.dist_seq_no = a.dist_seq_no
                      AND b.item_No     = a.item_no
                      AND b.peril_cd    = a.peril_cd
                      AND b.line_cd     = a.line_cd
                    GROUP BY a.dist_no, a.dist_seq_No, a.item_No, a.peril_cd, a.line_cd, tsi_amt)
        LOOP
            IF aa.tsi_amt <> aa.dist_tsi THEN
                FOR discrep IN (SELECT tsi_amt*(dist_spct/100) dist_tsi ,dist_tsi old_tsi ,share_cd ,b.peril_cd
                                  FROM giuw_witemperilds a, giuw_witemperilds_dtl b
                                 WHERE 1=1
                                   AND b.dist_no        = a.dist_no
                                   AND b.dist_seq_no    = a.dist_seq_no
                                   AND b.item_No        = a.item_no
                                   AND b.peril_cd       = a.peril_cd
                                   AND b.line_cd        = a.line_cd
                                   AND b.dist_no        = aa.dist_no
                                   AND b.dist_seq_no    = aa.dist_seq_no
                                   AND b.item_No        = aa.item_no
                                   AND b.peril_cd       = aa.peril_cd
                                   AND b.line_cd        = aa.line_cd
                                   AND proc             = 1)
                LOOP
                    IF ABS(discrep.old_tsi - ROUND(discrep.dist_tsi)) > 0 AND 
                       ABS(discrep.old_tsi - ROUND(discrep.dist_tsi)) <> 0.01 THEN 
                        UPDATE giuw_witemperilds_dtl
                           SET dist_tsi = ROUND(discrep.dist_tsi, 2)
                         WHERE 1=1
                           AND dist_no      = aa.dist_no
                           AND dist_seq_no  = aa.dist_seq_no
                           AND item_No      = aa.item_no
                           AND peril_cd     = aa.peril_cd
                           AND line_cd      = aa.line_cd
                           AND share_cd     = discrep.share_cd;
                    END IF;
                END loop;
                    
                IF proc = 2 THEN
                    UPDATE giuw_witemperilds_dtl
                       SET dist_tsi = dist_tsi + (aa.tsi_amt-aa.dist_tsi)
                     WHERE 1=1
                       AND dist_no      = aa.dist_no
                       AND dist_seq_no  = aa.dist_seq_no
                       AND item_No      = aa.item_no
                       AND peril_cd     = aa.peril_cd
                       AND line_cd      = aa.line_cd
                       AND share_cd     = 1;
                END IF;
            END IF;
        END LOOP; 
    END LOOP;
END recompute_tsi;
END dist_by_peril;
/


