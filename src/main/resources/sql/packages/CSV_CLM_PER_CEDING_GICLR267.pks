CREATE OR REPLACE PACKAGE CSV_CLM_PER_CEDING_GICLR267 AS
/*
**  Created by   : Bernadette Quitain
**  Date Created : 03.28.2016
**  Reference By : GICLR267 - Claim Listing per Ceding Company
*/

   TYPE report_type IS RECORD (
      ceding_company           GIIS_REINSURER.RI_NAME%TYPE,
      policy_number            VARCHAR2 (100),
      claim_number             VARCHAR2 (100), 
      assured                  GICL_CLAIMS.ASSURED_NAME%TYPE,
      loss_date                VARCHAR2 (15),
      file_date                VARCHAR2 (15),
      claim_status             VARCHAR2 (100),  
      loss_reserve             VARCHAR2 (50),
      losses_paid              VARCHAR2 (50),
      expense_reserve          VARCHAR2 (50),
      expenses_paid            VARCHAR2 (50)
   );
   
   TYPE report_tab IS TABLE OF report_type;

  FUNCTION CSV_GICLR267 (
      p_user_id         VARCHAR2,
      p_ri_cd           VARCHAR2,
      p_from_date       VARCHAR2,
      p_to_date         VARCHAR2,
      p_as_of_date      VARCHAR2,
      p_from_ldate      VARCHAR2,
      p_to_ldate        VARCHAR2,
      p_as_of_ldate     VARCHAR2
   )
      RETURN report_tab PIPELINED;
END;
/
