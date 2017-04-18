DROP PROCEDURE CPI.CHECK_MANUAL_ACCT_ENTRY;

CREATE OR REPLACE PROCEDURE CPI.CHECK_MANUAL_ACCT_ENTRY (
    p_tran_id          IN      GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
    p_user             IN      GIIS_USERS.user_id%TYPE,
    p_mesg             OUT     VARCHAR2,
    p_valid_user       OUT     VARCHAR2,
    p_manual           OUT     VARCHAR2
) IS
    v_tran_class						   giac_acctrans.tran_class%TYPE;
    v_tran_flag							   giac_acctrans.tran_flag%TYPE;
    v_tran_status						   varchar2(10);
    v_manual                               giac_parameters.param_value_v%TYPE := 'N';--added defaut value reymon 04292013
BEGIN

      /*
      **  Created by   :  D.Alcantara
      **  Date Created :  04.25.2011 
      **  Reference By : (GIACS030 - Accounting Entries)   
      **  Description  :  identifies if the accounting entry is editable
      */ 

    p_mesg := 'YES';
	BEGIN
		SELECT TRAN_CLASS, TRAN_FLAG 
          INTO v_tran_class, v_tran_flag
    	  FROM GIAC_ACCTRANS
    	 WHERE TRAN_ID = p_tran_id; 
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			v_tran_class := null;
        	v_tran_flag := null;
	END;
	--remove by steven 1/7/2013 may exception na sa taas... base on SR 0011813
     --exception when no_data_found then -- added by irwin 
    --v_tran_class := null;
    --v_tran_flag := null;
	
    IF v_tran_flag = 'O' THEN
        IF v_tran_class = 'COL' THEN
            SELECT PARAM_VALUE_V
              INTO v_manual
              FROM GIAC_PARAMETERS
             WHERE PARAM_NAME ='ALLOW_MANUAL_ACCTG_ENTRY';
                     
            IF v_manual = 'Y' THEN
                p_valid_user := GIAC_VALIDATE_USER_FN(nvl(p_user, USER),'MA','GIACS030');
                p_manual := v_manual;
            ELSE
                p_manual := 'Creation of manual accounting entries is not allowed.';
            END IF;
        ELSE
             --added by reymon 04292013
            p_valid_user := 'TRUE';
            p_manual := 'Y';
        END IF;
                
        /*
        ** Commented out and move by reymon 04292013
        ** as per checking to cs version
        ** only col transaction has validation of manual entry
        IF v_manual = 'Y' THEN
            p_valid_user := GIAC_VALIDATE_USER_FN(nvl(p_user, USER),'MA','GIACS030');
            p_manual := v_manual;
        ELSE
            p_manual := 'Creation of manual accounting entries is not allowed.';
        END IF;
        */
    ELSE   
        v_tran_status :=	GET_RV_MEANING('GIAC_ACCTRANS.TRAN_FLAG',v_tran_flag);
        --p_tran_status :=   v_tran_status;
        p_mesg := 'Transaction is already '||v_tran_status||'.';	
    END IF;
END CHECK_MANUAL_ACCT_ENTRY;
/


