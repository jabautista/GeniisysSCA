CREATE OR REPLACE PACKAGE CPI.GIACS158_PKG AS
   
    TYPE intm_type_type IS RECORD (
        intm_type   giis_intm_type.intm_type%TYPE,
        intm_desc   giis_intm_type.intm_desc%TYPE
    );
    
    TYPE intm_type_tab IS TABLE OF intm_type_type;
    
    TYPE intm_type IS RECORD (
        intm_no     giis_intermediary.intm_no%TYPE,
        intm_name   giis_intermediary.intm_name%TYPE
    );
    
    TYPE intm_tab IS TABLE OF intm_type;

    TYPE bank_files_type IS RECORD (
        bank_file_no     giac_bank_comm_payt_hdr_ext.bank_file_no%TYPE,
        bank_file_name   giac_bank_comm_payt_hdr_ext.bank_file_name%TYPE,
        extract_date     VARCHAR2(100),
        paid_sw          giac_bank_comm_payt_hdr_ext.paid_sw%TYPE
    );
    
    TYPE bank_files_tab IS TABLE OF bank_files_type; 

    TYPE records_type IS RECORD (
        view_sw             giac_bank_comm_payt_hdr_ext.paid_sw%TYPE,
        parent_intm_no      giac_bank_comm_payt_temp_ext.parent_intm_no%TYPE,   
        parent_intm_type    giac_bank_comm_payt_temp_ext.intm_type%TYPE,
        parent_intm_name    giis_intermediary.intm_name%TYPE,
        net_comm_due        giac_bank_comm_payt_temp_ext.commission_amt%TYPE
    );
    
    TYPE records_tab IS TABLE OF records_type;   
    
    TYPE details_type IS RECORD (
        bill_no             VARCHAR2(50),
        gross_premium       giac_paid_prem_comm_due_v.gross_premium%TYPE,
        premium_paid        giac_paid_prem_comm_due_v.premium_paid%TYPE,
        peril               giis_peril.peril_sname%TYPE,
        commission_rt       giac_paid_prem_comm_due_v.commission_rt%TYPE,
        commission_due      giac_paid_prem_comm_due_v.commission_due%TYPE,
        wholding_tax_due    giac_paid_prem_comm_due_v.wholding_tax_due%TYPE,
        input_vat_due       giac_paid_prem_comm_due_v.input_vat_due%TYPE,
        net_comm_due        giac_paid_prem_comm_due_v.net_comm_due%TYPE,
        policy_no           VARCHAR2 (50),
        assured             giis_assured.assd_name%TYPE,
        bank_ref_no         gipi_polbasic.bank_ref_no%TYPE,
        intm_no             giis_intermediary.intm_no%TYPE,
        intm_name           giis_intermediary.intm_name%TYPE,
        or_no               CLOB --VARCHAR2 (1000)	-- AFP SR-18481 : shan 05.21.2015
    );
    
    TYPE details_tab IS TABLE OF details_type;  
    
    TYPE file_type IS RECORD (
        text_to_write     VARCHAR2(1000)
    );
    
    TYPE file_tab IS TABLE OF file_type;
    
    FUNCTION get_intm_type_lov
        RETURN intm_type_tab PIPELINED;
        
    FUNCTION get_intm_lov(
        p_intm_type  giis_intermediary.intm_type%TYPE
    )
        RETURN intm_tab PIPELINED;

    FUNCTION get_bank_files
        RETURN bank_files_tab PIPELINED;   
    
    FUNCTION check_view_records(
        p_as_of_date    VARCHAR2,
        p_intm_type     giis_intermediary.intm_type%TYPE,
        p_intm          giis_intermediary.intm_no%TYPE
    )
        RETURN VARCHAR2;

    PROCEDURE invalidate_bank_file(
        p_as_of_date    VARCHAR2,
        p_intm_type     giis_intermediary.intm_type%TYPE,
        p_intm          giis_intermediary.intm_no%TYPE
    );
    
    PROCEDURE delete_temp_ext;        
    
    PROCEDURE insert_into_temp_table(
        p_as_of_date    VARCHAR2,
        p_intm_type     giis_intermediary.intm_type%TYPE,
        p_intm          giis_intermediary.intm_no%TYPE
    );

    FUNCTION get_records
        RETURN records_tab PIPELINED;  

    FUNCTION get_records_via_bank_file(
        p_bank_file_no  giac_bank_comm_payt_hdr_ext.bank_file_no%TYPE
    )
        RETURN records_tab PIPELINED;

    FUNCTION view_details_via_records(
        p_as_of_date        VARCHAR2,
        p_parent_intm_type  giac_paid_prem_comm_due_v.parent_intm_type%TYPE,
        p_parent_intm_no    giac_paid_prem_comm_due_v.parent_intm_no%TYPE
    )
        RETURN details_tab PIPELINED;

    FUNCTION view_details_via_bank_files(
        p_bank_file_no  giac_bank_comm_payt_hdr_ext.bank_file_no%TYPE,
        p_parent_intm_type  giac_paid_prem_comm_due_v.parent_intm_type%TYPE,
        p_parent_intm_no    giac_paid_prem_comm_due_v.parent_intm_no%TYPE
    )
        RETURN details_tab PIPELINED;

    FUNCTION get_max_bank_file_no
        RETURN NUMBER;        
    
    PROCEDURE set_bank_file_no(
        p_as_of_date    VARCHAR2,
        p_intm_type     giis_intermediary.intm_type%TYPE,
        p_intm          giis_intermediary.intm_no%TYPE,
        p_bank_file_no  giac_bank_comm_payt_hdr_ext.bank_file_no%TYPE
    );   
    
    PROCEDURE set_giac_bank_comm_payt(
        p_parent_intm_no    giac_paid_prem_comm_due_v.parent_intm_no%TYPE,
        p_bank_file_no      giac_bank_comm_payt_hdr_ext.bank_file_no%TYPE
    );
    
    PROCEDURE insert_into_summ_table(
        p_bank_file_no  giac_bank_comm_payt_hdr_ext.bank_file_no%TYPE
    );
    
    FUNCTION generate_file(
        p_bank_file_no  giac_bank_comm_payt_hdr_ext.bank_file_no%TYPE   
    )
        RETURN file_tab PIPELINED;
    
    PROCEDURE update_file_name(
        p_file_name     giac_bank_comm_payt_hdr_ext.bank_file_name%TYPE,
        p_bank_file_no  giac_bank_comm_payt_hdr_ext.bank_file_no%TYPE
    );
                              
END GIACS158_PKG;
/
