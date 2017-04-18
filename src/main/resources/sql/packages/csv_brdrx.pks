CREATE OR REPLACE PACKAGE CPI.CSV_BRDRX AS
/*
** Modified by   : MAC
** Date Modified : 05/16/2013
** Modifications : Included CSV of GICLR208A, GICLR208B, GICLR209A, GICLR209B in the latest version of CSV_BRDRX.
                   Functions are found in PCIC database.
*/
   -- 01. FUNCTION CSV_GICLR208A --
   TYPE giclr208a_rec_type IS RECORD (
      line_name          giis_line.line_name%TYPE,
      claim_no           gicl_res_brdrx_extr.claim_no%TYPE,
      policy_no          VARCHAR2 (60),
      clm_file_date      gicl_claims.clm_file_date%TYPE,
      eff_date           gicl_claims.pol_eff_date%TYPE,
      loss_date          gicl_res_brdrx_extr.loss_date%TYPE,
      assd_name          giis_assured.assd_name%TYPE,
      loss_cat_des       giis_loss_ctgry.loss_cat_des%TYPE,
      outstanding_loss   NUMBER (38, 2),
      net_ret            NUMBER (16, 2),
      facultative        NUMBER (16, 2),
      treaty             NUMBER (16, 2),
      xol_treaty         NUMBER (16, 2)
   );

   TYPE giclr208a_type IS TABLE OF giclr208a_rec_type;

   -- END 01 --

   -- 02. FUNCTION CSV_GICLR208B --
   TYPE giclr208b_rec_type IS RECORD (
      line_name          giis_line.line_name%TYPE,
      claim_no           gicl_res_brdrx_extr.claim_no%TYPE,
      policy_no          VARCHAR2 (60),
      clm_file_date      gicl_claims.clm_file_date%TYPE,
      eff_date           gicl_claims.pol_eff_date%TYPE,
      loss_date          gicl_res_brdrx_extr.loss_date%TYPE,
      assd_name          giis_assured.assd_name%TYPE,
      loss_cat_des       giis_loss_ctgry.loss_cat_des%TYPE,
      outstanding_loss   NUMBER (38, 2),
      net_ret            NUMBER (16, 2),
      facultative        NUMBER (16, 2),
      treaty             NUMBER (16, 2),
      xol_treaty         NUMBER (16, 2)
   );

   TYPE giclr208b_type IS TABLE OF giclr208b_rec_type;

   -- END 02 --

   -- 03. FUNCTION CSV_GICLR209A --
   TYPE giclr209a_rec_type IS RECORD (
      line_name          giis_line.line_name%TYPE,
      claim_no           gicl_res_brdrx_extr.claim_no%TYPE,
      policy_no          VARCHAR2 (60),
      clm_file_date      gicl_claims.clm_file_date%TYPE,
      eff_date           gicl_claims.pol_eff_date%TYPE,
      loss_date          gicl_res_brdrx_extr.loss_date%TYPE,
      assd_name          giis_assured.assd_name%TYPE,
      loss_cat_des       giis_loss_ctgry.loss_cat_des%TYPE,
      outstanding_loss   NUMBER (38, 2),
      net_ret            NUMBER (16, 2),
      facultative        NUMBER (16, 2),
      treaty             NUMBER (16, 2),
      xol_treaty         NUMBER (16, 2),
      date_paid          VARCHAR2 (500),
      reference_no       VARCHAR2 (1000),
      claim_status       VARCHAR2 (50)
   );

   TYPE giclr209a_type IS TABLE OF giclr209a_rec_type;

