DROP PROCEDURE CPI.CRTE_RI_NEW_WDISTFRPS_GIUWS005;

CREATE OR REPLACE PROCEDURE CPI.CRTE_RI_NEW_WDISTFRPS_GIUWS005(
	   	  		  				  p_dist_no         IN giuw_wpolicyds_dtl.dist_no%TYPE,
                                  p_dist_seq_no     IN giuw_wpolicyds_dtl.dist_seq_no%TYPE,
                                  p_new_tsi_amt     IN giuw_wpolicyds.tsi_amt%TYPE,
                                  p_new_prem_amt    IN giuw_wpolicyds.prem_amt%TYPE, 
                                  p_new_dist_tsi    IN giuw_wpolicyds_dtl.dist_tsi%TYPE, 
                                  p_new_dist_prem   IN giuw_wpolicyds_dtl.dist_prem%TYPE,
                                  p_new_dist_spct   IN giuw_wpolicyds_dtl.dist_spct%TYPE,
                                  p_new_currency_cd IN gipi_winvoice.currency_cd%TYPE,
                                  p_new_currency_rt IN gipi_winvoice.currency_rt%TYPE,
                                  p_new_user_id     IN giuw_pol_dist.user_id%TYPE,
                                  p_par_id          IN gipi_parlist.par_id%TYPE,
                                  p_line_cd         IN gipi_wpolbas.line_cd%TYPE,
                                  p_subline_cd      IN gipi_wpolbas.subline_cd%TYPE) IS

  v_claims_control_sw       giri_wdistfrps.claims_control_sw%TYPE := 'N';
  v_claims_coop_sw          giri_wdistfrps.claims_coop_sw%TYPE    := 'N';
  v_op_sw					giri_wdistfrps.op_sw%TYPE;
  v_op_frps_yy				giri_wdistfrps.op_frps_yy%TYPE;
  v_op_frps_seq_no			giri_wdistfrps.op_frps_seq_no%TYPE;

BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : April 05, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : CREATE_RI_NEW_WDISTFRPS program unit
  */
  
  /* Set the OP_SW of table GIRI_WDISTFRPS to 'Y',
  ** if the subline_cd of the specified PAR is in
  ** 'MOP' or 'MRN'. */
  IF p_subline_cd = 'MOP' THEN
     v_op_sw := 'Y';
  END IF;
  IF p_subline_cd = 'MRN' THEN
     v_op_sw := 'Y';

     /* For risk note policies, get the FRPS_YY and FRPS_SEQ_NO of the
     ** open policy to which the risk note belongs to.  The value 
     ** retrieved shall be used to populate the OP_FRPS_YY and OP_FRPS_SEQ_NO
     ** of table GIRI_WDISTFRPS upon data insertion. */
     FOR c1 IN (SELECT a.frps_yy frps_yy, a.frps_seq_no frps_seq_no
                  FROM giri_wdistfrps a   , giuw_pol_dist c080 ,
                       gipi_polbasic b250 , gipi_wopen_policy b
                 WHERE a.dist_no       = c080.dist_no
                   AND c080.policy_id  = b250.policy_id
                   AND b250.pol_seq_no = b.op_pol_seqno
                   AND b250.issue_yy   = b.op_issue_yy
                   AND b250.iss_cd     = b.op_iss_cd
                   AND b250.subline_cd = b.op_subline_cd
                   AND b250.line_cd    = b.line_cd
                   AND c080.dist_flag IN ('1', '2', '3')
                   AND b.par_id        = p_par_id)
     LOOP
       v_op_frps_yy     := c1.frps_yy;
       v_op_frps_seq_no := c1.frps_seq_no;
       EXIT;
     END LOOP;
  END IF;

  /* Check for an existing CLAIMS CONTROL clause from
  ** table GIPI_POLWC to determine the appropriate value
  ** of the CLAIMS_CONTROL_SW in table GIRI_WDISTFRPS. */
  FOR A IN (SELECT wc_cd
              FROM gipi_wpolwc
             WHERE UPPER(wc_title) LIKE '%CLAIMS CONTROL%'
               AND par_id = p_par_id)
  LOOP
    v_claims_control_sw := 'Y';
    EXIT;
  END LOOP;

  /* Check for an existing CLAIMS COOP clause from table
  ** GIPI_POLWC to determine the appropriate value of the
  ** of the CLAIMS_COOP_SW in table GIRI_WDISTFRPS. */
  FOR A IN (SELECT wc_cd
              FROM gipi_wpolwc
             WHERE UPPER(wc_title) LIKE '%CLAIMS COOP%'
               AND par_id = p_par_id)
  LOOP
    v_claims_coop_sw    := 'Y';
    EXIT;
  END LOOP;

  /* Creates a record in table GIRI_WDISTFRPS for the specified DIST_NO
  ** and DIST_SEQ_NO. */
  INSERT INTO  giri_wdistfrps
              (frps_yy                          , line_cd           , op_group_no      ,
               op_frps_yy                       , op_frps_seq_no    , dist_no          ,
               dist_seq_no                      , tsi_amt           , tot_fac_spct     ,
               tot_fac_tsi                      , prem_amt          , tot_fac_prem     ,
               loc_voy_unit                     , op_sw             , ri_flag          ,
               currency_cd                      , currency_rt       , create_date      ,
               user_id                          , prem_warr_sw      , claims_coop_sw   ,
               claims_control_sw)
       VALUES (TO_NUMBER(TO_CHAR(SYSDATE,'YY')) , p_line_cd         , NULL             ,
               v_op_frps_yy                     , v_op_frps_seq_no  , p_dist_no        ,
               p_dist_seq_no                    , p_new_tsi_amt     , p_new_dist_spct  ,
               p_new_dist_tsi                   , p_new_prem_amt    , p_new_dist_prem  ,
               NULL                             , v_op_sw           , '1'              ,
               p_new_currency_cd                , p_new_currency_rt , SYSDATE          ,
               p_new_user_id                    , 'N'               , v_claims_coop_sw ,
               v_claims_control_sw);  
END;
/


