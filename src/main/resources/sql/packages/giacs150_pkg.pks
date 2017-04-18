CREATE OR REPLACE PACKAGE CPI.GIACS150_PKG
AS
   PROCEDURE age_bills(
      p_cut_off         IN VARCHAR2,
      p_direct          IN VARCHAR2,
      p_reinsurance     IN VARCHAR2,
      p_user_id         IN GIIS_USERS.user_id%TYPE
   );
   
   PROCEDURE age_bills_direct(
      p_cut_off         IN DATE
   );
   
   PROCEDURE age_bills_fc(
      p_cut_off         IN DATE
   );
   
   PROCEDURE age_bills_reinsurance(
      p_cut_off         IN DATE
   );
   
   PROCEDURE age_bills(
      p_cut_off         IN DATE,
      p_user_id         IN GIIS_USERS.user_id%TYPE
   );
   
   PROCEDURE age_bills_ri(
      p_cut_off         IN DATE,
      p_user_id         IN GIIS_USERS.user_id%TYPE
   );
   
END GIACS150_PKG;
/


