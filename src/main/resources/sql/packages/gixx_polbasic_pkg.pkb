CREATE OR REPLACE PACKAGE BODY CPI.GIXX_POLBASIC_PKG AS

  FUNCTION get_gixx_polbasic(p_extract_id         GIXX_POLBASIC.extract_id%TYPE)
    RETURN gixx_polbasic_tab PIPELINED IS
    v_polbasic                 gixx_polbasic_type;
  BEGIN
    FOR i IN (SELECT B540.LINE_CD || '-' ||B540.ISS_CD || '-' ||LTRIM(TO_CHAR(B540.issue_YY, '09')) || '-' || TRIM(TO_CHAR(B540.Pol_SEQ_NO, '099999')) 
                                      || '-' ||LTRIM(TO_CHAR(B540.renew_NO, '09'))  || DECODE(B540.REG_POLICY_SW,'N',' **') PAR_SEQ_NO1
                        ,B540.extract_ID    EXTRACT_ID1
                        ,B540.POLICY_ID  PAR_ID
                        ,B540.LINE_CD || '-' || b540.subline_cd || '-' || B540.ISS_CD || '-' || LTRIM(TO_CHAR(B540.issue_YY, '09')) || '-' || TRIM(TO_CHAR(B540.Pol_SEQ_NO, '099999'))
                                    || '-' || LTRIM(TO_CHAR(B540.renew_NO, '09')) POLICY_NUMBER
                        ,DECODE(B240.PAR_STATUS,10,B540.ISS_CD,B240.ISS_CD) iss_cd
                        ,DECODE(B240.PAR_STATUS,10,B540.LINE_CD,B240.LINE_CD) line_cd 
                        ,DECODE(B240.PAR_STATUS,10,B540.LINE_CD  || '-' ||b540.subline_cd || '-' ||B540.ISS_CD || '-' ||LTRIM(TO_CHAR(B540.ISSUE_YY, '09')) || '-'||                                                 
                             LTRIM(TO_CHAR(B540.POL_SEQ_NO, '0999999')) || '-' || LTRIM(TO_CHAR(B540.RENEW_NO, '09')) || DECODE(B540.REG_POLICY_SW,'N',' **'),             
                            B240.LINE_CD || '-' ||B240.ISS_CD || '-' ||LTRIM(TO_CHAR(B240.PAR_YY, '09')) || '-' ||TRIM(TO_CHAR(B240.PAR_SEQ_NO, '099999')) || '-' ||                          
                            LTRIM(TO_CHAR(B240.QUOTE_SEQ_NO, '09'))  || DECODE(B540.REG_POLICY_SW,'N',' **'))  PAR_NO   
                        ,B240.LINE_CD || '-' ||B240.ISS_CD || '-' ||LTRIM(TO_CHAR(B240.PAR_YY, '09')) || '-' ||TRIM(TO_CHAR(B240.PAR_SEQ_NO, '099999')) || '-'||             
                                       LTRIM(TO_CHAR(B240.QUOTE_SEQ_NO, '09'))  || DECODE(B540.REG_POLICY_SW,'N',' **') PAR_ORIG
                        ,A150.LINE_NAME    LINE_LINE_NAME
                        ,A210.SUBLINE_NAME SUBLINE_SUBLINE_NAME
                        ,A210.SUBLINE_CD   SUBLINE_SUBLINE_CD
                        ,A210.LINE_CD      SUBLINE_LINE_CD
                        ,DECODE(B240.PAR_TYPE,'E',TO_CHAR(B540.INCEPT_DATE,'FMMonth DD, YYYY') ,DECODE(B540.INCEPT_TAG,'Y',LTRIM('T.B.A.'),TO_CHAR(B540.INCEPT_DATE,'FMMonth DD, YYYY')))   BASIC_INCEPT_DATE
                        ,DECODE(TO_CHAR(B540.INCEPT_DATE,'HH:MI:SS AM'),'12:00:00 AM',
                                                   '12:00:00 MN','12:00:00 PM',
                                                   '12:00:00 NOON',TO_CHAR(B540.INCEPT_DATE,'HH:MI:SS AM'))  BASIC_INCEPT_TIME
                        ,DECODE(B540.EXPIRY_TAG,'Y',LTRIM('T.B.A.'),TO_CHAR(B540.EXPIRY_DATE,'FMMonth DD, YYYY'))    BASIC_EXPIRY_DATE
                        ,DECODE(TO_CHAR(B540.EXPIRY_DATE,'HH:MI:SS AM'),'12:00:00 AM',
                                                   '12:00:00 MN','12:00:00 PM',
                                                   '12:00:00 NOON',TO_CHAR(B540.EXPIRY_DATE,'HH:MI:SS AM'))  BASIC_EXPIRY_TIME
                        ,B540.EXPIRY_TAG   BASIC_EXPIRY_TAG
                        ,TO_CHAR(B540.ISSUE_DATE, 'FMMonth DD, YYYY')   BASIC_ISSUE_DATE
                        ,B540.TSI_AMT      BASIC_TSI_AMT
                        ,DECODE(TO_CHAR(TO_DATE(a210.subline_time,'SSSSS'),'HH:MI:SS AM'),'12:00:00 AM','12:00:00 MN','12:00:00 PM','12:00:00 NOON',TO_CHAR(TO_DATE(a210.subline_time,'SSSSS'),'HH:MI:SS AM')) SUBLINE_SUBLINE_TIME
                        ,B540.ACCT_OF_CD   BASIC_ACCT_OF_CD
                        ,B540.MORTG_NAME   BASIC_MORTG_NAME
                        ,DECODE(A020.DESIGNATION, NULL,  A020.ASSD_NAME || A020.ASSD_NAME2,A020.DESIGNATION || ' ' || A020.ASSD_NAME ||                         
                                    A020.ASSD_NAME2) ASSD_NAME,
                        DECODE(B240.PAR_TYPE, 'E',DECODE(B540.OLD_ADDRESS1, NULL, B240.ADDRESS1, B540.OLD_ADDRESS1), B540.ADDRESS1) ADDRESS1, 
                        DECODE(B240.PAR_TYPE, 'E', DECODE(B540.OLD_ADDRESS1, NULL, B240.ADDRESS2, B540.OLD_ADDRESS2), B540.ADDRESS2) ADDRESS2, 
                        DECODE(B240.PAR_TYPE, 'E', DECODE(B540.OLD_ADDRESS1, NULL, B240.ADDRESS3, B540.OLD_ADDRESS3), B540.ADDRESS3) ADDRESS3
                        ,DECODE(B240.PAR_TYPE, 'E',DECODE(B540.OLD_ADDRESS1, NULL, B240.ADDRESS1, B540.OLD_ADDRESS1), B540.ADDRESS1)||' '|| 
                        DECODE(B240.PAR_TYPE, 'E', DECODE(B540.OLD_ADDRESS1, NULL, B240.ADDRESS2, B540.OLD_ADDRESS2), B540.ADDRESS2)||' '|| 
                        DECODE(B240.PAR_TYPE, 'E', DECODE(B540.OLD_ADDRESS1, NULL, B240.ADDRESS3, B540.OLD_ADDRESS3), B540.ADDRESS3) basic_addr
                        ,B540.POL_FLAG          BASIC_POL_FLAG 
                        ,B540.LINE_CD           BASIC_LINE_CD
                        ,B540.REF_POL_NO        BASIC_REF_POL_NO
                        ,B540.ASSD_NO           BASIC_ASSD_NO
                        ,DECODE(B540.LABEL_TAG,'Y','Leased to    :','In acct of   :') Label_Tag
                        ,decode(b240.par_type,'E',B540.ENDT_ISS_CD || '-' || LTRIM(TO_CHAR(B540.ENDT_YY, '09')) || '-' ||LTRIM(TO_CHAR(B540.ENDT_SEQ_NO, '099999'))) ENDT_NO
                        ,decode(b240.par_type,'E',B540.LINE_CD || '-' || B540.SUBLINE_CD || '-' || B540.ISS_CD || '-' ||LTRIM(TO_CHAR(B540.ISSUE_YY, '09')) || '-' ||LTRIM(TO_CHAR(B540.POL_SEQ_NO, '099999')) || '-' || LTRIM(TO_CHAR(B540.RENEW_NO, '09')) || ' - ' ||B540.ENDT_ISS_CD || '-' || LTRIM(TO_CHAR(B540.ENDT_YY, '09')) || '-' ||LTRIM(TO_CHAR(B540.ENDT_SEQ_NO, '099999'))) POL_ENDT_NO
                        ,DECODE(B540.ENDT_EXPIRY_TAG,'Y','T.B.A.',TO_CHAR(B540.ENDT_EXPIRY_DATE,'FMMonth DD, YYYY'))  ENDT_EXPIRY_DATE
                        ,TO_CHAR(B540.EFF_DATE, 'FMMonth DD, YYYY')         BASIC_EFF_DATE
                        , B540.EFF_DATE                EFF_DATE
                        ,decode(b240.par_type,'E',B540.ENDT_EXPIRY_TAG)   ENDT_EXPIRY_TAG      
                        ,B540.INCEPT_TAG        BASIC_INCEPT_TAG
                        ,B540.SUBLINE_CD           BASIC_SUBLINE_CD
                        ,B540.ISS_CD               BASIC_ISS_CD    
                        ,B540.ISSUE_YY          BASIC_ISSUE_YY
                        ,B540.POL_SEQ_NO        BASIC_POL_SEQ_NO
                        ,B540.RENEW_NO           BASIC_RENEW_NO
                        ,DECODE(TO_CHAR(B540.EFF_DATE,'HH:MI:SS AM'),'12:00:00 AM','12:00:00 MN','12:00:00 PM','12:00:00 NOON',TO_CHAR(B540.EFF_DATE,'HH:MI:SS AM'))                 BASIC_EFF_TIME
                        ,DECODE(TO_CHAR(B540.ENDT_EXPIRY_DATE,'HH:MI:SS AM'),'12:00:00 AM','12:00:00 MN','12:00:00 PM','12:00:00 NOON',TO_CHAR(B540.ENDT_EXPIRY_DATE,'HH:MI:SS AM')) BASIC_ENDT_EXPIRY_TIME
                        ,B240.PAR_TYPE         PAR_PAR_TYPE
                        ,B240.PAR_STATUS    PAR_PAR_STATUS
                        ,B540.CO_INSURANCE_SW BASIC_CO_INSURANCE_SW
                        ,' * '||USER||' * ' USERNAME
                     ,ltrim(NVL2 ( PARENT.REF_INTM_CD, AGENT.PARENT_INTM_NO || '-' || PARENT.REF_INTM_CD , AGENT.PARENT_INTM_NO )
                                  ||' / '||    NVL2 ( AGENT.REF_INTM_CD, AGENT.INTM_NO || '-' || AGENT.REF_INTM_CD , AGENT.INTM_NO )) INTM_NO     
                        ,LTRIM(PARENT.INTM_NAME||' / '|| AGENT.INTM_NAME)  INTM_NAME, 
                     PARENT.INTM_NAME PARENT_INTM_NAME, 
                     AGENT.INTM_NAME AGENT_INTM_NAME,
                     AGENT.PARENT_INTM_NO PARENT_INTM_NO,
                        AGENT.INTM_NO                  AGENT_INTM_NO
                     ,B540.TSI_AMT     BASIC_TSI_AMT_1
                     ,A210.OP_FLAG  SUBLINE_OPEN_POLICY,
                     DECODE(TO_CHAR(TO_DATE(a210.subline_time,'SSSSS'),'HH:MI AM'),'12:00 AM','12:00 MN','12:00 PM','12:00 noon',TO_CHAR(TO_DATE(a210.subline_time,'SSSSS'),'HH:MI AM')) subline_time
                     ,DECODE(b240.par_type,'E', NVL(b540.old_assd_no,b240.assd_no), b240.assd_no) basic_assd_number,
                     b540.cred_branch cred_br,
                     B540.label_tag label_tag_1
                     ,nvl(b540.polendt_printed_cnt,0)      BASIC_PRINTED_CNT
                     ,b540.polendt_printed_date    BASIC_PRINTED_DT
                     ,b540.ann_tsi_amt ann_tsi_amt
                FROM GIxx_POLBASIC B540
                      , GIxx_PARLIST B240
                      , GIIS_LINE A150
                      , GIIS_SUBLINE A210
                      , GIIS_ASSURED A020
                      , GIXX_COMM_INVOICE B440
                      , GIIS_INTERMEDIARY AGENT
                      , GIIS_INTERMEDIARY PARENT

               WHERE B540.extract_ID     = p_extract_id
                 AND B240.EXTRACT_ID     = B540.EXTRACT_ID
                 AND   A150.LINE_CD        = B540.LINE_CD
                 AND   A210.LINE_CD        = B540.LINE_CD
                 AND   A210.SUBLINE_CD     = B540.SUBLINE_CD
                 AND   A020.ASSD_NO        = B240.ASSD_NO
                 AND ( B540.EXTRACT_ID = B440.EXTRACT_ID (+) )
                 AND ( B440.INTRMDRY_INTM_NO=AGENT.INTM_NO (+) )  
                 AND ( AGENT.PARENT_INTM_NO=PARENT.INTM_NO (+) )
                 AND ROWNUM <2)
    LOOP
      v_polbasic.par_seq_no1          := i.par_seq_no1;
      v_polbasic.extract_id1          := i.extract_id1;
      v_polbasic.par_id                  := i.par_id;
      v_polbasic.policy_number          := i.policy_number;
      v_polbasic.iss_cd                  := i.iss_cd;
      v_polbasic.line_cd              := i.line_cd;
      v_polbasic.par_no               := i.par_no;
      v_polbasic.par_orig              := i.par_orig;
      v_polbasic.line_line_name          := i.line_line_name;
      v_polbasic.subline_subline_name := i.subline_subline_name;
      v_polbasic.subline_subline_cd     := i.subline_subline_cd;
      v_polbasic.subline_line_cd     := i.subline_line_cd;
      v_polbasic.basic_incept_date     := i.basic_incept_date;
      v_polbasic.basic_incept_time     := i.basic_incept_time;
      v_polbasic.basic_expiry_date     := i.basic_expiry_date;
      v_polbasic.basic_expiry_time     := i.basic_expiry_time;
      v_polbasic.basic_expiry_tag     := i.basic_expiry_tag;
      v_polbasic.basic_issue_date     := i.basic_issue_date;
      v_polbasic.basic_tsi_amt          := i.basic_tsi_amt;
      v_polbasic.subline_subline_time := i.subline_subline_time;
      v_polbasic.basic_acct_of_cd     := i.basic_acct_of_cd;
      v_polbasic.basic_mortg_name     := i.basic_mortg_name;
      v_polbasic.assd_name              := i.assd_name;
      v_polbasic.address1              := i.address1;
      v_polbasic.address2              := i.address2;
      v_polbasic.address3              := i.address3;
      v_polbasic.basic_addr           := i.basic_addr;
      v_polbasic.basic_pol_flag          := i.basic_pol_flag;
      v_polbasic.basic_line_cd          := i.basic_line_cd;
      v_polbasic.basic_ref_pol_no     := i.basic_ref_pol_no;
      v_polbasic.basic_assd_no          := i.basic_assd_no;
      v_polbasic.label_tag              := i.label_tag;
      v_polbasic.endt_no              := i.endt_no;
      v_polbasic.pol_endt_no         := i.pol_endt_no;
      v_polbasic.endt_expiry_date     := i.endt_expiry_date;
      v_polbasic.basic_eff_date          := i.basic_eff_date;
      v_polbasic.eff_date              := i.eff_date;
      v_polbasic.endt_expiry_tag     := i.endt_expiry_tag;
      v_polbasic.basic_incept_tag     := i.basic_incept_tag;
      v_polbasic.basic_subline_cd     := i.basic_subline_cd;
      v_polbasic.basic_iss_cd          := i.basic_iss_cd;
      v_polbasic.basic_issue_yy          := i.basic_issue_yy;
      v_polbasic.basic_pol_seq_no     := i.basic_pol_seq_no;
      v_polbasic.basic_renew_no          := i.basic_renew_no;
      v_polbasic.basic_eff_time          := i.basic_eff_time;
      v_polbasic.basic_endt_expiry_time     := i.basic_endt_expiry_time;
      v_polbasic.par_par_type          := i.par_par_type;
      v_polbasic.par_par_status          := i.par_par_status;
      v_polbasic.basic_co_insurance_sw     := i.basic_co_insurance_sw;
      v_polbasic.username              := i.username;
      v_polbasic.intm_no              := i.intm_no;
      v_polbasic.intm_name              := i.intm_name;
      v_polbasic.agent_intm_name     := i.agent_intm_name;
      v_polbasic.parent_intm_name     := i.parent_intm_name;
      v_polbasic.agent_intm_no          := i.agent_intm_no;
      v_polbasic.parent_intm_no          := i.parent_intm_no;
      v_polbasic.basic_tsi_amt_1     := i.basic_tsi_amt_1;
      v_polbasic.subline_open_policy := i.subline_open_policy;
      v_polbasic.subline_time          := i.subline_time;
      v_polbasic.basic_assd_number     := i.basic_assd_number;
      v_polbasic.cred_br              := i.cred_br;
      v_polbasic.label_tag_1          := i.label_tag_1;
      v_polbasic.basic_printed_cnt     := i.basic_printed_cnt;
      v_polbasic.basic_printed_dt     := i.basic_printed_dt;
      v_polbasic.ann_tsi_amt          := i.ann_tsi_amt;
      PIPE ROW(v_polbasic);
    END LOOP;
    RETURN;
  END get_gixx_polbasic;    
  
  
  /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  February 15, 2013
  ** Reference by:  GIPIS101 - Policy Information (Summary)
  ** Description:   Retrieves info for GIPIS101
  */
  FUNCTION get_policy_summary(
    p_iss_cd        GIXX_POLBASIC.iss_cd%TYPE,
    p_line_cd       GIXX_POLBASIC.line_cd%TYPE,
    p_subline_cd    GIXX_POLBASIC.subline_cd%TYPE,
    p_issue_yy      GIXX_POLBASIC.issue_yy%TYPE,
    p_pol_seq_no    GIXX_POLBASIC.pol_seq_no%TYPE,
    p_renew_no      GIXX_POLBASIC.renew_no%TYPE,
    p_ref_pol_no    GIXX_POLBASIC.ref_pol_no%TYPE
  ) RETURN gixx_polbasic_tab2 PIPELINED
  IS
    v_polbasic      gixx_polbasic_type2;
    v_policy_id     GIXX_POLBASIC.POLICY_ID%TYPE;
    v_exist_or_not  VARCHAR(100);
    v_line_cd       GIIS_LINE.line_cd%TYPE;
    v_menu_line_cd  GIIS_LINE.MENU_LINE_CD%TYPE;
    v_line_mn               giis_parameters.param_value_v%TYPE;
    v_line_ca               giis_parameters.param_value_v%TYPE;
    v_line_fi               giis_parameters.param_value_v%TYPE;
    v_line_ac               giis_parameters.param_value_v%TYPE;
    v_line_av               giis_parameters.param_value_v%TYPE;
    v_line_en               giis_parameters.param_value_v%TYPE;
    v_line_mc               giis_parameters.param_value_v%TYPE;
    v_line_mh               giis_parameters.param_value_v%TYPE;
    v_line_su               giis_parameters.param_value_v%TYPE;
    v_subline_op            giis_parameters.param_value_v%TYPE;
    v_subline_car           giis_parameters.param_value_v%TYPE;
    v_subline_ear           giis_parameters.param_value_v%TYPE;
    v_subline_mbi           giis_parameters.param_value_v%TYPE;
    v_subline_dos           giis_parameters.param_value_v%TYPE;
    v_subline_bpv           giis_parameters.param_value_v%TYPE;
    v_subline_eei           giis_parameters.param_value_v%TYPE;
    v_subline_pcp           giis_parameters.param_value_v%TYPE;
    v_subline_bbi           giis_parameters.param_value_v%TYPE;
    v_subline_mop           giis_parameters.param_value_v%TYPE;
    v_subline_oth           giis_parameters.param_value_v%TYPE;
    v_subline_mlop          giis_parameters.param_value_v%TYPE;
    v_co_ri_cd              giis_parameters.param_value_n%TYPE;
    v_rate                  VARCHAR2(100);
    variables_subline_open  giis_subline.subline_cd%TYPE;
    variables_subline_mop   giis_subline.subline_cd%TYPE;
  BEGIN
     -- initialize_line_cd procedure body
     BEGIN
         SELECT ca.param_value_v, mn.param_value_v, fi.param_value_v, 
                ac.param_value_v, av.param_value_v, en.param_value_v,
                mc.param_value_v, mh.param_value_v, su.param_value_v
           INTO v_line_ca, v_line_mn, v_line_fi,
                v_line_ac, v_line_av, v_line_en,
                v_line_mc, v_line_mh, v_line_su
           FROM giis_parameters ca, giis_parameters mn, giis_parameters fi,
                giis_parameters ac, giis_parameters av, giis_parameters en,
                giis_parameters mc, giis_parameters mh, giis_parameters su
          WHERE ca.param_name = 'LINE_CODE_CA'
            AND mn.param_name = 'LINE_CODE_MN'
            AND fi.param_name = 'LINE_CODE_FI'
            AND ac.param_name = 'LINE_CODE_AC'
            AND av.param_name = 'LINE_CODE_AV'
            AND en.param_name = 'LINE_CODE_EN'
            AND mc.param_name = 'LINE_CODE_MC'
            AND mh.param_name = 'LINE_CODE_MH'
            AND su.param_name = 'LINE_CODE_SU';
     EXCEPTION
         WHEN NO_DATA_FOUND THEN
            v_line_ca := 'CA';
            v_line_mn := 'MN';
            v_line_fi := 'FI';
            v_line_ac := 'AC';
            v_line_av := 'AV';
            v_line_en := 'EN';
            v_line_mc := 'MC';
            v_line_mh := 'MH';
            v_line_su := 'SU';
     END;

     BEGIN
         SELECT a.param_value_v a, b.param_value_v b, c.param_value_v c,
                d.param_value_v d, e.param_value_v e, f.param_value_v f,
                g.param_value_v g, h.param_value_v h, i.param_value_v i,
                j.param_value_v j, k.param_value_v k, l.param_value_n l
           INTO v_subline_car, v_subline_ear, v_subline_mbi,
                v_subline_mlop, v_subline_dos, v_subline_bpv,
                v_subline_eei, v_subline_pcp, v_subline_op,
                v_subline_bbi, v_subline_mop, v_co_ri_cd
           FROM giis_parameters a,
                giis_parameters b,
                giis_parameters c,
                giis_parameters d,
                giis_parameters e,
                giis_parameters f,
                giis_parameters g,
                giis_parameters h,
                giis_parameters i,
                giis_parameters j,
                giis_parameters k,
                giis_parameters l
          WHERE a.param_name = 'CONTRACTOR_ALL_RISK'
            AND b.param_name = 'ERECTION_ALL_RISK'
            AND c.param_name = 'MACHINERY_BREAKDOWN_INSURANCE'
            AND d.param_name = 'MACHINERY_LOSS_OF_PROFIT'
            AND e.param_name = 'DETERIORATION_OF_STOCKS'
            AND f.param_name = 'BOILER_AND_PRESSURE_VESSEL'
            AND g.param_name = 'ELECTRONIC_EQUIPMENT'
            AND h.param_name = 'PRINCIPAL_CONTROL_POLICY'
            AND i.param_name = 'OPEN_POLICY'
            AND j.param_name = 'BANKERS BLANKET INSURANCE'
            AND k.param_name = 'SUBLINE_MN_MOP'
            AND l.param_name = 'CO_INSURER_DEFAULT';
     EXCEPTION
         WHEN NO_DATA_FOUND THEN
            v_subline_car := 'CAR';
            v_subline_ear := 'EAR';
            v_subline_mbi := 'MBI';
            v_subline_mlop := 'MLOP';
            v_subline_dos := 'DOS';
            v_subline_bpv := 'BPV';
            v_subline_eei := 'EEI';
            v_subline_pcp := 'PCP';
            v_subline_op := 'OP';
            v_subline_bbi := 'BBI';
            v_subline_mop := 'MOP';
