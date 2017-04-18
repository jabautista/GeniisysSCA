CREATE OR REPLACE PACKAGE BODY CPI.GIPIR209_PKG
AS

    FUNCTION get_report_details(        
        P_FROM_DATE         DATE,
        P_TO_DATE           DATE,
        P_AS_OF_DATE        DATE,
        P_INC_FROM_DATE     DATE,
        P_INC_TO_DATE       DATE,
        P_INC_AS_OF_DATE    DATE,
        P_EFF_FROM_DATE     DATE,
        P_EFF_TO_DATE       DATE,
        P_EFF_AS_OF_DATE    DATE,
        P_ISS_FROM_DATE     DATE,
        P_ISS_TO_DATE       DATE,
        P_ISS_AS_OF_DATE    DATE,
        P_EXP_FROM_DATE     DATE,
        P_EXP_TO_DATE       DATE,
        P_EXP_AS_OF_DATE    DATE
    ) RETURN gipir209_tab PIPELINED
    IS
        v_detail    gipir209_type;
        v_count     NUMBER := 0;
    BEGIN
    
        SELECT giisp.v('COMPANY_NAME')
          INTO v_detail.company_name
          FROM dual;
          
        SELECT giisp.v('COMPANY_ADDRESS')
          INTO v_detail.company_address
          FROM dual;
          
        IF ( P_FROM_DATE IS NOT NULL AND P_TO_DATE IS NOT NULL ) THEN
        
            v_detail.subtitle := 'From ' || TO_CHAR(P_FROM_DATE, 'fmMonth dd, yyyy') || ' to ' || TO_CHAR(P_TO_DATE, 'fmMonth dd, yyyy');
        
        ELSIF ( P_INC_FROM_DATE IS NOT NULL AND P_INC_TO_DATE IS NOT NULL ) THEN
        
            v_detail.subtitle := 'From ' || TO_CHAR(P_INC_FROM_DATE, 'fmMonth dd, yyyy') || ' to ' || TO_CHAR(P_INC_TO_DATE, 'fmMonth dd, yyyy');
        
        ELSIF ( P_EFF_FROM_DATE IS NOT NULL AND P_EFF_TO_DATE IS NOT NULL ) THEN
        
            v_detail.subtitle := 'From ' || TO_CHAR(P_EFF_FROM_DATE, 'fmMonth dd, yyyy') || ' to ' || TO_CHAR(P_EFF_TO_DATE, 'fmMonth dd, yyyy');
            
        ELSIF ( P_ISS_FROM_DATE IS NOT NULL AND P_ISS_TO_DATE IS NOT NULL ) THEN
        
            v_detail.subtitle := 'From ' || TO_CHAR(P_ISS_FROM_DATE, 'fmMonth dd, yyyy') || ' to ' || TO_CHAR(P_ISS_TO_DATE, 'fmMonth dd, yyyy');
        
        ELSIF ( P_EXP_FROM_DATE IS NOT NULL AND P_EXP_TO_DATE IS NOT NULL ) THEN
           
            v_detail.subtitle := 'From ' || TO_CHAR(P_EXP_FROM_DATE, 'fmMonth dd, yyyy') || ' to ' || TO_CHAR(P_EXP_TO_DATE, 'fmMonth dd, yyyy');
            
        ELSIF P_AS_OF_DATE IS NOT NULL THEN
        
            v_detail.subtitle := 'As of ' || TO_CHAR(P_AS_OF_DATE, 'fmMonth dd, yyyy');
            
        ELSIF P_INC_AS_OF_DATE IS NOT NULL THEN
        
            v_detail.subtitle := 'As of ' || TO_CHAR(P_INC_AS_OF_DATE, 'fmMonth dd, yyyy');
        
        ELSIF P_EFF_AS_OF_DATE IS NOT NULL THEN
        
            v_detail.subtitle := 'As of ' || TO_CHAR(P_EFF_AS_OF_DATE, 'fmMonth dd, yyyy');
        
        ELSIF P_ISS_AS_OF_DATE IS NOT NULL THEN
        
            v_detail.subtitle := 'As of ' || TO_CHAR(P_ISS_AS_OF_DATE, 'fmMonth dd, yyyy');
        
        ELSIF P_EXP_AS_OF_DATE IS NOT NULL THEN
        
            v_detail.subtitle := 'As of ' || TO_CHAR(P_EXP_AS_OF_DATE, 'fmMonth dd, yyyy');
        
        END IF;
          
        FOR rec IN ( SELECT a.ASSD_NO,
                            D.ASSD_NAME,
                            a.INCEPT_DATE,
                            a.EFF_DATE,
                            a.ISSUE_DATE,
                            a.EXPIRY_DATE,
                            a.POLICY_ID, 
                            'Item - '||b.ITEM_TITLE ITEM, 
                            NVL(b.TSI_AMT,0) TSI_AMT, 
                            NVL(b.PREM_AMT,0) PREM_AMT, 
                            DECODE(b.CURRENCY_RT,1,'','*') CURRENCY_RT, 
                            a.LINE_CD||'-'||a.SUBLINE_CD||'-'||a.ISS_CD||'-'|| LPAD(a.ISSUE_YY,2,0)||'-'||LPAD(a.POL_SEQ_NO,7,0)||'/'||a.ENDT_ISS_CD||'-'|| LPAD(a.ENDT_YY,2,0)||'-'||LPAD(a.ENDT_SEQ_NO,7,0) POLICY_NUM, 
                            a.ENDT_SEQ_NO, 
                            a.ENDT_ISS_CD, 
                            a.ENDT_YY, 
                            NVL(b.ANN_TSI_AMT,0) ANN_TSI_AMT, 
                            NVL(b.ANN_PREM_AMT,0) ANN_PREM_AMT, 
                            a.POL_SEQ_NO, 
                            a.LINE_CD||'-'||a.SUBLINE_CD||'-'||a.ISS_CD||'-'|| LPAD(a.ISSUE_YY,2,0)||'-'||LPAD(a.POL_SEQ_NO,7,0) policy_num1 
                       FROM GIPI_POLBASIC a, GIPI_ITEM b, GIPI_ACCIDENT_ITEM c, GIIS_ASSURED D 
                      WHERE a.POLICY_ID = c.POLICY_ID 
                        AND a.POLICY_ID = b.POLICY_ID 
                        AND b.ITEM_NO = c.ITEM_NO 
                        AND a.ASSD_NO = D.ASSD_NO 
                        AND (   a.INCEPT_DATE >= P_INC_FROM_DATE AND
                                a.INCEPT_DATE <= P_INC_TO_DATE OR
                                a.INCEPT_DATE <= P_INC_AS_OF_DATE
                         OR      
                                a.EFF_DATE >= P_EFF_FROM_DATE AND
                                a.EFF_DATE <= P_EFF_TO_DATE OR
                                a.EFF_DATE <= P_EFF_AS_OF_DATE
                         OR      
                                a.ISSUE_DATE >= P_ISS_FROM_DATE AND
                                a.ISSUE_DATE <= P_ISS_TO_DATE OR
                                a.ISSUE_DATE <= P_ISS_AS_OF_DATE
                         OR 
                                a.EXPIRY_DATE >= P_EXP_FROM_DATE AND
                                a.EXPIRY_DATE <= P_EXP_TO_DATE OR 
                                a.EXPIRY_DATE <= P_EXP_AS_OF_DATE 
                         OR     
                                a.INCEPT_DATE >= P_FROM_DATE AND
                                a.INCEPT_DATE <= P_TO_DATE OR 
                                a.INCEPT_DATE <= P_AS_OF_DATE)
                      UNION 
                     SELECT a.ASSD_NO,
                            D.ASSD_NAME,
                            a.INCEPT_DATE,
                            a.EFF_DATE,
                            a.ISSUE_DATE,
                            a.EXPIRY_DATE, 
                            a.POLICY_ID, 
                            'Grouped Item - '||b.GROUPED_ITEM_TITLE ITEM, 
                            NVL(b.TSI_AMT,0) TSI_AMT, 
                            NVL(b.PREM_AMT,0) PREM_AMT, 
                            DECODE(e.CURRENCY_RT,1,'','*') CURRENCY_RT,
                            a.LINE_CD||'-'||a.SUBLINE_CD||'-'||a.ISS_CD||'-'|| LPAD(a.ISSUE_YY,2,0)||'-'||LPAD(a.POL_SEQ_NO,7,0)||'/'||a.ENDT_ISS_CD||'-'|| LPAD(a.ENDT_YY,2,0)||'-'||LPAD(a.ENDT_SEQ_NO,7,0) POLICY_NUM, 
                            a.ENDT_SEQ_NO,
                            a.ENDT_ISS_CD, 
                            a.ENDT_YY, 
                            NVL(b.ANN_TSI_AMT,0) ANN_TSI_AMT, 
                            NVL(b.ANN_PREM_AMT,0) ANN_PREM_AMT, 
                            a.POL_SEQ_NO, 
                            a.LINE_CD||'-'||a.SUBLINE_CD||'-'||a.ISS_CD||'-'|| LPAD(a.ISSUE_YY,2,0)||'-'||LPAD(a.POL_SEQ_NO,7,0) policy_num1 
                       FROM GIPI_POLBASIC a, GIPI_GROUPED_ITEMS b, GIPI_ACCIDENT_ITEM c, GIIS_ASSURED D , gipi_item e
                      WHERE a.POLICY_ID = c.POLICY_ID
                        AND a.POLICY_ID = b.POLICY_ID
                        and b.policy_id = e.policy_id
                        AND b.ITEM_NO = c.ITEM_NO
                        and c.item_no = e.item_no
                        AND a.ASSD_NO = D.ASSD_NO 
                        AND (   a.INCEPT_DATE >= P_INC_FROM_DATE AND
                                a.INCEPT_DATE <= P_INC_TO_DATE OR
                                a.INCEPT_DATE <= P_INC_AS_OF_DATE
                         OR   
                                a.EFF_DATE >= P_EFF_FROM_DATE AND
                                a.EFF_DATE <= P_EFF_TO_DATE OR
                                a.EFF_DATE <= P_EFF_AS_OF_DATE
                         OR   
                                a.ISSUE_DATE >= P_ISS_FROM_DATE AND
                                a.ISSUE_DATE <= P_ISS_TO_DATE OR
                                a.ISSUE_DATE <= P_ISS_AS_OF_DATE
                         OR 
                                a.EXPIRY_DATE >= P_EXP_FROM_DATE AND
                                a.EXPIRY_DATE <= P_EXP_TO_DATE OR 
                                a.EXPIRY_DATE <= P_EXP_AS_OF_DATE 
                         OR     
                                a.INCEPT_DATE >= P_FROM_DATE AND
                                a.INCEPT_DATE <= P_TO_DATE OR 
                                a.INCEPT_DATE <= P_AS_OF_DATE)
                        order by policy_num, item)
        LOOP
            v_count := 1;
            v_detail.assd_no := rec.assd_no;
            v_detail.assd_name := rec.assd_name;            
            v_detail.INCEPT_DATE := TRUNC(rec.INCEPT_DATE);
            v_detail.EFF_DATE := rec.EFF_DATE;
            v_detail.ISSUE_DATE := rec.ISSUE_DATE;
            v_detail.EXPIRY_DATE := rec.EXPIRY_DATE;
            
            v_detail.POLICY_ID := rec.POLICY_ID;     
            v_detail.ITEM := rec.ITEM;     
            v_detail.TSI_AMT := rec.TSI_AMT;
            v_detail.PREM_AMT := rec.PREM_AMT;
            v_detail.CURRENCY_RT_CHK := rec.CURRENCY_RT;
            v_detail.POLICY_NUM := rec.POLICY_NUM;
            v_detail.ENDT_SEQ_NO := rec.ENDT_SEQ_NO;
            v_detail.ENDT_ISS_CD := rec.ENDT_ISS_CD;
            v_detail.ENDT_YY := rec.ENDT_YY;
            v_detail.ANN_TSI_AMT := rec.ANN_TSI_AMT;
            v_detail.ANN_PREM_AMT := rec.ANN_PREM_AMT;
            v_detail.POL_SEQ_NO := rec.POL_SEQ_NO;
            v_detail.policy_num1 := rec.policy_num1;
            
            PIPE ROW(v_detail);
        END LOOP;
        
        IF v_count = 0 THEN
            PIPE ROW(v_detail);
        END IF;
    END get_report_details;
    
END GIPIR209_PKG;
/