-- END 03 --

   -- 04. FUNCTION CSV_GICLR209B --
   TYPE giclr209b_rec_type IS RECORD (
      line_name          giis_line.line_name%TYPE,
      claim_no           gicl_res_brdrx_extr.claim_no%TYPE,
      policy_no          VARCHAR2 (60),
      clm_file_date      gicl_claims.clm_file_date%TYPE,
      eff_date           gicl_claims.pol_eff_date%TYPE,
      loss_date          gicl_res_brdrx_extr.loss_date%TYPE,
      assd_name          giis_assured.assd_name%TYPE,
      loss_cat_des       giis_loss_ctgry.loss_cat_des%TYPE,
      outstanding_loss   NUMBER (38, 2),
      net_ret            NUMBER (16, 2),
      facultative        NUMBER (16, 2),
      treaty             NUMBER (16, 2),
      xol_treaty         NUMBER (16, 2),
      tran_date          VARCHAR2 (500),
      check_no           VARCHAR2 (1000),
      clm_stat           VARCHAR2 (50)
   );

   TYPE giclr209b_type IS TABLE OF giclr209b_rec_type;

   -- END 04 --

 --A. FUNCTION CSV_GICLR205E--
  TYPE giclr205e_rec_type IS RECORD(buss_source_name      GIIS_INTM_TYPE.INTM_DESC%TYPE,
                    	  	 		source_name           GIIS_INTERMEDIARY.INTM_NAME%TYPE,
                    				iss_name          	  GIIS_ISSOURCE.ISS_NAME%TYPE,
                    				line_name          	  GIIS_LINE.LINE_NAME%TYPE,
                    				subline_name          GIIS_SUBLINE.SUBLINE_NAME%TYPE,
                    				loss_year             GICL_RES_BRDRX_EXTR.LOSS_YEAR%TYPE,
                    				claim_no         	  GICL_RES_BRDRX_EXTR.CLAIM_NO%TYPE,
                                    policy_no          	  VARCHAR2(60),
                                    assd_name          	  GIIS_ASSURED.ASSD_NAME%TYPE,
                                    incept_date        	  GICL_RES_BRDRX_EXTR.INCEPT_DATE%TYPE,
                                    expiry_date        	  GICL_RES_BRDRX_EXTR.EXPIRY_DATE%TYPE,
                                    loss_date          	  GICL_RES_BRDRX_EXTR.LOSS_DATE%TYPE,
                                    item_title        	  varchar2(200),--GICL_CLM_ITEM.ITEM_TITLE%TYPE, Modified by Marlo 01282010
                                    tsi_amt            	  GICL_RES_BRDRX_EXTR.TSI_AMT%TYPE,
                                    peril_name        	  GIIS_PERIL.PERIL_NAME%TYPE,
                                    loss_cat_des          giis_loss_ctgry.loss_cat_des%TYPE, --added by MAC 10/31/2013
                                    INTERMEDIARY      	  VARCHAR2(2000),
                                    outstanding_loss      NUMBER(38, 2),
									claim_id			  GICL_RES_BRDRX_EXTR.CLAIM_ID%TYPE, -- Added by Marlo 01282010
									item_no				  GICL_RES_BRDRX_EXTR.ITEM_NO%TYPE, -- Added by Marlo 01282010
									peril_cd			  GICL_RES_BRDRX_EXTR.PERIL_CD%TYPE, -- Added by Marlo 01282010
									grp_seq_no			  GICL_RES_BRDRX_DS_EXTR.GRP_SEQ_NO%TYPE, -- Added by Marlo 01282010
									line_cd				  GICL_RES_BRDRX_EXTR.LINE_CD%TYPE, -- Added by Marlo 01282010
									ds_loss				  NUMBER(38, 2)); -- Added by Marlo 01282010
  TYPE giclr205e_type IS TABLE OF giclr205e_rec_type;
 --END A--
  --b. FUNCTION CSV_GICLR205LE
  TYPE giclr205le_rec_type IS RECORD(buss_source_name     GIIS_INTM_TYPE.INTM_DESC%TYPE,
                     	   	  		 source_name          GIIS_INTERMEDIARY.INTM_NAME%TYPE,
                     				 iss_name          	  GIIS_ISSOURCE.ISS_NAME%TYPE,
                     				 line_name        	  GIIS_LINE.LINE_NAME%TYPE,
                     				 subline_name         GIIS_SUBLINE.SUBLINE_NAME%TYPE,
                     				 loss_year            GICL_RES_BRDRX_EXTR.LOSS_YEAR%TYPE,
                     				 claim_no         	  GICL_RES_BRDRX_EXTR.CLAIM_NO%TYPE,
                                     policy_no        	  VARCHAR2(60),
                                     assd_name        	  GIIS_ASSURED.ASSD_NAME%TYPE,
                                     incept_date      	  GICL_RES_BRDRX_EXTR.INCEPT_DATE%TYPE,
                                     expiry_date      	  GICL_RES_BRDRX_EXTR.EXPIRY_DATE%TYPE,
                                     loss_date        	  GICL_RES_BRDRX_EXTR.LOSS_DATE%TYPE,
                                     item_title        	  varchar2(200),--GICL_CLM_ITEM.ITEM_TITLE%TYPE, Modified by Marlo 01282010
                                     tsi_amt          	  GICL_RES_BRDRX_EXTR.TSI_AMT%TYPE,
                                     peril_name        	  GIIS_PERIL.PERIL_NAME%TYPE,
                                     loss_cat_des         giis_loss_ctgry.loss_cat_des%TYPE, --added by MAC 10/31/2013
                                     INTERMEDIARY      	  VARCHAR2(2000),
                                     outstanding_loss     NUMBER(38, 2),
									 outstanding_expense  NUMBER(38, 2),
									 claim_id			  GICL_RES_BRDRX_EXTR.CLAIM_ID%TYPE, -- Added by Marlo 01282010
									 item_no			  GICL_RES_BRDRX_EXTR.ITEM_NO%TYPE, -- Added by Marlo 01282010
									 peril_cd			  GICL_RES_BRDRX_EXTR.PERIL_CD%TYPE, -- Added by Marlo 01282010
									 grp_seq_no			  GICL_RES_BRDRX_DS_EXTR.GRP_SEQ_NO%TYPE, -- Added by Marlo 01282010
									 line_cd			  GICL_RES_BRDRX_EXTR.LINE_CD%TYPE, -- Added by Marlo 01282010
									 ds_loss			  NUMBER(38, 2), -- Added by Marlo 01282010
									 ds_expense			  NUMBER(38, 2));-- Added by Marlo 01282010
  TYPE giclr205le_type IS TABLE OF giclr205le_rec_type;
 --END B--
   --c. FUNCTION CSV_GICLR205L
  TYPE giclr205l_rec_type IS RECORD(buss_source_name     GIIS_INTM_TYPE.INTM_DESC%TYPE,
                     	  	 		source_name          GIIS_INTERMEDIARY.INTM_NAME%TYPE,
                     				iss_name          	 GIIS_ISSOURCE.ISS_NAME%TYPE,
                     				line_name        	 GIIS_LINE.LINE_NAME%TYPE,
                     				subline_name         GIIS_SUBLINE.SUBLINE_NAME%TYPE,
                     				loss_year            GICL_RES_BRDRX_EXTR.LOSS_YEAR%TYPE,
                     				claim_no         	 GICL_RES_BRDRX_EXTR.CLAIM_NO%TYPE,
                                    policy_no        	 VARCHAR2(60),
                                    assd_name        	 GIIS_ASSURED.ASSD_NAME%TYPE,
                                    incept_date      	 GICL_RES_BRDRX_EXTR.INCEPT_DATE%TYPE,
                                    expiry_date      	 GICL_RES_BRDRX_EXTR.EXPIRY_DATE%TYPE,
                                    loss_date        	 GICL_RES_BRDRX_EXTR.LOSS_DATE%TYPE,
                                    item_title        	 VARCHAR2(200), --GICL_CLM_ITEM.ITEM_TITLE%TYPE, Modified by Marlo 01282010
                                    tsi_amt          	 GICL_RES_BRDRX_EXTR.TSI_AMT%TYPE,
                                    peril_name        	 GIIS_PERIL.PERIL_NAME%TYPE,
                                    loss_cat_des         giis_loss_ctgry.loss_cat_des%TYPE, --added by MAC 10/31/2013
                                    INTERMEDIARY      	 VARCHAR2(2000),
                                    outstanding_loss     NUMBER(38, 2),
									claim_id			 GICL_RES_BRDRX_EXTR.CLAIM_ID%TYPE, -- Added by Marlo 01282010
									item_no				 GICL_RES_BRDRX_EXTR.ITEM_NO%TYPE, -- Added by Marlo 01282010
									peril_cd			 GICL_RES_BRDRX_EXTR.PERIL_CD%TYPE, -- Added by Marlo 01282010
									grp_seq_no			 GICL_RES_BRDRX_DS_EXTR.GRP_SEQ_NO%TYPE, -- Added by Marlo 01282010
									line_cd				 GICL_RES_BRDRX_EXTR.LINE_CD%TYPE, -- Added by Marlo 01282010
									ds_loss				 NUMBER(38, 2)); -- Added by Marlo 01282010
  TYPE giclr205l_type IS TABLE OF giclr205l_rec_type;
 --END C--
    --D. FUNCTION CSV_GICLR206L
  TYPE giclr206l_rec_type IS RECORD(buss_source_name     GIIS_INTM_TYPE.INTM_DESC%TYPE,
                     	  	 		source_name          GIIS_INTERMEDIARY.INTM_NAME%TYPE,
                     				iss_name          	 GIIS_ISSOURCE.ISS_NAME%TYPE,
                     				line_name        	 GIIS_LINE.LINE_NAME%TYPE,
                     				subline_name         GIIS_SUBLINE.SUBLINE_NAME%TYPE,
                     				loss_year            GICL_RES_BRDRX_EXTR.LOSS_YEAR%TYPE,
                     				claim_no         	 GICL_RES_BRDRX_EXTR.CLAIM_NO%TYPE,
                                    policy_no        	 VARCHAR2(60),
                                    assd_name        	 GIIS_ASSURED.ASSD_NAME%TYPE,
                                    incept_date      	 GICL_RES_BRDRX_EXTR.INCEPT_DATE%TYPE,
                                    expiry_date      	 GICL_RES_BRDRX_EXTR.EXPIRY_DATE%TYPE,
                                    loss_date        	 GICL_RES_BRDRX_EXTR.LOSS_DATE%TYPE,
                                    item_title        	 VARCHAR2(200), --GICL_CLM_ITEM.ITEM_TITLE%TYPE, Modified by Marlo 01292010
                                    tsi_amt          	 GICL_RES_BRDRX_EXTR.TSI_AMT%TYPE,
                                    peril_name        	 GIIS_PERIL.PERIL_NAME%TYPE,
                                    loss_cat_des         giis_loss_ctgry.loss_cat_des%TYPE, --added by MAC 10/31/2013
                                    INTERMEDIARY      	 VARCHAR2(2000),
          							voucher_no_check_no  VARCHAR2(2000),
                                    losses_paid     	 NUMBER(38, 2),
									claim_id			 GICL_RES_BRDRX_EXTR.CLAIM_ID%TYPE, -- Added by Marlo 01292010
									item_no				 GICL_RES_BRDRX_EXTR.ITEM_NO%TYPE, -- Added by Marlo 01292010
									peril_cd			 GICL_RES_BRDRX_EXTR.PERIL_CD%TYPE, -- Added by Marlo 01292010
									grp_seq_no			 GICL_RES_BRDRX_DS_EXTR.GRP_SEQ_NO%TYPE, -- Added by Marlo 01292010
									line_cd				 GICL_RES_BRDRX_EXTR.LINE_CD%TYPE, -- Added by Marlo 01292010
									ds_loss				 NUMBER(38, 2)); -- Added by Marlo 01292010
  TYPE giclr206l_type IS TABLE OF giclr206l_rec_type;
 --END D--
     --E. FUNCTION CSV_GICLR206E
  TYPE giclr206e_rec_type IS RECORD(buss_source_name     GIIS_INTM_TYPE.INTM_DESC%TYPE,
                     	  	 		source_name          GIIS_INTERMEDIARY.INTM_NAME%TYPE,
                     				iss_name          	 GIIS_ISSOURCE.ISS_NAME%TYPE,
                     				line_name        	 GIIS_LINE.LINE_NAME%TYPE,
                     				subline_name         GIIS_SUBLINE.SUBLINE_NAME%TYPE,
                     				loss_year            GICL_RES_BRDRX_EXTR.LOSS_YEAR%TYPE,
                     				claim_no         	 GICL_RES_BRDRX_EXTR.CLAIM_NO%TYPE,
                                    policy_no        	 VARCHAR2(60),
                                    assd_name        	 GIIS_ASSURED.ASSD_NAME%TYPE,
                                    incept_date      	 GICL_RES_BRDRX_EXTR.INCEPT_DATE%TYPE,
                                    expiry_date      	 GICL_RES_BRDRX_EXTR.EXPIRY_DATE%TYPE,
                                    loss_date        	 GICL_RES_BRDRX_EXTR.LOSS_DATE%TYPE,
                                    item_title        	 VARCHAR2(200), --GICL_CLM_ITEM.ITEM_TITLE%TYPE,
                                    tsi_amt          	 GICL_RES_BRDRX_EXTR.TSI_AMT%TYPE,
                                    peril_name        	 GIIS_PERIL.PERIL_NAME%TYPE,
                                    loss_cat_des         giis_loss_ctgry.loss_cat_des%TYPE, --added by MAC 10/31/2013
                                    INTERMEDIARY      	 VARCHAR2(2000),
          							voucher_no_check_no  VARCHAR(2000),
                                    losses_paid     	 NUMBER(38, 2),
									claim_id			 GICL_RES_BRDRX_EXTR.CLAIM_ID%TYPE, -- Added by Marlo 01292010
									item_no				 GICL_RES_BRDRX_EXTR.ITEM_NO%TYPE, -- Added by Marlo 01292010
									peril_cd			 GICL_RES_BRDRX_EXTR.PERIL_CD%TYPE, -- Added by Marlo 01292010
									grp_seq_no			 GICL_RES_BRDRX_DS_EXTR.GRP_SEQ_NO%TYPE, -- Added by Marlo 01292010
									line_cd				 GICL_RES_BRDRX_EXTR.LINE_CD%TYPE, -- Added by Marlo 01292010
									ds_loss				 NUMBER(38, 2)); -- Added by Marlo 01292010
  TYPE giclr206e_type IS TABLE OF giclr206e_rec_type;
 --END E--
 --F. FUNCTION CSV_GICLR206LE
  TYPE giclr206le_rec_type IS RECORD(buss_source_name     GIIS_INTM_TYPE.INTM_DESC%TYPE,
                     	   	  		 source_name          GIIS_INTERMEDIARY.INTM_NAME%TYPE,
                     				 iss_name          	  GIIS_ISSOURCE.ISS_NAME%TYPE,
                     				 line_name        	  GIIS_LINE.LINE_NAME%TYPE,
                     				 subline_name         GIIS_SUBLINE.SUBLINE_NAME%TYPE,
                     				 loss_year            GICL_RES_BRDRX_EXTR.LOSS_YEAR%TYPE,
                     				 claim_no         	  GICL_RES_BRDRX_EXTR.CLAIM_NO%TYPE,
                                     policy_no        	  VARCHAR2(60),
                                     assd_name        	  GIIS_ASSURED.ASSD_NAME%TYPE,
                                     incept_date      	  GICL_RES_BRDRX_EXTR.INCEPT_DATE%TYPE,
                                     expiry_date      	  GICL_RES_BRDRX_EXTR.EXPIRY_DATE%TYPE,
                                     loss_date        	  GICL_RES_BRDRX_EXTR.LOSS_DATE%TYPE,
                                     item_title        	  VARCHAR2(200), --GICL_CLM_ITEM.ITEM_TITLE%TYPE, Modified by Marlo 01292010
                                     tsi_amt          	  GICL_RES_BRDRX_EXTR.TSI_AMT%TYPE,
                                     peril_name        	  GIIS_PERIL.PERIL_NAME%TYPE,
                                     loss_cat_des         giis_loss_ctgry.loss_cat_des%TYPE, --added by MAC 10/31/2013
                                     INTERMEDIARY      	  VARCHAR2(2000),
                                     --separate voucher number of loss from expense by MAC 05/17/2013
          							 voucher_no_check_no_loss  VARCHAR2(4000),
                                     voucher_no_check_no_exp   VARCHAR2(4000),
                                     losses_paid     	  NUMBER(38, 2),
									 expenses_paid	   	  NUMBER(38, 2),
									 claim_id			  GICL_RES_BRDRX_EXTR.CLAIM_ID%TYPE, -- Added by Marlo 01282010
									 item_no			  GICL_RES_BRDRX_EXTR.ITEM_NO%TYPE, -- Added by Marlo 01282010
									 peril_cd			  GICL_RES_BRDRX_EXTR.PERIL_CD%TYPE, -- Added by Marlo 01282010
									 grp_seq_no			  GICL_RES_BRDRX_DS_EXTR.GRP_SEQ_NO%TYPE, -- Added by Marlo 01282010
									 line_cd			  GICL_RES_BRDRX_EXTR.LINE_CD%TYPE, -- Added by Marlo 01282010
									 ds_loss			  NUMBER(38, 2), -- Added by Marlo 01282010
									 ds_expense			  NUMBER(38, 2));-- Added by Marlo 01282010
  TYPE giclr206le_type IS TABLE OF giclr206le_rec_type;
 --END F--
 /* Added by Marlo
 ** 02082010
 ** For extraction of losses paid per policy and per enrollee*/
 --G. FUNCTION CSV_GICLR222L
  TYPE giclr222l_rec_type IS RECORD(claim_no         	 GICL_RES_BRDRX_EXTR.CLAIM_NO%TYPE,
                                    policy_no        	 VARCHAR2(60),
                                    assd_name        	 GIIS_ASSURED.ASSD_NAME%TYPE,
                                    incept_date      	 GICL_RES_BRDRX_EXTR.INCEPT_DATE%TYPE,
                                    expiry_date      	 GICL_RES_BRDRX_EXTR.EXPIRY_DATE%TYPE,
                                    term                 VARCHAR2(40),
                                    loss_date        	 GICL_RES_BRDRX_EXTR.LOSS_DATE%TYPE,
                                    item_title        	 VARCHAR2(200),
                                    tsi_amt          	 GICL_RES_BRDRX_EXTR.TSI_AMT%TYPE,
                                    peril_name        	 GIIS_PERIL.PERIL_NAME%TYPE,
                                    loss_cat_des         giis_loss_ctgry.loss_cat_des%TYPE, --added by MAC 10/31/2013
                                    INTERMEDIARY      	 VARCHAR2(2000),
          							voucher_no_check_no  VARCHAR2(2000),
                                    losses_paid     	 NUMBER(38, 2),
									claim_id			 GICL_RES_BRDRX_EXTR.CLAIM_ID%TYPE,
									item_no				 GICL_RES_BRDRX_EXTR.ITEM_NO%TYPE,
									peril_cd			 GICL_RES_BRDRX_EXTR.PERIL_CD%TYPE,
									grp_seq_no			 GICL_RES_BRDRX_DS_EXTR.GRP_SEQ_NO%TYPE,
									line_cd				 GICL_RES_BRDRX_EXTR.LINE_CD%TYPE,
									ds_loss				 NUMBER(38, 2));
  TYPE giclr222l_type IS TABLE OF giclr222l_rec_type;
 --END G--
 --H. FUNCTION CSV_GICLR222E
  TYPE giclr222e_rec_type IS RECORD(claim_no         	 GICL_RES_BRDRX_EXTR.CLAIM_NO%TYPE,
                                    policy_no        	 VARCHAR2(60),
                                    assd_name        	 GIIS_ASSURED.ASSD_NAME%TYPE,
                                    incept_date      	 GICL_RES_BRDRX_EXTR.INCEPT_DATE%TYPE,
                                    expiry_date      	 GICL_RES_BRDRX_EXTR.EXPIRY_DATE%TYPE,
                                    loss_date        	 GICL_RES_BRDRX_EXTR.LOSS_DATE%TYPE,
                                    item_title        	 VARCHAR2(200),
                                    tsi_amt          	 GICL_RES_BRDRX_EXTR.TSI_AMT%TYPE,
                                    peril_name        	 GIIS_PERIL.PERIL_NAME%TYPE,
                                    loss_cat_des         giis_loss_ctgry.loss_cat_des%TYPE, --added by MAC 10/31/2013
                                    INTERMEDIARY      	 VARCHAR2(2000),
          							voucher_no_check_no  VARCHAR2(2000),
                                    losses_paid     	 NUMBER(38, 2),
									claim_id			 GICL_RES_BRDRX_EXTR.CLAIM_ID%TYPE,
									item_no				 GICL_RES_BRDRX_EXTR.ITEM_NO%TYPE,
									peril_cd			 GICL_RES_BRDRX_EXTR.PERIL_CD%TYPE,
									grp_seq_no			 GICL_RES_BRDRX_DS_EXTR.GRP_SEQ_NO%TYPE,
									line_cd				 GICL_RES_BRDRX_EXTR.LINE_CD%TYPE,
									ds_loss				 NUMBER(38, 2));
  TYPE giclr222e_type IS TABLE OF giclr222e_rec_type;
 --END H--
 --I. FUNCTION CSV_GICLR222LE
  TYPE giclr222le_rec_type IS RECORD(claim_no         	  GICL_RES_BRDRX_EXTR.CLAIM_NO%TYPE,
                                     policy_no        	  VARCHAR2(60),
                                     assd_name        	  GIIS_ASSURED.ASSD_NAME%TYPE,
                                     incept_date      	  GICL_RES_BRDRX_EXTR.INCEPT_DATE%TYPE,
                                     expiry_date      	  GICL_RES_BRDRX_EXTR.EXPIRY_DATE%TYPE,
                                     loss_date        	  GICL_RES_BRDRX_EXTR.LOSS_DATE%TYPE,
                                     item_title        	  VARCHAR2(200),
                                     tsi_amt          	  GICL_RES_BRDRX_EXTR.TSI_AMT%TYPE,
                                     peril_name        	  GIIS_PERIL.PERIL_NAME%TYPE,
                                     loss_cat_des         giis_loss_ctgry.loss_cat_des%TYPE, --added by MAC 10/31/2013
                                     INTERMEDIARY      	  VARCHAR2(2000),
          							 --separate voucher number of loss from expense by MAC 05/17/2013
          							 voucher_no_check_no_loss  VARCHAR2(4000),
                                     voucher_no_check_no_exp   VARCHAR2(4000),
                                     losses_paid     	  NUMBER(38, 2),
									 expenses_paid	   	  NUMBER(38, 2),
									 claim_id			  GICL_RES_BRDRX_EXTR.CLAIM_ID%TYPE,
									 item_no			  GICL_RES_BRDRX_EXTR.ITEM_NO%TYPE,
									 peril_cd			  GICL_RES_BRDRX_EXTR.PERIL_CD%TYPE,
									 grp_seq_no			  GICL_RES_BRDRX_DS_EXTR.GRP_SEQ_NO%TYPE,
									 line_cd			  GICL_RES_BRDRX_EXTR.LINE_CD%TYPE,
									 ds_loss			  NUMBER(38, 2),
									 ds_expense			  NUMBER(38, 2));
  TYPE giclr222le_type IS TABLE OF giclr222le_rec_type;
 --END I--
 --J. FUNCTION CSV_GICLR221L
  TYPE giclr221l_rec_type IS RECORD(enrollee             GICL_RES_BRDRX_EXTR.ENROLLEE%TYPE,
                                    claim_no         	 GICL_RES_BRDRX_EXTR.CLAIM_NO%TYPE,
                                    policy_no        	 VARCHAR2(60),
                                    assd_name        	 GIIS_ASSURED.ASSD_NAME%TYPE,
                                    incept_date      	 GICL_RES_BRDRX_EXTR.INCEPT_DATE%TYPE,
                                    expiry_date      	 GICL_RES_BRDRX_EXTR.EXPIRY_DATE%TYPE,
                                    loss_date        	 GICL_RES_BRDRX_EXTR.LOSS_DATE%TYPE,
                                    item_title        	 VARCHAR2(200),
                                    tsi_amt          	 VARCHAR2(30),
                                    peril_name        	 GIIS_PERIL.PERIL_NAME%TYPE,
                                    loss_cat_des         giis_loss_ctgry.loss_cat_des%TYPE, --added by MAC 10/31/2013
                                    INTERMEDIARY      	 VARCHAR2(2000),
          							voucher_no_check_no  VARCHAR2(2000),
                                    losses_paid     	 VARCHAR2(30),
									claim_id			 GICL_RES_BRDRX_EXTR.CLAIM_ID%TYPE,
									item_no				 GICL_RES_BRDRX_EXTR.ITEM_NO%TYPE,
									peril_cd			 GICL_RES_BRDRX_EXTR.PERIL_CD%TYPE,
									grp_seq_no			 GICL_RES_BRDRX_DS_EXTR.GRP_SEQ_NO%TYPE,
									line_cd				 GICL_RES_BRDRX_EXTR.LINE_CD%TYPE,
									ds_loss				 NUMBER(38, 2),
                                    term_of_policy       VARCHAR2(30));
  TYPE giclr221l_type IS TABLE OF giclr221l_rec_type;
 --END J--
 --K. FUNCTION CSV_GICLR221E
  TYPE giclr221e_rec_type IS RECORD(enrollee             GICL_RES_BRDRX_EXTR.ENROLLEE%TYPE,
                                    claim_no         	 GICL_RES_BRDRX_EXTR.CLAIM_NO%TYPE,
                                    policy_no        	 VARCHAR2(60),
                                    assd_name        	 GIIS_ASSURED.ASSD_NAME%TYPE,
                                    incept_date      	 GICL_RES_BRDRX_EXTR.INCEPT_DATE%TYPE,
                                    expiry_date      	 GICL_RES_BRDRX_EXTR.EXPIRY_DATE%TYPE,
                                    loss_date        	 GICL_RES_BRDRX_EXTR.LOSS_DATE%TYPE,
                                    item_title        	 VARCHAR2(200),
                                    tsi_amt          	 GICL_RES_BRDRX_EXTR.TSI_AMT%TYPE,
                                    peril_name        	 GIIS_PERIL.PERIL_NAME%TYPE,
                                    loss_cat_des         giis_loss_ctgry.loss_cat_des%TYPE, --added by MAC 10/31/2013
                                    INTERMEDIARY      	 VARCHAR2(2000),
          							voucher_no_check_no  VARCHAR2(2000),
                                    losses_paid     	 NUMBER(38, 2),
									claim_id			 GICL_RES_BRDRX_EXTR.CLAIM_ID%TYPE,
									item_no				 GICL_RES_BRDRX_EXTR.ITEM_NO%TYPE,
									peril_cd			 GICL_RES_BRDRX_EXTR.PERIL_CD%TYPE,
									grp_seq_no			 GICL_RES_BRDRX_DS_EXTR.GRP_SEQ_NO%TYPE,
									line_cd				 GICL_RES_BRDRX_EXTR.LINE_CD%TYPE,
									ds_loss				 NUMBER(38, 2),
                                    term_of_policy        VARCHAR2(30));
  TYPE giclr221e_type IS TABLE OF giclr221e_rec_type;
 --END K--
 --L. FUNCTION CSV_GICLR221LE
  TYPE giclr221le_rec_type IS RECORD(enrollee             GICL_RES_BRDRX_EXTR.ENROLLEE%TYPE,
                                     claim_no         	  GICL_RES_BRDRX_EXTR.CLAIM_NO%TYPE,
                                     policy_no        	  VARCHAR2(60),
                                     assd_name        	  GIIS_ASSURED.ASSD_NAME%TYPE,
                                     incept_date      	  GICL_RES_BRDRX_EXTR.INCEPT_DATE%TYPE,
                                     expiry_date      	  GICL_RES_BRDRX_EXTR.EXPIRY_DATE%TYPE,
                                     term                 VARCHAR2(40),
                                     loss_date        	  GICL_RES_BRDRX_EXTR.LOSS_DATE%TYPE,
                                     item_title        	  VARCHAR2(200),
                                     tsi_amt          	  GICL_RES_BRDRX_EXTR.TSI_AMT%TYPE,
                                     peril_name        	  GIIS_PERIL.PERIL_NAME%TYPE,
                                     loss_cat_des         giis_loss_ctgry.loss_cat_des%TYPE, --added by MAC 10/31/2013
                                     INTERMEDIARY      	  VARCHAR2(2000),
          							 --separate voucher number of loss from expense by MAC 05/17/2013
          							 voucher_no_check_no_loss  VARCHAR2(4000),
                                     voucher_no_check_no_exp   VARCHAR2(4000),
                                     voucher_no_check_no_le    VARCHAR2(4000),
                                     losses_paid     	  NUMBER(38, 2),
									 expenses_paid	   	  NUMBER(38, 2),
									 claim_id			  GICL_RES_BRDRX_EXTR.CLAIM_ID%TYPE,
									 item_no			  GICL_RES_BRDRX_EXTR.ITEM_NO%TYPE,
									 peril_cd			  GICL_RES_BRDRX_EXTR.PERIL_CD%TYPE,
									 grp_seq_no			  GICL_RES_BRDRX_DS_EXTR.GRP_SEQ_NO%TYPE,
									 line_cd			  GICL_RES_BRDRX_EXTR.LINE_CD%TYPE,
									 ds_loss			  NUMBER(38, 2),
									 ds_expense			  NUMBER(38, 2));
  TYPE giclr221le_type IS TABLE OF giclr221le_rec_type;
 --END L--
  
  FUNCTION csv_giclr208a (
      p_session_id   VARCHAR2,
      p_claim_id     VARCHAR2,
      p_intm_break   NUMBER,
      p_iss_break    NUMBER
   )
      RETURN giclr208a_type PIPELINED;

   FUNCTION csv_giclr208b (
      p_session_id   VARCHAR2,
      p_claim_id     VARCHAR2,
      p_intm_break   NUMBER,
      p_iss_break    NUMBER
   )
      RETURN giclr208b_type PIPELINED;

   FUNCTION csv_giclr209a (
      p_session_id   VARCHAR2,
      p_claim_id     VARCHAR2,
      p_intm_break   NUMBER,
      p_iss_break    NUMBER
   )
      RETURN giclr209a_type PIPELINED;

   FUNCTION csv_giclr209b (
      p_session_id   VARCHAR2,
      p_claim_id     VARCHAR2,
      p_intm_break   NUMBER,
      p_iss_break    NUMBER
   )
      RETURN giclr209b_type PIPELINED;

  FUNCTION CSV_GICLR205E(p_session_id    VARCHAR2,
                         p_claim_id      VARCHAR2,
                         p_intm_break    NUMBER) RETURN giclr205e_type PIPELINED;
  FUNCTION CSV_GICLR205LE(p_session_id   VARCHAR2,
                          p_claim_id     VARCHAR2,
                          p_intm_break   NUMBER) RETURN giclr205le_type PIPELINED;
  FUNCTION CSV_GICLR205L(p_session_id   VARCHAR2,
                         p_claim_id     VARCHAR2,
                         p_intm_break   NUMBER) RETURN giclr205l_type PIPELINED;
  FUNCTION CSV_GICLR206L(p_session_id   VARCHAR2,
                         p_claim_id     VARCHAR2,
                         p_intm_break   NUMBER,
                         p_paid_date    VARCHAR2,
                         p_from_date    VARCHAR2,
                         p_to_date      VARCHAR2) RETURN giclr206l_type PIPELINED;
  FUNCTION CSV_GICLR206E(p_session_id   VARCHAR2,
                         p_claim_id     VARCHAR2,
                         p_intm_break   NUMBER,
                         p_paid_date    VARCHAR2,
                         p_from_date    VARCHAR2,
                         p_to_date      VARCHAR2) RETURN giclr206e_type PIPELINED;
  FUNCTION CSV_GICLR206LE(p_session_id   VARCHAR2,
                          p_claim_id     VARCHAR2,
                          p_intm_break   NUMBER,
                          p_paid_date    VARCHAR2,
                          p_from_date    VARCHAR2,
                          p_to_date      VARCHAR2) RETURN giclr206le_type PIPELINED;
  /* Added by Marlo
  ** 02082010
  ** For the extraction of losses paid per policy and per enrollee.*/
  FUNCTION CSV_GICLR222L(p_session_id   VARCHAR2,
                         p_claim_id     VARCHAR2,
                         p_paid_date    VARCHAR2,
                         p_from_date    VARCHAR2,
                         p_to_date      VARCHAR2) RETURN giclr222l_type PIPELINED;
  FUNCTION CSV_GICLR222E(p_session_id   VARCHAR2,
                         p_claim_id     VARCHAR2,
                         p_paid_date    VARCHAR2,
                         p_from_date    VARCHAR2,
                         p_to_date      VARCHAR2) RETURN giclr222e_type PIPELINED;
  FUNCTION CSV_GICLR222LE(p_session_id   VARCHAR2,
                          p_claim_id     VARCHAR2,
                          p_paid_date    VARCHAR2,
                          p_from_date    VARCHAR2,
                          p_to_date      VARCHAR2) RETURN giclr222le_type PIPELINED;
  FUNCTION CSV_GICLR221L(p_session_id   VARCHAR2,
                         p_claim_id     VARCHAR2,
                         p_paid_date    VARCHAR2,
                         p_from_date2    VARCHAR2,
                         p_to_date2      VARCHAR2) RETURN giclr221l_type PIPELINED;
  FUNCTION CSV_GICLR221E(p_session_id   VARCHAR2,
                         p_claim_id     VARCHAR2,
                         p_paid_date    VARCHAR2,
                         p_from_date2    VARCHAR2,
                         p_to_date2      VARCHAR2) RETURN giclr221e_type PIPELINED;
  FUNCTION CSV_GICLR221LE(p_session_id   VARCHAR2,
                          p_claim_id     VARCHAR2,
                          p_paid_date    VARCHAR2,
                          p_from_date    VARCHAR2,
                          p_to_date      VARCHAR2) RETURN giclr221le_type PIPELINED;
                          
  --created function that will display loss category by MAC 10/31/2013.
  FUNCTION get_loss_category (p_line_cd giis_loss_ctgry.line_cd%TYPE,
                              p_loss_cat_cd giis_loss_ctgry.loss_cat_cd%TYPE)
  RETURN VARCHAR2;
  
  --retrieve voucher and check number per transaction by MAC 03/28/2014
   FUNCTION get_voucher_check_no (
      p_claim_id           IN   gicl_clm_res_hist.claim_id%TYPE,
      p_item_no            IN   gicl_clm_res_hist.item_no%TYPE,
      p_peril_cd           IN   gicl_clm_res_hist.peril_cd%TYPE,
      p_grouped_item_no    IN   gicl_clm_res_hist.grouped_item_no%TYPE,
      p_dsp_from_date      IN   VARCHAR,    --DATE, --kenneth SR 20583 10142015
      p_dsp_to_date        IN   VARCHAR,    --DATE, --kenneth SR 20583 10142015
      p_paid_date_option   IN   gicl_res_brdrx_extr.pd_date_opt%TYPE,
      p_clm_res_hist_id    IN   gicl_clm_res_hist.clm_res_hist_id%TYPE,
      p_payee_type         IN   VARCHAR
   )
      RETURN VARCHAR2;
      
   --retrieve details of GICLR209 per transaction by MAC 03/28/2014
   FUNCTION get_giclr209_dtl (
      p_claim_id           IN   gicl_clm_res_hist.claim_id%TYPE,
      p_dsp_from_date      IN   DATE,
      p_dsp_to_date        IN   DATE,
      p_paid_date_option   IN   gicl_res_brdrx_extr.pd_date_opt%TYPE,
      p_clm_res_hist_id    IN   gicl_clm_res_hist.clm_res_hist_id%TYPE,
      p_payee_type         IN   VARCHAR,
      p_type               IN   VARCHAR
   )       
      RETURN VARCHAR2;
END;
/
