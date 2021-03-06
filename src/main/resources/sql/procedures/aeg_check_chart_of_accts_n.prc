DROP PROCEDURE CPI.AEG_CHECK_CHART_OF_ACCTS_N;

CREATE OR REPLACE PROCEDURE CPI.AEG_Check_Chart_Of_Accts_N
    (cca_gl_acct_category    GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
     cca_gl_control_acct     GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
     cca_gl_sub_acct_1       GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
     cca_gl_sub_acct_2       GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
     cca_gl_sub_acct_3       GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
     cca_gl_sub_acct_4       GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
     cca_gl_sub_acct_5       GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
     cca_gl_sub_acct_6       GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
     cca_gl_sub_acct_7       GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
     cca_gl_acct_id   IN OUT GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE,
	 p_msg_alert             OUT   VARCHAR2 ) IS

BEGIN
 dbms_output.put_line('here 3.1');
--msg_alert('AEG CHK CHART OF ACCTS...','I',FALSE);
  SELECT DISTINCT(gl_acct_id)
    INTO cca_gl_acct_id
    FROM giac_chart_of_accts
   WHERE gl_acct_category  = cca_gl_acct_category
     AND gl_control_acct   = cca_gl_control_acct
     AND gl_sub_acct_1     = cca_gl_sub_acct_1
     AND gl_sub_acct_2     = cca_gl_sub_acct_2
     AND gl_sub_acct_3     = cca_gl_sub_acct_3
     AND gl_sub_acct_4     = cca_gl_sub_acct_4
     AND gl_sub_acct_5     = cca_gl_sub_acct_5
     AND gl_sub_acct_6     = cca_gl_sub_acct_6
     AND gl_sub_acct_7     = cca_gl_sub_acct_7;
	 
	 dbms_output.put_line('gl_acct_id: ' || cca_gl_acct_id);
EXCEPTION
   WHEN no_data_found THEN
     BEGIN
       p_msg_alert := 'GL account code '||to_char(cca_gl_acct_category)
                ||'-'||to_char(cca_gl_control_acct,'09') 
                ||'-'||to_char(cca_gl_sub_acct_1,'09')
                ||'-'||to_char(cca_gl_sub_acct_2,'09')
                ||'-'||to_char(cca_gl_sub_acct_3,'09')
                ||'-'||to_char(cca_gl_sub_acct_4,'09')
                ||'-'||to_char(cca_gl_sub_acct_5,'09')
                ||'-'||to_char(cca_gl_sub_acct_6,'09')
                ||'-'||to_char(cca_gl_sub_acct_7,'09')
                ||' does not exist in Chart of Accounts (Giac_Acctrans).';
				
				dbms_output.put_line('here 3.2 no data' || p_msg_alert);
/*
       aeg_delete_acct_entries;
       delete 
         from giac_direct_prem_collns
        where gacc_tran_id = :GLOBAL.cg$giop_gacc_tran_id
          and b140_prem_seq_no = :gdpc.b140_prem_seq_no
          and b140_iss_cd = :gdpc.b140_iss_cd;
       commit;
*/
     END;
END;
/


