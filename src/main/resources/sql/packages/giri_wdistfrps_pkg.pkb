CREATE OR REPLACE PACKAGE BODY CPI.GIRI_WDISTFRPS_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.17.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/
	PROCEDURE del_giri_wdistfrps(p_dist_no	GIRI_WDISTFRPS.dist_no%TYPE)
	IS
	BEGIN
		DELETE GIRI_WDISTFRPS
		 WHERE dist_no = p_dist_no;
	END del_giri_wdistfrps;
    
  /*
  **  Created by	: Menandro G.C. Robes
  **  Date Created 	: March 22, 2010
  **  Reference By 	: (SET_LIMIT_INTO_GIPI_WITMPERL)
  **  Description 	: Procedure to delete wdistfrps record.
  */
  PROCEDURE del_giri_wdistfrps1(p_frps_seq_no IN GIRI_WDISTFRPS.frps_seq_no%TYPE,
                                p_frps_yy     IN GIRI_WDISTFRPS.frps_yy%TYPE)
  IS
  BEGIN
    DELETE giri_wdistfrps
     WHERE frps_seq_no = p_frps_seq_no
       AND frps_yy     = p_frps_yy;
         
  END del_giri_wdistfrps1;
  
    /*
    **  Created by        : Jerome Orio 
    **  Date Created     : 06.09.2011   
    **  Reference By     : (GIUWS006- Preliminary  Peril Distribution by TSI/Prem) 
    */
    PROCEDURE CREATE_RI_NEW_WDISTFRPS(p_dist_no         IN giuw_wpolicyds_dtl.dist_no%TYPE,
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
                                      p_subline_cd      IN gipi_wpolbas.subline_cd%TYPE,
                                      p_new_dist_spct1  IN giuw_wpolicyds_dtl.dist_spct%TYPE) IS

      v_claims_control_sw           giri_wdistfrps.claims_control_sw%TYPE := 'N';
      v_claims_coop_sw              giri_wdistfrps.claims_coop_sw%TYPE    := 'N';
      v_op_sw                       giri_wdistfrps.op_sw%TYPE;
      v_op_frps_yy                  giri_wdistfrps.op_frps_yy%TYPE;
      v_op_frps_seq_no              giri_wdistfrps.op_frps_seq_no%TYPE;
      v_tot_fac_spct1               giri_wdistfrps.tot_fac_spct2%TYPE;
    BEGIN
      
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
                   claims_control_sw                , tot_fac_spct2)
           VALUES (TO_NUMBER(TO_CHAR(SYSDATE,'YY')) , p_line_cd         , NULL             ,
                   v_op_frps_yy                     , v_op_frps_seq_no  , p_dist_no        ,
                   p_dist_seq_no                    , p_new_tsi_amt     , p_new_dist_spct  ,
                   p_new_dist_tsi                   , p_new_prem_amt    , p_new_dist_prem  ,
                   NULL                             , v_op_sw           , '1'              ,
                   p_new_currency_cd                , p_new_currency_rt , SYSDATE          ,
                   p_new_user_id                    , 'N'               , v_claims_coop_sw ,
                   v_claims_control_sw              , p_new_dist_spct1);  


    END;  

    /*
    **  Created by        : Jerome Orio 
    **  Date Created     : 06.09.2011   
    **  Reference By     : (GIUWS006- Preliminary  Peril Distribution by TSI/Prem) 
    */
    PROCEDURE UPDATE_RI_WDISTFRPS(p_dist_no         IN giuw_wpolicyds_dtl.dist_no%TYPE,
                                  p_dist_seq_no     IN giuw_wpolicyds_dtl.dist_seq_no%TYPE,
                                  p_new_tsi_amt     IN giuw_wpolicyds.tsi_amt%TYPE,
                                  p_new_prem_amt    IN giuw_wpolicyds.prem_amt%TYPE,
                                  p_new_dist_tsi    IN giuw_wpolicyds_dtl.dist_tsi%TYPE,
                                  p_new_dist_prem   IN giuw_wpolicyds_dtl.dist_prem%TYPE, 
                                  p_new_dist_spct   IN giuw_wpolicyds_dtl.dist_spct%TYPE,
                                  p_new_currency_cd IN gipi_winvoice.currency_cd%TYPE,
                                  p_new_currency_rt IN gipi_winvoice.currency_rt%TYPE,
                                  p_new_user_id     IN giuw_pol_dist.user_id%TYPE,
                                  p_new_dist_spct1   IN giuw_wpolicyds_dtl.dist_spct1%TYPE) IS
    BEGIN
      
      
      UPDATE giri_wdistfrps
         SET tsi_amt      = p_new_tsi_amt,
             prem_amt     = p_new_prem_amt,
             tot_fac_spct = p_new_dist_spct,
             tot_fac_spct2 = p_new_dist_spct1,
             tot_fac_prem = p_new_dist_prem,
             tot_fac_tsi  = p_new_dist_tsi,
             currency_cd  = p_new_currency_cd,
             currency_rt  = p_new_currency_rt,
             user_id      = p_new_user_id
       WHERE dist_seq_no  = p_dist_seq_no
         AND dist_no      = p_dist_no;
    END;
	
	/*
    **  Created by        : Anthony Santos
    **  Date Created     : 07.20.2011   
    **  Reference By     : (GIUWS013- One Risk Policy) 
    */

PROCEDURE CREATE_NEW_WDISTFRPS_GIUWS013(
		  					   p_dist_no         IN giuw_wpolicyds_dtl.dist_no%TYPE,	 		
		  					   p_dist_seq_no     IN giuw_wpolicyds_dtl.dist_seq_no%TYPE,
                               p_new_tsi_amt     IN giuw_wpolicyds.tsi_amt%TYPE,
                               p_new_prem_amt    IN giuw_wpolicyds.prem_amt%TYPE, 
                               p_new_dist_tsi    IN giuw_wpolicyds_dtl.dist_tsi%TYPE, 
                               p_new_dist_prem   IN giuw_wpolicyds_dtl.dist_prem%TYPE,
                               p_new_dist_spct   IN giuw_wpolicyds_dtl.dist_spct%TYPE,
                               p_new_currency_cd IN gipi_invoice.currency_cd%TYPE,
                               p_new_currency_rt IN gipi_invoice.currency_rt%TYPE,
                               p_new_user_id     IN giuw_pol_dist.user_id%TYPE,
							   p_line_cd         IN gipi_wpolbas.line_cd%TYPE,
                               p_subline_cd      IN gipi_wpolbas.subline_cd%TYPE,
							   p_policy_id       IN giuw_pol_dist.policy_id%TYPE) IS

  v_claims_control_sw                   giri_wdistfrps.claims_control_sw%TYPE := 'N';
  v_claims_coop_sw                      giri_wdistfrps.claims_coop_sw%TYPE    := 'N';
  v_op_sw				giri_wdistfrps.op_sw%TYPE;
  v_op_frps_yy				giri_wdistfrps.op_frps_yy%TYPE;
  v_op_frps_seq_no			giri_wdistfrps.op_frps_seq_no%TYPE;

BEGIN

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
                       gipi_polbasic b250 , gipi_open_policy b
                 WHERE a.dist_no       = c080.dist_no
                   AND c080.policy_id  = b250.policy_id
                   AND b250.pol_seq_no = b.op_pol_seqno
                   AND b250.issue_yy   = b.op_issue_yy
                   AND b250.iss_cd     = b.op_iss_cd
                   AND b250.subline_cd = b.op_subline_cd
                   AND b250.line_cd    = b.line_cd
                   AND c080.dist_flag IN ('1', '2', '3')
                   AND b.policy_id     = p_policy_id)
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
              FROM gipi_polwc
             WHERE UPPER(wc_title) LIKE '%CLAIMS CONTROL%'
               AND policy_id = p_policy_id)
  LOOP
    v_claims_control_sw := 'Y';
    EXIT;
  END LOOP;

  /* Check for an existing CLAIMS COOP clause from table
  ** GIPI_POLWC to determine the appropriate value of the
  ** of the CLAIMS_COOP_SW in table GIRI_WDISTFRPS. */
  FOR A IN (SELECT wc_cd
              FROM gipi_polwc
             WHERE UPPER(wc_title) LIKE '%CLAIMS COOP%'
               AND policy_id = p_policy_id)
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
       VALUES (TO_NUMBER(TO_CHAR(SYSDATE,'YY')) , p_line_cd    , NULL             ,
               v_op_frps_yy                     , v_op_frps_seq_no  , p_dist_no    ,
               p_dist_seq_no                    , p_new_tsi_amt     , p_new_dist_spct  ,
               p_new_dist_tsi                   , p_new_prem_amt    , p_new_dist_prem  ,
               NULL                             , v_op_sw           , '1'              ,
               p_new_currency_cd                , p_new_currency_rt , SYSDATE          ,
               p_new_user_id                    , 'N'               , v_claims_coop_sw ,
               v_claims_control_sw);  
