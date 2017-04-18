CREATE OR REPLACE PACKAGE CPI.GIPIS100A_PKG
AS
/* Created by : John Dolon
 * Date Created: 09.03.2013
 * Reference By: GIPIS100A - Package Policy Information
 *
*/
   TYPE package_lov_type IS RECORD (
      line_cd           VARCHAR2(2),
      subline_cd        VARCHAR2(7),
      iss_cd            VARCHAR2(2),
      issue_yy          NUMBER(2),
      pol_seq_no        NUMBER(7),
      renew_no          NUMBER(2),
      ref_pol_no        VARCHAR2(30),
      par_line_cd       VARCHAR2(2),
      par_iss_cd        VARCHAR2(2),
      par_yy            NUMBER(2),
      par_seq_no        NUMBER(6),
      quote_seq_no      NUMBER(2),
      endt_iss_cd       gipi_pack_polbasic.ENDT_ISS_CD%TYPE,    -- start SR-19640 : shan 07.09.2015
      endt_yy           gipi_pack_polbasic.ENDT_YY%TYPE,
      endt_seq_no       gipi_pack_polbasic.ENDT_SEQ_NO%TYPE,    -- end SR-19640 : shan 07.09.2015
      assd_no           NUMBER(12),
      assd_name         VARCHAR2(500),
      pol_flag          VARCHAR2(1),
      pol_status        VARCHAR2(50),
      line_cd_rn        VARCHAR2(2),
      iss_cd_rn         VARCHAR2(2),
      rn_yy             NUMBER(2),
      rn_seq_no         NUMBER(7),
      incept_date       DATE,
      expiry_date       DATE,
      issue_date        DATE,
      pack_policy_id    NUMBER(12),
      pack_par_id       NUMBER(12)
      );
      
   TYPE package_lov_tab IS TABLE OF package_lov_type;

   FUNCTION get_package_lov (
      p_module_id    VARCHAR2,
      p_user_id      VARCHAR2,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_iss_cd       VARCHAR2,
      p_issue_yy     VARCHAR2,
      p_pol_seq_no   VARCHAR2,
      p_renew_no     VARCHAR2,
      p_pack_pol_id  VARCHAR2
   )
   RETURN package_lov_tab PIPELINED;
   
   TYPE package_pol_info_type IS RECORD (
      policy_id         NUMBER(12),
      line_cd           VARCHAR2(2),
      subline_cd        VARCHAR2(7),
      iss_cd            VARCHAR2(2),
      issue_yy          NUMBER(2),
      pol_seq_no        NUMBER(7),
      endt_iss_cd       VARCHAR2(2),
      endt_yy           NUMBER(6),
      endt_seq_no       NUMBER(2),
      renew_no          NUMBER(2),
      pack_policy_id    NUMBER(12),
      par_id            NUMBER(12),
      policy_no         VARCHAR2(50)
   );
   
   TYPE package_pol_info_tab IS TABLE OF package_pol_info_type;
   
   FUNCTION get_package_pol_info (
      p_pack_policy_id    NUMBER
   )
   RETURN package_pol_info_tab PIPELINED;
   
   TYPE package_pol_item_type IS RECORD (
      policy_id         NUMBER(12),
      line_cd           VARCHAR2(2),
      subline_cd        VARCHAR2(7),
      item_no           NUMBER(9),
      item_title        VARCHAR2(50),
      policy_no         VARCHAR2(50)
   );
   
   TYPE package_pol_item_tab IS TABLE OF package_pol_item_type;
   
   FUNCTION get_package_pol_item (
      p_pack_policy_id    NUMBER
   )
   RETURN package_pol_item_tab PIPELINED;
   
   -- added by gab 08.06.2015
   TYPE package_assd_lov_type IS RECORD (
      line_cd           VARCHAR2(2),
      subline_cd        VARCHAR2(7),
      iss_cd            VARCHAR2(2),
      issue_yy          NUMBER(2),
      pol_seq_no        NUMBER(7),
      renew_no          NUMBER(2),
      ref_pol_no        VARCHAR2(30),
      par_line_cd       VARCHAR2(2),
      par_iss_cd        VARCHAR2(2),
      par_yy            NUMBER(2),
      par_seq_no        NUMBER(6),
      quote_seq_no      NUMBER(2),
      endt_iss_cd       gipi_pack_polbasic.ENDT_ISS_CD%TYPE,
      endt_yy           gipi_pack_polbasic.ENDT_YY%TYPE,
      endt_seq_no       gipi_pack_polbasic.ENDT_SEQ_NO%TYPE,
      assd_no           NUMBER(12),
      assd_name         VARCHAR2(500),
      pol_flag          VARCHAR2(1),
      pol_status        VARCHAR2(50),
      line_cd_rn        VARCHAR2(2),
      iss_cd_rn         VARCHAR2(2),
      rn_yy             NUMBER(2),
      rn_seq_no         NUMBER(7),
      incept_date       DATE,
      expiry_date       DATE,
      issue_date        DATE,
      eff_date          DATE,
      pack_policy_id    gipi_pack_polbasic.pack_policy_id%TYPE,
      pack_par_id       gipi_pack_polbasic.pack_par_id%TYPE,
      policy_no         VARCHAR(50),
      endt_no           VARCHAR(50)
      );
      
   TYPE package_assd_lov_tab IS TABLE OF package_assd_lov_type;

   FUNCTION get_package_assd_lov (
      p_assd_no        VARCHAR2,
      p_assd_name      VARCHAR2
   )
   RETURN package_assd_lov_tab PIPELINED;
END;
/
