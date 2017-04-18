DROP PROCEDURE CPI.CREATE_GRP_DFLT_DIST;

CREATE OR REPLACE PROCEDURE CPI.CREATE_GRP_DFLT_DIST(
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
							   p_v_default_no	IN giis_default_dist.default_no%TYPE) IS

  v_peril_cd			giis_peril.peril_cd%TYPE;
  v_peril_tsi			giuw_wperilds.tsi_amt%TYPE      := 0;
  v_peril_premium		giuw_wperilds.prem_amt%TYPE     := 0;
  v_peril_ann_tsi		giuw_wperilds.ann_tsi_amt%TYPE  := 0;
  v_exist				VARCHAR2(1)                     := 'N';
  v_insert_sw			VARCHAR2(1)                     := 'N';
  dist_cnt 				NUMBER:=0;
  dist_max 				giuw_pol_dist.dist_no%TYPE;
  v_policy_tsi      	giuw_wpolicyds.tsi_amt%TYPE     ;
  v_policy_premium  	giuw_wpolicyds.prem_amt%TYPE    ;
  v_policy_ann_tsi  	giuw_wpolicyds.ann_tsi_amt%TYPE ;


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
  /*
  **  Created by   : Jerome Orio 
  **  Date Created : April 05, 2010 
  **  Reference By : (GIPIS055 - POST PAR) 
  **  Description  : CREATE_GRP_DFLT_DIST program unit 
  */
  
	SELECT count(dist_no), max(dist_no)
	  INTO dist_cnt, dist_max
	  FROM giuw_pol_dist
	 WHERE par_id = p_par_id
	   AND item_grp = p_item_grp;
	
	IF dist_cnt = 0 AND dist_max IS NULL THEN
    BEGIN
    	SELECT count(dist_no), max(dist_no)
	  		INTO dist_cnt, dist_max
	  		FROM giuw_pol_dist
	 	 	 WHERE par_id = p_par_id
	     	 AND item_grp IS NULL;
    EXCEPTION
    	WHEN NO_DATA_FOUND THEN
    		null;
    END;
  END IF;
	
	/* Create records in table GIUW_WPOLICYDS and GIUW_WPOLICYDS_DTL
  ** for the specified DIST_SEQ_NO. */
  IF p_dist_no = dist_max THEN 
		FOR x IN (SELECT SUM(NVL(DECODE(c.peril_type,'B',a.tsi_amt,0),0)     /*beth- (ROUND((NVL(DECODE(c.peril_type,'B',a.tsi_amt,0),0)/dist_cnt),2) * (dist_cnt - 1))*/) tsi_amt, 
	  								 SUM(NVL(a.prem_amt,0) - (ROUND((NVL(a.prem_amt,0)/dist_cnt),2) * (dist_cnt - 1))) prem_amt, 
	  								 SUM(NVL(DECODE(c.peril_type,'B',a.ann_tsi_amt,0),0) /*beth- (ROUND((NVL(DECODE(c.peril_type,'B',a.ann_tsi_amt,0),0)/dist_cnt),2) * (dist_cnt - 1))*/) ann_tsi_amt
	  						FROM gipi_witmperl a, gipi_witem b, giis_peril c
	  					 WHERE a.par_id   = b.par_id
	  					   AND a.item_no  = b.item_no
	  					   AND a.par_id   = p_par_id
								 AND b.item_grp = p_item_grp
								 AND a.peril_cd = c.peril_cd
								 AND c.line_cd  = p_line_cd)
		LOOP
			v_policy_tsi 		 := x.tsi_amt;
			v_policy_premium := x.prem_amt;
			v_policy_ann_tsi := x.ann_tsi_amt;
		END LOOP;
	ELSE
		FOR x IN (SELECT SUM(ROUND((NVL(DECODE(c.peril_type,'B',a.tsi_amt,0),0)/*beth/dist_cnt*/),2)) tsi_amt, 
	  								 SUM(ROUND((NVL(a.prem_amt,0)/dist_cnt),2)) prem_amt, 
	  								 SUM(ROUND((NVL(DECODE(c.peril_type,'B',a.ann_tsi_amt,0),0)/*beth/dist_cnt*/),2)) ann_tsi_amt
	  						FROM gipi_witmperl a, gipi_witem b, giis_peril c
	  					 WHERE a.par_id   = b.par_id
	  					   AND a.item_no  = b.item_no
	  					   AND a.par_id   = p_par_id
								 AND b.item_grp = p_item_grp
								 AND a.peril_cd = c.peril_cd
								 AND c.line_cd  = p_line_cd)
		LOOP
			v_policy_tsi 		 := x.tsi_amt;
			v_policy_premium := x.prem_amt;
			v_policy_ann_tsi := x.ann_tsi_amt;
		END LOOP;
	END IF;
	----
  INSERT INTO  giuw_wpolicyds
              (dist_no      , dist_seq_no      , dist_flag        ,
               tsi_amt      , prem_amt         , ann_tsi_amt      ,
               item_grp)
       VALUES (p_dist_no    , p_dist_seq_no    , p_dist_flag      ,
               v_policy_tsi , v_policy_premium , v_policy_ann_tsi ,
               p_item_grp);
  CREATE_GRP_DFLT_WPOLICYDS
              (p_dist_no    , p_dist_seq_no    , p_line_cd        ,
               v_policy_tsi , v_policy_premium , v_policy_ann_tsi ,
               p_rg_count   , p_default_type   , p_currency_rt    ,
               p_par_id     , p_item_grp	   , p_v_default_no);

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
    IF p_dist_no = dist_max THEN
			FOR x IN (SELECT SUM(NVL(DECODE(c.peril_type,'B',a.tsi_amt,0),0) /*beth- (ROUND((NVL(DECODE(c.peril_type,'B',a.tsi_amt,0),0)/dist_cnt),2) * (dist_cnt - 1))*/) tsi_amt, 
  										 SUM(NVL(a.prem_amt,0) - (ROUND((NVL(a.prem_amt,0)/dist_cnt),2) * (dist_cnt - 1))) prem_amt, 
  										 SUM(NVL(DECODE(c.peril_type,'B',a.ann_tsi_amt,0),0) /*beth- (ROUND((NVL(DECODE(c.peril_type,'B',a.ann_tsi_amt,0),0)/dist_cnt),2) * (dist_cnt - 1))*/
  										 ) ann_tsi_amt
  								FROM gipi_witmperl a, gipi_witem b, giis_peril c
  					 		 WHERE a.par_id = b.par_id
  					   		 AND a.item_no = b.item_no
  					   		 AND a.par_id = p_par_id
							 	   AND b.item_no  = c2.item_no
							 	   AND a.peril_cd = c.peril_cd
							 	   AND c.line_cd = p_line_cd)
			LOOP
				c2.tsi_amt         := x.tsi_amt;--NVL(c2.tsi_amt,0) - (ROUND((NVL(c2.tsi_amt,0)/dist_cnt),2) * (dist_cnt - 1));
				c2.prem_amt	 	 		 := x.prem_amt;--NVL(c2.prem_amt,0) - (ROUND((NVL(c2.prem_amt,0)/dist_cnt),2) * (dist_cnt - 1));
				c2.ann_tsi_amt     := x.ann_tsi_amt;--NVL(c2.ann_tsi_amt,0) - (ROUND((NVL(c2.ann_tsi_amt,0)/dist_cnt),2) * (dist_cnt - 1));
			END LOOP;
		ELSE
			FOR x IN (SELECT SUM(ROUND((NVL(DECODE(c.peril_type,'B',a.tsi_amt,0),0)/*beth/dist_cnt*/),2)) tsi_amt, 
  										 SUM(ROUND((NVL(a.prem_amt,0)/dist_cnt),2)) prem_amt, 
  										 SUM(ROUND((NVL(DECODE(c.peril_type,'B',a.ann_tsi_amt,0),0)/*beth/dist_cnt*/),2)) ann_tsi_amt
  								FROM gipi_witmperl a, gipi_witem b, giis_peril c
  					 		 WHERE a.par_id = b.par_id
  					   		 AND a.item_no = b.item_no
  					   		 AND a.par_id = p_par_id
							 	   AND a.item_no  = c2.item_no
							 	   AND a.peril_cd = c.peril_cd
							 	   AND c.line_cd = p_line_cd)
			LOOP
				c2.tsi_amt         := x.tsi_amt;--NVL(c2.tsi_amt,0) - (ROUND((NVL(c2.tsi_amt,0)/dist_cnt),2) * (dist_cnt - 1));
				c2.prem_amt	 	 		 := x.prem_amt;--NVL(c2.prem_amt,0) - (ROUND((NVL(c2.prem_amt,0)/dist_cnt),2) * (dist_cnt - 1));
				c2.ann_tsi_amt     := x.ann_tsi_amt;--NVL(c2.ann_tsi_amt,0) - (ROUND((NVL(c2.ann_tsi_amt,0)/dist_cnt),2) * (dist_cnt - 1));
			END LOOP;
		END IF;
    -----
    INSERT INTO  giuw_witemds
                (dist_no        , dist_seq_no   , item_no        ,
                 tsi_amt        , prem_amt      , ann_tsi_amt)
         VALUES (p_dist_no      , p_dist_seq_no , c2.item_no     ,
                 c2.tsi_amt     , c2.prem_amt   , c2.ann_tsi_amt);
    CREATE_GRP_DFLT_WITEMDS
                (p_dist_no      , p_dist_seq_no , c2.item_no  ,
                 p_line_cd      , c2.tsi_amt    , c2.prem_amt ,
                 c2.ann_tsi_amt , p_rg_count	, p_v_default_no);
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
    IF p_dist_no = dist_max THEN
  		c3.itmperil_tsi     := NVL(c3.itmperil_tsi,0)     /*beth- (ROUND((NVL(c3.itmperil_tsi,0)/dist_cnt),2) * (dist_cnt - 1))*/;
			c3.itmperil_premium	:= NVL(c3.itmperil_premium,0) - (ROUND((NVL(c3.itmperil_premium,0)/dist_cnt),2) * (dist_cnt - 1));
			c3.itmperil_ann_tsi := NVL(c3.itmperil_ann_tsi,0) /*beth- (ROUND((NVL(c3.itmperil_ann_tsi,0)/dist_cnt),2) * (dist_cnt - 1))*/;
		ELSE
			c3.itmperil_tsi     := ROUND((NVL(c3.itmperil_tsi,0)    /*beth/dist_cnt*/),2);
			c3.itmperil_premium	:= ROUND((NVL(c3.itmperil_premium,0)/dist_cnt),2);
			c3.itmperil_ann_tsi := ROUND((NVL(c3.itmperil_ann_tsi,0)/*beth/dist_cnt*/),2);
		END IF;
    -----
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
                 c3.itmperil_premium , c3.itmperil_ann_tsi , p_rg_count 	 , 
				 p_v_default_no);
  END LOOP;
  
  /* Create the newly processed PERIL_CD in table
  ** GIUW_WPERILDS. */
	FOR c4 IN (SELECT SUM(B490.tsi_amt)     itmperil_tsi     ,
		           			SUM(B490.prem_amt)    itmperil_premium ,
		           			SUM(B490.ann_tsi_amt) itmperil_ann_tsi ,
		           			--B490.item_no     item_no          ,
		           			B490.peril_cd    peril_cd
		       		 FROM gipi_witmperl B490, gipi_witem B480
		      		WHERE B490.item_no  = B480.item_no
		       			AND B490.par_id   = B480.par_id
		       			AND B480.item_grp = p_item_grp
		       			AND B480.par_id   = p_par_id         
		      		GROUP BY B490.peril_cd)
	LOOP       
	  --msg_alert('giuw_wperilds','I',FALSE);
	  IF p_dist_no = dist_max THEN
	    c4.itmperil_tsi      := NVL(c4.itmperil_tsi,0)     /*beth- (ROUND((NVL(c4.itmperil_tsi,0)/dist_cnt),2) * (dist_cnt - 1))*/;
	    c4.itmperil_premium	 := NVL(c4.itmperil_premium,0) - (ROUND((NVL(c4.itmperil_premium,0)/dist_cnt),2) * (dist_cnt - 1));
	    c4.itmperil_ann_tsi  := NVL(c4.itmperil_ann_tsi,0) /*beth- (ROUND((NVL(c4.itmperil_ann_tsi,0)/dist_cnt),2) * (dist_cnt - 1))*/;
	  ELSE
	    c4.itmperil_tsi      := c4.itmperil_tsi     /*beth/ dist_cnt*/;
	    c4.itmperil_premium  := c4.itmperil_premium / dist_cnt;
	    c4.itmperil_ann_tsi  := c4.itmperil_ann_tsi /*beth/ dist_cnt*/;
	  END IF;
		  
	  INSERT INTO giuw_wperilds  
	    (dist_no   , dist_seq_no   , peril_cd         ,
	     line_cd   , tsi_amt       , prem_amt         ,
	     ann_tsi_amt)
	  VALUES 
	  	(p_dist_no , p_dist_seq_no , c4.peril_cd       ,
	     p_line_cd , c4.itmperil_tsi   , c4.itmperil_premium  ,
	     c4.itmperil_ann_tsi);			
		  
	  v_peril_cd 			:= c4.peril_cd;
	  v_peril_tsi			:= c4.itmperil_tsi;
	  v_peril_premium	:= c4.itmperil_premium;
	  v_peril_ann_tsi	:= c4.itmperil_ann_tsi;
	
	  UPD_CREATE_WPERIL_DTL_DATA;                   
	END LOOP;
END;
	







/*-- IF v_peril_cd IS NULL THEN
       v_peril_cd     := c3.peril_cd;
       v_insert_sw    := 'Y';
     END IF;
*/
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
  
/*-- IF v_peril_cd != c3.peril_cd THEN--*/

  /* Updates the amounts of the previously processed PERIL_CD.
  ** After which, the records for table GIUW_WPERILDS_DTL are
  ** also created. */
/*-- UPD_CREATE_WPERIL_DTL_DATA;--*/

         /* Assigns the new PERIL_CD to the V_PERIL_CD
         ** variable in preparation for data creation
         ** in table GIUW_WPERILDS. */
/*-- v_peril_cd      := c3.peril_cd;
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
*/
       /* Updates the amounts of the last processed PERIL_CD.
       ** After which, its corresponding records for table 
       ** GIUW_WPERILDS_DTL are also created.
       ** NOTE:  This was done so, because the last processed
       **        PERIL_CD is no longer handled by the C3 loop. */
/*--       UPD_CREATE_WPERIL_DTL_DATA;

    END IF;

END;
*/
/


