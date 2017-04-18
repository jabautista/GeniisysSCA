CREATE OR REPLACE PACKAGE CPI.giacr274_pkg
AS
/*
** Created by : Benedict G. Castillo
** Date Created : 07.11.2013
** Description : GIACR274_PKG-LIST OF BINDERS ATTACHED TO REDISTRIBUTED RECORDS
*/
   TYPE giacr274_type IS RECORD (
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (400),
      flag              VARCHAR2 (2),
      branch            VARCHAR2 (100),
      line_name         VARCHAR2 (100),
      counter           NUMBER (5),
      policy_no         giac_redist_binders_ext.policy_no%TYPE,
      dist_no1          giac_redist_binders_ext.dist_no%TYPE,
      dist_no2          giac_redist_binders_ext.dist_no%TYPE,
      dist_no3          giac_redist_binders_ext.dist_no%TYPE,
      policy_id         giac_redist_binders_ext.policy_id%TYPE,
      iss_cd            giac_redist_binders_ext.iss_cd%TYPE,
      line_cd           giac_redist_binders_ext.line_cd%TYPE
   );

   TYPE giacr274_tab IS TABLE OF giacr274_type;

   FUNCTION populate_giacr274 (p_iss_cd VARCHAR2, p_line_cd VARCHAR2)
      RETURN giacr274_tab PIPELINED;

   TYPE column_type IS RECORD (
      max_count   NUMBER (5),
      flag        VARCHAR2 (2)
   );

   TYPE column_tab IS TABLE OF column_type;

   FUNCTION populate_column_title (
      p_iss_cd    VARCHAR2,
      p_line_cd   VARCHAR2,
      p_user_id   VARCHAR2
   )
      RETURN column_tab PIPELINED;

   TYPE giacr274_details_type IS RECORD (
      dist_no     giac_redist_binders_ext.dist_no%TYPE,
      binder_no   giac_redist_binders_ext.binder_no%TYPE,
      ri_name     VARCHAR2 (200),
      prem_amt    giac_redist_binders_ext.prem_amt%TYPE,
      comm_amt    giac_redist_binders_ext.comm_amt%TYPE,
      policy_id   giac_redist_binders_ext.policy_id%TYPE,
      paid_amt    giac_redist_binders_ext.paid_amt%TYPE
   );

   TYPE giacr274_details_tab IS TABLE OF giacr274_details_type;

   FUNCTION populate_giacr274_details (
      p_iss_cd      VARCHAR2,
      p_line_cd     VARCHAR2,
      p_user_id     VARCHAR2,
      p_policy_id   NUMBER,
      p_dist_no     NUMBER
   )
      RETURN giacr274_details_tab PIPELINED;
END giacr274_pkg;
/


