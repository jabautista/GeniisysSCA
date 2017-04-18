CREATE OR REPLACE PACKAGE BODY CPI.Policy_Docs_Pkg
AS
    FUNCTION get_item_count(p_extract_id NUMBER)
      RETURN NUMBER IS
      
      v_count NUMBER;
      
    BEGIN
      SELECT COUNT(item_no)
        INTO v_count
        FROM GIXX_ITEM
       WHERE extract_id = p_extract_id;
       
      RETURN v_count;
    END get_item_count;

    FUNCTION get_report_details(
        p_extract_id IN GIXX_POLBASIC.extract_id%TYPE,
        p_report_id    IN GIIS_DOCUMENT.report_id%TYPE)
    RETURN report_tab PIPELINED
    IS
        v_report             report_type;
        v_co_insurance_sw     GIXX_POLBASIC.co_insurance_sw%TYPE;
        v_assd_name         GIIS_ASSURED.assd_name%TYPE;
        v_mop_wordings        GIIS_DOCUMENT.text%TYPE;
        v_mop_wordings2        GIIS_DOCUMENT.text%TYPE;
        v_pack_method        GIIS_DOCUMENT.text%TYPE;
        v_return            VARCHAR2(1) := 'N';
        CURSOR main IS
            SELECT
                    -- info for policy --
                    B540.LINE_CD || '-' ||B540.ISS_CD || '-' ||LTRIM(TO_CHAR(B540.issue_YY, '09')) || '-' || TRIM(TO_CHAR(B540.Pol_SEQ_NO, '099999'))|| '-' ||LTRIM(TO_CHAR(B540.renew_NO, '09'))  || DECODE(B540.REG_POLICY_SW,'N',' **') PAR_SEQ_NO1
                   ,B540.extract_ID            EXTRACT_ID1
                   ,B540.POLICY_ID          PAR_ID
                   ,B540.LINE_CD || '-' || b540.subline_cd || '-' || B540.ISS_CD || '-' || LTRIM(TO_CHAR(B540.issue_YY, '09')) ||'-' || TRIM(TO_CHAR(B540.Pol_SEQ_NO, '099999'))|| '-' || LTRIM(TO_CHAR(B540.renew_NO, '09')) POLICY_NUMBER
                   ,DECODE(B240.PAR_STATUS,10, B540.LINE_CD  || '-' ||b540.subline_cd || '-' ||B540.ISS_CD || '-' ||LTRIM(TO_CHAR(B540.ISSUE_YY, '09')) ||'-'||LTRIM(TO_CHAR(B540.POL_SEQ_NO, '0999999')) || '-' ||LTRIM(TO_CHAR(B540.RENEW_NO, '09')) || DECODE(B540.REG_POLICY_SW,'N',' **') 
                   ,B240.LINE_CD || '-' ||B240.ISS_CD || '-' ||LTRIM(TO_CHAR(B240.PAR_YY, '09')) || '-' ||TRIM(TO_CHAR(B240.PAR_SEQ_NO, '099999')) || '-' || LTRIM(TO_CHAR(B240.QUOTE_SEQ_NO, '09'))  || DECODE(B540.REG_POLICY_SW,'N',' **')) PAR_NO
                   ,B240.LINE_CD || '-' ||B240.ISS_CD || '-' ||LTRIM(TO_CHAR(B240.PAR_YY, '09')) || '-' ||TRIM(TO_CHAR(B240.PAR_SEQ_NO, '099999')) || '- '|| LTRIM(TO_CHAR(B240.QUOTE_SEQ_NO, '09'))  || DECODE(B540.REG_POLICY_SW,'N',' **') PAR_ORIG
                   ,A150.LINE_NAME        LINE_LINE_NAME
                   ,A210.SUBLINE_NAME     SUBLINE_SUBLINE_NAME
                   ,A210.SUBLINE_CD        SUBLINE_SUBLINE_CD
                   ,A150.LINE_CD        SUBLINE_LINE_CD
                   ,DECODE(B540.INCEPT_TAG,'Y',LTRIM('T.B.A.'),TO_CHAR(B540.INCEPT_DATE,'FMMonth DD, YYYY'))   BASIC_INCEPT_DATE
                   ,DECODE(B540.EXPIRY_TAG,'Y',LTRIM('T.B.A.'),TO_CHAR(B540.EXPIRY_DATE,'FMMonth DD, YYYY'))    BASIC_EXPIRY_DATE
                   ,B540.EXPIRY_TAG        BASIC_EXPIRY_TAG
                   ,TO_CHAR(B540.ISSUE_DATE, 'FMMonth DD, YYYY')   BASIC_ISSUE_DATE
                   ,B540.TSI_AMT        BASIC_TSI_AMT
                   ,DECODE(TO_CHAR(TO_DATE(a210.subline_time,'SSSSS'),'HH:MI:SS AM'),'12:00:00 AM','12:00:00 MN','12:00:00 PM','12:00:00 NOON',TO_CHAR(TO_DATE(a210.subline_time,'SSSSS'),'HH:MI:SS AM'))  SUBLINE_SUBLINE_TIME
                   ,B540.ACCT_OF_CD       BASIC_ACCT_OF_CD
                   ,B540.MORTG_NAME      BASIC_MORTG_NAME
                   ,DECODE(b240.par_type,'E', NVL(b540.old_assd_no,b240.assd_no), b240.assd_no)  BASIC_ASSD_NO
                   ,DECODE(B240.PAR_TYPE, 'E', DECODE(B540.OLD_ADDRESS1, NULL, B240.ADDRESS1, B540.OLD_ADDRESS1), B540.ADDRESS1) ADDRESS1
                   ,DECODE(B240.PAR_TYPE, 'E', DECODE(B540.OLD_ADDRESS1, NULL, B240.ADDRESS2, B540.OLD_ADDRESS2), B540.ADDRESS2) ADDRESS2
                   ,DECODE(B240.PAR_TYPE, 'E', DECODE(B540.OLD_ADDRESS1, NULL, B240.ADDRESS3, B540.OLD_ADDRESS3), B540.ADDRESS3) ADDRESS3
                   ,DECODE(B240.PAR_TYPE, 'E', DECODE(B540.OLD_ADDRESS1, NULL, B240.ADDRESS1, B540.OLD_ADDRESS1), B540.ADDRESS1)||' '||DECODE(B240.PAR_TYPE, 'E', DECODE(B540.OLD_ADDRESS1, NULL, B240.ADDRESS2, B540.OLD_ADDRESS2),B540.ADDRESS2)||' '||DECODE(B240.PAR_TYPE, 'E', DECODE(B540.OLD_ADDRESS1, NULL, B240.ADDRESS3, B540.OLD_ADDRESS3), B540.ADDRESS3) BASIC_ADDR
                   ,B540.POL_FLAG        BASIC_POL_FLAG
                   ,B540.LINE_CD        BASIC_LINE_CD
                   ,B540.REF_POL_NO        BASIC_REF_POL_NO
                   ,B540.ASSD_NO        BASIC_ASSD_NO2
                   ,DECODE(B540.LABEL_TAG,'Y','Leased to','In acct of') LABEL_TAG
                   ,B540.label_tag LABEL_TAG1
                    -- end of info for policy --
                    -- info for endt policy --
                   ,DECODE(b240.par_type,'E',B540.ENDT_ISS_CD || '-' || LTRIM(TO_CHAR(B540.ENDT_YY, '09')) || '-' ||LTRIM(TO_CHAR(B540.ENDT_SEQ_NO, '099999'))) ENDT_NO
                   ,DECODE(b240.par_type,'E',B540.LINE_CD || '-' || B540.SUBLINE_CD || '-' || B540.ISS_CD || '-' ||LTRIM(TO_CHAR(B540.ISSUE_YY, '09')) || '-' ||LTRIM(TO_CHAR(B540.POL_SEQ_NO, '099999')) || '-' || LTRIM(TO_CHAR(B540.RENEW_NO, '09')) || ' - ' ||B540.ENDT_ISS_CD || '-' || LTRIM(TO_CHAR(B540.ENDT_YY, '09')) || '-' || LTRIM(TO_CHAR(B540.ENDT_SEQ_NO, '099999'))) POL_ENDT_NO
                   ,DECODE(B540.ENDT_EXPIRY_TAG,'Y','T.B.A.',TO_CHAR(B540.ENDT_EXPIRY_DATE,'FMMonth DD, YYYY'))  ENDT_EXPIRY_DATE
                   ,TO_CHAR(B540.EFF_DATE, 'FMMonth DD, YYYY') BASIC_EFF_DATE
                   ,B540.EFF_DATE        EFF_DATE
                   ,DECODE(b240.par_type,'E',B540.ENDT_EXPIRY_TAG)   ENDT_EXPIRY_TAG
                   ,B540.INCEPT_TAG        BASIC_INCEPT_TAG
                   ,B540.SUBLINE_CD        BASIC_SUBLINE_CD
                   ,B540.ISS_CD            BASIC_ISS_CD
                   ,B540.ISSUE_YY        BASIC_ISSUE_YY
                   ,B540.POL_SEQ_NO        BASIC_POL_SEQ_NO
                   ,B540.RENEW_NO        BASIC_RENEW_NO
                   ,DECODE(TO_CHAR(B540.EFF_DATE,'HH:MI:SS AM'),'12:00:00 AM','12:00:00 MN','12:00:00 PM','12:00:00 NOON',TO_CHAR(B540.EFF_DATE,'HH:MI:SS AM')) BASIC_EFF_TIME
                   ,DECODE(TO_CHAR(B540.ENDT_EXPIRY_DATE,'HH:MI:SS AM'),'12:00:00 AM','12:00:00 MN','12:00:00 PM','12:00:00 NOON',TO_CHAR(B540.ENDT_EXPIRY_DATE,'HH:MI:SS AM')) BASIC_ENDT_EXPIRY_TIME
                   --,TO_DATE(TO_CHAR(B540.EFF_DATE||DECODE(TO_CHAR(TO_DATE(a210.subline_time,'SSSSS'),' HH:MI:SS AM'),' 12:00:00 AM',' 12:00:00 AM',' 12:00:00 PM',TO_CHAR(TO_DATE(a210.subline_time,'SSSSS'),' HH:MI:SS AM'))),'DD-MON-RRRR HH:MI:SS AM') EFF_DATE_TIME --abie 07212011
                   ,TO_DATE(TO_CHAR(B540.EFF_DATE, 'DD-MON-RRRR')||DECODE(TO_CHAR(TO_DATE(a210.subline_time,'SSSSS'),' HH:MI:SS AM'),' 12:00:00 AM',' 12:00:00 AM',' 12:00:00 PM',TO_CHAR(TO_DATE(a210.subline_time,'SSSSS'),' HH:MI:SS AM')),'DD-MON-RRRR HH:MI:SS AM') EFF_DATE_TIME --andrew 10292012
                    -- end of info for endt policy -- 
                    -- info for par ---
                   ,B240.PAR_TYPE            PAR_PAR_TYPE
                   ,B240.PAR_STATUS            PAR_PAR_STATUS
                   ,B540.CO_INSURANCE_SW     BASIC_CO_INSURANCE_SW
                   ,' * '||USER||' * '         USERNAME
                   ,A210.OP_FLAG              SUBLINE_OPEN_POLICY
                   ,b540.cred_branch         CRED_BR
                   ,DECODE(A020.designation, NULL, A020.assd_name||' '||A020.assd_name2, A020.designation ||''||A020.assd_name||' '||A020.assd_name2) ASSD_NAME
                   ,A020.assd_name IN_ACCT_OF
                   --,Giis_Assured_Pkg.get_assd_name2(DECODE(b240.par_type,'E', NVL(b540.old_assd_no,b240.assd_no), b240.assd_no)) f_assd_name replaced by: Nica 10.13.2011
                   --,DISPLAY_ASSURED(DECODE(b240.par_type,'E', NVL(b540.old_assd_no,b240.assd_no), b240.assd_no)) f_assd_name 
                   --,decode(A020.designation, null, A020.assd_name ||' '|| A020.assd_name2
                   --          ,A020.designation||' '||A020.assd_name ||' '|| A020.assd_name2) f_assd_name  --edited by d.alcantara, 01/30/2012
               FROM GIXX_POLBASIC B540
                    ,GIXX_PARLIST B240
                    ,GIIS_LINE A150
                    ,GIIS_SUBLINE A210
                    ,GIIS_ASSURED A020
                    ,GIIS_ASSURED A020A
              WHERE B540.extract_ID = p_extract_id
                AND B240.EXTRACT_ID = B540.EXTRACT_ID
                AND A150.LINE_CD = B540.LINE_CD
                AND A210.LINE_CD = B540.LINE_CD
                AND A210.SUBLINE_CD = B540.SUBLINE_CD
                AND A020.ASSD_NO = B240.ASSD_NO
                AND B540.co_insurance_sw = '1'
                AND A020A.assd_no (+) = B540.acct_of_cd
              UNION
            SELECT
                    -- info for par to be policy --
                    B540.LINE_CD || '-' ||B540.ISS_CD || '-' ||LTRIM(TO_CHAR(B540.issue_YY, '09')) || '-' || TRIM(TO_CHAR(B540.Pol_SEQ_NO, '099999')) || '-' ||LTRIM(TO_CHAR(B540.renew_NO, '09'))  || DECODE(B540.REG_POLICY_SW,'N',' **') PAR_SEQ_NO1
                    ,B540.extract_ID           EXTRACT_ID1
                    ,B540.policy_ID          PAR_ID
                    ,B540.LINE_CD || '-' || b540.subline_cd || '-' || B540.ISS_CD || '-' || LTRIM(TO_CHAR(B540.issue_YY, '09')) || '-' || TRIM(TO_CHAR(B540.Pol_SEQ_NO, '099999')) || '-' || LTRIM(TO_CHAR(B540.renew_NO, '09')) POLICY_NUMBER
                    ,DECODE(B240.PAR_STATUS,10,B540.LINE_CD  || '-' ||b540.subline_cd || '-' ||B540.ISS_CD || '-' ||LTRIM(TO_CHAR(B540.ISSUE_YY, '09')) ||'-'||LTRIM(TO_CHAR(B540.POL_SEQ_NO, '0999999')) || '-' ||LTRIM(TO_CHAR(B540.RENEW_NO, '09')) || DECODE(B540.REG_POLICY_SW,'N',' **') 
                    ,B240.LINE_CD || '-' ||B240.ISS_CD || '-' ||LTRIM(TO_CHAR(B240.PAR_YY, '09')) || '-' ||TRIM(TO_CHAR(B240.PAR_SEQ_NO, '099999')) || '-' ||LTRIM(TO_CHAR(B240.QUOTE_SEQ_NO, '09'))  || DECODE(B540.REG_POLICY_SW,'N',' **')) PAR_NO
                    ,B240.LINE_CD || '-' ||B240.ISS_CD || '-' ||LTRIM(TO_CHAR(B240.PAR_YY, '09')) || '-' ||TRIM(TO_CHAR(B240.PAR_SEQ_NO, '099999')) || '-' ||LTRIM(TO_CHAR(B240.QUOTE_SEQ_NO, '09'))  || DECODE(B540.REG_POLICY_SW,'N',' **') PAR_ORIG
                    ,A150.LINE_NAME            LINE_LINE_NAME
                    ,A210.SUBLINE_NAME         SUBLINE_SUBLINE_NAME
                    ,A210.SUBLINE_CD           SUBLINE_SUBLINE_CD
                    ,A210.LINE_CD             SUBLINE_LINE_CD
                    ,DECODE(B540.INCEPT_TAG,'Y',LTRIM('T.B.A.'),TO_CHAR(B540.INCEPT_DATE,'FMMonth DD, YYYY')) BASIC_INCEPT_DATE
                    ,DECODE(B540.EXPIRY_TAG,'Y',LTRIM('T.B.A.'),TO_CHAR(B540.EXPIRY_DATE,'FMMonth DD, YYYY')) BASIC_EXPIRY_DATE
                    ,B540.EXPIRY_TAG           BASIC_EXPIRY_TAG
                    ,TO_CHAR(B540.ISSUE_DATE, 'FMMonth DD, YYYY')   BASIC_ISSUE_DATE
                    ,B540.TSI_AMT              BASIC_TSI_AMT
                    ,DECODE(TO_CHAR(TO_DATE(a210.subline_time,'SSSSS'),'HH:MI:SS AM'),'12:00:00 AM','12:00:00 MN','12:00:00 PM','12:00:00 NOON',TO_CHAR(TO_DATE(a210.subline_time,'SSSSS'),'HH:MI:SS AM')) SUBLINE_SUBLINE_TIME
                    ,B540.ACCT_OF_CD           BASIC_ACCT_OF_CD
                    ,B540.MORTG_NAME           BASIC_MORTG_NAME
                    ,DECODE(b240.par_type, 'E', NVL(b540.old_assd_no,b240.assd_no), b240.assd_no)  BASIC_ASSD_NO
                    ,DECODE(B240.PAR_TYPE, 'E', DECODE(B540.OLD_ADDRESS1, NULL, B240.ADDRESS1, B540.OLD_ADDRESS1), B540.ADDRESS1) ADDRESS1
                    ,DECODE(B240.PAR_TYPE, 'E', DECODE(B540.OLD_ADDRESS1, NULL, B240.ADDRESS2, B540.OLD_ADDRESS2), B540.ADDRESS2) ADDRESS2
                    ,DECODE(B240.PAR_TYPE, 'E', DECODE(B540.OLD_ADDRESS1, NULL, B240.ADDRESS3, B540.OLD_ADDRESS3), B540.ADDRESS3) ADDRESS3
                    ,DECODE(B240.PAR_TYPE, 'E', DECODE(B540.OLD_ADDRESS1, NULL, B240.ADDRESS1, B540.OLD_ADDRESS1), B540.ADDRESS1)||' '||DECODE(B240.PAR_TYPE, 'E', DECODE(B540.OLD_ADDRESS1, NULL, B240.ADDRESS2, B540.OLD_ADDRESS2),B540.ADDRESS2)||' '||DECODE(B240.PAR_TYPE, 'E', DECODE(B540.OLD_ADDRESS1, NULL, B240.ADDRESS3, B540.OLD_ADDRESS3), B540.ADDRESS3) BASIC_ADDR
                    ,NULL                BASIC_POL_FLAG
                    ,B540.LINE_CD        BASIC_LINE_CD
                    ,B540.REF_POL_NO    BASIC_REF_POL_NO
                    ,B540.ASSD_NO        BASIC_ASSD_NO2
                    ,DECODE(B540.LABEL_TAG,'Y','Leased to   ','In acct of  ') LABEL_TAG
                    ,B540.label_tag LABEL_TAG1
                    -- end of info for par to be policy --
                    -- info for endt policy --
                    ,DECODE(b240.par_type,'E',B540.ENDT_ISS_CD || '-' ||LTRIM(TO_CHAR(B540.ENDT_YY, '09')) || '-'||LTRIM(TO_CHAR(B540.ENDT_SEQ_NO, '099999'))) ENDT_NO
                    ,DECODE(b240.par_type,'E',B540.LINE_CD || '-' || B540.SUBLINE_CD || '-' ||B540.ISS_CD || '-'||LTRIM(TO_CHAR(B540.ISSUE_YY, '09')) || '-' ||LTRIM(TO_CHAR(B540.POL_SEQ_NO, '099999')) || '-' ||LTRIM(TO_CHAR(B540.RENEW_NO, '09')) || ' - ' ||B540.ENDT_ISS_CD || '-' || LTRIM(TO_CHAR(B540.ENDT_YY, '09')) || '-'||LTRIM(TO_CHAR(B540.ENDT_SEQ_NO, '099999'))) POL_ENDT_NO
                    ,DECODE(b240.par_type,'E',TO_CHAR(B540.ENDT_EXPIRY_DATE,'FMMonth DD, YYYY'))  ENDT_EXPIRY_DATE
                    ,TO_CHAR(B540.EFF_DATE, 'FMMonth DD, YYYY')            BASIC_EFF_DATE
                    ,B540.EFF_DATE                 EFF_DATE
                    ,DECODE(b240.par_type,'E',B540.ENDT_EXPIRY_TAG)   ENDT_EXPIRY_TAG
                    ,B540.INCEPT_TAG    BASIC_INCEPT_TAG
                    ,B540.SUBLINE_CD    BASIC_SUBLINE_CD
                    ,B540.ISS_CD        BASIC_ISS_CD
                    ,B540.ISSUE_YY        BASIC_ISSUE_YY
                    ,B540.POL_SEQ_NO    BASIC_POL_SEQ_NO
                    ,B540.RENEW_NO        BASIC_RENEW_NO
                    ,DECODE(TO_CHAR(B540.EFF_DATE,'HH:MI:SS AM'),'12:00:00 AM','12:00:00 MN','12:00:00 PM','12:00:00 NOON',TO_CHAR(B540.EFF_DATE,'HH:MI:SS AM')) BASIC_EFF_TIME
                    ,DECODE(TO_CHAR(B540.ENDT_EXPIRY_DATE,'HH:MI:SS AM'),'12:00:00 AM','12:00:00 MN','12:00:00 PM','12:00:00 NOON',TO_CHAR(B540.ENDT_EXPIRY_DATE,'HH:MI:SS AM')) BASIC_ENDT_EXPIRY_TIME
                    --,TO_DATE(TO_CHAR(B540.EFF_DATE||DECODE(TO_CHAR(TO_DATE(a210.subline_time,'SSSSS'),' HH:MI:SS AM'),' 12:00:00 AM',' 12:00:00 AM',' 12:00:00 PM',TO_CHAR(TO_DATE(a210.subline_time,'SSSSS'),' HH:MI:SS AM'))),'DD-MON-RRRR HH:MI:SS AM') EFF_DATE_TIME --abie 07212011
                    ,TO_DATE(TO_CHAR(B540.EFF_DATE, 'DD-MON-RRRR')||DECODE(TO_CHAR(TO_DATE(a210.subline_time,'SSSSS'),' HH:MI:SS AM'),' 12:00:00 AM',' 12:00:00 AM',' 12:00:00 PM',TO_CHAR(TO_DATE(a210.subline_time,'SSSSS'),' HH:MI:SS AM')),'DD-MON-RRRR HH:MI:SS AM') EFF_DATE_TIME --andrew 10292012
                    -- end of info for endt policy --
                    -- info for par ---
                    ,B240.PAR_TYPE              PAR_PAR_TYPE
                    ,B240.PAR_STATUS            PAR_PAR_STATUS
                    ,B540.CO_INSURANCE_SW BASIC_CO_INSURANCE_SW
                    ,' * '||USER||' * '        USERNAME
                    ,A210.OP_FLAG             SUBLINE_OPEN_POLICY
                    ,b540.cred_branch         CRED_BR
                    ,DECODE(A020.designation, NULL, A020.assd_name||' '||A020.assd_name2, A020.designation ||' '||A020.assd_name||' '||A020.assd_name2) ASSD_NAME
                    ,A020.assd_name         IN_ACCT_OF
                    --,Giis_Assured_Pkg.get_assd_name2(DECODE(b240.par_type,'E', NVL(b540.old_assd_no,b240.assd_no), b240.assd_no)) f_assd_name
                    --,DISPLAY_ASSURED(DECODE(b240.par_type,'E', NVL(b540.old_assd_no,b240.assd_no), b240.assd_no)) f_assd_name 
                    --,decode(A020.designation, null, A020.assd_name ||' '|| A020.assd_name2
                    --         ,A020.designation||' '||A020.assd_name ||' '|| A020.assd_name2) f_assd_name  --edited by d.alcantara, 01/30/2012
               FROM GIXX_PARLIST B240
                    ,GIXX_POLBASIC B540
                    ,GIIS_LINE A150
                    ,GIIS_SUBLINE A210
                    ,GIIS_ASSURED A020
                    ,GIIS_ASSURED A020A
                    ,GIXX_MAIN_CO_INS B340
              WHERE B240.extract_id  = p_extract_id
                AND B240.extract_id  = B340.extract_id(+)
                AND B240.extract_id  = B540.extract_ID
                AND A150.LINE_CD = B540.LINE_CD
                AND A210.LINE_CD = B540.LINE_CD
                AND A210.SUBLINE_CD = B540.SUBLINE_CD
                AND A020.ASSD_NO  = B540.ASSD_NO
                AND b540.co_insurance_sw IN ('2','3')                
                AND A020A.assd_no (+) = B540.acct_of_cd;
    BEGIN
    
        --initialize_variables(p_report_id);        
        
        FOR i IN main
        LOOP                
            v_report.par_seq_no1            := i.par_seq_no1;
            v_report.extract_id1            := i.extract_id1;
            v_report.par_id                    := i.par_id;
            v_report.policy_number            := i.policy_number;                
            v_report.par_no                    := i.par_no;
            v_report.par_orig                := i.par_orig;
            v_report.line_line_name            := i.line_line_name;
            v_report.subline_subline_name    := i.subline_subline_name;
            v_report.subline_subline_cd        := i.subline_subline_cd;
            v_report.subline_line_cd        := giis_line_pkg.get_menu_line_cd(i.subline_line_cd);
            v_report.basic_incept_date        := i.basic_incept_date;
            v_report.basic_expiry_date        := i.basic_expiry_date;
            v_report.basic_expiry_tag        := i.basic_expiry_tag;
            v_report.basic_issue_date        := i.basic_issue_date;
            v_report.basic_tsi_amt            := i.basic_tsi_amt;
            v_report.subline_subline_time    := i.subline_subline_time;
            v_report.basic_acct_of_cd        := i.basic_acct_of_cd;
            v_report.basic_mortg_name        := i.basic_mortg_name;
            v_report.basic_assd_no            := i.basic_assd_no;
            v_report.address1                := i.address1;
            v_report.address2                := i.address2;
            v_report.address3                := i.address3;
            v_report.basic_addr                := i.basic_addr;
            v_report.basic_pol_flag            := i.basic_pol_flag;
            v_report.basic_line_cd            := i.basic_line_cd;
            v_report.basic_ref_pol_no        := i.basic_ref_pol_no;
            v_report.basic_assd_no2            := i.basic_assd_no2;
            v_report.label_tag                := i.label_tag;
            v_report.label_tag1                := i.label_tag1;
            -- end of pol info -- 
            v_report.endt_no                := i.endt_no;
            v_report.pol_endt_no            := i.pol_endt_no;
            v_report.endt_expiry_date        := i.endt_expiry_date;
            v_report.basic_eff_date            := i.basic_eff_date;
            v_report.eff_date                := i.eff_date;
            v_report.endt_expiry_tag        := i.endt_expiry_tag;
            v_report.basic_incept_tag        := i.basic_incept_tag;
            v_report.basic_subline_cd        := i.basic_subline_cd;
            v_report.basic_iss_cd            := i.basic_iss_cd;
            v_report.basic_issue_yy            := i.basic_issue_yy;
            v_report.basic_pol_seq_no        := i.basic_pol_seq_no;
            v_report.basic_renew_no            := i.basic_renew_no;
            v_report.basic_eff_time            := i.basic_eff_time;
            v_report.basic_endt_expiry_time    := i.basic_endt_expiry_time;
            v_report.eff_date_time             := i.eff_date_time; --abie 07212011
            -- end of endt policy --
            v_report.par_par_type            := i.par_par_type;
            v_report.par_par_status            := i.par_par_status;
            v_report.basic_co_insurance_sw    := i.basic_co_insurance_sw;
            v_report.username                := i.username;
            v_report.subline_open_policy    := i.subline_open_policy;
            v_report.cred_br                := i.cred_br;
            v_report.assd_name                := i.assd_name;
            v_report.in_acct_of                := i.in_acct_of;
            --v_report.f_assd_name            := i.f_assd_name;    
            v_report.f_assd_name            := Display_Assured2(i.basic_assd_no);
            v_return := 'Y';
            --PIPE ROW(v_report);

			FOR j IN(SELECT fleet_print_tag -- bonok :: 09.11.2012
			           FROM gipi_polbasic
					  WHERE policy_id IN (SELECT policy_id
						                    FROM gixx_polbasic
										   WHERE extract_id = p_extract_id))
			LOOP
				v_report.rv_print_fleet_tag := j.fleet_print_tag;
			END LOOP;
			
			IF v_report.rv_print_fleet_tag IS NULL THEN
				FOR k IN(SELECT fleet_print_tag
				           FROM gipi_wpolbas
						  WHERE par_id IN (SELECT par_id
						                     FROM gixx_polbasic
										    WHERE extract_id = p_extract_id))
				LOOP
					v_report.rv_print_fleet_tag := k.fleet_print_tag;
				END LOOP;
			END IF;
			
        END LOOP;        
        
        /*checks if the main query has record*/
        IF v_return = 'Y' THEN
            initialize_variables(p_report_id);
        ELSE
            RETURN;
        END IF;
        
        /* f_header */
        IF v_report.par_par_status != 10 THEN
            IF v_report.par_par_type = 'P' THEN
                v_report.f_header := Policy_Docs_Pkg.par_header;
            ELSE
                v_report.f_header := Policy_Docs_Pkg.endt_header;
            END IF;
        ELSE
            v_report.f_header := NULL;
        END IF;
        
        /* report title*/
        IF v_report.par_par_type = 'P' THEN
            IF v_report.par_par_status NOT IN (10, 99) THEN
                v_report.f_report_title := Policy_Docs_Pkg.par_par;
                v_report.f_dash := LPAD('-',LENGTH(Policy_Docs_Pkg.par_par)+1,'-');
            ELSE
                v_report.f_report_title := Policy_Docs_Pkg.par_policy;
                v_report.f_dash := LPAD('-',LENGTH(Policy_Docs_Pkg.par_policy)+1,'-');
            END IF;
        ELSE            
            IF v_report.par_par_status NOT IN (10, 99) THEN
                v_report.f_report_title := Policy_Docs_Pkg.endt_par;
                v_report.f_dash := LPAD('-',LENGTH(Policy_Docs_Pkg.endt_par)+1,'-');
            ELSE
                v_report.f_report_title := Policy_Docs_Pkg.endt_policy;
                v_report.f_dash := LPAD('-',LENGTH(Policy_Docs_Pkg.endt_policy)+1,'-');
            END IF;
        END IF;
        
        /* f_assd_name */
        /*DECLARE
            v_assd_name VARCHAR2(1000);
        BEGIN
            SELECT DECODE(designation, NULL, assd_name||' '||assd_name2, designation ||' '||assd_name||' '||assd_name2)
              INTO v_assd_name
              FROM giis_assured
             WHERE assd_no = v_report.basic_assd_no;
        END;
        
        v_report.f_assd_name := v_assd_name;
        */
        
        /* f_acct_of_cd 
        DECLARE
            v_assd_name GIIS_ASSURED.assd_name%TYPE;
        BEGIN
            FOR a IN ( 
                SELECT a.assd_name  assd_name
                  FROM GIIS_ASSURED a,GIXX_POLBASIC b
                 WHERE b.acct_of_cd > 0
                   AND b.acct_of_cd = v_report.basic_acct_of_cd
                   AND a.assd_no = b.acct_of_cd) 
            LOOP
                v_assd_name := a.assd_name;                   
                EXIT;
            END LOOP;
            v_report.f_acct_of_cd := v_assd_name;
        END;
        */
        v_report.f_acct_of_cd := Giis_Assured_Pkg.get_pol_doc_assd_name(v_report.basic_acct_of_cd);
        
        /* par_policy label */
        IF v_report.par_par_status = 10 THEN
            v_report.par_policy_label := Policy_Docs_Pkg.POLICY;
        ELSE
            v_report.par_policy_label := Policy_Docs_Pkg.par;
        END IF;
        
        /* robert 12/16/2011 */
        BEGIN
          SELECT text
            INTO v_report.label_assd 
            FROM giis_document
           WHERE title = 'NAME_INSURED_TITLE'
             AND line_cd = v_report.subline_line_cd
             AND report_id = v_report.line_line_name;
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
            v_report.label_assd := 'Insured';
        END;
        
        /* prem_label and prem_label_amount */
        DECLARE
            v_title_upper        VARCHAR2(25) := RPAD('PREMIUM', 18, ' ');
            v_title_initc         VARCHAR2(25) := RPAD('Premium', 18, ' ');
            v_currency            GIIS_CURRENCY.short_name%TYPE;
            v_prem_amt             NUMBER(16, 2) := 0;
            v_total_tax_charges    NUMBER(16,2) := 0;
            
            v_total_amt_upper VARCHAR2(50) := RPAD('AMOUNT DUE', 18, ' ');
            v_total_amt_initc VARCHAR2(50) := RPAD('Amount Due', 18, ' ');
            v_total_ref_upper VARCHAR2(50) := RPAD('TOTAL REFUND', 18, ' ');
            v_total_ref_initc VARCHAR2(50) := RPAD('Total Refund', 18, ' ');
            
            CURSOR G_EXTRACT_ID22 IS
                  SELECT ALL invtax.extract_id EXTRACT_ID,
                         invtax.tax_cd INVTAX_TAX_CD,
                         DECODE(invoice.policy_currency,'Y',SUM(invtax.tax_amt),SUM(invtax.tax_amt * invoice.currency_rt)) INVTAX_TAX_AMT,
                         taxcharg.tax_desc TAXCHARG_TAX_DESC,
                         taxcharg.include_tag TAX_CHARGE_INCLUDE_TAG,
                         taxcharg.SEQUENCE TAXCHARG_SEQUENCE
                    FROM GIXX_INVOICE invoice,
                         GIXX_INV_TAX invtax,
                         GIIS_TAX_CHARGES taxcharg,
                         GIXX_POLBASIC pol,
                         GIXX_PARLIST par
                   WHERE (invtax.iss_cd, invtax.line_cd, invtax.tax_cd, invtax.tax_id ) =
                         ((taxcharg.iss_cd, taxcharg.line_cd, taxcharg.tax_cd, taxcharg.tax_id ) )
                     AND invoice.extract_id = invtax.extract_id
                     AND invoice.extract_id = p_extract_id
                     AND invoice.extract_id = pol.extract_id
                     AND pol.co_insurance_sw IN (1,3)
                     AND par.extract_id = pol.extract_id
                     AND DECODE(par.par_status,10,invoice.prem_seq_no,1) = DECODE(par.par_status,10,invtax.prem_seq_no,1)
                     AND invtax.item_grp = invoice.item_grp
                GROUP BY invtax.extract_id, invtax.tax_cd, taxcharg.tax_desc, taxcharg.SEQUENCE, taxcharg.include_tag,invoice.policy_currency
                   UNION
                  SELECT ALL invtax.extract_id EXTRACT_ID2,
                         invtax.tax_cd INVTAX_TAX_CD,
                         DECODE(invoice.policy_currency,'Y',SUM(invtax.tax_amt),SUM(invtax.tax_amt * invoice.currency_rt)) INVTAX_TAX_AMT,
                         taxcharg.tax_desc TAXCHARG_TAX_DESC, taxcharg.include_tag TAX_CHARGE_INCLUDE_TAG, taxcharg.SEQUENCE TAXCHARG_SEQUENCE
                    FROM GIXX_ORIG_INVOICE invoice,
                         GIXX_ORIG_INV_TAX invtax,
                         GIIS_TAX_CHARGES taxcharg,
                         GIXX_POLBASIC pol
                   WHERE (invtax.iss_cd, invtax.line_cd, invtax.tax_cd, invtax.tax_id) = ((taxcharg.iss_cd, taxcharg.line_cd, taxcharg.tax_cd, taxcharg.tax_id ) )
                     AND invoice.extract_id = invtax.extract_id
                     AND invoice.extract_id = p_extract_id
                     AND invoice.extract_id = pol.extract_id
                     AND pol.co_insurance_sw = 2
                GROUP BY invtax.extract_id, invtax.tax_cd, taxcharg.tax_desc, taxcharg.SEQUENCE, taxcharg.include_tag,invoice.policy_currency, taxcharg.SEQUENCE
                ORDER BY taxcharg_sequence;
        BEGIN
            FOR i IN G_EXTRACT_ID22
            LOOP                
                --v_prem_amt := v_prem_amt + i.INVOICE_PREM_AMT;
                IF i.TAX_CHARGE_INCLUDE_TAG = 'N' THEN
                    v_total_tax_charges := v_total_tax_charges + i.INVTAX_TAX_AMT;
                END IF;
            END LOOP;            
            
            v_currency := Giis_Currency_Pkg.GET_ITEM_SHORT_NAME(p_extract_id);
            
            /* f_prem_title  */
            IF NVL(Policy_Docs_Pkg.print_upper_case,'N') = 'Y' THEN
                v_report.f_prem_title := v_title_upper;
                v_report.f_amount_due_title := v_total_amt_upper;
            ELSE
                v_report.f_prem_title := v_title_initc;
                v_report.f_amount_due_title := v_total_amt_initc;                
            END IF;
            
            v_report.f_amount_due := v_total_tax_charges;
            
            /* f_prem_title_short_name  */
            v_report.f_prem_title_short_name := v_currency;
            v_report.f_amount_due_short_name := v_currency;            
            
            /* currency desc */
            DECLARE
                v_currency_desc GIIS_CURRENCY.currency_desc%TYPE;
            BEGIN                
                v_currency_desc := Giis_Currency_Pkg.get_pol_doc_short_name2(p_extract_id);
                v_report.f_currency := v_currency_desc;                                
            END;            
            
            /* prem_label_amount */
            FOR a IN ( 
                SELECT DECODE( NVL(a.policy_currency,'N'),'N', NVL(b.tax_amt,0) * 
                       a.currency_rt, NVL(b.tax_amt,0)) tax_amt,
                       c.include_tag include_tag
                  FROM GIXX_INVOICE a, GIXX_INV_TAX b, GIIS_TAX_CHARGES c
                 WHERE a.extract_id = b.extract_id
                   AND a.item_grp = b.item_grp
                   AND b.line_cd = c.line_cd
                   AND b.iss_cd = c.iss_cd
                   AND b.tax_cd = c.tax_cd
                   AND a.extract_id = p_extract_id
                   AND v_report.basic_co_insurance_sw = 1
                 UNION
                SELECT DECODE( NVL(a.policy_currency,'N'),'N', NVL(b.tax_amt,0) * 
                       a.currency_rt, NVL(b.tax_amt,0)) tax_amt,
                       c.include_tag include_tag
                  FROM GIXX_ORIG_INVOICE a, GIXX_ORIG_INV_TAX b, GIIS_TAX_CHARGES c
                 WHERE a.extract_id = b.extract_id
                   AND a.item_grp = b.item_grp
                   AND b.line_cd = c.line_cd
                   AND b.iss_cd = c.iss_cd
                   AND b.tax_cd = c.tax_cd
                   AND a.extract_id = p_extract_id
                   AND v_report.basic_co_insurance_sw = 2) 
            LOOP
                IF a.include_tag = 'Y' THEN
                    v_prem_amt :=  v_prem_amt  + a.tax_amt;
                END IF;
            END LOOP;
            
            v_report.prem_label_amount := v_prem_amt;            
            
        END;
        
        /* f_tsi_label1 */
        IF Policy_Docs_Pkg.tsi_label1 IS NULL THEN
            v_report.f_tsi_label1 := 'Total Sum Insured';
        ELSE
            v_report.f_tsi_label1 := Policy_Docs_Pkg.tsi_label1;
        END IF;
        
        /* f_tsi_amt and f_premium_amt */
        DECLARE
            v_main_tsi              GIXX_POLBASIC.tsi_amt%TYPE;
            v_co_ins_sw             VARCHAR2(1);
            v_rate                    GIXX_ITEM.currency_rt%TYPE := 1;
            v_show_doc_total_in_box    VARCHAR2(1) := 'N';
            
            /* for f_premium_amt */
            v_prem_amt      NUMBER(16,2) := 0;
            v_tax_amt         NUMBER(16,2) := 0;
            v_other_charges NUMBER(38,2) := 0;
            v_total_tsi     NUMBER(38,2) := 0;
            v_policy_currency GIXX_INVOICE.policy_currency%TYPE;
            v_param_value_n  GIIS_PARAMETERS.param_value_n%TYPE;
            
            CURSOR G_EXTRACT_ID20 IS
                  SELECT B450.EXTRACT_ID EXTRACT_ID20,
                         SUM(DECODE(NVL(B450.policy_currency,'N'),'N',( NVL(B450.prem_amt,0) *  B450.currency_rt), NVL(B450.prem_amt,0))) PREMIUM_AMT,
                         SUM(DECODE(NVL(B450.policy_currency,'N'),'N',( NVL(B450.tax_amt,0) * B450.currency_rt), NVL(B450.tax_amt,0))) TAX_AMT,
                         SUM(DECODE(NVL(B450.policy_currency,'N'),'N',( NVL(B450.other_charges,0) * B450.currency_rt),NVL(B450.other_charges,0))) OTHER_CHARGES,
                         SUM(DECODE(NVL(B450.policy_currency,'N'),'N',( NVL(B450.prem_amt,0) *  B450.currency_rt), NVL(B450.prem_amt,0))) +
                         SUM(DECODE(NVL(B450.policy_currency,'N'),'N',( NVL(B450.tax_amt,0) * B450.currency_rt), NVL(B450.tax_amt,0))) +
                         SUM(DECODE(NVL(B450.policy_currency,'N'),'N',( NVL(B450.other_charges,0) * B450.currency_rt),NVL(B450.other_charges,0))) TOTAL,
                         B450.policy_currency POLICY_CURRENCY
                    FROM GIXX_INVOICE B450, 
                         GIXX_POLBASIC POL
                   WHERE B450.EXTRACT_ID = p_extract_id
                     AND B450.EXTRACT_ID = POL.EXTRACT_ID
                     AND POL.CO_INSURANCE_SW = 1
                GROUP BY B450.EXTRACT_ID ,B450.POLICY_CURRENCY
                   UNION
                  SELECT B450.EXTRACT_ID EXTRACT_ID20,
                         SUM(DECODE(NVL(B450.policy_currency,'N'),'N',( NVL(B450.prem_amt,0) *  B450.currency_rt), NVL(B450.prem_amt,0))) PREMIUM_AMT,
                         SUM(DECODE(NVL(B450.policy_currency,'N'),'N',( NVL(B450.tax_amt,0) * B450.currency_rt), NVL(B450.tax_amt,0))) TAX_AMT,
                         SUM(DECODE(NVL(B450.policy_currency,'N'),'N',( NVL(B450.other_charges,0) * B450.currency_rt),NVL(B450.other_charges,0))) OTHER_CHARGES,
                         SUM(DECODE(NVL(B450.policy_currency,'N'),'N',( NVL(B450.prem_amt,0) *  B450.currency_rt), NVL(B450.prem_amt,0))) +
                         SUM(DECODE(NVL(B450.policy_currency,'N'),'N',( NVL(B450.tax_amt,0) * B450.currency_rt), NVL(B450.tax_amt,0))) +
                         SUM(DECODE(NVL(B450.policy_currency,'N'),'N',( NVL(B450.other_charges,0) * B450.currency_rt),NVL(B450.other_charges,0))) TOTAL ,
                         B450.policy_currency POLICY_CURRENCY
                    FROM GIXX_ORIG_INVOICE B450,
                         GIXX_POLBASIC POL
                   WHERE B450.extract_id = p_extract_id
                     AND B450.extract_id = POL.extract_id
                     AND POL.co_insurance_sw  = 2
                GROUP BY B450.extract_id,B450.policy_currency;            
        BEGIN
            FOR i IN G_EXTRACT_ID20
            LOOP
                IF i.policy_currency = 'Y' THEN
                    FOR b IN (
                        SELECT currency_rt
                          FROM GIXX_ITEM
                         WHERE extract_id = p_extract_id)
                    LOOP
                        v_rate := b.currency_rt;
                    END LOOP;
                END IF;
                
                v_main_tsi := v_report.basic_tsi_amt / v_rate;
                
                IF v_report.basic_co_insurance_sw = 2 THEN
                    FOR a IN (
                        SELECT (NVL(a.tsi_amt,0) * b.currency_rt)  tsi
                          FROM GIXX_MAIN_CO_INS a, GIXX_INVOICE b
                         WHERE a.extract_id = b.extract_id
                           AND a.extract_id = p_extract_id)
                    LOOP
                        v_main_tsi := a.tsi;
                        EXIT;
                    END LOOP;
                END IF;
                
                v_prem_amt                 := i.premium_amt;
                v_tax_amt                 := i.tax_amt;
                v_other_charges         := i.other_charges;
                v_total_tsi             := i.total;
                v_policy_currency         := i.policy_currency;
                v_show_doc_total_in_box := 'Y';
            END LOOP;              
             
            /* f_tsi_amt */
            v_report.f_tsi_amt := TO_CHAR(v_main_tsi, '999999999990.99');
            
            /* show_doc_total_in_box */
            v_report.show_doc_total_in_box := v_show_doc_total_in_box;
            
            /* f_premium_amt, f_tax_amt, f_other_charges, and f_total_tsi */            
            BEGIN            
                
                v_param_value_n := Giis_Parameters_Pkg.n('NEW_PREM_AMT');
                
                IF v_report.PAR_PAR_STATUS = 10 AND v_report.PAR_PAR_TYPE = 'E' AND v_report.BASIC_CO_INSURANCE_SW = 2 THEN
                    FOR A IN (
                        SELECT b.tax_cd  tax_cd, 
                               DECODE(NVL(A.policy_currency,'N'),'Y', NVL(B.tax_amt,0) * 
                               A.currency_rt, NVL(B.tax_amt,0)) TAX_AMT
                          FROM GIXX_ORIG_INVOICE A, GIXX_ORIG_INV_TAX B,GIXX_POLBASIC POL
                         WHERE A.extract_id = B.extract_id
                           AND A.item_grp = B.item_grp
                           AND A.extract_id = p_extract_id
                           AND A.extract_id = pol.extract_id
                           AND POL.co_insurance_sw = 2)
                    LOOP                
                        IF v_param_value_n = A.tax_cd THEN
                            v_prem_amt := v_prem_amt + A.tax_amt;
                            v_tax_amt := v_tax_amt - A.tax_amt;
                        ELSE
                            v_prem_amt := v_prem_amt;
                            v_tax_amt := v_tax_amt;
                        END IF;             
                    END LOOP; 
                ELSE
                    FOR A IN (
                        SELECT DECODE(NVL(invoice.policy_currency, 'N'),'N',
                               SUM(invtax.tax_amt),
                               SUM(invtax.tax_amt * invoice.currency_rt))    tax_amt, 
                               taxcharg.include_tag                 include_tag
                          FROM GIXX_INVOICE invoice, 
                               GIXX_INV_TAX invtax, 
                               GIIS_TAX_CHARGES taxcharg,
                               GIXX_POLBASIC pol,
                               GIXX_PARLIST par
                         WHERE invtax.iss_cd = taxcharg.iss_cd
                           AND invtax.line_cd = taxcharg.line_cd
                           AND invtax.tax_cd = taxcharg.tax_cd
                           AND invtax.tax_id = taxcharg.tax_id 
                           AND invoice.extract_id = invtax.extract_id
                           AND invoice.extract_id = p_extract_id
                           AND invoice.extract_id = pol.extract_id
                           AND pol.co_insurance_sw = 1
                           AND par.extract_id = pol.extract_id
                           AND DECODE(par.par_status,10,invoice.prem_seq_no,1) = DECODE(par.par_status,10,invtax.prem_seq_no,1)
                           AND invtax.item_grp = invoice.item_grp
                      GROUP BY invtax.extract_id, invtax.tax_cd, taxcharg.tax_desc, taxcharg.include_tag, invoice.policy_currency 
                         UNION
                        SELECT DECODE(NVL(invoice.policy_currency, 'N'),'N',
                               SUM(invtax.tax_amt),
                               SUM(invtax.tax_amt * invoice.currency_rt))    tax_amt, 
                               taxcharg.include_tag                 include_tag
                          FROM GIXX_ORIG_INVOICE invoice, 
                               GIXX_ORIG_INV_TAX invtax, 
                               GIIS_TAX_CHARGES taxcharg,
                               GIXX_POLBASIC pol
                         WHERE invtax.iss_cd = taxcharg.iss_cd
                           AND invtax.line_cd = taxcharg.line_cd
                           AND invtax.tax_cd = taxcharg.tax_cd
                           AND invtax.tax_id = taxcharg.tax_id 
                           AND invoice.extract_id = invtax.extract_id
                           AND invoice.extract_id = p_extract_id
                           AND invoice.extract_id = pol.extract_id
                           AND pol.co_insurance_sw = 2
                      GROUP BY invtax.extract_id, invtax.tax_cd, taxcharg.tax_desc, taxcharg.include_tag, invoice.policy_currency)
                    LOOP                      
                        IF A.include_tag = 'Y' THEN
                            v_prem_amt := v_prem_amt + A.tax_amt;
                            v_tax_amt := v_tax_amt - A.tax_amt;
                        ELSE
                            v_prem_amt := v_prem_amt;
                            v_tax_amt := v_tax_amt;
                        END IF;             
                    END LOOP;     
                END IF;
              
                v_report.f_premium_amt := v_prem_amt;
                v_report.f_tax_amt := v_tax_amt;
                v_report.f_other_charges := v_other_charges;
                v_report.f_total_tsi := v_total_tsi;
                
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_report.f_premium_amt := v_prem_amt;
                    v_report.f_tax_amt := v_tax_amt;
                    v_report.f_other_charges := v_other_charges;
                    v_report.f_total_tsi := v_total_tsi;
            END;

            /* f_currency_name */
            DECLARE
                v_currency_desc   GIIS_CURRENCY.currency_desc%TYPE;
            BEGIN
                IF NVL(v_policy_currency, 'N')  = 'Y' THEN
                    FOR curr_rec IN (
                        SELECT a.currency_desc currency_desc
                          FROM GIIS_CURRENCY a,GIXX_INVOICE b
                         WHERE a.main_currency_cd = b.currency_cd
                           AND b.extract_id = p_extract_id)
                    LOOP
                        v_currency_desc := curr_rec.currency_desc; 
                        EXIT;
                    END LOOP;
                ELSE                    
                    v_currency_desc := Giis_Currency_Pkg.get_default_currency2;
                END IF;
                v_report.f_currency_name := v_currency_desc;
            END;
        END;
        
        /* f_tsi_label2 */
        IF Policy_Docs_Pkg.TSI_LABEL2 IS NULL THEN
            v_report.f_tsi_label2 := 'Accumulated Sum Insured';
        ELSE
            v_report.f_tsi_label2 := Policy_Docs_Pkg.tsi_label2;
        END IF;
        
        /* f_acc_sum */
        DECLARE
            v_total    NUMBER(20) := 0;
            v_line_cd    VARCHAR2(20);
        BEGIN            
            IF v_report.par_par_status >= 10 THEN -- to check if par is already posted
                IF Policy_Docs_Pkg.include_tsi = 'N' THEN            
                    SELECT NVL(SUM(NVL(tsi_amt,0)) ,0)
                      INTO v_total
                      FROM GIPI_ITEM
                     WHERE policy_id IN (SELECT policy_id
                                           FROM GIPI_POLBASIC
                                          WHERE pol_flag NOT IN ('4','5','X')
                                            AND line_cd = DECODE(p_report_id,'OTHER', v_report.basic_line_cd, Giisp.v(Policy_Docs_Pkg.get_giisp_v_param(p_report_id)))
                                            AND subline_cd = v_report.subline_subline_cd
                                            AND pol_seq_no = v_report.basic_pol_seq_no
                                            AND renew_no = v_report.basic_renew_no
                                            AND issue_yy = v_report.basic_issue_yy
                                            AND iss_cd = v_report.basic_iss_cd
                                            AND eff_date <= v_report.eff_date_time) -- removed the TRUNC function on eff_date
                         AND policy_id <> v_report.par_id;
                                                                  
                ELSIF Policy_Docs_Pkg.include_tsi = 'Y' THEN
                    SELECT NVL(SUM(NVL(tsi_amt,0)),0)
                      INTO v_total
                      FROM GIPI_ITEM
                     WHERE policy_id IN (SELECT policy_id
                                           FROM GIPI_POLBASIC
                                          WHERE pol_flag NOT IN ('4','5','X')
                                            AND line_cd = DECODE(p_report_id,'OTHER', v_report.basic_line_cd, Giisp.v(Policy_Docs_Pkg.get_giisp_v_param(p_report_id)))
                                            AND subline_cd = v_report.subline_subline_cd
                                            AND pol_seq_no = v_report.basic_pol_seq_no
                                            AND renew_no = v_report.basic_renew_no
                                            AND issue_yy = v_report.basic_issue_yy
                                            AND iss_cd = v_report.basic_iss_cd
                                            AND eff_date <= v_report.eff_date_time); -- removed the TRUNC function on eff_date  --abie
            
                END IF;    
            ELSIF v_report.par_par_status < 10 THEN
                IF Policy_Docs_Pkg.include_tsi = 'Y' THEN
                    SELECT NVL(DECODE(SUM(NVL(tsi_amt,0)),NULL, TO_NUMBER(v_report.f_tsi_amt), (SUM(NVL(tsi_amt,0)) + TO_NUMBER(v_report.f_tsi_amt))),0)
                      INTO v_total
                      FROM GIPI_ITEM
                     WHERE policy_id IN (SELECT policy_id
                                           FROM GIPI_POLBASIC
                                          WHERE pol_flag NOT IN ('4','5','X')
                                            AND line_cd = DECODE(p_report_id,'OTHER', v_report.basic_line_cd, Giisp.v(Policy_Docs_Pkg.get_giisp_v_param(p_report_id)))
                                            AND subline_cd = v_report.subline_subline_cd
                                            AND pol_seq_no = v_report.basic_pol_seq_no
                                            AND renew_no = v_report.basic_renew_no
                                            AND issue_yy = v_report.basic_issue_yy
                                            AND iss_cd = v_report.basic_iss_cd
                                            AND eff_date <= v_report.eff_date_time); -- removed the TRUNC function on eff_date
            
                ELSIF Policy_Docs_Pkg.include_tsi = 'N' THEN
                    SELECT NVL(SUM(NVL(tsi_amt,0)) ,0)
                      INTO v_total
                      FROM GIPI_ITEM
                     WHERE policy_id IN (SELECT policy_id
                                           FROM GIPI_POLBASIC
                                          WHERE pol_flag NOT IN ('4','5','X')
                                            AND line_cd = DECODE(p_report_id,'OTHER', v_report.basic_line_cd, Giisp.v(Policy_Docs_Pkg.get_giisp_v_param(p_report_id)))
                                            AND subline_cd = v_report.subline_subline_cd
                                            AND pol_seq_no = v_report.basic_pol_seq_no
                                            AND renew_no = v_report.basic_renew_no
                                            AND issue_yy = v_report.basic_issue_yy
                                            AND iss_cd = v_report.basic_iss_cd
                                            AND eff_date <= v_report.eff_date_time); -- removed the TRUNC function on eff_date
                END IF;         
            END IF;
            
            v_report.f_acc_sum := v_total;
        END;
        
        /* f_basic_tsi_spell */
        DECLARE
            v_currency_desc    VARCHAR2(400);
            v_short_name    GIIS_CURRENCY.short_name%TYPE;
            v_short_name2    GIIS_CURRENCY.short_name%TYPE;
            v_tsi             VARCHAR2(400);
            v_num2             VARCHAR2(400);
            v_tsi2             VARCHAR2(400);
            v_num             VARCHAR2(400);
            v_tsi_spell        VARCHAR2(500);
            v_rate            GIXX_ITEM.currency_rt%TYPE := 1;
            v_cents         NUMBER;
        BEGIN
            FOR a IN (
                SELECT DECODE(NVL(b.policy_currency, 'N'),'Y',a.currency_desc) currency_desc,
                       DECODE(NVL(b.policy_currency, 'N'),'Y',a.short_name)    short_name,
                       b.policy_currency
                  FROM GIIS_CURRENCY a,
                       GIXX_INVOICE b
                 WHERE a.main_currency_cd = b.currency_cd
                   AND b.extract_id = p_extract_id)
            LOOP
                v_currency_desc := ' IN '||a.currency_desc; 
                v_short_name    := a.short_name;
                IF a.policy_currency = 'Y' THEN
                    FOR b IN (
                          SELECT currency_rt
                            FROM GIXX_ITEM
                           WHERE extract_id = p_extract_id)
                    LOOP
                        v_rate := b.currency_rt;
                    END LOOP;
                    EXIT;
                END IF;
            END LOOP;
                      
            IF v_currency_desc = ' IN ' OR v_currency_desc IS NULL THEN
                FOR b IN (
                    SELECT currency_desc, short_name
                      FROM GIIS_CURRENCY
                     WHERE short_name IN ( SELECT param_value_v
                                             FROM GIAC_PARAMETERS
                                            WHERE param_name = 'DEFAULT_CURRENCY'))
                LOOP
                    v_short_name    := b.short_name;
                    v_currency_desc := ' IN '||b.currency_desc;
                    EXIT;
                END LOOP;
            END IF;
            
            v_short_name2 := v_short_name;              
                    
            IF v_report.basic_co_insurance_sw <> 2 THEN            
                FOR c IN (
                  SELECT LTRIM (TRUNC(((a.tsi_amt/v_rate)-TRUNC (a.tsi_amt/v_rate))*100) ) cents                  
                    FROM GIXX_POLBASIC a
                   WHERE a.extract_id = p_extract_id)
                LOOP
                    v_cents := c.cents;
                    EXIT;
                END LOOP;
                        
                IF v_cents = 0 AND NVL(Policy_Docs_Pkg.PRINT_CENTS,'N') = 'N' THEN -- print 'value/cents' when value is not = 0
                    FOR c IN (
                        SELECT UPPER( Dh_Util.spell ( TRUNC ( a.tsi_amt/v_rate)  )    ) tsi,
                               DECODE(Policy_Docs_Pkg.PRINT_SHORT_NAME,'Y',v_short_name2||' ')||LTRIM ( RTRIM ( TO_CHAR ( a.tsi_amt/v_rate  , '999,999,999,999,990.00' ) ) ) tsi_num,
                               UPPER( Dh_Util.spell ( TRUNC ( a.ann_tsi_amt/v_rate)  )    ) tsi2,
                               DECODE(Policy_Docs_Pkg.PRINT_SHORT_NAME,'Y',v_short_name2||' ')||LTRIM ( RTRIM ( TO_CHAR ( a.ann_tsi_amt/v_rate  , '999,999,999,999,990.00' ) ) ) tsi_num2    
                          FROM GIXX_POLBASIC a
                         WHERE a.extract_id = p_extract_id)
                    LOOP
                        v_tsi  := c.tsi;
                        v_num  := c.tsi_num;
                        v_tsi2 := c.tsi2;
                        v_num2 := c.tsi_num2;
                        EXIT;
                    END LOOP;
                ELSIF NVL(Policy_Docs_Pkg.PRINT_CENTS,'N') = 'Y' THEN -- print 'value/cents' when even value = 0
                    FOR c IN (
                        SELECT UPPER(Dh_Util.spell ( TRUNC ( a.tsi_amt/v_rate)) ||    ' AND '|| LTRIM (ROUND/*roundtrunc*/(((a.tsi_amt/v_rate)-TRUNC (a.tsi_amt/v_rate))*100)) ||'/100 ' ) tsi,
                               DECODE(Policy_Docs_Pkg.PRINT_SHORT_NAME,'Y',v_short_name2||' ')||LTRIM ( RTRIM ( TO_CHAR ( a.tsi_amt/v_rate  , '999,999,999,999,990.00' ) ) ) tsi_num,
                               UPPER( Dh_Util.spell ( TRUNC ( a.ann_tsi_amt/v_rate)) ||' AND '|| LTRIM (ROUND/*roundtrunc*/(((a.ann_tsi_amt/v_rate)-TRUNC (a.ann_tsi_amt/v_rate))*100)) ||'/100' ) tsi2, --to not print 0/100 on tsi 
                               DECODE(Policy_Docs_Pkg.PRINT_SHORT_NAME,'Y',v_short_name2||' ')||LTRIM ( RTRIM ( TO_CHAR ( a.ann_tsi_amt/v_rate  , '999,999,999,999,990.00' ) ) ) tsi_num2
                          FROM GIXX_POLBASIC a
                         WHERE a.extract_id = p_extract_id)
                    LOOP
                        v_tsi  := c.tsi;
                        v_num  := c.tsi_num;
                        v_tsi2 := c.tsi2;
                        v_num2 := c.tsi_num2;
                        EXIT;
                    END LOOP;                    
                ELSE -- will not print 'value/cents'
                    FOR c IN (
                        SELECT UPPER( Dh_Util.spell ( TRUNC ( a.tsi_amt/v_rate)) || DECODE(LTRIM (ROUND/*trunc*/(((a.tsi_amt/v_rate)-TRUNC (a.tsi_amt/v_rate))*100)),0,'',
                               ' AND '|| LTRIM (ROUND/*trunc*/(((a.tsi_amt/v_rate)-TRUNC (a.tsi_amt/v_rate))*100)) ||'/100' )) tsi,
                               DECODE(Policy_Docs_Pkg.PRINT_SHORT_NAME,'Y',v_short_name2||' ')||LTRIM ( RTRIM ( TO_CHAR ( a.tsi_amt/v_rate  , '999,999,999,999,990.00' ) ) ) tsi_num,
                               UPPER( Dh_Util.spell ( TRUNC ( a.ann_tsi_amt/v_rate)) || DECODE(LTRIM (ROUND/*trunc*/(((a.ann_tsi_amt/v_rate)-TRUNC (a.ann_tsi_amt/v_rate))*100)),0,'',
                               ' AND '|| LTRIM (ROUND/*trunc*/(((a.ann_tsi_amt/v_rate)-TRUNC (a.ann_tsi_amt/v_rate))*100)) ||'/100' )) tsi2, --Connie 02/22/2007, to not print 0/100 on tsi 
                               DECODE(Policy_Docs_Pkg.PRINT_SHORT_NAME,'Y',v_short_name2||' ')||LTRIM ( RTRIM ( TO_CHAR ( a.ann_tsi_amt/v_rate  , '999,999,999,999,990.00' ) ) ) tsi_num2
                          FROM GIXX_POLBASIC a
                         WHERE a.extract_id = p_extract_id)
                    LOOP
                        v_tsi  := c.tsi;
                        v_num  := c.tsi_num;
                        v_tsi2 := c.tsi2;
                        v_num2 := c.tsi_num2;
                        EXIT;
                    END LOOP;
                END IF;    
                --edited by d.alcantara, 11-02-2011
                IF Policy_Docs_Pkg.DISPLAY_ANN_TSI = 'Y' THEN    
                    v_report.f_basic_tsi_spell := ( v_tsi2||v_currency_desc||' ('/*||v_short_name||' '*/||v_num2||')');
					--v_report.f_basic_tsi_spell := ( v_tsi2||v_currency_desc||' ('||v_short_name||' '||v_num2||')');--by bonok :: 8.31.2012
                ELSE
                    v_report.f_basic_tsi_spell := ( v_tsi||v_currency_desc||' ('/*||v_short_name||' '*/||v_num||')');
					--v_report.f_basic_tsi_spell := ( v_tsi||v_currency_desc||' ('||v_short_name||' '||v_num||')');--by bonok :: 8.31.2012
                END IF;
            ELSE
                FOR X IN (
                    SELECT LTRIM(TRUNC((SUM(DECODE(NVL(c.policy_currency,'N'),'Y',co.co_ri_tsi_amt,co.co_ri_tsi_amt*c.currency_rt))  
                           - TRUNC(SUM(DECODE(NVL(c.policy_currency,'N'),'Y',co.co_ri_tsi_amt,co.co_ri_tsi_amt*c.currency_rt)))) * 100)) cents
                      FROM GIXX_CO_INSURER co, GIIS_REINSURER re,GIXX_INVOICE c,GIXX_POLBASIC d
                     WHERE co.co_ri_cd = re.ri_cd
                       AND c.extract_id  = co.extract_id
                       AND co.extract_id = p_extract_id 
                       AND co.extract_id = d.extract_id)          
                LOOP
                    v_cents := X.cents;
                    EXIT;
                END LOOP;
                
                IF v_cents = 0 AND NVL(Policy_Docs_Pkg.PRINT_CENTS,'N') = 'N' THEN                                             -- print 'value/cents' when value is not = 0
                    FOR y IN (
                        SELECT UPPER(Dh_Util.spell(SUM(DECODE(NVL(c.policy_currency,'N'),'Y',co.co_ri_tsi_amt,co.co_ri_tsi_amt*c.currency_rt)))) tsi,
                               DECODE(Policy_Docs_Pkg.PRINT_SHORT_NAME,'Y',v_short_name2||' ')||LTRIM ( RTRIM (TO_CHAR (SUM(DECODE(NVL(c.policy_currency,'N'),'Y',co.co_ri_tsi_amt,co.co_ri_tsi_amt*c.currency_rt)), '999,999,999,999,990.00' ))) tsi_num
                          FROM GIXX_CO_INSURER co, GIIS_REINSURER re,GIXX_INVOICE c,GIXX_POLBASIC d
                         WHERE co.co_ri_cd   = re.ri_cd
                           AND c.extract_id  = co.extract_id
                           AND co.extract_id = p_extract_id 
                           AND co.extract_id = d.extract_id)
                    LOOP             
                        v_tsi  := y.tsi;
                        v_num  := y.tsi_num;
                        EXIT;
                    END LOOP;
                ELSIF NVL(Policy_Docs_Pkg.PRINT_CENTS,'N') = 'Y' THEN -- print 'value/cents' when even value = 0
                    FOR c IN (
                        SELECT UPPER( Dh_Util.spell ( TRUNC ( a.tsi_amt/v_rate)) ||    ' AND '|| LTRIM (ROUND/*roundtrunc*/(((a.tsi_amt/v_rate)-TRUNC (a.tsi_amt/v_rate))*100)) ||'/100 ' ) tsi,
                               DECODE(Policy_Docs_Pkg.PRINT_SHORT_NAME,'Y',v_short_name2||' ')||LTRIM ( RTRIM ( TO_CHAR ( a.tsi_amt/v_rate  , '999,999,999,999,990.00' ) ) ) tsi_num,
                               UPPER( Dh_Util.spell ( TRUNC ( a.ann_tsi_amt/v_rate)) ||' AND '|| LTRIM (ROUND/*roundtrunc*/(((a.ann_tsi_amt/v_rate)-TRUNC (a.ann_tsi_amt/v_rate))*100)) ||'/100 ' ) tsi2, --Connie 02/22/2007, to not print 0/100 on tsi 
                               DECODE(Policy_Docs_Pkg.PRINT_SHORT_NAME,'Y',v_short_name2||' ')||LTRIM ( RTRIM ( TO_CHAR ( a.ann_tsi_amt/v_rate  , '999,999,999,999,990.00' ) ) ) tsi_num2
                          FROM GIXX_POLBASIC a
                         WHERE a.extract_id = p_extract_id)
                    LOOP
                        v_tsi  := c.tsi;
                        v_num  := c.tsi_num;
                        v_tsi2 := c.tsi2;
                        v_num2 := c.tsi_num2;
                        EXIT;
                    END LOOP;
                ELSE -- will not print 'value/cents'
                    FOR y IN (
                        SELECT Dh_Util.spell(SUM(DECODE(NVL(c.policy_currency,'N'),'Y',co.co_ri_tsi_amt,co.co_ri_tsi_amt*c.currency_rt))) || DECODE(LTRIM (ROUND((SUM(DECODE(NVL(c.policy_currency,'N'),'Y',co.co_ri_tsi_amt,co.co_ri_tsi_amt*c.currency_rt))
                               - TRUNC(SUM(DECODE(NVL(c.policy_currency,'N'),'Y',co.co_ri_tsi_amt,co.co_ri_tsi_amt*c.currency_rt)))) * 100) ),0,'',
                               ' AND '|| LTRIM (ROUND((SUM(DECODE(NVL(c.policy_currency,'N'),'Y',co.co_ri_tsi_amt,co.co_ri_tsi_amt*c.currency_rt)) 
                               - TRUNC(SUM(DECODE(NVL(c.policy_currency,'N'),'Y',co.co_ri_tsi_amt,co.co_ri_tsi_amt*c.currency_rt)))) * 100) ||'/100' )) tsi, --Connie 02/22/2007, to not print 0/100
                               DECODE(Policy_Docs_Pkg.PRINT_SHORT_NAME,'Y',v_short_name2||' ')||LTRIM ( RTRIM (TO_CHAR (SUM(DECODE(NVL(c.policy_currency,'N'),'Y',co.co_ri_tsi_amt,co.co_ri_tsi_amt*c.currency_rt)), '999,999,999,999,990.00' ))) tsi_num
                          FROM GIXX_CO_INSURER co, GIIS_REINSURER re,GIXX_INVOICE c,GIXX_POLBASIC d 
                         WHERE co.co_ri_cd = re.ri_cd 
                           AND c.extract_id = co.extract_id 
                           AND co.extract_id = p_extract_id 
                           AND co.extract_id = d.extract_id)
                    LOOP
                        v_tsi  := y.tsi;
                        v_num  := y.tsi_num;                    
                        EXIT;
                    END LOOP;      
                END IF; 
                --edited by d.alcantara, 11-02-2011
                v_report.f_basic_tsi_spell := ( v_tsi||v_currency_desc||' ('/*||' '||v_short_name||' '*/||v_num||')');
            END IF;
        END;
        
        /* f_total_in_words */
        DECLARE
            CURSOR G_EXTRACT_ID3 IS
              SELECT tsi.extract_id extract_id3, 
                     tsi.fx_name tsi_fx_name, 
                     tsi.fx_desc tsi_fx_desc,   
                     UPPER( tsi.fx_name|| ' ' || Dh_Util.spell ( TRUNC ( SUM(tsi.itm_tsi) ) )
                     || ' AND ' || LTRIM ( (( SUM(tsi.itm_tsi) )-( TRUNC ( SUM(tsi.itm_tsi) ) ) )*100)
                     || '/100 (' || LTRIM ( RTRIM ( TO_CHAR ( SUM(tsi.itm_tsi), '999,999,999,999,999.00' ) ) )
                     || ') IN ' || tsi.fx_desc ) tsi_spelled_tsi
                FROM (SELECT item.extract_id extract_id,
                             SUM(DECODE(NVL(invoice.policy_currency,'N'), 'Y', NVL(item.tsi_amt, 0),
                             'N', NVL(item.tsi_amt, 0) * invoice.currency_rt,
                             NVL(item.tsi_amt, 0))) itm_tsi,  
                             DECODE(NVL(invoice.policy_currency,'N'), 'Y', fx.short_name,
                                'N', 'PHP', fx.short_name) fx_name,  
                             DECODE(NVL(invoice.policy_currency,'N'), 'Y', fx.currency_desc,
                                'N', 'PHILIPPINE PESO', fx.currency_desc ) fx_desc,  
                             invoice.currency_cd invoice_fx_cd, 
                             AVG(invoice.currency_rt) avg_fx_rt           
                        FROM GIXX_ITEM item,  GIIS_CURRENCY fx,  GIXX_INVOICE  invoice,GIXX_POLBASIC pol
                       WHERE (( item.currency_cd= fx.main_currency_cd)
                         AND ( item.extract_id= invoice.extract_id)
                         AND ( fx.main_currency_cd= invoice.currency_cd))
                         AND item.extract_id = p_extract_id
                         AND item.extract_id = pol.extract_id
                         AND pol.co_insurance_sw IN ('1','3')
                    GROUP BY item.extract_id, 
                             DECODE(NVL(invoice.policy_currency,'N'), 'Y', fx.short_name,
                                'N', 'PHP', fx.short_name),
                             DECODE(NVL(invoice.policy_currency,'N'), 'Y', fx.currency_desc,
                                'N', 'PHILIPPINE PESO',    fx.currency_desc ),  
                             invoice.currency_cd) tsi
            GROUP BY tsi.extract_id, tsi.fx_name, tsi.fx_desc
               UNION
              SELECT tsi.extract_id extract_id3, 
                     tsi.fx_name tsi_fx_name, 
                     tsi.fx_desc tsi_fx_desc,   
                     UPPER( tsi.fx_name|| ' ' || Dh_Util.spell ( TRUNC ( SUM(tsi.itm_tsi) ) )
                     || ' AND ' || LTRIM ( (( SUM(tsi.itm_tsi) )-( TRUNC ( SUM(tsi.itm_tsi) ) ) )*100)
                     || '/100 (' || LTRIM ( RTRIM ( TO_CHAR ( SUM(tsi.itm_tsi), '999,999,999,999,999.00' ) ) )
                     || ') IN ' || tsi.fx_desc ) tsi_spelled_tsi
                FROM (SELECT item.extract_id extract_id,
                             SUM(DECODE(NVL(invoice.policy_currency,'N'), 'Y', NVL(item.tsi_amt, 0),
                             'N', NVL(item.tsi_amt, 0) * invoice.currency_rt,
                             NVL(item.tsi_amt, 0))) itm_tsi,  
                             DECODE(NVL(invoice.policy_currency,'N'), 'Y', fx.short_name,
                                'N', 'PHP', fx.short_name) fx_name,  
                             DECODE(NVL(invoice.policy_currency,'N'), 'Y', fx.currency_desc,
                                'N', 'PHILIPPINE PESO', fx.currency_desc ) fx_desc,  
                             invoice.currency_cd invoice_fx_cd, 
                             AVG(invoice.currency_rt) avg_fx_rt           
                        FROM GIXX_ITEM item,  GIIS_CURRENCY fx,  GIXX_ORIG_INVOICE  invoice,GIXX_POLBASIC pol
                       WHERE (( item.currency_cd= fx.main_currency_cd)
                         AND ( item.extract_id= invoice.extract_id)
                         AND ( fx.main_currency_cd= invoice.currency_cd))
                         AND item.extract_id = p_extract_id
                         AND item.extract_id = pol.extract_id
                         AND pol.co_insurance_sw = '2'
                    GROUP BY item.extract_id, 
                             DECODE(NVL(invoice.policy_currency,'N'), 'Y', fx.short_name,
                                'N', 'PHP', fx.short_name),
                             DECODE(NVL(invoice.policy_currency,'N'), 'Y', fx.currency_desc,
                                'N', 'PHILIPPINE PESO',    fx.currency_desc ),  
                             invoice.currency_cd) tsi
            GROUP BY tsi.extract_id, tsi.fx_name, tsi.fx_desc;
            
            v_tsi_spelled_tsi     VARCHAR2(500);
            v_tsi_fx_desc         VARCHAR2(100);            
        BEGIN
            FOR i IN G_EXTRACT_ID3
            LOOP
                v_tsi_spelled_tsi := i.tsi_spelled_tsi;
                v_tsi_fx_desc := i.tsi_fx_desc;
            END LOOP;
            
            /* f_total_in_words */
            DECLARE
                v_spell_tsi  VARCHAR2(500) := v_tsi_spelled_tsi;
                v_co_ins_sw NUMBER(1);
            BEGIN
                IF v_report.basic_co_insurance_sw = 2 THEN
                    FOR a IN (
                        SELECT UPPER( Dh_Util.spell ( TRUNC ( DECODE(NVL(c.policy_currency, 'N'),'N',a.tsi_amt,a.tsi_amt*c.currency_rt) ) )
                               || ' AND ' || LTRIM (( (DECODE(NVL(c.policy_currency, 'N'),'N',a.tsi_amt,a.tsi_amt*c.currency_rt))-( TRUNC (DECODE(NVL(c.policy_currency, 'N'),'N',a.tsi_amt,a.tsi_amt*c.currency_rt)   ) ))*100 )
                               || '/100 (' || LTRIM ( RTRIM ( TO_CHAR ( DECODE(NVL(c.policy_currency, 'N'),'N',a.tsi_amt,a.tsi_amt*c.currency_rt)  , '999,999,999,999,999.00' ) ) )
                               || ') IN ' || v_tsi_fx_desc ) tsi
                          FROM GIXX_MAIN_CO_INS a, GIXX_ORIG_INVOICE c 
                         WHERE a.extract_id = c.extract_id
                           AND a.extract_id = p_extract_id)
                    LOOP
                        v_spell_tsi := a.tsi;
                        EXIT;
                    END LOOP;
                END IF;
                v_report.f_total_in_words := v_spell_tsi;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_report.f_total_in_words := v_tsi_spelled_tsi;
            END;            
        END;
        
        /* f_acc_sum_word */
        DECLARE
            total_amt /*NUMBER(20)*/ GIPI_ITEM.tsi_amt%TYPE := 0;
            v_currency_desc        VARCHAR2(400);
            v_short_name        GIIS_CURRENCY.short_name%TYPE;
            v_short_name2        GIIS_CURRENCY.short_name%TYPE;
            v_tsi                 VARCHAR2(400);
            v_num2                 VARCHAR2(400);
            v_tsi2                 VARCHAR2(400);
            v_num                 VARCHAR2(400);
            v_tsi_spell            VARCHAR2(500);
            v_rate                GIXX_ITEM.currency_rt%TYPE := 1;
            v_cents               NUMBER;
            v_policy_cur        GIXX_INVOICE.policy_currency%TYPE; 
        BEGIN
            v_tsi := 0;
            FOR a IN (
                SELECT DECODE(NVL(b.policy_currency, 'N'),'Y',a.currency_desc) currency_desc,
                       DECODE(NVL(b.policy_currency, 'N'),'Y',a.short_name)    short_name,
                       b.policy_currency
                  FROM GIIS_CURRENCY a,
                       GIXX_INVOICE b
                 WHERE a.main_currency_cd = b.currency_cd
                   AND b.extract_id = p_extract_id)
            LOOP
                v_currency_desc := ' IN '||a.currency_desc;
                v_short_name    := a.short_name;
            
                IF a.policy_currency = 'Y' THEN
                   v_policy_cur := 'Y';
                    FOR b IN (
                        SELECT currency_rt
                          FROM GIXX_ITEM
                         WHERE extract_id = p_extract_id)
                    LOOP
                        v_rate := b.currency_rt;
                    END LOOP;
                    EXIT;
                ELSE
                    v_policy_cur := 'N'; 
                END IF;
            END LOOP;
                      
            IF v_currency_desc = ' IN ' OR v_currency_desc IS NULL THEN
                FOR b IN (
                    SELECT currency_desc, short_name
                      FROM GIIS_CURRENCY
                     WHERE short_name IN (SELECT param_value_v
                                            FROM GIAC_PARAMETERS
                                           WHERE param_name = 'DEFAULT_CURRENCY'))
                LOOP
                    v_short_name    := b.short_name;
                    v_currency_desc := ' IN '||b.currency_desc;
                    EXIT;
                END LOOP;
            END IF;         
            
            v_short_name2 := v_short_name;
            
            IF v_report.par_par_status >= 10 THEN -- to check if par is already posted 
                IF Policy_Docs_Pkg.include_tsi = 'N' THEN
                    SELECT SUM(NVL(tsi_amt,0)*DECODE(v_policy_cur, 'Y',1,NVL(currency_rt, 0))) 
                      INTO total_amt
                      FROM GIPI_ITEM
                     WHERE policy_id IN (
                            SELECT policy_id 
                              FROM GIPI_POLBASIC                                                                 
                             WHERE line_cd = DECODE(p_report_id,'OTHER', v_report.basic_line_cd, Giisp.v(Policy_Docs_Pkg.get_giisp_v_param(p_report_id)))
                               AND pol_flag NOT IN ('4','5','X')
                               AND subline_cd = v_report.subline_subline_cd
                               AND iss_cd = v_report.basic_iss_cd
                               AND issue_yy = v_report.basic_issue_yy                                                           
                               AND pol_seq_no = v_report.basic_pol_seq_no
                               AND renew_no = v_report.basic_renew_no
                               AND eff_date <= v_report.eff_date_time -- removed the TRUNC function on eff_date
                               AND POLICY_ID <> v_report.PAR_ID);

                    FOR X IN (
                        SELECT UPPER( NVL(Dh_Util.spell ( TRUNC (total_amt)  ),'ZERO')
                               || ' AND ' || LTRIM (TRUNC(((total_amt)-TRUNC (total_amt))*100) )
                               || '/100 ') tsi_word,
                               /*DECODE(POLICY_DOCS_PKG.PRINT_SHORT_NAME,'Y',v_short_name2||' ') ||*/LTRIM ( RTRIM ( TO_CHAR ( total_amt  , '999,999,999,999,990.00' ) ) ) tsi_amt
                          FROM GIXX_POLBASIC a
                         WHERE a.extract_id = p_extract_id)            
                    LOOP
                        v_tsi := X.tsi_word;
                        v_num := X.tsi_amt;
                    END LOOP;                                                             
                ELSIF Policy_Docs_Pkg.include_tsi = 'Y' THEN            
                    SELECT SUM(NVL(tsi_amt,0)*DECODE(v_policy_cur, 'Y',1,NVL(currency_rt, 0))) 
                      INTO total_amt 
                      FROM GIPI_ITEM
                     WHERE policy_id IN (
                            SELECT policy_id 
                              FROM GIPI_POLBASIC
                             WHERE pol_flag NOT IN ('4','5','X')
                               AND line_cd = DECODE(p_report_id,'OTHER', v_report.basic_line_cd, Giisp.v(Policy_Docs_Pkg.get_giisp_v_param(p_report_id)))
                               AND subline_cd = v_report.subline_subline_cd
                               AND iss_cd = v_report.basic_iss_cd
                               --AND endt_seq_no = :basic_endt_seq_no
                               AND issue_yy = v_report.basic_issue_yy
                               AND pol_seq_no = v_report.basic_pol_seq_no
                               AND renew_no = v_report.basic_renew_no
                               AND eff_date <= v_report.eff_date_time); -- removed the TRUNC function on eff_date

                    FOR X IN (
                        SELECT NVL(Dh_Util.spell(TRUNC(NVL(SUM(tsi_amt*DECODE(v_policy_cur, 'Y',1,currency_rt)),0))),'ZERO')|| --added trunc by rose b 10/17/2008 to avoid redundant display of cents
                               ' AND '|| LTRIM (ROUND(((NVL(SUM(tsi_amt*DECODE(v_policy_cur, 'Y',1,currency_rt)),0)) - TRUNC (NVL(SUM(tsi_amt*DECODE(v_policy_cur, 'Y',1,currency_rt)),0)))*100)) ||'/100 ' tsi_word, 
                               LTRIM( RTRIM( TO_CHAR(NVL(SUM(tsi_amt*DECODE(v_policy_cur, 'Y',1,currency_rt)),0), '999,999,999,999,990.00'))) tsi_amt 
                          FROM GIPI_ITEM
                         WHERE policy_id IN (
                                SELECT policy_id
                                  FROM GIPI_POLBASIC
                                 WHERE pol_flag NOT IN ('4','5','X')
                                   AND line_cd = DECODE(p_report_id,'OTHER', v_report.basic_line_cd, Giisp.v(Policy_Docs_Pkg.get_giisp_v_param(p_report_id)))
                                   AND subline_cd = v_report.subline_subline_cd
                                   AND pol_seq_no = v_report.basic_pol_seq_no
                                   AND renew_no = v_report.basic_renew_no
                                   AND issue_yy = v_report.basic_issue_yy
                                   AND iss_cd = v_report.basic_iss_cd
                                   AND eff_date <= v_report.eff_date_time))     
                    LOOP
                        v_tsi := X.tsi_word;
                        v_num := X.tsi_amt;
                    END LOOP;
                END IF;    
            ELSIF v_report.par_par_status < 10 THEN
                IF Policy_Docs_Pkg.include_tsi = 'Y' THEN
                    SELECT SUM(NVL(tsi_amt,0)*DECODE(v_policy_cur, 'Y',1,NVL(currency_rt, 0))) + Gixx_Invoice_Pkg.get_pol_doc_tsi_amt(p_extract_id, NVL(v_report.basic_tsi_amt, 0), v_report.basic_co_insurance_sw)
                      INTO total_amt 
                      FROM GIPI_ITEM
                     WHERE policy_id IN (
                            SELECT policy_id 
                              FROM GIPI_POLBASIC
                             WHERE pol_flag NOT IN ('4','5','X')
                               AND line_cd = DECODE(p_report_id,'OTHER', v_report.basic_line_cd, Giisp.v(Policy_Docs_Pkg.get_giisp_v_param(p_report_id)))
                               AND subline_cd = v_report.subline_subline_cd
                               AND iss_cd = v_report.basic_iss_cd
                               --AND endt_seq_no = :basic_endt_seq_no
                               AND issue_yy = v_report.basic_issue_yy
                               AND pol_seq_no = v_report.basic_pol_seq_no
                               AND renew_no = v_report.basic_renew_no
                               AND TRUNC(eff_date) <= v_report.eff_date_time); -- returned the TRUNC function on eff_date                                                               

                    FOR X IN (
                        SELECT UPPER( NVL(Dh_Util.spell ( TRUNC (NVL(total_amt,0))  ),'ZERO')
                               || ' AND ' || LTRIM (TRUNC(((NVL(total_amt,0))-TRUNC (NVL(total_amt,0)))*100) )
                               || '/100 ') tsi_word,
                               /*DECODE(POLICY_DOCS_PKG.PRINT_SHORT_NAME,'Y',v_short_name2||' ') ||*/LTRIM ( RTRIM ( TO_CHAR (total_amt  , '999,999,999,999,990.00' ) ) ) tsi_amt
                          FROM GIXX_POLBASIC a
                         WHERE a.extract_id = p_extract_id)
                    LOOP
                        v_tsi := X.tsi_word;
                        v_num := X.tsi_amt;
                    END LOOP;    
                ELSIF Policy_Docs_Pkg.include_tsi = 'N' THEN
                    SELECT SUM(tsi_amt*DECODE(v_policy_cur, 'Y',1,NVL(currency_rt, 0))) 
                      INTO total_amt
                      FROM GIPI_ITEM
                     WHERE policy_id IN (
                            SELECT policy_id
                              FROM GIPI_POLBASIC
                             WHERE pol_flag NOT IN ('4','5','X')
                               AND line_cd = DECODE(p_report_id,'OTHER', v_report.basic_line_cd, Giisp.v(Policy_Docs_Pkg.get_giisp_v_param(p_report_id)))
                               AND subline_cd = v_report.subline_subline_cd
                               AND pol_seq_no = v_report.basic_pol_seq_no
                               AND renew_no = v_report.basic_renew_no
                               AND issue_yy = v_report.basic_issue_yy             
                               AND iss_cd = v_report.basic_iss_cd                         
                               AND eff_date <= v_report.eff_date_time); -- removed the TRUNC function on eff_date

                    FOR X IN (
                        SELECT UPPER( NVL(Dh_Util.spell ( TRUNC (total_amt)  ),'ZERO')
                               || ' AND ' || LTRIM (TRUNC(((total_amt)-TRUNC (total_amt))*100) )
                               || '/100 ') tsi_word,
                               /*DECODE(POLICY_DOCS_PKG.PRINT_SHORT_NAME,'Y',v_short_name2||' ') ||*/LTRIM ( RTRIM ( TO_CHAR (total_amt  , '999,999,999,999,990.00' ) ) ) tsi_amt
                          FROM GIXX_POLBASIC a
                         WHERE a.extract_id = p_extract_id)
                    LOOP
                        v_tsi := X.tsi_word;
                        v_num := X.tsi_amt;
                    END LOOP;
                END IF;         
            END IF;
            
            v_report.f_acc_sum_word := ( v_tsi||v_currency_desc||' ('||' '||v_short_name||' '||v_num||')' );
        END;
        
        /* show_mortgagee */
        DECLARE
            v_exists             VARCHAR2(1) := 'N';
            v_show                 VARCHAR2(1) := 'N';
            v_itmperil_count    NUMBER := 0;
        BEGIN
            IF p_report_id = 'AVIATION' THEN
                FOR i IN (
                    SELECT extract_id
                      FROM GIXX_MORTGAGEE
                     WHERE extract_id = p_extract_id)
                LOOP
                    v_exists := 'Y';
                END LOOP;
                
                /*
                IF v_exists = 'Y' AND Policy_Docs_Pkg.PRINT_MORTGAGEE = 'Y' OR Policy_Docs_Pkg.PRINT_NULL_MORTGAGEE = 'Y' THEN
                    v_show := 'Y';
                ELSE
                    v_show := 'N';
                END IF;
                */
                v_show := v_exists;
            ELSE
                IF Policy_Docs_Pkg.PRINT_NULL_MORTGAGEE = 'Y' THEN
                    v_show := 'Y';
                ELSE
                    FOR a IN (
                        SELECT extract_id
                          FROM GIXX_MORTGAGEE
                         WHERE EXTRACT_ID = p_extract_id)
                    LOOP
                        v_exists := 'Y';
                        EXIT;
                    END LOOP;
                    
                    IF p_report_id = 'ENGINEERING' THEN
                        IF v_exists = 'Y' THEN
                            v_show := v_exists;
                        ELSE
                            IF v_report.basic_co_insurance_sw = 1 THEN
                                FOR a IN (
                                    SELECT extract_id
                                      FROM GIXX_ITMPERIL
                                     WHERE extract_id = p_extract_id)
                                LOOP
                                    v_itmperil_count := 1;
                                    EXIT;
                                END LOOP;
                            ELSE
                                FOR a IN (
                                    SELECT extract_id
                                      FROM GIXX_ORIG_ITMPERIL
                                     WHERE extract_id = p_extract_id)
                                LOOP
                                    v_itmperil_count := 1;
                                    EXIT;
                                END LOOP;
                            END IF;
                            
                            IF v_exists = 'Y' AND v_itmperil_count > 0 AND Policy_Docs_Pkg.PRINT_MORTGAGEE_NAME = 'Y' THEN
                                v_show := 'Y';
                            ELSE
                                v_show := 'N';
                            END IF;
                        END IF;
                    ELSE
                        IF v_exists = 'N' OR Policy_Docs_Pkg.PRINT_MORTGAGEE = 'N' THEN
                            v_show := 'N';
                        ELSE
                            v_show := 'Y';
                        END IF;
                    END IF;
                END IF;            
            END IF;            
            v_report.show_mortgagee := v_show;
        END;
        
        /* show_deductible_text */
        DECLARE
            v_ded_text  GIXX_DEDUCTIBLES.deductible_text%TYPE;
        BEGIN
            FOR X IN (
                SELECT deductible_text
                  FROM GIXX_DEDUCTIBLES
                 WHERE extract_id = p_extract_id
                     AND item_no = 0)
            LOOP
                v_ded_text := X.deductible_text;
                EXIT;
            END LOOP;
            
            v_report.show_deductible_text := v_ded_text;
        END;
        
        /* f_renewal */
        DECLARE
            v_policy  VARCHAR2(100):= NULL;
        BEGIN
            IF v_report.par_par_status = 10 THEN
                FOR a IN (
                    SELECT a.line_cd || '-' || a.subline_cd || '-' ||a.iss_cd || '-' ||
                           LTRIM(TO_CHAR(a.issue_yy, '09')) || '-' ||LTRIM(TO_CHAR(a.pol_seq_no, '099999')) || '-' || 
                           LTRIM(TO_CHAR(a.renew_no, '09')) policy_no 
                      FROM GIPI_POLBASIC a, GIPI_POLNREP b
                     WHERE b.new_policy_id = v_report.par_id
                       AND a.policy_id = b.old_policy_id)
                LOOP
                    IF v_policy IS NULL THEN
                        v_policy := a.policy_no;
                    ELSE
                        v_policy := v_policy || CHR(10) || a.policy_no;
                    END IF;
                END LOOP;
            ELSE
                FOR a IN (
                    SELECT a.line_cd || '-' || a.subline_cd || '-' || a.iss_cd || '-' ||
                           LTRIM(TO_CHAR(a.issue_yy, '09')) || '-' ||
                           LTRIM(TO_CHAR(a.pol_seq_no, '099999')) || '-' || 
                           LTRIM(TO_CHAR(a.renew_no, '09')) policy_no 
                      FROM GIPI_POLBASIC a, GIPI_WPOLNREP b
                     WHERE b.par_id = p_extract_id
                       AND a.policy_id = b.old_policy_id) 
                LOOP
                    IF v_policy IS NULL THEN
                        v_policy := a.policy_no;
                    ELSE
                        v_policy := v_policy || CHR(10) || a.policy_no;
                    END IF;
                END LOOP;
            END IF;
            
            v_report.f_renewal := v_policy;
        END;
        
        /* show_polgenin */
        DECLARE
            v_show_polgenin VARCHAR2(1) := 'N';
            v_show_polgenin_gen_info VARCHAR2(1) := 'N';
            v_gen_info001 gixx_polgenin.gen_info01%TYPE;
            v_initial_info01 gixx_polgenin.initial_info01%TYPE;
        BEGIN
            FOR i IN (
                SELECT initial_info01, gen_info01
                  FROM gixx_polgenin
                 WHERE extract_id = p_extract_id)
            LOOP
                v_show_polgenin := 'Y';
                v_gen_info001 := i.gen_info01;
                v_initial_info01 := i.initial_info01;
                EXIT;
            END LOOP;
            
            IF p_report_id = 'MARINE_CARGO' THEN
                IF v_report.par_par_type = 'E' OR v_initial_info01 IS NULL THEN
                    v_report.show_polgenin := 'N';                    
                ELSE
                    v_report.show_polgenin := 'Y';                    
                END IF;
            ELSE
                v_report.show_polgenin := v_show_polgenin;
            END IF; 
            
            IF v_gen_info001 IS NULL OR Policy_Docs_Pkg.PRINT_DOC_SUBTITLE3 = 'N' THEN
                v_show_polgenin_gen_info := 'N';
            ELSE
                v_show_polgenin_gen_info := 'Y';
            END IF;
            
            IF p_report_id = 'MARINE_HULL' THEN
                IF Policy_Docs_Pkg.PRINT_GEN_INFO_ABOVE = 'Y' THEN
                    v_show_polgenin_gen_info := 'N';
                END IF;
            END IF;
            
            v_report.show_polgenin_gen_info := v_show_polgenin_gen_info;
        END;
        
        /* show_perils */
        DECLARE
            v_item_count NUMBER(9);
        BEGIN
          IF v_report.basic_line_cd = 'EN' THEN
            SELECT COUNT(extract_id)
              INTO v_item_count
              FROM GIXX_ITMPERIL
             WHERE extract_id = p_extract_id;
            
            IF NVL(v_item_count,0) = 0 THEN
                v_report.show_perils := 'N';
            END IF;
            
            IF Policy_Docs_Pkg.PRINT_DOC_SUBTITLE5 = 'Y' AND Policy_Docs_Pkg.doc_subtitle5_before_wc = 'Y' THEN
                v_report.show_perils := 'Y';
            ELSE
                v_report.show_perils := 'N';
            END IF;
          ELSE
            SELECT COUNT(extract_id)
              INTO v_item_count
              FROM GIXX_ITMPERIL
             WHERE extract_id = p_extract_id;
            
            IF NVL(v_item_count,0) = 0 THEN
                v_report.show_perils := 'N';
            END IF;
            
            IF Policy_Docs_Pkg.PRINT_DOC_SUBTITLE4 = 'Y' AND Policy_Docs_Pkg.doc_subtitle4_before_wc = 'Y' THEN
                v_report.show_perils := 'Y';
            ELSE
                v_report.show_perils := 'N';
            END IF;
          END IF;
        END;
        
        /* show_perils2 */
        DECLARE
            v_item_count NUMBER(9);
        BEGIN
          IF v_report.basic_line_cd = 'EN' THEN
            SELECT COUNT(extract_id)
              INTO v_item_count
              FROM GIXX_ITMPERIL
             WHERE extract_id = p_extract_id;
            
            IF NVL(v_item_count,0) = 0 THEN
                v_report.show_perils2 := 'N';
            END IF;
            
            IF Policy_Docs_Pkg.PRINT_DOC_SUBTITLE5 = 'Y' AND Policy_Docs_Pkg.doc_subtitle5_before_wc = 'N' THEN
                v_report.show_perils2 := 'Y';
            ELSE
                v_report.show_perils2 := 'N';
            END IF;
          ELSE
            SELECT COUNT(extract_id)
              INTO v_item_count
              FROM GIXX_ITMPERIL
             WHERE extract_id = p_extract_id;
            
            IF NVL(v_item_count,0) = 0 THEN
                v_report.show_perils2 := 'N';
            END IF;
            
            IF Policy_Docs_Pkg.PRINT_DOC_SUBTITLE4 = 'Y' AND Policy_Docs_Pkg.doc_subtitle4_before_wc = 'N' THEN
                v_report.show_perils2 := 'Y';
            ELSE
                v_report.show_perils2 := 'N';
            END IF;
          END IF;
        END;

        /* show_item */
        DECLARE
            v_count NUMBER(20);
            v_exist VARCHAR2(1) := 'N';
        BEGIN
            SELECT NVL(COUNT(extract_id), 0)
              INTO v_count
              FROM GIXX_ITEM
             WHERE extract_id = p_extract_id;
             
            IF v_count = 0 THEN
                v_exist := 'N';
            ELSE
                v_exist := 'Y';
            END IF;
            
            v_report.show_item := v_exist;
        END;
        
        /* f_signatory_header */
        DECLARE
            v_header    GIIS_DOCUMENT.text%TYPE;
            v_subline    GIIS_SUBLINE.subline_name%TYPE;
        BEGIN
            FOR a IN (
                SELECT text
                  FROM GIIS_DOCUMENT
                 WHERE title = 'DOC_SIGNATORY_HEADER'
                   AND line_cd = Giis_Line_Pkg.get_line_cd(Policy_Docs_Pkg.get_line_name(p_report_id))
                   AND report_id = p_report_id)
            LOOP
                v_header := a.text;
            END LOOP;
            
            FOR b IN (
                SELECT INITCAP(subline_name) subline_name
                  FROM GIIS_SUBLINE
                 WHERE line_cd = Giis_Line_Pkg.get_line_cd(Policy_Docs_Pkg.get_line_name(p_report_id))
                   AND subline_cd = v_report.subline_subline_cd)
            LOOP
                v_subline := b.subline_name;
            END LOOP;
            
            IF v_header IS NOT NULL THEN
                v_report.f_signatory_header := v_header || ' ' || v_subline || ' Policy' || ')';
            ELSE
                v_report.f_signatory_header := NULL;
            END IF;
        END;
        
        /* f_signatory_text1  */
        DECLARE
            v_pol_text1            GIIS_DOCUMENT.text%TYPE;
            v_pol_text2            GIIS_DOCUMENT.text%TYPE;
            v_endt_text1        GIIS_DOCUMENT.text%TYPE;
            v_endt_text2        GIIS_DOCUMENT.text%TYPE;
            v_iss_add1            VARCHAR2(150);
            v_iss_add2            VARCHAR2(150);
            v_signatory_text1     VARCHAR2(2000);
            v_signatory_text2     VARCHAR2(2000);
        BEGIN
            FOR n IN (
                SELECT text
                  FROM GIIS_DOCUMENT
                 WHERE title = 'DOC_SIGNATURE_POL1'
                   AND (line_cd = Giis_Line_Pkg.get_menu_line_cd(v_report.basic_line_cd)
                        OR  line_cd = v_report.basic_line_cd)                   -- OR condition added by d.alcantara, 08-15-2011
                   AND report_id = p_report_id)
            LOOP
                v_pol_text1 := n.text;
            END LOOP;
            
            FOR n IN (
                SELECT text
                  FROM GIIS_DOCUMENT
                 WHERE title = 'DOC_SIGNATURE_POL2'
                   AND (line_cd = Giis_Line_Pkg.get_menu_line_cd(v_report.basic_line_cd)
                        OR  line_cd = v_report.basic_line_cd)
                   AND report_id = p_report_id)
            LOOP
                v_pol_text2 := n.text;
            END LOOP;
            
            FOR E IN (
                SELECT text
                  FROM GIIS_DOCUMENT
                 WHERE title = 'DOC_SIGNATURE_ENDT1'
                   AND (line_cd = Giis_Line_Pkg.get_menu_line_cd(v_report.basic_line_cd)
                        OR  line_cd = v_report.basic_line_cd)
                   AND report_id = p_report_id)
            LOOP
                v_endt_text1 := E.text;
            END LOOP;
            
            FOR E IN (
                SELECT text
                  FROM GIIS_DOCUMENT
                 WHERE title = 'DOC_SIGNATURE_ENDT2'
                   AND (line_cd = Giis_Line_Pkg.get_menu_line_cd(v_report.basic_line_cd)
                        OR  line_cd = v_report.basic_line_cd)
                   AND report_id = p_report_id)
            LOOP
                v_endt_text2 := E.text;
            END LOOP;
            
            FOR r IN (
                SELECT address1 || ' ' || address2 || ' ' || address3 address
                  FROM GIIS_ISSOURCE
                 WHERE iss_cd = v_report.basic_iss_cd)
            LOOP
                v_iss_add1 := r.address;
            END LOOP;
            
            FOR r IN (
                SELECT address1 || ' ' || address2 || ' ' || address3 address
                  FROM GIIS_ISSOURCE
                 WHERE iss_cd = v_report.basic_iss_cd)
            LOOP
                v_iss_add2 := r.address;
            END LOOP;
            
            IF v_report.par_par_type = 'P' THEN
                IF v_pol_text1 IS NOT NULL THEN
                    v_signatory_text1 := v_pol_text1 || ' ' || v_iss_add1 || '.';
                ELSE
                    v_signatory_text1 := NULL;
                END IF;
                
                IF v_pol_text2 IS NOT NULL THEN
                    v_signatory_text2 := v_pol_text2 || ' ' || v_iss_add2 || '.';
                ELSE
                    v_signatory_text2 := NULL;
                END IF;
            ELSE
                v_signatory_text1 := v_endt_text1;
                v_signatory_text2 := v_endt_text2;
            END IF;
            
            v_report.f_signatory_text1 := v_signatory_text1;
            v_report.f_signatory_text2 := v_signatory_text2;
        END;
        
        /* f_company */
        DECLARE
            v_company_name VARCHAR2(100);
        BEGIN
            FOR NAME IN (
                SELECT param_value_v
                  FROM GIIS_PARAMETERS
                 WHERE param_name = 'COMPANY_NAME')
            LOOP
                v_company_name := NAME.param_value_v;
            END LOOP;
            
            v_report.f_company := v_company_name;
        END;
        
        /* f_signatory  */
        DECLARE
            v_signatory        VARCHAR2(50);
            v_designation    VARCHAR2(50);
            v_signature_img VARCHAR2(500); -- bonok :: 7.30.2015 :: SR 19544
        BEGIN
            FOR c IN (
                SELECT signatory, designation, file_name -- bonok :: 7.30.2015 :: SR 19544
                  FROM GIIS_SIGNATORY_NAMES a,
                       GIIS_SIGNATORY b
                 WHERE a.signatory_id = b.signatory_id
                   AND iss_cd = (SELECT iss_cd
                                   FROM GIXX_POLBASIC
                                  WHERE extract_id = p_extract_id)
                   AND b.current_signatory_sw = 'Y'
                   AND b.line_cd IN (SELECT param_value_v
                                       FROM GIIS_PARAMETERS
                                      WHERE param_name = Policy_Docs_Pkg.get_giisp_v_param(p_report_id))
                   AND NVL(b.report_id, p_report_id) = p_report_id)
            LOOP
                v_signatory := c.signatory;
                v_designation := c.designation;
                v_signature_img := c.file_name; -- bonok :: 7.30.2015 :: SR 19544
            END LOOP;
            
            v_report.f_signatory := v_signatory;
            v_report.f_designation := v_designation;
            v_report.f_signature_img := v_signature_img; -- bonok :: 7.30.2015 :: SR 19544
        END;
        
        /* f_user */
        DECLARE
            v_user            GIXX_POLBASIC.user_id%TYPE;
            v_user_create    GIXX_POLBASIC.user_id%TYPE;
        BEGIN
            IF v_report.par_par_status = 10 THEN
                FOR c IN (
                    SELECT a.user_id user_id
                      FROM GIPI_PARHIST a,
                           GIPI_POLBASIC b
                     WHERE a.par_id = b.par_id
                       AND a.parstat_cd = '10'
                       AND b.policy_id = v_report.par_id)
                LOOP
                    v_user := c.user_id;
                END LOOP;
                
                /*FOR a IN (
                    SELECT b.par_id, b.user_id user2, b.parstat_date
                      FROM GIPI_POLBASIC a,
                           GIPI_PARHIST b
                     WHERE a.par_id = b.par_id
                       AND a.policy_id = v_report.par_id
                       AND b.parstat_date = (SELECT MIN(b.parstat_date)
                                               FROM GIPI_POLBASIC a,
                                                    GIPI_PARHIST b
                                              WHERE a.par_id = b.par_id
                                                AND a.policy_id = v_report.par_id))
                LOOP
                    v_user_create := a.user2;
                END LOOP;*/ --belle 10032012
            ELSE
                FOR c IN (
                    SELECT a.user_id user_id
                      FROM GIPI_PARHIST a,
                           GIPI_PARLIST b
                     WHERE a.par_id = b.par_id
                       AND a.parstat_cd = '10'
                       AND b.par_id = v_report.par_id)
                LOOP
                    v_user := c.user_id;
                END LOOP;
                
                FOR a IN (
                    SELECT b.par_id, b.user_id user2, b.parstat_date
                      FROM GIPI_PARLIST a,
                           GIPI_PARHIST b
                     WHERE a.par_id = b.par_id
                       AND a.par_id = v_report.par_id
                       AND b.parstat_date = (SELECT MIN(b.parstat_date)
                                               FROM GIPI_PARLIST a,
                                                    GIPI_PARHIST b
                                              WHERE a.par_id = b.par_id
                                                AND a.par_id = v_report.par_id))
                LOOP
                    v_user_create := a.user2;
                END LOOP;
            END IF;
            
            v_report.f_user := v_user || CHR(10) || TO_CHAR(SYSDATE, 'DD-MON-RR') || ' ' || TO_CHAR(SYSDATE, 'HH24:MI:SS'); -- belle 10032012  changed from v_user_create
        END;
        
        /* f_intm_no */
        DECLARE
            v_intm_no        VARCHAR2(100);
            v_parent        VARCHAR2(100);
            v_agent            VARCHAR2(100);
            v_orig_parent    VARCHAR2(100);
            v_orig_agent    VARCHAR2(100);
        BEGIN
            FOR a IN ( 
                SELECT DECODE(PARENT.ref_intm_cd,NULL,
                       TO_CHAR(a.parent_intm_no,'999999999990'),
                       TO_CHAR(a.parent_intm_no,'999999999990')||'-'||PARENT.ref_intm_cd)  parent_intm_no,
                       DECODE(agent.ref_intm_cd,NULL,
                       TO_CHAR(a.intrmdry_intm_no,'999999999990'),
                       TO_CHAR(a.intrmdry_intm_no,'999999999990')||'-'||agent.ref_intm_cd) agent_intm_no
                  FROM GIIS_INTERMEDIARY agent,
                       GIIS_INTERMEDIARY PARENT,
                       GIXX_COMM_INVOICE a 
                 WHERE a.parent_intm_no = PARENT.intm_no(+)
                   AND a.intrmdry_intm_no = agent.intm_no(+)
                   AND a.extract_id = p_extract_id)
            LOOP
                v_parent := a.parent_intm_no;
                v_agent  := a.agent_intm_no;
                EXIT;
            END LOOP;
            
            IF NVL(v_parent,'*') = NVL(v_agent,'**') THEN
                v_intm_no := ('/ '||LTRIM(v_agent));
            ELSE
                v_intm_no := v_parent||' / '||LTRIM(v_agent);
            END IF;
            
            IF v_parent IS NULL AND v_agent IS NULL  THEN
                FOR a IN ( 
                    SELECT DECODE(PARENT.ref_intm_cd,NULL,
                           TO_CHAR(a.parent_intm_no,'999999999990'),
                           TO_CHAR(a.parent_intm_no,'999999999990')||'-'||PARENT.ref_intm_cd)  parent_intm_no,
                           DECODE(agent.ref_intm_cd,NULL,
                           TO_CHAR(a.intrmdry_intm_no,'999999999990'),
                           TO_CHAR(a.intrmdry_intm_no,'999999999990')||'-'||agent.ref_intm_cd) agent_intm_no
                      FROM GIIS_INTERMEDIARY agent,
                           GIIS_INTERMEDIARY PARENT,
                           GIPI_COMM_INVOICE a 
                     WHERE a.parent_intm_no = PARENT.intm_no
                       AND a.intrmdry_intm_no = agent.intm_no
                       AND a.policy_id IN (SELECT a.policy_id 
                                             FROM GIPI_POLBASIC a, GIPI_INVOICE b
                                            WHERE a.policy_id = b.policy_id
                                              AND a.line_cd= v_report.subline_line_cd
                                              AND a.subline_cd  = v_report.subline_subline_cd
                                              AND a.iss_cd = v_report.basic_iss_cd 
                                              AND a.issue_yy = v_report.basic_issue_yy
                                              AND a.pol_seq_no = v_report.basic_pol_seq_no
                                              AND a.renew_no = v_report.basic_renew_no
                                              AND a.endt_seq_no = 00
                                              AND a.pol_flag IN ('1','2','3')))
                LOOP
                    v_orig_parent := a.parent_intm_no;
                    v_orig_agent  := a.agent_intm_no;
                    EXIT;
                END LOOP;
                
                IF v_orig_parent = v_orig_agent THEN
                   v_intm_no := ('/ '||LTRIM(v_orig_agent));
                ELSE
                   v_intm_no := LTRIM(v_orig_parent)||' / '||LTRIM(v_orig_agent);
                END IF;
            END IF;    
            
            v_report.f_intm_no := LTRIM(v_intm_no);
        END;
        
        /* f_intm_name */
        DECLARE
            v_intm_name         VARCHAR2(500);--VARCHAR2(100); changed by: Nica 12.21.2011
            v_agent             GIIS_INTERMEDIARY.intm_name%TYPE;
            v_parent            GIIS_INTERMEDIARY.intm_name%TYPE;
            v_orig_agent        GIIS_INTERMEDIARY.intm_name%TYPE;
            v_orig_parent       GIIS_INTERMEDIARY.intm_name%TYPE;
        BEGIN
            FOR a IN ( 
                SELECT PARENT.intm_name parent_intm_name, 
                       agent.intm_name agent_intm_name
                  FROM GIIS_INTERMEDIARY agent,
                       GIIS_INTERMEDIARY PARENT,
                       GIXX_COMM_INVOICE a 
                 WHERE a.parent_intm_no = PARENT.intm_no
                   AND a.intrmdry_intm_no = agent.intm_no
                   AND a.extract_id = p_extract_id)
            LOOP
                v_parent := a.parent_intm_name; 
                v_agent := a.agent_intm_name;
                EXIT;
            END LOOP;
            
            IF v_parent = v_agent THEN
                v_intm_name := LTRIM('/ '||v_agent);
            ELSE
                v_intm_name := v_parent||' / '||v_agent;
            END IF;
            
            IF v_parent IS NULL AND v_agent IS NULL THEN
                FOR a IN ( 
                    SELECT PARENT.intm_name parent_intm_name, 
                           agent.intm_name agent_intm_name
                      FROM GIIS_INTERMEDIARY agent,
                           GIIS_INTERMEDIARY PARENT,
                           GIPI_COMM_INVOICE a 
                     WHERE a.parent_intm_no = PARENT.intm_no
                       AND a.intrmdry_intm_no = agent.intm_no
                       AND a.policy_id IN (SELECT a.policy_id 
                                             FROM GIPI_POLBASIC a, GIPI_INVOICE b
                                            WHERE a.policy_id = b.policy_id
                                              AND a.line_cd = v_report.subline_line_cd
                                                AND a.subline_cd = v_report.subline_subline_cd
                                                AND a.iss_cd = v_report.basic_iss_cd 
                                                AND a.issue_yy = v_report.basic_issue_yy
                                                AND a.pol_seq_no = v_report.basic_pol_seq_no
                                                AND a.renew_no = v_report.basic_renew_no
                                                AND a.endt_seq_no = 00
                                                AND a.pol_flag IN ('1','2','3')))
                LOOP
                    v_orig_parent := a.parent_intm_name;
                    v_orig_agent  := a.agent_intm_name;
                    EXIT;
                END LOOP;
                
                IF v_orig_parent = v_orig_agent THEN
                    v_intm_name := LTRIM('/ '||v_orig_agent);
                ELSE
                    v_intm_name := v_orig_parent||' / '||v_orig_agent;
                END IF;
            END IF;
            
            v_report.f_intm_name := LTRIM(v_intm_name);
        END;
        
        /* f_ref_inv_no */
        DECLARE
            v_ref_inv_no    GIXX_INVOICE.ref_inv_no%TYPE;
            v_count         NUMBER(2):=1;
        BEGIN
            IF v_report.basic_co_insurance_sw = 1 THEN
                FOR a IN (
                    SELECT ref_inv_no
                        FROM GIXX_INVOICE
                     WHERE extract_id = p_extract_id)
                LOOP
                    IF v_count = 1 THEN
                        v_ref_inv_no := a.ref_inv_no;
                    ELSE
                        IF a.ref_inv_no IS NOT NULL THEN
                            v_ref_inv_no := v_ref_inv_no || CHR(10) || a.ref_inv_no;
                        END IF;
                    END IF;
                    v_count := v_count + 1;
                END LOOP;
            ELSE
                FOR a IN (
                    SELECT ref_inv_no
                      FROM GIXX_INVOICE
                     WHERE extract_id = p_extract_id)
                LOOP
                    IF v_count = 1 THEN
                        v_ref_inv_no := a.ref_inv_no;
                    ELSE
                        IF a.ref_inv_no IS NOT NULL THEN
                            v_ref_inv_no := v_ref_inv_no || CHR(10) || a.ref_inv_no;
                        END IF;
                    END IF;
                    v_count := v_count + 1;
                END LOOP;
            END IF;
            
            v_report.f_ref_inv_no := v_ref_inv_no;
        END;
        
        /* f_policy_id */
        DECLARE
            v_pol_id  GIPI_POLBASIC.policy_id%TYPE;
        BEGIN
            FOR a IN (
                SELECT line_cd, subline_cd, iss_cd,
                       issue_yy, pol_seq_no, renew_no, endt_iss_cd, endt_yy, endt_seq_no --koks 10.13.14: Print policy_id of endt
                  FROM GIXX_POLBASIC
                 WHERE extract_id = p_extract_id)
            LOOP
                BEGIN
                  SELECT policy_id
                    INTO v_pol_id
                    FROM GIPI_POLBASIC
                   WHERE line_cd = a.line_cd
                     AND subline_cd  = a.subline_cd
                     AND iss_cd = a.iss_cd
                     AND issue_yy = a.issue_yy
                     AND pol_seq_no = a.pol_seq_no
                     AND renew_no = a.renew_no
                    -- AND endt_seq_no = 0
                     AND endt_iss_cd = a.endt_iss_cd --koks 10.13.14: Print policy_id of endt
                     AND endt_yy = a.endt_yy
                     AND endt_seq_no = a.endt_seq_no;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        v_pol_id := 0;
                END;
                EXIT;
            END LOOP;
            
            v_report.f_policy_id := v_pol_id;
        END;
        
        --f_mop_map_wordings--
        IF v_report.subline_subline_cd IN ('MAP','MOP') THEN    
          v_mop_wordings := Policy_Docs_Pkg.MOP_MAP_WORDINGS;
        ELSIF v_report.subline_subline_cd IN ('MARN','MRN') THEN
          v_mop_wordings := Policy_Docs_Pkg.ALL_SUBLINE_WORDINGS1;
        ELSIF v_report.subline_subline_cd ='MAR' THEN
          v_mop_wordings := Policy_Docs_Pkg.ALL_SUBLINE_WORDINGS2;
        ELSE
          v_mop_wordings := NULL;
        END IF;
        
        /* show_warr_and_clauses */
        DECLARE
            v_show_wc    VARCHAR2(1) := 'N';
        BEGIN
            /*
            FOR i IN (
                SELECT extract_id
                  FROM GIXX_POLWC
                 WHERE extract_id = p_extract_id)
            LOOP
                v_show_wc := 'Y';
            END LOOP;
            */
            v_report.show_warr_and_clauses := Gixx_Polwc_Pkg.is_record_exists(p_extract_id);
        END;
        
        --for MOP_NO if line_cd = 'MN''
        FOR mop IN (SELECT op.line_cd || '-' || op.op_subline_cd || '-' || op.op_iss_cd || '-' ||
                              LTRIM(TO_CHAR(op.op_issue_yy,'09')) || '-' ||  
                           LTRIM(TO_CHAR(op.op_pol_seqno,'0999999'))||DECODE(gp.ref_pol_no,NULL,'',' / '||gp.ref_pol_no) policy_no
                      FROM GIXX_OPEN_POLICY op , GIPI_POLBASIC gp 
                     WHERE op.extract_id      = p_extract_id 
                       AND op.line_cd         = gp.line_cd
                        AND op.op_subline_cd   = gp.subline_cd
                        AND op.op_iss_cd       = gp.iss_cd
                        AND op.op_issue_yy     = gp.issue_yy
                        AND op.op_pol_seqno    = gp.pol_seq_no)
        LOOP
          v_report.mop_no := mop.policy_no;
        END LOOP;
        
        --f_mop_wordings
        IF v_report.subline_subline_cd IN ('MRN','MARN') THEN
            v_mop_wordings2 := Policy_Docs_Pkg.MRN_WORDINGS;   
          ELSIF v_report.subline_subline_cd IN ('MOP','MAP','MAR') THEN
          v_mop_wordings2 := Policy_Docs_Pkg.MAR_WORDINGS;
          ELSE
          v_mop_wordings2 := NULL;
        END IF;
        
        /* show_intm_no */
        DECLARE
            v_show_intm_no VARCHAR2(1) := 'Y';
        BEGIN
            IF v_report.par_par_status <> 10 THEN
                IF Policy_Docs_Pkg.PRINT_LOWER_DTLS = 'Y' THEN                    
                    IF Policy_Docs_Pkg.HIDE_LINE = 'Y' AND p_report_id IN ('MARINE_CARGO') THEN
                        v_show_intm_no := 'N';
                    ELSE
                        IF p_report_id = 'MARINE_CARGO' THEN
                            IF LENGTH(v_report.F_INTM_NAME) > 2 THEN
                                v_show_intm_no := 'Y';
                            ELSE
                                v_show_intm_no := 'N';
                            END IF;
                        ELSE
                            IF LENGTH(v_report.F_INTM_NO) > 2 THEN
                                v_show_intm_no := 'Y';
                            ELSE
                                v_show_intm_no := 'N';
                            END IF;
                        END IF;
                    END IF;
                ELSE
                    v_show_intm_no := 'N';
                END IF;
            ELSE
                IF p_report_id = 'AVIATION' THEN
                    IF LENGTH(v_report.f_intm_no) > 2 THEN
                        v_show_intm_no := 'Y';                    
                    ELSE
                        v_show_intm_no := 'N';
                    END IF;
                ELSIF p_report_id = 'ENGINEERING' THEN
                    IF LENGTH(v_report.f_intm_no) < 1 OR Policy_Docs_Pkg.PRINT_DTLS_BELOW_USER = 'N' THEN
                        v_show_intm_no := 'N';
                    ELSE
                        v_show_intm_no := 'Y';
                    END IF;
                ELSE
                    /* default : FIRE */
                    IF LENGTH(v_report.f_intm_no) > 1 THEN
                        v_show_intm_no := 'Y';
                    ELSE
                        v_show_intm_no := 'N';
                    END IF;
                END IF;                
            END IF;
            
            v_report.show_intm_no := v_show_intm_no;
        END;
        
        /* show_intm_name */
        DECLARE
            v_show_intm_name VARCHAR2(1) := 'Y';
        BEGIN
            IF v_report.par_par_status <> 10 THEN
                IF Policy_Docs_Pkg.PRINT_LOWER_DTLS = 'Y' THEN                    
                    IF Policy_Docs_Pkg.HIDE_LINE = 'Y' AND p_report_id IN ('MARINE_CARGO') THEN
                        v_show_intm_name := 'N';
                    ELSE
                        IF p_report_id = 'MARINE_CARGO' THEN
                            IF LENGTH(v_report.F_INTM_NAME) > 5 AND Policy_Docs_Pkg.PRINT_INTM_NAME = 'Y' THEN
                                v_show_intm_name := 'Y';
                            ELSE
                                v_show_intm_name := 'N';
                            END IF;
                        ELSE
                            IF LENGTH(v_report.F_INTM_NAME) > 5 AND Policy_Docs_Pkg.PRINT_INTM_NAME = 'Y' THEN
                                v_show_intm_name := 'Y';
                            ELSE
                                v_show_intm_name := 'N';
                            END IF;
                        END IF;
                    END IF;
                ELSE
                    v_show_intm_name := 'N';
                END IF;
            ELSE
                IF LENGTH(v_report.f_intm_name) > 5 AND Policy_Docs_Pkg.PRINT_INTM_NAME = 'Y' THEN                    
                    v_show_intm_name := 'Y';
                ELSE                    
                    v_show_intm_name := 'N';
                END IF;    
            END IF;
            
            v_report.show_intm_name := v_show_intm_name;
            
            /* show_ref_pol_no */
            DECLARE
                v_show    VARCHAR2(1) := 'N';
            BEGIN                                    
                IF p_report_id = 'ENGINEERING' THEN
                    IF Policy_Docs_Pkg.PRINT_REF_POL_NO = 'N' OR v_report.basic_ref_pol_no IS NULL OR Policy_Docs_Pkg.DISPLAY_REF_POL_NO = 'N' THEN
                        v_show := 'N';
                    ELSE
                        v_show := 'Y';
                    END IF;
                ELSIF p_report_id = 'AVIATION' THEN
                    IF v_report.basic_ref_pol_no IS NULL OR (v_report.par_par_type = 'E' AND v_report.basic_co_insurance_sw = 2) THEN
                        v_show := 'N';
                    ELSE
                        v_show := 'Y';
                    END IF;
                ELSE
                    IF Policy_Docs_Pkg.PRINT_REF_POL_NO = 'N' THEN
                        v_show := 'N';
                    ELSE
                        IF v_report.basic_ref_pol_no IS NULL OR (v_report.par_par_type = 'E' AND v_report.basic_co_insurance_sw = 2) THEN
                            v_show := 'N';
                        ELSE
                            v_show := 'Y';
                        END IF;
                    END IF;
                END IF;                
                
                v_report.show_ref_pol_no := v_show;
            END;
        END;
        
        /* show_basic_tsi_spell */
        DECLARE
            v_show VARCHAR2(1) := 'Y';
        BEGIN
            IF v_report.basic_tsi_amt IS NULL OR v_report.basic_tsi_amt = 0 OR Policy_Docs_Pkg.PRINT_SUM_INSURED = 'N' THEN
                v_show := 'N';
            ELSE
                v_show := 'Y';
            END IF;
            v_report.show_basic_tsi_spell := v_show;
        END;
        
        /* show_acc_sum_word */
        DECLARE
            v_show VARCHAR2(1) := 'Y';
        BEGIN
            IF Policy_Docs_Pkg.PRINT_ACC_TSI != 'Y' THEN
                v_show := 'N';
            ELSE
                IF Policy_Docs_Pkg.SUM_INSURED_TITLE2 IS NULL OR Policy_Docs_Pkg.TSI_LABEL2 IS NULL THEN
                    v_show := 'N';
                ELSE
                    IF v_report.PAR_PAR_TYPE = 'P' THEN
                        v_show := 'N';
                    END IF;
                END IF;
            END IF;
            v_report.show_acc_sum_word := v_show;
        END;
        
        --pack_method
        IF Policy_Docs_Pkg.PACK_METHOD LIKE '%Type of Packing%' THEN
            v_pack_method := Policy_Docs_Pkg.PACK_METHOD;
        ELSE
          v_pack_method := 'Pack Method';
        END IF;
        
        /* show_par_no */
        DECLARE
            v_show_par_no         VARCHAR2(1) := 'N';
            v_show_cred_br        VARCHAR2(1) := 'N';
            v_show_policy_id    VARCHAR2(1) := 'N';
        BEGIN
            IF v_report.par_par_status NOT IN (10, 99) THEN
                v_show_par_no := 'N';
                v_show_cred_br := 'N';
                v_show_policy_id := 'N';
            ELSE
                IF p_report_id IN ('MARINE_HULL', 'ENGINEERING') THEN
                    v_show_par_no := 'N';
                    v_show_cred_br := 'N';
                    v_show_policy_id := 'N';
                ELSE
                    v_show_par_no := 'Y';
                    v_show_policy_id := 'Y';
                    IF v_report.cred_br IS NULL THEN
                        v_show_cred_br := 'N';
                    ELSE
                        v_show_cred_br := 'Y';
                    END IF;
                END IF;
            END IF;        
            
            v_report.show_par_no := v_show_par_no;
            v_report.show_cred_br := v_show_cred_br;
            v_report.show_policy_id := v_show_policy_id;
        END;
        
        /* show_mn_item_header */
        DECLARE
            v_show VARCHAR2(1) := 'N';
        BEGIN
            FOR a IN (
                SELECT item_no
                  FROM gixx_item
                 WHERE extract_id = p_extract_id)
            LOOP
                v_show := 'Y';
                EXIT;
            END LOOP;
            
            IF v_show = 'Y' AND v_report.subline_open_policy = 'N' AND
                    Policy_Docs_Pkg.print_sub_info = 'Y' AND Policy_Docs_Pkg.print_doc_subtitle1 = 'Y' THEN
                v_report.show_mn_item_header := 'Y';
            ELSE
                v_report.show_mn_item_header := 'N';
            END IF;
        END;
        
        v_report.f_mop_map_wordings                := v_mop_wordings;
        v_report.f_mop_wordings                    := v_mop_wordings2;
        v_report.rv_pack_method                    := v_pack_method;
        v_report.rv_attestation_title              := Policy_Docs_Pkg.attestation_title;
        v_report.rv_block_description            := Policy_Docs_Pkg.block_description;
        v_report.rv_boundary_title                := Policy_Docs_Pkg.boundary_title;
        v_report.rv_ca_deductible_levels         := Policy_Docs_Pkg.ca_deductible_levels;
        v_report.rv_casualty_co_insurance         := Policy_Docs_Pkg.casualty_co_insurance;
        v_report.rv_constr_remarks_title        := Policy_Docs_Pkg.constr_remarks_title;
        v_report.rv_construction_title            := Policy_Docs_Pkg.construction_title;
        v_report.rv_deductible_title              := Policy_Docs_Pkg.deductible_title;
        v_report.rv_display_ann_tsi              := Policy_Docs_Pkg.display_ann_tsi;
        v_report.rv_display_policy_term          := Policy_Docs_Pkg.display_policy_term;
        v_report.rv_display_property_type         := Policy_Docs_Pkg.display_property_type;
        v_report.rv_display_ref_pol_no             := Policy_Docs_Pkg.display_ref_pol_no;
        v_report.rv_doc_attestation1            := Policy_Docs_Pkg.doc_attestation1;
        v_report.rv_doc_attestation2            := Policy_Docs_Pkg.doc_attestation2;
        v_report.rv_doc_subtitle1                  := Policy_Docs_Pkg.doc_subtitle1;
        v_report.rv_doc_subtitle2                  := Policy_Docs_Pkg.doc_subtitle2;
        v_report.rv_doc_subtitle3                  := Policy_Docs_Pkg.doc_subtitle3;
        v_report.rv_doc_subtitle4                  := Policy_Docs_Pkg.doc_subtitle4;
        v_report.rv_doc_subtitle4_before_wc      := Policy_Docs_Pkg.doc_subtitle4_before_wc;
        v_report.rv_doc_subtitle5                  := Policy_Docs_Pkg.doc_subtitle5;
        v_report.rv_doc_subtitle5_before_wc        := Policy_Docs_Pkg.doc_subtitle5_before_wc;
        v_report.rv_doc_tax_breakdown             := Policy_Docs_Pkg.doc_tax_breakdown;
        v_report.rv_doc_total_in_box             := Policy_Docs_Pkg.doc_total_in_box;
        v_report.rv_endt_par                     := Policy_Docs_Pkg.endt_par;        
        v_report.rv_endt_policy                 := Policy_Docs_Pkg.endt_policy;
        v_report.rv_grouped_item_title          := Policy_Docs_Pkg.grouped_item_title;
        v_report.rv_grouped_subtitle              := Policy_Docs_Pkg.grouped_subtitle;
        v_report.rv_hide_line                    := Policy_Docs_Pkg.hide_line;
        v_report.rv_include_tsi                 := Policy_Docs_Pkg.include_tsi;
        v_report.rv_item_title                  := Policy_Docs_Pkg.item_title;
        v_report.rv_leased_to                      := Policy_Docs_Pkg.leased_to;
        v_report.rv_occupancy_remarks_title        := Policy_Docs_Pkg.occupancy_remarks_title;
        v_report.rv_occupancy_title                := Policy_Docs_Pkg.occupancy_title;
        v_report.rv_par_par                     := Policy_Docs_Pkg.par_par;
        v_report.rv_par_policy                     := Policy_Docs_Pkg.par_policy;
        v_report.rv_peril_title                  := Policy_Docs_Pkg.peril_title;
        v_report.rv_personnel_item_title          := Policy_Docs_Pkg.personnel_item_title;
        v_report.rv_personnel_subtitle1          := Policy_Docs_Pkg.personnel_subtitle1;
        v_report.rv_personnel_subtitle2          := Policy_Docs_Pkg.personnel_subtitle2;
        v_report.rv_personnel_subtitle3          := Policy_Docs_Pkg.personnel_subtitle3;
        v_report.rv_policy_siglabel             := Policy_Docs_Pkg.policy_siglabel;
        v_report.rv_print_acc_tsi                 := NVL(Policy_Docs_Pkg.print_acc_tsi, 'N');
        v_report.rv_print_accessories_above     := Policy_Docs_Pkg.print_accessories_above;
        v_report.rv_print_all_warranties         := Policy_Docs_Pkg.print_all_warranties;
        v_report.rv_print_all_warranties          := Policy_Docs_Pkg.print_all_warranties;
        v_report.rv_print_authorized_signatory     := Policy_Docs_Pkg.print_authorized_signatory;
        v_report.rv_print_cargo_desc            := Policy_Docs_Pkg.print_cargo_desc;
        v_report.rv_print_cents                  := Policy_Docs_Pkg.print_cents;
        v_report.rv_print_currency_desc         := Policy_Docs_Pkg.print_currency_desc;
        v_report.rv_print_declaration_no        := Policy_Docs_Pkg.print_declaration_no;
        v_report.rv_print_ded_text                := Policy_Docs_Pkg.print_ded_text;
        v_report.rv_print_ded_text_peril          := Policy_Docs_Pkg.print_ded_text_peril;
        v_report.rv_print_ded_twice             := Policy_Docs_Pkg.print_ded_twice;
        v_report.rv_print_deduct_text_amt          := Policy_Docs_Pkg.print_deduct_text_amt;
        v_report.rv_print_deductible_amt        := Policy_Docs_Pkg.print_deductible_amt;
		v_report.rv_print_deductible_rt         := Policy_Docs_Pkg.print_deductible_rt;
        v_report.rv_print_deductibles             := Policy_Docs_Pkg.print_deductibles;
        v_report.rv_print_district_block        := Policy_Docs_Pkg.print_district_block;
        v_report.rv_print_doc_signature_pol1     := Policy_Docs_Pkg.print_doc_signature_pol1;
        v_report.rv_print_doc_signature_pol2     := Policy_Docs_Pkg.print_doc_signature_pol2;
        v_report.rv_print_doc_subtitle1         := Policy_Docs_Pkg.print_doc_subtitle1;
        v_report.rv_print_doc_subtitle2         := Policy_Docs_Pkg.print_doc_subtitle2;
        v_report.rv_print_doc_subtitle3         := Policy_Docs_Pkg.print_doc_subtitle3;
        v_report.rv_print_doc_subtitle4         := Policy_Docs_Pkg.print_doc_subtitle4;
        v_report.rv_print_doc_subtitle5            := Policy_Docs_Pkg.print_doc_subtitle5;
        v_report.rv_print_dtls_below_user        := Policy_Docs_Pkg.print_dtls_below_user;
        v_report.rv_print_gen_info_above        := Policy_Docs_Pkg.print_gen_info_above;
        v_report.rv_print_grouped_beneficiary     := Policy_Docs_Pkg.print_grouped_beneficiary;
        v_report.rv_print_intm_name             := Policy_Docs_Pkg.print_intm_name;
        v_report.rv_print_item_total             := Policy_Docs_Pkg.print_item_total;
        v_report.rv_print_last_endtxt             := Policy_Docs_Pkg.print_last_endtxt;
        v_report.rv_print_lower_dtls              := Policy_Docs_Pkg.print_lower_dtls;
        v_report.rv_print_mop_deductibles        := Policy_Docs_Pkg.print_mop_deductibles;
        v_report.rv_print_mop_wordings            := Policy_Docs_Pkg.print_mop_wordings;
        v_report.rv_print_mort_amt                 := Policy_Docs_Pkg.print_mort_amt;
        v_report.rv_print_mortgagee             := Policy_Docs_Pkg.print_mortgagee;
        v_report.rv_print_mortgagee_name        := Policy_Docs_Pkg.print_mortgagee_name;
        v_report.rv_print_null_mortgagee          := Policy_Docs_Pkg.print_null_mortgagee;
        v_report.rv_print_one_item_title         := Policy_Docs_Pkg.print_one_item_title;
        v_report.rv_print_one_item_title         := Policy_Docs_Pkg.print_one_item_title;
        v_report.rv_print_peril                 := Policy_Docs_Pkg.print_peril;
        v_report.rv_print_peril_name_long         := Policy_Docs_Pkg.print_peril_name_long;
        v_report.rv_print_polno_endt              := Policy_Docs_Pkg.print_polno_endt;
        v_report.rv_print_premium_rate             := Policy_Docs_Pkg.print_premium_rate;
        v_report.rv_print_ref_pol_no              := NVL(Policy_Docs_Pkg.print_ref_pol_no, 'N');
        v_report.rv_print_renewal_top            := Policy_Docs_Pkg.print_renewal_top;
        v_report.rv_print_report_title             := Policy_Docs_Pkg.print_report_title;
        v_report.rv_print_short_name              := Policy_Docs_Pkg.print_short_name;
        v_report.rv_print_signatory             := Policy_Docs_Pkg.print_signatory;
        v_report.rv_print_sub_info                 := Policy_Docs_Pkg.print_sub_info;
        v_report.rv_print_sum_insured             := Policy_Docs_Pkg.print_sum_insured;
        v_report.rv_print_survey_settling_agent := Policy_Docs_Pkg.print_survey_settling_agent;
        v_report.rv_print_tabular                := Policy_Docs_Pkg.print_tabular;
        v_report.rv_print_tariff_zone            := Policy_Docs_Pkg.print_tariff_zone;
        v_report.rv_print_time                  := Policy_Docs_Pkg.print_time;
        v_report.rv_print_upper_case              := Policy_Docs_Pkg.print_upper_case;
        v_report.rv_print_wrrnties_fontbig         := Policy_Docs_Pkg.print_wrrnties_fontbig;
        v_report.rv_print_zero_premium             := Policy_Docs_Pkg.print_zero_premium;
        v_report.rv_print_zone                    := Policy_Docs_Pkg.print_zone;
        v_report.rv_sum_insured_title              := Policy_Docs_Pkg.sum_insured_title;
        v_report.rv_sum_insured_title2             := Policy_Docs_Pkg.sum_insured_title2;
        v_report.rv_survey_title                := Policy_Docs_Pkg.survey_title;
        v_report.rv_survey_wordings                := Policy_Docs_Pkg.survey_wordings;
        v_report.rv_tax_breakdown                 := Policy_Docs_Pkg.tax_breakdown;
        v_report.rv_tsi_label1                     := Policy_Docs_Pkg.tsi_label1;
        v_report.rv_tsi_label2                     := Policy_Docs_Pkg.tsi_label2;
        v_report.rv_without_item_no                := Policy_Docs_Pkg.without_item_no;
        v_report.rv_print_ded_text_only            := Policy_Docs_Pkg.print_ded_text_only;
        v_report.rv_print_origin_dest_above        := Policy_Docs_Pkg.print_origin_dest_above;
        v_report.rv_beneficiary_item_title        := Policy_Docs_Pkg.beneficiary_item_title;
        v_report.rv_beneficiary_subtitle1        := Policy_Docs_Pkg.beneficiary_subtitle1;
        v_report.rv_beneficiary_subtitle2        := Policy_Docs_Pkg.beneficiary_subtitle2;
        v_report.rv_print_mop_no_above            := Policy_Docs_Pkg.print_mop_no_above;
        v_report.rv_print_deductible_amt_total  := Policy_Docs_Pkg.print_deductible_amt_total;
        v_report.rv_show_signature                  := Policy_Docs_Pkg.show_signature; -- bonok :: 7.30.2015 :: SR 19544
        v_report.rv_item_count                  := get_item_count(p_extract_id);
		v_report.rv_print_deductible_type := GIIS_DOCUMENT_PKG.get_doc_text2(v_report.basic_line_cd, p_report_id, 'PRINT_DEDUCTIBLE_LOSSTYPE'); -- marco - 11.21.2012 
        PIPE ROW(v_report);
        RETURN;
        
    END get_report_details;
    
    PROCEDURE initialize_variables (p_report_id IN GIIS_DOCUMENT.report_id%TYPE)
    IS
    BEGIN
        FOR REPORT IN (
            SELECT TITLE,TEXT 
              FROM GIIS_DOCUMENT    
             WHERE report_id = p_report_id)
        LOOP
            IF REPORT.TITLE = 'POLICY_POLICY_TITLE' THEN
                Policy_Docs_Pkg.PAR_POLICY := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'ENDT_PAR_TITLE' THEN
                Policy_Docs_Pkg.ENDT_PAR := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'ENDT_POLICY_TITLE' THEN
                Policy_Docs_Pkg.ENDT_POLICY := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'POLICY_PAR_TITLE' THEN
                Policy_Docs_Pkg.PAR_PAR := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'DOC_TAX_BREAKDOWN' THEN
                Policy_Docs_Pkg.TAX_BREAKDOWN := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_MORTGAGEE' THEN
                Policy_Docs_Pkg.PRINT_MORTGAGEE := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_CURRENCY_DESC' THEN
                Policy_Docs_Pkg.PRINT_CURRENCY_DESC := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_ITEM_TOTAL' THEN
                Policy_Docs_Pkg.PRINT_ITEM_TOTAL := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_PERIL' THEN
                Policy_Docs_Pkg.PRINT_PERIL := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_PERIL_LONG_NAME' THEN
                Policy_Docs_Pkg.PRINT_PERIL_NAME_LONG := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_RENEWAL_TOP' THEN
                Policy_Docs_Pkg.PRINT_RENEWAL_TOP := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_DOC_SUBTITLE1' THEN
                Policy_Docs_Pkg.PRINT_DOC_SUBTITLE1 := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_DEDUCTIBLES' THEN
                Policy_Docs_Pkg.PRINT_DEDUCTIBLES := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_DOC_SUBTITLE2' THEN
                Policy_Docs_Pkg.PRINT_DOC_SUBTITLE2 := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_DOC_SUBTITLE3' THEN
                Policy_Docs_Pkg.PRINT_DOC_SUBTITLE3 := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_DOC_SUBTITLE4' THEN
                Policy_Docs_Pkg.PRINT_DOC_SUBTITLE4 := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_ACCESSORIES_ABOVE' THEN
                Policy_Docs_Pkg.PRINT_ACCESSORIES_ABOVE := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_WARRANTIES_FONT_BIG' THEN
                Policy_Docs_Pkg.PRINT_WRRNTIES_FONTBIG := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_ALL_WARRANTIES_TITLE_ABOVE' THEN
                Policy_Docs_Pkg.PRINT_ALL_WARRANTIES := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_LAST_ENDTXT' THEN
                Policy_Docs_Pkg.PRINT_LAST_ENDTXT := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_SUB_INFO' THEN
                Policy_Docs_Pkg.PRINT_SUB_INFO := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'DOC_TAX_BREAKDOWN' THEN
                Policy_Docs_Pkg.DOC_TAX_BREAKDOWN := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_PREMIUM_RATE' THEN
                Policy_Docs_Pkg.PRINT_PREMIUM_RATE := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_MORT_AMT' THEN
                Policy_Docs_Pkg.PRINT_MORT_AMT := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_SUM_INSURED' THEN
                Policy_Docs_Pkg.PRINT_SUM_INSURED := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_ONE_ITEM_TITLE' THEN
                Policy_Docs_Pkg.PRINT_ONE_ITEM_TITLE := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_REPORT_TITLE' THEN
                Policy_Docs_Pkg.PRINT_REPORT_TITLE := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_INTM_NAME' THEN
                Policy_Docs_Pkg.PRINT_INTM_NAME := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'DOC_TOTAL_IN_BOX' THEN
                Policy_Docs_Pkg.DOC_TOTAL_IN_BOX := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'DOC_SUBTITLE1' THEN
                Policy_Docs_Pkg.DOC_SUBTITLE1  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'DOC_SUBTITLE2' THEN
                Policy_Docs_Pkg.DOC_SUBTITLE2  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'DOC_SUBTITLE3' THEN
                Policy_Docs_Pkg.DOC_SUBTITLE3  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'DOC_SUBTITLE4' THEN
                Policy_Docs_Pkg.DOC_SUBTITLE4  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'DOC_SUBTITLE4_BEFORE_WC' THEN
                Policy_Docs_Pkg.DOC_SUBTITLE4_BEFORE_WC  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'DEDUCTIBLE_TITLE' THEN
                Policy_Docs_Pkg.DEDUCTIBLE_TITLE  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PERIL_TITLE' THEN
                Policy_Docs_Pkg.PERIL_TITLE  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'ITEM_TITLE' THEN
                Policy_Docs_Pkg.ITEM_TITLE  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'SUM_INSURED_TITLE' THEN
                Policy_Docs_Pkg.SUM_INSURED_TITLE  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_UPPER_CASE' THEN
                Policy_Docs_Pkg.PRINT_UPPER_CASE  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_GROUPED_BENEFICIARY' THEN
                Policy_Docs_Pkg.PRINT_GROUPED_BENEFICIARY := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_ALL_WARRANTIES' THEN
                Policy_Docs_Pkg.PRINT_ALL_WARRANTIES  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_DEDUCTIBLES_TEXT_AMT' THEN
                Policy_Docs_Pkg.PRINT_DEDUCT_TEXT_AMT  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PERSONNEL_ITEM_TITLE' THEN
                Policy_Docs_Pkg.PERSONNEL_ITEM_TITLE  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'GROUPED_ITEM_TITLE' THEN
                Policy_Docs_Pkg.GROUPED_ITEM_TITLE  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PERSONNEL_SUBTITLE1' THEN
                Policy_Docs_Pkg.PERSONNEL_SUBTITLE1  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PERSONNEL_SUBTITLE2' THEN
                Policy_Docs_Pkg.PERSONNEL_SUBTITLE2  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PERSONNEL_SUBTITLE3' THEN
                Policy_Docs_Pkg.PERSONNEL_SUBTITLE3  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'GROUPED_SUBTITLE' THEN
                Policy_Docs_Pkg.GROUPED_SUBTITLE  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'ATTESTATION_TITLE' THEN
                Policy_Docs_Pkg.ATTESTATION_TITLE  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_REF_POL_NO' THEN
                Policy_Docs_Pkg.PRINT_REF_POL_NO  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_SHORT_NAME' THEN
                Policy_Docs_Pkg.PRINT_SHORT_NAME  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_NULL_MORTGAGEE' THEN
                Policy_Docs_Pkg.PRINT_NULL_MORTGAGEE  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'DISPLAY_POLICY_TERM' THEN
                Policy_Docs_Pkg.DISPLAY_POLICY_TERM  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_TIME' THEN
                Policy_Docs_Pkg.PRINT_TIME  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'LEASED_TO' THEN
                Policy_Docs_Pkg.LEASED_TO  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_CENTS' THEN
                Policy_Docs_Pkg.PRINT_CENTS  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_DED_TEXT_PERIL' THEN
                Policy_Docs_Pkg.PRINT_DED_TEXT_PERIL  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'DISPLAY_ANN_TSI' THEN
                Policy_Docs_Pkg.DISPLAY_ANN_TSI  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'DISPLAY_PROPERTY_TYPE' THEN
                Policy_Docs_Pkg.DISPLAY_PROPERTY_TYPE := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'DISPLAY_REF_POL_NO' THEN
                Policy_Docs_Pkg.DISPLAY_REF_POL_NO := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'CA_DEDUCTIBLE_LEVELS' THEN
                Policy_Docs_Pkg.CA_DEDUCTIBLE_LEVELS := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_DOC_SIGNATURE_POL1' THEN
                Policy_Docs_Pkg.PRINT_DOC_SIGNATURE_POL1 := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_SIGNATORY' THEN
                Policy_Docs_Pkg.PRINT_SIGNATORY := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_DOC_SIGNATURE_POL2' THEN
                Policy_Docs_Pkg.PRINT_DOC_SIGNATURE_POL2 := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'CASUALTY_CO_INSURANCE' THEN
                Policy_Docs_Pkg.CASUALTY_CO_INSURANCE := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_ZERO_PREMIUM' THEN
                Policy_Docs_Pkg.PRINT_ZERO_PREMIUM := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_LOWER_DTLS' THEN
                Policy_Docs_Pkg.PRINT_LOWER_DTLS  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_POLNO_ENDT' THEN
                Policy_Docs_Pkg.PRINT_POLNO_ENDT  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_ONE_ITEM_TITLE' THEN
                Policy_Docs_Pkg.PRINT_ONE_ITEM_TITLE := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'TSI_LABEL1' THEN
                Policy_Docs_Pkg.TSI_LABEL1 := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'TSI_LABEL2' THEN
                Policy_Docs_Pkg.TSI_LABEL2 := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'INCLUDE_TSI' THEN
                Policy_Docs_Pkg.INCLUDE_TSI := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'SUM_INSURED_TITLE2' THEN
                Policy_Docs_Pkg.SUM_INSURED_TITLE2 := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'POLICY_SIGLABEL' THEN
                Policy_Docs_Pkg.POLICY_SIGLABEL := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_AUTHORIZED_SIGNATORY' THEN
                Policy_Docs_Pkg.PRINT_AUTHORIZED_SIGNATORY := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_DED_TWICE' THEN
                Policy_Docs_Pkg.PRINT_DED_TWICE := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_ACC_TSI' THEN
                Policy_Docs_Pkg.PRINT_ACC_TSI := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'BLOCK_DESCRIPTION' THEN
                Policy_Docs_Pkg.BLOCK_DESCRIPTION := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'CONSTRUCTION_TITLE' THEN
                Policy_Docs_Pkg.CONSTRUCTION_TITLE := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'CONSTRUCTION_REMARKS_TITLE' THEN
                Policy_Docs_Pkg.CONSTR_REMARKS_TITLE := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'OCCUPANCY_TITLE' THEN
                Policy_Docs_Pkg.OCCUPANCY_TITLE := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'OCCUPANCY_REMARKS_TITLE' THEN
                Policy_Docs_Pkg.OCCUPANCY_REMARKS_TITLE := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'BOUNDARY_TITLE' THEN
                Policy_Docs_Pkg.BOUNDARY_TITLE := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_DISTRICT_BLOCK' THEN
                Policy_Docs_Pkg.PRINT_DISTRICT_BLOCK := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_ZONE' THEN
                Policy_Docs_Pkg.PRINT_ZONE := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_TARIFF_ZONE' THEN
                Policy_Docs_Pkg.PRINT_TARIFF_ZONE := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'DOC_ATTESTATION1' THEN
                Policy_Docs_Pkg.DOC_ATTESTATION1  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'DOC_ATTESTATION2' THEN
                Policy_Docs_Pkg.DOC_ATTESTATION2  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'WITHOUT_ITEM_NO' THEN
                 Policy_Docs_Pkg.WITHOUT_ITEM_NO  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_DECLARATION_NO' THEN
                 Policy_Docs_Pkg.PRINT_DECLARATION_NO  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'LINE_HIDDEN' THEN
                 Policy_Docs_Pkg.HIDE_LINE  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_CARGO_DESC' THEN
                 Policy_Docs_Pkg.PRINT_CARGO_DESC := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_MOP_DEDUCTIBLES' THEN
                 Policy_Docs_Pkg.PRINT_MOP_DEDUCTIBLES  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_GEN_INFO_ABOVE' THEN 
                 Policy_Docs_Pkg.PRINT_GEN_INFO_ABOVE  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'MOP_MAP_WORDINGS' THEN 
                 Policy_Docs_Pkg.MOP_MAP_WORDINGS  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'ALL_SUBLINE_WORDINGS1' THEN 
                 Policy_Docs_Pkg.ALL_SUBLINE_WORDINGS1  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'ALL_SUBLINE_WORDINGS2' THEN
                 Policy_Docs_Pkg.ALL_SUBLINE_WORDINGS2  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'SURVEY_TITLE' THEN
                 Policy_Docs_Pkg.SURVEY_TITLE  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'SURVEY_WORDINGS' THEN 
                 Policy_Docs_Pkg.SURVEY_WORDINGS  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_SURVEY_SETTLING_AGENT' THEN  
                 Policy_Docs_Pkg.PRINT_SURVEY_SETTLING_AGENT  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'MRN_WORDINGS' THEN  
                 Policy_Docs_Pkg.MRN_WORDINGS  := REPORT.TEXT;
             ELSIF REPORT.TITLE = 'MAR_WORDINGS' THEN  
                 Policy_Docs_Pkg.MAR_WORDINGS  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_MOP_WORDINGS' THEN
                Policy_Docs_Pkg.PRINT_MOP_WORDINGS  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_DEDUCTIBLE_AMT' THEN  
                 Policy_Docs_Pkg.PRINT_DEDUCTIBLE_AMT  := REPORT.TEXT;
			ELSIF REPORT.TITLE = 'PRINT_DEDUCTIBLE_RT' THEN  
                 Policy_Docs_Pkg.PRINT_DEDUCTIBLE_RT  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_DED_TEXT' THEN 
                 Policy_Docs_Pkg.PRINT_DED_TEXT  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_TABULAR' THEN
                 Policy_Docs_Pkg.PRINT_TABULAR := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_DOC_SUBTITLE5' THEN
                 Policy_Docs_Pkg.PRINT_DOC_SUBTITLE5 := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'DOC_SUBTITLE5_BEFORE_WC' THEN
                 Policy_Docs_Pkg.DOC_SUBTITLE5_BEFORE_WC  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'DOC_SUBTITLE5' THEN
                 Policy_Docs_Pkg.DOC_SUBTITLE5  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_MORTGAGEE_NAME' THEN
                Policy_Docs_Pkg.PRINT_MORTGAGEE_NAME := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_DTLS_BELOW_USER' THEN
                Policy_Docs_Pkg.PRINT_DTLS_BELOW_USER := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_DED_TEXT_ONLY' THEN
                 Policy_Docs_Pkg.PRINT_DED_TEXT_ONLY  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PACK_METHOD' THEN
                 Policy_Docs_Pkg.PACK_METHOD  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_ORIGIN_DEST_ABOVE' THEN  
                 Policy_Docs_Pkg.PRINT_ORIGIN_DEST_ABOVE  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_DEDUCTIBLE_AMT' THEN 
                 Policy_Docs_Pkg.PRINT_DEDUCTIBLE_AMT  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'BENEFICIARY_ITEM_TITLE' THEN 
                 Policy_Docs_Pkg.BENEFICIARY_ITEM_TITLE  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'BENEFICIARY_SUBTITLE1' THEN 
                 Policy_Docs_Pkg.BENEFICIARY_SUBTITLE1  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'BENEFICIARY_SUBTITLE2' THEN 
                 Policy_Docs_Pkg.BENEFICIARY_SUBTITLE2  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_MOP_NO_ABOVE' THEN  -- ging 080206
                 Policy_Docs_Pkg.PRINT_MOP_NO_ABOVE  := REPORT.TEXT;
            ELSIF REPORT.TITLE = 'PRINT_DEDUCTIBLE_AMT_TOTAL' THEN
                 Policy_Docs_Pkg.PRINT_DEDUCTIBLE_AMT_TOTAL  := REPORT.TEXT;
			ELSIF REPORT.TITLE = 'SHOW_SIGNATURE' THEN -- bonok :: 7.30.2015 :: SR 19544
                 Policy_Docs_Pkg.SHOW_SIGNATURE  := REPORT.TEXT;
            END IF;            
            
        END LOOP;
    END initialize_variables;
    
    FUNCTION get_giisp_v_param(p_report_id    IN GIIS_DOCUMENT.report_id%TYPE)
    RETURN VARCHAR2
    IS
        v_line_cd VARCHAR2(20);
    BEGIN
        IF p_report_id = 'FIRE' THEN
            v_line_cd := 'LINE_CODE_FI';
        ELSIF p_report_id = 'MARINE_CARGO' THEN
            v_line_cd := 'LINE_CODE_MN';
        ELSIF p_report_id = 'SURETYSHIP' THEN
            v_line_cd := 'LINE_CODE_SU';
        ELSIF p_report_id = 'MOTORCAR' THEN
            v_line_cd := 'LINE_CODE_MC';
        ELSIF p_report_id = 'ACCIDENT' THEN
            v_line_cd := 'LINE_CODE_AH';
        ELSIF p_report_id = 'CASUALTY' THEN
            v_line_cd := 'LINE_CODE_CA';
        ELSIF p_report_id = 'AVIATION' THEN
            v_line_cd := 'LINE_CODE_AV';
        ELSIF p_report_id = 'ENGINEERING' THEN
            v_line_cd := 'LINE_CODE_EN';
        ELSIF p_report_id = 'MARINE_HULL' THEN
            v_line_cd := 'LINE_CODE_MH';
        END IF;
        
        RETURN v_line_cd;
    END;
    
    FUNCTION CF_TSI_AMT2 (
        p_extract_id IN GIXX_POLBASIC.extract_id%TYPE,
        p_basic_tsi_amt IN GIXX_POLBASIC.tsi_amt%TYPE,
        p_basic_co_insurance_sw IN GIXX_POLBASIC.co_insurance_sw%TYPE) RETURN NUMBER
    IS
        v_extact              GIXX_INVOICE.extract_id%TYPE;
        v_prem_amt          GIXX_INVOICE.prem_amt%TYPE;
        v_tax_amt              GIXX_INVOICE.tax_amt%TYPE;
        v_other              GIXX_INVOICE.other_charges%TYPE;
        v_total              GIXX_INVOICE.prem_amt%TYPE;
        v_policy_curr       GIXX_INVOICE.policy_currency%TYPE;
        v_tsi_amt             GIXX_INVOICE.prem_amt%TYPE;
        v_main_tsi          GIXX_POLBASIC.tsi_amt%TYPE;
        v_co_ins_sw         VARCHAR2(1);
        v_rate                  GIXX_ITEM.currency_rt%TYPE := 1;
    BEGIN
        FOR X IN (
            SELECT B450.EXTRACT_ID EXTRACT_ID20,
                   SUM(DECODE(NVL(B450.POLICY_CURRENCY,'N'),'N',( NVL(B450.PREM_AMT,0) *  B450.CURRENCY_RT), NVL(B450.PREM_AMT,0))) PREMIUM_AMT,
                   SUM(DECODE(NVL(B450.POLICY_CURRENCY,'N'),'N',( NVL(B450.TAX_AMT,0) * B450.CURRENCY_RT), NVL(B450.TAX_AMT,0))) TAX_AMT,
                   SUM(DECODE(NVL(B450.POLICY_CURRENCY,'N'),'N',( NVL(B450.OTHER_CHARGES,0) * B450.CURRENCY_RT),NVL(B450.OTHER_CHARGES,0))) OTHER_CHARGES,
                   SUM(DECODE(NVL(B450.POLICY_CURRENCY,'N'),'N',( NVL(B450.PREM_AMT,0) *  B450.CURRENCY_RT), NVL(B450.PREM_AMT,0))) +
                   SUM(DECODE(NVL(B450.POLICY_CURRENCY,'N'),'N',( NVL(B450.TAX_AMT,0) * B450.CURRENCY_RT), NVL(B450.TAX_AMT,0))) +
                   SUM(DECODE(NVL(B450.POLICY_CURRENCY,'N'),'N',( NVL(B450.OTHER_CHARGES,0) * B450.CURRENCY_RT),NVL(B450.OTHER_CHARGES,0))) TOTAL,
                   B450.POLICY_CURRENCY POLICY_CURRENCY
              FROM GIXX_INVOICE B450, GIXX_POLBASIC POL
             WHERE B450.EXTRACT_ID = p_extract_id
               AND B450.EXTRACT_ID = POL.EXTRACT_ID
               AND POL.CO_INSURANCE_SW IN ('1','3')
          GROUP BY B450.EXTRACT_ID, B450.POLICY_CURRENCY 
             UNION
            SELECT B450.EXTRACT_ID EXTRACT_ID20,
                   SUM(DECODE(NVL(B450.POLICY_CURRENCY,'N'),'N',( NVL(B450.PREM_AMT,0) *  B450.CURRENCY_RT), NVL(B450.PREM_AMT,0))) PREMIUM_AMT,
                   SUM(DECODE(NVL(B450.POLICY_CURRENCY,'N'),'N',( NVL(B450.TAX_AMT,0) * B450.CURRENCY_RT), NVL(B450.TAX_AMT,0))) TAX_AMT,
                   SUM(DECODE(NVL(B450.POLICY_CURRENCY,'N'),'N',( NVL(B450.OTHER_CHARGES,0) * B450.CURRENCY_RT),NVL(B450.OTHER_CHARGES,0))) OTHER_CHARGES,
                   SUM(DECODE(NVL(B450.POLICY_CURRENCY,'N'),'N',( NVL(B450.PREM_AMT,0) *  B450.CURRENCY_RT), NVL(B450.PREM_AMT,0))) +
                   SUM(DECODE(NVL(B450.POLICY_CURRENCY,'N'),'N',( NVL(B450.TAX_AMT,0) * B450.CURRENCY_RT), NVL(B450.TAX_AMT,0))) +
                   SUM(DECODE(NVL(B450.POLICY_CURRENCY,'N'),'N',( NVL(B450.OTHER_CHARGES,0) * B450.CURRENCY_RT),NVL(B450.OTHER_CHARGES,0))) TOTAL ,B450.POLICY_CURRENCY POLICY_CURRENCY
              FROM GIXX_ORIG_INVOICE B450,GIXX_POLBASIC POL
             WHERE B450.EXTRACT_ID = p_extract_id
               AND B450.EXTRACT_ID = POL.EXTRACT_ID
               AND POL.CO_INSURANCE_SW  = '2'  
          GROUP BY B450.EXTRACT_ID,B450.POLICY_CURRENCY)
        LOOP
            v_extact        := X.extract_ID20; 
            v_prem_amt      := X.premium_amt;  
            v_tax_amt       := X.tax_amt;  
            v_other         := X.other_charges;
            v_total         := X.total ;
            v_policy_curr   := X.policy_currency;
        END LOOP;

        IF v_policy_curr = 'Y' THEN
            FOR b IN (
                SELECT currency_rt
                 FROM GIXX_ITEM
                 WHERE extract_id = p_extract_id)
            LOOP
                v_rate := b.currency_rt;
            END LOOP;
        END IF;
        
        v_main_tsi := p_basic_tsi_amt / v_rate;
        
        IF p_basic_co_insurance_sw = 2 THEN
            FOR a IN (
                SELECT (NVL(a.tsi_amt,0) * b.currency_rt)  tsi
                  FROM GIXX_MAIN_CO_INS a, GIXX_INVOICE b
                 WHERE a.extract_id = b.extract_id
                   AND a.extract_id = p_extract_id)
            LOOP
                v_main_tsi := a.tsi;
                EXIT;
            END LOOP;
        END IF;      
          
        RETURN (v_main_tsi);
    END;
    
    FUNCTION get_line_name(p_report_id IN GIIS_DOCUMENT.report_id%TYPE)
    RETURN VARCHAR2
    IS
        v_line_name    VARCHAR2(50);
    BEGIN
        IF p_report_id IN ('FIRE', 'CASUALTY', 'AVIATION', 'ENGINEERING', 'ACCIDENT', 'MARINE_CARGO') THEN
            v_line_name := p_report_id;
        ELSIF p_report_id =  'MOTORCAR' THEN
            v_line_name := 'MOTOR CAR';
        ELSIF p_report_id = 'MARINE_HULL' THEN
            v_line_name := 'MARINE HULL';
        ELSIF p_report_id = 'MARINE_CARGO' THEN
            v_line_name := 'MARINE CARGO';
        END IF;
        
        RETURN v_line_name;        
    END get_line_name;
    
    FUNCTION get_pol_doc_prem_title (p_print_upper_case  IN GIIS_DOCUMENT.text%TYPE)
    RETURN VARCHAR2
    IS
        v_title_upper    VARCHAR2(25) := RPAD('PREMIUM', 18, ' ');
        v_title_initc     VARCHAR2(25) := RPAD('Premium', 18, ' ');
    BEGIN
        IF NVL(p_print_upper_case, 'N') = 'Y' THEN
            RETURN v_title_upper;
        ELSE
            RETURN v_title_initc;
        END IF;
    END get_pol_doc_prem_title;
    
    FUNCTION get_eng_taxes_list(p_extract_id     IN   GIXX_INV_TAX.extract_id%TYPE)
    RETURN eng_taxes_tab PIPELINED IS
    
    v_tax_eng               eng_taxes_type;
    v_count_taxes           NUMBER := 0;
    v_sum_other_charges     NUMBER := 0;
    v_final_count_taxes     NUMBER := 0;
    v_show                  VARCHAR2(1);
    
    CURSOR tax IS 
        SELECT ALL invtax.extract_id                  extract_id, 
               invtax.tax_cd                       invtax_tax_cd, 
               DECODE(invoice.policy_currency,'Y',SUM(invtax.tax_amt),SUM(invtax.tax_amt * invoice.currency_rt))    invtax_tax_amt, 
               taxcharg.tax_desc                    taxcharg_tax_desc,
               taxcharg.include_tag                 tax_charge_include_tag,
               DECODE(taxcharg.tax_desc, 'OTHERS', 100, 'OTHER CHARGES', 100, taxcharg.sequence) taxcharg_sequence 
          FROM GIXX_INVOICE invoice, 
               GIXX_INV_TAX invtax, 
               GIIS_TAX_CHARGES taxcharg,
               GIXX_POLBASIC pol,
               GIXX_PARLIST par
        WHERE (invtax.iss_cd, invtax.line_cd, invtax.tax_cd, invtax.tax_id) = ((taxcharg.iss_cd, taxcharg.line_cd, taxcharg.tax_cd, taxcharg.tax_id ))
          AND invoice.extract_id = invtax.extract_id 
          AND invoice.extract_id = p_extract_id
          AND invoice.extract_id = pol.extract_id
          AND pol.co_insurance_sw IN (1,3)
          AND par.extract_id    = pol.extract_id
          AND DECODE(par.par_status,10,invoice.prem_seq_no,1) = DECODE(par.par_status,10,invtax.prem_seq_no,1)
          AND invtax.item_grp = invoice.item_grp
          AND taxcharg.include_tag = 'N'
        GROUP BY invtax.extract_id, 
                 invtax.tax_cd,  
                 taxcharg.tax_desc, taxcharg.sequence,
                 taxcharg.include_tag,invoice.policy_currency
        UNION
        SELECT ALL invtax.extract_id                  extract_id, 
               invtax.tax_cd                          invtax_tax_cd, 
               DECODE(invoice.policy_currency,'Y',SUM(invtax.tax_amt),SUM(invtax.tax_amt * invoice.currency_rt))    invtax_tax_amt, 
               taxcharg.tax_desc                      taxcharg_tax_desc,
               taxcharg.include_tag                   tax_charge_include_tag,
               DECODE(taxcharg.tax_desc, 'OTHERS', 100, 'OTHER CHARGES', 100, taxcharg.sequence) taxcharg_sequence 
          FROM GIXX_ORIG_INVOICE invoice, 
               GIXX_ORIG_INV_TAX invtax, 
               GIIS_TAX_CHARGES taxcharg,
               GIXX_POLBASIC pol
        WHERE (invtax.iss_cd, invtax.line_cd, invtax.tax_cd, invtax.tax_id) = ((taxcharg.iss_cd, taxcharg.line_cd, taxcharg.tax_cd, taxcharg.tax_id))
          AND invoice.extract_id = invtax.extract_id
          AND invoice.extract_id = p_extract_id
          AND invoice.extract_id = pol.extract_id
          AND pol.co_insurance_sw = 2
          AND taxcharg.include_tag = 'N'
        GROUP BY invtax.extract_id, 
                 invtax.tax_cd,  
                 taxcharg.tax_desc, taxcharg.sequence,
                 taxcharg.include_tag,invoice.policy_currency
        ORDER BY taxcharg_sequence;
    
   BEGIN
       FOR i IN tax
       LOOP
            v_final_count_taxes := v_final_count_taxes + 1;
       END LOOP; 
       
       BEGIN
         SELECT NVL(text, 'N')
           INTO v_show
           FROM GIIS_DOCUMENT
         WHERE title = 'SHOW_4TAXES_EN';
       EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_show := 'N'; 
       END;
       
       FOR i IN tax
       LOOP
          v_count_taxes := v_count_taxes + 1; 
          
          IF v_show = 'Y' THEN
              v_tax_eng.extract_id        := i.extract_id;
              v_tax_eng.invtax_tax_amt    := i.invtax_tax_amt;
              v_tax_eng.taxcharg_tax_desc := i.taxcharg_tax_desc;
              v_tax_eng.invtax_tax_cd     := i.invtax_tax_cd;
              v_tax_eng.taxcharg_sequence := i.taxcharg_sequence;
              v_tax_eng.tax_charge_include_tag := i.tax_charge_include_tag;
              v_tax_eng.count_tax         := v_final_count_taxes;
              PIPE ROW(v_tax_eng);
          ELSE
              IF v_count_taxes > 4 AND v_final_count_taxes > 5 THEN
                  v_sum_other_charges := v_sum_other_charges + i.invtax_tax_amt;
                  
                  IF v_count_taxes = v_final_count_taxes THEN
                    v_tax_eng.extract_id        := i.extract_id;
                    v_tax_eng.invtax_tax_amt    := v_sum_other_charges;
                    v_tax_eng.taxcharg_tax_desc := 'OTHER CHARGES';
                    v_tax_eng.invtax_tax_cd     := i.invtax_tax_cd;
                    v_tax_eng.taxcharg_sequence := i.taxcharg_sequence;
                    v_tax_eng.tax_charge_include_tag := i.tax_charge_include_tag;
                    v_tax_eng.count_tax         := v_final_count_taxes; 
                    PIPE ROW(v_tax_eng);
                  END IF;
                  
              ELSE
                  v_tax_eng.extract_id        := i.extract_id;
                  v_tax_eng.invtax_tax_amt    := i.invtax_tax_amt;
                  v_tax_eng.taxcharg_tax_desc := i.taxcharg_tax_desc;
                  v_tax_eng.invtax_tax_cd     := i.invtax_tax_cd;
                  v_tax_eng.taxcharg_sequence := i.taxcharg_sequence;
                  v_tax_eng.tax_charge_include_tag := i.tax_charge_include_tag;
                  v_tax_eng.count_tax         := v_final_count_taxes;
                  PIPE ROW(v_tax_eng);
                  
              END IF;
          END IF;
            
       END LOOP;
   END get_eng_taxes_list;
   
    
END POLICY_DOCS_PKG;
/