--            v_co_ri_cd := '
            v_subline_oth := 'OTH';
     END;
    
    FOR rec IN (SELECT extract_id ,policy_id
                       ,line_cd || ' - ' || subline_cd || ' - ' || iss_cd || ' - ' || LTRIM(TO_CHAR(issue_yy, '09')) || ' - ' || TRIM(TO_CHAR(pol_seq_no, '099999'))
                                    || ' - ' || LTRIM(TO_CHAR(renew_no, '09')) policy_no
                       ,iss_cd ,line_cd ,subline_cd ,issue_yy ,pol_seq_no ,renew_no ,ref_pol_no
                       ,assd_no ,acct_of_cd ,address1 ,address2 ,address3
                       ,type_cd ,manual_renew_no ,risk_tag
                       ,TRUNC(incept_date) incept_date
                       ,incept_tag
                       ,TRUNC(expiry_date) expiry_date
                       ,expiry_tag
                       ,TRUNC(eff_date) eff_date
                       ,TRUNC(issue_date) issue_date
                       ,industry_cd ,region_cd
                       ,cred_branch
                       ,sum(prem_amt) prem_amt
                       ,sum(tsi_amt) tsi_amt
                       ,pack_pol_flag ,auto_renew_flag ,foreign_acc_sw
                       ,reg_policy_sw ,prem_warr_tag ,co_insurance_sw
                  FROM gixx_polbasic 
                 WHERE iss_cd       = p_iss_cd 
                   AND line_cd      = p_line_cd
                   AND subline_cd   = p_subline_cd
                   AND issue_yy     = p_issue_yy
                   AND pol_seq_no   = p_pol_seq_no
                   AND renew_no     = p_renew_no
                   --AND ref_pol_no   = NVL(p_ref_pol_no, ref_pol_no)
                   --AND rownum = 1
                 GROUP BY extract_id, policy_id, 
                       line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, 
                       assd_no, acct_of_cd, address1, address2, address3, 
                       ref_pol_no, type_cd, manual_renew_no, risk_tag, incept_date, incept_tag,
                       expiry_date, expiry_tag, eff_date, issue_date, industry_cd, region_cd,
                       cred_branch, pack_pol_flag, auto_renew_flag, foreign_acc_sw, reg_policy_sw,
                       prem_warr_tag, co_insurance_sw
                  )
    LOOP
        
        v_policy_id := nvl(rec.policy_id, -1);
    
        v_polbasic.extract_id   := rec.extract_id;
