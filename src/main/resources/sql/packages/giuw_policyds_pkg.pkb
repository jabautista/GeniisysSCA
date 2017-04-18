CREATE OR REPLACE PACKAGE BODY CPI.GIUW_POLICYDS_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/
	PROCEDURE del_giuw_policyds (p_dist_no 	GIUW_POLICYDS.dist_no%TYPE)
	IS
	BEGIN
		DELETE GIUW_POLICYDS
		 WHERE dist_no = p_dist_no;
	END del_giuw_policyds;
	
	/*
	**  Created by		: Anthony Santos
	**  Date Created 	: 07.19.2010
	**  Reference By 	: (GIUWS013 - One Risk)
	**  
	*/
	PROCEDURE post_wpolicyds_dtl (
		  p_dist_no	  GIUW_POL_DIST.dist_no%TYPE,
		  p_endt_seq_no GIPI_POLBASIC_POL_DIST_V1.endt_seq_no%TYPE,
		  p_eff_date GIPI_POLBASIC_POL_DIST_V1.eff_date%TYPE,
		  p_message OUT VARCHAR2
	)
	IS
	  v_count      NUMBER(1);
	  valid_sw     VARCHAR2(1) := 'Y';
	BEGIN
	
	  /* Get the value of the columns in table GIUW_WPOLICYDS 
	  ** in preparation for insertion or update to its corresponding
	  ** master table GIUW_POLICYDS. */ 
	  FOR wds_cur IN ( SELECT dist_no     , dist_seq_no , tsi_amt  , 
	                          prem_amt    , ann_tsi_amt , item_grp
	                     FROM giuw_wpolicyds
	                    WHERE dist_no = p_dist_no
	                 ORDER BY dist_no , dist_seq_no)
	  LOOP
	    v_count  :=  NULL;
	
	    /* If the record corresponding to the specified DIST_NO
	    ** and DIST_SEQ_NO does not exist in table GIUW_POLICYDS,
	    ** then the record in table GIUW_WPOLICYDS must be inserted
	    ** to the said table. */ 
	    IF v_count IS NULL THEN
	       INSERT INTO  giuw_policyds
	                   (dist_no             , dist_seq_no         ,
	                    tsi_amt             , prem_amt            ,
	                    ann_tsi_amt         , item_grp)
	            VALUES (wds_cur.dist_no     , wds_cur.dist_seq_no , 
	                    wds_cur.tsi_amt     , wds_cur.prem_amt    , 
	                    wds_cur.ann_tsi_amt , wds_cur.item_grp);
	    END IF;
	  END LOOP;
	
	  /* Get the value of the columns in table GIUW_WPOLICYDS_DTL 
	  ** in preparation for insertion or update to its corresponding
	  ** master table GIUW_POLICYDS_DTL. */ 
	  FOR wds_dtl_cur IN (  SELECT a.dist_no   , a.dist_seq_no   , a.line_cd      , 
	                               a.share_cd  , a.dist_tsi      , a.dist_prem    ,
	                               a.dist_spct , a.ann_dist_spct , a.ann_dist_tsi ,
	                               a.dist_grp  , b.share_type    , b.expiry_date  ,
	                               b.trty_name , b.eff_date      , b.prtfolio_sw
	                          FROM giuw_wpolicyds_dtl a, giis_dist_share b
	                         WHERE a.share_cd = b.share_cd
	                           AND a.line_cd  = b.line_cd
	                           AND a.dist_no  = p_dist_no
	                      ORDER BY a.dist_no  , a.dist_seq_no    , a.line_cd      ,
	                               a.share_cd)
	  LOOP
	    v_count  :=  NULL;
	    FOR flag IN 
	        ( SELECT a.dist_flag
	            FROM giuw_pol_dist a, giuw_distrel b
	           WHERE a.dist_no = b.dist_no_old
	             AND b.dist_no_new = p_dist_no
	        ) LOOP
	        IF flag.dist_flag = '5' THEN
	        	 valid_sw := 'N';
	        END IF;	 	
	    END LOOP;    	      
	    IF wds_dtl_cur.share_type = '2' AND
	    	 valid_sw = 'Y' AND NVL(p_endt_seq_no , 0) = 0 THEN
	       IF TRUNC(p_eff_date) > TRUNC(wds_dtl_cur.expiry_date) AND 
	       	  nvl(wds_dtl_cur.prtfolio_sw,'N') = 'P' THEN
	          
	          /* Closes the warning canvas and
	          ** sets the cursor style to default. */
	
	          p_message := 'Treaty ' || wds_dtl_cur.trty_name || ' has already expired.  ' ||
	                    'Replace the treaty with another one.';
			  RETURN;			
	       END IF;
	    END IF;
	
	    /* If the record corresponding to the specified DIST_NO,
	    ** DIST_SEQ_NO, LINE_CD, SHARE_CD does not exist in table
	    ** GIUW_POLICYDS_DTL, then the record in table GIUW_WPOLICYDS_DTL
	    ** must be inserted to the said table. */ 
	    IF v_count IS NULL THEN
	       INSERT INTO  giuw_policyds_dtl
	                   (dist_no                  , dist_seq_no               ,
	                    line_cd                  , share_cd                  ,
	                    dist_tsi                 , dist_prem                 ,
	                    dist_spct                , ann_dist_spct             ,
	                    ann_dist_tsi             , dist_grp                  ,
	                    dist_spct1)
	            VALUES (wds_dtl_cur.dist_no      , wds_dtl_cur.dist_seq_no   , 
	                    wds_dtl_cur.line_cd      , wds_dtl_cur.share_cd      , 
	                    wds_dtl_cur.dist_tsi     , wds_dtl_cur.dist_prem     ,
	                    wds_dtl_cur.dist_spct    , wds_dtl_cur.ann_dist_spct , 
	                    wds_dtl_cur.ann_dist_tsi , wds_dtl_cur.dist_grp      ,
	                    NULL);
	    END IF;
	  END LOOP;
	END post_wpolicyds_dtl;
    
