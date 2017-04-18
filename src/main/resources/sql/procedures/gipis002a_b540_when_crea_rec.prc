DROP PROCEDURE CPI.GIPIS002A_B540_WHEN_CREA_REC;

CREATE OR REPLACE PROCEDURE CPI.GIPIS002A_B540_WHEN_CREA_REC
   (v_issue_param           IN VARCHAR2,
    b540_issue_date         IN DATE,
    b240_assd_no            IN NUMBER,
	b540_issue_yy           OUT NUMBER,
    b540_assured_name       OUT VARCHAR2,
    b540_address1           OUT VARCHAR2,
    b540_address2           OUT VARCHAR2,
    b540_address3           OUT VARCHAR2,
    b540_designation        OUT VARCHAR2) IS 

BEGIN
 FOR A1 IN (
       SELECT TO_NUMBER(TO_CHAR(SYSDATE,'YY'))  ISS_YY
         FROM DUAL) 
 LOOP
     b540_issue_yy  :=  A1.ISS_YY;
     EXIT;
 END LOOP;
         
 IF UPPER(v_issue_param) = 'ISSUE_DATE' THEN
    b540_issue_yy  := TO_NUMBER(SUBSTR(TO_CHAR(b540_issue_date,'MM-DD-YYYY'),9,2));
 END IF;
 
 FOR A1 IN (
   SELECT assd_name,mail_addr1,mail_addr2,mail_addr3,designation
     FROM GIIS_ASSURED
    WHERE assd_no = b240_assd_no) LOOP
      b540_assured_name  :=  A1.assd_name;
      b540_address1      :=  A1.mail_addr1;
      b540_address2      :=  A1.mail_addr2;
      b540_address3      :=  A1.mail_addr3;
      b540_designation   :=  A1.designation;
      EXIT;
 END LOOP;

END;
/


