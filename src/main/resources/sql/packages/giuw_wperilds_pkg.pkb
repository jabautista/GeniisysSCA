CREATE OR REPLACE PACKAGE BODY CPI.GIUW_WPERILDS_PKG
AS
    /*
    **  Created by        : Mark JM
    **  Date Created     : 02.18.2010
    **  Reference By     : (GIPIS010 - Item Information)
    **  Description     : Contains the Insert / Update / Delete procedure of the table
    */
    PROCEDURE del_giuw_wperilds (p_dist_no     GIUW_WPERILDS.dist_no%TYPE)
    IS
    BEGIN
        DELETE   GIUW_WPERILDS
         WHERE   dist_no  =  p_dist_no;
    END del_giuw_wperilds;
    
    /*
    **  Created by        : Emman
    **  Date Created     : 06.03.2011
    **  Reference By     : (GIUWS003 - Preliminary Peril Distribution)
    **  Description     : Delete procedure of the table, based on the primary keys
    */
    PROCEDURE del_giuw_wperilds2(p_dist_no     GIUW_WPERILDS.dist_no%TYPE,
                                   p_dist_seq_no GIUW_WPERILDS.dist_seq_no%TYPE,
                                 p_peril_cd       GIUW_WPERILDS.peril_cd%TYPE,
                                 p_line_cd       GIUW_WPERILDS.dist_no%TYPE)
    IS
    BEGIN
        DELETE   GIUW_WPERILDS
         WHERE   dist_no        =  p_dist_no
           AND     dist_seq_no  =  p_dist_seq_no
           AND     peril_cd      =     p_peril_cd
           AND     line_cd      =     p_line_cd;
    END del_giuw_wperilds2;
    
    /*
    **  Created by        : Mark JM
    **  Date Created    : 03.31.2011
    **  Reference By    : (GIUWS003 - Preliminary Peril Distribution)
    **  Description     : Retrieve records on giuw_wperilds based on the given parameter
    */
    FUNCTION get_giuw_wperilds (p_dist_no IN giuw_wperilds.dist_no%TYPE)
    RETURN giuw_wperilds_tab PIPELINED
    IS
        v_giuw_wperilds giuw_wperilds_type;
    BEGIN
        FOR i IN (
            SELECT a.dist_no,        a.dist_seq_no,    a.peril_cd,        a.line_cd,
                   a.tsi_amt,        a.prem_amt,        a.ann_tsi_amt,    a.dist_flag,
                   a.arc_ext_data,    b.peril_name
              FROM giuw_wperilds a,
                   giis_peril b
             WHERE a.dist_no = p_dist_no
               AND a.peril_cd = b.peril_cd
               AND a.line_cd = b.line_cd)
        LOOP
            v_giuw_wperilds.dist_no            := i.dist_no;
            v_giuw_wperilds.dist_seq_no        := i.dist_seq_no;
            v_giuw_wperilds.peril_cd        := i.peril_cd;
            v_giuw_wperilds.peril_name        := i.peril_name;
            v_giuw_wperilds.line_cd            := i.line_cd;
            v_giuw_wperilds.tsi_amt            := i.tsi_amt;
            v_giuw_wperilds.prem_amt        := i.prem_amt;
            v_giuw_wperilds.ann_tsi_amt        := i.ann_tsi_amt;
            v_giuw_wperilds.dist_flag        := i.dist_flag;
            v_giuw_wperilds.arc_ext_data    := i.arc_ext_data;
            
            FOR w IN (
                SELECT par_id
                  FROM giuw_pol_dist
                 WHERE dist_no = i.dist_no)
            LOOP
                FOR x IN (
                    SELECT item_grp
                      FROM giuw_wpolicyds
                     WHERE dist_no = i.dist_no
                       AND dist_seq_no = i.dist_seq_no)
                LOOP
                    FOR y IN (
                        SELECT currency_cd
                          FROM gipi_winvoice
                         WHERE item_grp = x.item_grp
                           AND par_id = w.par_id)
                    LOOP
                        FOR z IN (
                            SELECT currency_desc
                              FROM giis_currency
                             WHERE main_currency_cd = y.currency_cd)
                        LOOP
                            v_giuw_wperilds.currency_desc := z.currency_desc;
                        END LOOP;
                    END LOOP;
                END LOOP;
            END LOOP;            
            
            PIPE ROW(v_giuw_wperilds);
        END LOOP;
        
        RETURN;
    END get_giuw_wperilds;
    
    PROCEDURE set_giuw_wperilds(
        p_dist_no                    giuw_wperilds.dist_no%TYPE,
        p_dist_seq_no              giuw_wperilds.dist_seq_no%TYPE,
        p_peril_cd                  giuw_wperilds.peril_cd%TYPE,
        p_line_cd                  giuw_wperilds.line_cd%TYPE,
        p_tsi_amt                  giuw_wperilds.tsi_amt%TYPE,
        p_prem_amt                  giuw_wperilds.prem_amt%TYPE,
        p_ann_tsi_amt              giuw_wperilds.ann_tsi_amt%TYPE,
        p_dist_flag                  giuw_wperilds.dist_flag%TYPE,
        p_arc_ext_data              giuw_wperilds.arc_ext_data%TYPE)
    IS
    BEGIN
        MERGE INTO giuw_wperilds
     USING dual ON (dist_no        = p_dist_no
                    AND dist_seq_no    = p_dist_seq_no
                AND peril_cd    = p_peril_cd
                AND line_cd        = p_line_cd)
      WHEN NOT MATCHED THEN
             INSERT (dist_no,        dist_seq_no,      peril_cd,               line_cd,
                      tsi_amt,        prem_amt,          ann_tsi_amt,         dist_flag,
                   arc_ext_data)
           VALUES (p_dist_no,    p_dist_seq_no,    p_peril_cd,         p_line_cd,
                      p_tsi_amt,    p_prem_amt,          p_ann_tsi_amt,     p_dist_flag,
                   p_arc_ext_data)
      WHEN MATCHED THEN
             UPDATE SET
                     tsi_amt          = p_tsi_amt,
                  prem_amt          = p_prem_amt,
                  ann_tsi_amt      = p_ann_tsi_amt,
                  dist_flag          = p_dist_flag,
                  arc_ext_data      = p_arc_ext_data;
    END set_giuw_wperilds;
    
    /*
    **  Created by       :Belle Bebing
    **  Date Created    : 07.07.2011
    **  Reference By    : (GIUWS018 - Set-up Peril Groups for Distribution)
    **  Description     : Retrieve records on giuw_wperilds based on the given parameter
    */
    FUNCTION get_giuw_wperilds2 (
        p_dist_no  giuw_wperilds.dist_no%TYPE,
        p_policy_id  gipi_polbasic.policy_id%TYPE
    )
    RETURN giuw_wperilds_tab PIPELINED
    IS
        v_giuw_wperilds2     giuw_wperilds_type;
        v_count                 NUMBER;
        v_dist_seq_no         NUMBER;
        v_temp_cnt        NUMBER ; -- jhing 12.11.2014         
     BEGIN
		SELECT max(dist_seq_no) 
		  INTO v_giuw_wperilds2.max_dist_seq_no
		  FROM giuw_wpolicyds
		 WHERE dist_no = p_dist_no;
		 
		 FOR i IN (SELECT a.dist_no, b.peril_type, b.peril_cd, b.basc_perl_cd, b.peril_name, 
                         d.dist_seq_no, a.tsi_amt, a.prem_amt, a.ann_tsi_amt, d.item_grp, a.line_cd, c.policy_id
                    FROM GIUW_WPERILDS a, GIIS_PERIL b, GIUW_POL_DIST c, GIUW_WPOLICYDS d
                   WHERE 1=1
                     AND a.line_cd = b.line_cd
                     AND a.peril_cd = b.peril_cd
                     AND a.dist_no = c.dist_no
                     AND a.dist_no = d.dist_no
                     AND a.dist_seq_no = d.dist_seq_no
                     AND a.dist_no = p_dist_no)
        LOOP
            v_giuw_wperilds2.dist_no  := i.dist_no;
            v_giuw_wperilds2.peril_type := i.peril_type;
            v_giuw_wperilds2.peril_cd := i.peril_cd;
            v_giuw_wperilds2.basc_perl_cd := i.basc_perl_cd;
            v_giuw_wperilds2.dist_seq_no := i.dist_seq_no;
            v_giuw_wperilds2.peril_name  := i.peril_name;
            v_giuw_wperilds2.tsi_amt  := i.tsi_amt;
            v_giuw_wperilds2.prem_amt := i.prem_amt;
            v_giuw_wperilds2.ann_tsi_amt := i.ann_tsi_amt;
            v_giuw_wperilds2.item_grp := i.item_grp;
            v_giuw_wperilds2.line_cd := i.line_cd;
			
			FOR c1 IN (SELECT pack_line_cd , 
                      pack_subline_cd , item_grp  , currency_cd  ,
                      currency_rt     , ann_tsi_amt
                 FROM gipi_item
                WHERE policy_id  = p_policy_id) LOOP
                      
              FOR a IN (SELECT item_grp
						  FROM giuw_wpolicyds
						 WHERE dist_no = i.dist_no
							 AND dist_seq_no = i.dist_seq_no
							 AND item_grp = c1.item_grp)             
			  LOOP
				  v_giuw_wperilds2.pack_line_cd     :=  c1.pack_line_cd;
				  v_giuw_wperilds2.pack_subline_cd  :=  c1.pack_subline_cd;
				  v_giuw_wperilds2.currency_cd      :=  c1.currency_cd;
				  v_giuw_wperilds2.currency_rt      :=  c1.currency_rt;
				  
				  FOR c2 IN (SELECT short_name
							   FROM giis_currency
							  WHERE main_currency_cd = c1.currency_cd)
				  LOOP
					v_giuw_wperilds2.currency_shrtname  :=  c2.short_name;
					EXIT;
				  END LOOP;
				EXIT;
			  END LOOP;
			END LOOP;

            v_giuw_wperilds2.orig_dist_seq_no :=  i.dist_seq_no;   
            v_giuw_wperilds2.orig_peril_cd :=  i.peril_cd;

            -- jhing 12.11.2014, query cnt of items per dist group
            v_temp_cnt := 0 ;
            FOR curPeril IN (SELECT count(*)  cnt 
                                FROM giuw_wperilds
                                    WHERE dist_no = p_dist_no
                                      AND dist_seq_no = i.dist_seq_no )
            LOOP
                v_temp_cnt := curPeril.cnt;
                EXIT;
            END LOOP;
            
            v_giuw_wperilds2.cnt_per_dist_grp := v_temp_cnt ;			
			PIPE ROW (v_giuw_wperilds2);
		END LOOP;
		
		RETURN; 
    END get_giuw_wperilds2;
    
    /*
    **  Created by        : Belle Bebing 
    **  Date Created     : 07.22.2011
    **  Reference By     : GIUWS018 -  Set-up Peril Groups for Distribution Final
    **  Description     : Delete procedure of the table
    */
    PROCEDURE del_giuw_wperilds3(
        p_dist_no             GIUW_WPERILDS.dist_no%TYPE,
        p_dist_seq_no       GIUW_WPERILDS.dist_seq_no%TYPE
        ) IS
    BEGIN
        DELETE GIUW_WPERILDS
         WHERE dist_no =  p_dist_no
           AND dist_seq_no = p_dist_seq_no;  
    END del_giuw_wperilds3; 


    /*
    **  Created by        : Jhing Factor 
    **  Date Created     : 12.10.2014
    **  Reference By     : GIUWS018 -  Set-up Peril Groups for Distribution Final
    **  Description     : Delete procedure of the table
    */
    PROCEDURE del_giuw_wperilds4(
        p_dist_no             GIUW_WPERILDS.dist_no%TYPE,
        p_dist_seq_no       GIUW_WPERILDS.dist_seq_no%TYPE,
        p_peril_cd          GIUW_WPERILDS.peril_cd%TYPE 
        ) IS
    BEGIN
        DELETE GIUW_WPERILDS
         WHERE dist_no =  p_dist_no
           AND dist_seq_no = p_dist_seq_no
           AND peril_cd = p_peril_cd;  
    END del_giuw_wperilds4; 
    