/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 2, 2011
**  Reference By : GIUWS016 - One-Risk Distribution by TSI/Prem (Group)
**  Description  : Post records retrieved from the working tables to their 
** 				   corresponding master tables.
** 				   Create or update non-existing or existing records of tables
** 				   GIUW_POLICYDS and GIUW_POLICYDS_DTL based on the data retrieved
** 				   from working tables GIUW_WPOLICYDS and GIUW_WPOLICYDS_DTL.
*/
    
  PROCEDURE post_wpolicyds_dtl_giuws016 (
      p_dist_no     IN   GIUW_POL_DIST.dist_no%TYPE,
      p_eff_date    IN   GIPI_POLBASIC_POL_DIST_V1.eff_date%TYPE,
      p_message     OUT  VARCHAR2) 
      
      IS
      
      v_count      NUMBER(1);
      
    BEGIN

      /* Get the value of the columns in table GIUW_WPOLICYDS 
      ** in preparation for insertion or update to its corresponding
      ** master table GIUW_POLICYDS. */ 
      FOR wds_cur IN ( SELECT dist_no     , dist_seq_no , tsi_amt  , 
                              prem_amt    , ann_tsi_amt , item_grp
                         FROM GIUW_WPOLICYDS
                        WHERE dist_no = p_dist_no
                     ORDER BY dist_no , dist_seq_no)
      LOOP
        v_count  :=  NULL;

        /* If the record corresponding to the specified DIST_NO
        ** and DIST_SEQ_NO does not exist in table GIUW_POLICYDS,
        ** then the record in table GIUW_WPOLICYDS must be inserted
        ** to the said table. */ 
        IF v_count IS NULL THEN
           INSERT INTO  GIUW_POLICYDS
                       (dist_no             , dist_seq_no         ,
                        tsi_amt             , prem_amt            ,
                        ann_tsi_amt         , item_grp)
                VALUES (wds_cur.dist_no     , wds_cur.dist_seq_no , 
                        wds_cur.tsi_amt     , wds_cur.prem_amt    , 
                        wds_cur.ann_tsi_amt , wds_cur.item_grp);
        END IF;
      END LOOP;

      /* Get the value of the columns in table GIUW_WPOLICYDS_DTL 
      ** in preparation for insertion or update to its corresponding
      ** master table GIUW_POLICYDS_DTL. */ 
      FOR wds_dtl_cur IN (  SELECT a.dist_no   , a.dist_seq_no   , a.line_cd      , 
                                   a.share_cd  , a.dist_tsi      , a.dist_prem    ,
                                   a.dist_spct , a.ann_dist_spct , a.ann_dist_tsi ,
                                   a.dist_grp  , b.share_type    , b.expiry_date  ,
                                   b.trty_name , b.eff_date      , a.dist_spct1   ,
                                   b.prtfolio_sw 
                              FROM GIUW_WPOLICYDS_DTL a, GIIS_DIST_SHARE b
                             WHERE a.share_cd = b.share_cd
                               AND a.line_cd  = b.line_cd
                               AND a.dist_no  = p_dist_no
                          ORDER BY a.dist_no  , a.dist_seq_no    , a.line_cd      ,
                                   a.share_cd)
      LOOP
        v_count  :=  NULL;

        IF wds_dtl_cur.share_type = '2' THEN
           IF TRUNC(p_eff_date) > TRUNC(wds_dtl_cur.expiry_date) AND 
                 NVL(wds_dtl_cur.prtfolio_sw,'N') = 'P' THEN
              
              --FORMS_DDL('ROLLBACK');

              /* Closes the warning canvas and
              ** sets the cursor style to default. */
              --CURSOR_NORMAL;          

              p_message := ('Treaty ' || wds_dtl_cur.trty_name || ' has already expired.  ' ||
                            'Replace the treaty with another one.');
           END IF;
        END IF;

        /* If the record corresponding to the specified DIST_NO,
        ** DIST_SEQ_NO, LINE_CD, SHARE_CD does not exist in table
        ** GIUW_POLICYDS_DTL, then the record in table GIUW_WPOLICYDS_DTL
        ** must be inserted to the said table. */ 
        IF v_count IS NULL THEN
           INSERT INTO  GIUW_POLICYDS_DTL
                       (dist_no                  , dist_seq_no               ,
                        line_cd                  , share_cd                  ,
                        dist_tsi                 , dist_prem                 ,
                        dist_spct                , ann_dist_spct             ,
                        ann_dist_tsi             , dist_grp                  ,
                        dist_spct1)
                VALUES (wds_dtl_cur.dist_no      , wds_dtl_cur.dist_seq_no   , 
                        wds_dtl_cur.line_cd      , wds_dtl_cur.share_cd      , 
                        wds_dtl_cur.dist_tsi     , wds_dtl_cur.dist_prem     ,
                        wds_dtl_cur.dist_spct    , wds_dtl_cur.ann_dist_spct , 
                        wds_dtl_cur.ann_dist_tsi , wds_dtl_cur.dist_grp      ,
                        wds_dtl_cur.dist_spct1);
        END IF;
      END LOOP;
    END;
    
    /*
    **  Created by        : Robert John Virrey
    **  Date Created      : August 8,.2011 
    **  Reference By      : (GIUTS002) 
    */
   FUNCTION get_giuw_policyds(    
        p_dist_no           giuw_policyds.dist_no%TYPE,
        p_policy_id         gipi_invoice.policy_id%TYPE,
        p_takeup_seq_no     giuw_pol_dist.takeup_seq_no%TYPE  
        )
    RETURN giuw_policyds_tab PIPELINED IS
      v_list        giuw_policyds_type;
    BEGIN
        FOR i IN (SELECT a.dist_no,         a.dist_seq_no,
                         a.tsi_amt,         a.prem_amt,        
                         a.item_grp,        a.ann_tsi_amt,
                         a.cpi_rec_no,      a.cpi_branch_cd,      
                         a.arc_ext_data,    b.currency_cd
                    FROM giuw_policyds a,
                         gipi_invoice b
                   WHERE a.dist_no = p_dist_no
                     AND b.policy_id = p_policy_id
                     AND a.item_grp = b.item_grp
                     --AND b.takeup_seq_no = nvl(p_takeup_seq_no,b.takeup_seq_no) removed by jdiago 08.15.2014
                     AND NVL (b.takeup_seq_no,1) = NVL(p_takeup_seq_no,NVL(b.takeup_seq_no,1)) --added by jdiago 08.15.2014 : added NVL on both tables.
                   ORDER BY dist_no, dist_seq_no)
        LOOP
            v_list.dist_no          := i.dist_no; 
            v_list.dist_seq_no      := i.dist_seq_no;    
            v_list.tsi_amt          := i.tsi_amt; 
            v_list.prem_amt         := i.prem_amt;
            v_list.item_grp         := i.item_grp;
            v_list.ann_tsi_amt      := i.ann_tsi_amt;
            v_list.cpi_rec_no       := i.cpi_rec_no;
            v_list.cpi_branch_cd    := i.cpi_branch_cd;
            v_list.arc_ext_data     := i.arc_ext_data;
            v_list.currency_cd      := i.currency_cd;
            FOR x IN (SELECT currency_desc
                        FROM giis_currency
                       WHERE main_currency_cd = i.currency_cd)
            LOOP
                v_list.currency_desc    := x.currency_desc;
            END LOOP;
            FOR c1 IN (SELECT line_cd
                         FROM giuw_wperilds
                        WHERE dist_seq_no = i.dist_seq_no
                          AND dist_no     = i.dist_no)
            LOOP
              v_list.nbt_line_cd := c1.line_cd;
              EXIT;
            END LOOP;
        PIPE ROW(v_list);
        END LOOP;        
    RETURN;             
    END get_giuw_policyds;
    
        
	/*
	**  Created by		: Robert John Virrey 
	**  Date Created 	: August 8, 2011 
	**  Reference By 	: (GIUTS002 - Distribution Negation) 
	**  Description 	:  
	*/
   FUNCTION get_giuw_policyds_exist(
    p_dist_no     giuw_policyds.dist_no%TYPE)
   RETURN VARCHAR2 IS
      v_exist   VARCHAR2 (1) := 'N';
   BEGIN
     FOR x IN (SELECT '1'
	  	         FROM giuw_policyds
		        WHERE dist_no = p_dist_no) 
     LOOP
       v_exist := 'Y';
       EXIT;
     END LOOP;
   RETURN v_exist;
   END get_giuw_policyds_exist;

END GIUW_POLICYDS_PKG;
/