END;

/*
    **  Created by        : Anthony Santos
    **  Date Created     : 07.20.2011   
    **  Reference By     : (GIUWS013- One Risk Policy) 
    */

PROCEDURE UPDATE_WDISTFRPS_GIUWS013(
		  				   p_dist_no         IN giuw_wpolicyds_dtl.dist_no%TYPE,
		  				   p_dist_seq_no     IN giuw_wpolicyds_dtl.dist_seq_no%TYPE,
                           p_new_tsi_amt     IN giuw_wpolicyds.tsi_amt%TYPE,
                           p_new_prem_amt    IN giuw_wpolicyds.prem_amt%TYPE,
                           p_new_dist_tsi    IN giuw_wpolicyds_dtl.dist_tsi%TYPE,
                           p_new_dist_prem   IN giuw_wpolicyds_dtl.dist_prem%TYPE, 
                           p_new_dist_spct   IN giuw_wpolicyds_dtl.dist_spct%TYPE,
                           p_new_currency_cd IN gipi_invoice.currency_cd%TYPE,
                           p_new_currency_rt IN gipi_invoice.currency_rt%TYPE,
                           p_new_user_id     IN giuw_pol_dist.user_id%TYPE) IS
BEGIN
  UPDATE giri_wdistfrps
     SET tsi_amt      = p_new_tsi_amt,
         prem_amt     = p_new_prem_amt,
         tot_fac_spct = p_new_dist_spct,
         tot_fac_prem = p_new_dist_prem,
         tot_fac_tsi  = p_new_dist_tsi,
         currency_cd  = p_new_currency_cd,
         currency_rt  = p_new_currency_rt,
         user_id      = p_new_user_id
   WHERE dist_seq_no  = p_dist_seq_no
     AND dist_no      = p_dist_no;
END;

/*
    **  Created by        : Anthony Santos
    **  Date Created     : 07.20.2011   
    **  Reference By     : (GIUWS013- One Risk Policy) 
    */
PROCEDURE CREATE_WDISTFRPS_GIUWS013(
		  				   p_dist_no         IN giuw_wpolicyds_dtl.dist_no%TYPE,
		  				   p_old_dist_no     IN giuw_wpolicyds.dist_no%TYPE,
                           p_dist_seq_no     IN giuw_wpolicyds_dtl.dist_seq_no%TYPE,
                           p_new_tsi_amt     IN giuw_wpolicyds.tsi_amt%TYPE,
                           p_new_prem_amt    IN giuw_wpolicyds.prem_amt%TYPE,
                           p_new_dist_tsi    IN giuw_wpolicyds_dtl.dist_tsi%TYPE,
                           p_new_dist_prem   IN giuw_wpolicyds_dtl.dist_prem%TYPE, 
                           p_new_dist_spct   IN giuw_wpolicyds_dtl.dist_spct%TYPE, 
                           p_new_currency_cd IN gipi_invoice.currency_cd%TYPE,
                           p_new_currency_rt IN gipi_invoice.currency_rt%TYPE,
                           p_new_user_id     IN giuw_pol_dist.user_id%TYPE,
						   p_line_cd         IN gipi_wpolbas.line_cd%TYPE) IS
  
  v_op_group_no		giri_distfrps.op_group_no%TYPE;
  v_op_frps_yy		giri_distfrps.op_frps_yy%TYPE;
  v_op_frps_seq_no	giri_distfrps.op_frps_seq_no%TYPE;
  v_loc_voy_unit	giri_distfrps.loc_voy_unit%TYPE;
  v_op_sw		giri_distfrps.op_sw%TYPE;
  v_ri_flag		giri_distfrps.ri_flag%TYPE;
  v_prem_warr_sw	giri_distfrps.prem_warr_sw%TYPE;
  v_claims_coop_sw	giri_distfrps.claims_coop_sw%TYPE;
  v_claims_control_sw	giri_distfrps.claims_control_sw%TYPE;

BEGIN
  FOR c1 IN (SELECT op_group_no  , op_frps_yy     , op_frps_seq_no    ,
                    loc_voy_unit , op_sw          , ri_flag           ,
                    prem_warr_sw , claims_coop_sw , claims_control_sw
               FROM giri_distfrps
              WHERE dist_seq_no = p_dist_seq_no
                AND dist_no     = p_old_dist_no)
  LOOP
    v_op_group_no       := c1.op_group_no;
    v_op_frps_yy        := c1.op_frps_yy;
    v_op_frps_seq_no    := c1.op_frps_seq_no;
    v_loc_voy_unit      := c1.loc_voy_unit;
    v_op_sw             := c1.op_sw;
    v_ri_flag           := c1.ri_flag;
    v_prem_warr_sw      := c1.prem_warr_sw;
    v_claims_coop_sw    := c1.claims_coop_sw;
    v_claims_control_sw := c1.claims_control_sw;
    EXIT;
  END LOOP;

  INSERT INTO  giri_wdistfrps
              (frps_yy                          , line_cd           , op_group_no      ,
               op_frps_yy                       , op_frps_seq_no    , dist_no          ,
               dist_seq_no                      , tsi_amt           , tot_fac_spct     ,
               tot_fac_tsi                      , prem_amt          , tot_fac_prem     ,
               loc_voy_unit                     , op_sw             , ri_flag          ,
               currency_cd                      , currency_rt       , create_date      ,
               user_id                          , prem_warr_sw      , claims_coop_sw   ,
               claims_control_sw)
       VALUES (TO_NUMBER(TO_CHAR(SYSDATE,'YY')) , p_line_cd    , v_op_group_no    , 
               v_op_frps_yy                     , v_op_frps_seq_no  , p_dist_no    ,
               p_dist_seq_no                    , p_new_tsi_amt     , p_new_dist_spct  ,
               p_new_dist_tsi                   , p_new_prem_amt    , p_new_dist_prem  ,
               v_loc_voy_unit                   , v_op_sw           , v_ri_flag        ,
               p_new_currency_cd                , p_new_currency_rt , SYSDATE          ,
               p_new_user_id                    , v_prem_warr_sw    , v_claims_coop_sw ,
               v_claims_control_sw);
END;


/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 2, 2011
**  Reference By : GIUWS016 - One-Risk Distribution by TSI/Prem (Group)
**  Description  : Updates the existing record in table GIRI_WDISTFRPS,
**                 setting fields to its new values as reflected
**                 in table GIUW_WPOLICYDS_DTL.
*/

PROCEDURE UPDATE_WDISTFRPS_GIUWS016(p_dist_no         IN  GIUW_POL_DIST.dist_no%TYPE,
                                    p_dist_seq_no     IN  GIUW_WPOLICYDS_DTL.dist_seq_no%TYPE,
                                    p_new_tsi_amt     IN  GIUW_WPOLICYDS.tsi_amt%TYPE,
                                    p_new_prem_amt    IN  GIUW_WPOLICYDS.prem_amt%TYPE,
                                    p_new_dist_tsi    IN  GIUW_WPOLICYDS_DTL.dist_tsi%TYPE,
                                    p_new_dist_prem   IN  GIUW_WPOLICYDS_DTL.dist_prem%TYPE, 
                                    p_new_dist_spct   IN  GIUW_WPOLICYDS_DTL.dist_spct%TYPE,
                                    p_new_dist_spct1  IN  GIUW_WPOLICYDS_DTL.dist_spct1%TYPE,
                                    p_new_currency_cd IN  GIPI_INVOICE.currency_cd%TYPE,
                                    p_new_currency_rt IN  GIPI_INVOICE.currency_rt%TYPE,
                                    p_new_user_id     IN  GIUW_POL_DIST.user_id%TYPE) 
IS

BEGIN
  UPDATE GIRI_WDISTFRPS
     SET tsi_amt       = p_new_tsi_amt,
         prem_amt      = p_new_prem_amt,
         tot_fac_spct  = p_new_dist_spct,
         tot_fac_spct2 = p_new_dist_spct1,
         tot_fac_prem  = p_new_dist_prem,
         tot_fac_tsi   = p_new_dist_tsi,
         currency_cd   = p_new_currency_cd,
         currency_rt   = p_new_currency_rt,
         user_id       = p_new_user_id
   WHERE dist_seq_no   = p_dist_seq_no
     AND dist_no       = p_dist_no;
