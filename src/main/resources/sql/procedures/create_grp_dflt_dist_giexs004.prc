DROP PROCEDURE CPI.CREATE_GRP_DFLT_DIST_GIEXS004;

CREATE OR REPLACE PROCEDURE CPI.CREATE_GRP_DFLT_DIST_GIEXS004(
    p_dist_no        IN giuw_wpolicyds.dist_no%TYPE,
    p_dist_seq_no    IN giuw_wpolicyds.dist_seq_no%TYPE,
    p_dist_flag      IN giuw_wpolicyds.dist_flag%TYPE,
    p_policy_tsi     IN giuw_wpolicyds.tsi_amt%TYPE,
    p_policy_premium IN giuw_wpolicyds.prem_amt%TYPE,
    p_policy_ann_tsi IN giuw_wpolicyds.ann_tsi_amt%TYPE,
    p_item_grp       IN giuw_wpolicyds.item_grp%TYPE,
    p_line_cd        IN giis_line.line_cd%TYPE,
    p_rg_count       IN OUT NUMBER,
    p_default_type   IN giis_default_dist.default_type%TYPE,
    p_currency_rt    IN gipi_witem.currency_rt%TYPE,
    p_par_id         IN gipi_parlist.par_id%TYPE,
	p_v_default_no	 IN giis_default_dist.default_no%TYPE
) 
IS
  v_peril_cd         giis_peril.peril_cd%TYPE;
  v_peril_tsi        giuw_wperilds.tsi_amt%TYPE      := 0;
  v_peril_premium    giuw_wperilds.prem_amt%TYPE     := 0;
  v_peril_ann_tsi    giuw_wperilds.ann_tsi_amt%TYPE  := 0;
  v_exist            VARCHAR2(1)                     := 'N';
  v_insert_sw        VARCHAR2(1)                     := 'N';

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
           v_peril_ann_tsi , p_rg_count	   , p_v_default_no);
  END;

BEGIN

    /* Create records in table GIUW_WPOLICYDS and GIUW_WPOLICYDS_DTL
    ** for the specified DIST_SEQ_NO. */
    INSERT INTO  giuw_wpolicyds
                (dist_no      , dist_seq_no      , dist_flag        ,
                 tsi_amt      , prem_amt         , ann_tsi_amt      ,
                 item_grp)
         VALUES (p_dist_no    , p_dist_seq_no    , p_dist_flag      ,
                 p_policy_tsi , p_policy_premium , p_policy_ann_tsi ,
                 p_item_grp);
    CREATE_GRP_DFLT_WPOLICYDS
                (p_dist_no    , p_dist_seq_no    , p_line_cd        ,
                 p_policy_tsi , p_policy_premium , p_policy_ann_tsi ,
                 p_rg_count   , p_default_type   , p_currency_rt    ,
                 p_par_id     , p_item_grp	     , p_v_default_no);

    /* Get the amounts for each item in table GIPI_WITEM in preparation
    ** for data insertion to its corresponding distribution tables. */
    FOR c2 IN (SELECT a.item_no     , a.tsi_amt , a.prem_amt ,
                      a.ann_tsi_amt
                 FROM gipi_witem a
                WHERE exists( SELECT '1'
                                FROM gipi_witmperl b
                               WHERE b.par_id = a.par_id
                                 AND b.item_no = a.item_no)
                  AND a.item_grp = p_item_grp
                  AND a.par_id   = p_par_id)
    LOOP

      /* Create records in table GIUW_WITEMDS and GIUW_WITEMDS_DTL
      ** for the specified DIST_SEQ_NO. */
      INSERT INTO  giuw_witemds
                  (dist_no        , dist_seq_no   , item_no        ,
                   tsi_amt        , prem_amt      , ann_tsi_amt)
           VALUES (p_dist_no      , p_dist_seq_no , c2.item_no     ,
                   c2.tsi_amt     , c2.prem_amt   , c2.ann_tsi_amt);
      CREATE_GRP_DFLT_WITEMDS
                  (p_dist_no      , p_dist_seq_no , c2.item_no  ,
                   p_line_cd      , c2.tsi_amt    , c2.prem_amt ,
                   c2.ann_tsi_amt , p_rg_count	  , p_v_default_no);

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
    ** in table GIPI_WITMPERL in preparation for data insertion to 
    ** distribution tables GIUW_WITEMPERILDS, GIUW_WITEMPERILDS_DTL,
    ** GIUW_WPERILDS and GIUW_WPERILDS_DTL. */
    FOR c3 IN (  SELECT B490.tsi_amt     itmperil_tsi     ,
                        B490.prem_amt    itmperil_premium ,
                        B490.ann_tsi_amt itmperil_ann_tsi ,
                        B490.item_no     item_no          ,
                        B490.peril_cd    peril_cd
                   FROM gipi_witmperl B490, gipi_witem B480
                  WHERE B490.item_no  = B480.item_no
                    AND B490.par_id   = B480.par_id
                    AND B480.item_grp = p_item_grp
                    AND B480.par_id   = p_par_id
               ORDER BY B490.peril_cd)
    LOOP
      v_exist     := 'Y';

      /* Create records in table GIUW_WITEMPERILDS and GIUW_WITEMPERILDS_DTL
      ** for the specified DIST_SEQ_NO. */
      INSERT INTO  giuw_witemperilds  
                  (dist_no             , dist_seq_no   , item_no         ,
                   peril_cd            , line_cd       , tsi_amt         ,
                   prem_amt            , ann_tsi_amt)
           VALUES (p_dist_no           , p_dist_seq_no , c3.item_no      ,
                   c3.peril_cd         , p_line_cd     , c3.itmperil_tsi , 
                   c3.itmperil_premium , c3.itmperil_ann_tsi);
      CREATE_GRP_DFLT_WITEMPERILDS
                  (p_dist_no           , p_dist_seq_no       , c3.item_no      ,
                   p_line_cd           , c3.peril_cd         , c3.itmperil_tsi ,
                   c3.itmperil_premium , c3.itmperil_ann_tsi , p_rg_count	   ,
                   p_v_default_no);

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
              VALUES (p_dist_no , p_dist_seq_no , v_peril_cd       ,
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

END CREATE_GRP_DFLT_DIST_GIEXS004;
/