--        v_polbasic.policy_id    := rec.policy_id;
        v_polbasic.policy_no    := rec.policy_no;
        v_polbasic.iss_cd       := rec.iss_cd;
        v_polbasic.line_cd      := rec.line_cd;
        v_polbasic.subline_cd   := rec.subline_cd;
        v_polbasic.issue_yy     := rec.issue_yy;
        v_polbasic.pol_seq_no   := rec.pol_seq_no;
        v_polbasic.renew_no     := rec.renew_no;
        v_polbasic.assd_no      := rec.assd_no;
        v_polbasic.address1     := rec.address1;
        v_polbasic.address2     := rec.address2;
        v_polbasic.address3     := rec.address3;
        v_polbasic.ref_pol_no   := rec.ref_pol_no;
        v_polbasic.type_cd      := rec.type_cd;
        v_polbasic.manual_renew_no  := rec.manual_renew_no;
        v_polbasic.risk_tag     := rec.risk_tag;
        v_polbasic.incept_date  := TRUNC(rec.incept_date);
        v_polbasic.incept_tag   := rec.incept_tag;
        v_polbasic.expiry_date  := TRUNC(rec.expiry_date);
        v_polbasic.expiry_tag  := rec.expiry_tag;
        v_polbasic.eff_date     := TRUNC(rec.eff_date);
        v_polbasic.issue_date     := TRUNC(rec.issue_date);
        v_polbasic.industry_cd  := rec.industry_cd;
        v_polbasic.region_cd    := rec.region_cd;
        v_polbasic.cred_branch  := rec.cred_branch;
        v_polbasic.prem_amt     := rec.prem_amt;
        v_polbasic.tsi_amt      := rec.tsi_amt;
        v_polbasic.pack_pol_flag    := rec.pack_pol_flag;
        v_polbasic.auto_renew_flag  := rec.auto_renew_flag;
        v_polbasic.foreign_acc_sw   := rec.foreign_acc_sw;
        v_polbasic.reg_policy_sw    := rec.reg_policy_sw;
        v_polbasic.prem_warr_tag    := rec.prem_warr_tag;
        v_polbasic.co_insurance_sw  := rec.co_insurance_sw;
        v_polbasic.subline_cd_param := GIIS_PARAMETERS_PKG.GET_ENGG_SUBLINE_NAME(rec.subline_cd); --added by robert SR 20307 10.27.15    
        --------
        FOR ind IN (SELECT industry_nm
                      FROM giis_industry
                     WHERE industry_cd = rec.industry_cd)                                    
        LOOP
            v_polbasic.industry_nm := ind.industry_nm;
            EXIT;
        END LOOP;
        
        -- getting the dsp_type_desc
        FOR pol IN(SELECT type_desc
                     FROM giis_policy_type
                    WHERE line_cd = rec.line_cd
                      AND type_cd = rec.type_cd)
        LOOP
            v_polbasic.dsp_type_desc := pol.type_desc;
        END LOOP;
        
        -- getting the dsp_cred_branch
        FOR cred IN (SELECT iss_name
                       FROM giis_issource
                      WHERE iss_cd = rec.cred_branch)
        LOOP
            v_polbasic.dsp_cred_branch := cred.iss_name;
            EXIT;
        END LOOP;
        
        FOR reg IN ( SELECT region_desc
                       FROM giis_region
                      WHERE region_cd = rec.region_cd)
                                    
        LOOP
            v_polbasic.region_desc := reg.region_desc;
            EXIT;
        END LOOP;
        
        -- getting the drv_assd_no
        SELECT designation||' '||assd_name 
          INTO v_polbasic.drv_assd_no
          FROM giis_assured
         WHERE assd_no = rec.assd_no;   
        
        --to summarize risk_tag in GIPI_POLBASIC
        FOR sum_risk IN (SELECT risk_tag
                         FROM gipi_polbasic
                        WHERE line_cd    = rec.line_cd
                          AND subline_cd = rec.subline_cd
                          AND iss_cd     = rec.iss_cd
                          AND issue_yy   = rec.issue_yy
                          AND pol_seq_no = rec.pol_seq_no
                          AND renew_no   = rec.renew_no
                        ORDER BY eff_date DESC, endt_seq_no DESC)
        LOOP
            --populate nbt_risk_tag
            FOR nbt IN (SELECT rv_meaning
                          FROM cg_ref_codes
                         WHERE rv_domain    = 'GIPI_POLBASIC.RISK_TAG'
                           AND rv_low_value = sum_risk.risk_tag)
            LOOP
                v_polbasic.nbt_risk_tag := nbt.rv_meaning;
                EXIT;
            END LOOP;
            
            v_polbasic.risk_tag     := sum_risk.risk_tag; 
            EXIT;
        END LOOP;
        
        FOR C IN (SELECT assd_name
                    FROM giis_assured
                   WHERE assd_no = rec.acct_of_cd) 
        LOOP
             v_polbasic.drv_acct_of := c.assd_name;
        END LOOP;
        
        FOR pol IN(SELECT DECODE(label_tag,'Y','Leased to   :','In Account of  :') label_tag,
                          policy_id -- kris: 02.19.2013
                     FROM gipi_polbasic
                    WHERE line_cd    = rec.line_cd
                      AND subline_cd = rec.subline_cd
                      AND iss_cd     = rec.iss_cd
                      AND issue_yy   = rec.issue_yy
                      AND pol_seq_no = rec.pol_seq_no
                      AND renew_no   = rec.renew_no
                    ORDER BY endt_seq_no DESC)
       LOOP
              v_polbasic.dsp_label_tag := pol.label_tag;
            --v_polbasic.policy_id := pol.policy_id;
            --v_policy_id := pol.policy_id;
              EXIT;
       END LOOP;
       