END;

/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 2, 2011
**  Reference By : GIUWS016 - One-Risk Distribution by TSI/Prem (Group)
**  Description  : Creates a record in table GIRI_WDISTFRPS based on the values taken in
**                 by certain fields belonging to table GIUW_WPOLICYDS_DTL of the current
**                 distribution record, and GIRI_DISTFRPS of the previously negated 
**                 distribution record.
*/

PROCEDURE CREATE_WDISTFRPS_GIUWS016(p_dist_no         IN  GIUW_WPOLICYDS_DTL.dist_no%TYPE,
                                    p_line_cd         IN  GIPI_WPOLBAS.line_cd%TYPE,
                                    p_old_dist_no     IN  GIUW_WPOLICYDS.dist_no%TYPE,
                                    p_dist_seq_no     IN  GIUW_WPOLICYDS_DTL.dist_seq_no%TYPE,
                                    p_new_tsi_amt     IN  GIUW_WPOLICYDS.tsi_amt%TYPE,
                                    p_new_prem_amt    IN  GIUW_WPOLICYDS.prem_amt%TYPE,
                                    p_new_dist_tsi    IN  GIUW_WPOLICYDS_DTL.dist_tsi%TYPE,
                                    p_new_dist_prem   IN  GIUW_WPOLICYDS_DTL.dist_prem%TYPE, 
                                    p_new_dist_spct   IN  GIUW_WPOLICYDS_DTL.dist_spct%TYPE, 
                                    p_new_dist_spct1  IN  GIUW_WPOLICYDS_DTL.dist_spct1%TYPE, 
                                    p_new_currency_cd IN  GIPI_INVOICE.currency_cd%TYPE,
                                    p_new_currency_rt IN  GIPI_INVOICE.currency_rt%TYPE,
                                    p_new_user_id     IN  GIUW_POL_DIST.user_id%TYPE) IS
  
  v_op_group_no         GIRI_DISTFRPS.op_group_no%TYPE;
  v_op_frps_yy          GIRI_DISTFRPS.op_frps_yy%TYPE;
  v_op_frps_seq_no      GIRI_DISTFRPS.op_frps_seq_no%TYPE;
  v_loc_voy_unit        GIRI_DISTFRPS.loc_voy_unit%TYPE;
  v_op_sw               GIRI_DISTFRPS.op_sw%TYPE;
  v_ri_flag             GIRI_DISTFRPS.ri_flag%TYPE;
  v_prem_warr_sw        GIRI_DISTFRPS.prem_warr_sw%TYPE;
  v_claims_coop_sw      GIRI_DISTFRPS.claims_coop_sw%TYPE;
  v_claims_control_sw   GIRI_DISTFRPS.claims_control_sw%TYPE;

BEGIN
  FOR c1 IN (SELECT op_group_no  , op_frps_yy     , op_frps_seq_no    ,
                    loc_voy_unit , op_sw          , ri_flag           ,
                    prem_warr_sw , claims_coop_sw , claims_control_sw
               FROM GIRI_DISTFRPS
              WHERE dist_seq_no = p_dist_seq_no
                AND dist_no     = p_old_dist_no)
  LOOP
    v_op_group_no       := c1.op_group_no;
    v_op_frps_yy        := c1.op_frps_yy;
    v_op_frps_seq_no    := c1.op_frps_seq_no;
    v_loc_voy_unit      := c1.loc_voy_unit;
    v_op_sw             := c1.op_sw;
    v_ri_flag           := c1.ri_flag;
    v_prem_warr_sw      := c1.prem_warr_sw;
    v_claims_coop_sw    := c1.claims_coop_sw;
    v_claims_control_sw := c1.claims_control_sw;
    EXIT;
  END LOOP;

  INSERT INTO  GIRI_WDISTFRPS
              (frps_yy                          , line_cd           , op_group_no      ,
               op_frps_yy                       , op_frps_seq_no    , dist_no          ,
               dist_seq_no                      , tsi_amt           , tot_fac_spct     ,
               tot_fac_tsi                      , prem_amt          , tot_fac_prem     ,
               loc_voy_unit                     , op_sw             , ri_flag          ,
               currency_cd                      , currency_rt       , create_date      ,
               user_id                          , prem_warr_sw      , claims_coop_sw   ,
               claims_control_sw                , tot_fac_spct2     )
       VALUES (TO_NUMBER(TO_CHAR(SYSDATE,'YY')) , p_line_cd    , v_op_group_no    , 
               v_op_frps_yy                     , v_op_frps_seq_no  , p_dist_no    ,
               p_dist_seq_no                    , p_new_tsi_amt     , p_new_dist_spct  ,
               p_new_dist_tsi                   , p_new_prem_amt    , p_new_dist_prem  ,
               v_loc_voy_unit                   , v_op_sw           , v_ri_flag        ,
               p_new_currency_cd                , p_new_currency_rt , SYSDATE          ,
               p_new_user_id                    , v_prem_warr_sw    , v_claims_coop_sw ,
               v_claims_control_sw              , p_new_dist_spct1);
END;

/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 2, 2011
**  Reference By : GIUWS016 - One-Risk Distribution by TSI/Prem (Group)
**  Description  : Creates a new record in table GIRI_WDISTFRPS in accordance with
**                 the data taken in by the facultative share of a specific DIST_SEQ_NO
**                 in table GIUW_WPOLICYDS_DTL.
*/

PROCEDURE CREATE_RI_NEW_WDISTFRPS_016(p_policy_id       IN  GIUW_POL_DIST.policy_id%TYPE,
                                      p_dist_no         IN  GIUW_WPOLICYDS_DTL.dist_no%TYPE,
                                      p_dist_seq_no     IN  GIUW_WPOLICYDS_DTL.dist_seq_no%TYPE,
                                      p_new_tsi_amt     IN  GIUW_WPOLICYDS.tsi_amt%TYPE,
                                      p_new_prem_amt    IN  GIUW_WPOLICYDS.prem_amt%TYPE, 
                                      p_new_dist_tsi    IN  GIUW_WPOLICYDS_DTL.dist_tsi%TYPE, 
                                      p_new_dist_prem   IN  GIUW_WPOLICYDS_DTL.dist_prem%TYPE,
                                      p_new_dist_spct   IN  GIUW_WPOLICYDS_DTL.dist_spct%TYPE,
                                      p_new_currency_cd IN  GIPI_WINVOICE.currency_cd%TYPE,
                                      p_new_currency_rt IN  GIPI_WINVOICE.currency_rt%TYPE,
                                      p_new_user_id     IN  GIUW_POL_DIST.user_id%TYPE,
                                      p_par_id          IN  GIPI_PARLIST.par_id%TYPE,
                                      p_line_cd         IN  GIPI_WPOLBAS.line_cd%TYPE,
                                      p_subline_cd      IN  GIPI_WPOLBAS.subline_cd%TYPE) 
  IS

  v_claims_control_sw             GIRI_WDISTFRPS.claims_control_sw%TYPE := 'N';
  v_claims_coop_sw                GIRI_WDISTFRPS.claims_coop_sw%TYPE    := 'N';
  v_op_sw                         GIRI_WDISTFRPS.op_sw%TYPE;
  v_op_frps_yy                    GIRI_WDISTFRPS.op_frps_yy%TYPE;
  v_op_frps_seq_no                GIRI_WDISTFRPS.op_frps_seq_no%TYPE;

BEGIN

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
                  FROM GIRI_WDISTFRPS a   , GIUW_POL_DIST c080 ,
                       GIPI_POLBASIC b250 , GIPI_WOPEN_POLICY b
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
              FROM GIPI_POLWC
             WHERE UPPER(wc_title) LIKE '%CLAIMS CONTROL%'
               AND policy_id = p_policy_id)
  LOOP
    v_claims_control_sw := 'Y';
    EXIT;
  END LOOP;

  /* Check for an existing CLAIMS COOP clause from table
  ** GIPI_POLWC to determine the appropriate value of the
  ** of the CLAIMS_COOP_SW in table GIRI_WDISTFRPS. */
  FOR A IN (SELECT wc_cd
              FROM GIPI_POLWC
             WHERE UPPER(wc_title) LIKE '%CLAIMS COOP%'
               AND policy_id = p_policy_id)
  LOOP
    v_claims_coop_sw    := 'Y';
    EXIT;
  END LOOP;

  /* Creates a record in table GIRI_WDISTFRPS for the specified DIST_NO
  ** and DIST_SEQ_NO. */
  INSERT INTO  GIRI_WDISTFRPS
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

