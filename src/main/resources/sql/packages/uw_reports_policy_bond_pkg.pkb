CREATE OR REPLACE PACKAGE BODY CPI.UW_REPORTS_POLICY_BOND_PKG AS

FUNCTION get_uw_endt_bond
		(p_policy_id	GIPI_POLBASIC.policy_id%TYPE
		,p_subline_cd	GIPI_POLBASIC.subline_cd%TYPE
		,p_endt_cd		GIPI_POLBASIC.endt_iss_cd%TYPE
		,p_endt_yy		GIPI_POLBASIC.endt_yy%TYPE
		,p_endt_seq_no	GIPI_POLBASIC.endt_seq_no%TYPE)
		
		RETURN uw_rpt_pol_bond_tab PIPELINED IS
		
        v_endt_bond		uw_rpt_pol_bond_type;
		v_line_cd		GIPI_POLBASIC.line_cd%TYPE	:= 'SU';
		v_prin_signor	GIIS_PRIN_SIGNTRY.prin_signor%TYPE;
        v_obligee_no    GIIS_OBLIGEE.obligee_no%TYPE;
        
		BEGIN
		
		FOR A IN (SELECT  B2503.POLICY_ID 	,B2503.expiry_date EXPIRY_DATE 	,B2503.endt_iss_cd ENDT_ISS_CD
			,B2503.endt_seq_no ENDT_SEQ_NO 	,B2503.endt_type ENDT_TYPE 		,B2503.endt_yy ENDT_YY
			,B2503.line_cd LINE_CD 			,B2503.subline_cd SUBLINE_CD 	,B2503.iss_cd ISS_CD
			,B2503.issue_yy ISSUE_YY 		,B2503.pol_seq_no POL_SEQ_NO 	,B2503.renew_no RENEW_NO2
			,b2503.tsi_amt ENDT_TSI_AMT 	,b2503.prem_amt ENDT_PREM_AMT 	,b2503.ann_tsi_amt ENDT_ANN_TSI_AMT
			,b2503.ann_prem_amt ENDT_ANN_PREM_AMT ,B70010.ENDT_EFF_DATE 	,A2106.subline_name SUBLINE_NAME
			,B2503.issue_date ISSUE_DATE 	,A020.assd_name ASSD_NAME		,A020.assd_no ASSD_NO 
			,A020.bill_addr1 BILL_ADDR1 	,A020.bill_addr2 BILL_ADDR2		,A020.bill_addr3 BILL_ADDR3 
			,B0401.endt_text ENDT_TEXT 		,B70010.obligee_no OBLIGEE_NO1	,B70010.prin_id	PRIN_ID
			,B2500.assd_no ASSD_NO2
			FROM GIIS_SUBLINE A2106
				,GIIS_ASSURED A020 
				,GIPI_BOND_BASIC B70010
				,GIPI_ENDTTEXT B0401    
				,GIPI_POLBASIC B2503
				,GIPI_PARLIST B2500
			WHERE B2503.POLICY_ID = B70010.POLICY_ID (+) --added outer join to prevent returning null result even SU endorsement has no records in gipi_bond_basic table by MAC 03/14/2012.
			AND   B2503.POLICY_ID = B0401.POLICY_ID
			AND   B2500.PAR_ID = B2503.PAR_ID
			AND   B2503.ASSD_NO = A020.ASSD_NO 
			AND   B2503.LINE_CD = A2106.LINE_CD 
			AND   B2503.SUBLINE_CD= A2106.SUBLINE_CD
			AND   DECODE(P_POLICY_ID, NULL,
						B2503.SUBLINE_CD ||'A'|| B2503.ENDT_ISS_CD ||'A'|| TO_CHAR(B2503.ENDT_YY,'00') ||'A'|| TO_CHAR(B2503.ENDT_SEQ_NO,'00000000')
							, B2503.POLICY_ID) = DECODE(P_POLICY_ID, NULL,
						P_SUBLINE_CD ||'A'|| P_ENDT_CD ||'A'|| TO_CHAR(P_ENDT_YY,'00') ||'A'|| TO_CHAR(P_ENDT_SEQ_NO,'00000000')
							, P_POLICY_ID) 
			AND   B2503.LINE_CD = v_line_cd)
           
            
			LOOP
				v_endt_bond.policy_id	:=	A.policy_id;
				v_endt_bond.expiry_date	:=	A.expiry_date;
				v_endt_bond.endt_iss_cd	:=	A.endt_iss_cd;
				v_endt_bond.endt_seq_no	:=	A.endt_seq_no;
				v_endt_bond.endt_type	:= 	A.endt_type;
				v_endt_bond.endt_yy		:= 	A.endt_yy;
				v_endt_bond.line_cd		:=	A.line_cd;
				v_endt_bond.subline_cd	:=	A.subline_cd;
				v_endt_bond.iss_cd		:=	A.iss_cd;
				v_endt_bond.issue_yy	:=	A.issue_yy;
				v_endt_bond.pol_seq_no	:= 	A.pol_seq_no;
				v_endt_bond.renew_no2	:=	A.renew_no2;
				v_endt_bond.endt_prem_amt	:=	A.endt_prem_amt;
				v_endt_bond.endt_tsi_amt	:=	A.endt_tsi_amt;
				v_endt_bond.endt_ann_prem_amt	:=	A.endt_ann_prem_amt;
				v_endt_bond.endt_ann_tsi_amt	:=	A.endt_ann_tsi_amt;
				v_endt_bond.endt_eff_date	:=	A.endt_eff_date;
				v_endt_bond.subline_name	:=	A.subline_name;
				v_endt_bond.assd_name	:=	A.assd_name;
				v_endt_bond.assd_no		:=	A.assd_no;
				v_endt_bond.issue_date	:=	A.issue_date;
				v_endt_bond.bill_addr1	:=	A.bill_addr1;
				v_endt_bond.bill_addr2	:=	A.bill_addr2;
				v_endt_bond.bill_addr3	:=	A.bill_addr3;
				v_endt_bond.endt_text	:=	A.endt_text;
				v_endt_bond.obligee_no1	:=	A.obligee_no1;
				
                
				-- PRINCIPAL SIGNATORY
				IF ((a.prin_id is NULL) OR (a.prin_id = '')) THEN
					BEGIN
					    SELECT prin_signor, designation 
                            INTO v_endt_bond.prin_signor1, v_endt_bond.designation3
                          FROM GIIS_PRIN_SIGNTRY WHERE assd_no = a.assd_no2;
					EXCEPTION
						WHEN OTHERS THEN
							v_endt_bond.prin_signor1	:=	'';
					END;
				ELSE
					SELECT prin_signor, designation 
                        INTO v_endt_bond.prin_signor1, v_endt_bond.designation3 
                      FROM GIIS_PRIN_SIGNTRY WHERE prin_id = a.prin_id;
				END IF;
				
				-- OBLIGEE 
				IF ((a.obligee_no1 is NULL) OR (a.obligee_no1 = '')) THEN
					BEGIN
						FOR b IN (SELECT obligee_no FROM GIPI_BOND_BASIC 
									WHERE policy_id in (SELECT policy_id FROM GIPI_POLBASIC WHERE line_cd = a.line_cd
																AND subline_cd	= a.subline_cd
																AND iss_cd 		= a.iss_cd
																AND issue_yy	= a.issue_yy
																AND pol_seq_no	= a.pol_seq_no
																AND renew_no	= a.renew_no2
																))
							LOOP
								IF (b.obligee_no is not NULL) THEN
									v_obligee_no	:= b.obligee_no;
									EXIT;
								END IF;
							END LOOP;
							SELECT obligee_name, address1, address2, address3 
                                INTO v_endt_bond.obligee_name1, v_endt_bond.address1
                                    ,v_endt_bond.address2, v_endt_bond.address3 
                              FROM GIIS_OBLIGEE where obligee_no = v_obligee_no;
					EXCEPTION
						WHEN OTHERS THEN
							v_endt_bond.obligee_name1	:=	'';
					END;
				ELSE
					SELECT obligee_name, address1, address2, address3  
                        INTO v_endt_bond.obligee_name1, v_endt_bond.address1
                             ,v_endt_bond.address2, v_endt_bond.address3 
                      FROM GIIS_OBLIGEE where obligee_no = a.obligee_no1;
				END IF;
                PIPE ROW(v_endt_bond);
			END LOOP;
            RETURN;
		END get_uw_endt_bond;
		
END UW_REPORTS_POLICY_BOND_PKG;
/