/*
    **  Created by      : Jerome Orio 
    **  Date Created    : 07.29.2011
    **  Reference By    : GIUWS017 - Dist by TSI/Prem (Peril)  
    **  Description     : Retrieve records on giuw_wperilds based on the given parameter
    */
    FUNCTION get_giuw_wperilds3 (p_dist_no IN giuw_wperilds.dist_no%TYPE)
    RETURN giuw_wperilds_tab PIPELINED
    IS
        v_giuw_wperilds giuw_wperilds_type;
    BEGIN
        FOR i IN (
            SELECT a.dist_no,        a.dist_seq_no,    a.peril_cd,        a.line_cd,
                   a.tsi_amt,        a.prem_amt,        a.ann_tsi_amt,    a.dist_flag,
                   a.arc_ext_data,    b.peril_name
              FROM giuw_wperilds a,
                   giis_peril b
             WHERE a.dist_no = p_dist_no
               AND a.peril_cd = b.peril_cd
               AND a.line_cd = b.line_cd
             ORDER BY a.dist_seq_no)
        LOOP
            v_giuw_wperilds.dist_no            := i.dist_no;
            v_giuw_wperilds.dist_seq_no        := i.dist_seq_no;
            v_giuw_wperilds.peril_cd        := i.peril_cd;
            v_giuw_wperilds.peril_name        := i.peril_name;
            v_giuw_wperilds.line_cd            := i.line_cd;
            v_giuw_wperilds.tsi_amt            := i.tsi_amt;
            v_giuw_wperilds.prem_amt        := i.prem_amt;
            v_giuw_wperilds.ann_tsi_amt        := i.ann_tsi_amt;
            v_giuw_wperilds.dist_flag        := i.dist_flag;
            v_giuw_wperilds.arc_ext_data    := i.arc_ext_data;
            
            FOR w IN (
                SELECT policy_id
                  FROM giuw_pol_dist
                 WHERE dist_no = i.dist_no)
            LOOP
                FOR x IN (
                    SELECT item_grp
                      FROM giuw_wpolicyds
                     WHERE dist_no = i.dist_no
                       AND dist_seq_no = i.dist_seq_no)
                LOOP
                    FOR y IN (
                        SELECT currency_cd
                          FROM gipi_invoice
                         WHERE item_grp = x.item_grp
                           AND policy_id = w.policy_id)
                    LOOP
                        FOR z IN (
                            SELECT currency_desc
                              FROM giis_currency
                             WHERE main_currency_cd = y.currency_cd)
                        LOOP
                            v_giuw_wperilds.currency_desc := z.currency_desc;
                        END LOOP;
                    END LOOP;
                END LOOP;
            END LOOP;            
            
            PIPE ROW(v_giuw_wperilds);
        END LOOP;
        
        RETURN;
    END get_giuw_wperilds3;    
    
   /*
   **  Created by        : Jerome Orio
   **  Date Created     : 08.01.2011
   **  Reference By     : (GIUWS017 - Dist by TSI/Prem (Peril))
   **  Description     :
   */
    FUNCTION get_giuw_wperilds_exist (
      p_dist_no   giuw_wperilds.dist_no%TYPE)
    RETURN VARCHAR2 IS
      v_exist   VARCHAR2 (1) := 'N';
    BEGIN
      FOR x IN (SELECT '1'
                  FROM giuw_wperilds
                 WHERE dist_no = p_dist_no)
      LOOP
         v_exist := 'Y';
         EXIT;
      END LOOP;

      RETURN v_exist;
    END;    
    
   /*
   **  Created by        : Jerome Orio
   **  Date Created     : 08.03.2011
   **  Reference By     : (GIUWS017 - Dist by TSI/Prem (Peril))
   **  Description     :
   */
    PROCEDURE get_giuw_wperilds_exist2(
        p_dist_no                   IN  giuw_wperilds.dist_no%TYPE,
        p_pol_flag                  IN  gipi_wpolbas.pol_flag%TYPE,
        p_par_type                  IN  gipi_parlist.par_type%TYPE,
        p_giuw_wperilds_exist       OUT VARCHAR2,
        p_giuw_wperilds_dtl_exist   OUT VARCHAR2
        ) IS 
      v_hdr_sw          VARCHAR2(1); --field that used as a switch to determing if records rexist in header table
      v_dtl_sw          VARCHAR2(1); --field that used as a switch to determing if records rexist in header table
      v_msg_alert       VARCHAR2(3200) := ''; 
    BEGIN
      v_hdr_sw := 'N';
      p_giuw_wperilds_exist := 'N';
      p_giuw_wperilds_dtl_exist := 'N';  
      --check if there are records in giuw_wpolicyds
      FOR A IN (SELECT dist_no, dist_seq_no
                  FROM giuw_wperilds
                 WHERE dist_no = p_dist_no)
      LOOP     
        v_hdr_sw := 'Y';
        p_giuw_wperilds_exist := 'Y';
        v_dtl_sw := 'N';
        --check if there are records corresponding records in giuw_wpolicyds_dtl        
        -- for every record in giuw_wpolicyds    
        FOR B IN (SELECT '1'
                    FROM giuw_wperilds_dtl
                   WHERE dist_no = a.dist_no
                     AND dist_seq_no = a.dist_seq_no)
        LOOP            
            v_dtl_sw := 'Y';
            p_giuw_wperilds_dtl_exist := 'Y';  
            EXIT;
        END LOOP;     
        IF v_dtl_sw = 'N' THEN
           IF p_pol_flag = '2' OR p_par_type = 'E' THEN 
             NULL;
           ELSE 
             p_giuw_wperilds_dtl_exist := 'N';  
             RETURN;      
           END IF;
        END IF;
      END LOOP;
      IF v_hdr_sw = 'N' THEN
         IF p_pol_flag = '2' OR p_par_type = 'E' THEN
           NULL;
         ELSE              
           p_giuw_wperilds_exist := 'N';
           RETURN;  
         END IF;
      END IF;
    END;    
    
    /*
    **  Created by   : Robert John Virrey 
    **  Date Created : August 4, 2011
    **  Reference By : GIUTS002 - Distribution Negation 
    **  Description  : Creates a new distribution record in table GIUW_WPERILDS
    **                  based on the values taken in by the fields of the negated
    **                  record
    */
    PROCEDURE neg_perilds (
        p_dist_no     IN  giuw_perilds.dist_no%TYPE,
        p_temp_distno IN  giuw_perilds.dist_no%TYPE
    ) 
    IS

      CURSOR dtl_retriever_cur IS
        SELECT dist_seq_no , peril_cd , line_cd     ,
               tsi_amt     , prem_amt , ann_tsi_amt
          FROM giuw_perilds
         WHERE dist_no = p_dist_no;

      v_dist_seq_no            giuw_perilds.dist_seq_no%type;
      v_peril_cd               giuw_perilds.peril_cd%type;
      v_line_cd                giuw_perilds.line_cd%type;    
      v_tsi_amt                giuw_perilds.tsi_amt%type;    
      v_prem_amt               giuw_perilds.prem_amt%type;    
      v_ann_tsi_amt            giuw_perilds.ann_tsi_amt%type;
         
    BEGIN
      OPEN dtl_retriever_cur;
      LOOP
        FETCH dtl_retriever_cur 
         INTO v_dist_seq_no , v_peril_cd , v_line_cd ,
              v_tsi_amt     , v_prem_amt , v_ann_tsi_amt;
        EXIT WHEN dtl_retriever_cur%NOTFOUND; 
        INSERT INTO  giuw_wperilds
                    (dist_no           , dist_seq_no   , peril_cd   ,
                     line_cd           , tsi_amt       , prem_amt   , 
                     ann_tsi_amt)
             VALUES (p_temp_distno     , v_dist_seq_no , v_peril_cd , 
                     v_line_cd         , v_tsi_amt     , v_prem_amt , 
                     v_ann_tsi_amt);
      END LOOP;
      CLOSE dtl_retriever_cur;
    END neg_perilds;
    
    /*
   **  Created by        : Emman
   **  Date Created     : 08.10.2011
   **  Reference By     : (GIUWS012 - Distribution by Peril)
   **  Description     : checks if dist exists in giuw_wperilds and giuw_wperilds_dtl. used in POST-QUERY of GIUW_POL_DIST block
   */
    FUNCTION get_giuw_wperilds_exist3 (
      p_dist_no   giuw_wperilds.dist_no%TYPE)
    RETURN VARCHAR2 IS
      v_exist   VARCHAR2 (1) := 'Y';
      v_hdr_sw   VARCHAR2(1); --field that used as a switch to determing if records rexist in header table
      v_dtl_sw   VARCHAR2(1); --field that used as a switch to determing if records rexist in header table
    BEGIN
      v_hdr_sw := 'N';
      --check if there are records in giuw_wpolicyds    
      FOR A IN (SELECT dist_no, dist_seq_no
                  FROM giuw_wperilds
                 WHERE dist_no = p_dist_no)
      LOOP     
        v_hdr_sw := 'Y';
        v_dtl_sw := 'N';
        --check if there are records corresponding records in giuw_wpolicyds_dtl        
        -- for every record in giuw_wpolicyds    
        FOR B IN (SELECT '1'
                    FROM giuw_wperilds_dtl
                   WHERE dist_no = a.dist_no
                     AND dist_seq_no = a.dist_seq_no)
        LOOP            
            v_dtl_sw := 'Y';
            EXIT;
        END LOOP;     
        IF v_dtl_sw = 'N' THEN
           v_exist := 'N';
        END IF;
      END LOOP;
      IF v_hdr_sw = 'N' THEN
         v_exist := 'N';
      END IF;

      RETURN v_exist;
    END get_giuw_wperilds_exist3;
    
    /*
    **  Created by   :  Emman
    **  Date Created :  08.16.2011
    **  Reference By : (GIUTS021 - Redistribution)
    **                  Description  : Creates a new distribution record in table GIUW_WPERILDS
    **                  based on the values taken in by the fields of the negated
    **                  record.
    **                  NOTE:  The value of field DIST_NO was not copied, as the newly 
    **                  created distribution record has its own distribution number.
    */ 
    PROCEDURE NEG_PERILDS_GIUTS021(p_dist_no          IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                  p_temp_distno      IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                  p_var_v_neg_distno IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                  p_v_ratio          IN OUT NUMBER)
    IS
      CURSOR dtl_retriever_cur IS
        SELECT dist_seq_no , peril_cd , line_cd     ,
               tsi_amt     , prem_amt , ann_tsi_amt
          FROM giuw_perilds
         WHERE dist_no = p_var_v_neg_distno;

      v_dist_seq_no            giuw_perilds.dist_seq_no%type;
      v_peril_cd            giuw_perilds.peril_cd%type;
      v_line_cd            giuw_perilds.line_cd%type;    
      v_tsi_amt            giuw_perilds.tsi_amt%type;    
      v_prem_amt            giuw_perilds.prem_amt%type;    
      v_prem_amt_w            giuw_perilds.prem_amt%type;    
      v_prem_amt_f            giuw_perilds.prem_amt%type;    
      v_ann_tsi_amt            giuw_perilds.ann_tsi_amt%type;
         
    BEGIN
      OPEN dtl_retriever_cur;
      LOOP
        FETCH dtl_retriever_cur 
         INTO v_dist_seq_no , v_peril_cd , v_line_cd ,
              v_tsi_amt     , v_prem_amt , v_ann_tsi_amt;
        EXIT WHEN dtl_retriever_cur%NOTFOUND; 
        v_prem_amt_f := ROUND(v_prem_amt * p_v_ratio,2);
        v_prem_amt_w := v_prem_amt - v_prem_amt_f; 
        /* earned portion */
        INSERT INTO  giuw_wperilds
                    (dist_no           , dist_seq_no   , peril_cd   ,
                     line_cd           , tsi_amt       , prem_amt   , 
                     ann_tsi_amt)
             VALUES (p_dist_no     , v_dist_seq_no , v_peril_cd   , 
                     v_line_cd         , v_tsi_amt     , v_prem_amt_f , 
                     v_ann_tsi_amt);
        /* unearned portion */
        INSERT INTO  giuw_wperilds
                    (dist_no           , dist_seq_no   , peril_cd   ,
                     line_cd           , tsi_amt       , prem_amt   , 
                     ann_tsi_amt)
             VALUES (p_temp_distno , v_dist_seq_no , v_peril_cd   , 
                     v_line_cd         , v_tsi_amt     , v_prem_amt_w , 
                     v_ann_tsi_amt);
                     --forms_ddl('COMMIT');
      END LOOP;
      CLOSE dtl_retriever_cur;
    END NEG_PERILDS_GIUTS021;
    
