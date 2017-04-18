CREATE OR REPLACE PACKAGE CPI.CSV_GICLR259 AS
/*Created by: Jen.20130218 
**This package will print GICLR259 - CLAIM LISTING PER PAYEE TO CSV
*/
TYPE giclr259_rec_type IS RECORD(payee_class    VARCHAR2(30),
                                 payee_name     VARCHAR2(1000),
                                 claim_no       varchar2(100),
                                 policy_no      varchar2(100),
                                 assured_name   gicl_claims.assured_name%TYPE,
                                 file_date      gicl_claims.clm_file_date%TYPE,
                                 loss_date      gicl_claims.dsp_loss_date%TYPE,
                                 --item           gicl_clm_item.item_title%TYPE,*replaced, see code below - Dexter 07/03/2013
                                 item           varchar2(100), --added by Dexter 07/03/2013
                                 --peril_name     giis_peril.peril_name%TYPE, *replaced, see code below - Dexter 06/27/2013
                                 peril_name     varchar2(30),
                                 advice_no      varchar2(100),
                                 hist_seq_no    gicl_clm_loss_exp.HIST_SEQ_NO%TYPE,
                                 paid_amt       gicl_clm_loss_exp.PAID_AMT%TYPE,
                                 --advice_amt     gicl_clm_loss_exp.NET_AMT%TYPE, --commented by Dexter 07/03/2013
                                 net_amt     gicl_clm_loss_exp.NET_AMT%TYPE, --added by Dexter 07/03/2013
                                 advice_amt     gicl_clm_loss_exp.ADVISE_AMT%TYPE, --added by Dexter 07/03/2013
                                 payee_type     gicl_clm_loss_exp.payee_type%TYPE); 
TYPE giclr259_type IS TABLE OF giclr259_rec_type;

  FUNCTION CSV_GICLR259_f (p_payee_no       NUMBER,
                             p_payee_class_cd NUMBER, 
                             p_from_date      DATE,
                             p_to_date        DATE,
                             p_as_of_date     DATE, 
                             p_from_ldate     DATE,
                             p_to_ldate       DATE,
                             p_as_of_ldate    DATE)
                             RETURN giclr259_type PIPELINED;
END;
/


