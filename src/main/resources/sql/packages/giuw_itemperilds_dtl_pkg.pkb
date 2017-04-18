CREATE OR REPLACE PACKAGE BODY CPI.giuw_itemperilds_dtl_pkg
AS
   /*
   **  Created by    : Mark JM
   **  Date Created  : 02.18.2010
   **  Reference By  : (GIPIS010 - Item Information)
   **  Description   : Contains the Insert / Update / Delete procedure of the table
   */
   PROCEDURE del_giuw_itemperilds_dtl (
      p_dist_no   giuw_itemperilds_dtl.dist_no%TYPE
   )
   IS
   BEGIN
      DELETE      giuw_itemperilds_dtl
            WHERE dist_no = p_dist_no;
   END del_giuw_itemperilds_dtl;

   /*
   **  Created by    : Anthony Santos
   **  Date Created  : 07.18.2010
   **  Reference By  : (GIUW013 - One Risk)
   */
   PROCEDURE post_witemperilds_dtl (p_dist_no giuw_pol_dist.dist_no%TYPE)
   IS
      v_count   NUMBER (1);
   BEGIN
      /* Get the value of the columns in table GIUW_WITEMPERILDS
      ** in preparation for insertion or update to its corresponding
      ** master table GIUW_ITEMPERILDS. */
      FOR wds_cur IN (SELECT   dist_no, dist_seq_no, item_no, line_cd,
                               peril_cd, tsi_amt, prem_amt, ann_tsi_amt
                          FROM giuw_witemperilds
                         WHERE dist_no = p_dist_no
                      ORDER BY dist_no,
                               dist_seq_no,
                               item_no,
                               line_cd,
                               peril_cd)
      LOOP
         v_count := NULL;

         /* If the record corresponding to the specified DIST_NO, DIST_SEQ_NO,
          ** ITEM_NO, LINE_CD and PERIL_CD does not exist in table GIUW_ITEMPERILDS,
          ** then the record in table GIUW_WITEMPERILDS must be inserted to the said
          ** table. */
         IF v_count IS NULL
         THEN
            INSERT INTO giuw_itemperilds
                        (dist_no, dist_seq_no,
                         item_no, line_cd, peril_cd,
                         tsi_amt, prem_amt,
                         ann_tsi_amt
                        )
                 VALUES (wds_cur.dist_no, wds_cur.dist_seq_no,
                         wds_cur.item_no, wds_cur.line_cd, wds_cur.peril_cd,
                         wds_cur.tsi_amt, wds_cur.prem_amt,
                         wds_cur.ann_tsi_amt
                        );
         END IF;
      END LOOP;

      /* Get the value of the columns in table GIUW_WITEMPERILDS_DTL
      ** in preparation for insertion or update to its corresponding
      ** master table GIUW_ITEMPERILDS_DTL. */
      FOR wds_dtl_cur IN (SELECT   dist_no, dist_seq_no, item_no, peril_cd,
                                   line_cd, share_cd, dist_tsi, dist_prem,
                                   dist_spct, ann_dist_spct, ann_dist_tsi,
                                   dist_grp
                              FROM giuw_witemperilds_dtl
                             WHERE dist_no = p_dist_no
                          ORDER BY dist_no,
                                   dist_seq_no,
                                   item_no,
                                   line_cd,
                                   peril_cd,
                                   share_cd)
      LOOP
         v_count := NULL;

         /* If the record corresponding to the specified DIST_NO, DIST_SEQ_NO,
         ** ITEM_NO, LINE_CD, PERIL_CD and SHARE_CD does not exist in table
         ** GIUW_ITEMPERILDS_DTL, then the record in table GIUW_WITEMPERILDS_DTL
         ** must be inserted to the said table. */
         IF v_count IS NULL
         THEN
            INSERT INTO giuw_itemperilds_dtl
                        (dist_no, dist_seq_no,
                         item_no, peril_cd,
                         line_cd, share_cd,
                         dist_tsi, dist_prem,
                         dist_spct, ann_dist_spct,
                         ann_dist_tsi, dist_grp, dist_spct1
                        )
                 VALUES (wds_dtl_cur.dist_no, wds_dtl_cur.dist_seq_no,
                         wds_dtl_cur.item_no, wds_dtl_cur.peril_cd,
                         wds_dtl_cur.line_cd, wds_dtl_cur.share_cd,
                         wds_dtl_cur.dist_tsi, wds_dtl_cur.dist_prem,
                         wds_dtl_cur.dist_spct, wds_dtl_cur.ann_dist_spct,
                         wds_dtl_cur.ann_dist_tsi, wds_dtl_cur.dist_grp, NULL
                        );
         END IF;
      END LOOP;
   END post_witemperilds_dtl;