--       IF rec.policy_id IS NOT NULL THEN
--            v_polbasic.policy_id := rec.policy_id;
--       END IF;
       
       IF v_policy_id > -1 THEN
            v_polbasic.policy_id := v_policy_id;
       ELSE
            SELECT policy_id
              INTO v_polbasic.policy_id
              FROM gipi_polbasic 
             WHERE iss_cd       = p_iss_cd 
               AND line_cd      = p_line_cd
               AND subline_cd   = p_subline_cd
               AND issue_yy     = p_issue_yy
               AND pol_seq_no   = NVL(p_pol_seq_no, POL_SEQ_NO) --:p_pol_seq_no --
               AND renew_no     = NVL(p_renew_no, RENEW_NO) --:p_renew_no --
               AND (ref_pol_no  = NVL(p_ref_pol_no, ref_pol_no) OR REF_POL_NO IS NULL)
               AND rownum = 1;
       END IF; 
       
       -- checks if line=marine
      /* IF rec.pack_pol_flag = 'Y' THEN
           FOR x IN (SELECT pack_line_cd
                       FROM gipi_item
                      WHERE policy_id = rec.policy_id)
            LOOP
               v_line_cd := x.pack_line_cd;
            END LOOP;
       ELSE
         v_line_cd  := rec.line_cd;
       END IF;
       
       SELECT menu_line_cd
         INTO v_menu_line_cd
         FROM giis_line
        WHERE line_cd = NVL(v_line_cd, rec.line_cd);

       FOR C IN (SELECT menu_line_cd
                   FROM GIIS_LINE
                  WHERE line_cd = v_line_cd)
       LOOP
            IF c.menu_line_cd IS NOT NULL THEN
               v_menu_line_cd := c.menu_line_cd;
            END IF;
            EXIT;
       END LOOP;    
       
       IF v_line_cd = v_line_mn OR v_menu_line_cd = 'MN' THEN
          v_polbasic.line_type := 'marine';       
       ELSE                                                         
          v_polbasic.line_type := NULL;     
       END IF; */-- from gipi_polbasic_pkg
       
       -- from when-new-block-instance
       IF rec.pack_pol_flag = 'Y' THEN
            FOR x IN (SELECT pack_line_cd
                        FROM gixx_item
                       WHERE extract_id = rec.extract_id)
            LOOP
               v_line_cd := x.pack_line_cd;
            END LOOP;
       ELSE
            v_line_cd := rec.line_cd;
       END IF;
       
       FOR c IN (SELECT menu_line_cd
                   FROM giis_line
                  WHERE line_cd = v_line_cd)
       LOOP
            IF c.menu_line_cd IS NOT NULL THEN
                v_menu_line_cd := c.menu_line_cd;            
            END IF;
            EXIT;
       END LOOP;
       
       IF v_line_cd = v_line_mn OR v_menu_line_cd = 'MN' THEN
            v_polbasic.line_type := 'marine';
       /*ELSE
            v_polbasic.line_type := '';*/
       END IF;
       ---- end: from when-new-block-instance
       
       -- gets the policyIdType
       BEGIN 
            SELECT 'exists in gipi_polnrep'
              INTO v_exist_or_not
              FROM (SELECT DISTINCT policy_id
                               FROM gipi_polbasic
                              WHERE policy_id IN (
                                                 SELECT DISTINCT old_policy_id
                                                            FROM gipi_polnrep)
                                 OR policy_id IN (
                                                 SELECT DISTINCT new_policy_id
                                                            FROM gipi_polnrep))
             WHERE policy_id = v_polbasic.policy_id;
       EXCEPTION
            WHEN NO_DATA_FOUND THEN
               v_exist_or_not := NULL;
       END;

       IF v_exist_or_not = 'exists in gipi_polnrep' THEN
            FOR a IN (SELECT 1
                        FROM gipi_polnrep
                       WHERE old_policy_id = v_polbasic.policy_id)
            LOOP
               v_polbasic.policy_id_type := 'old';
               EXIT;
            END LOOP;

            FOR b IN (SELECT 1
                        FROM gipi_polnrep
                       WHERE new_policy_id = v_polbasic.policy_id)
            LOOP
               v_polbasic.policy_id_type := 'new';
               EXIT;
            END LOOP;
       ELSE
            v_polbasic.policy_id_type := NULL;
       END IF;
       
       SELECT giacp.v ('DEFAULT_CURRENCY')
         INTO v_polbasic.default_currency
         FROM DUAL;
           
       FOR c1 IN (SELECT 1
                FROM gipi_item
               WHERE policy_id = v_polbasic.policy_id
                 AND currency_cd <> GIACP.N('CURRENCY_CD'))
       LOOP
         v_polbasic.is_foreign_currency := 'Y';
         EXIT;
       END LOOP;     
       
       BEGIN
            SELECT contract_proj_buss_title,
                   site_location,
                   construct_start_date,
                   construct_end_date,
                   maintain_start_date,
                   maintain_end_date,
                   mbi_policy_no,
                   weeks_test,
                   time_excess
              INTO v_polbasic.contract_proj_buss_title,
                   v_polbasic.site_location,
                   v_polbasic.construct_start_date,
                   v_polbasic.construct_end_date,
                   v_polbasic.maintain_start_date,
                   v_polbasic.maintain_end_date,
                   v_polbasic.mbi_policy_no, 
                   v_polbasic.weeks_test,
                   v_polbasic.time_excess
              FROM gixx_engg_basic
             WHERE extract_id = rec.extract_id;
             
       EXCEPTION
            WHEN NO_DATA_FOUND THEN
               v_polbasic.contract_proj_buss_title := NULL;
               v_polbasic.site_location := NULL;
               v_polbasic.construct_start_date := NULL;
               v_polbasic.construct_end_date := NULL;
               v_polbasic.maintain_start_date := NULL;
               v_polbasic.maintain_end_date := NULL;
               v_polbasic.mbi_policy_no := NULL;
               v_polbasic.weeks_test := NULL;
               v_polbasic.time_excess := NULL;
       END;
       
       IF rec.subline_cd = v_subline_car THEN
            v_polbasic.prompt_title := 'Title of Contract';
            v_polbasic.prompt_location := 'Contract Site Location';
       ELSIF rec.subline_cd = v_subline_ear THEN
            v_polbasic.prompt_title := 'Project';
            v_polbasic.prompt_location := 'Site of Erection';
       ELSIF rec.subline_cd = v_subline_eei THEN
            v_polbasic.prompt_title := 'Description';
            v_polbasic.prompt_location := 'The Premises';
       ELSIF rec.subline_cd = v_subline_mbi THEN
            v_polbasic.prompt_title := 'Nature of Business';
            v_polbasic.prompt_location := 'Work Site';
       ELSIF rec.subline_cd = v_subline_mlop THEN
            v_polbasic.prompt_title := 'Nature of Business';
            v_polbasic.prompt_location := 'The Premises';
       ELSIF rec.subline_cd = v_subline_dos THEN
            v_polbasic.prompt_title := 'Description';
            v_polbasic.prompt_location := 'Location of Refrigeration Plant';
       ELSIF rec.subline_cd = v_subline_bpv THEN
            v_polbasic.prompt_title := 'Description';
            v_polbasic.prompt_location := 'The Premises';
       ELSIF rec.subline_cd = v_subline_pcp THEN
            v_polbasic.prompt_title := 'Description';
            v_polbasic.prompt_location := 'Territorial Limits';
       ELSE
            v_polbasic.prompt_title := 'Title';
            v_polbasic.prompt_location := 'Location';
       END IF;
       
       FOR rate IN (SELECT co_ri_shr_pct
                      FROM gixx_co_insurer
                     WHERE extract_id   = v_polbasic.extract_id
                       AND co_ri_cd     = v_co_ri_cd)
       LOOP
            v_rate := TO_CHAR(rate.co_ri_shr_pct,'FM990.999999999');
       END LOOP;
       
       IF substr(v_rate,NVL(length(v_rate), 0)) = '.' THEN
            v_polbasic.dsp_rate := '('||substr(v_rate,1,NVL(length(v_rate), 0)-1)||'%)';
       ELSE
            v_polbasic.dsp_rate := '('||v_rate||'%)';
       END IF; 
       
       -- Determine_subline_open program unit
       BEGIN
            FOR c IN (SELECT open_policy_sw
                        FROM giis_subline
                       WHERE line_cd = p_line_cd
                         AND subline_cd = p_subline_cd)
            LOOP
                IF c.open_policy_sw = 'Y' THEN
                    v_polbasic.variables_subline_open := p_subline_cd;
                ELSE
                    v_polbasic.variables_subline_open := NULL;
                END IF;
            END LOOP;
            
            FOR c IN (SELECT op_flag
                        FROM giis_subline
                       WHERE line_cd = p_line_cd
                         AND subline_cd = p_subline_cd)
            LOOP
                IF c.op_flag = 'Y' THEN
                    v_polbasic.variables_subline_mop := p_subline_cd;
                ELSE
                    v_polbasic.variables_subline_mop := NULL;
                END IF;
            END LOOP;
            -- end of procedure determine_subline_open program unit
            
            -- for marine details
            FOR marine_dtls IN (SELECT survey_agent_cd, settling_agent_cd
                                  FROM gixx_polbasic
                                 WHERE extract_id = rec.extract_id)
            LOOP
                v_polbasic.survey_agent_cd := marine_dtls.survey_agent_cd;
                v_polbasic.settling_agent_cd := marine_dtls.settling_agent_cd;
                
                FOR dtl IN (SELECT payee_no,
                                   DECODE(payee_first_name, NULL, NULL, payee_first_name || ' ') ||
                                   DECODE(payee_middle_name, NULL, NULL, payee_middle_name || ' ') ||
                                   payee_last_name name
                              FROM giis_payees
                             WHERE payee_no = marine_dtls.survey_agent_cd
                               AND payee_class_cd IN (SELECT param_value_v
                                                        FROM giis_parameters
                                                       WHERE param_name = 'SURVEY_PAYEE_CLASS'))
                LOOP
                    v_polbasic.survey_agent := dtl.name;
                    EXIT;
                END LOOP;
                
                FOR dtl IN (SELECT payee_no,
                                   DECODE(payee_first_name, NULL, NULL, payee_first_name) || ' ' ||
                                   DECODE(payee_middle_name, NULL, NULL, payee_middle_name) || ' ' ||
                                   payee_last_name name
                              FROM giis_payees
                             WHERE payee_no = marine_dtls.settling_agent_cd
                               AND payee_class_cd IN (SELECT param_value_v
                                                        FROM giis_parameters
                                                       WHERE param_name = 'SETTLING_PAYEE_CLASS'))
                LOOP
                    v_polbasic.settling_agent := dtl.name;
                    EXIT;
                END LOOP;
                
            END LOOP;
            
            -- from X010.bank (when-button-pressed trigger)
            -- to determine the value of bank button
            IF rec.line_cd = v_line_ca AND rec.subline_cd = v_subline_bbi THEN
                v_polbasic.bank_btn_label := 'Bank Collection';
            ELSIF rec.line_cd = v_line_mn THEN
                v_polbasic.bank_btn_label := 'Carrier Information';
            ELSE
                v_polbasic.bank_btn_label := '';
            END IF;
            -- end
            
            
            IF v_polbasic.line_cd = v_line_en THEN -- to determine properties for Additional information button
                v_polbasic.line_type := 'engine';
            ELSIF v_polbasic.line_cd = v_line_fi THEN  -- added for open policy button label
                v_polbasic.line_type := 'fire';
            ELSIF v_polbasic.line_cd = v_line_mn THEN  -- added for open policy button label
                v_polbasic.line_type := 'marine';
            END IF;
            
       END;
       
        
       PIPE ROW(v_polbasic);
    END LOOP;
    
  END get_policy_summary;
   
   /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  February 20, 2013
  ** Reference by:  GIPIS101 - Policy Information (Summary)
  ** Description:   Retrieves info for GIPIS101 for line = SU
  */
  FUNCTION get_policy_summary_su(
    --p_extract_id        gixx_polbasic.extract_id%TYPE
    p_iss_cd        GIXX_POLBASIC.iss_cd%TYPE,
    p_line_cd       GIXX_POLBASIC.line_cd%TYPE,
    p_subline_cd    GIXX_POLBASIC.subline_cd%TYPE,
    p_issue_yy      GIXX_POLBASIC.issue_yy%TYPE,
    p_pol_seq_no    GIXX_POLBASIC.pol_seq_no%TYPE,
    p_renew_no      GIXX_POLBASIC.renew_no%TYPE,
    p_ref_pol_no    GIXX_POLBASIC.ref_pol_no%TYPE
  ) RETURN gixx_polbasic_su_tab PIPELINED
  IS
    v_policy_su        gixx_polbasic_su_type;
    v_policy_id        gipi_polbasic.policy_id%TYPE;
  BEGIN
    FOR rec IN (SELECT a.extract_id, a.policy_id,
                       a.pol_flag, a.auto_renew_flag, a.reg_policy_sw,
                       a.issue_date, a.incept_date, a.expiry_date, a.eff_date,
                       a.incept_tag, a.expiry_tag,
                       a.address1, a.address2, a.address3,
                       a.ref_pol_no, a.mortg_name, 
                       a.subline_cd, a.line_cd,
                       a.booking_year, a.booking_mth,
                       a.industry_cd, a.region_cd
--                       d.val_period, d.val_period_unit       
                  FROM gixx_polbasic a
--                       gixx_bond_basic d
                 WHERE line_cd = p_line_cd
                   AND subline_cd = p_subline_cd
                   AND iss_cd = p_iss_cd
                   AND issue_yy = p_issue_yy          
                   AND pol_seq_no = p_pol_seq_no  
                   AND renew_no = p_renew_no
                   AND (ref_pol_no = NVL(p_ref_pol_no, ref_pol_no) 
                            OR ref_pol_no IS NULL)
                   --AND a.extract_id = p_extract_id
--                   AND a.industry_cd = B.INDUSTRY_CD
--                   AND a.region_cd = C.REGION_CD
--                   AND a.extract_id = d.extract_id
                   --AND rownum = 1
--                 ORDER BY extract_id ASC 
                 )
    LOOP
        v_policy_id := nvl(rec.policy_id, -1);
        
        v_policy_su.extract_id := rec.extract_id;
        --v_policy_su.policy_id := rec.policy_id;
        v_policy_su.pol_flag := rec.pol_flag;
        v_policy_su.auto_renew_flag := rec.auto_renew_flag;
        v_policy_su.reg_policy_sw := rec.reg_policy_sw;
        v_policy_su.issue_date := TRUNC(rec.issue_date);
        v_policy_su.incept_date := TRUNC(rec.incept_date);
        v_policy_su.expiry_date := TRUNC(rec.expiry_date); 
        v_policy_su.eff_date := TRUNC(rec.eff_date); 
        v_policy_su.incept_tag := rec.incept_tag;
        v_policy_su.address1 := rec.address1; 
        v_policy_su.address2 := rec.address2; 
        v_policy_su.address3 := rec.address3;
        v_policy_su.ref_pol_no := rec.ref_pol_no; 
        v_policy_su.mortg_name := rec.mortg_name;
        v_policy_su.line_cd := rec.line_cd; 
        v_policy_su.subline_Cd := rec.subline_Cd;
