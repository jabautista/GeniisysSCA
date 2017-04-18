CREATE OR REPLACE PACKAGE CPI.CSV_LOSS_PROFILE AS
/* Modified by   : Edison 
** Date Modified : 08.15.2012
** Modifications : Changed PROCEDURE to FUNCTION
**                 Added TYPE rec_type IS RECORD to create a table using the records
**                 found in the function*/
TYPE giclr211_rec_type IS RECORD(rnge               VARCHAR2(100),
                                 claim_cnt          gicl_loss_profile.policy_count%TYPE,
                                 total_tsi_amt      gicl_loss_profile.total_tsi_amt%TYPE,
                                 gross_loss         gicl_loss_profile.net_retention%TYPE,
                                 net_ret            gicl_loss_profile.net_retention%TYPE,
                                 prop_trty          gicl_loss_profile.treaty%TYPE,
                                 nprop_trty         gicl_loss_profile.treaty%TYPE,
                                 facultative        gicl_loss_profile.facultative%TYPE);
TYPE giclr211_type IS TABLE OF giclr211_rec_type;

TYPE giclr215_rec_type IS RECORD(policy_no          VARCHAR2(100),
                                 total_tsi_amt      gicl_loss_profile.total_tsi_amt%TYPE,
                                 claim_no           VARCHAR2(100),
                                 assd_name          giis_assured.assd_name%TYPE,
                                 gross_loss         gicl_loss_profile.net_retention%TYPE,
                                 net_ret            gicl_loss_profile.net_retention%TYPE,
                                 prop_trty          gicl_loss_profile.treaty%TYPE,
                                 nprop_trty         gicl_loss_profile.treaty%TYPE,
                                 facultative        gicl_loss_profile.facultative%TYPE); 
TYPE giclr215_type IS TABLE OF giclr215_rec_type;
  FUNCTION CSV_GICLR211(p_line_cd           VARCHAR2,
                        p_user              VARCHAR2,
                        p_subline_cd        VARCHAR2) RETURN giclr211_type PIPELINED; --Edison 08.15.2012
                      --  p_file_name      VARCHAR2
  FUNCTION CSV_GICLR215(p_line_cd           VARCHAR2,
                        p_user              VARCHAR2,
                        p_loss_sw           VARCHAR2,
                        p_loss_date_from    DATE,
                        p_loss_date_to      DATE,
                        p_subline_cd        VARCHAR2) RETURN giclr215_type PIPELINED; --Edison 08.15.2012
                    --    p_file_name      VARCHAR2
END;
/


