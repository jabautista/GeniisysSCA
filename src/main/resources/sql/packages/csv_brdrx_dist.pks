CREATE OR REPLACE PACKAGE CPI.CSV_BRDRX_DIST AS
  PROCEDURE CSV_GICLR205E(p_session_id   VARCHAR2,
                          p_claim_id     VARCHAR2,
                          p_intm_break   NUMBER,
                          p_file_name    VARCHAR2);
  PROCEDURE CSV_GICLR205L(p_session_id   VARCHAR2,
                          p_claim_id     VARCHAR2,
                          p_intm_break   NUMBER,
                          p_file_name    VARCHAR2);  
  PROCEDURE CSV_GICLR205LE(p_session_id  VARCHAR2,
                           p_claim_id    VARCHAR2,
                           p_intm_break  NUMBER,
                           p_file_name   VARCHAR2);
  PROCEDURE CSV_GICLR206L(p_session_id   VARCHAR2,
               			  p_claim_id     VARCHAR2,
               			  p_intm_break   NUMBER,
      					  p_paid_date    VARCHAR2,
      					  p_from_date    VARCHAR2,
      					  p_to_date      VARCHAR2,
						  p_file_name	 VARCHAR2);						   
  PROCEDURE CSV_GICLR206E(p_session_id   VARCHAR2,
               			  p_claim_id     VARCHAR2,
               			  p_intm_break   NUMBER,
      					  p_paid_date    VARCHAR2,
      					  p_from_date    VARCHAR2,
      					  p_to_date      VARCHAR2,
						  p_file_name	 VARCHAR2);						   
  PROCEDURE CSV_GICLR206LE(p_session_id  VARCHAR2,
               			   p_claim_id    VARCHAR2,
               			   p_intm_break  NUMBER,
      					   p_paid_date   VARCHAR2,
      					   p_from_date   VARCHAR2,
      					   p_to_date     VARCHAR2,
						   p_file_name	 VARCHAR2);	
  PROCEDURE CSV_GICLR222L(p_session_id   VARCHAR2,
               			  p_claim_id     VARCHAR2,
      					  p_paid_date    VARCHAR2,
      					  p_from_date    VARCHAR2,
      					  p_to_date      VARCHAR2,
						  p_file_name	 VARCHAR2);		                           
  PROCEDURE CSV_GICLR222E(p_session_id   VARCHAR2,
               			  p_claim_id     VARCHAR2,
      					  p_paid_date    VARCHAR2,
      					  p_from_date    VARCHAR2,
      					  p_to_date      VARCHAR2,
						  p_file_name	 VARCHAR2);		                           
  PROCEDURE CSV_GICLR222LE(p_session_id  VARCHAR2,
               			  p_claim_id     VARCHAR2,
      					  p_paid_date    VARCHAR2,
      					  p_from_date    VARCHAR2,
      					  p_to_date      VARCHAR2,
						  p_file_name	 VARCHAR2);                           					   
  PROCEDURE CSV_GICLR221L(p_session_id   VARCHAR2,
               			  p_claim_id     VARCHAR2,
      					  p_paid_date    VARCHAR2,
      					  p_from_date    VARCHAR2,
      					  p_to_date      VARCHAR2,
						  p_file_name	 VARCHAR2);		                           
  PROCEDURE CSV_GICLR221E(p_session_id   VARCHAR2,
               			  p_claim_id     VARCHAR2,
      					  p_paid_date    VARCHAR2,
      					  p_from_date    VARCHAR2,
      					  p_to_date      VARCHAR2,
						  p_file_name	 VARCHAR2);		                           
  PROCEDURE CSV_GICLR221LE(p_session_id  VARCHAR2,
               			  p_claim_id     VARCHAR2,
      					  p_paid_date    VARCHAR2,
      					  p_from_date    VARCHAR2,
      					  p_to_date      VARCHAR2,
						  p_file_name	 VARCHAR2);  
  PROCEDURE CSV_GICLR208A(p_session_id   VARCHAR2,
                          p_claim_id     VARCHAR2,
                          p_intm_break   NUMBER,
                          p_iss_break    NUMBER,
                          p_file_name    VARCHAR2);                                               					   
  PROCEDURE CSV_GICLR208B(p_session_id   VARCHAR2,
                          p_claim_id     VARCHAR2,
                          p_intm_break   NUMBER,
                          p_iss_break    NUMBER,
                          p_file_name    VARCHAR2); 
  PROCEDURE CSV_GICLR209A(p_session_id   VARCHAR2,
                          p_claim_id     VARCHAR2,
                          p_intm_break   NUMBER,
                          p_iss_break    NUMBER,
                          p_file_name    VARCHAR2);                                               					   
  PROCEDURE CSV_GICLR209B(p_session_id   VARCHAR2,
                          p_claim_id     VARCHAR2,
                          p_intm_break   NUMBER,
                          p_iss_break    NUMBER,
                          p_file_name    VARCHAR2);                                                                      					   
END;
/


