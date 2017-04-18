CREATE OR REPLACE PACKAGE BODY CPI.GIUW_WITEMPERILDS_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/
	PROCEDURE del_giuw_witemperilds (p_dist_no 	GIUW_WITEMPERILDS.dist_no%TYPE)
	IS
	BEGIN
		DELETE   GIUW_WITEMPERILDS
         WHERE   dist_no = p_dist_no;
	END del_giuw_witemperilds;

    /*
    **  Created by   : Robert John Virrey
    **  Date Created : August 4, 2011
    **  Reference By : GIUTS002 - Distribution Negation
    **  Description  : Creates a new distribution record in table GIUW_WITEMPERILDS
    **                  based on the values taken in by the fields of the negated
    **                  record
    */
    PROCEDURE neg_itemperilds (
        p_dist_no     IN  giuw_itemperilds.dist_no%TYPE,
        p_temp_distno IN  giuw_itemperilds.dist_no%TYPE
    )
    IS

      CURSOR dtl_retriever_cur IS
        SELECT dist_seq_no , peril_cd , line_cd     ,
               tsi_amt     , prem_amt , ann_tsi_amt ,
               item_no
          FROM giuw_itemperilds
         WHERE dist_no = p_dist_no;

      v_dist_seq_no            giuw_itemperilds.dist_seq_no%TYPE;
      v_item_no                giuw_itemperilds.item_no%TYPE;
      v_peril_cd               giuw_itemperilds.peril_cd%TYPE;
      v_line_cd                giuw_itemperilds.line_cd%TYPE;
      v_tsi_amt                giuw_itemperilds.tsi_amt%TYPE;
      v_prem_amt               giuw_itemperilds.prem_amt%TYPE;
      v_ann_tsi_amt            giuw_itemperilds.ann_tsi_amt%TYPE;

    BEGIN
      OPEN dtl_retriever_cur;
      LOOP
        FETCH dtl_retriever_cur
         INTO v_dist_seq_no , v_peril_cd , v_line_cd     ,
              v_tsi_amt     , v_prem_amt , v_ann_tsi_amt ,
              v_item_no;
        EXIT WHEN dtl_retriever_cur%NOTFOUND;
        INSERT INTO  giuw_witemperilds
                    (dist_no           , dist_seq_no   , peril_cd   ,
                     line_cd           , tsi_amt       , prem_amt   ,
                     ann_tsi_amt       , item_no)
             VALUES (p_temp_distno , v_dist_seq_no , v_peril_cd ,
                     v_line_cd         , v_tsi_amt     , v_prem_amt ,
                     v_ann_tsi_amt     , v_item_no);
      END LOOP;
      CLOSE dtl_retriever_cur;
    END neg_itemperilds;

    /*
    **  Created by   :  Emman
    **  Date Created :  08.16.2011
    **  Reference By : (GIUTS021 - Redistribution)
    **                  Description  : Creates a new distribution record in table GIUW_WITEMPERILDS
    **                  based on the values taken in by the fields of the negated
    **                  record.
    **                  NOTE:  The value of field DIST_NO was not copied, as the newly
    **                  created distribution record has its own distribution number.
    */
    PROCEDURE NEG_ITEMPERILDS_GIUTS021(p_dist_no          IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                       p_temp_distno      IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                       p_var_v_neg_distno IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                       p_v_ratio          IN OUT NUMBER)
    IS

      CURSOR dtl_retriever_cur IS
        SELECT dist_seq_no , peril_cd , line_cd     ,
               tsi_amt     , prem_amt , ann_tsi_amt ,
               item_no
          FROM giuw_itemperilds
         WHERE dist_no = p_var_v_neg_distno;

      v_dist_seq_no            giuw_itemperilds.dist_seq_no%TYPE;
      v_item_no                     giuw_itemperilds.item_no%TYPE;
      v_peril_cd            giuw_itemperilds.peril_cd%TYPE;
      v_line_cd            giuw_itemperilds.line_cd%TYPE;
      v_tsi_amt            giuw_itemperilds.tsi_amt%TYPE;
      v_prem_amt            giuw_itemperilds.prem_amt%TYPE;
      v_ann_tsi_amt            giuw_itemperilds.ann_tsi_amt%TYPE;
      v_prem_amt_f            giuw_itemperilds.prem_amt%TYPE;
      v_prem_amt_w            giuw_itemperilds.prem_amt%TYPE;
    BEGIN
      OPEN dtl_retriever_cur;
      LOOP
        FETCH dtl_retriever_cur
         INTO v_dist_seq_no , v_peril_cd , v_line_cd     ,
              v_tsi_amt     , v_prem_amt , v_ann_tsi_amt ,
              v_item_no;
        EXIT WHEN dtl_retriever_cur%NOTFOUND;
        v_prem_amt_f := ROUND(v_prem_amt * p_v_ratio, 2);
        v_prem_amt_w := v_prem_amt - v_prem_amt_f;
        /* earned portion */
        INSERT INTO  giuw_witemperilds
                    (dist_no           , dist_seq_no   , peril_cd   ,
                     line_cd           , tsi_amt       , prem_amt   ,
                     ann_tsi_amt       , item_no)
             VALUES (p_dist_no     , v_dist_seq_no , v_peril_cd   ,
                     v_line_cd         , v_tsi_amt     , v_prem_amt_f ,
                     v_ann_tsi_amt     , v_item_no);
        /* unearned portion */
        INSERT INTO  giuw_witemperilds
                    (dist_no           , dist_seq_no   , peril_cd   ,
                     line_cd           , tsi_amt       , prem_amt   ,
                     ann_tsi_amt       , item_no)
             VALUES (p_temp_distno , v_dist_seq_no , v_peril_cd    ,
                     v_line_cd         , v_tsi_amt     , v_prem_amt_w  ,
                     v_ann_tsi_amt     , v_item_no);
                     --forms_ddl('COMMIT');
      END LOOP;
      CLOSE dtl_retriever_cur;
    END NEG_ITEMPERILDS_GIUTS021;

