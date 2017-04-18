DROP PROCEDURE CPI.CREATE_RI_RECORDS;

CREATE OR REPLACE PROCEDURE CPI.CREATE_RI_RECORDS(p_dist_no    IN giuw_pol_dist.dist_no%TYPE,
                            p_par_id     IN gipi_parlist.par_id%TYPE,
                            p_line_cd    IN gipi_wpolbas.line_cd%TYPE,
                            p_subline_cd IN gipi_wpolbas.subline_cd%TYPE) IS
  v_frps_exist			BOOLEAN;
  v_line_cd			giuw_wperilds.line_cd%TYPE;
  v_new_dist_tsi		giuw_wpolicyds_dtl.dist_tsi%TYPE;
  v_new_dist_prem               giuw_wpolicyds_dtl.dist_prem%TYPE;
  v_new_dist_spct		giuw_wpolicyds_dtl.dist_spct%TYPE;
  v_exist			VARCHAR2(1) := 'N';
  v_disallow_posting_sw         VARCHAR2(1) := 'N';
BEGIN

  /* ************************************************************************************* */
  /* Checks for the existence of a facultative share code in each of the DIST_SEQ_NO's of
  ** table GIUW_WPOLICYDS_DTL.  If the said share code exists for a particular DIST_SEQ_NO,
  ** then procedure will check for an existing record in RI table GIRI_WDISTFRPS and update
  ** such record in accordance with the values taken in by table GIUW_WPOLICYDS_DTL.  Should
  ** table GIRI_WDISTFRPS contain no entries with regards to the current DIST_SEQ_NO with the
  ** facultative share, then a record shall be created against the said table.
  ** On the other hand, if a facultative share does not exist for a particular DIST_SEQ_NO,
  ** then procedure will delete any related records in RI tables GIRI_WBINDER_PERIL,
  ** GIRI_WBINDER, GIRI_WFRPERIL, GIRI_WFRPS_RI, and GIRI_WDISTFRPS.
  ** NOTE:  A VALID facultative share must not have a zero DIST_TSI and a zero DIST_PREM.
  ** Modified by:  Crystal 12/28/1998  */
  /* ************************************************************************************ */

  FOR c1 IN (SELECT C1306.dist_seq_no , C1306.tsi_amt    , C1306.prem_amt ,
                    B450.currency_cd  , B450.currency_rt , C080.user_id
               FROM giuw_wpolicyds C1306,
                    giuw_pol_dist C080,
                    gipi_winvoice B450
              WHERE B450.item_grp = C1306.item_grp
                AND B450.par_id   = C080.par_id
                AND C080.dist_no  = C1306.dist_no
                AND C1306.dist_no = p_dist_no)
  LOOP
    BEGIN

      /* Get the LINE_CD for the particular DIST_SEQ_NO
      ** for use in retrieving the correct data from
      ** GIUW_WPOLICYDS_DTL. */
      FOR c100 IN (SELECT line_cd
                     FROM giuw_wperilds
                    WHERE dist_seq_no = c1.dist_seq_no
                      AND dist_no     = p_dist_no)
      LOOP
        v_line_cd := c100.line_cd;
        EXIT;
      END LOOP;

      v_exist := 'N';
      FOR c200 IN (SELECT dist_prem , dist_spct , dist_tsi
                   FROM giuw_wpolicyds_dtl
                  WHERE share_cd    = '999'
                    AND line_cd     = v_line_cd
                    AND dist_seq_no = c1.dist_seq_no
                    AND dist_no     = p_dist_no)
      LOOP
        v_exist         := 'Y';
        v_new_dist_prem := c200.dist_prem;
        v_new_dist_spct := c200.dist_spct;
        v_new_dist_tsi  := c200.dist_tsi;
        EXIT;
      END LOOP;
      IF v_exist = 'N' THEN
         RAISE NO_DATA_FOUND;
      END IF;

      IF v_new_dist_tsi  = 0 AND
         v_new_dist_prem = 0 THEN

         /* Sets the distribution flag of table GIUW_WPOLICYDS to
         ** 1, signifying that the current DIST_SEQ_NO is not yet
         ** properly distributed. */
         UPDATE giuw_wpolicyds
            SET dist_flag =  '1'
          WHERE dist_seq_no = c1.dist_seq_no
            AND dist_no     = p_dist_no;

      END IF;

      IF v_new_dist_tsi  != 0 OR 
         v_new_dist_prem != 0 THEN

         /* Checks for an existing record corresponding to
         ** the given DIST_SEQ_NO in table GIRI_WDISTFRPS. */
         v_frps_exist := CHECK_FOR_EXISTING_FRPS(p_dist_no, c1.dist_seq_no);

         IF NOT v_frps_exist THEN

            /* Creates a new record in table GIRI_WDISTFRPS in
            ** accordance with the data taken in by table
            ** GIUW_WPOLICYDS_DTL. */
            CREATE_RI_NEW_WDISTFRPS
                  (p_dist_no       , c1.dist_seq_no , c1.tsi_amt      ,
                   c1.prem_amt     , v_new_dist_tsi , v_new_dist_prem ,
                   v_new_dist_spct , c1.currency_cd , c1.currency_rt  ,
                   c1.user_id      , p_par_id       , p_line_cd       ,
                   p_subline_cd);

         ELSE

            /* Updates the existing record of table 
            ** GIRI_WDISTFRPS in accordance with the
            ** data taken in by table GIUW_WPOLICYDS_DTL. */            
            UPDATE_RI_WDISTFRPS
                  (p_dist_no       , c1.dist_seq_no , c1.tsi_amt      ,
                   c1.prem_amt     , v_new_dist_tsi , v_new_dist_prem , 
                   v_new_dist_spct , c1.currency_cd , c1.currency_rt  ,
                   c1.user_id);

         END IF;
      ELSE

         /* Delete related records in RI tables GIRI_WBINDER_PERIL,
         ** GIRI_WBINDER, GIRI_WFRPERIL, GIRI_WFRPS_RI, and 
         ** GIRI_WDISTFRPS. */
         DELETE_RI_TABLES(p_dist_no, c1.dist_seq_no);

      END IF;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN

        /* Delete related records in RI tables GIRI_WBINDER_PERIL,
        ** GIRI_WBINDER, GIRI_WFRPERIL, GIRI_WFRPS_RI, and 
        ** GIRI_WDISTFRPS. */
        DELETE_RI_TABLES(p_dist_no, c1.dist_seq_no);

    END;
  END LOOP;

END;
/


