CREATE OR REPLACE PACKAGE CPI.giacr101_pkg
AS
   TYPE giacr101_type IS RECORD (
      company_name    VARCHAR2 (100),
      company_add     giac_parameters.param_value_v%TYPE,
      date_range      VARCHAR2 (100),
      flag            VARCHAR2 (2),
      iss_cd1         giis_issource.iss_cd%TYPE,
      iss_cd          giis_issource.iss_cd%TYPE,
      iss_name        giis_issource.iss_name%TYPE,
      line_name       giis_line.line_name%TYPE,
      subline_name    giis_subline.subline_name%TYPE,
      POLICY          VARCHAR2 (50),
      incept_date     VARCHAR2 (50),
      expiry_date     VARCHAR2 (50),
      total_tsi       NUMBER (16, 2),
      evat            NUMBER (16, 2),
      prem_tax        NUMBER (16, 2),
      fst             NUMBER (16, 2),
      lgt             NUMBER (16, 2),
      doc_stamps      NUMBER (16, 2),
      other_taxes     NUMBER (16, 2),
      total_tax       NUMBER (16, 2),
      total_premium   NUMBER (16, 2)
   );

   TYPE giacr101_tab IS TABLE OF giacr101_type;

   FUNCTION populate_giacr101 (
      p_from_date     DATE,
      p_to_date       DATE,
      p_module_id     VARCHAR2,
      p_user_id       VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_line_cd       VARCHAR2,
      p_subline_cd    VARCHAR2,
      p_branch_type   VARCHAR2
   )
      RETURN giacr101_tab PIPELINED;
END giacr101_pkg;
/


