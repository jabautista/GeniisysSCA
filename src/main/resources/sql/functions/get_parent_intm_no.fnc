DROP FUNCTION CPI.GET_PARENT_INTM_NO;

CREATE OR REPLACE FUNCTION CPI.GET_PARENT_INTM_NO
   (V_POLICY_ID  GIPI_POLBASIC.POLICY_ID%TYPE)
  RETURN CHAR IS
   V_SHARE_PERCENTAGE         GIPI_COMM_INVOICE.SHARE_PERCENTAGE%TYPE;
   V_INTM_NO                  GIPI_COMM_INVOICE.INTRMDRY_INTM_NO%TYPE;
   V_PARENT_INTM_NO           GIIS_INTERMEDIARY.PARENT_INTM_NO%TYPE;
   V_INTM_TYPE                GIIS_INTM_TYPE.INTM_TYPE%TYPE;
   V_ACCT_INTM_CD             GIIS_INTM_TYPE.ACCT_INTM_CD%TYPE;
   V_LIC_TAG                  GIIS_INTERMEDIARY.LIC_TAG%TYPE;
   VAR_LIC_TAG                GIIS_INTERMEDIARY.LIC_TAG%TYPE:='N';
   VAR_INTM_TYPE              GIIS_INTM_TYPE.INTM_TYPE%TYPE;
   VAR_INTM_NO                GIPI_COMM_INVOICE.INTRMDRY_INTM_NO%TYPE;
   VAR_PARENT_INTM_NO         GIIS_INTERMEDIARY.PARENT_INTM_NO%TYPE;
   v_exs BOOLEAN := FALSE;
-- BILANG                     NUMBER:=0;
 BEGIN
   FOR rec IN (
    SELECT DISTINCT POLICY_ID
    FROM GIPI_COMM_INVOICE
    WHERE POLICY_ID = V_POLICY_ID )loop
     v_exs := TRUE;
     BEGIN
         SELECT MAX(SHARE_PERCENTAGE)
         INTO V_SHARE_PERCENTAGE
         FROM GIPI_COMM_INVOICE
         WHERE POLICY_ID = REC.POLICY_ID;
          IF V_SHARE_PERCENTAGE IS NOT NULL THEN
            BEGIN
             SELECT min(intrmdry_intm_no)
             INTO v_intm_no
             FROM gipi_comm_invoice
             WHERE share_percentage = v_share_percentage
               AND POLICY_ID = REC.POLICY_ID;
               IF V_INTM_NO IS NULL THEN NULL;
                  DBMS_OUTPUT.PUT_LINE('NO INTERMEDIARY FOUND FOR POLICY '||TO_CHAR(REC.POLICY_ID));
               END IF;
            EXCEPTION
             when no_data_found then
               DBMS_OUTPUT.PUT_LINE('NO SHARE PERCENTAGE FOUND FOR POLICY '||TO_CHAR(REC.POLICY_ID));
            END;
          ELSE
           DBMS_OUTPUT.PUT_LINE('NO SHARE PERCENTAGE FOUND FOR POLICY '||TO_CHAR(REC.POLICY_ID));
          END IF;
     EXCEPTION
         WHEN NO_DATA_FOUND THEN
           DBMS_OUTPUT.PUT_LINE('NO SHARE PERCENTAGE FOUND FOR THIS POLICY');
     END;
     BEGIN
       SELECT PARENT_INTM_NO, INTM_TYPE, nvl(LIC_TAG,'N')
       INTO V_PARENT_INTM_NO, V_INTM_TYPE, V_LIC_TAG
       FROM GIIS_INTERMEDIARY
       WHERE INTM_NO = V_INTM_NO;
         IF V_LIC_TAG  = 'Y' THEN
             V_PARENT_INTM_NO := V_INTM_NO;
         ELSIF V_LIC_TAG  = 'N' THEN
           IF V_PARENT_INTM_NO IS NULL THEN
             V_PARENT_INTM_NO := V_INTM_NO;
           ELSE  -- check for the nearest licensed parent intm no --
             var_lic_tag := v_lic_tag;
             while var_lic_tag = 'N'
               and v_parent_intm_no is not null loop
               begin
                 select intm_no,
                        parent_intm_no,
                        intm_type,
                        lic_tag
                 into   var_intm_no,
                        var_parent_intm_no,
                        var_intm_type,
                        var_lic_tag
                 from giis_intermediary
                 where intm_no = v_parent_intm_no;
                 v_parent_intm_no := var_parent_intm_no;
                 v_intm_type      := var_intm_type;
                 v_lic_tag        := var_lic_tag;
                 IF VAR_PARENT_INTM_NO IS NULL THEN
                   v_parent_intm_no := var_intm_no;
                   EXIT;
                 ELSE
                   var_lic_tag := 'N';
                 END IF;
               exception
                 when no_data_found then
                   DBMS_OUTPUT.PUT_LINE(TO_Char(v_parent_intm_no)||' HAS NO_DATA_FOUND IN GIIS INTERMEDIARY');
                   v_parent_intm_no := var_intm_no;
                   EXIT;
               end;
             end loop;
           END IF;
         END IF;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE( TO_CHAR(REC.POLICY_iD)|| ' POLICY HAS NO RECORD IN GIIS_INTERMEDIARY.');
         DBMS_OUTPUT.PUT_LINE('INTERMEDIARY ' || TO_CHAR(V_INTM_NO)|| ' HAS NO RECORD IN GIIS_INTERMEDIARY.');
         DBMS_OUTPUT.PUT_LINE('intm type :  ' || var_intm_type);
         DBMS_OUTPUT.PUT_LINE('lic tag   :  ' || var_lic_tag);
         DBMS_OUTPUT.PUT_LINE('parent_intm no :  ' || to_char(v_parent_intm_no));
     END;
     BEGIN
       SELECT ACCT_INTM_CD
       INTO V_ACCT_INTM_CD
       FROM GIIS_INTM_TYPE
       WHERE INTM_TYPE = V_INTM_TYPE;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE( V_INTM_TYPE||' HAS NO RECORD IN GIIS_INTM_TYPE.');
     END;
     RETURN(V_PARENT_INTM_NO);
--     UPDATE GIPI_COMM_INVOICE
--     SET PARENT_INTM_NO =   V_PARENT_INTM_NO
--     WHERE POLICY_ID  =   REC.POLICY_ID;
--     COMMIT;
 END LOOP;
 --Added by mike, if the policy does not exist in gipi_comm_invoice, it probably is a tax endt
 --Get the orig intm of the policy using BAE_V_POLPRNT_PARENT
 IF v_exs = FALSE THEN
    --get the input parameters from gipi_Polbasic
	FOR m IN (SELECT policy_id,line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
	            FROM gipi_polbasic
			   where policy_id = v_policy_id)
	LOOP
       v_intm_no := BAE_V_POLPRNT_PARENT(m.policy_id,m.line_cd, m.subline_cd,m.iss_cd, m.issue_yy,m.pol_seq_no,m.renew_no);
	   RETURN(v_intm_no);
	   EXIT;
	END LOOP;
 END IF;
 --End of addition
END;
/


