CREATE OR REPLACE PACKAGE CPI.GIACR161_PKG
AS
   TYPE giacr161_record_type IS RECORD (
      company_name     VARCHAR2 (200),
      address          VARCHAR2 (300),
      branch_name      VARCHAR2 (250),
      upload_tag       VARCHAR2 (1),
      or_tag           VARCHAR2 (2),
      tran_date        DATE,
      tran_id          NUMBER (8),
      ref_class        VARCHAR2 (19),
      item_no          NUMBER (9),
      collection_amt   NUMBER (16, 2),
      assd_no          NUMBER (12),
      assured_name     VARCHAR2 (550),
      remarks          VARCHAR2 (4000),
      rev_tran_date    DATE,
      rev_ref_class    VARCHAR2 (34),
      rev_coll_amt     NUMBER (16, 2),
      rev_tran_id      NUMBER (8),
      balance          NUMBER (16, 2),
      from_date        DATE,
      TO_DATE          DATE,
      branch_cd        VARCHAR2 (2),
      cutoff_date      DATE,
      date_flag        VARCHAR2 (1),
      tran             VARCHAR2 (17),
      rev_tran         VARCHAR2 (17),
      dep_flag         VARCHAR2 (1),
      cutoff           VARCHAR2 (50),
      d_from           VARCHAR2 (50),
      d_to             VARCHAR2 (50),
      d_flag           VARCHAR2 (50),
      v_for_zero_bal   NUMBER
   );

   TYPE giacr161_record_tab IS TABLE OF giacr161_record_type;

   FUNCTION get_giacr161_records (
      p_assd_no     VARCHAR2,
      p_branch_cd   VARCHAR2,
      p_date_from   DATE,
      p_date_to     DATE,
      p_dep_flag    VARCHAR2,
      p_switch      VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN giacr161_record_tab PIPELINED;
END;
/