/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 24, 2011
**  Reference By : GIUWS015 - Batch Distribution
**  Description  : This program will transfer all the records from working
**                 table of GIUW_WITEMPERILDS to main table GIUW_ITEMPERILDS
*/

    PROCEDURE TRANSFER_WITEMPERILDS (p_dist_no     IN GIUW_POL_DIST.dist_no%TYPE) IS

    BEGIN
            /* Master Table */
            FOR POLDS_REC IN (SELECT *
                                FROM GIUW_WITEMPERILDS
                               WHERE dist_no = p_dist_no)
            LOOP
                    INSERT INTO GIUW_ITEMPERILDS(dist_no,              dist_seq_no,                 item_no,
                                                 peril_cd,             line_cd,                     tsi_amt,
                                                 prem_amt,             ann_tsi_amt)
                                          VALUES(POLDS_REC.dist_no,    POLDS_REC.dist_seq_no,       POLDS_REC.item_no,
                                                 POLDS_REC.peril_cd,   POLDS_REC.line_cd,           POLDS_REC.tsi_amt,
                                                 POLDS_REC.prem_amt,   POLDS_REC.ann_tsi_amt);
            END LOOP;

            /* Detail Table */
            FOR ITPDSDTL_REC IN (SELECT *
                                   FROM GIUW_WITEMPERILDS_DTL
                                  WHERE dist_no = p_dist_no)
            LOOP
                    INSERT INTO GIUW_ITEMPERILDS_DTL(dist_no,          dist_seq_no,                 item_no,
                                                     line_cd,          peril_cd,                    share_cd,
                                                     dist_spct,        dist_spct1,                  dist_tsi,
                                                     dist_prem,        ann_dist_spct,               ann_dist_tsi,
                                                     dist_grp)
                                              VALUES(ITPDSDTL_REC.dist_no,      ITPDSDTL_REC.dist_seq_no,      ITPDSDTL_REC.item_no,
                                                     ITPDSDTL_REC.line_cd,      ITPDSDTL_REC.peril_cd,         ITPDSDTL_REC.share_cd,
                                                     ITPDSDTL_REC.dist_spct,    ITPDSDTL_REC.dist_spct1,       ITPDSDTL_REC.dist_tsi,
                                                     ITPDSDTL_REC.dist_prem,    ITPDSDTL_REC.ann_dist_spct,    ITPDSDTL_REC.ann_dist_tsi,
                                                     ITPDSDTL_REC.dist_grp);
            END LOOP;

    END;


END GIUW_WITEMPERILDS_PKG;
/


