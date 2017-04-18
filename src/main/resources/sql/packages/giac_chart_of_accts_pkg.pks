CREATE OR REPLACE PACKAGE CPI.giac_chart_of_accts_pkg
AS
    TYPE gl_acct_list_type IS RECORD(
            item_no         giac_module_entries.item_no%TYPE,       
            gl_acct_id      giac_chart_of_accts.gl_acct_id%TYPE,    
            gl_acct_cd      VARCHAR2(32000),
            gl_acct_name    giac_chart_of_accts.gl_acct_name%TYPE,
            gslt_sl_type_cd giac_chart_of_accts.gslt_sl_type_cd%TYPE);
            
    TYPE gl_acct_list_tab IS TABLE OF gl_acct_list_type;
    
    FUNCTION get_gl_acct_list RETURN gl_acct_list_tab PIPELINED;        

    TYPE gl_acct_list2_type IS RECORD(
            gl_acct_category        giac_chart_of_accts.gl_acct_category%TYPE,
            gl_control_acct         giac_chart_of_accts.gl_control_acct%TYPE,
            gl_sub_acct_1           giac_chart_of_accts.gl_sub_acct_1%TYPE,         
            gl_sub_acct_2           giac_chart_of_accts.gl_sub_acct_2%TYPE,
            gl_sub_acct_3           giac_chart_of_accts.gl_sub_acct_3%TYPE,
            gl_sub_acct_4           giac_chart_of_accts.gl_sub_acct_4%TYPE,
            gl_sub_acct_5           giac_chart_of_accts.gl_sub_acct_5%TYPE,
            gl_sub_acct_6           giac_chart_of_accts.gl_sub_acct_6%TYPE,
            gl_sub_acct_7           giac_chart_of_accts.gl_sub_acct_7%TYPE,
            gl_acct_name            giac_chart_of_accts.gl_acct_name%TYPE,
            gl_acct_id              giac_chart_of_accts.gl_acct_id%TYPE,
            gslt_sl_type_cd         giac_chart_of_accts.gslt_sl_type_cd%TYPE,
            sl_type_name            giac_sl_types.sl_type_name%TYPE
    );

    TYPE gl_acct_list2_tab IS TABLE OF gl_acct_list2_type;

    FUNCTION get_gl_acct_list2(p_gl_acct_name        giac_chart_of_accts.gl_acct_name%TYPE) 
    RETURN gl_acct_list2_tab PIPELINED;
    
    FUNCTION CHECK_ACCOUNT_CD(
            p_gl_acct_category        giac_chart_of_accts.gl_acct_category%TYPE,
            p_gl_control_acct         giac_chart_of_accts.gl_control_acct%TYPE,
            p_gl_sub_acct_1           giac_chart_of_accts.gl_sub_acct_1%TYPE,         
            p_gl_sub_acct_2           giac_chart_of_accts.gl_sub_acct_2%TYPE,
            p_gl_sub_acct_3           giac_chart_of_accts.gl_sub_acct_3%TYPE,
            p_gl_sub_acct_4           giac_chart_of_accts.gl_sub_acct_4%TYPE,
            p_gl_sub_acct_5           giac_chart_of_accts.gl_sub_acct_5%TYPE,
            p_gl_sub_acct_6           giac_chart_of_accts.gl_sub_acct_6%TYPE,
            p_gl_sub_acct_7           giac_chart_of_accts.gl_sub_acct_7%TYPE)
    RETURN gl_acct_list2_tab PIPELINED;
    
    FUNCTION get_gl_acct_list_GIACS030(
            p_gl_acct_category        giac_chart_of_accts.gl_acct_category%TYPE,
            p_gl_control_acct         giac_chart_of_accts.gl_control_acct%TYPE,
            p_gl_sub_acct_1           giac_chart_of_accts.gl_sub_acct_1%TYPE,         
            p_gl_sub_acct_2           giac_chart_of_accts.gl_sub_acct_2%TYPE,
            p_gl_sub_acct_3           giac_chart_of_accts.gl_sub_acct_3%TYPE,
            p_gl_sub_acct_4           giac_chart_of_accts.gl_sub_acct_4%TYPE,
            p_gl_sub_acct_5           giac_chart_of_accts.gl_sub_acct_5%TYPE,
            p_gl_sub_acct_6           giac_chart_of_accts.gl_sub_acct_6%TYPE,
            p_gl_sub_acct_7           giac_chart_of_accts.gl_sub_acct_7%TYPE,
            p_keyword                 VARCHAR2) 
    RETURN gl_acct_list2_tab PIPELINED;
	
	FUNCTION get_gl_acct_list4(
            p_gl_acct_category        giac_chart_of_accts.gl_acct_category%TYPE,
            p_gl_control_acct         giac_chart_of_accts.gl_control_acct%TYPE,
            p_gl_sub_acct_1           giac_chart_of_accts.gl_sub_acct_1%TYPE,         
            p_gl_sub_acct_2           giac_chart_of_accts.gl_sub_acct_2%TYPE,
            p_gl_sub_acct_3           giac_chart_of_accts.gl_sub_acct_3%TYPE,
            p_gl_sub_acct_4           giac_chart_of_accts.gl_sub_acct_4%TYPE,
            p_gl_sub_acct_5           giac_chart_of_accts.gl_sub_acct_5%TYPE,
            p_gl_sub_acct_6           giac_chart_of_accts.gl_sub_acct_6%TYPE,
            p_gl_sub_acct_7           giac_chart_of_accts.gl_sub_acct_7%TYPE,
			p_find					  VARCHAR2) 
    RETURN gl_acct_list2_tab PIPELINED;
    
	FUNCTION search_gl_acct_list(
            p_keyword varchar2) 
    RETURN gl_acct_list2_tab PIPELINED;
    
    FUNCTION get_gl_acct_listing (
        p_gl_acct_category        giac_chart_of_accts.gl_acct_category%TYPE,
        p_gl_control_acct         giac_chart_of_accts.gl_control_acct%TYPE,
        p_gl_sub_acct_1           giac_chart_of_accts.gl_sub_acct_1%TYPE,         
        p_gl_sub_acct_2           giac_chart_of_accts.gl_sub_acct_2%TYPE,
        p_gl_sub_acct_3           giac_chart_of_accts.gl_sub_acct_3%TYPE,
        p_gl_sub_acct_4           giac_chart_of_accts.gl_sub_acct_4%TYPE,
        p_gl_sub_acct_5           giac_chart_of_accts.gl_sub_acct_5%TYPE,
        p_gl_sub_acct_6           giac_chart_of_accts.gl_sub_acct_6%TYPE,
        p_gl_sub_acct_7           giac_chart_of_accts.gl_sub_acct_7%TYPE,
        p_gl_acct_name            giac_chart_of_accts.gl_acct_name%TYPE
    ) RETURN gl_acct_list2_tab PIPELINED;
    
    PROCEDURE Check_Chart_Of_Accts_GICLS055
        (cca_gl_acct_category   IN  GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
         cca_gl_control_acct    IN  GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
         cca_gl_sub_acct_1      IN  GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
         cca_gl_sub_acct_2      IN  GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
         cca_gl_sub_acct_3      IN  GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
         cca_gl_sub_acct_4      IN  GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
         cca_gl_sub_acct_5      IN  GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
         cca_gl_sub_acct_6      IN  GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
         cca_gl_sub_acct_7      IN  GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
         cca_gl_acct_id   		IN OUT GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE,
         p_mesg					OUT VARCHAR2);
         
     
    --added by Shan 04.22.2013      
     TYPE gl_acct_list3_type IS RECORD(
            gl_acct_id              giac_chart_of_accts.gl_acct_id%TYPE,
            gl_acct_type            VARCHAR2(1),
            gl_acct_category        giac_chart_of_accts.gl_acct_category%TYPE,
            gl_control_acct         VARCHAR2(3),--giac_chart_of_accts.gl_control_acct%TYPE,
            gl_sub_acct_1           VARCHAR2(3),--giac_chart_of_accts.gl_sub_acct_1%TYPE,         
            gl_sub_acct_2           VARCHAR2(3),--giac_chart_of_accts.gl_sub_acct_2%TYPE,
            gl_sub_acct_3           VARCHAR2(3),--giac_chart_of_accts.gl_sub_acct_3%TYPE,
            gl_sub_acct_4           VARCHAR2(3),--giac_chart_of_accts.gl_sub_acct_4%TYPE,
            gl_sub_acct_5           VARCHAR2(3),--giac_chart_of_accts.gl_sub_acct_5%TYPE,
            gl_sub_acct_6           VARCHAR2(3),--giac_chart_of_accts.gl_sub_acct_6%TYPE,
            gl_sub_acct_7           VARCHAR2(3),--giac_chart_of_accts.gl_sub_acct_7%TYPE,
            gl_acct_name            giac_chart_of_accts.gl_acct_name%TYPE,
            gl_acct_no              VARCHAR2(50)
    );

    TYPE gl_acct_list3_tab IS TABLE OF gl_acct_list3_type;
         
    FUNCTION get_gl_acct_list_GIACS230(
        p_gl_acct_category        VARCHAR2, --giac_chart_of_accts.gl_acct_category%TYPE,
        p_gl_control_acct         VARCHAR2, --giac_chart_of_accts.gl_control_acct%TYPE,
        p_gl_sub_acct_1           VARCHAR2, --giac_chart_of_accts.gl_sub_acct_1%TYPE,         
        p_gl_sub_acct_2           VARCHAR2, --giac_chart_of_accts.gl_sub_acct_2%TYPE,
        p_gl_sub_acct_3           VARCHAR2, --giac_chart_of_accts.gl_sub_acct_3%TYPE,
        p_gl_sub_acct_4           VARCHAR2, --giac_chart_of_accts.gl_sub_acct_4%TYPE,
        p_gl_sub_acct_5           VARCHAR2, --giac_chart_of_accts.gl_sub_acct_5%TYPE,
        p_gl_sub_acct_6           VARCHAR2, --giac_chart_of_accts.gl_sub_acct_6%TYPE,
        p_gl_sub_acct_7           VARCHAR2 --giac_chart_of_accts.gl_sub_acct_7%TYPE
    ) RETURN gl_acct_list3_tab PIPELINED;
    
    TYPE giacs060_gl_acct_code_type IS RECORD (
       gl_acct_category giac_chart_of_accts.gl_acct_category%TYPE, 
       gl_control_acct  giac_chart_of_accts.gl_control_acct%TYPE, 
       gl_sub_acct_1    giac_chart_of_accts.gl_sub_acct_1%TYPE, 
       gl_sub_acct_2    giac_chart_of_accts.gl_sub_acct_2%TYPE, 
       gl_sub_acct_3    giac_chart_of_accts.gl_sub_acct_3%TYPE, 
       gl_sub_acct_4    giac_chart_of_accts.gl_sub_acct_4%TYPE, 
       gl_sub_acct_5    giac_chart_of_accts.gl_sub_acct_5%TYPE, 
       gl_sub_acct_6    giac_chart_of_accts.gl_sub_acct_6%TYPE, 
       gl_sub_acct_7    giac_chart_of_accts.gl_sub_acct_7%TYPE, 
       gl_acct_name     giac_chart_of_accts.gl_acct_name%TYPE, 
       gl_acct_id       giac_chart_of_accts.gl_acct_id%TYPE,
       gl_acct_no       VARCHAR2(200),
       gl_acct_type     VARCHAR2(200)
    );
    
    TYPE giacs060_gl_acct_code_tab IS TABLE OF giacs060_gl_acct_code_type;
    
    FUNCTION get_giacs060_gl_acct_code (
       p_gl_acct_category   VARCHAR2,
       p_gl_control_acct      VARCHAR2,
       p_gl_sub_acct_1        VARCHAR2,
       p_gl_sub_acct_2        VARCHAR2,
       p_gl_sub_acct_3        VARCHAR2,
       p_gl_sub_acct_4        VARCHAR2,
       p_gl_sub_acct_5        VARCHAR2,
       p_gl_sub_acct_6        VARCHAR2,
       p_gl_sub_acct_7        VARCHAR2,
       p_gl_acct_name         VARCHAR2
    )
       RETURN giacs060_gl_acct_code_tab PIPELINED;
    
	FUNCTION get_gl_acct_lov(
            p_gl_acct_category        giac_chart_of_accts.gl_acct_category%TYPE,
            p_gl_control_acct         giac_chart_of_accts.gl_control_acct%TYPE,
            p_gl_sub_acct_1           giac_chart_of_accts.gl_sub_acct_1%TYPE,         
            p_gl_sub_acct_2           giac_chart_of_accts.gl_sub_acct_2%TYPE,
            p_gl_sub_acct_3           giac_chart_of_accts.gl_sub_acct_3%TYPE,
            p_gl_sub_acct_4           giac_chart_of_accts.gl_sub_acct_4%TYPE,
            p_gl_sub_acct_5           giac_chart_of_accts.gl_sub_acct_5%TYPE,
            p_gl_sub_acct_6           giac_chart_of_accts.gl_sub_acct_6%TYPE,
            p_gl_sub_acct_7           giac_chart_of_accts.gl_sub_acct_7%TYPE,
			p_find					  VARCHAR2) 
    RETURN gl_acct_list2_tab PIPELINED;    
    
	FUNCTION get_gl_acct_lov2(
            p_gl_acct_category        giac_chart_of_accts.gl_acct_category%TYPE,
            p_gl_control_acct         giac_chart_of_accts.gl_control_acct%TYPE,
            p_gl_sub_acct_1           giac_chart_of_accts.gl_sub_acct_1%TYPE,         
            p_gl_sub_acct_2           giac_chart_of_accts.gl_sub_acct_2%TYPE,
            p_gl_sub_acct_3           giac_chart_of_accts.gl_sub_acct_3%TYPE,
            p_gl_sub_acct_4           giac_chart_of_accts.gl_sub_acct_4%TYPE,
            p_gl_sub_acct_5           giac_chart_of_accts.gl_sub_acct_5%TYPE,
            p_gl_sub_acct_6           giac_chart_of_accts.gl_sub_acct_6%TYPE,
            p_gl_sub_acct_7           giac_chart_of_accts.gl_sub_acct_7%TYPE,
			p_find					  VARCHAR2) 
    RETURN gl_acct_list2_tab PIPELINED;       
END;
/