/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 2, 2011
**  Reference By : GIUWS016 - One-Risk Distribution by TSI/Prem (Group)
**  Description  : Creates a new record in table GIRI_WDISTFRPS in accordance with
**                 the data taken in by the facultative share of a specific DIST_SEQ_NO
**                 in table GIUW_WPOLICYDS_DTL
*/

PROCEDURE CREATE_NEW_WDISTFRPS_GIUWS016(p_dist_no         IN  GIUW_WPOLICYDS_DTL.dist_no%TYPE,
                                        p_dist_seq_no     IN  GIUW_WPOLICYDS_DTL.dist_seq_no%TYPE,
                                        p_new_tsi_amt     IN  GIUW_WPOLICYDS.tsi_amt%TYPE,
                                        p_new_prem_amt    IN  GIUW_WPOLICYDS.prem_amt%TYPE, 
                                        p_new_dist_tsi    IN  GIUW_WPOLICYDS_DTL.dist_tsi%TYPE, 
                                        p_new_dist_prem   IN  GIUW_WPOLICYDS_DTL.dist_prem%TYPE,
                                        p_new_dist_spct   IN  GIUW_WPOLICYDS_DTL.dist_spct%TYPE,
                                        p_new_dist_spct1  IN  GIUW_WPOLICYDS_DTL.dist_spct1%TYPE,
                                        p_new_currency_cd IN  GIPI_INVOICE.currency_cd%TYPE,
                                        p_new_currency_rt IN  GIPI_INVOICE.currency_rt%TYPE,
                                        p_new_user_id     IN  GIUW_POL_DIST.user_id%TYPE,
                                        p_line_cd         IN  GIPI_WPOLBAS.line_cd%TYPE,
                                        p_subline_cd      IN  GIPI_WPOLBAS.subline_cd%TYPE,
                                        p_policy_id       IN  GIUW_POL_DIST.policy_id%TYPE) IS

  v_claims_control_sw          GIRI_WDISTFRPS.claims_control_sw%TYPE := 'N';
  v_claims_coop_sw             GIRI_WDISTFRPS.claims_coop_sw%TYPE    := 'N';
  v_op_sw                      GIRI_WDISTFRPS.op_sw%TYPE;
  v_op_frps_yy                 GIRI_WDISTFRPS.op_frps_yy%TYPE;
  v_op_frps_seq_no             GIRI_WDISTFRPS.op_frps_seq_no%TYPE;

BEGIN

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
                  FROM GIRI_WDISTFRPS a   , GIUW_POL_DIST c080 ,
                       GIPI_POLBASIC b250 , GIPI_OPEN_POLICY b
                 WHERE a.dist_no       = c080.dist_no
                   AND c080.policy_id  = b250.policy_id
                   AND b250.pol_seq_no = b.op_pol_seqno
                   AND b250.issue_yy   = b.op_issue_yy
                   AND b250.iss_cd     = b.op_iss_cd
                   AND b250.subline_cd = b.op_subline_cd
                   AND b250.line_cd    = b.line_cd
                   AND c080.dist_flag IN ('1', '2', '3')
                   AND b.policy_id     = p_policy_id)
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
              FROM GIPI_POLWC
             WHERE UPPER(wc_title) LIKE '%CLAIMS CONTROL%'
               AND policy_id = p_policy_id)
  LOOP
    v_claims_control_sw := 'Y';
    EXIT;
  END LOOP;

  /* Check for an existing CLAIMS COOP clause from table
  ** GIPI_POLWC to determine the appropriate value of the
  ** of the CLAIMS_COOP_SW in table GIRI_WDISTFRPS. */
  FOR A IN (SELECT wc_cd
              FROM GIPI_POLWC
             WHERE UPPER(wc_title) LIKE '%CLAIMS COOP%'
               AND policy_id = p_policy_id)
  LOOP
    v_claims_coop_sw    := 'Y';
    EXIT;
  END LOOP;

  /* Creates a record in table GIRI_WDISTFRPS for the specified DIST_NO
  ** and DIST_SEQ_NO. */
  INSERT INTO  GIRI_WDISTFRPS
              (frps_yy                          , line_cd           , op_group_no      ,
               op_frps_yy                       , op_frps_seq_no    , dist_no          ,
               dist_seq_no                      , tsi_amt           , tot_fac_spct     ,
               tot_fac_tsi                      , prem_amt          , tot_fac_prem     ,
               loc_voy_unit                     , op_sw             , ri_flag          ,
               currency_cd                      , currency_rt       , create_date      ,
               user_id                          , prem_warr_sw      , claims_coop_sw   ,
               claims_control_sw                , tot_fac_spct2     )
       VALUES (TO_NUMBER(TO_CHAR(SYSDATE,'YY')) , p_line_cd    , NULL             ,
               v_op_frps_yy                     , v_op_frps_seq_no  , p_dist_no    ,
               p_dist_seq_no                    , p_new_tsi_amt     , p_new_dist_spct  ,
               p_new_dist_tsi                   , p_new_prem_amt    , p_new_dist_prem  ,
               NULL                             , v_op_sw           , '1'              ,
               p_new_currency_cd                , p_new_currency_rt , SYSDATE          ,
               p_new_user_id                    , 'N'               , v_claims_coop_sw ,
               v_claims_control_sw              , p_new_dist_spct1  );  