--        v_policy_su.booking_year := rec.booking_year; 
--        v_policy_su.booking_mth := rec.booking_mth;
        
        IF v_policy_id IS NOT NULL THEN
            v_policy_su.policy_id := v_policy_id;
        END IF;
        
        IF v_policy_id > -1 THEN
            v_policy_su.policy_id := v_policy_id;
        ELSE
            SELECT policy_id
              INTO v_policy_su.policy_id
              FROM gipi_polbasic 
             WHERE iss_cd       = p_iss_cd 
               AND line_cd      = p_line_cd
               AND subline_cd   = p_subline_cd
               AND issue_yy     = p_issue_yy
               AND pol_seq_no   = NVL(p_pol_seq_no, POL_SEQ_NO) --:p_pol_seq_no --
               AND renew_no     = NVL(p_renew_no, RENEW_NO) --:p_renew_no --
               AND (ref_pol_no  = NVL(p_ref_pol_no, ref_pol_no) OR REF_POL_NO IS NULL)
               AND rownum = 1;
        END IF; 
        
        FOR b IN (SELECT industry_nm
                    FROM giis_industry
                   WHERE industry_cd = rec.industry_cd)
        LOOP
            v_policy_su.industry_nm := b.industry_nm;
        END LOOP;
        
        FOR c IN (SELECT region_desc
                    FROM giis_region
                   WHERE region_cd = rec.region_cd)
        LOOP
            v_policy_su.region_desc := c.region_desc;
        
        END LOOP;
        
        FOR d IN (SELECT val_period, val_period_unit
                    FROM gixx_bond_basic
                   WHERE extract_id = rec.extract_id)
        LOOP
            v_policy_su.val_period      := d.val_period; 
            v_policy_su.val_period_unit := nvl(d.val_period_unit, 'D');
        END LOOP;
        
        FOR e in (SELECT rv_meaning pol_flag_desc
                  FROM cg_ref_codes
                  WHERE rv_low_value = rec.pol_flag
                  AND rv_domain LIKE '%GIPI_POLBASIC.POL_FLAG%')
        LOOP
            v_policy_su.pol_flag_desc := e.pol_flag_desc;
        END LOOP;
        
        PIPE ROW(v_policy_su);
    END LOOP;
  
  END get_policy_summary_su;

END GIXX_POLBASIC_PKG; 
/

