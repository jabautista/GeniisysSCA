CREATE OR REPLACE PACKAGE BODY CPI.GIUW_WPERILDS_DTL_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description     : Contains the Insert / Update / Delete procedure of the table
    */
    PROCEDURE del_giuw_wperilds_dtl (p_dist_no     GIUW_WPERILDS_DTL.dist_no%TYPE)
    IS
    BEGIN
        DELETE   GIUW_WPERILDS_DTL
         WHERE   dist_no  =  p_dist_no;
    END del_giuw_wperilds_dtl;
    
    /*
    **  Created by        : Mark JM
    **  Date Created     : 03.31.2011
    **  Reference By     : (GIUWS003 - Preliminary Peril Distribution)
    **  Description     : Retrieve records on giuw_wperilds_dtl based on the given parameter
    */
    FUNCTION get_giuw_wperilds_dtl (
        p_dist_no IN giuw_wperilds_dtl.dist_no%TYPE,
        p_dist_seq_no IN giuw_wperilds_dtl.dist_seq_no%TYPE,
        p_line_cd IN giuw_wperilds_dtl.line_cd%TYPE,
        p_peril_cd IN giuw_wperilds_dtl.peril_cd%TYPE)
    RETURN giuw_wperilds_dtl_tab PIPELINED
    IS
        v_wperilds_dtl giuw_wperilds_dtl_type;
    BEGIN
        FOR i IN (
            SELECT a.dist_no,        a.dist_seq_no,    a.line_cd,    a.peril_cd,
                   a.share_cd,        a.dist_spct,    a.dist_tsi,    a.dist_prem,
                   a.ann_dist_spct,    a.ann_dist_tsi,    a.dist_grp,    a.dist_spct1,
                   a.arc_ext_data,    b.trty_name
              FROM giuw_wperilds_dtl a,
                   giis_dist_share b
             WHERE a.dist_no = p_dist_no
               AND a.dist_seq_no = p_dist_seq_no
               AND a.line_cd = p_line_cd
               AND a.peril_cd = p_peril_cd
               AND a.line_cd = b.line_cd
               AND a.share_cd = b.share_cd(+))
        LOOP
            v_wperilds_dtl.dist_no            := i.dist_no;
            v_wperilds_dtl.dist_seq_no        := i.dist_seq_no;
            v_wperilds_dtl.line_cd            := i.line_cd;
            v_wperilds_dtl.peril_cd            := i.peril_cd;
            v_wperilds_dtl.share_cd            := i.share_cd;
            v_wperilds_dtl.dist_spct        := i.dist_spct;
            v_wperilds_dtl.dist_tsi            := i.dist_tsi;
            v_wperilds_dtl.dist_prem        := i.dist_prem;
            v_wperilds_dtl.ann_dist_spct    := i.ann_dist_spct;
            v_wperilds_dtl.ann_dist_tsi        := i.ann_dist_tsi;
            v_wperilds_dtl.dist_grp            := i.dist_grp;
            v_wperilds_dtl.dist_spct1        := i.dist_spct1;
            v_wperilds_dtl.arc_ext_data        := i.arc_ext_data;
            v_wperilds_dtl.trty_name        := i.trty_name;
            
            PIPE ROW(v_wperilds_dtl);
        END LOOP;
        
        RETURN;
    END get_giuw_wperilds_dtl;
	
	PROCEDURE set_giuw_wperilds_dtl(
		p_dist_no				giuw_wperilds_dtl.dist_no%TYPE,
		p_dist_seq_no			giuw_wperilds_dtl.dist_seq_no%TYPE,
		p_line_cd				giuw_wperilds_dtl.line_cd%TYPE,
		p_peril_cd				giuw_wperilds_dtl.peril_cd%TYPE,
		p_share_cd				giuw_wperilds_dtl.share_cd%TYPE,
		p_dist_spct				giuw_wperilds_dtl.dist_spct%TYPE,
		p_dist_tsi				giuw_wperilds_dtl.dist_tsi%TYPE,
		p_dist_prem				giuw_wperilds_dtl.dist_prem%TYPE,
		p_ann_dist_spct			giuw_wperilds_dtl.ann_dist_spct%TYPE,
		p_ann_dist_tsi			giuw_wperilds_dtl.ann_dist_tsi%TYPE,
		p_dist_grp				giuw_wperilds_dtl.dist_grp%TYPE,
		p_dist_spct1			giuw_wperilds_dtl.dist_spct1%TYPE,
		p_arc_ext_data			giuw_wperilds_dtl.arc_ext_data%TYPE)
	IS
	BEGIN
		MERGE INTO giuw_wperilds_dtl
	USING dual ON (dist_no			= p_dist_no
		  	   AND dist_seq_no		= p_dist_seq_no
			   AND line_cd			= p_line_cd
			   AND peril_cd			= p_peril_cd
			   AND share_cd			= p_share_cd)
		WHEN NOT MATCHED THEN
		   INSERT (dist_no,	 		dist_seq_no,   		line_cd,	 	 peril_cd,
		   		   share_cd,		dist_spct,			dist_tsi,		 dist_prem,
				   ann_dist_spct,	ann_dist_tsi,		dist_grp,		 dist_spct1,
				   arc_ext_data)
		   VALUES (p_dist_no,	 	p_dist_seq_no,   	p_line_cd,	 	 p_peril_cd,
		   		   p_share_cd,		p_dist_spct,		p_dist_tsi,		 p_dist_prem,
				   p_ann_dist_spct,	p_ann_dist_tsi,		p_dist_grp,		 p_dist_spct1,
				   p_arc_ext_data)
		WHEN MATCHED THEN
			UPDATE SET
				   dist_spct	  	= p_dist_spct,
				   dist_tsi			= p_dist_tsi,
				   dist_prem		= p_dist_prem,
				   ann_dist_spct	= p_ann_dist_spct,
				   ann_dist_tsi		= p_ann_dist_tsi,
				   dist_grp			= p_dist_grp,
				   dist_spct1		= p_dist_spct1,
				   arc_ext_data		= p_arc_ext_data;
	END set_giuw_wperilds_dtl;
	
	/*
	**  Created by		: Emman
	**  Date Created 	: 06.03.2011
    **  Reference By     : (GIUWS003 - Preliminary Peril Distribution)
    **  Description     : Delete procedure of the table, based on the primary keys
    */
	PROCEDURE del_giuw_wperilds_dtl2(p_dist_no     GIUW_WPERILDS_DTL.dist_no%TYPE,
			  						 p_dist_seq_no GIUW_WPERILDS.dist_seq_no%TYPE,
									 p_line_cd	   GIUW_WPERILDS.line_cd%TYPE,
									 p_peril_cd	   GIUW_WPERILDS.peril_cd%TYPE,
									 p_share_cd	   GIUW_WPERILDS_DTL.share_cd%TYPE)
    IS
    BEGIN
        DELETE   GIUW_WPERILDS_DTL
         WHERE   dist_no  		  =  p_dist_no
		   AND	 dist_seq_no	  =	 p_dist_seq_no
		   AND	 line_cd		  =  p_line_cd
		   AND	 peril_cd		  =	 p_peril_cd
		   AND	 share_cd		  =	 p_share_cd;
    END del_giuw_wperilds_dtl2;
	
	/*
	**  Created by		: Anthony Santos
	**  Date Created 	: 07.09.2011
    **  Reference By     : (GIUWS013 - One Risk
    */
	PROCEDURE post_wperilds_dtl (
	   p_dist_no             giuw_pol_dist.dist_no%TYPE
	)
	IS
	  v_count    NUMBER(1);
	BEGIN
	
	  /* Get the value of the columns in table GIUW_WPERILDS 
	  ** in preparation for insertion or update to its corresponding
	  ** master table GIUW_PERILDS. */
	  FOR wds_cur IN (  SELECT dist_no     , dist_seq_no , line_cd     ,
	                           peril_cd    , tsi_amt     , prem_amt    ,
	                           ann_tsi_amt
	                      FROM giuw_wperilds
	                     WHERE dist_no = p_dist_no
	                  ORDER BY dist_no     , dist_seq_no , line_cd     ,
	                           peril_cd)
	  LOOP
	    v_count  :=  NULL;
	
	    /* If the record corresponding to the specified DIST_NO
	    ** DIST_SEQ_NO, LINE_CD and PERIL_CD does not exist in table
	    ** GIUW_PERILDS, then the record in table GIUW_WPERILDS must be
	    ** inserted to the said table. */ 
	    IF v_count IS NULL THEN
	       INSERT INTO  giuw_perilds
	                   (dist_no             , dist_seq_no         , line_cd          ,
	                    peril_cd            , tsi_amt             , prem_amt         , 
	                    ann_tsi_amt)
	            VALUES (wds_cur.dist_no     , wds_cur.dist_seq_no , wds_cur.line_cd  ,
	                    wds_cur.peril_cd    , wds_cur.tsi_amt     , wds_cur.prem_amt ,
	                    wds_cur.ann_tsi_amt);
	     END IF;
	  END LOOP;
	
	  /* Get the value of the columns in table GIUW_WPERILDS_DTL 
	  ** in preparation for insertion or update to its corresponding
	  ** master table GIUW_PERILDS_DTL. */ 
	  FOR wds_dtl_cur IN (  SELECT dist_no      , dist_seq_no   , peril_cd      ,
	                               line_cd      , share_cd      , dist_tsi      ,
	                               dist_prem    , dist_spct     , ann_dist_spct ,
	                               ann_dist_tsi , dist_grp
	                          FROM giuw_wperilds_dtl
	                         WHERE dist_no = p_dist_no
	                      ORDER BY dist_no      , dist_seq_no   , line_cd       ,
	                               peril_cd     , share_cd)
	  LOOP
	    v_count  :=  NULL;
	
	    /* If the record corresponding to the specified DIST_NO, DIST_SEQ_NO, 
	    ** LINE_CD, PERIL_CD and SHARE_CD does not exist in table GIUW_PERILDS_DTL,
	    ** then the record in table GIUW_WPERILDS_DTL must be inserted to the
	    ** said table. */ 
	    IF v_count IS NULL THEN
	       INSERT INTO  giuw_perilds_dtl
	                   (dist_no                   , dist_seq_no               ,
	                    peril_cd                  , line_cd                   ,
	                    share_cd                  , dist_tsi                  ,
	                    dist_prem                 , dist_spct                 ,
	                    ann_dist_spct             , ann_dist_tsi              ,
	                    dist_grp                  , dist_spct1)
	            VALUES (wds_dtl_cur.dist_no       , wds_dtl_cur.dist_seq_no   , 
	                    wds_dtl_cur.peril_cd      , wds_dtl_cur.line_cd       ,
	                    wds_dtl_cur.share_cd      , wds_dtl_cur.dist_tsi      ,
	                    wds_dtl_cur.dist_prem     , wds_dtl_cur.dist_spct     ,
	                    wds_dtl_cur.ann_dist_spct , wds_dtl_cur.ann_dist_tsi  ,
	                    wds_dtl_cur.dist_grp      , NULL);
	    END IF;
	  END LOOP;
	END post_wperilds_dtl;
    
   /*
   **  Created by        : Jerome Orio
   **  Date Created     : 08.01.2011
   **  Reference By     : (GIUWS017 - Dist by TSI/Prem (Peril))
   **  Description     :
   */
    FUNCTION get_giuw_wperilds_dtl_exist (
      p_dist_no   giuw_wperilds_dtl.dist_no%TYPE)
    RETURN VARCHAR2 IS
      v_exist   VARCHAR2 (1) := 'N';
    BEGIN
      FOR x IN (SELECT '1'
                  FROM giuw_wperilds_dtl
                 WHERE dist_no = p_dist_no)
      LOOP
         v_exist := 'Y';
         EXIT;
      END LOOP;

      RETURN v_exist;
    END;
    
