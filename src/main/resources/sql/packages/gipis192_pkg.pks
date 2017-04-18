CREATE OR REPLACE PACKAGE CPI.GIPIS192_PKG
AS
/* Created by : John Dolon
 * Date Created: 09.16.2013
 * Reference By: GIPIS192 - Policy Listing per Make
 *
*/
   TYPE make_lov_type IS RECORD (
      make_cd           NUMBER(12),
      make              VARCHAR2(50),
      car_company_cd    NUMBER(6),    
      car_company       VARCHAR2(50)
      );
      
   TYPE make_lov_tab IS TABLE OF make_lov_type;
   
   FUNCTION get_make_lov(
        p_make_cd       VARCHAR2,
        p_company_cd    VARCHAR2
   )
    RETURN make_lov_tab PIPELINED;
    
   TYPE company_lov_type IS RECORD (
      car_company_cd    NUMBER(6),    
      car_company       VARCHAR2(50)
      );
      
   TYPE company_lov_tab IS TABLE OF company_lov_type;
   
   FUNCTION get_company_lov
    RETURN company_lov_tab PIPELINED;
   
   
   PROCEDURE validate_gipis192_make_cd(
       p_make_cd    IN OUT VARCHAR2,
       p_make       IN OUT VARCHAR2,
       p_company_cd IN OUT VARCHAR2,
       p_company    IN OUT VARCHAR2
   );
   
   PROCEDURE validate_gipis192_company_cd(
       p_company_cd IN OUT VARCHAR2,
       p_company    IN OUT VARCHAR2
   );
   
   TYPE gipis192_table_type IS RECORD (
      policy_id         NUMBER(12),
      policy_no         VARCHAR2(100),
      item_no           NUMBER(12),
      item_title        VARCHAR2(50),
      plate_no          VARCHAR2(10),
      motor_no          VARCHAR2(20),
      serial_no         VARCHAR2(25),
      tsi_amt           NUMBER(16,2),
      prem_amt          NUMBER(16,2),
      assd_no           NUMBER(12),
      assd_name         VARCHAR2(500),
      incept_date       DATE,
      eff_date          DATE,
      expiry_date       DATE,
      issue_date        DATE,
      make_cd           VARCHAR2(20),
      company_cd        VARCHAR2(20),
      iss_cd            VARCHAR2(5),
      total_tsi_amt     NUMBER(16,2),
      total_prem_amt    NUMBER(16,2)
      );
      
   TYPE gipis192_table_tab IS TABLE OF gipis192_table_type;
   
   FUNCTION get_gipis192_table(
       p_make_cd               VARCHAR2,
       p_company_cd            VARCHAR2,
       p_search_by             VARCHAR2,
       p_as_of_date            VARCHAR2,
       p_from_date             VARCHAR2,
       p_to_date               VARCHAR2,
       p_user                  VARCHAR2,
       p_cred_branch           VARCHAR2
   )
   RETURN gipis192_table_tab PIPELINED;
END;
/


