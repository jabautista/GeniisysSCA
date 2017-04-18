DROP PROCEDURE CPI.AUTO_CREATE_POLICY;

CREATE OR REPLACE PROCEDURE CPI.AUTO_CREATE_POLICY
 (P_INSD_NAME       GIPI_ITEM.ITEM_TITLE%TYPE,    -- PLACED IN INVOICE AND ITEM
  P_INSD_CS         GIPI_ACCIDENT_ITEM.CIVIL_STATUS%TYPE,  --IN ACCIDENT_ITEM
  P_INSD_SEX        GIPI_ACCIDENT_ITEM.SEX%TYPE,
  P_INSD_BDAY       GIPI_ACCIDENT_ITEM.DATE_OF_BIRTH%TYPE,
  P_INTM_NO         GIIS_INTERMEDIARY.INTM_NO%TYPE,
  P_ASSD_NAME       GIIS_ASSURED.ASSD_NAME%TYPE,
  P_ASSD_NO         GIPI_PARLIST.ASSD_NO%TYPE,
  P_ASSD_ADDR       GIIS_ASSURED.MAIL_ADDR1%TYPE,
  P_BEN_NAME1       GIPI_BENEFICIARY.BENEFICIARY_NAME%TYPE,
  P_BEN_CS1         GIPI_BENEFICIARY.CIVIL_STATUS%TYPE,
  P_BEN_SEX1        GIPI_BENEFICIARY.SEX%TYPE,
  P_BEN_ADDR1       GIPI_BENEFICIARY.BENEFICIARY_ADDR%TYPE,
  P_BEN_BDAY1       GIPI_BENEFICIARY.DATE_OF_BIRTH%TYPE,
  P_BEN_REL1        GIPI_BENEFICIARY.RELATION%TYPE,
  P_INCEPT_DATE     GIPI_POLBASIC.INCEPT_DATE%TYPE,
  P_EXPIRY_DATE     GIPI_POLBASIC.EXPIRY_DATE%TYPE,
  P_EFF_DATE        GIPI_POLBASIC.EFF_DATE%TYPE,
  P_PAYT_TERMS      GIPI_INVOICE.PAYT_TERMS%TYPE,
  P_REF_POL_NO      GIPI_POLBASIC.REF_POL_NO%TYPE,
  P_POLICY_TYPE     GIPI_DEFAULT_POLICY_TYPES.POLICY_TYPE%TYPE )
IS
  /* assumptions :  */
  /* 1.  1 insured and 1 beneficiary
     2.  1 agent which is already in the master file
	 3.  1 item group and item
     4.  1 distribution only - undistributed for now
     5.  currency rate is peso
  */
  /* this procedure was made with CARETAKER in mind */
  /* the peril codes are hard-coded for now wyl no parameters are set up*/
  V_PAR_ID          GIPI_PARLIST.PAR_ID%TYPE;
  V_PAR_SEQ_NO      GIPI_PARLIST.PAR_SEQ_NO%TYPE;
  V_POLICY_ID       GIPI_POLBASIC.POLICY_ID%TYPE;
  V_POL_SEQ_NO      GIPI_POLBASIC.POL_SEQ_NO%TYPE;
  V_PREM_SEQ_NO     GIPI_INVOICE.PREM_SEQ_NO%TYPE;
  V_ISS_CD          GIPI_PARLIST.ISS_CD%TYPE;
  V_LINE_CD         GIPI_PARLIST.LINE_CD%TYPE;
  V_LINE_ACCIDENT   GIPI_PARLIST.LINE_CD%TYPE;
  V_SUBLINE_CD      GIPI_POLBASIC.SUBLINE_CD%TYPE;
  V_PAR_YY          GIPI_PARLIST.PAR_YY%TYPE:= TO_NUMBER(TO_CHAR(SYSDATE,'YY'));
  V_PAR_TYPE        GIPI_PARLIST.PAR_TYPE%TYPE:= 'P';
  V_DIST_NO         GIUW_POL_DIST.DIST_NO%TYPE;
  V_DIST_FLAG       GIUW_POL_DIST.DIST_FLAG%TYPE:= '1';
  V_REDIST_FLAG     GIUW_POL_DIST.REDIST_FLAG%TYPE:= '1';
  V_INTM_NO         GIIS_INTERMEDIARY.INTM_NO%TYPE:=P_INTM_NO;
  V_SHARE_PERCENTAGE GIPI_COMM_INVOICE.SHARE_PERCENTAGE%TYPE:=100;
  V_PARENT_INTM_NO  GIIS_INTERMEDIARY.INTM_NO%TYPE;
  V_COMM_RT         GIPI_COMM_INV_PERIL.COMMISSION_RT%TYPE;
  V_TSI_AMT         GIPI_POLBASIC.TSI_AMT%TYPE;
  V_PREM_AMT        GIPI_POLBASIC.PREM_AMT%TYPE;
  PESO_TSI          GIPI_POLBASIC.TSI_AMT%TYPE;
  PESO_PREM         GIPI_POLBASIC.PREM_AMT%TYPE;
  V_PREM_RT         GIPI_ITMPERIL.PREM_RT%TYPE;
  V_ASSD_NO         GIIS_ASSURED.ASSD_NO%TYPE;
  V_ASSD_NAME       GIIS_ASSURED.ASSD_NAME%TYPE;
  V_ASSD_MAIL1      GIIS_ASSURED.MAIL_ADDR1%TYPE;
  V_ASSD_MAIL2      GIIS_ASSURED.MAIL_ADDR2%TYPE;
  V_ASSD_MAIL3      GIIS_ASSURED.MAIL_ADDR3%TYPE;
  V_ASSD_BILL1      GIIS_ASSURED.BILL_ADDR1%TYPE;
  V_ASSD_BILL2      GIIS_ASSURED.BILL_ADDR2%TYPE;
  V_ASSD_BILL3      GIIS_ASSURED.BILL_ADDR3%TYPE;
  V_DATE            DATE := SYSDATE;
  V_EFF_DATE        GIPI_POLBASIC.EFF_DATE%TYPE:= NVL(P_EFF_DATE,SYSDATE);
  V_INCEPT_DATE     GIPI_POLBASIC.INCEPT_DATE%TYPE:= NVL(P_INCEPT_DATE, SYSDATE);
  V_EXPIRY_DATE     GIPI_POLBASIC.EXPIRY_DATE%TYPE:= P_EXPIRY_DATE;
  COUNTER           NUMBER:= 0;  --to check if there are more than 1 assured that has the
                                 --same name in the giis_assured maintenanace
  V_DISCOUNT_SW     GIPI_POLBASIC.DISCOUNT_SW%TYPE:= 'N';
  V_CURRENCY_RT     GIPI_INVOICE.CURRENCY_RT%TYPE; -- USED BY GIPI_ITEM
  V_CURRENCY_CD     GIPI_INVOICE.CURRENCY_CD%TYPE; -- USED BY GIPI_ITEM
  V_ITEM_NO         GIPI_ITEM.ITEM_NO%TYPE;   -- USED BY GIPI_ITEM, GIPI_ITMPERIL
  V_ITEM_GRP        GIPI_ITEM.ITEM_GRP%TYPE:=1;  -- USED BY GIPI_ITEM, GIPI_ITMPERIL
  V_PROPERTY        GIPI_INVOICE.PROPERTY%TYPE;
  V_PAYT_TERMS      GIIS_PAYTERM.PAYT_TERMS%TYPE:= NVL(UPPER(P_PAYT_TERMS),'COD');
  V_WTAX_RT         GIPI_COMM_INV_PERIL.COMMISSION_RT%TYPE;
  V_TAX_AMT         GIPI_INVOICE.TAX_AMT%TYPE;
  V_NO_OF_PERSONS   GIPI_ACCIDENT_ITEM.NO_OF_PERSONS%TYPE;
  V_ITMPRL_TSI_AMT  GIPI_ITMPERIL.TSI_AMT%TYPE;   -- USED TO ACCUMULATE AMOUNT OF GIPI_ITMPERIL
  V_ITMPRL_PREM_AMT GIPI_ITMPERIL.PREM_AMT%TYPE;  -- FOR UPDATE TO GIPI_ITEM
