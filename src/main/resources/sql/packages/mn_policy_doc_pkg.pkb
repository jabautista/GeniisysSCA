CREATE OR REPLACE PACKAGE BODY CPI.MN_POLICY_DOC_PKG AS

  FUNCTION get_mn_policy_doc_details(p_extract_id		 GIXX_POLBASIC.extract_id%TYPE)
    RETURN mn_policy_doc_tab PIPELINED IS

	v_doc				 mn_policy_doc_type;
	v_par_no_ref_no		 VARCHAR2(50);
	v_file_name 		 giis_signatory_names.file_name%type;
	v_policy  			 VARCHAR2(1000):= NULL;
	v_header			 giis_document.text%type;
	v_company_name    	 VARCHAR2(100);
	v_label				 giis_document.text%type;
	v_designation		 varchar2(50);
	v_assd_name  		 VARCHAR2(50):= NULL;
	v_ref_inv_no		 gixx_invoice.ref_inv_no%type;
	v_count         	 number(2):=1;
	v_2ndheader			 VARCHAR2(500);
	v_name				 VARCHAR2(50);
	v_decltn  			 gixx_open_policy.decltn_no%type;
	v_2ndheader2		 VARCHAR2(500);
	v_2ndheader3		 VARCHAR2(500);

	CURSOR c1 IS
	          SELECT B540.LINE_CD || '-' ||B540.ISS_CD || '-' ||LTRIM(TO_CHAR(B540.issue_YY, '09')) || '-' || TRIM(TO_CHAR(B540.Pol_SEQ_NO, '099999'))
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
       				 ,DECODE(B540.LABEL_TAG,'Y','Leased to    :','In acct of   :') Label_Tag1
       				 ,decode(b240.par_type,'E',B540.ENDT_ISS_CD || '-' || LTRIM(TO_CHAR(B540.ENDT_YY, '09')) || '-' ||LTRIM(TO_CHAR(B540.ENDT_SEQ_NO, '099999'))) ENDT_NO
       				 ,decode(b240.par_type,'E',B540.LINE_CD || '-' || B540.SUBLINE_CD || '-' || B540.ISS_CD || '-' ||LTRIM(TO_CHAR(B540.ISSUE_YY, '09')) || '-' ||LTRIM(TO_CHAR(B540.POL_SEQ_NO, '099999')) || '-' || LTRIM(TO_CHAR(B540.RENEW_NO, '09')) || ' - ' ||B540.ENDT_ISS_CD || '-' || LTRIM(TO_CHAR(B540.ENDT_YY, '09')) || '-' ||LTRIM(TO_CHAR(B540.ENDT_SEQ_NO, '099999'))) POL_ENDT_NO
       				 ,DECODE(B540.ENDT_EXPIRY_TAG,'Y','T.B.A.',TO_CHAR(B540.ENDT_EXPIRY_DATE,'FMMonth DD, YYYY'))  ENDT_EXPIRY_DATE
       				 ,TO_CHAR(B540.EFF_DATE, 'FMMonth DD, YYYY')         BASIC_EFF_DATE
       				 , B540.EFF_DATE                EFF_DATE
       				 ,decode(b240.par_type,'E',B540.ENDT_EXPIRY_TAG)   ENDT_EXPIRY_TAG
       				 ,B540.INCEPT_TAG        BASIC_INCEPT_TAG
       				 ,B540.SUBLINE_CD	       BASIC_SUBLINE_CD
       				 ,B540.ISS_CD	           BASIC_ISS_CD
       				 ,B540.ISSUE_YY          BASIC_ISSUE_YY
       				 ,B540.POL_SEQ_NO        BASIC_POL_SEQ_NO
       				 ,B540.RENEW_NO	       BASIC_RENEW_NO
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
					 B540.label_tag label_tag
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
				 AND ROWNUM <2;

  BEGIN

    MN_POLICY_DOC_PKG.Initialize_Variables('MARINE_CARGO');

    FOR i IN c1
	LOOP

	  --CF_PAR_NO_REF_NO
	  IF MN_POLICY_DOC_PKG.DISPLAY_REF_POL_NO = 'Y' THEN
		v_par_no_ref_no := i.par_no;
	  ELSE
	    IF i.basic_ref_pol_no IS NOT NULL THEN
	  	  v_par_no_ref_no := i.par_no || ' / ' || i.basic_ref_pol_no;
	    ELSE
	  	  v_par_no_ref_no := i.par_no;
	    END IF;
	  END IF;

	  --CF_SIGNATORY_NAME
	  BEGIN
		  SELECT a.file_name
		    INTO v_file_name
		    from giis_signatory_names a,giis_signatory b
		         	where a.signatory_id=b.signatory_id
			          AND iss_cd = i.iss_cd
		          	and b.current_signatory_sw='Y'
		          	and	b.line_cd = i.line_cd
		          	and nvl(b.report_id, 'MARINE_CARGO') = 'MARINE_CARGO';
	  EXCEPTION
			WHEN NO_DATA_FOUND THEN
			   v_file_name := NULL;

	  END;

	  --CF_RENEWAL
	  IF i.par_par_status = 10 THEN
	  	 FOR a in (
	    	SELECT a.line_cd || '-' || a.subline_cd || '-' ||a.iss_cd || '-' ||
	      	       LTRIM(TO_CHAR(a.issue_yy, '09')) || '-' ||LTRIM(TO_CHAR(a.pol_seq_no, '099999')) || '-' ||
	        	     LTRIM(TO_CHAR(a.renew_no, '09')) policy_no
	     	  FROM gipi_polbasic a, gipi_polnrep b
	     	 WHERE b.new_policy_id = i.par_id
		       AND a.policy_id     = b.old_policy_id)
	  	 LOOP
	  		 IF v_policy IS NULL THEN
	  		 	 	v_policy := a.policy_no;
	  		 ELSE
		   		  v_policy := v_policy || chr(10) || a.policy_no;
	  		 END IF;
	  	 END LOOP;
	  ELSE
	  	 FOR a IN (
	  	   SELECT a.line_cd || '-' || a.subline_cd || '-' || a.iss_cd || '-' ||
	       		       LTRIM(TO_CHAR(a.issue_yy, '09')) || '-' ||
	          		   LTRIM(TO_CHAR(a.pol_seq_no, '099999')) || '-' ||
	              	LTRIM(TO_CHAR(a.renew_no, '09')) policy_no
	         FROM gipi_polbasic a, gipi_wpolnrep b
	        WHERE b.par_id    = i.extract_id1
	          AND a.policy_id = b.old_policy_id)
	     LOOP
	     	 IF v_policy IS NULL THEN
	  		 	 	v_policy := a.policy_no;
	  		 ELSE
		   		  v_policy := v_policy || chr(10) || a.policy_no;
	  		 END IF;
	     END LOOP;
	  END IF;

	  --CF_HEADER
	  IF i.PAR_PAR_STATUS != 10 THEN
	  	IF i.PAR_PAR_TYPE  = 'P' THEN
	  		v_header := MN_POLICY_DOC_PKG.par_header;
	  	ELSE
	  		v_header := MN_POLICY_DOC_PKG.endt_header;
	  	END IF;
	  else
	  		v_header := null;
	  end if;

	  --CF_COMPANY
	  FOR name IN (
	    SELECT param_value_v
	      FROM giis_parameters
	     WHERE param_name = 'COMPANY_NAME')
	  LOOP
	    v_company_name := name.param_value_v;
	  END LOOP;

	  --CF_LABEL
	  IF i.PAR_PAR_STATUS = 10 THEN
	  	v_label := MN_POLICY_DOC_PKG.policy;
	  ELSE
	  	v_label := MN_POLICY_DOC_PKG.par;
	  END IF;

	  --CF_SIGNATORY
	  for a in
           (Select rtrim(ltrim(Initcap(designation))) designation
           from giis_signatory_names a,giis_signatory b
         	where a.signatory_id=b.signatory_id
	          AND iss_cd = i.iss_cd
          	and b.current_signatory_sw='Y'
          	and	b.line_cd = i.line_cd
          	and nvl(b.report_id,'MARINE_CARGO') = 'MARINE_CARGO')
	  loop
	  	v_designation := a.designation;
	  end loop;

	  --CF_ACCT_OF_CD
	  IF i.label_tag1 = 'Y' AND MN_POLICY_DOC_PKG.LEASED_TO = 'Y' THEN
		  SELECT DECODE(designation, NULL, assd_name||' '||assd_name2, designation ||' '||assd_name||' '||assd_name2)
		    INTO v_assd_name
		    FROM giis_assured
		   WHERE assd_no = i.basic_assd_number;

	  ELSE

		FOR a IN (
		  SELECT a.assd_name  assd_name
		    FROM giis_assured a,gixx_polbasic b
		   WHERE b.acct_of_cd > 0
		     AND b.acct_of_cd = i.basic_acct_of_cd
		     AND a.assd_no    = b.acct_of_cd)
		LOOP
		  v_assd_name   :=  a.assd_name;
		  EXIT;
		END LOOP;
	  END IF;

	  --CF_REF_INV_NO
	  IF i.basic_co_insurance_sw = 1 THEN
				FOR a IN (
		  		SELECT ref_inv_no
		    		FROM gixx_invoice
		   		 WHERE extract_id = i.extract_id1)
				LOOP
		  		IF v_count = 1 THEN
		  	 		 v_ref_inv_no := a.ref_inv_no;
		  		ELSE
		  	 		 v_ref_inv_no := v_ref_inv_no || chr(10) || a.ref_inv_no;
		  		END IF;
				END LOOP;
	  ELSE
			  FOR a IN (
				  SELECT ref_inv_no
		    		FROM gixx_invoice
		   		 WHERE extract_id = i.extract_id1)
				LOOP
		  		IF v_count = 1 THEN
		  	 		 v_ref_inv_no := a.ref_inv_no;
		  		ELSE
		  	 		 v_ref_inv_no := v_ref_inv_no || chr(10) || a.ref_inv_no;
		  		END IF;
				END LOOP;
	  END IF;

	  --CF_2NDHEADER
	  IF i.PAR_PAR_TYPE = 'P' THEN
		    v_2ndheader := 'Attached to and forming part of '||i.PAR_NO||'  ';
	  ELSE
	 	  IF i.PAR_PAR_STATUS = 10 THEN
	  		 v_2ndheader := 'Attached to and forming part of '||i.ENDT_NO||'  ';
	 	  ELSE
	 	  	 v_2ndheader := 'Attached to and forming part of '||i.PAR_NO||'  ';
	 	  END IF;
	  END IF;

	  --CF_2NDHEADER1
	  IF i.PAR_PAR_TYPE = 'E' AND i.PAR_PAR_STATUS != 10 THEN
	 	  v_name := 'PAR No.';
	  END IF;

	  IF i.PAR_PAR_TYPE = 'P' THEN
	  	IF i.PAR_PAR_STATUS NOT IN (10,99) THEN
	  		v_name := 'PAR No.';
	  	else
	  		v_name := 'Policy No.';
	  	end if;
	  else
	  	IF i.PAR_PAR_STATUS NOT IN (10,99) THEN
	  		v_name := 'Endt. No.';
	  	else
	  		v_name := 'Endt. No.';
	  	end if;
	  end if;

	  --CF_DECLARATION
	  FOR x IN(SELECT decltn_no
			     FROM gixx_open_policy
			    WHERE extract_id = i.extract_id1)
	  LOOP
		v_decltn := x.decltn_no;
	  END LOOP;

	  --CF_2NDHEADER2
	  IF i.PAR_PAR_TYPE = 'P' THEN
	    v_2ndheader2 := NULL;
	  else
	    v_2ndheader2 := '/';
	  end if;

	  --CF_2NDHEADER3
	  IF i.PAR_PAR_TYPE = 'P' THEN
  		v_2ndheader3 := 'Attached to and forming part of '||i.PAR_NO||'  ';
	  else
	  		IF i.PAR_PAR_STATUS = 10 THEN
	  		 v_2ndheader3 := 'Attached to and forming part of '||i.PAR_NO||' / '||i.ENDT_NO||'  ';
	 	  ELSE
	 	  	 v_2ndheader3 := 'Attached to and forming part of '||i.PAR_NO||' / '||i.PAR_NO||'  ';
	 	  	 END IF;
	  end if;

	  v_doc.par_seq_no1	 	   	 := i.par_seq_no1;
	  v_doc.extract_id1	 	 	 := i.extract_id1;
	  v_doc.par_id	 			 := i.par_id;
	  v_doc.policy_number	 	 := i.policy_number;
	  v_doc.iss_cd	 			 := i.iss_cd;
	  v_doc.line_cd	 		 	 := i.line_cd;
	  v_doc.par_no 	 			 := i.par_no;
	  v_doc.par_orig	 		 := i.par_orig;
	  v_doc.line_line_name	 	 := i.line_line_name;
	  v_doc.subline_subline_name := i.subline_subline_name;
	  v_doc.subline_subline_cd	 := i.subline_subline_cd;
	  v_doc.subline_line_cd	 	 := i.subline_line_cd;
	  v_doc.basic_incept_date	 := i.basic_incept_date;
	  v_doc.basic_incept_time	 := i.basic_incept_time;
	  v_doc.basic_expiry_date	 := i.basic_expiry_date;
	  v_doc.basic_expiry_time	 := i.basic_expiry_time;
	  v_doc.basic_expiry_tag	 := i.basic_expiry_tag;
	  v_doc.basic_issue_date	 := i.basic_issue_date;
	  v_doc.basic_tsi_amt	 	 := i.basic_tsi_amt;
	  v_doc.subline_subline_time := i.subline_subline_time;
	  v_doc.basic_acct_of_cd	 := i.basic_acct_of_cd;
	  v_doc.basic_mortg_name	 := i.basic_mortg_name;
	  v_doc.assd_name	 		 := i.assd_name;
	  v_doc.address1	 		 := i.address1;
	  v_doc.address2	 		 := i.address2;
	  v_doc.address3	 		 := i.address3;
	  v_doc.basic_addr 	 	 	 := i.basic_addr;
	  v_doc.basic_pol_flag	 	 := i.basic_pol_flag;
	  v_doc.basic_line_cd	 	 := i.basic_line_cd;
	  v_doc.basic_ref_pol_no	 := i.basic_ref_pol_no;
	  v_doc.basic_assd_no	 	 := i.basic_assd_no;
	  v_doc.label_tag1	 		 := i.label_tag1;
	  v_doc.endt_no	 		 	 := i.endt_no;
	  v_doc.pol_endt_no		 	 := i.pol_endt_no;
	  v_doc.endt_expiry_date	 := i.endt_expiry_date;
	  v_doc.basic_eff_date	 	 := i.basic_eff_date;
	  v_doc.eff_date	 		 := i.eff_date;
	  v_doc.endt_expiry_tag	 	 := i.endt_expiry_tag;
	  v_doc.basic_incept_tag	 := i.basic_incept_tag;
	  v_doc.basic_subline_cd	 := i.basic_subline_cd;
	  v_doc.basic_iss_cd	 	 := i.basic_iss_cd;
	  v_doc.basic_issue_yy	 	 := i.basic_issue_yy;
	  v_doc.basic_pol_seq_no	 := i.basic_pol_seq_no;
	  v_doc.basic_renew_no	 	 := i.basic_renew_no;
	  v_doc.basic_eff_time	 	 := i.basic_eff_time;
	  v_doc.basic_endt_expiry_time	 := i.basic_endt_expiry_time;
	  v_doc.par_par_type	 	 := i.par_par_type;
	  v_doc.par_par_status	 	 := i.par_par_status;
	  v_doc.basic_co_insurance_sw	 := i.basic_co_insurance_sw;
	  v_doc.username	 		 := i.username;
	  v_doc.intm_no	 			 := i.intm_no;
	  v_doc.intm_name	 		 := i.intm_name;
	  v_doc.agent_intm_name	 	 := i.agent_intm_name;
	  v_doc.parent_intm_name	 := i.parent_intm_name;
	  v_doc.agent_intm_no	 	 := i.agent_intm_no;
	  v_doc.parent_intm_no	 	 := i.parent_intm_no;
	  v_doc.basic_tsi_amt_1	 	 := i.basic_tsi_amt_1;
	  v_doc.subline_open_policy  := i.subline_open_policy;
	  v_doc.subline_time	 	 := i.subline_time;
	  v_doc.basic_assd_number	 := i.basic_assd_number;
	  v_doc.cred_br	 		 	 := i.cred_br;
	  v_doc.label_tag	 	 	 := i.label_tag;
	  v_doc.basic_printed_cnt	 := i.basic_printed_cnt;
	  v_doc.basic_printed_dt	 := i.basic_printed_dt;
	  v_doc.ann_tsi_amt	 		 := i.ann_tsi_amt;
	  v_doc.f_survey_title		 := MN_POLICY_DOC_PKG.SURVEY_TITLE;
	  v_doc.f_par_no_ref_no		 := v_par_no_ref_no;
	  v_doc.f_signatory_name	 := v_file_name;
	  v_doc.f_attestation1		 := MN_POLICY_DOC_PKG.DOC_ATTESTATION1;
	  v_doc.f_attestation2		 := MN_POLICY_DOC_PKG.DOC_ATTESTATION2;
	  v_doc.f_renewal			 := v_policy;
	  v_doc.f_header			 := v_header;
	  v_doc.f_company			 := v_company_name;
	  v_doc.f_label				 := v_label;
	  v_doc.f_signatory			 := v_designation;
	  v_doc.f_upper_comp		 := UPPER(v_company_name);
	  v_doc.f_acct_of_cd		 := v_assd_name;
	  v_doc.f_ref_inv_no		 := v_ref_inv_no;
	  v_doc.f_2ndheader			 := v_2ndheader;
	  v_doc.f_2ndheader1		 := v_name;
	  v_doc.f_declaration		 := v_decltn;
	  v_doc.f_2ndheader2		 := v_2ndheader2;
	  v_doc.f_2ndheader3		 := v_2ndheader3;
	  v_doc.f_report_title		 := MN_POLICY_DOC_PKG.CF_REPORT_TITLE(i.par_par_type, i.par_par_status, i.subline_subline_cd);
	  v_doc.f_open_policy		 := MN_POLICY_DOC_PKG.cf_open_policy(p_extract_id);
	  v_doc.f_line_name			 := MN_POLICY_DOC_PKG.CF_LINE_NAME(i.par_id, i.line_line_name);
	  v_doc.f_DOC_SUBTITLE1		 := MN_POLICY_DOC_PKG.DOC_SUBTITLE1;
	  v_doc.f_DOC_SUBTITLE2		 := MN_POLICY_DOC_PKG.DOC_SUBTITLE2;
	  v_doc.f_DOC_SUBTITLE3		 := MN_POLICY_DOC_PKG.DOC_SUBTITLE3;
	  v_doc.f_DOC_SUBTITLE4		 := MN_POLICY_DOC_PKG.DOC_SUBTITLE4;
	  v_doc.F_PERIL_TITLE3		 := MN_POLICY_DOC_PKG.peril_title;
	  v_doc.F_INTM_NUMBER		 := MN_POLICY_DOC_PKG.CF_INTM_NUMBER(p_extract_id,
  		   				  		 									 i.subline_line_cd,
						  											 i.subline_subline_cd,
						  											 i.basic_iss_cd,
						  											 i.basic_issue_yy,
						  											 i.basic_pol_seq_no,
						  											 i.basic_renew_no);
	  v_doc.F_INTM_NAME		     := MN_POLICY_DOC_PKG.CF_INTM_NAME(p_extract_id,
  		   				  		 									 i.subline_line_cd,
						  											 i.subline_subline_cd,
						  											 i.basic_iss_cd,
						  											 i.basic_issue_yy,
						  											 i.basic_pol_seq_no,
						  											 i.basic_renew_no);
	  v_doc.F_ATTESTATION_TITLE  := MN_POLICY_DOC_PKG.ATTESTATION_TITLE;
	  v_doc.f_assd_name			 := MN_POLICY_DOC_PKG.CF_ASSD_NAME(i.label_tag1,
  		   						 								   i.basic_acct_of_cd,
																   i.basic_assd_number);

	  v_doc.f_user			     := MN_POLICY_DOC_PKG.CF_USER(i.par_id, i.par_par_status);
	  v_doc.F_TSI_TITLE			 := MN_POLICY_DOC_PKG.SUM_INSURED_TITLE;
	  v_doc.F_BASIC_TSI_SPELL	 := MN_POLICY_DOC_PKG.CF_BASIC_TSI_SPELL(p_extract_id, i.basic_co_insurance_sw);
	  v_doc.f_dash				 := MN_POLICY_DOC_PKG.CF_DASH(MN_POLICY_DOC_PKG.CF_REPORT_TITLE(i.par_par_type, i.par_par_status, i.subline_subline_cd));
	  v_doc.F_policy_id_0		 := MN_POLICY_DOC_PKG.CF_policy_id_0(i.par_id);
	  v_doc.F_MORTGAGEE_TITLE	 := MN_POLICY_DOC_PKG.CF_MORTGAGEE_TITLE(p_extract_id);
	  PIPE ROW(v_doc);
	END LOOP;
	RETURN;
  END get_mn_policy_doc_details;

  FUNCTION CF_REPORT_TITLE(p_par_type    GIXX_PARLIST.par_type%TYPE,
  		   				   p_par_status	 GIXX_PARLIST.par_status%TYPE,
						   p_subline_cd	 GIIS_SUBLINE.subline_cd%TYPE)
    RETURN VARCHAR2
	IS
	v_rep_ttle			 giis_document.text%type;
	v_op_flag 			 VARCHAR2(1);
	BEGIN
	  IF p_par_type = 'P' THEN
	  	IF p_par_status NOT IN (10,99) THEN
	  	  v_rep_ttle := MN_POLICY_DOC_PKG.par_par;
	  	ELSE
	  	  IF MN_POLICY_DOC_PKG.PRINT_OPEN_RISK = 'Y' THEN
			  SELECT op_flag
			    INTO v_op_flag
			    FROM giis_subline
			   WHERE line_cd = 'MN'
			     AND subline_cd = p_subline_cd;
			   IF v_op_flag = 'N' THEN
			   	   v_rep_ttle := MN_POLICY_DOC_PKG.POLICY_TITLE_RISK;
			   ELSE
			   	   v_rep_ttle := MN_POLICY_DOC_PKG.POLICY_TITLE_OPEN;
			   END IF;
		   ELSE
	  		 v_rep_ttle := MN_POLICY_DOC_PKG.par_policy;
	  	   END IF;
	  	 END IF;
	  ELSE
	  	IF p_par_status NOT IN (10,99) THEN
	  		v_rep_ttle := MN_POLICY_DOC_PKG.endt_par;
	  	else
	  		v_rep_ttle := MN_POLICY_DOC_PKG.endt_policy;
	  	end if;
	  end if;
	RETURN v_rep_ttle;
  END CF_REPORT_TITLE;

  FUNCTION cf_open_policy(p_extract_id	GIXX_POLBASIC.extract_id%TYPE)
    RETURN VARCHAR2 IS
	v_open_policy		VARCHAR2(100) ;
  BEGIN
    FOR a IN (SELECT op.line_cd || '-' || op.op_subline_cd || '-' || op.op_iss_cd || '-' ||
	           		 LTRIM(TO_CHAR(op.op_issue_yy,'09')) || '-' ||
	                 LTRIM(TO_CHAR(op.op_pol_seqno,'0999999'))||DECODE(gp.ref_pol_no,NULL,'',' / '||gp.ref_pol_no) policy_no
                FROM gixx_open_policy op , gipi_polbasic gp
               WHERE op.extract_id      = p_extract_id
	             AND op.line_cd         = gp.line_cd
	             AND op.op_subline_cd   = gp.subline_cd
	             AND op.op_iss_cd       = gp.iss_cd
	             AND op.op_issue_yy     = gp.issue_yy
	             AND op.op_pol_seqno    = gp.pol_seq_no)
	LOOP
	  v_open_policy := a.policy_no;
    END LOOP;
	RETURN (v_open_policy);
  END cf_open_policy;

  function CF_LINE_NAME(p_par_id   GIXX_POLBASIC.policy_id%TYPE,
  		   				p_line_name GIIS_LINE.line_name%TYPE)
    return VARCHAR2 is
  begin
	FOR C IN (
	    SELECT policy_currency
	      FROM gixx_invoice
	     WHERE policy_id = p_par_id)
	  LOOP
	    MN_POLICY_DOC_PKG.INVOICE_POLICY_CURRENCY :=  C.policy_currency;
	  EXIT;
	  END LOOP;
	  RETURN(p_line_name);
  end;

  function CF_INTM_NUMBER(p_extract_id			  GIXX_POLBASIC.extract_id%TYPE,
  		   				  p_subline_line_cd		  GIIS_SUBLINE.line_cd%TYPE,
						  p_subline_subline_cd	  GIIS_SUBLINE.subline_cd%TYPE,
						  p_basic_iss_cd 		  GIXX_POLBASIC.iss_cd%TYPE,
						  p_basic_issue_yy		  GIXX_POLBASIC.issue_yy%TYPE,
						  p_basic_pol_seq_no	  GIXX_POLBASIC.pol_seq_no%TYPE,
						  p_basic_renew_no		  GIXX_POLBASIC.renew_no%TYPE)
    return VARCHAR2 is
	v_intm_no			varchar2(100);
	v_parent		    varchar2(100);
	v_agent		        varchar2(100);
	v_orig_parent       varchar2(100);
	v_orig_agent        varchar2(100);
  begin
	  FOR a in (
	  	  SELECT DECODE(parent.ref_intm_cd,NULL,
	  	          to_char(a.parent_intm_no,'999999999990'),
	  	          to_char(a.parent_intm_no,'999999999990')||'-'||parent.ref_intm_cd)  parent_intm_no,
	      			 DECODE(agent.ref_intm_cd,NULL,
	      			  to_char(a.intrmdry_intm_no,'999999999990'),
	      			  to_char(a.intrmdry_intm_no,'999999999990')||'-'||agent.ref_intm_cd) agent_intm_no
				  FROM giis_intermediary agent,
				 			 giis_intermediary parent,
		           gixx_comm_invoice a
	 			 WHERE a.parent_intm_no   = parent.intm_no(+)
	   			 AND a.intrmdry_intm_no = agent.intm_no(+)
	   			 AND a.extract_id       = p_extract_id)
		LOOP
			v_parent := a.parent_intm_no;
			v_agent  := a.agent_intm_no;
			EXIT;
		END LOOP;

		IF v_parent = v_agent THEN
	     v_intm_no := ('/ '||LTRIM(v_agent));
	  ELSE
	  	 v_intm_no := LTRIM(v_parent)||' / '||LTRIM(v_agent);
	  END IF;

		IF v_parent IS NULL AND v_agent IS NULL  THEN
	  	FOR a in (
	  	  SELECT DECODE(parent.ref_intm_cd,NULL,
	  	          to_char(a.parent_intm_no,'999999999990'),
	  	          to_char(a.parent_intm_no,'999999999990')||'-'||parent.ref_intm_cd)  parent_intm_no,
	      			 DECODE(agent.ref_intm_cd,NULL,
	      			  to_char(a.intrmdry_intm_no,'999999999990'),
	      			  to_char(a.intrmdry_intm_no,'999999999990')||'-'||agent.ref_intm_cd) agent_intm_no
				  FROM giis_intermediary agent,
				 			 giis_intermediary parent,
		           gipi_comm_invoice a
	 			 WHERE a.parent_intm_no   = parent.intm_no
	   			 AND a.intrmdry_intm_no = agent.intm_no
	   			 AND a.policy_id  IN (SELECT a.policy_id
	   	   								 	         FROM gipi_polbasic a, gipi_invoice b
						        				  	WHERE a.policy_id   = b.policy_id
						              				  AND a.line_cd     = p_subline_line_cd
						            	  			  AND a.subline_cd  = p_subline_subline_cd
							        	  			  AND a.iss_cd      = p_basic_iss_cd
							        	  			  AND a.issue_yy    = p_basic_issue_yy
							        	  			  AND a.pol_seq_no  = p_basic_pol_seq_no
							        	  			  AND a.renew_no    = p_basic_renew_no
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
	  RETURN (LTRIM(v_intm_no));
  end CF_INTM_NUMBER;

  function CF_INTM_NAME(p_extract_id			  GIXX_POLBASIC.extract_id%TYPE,
  		   				  p_subline_line_cd		  GIIS_SUBLINE.line_cd%TYPE,
						  p_subline_subline_cd	  GIIS_SUBLINE.subline_cd%TYPE,
						  p_basic_iss_cd 		  GIXX_POLBASIC.iss_cd%TYPE,
						  p_basic_issue_yy		  GIXX_POLBASIC.issue_yy%TYPE,
						  p_basic_pol_seq_no	  GIXX_POLBASIC.pol_seq_no%TYPE,
						  p_basic_renew_no		  GIXX_POLBASIC.renew_no%TYPE)
    return VARCHAR2 is
	v_intm_name			varchar2(240);
	v_agent					giis_intermediary.intm_name%type;
	v_parent				giis_intermediary.intm_name%type;
	v_orig_agent		giis_intermediary.intm_name%type;
	v_orig_parent		giis_intermediary.intm_name%type;
  begin
		FOR a in (
	  	  SELECT PARENT.intm_name parent_intm_name,
	  	          agent.intm_name agent_intm_name
	  			FROM giis_intermediary agent,
		   				 giis_intermediary PARENT,
		           gixx_comm_invoice a
	 			 WHERE a.parent_intm_no   = PARENT.intm_no
	   			 AND a.intrmdry_intm_no = agent.intm_no
	   			 AND a.extract_id       = p_extract_id)
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
	  	FOR a in (
	  	  SELECT PARENT.intm_name parent_intm_name,
	  	          agent.intm_name agent_intm_name
				  FROM giis_intermediary agent,
				 			 giis_intermediary parent,
		           gipi_comm_invoice a
	 			 WHERE a.parent_intm_no   = parent.intm_no
	   			 AND a.intrmdry_intm_no = agent.intm_no
	   			 AND a.policy_id  IN (SELECT a.policy_id
	   	   								 	         FROM gipi_polbasic a, gipi_invoice b
						        				  		WHERE a.policy_id   = b.policy_id
						              				  AND a.line_cd     = p_subline_line_cd
						            	  				AND a.subline_cd  = p_subline_subline_cd
							        	  					AND a.iss_cd      = p_basic_iss_cd
							        	  					AND a.issue_yy    = p_basic_issue_yy
							        	  					AND a.pol_seq_no  = p_basic_pol_seq_no
							        	  					AND a.renew_no    = p_basic_renew_no
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
	RETURN (LTRIM(v_intm_name));
  end CF_INTM_NAME;

  function CF_ASSD_NAME(p_label_tag1	    VARCHAR2,
  		   				p_basic_acct_of_cd  GIXX_POLBASIC.acct_of_cd%TYPE,
						p_basic_assd_number GIXX_POLBASIC.assd_no%TYPE)
    return VARCHAR2 is
	v_assd_name   varchar2(500);
  BEGIN
	IF p_label_tag1 = 'Y' AND MN_POLICY_DOC_PKG.LEASED_TO = 'Y' THEN
		v_assd_name := display_assured_leased(p_basic_acct_of_cd);
	ELSE
	   v_assd_name := DISPLAY_ASSURED(p_basic_assd_number);
	END IF;
  	RETURN(v_assd_name);
  END;

  function CF_USER(p_par_id		gixx_polbasic.par_id%TYPE,
  		   		   p_par_status GIXX_PARLIST.par_status%TYPE)
    return VARCHAR2 is
	v_user         gixx_polbasic.user_id%TYPE;
	v_user_create  gixx_polbasic.user_id%TYPE;
  BEGIN
	IF p_par_status = 10 then

		FOR c IN(
		  SELECT a.user_id user_id
		    FROM gipi_parhist a,gipi_polbasic b
			 WHERE a.par_id     = b.par_id
			   AND a.parstat_cd = '10'
			   AND b.policy_id  = p_par_id)
		LOOP
			v_user:=c.user_id;
		END LOOP;
	  for a in (
	  	SELECT b.par_id,b.user_id user2,b.PARSTAT_DATE
	    	FROM gipi_polbasic a, gipi_parhist b
	   	 WHERE a.par_id = b.par_id
	     	 AND a.policy_id = p_par_id
	       AND b.PARSTAT_DATE = (SELECT MIN(b.PARSTAT_DATE)
	                               FROM gipi_polbasic a, gipi_parhist b
	                              WHERE a.par_id = b.par_id
	                                AND a.policy_id = p_par_id))
	  loop
	  	v_user_create := a.user2;
	  end loop;
	else
			FOR c IN(
		  SELECT a.user_id user_id
		    FROM gipi_parhist a,gipi_parlist b
			 WHERE a.par_id     = b.par_id
			   AND a.parstat_cd = '10'
			   AND b.par_id  = p_par_id)
		LOOP
			v_user:=c.user_id;
		END LOOP;
	  for a in (
	  	SELECT b.par_id,b.user_id user2,b.PARSTAT_DATE
	    	FROM gipi_parlist a, gipi_parhist b
	   	 WHERE a.par_id = b.par_id
	     	 AND a.par_id = p_par_id
	       AND b.PARSTAT_DATE = (SELECT MIN(b.PARSTAT_DATE)
	                               FROM gipi_parlist a, gipi_parhist b
	                              WHERE a.par_id = b.par_id
	                                AND a.par_id = p_par_id))
	  loop
	  	v_user_create := a.user2;
	  end loop;
	end if;
	RETURN(v_user_create|| chr(10) ||TO_CHAR(SYSDATE,'DD-MON-RR')||' '||TO_CHAR(SYSDATE,'HH24:MI:SS'));
  END;

  function CF_BASIC_TSI_SPELL(p_extract_id			  GIXX_POLBASIC.extract_id%TYPE,
  		   					  p_basic_co_insurance_sw GIXX_POLBASIC.co_insurance_sw%TYPE)
    return varchar2 is
	v_currency_desc		VARCHAR2(400);
	v_short_name			giis_currency.short_name%type;
	v_short_name2			giis_currency.short_name%type;
	v_tsi 					varchar2(400);
	v_num2 					varchar2(400);
	v_tsi2 					varchar2(400);
	v_num 					varchar2(400);
	v_tsi_spell				varchar2(500);
	v_rate					gixx_item.currency_rt%TYPE := 1;
    v_cents           number;
  BEGIN
     FOR a IN (
			       SELECT DECODE(nvl(b.policy_currency, 'N'),'Y',a.currency_desc) currency_desc,
				    				DECODE(nvl(b.policy_currency, 'N'),'Y',a.short_name)    short_name,
				    				b.policy_currency
			         FROM giis_currency a,
			        	 	  gixx_invoice b
			        WHERE a.main_currency_cd = b.currency_cd
			          AND b.extract_id       = p_extract_id)
			     LOOP
			       v_currency_desc := ' IN '||a.currency_desc;
			       v_short_name    := a.short_name;
			       IF a.policy_currency = 'Y' THEN
				        FOR b IN (
						      SELECT currency_rt
						        FROM gixx_item
						       WHERE extract_id = p_extract_id)
						    LOOP
						      v_rate := b.currency_rt;
						    END LOOP;
				      EXIT;
			       END IF;
				   END LOOP;
			     IF v_currency_desc = ' IN ' OR v_currency_desc IS NULL THEN
			    	  FOR b IN (
			    	    SELECT currency_desc,
			    	           short_name
				          FROM giis_currency
				         WHERE short_name IN ( SELECT param_value_v
				                                 FROM giac_parameters
				                                WHERE param_name = 'DEFAULT_CURRENCY'))
				      LOOP
			  			 	v_short_name    := b.short_name;
			  			 	v_currency_desc := ' IN '||b.currency_desc;
			  				EXIT;
				      END LOOP;
			     END IF;
			  v_short_name2 := v_short_name;
	 IF p_basic_co_insurance_sw <> 2 THEN
		  FOR c IN (
		      SELECT LTRIM (trunc(((a.tsi_amt/v_rate)-TRUNC (a.tsi_amt/v_rate))*100) ) cents
			   	FROM gixx_polbasic a
			   WHERE a.extract_id = p_extract_id)
		  LOOP
			v_cents := c.cents;
			EXIT;
		  END LOOP;
			IF v_cents = 0 AND NVL(MN_POLICY_DOC_PKG.PRINT_CENTS,'N') = 'N' THEN												-- print 'value/cents' when value is not = 0
			  FOR c IN (
			      SELECT UPPER( dh_util.spell ( TRUNC ( a.tsi_amt/v_rate)  )	) tsi,
					     DECODE(MN_POLICY_DOC_PKG.PRINT_SHORT_NAME,'Y',v_short_name2||' ')||LTRIM ( RTRIM ( TO_CHAR ( a.tsi_amt/v_rate  , '999,999,999,999,990.00' ) ) ) tsi_num,
					     UPPER( dh_util.spell ( TRUNC ( a.ann_tsi_amt/v_rate)  )	) tsi2,
					     DECODE(MN_POLICY_DOC_PKG.PRINT_SHORT_NAME,'Y',v_short_name2||' ')||LTRIM ( RTRIM ( TO_CHAR ( a.ann_tsi_amt/v_rate  , '999,999,999,999,990.00' ) ) ) tsi_num2
				    FROM gixx_polbasic a
				   WHERE a.extract_id = p_extract_id)
			  LOOP
				v_tsi  := c.tsi;
				v_num  := c.tsi_num;
				v_tsi2 := c.tsi2;
				v_num2 := c.tsi_num2;
				EXIT;
			  END LOOP;
			ELSIF NVL(MN_POLICY_DOC_PKG.PRINT_CENTS,'N') = 'Y' THEN
				FOR c IN (
				    SELECT UPPER( dh_util.spell ( TRUNC ( a.tsi_amt/v_rate)  )
					    	  ||	' AND '|| LTRIM (round(((a.tsi_amt/v_rate)-TRUNC (a.tsi_amt/v_rate))*100)) ||'/100 ' ) tsi,
					    	  DECODE(MN_POLICY_DOC_PKG.PRINT_SHORT_NAME,'Y',v_short_name2||' ')||LTRIM ( RTRIM ( TO_CHAR ( a.tsi_amt/v_rate  , '999,999,999,999,990.00' ) ) ) tsi_num,
					    	  UPPER( dh_util.spell ( TRUNC ( a.ann_tsi_amt/v_rate)  )
					    	  ||' AND '|| LTRIM (round(((a.ann_tsi_amt/v_rate)-TRUNC (a.ann_tsi_amt/v_rate))*100)) ||'/100 ' ) tsi2,
					    	  DECODE(MN_POLICY_DOC_PKG.PRINT_SHORT_NAME,'Y',v_short_name2||' ')||LTRIM ( RTRIM ( TO_CHAR ( a.ann_tsi_amt/v_rate  , '999,999,999,999,990.00' ) ) ) tsi_num2
					  FROM gixx_polbasic a
					 WHERE a.extract_id = p_extract_id)
				 LOOP
					v_tsi  := c.tsi;
					v_num  := c.tsi_num;
					v_tsi2 := c.tsi2;
					v_num2 := c.tsi_num2;
					EXIT;
				 END LOOP;
			 ELSE																																				-- will not print 'value/cents'
				 FOR c IN (
				    SELECT UPPER( dh_util.spell ( TRUNC ( a.tsi_amt/v_rate)  )
						   || DECODE(LTRIM (round/*trunc*/(((a.tsi_amt/v_rate)-TRUNC (a.tsi_amt/v_rate))*100)),0,'',
						   ' AND '|| LTRIM (round/*trunc*/(((a.tsi_amt/v_rate)-TRUNC (a.tsi_amt/v_rate))*100)) ||'/100' )) tsi,
						   DECODE(MN_POLICY_DOC_PKG.PRINT_SHORT_NAME,'Y',v_short_name2||' ')||LTRIM ( RTRIM ( TO_CHAR ( a.tsi_amt/v_rate  , '999,999,999,999,990.00' ) ) ) tsi_num,
						   UPPER( dh_util.spell ( TRUNC ( a.ann_tsi_amt/v_rate)  )
						   || DECODE(LTRIM (round/*trunc*/(((a.ann_tsi_amt/v_rate)-TRUNC (a.ann_tsi_amt/v_rate))*100)),0,'',
						   ' AND '|| LTRIM (round/*trunc*/(((a.ann_tsi_amt/v_rate)-TRUNC (a.ann_tsi_amt/v_rate))*100)) ||'/100' )) tsi2, --Connie 02/22/2007, to not print 0/100 on tsi
						   DECODE(MN_POLICY_DOC_PKG.PRINT_SHORT_NAME,'Y',v_short_name2||' ')||LTRIM ( RTRIM ( TO_CHAR ( a.ann_tsi_amt/v_rate  , '999,999,999,999,990.00' ) ) ) tsi_num2
					  FROM gixx_polbasic a
					 WHERE a.extract_id = p_extract_id)
				 LOOP
					v_tsi  := c.tsi;
					v_num  := c.tsi_num;
					v_tsi2 := c.tsi2;
					v_num2 := c.tsi_num2;
					EXIT;
				 END LOOP;
			 END IF;
			  IF MN_POLICY_DOC_PKG.DISPLAY_ANN_TSI = 'Y' THEN
			  	RETURN ( v_tsi2||v_currency_desc||' ('||v_short_name||' '||v_num2||')');
			  ELSE
				RETURN ( v_tsi||v_currency_desc||' ('||v_short_name||' '||v_num||')');
			  END IF;
	ELSE
		FOR x IN (SELECT ltrim(trunc((SUM(DECODE(NVL(c.policy_currency,'N'),'Y',co.co_ri_tsi_amt,co.co_ri_tsi_amt*c.currency_rt))
	                   - trunc(SUM(DECODE(NVL(c.policy_currency,'N'),'Y',co.co_ri_tsi_amt,co.co_ri_tsi_amt*c.currency_rt)))) * 100)) cents
	              FROM gixx_co_insurer co, giis_reinsurer re,gixx_invoice c,gixx_polbasic d
	             WHERE co.co_ri_cd   = re.ri_cd
	               AND c.extract_id  = co.extract_id
	               AND co.extract_id = p_extract_id
		             AND co.extract_id = d.extract_id)
		LOOP
			v_cents := x.cents;
			EXIT;
		END LOOP;
		IF v_cents = 0 AND NVL(MN_POLICY_DOC_PKG.PRINT_CENTS,'N') = 'N' THEN 									-- print 'value/cents' when value is not = 0
		   FOR y IN (SELECT UPPER(dh_util.spell(SUM(DECODE(NVL(c.policy_currency,'N'),'Y',co.co_ri_tsi_amt,co.co_ri_tsi_amt*c.currency_rt)))) tsi,
						    	      DECODE(MN_POLICY_DOC_PKG.PRINT_SHORT_NAME,'Y',v_short_name2||' ')||LTRIM ( RTRIM (TO_CHAR (SUM(DECODE(NVL(c.policy_currency,'N'),'Y',co.co_ri_tsi_amt,co.co_ri_tsi_amt*c.currency_rt)), '999,999,999,999,990.00' ))) tsi_num
						    	 FROM gixx_co_insurer co, giis_reinsurer re,gixx_invoice c,gixx_polbasic d
	                WHERE co.co_ri_cd   = re.ri_cd
	                  AND c.extract_id  = co.extract_id
	                  AND co.extract_id = p_extract_id
		                AND co.extract_id = d.extract_id)
		   LOOP
					v_tsi  := y.tsi;
					v_num  := y.tsi_num;
					EXIT;
		   END LOOP;
				ELSIF NVL(MN_POLICY_DOC_PKG.PRINT_CENTS,'N') = 'Y' THEN
				  FOR c IN (
				    SELECT UPPER( dh_util.spell ( TRUNC ( a.tsi_amt/v_rate)  )
						   ||	' AND '|| LTRIM (round(((a.tsi_amt/v_rate)-TRUNC (a.tsi_amt/v_rate))*100)) ||'/100 ' ) tsi,
						   DECODE(MN_POLICY_DOC_PKG.PRINT_SHORT_NAME,'Y',v_short_name2||' ')||LTRIM ( RTRIM ( TO_CHAR ( a.tsi_amt/v_rate  , '999,999,999,999,990.00' ) ) ) tsi_num,
						   UPPER( dh_util.spell ( TRUNC ( a.ann_tsi_amt/v_rate)  )
						   ||' AND '|| LTRIM (round(((a.ann_tsi_amt/v_rate)-TRUNC (a.ann_tsi_amt/v_rate))*100)) ||'/100 ' ) tsi2,
						   DECODE(MN_POLICY_DOC_PKG.PRINT_SHORT_NAME,'Y',v_short_name2||' ')||LTRIM ( RTRIM ( TO_CHAR ( a.ann_tsi_amt/v_rate  , '999,999,999,999,990.00' ) ) ) tsi_num2
					  FROM gixx_polbasic a
					 WHERE a.extract_id = p_extract_id)
				  LOOP
					v_tsi  := c.tsi;
					v_num  := c.tsi_num;
					v_tsi2 := c.tsi2;
					v_num2 := c.tsi_num2;
					EXIT;
				  END LOOP;
		 ELSE
			FOR y IN (SELECT dh_util.spell(SUM(DECODE(NVL(c.policy_currency,'N'),'Y',co.co_ri_tsi_amt,co.co_ri_tsi_amt*c.currency_rt)))
		                   || DECODE(LTRIM (ROUND((SUM(DECODE(NVL(c.policy_currency,'N'),'Y',co.co_ri_tsi_amt,co.co_ri_tsi_amt*c.currency_rt))
	                        - TRUNC(SUM(DECODE(NVL(c.policy_currency,'N'),'Y',co.co_ri_tsi_amt,co.co_ri_tsi_amt*c.currency_rt)))) * 100) ),0,'',
	                        ' AND '|| LTRIM (ROUND((SUM(DECODE(NVL(c.policy_currency,'N'),'Y',co.co_ri_tsi_amt,co.co_ri_tsi_amt*c.currency_rt))
	                        - TRUNC(SUM(DECODE(NVL(c.policy_currency,'N'),'Y',co.co_ri_tsi_amt,co.co_ri_tsi_amt*c.currency_rt)))) * 100) ||'/100' )) tsi,
		                   DECODE(MN_POLICY_DOC_PKG.PRINT_SHORT_NAME,'Y',v_short_name2||' ')||LTRIM ( RTRIM (TO_CHAR (SUM(DECODE(NVL(c.policy_currency,'N'),'Y',co.co_ri_tsi_amt,co.co_ri_tsi_amt*c.currency_rt)), '999,999,999,999,990.00' ))) tsi_num
	                FROM gixx_co_insurer co, giis_reinsurer re,gixx_invoice c,gixx_polbasic d
	               WHERE co.co_ri_cd   = re.ri_cd
	                 AND c.extract_id  = co.extract_id
	                 AND co.extract_id = p_extract_id
		               AND co.extract_id = d.extract_id)
			LOOP
					v_tsi  := y.tsi;
					v_num  := y.tsi_num;
				EXIT;
		  END LOOP;
		 END IF;
		 RETURN ( v_tsi||v_currency_desc||' ('||v_short_name||' '||v_num||')');
	END IF;
  end CF_BASIC_TSI_SPELL;

  function CF_DASH(p_report_title	VARCHAR2)
    return VARCHAR2 is
	v_length varchar2(100):= NULL;
	v_count  number(2);
  begin
	 v_count := LENGTH(p_report_title);
	 IF v_count IS NOT NULL THEN
	 	FOR a IN 1..v_count loop
	   	 	v_length := '-'||v_length;
	     	end loop;
	 END IF;
	     return (v_length);
  END CF_DASH;

  function CF_policy_id_0(p_par_id		gixx_polbasic.par_id%TYPE)
    return Number is
	  v_pol_id  gipi_polbasic.policy_id%TYPE;
  BEGIN
    FOR a IN
	    (SELECT line_cd, subline_cd, iss_cd,
	            issue_yy, pol_seq_no, renew_no
	       FROM gipi_polbasic
	      WHERE policy_id = p_par_id)
	  LOOP
	    BEGIN
	  	  SELECT policy_id
	  	    INTO v_pol_id
	  	    FROM gipi_polbasic
	  	   WHERE line_cd     = a.line_cd
	  	     AND subline_cd  = a.subline_cd
	  	     AND iss_cd      = a.iss_cd
	  	     AND issue_yy    = a.issue_yy
	  	     AND pol_seq_no  = a.pol_seq_no
	  	     AND renew_no    = a.renew_no
	  	     AND endt_seq_no = 0;
	    EXCEPTION
	      WHEN NO_DATA_FOUND THEN
	        v_pol_id := 0;
	    END;
	    EXIT;
	  END LOOP;
	  RETURN(v_pol_id);
  END;

  function CF_MORTGAGEE_TITLE(p_extract_id			  GIXX_POLBASIC.extract_id%TYPE)
    return VARCHAR2 is
	v_count	NUMBER:=0;
  begin
	SELECT count(extract_id)
	  INTO v_count
	  FROM gixx_mortgagee
	 WHERE extract_id = p_extract_id;
	 IF MN_POLICY_DOC_PKG.PRINT_NULL_MORTGAGEE = 'Y'  AND v_count = 0 THEN
	   RETURN ('Mortgagee   : None');
	 ELSE
	   RETURN ('Mortgagee   :');
	 END IF;
  end;

  PROCEDURE Initialize_Variables (p_report_id IN VARCHAR2)
	IS
	BEGIN
		FOR REPORT IN (
			SELECT TITLE,TEXT
              FROM GIIS_DOCUMENT
             WHERE report_id = p_report_id)
		LOOP
			IF REPORT.TITLE = 'POLICY_POLICY_TITLE' THEN
     		   MN_POLICY_DOC_PKG.PAR_POLICY := REPORT.TEXT;
      		ELSIF REPORT.TITLE = 'ENDT_PAR_TITLE' THEN
     		   MN_POLICY_DOC_PKG.ENDT_PAR := REPORT.TEXT;
      		ELSIF REPORT.TITLE = 'ENDT_POLICY_TITLE' THEN
     		   MN_POLICY_DOC_PKG.ENDT_POLICY := REPORT.TEXT;
      		ELSIF REPORT.TITLE = 'POLICY_PAR_TITLE' THEN
     		   MN_POLICY_DOC_PKG.PAR_PAR := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'DOC_TAX_BREAKDOWN' THEN
     		   MN_POLICY_DOC_PKG.TAX_BREAKDOWN := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'PRINT_CURRENCY_DESC' THEN
     		   MN_POLICY_DOC_PKG.PRINT_CURRENCY_DESC := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'PRINT_REF_POL_NO' THEN
     		   MN_POLICY_DOC_PKG.PRINT_REF_POL_NO := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'PRINT_MORTGAGEE' THEN
     		   MN_POLICY_DOC_PKG.PRINT_MORTGAGEE := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'PRINT_ITEM_TOTAL' THEN
     		   MN_POLICY_DOC_PKG.PRINT_ITEM_TOTAL := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'PRINT_PERIL' THEN
     		   MN_POLICY_DOC_PKG.PRINT_PERIL := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'PRINT_RENEWAL_TOP' THEN
     		   MN_POLICY_DOC_PKG.PRINT_RENEWAL_TOP := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'PRINT_DOC_SUBTITLE1' THEN
     		   MN_POLICY_DOC_PKG.PRINT_DOC_SUBTITLE1 := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'PRINT_DEDUCTIBLES' THEN
     		   MN_POLICY_DOC_PKG.PRINT_DEDUCTIBLES := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'PRINT_DOC_SUBTITLE2' THEN
     		   MN_POLICY_DOC_PKG.PRINT_DOC_SUBTITLE2 := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'PRINT_DOC_SUBTITLE3' THEN
     		   MN_POLICY_DOC_PKG.PRINT_DOC_SUBTITLE3 := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'PRINT_DOC_SUBTITLE4' THEN
     		   MN_POLICY_DOC_PKG.PRINT_DOC_SUBTITLE4 := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'PRINT_ACCESSORIES_ABOVE' THEN
	     		MN_POLICY_DOC_PKG.PRINT_ACCESSORIES_ABOVE := REPORT.TEXT;
	     	ELSIF REPORT.TITLE = 'PRINT_WARRANTIES_FONT_BIG' THEN
     		   MN_POLICY_DOC_PKG.PRINT_WRRNTIES_FONTBIG := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'PRINT_ALL_WARRANTIES_TITLE_ABOVE' THEN
     		   MN_POLICY_DOC_PKG.PRINT_ALL_WARRANTIES := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'PRINT_LAST_ENDTXT' THEN
     		   MN_POLICY_DOC_PKG.PRINT_LAST_ENDTXT := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'PRINT_SUB_INFO' THEN
     		   MN_POLICY_DOC_PKG.PRINT_SUB_INFO := REPORT.TEXT;
			ELSIF REPORT.TITLE = 'DOC_TAX_BREAKDOWN' THEN
     		   MN_POLICY_DOC_PKG.DOC_TAX_BREAKDOWN := REPORT.TEXT;
			ELSIF REPORT.TITLE = 'PRINT_PREMIUM_RATE' THEN
     		   MN_POLICY_DOC_PKG.PRINT_PREMIUM_RATE := REPORT.TEXT;
			ELSIF REPORT.TITLE = 'PRINT_MORT_AMT' THEN
     		   MN_POLICY_DOC_PKG.PRINT_MORT_AMT := REPORT.TEXT;
			ELSIF REPORT.TITLE = 'PRINT_SUM_INSURED' THEN
     		   MN_POLICY_DOC_PKG.PRINT_SUM_INSURED := REPORT.TEXT;
			ELSIF REPORT.TITLE = 'PRINT_ONE_ITEM_TITLE' THEN
     		   MN_POLICY_DOC_PKG.PRINT_ONE_ITEM_TITLE := REPORT.TEXT;
			ELSIF REPORT.TITLE = 'PRINT_REPORT_TITLE' THEN
     		   MN_POLICY_DOC_PKG.PRINT_REPORT_TITLE := REPORT.TEXT;
			ELSIF REPORT.TITLE = 'PRINT_INTM_NAME' THEN
     		   MN_POLICY_DOC_PKG.PRINT_INTM_NAME := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'DOC_TOTAL_IN_BOX' THEN
	     	   MN_POLICY_DOC_PKG.DOC_TOTAL_IN_BOX := REPORT.TEXT;
	     	ELSIF REPORT.TITLE = 'DOC_SUBTITLE1' THEN
     		   MN_POLICY_DOC_PKG.DOC_SUBTITLE1  := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'DOC_SUBTITLE2' THEN
     		   MN_POLICY_DOC_PKG.DOC_SUBTITLE2  := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'DOC_SUBTITLE3' THEN
     		   MN_POLICY_DOC_PKG.DOC_SUBTITLE3  := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'DOC_SUBTITLE4' THEN
     		   MN_POLICY_DOC_PKG.DOC_SUBTITLE4  := REPORT.TEXT;
			ELSIF REPORT.TITLE = 'DOC_SUBTITLE4_BEFORE_WC' THEN
     		   MN_POLICY_DOC_PKG.DOC_SUBTITLE4_BEFORE_WC  := REPORT.TEXT;
			ELSIF REPORT.TITLE = 'DEDUCTIBLE_TITLE' THEN
     		   MN_POLICY_DOC_PKG.DEDUCTIBLE_TITLE  := REPORT.TEXT;
			ELSIF REPORT.TITLE = 'PERIL_TITLE' THEN
     		   MN_POLICY_DOC_PKG.PERIL_TITLE  := REPORT.TEXT;
			ELSIF REPORT.TITLE = 'ITEM_TITLE' THEN
     		   MN_POLICY_DOC_PKG.ITEM_TITLE  := REPORT.TEXT;
			ELSIF REPORT.TITLE = 'SUM_INSURED_TITLE' THEN
     		   MN_POLICY_DOC_PKG.SUM_INSURED_TITLE  := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'PRINT_UPPER_CASE' THEN
     		   MN_POLICY_DOC_PKG.PRINT_UPPER_CASE  := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'PRINT_GROUPED_BENEFICIARY' THEN
     		   MN_POLICY_DOC_PKG.PRINT_GROUPED_BENEFICIARY := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'PRINT_ALL_WARRANTIES' THEN
     		   MN_POLICY_DOC_PKG.PRINT_ALL_WARRANTIES  := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'PRINT_DEDUCTIBLES_TEXT_AMT' THEN
     		   MN_POLICY_DOC_PKG.PRINT_DEDUCT_TEXT_AMT  := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'PERSONNEL_ITEM_TITLE' THEN
     		   MN_POLICY_DOC_PKG.PERSONNEL_ITEM_TITLE  := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'GROUPED_ITEM_TITLE' THEN
     		   MN_POLICY_DOC_PKG.GROUPED_ITEM_TITLE  := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'PERSONNEL_SUBTITLE1' THEN
     		   MN_POLICY_DOC_PKG.PERSONNEL_SUBTITLE1  := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'PERSONNEL_SUBTITLE2' THEN
     		   MN_POLICY_DOC_PKG.PERSONNEL_SUBTITLE2  := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'GROUPED_SUBTITLE' THEN
     		   MN_POLICY_DOC_PKG.GROUPED_SUBTITLE  := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'ATTESTATION_TITLE' THEN
     		   MN_POLICY_DOC_PKG.ATTESTATION_TITLE  := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'DOC_ATTESTATION1' THEN
     		   MN_POLICY_DOC_PKG.DOC_ATTESTATION1  := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'DOC_ATTESTATION2' THEN
     		   MN_POLICY_DOC_PKG.DOC_ATTESTATION2 := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'PRINT_CARGO_DESC' THEN
     		   MN_POLICY_DOC_PKG.PRINT_CARGO_DESC := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'PRINT_SHORT_NAME' THEN
     		   MN_POLICY_DOC_PKG.PRINT_SHORT_NAME := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'PRINT_NULL_MORTGAGEE' THEN
     		   MN_POLICY_DOC_PKG.PRINT_NULL_MORTGAGEE := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'DISPLAY_POLICY_TERM' THEN  --yvette.10132004
     		   MN_POLICY_DOC_PKG.DISPLAY_POLICY_TERM := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'PRINT_TIME' THEN  --ging02162006@FLT
     		   MN_POLICY_DOC_PKG.PRINT_TIME  := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'LEASED_TO' THEN  -- created by Rosch, 05222006
     		   MN_POLICY_DOC_PKG.LEASED_TO  := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'PRINT_CENTS' THEN  -- created by Rosch, 05222006
     		   MN_POLICY_DOC_PKG.PRINT_CENTS  := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'PRINT_DED_TEXT_PERIL' THEN  -- created by Rosch, 05222006
     		   MN_POLICY_DOC_PKG.PRINT_DED_TEXT_PERIL  := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'LINE_HIDDEN' THEN  -- ging 071806
     		   MN_POLICY_DOC_PKG.HIDE_LINE  := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'PRINT_MOP_WORDINGS' THEN  -- ging 073106
     		   MN_POLICY_DOC_PKG.PRINT_MOP_WORDINGS  := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'PRINT_MOP_DEDUCTIBLES' THEN  -- ging 073106
     		   MN_POLICY_DOC_PKG.PRINT_MOP_DEDUCTIBLES  := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'MOP_WORDINGS' THEN  -- ging 073106
     		   MN_POLICY_DOC_PKG.MOP_WORDINGS  := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'MRN_WORDINGS' THEN  -- ging 073106
     		   MN_POLICY_DOC_PKG.MRN_WORDINGS  := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'MAR_WORDINGS' THEN  -- ging 073106
     		   MN_POLICY_DOC_PKG.MAR_WORDINGS  := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'PRINT_SURVEY_SETTLING_AGENT' THEN  -- ging 080106
     		   MN_POLICY_DOC_PKG.PRINT_SURVEY_SETTLING_AGENT  := REPORT.TEXT;
      		ELSIF REPORT.TITLE = 'SURVEY_WORDINGS' THEN  -- ging 080106
     		   MN_POLICY_DOC_PKG.SURVEY_WORDINGS  := REPORT.TEXT;
      		ELSIF REPORT.TITLE = 'PRINT_COVERAGE_RATE' THEN  -- ging 080206
     		   MN_POLICY_DOC_PKG.PRINT_COVERAGE_RATE  := REPORT.TEXT;
      		ELSIF REPORT.TITLE = 'WITHOUT_ITEM_NO' THEN  -- ging 080206
     		   MN_POLICY_DOC_PKG.WITHOUT_ITEM_NO  := REPORT.TEXT;
      		ELSIF REPORT.TITLE = 'PRINT_ORIGIN_DEST_ABOVE' THEN  -- ging 080206
     		   MN_POLICY_DOC_PKG.PRINT_ORIGIN_DEST_ABOVE  := REPORT.TEXT;
      		ELSIF REPORT.TITLE = 'PRINT_MOP_NO_ABOVE' THEN  -- ging 080206
     		   MN_POLICY_DOC_PKG.PRINT_MOP_NO_ABOVE  := REPORT.TEXT;
      		ELSIF REPORT.TITLE = 'PAR_ENDT_HEADER' THEN  -- ging 080306
     		   MN_POLICY_DOC_PKG.PAR_ENDT_HEADER  := REPORT.TEXT;
      		ELSIF REPORT.TITLE = 'PRINT_GEN_INFO_ABOVE' THEN  -- ging 080306
     		   MN_POLICY_DOC_PKG.PRINT_GEN_INFO_ABOVE  := REPORT.TEXT;
      		ELSIF REPORT.TITLE = 'ALL_SUBLINE_WORDINGS1' THEN  -- ging 080806
     		   MN_POLICY_DOC_PKG.ALL_SUBLINE_WORDINGS1  := REPORT.TEXT;
       		ELSIF REPORT.TITLE = 'ALL_SUBLINE_WORDINGS2' THEN  -- ging 080806
     		   MN_POLICY_DOC_PKG.ALL_SUBLINE_WORDINGS2  := REPORT.TEXT;
      		ELSIF REPORT.TITLE = 'MARINE_CO_INSURANCE' THEN  -- ging 081106
     		   MN_POLICY_DOC_PKG.MARINE_CO_INSURANCE  := REPORT.TEXT;
      		ELSIF REPORT.TITLE = 'PACK_METHOD' THEN  -- ging 081106
     		   MN_POLICY_DOC_PKG.PACK_METHOD  := REPORT.TEXT;
      		ELSIF REPORT.TITLE = 'PRINT_DECLARATION_NO' THEN  -- ging 081406
     		   MN_POLICY_DOC_PKG.PRINT_DECLARATION_NO  := REPORT.TEXT;
      		ELSIF REPORT.TITLE = 'DISPLAY_ANN_TSI' THEN  -- ging 081406
     		   MN_POLICY_DOC_PKG.DISPLAY_ANN_TSI  := REPORT.TEXT;
      		ELSIF REPORT.TITLE = 'MOP_MAP_WORDINGS' THEN  -- ging 082906
     		   MN_POLICY_DOC_PKG.MOP_MAP_WORDINGS  := REPORT.TEXT;
      		ELSIF REPORT.TITLE = 'SURVEY_TITLE' THEN  -- ging 110706
     		   MN_POLICY_DOC_PKG.SURVEY_TITLE  := REPORT.TEXT;
      		ELSIF REPORT.TITLE = 'PRINT_OPEN_RISK' THEN  -- ging 111706
     		   MN_POLICY_DOC_PKG.PRINT_OPEN_RISK  := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'POLICY_TITLE_RISK' THEN  -- ging 111706
     		   MN_POLICY_DOC_PKG.POLICY_TITLE_RISK  := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'POLICY_TITLE_OPEN' THEN  -- ging 111706
     		   MN_POLICY_DOC_PKG.POLICY_TITLE_OPEN  := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'PRINT_ZERO_PREMIUM' THEN --abe04.28.2007
     		   MN_POLICY_DOC_PKG.PRINT_ZERO_PREMIUM := REPORT.TEXT;
      		ELSIF REPORT.TITLE = 'DISPLAY_REF_POL_NO' THEN --vj 072507
     		   MN_POLICY_DOC_PKG.DISPLAY_REF_POL_NO := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'PRINT_LOWER_DTLS' THEN		--allan 031308
     		   MN_POLICY_DOC_PKG.PRINT_LOWER_DTLS  := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'PRINT_POLNO_ENDT' THEN
     		   MN_POLICY_DOC_PKG.PRINT_POLNO_ENDT  := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'TSI_LABEL1' THEN
     		   MN_POLICY_DOC_PKG.TSI_LABEL1  := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'TSI_LABEL2' THEN
     		   MN_POLICY_DOC_PKG.TSI_LABEL2  := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'INCLUDE_TSI' THEN
     		   MN_POLICY_DOC_PKG.INCLUDE_TSI  := REPORT.TEXT;
     		ELSIF REPORT.TITLE = 'SUM_INSURED_TITLE2' THEN
     		   MN_POLICY_DOC_PKG.SUM_INSURED_TITLE2  := REPORT.TEXT;
    		ELSIF REPORT.TITLE = 'POLICY_SIGLABEL' THEN
   			   MN_POLICY_DOC_PKG.POLICY_SIGLABEL := REPORT.TEXT;
    		ELSIF REPORT.TITLE = 'PRINT_AUTHORIZED_SIGNATORY' THEN
   			   MN_POLICY_DOC_PKG.PRINT_AUTHORIZED_SIGNATORY := REPORT.TEXT;
    		ELSIF REPORT.TITLE = 'PRINT_DEDUCTIBLE_RT' THEN
   			   MN_POLICY_DOC_PKG.PRINT_DEDUCTIBLE_RT := REPORT.TEXT; --ADDED BY APRIL 12/22/2008
    		ELSIF REPORT.TITLE = 'PRINT_DEDUCTIBLE_AMT' THEN  -- added by petermkaw 11202009
     		   MN_POLICY_DOC_PKG.PRINT_DEDUCTIBLE_AMT  := REPORT.TEXT;
			END IF;
		END LOOP;
	END Initialize_Variables;

END MN_POLICY_DOC_PKG;
/


