CREATE OR REPLACE PACKAGE CPI.csv_brdrx_dynamic
AS
   TYPE csv_dynamicsql IS RECORD (
      query1   VARCHAR2 (4000),
      query2   VARCHAR2 (4000), 
      query3   VARCHAR2 (4000),
      query4   VARCHAR2 (4000), 
      query5   VARCHAR2 (4000), 
      query6   VARCHAR2 (4000),
      query7   VARCHAR2 (4000), 
      query8   VARCHAR2 (4000)
   );

   TYPE csv_dynamicsql_tab IS TABLE OF csv_dynamicsql;

   FUNCTION csv_giclr206le_dynsql (
      p_session_id   VARCHAR2, 
      p_claim_id     VARCHAR2, 
      p_intm_break   NUMBER, 
      p_paid_date    VARCHAR2, 
      p_from_date    VARCHAR2, 
      p_to_date      VARCHAR2
   )
      RETURN csv_dynamicsql_tab PIPELINED;
      
   FUNCTION csv_giclr205le_dynsql (
      p_session_id   VARCHAR2,
      p_claim_id     VARCHAR2,
      p_intm_break   NUMBER
   )
      RETURN csv_dynamicsql_tab PIPELINED;
      
   FUNCTION csv_giclr222l_dynsql (
      p_session_id    GICL_RES_BRDRX_DS_EXTR.SESSION_ID%type,
      p_claim_id      VARCHAR2,
      p_paid_date     NUMBER,
      p_from_date     DATE,
      p_to_date       DATE
   )
      RETURN csv_dynamicsql_tab PIPELINED;
      
   FUNCTION csv_giclr221le(
      p_session_id   VARCHAR2,
      p_claim_id     VARCHAR2,
      p_paid_date    VARCHAR2,
      p_from_date2   VARCHAR2,
      p_to_date2     VARCHAR2
   )
      RETURN csv_dynamicsql_tab PIPELINED;
      
   FUNCTION csv_giclr221l_dynsql (
      p_session_id   VARCHAR2,
      p_claim_id     VARCHAR2,
      p_paid_date    VARCHAR2,
      p_from_date2   VARCHAR2,
      p_to_date2     VARCHAR2
   )
      RETURN csv_dynamicsql_tab PIPELINED;
      
      --Added by Carlo Rubenecia 05.17.2016 SR - 5368 START
   FUNCTION csv_giclr222le_dynsql (
      p_session_id   VARCHAR2,
      p_claim_id     VARCHAR2,
      p_paid_date    VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2
   )
      RETURN csv_dynamicsql_tab PIPELINED;
   --Added by Carlo Rubenecia 05.17.2016 SR-5368 END
   
    --Added by Carlo Rubenecia 05.16.2016 SR - 5367 START
   FUNCTION csv_giclr222e_dynsql(
      p_session_id   VARCHAR2, 
      p_claim_id     VARCHAR2, 
      p_paid_date    VARCHAR2, 
      p_from_date    VARCHAR2, 
      p_to_date      VARCHAR2
   )
      RETURN csv_dynamicsql_tab PIPELINED;
   --Added by Carlo Rubenecia 05.16.2016 SR 5367 END
   --SR-5364
   FUNCTION csv_giclr221e_dynsql (
      p_session_id   VARCHAR2,
      p_claim_id     VARCHAR2,
      p_paid_date    VARCHAR2,
      p_from_date2   VARCHAR2,
      p_to_date2     VARCHAR2
   )
      RETURN csv_dynamicsql_tab PIPELINED;
   --END
END;
/
