CREATE OR REPLACE PACKAGE CPI.GIPIS213_PKG
AS

    TYPE parlist_type IS RECORD(
        par_id          GIPI_PARLIST.par_id%type,
        line_cd         GIPI_PARLIST.line_cd%type,
        iss_cd          GIPI_PARLIST.iss_cd%type,
        par_yy          GIPI_PARLIST.par_yy%type,
        par_seq_no      GIPI_PARLIST.par_seq_no%type,
        par_status      GIPI_PARLIST.par_status%type,
        par_number      VARCHAR2(100),
        assd_no         GIPI_PARLIST.assd_no%type,
        assd_name       GIIS_ASSURED.ASSD_NAME%type,
        address         VARCHAR2(200),
        incept_date     GIPI_POLBASIC.INCEPT_DATE%type,
        expiry_date     GIPI_POLBASIC.EXPIRY_DATE%type,
        cn_date_printed GIPI_POLBASIC.CN_DATE_PRINTED%type,
        cn_expiry_date  GIPI_POLBASIC.CN_DATE_PRINTED%type,
        prem_amt        GIPI_POLBASIC.PREM_AMT%type,
        policy_no       VARCHAR2(100),
        underwriter     GIPI_PARLIST.underwriter%type
    );
    
    TYPE parlist_tab IS TABLE OF parlist_type;
    
    FUNCTION get_parlist_listing(
        p_date_type         VARCHAR2,
        p_search_by         VARCHAR2,
        p_as_of_date        VARCHAR2,
        p_from_date         VARCHAR2,
        p_to_date           VARCHAR2
    ) RETURN parlist_tab PIPELINED;
    
END GIPIS213_PKG;
/


