DROP TRIGGER CPI.GIIS_ISSOURCE_TAIUD;

CREATE OR REPLACE TRIGGER CPI.GIIS_ISSOURCE_TAIUD
/*Modified by Edison 03.30.2012
**Adding, Updating and Deleting of records in Issuing Source
**Maintenance will update the record in Branch Maintenance.
*/
--DECLARE
     --PRAGMA AUTONOMOUS_TRANSACTION; --added by Edison 03.30.2012  --Commented out by PJD causing ORA-06519 error 05/06/2013
  AFTER INSERT OR DELETE OR UPDATE ON CPI.GIIS_ISSOURCE FOR EACH ROW
BEGIN
  --edison 03.30.2012 to disable first the trigger
  --EXECUTE IMMEDIATE 'ALTER TRIGGER CPI.GIAC_BRANCHES_TAIUX DISABLE';  --Commented out by PJD causing ORA-04080 error 05/06/2013
  --to avoid circular update between two tables                                                                     
  DECLARE
    ws_fund_cd         GIAC_SL_LISTS.fund_cd%TYPE    ;
    ws_sl_type_cd      GIAC_SL_LISTS.sl_type_cd%TYPE ;
    ws_sl_cd           GIAC_SL_LISTS.sl_cd%TYPE:= nvl(:NEW.acct_iss_cd,:OLD.acct_iss_cd);
    ws_sl_nm           GIAC_SL_LISTS.sl_name%TYPE:= nvl(:NEW.iss_name,:OLD.iss_name);
    ws_branch_cd       GIAC_BRANCHES.branch_cd%TYPE:=nvl(:NEW.iss_cd,:OLD.iss_cd);
    --added by Edison 03.30.2012
    ws_address1        GIAC_BRANCHES.address1%TYPE:=nvl(:NEW.address1,:OLD.address1);
    ws_address2        GIAC_BRANCHES.address2%TYPE:=nvl(:NEW.address2,:OLD.address2);
    ws_address3        GIAC_BRANCHES.address3%TYPE:=nvl(:NEW.address3,:OLD.address3);
    ws_tel_no          GIAC_BRANCHES.tel_no%TYPE:=nvl(:NEW.tel_no,:OLD.tel_no);
    ws_branch_tin      GIAC_BRANCHES.branch_tin%TYPE:=nvl(:NEW.branch_tin_cd,:OLD.branch_tin_cd);
    --end 03.30.2012
 BEGIN
    BEGIN
       SELECT param_value_v
         INTO ws_fund_cd
        FROM  giac_parameters
        WHERE param_name = 'FUND_CD';
        
      SELECT PARAM_VALUE_V
        INTO WS_SL_TYPE_CD
        FROM GIAC_PARAMETERS
       WHERE PARAM_NAME = 'BRANCH_SL_TYPE';
    EXCEPTION
       WHEN no_data_found THEN
         RAISE_APPLICATION_ERROR(-20009, 'No records in PARAMETERS table.');
    END;
    IF  updating  THEN
     UPDATE giac_sl_lists
           SET sl_name = ws_sl_nm
         WHERE fund_cd    = ws_fund_cd
           AND sl_type_cd = ws_sl_type_cd
           AND sl_cd      = ws_sl_cd;

        UPDATE giac_branches
         SET branch_name    = ws_sl_nm,
             acct_branch_cd = ws_sl_cd,
             remarks        = 'Updated by the system after update of the ISSUING SOURCE table.',
             address1       = ws_address1, --added by
             address2       = ws_address2, --Edison
             address3       = ws_address3, --03.30.2012
             tel_no         = ws_tel_no,   --for additional 
             branch_tin     = ws_branch_tin--column updates
        WHERE gfun_fund_cd = ws_fund_cd
            AND branch_cd    = ws_branch_cd ;
    ELSIF inserting  THEN
      INSERT INTO giac_sl_lists (fund_cd,
                              sl_type_cd,
    sl_cd,
    sl_name,
    remarks,
    user_id,
    last_update)
                   VALUES (ws_fund_cd,
             ws_sl_type_cd,
          ws_sl_cd,
          ws_sl_nm,
                   'Generated by the system after insert on ISSUING SOURCE table.',
                   NVL (giis_users_pkg.app_user, USER),
          sysdate);
       INSERT INTO giac_branches (gfun_fund_cd,
           branch_cd,
          acct_branch_cd,
          branch_name,
           user_id,
          last_update,
          remarks,
          address1,   --added by
          address2,   --Edison 
          address3,   --03.30.2012
          tel_no,     --additional column
          branch_tin) --for records to insert
                    VALUES (ws_fund_cd,
           ws_branch_cd,
           ws_sl_cd,
           ws_sl_nm,
           NVL (giis_users_pkg.app_user, USER),
           sysdate,
           'Generated by the system after insert on ISSUING SOURCE table.',
           ws_address1,   --added by
           ws_address2,   --Edison 
           ws_address3,   --03.30.2012
           ws_tel_no,     --additional column
           ws_branch_tin);--for records to insert
    --added by Edison 04.02.2012 to update the record in Branch 
    --Maintenance when the record will be deleted.
    ELSIF deleting THEN
        DELETE 
          FROM giac_branches
         WHERE gfun_fund_cd = ws_fund_cd
           AND branch_cd    = ws_branch_cd;
    --end 04.02.2012   
    --added by PJD 05/06/2013
        DELETE 
          FROM giac_sl_lists
         WHERE fund_cd    = ws_fund_cd     
           AND sl_type_cd = ws_sl_type_cd  
           AND sl_cd      = ws_sl_cd; 
    --end 05/06/2013 
    END IF;   
  END;
  ---EXECUTE IMMEDIATE 'ALTER TRIGGER CPI.GIAC_BRANCHES_TAIUX ENABLE';--Edison 03.30.2012 to enable the trigger
     --Commented out by PJD causing ORA-04080 error 05/06/2013
END;
/