/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 2, 2011
**  Reference By : GIUWS016 - One-Risk Distribution by TSI/Prem (Group)
**  Description  : Post records retrieved from the working tables to their
**                 corresponding master tables.
**                 Create or update non-existing or existing records of tables
**                 GIUW_ITEMPERILDS and GIUW_ITEMPERILDS_DTL based on the data retrieved
**                 from working tables GIUW_WITEMPERILDS and GIUW_WITEMPERILDS_DTL.
*/

    PROCEDURE POST_WITEMPERILDS_DTL_GIUWS016 (p_dist_no      IN       GIUW_POL_DIST.dist_no%TYPE) IS
      v_count    NUMBER(1);
    BEGIN

      /* Get the value of the columns in table GIUW_WITEMPERILDS
      ** in preparation for insertion or update to its corresponding
      ** master table GIUW_ITEMPERILDS. */
      FOR wds_cur IN (  SELECT dist_no     , dist_seq_no , item_no     ,
                               line_cd     , peril_cd    , tsi_amt     ,
                               prem_amt    , ann_tsi_amt
                          FROM GIUW_WITEMPERILDS
                         WHERE dist_no =  p_dist_no
                      ORDER BY dist_no     , dist_seq_no , item_no     ,
                               line_cd     , peril_cd)
      LOOP
        v_count  :=  NULL;


        /* If the record corresponding to the specified DIST_NO, DIST_SEQ_NO,
        ** ITEM_NO, LINE_CD and PERIL_CD does not exist in table GIUW_ITEMPERILDS,
        ** then the record in table GIUW_WITEMPERILDS must be inserted to the said
        ** table. */
        IF v_count IS NULL THEN
           INSERT INTO  GIUW_ITEMPERILDS
                       (dist_no             , dist_seq_no         , item_no          ,
                        line_cd             , peril_cd            , tsi_amt          ,
                        prem_amt            , ann_tsi_amt)
                VALUES (wds_cur.dist_no     , wds_cur.dist_seq_no , wds_cur.item_no  ,
                        wds_cur.line_cd     , wds_cur.peril_cd    , wds_cur.tsi_amt  ,
                        wds_cur.prem_amt    , wds_cur.ann_tsi_amt);
         END IF;
      END LOOP;

      /* Get the value of the columns in table GIUW_WITEMPERILDS_DTL
      ** in preparation for insertion or update to its corresponding
      ** master table GIUW_ITEMPERILDS_DTL. */
      FOR wds_dtl_cur IN (  SELECT dist_no       , dist_seq_no   , item_no       ,
                                   peril_cd      , line_cd       , share_cd      ,
                                   dist_tsi      , dist_prem     , dist_spct     ,
                                   ann_dist_spct , ann_dist_tsi  , dist_grp      ,
                                   dist_spct1
                              FROM GIUW_WITEMPERILDS_DTL
                             WHERE dist_no = p_dist_no
                          ORDER BY dist_no       , dist_seq_no   , item_no       ,
                                   line_cd       , peril_cd      , share_cd)
      LOOP
        v_count  :=  NULL;

        /* If the record corresponding to the specified DIST_NO, DIST_SEQ_NO,
        ** ITEM_NO, LINE_CD, PERIL_CD and SHARE_CD does not exist in table
        ** GIUW_ITEMPERILDS_DTL, then the record in table GIUW_WITEMPERILDS_DTL
        ** must be inserted to the said table. */
        IF v_count IS NULL THEN
           INSERT INTO  GIUW_ITEMPERILDS_DTL
                       (dist_no                   , dist_seq_no               ,
                        item_no                   , peril_cd                  ,
                        line_cd                   , share_cd                  ,
                        dist_tsi                  , dist_prem                 ,
                        dist_spct                 , ann_dist_spct             ,
                        ann_dist_tsi              , dist_grp                  ,
                        dist_spct1)
                VALUES (wds_dtl_cur.dist_no       , wds_dtl_cur.dist_seq_no   ,
                        wds_dtl_cur.item_no       , wds_dtl_cur.peril_cd      ,
                        wds_dtl_cur.line_cd       , wds_dtl_cur.share_cd      ,
                        wds_dtl_cur.dist_tsi      , wds_dtl_cur.dist_prem     ,
                        wds_dtl_cur.dist_spct     , wds_dtl_cur.ann_dist_spct ,
                        wds_dtl_cur.ann_dist_tsi  , wds_dtl_cur.dist_grp      ,
                        wds_dtl_cur.dist_spct1);
        END IF;
      END LOOP;
    END;

END GIUW_ITEMPERILDS_DTL_PKG;
/


