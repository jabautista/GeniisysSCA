CREATE OR REPLACE PACKAGE CPI.giac_tran_mm_pkg
AS
   TYPE giac_tran_mm_type IS RECORD (
      fund_cd      giac_tran_mm.fund_cd%TYPE,
      branch_cd    giac_tran_mm.branch_cd%TYPE,
      tran_mm      giac_tran_mm.tran_mm%TYPE,
      tran_yr      giac_tran_mm.tran_yr%TYPE,
      closed_tag   giac_tran_mm.closed_tag%TYPE,
      remarks      giac_tran_mm.remarks%TYPE
   );

   TYPE giac_tran_mm_tab IS TABLE OF giac_tran_mm_type;

   FUNCTION closed_transaction_month_year (
      p_fund_cd     giac_tran_mm.fund_cd%TYPE,
      p_branch_cd   giac_tran_mm.branch_cd%TYPE
   )
      RETURN giac_tran_mm_tab PIPELINED;
      
   TYPE booked_list_type IS RECORD
        (booking_year     GIIS_BOOKING_MONTH.booking_year%TYPE,
        booking_mth      GIIS_BOOKING_MONTH.booking_mth%TYPE,
        booking_mth_num  VARCHAR2(2));
  
    TYPE booked_list_tab IS TABLE OF booked_list_type;
    
     FUNCTION get_booking_date_list(p_claim_id   gicl_claims.claim_id%TYPE)
       RETURN booked_list_tab PIPELINED;
       
     FUNCTION check_booking_date (
        p_claim_id      gicl_claims.claim_id%TYPE,
        p_booking_year  giac_tran_mm.tran_yr%TYPE,
        p_booking_month VARCHAR2
    )
       RETURN VARCHAR2;
       
	TYPE gicls024_booking_date_type IS RECORD(
        booking_mth             GIIS_BOOKING_MONTH.booking_mth%TYPE,
        booking_year            GIIS_BOOKING_MONTH.booking_year%TYPE
    );
    TYPE gicls024_booking_date_tab IS TABLE OF gicls024_booking_date_type;
    
    FUNCTION gicls024_get_booking_date_lov(
        p_claim_id              GICL_CLAIMS.claim_id%TYPE
    )
    RETURN gicls024_booking_date_tab PIPELINED; 
    
    -- added by Kris 04.16.2013 for GIACS002
    FUNCTION get_closed_tag(
        p_fund_cd   IN  giac_tran_mm.fund_cd%TYPE,
        p_branch_cd IN  giac_tran_mm.branch_cd%TYPE,
        p_date      IN  giac_acctrans.tran_date%TYPE
    ) RETURN VARCHAR2;
END;
/


