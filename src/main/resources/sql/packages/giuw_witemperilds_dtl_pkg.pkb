CREATE OR REPLACE PACKAGE BODY CPI.GIUW_WITEMPERILDS_DTL_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.17.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/
	PROCEDURE del_giuw_witemperilds_dtl (p_dist_no 	GIUW_WITEMPERILDS_DTL.dist_no%TYPE)
	IS
	BEGIN
		DELETE   GIUW_WITEMPERILDS_DTL
         WHERE   dist_no = p_dist_no; 
	END del_giuw_witemperilds_dtl;
	
	PROCEDURE POPULATE_WITEMPERILDS_DTL(p_dist_no	   	 GIUW_POL_DIST.dist_no%TYPE)
	IS
	  v_dist_tsi					giuw_witemperilds_dtl.dist_tsi%type;
	  v_dist_prem                   giuw_witemperilds_dtl.dist_prem%type;  
	  v_ann_dist_tsi                giuw_witemperilds_dtl.ann_dist_tsi%type;
	BEGIN
	  DELETE giuw_witemperilds_dtl 
	   WHERE dist_no = p_dist_no;
	  FOR c1 IN (SELECT dist_spct , ann_dist_spct , dist_grp    ,
	                    share_cd  , line_cd       , dist_seq_no ,
	                    peril_cd
	               FROM giuw_wperilds_dtl
	              WHERE dist_no = p_dist_no)
	  LOOP
	    FOR c2 IN (SELECT tsi_amt , prem_amt    , ann_tsi_amt ,
	                      dist_no , dist_seq_no , item_no     ,
	                      line_cd , peril_cd
	                 FROM giuw_witemperilds
	                WHERE peril_cd    = c1.peril_cd
	                  AND line_cd     = c1.line_cd
	                  AND dist_seq_no = c1.dist_seq_no
	                  AND dist_no     = p_dist_no)
	    LOOP
	
	      /* Multiply the percentage values of table GIUW_WPERILDS_DTL
	      ** with the values of columns belonging to table GIUW_WITEMPERILDS,
	      ** to arrive at the correct break down of values in table
	      ** GIUW_WITEMPERILDS_DTL. */
	      v_dist_tsi     := ROUND(c1.dist_spct/100     * c2.tsi_amt, 2);
	      v_dist_prem    := ROUND(c1.dist_spct/100     * c2.prem_amt, 2);
	      v_ann_dist_tsi := ROUND(c1.ann_dist_spct/100 * c2.ann_tsi_amt, 2);
	
	      INSERT INTO  giuw_witemperilds_dtl
	                  (dist_no          , dist_seq_no    , item_no          ,
	                   line_cd          , peril_cd       , share_cd         ,
	                   dist_spct        , dist_tsi       , dist_prem        ,
	                   ann_dist_spct    , ann_dist_tsi   , dist_grp)
	           VALUES (c2.dist_no       , c2.dist_seq_no , c2.item_no       ,
	                   c2.line_cd       , c2.peril_cd    , c1.share_cd      ,
	                   c1.dist_spct     , v_dist_tsi     , v_dist_prem      ,
	                   c1.ann_dist_spct , v_ann_dist_tsi , c1.dist_grp);
	    END LOOP;
	  END LOOP;
	END POPULATE_WITEMPERILDS_DTL;
    
    /*
    **  Created by        : Jerome Orio 
    **  Date Created     : 06.09.2011   
    **  Reference By     : (GIUWS006- Preliminary  Peril Distribution by TSI/Prem)  
    */
    PROCEDURE POPULATE_WITEMPERILDS_DTL2 (p_dist_no 	GIUW_WITEMPERILDS_DTL.dist_no%TYPE) IS
      v_dist_tsi			giuw_witemperilds_dtl.dist_tsi%type;
      v_dist_prem                   giuw_witemperilds_dtl.dist_prem%type;  
      v_ann_dist_tsi                giuw_witemperilds_dtl.ann_dist_tsi%type;
    BEGIN
      

      DELETE giuw_witemperilds_dtl 
       WHERE dist_no = p_dist_no;
      FOR c1 IN (SELECT dist_spct , ann_dist_spct , dist_grp    ,
                        share_cd  , line_cd       , dist_seq_no ,
                        peril_cd  , dist_spct1
                   FROM giuw_wperilds_dtl
                  WHERE dist_no = p_dist_no)
      LOOP
        FOR c2 IN (SELECT tsi_amt , prem_amt    , ann_tsi_amt ,
                          dist_no , dist_seq_no , item_no     ,
                          line_cd , peril_cd
                     FROM giuw_witemperilds
                    WHERE peril_cd    = c1.peril_cd
                      AND line_cd     = c1.line_cd
                      AND dist_seq_no = c1.dist_seq_no
                      AND dist_no     = p_dist_no)
        LOOP

          /* Multiply the percentage values of table GIUW_WPERILDS_DTL
          ** with the values of columns belonging to table GIUW_WITEMPERILDS,
          ** to arrive at the correct break down of values in table
          ** GIUW_WITEMPERILDS_DTL. */
          v_dist_tsi     := ROUND(c1.dist_spct/100     * c2.tsi_amt, 2);
          v_dist_prem    := ROUND(c1.dist_spct1/100     * c2.prem_amt, 2);
          v_ann_dist_tsi := ROUND(c1.ann_dist_spct/100 * c2.ann_tsi_amt, 2);

      
          INSERT INTO  giuw_witemperilds_dtl
                      (dist_no          , dist_seq_no    , item_no          ,
                       line_cd          , peril_cd       , share_cd         ,
                       dist_spct        , dist_tsi       , dist_prem        ,
                       ann_dist_spct    , ann_dist_tsi   , dist_grp         ,
                       dist_spct1) --aaron
               VALUES (c2.dist_no       , c2.dist_seq_no , c2.item_no       ,
                       c2.line_cd       , c2.peril_cd    , c1.share_cd      ,
                       c1.dist_spct     , v_dist_tsi     , v_dist_prem      ,
                       c1.ann_dist_spct , v_ann_dist_tsi , c1.dist_grp      ,
                       c1.dist_spct1); --aaron
        END LOOP;
      END LOOP;
    END;
    
    /*
    **  Created by        : Jerome Orio 
    **  Date Created     : 08.05.2011   
    **  Reference By     : (GIUWS017- Distribution by TSI/Prem (Peril))   
    */
    PROCEDURE POPULATE_WITEMPERILDS_DTL3 (p_dist_no 	GIUW_WITEMPERILDS_DTL.dist_no%TYPE) IS
      v_dist_tsi			        giuw_witemperilds_dtl.dist_tsi%type;
      v_dist_prem                   giuw_witemperilds_dtl.dist_prem%type;  
      v_ann_dist_tsi                giuw_witemperilds_dtl.ann_dist_tsi%type;
    BEGIN
      DELETE giuw_witemperilds_dtl 
       WHERE dist_no = p_dist_no;
      FOR c1 IN (SELECT dist_spct , ann_dist_spct , dist_grp    ,
                        share_cd  , line_cd       , dist_seq_no ,
                        peril_cd  , dist_spct1
                   FROM giuw_wperilds_dtl
                  WHERE dist_no = p_dist_no)
      LOOP
        FOR c2 IN (SELECT tsi_amt , prem_amt    , ann_tsi_amt ,
                          dist_no , dist_seq_no , item_no     ,
                          line_cd , peril_cd
                     FROM giuw_witemperilds
                    WHERE peril_cd    = c1.peril_cd
                      AND line_cd     = c1.line_cd
                      AND dist_seq_no = c1.dist_seq_no
                      AND dist_no     = p_dist_no)
        LOOP

          /* Multiply the percentage values of table GIUW_WPERILDS_DTL
          ** with the values of columns belonging to table GIUW_WITEMPERILDS,
          ** to arrive at the correct break down of values in table
          ** GIUW_WITEMPERILDS_DTL. */
          IF c2.tsi_amt = 0 THEN
             v_dist_tsi := 0;
          ELSE   
             v_dist_tsi     := ROUND(c1.dist_spct/100     * c2.tsi_amt, 2);
          END IF;
          IF c2.prem_amt = 0 THEN
             v_dist_prem := 0;
          ELSE   
             v_dist_prem    := ROUND(c1.dist_spct1/100     * c2.prem_amt, 2);
          END IF;   
          IF c2.ann_tsi_amt = 0 THEN
             v_ann_dist_tsi := 0;
          ELSE   	
             v_ann_dist_tsi := ROUND(c1.ann_dist_spct/100 * c2.ann_tsi_amt, 2);
          END IF;   

          INSERT INTO  giuw_witemperilds_dtl
                      (dist_no          , dist_seq_no    , item_no          ,
                       line_cd          , peril_cd       , share_cd         ,
                       dist_spct        , dist_tsi       , dist_prem        ,
                       ann_dist_spct    , ann_dist_tsi   , dist_grp         ,
                       dist_spct1)
               VALUES (c2.dist_no       , c2.dist_seq_no , c2.item_no       ,
                       c2.line_cd       , c2.peril_cd    , c1.share_cd      ,
                       c1.dist_spct     , v_dist_tsi     , v_dist_prem      ,
                       c1.ann_dist_spct , v_ann_dist_tsi , c1.dist_grp      ,
                       c1.dist_spct1);
        END LOOP;
      END LOOP;
    END;
    
    /*
    **  Created by   : Robert John Virrey 
    **  Date Created : August 4, 2011
    **  Reference By : GIUTS002 - Distribution Negation 
    **  Description  : Creates a new distribution record in table GIUW_WITEMPERILDS_DTL
    **                  based on the values taken in by the fields of the negated
    **                  record
    */
    PROCEDURE neg_itemperilds_dtl (
        p_dist_no     IN  giuw_itemperilds_dtl.dist_no%TYPE,
        p_temp_distno IN  giuw_itemperilds_dtl.dist_no%TYPE
    ) 
    IS

      CURSOR dtl_retriever_cur IS
        SELECT dist_seq_no , peril_cd      , line_cd      ,
               share_cd    , dist_spct     , dist_tsi     ,
               dist_prem   , ann_dist_spct , ann_dist_tsi ,
               dist_grp    , item_no
          FROM giuw_itemperilds_dtl
         WHERE dist_no = p_dist_no;

      v_dist_seq_no            giuw_itemperilds_dtl.dist_seq_no%TYPE;
      v_item_no                giuw_itemperilds_dtl.item_no%TYPE;
      v_peril_cd               giuw_itemperilds_dtl.peril_cd%TYPE;
      v_line_cd                giuw_itemperilds_dtl.line_cd%TYPE;
      v_share_cd               giuw_itemperilds_dtl.share_cd%TYPE;
      v_dist_spct              giuw_itemperilds_dtl.dist_spct%TYPE;
      v_dist_tsi               giuw_itemperilds_dtl.dist_tsi%TYPE;
      v_dist_prem              giuw_itemperilds_dtl.dist_prem%TYPE;
      v_ann_dist_spct          giuw_itemperilds_dtl.ann_dist_spct%TYPE;
      v_ann_dist_tsi           giuw_itemperilds_dtl.ann_dist_tsi%TYPE;
      v_dist_grp               giuw_itemperilds_dtl.dist_grp%TYPE;

    BEGIN
      OPEN dtl_retriever_cur;
      LOOP
        FETCH dtl_retriever_cur 
         INTO v_dist_seq_no , v_peril_cd      , v_line_cd      ,
              v_share_cd    , v_dist_spct     , v_dist_tsi     ,
              v_dist_prem   , v_ann_dist_spct , v_ann_dist_tsi ,
              v_dist_grp    , v_item_no;
        EXIT WHEN dtl_retriever_cur%NOTFOUND;
        INSERT INTO  giuw_witemperilds_dtl
                    (dist_no           , dist_seq_no   , peril_cd        ,
                     line_cd           , share_cd      , dist_spct       , 
                     dist_tsi          , dist_prem     , ann_dist_spct   , 
                     ann_dist_tsi      , dist_grp      , item_no)
             VALUES (p_temp_distno     , v_dist_seq_no , v_peril_cd      ,
                     v_line_cd         , v_share_cd    , v_dist_spct     , 
                     v_dist_tsi        , v_dist_prem   , v_ann_dist_spct , 
                     v_ann_dist_tsi    , v_dist_grp    , v_item_no);
      END LOOP;
      CLOSE dtl_retriever_cur;
    END neg_itemperilds_dtl;
    
    /*
    **  Created by   :  Emman
    **  Date Created :  08.16.2011
    **  Reference By : (GIUTS021 - Redistribution)
    **  Description  : Creates a new distribution record in table GIUW_WITEMPERILDS_DTL
    **                 based on the values taken in by the fields of the negated
    **                 record.
    **                 NOTE:  The value of field DIST_NO was not copied, as the newly 
    **                  created distribution record has its own distribution number.
    */ 
    PROCEDURE NEG_ITEMPERILDS_DTL_GIUTS021(p_dist_no          IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                           p_temp_distno      IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                           p_var_v_neg_distno IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                           p_v_ratio          IN OUT NUMBER)
    IS
      CURSOR dtl_retriever_cur IS
        SELECT dist_seq_no , peril_cd      , line_cd      ,
               share_cd    , dist_spct     , dist_tsi     ,
               dist_prem   , ann_dist_spct , ann_dist_tsi ,
               dist_grp    , item_no       , dist_spct1 --added dist_spct1 edgar 09/22/2014
          FROM giuw_itemperilds_dtl
         WHERE dist_no = p_var_v_neg_distno;

      v_dist_seq_no            giuw_itemperilds_dtl.dist_seq_no%TYPE;
      v_item_no            giuw_itemperilds_dtl.item_no%TYPE;
      v_peril_cd            giuw_itemperilds_dtl.peril_cd%TYPE;
      v_line_cd            giuw_itemperilds_dtl.line_cd%TYPE;
      v_share_cd            giuw_itemperilds_dtl.share_cd%TYPE;
      v_dist_spct            giuw_itemperilds_dtl.dist_spct%TYPE;
      v_dist_spct1            giuw_policyds_dtl.dist_spct%type; --added dist_spct1 edgar 09/22/2014
      v_dist_tsi            giuw_itemperilds_dtl.dist_tsi%TYPE;
      v_dist_prem            giuw_itemperilds_dtl.dist_prem%TYPE;
      v_ann_dist_spct        giuw_itemperilds_dtl.ann_dist_spct%TYPE;
      v_ann_dist_tsi        giuw_itemperilds_dtl.ann_dist_tsi%TYPE;
      v_dist_grp            giuw_itemperilds_dtl.dist_grp%TYPE;
      v_dist_prem_f            giuw_itemperilds_dtl.dist_prem%TYPE;
      v_dist_prem_w            giuw_itemperilds_dtl.dist_prem%TYPE;
    BEGIN
      OPEN dtl_retriever_cur;
      LOOP
        FETCH dtl_retriever_cur 
         INTO v_dist_seq_no , v_peril_cd      , v_line_cd      ,
              v_share_cd    , v_dist_spct     , v_dist_tsi     ,
              v_dist_prem   , v_ann_dist_spct , v_ann_dist_tsi ,
              v_dist_grp    , v_item_no       , v_dist_spct1;--added dist_spct1 edgar 09/22/2014
        EXIT WHEN dtl_retriever_cur%NOTFOUND;
        v_dist_prem_f := ROUND(v_dist_prem * p_v_ratio,2);
        v_dist_prem_w := v_dist_prem - v_dist_prem_f;
        /* earned portion */
        INSERT INTO  giuw_witemperilds_dtl
                    (dist_no           , dist_seq_no   , peril_cd        ,
                     line_cd           , share_cd      , dist_spct       , 
                     dist_tsi          , dist_prem     , ann_dist_spct   , 
                     ann_dist_tsi      , dist_grp      , item_no         , dist_spct1)--added dist_spct1 edgar 09/22/2014
             VALUES (p_dist_no     , v_dist_seq_no , v_peril_cd      ,
                     v_line_cd         , v_share_cd    , v_dist_spct     , 
                     v_dist_tsi        , v_dist_prem_f , v_ann_dist_spct , 
                     v_ann_dist_tsi    , v_dist_grp    , v_item_no       , v_dist_spct1);--added dist_spct1 edgar 09/22/2014
        /* unearned portion */
        INSERT INTO  giuw_witemperilds_dtl
                    (dist_no           , dist_seq_no   , peril_cd        ,
                     line_cd           , share_cd      , dist_spct       , 
                     dist_tsi          , dist_prem     , ann_dist_spct   , 
                     ann_dist_tsi      , dist_grp      , item_no         , dist_spct1)--added dist_spct1 edgar 09/22/2014
             VALUES (p_temp_distno , v_dist_seq_no , v_peril_cd      ,
                     v_line_cd         , v_share_cd    , v_dist_spct     , 
                     v_dist_tsi        , v_dist_prem_w , v_ann_dist_spct , 
                     v_ann_dist_tsi    , v_dist_grp    , v_item_no       , v_dist_spct1);--added dist_spct1 edgar 09/22/2014
                     --forms_ddl('COMMIT');
      END LOOP;
      CLOSE dtl_retriever_cur;
    END NEG_ITEMPERILDS_DTL_GIUTS021;
    
    
