CREATE OR REPLACE PACKAGE BODY CPI.GIUW_WPOLICYDS_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/
	PROCEDURE del_giuw_wpolicyds (p_dist_no 	GIUW_WPOLICYDS.dist_no%TYPE)
	IS
	BEGIN
		DELETE   GIUW_WPOLICYDS
		 WHERE   dist_no  =  p_dist_no;
	END del_giuw_wpolicyds;

	/*
	**  Created by		: Jerome Orio
	**  Date Created 	: 03.11.2011
	**  Reference By 	: (GIUWS004 - Preliminary One-Risk Distribution)
	**  Description 	: get records for giuw_wpolicyds table
	*/
    FUNCTION get_giuw_wpolicyds(
        p_dist_no           GIUW_WPOLICYDS.dist_no%TYPE,
        p_par_id            gipi_winvoice.par_id%TYPE,
        p_takeup_seq_no     giuw_pol_dist.takeup_seq_no%TYPE
        )
    RETURN giuw_wpolicyds_tab PIPELINED IS
      v_list        giuw_wpolicyds_type;
    BEGIN
        FOR i IN (SELECT a.dist_no,         a.dist_seq_no,
                         a.dist_flag,       a.tsi_amt,
                         a.prem_amt,        a.item_grp,
                         a.ann_tsi_amt,     a.arc_ext_data,
                         b.currency_cd
                    FROM giuw_wpolicyds a,
                         gipi_winvoice b
                   WHERE a.dist_no = p_dist_no
                     AND b.par_id = p_par_id
                     AND a.item_grp = b.item_grp
                     AND b.takeup_seq_no = nvl(p_takeup_seq_no,b.takeup_seq_no)
                   ORDER BY dist_no, dist_seq_no)
        LOOP
            v_list.dist_no          := i.dist_no;
            v_list.dist_seq_no      := i.dist_seq_no;
            v_list.dist_flag        := i.dist_flag;
            v_list.tsi_amt          := i.tsi_amt;
            v_list.prem_amt         := i.prem_amt;
            v_list.item_grp         := i.item_grp;
            v_list.ann_tsi_amt      := i.ann_tsi_amt;
            v_list.arc_ext_data     := i.arc_ext_data;
            v_list.currency_cd      := i.currency_cd;
            v_list.currency_desc    := '';
            v_list.nbt_line_cd      := '';

            FOR x IN (SELECT currency_desc
                        FROM giis_currency
                       WHERE main_currency_cd = i.currency_cd)
            LOOP
              v_list.currency_desc    := x.currency_desc;
              EXIT;
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
    END;

    /*
    **  Created by        : Jerome Orio
    **  Date Created     : 04.04.2011
    **  Reference By     : (GIUWS004- Preliminary One-Risk Distribution)
    **  Description     : Insert record for giuw_wpolicyds table
    */
    PROCEDURE set_giuw_wpolicyds(
        p_dist_no           giuw_wpolicyds.dist_no%TYPE,
        p_dist_seq_no       giuw_wpolicyds.dist_seq_no%TYPE,
        p_dist_flag         giuw_wpolicyds.dist_flag%TYPE,
        p_tsi_amt           giuw_wpolicyds.tsi_amt%TYPE,
        p_prem_amt          giuw_wpolicyds.prem_amt%TYPE,
        p_item_grp          giuw_wpolicyds.item_grp%TYPE,
        p_ann_tsi_amt       giuw_wpolicyds.ann_tsi_amt%TYPE,
        p_arc_ext_data      giuw_wpolicyds.arc_ext_data%TYPE
        ) IS
    BEGIN
        MERGE INTO giuw_wpolicyds
            USING dual ON (dist_no = p_dist_no
                       AND dist_seq_no = p_dist_seq_no)
            WHEN NOT MATCHED THEN
                INSERT (dist_no,         dist_seq_no,
                        dist_flag,       tsi_amt,
                        prem_amt,        item_grp,
                        ann_tsi_amt,     arc_ext_data)
                VALUES (p_dist_no,         p_dist_seq_no,
                        p_dist_flag,       p_tsi_amt,
                        p_prem_amt,        p_item_grp,
                        p_ann_tsi_amt,     p_arc_ext_data)
            WHEN MATCHED THEN
                UPDATE SET
                        dist_flag       = p_dist_flag,
                        tsi_amt         = p_tsi_amt,
                        prem_amt        = p_prem_amt,
                        item_grp        = p_item_grp,
                        ann_tsi_amt     = p_ann_tsi_amt,
                        arc_ext_data    = p_arc_ext_data;
    END;

	/*
	**  Created by		: Jerome Orio
	**  Date Created 	: 04.12.2011
	**  Reference By 	: (GIUWS001 - Set-up Groups for Preliminary Distribution)
	**  Description 	:
	*/
   FUNCTION get_giuw_wpolicyds_exist(p_dist_no     giuw_wpolicyds.dist_no%TYPE)
   RETURN VARCHAR2 IS
      v_exist   VARCHAR2 (1) := 'N';
   BEGIN
     FOR x IN (SELECT '1'
	  	         FROM giuw_wpolicyds
		        WHERE dist_no = p_dist_no)
     LOOP
       v_exist := 'Y';
       EXIT;
     END LOOP;
   RETURN v_exist;
   END;

   /*
	**  Created by		: Anthony Santos
	**  Date Created 	: 07.18.2011
	**  Reference By 	: (GIUWS013 )
	**  Description 	:  For Policy Groups
	*/
   FUNCTION get_giuw_wpolicyds2(
        p_dist_no           GIUW_WPOLICYDS.dist_no%TYPE,
        p_policy_id			gipi_invoice.policy_id%TYPE,
        p_takeup_seq_no     giuw_pol_dist.takeup_seq_no%TYPE
        )
    RETURN giuw_wpolicyds_tab PIPELINED IS
      v_list        giuw_wpolicyds_type;
    BEGIN
        FOR i IN (SELECT a.dist_no,         a.dist_seq_no,
                         a.dist_flag,       a.tsi_amt,
                         a.prem_amt,        a.item_grp,
                         a.ann_tsi_amt,     a.arc_ext_data,
                         b.currency_cd
                    FROM giuw_wpolicyds a,
                         gipi_invoice b
                   WHERE a.dist_no = p_dist_no
                     AND b.policy_id = p_policy_id
                     AND a.item_grp = b.item_grp
                     AND b.takeup_seq_no = nvl(p_takeup_seq_no,b.takeup_seq_no)
                   ORDER BY dist_no, dist_seq_no)
        LOOP
            v_list.dist_no          := i.dist_no;
            v_list.dist_seq_no      := i.dist_seq_no;
            v_list.dist_flag        := i.dist_flag;
            v_list.tsi_amt          := i.tsi_amt;
            v_list.prem_amt         := i.prem_amt;
            v_list.item_grp         := i.item_grp;
            v_list.ann_tsi_amt      := i.ann_tsi_amt;
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
    END;