-- USED BY GIPI_COMM_INV_PERIL TO ACCUMULATE AMOUNTS FOR UPDATE OF GIPI_COMM_INVOICE
  V_COMM            GIPI_COMM_INVOICE.COMMISSION_AMT%TYPE;
  V_PREM            GIPI_COMM_INVOICE.PREMIUM_AMT%TYPE;
  V_WTAX            GIPI_COMM_INVOICE.WHOLDING_TAX%TYPE;
  V_TOT_COMM        GIPI_COMM_INVOICE.COMMISSION_AMT%TYPE;
  V_TOT_PREM        GIPI_COMM_INVOICE.PREMIUM_AMT%TYPE;
  V_TOT_WTAX        GIPI_COMM_INVOICE.WHOLDING_TAX%TYPE;
--  USED TO VALIDATE PAYMENT TERMS
  V_DUMMY           VARCHAR2(10);
  INSERT_SWITCH     VARCHAR2(1):='N';

  CURSOR LINE IS
    SELECT PARAM_VALUE_V
    FROM GIIS_PARAMETERS
    WHERE PARAM_NAME LIKE 'LINE_CODE_AC';

  CURSOR DFLT IS
    SELECT DISTINCT LINE_CD, SUBLINE_CD, ISS_CD
    FROM GIPI_DEFAULT_POLICY_TYPES
    WHERE POLICY_TYPE = P_POLICY_TYPE;

  CURSOR DFLT2 IS
    SELECT A.ITEM_NO, A.PERIL_CD, A.PREM_RT, A.TSI_AMT, A.PREM_AMT,
	       A.CURRENCY_RT, A.CURRENCY_CD, B.PERIL_TYPE
    FROM GIPI_DEFAULT_POLICY_TYPES A,  GIIS_PERIL B
    WHERE POLICY_TYPE = P_POLICY_TYPE
    AND A.LINE_CD = B.LINE_CD
    AND A.PERIL_CD = B.PERIL_CD;

  CURSOR TOTAL_PREM IS
    SELECT SUM(NVL(PREM_AMT,0)) PREM_AMT, SUM(NVL(TAX_AMT,0)) TAX_AMT,
           SUM(NVL(PREM_AMT,0) * NVL(CURRENCY_RT,1)) PESO_PREM_AMT
    FROM GIPI_DEFAULT_POLICY_TYPES
	WHERE POLICY_TYPE = P_POLICY_TYPE;

  CURSOR TOTAL_TSI IS
    SELECT SUM(NVL(TSI_AMT,0)) TSI_AMT, SUM(NVL(TSI_AMT,0) * NVL(A.CURRENCY_RT,1)) PESO_TSI_AMT
    FROM GIPI_DEFAULT_POLICY_TYPES A,
         GIIS_PERIL  B
    WHERE A.POLICY_TYPE = P_POLICY_TYPE
    AND A.LINE_CD = B.LINE_CD
    AND A.PERIL_CD = B.PERIL_CD
    AND B.PERIL_TYPE = 'B';

  /* PLEASE ADD THIS TO CG_REF_CODES */
  CURSOR PAR_TYPE IS
    SELECT RV_LOW_VALUE
    FROM CG_REF_CODES
    WHERE RV_DOMAIN LIKE 'GIPI_PARLIST.PAR_TYPE'
    AND UPPER(RV_MEANING) LIKE 'POLICY';

  CURSOR ASSD (P_ASSD_NO    GIIS_ASSURED.ASSD_NO%TYPE) IS
    SELECT ASSD_NO, ASSD_NAME ,
           MAIL_ADDR1 , MAIL_ADDR2 , MAIL_ADDR3,
           BILL_ADDR1 , BILL_ADDR2 , BILL_ADDR3,
           PHONE_NO
    FROM GIIS_ASSURED
    WHERE ASSD_NO = NVL(P_ASSD_NO, ASSD_NO);

  CURSOR WTAX (P_INTM_NO    GIIS_INTERMEDIARY.INTM_NO%TYPE) IS
    SELECT wtax_rate PARAM_VALUE_N
    FROM GIIS_INTERMEDIARY a
    WHERE A.INTM_NO = V_INTM_NO;

