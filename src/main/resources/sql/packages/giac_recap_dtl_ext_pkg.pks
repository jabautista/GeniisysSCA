CREATE OR REPLACE PACKAGE CPI.GIAC_RECAP_DTL_EXT_PKG
AS

    TYPE recap_variables_type IS RECORD(
        recap_from_date         VARCHAR2(20),
        recap_to_date           VARCHAR2(20)
    );
    TYPE recap_variables_tab IS TABLE OF recap_variables_type;

    TYPE recap_detail_type IS RECORD(
        row_title               VARCHAR2(50),
        direct_amt              NUMBER(16, 2),
        direct_auth             NUMBER(16, 2),
        direct_asean            NUMBER(16, 2),
        direct_oth              NUMBER(16, 2),
        direct_net              NUMBER(16, 2),
        inw_auth                NUMBER(16, 2),
        inw_asean               NUMBER(16, 2),
        inw_oth                 NUMBER(16, 2),
        ret_auth                NUMBER(16, 2),
        ret_asean               NUMBER(16, 2),
        ret_oth                 NUMBER(16, 2),
        net_written             NUMBER(16, 2)
    );
    TYPE recap_detail_tab IS TABLE OF recap_detail_type;
    
    FUNCTION get_recap_variables
      RETURN recap_variables_tab PIPELINED;

    FUNCTION get_recap_premium_details
      RETURN recap_detail_tab PIPELINED;

    FUNCTION get_recap_losspd_details
      RETURN recap_detail_tab PIPELINED;
      
    FUNCTION get_recap_comm_details
      RETURN recap_detail_tab PIPELINED;

    FUNCTION get_recap_tsi_details
      RETURN recap_detail_tab PIPELINED;
      
    FUNCTION get_recap_osloss_details
      RETURN recap_detail_tab PIPELINED;
      
    FUNCTION get_recap_premium_line_details(
        p_row_title             VARCHAR2
    )
      RETURN recap_detail_tab PIPELINED;
      
    FUNCTION get_recap_losspd_line_details(
        p_row_title             VARCHAR2
    )
      RETURN recap_detail_tab PIPELINED;
      
    FUNCTION get_recap_comm_line_details(
        p_row_title             VARCHAR2
    )
      RETURN recap_detail_tab PIPELINED;
      
    FUNCTION get_recap_tsi_line_details(
        p_row_title             VARCHAR2
    )
      RETURN recap_detail_tab PIPELINED;
      
    FUNCTION get_recap_osloss_line_details(
        p_row_title             VARCHAR2
    )
      RETURN recap_detail_tab PIPELINED;
      
    PROCEDURE keep_dates(
        p_from_date             VARCHAR2,
        p_to_date               VARCHAR2
    );
    
    FUNCTION check_data_fetched
      RETURN NUMBER;
      
END;
/


