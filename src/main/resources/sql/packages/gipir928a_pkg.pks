CREATE OR REPLACE PACKAGE CPI.GIPIR928A_PKG
AS
     TYPE get_data_type IS RECORD(
                        iss_cd          gipi_uwreports_dist_peril_ext.iss_cd%type,
                        iss_cd_header   VARCHAR2(100),
                        line_cd         gipi_uwreports_dist_peril_ext.line_cd%type,
                        line_name       giis_line.line_name%type,
                        subline_cd      gipi_uwreports_dist_peril_ext.subline_cd%type,
                        subline_name    giis_subline.subline_name%type,
                        policy_no       gipi_uwreports_dist_peril_ext.policy_no%type,
                        peril_sname     VARCHAR2(50),
                        f_nr_dist_tsi   NUMBER(20,2),
                        f_tr_dist_tsi   NUMBER(20,2),
                        f_fa_dist_tsi   NUMBER(20,2),
                        nr_peril_tsi    NUMBER(20,2),
                        nr_peril_prem   NUMBER(20,2),
                        tr_peril_tsi    NUMBER(20,2),
                        tr_peril_prem   NUMBER(20,2),
                        fa_peril_tsi    NUMBER(20,2),
                        fa_peril_prem   NUMBER(20,2),
   /* CF_iss_name  */   iss_name        giis_issource.iss_name%TYPE,
   /* CF_iss_header */  iss_header      VARCHAR2(30),
   /* CF_based_on */    based_on        VARCHAR2(30),
   /* CF_toggle */      policy_label    VARCHAR2(30),
   /* CF_company_name*/ company_name    VARCHAR2(150), --steven 01.10.2013 nilakihan ko ung char niya
   /* CF_company_add*/  company_address VARCHAR2(500), --steven 01.10.2013 nilakihan ko ung char niya
   /* CF_report_nm */   reportnm        VARCHAR2(75),
   /* CF_from_date */   f_from          gipi_uwreports_dist_peril_ext.from_date1%TYPE,
   /* CF_to_date1 */    to_date1        gipi_uwreports_dist_peril_ext.to_date1%TYPE,
                        fromtodate      VARCHAR2(100)
   
    );
    TYPE gipir928a_tab IS TABLE OF get_data_type;
    TYPE get_subrecap_type IS RECORD(
                        ISS_CD1         gipi_uwreports_dist_peril_ext.iss_cd%TYPE,
                        line_cd1        gipi_uwreports_dist_peril_ext.line_cd%TYPE,
                        subline_cd2     gipi_uwreports_dist_peril_ext.subline_cd%TYPE,
                        peril_sname4    VARCHAR2(50),
                        f_nr_dist_tsi3  NUMBER(20,2),
                        f_tr_dist_tsi3  NUMBER(20,2),
                        f_fa_dist_tsi3  NUMBER(20,2),
                        nr_peril_tsi3   NUMBER(20,2),
                        nr_peril_prem3  NUMBER(20,2),
                        tr_peril_tsi3   NUMBER(20,2),
                        tr_peril_prem3  NUMBER(20,2),
                        fa_peril_tsi3   NUMBER(20,2),
                        fa_peril_prem3  NUMBER(20,2)
    );
    TYPE gipir928a_subline_recap_tab IS TABLE OF get_subrecap_type;
    TYPE get_linerecap_type IS RECORD(
                        iss_cd3         gipi_uwreports_dist_peril_ext.iss_cd%TYPE,
                        line_cd2        gipi_uwreports_dist_peril_ext.line_cd%TYPE,
                        peril_sname5    VARCHAR2(50),
                        f_nr_dist_tsi4  NUMBER(20,2),
                        f_tr_dist_tsi4  NUMBER(20,2),
                        f_fa_dist_tsi4  NUMBER(20,2),
                        nr_peril_tsi4   NUMBER(20,2),
                        nr_peril_prem4  NUMBER(20,2),
                        tr_peril_tsi4   NUMBER(20,2),
                        tr_peril_prem4  NUMBER(20,2),
                        fa_peril_tsi4   NUMBER(20,2),
                        fa_peril_prem4  NUMBER(20,2)
    );
    TYPE gipir928a_line_recap_tab IS TABLE OF get_linerecap_type;
    TYPE get_branchrecap_type IS RECORD(
                        iss_cd4           gipi_uwreports_dist_peril_ext.iss_cd%TYPE,
                        peril_sname1      VARCHAR(50),
                        f_nr_dist_tsi5    NUMBER(20,2),
                        f_tr_dist_tsi5    NUMBER(20,2),
                        f_fa_dist_tsi5    NUMBER(20,2),
                        nr_peril_tsi5     NUMBER(20,2),
                        nr_peril_prem5    NUMBER(20,2),
                        tr_peril_tsi5     NUMBER(20,2),
                        tr_peril_prem5    NUMBER(20,2),
                        fa_peril_tsi5     NUMBER(20,2),
                        fa_peril_prem5    NUMBER(20,2)
    );
    TYPE gipir928a_branch_recap_tab IS TABLE OF get_branchrecap_type;
    TYPE get_grandrecap_type IS RECORD(
                        peril_sname2     VARCHAR2(50),
                        f_nr_dist_tsi1    NUMBER(20,2),
                        f_tr_dist_tsi1    NUMBER(20,2),
                        f_fa_dist_tsi1    NUMBER(20,2),
                        nr_peril_tsi1     NUMBER(20,2),
                        nr_peril_prem1    NUMBER(20,2),
                        tr_peril_tsi1     NUMBER(20,2),
                        tr_peril_prem1    NUMBER(20,2),
                        fa_peril_tsi1     NUMBER(20,2),
                        fa_peril_prem1    NUMBER(20,2)
    );
    TYPE gipir928a_grand_recap_tab IS TABLE OF get_grandrecap_type;


    
  FUNCTION get_data(P_ISS_CD  gipi_uwreports_dist_peril_ext.iss_cd%type,
                    P_ISS_PARAM NUMBER, 
                    P_LINE_CD  gipi_uwreports_dist_peril_ext.line_cd%type, 
                    P_SCOPE NUMBER, 
                    P_SUBLINE_CD gipi_uwreports_dist_peril_ext.subline_cd%type,
                    p_user_id    gipi_uwreports_dist_peril_ext.user_id%TYPE)
  RETURN gipir928a_tab PIPELINED;  
  FUNCTION get_subrecap(P_ISS_CD  gipi_uwreports_dist_peril_ext.iss_cd%type, 
                          P_LINE_CD  gipi_uwreports_dist_peril_ext.line_cd%type, 
                          P_SUBLINE_CD gipi_uwreports_dist_peril_ext.subline_cd%type,
                          P_SCOPE  NUMBER,
                          P_ISS_PARAM NUMBER,
                          P_ISS_CD1 gipi_uwreports_dist_peril_ext.iss_cd%TYPE,
                          P_LINE_CD1 gipi_uwreports_dist_peril_ext.line_cd%TYPE, 
                          P_SUBLINE_CD1 gipi_uwreports_dist_peril_ext.subline_cd%TYPE,
                          p_user_id     gipi_uwreports_dist_peril_ext.user_id%TYPE)
  RETURN gipir928a_subline_recap_tab PIPELINED;
  FUNCTION get_linerecap (P_ISS_CD  gipi_uwreports_dist_peril_ext.iss_cd%TYPE, 
                          P_ISS_PARAM NUMBER,
                          P_LINE_CD  gipi_uwreports_dist_peril_ext.line_cd%TYPE, 
                          P_SCOPE NUMBER, 
                          P_SUBLINE_CD gipi_uwreports_dist_peril_ext.subline_cd%TYPE,
                          P_ISS_CD1 gipi_uwreports_dist_peril_ext.iss_cd%TYPE,
                          P_LINE_CD1 gipi_uwreports_dist_peril_ext.line_cd%TYPE,
                          p_user_id   gipi_uwreports_dist_peril_ext.user_id%TYPE)
  RETURN gipir928a_line_recap_tab PIPELINED;
  FUNCTION get_branchrecap (P_ISS_CD  gipi_uwreports_dist_peril_ext.iss_cd%TYPE, 
                        P_ISS_PARAM NUMBER,
                        P_LINE_CD  gipi_uwreports_dist_peril_ext.line_cd%TYPE, 
                        P_SCOPE NUMBER, 
                        P_SUBLINE_CD gipi_uwreports_dist_peril_ext.subline_cd%TYPE,
                        P_ISS_CD1 gipi_uwreports_dist_peril_ext.iss_cd%TYPE,
                        p_user_id   gipi_uwreports_dist_peril_ext.user_id%TYPE
                        --,P_ISS_CD_HEADER1 VARCHAR2
                        )
      RETURN gipir928a_branch_recap_tab PIPELINED;
  FUNCTION get_grandrecap (P_ISS_CD  gipi_uwreports_dist_peril_ext.iss_cd%type, 
                      P_ISS_PARAM NUMBER,
                      P_LINE_CD  gipi_uwreports_dist_peril_ext.line_cd%type, 
                      P_SCOPE NUMBER, 
                      P_SUBLINE_CD gipi_uwreports_dist_peril_ext.subline_cd%type,
                      p_user_id   gipi_uwreports_dist_peril_ext.user_id%TYPE)
      RETURN gipir928a_grand_recap_tab PIPELINED;
  FUNCTION CF_based_on(p_user_id   gipi_uwreports_dist_peril_ext.user_id%TYPE)
  RETURN Char;
END;
/


