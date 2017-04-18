CREATE OR REPLACE PACKAGE BODY CPI.GIUW_WITEMDS_DTL_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/
	PROCEDURE del_giuw_witemds_dtl (p_dist_no 	GIUW_WITEMDS_DTL.dist_no%TYPE)
	IS
	BEGIN
		DELETE   GIUW_WITEMDS_DTL
		 WHERE   dist_no  =  p_dist_no;
	END del_giuw_witemds_dtl;
	
	PROCEDURE POPULATE_WITEMDS_DTL(p_dist_no	   	 GIUW_POL_DIST.dist_no%TYPE)
	IS
	  v_dist_spct					giuw_witemds_dtl.dist_spct%TYPE;
	  v_ann_dist_spct               giuw_witemds_dtl.ann_dist_spct%TYPE;
	  v_allied_dist_prem            giuw_witemds_dtl.dist_prem%TYPE;
	  v_dist_prem                   giuw_witemds_dtl.dist_prem%TYPE;
	BEGIN
	  DELETE giuw_witemds_dtl 
	   WHERE dist_no = p_dist_no;
	   
	  FOR c1 IN (  SELECT dist_seq_no dist_seq_no  ,
	                      line_cd     line_cd      ,
	                      item_no     item_no      ,
	                      share_cd    share_cd     ,
	                      dist_grp    dist_grp
	                 FROM giuw_witemperilds_dtl
	                WHERE dist_no = p_dist_no
	             GROUP BY dist_seq_no, item_no, line_cd, share_cd, dist_grp)
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
	                    AND a.dist_seq_no   = c1.dist_seq_no                    
	                    AND a.dist_no       = p_dist_no)
	    LOOP
	      FOR c3 IN (SELECT tsi_amt , prem_amt    , ann_tsi_amt ,
	                        dist_no , dist_seq_no , item_no
	                   FROM giuw_witemds
	                  WHERE item_no     = c1.item_no
	                    AND dist_seq_no = c1.dist_seq_no
	                    AND dist_no     = p_dist_no)
	      LOOP
	
	        /* Divide the individual TSI/Premium with the total TSI/Premium
	        ** and multiply it by 100 to arrive at the correct percentage for
	        ** the breakdown. */
	        IF c3.tsi_amt != 0 THEN
	           v_dist_spct     := ROUND(((c2.dist_tsi/c3.tsi_amt) * 100), 9);/*ROUND(c2.dist_tsi/c3.tsi_amt, 14) * 100;*/ --changed to 9 from 14 decimal places edgar 07/04/2014
	        ELSIF c3.prem_amt != 0 THEN
	           v_dist_spct     := ROUND(((c2.dist_prem/c3.prem_amt) * 100), 9);/*ROUND(c2.dist_prem/c3.prem_amt, 14) * 100;*/ --changed to 9 from 14 decimal places edgar 07/04/2014
	        ELSE
	        	 v_dist_spct := 0;
	        END IF;
	        IF c3.ann_tsi_amt != 0 THEN 
	           v_ann_dist_spct := ROUND(((c2.ann_dist_tsi/c3.ann_tsi_amt) * 100), 9);/*ROUND(c2.ann_dist_tsi/c3.ann_tsi_amt, 14) * 100;*/ --changed to 9 from 14 decimal places edgar 07/04/2014
	        ELSE   
	           v_ann_dist_spct := 0;
	        END IF;   
	        
	        INSERT INTO  giuw_witemds_dtl
	                    (dist_no         , dist_seq_no    , item_no          ,
	                     line_cd         , share_cd       , dist_spct        ,
	                     dist_tsi        , dist_prem      , ann_dist_spct    ,
	                     ann_dist_tsi    , dist_grp)
	             VALUES (c3.dist_no      , c3.dist_seq_no , c3.item_no       , 
	                     c1.line_cd      , c1.share_cd    , v_dist_spct      ,
	                     c2.dist_tsi     , c2.dist_prem    , v_ann_dist_spct  ,
	                     c2.ann_dist_tsi , c1.dist_grp);
	      END LOOP;
	      EXIT;
	    END LOOP;
	  END LOOP;	  
	END;
    
    /*
    **  Created by        : Jerome Orio 
    **  Date Created     : 06.09.2011   
    **  Reference By     : (GIUWS006- Preliminary  Peril Distribution by TSI/Prem)  
    */
    PROCEDURE POPULATE_WITEMDS_DTL2(p_dist_no	   	 GIUW_POL_DIST.dist_no%TYPE) IS
      v_dist_spct            giuw_witemds_dtl.dist_spct%TYPE;
      v_dist_spct1        giuw_witemds_dtl.dist_spct1%TYPE;
      v_ann_dist_spct               giuw_witemds_dtl.ann_dist_spct%TYPE;
      v_allied_dist_prem            giuw_witemds_dtl.dist_prem%TYPE;
      v_dist_prem                   giuw_witemds_dtl.dist_prem%TYPE;
    BEGIN
      DELETE giuw_witemds_dtl 
      WHERE dist_no = p_dist_no;
     
      FOR c1 IN (  SELECT dist_seq_no dist_seq_no  ,
                          line_cd     line_cd      ,
                          item_no     item_no      ,
                          share_cd    share_cd     ,
                          dist_grp    dist_grp
                     FROM giuw_witemperilds_dtl
                    WHERE dist_no = p_dist_no
                 GROUP BY dist_seq_no, item_no, line_cd, share_cd, dist_grp)
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
                        AND a.dist_seq_no   = c1.dist_seq_no                    
                        AND a.dist_no       = p_dist_no)
        LOOP
      
          FOR c3 IN (SELECT tsi_amt , prem_amt    , ann_tsi_amt ,
                            dist_no , dist_seq_no , item_no
                       FROM giuw_witemds
                      WHERE item_no     = c1.item_no
                        AND dist_seq_no = c1.dist_seq_no
                        AND dist_no     = p_dist_no)
          LOOP

            /* Divide the individual TSI/Premium with the total TSI/Premium
            ** and multiply it by 100 to arrive at the correct percentage for
            ** the breakdown. */
           
            IF c3.tsi_amt = 0 THEN
                 v_dist_spct    := 0;
            ELSE	 
               v_dist_spct    := ROUND(((c2.dist_tsi/c3.tsi_amt) * 100),9) /*ROUND(c2.dist_tsi/c3.tsi_amt, 9) * 100*/;    --  shan 06.10.2014
            END IF;   
            IF c3.prem_amt = 0 THEN
                 v_dist_spct1   := 0;
            ELSE	 
               v_dist_spct1   := ROUND(((c2.dist_prem/c3.prem_amt) * 100),9) /*ROUND(c2.dist_prem/c3.prem_amt, 9) * 100*/;    -- shan 06.10.2014
            END IF;   
            IF c3.ann_tsi_amt = 0 THEN
                 v_ann_dist_spct := 0;
            ELSE	 
               v_ann_dist_spct := ROUND(((c2.ann_dist_tsi/c3.ann_tsi_amt) * 100),9) /*ROUND(c2.ann_dist_tsi/c3.ann_tsi_amt, 9) * 100*/;    -- shan 06.10.2014
            END IF;   

            --added by robert SR 5053 01.08.16 
            IF c3.tsi_amt = 0
            THEN           
               FOR c4 IN (SELECT SUM (tsi_amt) tsi_amt
                            FROM giuw_witemperilds a, giis_peril b
                           WHERE a.dist_seq_no = c3.dist_seq_no
                             AND a.item_no = c3.item_no
                             AND a.dist_no = p_dist_no
                             AND a.line_cd = b.line_cd
                             AND a.peril_cd = b.peril_cd
                             AND b.peril_type = 'A')
               LOOP
                  IF c4.tsi_amt = 0 THEN
                     IF c3.prem_amt = 0 THEN
                        v_dist_spct   := 0;
                     ELSE
                        FOR c5 IN (SELECT SUM (dist_prem) dist_prem
                                      FROM giuw_witemperilds_dtl a
                                     WHERE a.dist_seq_no = c1.dist_seq_no
                                       AND a.share_cd = c1.share_cd
                                       AND a.item_no = c3.item_no
                                       AND a.dist_no = p_dist_no)
                        LOOP
                             v_dist_spct := ROUND(((c5.dist_prem/c3.prem_amt) * 100),9);
                        END LOOP;
                     END IF;
                  ELSE
                     FOR c5 IN (SELECT SUM (dist_tsi) dist_tsi
                                  FROM giuw_witemperilds_dtl a, giis_peril b
                                 WHERE a.dist_seq_no = c1.dist_seq_no
                                   AND a.share_cd = c1.share_cd
                                   AND a.item_no = c3.item_no
                                   AND a.dist_no = p_dist_no
                                   AND a.line_cd = b.line_cd
                                   AND a.peril_cd = b.peril_cd
                                   AND b.peril_type = 'A')
                     LOOP
                         v_dist_spct := ROUND(((c5.dist_tsi/c4.tsi_amt) * 100),9);
                     END LOOP;
                  END IF;
               END LOOP;
               IF v_dist_spct1 = 0 THEN
                  v_dist_spct1 := v_dist_spct;
               END IF;
               v_ann_dist_spct := v_dist_spct;
            END IF;
			--end of codes robert SR 5053 01.08.16 
			/*
            IF c3.tsi_amt != 0 THEN
               v_dist_spct     := ROUND(c2.dist_tsi/c3.tsi_amt, 9) * 100;
            --ELSIF c3.prem_amt != 0 THEN
            --   v_dist_spct     := ROUND(c2.dist_prem/c3.prem_amt, 9) * 100;
            ELSE
                 v_dist_spct := 0;
            END IF;
           
            IF c3.prem_amt != 0 THEN
               v_dist_spct1     := ROUND(c2.dist_prem/c3.prem_amt, 9) * 100;
            ELSE
                 v_dist_spct1 := 0;
            END IF;

            IF c3.ann_tsi_amt != 0 THEN 
               v_ann_dist_spct := ROUND(c2.ann_dist_tsi/c3.ann_tsi_amt, 9) * 100;
            ELSE   
               v_ann_dist_spct := 0;
            END IF;   
            
            */
            
            INSERT INTO  giuw_witemds_dtl
                        (dist_no         , dist_seq_no    , item_no          ,
                         line_cd         , share_cd       , dist_spct        ,
                         dist_tsi        , dist_prem      , ann_dist_spct    ,
                         ann_dist_tsi    , dist_grp       , dist_spct1)  --aaron
                 VALUES (c3.dist_no      , c3.dist_seq_no , c3.item_no       , 
                         c1.line_cd      , c1.share_cd    , v_dist_spct      ,
                         c2.dist_tsi     , c2.dist_prem   , v_ann_dist_spct  ,
                         c2.ann_dist_tsi , c1.dist_grp    , v_dist_spct1);  --aaron
          END LOOP;
          EXIT;
        END LOOP;
      END LOOP;
    END;
	
	/*
	**  Created by		: Emman
	**  Date Created 	: 07.27.2011
	**  Reference By 	: (GIUWS012 - Distribution by Peril)
	**  Description 	: Recreate records in table GIUW_WITEMDS_DTL based on
	** 					  the values taken in by table GIUW_WITEMPERILDS_DTL.
	*/
	PROCEDURE POPULATE_WITEMDS_DTL_GIUWS012(p_dist_no	   	 GIUW_POL_DIST.dist_no%TYPE)
	IS
	  v_dist_spct					giuw_witemds_dtl.dist_spct%TYPE;
	  v_ann_dist_spct               giuw_witemds_dtl.ann_dist_spct%TYPE;
	  v_allied_dist_prem            giuw_witemds_dtl.dist_prem%TYPE;
	  v_dist_prem                   giuw_witemds_dtl.dist_prem%TYPE;
	BEGIN
	  DELETE giuw_witemds_dtl 
	   WHERE dist_no = p_dist_no;
	   
	  FOR c1 IN (  SELECT dist_seq_no dist_seq_no  ,
	                      line_cd     line_cd      ,
	                      item_no     item_no      ,
	                      share_cd    share_cd     ,
	                      dist_grp    dist_grp
	                 FROM giuw_witemperilds_dtl
	                WHERE dist_no = p_dist_no
	             GROUP BY dist_seq_no, item_no, line_cd, share_cd, dist_grp)
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
	                    AND a.dist_seq_no   = c1.dist_seq_no                    
	                    AND a.dist_no       = p_dist_no)
	    LOOP
	      FOR c3 IN (SELECT tsi_amt , prem_amt    , ann_tsi_amt ,
	                        dist_no , dist_seq_no , item_no
	                   FROM giuw_witemds
	                  WHERE item_no     = c1.item_no
	                    AND dist_seq_no = c1.dist_seq_no
	                    AND dist_no     = p_dist_no)
	      LOOP
	
	        /* Divide the individual TSI/Premium with the total TSI/Premium
	        ** and multiply it by 100 to arrive at the correct percentage for
	        ** the breakdown. */
	        IF nvl(c3.tsi_amt,0) = 0 THEN
        	     v_dist_spct     := 0;
	        ELSE
	        	 v_dist_spct     := ROUND(c2.dist_tsi/c3.tsi_amt, 14) * 100;
	        END IF;	 
	        IF nvl(c3.ann_tsi_amt,0) = 0 THEN
	             v_ann_dist_spct := 0;
	        ELSE
	        	 v_ann_dist_spct := ROUND(c2.ann_dist_tsi/c3.ann_tsi_amt, 14) * 100;
	        END IF; 
	        
	        INSERT INTO  giuw_witemds_dtl
	                    (dist_no         , dist_seq_no    , item_no          ,
	                     line_cd         , share_cd       , dist_spct        ,
	                     dist_tsi        , dist_prem      , ann_dist_spct    ,
	                     ann_dist_tsi    , dist_grp		  , dist_spct1)
	             VALUES (c3.dist_no      , c3.dist_seq_no , c3.item_no       , 
	                     c1.line_cd      , c1.share_cd    , v_dist_spct      ,
	                     c2.dist_tsi     , c2.dist_prem    , v_ann_dist_spct  ,
	                     c2.ann_dist_tsi , c1.dist_grp	  , NULL);
	      END LOOP;
	      EXIT;
	    END LOOP;
	  END LOOP;	  
	END POPULATE_WITEMDS_DTL_GIUWS012;   
    
    /*
    **  Created by   : Robert John Virrey 
    **  Date Created : August 4, 2011
    **  Reference By : GIUTS002 - Distribution Negation 
    **  Description  : Creates a new distribution record in table GIUW_WITEMDS_DTL
    **                  based on the values taken in by the fields of the negated
    **                  record
    */
    PROCEDURE neg_itemds_dtl (
        p_dist_no     IN  giuw_itemds_dtl.dist_no%TYPE,
        p_temp_distno IN  giuw_itemds_dtl.dist_no%TYPE
    ) 
    IS

      CURSOR dtl_retriever_cur IS
        SELECT dist_seq_no , item_no       , line_cd      ,
               share_cd    , dist_spct     , dist_tsi     ,
               dist_prem   , ann_dist_spct , ann_dist_tsi ,
               dist_grp
          FROM giuw_itemds_dtl
         WHERE dist_no = p_dist_no;

      v_dist_seq_no        giuw_itemds_dtl.dist_seq_no%type;
      v_item_no            giuw_itemds_dtl.item_no%type;
      v_line_cd            giuw_itemds_dtl.line_cd%type;
      v_share_cd           giuw_itemds_dtl.share_cd%type;
      v_dist_spct          giuw_itemds_dtl.dist_spct%type;
      v_dist_tsi           giuw_itemds_dtl.dist_tsi%type;
      v_dist_prem          giuw_itemds_dtl.dist_prem%type;
      v_ann_dist_spct      giuw_itemds_dtl.ann_dist_spct%type;
      v_ann_dist_tsi       giuw_itemds_dtl.ann_dist_tsi%type;
      v_dist_grp           giuw_itemds_dtl.dist_grp%type;

    BEGIN
      OPEN dtl_retriever_cur;
      LOOP
        FETCH dtl_retriever_cur
         INTO v_dist_seq_no , v_item_no       , v_line_cd      ,
              v_share_cd    , v_dist_spct     , v_dist_tsi     ,
              v_dist_prem   , v_ann_dist_spct , v_ann_dist_tsi ,
              v_dist_grp;
        EXIT WHEN dtl_retriever_cur%NOTFOUND;
        INSERT INTO  giuw_witemds_dtl
                    (dist_no           , dist_seq_no   , item_no         , 
                     line_cd           , share_cd      , dist_spct       , 
                     dist_tsi          , dist_prem     , ann_dist_spct   , 
                     ann_dist_tsi      , dist_grp)
             VALUES (p_temp_distno     , v_dist_seq_no , v_item_no       , 
                     v_line_cd         , v_share_cd    , v_dist_spct     , 
                     v_dist_tsi        , v_dist_prem   , v_ann_dist_spct , 
                     v_ann_dist_tsi    , v_dist_grp);
      END LOOP;
      CLOSE dtl_retriever_cur;
    END neg_itemds_dtl;
    
    /*
    **  Created by   :  Emman
    **  Date Created :  08.16.2011
    **  Reference By : (GIUTS021 - Redistribution)
    **  Description  : Creates a new distribution record in table GIUW_WITEMDS_DTL
    **                 based on the values taken in by the fields of the negated
    **                 record.
    **                 NOTE:  The value of field DIST_NO was not copied, as the newly 
    **                  created distribution record has its own distribution number.
    */ 
    PROCEDURE NEG_ITEMDS_DTL_GIUTS021(p_dist_no          IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                      p_temp_distno      IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                      p_var_v_neg_distno IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                      p_v_ratio          IN OUT NUMBER)
    IS

      CURSOR dtl_retriever_cur IS
        SELECT dist_seq_no , item_no       , line_cd      ,
               share_cd    , dist_spct     , dist_tsi     ,
               dist_prem   , ann_dist_spct , ann_dist_tsi ,
               dist_grp    , dist_spct1 --added dist_spct1 edgar 09/22/2014
          FROM giuw_itemds_dtl
         WHERE dist_no = p_var_v_neg_distno;

      v_dist_seq_no            giuw_itemds_dtl.dist_seq_no%type;
      v_item_no            giuw_itemds_dtl.item_no%type;
      v_line_cd            giuw_itemds_dtl.line_cd%type;
      v_share_cd            giuw_itemds_dtl.share_cd%type;
      v_dist_spct            giuw_itemds_dtl.dist_spct%type;
      v_dist_spct1            giuw_policyds_dtl.dist_spct%type; --added dist_spct1 edgar 09/22/2014
      v_dist_tsi            giuw_itemds_dtl.dist_tsi%type;
      v_dist_prem            giuw_itemds_dtl.dist_prem%type;
      v_ann_dist_spct        giuw_itemds_dtl.ann_dist_spct%type;
      v_ann_dist_tsi        giuw_itemds_dtl.ann_dist_tsi%type;
      v_dist_grp            giuw_itemds_dtl.dist_grp%type;
      v_dist_prem_f            giuw_itemds_dtl.dist_prem%type;
      v_dist_prem_w            giuw_itemds_dtl.dist_prem%type;
    BEGIN
      OPEN dtl_retriever_cur;
      LOOP
        FETCH dtl_retriever_cur
         INTO v_dist_seq_no , v_item_no       , v_line_cd      ,
              v_share_cd    , v_dist_spct     , v_dist_tsi     ,
              v_dist_prem   , v_ann_dist_spct , v_ann_dist_tsi ,
              v_dist_grp    , v_dist_spct1;--added dist_spct1 edgar 09/22/2014
        EXIT WHEN dtl_retriever_cur%NOTFOUND;
        v_dist_prem_f := ROUND(v_dist_prem * p_v_ratio, 2);
        v_dist_prem_w := v_dist_prem - v_dist_prem_f;
       /* earned portion */ 
       INSERT INTO  giuw_witemds_dtl
                    (dist_no           , dist_seq_no   , item_no         , 
                     line_cd           , share_cd      , dist_spct       , 
                     dist_tsi          , dist_prem     , ann_dist_spct   , 
                     ann_dist_tsi      , dist_grp      , dist_spct1)--added dist_spct1 edgar 09/22/2014
             VALUES (p_dist_no     , v_dist_seq_no , v_item_no       , 
                     v_line_cd         , v_share_cd    , v_dist_spct     , 
                     v_dist_tsi        , v_dist_prem_f , v_ann_dist_spct , 
                     v_ann_dist_tsi    , v_dist_grp    , v_dist_spct1);--added dist_spct1 edgar 09/22/2014
       /* unearned portion */ 
       INSERT INTO  giuw_witemds_dtl
                    (dist_no           , dist_seq_no   , item_no         , 
                     line_cd           , share_cd      , dist_spct       , 
                     dist_tsi          , dist_prem     , ann_dist_spct   , 
                     ann_dist_tsi      , dist_grp      , dist_spct1)--added dist_spct1 edgar 09/22/2014
             VALUES (p_temp_distno , v_dist_seq_no , v_item_no       , 
                     v_line_cd         , v_share_cd    , v_dist_spct     , 
                     v_dist_tsi        , v_dist_prem_w , v_ann_dist_spct , 
                     v_ann_dist_tsi    , v_dist_grp    , v_dist_spct1);--added dist_spct1 edgar 09/22/2014
                     --forms_ddl('COMMIT');
      END LOOP;
      CLOSE dtl_retriever_cur;
    END NEG_ITEMDS_DTL_GIUTS021;

END GIUW_WITEMDS_DTL_PKG;
/


