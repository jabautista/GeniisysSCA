CREATE OR REPLACE PACKAGE BODY CPI.GIRIR001C_PKG
AS

    /** Created By:     Shan Bati
     ** Date Created:   05.09.2013
     ** Referenced By:  GIRIR001C 
     **/
     
    FUNCTION CF_FIRST_PARAGRAPH(
        p_policy_id     gipi_polbasic.POLICY_ID%type,
        p_par_id        gipi_parlist.PAR_ID%type,
        p_endt_seq_no   GIPI_POLBASIC.ENDT_SEQ_NO%type
    ) RETURN VARCHAR2
    AS
        status_v	VARCHAR2(15);
        object_v	VARCHAR2(12);
        object_v2	VARCHAR2(12);
        v_pol_flag    VARCHAR2(1);
        v_par_type    VARCHAR2(1);
    BEGIN
        BEGIN
            SELECT pol_flag
              INTO v_pol_flag
              FROM gipi_polbasic
             WHERE policy_id = p_policy_id;
             
            SELECT par_type
              INTO v_par_type
              FROM gipi_parlist
             WHERE par_id = p_par_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN NULL;
        END;
        
        IF (v_pol_flag = '1') OR (v_pol_flag = '2') OR (v_pol_flag = '3') OR (v_pol_flag = '5')    THEN
            IF P_ENDT_SEQ_NO  >0 THEN
                status_v := 'endorse';
            elsIF P_ENDT_SEQ_NO = 0 THEN
                status_v := 'issue';
            end if;
        ELSIF (v_pol_flag = '4') THEN
            status_v := 'cancel';
         END IF;
         
        --SRW.MESSAGE(1,v_pol_flag);
        IF (v_par_type = 'P') THEN
            object_v := 'Policy';
        ELSIF (v_par_type = 'E') THEN
            object_v := 'Policy';
        END IF; 
        
        IF (v_pol_flag = '2') THEN
            object_v2 := 'renewal,';
        ELSE
            IF (v_par_type = 'P') THEN
                object_v2 := 'POLICY,';
            ELSIF (v_par_type = 'E') THEN
                object_v2 := 'ENDORSEMENT,';
            END IF; 
        END IF;
        
        RETURN ('Kindly ' || status_v || ' your Reinsurance ' || object_v || ' in accordance with our '
                || object_v2 || ' copy(ies) of which is(are) attached herewith.'); 
     
    END CF_FIRST_PARAGRAPH;
     
     
    FUNCTION CF_MOP_NUMBER(
        p_policy_id     gipi_polbasic.POLICY_ID%TYPE
    ) RETURN VARCHAR2
    AS
        MOP		VARCHAR2(27);
    BEGIN
        BEGIN
            SELECT   T1.line_cd || '-' || ltrim(op_subline_cd) || '-' || ltrim(op_iss_cd) || '-' || ltrim(to_char(op_issue_yy,'09'))
                        || '-' || ltrim(to_char(op_pol_seqno,'0999999'))
              INTO  mop
              FROM  gipi_open_policy T1, gipi_polbasic T2
             WHERE  T2.policy_id = p_policy_id
               AND  T1.policy_id = T2.policy_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN NULL;
        END;
        RETURN (MOP);
    END CF_MOP_NUMBER;
     
     
    FUNCTION CF_ASSD_NAME(
        p_assd_no   GIIS_ASSURED.ASSD_NO%TYPE
    ) RETURN VARCHAR2
    AS
        v_assd_name  giis_assured.assd_name%type;
    BEGIN   
        FOR C IN (SELECT ASSD_NAME ASSD_NAME
                    FROM GIIS_ASSURED
                   WHERE ASSD_NO = P_ASSD_NO) 
        LOOP
            v_assd_name := C.ASSD_NAME;
        END LOOP;
        
        RETURN(v_assd_name); 
    END CF_ASSD_NAME;
     
    
    FUNCTION CF_PROPERTY(
        p_policy_id     GIPI_INVOICE.POLICY_ID%TYPE,
        p_dist_no       GIUW_POLICYDS.DIST_NO%TYPE,
        p_dist_seq_no   GIUW_ITEMDS.DIST_SEQ_NO%TYPE,
        p_line_cd       GIPI_POLBASIC.LINE_CD%type,
        p_subline_cd    GIPI_POLBASIC.SUBLINE_CD%type
    ) RETURN VARCHAR2
    AS
        V_DIST_SEQ_NO   NUMBER(5);
        V_SEQ_COUNT		NUMBER(2) := 0;
        V_ITEM_COUNT    NUMBER(2) := 0;
        V_PROPERTY	    VARCHAR2(100);
    BEGIN
        IF p_line_cd = 'CA' and p_subline_cd = 'MSP' THEN
 	        v_property := 'MSPR';
        ELSE  	
            SELECT COUNT(DIST_SEQ_NO)
              INTO V_SEQ_COUNT
              FROM GIUW_POLICYDS
             WHERE DIST_NO = P_DIST_NO;

            --  srw.message(1000,to_char(v_seq_count)||'  v_seq_count');
             IF V_SEQ_COUNT = 1 THEN
                FOR A IN (SELECT PROPERTY
                            FROM GIPI_INVOICE
                           WHERE POLICY_ID = P_POLICY_ID) 
                LOOP
                      V_PROPERTY := A.PROPERTY;
                END LOOP;

             -- srw.message(1000,v_property||'  property');   
             ELSE
                SELECT COUNT(ITEM_NO)
                  INTO V_ITEM_COUNT
                  FROM GIUW_ITEMDS
                 WHERE DIST_NO =P_DIST_NO
                   AND DIST_SEQ_NO = P_DIST_SEQ_NO;

                --  srw.message(1000,to_char(v_item_count)||'  item count');     	   
                IF V_ITEM_COUNT = 1 THEN
                    FOR C IN (SELECT item_no                       --added by bdarusin, 12222003
                                FROM giuw_itemds                   --added for loop c to correct property name displayed
                               WHERE dist_no = p_dist_no             --just enclosed for loop b in for loop c
                                 AND dist_seq_no = p_dist_seq_no)
                    LOOP
                        FOR B IN (SELECT ITEM_TITLE
                                    FROM GIPI_ITEM
                                   WHERE POLICY_ID = P_POLICY_ID
                                     AND item_no = c.item_no)
                        LOOP
                            V_PROPERTY := B.ITEM_TITLE;
                            EXIT;
                        END LOOP; --for loop b
                    END LOOP;   --for loop c
                ELSE
                    V_PROPERTY := 'Various Items';           	
                END IF;
             END IF;
        END IF;
        
        RETURN (V_PROPERTY);
    END CF_PROPERTY;
     
     
    FUNCTION CF_COMP_NM
        RETURN VARCHAR2
    AS
        m_company_nm		giis_parameters.param_value_v%TYPE;
    BEGIN
        FOR name_rec IN ( SELECT param_value_v
	                        FROM giis_parameters
                           WHERE param_name = 'COMPANY_NAME')
        LOOP
            m_company_nm := name_rec.param_value_v;
            EXIT;
        END LOOP;
        RETURN (m_company_nm);
    END CF_COMP_NM;
    
    
    FUNCTION PARAM_BOOL(
        p_type      VARCHAR2
    ) RETURN VARCHAR2
    AS
        v_master varchar2(1);
    BEGIN
        FOR a IN (select UPPER(text) text
	  				from giis_document
   				   where report_id = 'GIRIR001'
     				 and title = p_type)
        LOOP
     	    v_master := a.text;
        END LOOP;
  
        if v_master = 'Y' then
  	        return ('Y');   -- return (TRUE);
        else
  	        return ('N');   --  return (FALSE);
        end if;
    END PARAM_BOOL;
    
    
    FUNCTION PARAM_CHAR(
        p_type      VARCHAR2,
        p_arg1      VARCHAR2
    ) RETURN VARCHAR2
    AS
        V_MASTER  VARCHAR2(2000);
    BEGIN
        BEGIN 
            select decode(p_type, 'HEADING', text)
              into v_master
              from giis_document
             where title = p_arg1
               and report_id = 'GIRIR001';
        EXCEPTION
   	        when no_data_found then
   	            v_master := 'NO HEADING';
        END;
        RETURN (v_master);
    END PARAM_CHAR;   
    
    
    FUNCTION get_report_details(
        p_line_cd           GIRI_BINDER.LINE_CD%type,
        p_binder_yy         GIRI_BINDER.BINDER_YY%type,
        p_binder_seq_no     GIRI_BINDER.BINDER_SEQ_NO%type
    ) RETURN report_details_tab PIPELINED
    AS
        rep                 report_details_type;
	    v_date		        VARCHAR2(12);
        V_VAT               VARCHAR2(1);
        v_t_lcomm_amt       NUMBER(16,2) := 0;
        cp_lcomm_vat        NUMBER(16,2) := 0;
        cp_wholding_vat     NUMBER(16,2) := 0;
        v_text              giis_document.TEXT%type;
    BEGIN   
        rep.cf_comp_nm      := CF_COMP_NM;
        
        FOR i IN (SELECT DISTINCT UPPER(A150.LINE_NAME) LINE_NAME
                       ,'FACULTATIVE REINSURANCE BINDER NUMBER ' || D0107.LINE_CD || '-' || LTRIM(TO_CHAR(D0107.BINDER_YY,'09')) || '-'  
                                || LTRIM(TO_CHAR(D0107.BINDER_SEQ_NO,'09999')) BINDER_NO
                       ,'FACULTATIVE REINSURANCE ALTERATION BINDER NUMBER ' || D0107.LINE_CD || '-' || LTRIM(TO_CHAR(D0107.BINDER_YY,'09')) 
                                || '-'  || LTRIM(TO_CHAR(D0107.BINDER_SEQ_NO,'09999')) BINDER_NUMBER
                       ,LTRIM(TO_CHAR((D0107.RI_TSI_AMT*  D06010.CURRENCY_RT),'99,999,999,999,990.99')) || '  (' 
                                || LTRIM(TO_CHAR(D0107.RI_SHR_PCT,'990.9999')) || '%)' YOUR_SHARE
                       ,NVL(D0107.PREM_TAX,0) PREM_TAX4
                       ,D0107.BINDER_DATE BINDER_DATE5
                       ,A18011.RI_NAME RI_NAME
                       ,A18011.BILL_ADDRESS1 BILL_ADDRESS11
                       ,A18011.BILL_ADDRESS2 BILL_ADDRESS22
                       ,A18011.BILL_ADDRESS3 BILL_ADDRESS33
                       ,NVL(NVL(D0107.ATTENTION, A18011.ATTENTION),'REINSURANCE DEPARTMENT') ATTENTION
                       ,DECODE(B240.PAR_TYPE,'E',B240.ASSD_NO,B2504.ASSD_NO) ASSD_NO
                       ,B2504.LINE_CD || '-' || B2504.SUBLINE_CD || '-' || B2504.ISS_CD || '-' ||  LTRIM(TO_CHAR(B2504.ISSUE_YY,'09'))
                                || '-' || LTRIM(TO_CHAR(B2504.POL_SEQ_NO,'0999999'))|| '-' || LTRIM(TO_CHAR(b2504.RENEW_NO,'09'))  POLICY_NO
                       ,D06010.LOC_VOY_UNIT
                       ,B2504.ENDT_ISS_CD || '-' || LTRIM(TO_CHAR(B2504.ENDT_YY,'09')) || '-' || LTRIM(TO_CHAR(B2504.ENDT_SEQ_NO,'099999')) ENDT_NO
                       ,DECODE(B2504.INCEPT_TAG, 'Y', 'TBA', TO_CHAR(D0107.EFF_DATE, 'Mon. DD, YYYY')) || ' to '  ||
                            DECODE(B2504.EXPIRY_TAG, 'Y', 'TBA', NVL(TO_CHAR(B2504.ENDT_EXPIRY_DATE, 'Mon. DD, YYYY'),TO_CHAR(D0107.EXPIRY_DATE, 'Mon. DD, YYYY'))) RI_TERM
                       ,'PHP  ' || LTRIM(TO_CHAR((D06010.TSI_AMT*  D06010.CURRENCY_RT),'99,999,999,999,990.99')) SUM_INSURED
                       ,B2504.ENDT_SEQ_NO ENDT_SEQ_NO2
                       ,D0107.CONFIRM_NO
                       ,D0107.CONFIRM_DATE
                       ,LTRIM(TO_CHAR(D06010.DIST_NO,'09999999')) || '-' || LTRIM(TO_CHAR(D06010.DIST_SEQ_NO,'09999')) DS_NO
                       ,D06010.DIST_NO DIST_NO
                       ,D06010.DIST_SEQ_NO DIST_SEQ_NO
                       ,LTRIM(TO_CHAR(D06010.FRPS_YY,'09')) || '-' || LTRIM(TO_CHAR(D06010.FRPS_SEQ_NO,'099999')) || '/' || LTRIM(TO_CHAR(D06010.OP_GROUP_NO,'099999')) FRPS_NO
                       ,D0809.BNDR_REMARKS1
                       ,D0809.BNDR_REMARKS2
                       ,D0809.BNDR_REMARKS3
                       ,D0107.FNL_BINDER_ID FNL_BINDER_ID2
                       ,B2504.POLICY_ID
                       ,B2504.PAR_ID
                       ,ENDT_SEQ_NO
                       ,ENDT_YY
                       ,ENDT_ISS_CD
                       ,SUBLINE_CD
                       ,B2504.LINE_CD
                       ,D0809.LINE_CD LINE_CD1
                       ,D0809.FRPS_YY
                       ,D0809.FRPS_SEQ_NO
                       ,D0809.REVERSE_SW
                       ,D0107.REVERSE_DATE
                       ,NVL((D0809.OTHER_CHARGES* D06010.CURRENCY_RT),0)   OTHER_CHARGES
                       ,'* '||B2504.USER_ID||' *' USER_ID
                       ,D06010.CURRENCY_RT
                  FROM GIRI_BINDER D0107
                       ,GIIS_REINSURER A18011
                       ,GIIS_LINE A150
                       ,GIRI_FRPS_RI D0809
                       ,GIRI_DISTFRPS D06010
                       ,GIUW_POL_DIST C0803
                       ,GIPI_POLBASIC B2504
                       ,GIIS_CURRENCY C100
                       ,GIPI_PARLIST B240
                 WHERE B240.PAR_ID = B2504.PAR_ID
                   AND A18011.RI_CD = D0107.RI_CD
                   AND D0107.LINE_CD = A150.LINE_CD
                   AND D06010.FRPS_SEQ_NO = D0809.FRPS_SEQ_NO
                   AND C0803.DIST_NO = D06010.DIST_NO
                   AND B2504.POLICY_ID = C0803.POLICY_ID
                   AND D06010.CURRENCY_CD = C100.MAIN_CURRENCY_CD
                   AND D06010.LINE_CD = D0809.LINE_CD
                   AND D06010.FRPS_YY = D0809.FRPS_YY
                   AND D0107.FNL_BINDER_ID = D0809.FNL_BINDER_ID
                   AND D06010.RI_FLAG != 4
                   --AND D06010.RI_FLAG IN (1,2)
                   --AND DECODE(D0107.REVERSE_DATE,NULL,2 ,D06010.RI_FLAG)= D06010.RI_FLAG
                   AND D0107.LINE_CD = UPPER(P_LINE_CD)
                   AND D0107.BINDER_YY = TO_NUMBER(P_BINDER_YY)
                   AND D0107.BINDER_SEQ_NO = TO_NUMBER(P_BINDER_SEQ_NO) )
        LOOP
            rep.line_name               := i.line_name;
            rep.print_line_name         := PARAM_BOOL('PRINT_LINE_NAME');
            rep.binder_no               := i.binder_no;
            rep.binder_number           := i.binder_number;
            
            --F_BINDER_NO format trigger
            IF i.ENDT_SEQ_NO2 = 0 THEN
  	            rep.print_binder_no := 'Y';
            ELSE
  	            rep.print_binder_no := 'N';
            END IF;
            
            
            -- F_BINDER_NO1 format trigger
            FOR C IN(SELECT reverse_date
					   FROM giri_BINDER
					  WHERE FNL_BINDER_ID = i.FNL_BINDER_ID2)
            LOOP						
			    V_DATE := C.REVERSE_DATE;
				EXIT;
			END LOOP;
            
            IF V_DATE is null THEN
			    V_VAT := 'N';
            ELSE
				V_VAT := 'Y';
            END IF;		
            			
            IF i.ENDT_SEQ_NO2 > 0 OR V_VAT='Y' THEN  	
  	            rep.print_binder_number := 'Y';
            ELSE
  	            rep.print_binder_number := 'N';
            END IF;
            
            rep.your_share                  := i.your_share;
            rep.prem_tax                    := i.prem_tax4;
            rep.binder_date                 := i.binder_date5;
            rep.cf_addressee                := PARAM_CHAR('HEADING', 'ADDRESSEE');
            rep.cf_addressee_confirmation   := PARAM_CHAR('HEADING', 'ADDRESSEE_CONFIRMATION');
            rep.ri_name                     := i.ri_name;
            rep.bill_address1               := i.bill_address11;
            rep.bill_address2               := i.bill_address22;
            rep.bill_address3               := i.bill_address33;
            rep.attention                   := i.attention;
            rep.cf_first_paragraph          := CF_FIRST_PARAGRAPH(i.policy_id, i.par_id, i.endt_seq_no);
            rep.assd_no                     := i.assd_no;
            rep.cf_assd_name                := CF_ASSD_NAME(i.assd_no);
            rep.policy_no                   := i.policy_no;
            rep.loc_voy_unit                := i.loc_voy_unit;
            rep.endt_no                     := i.endt_no;
            rep.ri_term                     := i.ri_term;
            rep.sum_insured                 := i.sum_insured;
            rep.endt_seq_no2                := i.endt_seq_no2;
            rep.confirm_no                  := i.confirm_no;
            rep.confirm_date                := i.confirm_date;
            rep.ds_no                       := i.ds_no;
            rep.dist_no                     := i.dist_no;
            rep.dist_seq_no                 := i.dist_seq_no;
            rep.frps_no                     := i.frps_no;
            rep.cf_mop_number               := CF_MOP_NUMBER(i.policy_id);
            rep.bndr_remarks1               := i.bndr_remarks1;
            rep.bndr_remarks2               := i.bndr_remarks2;
            rep.bndr_remarks3               := i.bndr_remarks3;
            rep.fnl_binder_id               := i.fnl_binder_id2;
            rep.policy_id                   := i.policy_id;
            rep.par_id                      := i.par_id;
            rep.endt_seq_no                 := i.endt_seq_no;
            rep.endt_yy                     := i.endt_yy;
            rep.endt_iss_cd                 := i.endt_iss_cd;
            rep.subline_cd                  := i.subline_cd;
            
            --CF_SAILING_DATE
            FOR a IN (SELECT etd
                        FROM gipi_cargo
                       WHERE policy_id = i.policy_id
                         AND item_no = 1) 
            LOOP
                rep.cf_sailing_date     := 'Sailing Date  : ' || TO_CHAR(a.etd,'Mon. DD, YYYY');
            END LOOP;
  
            --F_SAILING_DATE format trigger
            IF giisp.v('PRINT_ETD') = 'Y' THEN
                rep.print_cf_sailing_date   := 'Y';
            END IF;
  
            IF i.endt_seq_no != 0 THEN
                rep.cf_endt_no := i.endt_iss_cd || '-' ||ltrim(rtrim(to_char(i.endt_yy, '09'))) || '-' || ltrim(rtrim(to_char(i.endt_seq_no, '099999')));
            ELSE
                rep.cf_endt_no := NULL;
            END IF;
            
            rep.line_cd             := i.line_cd;
            rep.cf_heading          := 'LINE: ' || i.line_name;
            rep.line_cd1            := i.line_cd1;
            rep.frps_yy             := i.frps_yy;
            rep.frps_seq_no         := i.frps_seq_no;
            rep.cf_svu              := 'Property/Item     :';
            rep.reverse_sw          := i.reverse_sw;
            rep.reverse_date        := i.reverse_date;
            rep.other_charges       := i.other_charges;            
            rep.cf_property         := CF_PROPERTY(i.policy_id, i.dist_no, i.dist_seq_no, i.line_cd, i.subline_cd);
            rep.user_id             := i.user_id ;
            rep.currency_rt         := i.currency_rt;        
            
            FOR j IN(SELECT SUM((NVL(T1.RI_PREM_AMT,0) - NVL(T1.RI_COMM_AMT,0) )) LESS_RI_COMM_AMT
                           ,T2.RI_PREM_VAT
                           ,T2.RI_COMM_VAT
                           ,(NVL(T2.RI_WHOLDING_VAT,0)*(-1)) RI_WHOLDING_VAT
                      FROM GIRI_BINDER_PERIL T1
                           ,GIRI_BINDER T2
                           ,GIRI_FRPS_RI T3
                           ,GIRI_FRPS_PERIL_GRP T4
                     WHERE T1.FNL_BINDER_ID = T2.FNL_BINDER_ID
                       AND T2.FNL_BINDER_ID = T3.FNL_BINDER_ID
                       AND T3.LINE_CD       = T4.LINE_CD
                       AND T3.FRPS_YY       = T4.FRPS_YY
                       AND T3.FRPS_SEQ_NO   = T4.FRPS_SEQ_NO 
                       AND T1.PERIL_SEQ_NO  = T4.PERIL_SEQ_NO
                       AND T2.FNL_BINDER_ID = i.FNL_BINDER_ID2
                       AND T3.LINE_CD       = i.LINE_CD1
                       AND T3.FRPS_YY       = i.FRPS_YY
                       AND T3.FRPS_SEQ_NO   = i.FRPS_SEQ_NO 
                     GROUP BY T2.RI_PREM_VAT, T2.RI_COMM_VAT, T2.RI_WHOLDING_VAT)
            LOOP
                v_t_lcomm_amt   := v_t_lcomm_amt + j.less_ri_comm_amt;
                cp_lcomm_vat    := nvl(j.ri_prem_vat,0) - nvl(j.ri_comm_vat,0);
                cp_wholding_vat := nvl(j.ri_wholding_vat,0) * i.currency_rt;
            END LOOP;
            
            rep.net_due := ((NVL(v_t_lcomm_amt,0) * i.currency_rt) - (NVL(i.PREM_TAX4,0) * i.currency_rt) + (NVL(i.OTHER_CHARGES,0) * i.currency_rt) + ROUND(NVL(cp_wholding_vat,0) ,2))
                            + ROUND((NVL(cp_lcomm_vat,0) * i.currency_rt),2);
            
            rep.print_sign_ref_date_across1 := PARAM_BOOL('PRINT_SIGNATURE_REF_DATE_ACROSS');            
            rep.print_auth_rep_above        := PARAM_BOOL('PRINT_AUTHORIZED_SIGNATURE_ABOVE');
            rep.print_note                  := PARAM_BOOL('PRINT_NOTE');
            
            --M_8 format trigger
            BEGIN
                FOR A IN (SELECT UPPER(text) text
                            FROM giis_document
                           WHERE title = 'PRINT_AUTHORIZED_SIGNATURE_ABOVE'
                             AND report_id = 'GIRIR001')
                LOOP
                    v_text := A.text;
                END LOOP;
              
                IF v_text = 'N' THEN
                    rep.print_auth_sign_above    := 'Y';
                END IF;
            END;
            
            --M_10 format trigger
            BEGIN
                FOR A IN (SELECT UPPER(text) text
                            FROM giis_document
                           WHERE title = 'PRINT_SIGNATURE_REF_DATE_ACROSS'
                             AND report_id = 'GIRIR001')
                LOOP
  	                v_text := A.text;
                END LOOP;
  
                IF v_text = 'N' THEN
                    rep.print_sign_ref_date_across2 := 'Y';
                END IF;
            END;
            
            PIPE ROW(rep);
        END LOOP;
    END get_report_details;
    
    
    FUNCTION get_report_perils(
        p_fnl_binder_id     GIRI_BINDER_PERIL.FNL_BINDER_ID%type,
        p_line_cd           GIRI_FRPS_RI.LINE_CD%type,
        p_frps_yy           GIRI_FRPS_RI.FRPS_YY%type,
        p_frps_seq_no       GIRI_FRPS_RI.FRPS_SEQ_NO%type,
        p_currency_rt       GIRI_DISTFRPS.CURRENCY_RT%type,
        p_reverse_sw        GIRI_FRPS_RI.REVERSE_SW%TYPE,
        p_reverse_date      GIRI_BINDER.REVERSE_DATE%type        
    ) RETURN report_perils_tab PIPELINED
    AS
        rep     report_perils_type;
    BEGIN        
        FOR j IN  (SELECT  SUM(nvl(T4.PREM_AMT,0)) GROSS_PREM
                           ,SUM(NVL(T1.RI_PREM_AMT,0)) RI_PREM_AMT
                           ,AVG(NVL(T1.RI_COMM_RT,0)) RI_COMM_RT
                           ,SUM(NVL(T1.RI_COMM_AMT,0))  RI_COMM_AMT
                           ,SUM((NVL(T1.RI_PREM_AMT,0) - NVL(T1.RI_COMM_AMT,0) )) LESS_RI_COMM_AMT
                           ,T1.FNL_BINDER_ID FNL_BINDER_ID3
                           ,T3.LINE_CD
                           ,T3.FRPS_YY
                           ,T3.FRPS_SEQ_NO
                           ,T4.PERIL_TITLE
                           ,T2.RI_PREM_VAT
                           ,T2.RI_COMM_VAT
                           ,(NVL(T2.RI_WHOLDING_VAT,0)*(-1)) RI_WHOLDING_VAT
                      FROM GIRI_BINDER_PERIL T1
                           ,GIRI_BINDER T2
                           ,GIRI_FRPS_RI T3
                           ,GIRI_FRPS_PERIL_GRP T4
                     WHERE T1.FNL_BINDER_ID = T2.FNL_BINDER_ID
                       AND T2.FNL_BINDER_ID = T3.FNL_BINDER_ID
                       AND T3.LINE_CD       = T4.LINE_CD
                       AND T3.FRPS_YY       = T4.FRPS_YY
                       AND T3.FRPS_SEQ_NO   = T4.FRPS_SEQ_NO 
                       AND T1.PERIL_SEQ_NO  = T4.PERIL_SEQ_NO
                       AND T2.FNL_BINDER_ID = P_FNL_BINDER_ID
                       AND T3.LINE_CD       = P_LINE_CD
                       AND T3.FRPS_YY       = P_FRPS_YY
                       AND T3.FRPS_SEQ_NO   = P_FRPS_SEQ_NO 
                     GROUP BY T1.FNL_BINDER_ID, T3.LINE_CD, T3.FRPS_YY, T3.FRPS_SEQ_NO,T4.PERIL_CD,T4.PERIL_TITLE, T2.RI_PREM_VAT, 
                              T2.RI_COMM_VAT, T2.RI_WHOLDING_VAT)
        LOOP
            rep.gross_prem          := j.gross_prem;
            rep.ri_prem_amt         := j.ri_prem_amt;
            rep.ri_comm_amt         := j.ri_comm_amt;
            rep.less_ri_comm_amt    := j.less_ri_comm_amt;
                        
            rep.peril_title         := j.peril_title;
            rep.ri_prem_vat         := j.ri_prem_vat;
            rep.ri_comm_vat         := j.ri_comm_vat;
            rep.ri_comm_rt          := j.ri_comm_rt;
            rep.ri_wholding_vat     := j.ri_wholding_vat;
                
            -- CF_GROSS_PREM1, CF_RI_PREM_AMT1, CF_RI_COMM_AMT1, CF_LCOMM_AMT1
            IF p_reverse_sw = 'Y' OR p_reverse_date IS NOT NULL THEN
                rep.cf_gross_prem   := j.gross_prem * p_currency_rt * (-1);
                rep.cf_ri_prem_amt  := j.ri_prem_amt * p_currency_rt * (-1);
                rep.cf_ri_comm_amt  := j.ri_comm_amt * p_currency_rt * (-1);                    
                rep.cf_lcomm_amt    := j.less_ri_comm_amt * p_currency_rt * (-1);
            ELSE
                rep.cf_gross_prem   := j.gross_prem * p_currency_rt;
                rep.cf_ri_prem_amt  := j.ri_prem_amt * p_currency_rt;
                rep.cf_ri_comm_amt  := j.ri_comm_amt * p_currency_rt;                    
                rep.cf_lcomm_amt    := j.less_ri_comm_amt * p_currency_rt;
            END IF;
                 
            --CF_RI_COMM_RT
            /*BEGIN
                IF j.ri_prem_amt IS NOT NULL OR j.ri_prem_amt != 0  THEN
                    IF j.ri_comm_amt IS NULL OR j.ri_comm_amt = 0 THEN
                        rep.cf_ri_comm_rt   := '0.00%';
                        EXIT;
                    END IF;
                    rep.cf_ri_comm_rt   := TO_CHAR(((j.ri_comm_amt/j.ri_prem_amt)*100),'990.99') || '00%';
                ELSE
                    rep.cf_ri_comm_rt   := '0.00%';
                END IF;   
            END;  */          
                
            --CF_LESS_COM_VAT
            rep.cf_less_comm_vat    := 	nvl(j.ri_prem_vat,0) - nvl(j.ri_comm_vat,0);
                
            --CF_RI_PREM_VAT
            rep.cf_ri_prem_vat      := nvl(j.ri_prem_vat,0) * p_currency_rt;
                
            --CF_RI_COMM_VAT
            rep.cf_ri_comm_vat      := nvl(j.ri_comm_vat,0) * p_currency_rt;
                
            --CF_WHOLDING_VAT
            rep.cf_ri_wholding_vat     := nvl(j.ri_wholding_vat,0) * p_currency_rt;
            rep.cf_ri_wholding_vatcomm := ABS(rep.cf_ri_wholding_vat);
                
            
            PIPE ROW(rep);
        END LOOP;
    END get_report_perils;
    
END GIRIR001C_PKG;
/


