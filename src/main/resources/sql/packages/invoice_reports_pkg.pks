CREATE OR REPLACE PACKAGE CPI.INVOICE_REPORTS_PKG AS

    TYPE girir009_rec_type IS RECORD (
        policy_id			GIPI_POLBASIC.policy_id%TYPE,
        acct_of_cd			GIPI_POLBASIC.acct_of_cd%TYPE,
        label_tag			GIPI_POLBASIC.label_tag%TYPE,
        assd_name			VARCHAR2(520),
        address1			GIPI_POLBASIC.address1%TYPE,
        address2			GIPI_POLBASIC.address2%TYPE,
        address3			GIPI_POLBASIC.address3%TYPE,
        assd_tin			GIIS_ASSURED.assd_tin%TYPE,
        invoice_no			VARCHAR2(30),
        date_issued			VARCHAR2(30),
        line_name			GIIS_LINE.line_name%TYPE,
        policy_no			VARCHAR2(50),
        endt_no				VARCHAR2(30),
        date_from			VARCHAR2(30),
        date_to				VARCHAR2(30),
        subline_subline_time	VARCHAR2(30),
        tsi_amt				GIPI_POLBASIC.tsi_amt%TYPE,
        short_name			VARCHAR2(3),
        prem_amt		    GIPI_POLBASIC.prem_amt%TYPE,
        currency_cd            GIPI_INVOICE.currency_cd%TYPE,
        policy_currency        GIPI_INVOICE.policy_currency%TYPE,
        currency_rt            GIPI_INVOICE.currency_rt%TYPE,
        bank_ref_no            GIPI_POLBASIC.bank_ref_no%TYPE,
        subline_name        GIIS_SUBLINE.subline_name%TYPE,
        intrmdry_intm_no    GIPI_COMM_INVOICE.intrmdry_intm_no%TYPE,
        currency_desc        VARCHAR2(20),
        class_name            VARCHAR2(55),
        assd_name2            VARCHAR2(510),
        ri_comm_amt            GIPI_INVOICE.ri_comm_amt%TYPE,
        ri_comm_vat            GIPI_INVOICE.ri_comm_vat%TYPE,
        ri_name                GIIS_REINSURER.ri_name%TYPE,
        total_amt_due       NUMBER(16, 2)
    );
    
    TYPE girir009_rec_tab IS TABLE OF girir009_rec_type;
    
    FUNCTION get_girir009_records (p_policy_id            GIPI_POLBASIC.policy_id%TYPE) 
      RETURN girir009_rec_tab PIPELINED;

END INVOICE_REPORTS_PKG;
/