BEGIN
/*
     1.  GIPI_PARLIST
         REF : GIIS_LINE
               GIAC_BRANCHES
     2.  GIPI_PARHIST
         2A.  GIIS_ASSURED
	 3.  GIPI_POLBASIC
	 4.  GIPI_ITEM
	 5.  GIPI_ITMPERIL
	 6.  GIPI_ACCIDENT_ITEM
	 7.  GIPI_BENEFICIARY
	 8.  GIPI_INVOICE
	     REF : GIIS_PAYTERM
	 9.  GIPI_INV_PERIL
	 10. GIPI_INV_TAX       -- PROC AUTO_POP_INV_TAX
	 11. GIPI_INSTALLMENT   -- PROC AUTO_POP_INSTALLMENT
	 12. GIPI_COMM_INVOICE
	 13. GIPI_COMM_INV_PERIL
	 14. GIUW_POL_DIST */
  /* VALIDATION OF PAYMENT TERMS IF IT EXISTS IN GIIS_PAYTERM MASTER FILE*/

  DBMS_OUTPUT.PUT_LINE(' EXPIRY DATE :  ');

  IF V_EXPIRY_DATE IS NULL THEN
    SELECT TO_DATE(TO_CHAR(V_INCEPT_DATE,'DD')||'-'||
         TO_CHAR(V_INCEPT_DATE,'MON')||'-'||
         TO_CHAR(TO_NUMBER(TO_CHAR(V_INCEPT_DATE,'YYYY')) +1),'DD-MON-YYYY')
    INTO V_EXPIRY_DATE
    FROM DUAL;
  END IF;

  DBMS_OUTPUT.PUT_LINE(' TWO:  ');
  IF V_PAYT_TERMS != 'COD' THEN
    BEGIN
      SELECT 'X'
	  INTO V_DUMMY
	  FROM GIIS_PAYTERM
	  WHERE PAYT_TERMS = V_PAYT_TERMS;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20091, 'PAYMENT TERMS SPECIFIED DOES NOT EXIST');
      WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20091, 'PAYMENT TERMS RETURNS TOO MANY ROWS');
	END;
  END IF;

  FOR JA1 IN DFLT LOOP
    V_LINE_CD     :=  JA1.LINE_CD;
    V_SUBLINE_CD  :=  JA1.SUBLINE_CD;
    V_ISS_CD      :=  JA1.ISS_CD;
  END LOOP;
  IF V_LINE_CD IS NULL THEN
    RAISE_APPLICATION_ERROR(-20092, 'NO LINE CD IN GIPI_DEFAULT_POLICY_TYPES.');
  END IF;

  FOR JA1 IN TOTAL_PREM LOOP
    V_PREM_AMT    :=  JA1.PREM_AMT;
    V_TAX_AMT     :=  JA1.TAX_AMT;
    PESO_PREM     :=  JA1.PESO_PREM_AMT;
  END LOOP;
  IF NVL(V_PREM_AMT,0) = 0 THEN
    RAISE_APPLICATION_ERROR(-20093, 'NO PREMIUM AMT IN GIPI_DEFAULT_POLICY_TYPES.');
  END IF;

  FOR JA1 IN TOTAL_TSI LOOP
    V_TSI_AMT     :=  JA1.TSI_AMT;
    PESO_TSI      :=  JA1.PESO_TSI_AMT;
  END LOOP;
  IF NVL(V_TSI_AMT,0) = 0 THEN
    RAISE_APPLICATION_ERROR(-20094, 'NO TSI AMT IN GIPI_DEFAULT_POLICY_TYPES.');
  END IF;

  FOR JA1 IN PAR_TYPE LOOP
    V_PAR_TYPE := JA1.RV_LOW_VALUE;
  END LOOP;

  FOR JA1 IN LINE LOOP
    V_LINE_ACCIDENT := JA1.PARAM_VALUE_V;
  END LOOP;

  SELECT PARLIST_PAR_ID_S.NEXTVAL,
         POLBASIC_POLICY_ID_S.NEXTVAL,
         POL_DIST_DIST_NO_S.NEXTVAL
  INTO V_PAR_ID , V_POLICY_ID , V_DIST_NO
  FROM DUAL;

  DBMS_OUTPUT.PUT_LINE(' V_PAR_ID  :  '|| TO_CHAR( V_PAR_ID) );
  DBMS_OUTPUT.PUT_LINE(' V_POLICY_ID  :  '|| TO_CHAR( V_POLICY_ID) );
  DBMS_OUTPUT.PUT_LINE(' V_DIST_NO  :  '|| TO_CHAR( V_DIST_NO) );

  FOR JA2 IN ASSD (P_ASSD_NO) LOOP
    V_ASSD_NO := JA2.ASSD_NO;
    V_ASSD_NAME := JA2.ASSD_NAME;
    V_ASSD_MAIL1 := JA2.MAIL_ADDR1;
    V_ASSD_MAIL2 := JA2.MAIL_ADDR2;
    V_ASSD_MAIL3 := JA2.MAIL_ADDR3;
    V_ASSD_BILL1 := JA2.BILL_ADDR1;
    V_ASSD_BILL2 := JA2.BILL_ADDR2;
    V_ASSD_BILL3 := JA2.BILL_ADDR3;
  END LOOP JA2;
  IF V_ASSD_NO IS NULL THEN
    IF P_ASSD_NAME IS NULL THEN
      RAISE_APPLICATION_ERROR(-20094,'ASSURED NAME NOT SPECIFIED FOR INSERTION IN'||
	     'MASTER FILE');
	END IF;
    SELECT ASSD_NO_SEQ.NEXTVAL INTO V_ASSD_NO FROM DUAL;

    --GOVT_TAG IN (0,2)
    --INSTITUTIONAL_TAG IN ('Y','N',NULL)

    V_ASSD_NAME  := UPPER(P_ASSD_NAME);
    V_ASSD_MAIL1 := SUBSTR(P_ASSD_ADDR,1,50);
    V_ASSD_MAIL2 := SUBSTR(P_ASSD_ADDR,51,50);
    V_ASSD_MAIL3 := SUBSTR(P_ASSD_ADDR,101,50);
    V_ASSD_BILL1 := V_ASSD_MAIL1;
    V_ASSD_BILL2 := V_ASSD_MAIL2;
    V_ASSD_BILL3 := V_ASSD_MAIL3;
    INSERT INTO GIIS_ASSURED
      (ASSD_NO,    		ASSD_NAME,   	MAIL_ADDR1,  	MAIL_ADDR2,
       MAIL_ADDR3,     	BILL_ADDR1,  	BILL_ADDR2,  	BILL_ADDR3,
       PHONE_NO,    		USER_ID,     	TRAN_DATE,   	GOVT_TAG,
       LAST_UPDATE, 		INSTITUTIONAL_TAG  )
    VALUES
      (V_ASSD_NO,  P_ASSD_NAME, V_ASSD_MAIL1, V_ASSD_MAIL2,
       V_ASSD_MAIL3, V_ASSD_BILL1, V_ASSD_BILL2,
       V_ASSD_BILL3, NULL, USER,      V_DATE,    2,
       V_DATE,     'Y');
  END IF; -- ASSD_NO IS NULL THEN

  /****** INSERT INTO GIPI_PARLIST *****/
  DBMS_OUTPUT.PUT_LINE(' START PARLIST   ');
  BEGIN
    --ASSIGN_SW - ALL ARE 'Y'
    INSERT INTO GIPI_PARLIST
      (PAR_ID,     LINE_CD,     ISS_CD,      PAR_YY,      PAR_SEQ_NO,   QUOTE_SEQ_NO,
       PAR_TYPE,   ASSD_NO,     UNDERWRITER, ASSIGN_SW,   REMARKS,      PAR_STATUS,
       ADDRESS1,   ADDRESS2,    ADDRESS3,    LOAD_TAG)
    VALUES
      (V_PAR_ID,   V_LINE_CD,   V_ISS_CD,    V_PAR_YY,    NULL,         0,
       V_PAR_TYPE, V_ASSD_NO,   USER,        'Y',         NULL,         10,
       V_ASSD_MAIL1, V_ASSD_MAIL2, V_ASSD_MAIL3, NULL);
  END;   -- GIPI_PARLIST

  /****** INSERT INTO GIPI_PARHIST *****/
  DBMS_OUTPUT.PUT_LINE(' START PARHIST   ');
  BEGIN
    --ASSIGN_SW - ALL ARE 'Y'
    INSERT INTO GIPI_PARHIST
      (PAR_ID,     USER_ID,     PARSTAT_DATE,   ENTRY_SOURCE,   PARSTAT_CD)
    VALUES
      (V_PAR_ID,   USER,        V_DATE,         'DB'         ,  '10');
  END;   -- GIPI_PARHIST

  /****** INSERT INTO GIPI_POLBASIC *****/
  DBMS_OUTPUT.PUT_LINE(' START POLBASIC   ');
  BEGIN
    /*
    HARD CODED
n INVOICE_SW       ('N' - single invoice , 'Y' - multiple invoice )
n AUTO_RENEW_FLAG  ('N' - non-auto renewal , 'Y' - auto renewal )
n PROV_PREM_TAG    ('N' - no , 'Y' - 'yes' )
- provisionary premium percent
n PACK_POL_FLAG    ('N' - not a package policy , 'Y'- package policy )
- this program shall not handle package policies
n REG_POLICY_SW    ('N' -                , 'Y' - regular policy )
n CO_INSURANCE_SW  ( 1 - non co-insurance , 3 - co-insurance )
n GOVT_ACC_SW      ('N' - not a govt account, 'Y' - govt account )   lepanto only
n FOREIGN_ACC_SW   ('N' - not foreign account, 'Y' - foreign account )
n DISCOUNT_SW      ('N' - without discount, 'Y' - with discount )
n SPLD_FLAG        (1 - not spoiled , 2 - tagged for spoilage, 3 - spoiled )
n DIST_FLAG        (1 - not distributed, 2 - dist w facul, 3 - fully dist ,
4 - negated, 5 - redistributed )
n PRORATE_FLAG     (1 - pro-rated, 2 - annual computation, 3 - short-rate )
n SHORT_RT_PERCENT 0
n TYPE_CD	          null ( lepanto 4 )
n PREM_WARR_TAG    ('N' - no premium warranty , 'Y' - with premium warranty )
- for group accounts (used mainly in RI payments )
n FLEET_PRINT_TAG  ('N' - other lines, 'Y' - for MC with lots of items,
NULL - for bonds )
    */
    INSERT INTO GIPI_POLBASIC
      (POLICY_ID,       LINE_CD,       SUBLINE_CD,      ISS_CD,         ISSUE_YY,
       POL_SEQ_NO,      ENDT_ISS_CD,   ENDT_YY,         ENDT_SEQ_NO,    RENEW_NO,
       PAR_ID,          EFF_DATE,      POL_FLAG,        INVOICE_SW,     AUTO_RENEW_FLAG,
       PROV_PREM_TAG,   PACK_POL_FLAG, REG_POLICY_SW,   CO_INSURANCE_SW,INCEPT_DATE,
       EXPIRY_DATE,     EXPIRY_TAG,    ISSUE_DATE,      ASSD_NO,        ADDRESS1,
       TSI_AMT,         PREM_AMT,      ANN_TSI_AMT,     ANN_PREM_AMT,   FOREIGN_ACC_SW,
       DISCOUNT_SW,     SPLD_FLAG,     DIST_FLAG,       NO_OF_ITEMS,    PRORATE_FLAG,
       SHORT_RT_PERCENT,TYPE_CD,       PREM_WARR_TAG,   INCEPT_TAG,     BOOKING_MTH,
       BOOKING_YEAR,    FLEET_PRINT_TAG,USER_ID,        LAST_UPD_DATE,  MANUAL_RENEW_NO,
	   REF_POL_NO        )
    VALUES
      (V_POLICY_ID,     V_LINE_CD,     V_SUBLINE_CD,    V_ISS_CD,       V_PAR_YY,
       NULL,            V_ISS_CD,      0,               0,              0,
       V_PAR_ID,        V_EFF_DATE,    1,               'N',            'N',
       'N',             'N' ,          'Y' ,            1,              V_INCEPT_DATE,
       V_EXPIRY_DATE,   'N' ,          V_DATE,          V_ASSD_NO,      V_ASSD_MAIL1,
       PESO_TSI,        PESO_PREM,     PESO_TSI,        PESO_PREM,      'N',
       V_DISCOUNT_SW,   1,             1,               1,              2,
       0  ,             null,          'N',             'N',
       TO_CHAR(P_INCEPT_DATE,'MONTH'), TO_CHAR(P_INCEPT_DATE,'YYYY'), 'N', USER,SYSDATE,0,
	   P_REF_POL_NO      );
  END;   -- GIPI_POLBASIC
  /****** INSERT INTO GIPI_ITEM *****/
  DBMS_OUTPUT.PUT_LINE(' START ITEM ');
  BEGIN
    /*
    - REC_FLAG         ('A' - additional, 'C' - changed, 'D' - deleted , 'S' - spoiled ,
              	null - mostly used for policy)
    - ITEM_TITLE  ( pfic - assured name , lepanto - 'individual p.a.')
    */
    FOR JA2 IN DFLT2  LOOP
      IF NVL(JA2.ITEM_NO,1) != NVL(V_ITEM_NO,0) THEN
        /* INSERT ONLY IF DIFFERENT ITEM */
        V_ITEM_NO         := NVL(JA2.ITEM_NO,1);
        V_ITMPRL_TSI_AMT  := 0;
        V_ITMPRL_PREM_AMT := 0;
        INSERT INTO GIPI_ITEM
        (POLICY_ID              ,ITEM_GRP               ,ITEM_NO                ,
         ITEM_TITLE             ,ITEM_DESC              ,TSI_AMT                ,
         PREM_AMT               ,ANN_TSI_AMT            ,ANN_PREM_AMT           ,
         CURRENCY_CD            ,CURRENCY_RT            ,DISCOUNT_SW            )
        VALUES
        (V_POLICY_ID            ,V_ITEM_GRP             ,V_ITEM_NO              ,
         P_INSD_NAME            ,null                   ,JA2.TSI_AMT            ,
         JA2.PREM_AMT           ,JA2.TSI_AMT            ,JA2.PREM_AMT           ,
         JA2.CURRENCY_CD        ,JA2.CURRENCY_RT        ,V_DISCOUNT_SW          );
        V_CURRENCY_RT   := JA2.CURRENCY_RT;
        V_CURRENCY_CD   := JA2.CURRENCY_CD;
        /* UPDATE GIPI_ITEM.PREMIUM_AMT, TSI_AMT, ANN_TSI_AMT, ANN_PREM_AMT
		    ** AFTER INSERT INTO GIPI_ITMPERIL*/
      END IF;
      /****/
  DBMS_OUTPUT.PUT_LINE(' START ITMPERIL  ');
      BEGIN   /**** INSERT INTO GIPI_ITMPERIL ****/
        /*
        -- PRT_FLAG      ('1' AND NULL - PFIC, LEPANTO - NULL )
           sets where the peril should be printed , in policy, invoice, etc
        NOTE :  PREMIUM_AMT WILL BE PLACED IN THE FIRST BASIC PERIL
        */
        INSERT INTO GIPI_ITMPERIL
          (POLICY_ID      		,ITEM_NO        	  ,LINE_CD        ,
           PERIL_CD       		,REC_FLAG       	  ,PREM_RT        ,
           TSI_AMT        		,PREM_AMT       	  ,ANN_TSI_AMT    ,
           ANN_PREM_AMT    	    ,DISCOUNT_SW     	  ,PRT_FLAG       ,
           RI_COMM_AMT    		,RI_COMM_RATE       )
        VALUES
          (V_POLICY_ID          ,JA2.ITEM_NO       	  ,V_LINE_CD      ,
           JA2.PERIL_CD         ,'A'       	          ,JA2.PREM_RT    ,
           JA2.TSI_AMT   	    ,JA2.PREM_AMT         ,JA2.TSI_AMT    ,
           JA2.PREM_AMT         ,V_DISCOUNT_SW     	  ,1              ,
           0                    ,0                    );
        IF JA2.PERIL_TYPE = 'B' THEN
          V_ITMPRL_TSI_AMT  := V_ITMPRL_TSI_AMT + JA2.TSI_AMT ;
        END IF;
        V_ITMPRL_PREM_AMT := V_ITMPRL_PREM_AMT  + JA2.PREM_AMT;
        /*** UPDATE GIPI_ITEM.PREMIUM_AMT, TSI_AMT, ANN_PREM_AMT, ANN_TSI_AMT ***/
        IF V_ITEM_NO IS NOT NULL THEN
           UPDATE GIPI_ITEM
		   SET PREM_AMT = V_ITMPRL_PREM_AMT, ANN_PREM_AMT = V_ITMPRL_PREM_AMT,
		       TSI_AMT = V_ITMPRL_TSI_AMT, ANN_TSI_AMT = V_ITMPRL_TSI_AMT
           WHERE POLICY_ID = V_POLICY_ID
		   AND ITEM_NO = V_ITEM_NO;
        END IF;
        /*** END OF UPDATE TO GIPI_ITEM  ***/
        IF INSERT_SWITCH = 'N' AND V_LINE_CD = V_LINE_ACCIDENT THEN
  DBMS_OUTPUT.PUT_LINE(' START ACCIDENT   ');
        BEGIN  -- GIPI_ACCIDENT_ITEM
          INSERT_SWITCH := 'Y';
          INSERT INTO GIPI_ACCIDENT_ITEM
            (POLICY_ID	            ,ITEM_NO		    ,DATE_OF_BIRTH,
             AGE 				    ,POSITION_CD		,NO_OF_PERSONS,
             CIVIL_STATUS           ,SEX			)
          VALUES
            (V_POLICY_ID			,V_ITEM_NO		    ,P_INSD_BDAY,
             DECODE(P_INSD_BDAY,NULL,NULL,ROUND(TRUNC(SYSDATE) - TRUNC(P_INSD_BDAY))/365),
			 NULL	                ,V_NO_OF_PERSONS    ,
             P_INSD_CS			    ,P_INSD_SEX        	);
        /****** ONLY 1 BENEFICIARY FOR CARETAKER   *****/
        -- POSITION_CD    -- NO RECORD IN CG_REF_CODES
        -- DELETE_SW      -- NO RECORD IN CG_REF_CODES
  DBMS_OUTPUT.PUT_LINE(' START BENEFICIARY ');
          INSERT INTO GIPI_BENEFICIARY
            (POLICY_ID                   ,ITEM_NO             	,BENEFICIARY_NO,
             BENEFICIARY_NAME            ,BENEFICIARY_ADDR    	,CIVIL_STATUS  ,
             DATE_OF_BIRTH               ,AGE                 	,ADULT_SW      ,
             DELETE_SW                   ,SEX                 	,POSITION_CD   ,
             RELATION                    )
           VALUES
            (V_POLICY_ID                 ,V_ITEM_NO           	,1             ,
             P_BEN_NAME1                 ,P_BEN_ADDR1           ,P_BEN_CS1     ,
             P_BEN_BDAY1                 ,ROUND(TRUNC(SYSDATE)-TRUNC(P_BEN_BDAY1))/365, NULL     ,
             NULL			             ,P_BEN_SEX1		    ,NULL	   	   ,
             P_BEN_REL1                  );
        END;   -- GIPI_BENEFICIARY
        END IF;
      END;  -- GIPI_ITMPERIL
      /* END INSERT INTO GIPI_ITMPERIL AND GIPI_ACCIDENT_ITEM AND GIPI_BENEFICIARY */
    END LOOP JA2;
  END;  -- GIPI_ITEM
  /*  INSERT INTO GIPI_INVOICE */
  DBMS_OUTPUT.PUT_LINE(' START INVOICE ');
  BEGIN
    INSERT INTO GIPI_INVOICE
      (ISS_CD                      	,PREM_SEQ_NO          ,POLICY_ID       ,
       ITEM_GRP                    	,CURRENCY_CD          ,CURRENCY_RT     ,
       PROPERTY                    	,PREM_AMT             ,TAX_AMT         ,
       PAYT_TERMS                  	,INSURED              ,ACCT_ENT_DATE   ,
       DUE_DATE                   	,RI_COMM_AMT          ,REMARKS         ,
       OTHER_CHARGES              	,NOTARIAL_FEE         ,REF_INV_NO      ,
       POLICY_CURRENCY            	,BOND_RATE            ,BOND_TSI_AMT    ,
       PAY_TYPE                    	,CARD_NAME            ,CARD_NO         ,
       EXPIRY_DATE                 	,APPROVAL_CD          ,INVOICE_PRINTED_DATE  ,
       USER_ID                     	,LAST_UPD_DATE        ,INVOICE_PRINTED_CNT   )
    VALUES
      (V_ISS_CD                    	,NULL                 ,V_POLICY_ID     ,
       V_ITEM_GRP                  	,V_CURRENCY_CD        ,V_CURRENCY_RT   ,
       NVL(V_PROPERTY, P_INSD_NAME) ,V_PREM_AMT           ,V_TAX_AMT       ,
       V_PAYT_TERMS                	,P_INSD_NAME          ,NULL            ,
       V_INCEPT_DATE               	,0                    ,NULL            ,
       0                           	,0                    ,NULL            ,
       NULL                   	    ,0                    ,0               ,
       NULL                    	    ,NULL                 ,NULL            ,
       V_EXPIRY_DATE              	,NULL                 ,NULL            ,
       USER                     	,V_DATE               ,NULL            );
  END;  -- GIPI_INVOICE
  /*  INSERT INTO GIPI_INVPERIL */
  /*  GIPI_INVOICE.RI_COMM_AMT = SUM(GIPI_ITMPERIL.RI_COMM_AMT)  */
  /*  FOR CARETAKER, ALL RI_COMM_AMT AND RI_COMM_RT WILL BE = 0  */
  DBMS_OUTPUT.PUT_LINE(' START INVPERIL   ');
  BEGIN
    SELECT PREM_SEQ_NO
	INTO V_PREM_SEQ_NO
	FROM GIPI_INVOICE
	WHERE POLICY_ID = V_POLICY_ID;
    FOR JA1 IN (SELECT SUM(PREM_AMT) PREM_AMT, SUM(TSI_AMT) TSI_AMT, PERIL_CD
         FROM GIPI_ITMPERIL
         WHERE POLICY_ID = V_POLICY_ID
		 GROUP BY PERIL_CD ) LOOP
      INSERT INTO GIPI_INVPERIL
        (ISS_CD                 ,PREM_SEQ_NO            ,PERIL_CD               ,
         ITEM_GRP               ,TSI_AMT                ,PREM_AMT               ,
         RI_COMM_AMT            ,RI_COMM_RT             )
      VALUES
        (V_ISS_CD               ,V_PREM_SEQ_NO          ,JA1.PERIL_CD           ,
         V_ITEM_GRP             ,JA1.TSI_AMT            ,JA1.PREM_AMT           ,
         0                      ,0                       );
    END LOOP;
  END;
  DBMS_OUTPUT.PUT_LINE(' START GIPI_INV_TAX ');
  /*  INSERT INTO GIPI_INV_TAX  */
  /*  TO BE INSERTED BY PROCEDURE, CHECKING SHALL BE DONE AFTERWARDS */
  BEGIN
    IF NVL(V_TAX_AMT,0) != 0 THEN
       AUTO_POP_INV_TAX( V_POLICY_ID, V_ISS_CD, V_LINE_CD, V_ITEM_GRP, V_PREM_AMT,
       V_PREM_SEQ_NO);
    BEGIN
      SELECT sum(tax_amt)
      INTO v_tax_amt
      FROM gipi_inv_tax
      WHERE iss_cd = v_iss_cd
      AND prem_seq_no = v_prem_seq_no;
      IF V_TAX_AMT != V_TAX_AMT THEN
        RAISE_APPLICATION_ERROR(-20097,'TOTAL GIPI_INV_TAX TAX_AMT != TO TAX_AMT');
      END IF;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20096,'NO INSERTION WAS MADE IN GIPI_INV_TAX');
    END;
    END IF;
  END;  -- GIPI_INV_TAX
  /*  INSERT INTO GIPI_INSTALLMENT USING DO_PAYT_TERMS_COMPUTATION     */
  /*  TRIGGER INSTALLMENT_TBXIX  SHALL POPULATE GIAC_AGING_SOA_DETAILS */
  DBMS_OUTPUT.PUT_LINE(' START INSTALLMENT ');
  BEGIN
    AUTO_POP_INSTALLMENT(V_POLICY_ID, V_ISS_CD, V_PREM_SEQ_NO, V_LINE_CD,
        V_EXPIRY_DATE, V_INCEPT_DATE );
  END;  -- GIPI_INSTALLMENT
  /*  INSERT INTO GIPI_COMM_INVOICE   */
  /*  PREMIUM IS BASED ON GIPI_INVOICE.PREMIUM_AMT * V_SHARE_PERCENTAGE */
  DBMS_OUTPUT.PUT_LINE(' START COMM INVOICE ');
  BEGIN
    FOR JA1 IN WTAX (V_INTM_NO) LOOP
      V_WTAX_RT := NVL(JA1.PARAM_VALUE_N,0);
    END LOOP;
    IF V_WTAX_RT IS NULL THEN
      RAISE_APPLICATION_ERROR(-20096, 'INTM NO DOES NOT EXISTS IN MASTER FILE ');
    END IF;
    INSERT INTO GIPI_COMM_INVOICE
      (INTRMDRY_INTM_NO       ,ISS_CD                 ,POLICY_ID              ,
       PREM_SEQ_NO            ,SHARE_PERCENTAGE       ,PREMIUM_AMT            ,
       COMMISSION_AMT         ,WHOLDING_TAX           ,GACC_TRAN_ID           ,
       BOND_RATE              ,PARENT_INTM_NO         )
    VALUES
      (V_INTM_NO              ,V_ISS_CD               ,V_POLICY_ID            ,
       V_PREM_SEQ_NO          ,V_SHARE_PERCENTAGE     ,
       ROUND(V_PREM_AMT * (V_SHARE_PERCENTAGE/100),2),
       0                     	,0                      , NULL                  ,
       NULL           	      	,V_PARENT_INTM_NO       );
    -- COMMISSION_AMT AND WHOLDING_TAX WILL BE UPDATED AFTER INSERTION IN GCIP
  END;  -- GIPI_COMM_INVOICE
  DBMS_OUTPUT.PUT_LINE(' START COMM INV PERIL ');
  /*  INSERT INTO GIPI_COMM_INV_PERIL  */
  /*  PREMIUM IS BASED ON GIPI_INVPERIL.PREM_AMT * V_SHARE_PERCENTAGE */
  /*  FUNCTION */
  V_PARENT_INTM_NO := GET_PARENT_INTM_NO(V_POLICY_ID);
  /* FUNCTION */
  BEGIN
    V_TOT_COMM := 0;
    V_TOT_PREM := 0;
    V_TOT_WTAX := 0;
    FOR JA1 IN (SELECT SUM(PREM_AMT) PREM_AMT, SUM(TSI_AMT) TSI_AMT, PERIL_CD
         FROM GIPI_ITMPERIL
         WHERE POLICY_ID = V_POLICY_ID
		 GROUP BY PERIL_CD ) LOOP
      V_COMM_RT := GET_INTM_RATE(V_INTM_NO, V_LINE_CD, V_ISS_CD, JA1.PERIL_CD);
      V_COMM := JA1.PREM_AMT * (V_SHARE_PERCENTAGE/100) * (V_COMM_RT/100);
      V_WTAX := JA1.PREM_AMT * (V_SHARE_PERCENTAGE/100) * (V_COMM_RT/100) * (V_WTAX_RT/100);
      V_PREM := ROUND(JA1.PREM_AMT * (V_SHARE_PERCENTAGE/100),2);
      INSERT INTO GIPI_COMM_INV_PERIL
        (INTRMDRY_INTM_NO     ,ISS_CD           ,PREM_SEQ_NO            ,
         POLICY_ID            ,PERIL_CD         ,PREMIUM_AMT            ,
         COMMISSION_AMT       ,COMMISSION_RT    ,WHOLDING_TAX           )
      VALUES
        (V_INTM_NO            ,V_ISS_CD         ,V_PREM_SEQ_NO          ,
         V_POLICY_ID          ,JA1.PERIL_CD     ,V_PREM                 ,
         V_COMM               ,V_COMM_RT        ,V_WTAX                  );
      V_TOT_COMM := V_TOT_COMM + V_COMM;
      V_TOT_WTAX := V_TOT_WTAX + V_WTAX;
      V_TOT_PREM := V_TOT_PREM + V_PREM;
    END LOOP;
  END;  -- GIPI_COMM_INV_PERIL
