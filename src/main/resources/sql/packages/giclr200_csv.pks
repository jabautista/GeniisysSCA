CREATE OR REPLACE PACKAGE CPI.GICLR200_CSV AS
  TYPE giclr200_rec_type IS RECORD(catastrophic_cd	VARCHAR2(100),
                                   clm_cnt        	GICL_OS_PD_CLM_EXTR.CLM_CNT%TYPE,
                                   claim_no     	GICL_OS_PD_CLM_EXTR.CLAIM_NO%TYPE,
                        		   assured      	GICL_OS_PD_CLM_EXTR.ASSURED_NAME%TYPE,
                        		   loss_loc     	GICL_OS_PD_CLM_EXTR.LOSS_LOC%TYPE,
                        		   policy_no    	GICL_OS_PD_CLM_EXTR.POLICY_NO%TYPE,
                        		   tsi_amt			GICL_OS_PD_CLM_EXTR.TSI_AMT%TYPE,
                        		   loss_ctgry		GIIS_LOSS_CTGRY.LOSS_CAT_DES%TYPE,
                                   loss_date		GICL_OS_PD_CLM_EXTR.LOSS_DATE%TYPE,
								   os_loss			GICL_OS_PD_CLM_EXTR.OS_LOSS%TYPE,
								   os_exp			GICL_OS_PD_CLM_EXTR.OS_EXP%TYPE,
								   total_os			GICL_OS_PD_CLM_EXTR.OS_LOSS%TYPE,
                                   gross_loss       GICL_OS_PD_CLM_EXTR.GROSS_LOSS%TYPE,
								   pd_loss  		GICL_OS_PD_CLM_EXTR.PD_LOSS%TYPE,
								   pd_exp			GICL_OS_PD_CLM_EXTR.PD_EXP%TYPE,
								   total_pd			GICL_OS_PD_CLM_EXTR.PD_EXP%TYPE,
								   clm_status		GIIS_CLM_STAT.CLM_STAT_DESC%TYPE);
  TYPE giclr200_type IS TABLE OF giclr200_rec_type;

  TYPE giclr200a_rec_type IS RECORD(catastrophic_cd  VARCHAR2(100),
                                    treaty_name      GIIS_DIST_SHARE.TRTY_NAME%TYPE,
                                    paid             GICL_OS_PD_CLM_DS_EXTR.PD_EXP%TYPE,
                                    outstanding      GICL_OS_PD_CLM_DS_EXTR.OS_EXP%TYPE,
                                    total            GICL_OS_PD_CLM_DS_EXTR.OS_EXP%TYPE);
  TYPE giclr200a_type IS TABLE OF giclr200a_rec_type;

  TYPE giclr200b_rec_type IS RECORD(catastrophic_cd  VARCHAR2(100),
                                    treaty_name      GIIS_DIST_SHARE.TRTY_NAME%TYPE,
                                    paid             GICL_OS_PD_CLM_DS_EXTR.PD_EXP%TYPE,
                                    outstanding      GICL_OS_PD_CLM_DS_EXTR.OS_EXP%TYPE,
                                    total            GICL_OS_PD_CLM_DS_EXTR.OS_EXP%TYPE,
                                    ri_cd            GICL_OS_PD_CLM_RIDS_EXTR.RI_CD%TYPE,
                                    os               GICL_OS_PD_CLM_RIDS_EXTR.OS_EXP%TYPE,
                                    pd               GICL_OS_PD_CLM_RIDS_EXTR.PD_EXP%TYPE);
  TYPE giclr200b_type IS TABLE OF giclr200b_rec_type;

  FUNCTION CSV_GICLR200(p_session_id    VARCHAR2) RETURN giclr200_type PIPELINED;
  FUNCTION CSV_GICLR200A(p_session_id    VARCHAR2) RETURN giclr200a_type PIPELINED;
  FUNCTION CSV_GICLR200B(p_session_id    VARCHAR2, p_ri_cd VARCHAR2) RETURN giclr200b_type PIPELINED;
END;
/


