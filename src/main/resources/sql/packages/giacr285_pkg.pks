CREATE OR REPLACE PACKAGE CPI.giacr285_pkg
AS
   /*
   Created by: John Carlo M. Brigino
   October 15, 2012
   */
   TYPE giacr285_premium_coll_type IS RECORD (
      company_name      VARCHAR (2000),
      company_address   VARCHAR (2000),
      from_to           VARCHAR (2000),
      iss_cd            GIIS_ISSOURCE.ISS_CD%TYPE, -- added by Daniel Marasigan SR 5532 07.08.2016
      iss_source        GIIS_ISSOURCE.ISS_NAME%TYPE, -- added by Daniel Marasigan SR 5532 07.08.2016
      iss_name          VARCHAR (2000),
      branch_cd         GIAC_ORDER_OF_PAYTS.GIBR_BRANCH_CD%TYPE, -- added by Daniel Marasigan SR 5532 07.08.2016
      branch_name       VARCHAR (2000),
      gacc_tran_id      NUMBER,
      or_no             VARCHAR (2000),
      payor             VARCHAR (2000),
      particulars       VARCHAR (2000),
      pay_mode          VARCHAR (2000),
      check_no          VARCHAR (2000),
      collection_amt    NUMBER (12, 2),
      intm_no           VARCHAR (2000),
      intm_name         VARCHAR2 (2000), -- added by Daniel Marasigan SR 5532 07.08.2016
      policy_no         VARCHAR (2000),
      bill_no           VARCHAR (2000),
      premium_amt       NUMBER (12, 2),
      tax_amt           NUMBER (12, 2),
      commission_amt    NUMBER (12, 2),
      input_vat_amt     NUMBER (12, 2)
   );

   TYPE giacr285_premium_coll_tab IS TABLE OF giacr285_premium_coll_type;

   FUNCTION get_giacr285_details (
      p_branch_cd   giac_colln_batch.branch_cd%TYPE,
      p_date        NUMBER,
      p_from_date   giac_colln_batch.tran_date%TYPE,
      p_to_date     giac_colln_batch.tran_date%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN giacr285_premium_coll_tab PIPELINED;
END;
/