/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 2, 2011
**  Reference By : GIUWS016 - One-Risk Distribution by TSI/Prem (Group)
**  Description  : Post records retrieved from the working tables to their 
**                 corresponding master tables.
**                 Create or update non-existing or existing records of tables
**                 GIUW_PERILDS and GIUW_PERILDS_DTL based on the data retrieved
**                 from working tables GIUW_WPERILDS and GIUW_WPERILDS_DTL.
*/

    PROCEDURE post_wperilds_dtl_giuws016 (p_dist_no      IN       giuw_pol_dist.dist_no%TYPE) IS
      
      v_count    NUMBER(1);

    BEGIN

      /* Get the value of the columns in table GIUW_WPERILDS 
      ** in preparation for insertion or update to its corresponding
      ** master table GIUW_PERILDS. */
      FOR wds_cur IN (  SELECT dist_no     , dist_seq_no , line_cd     ,
                               peril_cd    , tsi_amt     , prem_amt    ,
                               ann_tsi_amt
                          FROM GIUW_WPERILDS
                         WHERE dist_no = p_dist_no
                      ORDER BY dist_no  , dist_seq_no , line_cd     ,
                               peril_cd)
      LOOP
        v_count  :=  NULL;


        /* If the record corresponding to the specified DIST_NO
        ** DIST_SEQ_NO, LINE_CD and PERIL_CD does not exist in table
        ** GIUW_PERILDS, then the record in table GIUW_WPERILDS must be
        ** inserted to the said table. */ 
        IF v_count IS NULL THEN
           INSERT INTO  GIUW_PERILDS
                       (dist_no             , dist_seq_no         , line_cd          ,
                        peril_cd            , tsi_amt             , prem_amt         , 
                        ann_tsi_amt)
                VALUES (wds_cur.dist_no     , wds_cur.dist_seq_no , wds_cur.line_cd  ,
                        wds_cur.peril_cd    , wds_cur.tsi_amt     , wds_cur.prem_amt ,
                        wds_cur.ann_tsi_amt);
         END IF;
      END LOOP;

      /* Get the value of the columns in table GIUW_WPERILDS_DTL 
      ** in preparation for insertion or update to its corresponding
      ** master table GIUW_PERILDS_DTL. */ 
      FOR wds_dtl_cur IN (  SELECT dist_no      , dist_seq_no   , peril_cd      ,
                                   line_cd      , share_cd      , dist_tsi      ,
                                   dist_prem    , dist_spct     , ann_dist_spct ,
                                   ann_dist_tsi , dist_grp      , dist_spct1
                              FROM GIUW_WPERILDS_DTL
                             WHERE dist_no = p_dist_no
                          ORDER BY dist_no      , dist_seq_no   , line_cd       ,
                                   peril_cd     , share_cd)
      LOOP
        v_count  :=  NULL;

        /* If the record corresponding to the specified DIST_NO, DIST_SEQ_NO, 
        ** LINE_CD, PERIL_CD and SHARE_CD does not exist in table GIUW_PERILDS_DTL,
        ** then the record in table GIUW_WPERILDS_DTL must be inserted to the
        ** said table. */ 
        IF v_count IS NULL THEN
           INSERT INTO  GIUW_PERILDS_DTL
                       (dist_no                   , dist_seq_no               ,
                        peril_cd                  , line_cd                   ,
                        share_cd                  , dist_tsi                  ,
                        dist_prem                 , dist_spct                 ,
                        ann_dist_spct             , ann_dist_tsi              ,
                        dist_grp                  , dist_spct1)
                VALUES (wds_dtl_cur.dist_no       , wds_dtl_cur.dist_seq_no   , 
                        wds_dtl_cur.peril_cd      , wds_dtl_cur.line_cd       ,
                        wds_dtl_cur.share_cd      , wds_dtl_cur.dist_tsi      ,
                        wds_dtl_cur.dist_prem     , wds_dtl_cur.dist_spct     ,
                        wds_dtl_cur.ann_dist_spct , wds_dtl_cur.ann_dist_tsi  ,
                        wds_dtl_cur.dist_grp      , wds_dtl_cur.dist_spct1);
        END IF;
      END LOOP;
    END;
   
    /*
    **  Created by   : Robert John Virrey 
    **  Date Created : August 4, 2011
    **  Reference By : GIUTS002 - Distribution Negation 
    **  Description  : Creates a new distribution record in table GIUW_WPERILDS_DTL
    **                  based on the values taken in by the fields of the negated
    **                  record
    */
    PROCEDURE neg_perilds_dtl (
        p_dist_no     IN  giuw_perilds_dtl.dist_no%TYPE,
        p_temp_distno IN  giuw_perilds_dtl.dist_no%TYPE
    ) 
    IS

      CURSOR dtl_retriever_cur IS
        SELECT dist_seq_no , peril_cd      , line_cd      ,
               share_cd    , dist_spct     , dist_tsi     ,
               dist_prem   , ann_dist_spct , ann_dist_tsi ,
               dist_grp
          FROM giuw_perilds_dtl
         WHERE dist_no = p_dist_no;

      v_dist_seq_no            giuw_perilds_dtl.dist_seq_no%type;
      v_peril_cd               giuw_perilds_dtl.peril_cd%type;
      v_line_cd                giuw_perilds_dtl.line_cd%type;
      v_share_cd               giuw_perilds_dtl.share_cd%type;
      v_dist_spct              giuw_perilds_dtl.dist_spct%type;
      v_dist_tsi               giuw_perilds_dtl.dist_tsi%type;
      v_dist_prem              giuw_perilds_dtl.dist_prem%type;
      v_ann_dist_spct          giuw_perilds_dtl.ann_dist_spct%type;
      v_ann_dist_tsi           giuw_perilds_dtl.ann_dist_tsi%type;
      v_dist_grp               giuw_perilds_dtl.dist_grp%type;

    BEGIN
      OPEN dtl_retriever_cur;
      LOOP
        FETCH dtl_retriever_cur 
         INTO v_dist_seq_no , v_peril_cd      , v_line_cd      ,
              v_share_cd    , v_dist_spct     , v_dist_tsi     ,
              v_dist_prem   , v_ann_dist_spct , v_ann_dist_tsi ,
              v_dist_grp;
        EXIT WHEN dtl_retriever_cur%NOTFOUND;
        INSERT INTO  giuw_wperilds_dtl
                    (dist_no           , dist_seq_no   , peril_cd        ,
                     line_cd           , share_cd      , dist_spct       , 
                     dist_tsi          , dist_prem     , ann_dist_spct   , 
                     ann_dist_tsi      , dist_grp)
             VALUES (p_temp_distno     , v_dist_seq_no , v_peril_cd      ,
                     v_line_cd         , v_share_cd    , v_dist_spct     , 
                     v_dist_tsi        , v_dist_prem   , v_ann_dist_spct , 
                     v_ann_dist_tsi    , v_dist_grp);
      END LOOP;
      CLOSE dtl_retriever_cur;
    END neg_perilds_dtl;    
    
    /*
    **  Created by   :  Emman
    **  Date Created :  08.16.2011
    **  Reference By : (GIUTS021 - Redistribution)
    **                  Description  : Creates a new distribution record in table GIUW_WPERILDS_DTL
    **                  based on the values taken in by the fields of the negated
    **                  record.
    **                  NOTE:  The value of field DIST_NO was not copied, as the newly 
    **                  created distribution record has its own distribution number.
    */ 
    PROCEDURE NEG_PERILDS_DTL_GIUTS021(p_dist_no          IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                      p_temp_distno      IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                      p_var_v_neg_distno IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                      p_v_ratio          IN OUT NUMBER)
    IS

      CURSOR dtl_retriever_cur IS
        SELECT dist_seq_no , peril_cd      , line_cd      ,
               share_cd    , dist_spct     , dist_tsi     ,
               dist_prem   , ann_dist_spct , ann_dist_tsi ,
               dist_grp    , dist_spct1 --added dist_spct1 edgar 09/22/2014
          FROM giuw_perilds_dtl
         WHERE dist_no = p_var_v_neg_distno;

      v_dist_seq_no            giuw_perilds_dtl.dist_seq_no%type;
      v_peril_cd            giuw_perilds_dtl.peril_cd%type;
      v_line_cd            giuw_perilds_dtl.line_cd%type;
      v_share_cd            giuw_perilds_dtl.share_cd%type;
      v_dist_spct            giuw_perilds_dtl.dist_spct%type;
      v_dist_spct1            giuw_policyds_dtl.dist_spct%type; --added dist_spct1 edgar 09/22/2014
      v_dist_tsi            giuw_perilds_dtl.dist_tsi%type;
      v_dist_prem            giuw_perilds_dtl.dist_prem%type;
      v_dist_prem_f            giuw_perilds_dtl.dist_prem%type;
      v_dist_prem_w            giuw_perilds_dtl.dist_prem%type;
      v_ann_dist_spct        giuw_perilds_dtl.ann_dist_spct%type;
      v_ann_dist_tsi        giuw_perilds_dtl.ann_dist_tsi%type;
      v_dist_grp            giuw_perilds_dtl.dist_grp%type;

    BEGIN
      OPEN dtl_retriever_cur;
      LOOP
        FETCH dtl_retriever_cur 
         INTO v_dist_seq_no , v_peril_cd      , v_line_cd      ,
              v_share_cd    , v_dist_spct     , v_dist_tsi     ,
              v_dist_prem   , v_ann_dist_spct , v_ann_dist_tsi ,
              v_dist_grp    , v_dist_spct1;--added dist_spct1 edgar 09/22/2014
        EXIT WHEN dtl_retriever_cur%NOTFOUND;
        v_dist_prem_f := ROUND(v_dist_prem * p_v_ratio,2);
        v_dist_prem_w := v_dist_prem - v_dist_prem_f;
        /* earned portion */
        INSERT INTO  giuw_wperilds_dtl
                    (dist_no           , dist_seq_no   , peril_cd        ,
                     line_cd           , share_cd      , dist_spct       , 
                     dist_tsi          , dist_prem     , ann_dist_spct   , 
                     ann_dist_tsi      , dist_grp      , dist_spct1)--added dist_spct1 edgar 09/22/2014
             VALUES (p_dist_no     , v_dist_seq_no , v_peril_cd      ,
                     v_line_cd         , v_share_cd    , v_dist_spct     , 
                     v_dist_tsi        , v_dist_prem_f , v_ann_dist_spct , 
                     v_ann_dist_tsi    , v_dist_grp    , v_dist_spct1);--added dist_spct1 edgar 09/22/2014
        /* unearned portion */
        INSERT INTO  giuw_wperilds_dtl
                    (dist_no           , dist_seq_no   , peril_cd        ,
                     line_cd           , share_cd      , dist_spct       , 
                     dist_tsi          , dist_prem     , ann_dist_spct   , 
                     ann_dist_tsi      , dist_grp      , dist_spct1)--added dist_spct1 edgar 09/22/2014
             VALUES (p_temp_distno , v_dist_seq_no , v_peril_cd      ,
                     v_line_cd         , v_share_cd    , v_dist_spct     , 
                     v_dist_tsi        , v_dist_prem_w , v_ann_dist_spct , 
                     v_ann_dist_tsi    , v_dist_grp    , v_dist_spct1);--added dist_spct1 edgar 09/22/2014
                     --forms_ddl('COMMIT');
      END LOOP;
      CLOSE dtl_retriever_cur;
    END NEG_PERILDS_DTL_GIUTS021;
    
