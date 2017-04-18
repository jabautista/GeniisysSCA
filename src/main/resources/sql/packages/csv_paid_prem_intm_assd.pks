CREATE OR REPLACE PACKAGE cpi.csv_paid_prem_intm_assd
AS
   /* Created by: Nestor 05/06/2010, Generate CSV in GIACS286 - PAID PREMIUM PER INTERMEDIARY/ASSURED REPORT */

   TYPE giacr286_rec_type IS RECORD
   (
      branch        VARCHAR2 (25),
      line          VARCHAR2 (25),
      --intm          VARCHAR2 (515), -- jhing GENQA 5298 separated intm into intm_no, intm_name, ref_intm_cd for easy sorting,identifying
      intm_no       giis_intermediary.intm_no%TYPE,
      intm_name     giis_intermediary.intm_name%TYPE,
      ref_intm_cd   giis_intermediary.ref_intm_cd%TYPE,
      ref_date      DATE,
     -- ref_no        giac_premium_colln_v.ref_no%TYPE,-- jhing GENQA 5298,5299
      ref_no        VARCHAR2(500),
      policy_no     VARCHAR2 (50),
      assd_name     giis_assured.assd_name%TYPE,
      incept_date   gipi_polbasic.incept_date%TYPE,
      bill_no       VARCHAR2 (20),  -- jhing GENQA 5298 changed from 15, 50 
      coll_amt      giac_premium_colln_v.collection_amt%TYPE,
      prem_amt      giac_premium_colln_v.premium_amt%TYPE,
      tax_amt       giac_premium_colln_v.tax_amt%TYPE
   );

   TYPE giacr286_type IS TABLE OF giacr286_rec_type;

   TYPE giacr287_rec_type IS RECORD
   (
      branch            VARCHAR2 (25),
      line              VARCHAR2 (25),
      assured           VARCHAR2 (515),
      prem_ref_date     DATE,
      prem_ref_no       giac_premium_colln_v.ref_no%TYPE,
      policy_no         VARCHAR2 (50),
      intm_name         giis_intermediary.intm_name%TYPE,
      incept_date       gipi_polbasic.incept_date%TYPE,
      bill_no           VARCHAR2 (15),
      coll_amt          giac_premium_colln_v.collection_amt%TYPE,
      prem_amt          giac_premium_colln_v.premium_amt%TYPE,
      tax_amt           giac_premium_colln_v.tax_amt%TYPE,
      comm_ref_date     DATE,
      comm_ref_no       giac_comm_paid_v.comm_ref_no%TYPE,
      comm_amt_pd       giac_comm_paid_v.comm_amt%TYPE,
      tax_comm_amt_pd   giac_comm_paid_v.wtax_amt%TYPE
   );

   TYPE giacr287_type IS TABLE OF giacr287_rec_type;

   -- jhing added type GENQA 5298,5299
   TYPE giacr287_rec_type2 IS RECORD
   (
      branch_cd         giac_branches.branch_cd%TYPE,
      branch_name       giac_branches.branch_name%TYPE,
      line_cd           giis_line.line_cd%TYPE,
      line_name         giis_line.line_name%TYPE,
      assd_no           giis_assured.assd_no%TYPE,
      assured           giis_assured.assd_name%TYPE,
      prem_ref_date     DATE,
      prem_ref_no       VARCHAR2 (500),
      policy_no         VARCHAR2 (50),
      intm_name         giis_intermediary.intm_name%TYPE,
      incept_date       gipi_polbasic.incept_date%TYPE,
      bill_no           VARCHAR2 (100),
      coll_amt          giac_premium_colln_v.collection_amt%TYPE,
      prem_amt          giac_premium_colln_v.premium_amt%TYPE,
      tax_amt           giac_premium_colln_v.tax_amt%TYPE,
      comm_ref_date     DATE,
      comm_ref_no       VARCHAR2 (500),
      comm_amt_pd       giac_comm_paid_v.comm_amt%TYPE,
      tax_comm_amt_pd   giac_comm_paid_v.wtax_amt%TYPE
   );

   TYPE giacr287_type2 IS TABLE OF giacr287_rec_type2;

   FUNCTION csv_giacr286 (
      p_intm_no          gipi_comm_invoice.intrmdry_intm_no%TYPE,
      p_branch_cd        giac_premium_colln_v.branch_cd%TYPE,
      p_cut_off_param    VARCHAR2,
      p_from_date        DATE,
      p_line_cd          gipi_polbasic.line_cd%TYPE,
      p_to_date          DATE,
      p_user_id          VARCHAR2     -- jhing added p_user_id GENQA 5298,5299
                                 )
      RETURN giacr286_type
      PIPELINED;

   FUNCTION csv_giacr287_old (
      p_assd_no          giis_assured.assd_no%TYPE,
      p_branch_cd        giac_premium_colln_v.branch_cd%TYPE,
      p_cut_off_param    VARCHAR2,
      p_from_date        DATE,
      p_line_cd          gipi_polbasic.line_cd%TYPE,
      p_to_date          DATE,
      p_user_id          VARCHAR2     -- jhing added p_user_id GENQA 5298,5299
                                 )
      RETURN giacr287_type
      PIPELINED;

   -- jhing GENQA 5298,5299 redesigned CSV function to address findings of preliminary testing
   FUNCTION csv_giacr287 (p_assd_no          giis_assured.assd_no%TYPE,
                          p_branch_cd        giac_premium_colln_v.branch_cd%TYPE,
                          p_cut_off_param    VARCHAR2,
                          p_from_date        DATE,
                          p_line_cd          gipi_polbasic.line_cd%TYPE,
                          p_to_date          DATE,
                          p_user_id          VARCHAR2 -- jhing added p_user_id GENQA 5298,5299
                                                     )
      RETURN giacr287_type2
      PIPELINED;

   FUNCTION get_branch_withaccess (p_module_id VARCHAR2, p_user_id VARCHAR2)
      RETURN VARCHAR2;
END;
/