/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 24, 2011
**  Reference By : GIUWS015 - Batch Distribution
**  Description  : This program will transfer all the records from working 					
**                 table of GIUW_WPERILDS to main table GIUW_PERILDS     
*/

    PROCEDURE TRANSFER_WPERILDS (p_dist_no     IN GIUW_POL_DIST.dist_no%TYPE) IS
                                                                 
    BEGIN
            /* Master Table */
            FOR POLDS_REC IN (SELECT *
                                FROM GIUW_WPERILDS
                               WHERE dist_no = p_dist_no)
            LOOP
                    INSERT INTO GIUW_PERILDS(dist_no,      dist_seq_no,                 peril_cd,
                                             line_cd,      tsi_amt,                     prem_amt,                          
                                             ann_tsi_amt)
                                      VALUES(POLDS_REC.dist_no,    POLDS_REC.dist_seq_no,   POLDS_REC.peril_cd,
                                             POLDS_REC.line_cd,    POLDS_REC.tsi_amt,       POLDS_REC.prem_amt,
                                             POLDS_REC.ann_tsi_amt);
            END LOOP;
            
            /* Detail Table */
            FOR PRLDSDTL_REC IN (SELECT *
                                   FROM GIUW_WPERILDS_DTL
                                  WHERE dist_no = p_dist_no)
            LOOP                             
                    INSERT INTO GIUW_PERILDS_DTL(dist_no,                   dist_seq_no,                      line_cd,
                                                 peril_cd,                  share_cd,                         dist_spct,                                
                                                 dist_spct1,                dist_tsi,                         dist_prem,                                
                                                 ann_dist_spct,             ann_dist_tsi,                     dist_grp)
                                         VALUES (PRLDSDTL_REC.dist_no,      PRLDSDTL_REC.dist_seq_no,         PRLDSDTL_REC.line_cd,             
                                                 PRLDSDTL_REC.peril_cd,     PRLDSDTL_REC.share_cd,            PRLDSDTL_REC.dist_spct,   
                                                 PRLDSDTL_REC.dist_spct1,   PRLDSDTL_REC.dist_tsi,            PRLDSDTL_REC.dist_prem,      
                                                 PRLDSDTL_REC.ann_dist_spct,PRLDSDTL_REC.ann_dist_tsi,        PRLDSDTL_REC.dist_grp);
            END LOOP;

    END;

END GIUW_WPERILDS_PKG;
/


