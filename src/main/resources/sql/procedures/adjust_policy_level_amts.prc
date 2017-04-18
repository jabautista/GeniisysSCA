DROP PROCEDURE CPI.ADJUST_POLICY_LEVEL_AMTS;

CREATE OR REPLACE PROCEDURE CPI.ADJUST_POLICY_LEVEL_AMTS(p_dist_no IN giuw_pol_dist.dist_no%TYPE) IS

  v_exist			VARCHAR2(1) := 'N';
  v_count			NUMBER;
  v_line_cd			gipi_parlist.line_cd%TYPE;
  v_tsi_amt			giuw_wpolicyds.tsi_amt%TYPE;
  v_prem_amt			giuw_wpolicyds.prem_amt%TYPE;
  v_ann_tsi_amt			giuw_wpolicyds.ann_tsi_amt%TYPE;
  v_dist_spct                   giuw_wpolicyds_dtl.dist_spct%TYPE;
  v_dist_tsi			giuw_wpolicyds_dtl.dist_tsi%TYPE;
  v_dist_prem			giuw_wpolicyds_dtl.dist_prem%TYPE;
  v_ann_dist_tsi		giuw_wpolicyds_dtl.ann_dist_tsi%TYPE;
  v_ann_dist_spct       	giuw_wpolicyds_dtl.ann_dist_spct%TYPE;
  v_sum_dist_tsi		giuw_wpolicyds_dtl.dist_tsi%TYPE;
  v_sum_dist_prem		giuw_wpolicyds_dtl.dist_prem%TYPE;
  v_sum_dist_spct       	giuw_wpolicyds_dtl.dist_spct%TYPE;
  v_sum_ann_dist_tsi		giuw_wpolicyds_dtl.ann_dist_tsi%TYPE;
  v_sum_ann_dist_spct   	giuw_wpolicyds_dtl.ann_dist_spct%TYPE;
  v_correct_dist_tsi		giuw_wpolicyds_dtl.dist_tsi%TYPE;
  v_correct_dist_prem   	giuw_wpolicyds_dtl.dist_prem%TYPE;
  v_correct_dist_spct		giuw_wpolicyds_dtl.dist_spct%TYPE;
  v_correct_ann_dist_tsi	giuw_wpolicyds_dtl.ann_dist_tsi%TYPE;
  v_correct_ann_dist_spct       giuw_wpolicyds_dtl.ann_dist_spct%TYPE;

BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : April 05, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : ADJUST_POLICY_LEVEL_AMTS program unit
  */
  
  /* Scan each DIST_SEQ_NO for computational floats. */
  FOR c1 IN (SELECT dist_no                                   ,
                    dist_seq_no                               ,
                    ROUND(NVL(tsi_amt    , 0), 2) tsi_amt     ,
                    ROUND(NVL(prem_amt   , 0), 2) prem_amt    ,
                    ROUND(NVL(ann_tsi_amt, 0), 2) ann_tsi_amt
               FROM giuw_wpolicyds
              WHERE dist_no = p_dist_no)
  LOOP
    BEGIN

      /* Get the LINE_CD for the particular DIST_SEQ_NO
      ** for use in retrieving the correct data from
      ** GIUW_WPOLICYDS_DTL. */
      FOR c2 IN (SELECT line_cd
                   FROM giuw_wperilds
                  WHERE dist_seq_no = c1.dist_seq_no
                    AND dist_no     = c1.dist_no)
      LOOP
        v_line_cd := c2.line_cd;
        EXIT;
      END LOOP;

      /* **************************** Section A **********************************
      ** Compare the amounts retrieved from the master table with the sum of its
      ** counterparts from the detail table.
      ************************************************************************* */
  
      v_tsi_amt     := c1.tsi_amt;
      v_prem_amt    := c1.prem_amt;
      v_ann_tsi_amt := c1.ann_tsi_amt;

      v_exist := 'N';
      FOR c10 IN (SELECT ROUND(SUM(NVL(dist_tsi, 0)), 2)     dist_tsi     , 
                         ROUND(SUM(NVL(dist_prem, 0)), 2)    dist_prem    ,
                         ROUND(SUM(NVL(dist_spct, 0)), 9)    dist_spct    ,
                         ROUND(SUM(NVL(ann_dist_tsi, 0)), 2) ann_dist_tsi
                    FROM giuw_wpolicyds_dtl
                   WHERE dist_seq_no = c1.dist_seq_no
                     AND dist_no     = c1.dist_no)
      LOOP 
        v_exist        := 'Y';
        v_dist_tsi     := c10.dist_tsi;
        v_dist_prem    := c10.dist_prem;
        v_dist_spct    := c10.dist_spct;
        v_ann_dist_tsi := c10.ann_dist_tsi;
        EXIT;
      END LOOP;
      IF v_exist = 'N' THEN
         EXIT;
      END IF;

      /*************************** End of Section A ****************************/

      /* If the amounts retrieved from the master table
      ** are not equal to the amounts retrieved from the
      ** the detail table then the procedure below shall
      ** be executed. */
      IF (100           != v_dist_spct   ) OR
         (v_tsi_amt     != v_dist_tsi    ) OR 
         (v_prem_amt    != v_dist_prem   ) OR
         (v_ann_tsi_amt != v_ann_dist_tsi) THEN
         BEGIN
           v_exist := 'N';

           /*************************** Section B *******************************
           ** Adjust the value of the fields belonging to the NET RETENTION share
           ** (SHARE_CD = '1'). If by chance a NET RETENTION share does not exist,
           ** then the NO_DATA_FOUND exception (Section C) shall handle the next
           ** few steps.
           *********************************************************************/
           
           /* Get the ROWID of the NET RETENTION share
           ** in preparation for update. */ 
           FOR c10 IN (SELECT ROWID
                         FROM giuw_wpolicyds_dtl
                        WHERE share_cd    = '1'
                          AND line_cd     = v_line_cd
                          AND dist_seq_no = c1.dist_seq_no
                          AND dist_no     = c1.dist_no)
           LOOP

             /* Get the sum of each field for all the shares excluding the NET
             ** RETENTION share.  The result will serve as the SUBTRAHEND in 
             ** calculating for the values to be attained by the fields belonging
             ** to NET RETENTION. */
             FOR c20 IN (SELECT ROUND(SUM(dist_tsi), 2)              dist_tsi     , 
                                ROUND(SUM(dist_prem), 2)             dist_prem    , 
                                ROUND(SUM(dist_spct), 9)             dist_spct    , 
                                ROUND(SUM(NVL(ann_dist_tsi, 0)), 2)  ann_dist_tsi ,
                                ROUND(SUM(NVL(ann_dist_spct, 0)), 9) ann_dist_spct
                           FROM giuw_wpolicyds_dtl
                          WHERE share_cd   != '1'
                            AND line_cd     = v_line_cd
                            AND dist_seq_no = c1.dist_seq_no
                            AND dist_no     = c1.dist_no)
             LOOP
               v_exist             := 'Y';
               v_sum_dist_tsi      := c20.dist_tsi;
               v_sum_dist_prem     := c20.dist_prem;
               v_sum_dist_spct     := c20.dist_spct;
               v_sum_ann_dist_tsi  := c20.ann_dist_tsi;
               v_sum_ann_dist_spct := c20.ann_dist_spct;
               EXIT;
             END LOOP;
             IF v_exist = 'N' THEN
                EXIT;
             END IF;

             /* Calculate for the values to be attained by the fields
             ** belonging to the NET RETENTION share by subtracting
             ** the values attained from the master table with the
             ** values attained above. */
             v_correct_dist_tsi      := ABS(v_tsi_amt)  - ABS(v_sum_dist_tsi);
             v_correct_dist_prem     := ABS(v_prem_amt) - ABS(v_sum_dist_prem);
             v_correct_dist_spct     := 100 - v_sum_dist_spct;
             v_correct_ann_dist_tsi  := ABS(v_ann_tsi_amt) - ABS(v_sum_ann_dist_tsi);
             v_correct_ann_dist_spct := 100 - v_sum_ann_dist_spct;

             IF SIGN(v_tsi_amt) = -1 THEN
                v_correct_dist_tsi := v_correct_dist_tsi * -1;
             END IF;
             IF SIGN(v_prem_amt) = -1 THEN
                v_correct_dist_prem := v_correct_dist_prem * -1;
             END IF;
             IF SIGN(v_ann_tsi_amt) = -1 THEN
                v_correct_ann_dist_tsi := v_correct_ann_dist_tsi * -1;
             END IF;

             /* Update the values of the fields belonging to the NET
             ** RETENTION share to equalize the amounts attained from
             ** the detail table with the amounts attained from the
             ** master table. */
             UPDATE giuw_wpolicyds_dtl 
                SET dist_tsi      = v_correct_dist_tsi,
                    dist_prem     = v_correct_dist_prem,
                    dist_spct     = v_correct_dist_spct,
                    ann_dist_tsi  = v_correct_ann_dist_tsi,
                    ann_dist_spct = v_correct_ann_dist_spct
              WHERE ROWID         = c10.rowid;
             EXIT;
           END LOOP;
           IF v_exist = 'N' THEN
              RAISE NO_DATA_FOUND;
           END IF;

           /*************************** End of Section B ***************************/

         EXCEPTION
           WHEN NO_DATA_FOUND THEN  
             BEGIN

               /****************************** Section C ******************************
               ** Adjust the value of the fields belonging to the share of the FIRST
               ** RETRIEVED ROW.
               ***********************************************************************/

               /* Get the ROWID of the first retrieved
               ** row in preparation for update. */ 
               FOR c10 IN (SELECT ROWID 
                             FROM giuw_wpolicyds_dtl
                            WHERE ROWNUM      = '1'
                              AND dist_seq_no = c1.dist_seq_no
                              AND dist_no     = c1.dist_no)
               LOOP

                 /* Get the sum of each field for all the shares excluding the share
                 ** of the FIRST RETRIEVED ROW.  The result will serve as the SUBTRAHEND
                 ** in calculating for the values to be attained by the fields belonging
                 ** to the FIRST ROW. */
                 FOR c20 IN (SELECT ROUND(SUM(dist_tsi), 2)              dist_tsi      ,
                                    ROUND(SUM(dist_prem), 2)             dist_prem     , 
                                    ROUND(SUM(dist_spct), 9)             dist_spct     ,
                                    ROUND(SUM(NVL(ann_dist_tsi, 0)), 2)  ann_dist_tsi  ,
                                    ROUND(SUM(NVL(ann_dist_spct, 0)), 9) ann_dist_spct
                               FROM giuw_wpolicyds_dtl
                              WHERE ROWID       != c10.rowid
                                AND dist_seq_no  = c1.dist_seq_no
                                AND dist_no      = c1.dist_no)
                 LOOP
                   v_sum_dist_tsi      := c20.dist_tsi;
                   v_sum_dist_prem     := c20.dist_prem;
                   v_sum_dist_spct     := c20.dist_spct;
                   v_sum_ann_dist_tsi  := c20.ann_dist_tsi;
                   v_sum_ann_dist_spct := c20.ann_dist_spct;
                   EXIT;
                 END LOOP;

                 /* Calculate for the values to be attained by the fields
                 ** belonging to the share of the FIRST ROW by subtracting
                 ** the values attained from the master table with the
                 ** values attained above. */
                 v_correct_dist_tsi      := ABS(v_tsi_amt) - ABS(v_sum_dist_tsi);
                 v_correct_dist_prem     := ABS(v_prem_amt) - ABS(v_sum_dist_prem);
                 v_correct_dist_spct     := 100 - v_sum_dist_spct;
                 v_correct_ann_dist_tsi  := ABS(v_ann_tsi_amt) - ABS(v_sum_ann_dist_tsi);
                 v_correct_ann_dist_spct := 100 - v_sum_ann_dist_spct;

                 IF SIGN(v_tsi_amt) = -1 THEN
                    v_correct_dist_tsi := v_correct_dist_tsi * -1;
                 END IF;
                 IF SIGN(v_prem_amt) = -1 THEN
                    v_correct_dist_prem := v_correct_dist_prem * -1;
                 END IF;
                 IF SIGN(v_ann_tsi_amt) = -1 THEN
                    v_correct_ann_dist_tsi := v_correct_ann_dist_tsi * -1;
                 END IF;

                 /* Update the values of the fields belonging to the share
                 ** of the FIRST ROW to equalize the amounts attained from
                 ** the detail table with the amounts attained from the
                 ** master table. */
                 UPDATE giuw_wpolicyds_dtl 
                    SET dist_tsi      = v_correct_dist_tsi,
                        dist_prem     = v_correct_dist_prem,
                        dist_spct     = v_correct_dist_spct,
                        ann_dist_tsi  = v_correct_ann_dist_tsi,
                        ann_dist_spct = v_correct_ann_dist_spct
                  WHERE ROWID         = c10.rowid;
                 EXIT;

               END LOOP;
             END;
            
             /**************************** End of Section C *************************/

         END;
      END IF;
    END;
  END LOOP;
END;
/


