CREATE OR REPLACE PACKAGE CPI.CSV_UW_RI_REPORTS
AS

    TYPE get_girir036_type IS RECORD(
        ri_name                 GIIS_REINSURER.RI_NAME%TYPE,
        address                 VARCHAR2(200),
        line_name               GIIS_LINE.LINE_NAME%TYPE,
        binder_number           VARCHAR2(15),
        assd_name               GIIS_ASSURED.ASSD_NAME%TYPE,
        policy_endt_no          VARCHAR2(35)        
    );
    
    TYPE get_girir036_tab IS TABLE OF get_girir036_type;
    FUNCTION get_girir036(
        p_ri_cd         GIRI_BINDER.RI_CD%TYPE,
        p_line_cd       GIRI_BINDER.LINE_CD%TYPE,
        p_from_date     GIRI_BINDER.BINDER_DATE%TYPE,
        p_to_date       GIRI_BINDER.BINDER_DATE%TYPE
    ) RETURN get_girir036_tab PIPELINED;
-- Start: added by Carlo De Guzman 02.11.2016 SR-5339
   TYPE get_girir101_type_y IS RECORD (
      cedant             giis_reinsurer.ri_name%TYPE,
      original_assured   giis_assured.assd_name%TYPE,
      line               giis_line.line_name%TYPE,
      amount_offered     VARCHAR2 (20),
      our_acceptance     VARCHAR2 (20),
      term_of_cover_from VARCHAR2 (20), --incept_date
      term_of_cover_to   VARCHAR2 (20), --expiry_date
      date_accepted      VARCHAR2 (20),
      as_no              giri_winpolbas.accept_no%TYPE,
      no_of_days         NUMBER (6),
      remarks            VARCHAR (8)
   );

   TYPE get_girir101_tab_y IS TABLE OF get_girir101_type_y;

   FUNCTION csv_girir101 (
      p_ri_cd            giri_inpolbas.ri_cd%TYPE,
      p_line_cd          gipi_polbasic.line_cd%TYPE,
      p_oar_print_date   VARCHAR2,
      p_morethan         NUMBER,
      p_lessthan         NUMBER,
      p_date_sw          VARCHAR2
   )
      RETURN get_girir101_tab_y PIPELINED;
-- End: Carlo De Guzman SR-5339
END CSV_UW_RI_REPORTS;
/