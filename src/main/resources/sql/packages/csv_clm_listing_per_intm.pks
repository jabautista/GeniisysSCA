CREATE OR REPLACE PACKAGE CPI.CSV_CLM_LISTING_PER_INTM AS
/* Created by   : Edison
** Date created : 09.21.2012
** Description  : It will be used for module GICLS266 - Claim Listing per Intermediary.
**                This is for CSV printing. */
TYPE giclr266_rec_type IS RECORD(intm_no        giis_intermediary.intm_no%TYPE,
                                 intm_name      giis_intermediary.intm_name%TYPE,
                                 claim_no       varchar(100),
                                 policy_no      varchar(100),
                                 assured_name   gicl_claims.assured_name%TYPE,
                                 loss_date      gicl_claims.loss_date%TYPE,
                                 clm_file_date  gicl_claims.clm_file_date%TYPE,
                                 entry_date     gicl_claims.entry_date%TYPE,
                                 claim_status   giis_clm_stat.clm_stat_desc%TYPE,
                                 item_no        gicl_clm_item.item_no%TYPE,
                                 item_title     gicl_clm_item.item_title%TYPE,
                                 peril_cd       gicl_intm_itmperil.peril_cd%TYPE,
                                 peril_name     giis_peril.peril_name%TYPE,
                                 share_pct      gicl_intm_itmperil.shr_intm_pct%TYPE,
                                 loss_reserve   gicl_clm_reserve.loss_reserve%TYPE,
                                 loss_paid      gicl_clm_reserve.losses_paid%TYPE,
                                 exp_reserve    gicl_clm_reserve.expense_reserve%TYPE,
                                 exp_paid       gicl_clm_reserve.expenses_paid%TYPE);
TYPE giclr266_type IS TABLE OF giclr266_rec_type;
  FUNCTION CSV_GICLR266(p_date_type   VARCHAR2,
                        p_as_of_date  DATE,
                        p_from_date   DATE,
                        p_to_date     DATE,
                        p_booking_tag VARCHAR2,
                        p_bk_mth      VARCHAR2,
                        p_bk_yr       NUMBER,
                        p_intm_no     NUMBER,
                        p_clm_status  VARCHAR2,
                        p_line_cd     VARCHAR2)RETURN giclr266_type PIPELINED;
END;
/

DROP PACKAGE CPI.CSV_CLM_LISTING_PER_INTM;