END;

    PROCEDURE PROCESS_DISTFRPS_GIUTS021(p_policy_id         IN     GIPI_POLBASIC_POL_DIST_V1.policy_id%TYPE,
                                       p_dist_no           IN     GIUW_POL_DIST.dist_no%TYPE,
                                       p_line_cd           IN     GIPI_POLBASIC_POL_DIST_V1.line_cd%TYPE,
                                       p_subline_cd        IN     GIPI_POLBASIC_POL_DIST_V1.subline_cd%TYPE,
                                       p_var_v_neg_distno  IN     GIUW_POL_DIST.dist_no%TYPE)
    IS
      v_exist                       VARCHAR2(1)  := 'N';
      v_old_dist_no                 giuw_pol_dist.dist_no%TYPE;
      v_old_tsi_amt                 giuw_policyds.tsi_amt%TYPE;
      v_old_prem_amt                giuw_policyds.prem_amt%TYPE;
      v_old_dist_tsi                giuw_policyds_dtl.dist_tsi%TYPE;
      v_old_dist_prem               giuw_policyds_dtl.dist_prem%TYPE;
      v_old_dist_spct               giuw_policyds_dtl.dist_spct%TYPE;
      v_old_line_cd                 giuw_policyds_dtl.line_cd%TYPE;
      v_old_currency_cd             gipi_invoice.currency_cd%TYPE;
      v_old_currency_rt             gipi_invoice.currency_rt%TYPE;
      v_old_user_id                 giuw_pol_dist.user_id%TYPE;
      v_new_tsi_amt                 giuw_wpolicyds.tsi_amt%TYPE;
      v_new_prem_amt                giuw_wpolicyds.prem_amt%TYPE;
      v_new_dist_tsi                giuw_wpolicyds_dtl.dist_tsi%TYPE;
      v_new_dist_prem               giuw_wpolicyds_dtl.dist_prem%TYPE;
      v_new_dist_spct               giuw_wpolicyds_dtl.dist_spct%TYPE;
      v_new_currency_cd             gipi_invoice.currency_cd%TYPE;
      v_new_currency_rt             gipi_invoice.currency_rt%TYPE;
      v_new_user_id                 giuw_pol_dist.user_id%TYPE;
      
      v_rg_seq_no                giuw_wpolicyds.dist_seq_no%TYPE;
      v_errors                NUMBER;
      v_count                NUMBER;
      v_frps_exist                BOOLEAN;
      
      /** Variables to be used for the record group **/
      TYPE rg_current_groups_type   IS RECORD (
        column_seq_no               GIUW_WPERILDS_DTL.dist_seq_no%TYPE,
        dist_tsi                    GIUW_WPERILDS_DTL.dist_tsi%TYPE,
        dist_prem                   GIUW_WPERILDS_DTL.dist_prem%TYPE,
        dist_spct                   GIUW_WPERILDS_DTL.dist_spct%TYPE,
        tsi_amt                     GIUW_WPERILDS.tsi_amt%TYPE,
        prem_amt                    GIUW_WPERILDS.prem_amt%TYPE,
        user_id                     GIUW_POL_DIST.user_id%TYPE,
        currency_cd                 GIPI_INVOICE.currency_cd%TYPE,
        currency_rt                 GIPI_INVOICE.currency_rt%TYPE
      );
      
      TYPE  rg_current_groups_tab IS TABLE OF rg_current_groups_type;
          
      v_rg_current_groups           rg_current_groups_tab;
          
      v_rg_index                    INTEGER;

      /* Process the remaining records from the
      ** dynamically created record group. */
      PROCEDURE PROCESS_REMAINING_RECORDS IS
      BEGIN
        v_count := v_rg_current_groups.COUNT;
		v_rg_index := v_count; 
        IF v_count > 0 THEN
           FOR c1 IN 1..v_rg_current_groups.COUNT 
           LOOP
             v_rg_seq_no           := v_rg_current_groups(c1).column_seq_no; --edited by steven 08.12.2014
             v_new_tsi_amt         := v_rg_current_groups(c1).tsi_amt;
             v_new_prem_amt        := v_rg_current_groups(c1).prem_amt;
             v_new_dist_tsi        := v_rg_current_groups(c1).dist_tsi;
             v_new_dist_prem       := v_rg_current_groups(c1).dist_prem;
             v_new_dist_spct       := v_rg_current_groups(c1).dist_spct;
             v_new_currency_cd     := v_rg_current_groups(c1).currency_cd;
             v_new_currency_rt     := v_rg_current_groups(c1).currency_rt;
             v_new_user_id         := v_rg_current_groups(c1).user_id;
             v_frps_exist          := CHECK_FOR_EXISTING_FRPS(p_dist_no, v_rg_seq_no);
             IF NOT v_frps_exist THEN

                /* Create a new record in table GIRI_WDISTFRPS in
                ** accordance with the values taken in by table
                ** GIUW_WPOLICYDS_DTL. */
                GIRI_WDISTFRPS_PKG.CREATE_NEW_WDISTFRPS_GIUWS013(p_dist_no, v_rg_seq_no       , v_new_tsi_amt     , v_new_prem_amt  , 
                                         v_new_dist_tsi    , v_new_dist_prem   , v_new_dist_spct ,
                                         v_new_currency_cd , v_new_currency_rt , v_new_user_id,
                                         p_line_cd         , p_subline_cd      , p_policy_id);

             ELSE

                /* Update the amounts of the existing record
                ** in table GIRI_WDISTFRPS. */
                GIRI_WDISTFRPS_PKG.UPDATE_WDISTFRPS_GIUWS013(p_dist_no , v_rg_seq_no       , v_new_tsi_amt     , v_new_prem_amt  ,
                                     v_new_dist_tsi    , v_new_dist_prem   , v_new_dist_spct , 
                                     v_new_currency_cd , v_new_currency_rt , v_new_user_id);

             END IF;
           END LOOP;
        END IF;
      END;

    BEGIN
      -- initialize record group tab
      v_rg_current_groups := rg_current_groups_tab();

      /* Create a dynamic record group for the current 
      ** distribution record to temporarily maintain a 
      ** list of the DIST_SEQ_NOs with a facultative share
      ** in it.
      ** NOTE:  The V_ERRORS variable was created to contain the ORA error
      **        number which caused the population failure of a record group
      **        during a call made to the POPULATE_GROUP built-in.  The
      **        variable will return a zero value if no errors were encountered,
      **        and a 1403 if the query caused no records to be retrieved. */
      IF v_rg_current_groups.COUNT > 0 THEN
         v_rg_current_groups.TRIM(v_rg_current_groups.COUNT);
      END IF;
      FOR c1 IN (SELECT C1407.dist_seq_no , C1407.dist_tsi, C1407.line_cd,
                        C1407.dist_prem, C1407.dist_spct, C1306.tsi_amt,
                        C1306.prem_amt, C080.user_id, B140.currency_cd,
                        B140.currency_rt
                   FROM giuw_wpolicyds_dtl C1407, giuw_wpolicyds C1306, giuw_pol_dist C080,
                        gipi_invoice B140
                  WHERE B140.item_grp     = C1306.item_grp
                    AND B140.policy_id    = C080.policy_id
                    AND C080.dist_no      = C1306.dist_no
                    AND C1306.dist_seq_no = C1407.dist_seq_no
                    AND C1306.dist_no     = C1407.dist_no
                    AND C1407.share_cd    = 999
                    AND C1407.dist_no     = p_dist_no
                    ORDER BY C1407.dist_seq_no)
      LOOP
         v_rg_current_groups.EXTEND(1);
         v_rg_current_groups(v_rg_current_groups.COUNT).column_seq_no    := c1.dist_seq_no;
         v_rg_current_groups(v_rg_current_groups.COUNT).tsi_amt          := c1.tsi_amt;
         v_rg_current_groups(v_rg_current_groups.COUNT).prem_amt         := c1.prem_amt;
         v_rg_current_groups(v_rg_current_groups.COUNT).dist_tsi         := c1.dist_tsi;
         v_rg_current_groups(v_rg_current_groups.COUNT).dist_prem        := c1.dist_prem;
         v_rg_current_groups(v_rg_current_groups.COUNT).dist_spct        := c1.dist_spct;
         v_rg_current_groups(v_rg_current_groups.COUNT).currency_cd      := c1.currency_cd;
         v_rg_current_groups(v_rg_current_groups.COUNT).currency_rt      := c1.currency_rt;
         v_rg_current_groups(v_rg_current_groups.COUNT).user_id          := c1.user_id;
      END LOOP;
      
      v_count := v_rg_current_groups.COUNT;

      v_old_dist_no := p_var_v_neg_distno;
      v_exist       := 'Y';
      /* Scan each of the DIST_SEQ_NO belonging to the
      ** previously negated distribution record, to check
      ** for the existence of a facultative share in each
      ** group. */
      FOR c1 IN (  SELECT dist_seq_no
                     FROM giuw_policyds
                    WHERE dist_no = v_old_dist_no
                 ORDER BY dist_seq_no DESC)
      LOOP

        /* Get the LINE_CD of the current 
        ** DIST_SEQ_NO for the negated distribution
        ** record to access its detail table
        ** more efficiently via primary key. */
        FOR c2 IN (SELECT line_cd
                     FROM giuw_perilds
                    WHERE dist_seq_no = c1.dist_seq_no
                      AND dist_no     = v_old_dist_no)
        LOOP
          v_old_line_cd := c2.line_cd;
          EXIT;
        END LOOP;

        v_exist := 'N';

        /* Get the facultative DIST_TSI of the
        ** previously negated distribution record to 
        ** allow the possibility of comparing its
        ** value with the facultative DIST_TSI of
        ** its recreated distribution record. */
        FOR c3 IN (SELECT C1407.dist_tsi,
                          C1407.dist_prem,
                          C1407.dist_spct,
                          C1306.tsi_amt,
                          C1306.prem_amt,
                          C080.user_id,
                          B140.currency_cd,
                          B140.currency_rt
                     FROM giuw_policyds_dtl C1407,
                          giuw_policyds C1306,
                          giuw_pol_dist C080,
                          gipi_invoice B140 
                    WHERE B140.item_grp     = C1306.item_grp
                      AND B140.policy_id    = C080.dist_no
                      AND C080.dist_no      = C1306.dist_no
                      AND C1306.dist_seq_no = C1407.dist_seq_no
                      AND C1306.dist_no     = C1407.dist_no
                      AND C1407.share_cd    = '999'
                      AND C1407.line_cd     = v_old_line_cd
                      AND C1407.dist_seq_no = c1.dist_seq_no
                      AND C1407.dist_no     = v_old_dist_no)
        LOOP
          v_exist           := 'Y';
          v_old_tsi_amt     := c3.tsi_amt;
          v_old_prem_amt    := c3.prem_amt;
          v_old_dist_tsi    := c3.dist_tsi;
          v_old_dist_prem    := c3.dist_prem;
          v_old_dist_spct   := c3.dist_spct;
          v_old_currency_cd := c3.currency_cd;
          v_old_currency_rt := c3.currency_rt;
          v_old_user_id     := c3.user_id;
          EXIT;
        END LOOP;

        /* If a facultative share in the negated distribution record exists
        ** for the current DIST_SEQ_NO processed then the procedure below
        ** shall be executed. */
        IF v_exist = 'Y' THEN
           IF v_count > 0 THEN
              v_rg_seq_no      := v_rg_current_groups(v_count).column_seq_no;
              -- v_new_line_cd := GET_GROUP_CHAR_CELL  (rg_column_line_cd, v_count);
              WHILE v_rg_seq_no > c1.dist_seq_no
              LOOP
                v_new_tsi_amt     := v_rg_current_groups(v_count).tsi_amt;
                v_new_prem_amt    := v_rg_current_groups(v_count).prem_amt;
                v_new_dist_tsi    := v_rg_current_groups(v_count).dist_tsi;
                v_new_dist_prem   := v_rg_current_groups(v_count).dist_prem;
                v_new_dist_spct   := v_rg_current_groups(v_count).dist_spct;
                v_new_currency_cd := v_rg_current_groups(v_count).currency_cd;
                v_new_currency_rt := v_rg_current_groups(v_count).currency_rt;
                v_new_user_id     := v_rg_current_groups(v_count).user_id;
                v_count           := v_count - 1;
                v_rg_current_groups.delete(v_count);
                v_frps_exist          := CHECK_FOR_EXISTING_FRPS(p_dist_no, v_rg_seq_no);
                IF NOT v_frps_exist THEN

                   -- GENERATE_FRPS_SEQ_NO;

                   /* Create a new record in table GIRI_WDISTFRPS in
                   ** accordance with the values taken in by table
                   ** GIUW_WPOLICYDS_DTL. */
                   GIRI_WDISTFRPS_PKG.CREATE_NEW_WDISTFRPS_GIUWS013(p_dist_no , v_rg_seq_no       , v_new_tsi_amt     , v_new_prem_amt  , 
                                            v_new_dist_tsi    , v_new_dist_prem   , v_new_dist_spct ,
                                            v_new_currency_cd , v_new_currency_rt , v_new_user_id   ,
                                            p_line_cd         , p_subline_cd      , p_policy_id);

                ELSE

                   /* Update the amounts of the existing record
                   ** in table GIRI_WDISTFRPS. */
                   GIRI_WDISTFRPS_PKG.UPDATE_WDISTFRPS_GIUWS013(p_dist_no , v_rg_seq_no       , v_new_tsi_amt     , v_new_prem_amt  ,
                                     v_new_dist_tsi    , v_new_dist_prem   , v_new_dist_spct , 
                                     v_new_currency_cd , v_new_currency_rt , v_new_user_id);

                END IF;
                IF v_count = 0 THEN
                   EXIT;
                END IF;            
                v_rg_seq_no      := v_rg_current_groups(v_count).column_seq_no;

              END LOOP;
              IF v_rg_seq_no < c1.dist_seq_no THEN

                 /* Updates table GIRI_BINDER of the negated
                 ** distribution record signifying that the
                 ** binder released has been reversed. */
                 GIRI_BINDER_PKG.UPDATE_REVERSE_DATE_GIUTS021(v_old_dist_no, c1.dist_seq_no);

              ELSIF v_rg_seq_no = c1.dist_seq_no THEN
                 v_new_tsi_amt     := v_rg_current_groups(v_count).tsi_amt;
                 v_new_prem_amt    := v_rg_current_groups(v_count).prem_amt;
                 v_new_dist_tsi    := v_rg_current_groups(v_count).dist_tsi;
                 v_new_dist_prem   := v_rg_current_groups(v_count).dist_prem;
                 v_new_dist_spct   := v_rg_current_groups(v_count).dist_spct;
                 v_new_currency_cd := v_rg_current_groups(v_count).currency_cd;
                 v_new_currency_rt := v_rg_current_groups(v_count).currency_rt;
                 v_new_user_id     := v_rg_current_groups(v_count).user_id;
                 v_count           := v_count - 1;
                 v_rg_current_groups.DELETE(v_count);
                 IF v_new_tsi_amt     <> v_old_tsi_amt     OR
                    v_new_prem_amt    <> v_old_prem_amt    OR
                    v_new_dist_tsi    <> v_old_dist_tsi    OR
                    v_new_dist_prem   <> v_old_dist_prem   OR
                    v_new_dist_spct   <> v_old_dist_spct   OR
                    v_new_currency_cd <> v_old_currency_cd OR
                    v_new_currency_rt <> v_old_currency_rt OR
                    v_new_user_id     <> v_old_user_id     THEN

                    /* Updates table GIRI_BINDER of the negated
                    ** distribution record signifying that the
                    ** binder released has been reversed. */
                    GIRI_BINDER_PKG.UPDATE_REVERSE_DATE_GIUTS021(v_old_dist_no, c1.dist_seq_no);

                    v_frps_exist := CHECK_FOR_EXISTING_FRPS(p_dist_no, c1.dist_seq_no);
                    IF NOT v_frps_exist THEN

                       -- GENERATE_FRPS_SEQ_NO;

                       /* Create a new record in table GIRI_WDISTFRPS in
                       ** accordance with the values taken in by tables
                       ** GIUW_WPOLICYDS_DTL of the current distribution
                       ** record, and GIRI_DISTFRPS of the previously negated
                       ** distribution record. */
                       GIRI_WDISTFRPS_PKG.CREATE_WDISTFRPS_GIUWS013(p_dist_no, v_old_dist_no   , c1.dist_seq_no    , v_new_tsi_amt     ,
                                            v_new_prem_amt  , v_new_dist_tsi    , v_new_dist_prem   , 
                                            v_new_dist_spct , v_new_currency_cd , v_new_currency_rt ,
                                            v_new_user_id, p_line_cd);

                    ELSE

                       /* Update the amounts of the existing record
                       ** in table GIRI_WDISTFRPS. */
                       GIRI_WDISTFRPS_PKG.UPDATE_WDISTFRPS_GIUWS013(p_dist_no, v_rg_seq_no       , v_new_tsi_amt     , v_new_prem_amt  ,
                                            v_new_dist_tsi    , v_new_dist_prem   , v_new_dist_spct , 
                                            v_new_currency_cd , v_new_currency_rt , v_new_user_id);

                    END IF;
                 END IF;
              END IF;
           ELSE

              /* Updates table GIRI_BINDER of the negated
              ** distribution record signifying that the
              ** binder released has been reversed. */
              GIRI_BINDER_PKG.UPDATE_REVERSE_DATE_GIUTS021(v_old_dist_no, c1.dist_seq_no);

           END IF;
         END IF;
      END LOOP;

      /* Process the remaining records
      ** in the list. */
      PROCESS_REMAINING_RECORDS;

      v_rg_current_groups.TRIM(v_rg_current_groups.COUNT);

    EXCEPTION
      WHEN NO_DATA_FOUND THEN

        /* Process the remaining records
        ** in the list. */    
        PROCESS_REMAINING_RECORDS;

        v_rg_current_groups.TRIM(v_rg_current_groups.COUNT);
    END PROCESS_DISTFRPS_GIUTS021;
    
    /*
    **  Created by      : Emman
    **  Date Created    : 08.17.2011
    **  Reference By    : (GIUTS021 - Redistribution)
    **  Description     : The procedure PROCESS_RI
    */
    PROCEDURE PROCESS_RI_GIUTS021(p_dist_no          IN OUT GIUW_POL_DIST.dist_no%TYPE,
                         p_v_post_flag      IN     VARCHAR2,
                         p_var_v_neg_distno IN OUT GIUW_POL_DIST.dist_no%TYPE,
                         p_renew_flag       IN     GIPI_POLBASIC.renew_flag%TYPE,
                         p_ratio            IN OUT NUMBER)
    IS
       v_diff_tsi       giri_frps_ri.ri_tsi_amt%TYPE;
       v_diff_prem      giri_frps_ri.ri_prem_amt%TYPE;
       v_tsi            giri_frps_ri.ri_tsi_amt%TYPE;
       v_prem           giri_frps_ri.ri_prem_amt%TYPE;
       v_prem_tax       giri_frps_ri.prem_tax%TYPE;
       v_binder_id      giri_frps_ri.fnl_binder_id%TYPE;
       v_tax            giis_parameters.param_value_n%type;
    BEGIN
      v_tax := 0;
      BEGIN
        SELECT param_value_n
          INTO v_tax
          FROM giis_parameters
         WHERE param_name like 'RI PREMIUM TAX';
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            INSERT INTO giis_parameters
              (param_type, param_name, param_value_n)
            VALUES
              ('N', 'RI PREMIUM TAX', 0);
      END;

      
      FOR A1 IN
          ( SELECT d140.line_cd,     d140.frps_yy,        d140.frps_seq_no, 
                   d140.dist_seq_no, d140.tot_fac_prem,   d140.tot_fac_tsi,
                   d140.ri_flag,     d140.prem_amt,       d140.tsi_amt
              FROM giri_wdistfrps d140
             WHERE d140.dist_no = p_dist_no
           ) LOOP
           FOR A2 IN
               ( SELECT d060.line_cd, d060.frps_yy, d060.frps_seq_no
                   FROM giri_distfrps d060
                  WHERE d060.dist_no = p_var_v_neg_distno
                    AND d060.dist_seq_no = a1.dist_seq_no
               ) LOOP
               FOR A3 IN
                   ( SELECT d050.ri_seq_no, d050.ri_cd, d050.ri_shr_pct, d050.ri_comm_rt
                            , d050.ri_shr_pct2, d050.ri_comm_amt, d050.ri_prem_vat, d050.ri_comm_vat, 
                            d050.address1, d050.address2, d050.address3, d050.prem_warr_days, d050.prem_warr_tag, d050.facoblig_sw  --added ri_shr_pct2, d050.ri_comm_amt, d050.ri_prem_vat, etc. edgar 09/24/2014
                       FROM giri_frps_ri d050 
                      WHERE d050.line_cd = a2.line_cd
                        AND d050.frps_yy = a2.frps_yy
                        AND d050.frps_seq_no = a2.frps_seq_no 
                        AND NVL(d050.reverse_sw, 'N') = 'N'
                   ) LOOP
                   --v_binder_id := v_binder_id + 1;
                          SELECT binder_id_s.nextval
                            INTO v_binder_id
                            FROM dual;
                          --
                   v_tsi   := round((a1.tsi_amt * a3.ri_shr_pct)/100,2);
                   v_prem  := round((a1.prem_amt * NVL(a3.ri_shr_pct2,a3.ri_shr_pct))/100,2);--added ri_shr_pct2 edgar 09/24/2014
                   v_prem_tax := round(((v_tax/100) * v_prem),2);
                   INSERT INTO giri_wfrps_ri
                               (line_cd,     frps_yy,       frps_seq_no,    ri_seq_no,
                                ri_cd,       pre_binder_id, ri_shr_pct,     ri_tsi_amt,
                                ri_prem_amt, reverse_sw,    prem_tax,       renew_sw,   ri_shr_pct2, ri_comm_amt, ri_comm_vat, address1, address2, address3, prem_warr_days, prem_warr_tag, facoblig_sw)--added ri_shr_pct2 edgar 09/24/2014
                        VALUES (a1.line_cd,  a1.frps_yy,    a1.frps_seq_no, a3.ri_seq_no,
                                a3.ri_cd,    v_binder_id,   a3.ri_shr_pct,  v_tsi,
                                v_prem,      'N',           v_prem_tax,     p_renew_flag,   a3.ri_shr_pct2, a3.ri_comm_amt, a3.ri_comm_vat, a3.address1, a3.address2, a3.address3, a3.prem_warr_days, a3.prem_warr_tag, a3.facoblig_sw);--added ri_shr_pct2 edgar 09/24/2014
               END LOOP;
           END LOOP;
           FOR A4 IN
               ( SELECT sum(d160.ri_prem_amt) prem, sum(d160.ri_tsi_amt) tsi
                   FROM giri_wfrps_ri d160
                  WHERE d160.line_cd = a1.line_cd
                    AND d160.frps_yy = a1.frps_yy
                    AND d160.frps_seq_no = a1.frps_seq_no
               ) LOOP
               v_diff_prem := nvl(a1.tot_fac_prem,0) - nvl(a4.prem,0);
               v_diff_tsi  := nvl(a1.tot_fac_tsi,0) - nvl(a4.tsi,0);
               --IF v_diff_prem <> 0 OR v_diff_tsi <> 0 THEN
               --   FOR A5 IN
               --       ( SELECT MAX(ri_cd) ri_cd
               --           FROM giri_wfrps_ri d160
               --          WHERE d160.line_cd = a1.line_cd
               --            AND d160.frps_yy = a1.frps_yy
               --            AND d160.frps_seq_no = a1.frps_seq_no  
               --       ) LOOP                  
               --       UPDATE giri_wfrps_ri
               --          SET ri_tsi_amt  = ri_tsi_amt + v_diff_tsi,
               --              ri_prem_amt = ri_prem_amt + v_diff_prem,
               --              prem_tax    = round((ri_prem_amt + v_diff_prem) * (v_tax/100),2) 
               --        WHERE line_cd = a1.line_cd
               --          AND frps_yy = a1.frps_yy
               --          AND frps_seq_no = a1.frps_seq_no     
               --          AND ri_cd  = a5.ri_cd;
               --       EXIT;
               --   END LOOP;
               --END IF; --commented out edgar 09/30/2014 replaced with codes below
               /*adde30edgar 09/30/2014*/
               IF v_diff_prem <> 0 THEN
                  FOR A5 IN
                      ( SELECT MAX(ri_cd) ri_cd
                          FROM giri_wfrps_ri d160
                         WHERE d160.line_cd = a1.line_cd
                           AND d160.frps_yy = a1.frps_yy
                           AND d160.frps_seq_no = a1.frps_seq_no  
                           AND ABS(d160.ri_prem_amt) >= ABS(v_diff_prem)
                      ) 
                  LOOP                  
                      UPDATE giri_wfrps_ri
                         SET ri_prem_amt = ri_prem_amt + v_diff_prem,
                             prem_tax    = round((ri_prem_amt + v_diff_prem) * (v_tax/100),2) 
                       WHERE line_cd = a1.line_cd
                         AND frps_yy = a1.frps_yy
                         AND frps_seq_no = a1.frps_seq_no     
                         AND ri_cd  = a5.ri_cd;
                      EXIT;
                  END LOOP;
               END IF;     
               
               IF v_diff_tsi <> 0 THEN
                  FOR A5 IN
                      ( SELECT MAX(ri_cd) ri_cd
                          FROM giri_wfrps_ri d160
                         WHERE d160.line_cd = a1.line_cd
                           AND d160.frps_yy = a1.frps_yy
                           AND d160.frps_seq_no = a1.frps_seq_no  
                           AND ABS(d160.ri_tsi_amt) >= ABS(v_diff_tsi)
                      ) 
                  LOOP                  
                      UPDATE giri_wfrps_ri
                         SET ri_tsi_amt  = ri_tsi_amt + v_diff_tsi
                       WHERE line_cd = a1.line_cd
                         AND frps_yy = a1.frps_yy
                         AND frps_seq_no = a1.frps_seq_no     
                         AND ri_cd  = a5.ri_cd;
                      EXIT;
                  END LOOP;
               END IF;                         
               /*ended edgar 09/30/2014*/
           END LOOP; 
           GIRI_WFRPS_PERIL_GRP_PKG.populate_wfrgroup(p_dist_no, a1.dist_seq_no, a1.line_cd, a1.frps_yy, a1.frps_seq_no);
           --IF a1.ri_flag = '3' THEN --commented out edgar 09/24/2014
           --   GIRI_WFRPERIL_PKG.create_wfrperil_r_giuts021(p_dist_no, a1.line_cd, a1.frps_yy, a1.frps_seq_no);   --commented out edgar 09/24/2014
           --ELSE --commented out edgar 09/24/2014
              GIRI_WFRPERIL_PKG.create_wfrperil_M_giuts021(p_dist_no, p_v_post_flag, a1.line_cd, a1.frps_yy, a1.frps_seq_no, p_ratio, p_var_v_neg_distno);  --added p_ratio edgar 09/29/2014
           --END IF; --commented out edgar 09/24/2014
           GIRI_WFRPS_RI_PKG.update_ri_comm_giuts021( a1.line_cd, a1.frps_yy, a1.frps_seq_no);
           --GIRI_WFRPERIL_PKG.offset_ri(p_dist_no, a1.dist_seq_no, a1.line_cd, a1.frps_yy, a1.frps_seq_no);--commented out edgar 09/24/2014
           ADJUST_BINDER_PKG.OFFSET_ADJUSTMENT_PKG( a1.line_cd, a1.frps_yy, a1.frps_seq_no);--edgar 09/24/2014 new offset procedure
           POST_RI_PLACEMENT_GIUTS021(p_dist_no, a1.dist_seq_no, a1.line_cd, a1.frps_yy, a1.frps_seq_no);
    END LOOP;
              
    END PROCESS_RI_GIUTS021;
    
