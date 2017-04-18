CREATE OR REPLACE PACKAGE BODY CPI.wsSoaPackage AS
  FUNCTION genArrSoa(assd_num IN NUMBER, tag IN NUMBER) RETURN WEB_TYPE_ARRAY
  IS
   WS_WEB_TYPE_ARRAY    WEB_TYPE_ARRAY:= WEB_TYPE_ARRAY();
   BEGIN
     IF tag=0 THEN
   FOR i IN   (SELECT f.col_title title, b.line_name,
                    DECODE(a.endt_seq_no,0,a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no, '0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09')),
                        a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy, '09'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no, '0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no, '09'))||'-' ||a.endt_iss_cd||'-'||LTRIM(TO_CHAR(a.endt_yy, '09'))||'-'||LTRIM(TO_CHAR(a.endt_seq_no, '099999'))) POLICY,
            c.ISS_CD||'-'||LTRIM(TO_CHAR(c.PREM_SEQ_NO, '099999999999'))||'-'||c.inst_no invoice,
            TO_CHAR(d.due_date,'MM-DD-YYYY') due_date,DECODE(c.BALANCE_AMT_DUE,'0',RTRIM(TO_CHAR(c.BALANCE_AMT_DUE,'0D09')),RTRIM(TO_CHAR(c.BALANCE_AMT_DUE,'99G999G999D09'))) balance2,c.BALANCE_AMT_DUE balance, e.rep_col_no
           FROM GIPI_POLBASIC a,
               GIIS_LINE b,
            GIAC_AGING_SOA_DETAILS c,
            GIPI_INSTALLMENT d,
            GIAC_AGING_PARAMETERS e,
            GIAC_SOA_TITLE f
          WHERE a.Line_cd=b.line_cd
            AND a.ASSD_NO=assd_num
            AND a.policy_id=c.policy_id
            AND d.ISS_CD=c.iss_cd
            AND d.PREM_SEQ_NO=c.PREM_SEQ_NO
            AND d.INST_NO=c.inst_no
            AND e.AGING_ID=c.GAGP_AGING_ID
            AND e.REP_COL_NO=f.col_no
            AND f.rep_cd=1
            AND c.balance_amt_due <>0
         AND d.due_date <= SYSDATE--TO_DATE('01-01-2003', 'MM-DD-YYYY')
          ORDER BY e.rep_col_no DESC,b.line_name ,POLICY,due_date)
  LOOP
       WS_WEB_TYPE_ARRAY.EXTEND;
       WS_WEB_TYPE_ARRAY(WS_WEB_TYPE_ARRAY.COUNT) := WEB_TYPE(i.title,i.line_name, i.POLICY, i.invoice, i.due_date, i.balance2,i.balance);
  END LOOP;
 END IF;
 IF tag=1 THEN
   FOR i IN   (SELECT f.col_title title, b.line_name,
                    DECODE(a.endt_seq_no,0,a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no, '0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09')),
                        a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy, '09'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no, '0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no, '09'))||'-' ||a.endt_iss_cd||'-'||LTRIM(TO_CHAR(a.endt_yy, '09'))||'-'||LTRIM(TO_CHAR(a.endt_seq_no, '099999'))) POLICY,
            c.ISS_CD||'-'||LTRIM(TO_CHAR(c.PREM_SEQ_NO, '099999999999'))||'-'||c.inst_no invoice,
            TO_CHAR(d.due_date,'MM-DD-YYYY') due_date,DECODE(c.BALANCE_AMT_DUE,'0',RTRIM(TO_CHAR(c.BALANCE_AMT_DUE,'0D09')),RTRIM(TO_CHAR(c.BALANCE_AMT_DUE,'99G999G999D09'))) balance2,c.BALANCE_AMT_DUE balance, e.rep_col_no
           FROM GIPI_POLBASIC a,
               GIIS_LINE b,
            GIAC_AGING_SOA_DETAILS c,
            GIPI_INSTALLMENT d,
            GIAC_AGING_PARAMETERS e,
            GIAC_SOA_TITLE f
          WHERE a.Line_cd=b.line_cd
            AND a.ASSD_NO=assd_num
            AND a.policy_id=c.policy_id
            AND d.ISS_CD=c.iss_cd
            AND d.PREM_SEQ_NO=c.PREM_SEQ_NO
            AND d.INST_NO=c.inst_no
            AND e.AGING_ID=c.GAGP_AGING_ID
            AND e.REP_COL_NO=f.col_no
            AND f.rep_cd=1
            AND c.balance_amt_due <>0
         ORDER BY e.rep_col_no DESC,b.line_name ,POLICY,due_date)
  LOOP
      WS_WEB_TYPE_ARRAY.EXTEND;
      WS_WEB_TYPE_ARRAY(WS_WEB_TYPE_ARRAY.COUNT) := WEB_TYPE(i.title,i.line_name, i.POLICY, i.invoice, i.due_date, i.balance2, i.balance);
  END LOOP;
 END IF;
 IF tag=2 THEN
   FOR i IN   (SELECT f.col_title title, b.line_name,
                    DECODE(a.endt_seq_no,0,a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no, '0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09')),
                        a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy, '09'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no, '0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no, '09'))||'-' ||a.endt_iss_cd||'-'||LTRIM(TO_CHAR(a.endt_yy, '09'))||'-'||LTRIM(TO_CHAR(a.endt_seq_no, '099999'))) POLICY,
            c.ISS_CD||'-'||LTRIM(TO_CHAR(c.PREM_SEQ_NO, '099999999999'))||'-'||c.inst_no invoice,
            TO_CHAR(d.due_date,'MM-DD-YYYY') due_date,DECODE(c.BALANCE_AMT_DUE,'0',RTRIM(TO_CHAR(c.BALANCE_AMT_DUE,'0D09')),RTRIM(TO_CHAR(c.BALANCE_AMT_DUE,'99G999G999D09'))) balance2,c.BALANCE_AMT_DUE balance, e.rep_col_no
           FROM GIPI_POLBASIC a,
               GIIS_LINE b,
            GIAC_AGING_SOA_DETAILS c,
            GIPI_INSTALLMENT d,
            GIAC_AGING_PARAMETERS e,
            GIAC_SOA_TITLE f
          WHERE a.Line_cd=b.line_cd
            AND a.ASSD_NO=assd_num
            AND a.policy_id=c.policy_id
            AND d.ISS_CD=c.iss_cd
            AND d.PREM_SEQ_NO=c.PREM_SEQ_NO
            AND d.INST_NO=c.inst_no
            AND e.AGING_ID=c.GAGP_AGING_ID
            AND e.REP_COL_NO=f.col_no
            AND f.rep_cd=1
            AND c.balance_amt_due <>0
         AND d.due_date <= SYSDATE--TO_DATE('01-01-2003', 'MM-DD-YYYY')
          ORDER BY b.line_name ,POLICY,due_date)
  LOOP
      WS_WEB_TYPE_ARRAY.EXTEND;
      WS_WEB_TYPE_ARRAY(WS_WEB_TYPE_ARRAY.COUNT) := WEB_TYPE(i.title,i.line_name, i.POLICY, i.invoice, i.due_date,  i.balance2,i.balance);
  END LOOP;
 END IF;
 IF tag=3 THEN
   FOR i IN   (SELECT f.col_title title, b.line_name,
                    DECODE(a.endt_seq_no,0,a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy,'09'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no, '0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no,'09')),
                        a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy, '09'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no, '0999999'))||'-'||LTRIM(TO_CHAR(a.renew_no, '09'))||'-' ||a.endt_iss_cd||'-'||LTRIM(TO_CHAR(a.endt_yy, '09'))||'-'||LTRIM(TO_CHAR(a.endt_seq_no, '099999'))) POLICY,
            c.ISS_CD||'-'||LTRIM(TO_CHAR(c.PREM_SEQ_NO, '099999999999'))||'-'||c.inst_no invoice,
            TO_CHAR(d.due_date,'MM-DD-YYYY') due_date,DECODE(c.BALANCE_AMT_DUE,'0',RTRIM(TO_CHAR(c.BALANCE_AMT_DUE,'0D09')),RTRIM(TO_CHAR(c.BALANCE_AMT_DUE,'99G999G999D09'))) balance2,c.BALANCE_AMT_DUE balance, e.rep_col_no
           FROM GIPI_POLBASIC a,
               GIIS_LINE b,
            GIAC_AGING_SOA_DETAILS c,
            GIPI_INSTALLMENT d,
            GIAC_AGING_PARAMETERS e,
            GIAC_SOA_TITLE f
          WHERE a.Line_cd=b.line_cd
            AND a.ASSD_NO=assd_num
            AND a.policy_id=c.policy_id
            AND d.ISS_CD=c.iss_cd
            AND d.PREM_SEQ_NO=c.PREM_SEQ_NO
            AND d.INST_NO=c.inst_no
            AND e.AGING_ID=c.GAGP_AGING_ID
            AND e.REP_COL_NO=f.col_no
            AND f.rep_cd=1
            AND c.balance_amt_due <>0
         ORDER BY b.line_name ,POLICY,due_date)
  LOOP
      WS_WEB_TYPE_ARRAY.EXTEND;
      WS_WEB_TYPE_ARRAY(WS_WEB_TYPE_ARRAY.COUNT) := WEB_TYPE(i.title,i.line_name, i.POLICY, i.invoice, i.due_date, i.balance2, i.balance);
  END LOOP;
 END IF;
 RETURN WS_WEB_TYPE_ARRAY;
 END;
END;
/


