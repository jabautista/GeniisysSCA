CREATE OR REPLACE PACKAGE CPI.CSV_OS_RECOVERY_GICLR201
AS
    /*
     **  Created by   : Mary Cris Invento
     **  Date Created : 03.29.2016
     **  Reference By : GICLR202
     **  Description  : Outstanding Claim Recoveries
     **  SR No.:      : 5398
     */
   TYPE report_type IS RECORD (
      claim_number          VARCHAR2 (100),
      policy_number         VARCHAR2 (100),
      assured               GIIS_ASSURED.ASSD_NAME%TYPE,
      loss_date             VARCHAR2 (20),
      file_date             VARCHAR2 (20),
      recovery_number       VARCHAR2 (100),
      recovery_type         VARCHAR2 (100),
      recovery_status       VARCHAR2 (100),
      lawyer                VARCHAR2 (850),
      recoverable_amount    VARCHAR2(50)
   );
   
   TYPE report_tab IS TABLE OF report_type;

  FUNCTION CSV_GICLR202 (
      p_as_of_date      VARCHAR2,
      p_line_cd         VARCHAR2,
      p_iss_cd          VARCHAR2,
      p_rec_type_cd     VARCHAR2
   )
      RETURN report_tab PIPELINED; 
END;
/