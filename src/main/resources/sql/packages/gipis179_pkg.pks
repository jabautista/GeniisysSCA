CREATE OR REPLACE PACKAGE CPI.GIPIS179_PKG
AS
   /* 
   * Created by : Bonok
   * Date Created : 10.08.2013
   * Reference By : GIPIS179 - VIEW RENEWAL
   */ 
   
   TYPE gipis179_type IS RECORD (
      policy_number        VARCHAR2(50),
      assured              giis_assured.assd_name%TYPE,
      renewal_no           VARCHAR2(50),
      user_id              giex_rn_no.user_id%TYPE,
      with_renewal         VARCHAR2(1),
      policy_id            giex_rn_no.policy_id%TYPE
   );
      
   TYPE gipis179_tab IS TABLE OF gipis179_type;
   
   FUNCTION get_gipis179_list(
      p_user_id            giex_rn_no.user_id%TYPE
   ) RETURN gipis179_tab PIPELINED;
   
   TYPE renewal_history_type IS RECORD (
      policy_number        VARCHAR2(50)
   );
      
   TYPE renewal_history_tab IS TABLE OF renewal_history_type;
   
   FUNCTION get_renewal_history_list(
      p_policy_id          giex_rn_no.policy_id%TYPE
   ) RETURN renewal_history_tab PIPELINED;
END;
/


