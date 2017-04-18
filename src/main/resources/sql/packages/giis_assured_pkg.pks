CREATE OR REPLACE PACKAGE CPI.Giis_Assured_Pkg
AS
     /*
     ** Created by: Whofeih 
     ** Created date: 02/12/2010
     ** Modified by: pjsantos, 09/16/2016 for optimization GENQ 5667A.
     */ 
      
   FUNCTION get_assd_name (p_assd_no GIIS_ASSURED.assd_no%TYPE)
      RETURN GIIS_ASSURED.assd_name%TYPE;

   TYPE giis_assured_type IS RECORD
   (
      assd_no         GIIS_ASSURED.assd_no%TYPE,
      assd_name       GIIS_ASSURED.assd_name%TYPE,
      address         VARCHAR2 (300),
      active_tag      GIIS_ASSURED.active_tag%TYPE,
      corporate_tag   GIIS_ASSURED.corporate_tag%TYPE
   );

   TYPE giis_assured_tab IS TABLE OF giis_assured_type;

   FUNCTION get_giis_assured
      RETURN giis_assured_tab
      PIPELINED;

   TYPE giis_assured_details_type IS RECORD
   (
      assd_no             GIIS_ASSURED.assd_no%TYPE,
      assd_name           GIIS_ASSURED.assd_name%TYPE,
      govt_tag            GIIS_ASSURED.govt_tag%TYPE,
      tran_date           GIIS_ASSURED.tran_date%TYPE,
      designation         GIIS_ASSURED.designation%TYPE,
      gsis_no             GIIS_ASSURED.gsis_no%TYPE,
      mail_addr1          GIIS_ASSURED.mail_addr1%TYPE,
      mail_addr2          GIIS_ASSURED.mail_addr2%TYPE,
      mail_addr3          GIIS_ASSURED.mail_addr3%TYPE,
      bill_addr1          GIIS_ASSURED.bill_addr1%TYPE,
      bill_addr2          GIIS_ASSURED.bill_addr2%TYPE,
      bill_addr3          GIIS_ASSURED.bill_addr3%TYPE,
      contact_pers        GIIS_ASSURED.contact_pers%TYPE,
      phone_no            GIIS_ASSURED.phone_no%TYPE,
      industry_cd         GIIS_ASSURED.industry_cd%TYPE,
      industry_nm         GIIS_INDUSTRY.industry_nm%TYPE,
      office_type         GIIS_ASSURED.office_type%TYPE,
      govt_type           GIIS_ASSURED.govt_type%TYPE,
      reference_no        GIIS_ASSURED.reference_no%TYPE,
      corporate_tag       GIIS_ASSURED.corporate_tag%TYPE,
      institutional_tag   GIIS_ASSURED.institutional_tag%TYPE,
      first_name          GIIS_ASSURED.first_name%TYPE,
      last_name           GIIS_ASSURED.last_name%TYPE,
      middle_initial      GIIS_ASSURED.middle_initial%TYPE,
      suffix              GIIS_ASSURED.suffix%TYPE,
      user_id             GIIS_ASSURED.user_id%TYPE,
      last_update         GIIS_ASSURED.last_update%TYPE,
      remarks             GIIS_ASSURED.remarks%TYPE,
      parent_assd_no      GIIS_ASSURED.parent_assd_no%TYPE,
      parent_assd_name    GIIS_ASSURED.assd_name%TYPE,
      assd_name2          GIIS_ASSURED.assd_name2%TYPE,
      assd_tin            GIIS_ASSURED.assd_tin%TYPE,
      cp_no               GIIS_ASSURED.cp_no%TYPE,
      sun_no              GIIS_ASSURED.sun_no%TYPE,
      globe_no            GIIS_ASSURED.globe_no%TYPE,
      smart_no            GIIS_ASSURED.smart_no%TYPE,
      control_type_cd     GIIS_ASSURED.control_type_cd%TYPE,
      control_type_desc   GIIS_CONTROL_TYPE.control_type_desc%TYPE,
      zip_cd              GIIS_ASSURED.zip_cd%TYPE,
      vat_tag             GIIS_ASSURED.vat_tag%TYPE,
      active_tag          GIIS_ASSURED.active_tag%TYPE,
      no_tin_reason       GIIS_ASSURED.no_tin_reason%TYPE,
       birth_date            GIIS_ASSURED.birth_date%TYPE, --added by irwin, enchancement
      birth_month             GIIS_ASSURED.birth_month%TYPE,
       birth_year          GIIS_ASSURED.birth_year%TYPE,
      email_address       GIIS_ASSURED.email_address%TYPE
      
   );

   TYPE giis_assured_details_tab IS TABLE OF giis_assured_details_type;

   FUNCTION get_giis_assured_details (p_assd_no GIIS_ASSURED.assd_no%TYPE)
      RETURN giis_assured_details_tab
      PIPELINED;

   PROCEDURE set_giis_assured (
      v_assd_no             IN GIIS_ASSURED.assd_no%TYPE,
      v_assd_name           IN GIIS_ASSURED.assd_name%TYPE,
      v_govt_tag            IN GIIS_ASSURED.govt_tag%TYPE,
      v_tran_date           IN GIIS_ASSURED.tran_date%TYPE,
      v_designation         IN GIIS_ASSURED.designation%TYPE,
      v_gsis_no             IN GIIS_ASSURED.gsis_no%TYPE,
      v_mail_addr1          IN GIIS_ASSURED.mail_addr1%TYPE,
      v_mail_addr2          IN GIIS_ASSURED.mail_addr2%TYPE,
      v_mail_addr3          IN GIIS_ASSURED.mail_addr3%TYPE,
      v_bill_addr1          IN GIIS_ASSURED.bill_addr1%TYPE,
      v_bill_addr2          IN GIIS_ASSURED.bill_addr2%TYPE,
      v_bill_addr3          IN GIIS_ASSURED.bill_addr3%TYPE,
      v_contact_pers        IN GIIS_ASSURED.contact_pers%TYPE,
      v_phone_no            IN GIIS_ASSURED.phone_no%TYPE,
      v_industry_cd         IN GIIS_ASSURED.industry_cd%TYPE,
      v_office_type         IN GIIS_ASSURED.office_type%TYPE,
      v_govt_type           IN GIIS_ASSURED.govt_type%TYPE,
      v_reference_no        IN GIIS_ASSURED.reference_no%TYPE,
      v_corporate_tag       IN GIIS_ASSURED.corporate_tag%TYPE,
      v_institutional_tag   IN GIIS_ASSURED.institutional_tag%TYPE,
      v_first_name          IN GIIS_ASSURED.first_name%TYPE,
      v_last_name           IN GIIS_ASSURED.last_name%TYPE,
      v_middle_initial      IN GIIS_ASSURED.middle_initial%TYPE,
      v_suffix              IN GIIS_ASSURED.suffix%TYPE,
      v_user_id             IN GIIS_ASSURED.user_id%TYPE,
      v_remarks             IN GIIS_ASSURED.remarks%TYPE,
      v_parent_assd_no      IN GIIS_ASSURED.parent_assd_no%TYPE,
      v_parent_assd_name    IN GIIS_ASSURED.assd_name%TYPE,
      v_assd_name2          IN GIIS_ASSURED.assd_name2%TYPE,
      v_assd_tin            IN GIIS_ASSURED.assd_tin%TYPE,
      v_cp_no               IN GIIS_ASSURED.cp_no%TYPE,
      v_sun_no              IN GIIS_ASSURED.sun_no%TYPE,
      v_globe_no            IN GIIS_ASSURED.globe_no%TYPE,
      v_smart_no            IN GIIS_ASSURED.smart_no%TYPE,
      v_control_type_cd     IN GIIS_ASSURED.control_type_cd%TYPE,
      v_zip_cd              IN GIIS_ASSURED.zip_cd%TYPE,
      v_vat_tag             IN GIIS_ASSURED.vat_tag%TYPE,
      v_active_tag          IN GIIS_ASSURED.active_tag%TYPE,
      v_no_tin_reason       IN GIIS_ASSURED.no_tin_reason%TYPE,
      v_birth_date              IN GIIS_ASSURED.birth_date%TYPE,
      v_birth_month             IN GIIS_ASSURED.birth_month%TYPE,
      v_birth_year          IN GIIS_ASSURED.birth_year%TYPE,
      v_email_address       IN GIIS_ASSURED.email_address%TYPE
      );


   PROCEDURE del_giis_assured (p_assd_no GIIS_ASSURED.assd_no%TYPE);


   /*************** LISTINGS *****************/

   TYPE assured_list_type IS RECORD
   (
      assd_no            GIIS_ASSURED.assd_no%TYPE,
      assd_name          GIIS_ASSURED.assd_name%TYPE,
      birthdate          GIIS_ASSD_IND_INFO.birthdate%TYPE,
      complete_address   VARCHAR2 (200),
      address1           GIIS_ASSURED.mail_addr1%TYPE,
      address2           GIIS_ASSURED.mail_addr2%TYPE,
      address3           GIIS_ASSURED.mail_addr3%TYPE
   );

   TYPE assured_list_tab IS TABLE OF assured_list_type;

   FUNCTION get_assured_list
      RETURN assured_list_tab
      PIPELINED;


   /********************************** FUNCTION 2 ************************************
     MODULE: GIPIS002
     RECORD GROUP NAME: SAME_ASSURED_NAME
   ***********************************************************************************/

   TYPE same_assured_name_list_type IS RECORD
   (
      assd_name        GIIS_ASSURED.assd_name%TYPE,
      assd_no          GIIS_ASSURED.assd_no%TYPE,
      mail_addr1       GIIS_ASSURED.mail_addr1%TYPE,
      mail_addr2       GIIS_ASSURED.mail_addr2%TYPE,
      mail_addr3       GIIS_ASSURED.mail_addr3%TYPE,
      bill_addr1       GIIS_ASSURED.bill_addr1%TYPE,
      bill_addr2       GIIS_ASSURED.bill_addr2%TYPE,
      bill_addr3       GIIS_ASSURED.bill_addr3%TYPE,
      contact_pers     GIIS_ASSURED.contact_pers%TYPE,
      phone_no         GIIS_ASSURED.phone_no%TYPE,
      first_name       GIIS_ASSURED.first_name%TYPE,
      last_name        GIIS_ASSURED.last_name%TYPE,
      middle_initial   GIIS_ASSURED.middle_initial%TYPE
   );

   TYPE same_assured_name_list_tab IS TABLE OF same_assured_name_list_type;

   FUNCTION get_same_assured_name_list (
      p_assured_name GIIS_ASSURED.assd_name%TYPE)
      RETURN same_assured_name_list_tab
      PIPELINED;


   /********************************** FUNCTION 3 ************************************
     MODULE: GIPIS002
     RECORD GROUP NAME: ASSURED_NAMES
   ***********************************************************************************/

   TYPE assured_names_list_type IS RECORD
   (
      count_        NUMBER,
      rownum_       NUMBER,
      assd_name     GIIS_ASSURED.assd_name%TYPE,
      assd_no       GIIS_ASSURED.assd_no%TYPE,
      mail_addr1    GIIS_ASSURED.mail_addr1%TYPE,
      mail_addr2    GIIS_ASSURED.mail_addr2%TYPE,
      mail_addr3    GIIS_ASSURED.mail_addr3%TYPE,
      designation   GIIS_ASSURED.designation%TYPE,
      active_tag    GIIS_ASSURED.active_tag%TYPE,
      user_id       GIIS_ASSURED.user_id%TYPE,
      industry_nm   GIIS_INDUSTRY.industry_nm%TYPE,
      industry_cd   GIIS_INDUSTRY.industry_cd%TYPE,
      birthdate     GIIS_ASSD_IND_INFO.birthdate%TYPE,
      corp_tag      CG_REF_CODES.rv_meaning%TYPE,
      control_type_cd   giis_assured.control_type_cd%TYPE -- bonok :: 10.25.2013
   );

   TYPE assured_names_list_tab IS TABLE OF assured_names_list_type;

   FUNCTION get_assured_names_list  (
     p_find_text     VARCHAR2,
     p_order_by      VARCHAR2,
     p_asc_desc_flag VARCHAR2,
     p_from          NUMBER,
     p_to            NUMBER
   ) RETURN assured_names_list_tab PIPELINED;

   /********************************** FUNCTION 3.1 **********************************
     MODULE: GIPIS002
     RECORD GROUP NAME: ASSURED_NAMES - FOR TABLE GRID
   ***********************************************************************************/

   TYPE assured_names_list_type_tg IS RECORD
   (
      assd_name     GIIS_ASSURED.assd_name%TYPE,
      assd_no       VARCHAR2(15),--GIIS_ASSURED.assd_no%TYPE, -- andrew 08.10.2012 - for formatted assured no
      mail_addr1    VARCHAR2(155), --GIIS_ASSURED.mail_addr1%TYPE,
      mail_addr2    VARCHAR2(50), --GIIS_ASSURED.mail_addr2%TYPE,
      mail_addr3    VARCHAR2(50), --GIIS_ASSURED.mail_addr3%TYPE,
      designation   GIIS_ASSURED.designation%TYPE,
      active_tag    GIIS_ASSURED.active_tag%TYPE,
      user_id       GIIS_ASSURED.user_id%TYPE,
      industry_nm   GIIS_INDUSTRY.industry_nm%TYPE, 
      industry_cd   GIIS_INDUSTRY.industry_cd%TYPE,
      birthdate     GIIS_ASSD_IND_INFO.birthdate%TYPE,
      corp_tag      CG_REF_CODES.rv_meaning%TYPE,
      intm_no       VARCHAR2(15),--GIIS_INTERMEDIARY.intm_no%TYPE,
      intm_name     GIIS_INTERMEDIARY.intm_name%TYPE,
      count_        NUMBER, --added by pjsantos @pcic 09/16/2016, for optimization GENQA 2016
      rownum_       NUMBER  --added by pjsantos @pcic 09/16/2016, for optimization GENQA 2016
   );

   TYPE assured_names_list_tab_tg IS TABLE OF assured_names_list_type_tg;

   FUNCTION get_assured_names_list_tg (
      p_assd_no          GIIS_ASSURED.assd_no%TYPE,
      p_corporate_tag    GIIS_ASSURED.corporate_tag%TYPE,
      p_assd_name        GIIS_ASSURED.assd_name%TYPE,
      p_mail_addr1       GIIS_ASSURED.mail_addr1%TYPE,
      p_active_tag       GIIS_ASSURED.active_tag%TYPE)
      RETURN assured_names_list_tab_tg
      PIPELINED;

   FUNCTION get_assured_names_list_tg2 (
      p_assd_no          GIIS_ASSURED.assd_no%TYPE,
      p_corporate_tag    GIIS_ASSURED.corporate_tag%TYPE,
      p_assd_name        GIIS_ASSURED.assd_name%TYPE,
      p_mail_addr1       GIIS_ASSURED.mail_addr1%TYPE,
      p_active_tag       GIIS_ASSURED.active_tag%TYPE,
      p_intm_name        GIIS_ASSURED.assd_name %TYPE,     --added by pjsantos @pcic 09/16/2016, for optimization GENQA 5667
      p_intm_no          GIIS_ASSURED_INTM.intm_no%type,   --added by pjsantos @pcic 09/16/2016, for optimization GENQA 5667
      p_str_assd_no      GIIS_ASSURED.assd_no%TYPE,        --added by pjsantos @pcic 09/16/2016, for optimization GENQA 5667
      p_order_by          VARCHAR2,  --added by pjsantos @pcic 09/16/2016, for optimization GENQA 5667
      p_asc_desc_flag     VARCHAR2,  --added by pjsantos @pcic 09/16/2016, for optimization GENQA 5667
      p_first_row         NUMBER,    --added by pjsantos @pcic 09/16/2016, for optimization GENQA 5667
      p_last_row          NUMBER     --added by pjsantos @pcic 09/16/2016, for optimization GENQA 5667
      )
      RETURN assured_names_list_tab_tg
      PIPELINED;

   /********************************** FUNCTION 4 ************************************
     MODULE: GIPIS002
     RECORD GROUP NAME: IN_ACCOUNT_OF
   ***********************************************************************************/

   TYPE in_account_of_list_type IS RECORD
   (
      assd_name     GIIS_ASSURED.assd_name%TYPE,
      assd_no       GIIS_ASSURED.assd_no%TYPE,
      active_tag    GIIS_ASSURED.active_tag%TYPE,
      industry_nm   GIIS_INDUSTRY.industry_nm%TYPE,
      mail_addr1    GIIS_ASSURED.mail_addr1%TYPE,
      mail_addr2    GIIS_ASSURED.mail_addr2%TYPE,
      mail_addr3    GIIS_ASSURED.mail_addr3%TYPE
   );

   TYPE in_account_of_list_tab IS TABLE OF in_account_of_list_type;

   FUNCTION get_in_account_of_list (
      p_assd_no       GIIS_ASSURED.assd_no%TYPE,
      p_in_acct_of    GIIS_ASSURED.assd_name%TYPE)
      RETURN in_account_of_list_tab
      PIPELINED;

   /********************************** FUNCTION 5 ************************************
     For Assured LOVs
   ***********************************************************************************/

   TYPE assd_lov_list_type IS RECORD
   (
      assd_name   GIIS_ASSURED.assd_name%TYPE,
      assd_no     GIIS_ASSURED.assd_no%TYPE
   );

   TYPE assd_lov_list_tab IS TABLE OF assd_lov_list_type;

   FUNCTION get_assd_lov_list
      RETURN assd_lov_list_tab
      PIPELINED;

   PROCEDURE get_assd_mailing_address (
      p_assd_no      IN     GIIS_ASSURED.assd_no%TYPE,
      p_mail_addr1      OUT GIIS_ASSURED.mail_addr1%TYPE,
      p_mail_addr2      OUT GIIS_ASSURED.mail_addr2%TYPE,
      p_mail_addr3      OUT GIIS_ASSURED.mail_addr3%TYPE);

   FUNCTION get_assd_name2 (p_assd_no IN GIIS_ASSURED.assd_no%TYPE)
      RETURN VARCHAR2;

   FUNCTION get_pol_doc_assd_name (
      p_acct_of_cd IN GIXX_POLBASIC.acct_of_cd%TYPE)
      RETURN VARCHAR2;

   FUNCTION check_assured_dependencies (p_assd_no NUMBER)
      RETURN VARCHAR2;

   PROCEDURE delete_giis_assured (p_assd_no NUMBER);

   FUNCTION get_assd_name_GIPIR913 (
      p_acct_of_cd    GIPI_POLBASIC.acct_of_cd%TYPE,
      p_label_tag     GIPI_POLBASIC.label_tag%TYPE)
      RETURN VARCHAR2;

   FUNCTION check_if_ref_no_exist (p_ref_no GIIS_ASSURED.reference_no%TYPE)
      RETURN VARCHAR2;
      
   FUNCTION check_if_ref_no_exist2 (
      p_ref_no GIIS_ASSURED.reference_no%TYPE, 
      p_assd_no GIIS_ASSURED.assd_no%TYPE)
      RETURN VARCHAR2;

   FUNCTION get_all_assd_list (p_keyword GIIS_ASSURED.assd_name%TYPE)
      RETURN assd_lov_list_tab
      PIPELINED;

   PROCEDURE validate_assd_no (
      p_assd_no     IN     GIIS_ASSURED.assd_no%TYPE,
      p_assd_name      OUT GIIS_ASSURED.assd_name%TYPE);

   FUNCTION validate_assd_no_giexs006 (p_assd_no giis_assured.assd_no%TYPE)
      RETURN giis_assured_tab
      PIPELINED;

   /**
    created by: Irwin Tabisora
  Date: 5.16.2012
  Description: checks if the assured is already existing
   */

   FUNCTION check_assured_exist_giiss006b (
      p_assd_name        IN giis_assured.assd_name%TYPE,
      p_last_name        IN giis_assured.last_name%TYPE,
      p_first_name       IN giis_assured.first_name%TYPE,
      p_middle_initial   IN giis_assured.middle_initial%TYPE,
      p_mail_addr1       IN giis_assured.mail_addr1%TYPE,
      p_mail_addr2       IN giis_assured.mail_addr2%TYPE,
      p_mail_addr3       IN giis_assured.mail_addr3%TYPE,
      p_assd_no          IN giis_assured.assd_no%TYPE)
      RETURN VARCHAR2;

   FUNCTION check_assured_exist_giiss006b2 (
      p_assd_name        IN giis_assured.assd_name%TYPE,
      p_last_name        IN giis_assured.last_name%TYPE,
      p_first_name       IN giis_assured.first_name%TYPE,
      p_middle_initial   IN giis_assured.middle_initial%TYPE,
      p_assd_no          IN giis_assured.assd_no%TYPE)
      RETURN VARCHAR2;

   FUNCTION giiss066b_post_query (p_assd_no IN giis_assured.assd_no%TYPE)
      RETURN VARCHAR2;

   TYPE assured_names_list_type2 IS RECORD
   (
      assd_name        GIIS_ASSURED.assd_name%TYPE,
      assd_no          GIIS_ASSURED.assd_no%TYPE,
      mail_addr1       GIIS_ASSURED.mail_addr1%TYPE,
      mail_addr2       GIIS_ASSURED.mail_addr2%TYPE,
      mail_addr3       GIIS_ASSURED.mail_addr3%TYPE,
      BILL_ADDR1       GIIS_ASSURED.BILL_ADDR1%TYPE,
      BILL_ADDR2       GIIS_ASSURED.BILL_ADDR2%TYPE,
      BILL_ADDR3       GIIS_ASSURED.BILL_ADDR3%TYPE,
      contact_pers     GIIS_ASSURED.contact_pers%TYPE,
      phone_no         GIIS_ASSURED.phone_no%TYPE,
      first_name       GIIS_ASSURED.first_name%TYPE,
      last_name        GIIS_ASSURED.last_name%TYPE,
      middle_initial   GIIS_ASSURED.middle_initial%TYPE
   );

   TYPE assured_names_list_tab2 IS TABLE OF assured_names_list_type2;

   FUNCTION get_giiss006b_exsiting_assd_tg (
      p_assd_name        IN giis_assured.assd_name%TYPE,
      p_last_name        IN giis_assured.last_name%TYPE,
      p_first_name       IN giis_assured.first_name%TYPE,
      p_middle_initial   IN giis_assured.middle_initial%TYPE,
      p_assd_no          IN giis_assured.assd_no%TYPE)
      RETURN assured_names_list_tab2
      PIPELINED;
      
   FUNCTION get_assured_details_list (p_keyword IN VARCHAR2)
      RETURN giis_assured_details_tab PIPELINED;
      
   --added by : Kenneth L. 07.16.2013 :for giacs286
    FUNCTION get_giacs286_assd_lov
     RETURN assd_lov_list_tab PIPELINED;
     
    FUNCTION get_gisms008_assd_lov (p_name VARCHAR2) 
      RETURN assd_lov_list_tab PIPELINED;

   FUNCTION get_giiss022_assured_lov(
      p_assured_name       giis_assured.assd_name%TYPE
   ) RETURN assured_names_list_tab PIPELINED;
      
   TYPE giiss006_intm_type IS RECORD (
     line_cd giis_assured_intm.line_cd%TYPE,
     intm_no giis_assured_intm.intm_no%TYPE,
     intm_name giis_intermediary.intm_name%TYPE
   );
   
   TYPE giiss006_intm_tab IS TABLE OF giiss006_intm_type; 
   
   FUNCTION get_giiss006_intm_list(
     p_assd_no giis_assured_intm.assd_no%TYPE,
     p_line_cd giis_assured_intm.line_cd%TYPE,
     p_intm_no giis_assured_intm.intm_no%TYPE,
     p_intm_name giis_intermediary.intm_name%TYPE
   ) RETURN giiss006_intm_tab PIPELINED;
   
   /* benjo 09.07.2016 SR-5604 */
   FUNCTION check_default_intm(
     p_assd_no giis_assured_intm.assd_no%TYPE,
     p_module_id giis_user_grp_modules.module_id%TYPE,
     p_user_id giis_users.user_id%TYPE
   ) RETURN VARCHAR2;
END Giis_Assured_Pkg;
/