/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 24, 2011
**  Reference By : GIUWS015 - Batch Distribution
**  Description  : Used for Post batch distribution process.     
*/

PROCEDURE POST_WITEMPERILDS_DTL_GIUWS015(p_batch_id  GIUW_POL_DIST.batch_id%TYPE,
                                         p_dist_no   GIUW_POL_DIST.dist_no%TYPE) IS

BEGIN
    
    DELETE GIUW_WITEMPERILDS_DTL
     WHERE dist_no = p_dist_no;
     
    DECLARE CURSOR C3 IS SELECT * FROM GIUW_WITEMPERILDS
                          WHERE dist_no = p_dist_no
                          ORDER BY dist_no;
                        
                        v_dist_tsi        GIUW_WITEMPERILDS.tsi_amt%TYPE;
                        v_dist_prem       GIUW_WITEMPERILDS.prem_amt%TYPE;
                        v_ann_dist_tsi    GIUW_WITEMPERILDS.ann_tsi_amt%TYPE;
                        v_dist_grp        CONSTANT GIUW_WPOLICYDS_DTL.dist_grp%TYPE := 1;

    BEGIN                             
        FOR C3_REC IN C3
        LOOP
            DECLARE 
                CURSOR C4 IS SELECT line_cd, share_cd, dist_spct
                               FROM GIUW_DIST_BATCH_DTL
                             WHERE batch_id = p_batch_id;
            BEGIN
                FOR C4_REC IN C4
                LOOP
                    v_dist_tsi     := C3_REC.tsi_amt * (C4_REC.dist_spct/100);
                    v_dist_prem    := C3_REC.prem_amt * (C4_REC.dist_spct/100);
                    v_ann_dist_tsi := C3_REC.ann_tsi_amt * (C4_REC.dist_spct/100);
                                    
                    INSERT INTO GIUW_WITEMPERILDS_DTL(
                            dist_no,              dist_seq_no,              item_no,                 peril_cd,                
                            line_cd,              share_cd,                 dist_tsi,                dist_prem,            
                            dist_spct,            dist_spct1,               ann_dist_tsi,            dist_grp,
                            ann_dist_spct)
                             VALUES( 
                            C3_REC.dist_no,       C3_REC.dist_seq_no,       C3_REC.item_no,          C3_REC.peril_cd,
                            C3_REC.line_cd,       C4_REC.share_cd,          v_dist_tsi,              v_dist_prem,
                            C4_REC.dist_spct,     NULL,                     v_ann_dist_tsi,          v_dist_grp,
                            C4_REC.dist_spct);
                
                 END LOOP;
            END;
        END LOOP;
    END;
END;

END GIUW_WITEMPERILDS_DTL_PKG;
/


