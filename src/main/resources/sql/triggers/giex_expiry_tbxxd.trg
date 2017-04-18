DROP TRIGGER CPI.GIEX_EXPIRY_TBXXD;

CREATE OR REPLACE TRIGGER CPI.GIEX_EXPIRY_TBXXD  
BEFORE DELETE  
ON CPI.GIEX_EXPIRY  
FOR EACH ROW
BEGIN  
  INSERT INTO GIEX_EXPIRY_TRACE (  
    policy_id,    expiry_date,  renew_flag,   line_cd,  
	subline_cd,   iss_cd,   	post_flag,    extract_user,  
	extract_date, tsi_amt,      prem_amt,     issue_yy,  
	pol_seq_no,   renew_no,     user_id,      last_update)  
 VALUES (  
   :OLD.policy_id,    :OLD.EXPIRY_DATE, :OLD.RENEW_FLAG, :OLD.LINE_CD,  
   :OLD.SUBLINE_CD,   :OLD.ISS_CD,      :OLD.POST_FLAG,  :OLD.EXTRACT_USER,  
   :OLD.EXTRACT_DATE, :OLD.TSI_AMT,     :OLD.PREM_AMT,   :OLD.ISSUE_YY,  
   :OLD.POL_SEQ_NO,   :OLD.RENEW_NO,    USER,			 SYSDATE);  
END;
/