/*
**  Created by   : Veronica V. Raymundo
**  Date Created : July 29, 2011
**  Reference By : GIUWS016 - One-Risk Distribution TSI/Prem (Group)
**  Description  : Retrieves records from GIUW_WPOLICYDS with the given parameters
*/
    FUNCTION get_giuw_wpolicyds3(
        p_dist_no           GIUW_WPOLICYDS.dist_no%TYPE,
        p_policy_id			GIPI_INVOICE.policy_id%TYPE
        )
    RETURN giuw_wpolicyds_tab PIPELINED IS
      v_list        giuw_wpolicyds_type;
    BEGIN
        FOR i IN (SELECT a.dist_no,         a.dist_seq_no,
                         a.dist_flag,       a.tsi_amt,
                         a.prem_amt,        a.item_grp,
                         a.ann_tsi_amt,     a.arc_ext_data
                    FROM GIUW_WPOLICYDS a
                   WHERE a.dist_no = p_dist_no
                   ORDER BY dist_no, dist_seq_no)
        LOOP
            v_list.dist_no          := i.dist_no;
            v_list.dist_seq_no      := i.dist_seq_no;
            v_list.dist_flag        := i.dist_flag;
            v_list.tsi_amt          := i.tsi_amt;
            v_list.prem_amt         := i.prem_amt;
            v_list.item_grp         := i.item_grp;
            v_list.ann_tsi_amt      := i.ann_tsi_amt;
            v_list.arc_ext_data     := i.arc_ext_data;

            FOR a2 IN (SELECT 		currency_cd
                         FROM 		GIPI_INVOICE
                        WHERE 		item_grp = i.item_grp
                          AND 		policy_id = p_policy_id)
            LOOP
                v_list.currency_cd := a2.currency_cd;
            END LOOP;

            FOR x IN (SELECT currency_desc
                        FROM GIIS_CURRENCY
                       WHERE main_currency_cd = v_list.currency_cd)
            LOOP
                v_list.currency_desc    := x.currency_desc;
            END LOOP;
            FOR c1 IN (SELECT line_cd
                         FROM GIUW_WPERILDS
                        WHERE dist_seq_no = i.dist_seq_no
                          AND dist_no     = i.dist_no)
            LOOP
              v_list.nbt_line_cd := c1.line_cd;
              EXIT;
            END LOOP;
        PIPE ROW(v_list);
        END LOOP;
    RETURN;
    END;

    /*
    **  Created by   : Robert John Virrey
    **  Date Created : August 4, 2011
    **  Reference By : GIUTS002 - Distribution Negation
    **  Description  : Creates a new distribution record in table GIUW_WPOLICYDS
    **                  based on the values taken in by the fields of the negated
    **                  record.
    */
    PROCEDURE neg_policyds (
        p_dist_no     IN  giuw_policyds.dist_no%TYPE,
        p_temp_distno IN  giuw_policyds.dist_no%TYPE
    )
    IS

      CURSOR dtl_retriever_cur IS
        SELECT dist_seq_no , tsi_amt  , prem_amt ,
               ann_tsi_amt , item_grp
          FROM giuw_policyds
         WHERE dist_no = p_dist_no;

      v_dist_seq_no        giuw_policyds.dist_seq_no%TYPE;
      v_tsi_amt            giuw_policyds.tsi_amt%TYPE;
      v_prem_amt           giuw_policyds.prem_amt%TYPE;
      v_ann_tsi_amt        giuw_policyds.ann_tsi_amt%TYPE;
      v_item_grp           giuw_policyds.item_grp%TYPE;

    BEGIN
      OPEN dtl_retriever_cur;
      LOOP
        FETCH dtl_retriever_cur
         INTO v_dist_seq_no , v_tsi_amt  , v_prem_amt ,
              v_ann_tsi_amt , v_item_grp;
        EXIT WHEN dtl_retriever_cur%NOTFOUND;
        INSERT INTO  giuw_wpolicyds
                    (dist_no           , dist_seq_no   , dist_flag     ,
                     tsi_amt           , prem_amt      , ann_tsi_amt   ,
                     item_grp)
             VALUES (p_temp_distno     , v_dist_seq_no , '2'           ,
                     v_tsi_amt         , v_prem_amt    , v_ann_tsi_amt ,
                     v_item_grp);
      END LOOP;
      CLOSE dtl_retriever_cur;
    END neg_policyds;

    /*
    **  Created by      : Emman
    **  Date Created    : 08.16.2011
    **  Reference By    : (GIUTS021 - Redistribution)
    **  Description     : Creates a new distribution record in table GIUW_WPOLICYDS
    **                    based on the values taken in by the fields of the negated
    **                    record.
    **                    NOTE:  The value of field DIST_NO was not copied, as the newly
    **                           created distribution record has its own distribution number.
    */
    PROCEDURE NEG_POLICYDS_GIUTS021(p_dist_no          IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                    p_temp_distno      IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                    p_var_v_neg_distno IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                    p_v_ratio          IN OUT NUMBER)
    IS

      CURSOR dtl_retriever_cur IS
        SELECT dist_seq_no , tsi_amt  , prem_amt ,
               ann_tsi_amt , item_grp
          FROM giuw_policyds
         WHERE dist_no = p_var_v_neg_distno;

      v_dist_seq_no        giuw_policyds.dist_seq_no%TYPE;
      v_tsi_amt            giuw_policyds.tsi_amt%TYPE;
      v_prem_amt           giuw_policyds.prem_amt%TYPE;
      v_ann_tsi_amt        giuw_policyds.ann_tsi_amt%TYPE;
      v_prem_amt_f         giuw_policyds.prem_amt%TYPE;
      v_prem_amt_w         giuw_policyds.prem_amt%TYPE;
      v_item_grp           giuw_policyds.item_grp%TYPE;

    BEGIN
      OPEN dtl_retriever_cur;
      LOOP
        FETCH dtl_retriever_cur
         INTO v_dist_seq_no , v_tsi_amt  , v_prem_amt ,
              v_ann_tsi_amt , v_item_grp;
        EXIT WHEN dtl_retriever_cur%NOTFOUND;
        v_prem_amt_f := ROUND(v_prem_amt * p_v_ratio, 2);
        v_prem_amt_w := v_prem_amt - v_prem_amt_f;
        /* earned portion */
        INSERT INTO  giuw_wpolicyds
                    (dist_no           , dist_seq_no     , tsi_amt       ,  dist_flag,
                     prem_amt          , ann_tsi_amt     , item_grp      )
             VALUES (p_dist_no     , v_dist_seq_no   , v_tsi_amt     ,  '2',
                     v_prem_amt_f      , v_ann_tsi_amt   , v_item_grp    );
        /* unearned portion */
        INSERT INTO  giuw_wpolicyds
                    (dist_no           , dist_seq_no   , dist_flag     ,
                     tsi_amt           , prem_amt      , ann_tsi_amt   ,
                     item_grp)
             VALUES (p_temp_distno   , v_dist_seq_no   , '2'             ,
                     v_tsi_amt           , v_prem_amt_w    , v_ann_tsi_amt   ,
                     v_item_grp);
      END LOOP;
      CLOSE dtl_retriever_cur;

    END NEG_POLICYDS_GIUTS021;