/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 24, 2011
**  Reference By : GIUWS015 - Batch Distribution
**  Description  : Used for Post batch distribution process.     
*/

    PROCEDURE POST_WPERILDS_DTL_GIUWS015 (p_batch_id    GIUW_POL_DIST.batch_id%TYPE,
                                          p_dist_no GIUW_POL_DIST.dist_no%TYPE) 
    IS

    BEGIN
        
      DELETE GIUW_WPERILDS_DTL
       WHERE dist_no = p_dist_no;

        DECLARE
          CURSOR C3 IS SELECT * FROM GIUW_WPERILDS
                        WHERE dist_no = p_dist_no
                     ORDER BY dist_no, peril_cd;
              
              v_dist_tsi       GIUW_WPOLICYDS.tsi_amt%TYPE;
              v_dist_prem      GIUW_WPOLICYDS.prem_amt%TYPE;
              v_ann_dist_tsi   GIUW_WPOLICYDS.ann_tsi_amt%TYPE;
              v_dist_grp       CONSTANT GIUW_WPOLICYDS_DTL.dist_grp%TYPE := 1;
      BEGIN
          FOR c3_rec IN C3 
          LOOP 
            DECLARE
              CURSOR C4 IS SELECT line_cd, share_cd, dist_spct 
                             FROM GIUW_DIST_BATCH_DTL
                            WHERE batch_id = p_batch_id;
          BEGIN     
              FOR c4_rec IN C4 LOOP
                    v_dist_tsi     := c3_rec.tsi_amt * (c4_rec.dist_spct/100);
                    v_dist_prem    := c3_rec.prem_amt * (c4_rec.dist_spct/100);
                    v_ann_dist_tsi := c3_rec.ann_tsi_amt * (c4_rec.dist_spct/100);
                    INSERT INTO GIUW_WPERILDS_DTL(
                               dist_no,       dist_seq_no,       peril_cd,        line_cd,            share_cd,
                               dist_tsi,      dist_prem,         dist_spct,       dist_spct1,         ann_dist_tsi,  
                               dist_grp,      ann_dist_spct) 
                      VALUES ( c3_rec.dist_no   ,c3_rec.dist_seq_no     ,c3_rec.peril_cd    ,c4_rec.line_cd     ,c4_rec.share_cd,
                               v_dist_tsi       ,v_dist_prem            ,c4_rec.dist_spct   ,NULL               ,v_ann_dist_tsi,
                               v_dist_grp       ,c4_rec.dist_spct);
            END LOOP;
          END;

        END LOOP;
      END;    
    END;

END GIUW_WPERILDS_DTL_PKG;
/


