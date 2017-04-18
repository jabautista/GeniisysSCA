DROP PROCEDURE CPI.CREATE_PERIL_DFLT_WPERILDS;

CREATE OR REPLACE PROCEDURE CPI.CREATE_PERIL_DFLT_WPERILDS
         (p_dist_no      IN giuw_wperilds_dtl.dist_no%TYPE      ,
          p_dist_seq_no  IN giuw_wperilds_dtl.dist_seq_no%TYPE  ,
          p_line_cd      IN giuw_wperilds_dtl.line_cd%TYPE      ,
          p_peril_cd     IN giuw_wperilds_dtl.peril_cd%TYPE     ,
          p_dist_tsi     IN giuw_wperilds_dtl.dist_tsi%TYPE     ,
          p_dist_prem    IN giuw_wperilds_dtl.dist_prem%TYPE    ,
          p_ann_dist_tsi IN giuw_wperilds_dtl.ann_dist_tsi%TYPE ,
          p_currency_rt  IN gipi_winvoice.currency_rt%TYPE      ,
          p_default_no   IN giis_default_dist.default_no%TYPE   ,
          p_default_type IN giis_default_dist.default_type%TYPE) IS

  v_dflt_dist_exist		VARCHAR2(1) := 'N';
  v_dist_spct			giuw_wperilds_dtl.dist_spct%TYPE;
--  v_dist_spct                   number;
  v_dist_tsi			giuw_wperilds_dtl.dist_tsi%TYPE;
  v_dist_prem			giuw_wperilds_dtl.dist_prem%TYPE;
  v_ann_dist_tsi		giuw_wperilds_dtl.ann_dist_tsi%TYPE;
  v_share_cd			giis_dist_share.share_cd%TYPE;
  v_sum_dist_tsi		giuw_wperilds_dtl.dist_tsi%TYPE     := 0;
  v_sum_dist_spct		giuw_wperilds_dtl.dist_spct%TYPE    := 0;
  v_sum_dist_prem		giuw_wperilds_dtl.dist_prem%TYPE    := 0;
  v_sum_ann_dist_tsi		giuw_wperilds_dtl.ann_dist_tsi%TYPE := 0;
  v_dist_spct_limit		NUMBER;
  v_remaining_tsi               NUMBER := p_dist_tsi * p_currency_rt;
  v_dist_spct1          giuw_wperilds_dtl.DIST_SPCT1%TYPE; --edgar 09/12/2014

  CURSOR dist_peril_cur IS
      SELECT a.share_cd , a.share_pct , a.share_amt1
        FROM giis_default_dist_peril a 
       WHERE a.default_no = p_default_no
         AND a.line_cd    = p_line_cd
         AND a.peril_cd   = p_peril_cd
         AND a.share_cd   <> 999
    ORDER BY a.sequence ASC;

  PROCEDURE INSERT_TO_WPERILDS_DTL IS
  BEGIN
    INSERT INTO  giuw_wperilds_dtl
                (dist_no     , dist_seq_no   , line_cd        ,
                 share_cd    , dist_spct     , dist_tsi       ,
                 dist_prem   , ann_dist_spct , ann_dist_tsi   ,
                 dist_grp    , peril_cd      , dist_spct1) --added dist_spct1 edgar 09/12/2014)
         VALUES (p_dist_no   , p_dist_seq_no , p_line_cd      ,
                 v_share_cd  , v_dist_spct   , v_dist_tsi     ,
                 v_dist_prem , v_dist_spct   , v_ann_dist_tsi ,
                 1           , p_peril_cd    , v_dist_spct1); --added dist_spct1 edgar 09/12/2014
    CREATE_PERIL_DFLT_WITEMPERILDS
          (p_dist_no  , p_dist_seq_no , p_line_cd   ,
           p_peril_cd , v_share_cd    , v_dist_spct ,  
           v_dist_spct, v_dist_spct1); --added dist_spct1 edgar 09/12/2014
  END;

BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : April 05, 2010 
  **  Reference By : (GIPIS055 - POST PAR) 
  **  Description  : CREATE_PERIL_DFLT_WPERILDS program unit 
  */

  /* Use AMOUNTS to create the default distribution records. */
  IF p_default_type = 1 THEN
     FOR c1 IN dist_peril_cur
     LOOP
       v_dflt_dist_exist := 'Y';
       IF v_remaining_tsi >= c1.share_amt1 THEN
          v_dist_tsi      := c1.share_amt1 / p_currency_rt;
          v_remaining_tsi := v_remaining_tsi - c1.share_amt1;
       ELSE
          v_remaining_tsi := 0;
       END IF;
       IF v_remaining_tsi != 0 THEN
          v_dist_spct        := ROUND(v_dist_tsi / p_dist_tsi * 100, 9);
          v_dist_tsi         := ROUND(p_dist_tsi     * v_dist_spct / 100, 2);
          v_dist_prem        := ROUND(p_dist_prem    * v_dist_spct / 100, 2);
          v_ann_dist_tsi     := ROUND(p_ann_dist_tsi * v_dist_spct / 100, 2);
          v_sum_dist_spct    := v_sum_dist_spct    + v_dist_spct;
          v_sum_dist_tsi     := v_sum_dist_tsi     + v_dist_tsi;
          v_sum_dist_prem    := v_sum_dist_prem    + v_dist_prem;
          v_sum_ann_dist_tsi := v_sum_ann_dist_tsi + v_ann_dist_tsi;
       ELSIF v_remaining_tsi = 0 THEN
          v_dist_spct    := 100            - v_sum_dist_spct;
          v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
          v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
          v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
       END IF;
       v_share_cd := c1.share_cd;
       INSERT_TO_WPERILDS_DTL;
       IF v_remaining_tsi = 0 THEN
          EXIT;
       END IF;
     END LOOP;
     IF v_remaining_tsi  != 0   AND
        v_dflt_dist_exist = 'Y' THEN
        v_dist_spct    := 100            - v_sum_dist_spct;
        v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
        v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
        v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
        v_share_cd     := '999';
        INSERT_TO_WPERILDS_DTL;

     END IF;

  /* Use PERCENTAGES to create the default distribution records. */
  ELSIF p_default_type = 2 THEN
     FOR c1 IN dist_peril_cur
     LOOP
       v_dflt_dist_exist := 'Y';
       v_dist_spct := c1.share_pct;
       IF c1.share_amt1 IS NOT NULL THEN
          v_dist_tsi        := c1.share_amt1 / p_currency_rt;
          IF p_dist_tsi != 0 THEN            
	     v_dist_spct_limit := ROUND(v_dist_tsi / p_dist_tsi * 100, 9);
          ELSE 
	     v_dist_spct_limit := 0;
          END IF;
          IF v_dist_spct_limit > 0 THEN 
             IF v_dist_spct > v_dist_spct_limit THEN 
                v_dist_spct := v_dist_spct_limit;
             END IF;
          END IF;
       END IF;
       v_sum_dist_spct := v_sum_dist_spct + v_dist_spct;

       IF v_sum_dist_spct != 100 THEN
          v_dist_tsi         := ROUND(p_dist_tsi         * v_dist_spct / 100, 2);
          v_dist_prem        := ROUND(p_dist_prem        * v_dist_spct / 100, 2);
          v_ann_dist_tsi     := ROUND(p_ann_dist_tsi     * v_dist_spct / 100, 2);
          v_sum_dist_tsi     := v_sum_dist_tsi     + v_dist_tsi;
          v_sum_dist_prem    := v_sum_dist_prem    + v_dist_prem;
          v_sum_ann_dist_tsi := v_sum_ann_dist_tsi + v_ann_dist_tsi;
       ELSE
          v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
          v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
          v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
       END IF;
       v_share_cd := c1.share_cd;
       INSERT_TO_WPERILDS_DTL;
     END LOOP;
     IF v_sum_dist_spct  != 100 AND
        v_dflt_dist_exist = 'Y' THEN
        v_dist_spct    := 100            - v_sum_dist_spct;
        v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
        v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
        v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
        v_share_cd     := '999';
        INSERT_TO_WPERILDS_DTL;
     END IF;
  END IF;

  /* If no default distribution record was found in table
  ** GIIS_DEFAULT_DIST_PERIL, then create the record using
  ** the traditional 100% NET RETENTION, 0% FACULTATIVE
  ** default. */
  IF v_dflt_dist_exist = 'N' THEN
     /* Create the default distribution records based on the 100%
     ** NET RETENTION and 0% FACULTATIVE hard code defaults. */
     v_share_cd     := 1;
     v_dist_spct    := 100;
     v_dist_tsi     := p_dist_tsi;
     v_dist_prem    := p_dist_prem;
     v_ann_dist_tsi := p_ann_dist_tsi;
     FOR c IN 1..2
     LOOP
       INSERT_TO_WPERILDS_DTL;
       v_share_cd     := 999;
       v_dist_spct    := 0;
       v_dist_tsi     := 0;
       v_dist_prem    := 0;
       v_ann_dist_tsi := 0;
     END LOOP;

  END IF;
END;
/