/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 24, 2011
**  Reference By : GIUWS015 - Batch Distribution
**  Description  : This program will transfer all the records from working
**                 table of GIUW_WPOLICYDS to main table GIUW_POLICYDS
*/

    PROCEDURE TRANSFER_WPOLICYDS (p_dist_no    IN GIUW_POL_DIST.dist_no%TYPE) IS

    BEGIN
            /* Master Table */
            FOR POLDS_REC IN (SELECT *
                                FROM GIUW_WPOLICYDS
                               WHERE dist_no = p_dist_no)
            LOOP
                    INSERT INTO GIUW_POLICYDS(dist_no,             dist_seq_no,                 tsi_amt,
                                              prem_amt,            item_grp,                    ann_tsi_amt)
                                       VALUES(POLDS_REC.dist_no,   POLDS_REC.dist_seq_no,       POLDS_REC.tsi_amt,
                                              POLDS_REC.prem_amt,  POLDS_REC.item_grp,          POLDS_REC.ann_tsi_amt);
            END LOOP;

            /* Detail Table */
            FOR POLDSDTL_REC IN (SELECT *
                                   FROM GIUW_WPOLICYDS_DTL
                                  WHERE dist_no = p_dist_no)
            LOOP
                    INSERT INTO GIUW_POLICYDS_DTL(dist_no,                  dist_seq_no,                  line_cd,
                                                  share_cd,                 dist_spct,                    dist_spct1,
                                                  dist_tsi,                 dist_prem,                    ann_dist_spct,
                                                  ann_dist_tsi,             DIST_GRP)
                                           VALUES(POLDSDTL_REC.dist_no,     POLDSDTL_REC.dist_seq_no,     POLDSDTL_REC.line_cd,
                                                  POLDSDTL_REC.share_cd,    POLDSDTL_REC.dist_spct,       POLDSDTL_REC.dist_spct1,
                                                  POLDSDTL_REC.dist_tsi,    POLDSDTL_REC.dist_prem,       POLDSDTL_REC.ann_dist_spct,
                                                  POLDSDTL_REC.ann_dist_tsi,POLDSDTL_REC.dist_grp);
            END LOOP;

    END;

END GIUW_WPOLICYDS_PKG;
/


