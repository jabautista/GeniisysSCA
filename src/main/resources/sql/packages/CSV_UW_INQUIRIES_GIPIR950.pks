CREATE OR REPLACE PACKAGE CSV_UW_INQUIRIES_GIPIR950 AS
/*
**  Created by   : Bernadette Quitain
**  Date Created : 03.28.2016
**  Reference By : GIPIR950 - Risk Category
*/
   TYPE gipir950_type IS RECORD (
      category             VARCHAR2 (50),
      sub_category_desc    VARCHAR2 (50),
      risk                 VARCHAR2 (50),
      risk_pct_total       VARCHAR2 (100),
      premium              VARCHAR2 (50),
      premium_pct_total    VARCHAR2 (100),
      ave_rate             VARCHAR2 (100)
   
   );

   TYPE gipir950_tab IS TABLE OF gipir950_type;

   FUNCTION csv_gipir950 (
      p_date_basis   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_user_id      VARCHAR2
   )
      RETURN gipir950_tab PIPELINED;
END;