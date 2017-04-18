DROP PROCEDURE CPI.WHEN_CRE_REC_B540_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.When_Cre_Rec_B540_Gipis002
   (b240_par_id IN NUMBER,
    p_exist OUT NUMBER,
    b540_issue_yy OUT NUMBER,
    v_issue_param IN VARCHAR2,
    b540_issue_date IN DATE,
    b240_assd_no IN NUMBER,
    b540_dsp_assured_name OUT VARCHAR2,
    b540_address1 OUT VARCHAR2,
    b540_address2 OUT VARCHAR2,
    b540_address3 OUT VARCHAR2,
    b540_designation OUT VARCHAR2) IS 
BEGIN
 FOR A IN (
        SELECT   1
          FROM   GIPI_WPOLBAS
         WHERE   par_id  =  b240_par_id) LOOP
     p_exist  :=  1;
 END LOOP;
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
 IF p_exist IS NULL THEN
     FOR A1 IN (
       SELECT assd_name,mail_addr1,mail_addr2,mail_addr3,designation
         FROM GIIS_ASSURED
        WHERE assd_no = b240_assd_no) LOOP
          b540_dsp_assured_name  :=  A1.assd_name;
          b540_address1    :=  A1.mail_addr1;
          b540_address2    :=  A1.mail_addr2;
          b540_address3    :=  A1.mail_addr3;
          b540_designation :=  A1.designation;
          EXIT;
      END LOOP;
 ELSE
      NULL;
 END IF;
END;
/


