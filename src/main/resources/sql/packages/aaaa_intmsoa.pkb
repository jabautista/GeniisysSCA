CREATE OR REPLACE PACKAGE BODY CPI.AAAA_INTMSOA AS
FUNCTION genIntmArrSoa(intm_num IN NUMBER, tag IN NUMBER) RETURN INTM_SOA_ARR
  IS
   WS_INTM_SOA_ARR    INTM_SOA_ARR:= INTM_SOA_ARR();
   BEGIN
     IF tag=0 THEN
	 	FOR i IN   (SELECT f.col_title title, b.line_name,
       		  	   		   DECODE(a.endt_seq_no,0,a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no, '0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09')),
            	   		      a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy, '09'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no, '0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no, '09'))||'-' ||a.endt_iss_cd||'-'||LTRIM(TO_CHAR(a.endt_yy, '09'))||'-'||LTRIM(TO_CHAR(a.endt_seq_no, '099999'))) POLICY,
	   						  h.assd_name,
							  c.ISS_CD||'-'||LTRIM(TO_CHAR(c.PREM_SEQ_NO, '099999999999'))||'-'||c.inst_no invoice,
	   						  TO_CHAR(d.due_date,'MM-DD-YYYY') due_date,DECODE(c.BALANCE_AMT_DUE,'0',RTRIM(TO_CHAR(c.BALANCE_AMT_DUE,'0D09')),RTRIM(TO_CHAR(c.BALANCE_AMT_DUE,'999G999G999G999D09'))) balance2,c.BALANCE_AMT_DUE balance, e.rep_col_no
  							  FROM GIPI_POLBASIC a,
       						  GIAC_AGING_SOA_DETAILS c,
	   						  GIPI_INSTALLMENT d,
	   						  GIIS_LINE b,
							  GIAC_AGING_PARAMETERS e,
	   						  GIAC_SOA_TITLE f,
 							  GIPI_COMM_INVOICE g,
							  GIIS_ASSURED h
							  WHERE a.Line_cd=b.line_cd
   							  AND a.assd_no=h.assd_no
							  AND a.policy_id=c.policy_id
   							  AND d.ISS_CD=c.iss_cd
   							  AND d.PREM_SEQ_NO=c.PREM_SEQ_NO
   							  AND d.INST_NO=c.inst_no
   							  AND e.AGING_ID=c.GAGP_AGING_ID
   							  AND e.REP_COL_NO=f.col_no
   							  AND f.rep_cd=1
   							  AND d.due_date <= SYSDATE
 							  AND g.POLICY_ID=a.POLICY_ID
							  AND g.iss_cd=c.iss_cd
							  AND g.prem_seq_no=c.prem_seq_no
							  AND g.intrmdry_intm_no=intm_num
							  AND c.balance_amt_due<>0
							  ORDER BY e.rep_col_no DESC, POLICY,due_date)
	 LOOP
      	WS_INTM_SOA_ARR.EXTEND;
      	WS_INTM_SOA_ARR(WS_INTM_SOA_ARR.COUNT) := INTM_SOA_TYPE(i.title,i.line_name, i.POLICY,i.assd_name ,i.invoice, i.due_date, i.balance2,i.balance);
	 END LOOP;
	END IF;
	IF tag=1 THEN
	 	FOR i IN   (SELECT f.col_title title, b.line_name,
       		  	   		   DECODE(a.endt_seq_no,0,a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no, '0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09')),
            	   		      a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy, '09'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no, '0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no, '09'))||'-' ||a.endt_iss_cd||'-'||LTRIM(TO_CHAR(a.endt_yy, '09'))||'-'||LTRIM(TO_CHAR(a.endt_seq_no, '099999'))) POLICY,
	   						  h.assd_name,
							  c.ISS_CD||'-'||LTRIM(TO_CHAR(c.PREM_SEQ_NO, '099999999999'))||'-'||c.inst_no invoice,
	   						  TO_CHAR(d.due_date,'MM-DD-YYYY') due_date,DECODE(c.BALANCE_AMT_DUE,'0',RTRIM(TO_CHAR(c.BALANCE_AMT_DUE,'0D09')),RTRIM(TO_CHAR(c.BALANCE_AMT_DUE,'999G999G999G999D09'))) balance2,c.BALANCE_AMT_DUE balance, e.rep_col_no
  							  FROM GIPI_POLBASIC a,
       						  GIAC_AGING_SOA_DETAILS c,
	   						  GIPI_INSTALLMENT d,
	   						  GIIS_LINE b,
							  GIAC_AGING_PARAMETERS e,
	   						  GIAC_SOA_TITLE f,
 							  GIPI_COMM_INVOICE g,
							  GIIS_ASSURED h
							  WHERE a.Line_cd=b.line_cd
   							  AND a.assd_no=h.assd_no
							  AND a.policy_id=c.policy_id
   							  AND d.ISS_CD=c.iss_cd
   							  AND d.PREM_SEQ_NO=c.PREM_SEQ_NO
   							  AND d.INST_NO=c.inst_no
   							  AND e.AGING_ID=c.GAGP_AGING_ID
   							  AND e.REP_COL_NO=f.col_no
   							  AND f.rep_cd=1
   							  --AND d.due_date > SYSDATE
 							  AND g.POLICY_ID=a.POLICY_ID
							  AND g.iss_cd=c.iss_cd
							  AND g.prem_seq_no=c.prem_seq_no
							  AND c.balance_amt_due<>0
							  AND g.intrmdry_intm_no=intm_num
							  ORDER BY e.rep_col_no DESC, POLICY,due_date)
	 LOOP
      WS_INTM_SOA_ARR.EXTEND;
      WS_INTM_SOA_ARR(WS_INTM_SOA_ARR.COUNT) := INTM_SOA_TYPE(i.title,i.line_name, i.POLICY,i.assd_name, i.invoice, i.due_date, i.balance2, i.balance);
	 END LOOP;
	END IF;
	IF tag=2 THEN
	 	FOR i IN   (SELECT f.col_title title, b.line_name,
       		  	   		   DECODE(a.endt_seq_no,0,a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no, '0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09')),
            	   		      a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy, '09'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no, '0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no, '09'))||'-' ||a.endt_iss_cd||'-'||LTRIM(TO_CHAR(a.endt_yy, '09'))||'-'||LTRIM(TO_CHAR(a.endt_seq_no, '099999'))) POLICY,
	   						  h.assd_name,
							  c.ISS_CD||'-'||LTRIM(TO_CHAR(c.PREM_SEQ_NO, '099999999999'))||'-'||c.inst_no invoice,
	   						  TO_CHAR(d.due_date,'MM-DD-YYYY') due_date,DECODE(c.BALANCE_AMT_DUE,'0',RTRIM(TO_CHAR(c.BALANCE_AMT_DUE,'0D09')),RTRIM(TO_CHAR(c.BALANCE_AMT_DUE,'999G999G999G999D09'))) balance2,c.BALANCE_AMT_DUE balance
  							  FROM GIPI_POLBASIC a,
       						  GIAC_AGING_SOA_DETAILS c,
	   						  GIPI_INSTALLMENT d,
	   						  GIIS_LINE b,
							  GIAC_AGING_PARAMETERS e,
	   						  GIAC_SOA_TITLE f,
 							  GIPI_COMM_INVOICE g,
							  GIIS_ASSURED h
							  WHERE a.Line_cd=b.line_cd
   							  AND a.assd_no=h.assd_no
							  AND a.policy_id=c.policy_id
   							  AND d.ISS_CD=c.iss_cd
   							  AND d.PREM_SEQ_NO=c.PREM_SEQ_NO
   							  AND d.INST_NO=c.inst_no
   							  AND e.AGING_ID=c.GAGP_AGING_ID
   							  AND e.REP_COL_NO=f.col_no
   							  AND f.rep_cd=1
   							  AND d.due_date <= SYSDATE
 							  AND g.POLICY_ID=a.POLICY_ID
							  AND g.iss_cd=c.iss_cd
							  AND g.prem_seq_no=c.prem_seq_no
							  AND c.balance_amt_due<>0
							  AND g.intrmdry_intm_no=intm_num
							  ORDER BY  line_name,title,POLICY,due_date)
	 LOOP
      WS_INTM_SOA_ARR.EXTEND;
      WS_INTM_SOA_ARR(WS_INTM_SOA_ARR.COUNT) := INTM_SOA_TYPE(i.title,i.line_name, i.POLICY,i.assd_name, i.invoice, i.due_date,  i.balance2,i.balance);
	 END LOOP;
	END IF;
	IF tag=3 THEN
	 	FOR i IN   (SELECT f.col_title title, b.line_name,
       		  	   		   DECODE(a.endt_seq_no,0,a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no, '0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09')),
            	   		      a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy, '09'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no, '0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no, '09'))||'-' ||a.endt_iss_cd||'-'||LTRIM(TO_CHAR(a.endt_yy, '09'))||'-'||LTRIM(TO_CHAR(a.endt_seq_no, '099999'))) POLICY,
	   						  h.assd_name,
							  c.ISS_CD||'-'||LTRIM(TO_CHAR(c.PREM_SEQ_NO, '099999999999'))||'-'||c.inst_no invoice,
	   						  TO_CHAR(d.due_date,'MM-DD-YYYY') due_date,DECODE(c.BALANCE_AMT_DUE,'0',RTRIM(TO_CHAR(c.BALANCE_AMT_DUE,'0D09')),RTRIM(TO_CHAR(c.BALANCE_AMT_DUE,'999G999G999G999D09'))) balance2,c.BALANCE_AMT_DUE balance
  							  FROM GIPI_POLBASIC a,
       						  GIAC_AGING_SOA_DETAILS c,
	   						  GIPI_INSTALLMENT d,
	   						  GIIS_LINE b,
							  GIAC_AGING_PARAMETERS e,
	   						  GIAC_SOA_TITLE f,
 							  GIPI_COMM_INVOICE g,
							  GIIS_ASSURED h
							  WHERE a.Line_cd=b.line_cd
   							  AND a.assd_no=h.assd_no
							  AND a.policy_id=c.policy_id
   							  AND d.ISS_CD=c.iss_cd
   							  AND d.PREM_SEQ_NO=c.PREM_SEQ_NO
   							  AND d.INST_NO=c.inst_no
   							  AND e.AGING_ID=c.GAGP_AGING_ID
   							  AND e.REP_COL_NO=f.col_no
   							  AND f.rep_cd=1
   							  AND g.POLICY_ID=a.POLICY_ID
							  AND g.iss_cd=c.iss_cd
							  AND g.prem_seq_no=c.prem_seq_no
							  AND c.balance_amt_due<>0
							  AND g.intrmdry_intm_no=intm_num
							  ORDER BY  line_name,title,POLICY,due_date)
	 LOOP
      WS_INTM_SOA_ARR.EXTEND;
      WS_INTM_SOA_ARR(WS_INTM_SOA_ARR.COUNT) := INTM_SOA_TYPE(i.title,i.line_name, i.POLICY,i.assd_name, i.invoice, i.due_date, i.balance2, i.balance);
	 END LOOP;
	END IF;
	IF tag=4 THEN
	 	FOR i IN   (SELECT f.col_title title, b.line_name,
       		  	   		   DECODE(a.endt_seq_no,0,a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no, '0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09')),
            	   		      a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy, '09'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no, '0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no, '09'))||'-' ||a.endt_iss_cd||'-'||LTRIM(TO_CHAR(a.endt_yy, '09'))||'-'||LTRIM(TO_CHAR(a.endt_seq_no, '099999'))) POLICY,
	   						  h.assd_name,
							  c.ISS_CD||'-'||LTRIM(TO_CHAR(c.PREM_SEQ_NO, '099999999999'))||'-'||c.inst_no invoice,
	   						  TO_CHAR(d.due_date,'MM-DD-YYYY') due_date,DECODE(c.BALANCE_AMT_DUE,'0',RTRIM(TO_CHAR(c.BALANCE_AMT_DUE,'0D09')),RTRIM(TO_CHAR(c.BALANCE_AMT_DUE,'999G999G999G999D09'))) balance2,c.BALANCE_AMT_DUE balance
  							  FROM GIPI_POLBASIC a,
       						  GIAC_AGING_SOA_DETAILS c,
	   						  GIPI_INSTALLMENT d,
	   						  GIIS_LINE b,
							  GIAC_AGING_PARAMETERS e,
	   						  GIAC_SOA_TITLE f,
 							  GIPI_COMM_INVOICE g,
							  GIIS_ASSURED h
							  WHERE a.Line_cd=b.line_cd
   							  AND a.assd_no=h.assd_no
							  AND a.policy_id=c.policy_id
   							  AND d.ISS_CD=c.iss_cd
   							  AND d.PREM_SEQ_NO=c.PREM_SEQ_NO
   							  AND d.INST_NO=c.inst_no
   							  AND e.AGING_ID=c.GAGP_AGING_ID
   							  AND e.REP_COL_NO=f.col_no
   							  AND f.rep_cd=1
   							  AND d.due_date <= SYSDATE
 							  AND g.POLICY_ID=a.POLICY_ID
							  AND g.iss_cd=c.iss_cd
							  AND g.prem_seq_no=c.prem_seq_no
							  AND c.balance_amt_due<>0
							  AND g.intrmdry_intm_no=intm_num
							  ORDER BY  assd_name,title,b.line_name,POLICY,due_date)
	 LOOP
      WS_INTM_SOA_ARR.EXTEND;
      WS_INTM_SOA_ARR(WS_INTM_SOA_ARR.COUNT) := INTM_SOA_TYPE(i.title,i.line_name, i.POLICY,i.assd_name, i.invoice, i.due_date, i.balance2, i.balance);
	 END LOOP;
	END IF;
	IF tag=5 THEN
	 	FOR i IN   (SELECT f.col_title title, b.line_name,
       		  	   		   DECODE(a.endt_seq_no,0,a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no, '0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09')),
            	   		      a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy, '09'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no, '0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no, '09'))||'-' ||a.endt_iss_cd||'-'||LTRIM(TO_CHAR(a.endt_yy, '09'))||'-'||LTRIM(TO_CHAR(a.endt_seq_no, '099999'))) POLICY,
	   						  h.assd_name,
							  c.ISS_CD||'-'||LTRIM(TO_CHAR(c.PREM_SEQ_NO, '099999999999'))||'-'||c.inst_no invoice,
	   						  TO_CHAR(d.due_date,'MM-DD-YYYY') due_date,DECODE(c.BALANCE_AMT_DUE,'0',RTRIM(TO_CHAR(c.BALANCE_AMT_DUE,'0D09')),RTRIM(TO_CHAR(c.BALANCE_AMT_DUE,'999G999G999G999D09'))) balance2,c.BALANCE_AMT_DUE balance
  							  FROM GIPI_POLBASIC a,
       						  GIAC_AGING_SOA_DETAILS c,
	   						  GIPI_INSTALLMENT d,
	   						  GIIS_LINE b,
							  GIAC_AGING_PARAMETERS e,
	   						  GIAC_SOA_TITLE f,
 							  GIPI_COMM_INVOICE g,
							  GIIS_ASSURED h
							  WHERE a.Line_cd=b.line_cd
   							  AND a.assd_no=h.assd_no
							  AND a.policy_id=c.policy_id
   							  AND d.ISS_CD=c.iss_cd
   							  AND d.PREM_SEQ_NO=c.PREM_SEQ_NO
   							  AND d.INST_NO=c.inst_no
   							  AND e.AGING_ID=c.GAGP_AGING_ID
   							  AND e.REP_COL_NO=f.col_no
   							  AND f.rep_cd=1
   							  AND g.POLICY_ID=a.POLICY_ID
							  AND g.iss_cd=c.iss_cd
							  AND g.prem_seq_no=c.prem_seq_no
							  AND c.balance_amt_due<>0
							  AND g.intrmdry_intm_no=intm_num
							  ORDER BY  assd_name,title,b.line_name,POLICY,due_date)
	 LOOP
      WS_INTM_SOA_ARR.EXTEND;
      WS_INTM_SOA_ARR(WS_INTM_SOA_ARR.COUNT) := INTM_SOA_TYPE(i.title,i.line_name, i.POLICY,i.assd_name, i.invoice, i.due_date, i.balance2, i.balance);
	 END LOOP;
	END IF;
	RETURN WS_INTM_SOA_ARR;
 END;
END;
/