--  DBMS_OUTPUT.PUT_LINE('FINISHED WITH GIPI_COMMiNV_PERIL');
  IF ABS(ROUND(V_PREM_AMT * (V_SHARE_PERCENTAGE/100),2) - V_TOT_PREM) > 1  THEN
    RAISE_APPLICATION_ERROR(-20095, 'PREMIUM AMOUNTS IN GIPI_COMM_INVOICE AND PERIL DO NOT MATCH');
  ELSE
    UPDATE GIPI_COMM_INVOICE
    SET COMMISSION_AMT = V_TOT_COMM, WHOLDING_TAX = V_TOT_WTAX,
	    PREMIUM_AMT = V_TOT_PREM, PARENT_INTM_NO = V_PARENT_INTM_NO
    WHERE POLICY_ID = V_POLICY_ID
    AND ISS_CD = V_ISS_CD
    AND PREM_SEQ_NO = V_PREM_SEQ_NO;
  END IF;
  /*  INSERT INTO GIUW_POL_DIST  */
  DBMS_OUTPUT.PUT_LINE('START WITH GIUW_POL_DIST');
  BEGIN
    INSERT INTO GIUW_POL_DIST
      (DIST_NO                ,PAR_ID                 ,DIST_FLAG              ,
       REDIST_FLAG            ,EFF_DATE               ,EXPIRY_DATE            ,
       CREATE_DATE            ,POST_FLAG              ,POLICY_ID              ,
       ENDT_TYPE              ,TSI_AMT                ,PREM_AMT               ,
       ANN_TSI_AMT            ,DIST_TYPE              ,ITEM_POSTED_SW         ,
       EX_LOSS_SW             ,NEGATE_DATE            ,ACCT_ENT_DATE          ,
       ACCT_NEG_DATE          ,BATCH_ID               ,USER_ID                ,
       LAST_UPD_DATE          )
    VALUES
      (V_DIST_NO              ,V_PAR_ID               ,V_DIST_FLAG            ,
       V_REDIST_FLAG          ,V_EFF_DATE             ,V_EXPIRY_DATE          ,
       V_DATE                 ,NULL                   ,V_POLICY_ID            ,
       NULL                   ,V_TSI_AMT              ,V_PREM_AMT             ,
       V_TSI_AMT              ,NULL                   ,NULL                   ,
       NULL                   ,NULL                   ,NULL                   ,
       NULL                   ,NULL                   ,USER                   ,
       SYSDATE                );
  -- POST_FLAG INSERTED BY TRIGGER POL_DIST_TBXIX
  -- USER_ID AND LAST_UPDATE INSERTED BY TRIGGER POL_DIST_TBXIX
  END;  -- GIUW_POL_DIST
  DBMS_OUTPUT.PUT_LINE(' START OF DISTRIBUTION :  '||TO_CHAR(SYSDATE,'HH:MI:SS AM'));
  AUTO_CREATE_DISTRIBUTION(V_DIST_NO ,V_LINE_CD  ,V_POLICY_ID ,V_ITEM_GRP );
  DBMS_OUTPUT.PUT_LINE(' END   OF DISTRIBUTION :  '||TO_CHAR(SYSDATE,'HH:MI:SS AM'));
  UPDATE GIPI_POLBASIC
  SET DIST_FLAG = '3'
  WHERE POLICY_iD = V_POLICY_iD;
END;
/


