CREATE OR REPLACE PACKAGE CPI.GIPIR192_PKG
AS

   TYPE gipir192_table_type IS RECORD (
      policy_id         NUMBER(12),
      item_no           NUMBER(12),
      item_title        VARCHAR2(50),
      plate_no          VARCHAR2(10),
      motor_no          VARCHAR2(20),
      serial_no         VARCHAR2(25),
      assd_no           NUMBER(12),
      assd_name         VARCHAR2(500),
      tsi_amt           NUMBER(16,2),
      prem_amt          NUMBER(16,2),
      policy_no         VARCHAR2(100),
      incept_date       DATE,
      expiry_date       DATE,
      make              VARCHAR2(50),
      company           VARCHAR2(100)
      --eff_date          DATE,
      --issue_date        DATE,
      );
      
   TYPE gipir192_table_tab IS TABLE OF gipir192_table_type;
   
   FUNCTION get_gipir192_table(
       p_make_cd               VARCHAR2,
       p_company_cd            VARCHAR2,
       p_search_by             VARCHAR2,
       p_as_of_date            VARCHAR2,
       p_from_date             VARCHAR2,
       p_to_date               VARCHAR2,
       p_user_id               VARCHAR2,
       p_cred_branch           VARCHAR2
   )
   RETURN gipir192_table_tab PIPELINED;
   
   TYPE gipir192_header_type IS RECORD(
        company_name        VARCHAR2(100),
        company_address     VARCHAR2(250)
    );
    
   TYPE gipir192_header_tab IS TABLE OF gipir192_header_type;
    
   FUNCTION get_gipir192_header
        RETURN gipir192_header_tab PIPELINED;

END;
/