/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 24, 2011
**  Reference By : GIUWS015 - Batch Distribution
**  Description  : Determine if sequence has already an existing  
**                FRPS in GIRI_WDISTFRPS. 
*/

    FUNCTION CHECK_IF_FRPS_EXIST (p_dist_no     IN GIUW_WPOLICYDS.dist_no%TYPE,
                                  p_dist_seq_no IN GIUW_WPOLICYDS.dist_seq_no%TYPE) 
         RETURN VARCHAR2 IS
         
    BEGIN
        FOR FRPS_REC IN (SELECT 1 
                           FROM GIRI_WDISTFRPS
                          WHERE dist_no     = p_dist_no
                            AND dist_seq_no = p_dist_seq_no)
        LOOP
             RETURN ('Y');
        END LOOP;
        
        RETURN ('N');
    END;
    
/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 24, 2011
**  Reference By : GIUWS015 - Batch Distribution
**  Description  : Creates a new record  in table GIRI_WDISTFRPS in accordance with
**                the data taken in by the facultative share of a specific DIST_SEQ_NO
**                in table GIUW_WPOLICYDS_DTL.
*/

    PROCEDURE CREATE_WDISTFRPS_GIUWS015(p_dist_no       IN  GIUW_WPOLICYDS.dist_no%TYPE,
                                        p_policy_id     IN  GIUW_POL_DIST.policy_id%TYPE,
                                        p_user_id       IN  GIIS_USERS.user_id%TYPE) IS
            
                v_op_sw                     GIRI_WDISTFRPS.op_sw%TYPE := 'N';
                v_op_frps_yy                GIRI_WDISTFRPS.op_frps_yy%TYPE;
                v_op_frps_seq_no            GIRI_WDISTFRPS.op_frps_seq_no%TYPE;
                v_claims_control_sw         GIRI_WDISTFRPS.claims_control_sw%TYPE := 'N';
                v_claims_coop_sw            GIRI_WDISTFRPS.claims_coop_sw%TYPE := 'N';
                v_line_cd                   GIPI_POLBASIC.line_cd%TYPE;
                v_prem_warr_tag             GIPI_POLBASIC.prem_warr_tag%TYPE;
                v_frps_exist                VARCHAR2(1) := 'N';
                
                CURSOR POL_DTL IS    (SELECT C1407.dist_seq_no, C1407.dist_tsi, NVL(C1407.dist_prem,0) dist_prem,
                                             C1407.line_cd, NVL(C1407.dist_spct,0) dist_spct, 
                                             NVL(C1306.tsi_amt,0) tsi_amt, NVL(C1306.prem_amt,0) prem_amt,
                                             B140.currency_cd, NVL(B140.currency_rt,0) currency_rt,
                                             B140.policy_id
                                          FROM GIUW_WPOLICYDS C1306,
                                               GIUW_WPOLICYDS_DTL C1407,
                                               GIUW_POL_DIST C080,
                                               GIPI_INVOICE B140
                                          WHERE C1306.item_grp    = B140.item_grp
                                            AND C080.policy_id    = B140.policy_id
                                            AND C1306.dist_no     = C080.dist_no
                                            AND C1306.dist_no     = C1407.dist_no
                                            AND C1306.dist_seq_no = C1407.dist_seq_no
                                            AND C1407.dist_no     = p_dist_no
                                            AND C1407.share_cd    = 999);
                                          
    BEGIN
      /* Set the OP_SW of table GIRI_WDISTFRPS to 'Y', 
      ** if the subline_cd of the specified PAR is in 'MOP' or 'MRN'. */
      FOR POLID_REC IN (SELECT subline_cd, prem_warr_tag
                          FROM GIPI_POLBASIC
                         WHERE policy_id = p_policy_id)
        LOOP
        v_prem_warr_tag := NVL(POLID_REC.prem_warr_tag,'N');
          
          IF POLID_REC.subline_cd = 'MOP' THEN
                 v_op_sw := 'Y';
          END IF;
          IF POLID_REC.subline_cd = 'MRN' THEN
               v_op_sw := 'Y';
                
                /* For risk note policies, get the FRPS_YY and FRPS_SEQ_NO of the
                  ** open policy to which the risk note belongs to.  The value 
                  ** retrieved shall be used to populate the OP_FRPS_YY and OP_FRPS_SEQ_NO
                  ** of table GIRI_WDISTFRPS upon data insertion. */
             FOR c1 IN (SELECT a.frps_yy frps_yy, a.frps_seq_no frps_seq_no
                          FROM GIRI_WDISTFRPS a   , GIUW_POL_DIST c080,
                               GIPI_POLBASIC b250 , GIPI_OPEN_POLICY b
                         WHERE a.dist_no       = c080.dist_no
                           AND c080.policy_id  = b250.policy_id
                           AND b250.pol_seq_no = b.op_pol_seqno
                           AND b250.issue_yy   = b.op_issue_yy
                           AND b250.iss_cd     = b.op_iss_cd
                           AND b250.subline_cd = b.op_subline_cd
                           AND b250.line_cd    = b.line_cd
                            AND c080.dist_flag IN ('1', '2', '3')
                            AND b.policy_id     = p_policy_id)
              LOOP
                           v_op_frps_yy     := c1.frps_yy;
                           v_op_frps_seq_no := c1.frps_seq_no;
                           EXIT;
              END LOOP;
          END IF;
          EXIT;
      END LOOP;

      /* Check for an existing CLAIMS CONTROL clause from 
      ** table GIPI_POLWC to determine the appropriate value 
      ** of the CLAIMS_CONTROL_SW in table GIRI_WDISTFRPS. */
      FOR A IN (SELECT wc_cd
                  FROM GIPI_POLWC
                 WHERE UPPER(wc_title) LIKE '%CLAIMS CONTROL%'
                   AND policy_id = p_policy_id)
      LOOP
        v_claims_control_sw := 'Y';
        EXIT;
      END LOOP;

      /* Check for an existing CLAIMS COOP clause from table
      ** GIPI_POLWC to determine the appropriate value of the
      ** of the CLAIMS_COOP_SW in table GIRI_WDISTFRPS. */
      FOR A IN (SELECT wc_cd
                  FROM GIPI_POLWC
                 WHERE UPPER(wc_title) LIKE '%CLAIMS COOP%'
                   AND policy_id = p_policy_id)
      LOOP
        v_claims_coop_sw := 'Y';
        EXIT;
      END LOOP;

      /* Creates a record in table GIRI_WDISTFRPS for each passed DIST_NO */
      /* and for each read DIST_SEQ_NO in GIUW_WPOLICYDS_DTL.*/
      FOR POL_DTL_REC IN POL_DTL
      LOOP
          v_frps_exist := GIRI_WDISTFRPS_PKG.check_if_frps_exist(p_dist_no, POL_DTL_REC.dist_seq_no);
          
          IF (v_frps_exist = 'Y') THEN
              UPDATE GIRI_WDISTFRPS
                 SET tsi_amt      = POL_DTL_REC.tsi_amt,
                     prem_amt     = POL_DTL_REC.prem_amt,
                     tot_fac_spct = POL_DTL_REC.dist_spct,
                     tot_fac_prem = POL_DTL_REC.dist_prem,
                     tot_fac_tsi  = POL_DTL_REC.dist_tsi,
                     currency_cd  = POL_DTL_REC.currency_cd,
                     currency_rt  = POL_DTL_REC.currency_rt
               WHERE dist_no      = p_dist_no
                 AND dist_seq_no  = POL_DTL_REC.dist_seq_no;
          ELSE
              INSERT INTO  GIRI_WDISTFRPS
                          (frps_yy                          , line_cd                       , op_group_no              ,
                           op_frps_yy                       , op_frps_seq_no                , dist_no                  ,
                           dist_seq_no                      , tsi_amt                       , tot_fac_spct             ,
                           tot_fac_tsi                      , prem_amt                      , tot_fac_prem             ,
                           loc_voy_unit                     , op_sw                         , ri_flag                  ,
                           currency_cd                      , currency_rt                   , create_date              ,
                           user_id                          , prem_warr_sw                  , claims_coop_sw           ,
                             claims_control_sw)
                    VALUES (TO_NUMBER(TO_CHAR(SYSDATE,'YY')) , POL_DTL_REC.line_cd          , NULL                     ,
                           v_op_frps_yy                      , v_op_frps_seq_no             , p_dist_no                ,
                           POL_DTL_REC.dist_seq_no           , POL_DTL_REC.tsi_amt          , POL_DTL_REC.dist_spct    ,
                           POL_DTL_REC.dist_tsi              , POL_DTL_REC.prem_amt         , POL_DTL_REC.dist_prem    ,
                           NULL                              , v_op_sw                      , '1'                      ,
                           POL_DTL_REC.currency_cd           , POL_DTL_REC.currency_rt      , SYSDATE                  ,
                           p_user_id                         , v_prem_warr_tag              , v_claims_coop_sw         ,
                           v_claims_control_sw);  
        END IF;
      END LOOP;
    END;
        
END GIRI_WDISTFRPS_PKG;
/


