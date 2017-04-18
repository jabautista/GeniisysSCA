CREATE OR REPLACE PACKAGE BODY CPI.giacs221_pkg
AS
   /*
   **  Created by        : Steven Ramirez
   **  Date Created      : 08.13.2013
   **  Reference By      : GIACS221 - COMMISSION INQUIRY
   */
   FUNCTION get_comm_iss_cd (
      p_module_id   giis_modules.module_id%TYPE, 
      p_user_id     giis_users.user_id%TYPE,
      p_iss_cd      gipi_invoice.iss_cd%TYPE,
      /*Added by pjsantos 11/25/2016, for optimization GENQA 5857*/      
      p_order_by             VARCHAR2,      
      p_asc_desc_flag        VARCHAR2,      
      p_first_row            NUMBER,        
      p_last_row             NUMBER
      --pjsantos end
   )
      RETURN com_inquiry_records_tab PIPELINED
   IS
      v_rec        com_inquiry_records_type;
     /*Modified by pjsantos 11/25/2016, for optimization GENQA 5857*/
      TYPE cur_type IS REF CURSOR;      
      c        cur_type;                
      v_sql    VARCHAR2(32767);
      TYPE com_inq_rec IS RECORD(count_             NUMBER,
                                 rownum_            NUMBER,
                                 iss_cd             GIPI_COMM_INVOICE.ISS_CD%TYPE);
       TYPE com_inq_tab IS TABLE OF com_inq_rec INDEX BY PLS_INTEGER;
       v_com_inq                 com_inq_tab;
   BEGIN   
                /* FOR i IN (SELECT DISTINCT gci.iss_cd
                             FROM gipi_comm_invoice gci
                            WHERE gci.iss_cd LIKE UPPER(NVL (p_iss_cd,''%''))  
                              AND (   EXISTS (
                                       --added by steven 10.23.2014; to replace check_user_per_iss_cd_acctg2
                                       SELECT d.access_tag
                                         FROM giis_users a,
                                              giis_user_iss_cd b2,
                                              giis_modules_tran c,
                                              giis_user_modules d
                                        WHERE a.user_id = p_user_id
                                          AND b2.iss_cd = gci.iss_cd
                                          AND c.module_id = p_module_id
                                          AND a.user_id = b2.userid
                                          AND d.userid = a.user_id
                                          AND b2.tran_cd = c.tran_cd
                                          AND d.tran_cd = c.tran_cd
                                          AND d.module_id = c.module_id)
                                 OR EXISTS (
                                       SELECT d.access_tag
                                         FROM giis_users a,
                                              giis_user_grp_dtl b2,
                                              giis_modules_tran c,
                                              giis_user_grp_modules d
                                        WHERE a.user_id = p_user_id
                                          AND b2.iss_cd = gci.iss_cd
                                          AND c.module_id = p_module_id
                                          AND a.user_grp = b2.user_grp
                                          AND d.user_grp = a.user_grp
                                          AND b2.tran_cd = c.tran_cd
                                          AND d.tran_cd = c.tran_cd
                                          AND d.module_id = c.module_id)
                                ORDER BY gci.iss_cd)*/
      v_sql := v_sql || 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM(SELECT *
                                    FROM  (SELECT DISTINCT gci.iss_cd
                           FROM gipi_comm_invoice gci
                          WHERE 1=1                           
                                 AND EXISTS (SELECT ''X''
                                       FROM TABLE (security_access.get_branch_line (''AC'','''|| p_module_id||''','''|| p_user_id||'''))
                                            WHERE branch_cd = gci.iss_cd) ';
                                IF p_iss_cd IS NOT NULL
                                    THEN
                                        v_sql := v_sql || ' AND  gci.iss_cd LIKE '''||UPPER(p_iss_cd)||''' ';
                                END IF;
                               
                                           IF p_order_by IS NOT NULL
                                              THEN
                                                IF p_order_by = 'billIssCd'
                                                 THEN        
                                                  v_sql := v_sql || ' ORDER BY iss_cd ';                                                
                                                END IF;                                                
                                                IF p_asc_desc_flag IS NOT NULL
                                                THEN
                                                   v_sql := v_sql || p_asc_desc_flag;
                                                ELSE
                                                   v_sql := v_sql || ' ASC '; 
                                                END IF;   
                                           ELSE
                                             v_sql := v_sql || ' ORDER BY iss_cd ';                                             
                                           END IF;                            
      v_sql := v_sql || ' )) innersql) outersql) mainsql WHERE rownum_ BETWEEN '|| p_first_row ||' AND ' || p_last_row; 
  OPEN c FOR v_sql;               
     FETCH c BULK COLLECT INTO v_com_inq;
      IF v_com_inq.count != 0
        THEN       
          FOR v_ctr IN v_com_inq.FIRST..v_com_inq.LAST
          LOOP
           v_rec.count_ := v_com_inq(v_ctr).count_; 
           v_rec.rownum_ := v_com_inq(v_ctr).rownum_; 
           v_rec.bill_iss_cd := v_com_inq(v_ctr).iss_cd;           
          PIPE ROW (v_rec);
         END LOOP;       
       END IF;          
     CLOSE c;            
    RETURN; 
   END;

   FUNCTION get_com_inquiry_records (
      p_module_id     giis_modules.module_id%TYPE,
      p_user_id       giis_users.user_id%TYPE,
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE,
      p_intm_no       NUMBER,
      p_assd_no       NUMBER,
      p_line_cd       VARCHAR2,
      p_subline_cd    VARCHAR2,
      p_pol_iss_cd    VARCHAR2,
      p_issue_yy      NUMBER,
      p_pol_seq_no    NUMBER,
      p_renew_no      NUMBER,
      p_endt_iss_cd   VARCHAR2,
      p_endt_yy       NUMBER,
      p_endt_seq_no   NUMBER,
      /*Added by pjsantos 11/25/2016, for optimization GENQA 5857*/
      p_filter_assd_name     VARCHAR2,
      p_filter_intm_type     VARCHAR2,
      p_filter_ref_intm_cd   VARCHAR2,
      p_filter_ref_intm_name VARCHAR2,
      p_filter_incept_date   VARCHAR2,
      p_filter_expiry_date   VARCHAR2,
      p_filter_bill_no       VARCHAR2,
      p_filter_policy_no     VARCHAR2,
      p_filter_endt_no       VARCHAR2,
      p_order_by             VARCHAR2,      
      p_asc_desc_flag        VARCHAR2,      
      p_first_row            NUMBER,        
      p_last_row             NUMBER
      --pjsantos end
   )
      RETURN com_inquiry_records_tab PIPELINED
   AS
      v_rec                com_inquiry_records_type;
      v_input_vat          NUMBER (16, 2);
      v_prem_pd_l          NUMBER (16, 2);
      v_curr_sname         VARCHAR2 (5);
      v_curr_cd            NUMBER (2);
      v_comm_amt           NUMBER (16, 2);
      v_wholding           NUMBER (16, 2);
      v_prem_amt           NUMBER (16, 2);
      v_wtax_rate          NUMBER;
      v_chk_payt           giac_parameters.param_value_v%TYPE
                                                      := giacp.v ('CHK_PAYT');
      v_comm_paid          NUMBER                               := 0;
      v_wtax_paid          NUMBER                               := 0;
      v_outstanding_wtax   NUMBER                               := 0;
      v_outstanding_comm   NUMBER                               := 0;
      /*Added by pjsantos 11/25/2016, for optimization GENQA 5857*/
      TYPE cur_type IS REF CURSOR;      
      c        cur_type;                
      v_sql    VARCHAR2(32767);
      TYPE com_inq_rec IS RECORD(count_             NUMBER,
                                 rownum_            NUMBER,
                                 iss_cd             GIPI_COMM_INVOICE.iss_cd%TYPE,
                                 prem_seq_no        GIPI_COMM_INVOICE.prem_seq_no%TYPE,
                                 line_cd            GIPI_POLBASIC.line_cd%TYPE,
                                 subline_cd         GIPI_POLBASIC.subline_cd%TYPE,
                                 pol_iss_cd         GIPI_POLBASIC.iss_cd%TYPE,
                                 issue_yy           GIPI_POLBASIC.issue_yy%TYPE,
                                 pol_seq_no         GIPI_POLBASIC.pol_seq_no%TYPE,
                                 renew_no           GIPI_POLBASIC.renew_no%TYPE,
                                 endt_iss_cd        GIPI_POLBASIC.endt_iss_cd%TYPE,
                                 endt_yy            GIPI_POLBASIC.endt_yy%TYPE,
                                 endt_seq_no        GIPI_POLBASIC.endt_seq_no%TYPE,
                                 assd_no            GIPI_POLBASIC.assd_no%TYPE,
                                 assd_name          GIIS_ASSURED.assd_name%TYPE,
                                 intm_type          GIIS_INTERMEDIARY.intm_type%TYPE,
                                 intrmdry_intm_no   GIPI_COMM_INVOICE.intrmdry_intm_no%TYPE,
                                 ref_intm_cd        GIIS_INTERMEDIARY.ref_intm_cd%TYPE,
                                 intm_name          GIIS_INTERMEDIARY.intm_name%TYPE,
                                 currency_cd_f      GIPI_INVOICE.currency_cd%TYPE,
                                 currency_rt_f      GIPI_INVOICE.currency_rt%TYPE,
                                 short_name_f       GIIS_CURRENCY.short_name%TYPE,
                                 parent_intm_no     GIPI_COMM_INVOICE.parent_intm_no%TYPE,
                                 rv_meaning         CG_REF_CODES.rv_meaning%TYPE,
                                 reg_policy_sw      GIPI_POLBASIC.reg_policy_sw%TYPE,
                                 pol_flag           GIPI_POLBASIC.pol_flag%TYPE,
                                 spld_date          GIPI_POLBASIC.spld_date%TYPE,
                                 incept_date        GIPI_POLBASIC.incept_date%TYPE,
                                 expiry_date        GIPI_POLBASIC.expiry_date%TYPE,
                                 bill_no            VARCHAR2(15),
                                 policy_number      VARCHAR2(50),
                                 endt_no            VARCHAR2(12));
       TYPE com_inq_tab IS TABLE OF com_inq_rec INDEX BY PLS_INTEGER;
       v_com_inq                 com_inq_tab;
      --pjsantos end
   BEGIN
      --FOR i IN (
       v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM(SELECT *
                                    FROM  (SELECT gci.iss_cd, gci.prem_seq_no, gp.line_cd,
                                                   gp.subline_cd, gp.iss_cd pol_iss_cd, gp.issue_yy,
                                                   gp.pol_seq_no, gp.renew_no, gp.endt_iss_cd,
                                                   gp.endt_yy, gp.endt_seq_no, gp.assd_no, ga.assd_name,
                                                   gi.intm_type, gci.intrmdry_intm_no, gi.ref_intm_cd,
                                                   gi.intm_name, ginv.currency_cd currency_cd_f,
                                                   ginv.currency_rt currency_rt_f,
                                                   gc.short_name short_name_f, gci.parent_intm_no,
                                                   crc.rv_meaning, gp.reg_policy_sw, gp.pol_flag,
                                                   gp.spld_date, gp.incept_date, gp.expiry_date,
                                                      gci.iss_cd
                                                   || ''-''
                                                   || LTRIM (TO_CHAR (gci.prem_seq_no, ''000000000009''))
                                                                                                 bill_no,
                                                      gp.line_cd
                                                   || ''-''
                                                   || gp.subline_cd
                                                   || ''-''
                                                   || gp.iss_cd
                                                   || ''-''
                                                   || LTRIM (TO_CHAR (gp.issue_yy, ''09''))
                                                   || ''-''
                                                   || LTRIM (TO_CHAR (gp.pol_seq_no, ''0000009''))
                                                   || ''-''
                                                   || LTRIM (TO_CHAR (gp.renew_no, ''09'')) policy_number,
                                                      gp.endt_iss_cd
                                                   || ''-''
                                                   || LTRIM (TO_CHAR (gp.endt_yy, ''09''))
                                                   || ''-''
                                                   || LTRIM (TO_CHAR (gp.endt_seq_no, ''099999'')) endt_no
                                              FROM gipi_comm_invoice gci,
                                                   gipi_polbasic gp,
                                                   giis_assured ga,
                                                   giis_intermediary gi,
                                                   cg_ref_codes crc,
                                                   gipi_invoice ginv,
                                                   giis_currency gc
                                             WHERE 1=1  
                                               AND crc.rv_domain = ''GIPI_POLBASIC.POL_FLAG''
                                               AND gci.policy_id = gp.policy_id
                                               AND gp.assd_no = ga.assd_no
                                               AND gi.intm_no = gci.intrmdry_intm_no
                                               AND rv_low_value = gp.pol_flag
                                               AND ginv.iss_cd = gci.iss_cd
                                               AND ginv.prem_seq_no = gci.prem_seq_no
                                               AND gc.main_currency_cd = ginv.currency_cd 
                                               AND EXISTS (SELECT ''X''
                                                      FROM TABLE (security_access.get_branch_line (''AC'','''|| p_module_id||''','''|| p_user_id||'''))
                                                     WHERE branch_cd = gci.iss_cd) ';
                                             IF p_iss_cd IS NOT NULL 
                                                THEN
                                                    v_sql := v_sql || ' AND gci.iss_cd = '''|| p_iss_cd||''' ';
                                             END IF;
                                             IF p_prem_seq_no IS NOT NULL 
                                                THEN
                                                    v_sql := v_sql || ' AND gci.prem_seq_no = '''||p_prem_seq_no||''' ';
                                             END IF;
                                             IF p_intm_no IS NOT NULL 
                                                THEN
                                                    v_sql := v_sql || ' AND gci.intrmdry_intm_no = '''||p_intm_no||''' ';
                                             END IF; 
                                             IF p_filter_assd_name IS NOT NULL 
                                                THEN
                                                    v_sql := v_sql || ' AND UPPER(assd_name) LIKE '''||REPLACE(UPPER(p_filter_assd_name),'''','''''')||''' ';
                                             END IF;
                                             IF p_filter_intm_type IS NOT NULL 
                                                THEN
                                                    v_sql := v_sql || ' AND UPPER(intm_type) LIKE '''||UPPER(p_filter_intm_type)||''' ';
                                             END IF;
                                             IF p_filter_ref_intm_cd IS NOT NULL 
                                                THEN
                                                    v_sql := v_sql || ' AND UPPER(ref_intm_cd) LIKE '''||UPPER(p_filter_ref_intm_cd)||''' ';
                                             END IF;
                                             IF p_filter_ref_intm_name IS NOT NULL 
                                                THEN
                                                    v_sql := v_sql || ' AND UPPER(intm_name) LIKE '''||UPPER(p_filter_ref_intm_name)||''' ';
                                             END IF;
                                             IF p_filter_incept_date IS NOT NULL 
                                                THEN
                                                    v_sql := v_sql || ' AND incept_date = '''||p_filter_incept_date||''' ';
                                             END IF;
                                             IF p_filter_expiry_date IS NOT NULL 
                                                THEN
                                                    v_sql := v_sql || ' AND expiry_date = '''||p_filter_expiry_date||''' ';
                                             END IF;                                            
                                             
                                             
                                       
                                             
                                             
                                             IF p_order_by IS NOT NULL 
                                              THEN
                                                IF p_order_by = 'billNo'
                                                 THEN        
                                                  v_sql := v_sql || ' ORDER BY bill_no ';
                                                ELSIF  p_order_by = 'endtNo'
                                                 THEN
                                                  v_sql := v_sql || ' ORDER BY endt_no ';
                                                ELSIF  p_order_by = 'policyNo'
                                                 THEN
                                                  v_sql := v_sql || ' ORDER BY policy_number ';
                                                ELSIF  p_order_by = 'assdName'
                                                 THEN
                                                  v_sql := v_sql || ' ORDER BY assd_name ';  
                                                ELSIF  p_order_by = 'intmName'
                                                 THEN
                                                  v_sql := v_sql || ' ORDER BY intm_name ';
                                                END IF;
                                                
                                                IF p_asc_desc_flag IS NOT NULL
                                                THEN
                                                   v_sql := v_sql || p_asc_desc_flag;
                                                ELSE
                                                   v_sql := v_sql || ' ASC '; 
                                                END IF;       
                                             ELSE
                                                v_sql := v_sql || ' ORDER BY bill_no ';                                       
                                             END IF;                                  
                                    v_sql := v_sql || ')) innersql WHERE 1=1 ';
                                    
                                             IF p_filter_bill_no IS NOT NULL 
                                                THEN
                                                    v_sql := v_sql || ' AND UPPER(bill_no) LIKE '''||UPPER(p_filter_bill_no)||''' ';
                                             END IF; 
                                             IF p_filter_endt_no IS NOT NULL 
                                                THEN
                                                    v_sql := v_sql || ' AND UPPER(endt_no) LIKE '''||UPPER(p_filter_endt_no)||''' ';
                                             END IF;   
                                             IF p_filter_policy_no IS NOT NULL 
                                                THEN
                                                    v_sql := v_sql || ' AND UPPER(policy_number) LIKE '''||UPPER(p_filter_policy_no)||''' ';
                                             END IF;              
                                    v_sql := v_sql || ' ) outersql) mainsql WHERE rownum_ BETWEEN '|| p_first_row ||' AND ' || p_last_row; 
  OPEN c FOR v_sql;               
     FETCH c BULK COLLECT INTO v_com_inq;
      IF v_com_inq.count != 0
        THEN     
          FOR v_ctr IN v_com_inq.FIRST..v_com_inq.LAST
           LOOP                 
         /*v_rec.bill_iss_cd := i.iss_cd;
         v_rec.prem_seq_no := i.prem_seq_no;
         v_rec.line_cd := i.line_cd;
         v_rec.subline_cd := i.subline_cd;
         v_rec.iss_cd := i.pol_iss_cd;
         v_rec.issue_yy := i.issue_yy;
         v_rec.pol_seq_no := i.pol_seq_no;
         v_rec.renew_no := i.renew_no;
         v_rec.endt_iss_cd := i.endt_iss_cd;
         v_rec.endt_yy := i.endt_yy;
         v_rec.endt_seq_no := i.endt_seq_no;
         v_rec.assd_no := i.assd_no;
         v_rec.assd_name := i.assd_name;
         v_rec.intm_type := i.intm_type;
         v_rec.intrmdry_intm_no := i.intrmdry_intm_no;
         v_rec.ref_intm_cd := i.ref_intm_cd;
         v_rec.intm_name := i.intm_name;
         v_rec.currency_cd_f := i.currency_cd_f;
         v_rec.currency_rt_f := i.currency_rt_f;
         v_rec.short_name_f := i.short_name_f;
         v_rec.parent_intm_no := i.parent_intm_no;
         v_rec.rv_meaning := i.rv_meaning;
         v_rec.reg_policy_sw := i.reg_policy_sw;
         v_rec.spld_date := i.spld_date;
         v_rec.pol_flag := i.pol_flag;
         v_rec.incept_date := TO_CHAR (i.incept_date, 'MM-DD-YYYY');
         v_rec.expiry_date := TO_CHAR (i.expiry_date, 'MM-DD-YYYY');
         v_rec.policy_number := i.policy_number;
         v_rec.endt_no := i.endt_no;
         v_rec.bill_no := i.bill_no;*/
         v_rec.count_ := v_com_inq(v_ctr).count_;
         v_rec.rownum_ :=  v_com_inq(v_ctr).rownum_;
         v_rec.bill_iss_cd := v_com_inq(v_ctr).iss_cd;
         v_rec.prem_seq_no :=  v_com_inq(v_ctr).prem_seq_no;
         v_rec.line_cd :=  v_com_inq(v_ctr).line_cd;
         v_rec.subline_cd :=  v_com_inq(v_ctr).subline_cd;
         v_rec.iss_cd :=  v_com_inq(v_ctr).pol_iss_cd;
         v_rec.issue_yy :=  v_com_inq(v_ctr).issue_yy;
         v_rec.pol_seq_no :=  v_com_inq(v_ctr).pol_seq_no;
         v_rec.renew_no :=  v_com_inq(v_ctr).renew_no;
         v_rec.endt_iss_cd :=  v_com_inq(v_ctr).endt_iss_cd;
         v_rec.endt_yy :=  v_com_inq(v_ctr).endt_yy;
         v_rec.endt_seq_no :=  v_com_inq(v_ctr).endt_seq_no;
         v_rec.assd_no :=  v_com_inq(v_ctr).assd_no;
         v_rec.assd_name :=  v_com_inq(v_ctr).assd_name;
         v_rec.intm_type :=  v_com_inq(v_ctr).intm_type;
         v_rec.intrmdry_intm_no :=  v_com_inq(v_ctr).intrmdry_intm_no;
         v_rec.ref_intm_cd :=  v_com_inq(v_ctr).ref_intm_cd;
         v_rec.intm_name :=  v_com_inq(v_ctr).intm_name;
         v_rec.currency_cd_f :=  v_com_inq(v_ctr).currency_cd_f;
         v_rec.currency_rt_f :=  v_com_inq(v_ctr).currency_rt_f;
         v_rec.short_name_f :=  v_com_inq(v_ctr).short_name_f;
         v_rec.parent_intm_no :=  v_com_inq(v_ctr).parent_intm_no;
         v_rec.rv_meaning :=  v_com_inq(v_ctr).rv_meaning;
         v_rec.reg_policy_sw :=  v_com_inq(v_ctr).reg_policy_sw;
         v_rec.spld_date :=  v_com_inq(v_ctr).spld_date;
         v_rec.pol_flag :=  v_com_inq(v_ctr).pol_flag;
         v_rec.incept_date := TO_CHAR ( v_com_inq(v_ctr).incept_date, 'MM-DD-YYYY');
         v_rec.expiry_date := TO_CHAR ( v_com_inq(v_ctr).expiry_date, 'MM-DD-YYYY');
         v_rec.policy_number :=  v_com_inq(v_ctr).policy_number;
         v_rec.endt_no :=  v_com_inq(v_ctr).endt_no;
         v_rec.bill_no :=  v_com_inq(v_ctr).bill_no;

         IF  v_com_inq(v_ctr).reg_policy_sw = 'Y'
         THEN
            v_rec.dsp_reg_policy_sw := 'Regular';
         ELSE
            v_rec.dsp_reg_policy_sw := 'Special';
         END IF;

         IF  v_com_inq(v_ctr).pol_flag = '5'
         THEN
            v_rec.pol_status :=
                  v_com_inq(v_ctr).rv_meaning || ' - ' || TO_CHAR ( v_com_inq(v_ctr).spld_date, 'MM-DD-RRRR');
         ELSE
            v_rec.pol_status :=  v_com_inq(v_ctr).rv_meaning;
         END IF;

         BEGIN
            SELECT NVL (SUM (input_vat), 0),
                   NVL (SUM (comm_amt), 0) comm_paid,
                   NVL (SUM (wtax_amt), 0) wtax_paid
              INTO v_input_vat,
                   v_comm_paid,
                   v_wtax_paid
              FROM (SELECT /*+ USE_HASH (gpci gint) */
                             NVL
                                (  (  (  NVL (gcid.commission_amt,
                                              gpci.commission_amt
                                             )
                                       * NVL ( v_com_inq(v_ctr).currency_rt_f, 0)
                                      )
                                    - NVL (gcpa.comm_amt, 0)
                                   )
                                 * (gint.input_vat_rate / 100),
                                 0
                                )                 --added d.currency_rt reymon
                           + NVL (gcpa.input_vat_paid, 0) input_vat,
                           NVL (comm_amt, 0) comm_amt,
                           NVL (wtax_amt, 0) wtax_amt
                      FROM gipi_comm_invoice gpci,
                           gipi_comm_inv_dtl gcid,
                           giis_intermediary gint,
                           (SELECT   j.intm_no, j.iss_cd, j.prem_seq_no,
                                     SUM (NVL (j.comm_amt, 0)) comm_amt,
                                     SUM (NVL (j.wtax_amt, 0)) wtax_amt,
                                     SUM
                                        (NVL (j.input_vat_amt, 0)
                                        ) input_vat_paid
                                FROM giac_comm_payts j, giac_acctrans k
                               WHERE j.gacc_tran_id = k.tran_id
                                 AND k.tran_flag <> 'D'
                                 AND NOT EXISTS (
                                        SELECT '1'
                                          FROM giac_reversals x,
                                               giac_acctrans y
                                         WHERE x.reversing_tran_id = y.tran_id
                                           AND y.tran_flag != 'D'
                                           AND x.gacc_tran_id = j.gacc_tran_id)
                            GROUP BY intm_no, iss_cd, prem_seq_no) gcpa
                     WHERE gpci.iss_cd = gcid.iss_cd(+)
                       AND gpci.prem_seq_no = gcid.prem_seq_no(+)
                       AND gpci.intrmdry_intm_no = gcid.intrmdry_intm_no(+)
                       AND gpci.intrmdry_intm_no = gint.intm_no
                       AND gpci.iss_cd = gcpa.iss_cd(+)
                       AND gpci.prem_seq_no = gcpa.prem_seq_no(+)
                       AND gpci.intrmdry_intm_no = gcpa.intm_no(+)
                       AND gpci.iss_cd =  v_com_inq(v_ctr).iss_cd
                       AND gpci.prem_seq_no =  v_com_inq(v_ctr).prem_seq_no
                       AND gpci.intrmdry_intm_no =  v_com_inq(v_ctr).intrmdry_intm_no
                    UNION
                    SELECT /*+ USE_HASH (gpci gint) */
                             NVL
                                (  (  (  NVL (gcin.commission_amt,
                                              gpci.commission_amt
                                             )
                                       * NVL ( v_com_inq(v_ctr).currency_rt_f, 0)
                                      )
                                    - NVL (gcpa.comm_amt, 0)
                                   )
                                 * (gint.input_vat_rate / 100),
                                 0
                                )                 --added d.currency_rt reymon
                           + NVL (gcpa.input_vat_paid, 0) input_vat,
                           NVL (comm_amt, 0) comm_amt,
                           NVL (wtax_amt, 0) wtax_amt
                      FROM gipi_comm_invoice gpci,
                           giac_parent_comm_invoice gcin,
                           giis_intermediary gint,
                           (SELECT   l.intm_no, l.iss_cd, l.prem_seq_no,
                                     SUM (NVL (l.comm_amt, 0)) comm_amt,
                                     SUM (NVL (l.wtax_amt, 0)) wtax_amt,
                                     SUM (NVL (l.input_vat, 0))
                                                               input_vat_paid
                                FROM giac_ovride_comm_payts l,
                                     giac_acctrans m
                               WHERE l.gacc_tran_id = m.tran_id
                                 AND m.tran_flag <> 'D'
                                 AND NOT EXISTS (
                                        SELECT '1'
                                          FROM giac_reversals x,
                                               giac_acctrans y
                                         WHERE x.reversing_tran_id = y.tran_id
                                           AND y.tran_flag != 'D'
                                           AND x.gacc_tran_id = l.gacc_tran_id)
                            GROUP BY intm_no, iss_cd, prem_seq_no) gcpa
                     WHERE gpci.iss_cd = gcin.iss_cd(+)
                       AND gpci.prem_seq_no = gcin.prem_seq_no(+)
                       AND gpci.parent_intm_no = gcin.intm_no(+)
                       AND gpci.parent_intm_no = gint.intm_no
                       AND gpci.iss_cd = gcpa.iss_cd(+)
                       AND gpci.prem_seq_no = gcpa.prem_seq_no(+)
                       AND gpci.parent_intm_no = gcpa.intm_no(+)
                       AND gpci.iss_cd =  v_com_inq(v_ctr).iss_cd
                       AND gpci.prem_seq_no =  v_com_inq(v_ctr).prem_seq_no
                       AND gpci.intrmdry_intm_no = gcin.chld_intm_no);

            v_rec.input_vat_l := v_input_vat;
            v_rec.input_vat_f := v_input_vat /  v_com_inq(v_ctr).currency_rt_f;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.input_vat_l := 0;
               v_rec.input_vat_f := 0;
         END;

         BEGIN
            IF NVL (v_chk_payt, 'N') = 'N'
            THEN
               BEGIN
                  SELECT   a.currency_cd, SUM (a.premium_amt) premium_amt
                      INTO v_curr_cd, v_prem_pd_l
                      FROM giac_direct_prem_collns a, giac_acctrans b
                     WHERE a.gacc_tran_id = b.tran_id
                       AND b140_iss_cd =  v_com_inq(v_ctr).iss_cd
                       AND b140_prem_seq_no =  v_com_inq(v_ctr).prem_seq_no
                       AND b.tran_flag <> 'D'
                       AND NOT EXISTS (
                              SELECT '1'
                                FROM giac_reversals x, giac_acctrans y
                               WHERE x.gacc_tran_id = a.gacc_tran_id
                                 AND x.reversing_tran_id = y.tran_id
                                 AND y.tran_flag <> 'D')
                  GROUP BY a.currency_cd;
               EXCEPTION
                  WHEN TOO_MANY_ROWS
                  THEN
                     v_curr_cd := NULL;
                     v_prem_pd_l := NULL;
               END;
            ELSIF NVL (v_chk_payt, 'N') = 'Y'
            THEN
               BEGIN                           --added by jomardiago 02072012
                  SELECT   a.currency_cd, SUM (a.premium_amt) premium_amt
                      INTO v_curr_cd, v_prem_pd_l
                      FROM giac_direct_prem_collns a, giac_acctrans b
                     WHERE a.gacc_tran_id = b.tran_id
                       AND b.tran_flag IN ('C', 'P')
                       -- closed and posted transactions only
                       AND NOT EXISTS (
                              SELECT '1'
                                FROM giac_reversals x, giac_acctrans y
                               WHERE x.gacc_tran_id = a.gacc_tran_id
                                 AND x.reversing_tran_id = y.tran_id
                                 AND y.tran_flag <> 'D')
                       AND b140_iss_cd =  v_com_inq(v_ctr).iss_cd
                       AND b140_prem_seq_no =  v_com_inq(v_ctr).prem_seq_no
                  GROUP BY a.currency_cd;
               EXCEPTION
                  WHEN TOO_MANY_ROWS
                  THEN
                     v_curr_cd := NULL;
                     v_prem_pd_l := NULL;
               END;
            END IF;

            v_rec.premium_paid_f := v_prem_pd_l /  v_com_inq(v_ctr).currency_rt_f;
            v_rec.premium_paid_l := v_prem_pd_l;

            SELECT short_name
              INTO v_curr_sname
              FROM giis_currency
             WHERE main_currency_cd = v_curr_cd;

            v_rec.prem_paid_sname_f := v_curr_sname;

            SELECT short_name
              INTO v_curr_sname
              FROM giis_currency
             WHERE main_currency_cd = 1;

            v_rec.prem_paid_sname_l := v_curr_sname;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.premium_paid_f := 0;
               v_rec.premium_paid_l := 0;
         END;

         BEGIN
            SELECT wtax_rate
              INTO v_wtax_rate
              FROM giis_intermediary
             WHERE intm_no =  v_com_inq(v_ctr).intrmdry_intm_no;

            SELECT SUM (commission_amt), SUM (wholding_tax)
              INTO v_comm_amt, v_wholding
              FROM gipi_comm_invoice
             WHERE iss_cd =  v_com_inq(v_ctr).iss_cd
               AND prem_seq_no =  v_com_inq(v_ctr).prem_seq_no
               AND intrmdry_intm_no =  v_com_inq(v_ctr).intrmdry_intm_no;

            v_rec.commission_amt_l := v_comm_amt *  v_com_inq(v_ctr).currency_rt_f;
            --v_outstanding_comm := v_comm_amt - v_comm_paid;
            v_outstanding_comm := (v_comm_amt *  v_com_inq(v_ctr).currency_rt_f) - v_comm_paid; -- bonok :: 8.12.2015 :: UCPB SR 19851
            v_outstanding_wtax := v_outstanding_comm * (v_wtax_rate / 100);
            v_rec.commission_amt_f := v_comm_amt;
            v_rec.wholding_tax_l := v_outstanding_wtax + v_wtax_paid;
            v_rec.wholding_tax_f := v_rec.wholding_tax_l /  v_com_inq(v_ctr).currency_rt_f;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.commission_amt_l := 0;
               v_rec.commission_amt_f := 0;
               v_rec.wholding_tax_l := 0;
               v_rec.wholding_tax_f := 0;
         END;

         BEGIN
            SELECT SUM (premium_amt)
              INTO v_prem_amt
              FROM gipi_comm_invoice
             WHERE iss_cd =  v_com_inq(v_ctr).iss_cd AND prem_seq_no =  v_com_inq(v_ctr).prem_seq_no;

            v_rec.premium_amt_l := v_prem_amt *  v_com_inq(v_ctr).currency_rt_f;
            v_rec.premium_amt_f := v_prem_amt;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.premium_amt_l := 0;
               v_rec.premium_amt_f := 0;
         END;

         BEGIN
            SELECT short_name
              INTO v_rec.short_name_l
              FROM giis_currency
             WHERE main_currency_cd = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.short_name_l := NULL;
         END;

         BEGIN
            SELECT intm_name
              INTO v_rec.parent_intm_name
              FROM giis_intermediary
             WHERE intm_no =  v_com_inq(v_ctr).parent_intm_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.parent_intm_name := NULL;
         END;

         v_rec.net_comm_f :=
              ROUND (v_rec.commission_amt_f, 2)
            - ROUND (v_rec.wholding_tax_f, 2)
            + ROUND (v_rec.input_vat_f, 2);
         v_rec.net_comm_l :=
              ROUND (v_rec.commission_amt_l, 2)
            - ROUND (v_rec.wholding_tax_l, 2)
            + ROUND (v_rec.input_vat_l, 2);
         v_rec.net_premium_amt_l := v_rec.premium_amt_l - v_rec.net_comm_l;
         v_rec.net_premium_amt_f := v_rec.premium_amt_f - v_rec.net_comm_f;
--          EXIT WHEN c%NOTFOUND;              
         PIPE ROW (v_rec);
         END LOOP;       
       END IF;          
     CLOSE c;            
    RETURN; 
   END;

   FUNCTION get_giis_intermediary_lov
      RETURN giis_intermediary_lov_tab PIPELINED
   IS
      v_rec   giis_intermediary_lov_type;
   BEGIN
      FOR i IN (SELECT intm_no, intm_name, ref_intm_cd, intm_type
                  FROM giis_intermediary
                 WHERE intm_no >= 0)
      LOOP
         v_rec.intm_no := i.intm_no;
         v_rec.ref_intm_cd := i.ref_intm_cd;
         v_rec.intm_name := i.intm_name;
         v_rec.intm_type := i.intm_type;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_giis_intm_lov
      RETURN giis_intm_lov_tab PIPELINED
   IS
      v_rec   giis_intm_lov_type;
   BEGIN
      FOR i IN (SELECT   intm_type, intm_desc
                    FROM giis_intm_type
                ORDER BY intm_type)
      LOOP
         v_rec.intm_type := i.intm_type;
         v_rec.intm_desc := i.intm_desc;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_giis_intermediary_lov2(p_intm_type giis_intermediary.intm_type%TYPE)
      RETURN giis_intermediary_lov_tab PIPELINED
   IS
      v_rec   giis_intermediary_lov_type;
   BEGIN
      FOR i IN (SELECT   intm_no, intm_name
                    FROM giis_intermediary
                WHERE intm_type = NVL(p_intm_type,intm_type)
                ORDER BY intm_no)
      LOOP
         v_rec.intm_no := i.intm_no;
         v_rec.intm_name := i.intm_name;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_giac_comm_payts_records (
      p_iss_cd             gipi_comm_invoice.iss_cd%TYPE,
      p_prem_seq_no        gipi_comm_invoice.prem_seq_no%TYPE,
      p_intrmdry_intm_no   gipi_comm_invoice.intrmdry_intm_no%TYPE,
      p_commission_amt     NUMBER
   )
      RETURN giac_comm_payts_tab PIPELINED
   IS
      v_rec                giac_comm_payts_type;
      v_ref_no             VARCHAR2 (30);
      v_temp_net           NUMBER (16, 2);
      v_temp_bal           NUMBER (16, 2);
      v_temp_tot           NUMBER (16, 2);
      v_conv_rt            NUMBER (12, 9);
      v_input_vat          NUMBER (16, 2);                       --jacq060706
      v_input_vat_amt      NUMBER (16, 2);                     --jacq[060506]
      v_currency_rt        NUMBER (12, 9);
      v_comm_amt           NUMBER (16, 2);
      v_wtax_amt           NUMBER (16, 2);
      v_chk_payt           giac_parameters.param_value_v%TYPE := giacp.v ('CHK_PAYT');
      --Vincent 020805: holds value of chk_payt
      v_tran_flag          giac_acctrans.tran_flag%TYPE;
      --Vincent 020805: holds value of tran_flag
      v_input_vat_rate     giis_intermediary.input_vat_rate%TYPE;
      -- U mikel 01.12.11
      v_comm_amt_inv       NUMBER (16, 2);
      v_wtax_amt_inv       NUMBER (16, 2);
      v_wtax_rate          NUMBER;                                   --reymon
      v_comm_paid          NUMBER                                  := 0;
      v_wtax_paid          NUMBER                                  := 0;
      v_outstanding_wtax   NUMBER                                  := 0;
      v_outstanding_comm   NUMBER                                  := 0;
   BEGIN
      FOR i IN (SELECT a.gacc_tran_id, a.tran_type, a.iss_cd, a.prem_seq_no, a.intm_no,
                       a.comm_amt, a.wtax_amt, a.input_vat_amt
                  FROM giac_comm_payts a, giac_acctrans b
                 WHERE iss_cd = p_iss_cd
                   AND prem_seq_no = p_prem_seq_no
                   AND intm_no = p_intrmdry_intm_no
                   --added by steven 10.27.2014
                   AND a.gacc_tran_id = b.tran_id
                   AND (   b.tran_flag =
                                    DECODE (v_chk_payt,
                                            'Y', 'P',
                                            b.tran_flag
                                           )
                        OR b.tran_flag =
                                    DECODE (v_chk_payt,
                                            'Y', 'C',
                                            b.tran_flag
                                           )
                       )
                   --end    
                   AND gacc_tran_id NOT IN (SELECT tran_id
                                              FROM giac_acctrans
                                             WHERE tran_flag = 'D')
                   AND gacc_tran_id NOT IN (
                          SELECT c.gacc_tran_id
                            FROM giac_reversals c, giac_acctrans d
                           WHERE c.reversing_tran_id = d.tran_id
                             AND d.tran_flag <> 'D')
                UNION ALL                          /*alfie 03032009 prf_2910*/
                SELECT a.gacc_tran_id, a.transaction_type tran_type, a.iss_cd,
                       a.prem_seq_no, a.chld_intm_no intm_no, a.comm_amt, a.wtax_amt,
                       a.input_vat
                  FROM giac_ovride_comm_payts a, giac_acctrans b
                 WHERE iss_cd = p_iss_cd
                   AND prem_seq_no = p_prem_seq_no
                   AND intm_no = p_intrmdry_intm_no
                   --added by steven 10.27.2014
                   AND a.gacc_tran_id = b.tran_id
                   AND (   b.tran_flag =
                                    DECODE (v_chk_payt,
                                            'Y', 'P',
                                            b.tran_flag
                                           )
                        OR b.tran_flag =
                                    DECODE (v_chk_payt,
                                            'Y', 'C',
                                            b.tran_flag
                                           )
                       )
                   --end
                   AND gacc_tran_id NOT IN (SELECT tran_id
                                              FROM giac_acctrans
                                             WHERE tran_flag = 'D')
                   AND gacc_tran_id NOT IN (
                          SELECT c.gacc_tran_id
                            FROM giac_reversals c, giac_acctrans d
                           WHERE c.reversing_tran_id = d.tran_id
                             AND d.tran_flag <> 'D'))
      LOOP
         v_rec.gacc_tran_id := i.gacc_tran_id;
         v_rec.tran_type := i.tran_type;
         v_rec.iss_cd := i.iss_cd;
         v_rec.prem_seq_no := i.prem_seq_no;
         v_rec.intm_no := i.intm_no;
         v_rec.comm_amt := i.comm_amt;
         v_rec.wtax_amt := i.wtax_amt;
         v_rec.input_vat_amt := i.input_vat_amt;

         --populate display item--
         FOR c IN (SELECT a.gibr_branch_cd, a.tran_date, a.tran_flag,
                          a.tran_year, a.tran_month, a.tran_seq_no,
                          a.tran_class, a.tran_class_no
                     FROM giac_acctrans a
                    WHERE a.tran_id = v_rec.gacc_tran_id)
         LOOP
            v_rec.dsp_tran_date := TO_CHAR (c.tran_date, 'MM-DD-YYYY');
            v_rec.tran_date := c.tran_date;
            v_rec.branch_cd := c.gibr_branch_cd;
            --jen 042605: Added Column Branch
            v_rec.tran_flag := c.tran_flag;
            v_rec.tran_year := c.tran_year;
            v_rec.tran_month := c.tran_month;
            v_rec.tran_seq_no := c.tran_seq_no;
            v_rec.tran_class := c.tran_class;
            v_rec.tran_class_no := c.tran_class_no;

            IF v_rec.tran_class = 'COL'
            THEN
               SELECT or_pref_suf || '-' || TO_CHAR (or_no)
                 INTO v_ref_no
                 FROM giac_order_of_payts
                WHERE gacc_tran_id = v_rec.gacc_tran_id;
            ELSIF v_rec.tran_class = 'DV'
            THEN
               BEGIN
                  SELECT dv_pref || '-' || TO_CHAR (dv_no)
                    INTO v_ref_no
                    FROM giac_disb_vouchers
                   WHERE gacc_tran_id = v_rec.gacc_tran_id;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     SELECT    document_cd
                            || '-'
                            || branch_cd
                            || '-'
                            || TO_CHAR (doc_year)
                            || '-'
                            || TO_CHAR (doc_mm)
                            || '-'
                            || TO_CHAR (doc_seq_no)
                       INTO v_ref_no
                       FROM giac_payt_requests a, giac_payt_requests_dtl b
                      WHERE a.ref_id = b.gprq_ref_id
                        AND tran_id = v_rec.gacc_tran_id;
               END;
            ELSIF v_rec.tran_class = 'JV'
            THEN
               v_ref_no := v_rec.tran_class || '-' || v_rec.tran_class_no;
            --added by ailene 082206 to consider tran_class 'CM' and 'DM'..
            ELSIF v_rec.tran_class IN ('CM', 'DM')
            THEN
               SELECT memo_type || '-' || memo_year || '-' || memo_seq_no
                 INTO v_ref_no
                 FROM giac_cm_dm
                WHERE gacc_tran_id = v_rec.gacc_tran_id;
            --end ailene
            ELSE                   -- judyann 06292007; for other tran classes
               SELECT tran_year || '-' || tran_month || '-' || tran_seq_no
                                                                      tran_no
                 INTO v_ref_no
                 FROM giac_acctrans
                WHERE tran_id = v_rec.gacc_tran_id;
            END IF;

            v_rec.ref_no := v_ref_no;
         END LOOP;

         BEGIN
            /*--get the value chk_payt
            FOR rec1 IN (SELECT param_value_v
                           FROM giac_parameters
                          WHERE param_name = 'CHK_PAYT')
            LOOP
               v_chk_payt := rec1.param_value_v;
               EXIT;
            END LOOP;*/

            --get value of tran_flag
            IF NVL (v_chk_payt, 'N') = 'Y'
            THEN
               FOR rec2 IN (SELECT tran_flag
                              FROM giac_acctrans
                             WHERE tran_id = v_rec.gacc_tran_id)
               LOOP
                  v_tran_flag := rec2.tran_flag;
                  EXIT;
               END LOOP;
            ELSE
               v_tran_flag := NULL;
                       --used null so that condition below    will always be satisfied
            --if chk_payt = 'N'
            END IF;

            --BEGIN
            --IF  v_chekpayt = 'Y' THEN
              --IF nvl(v_tran_flag, 'C') = 'C' THEN--Vincent 020805: use condition for tran_flag
            IF NVL (v_tran_flag, 'C') IN ('C', 'P')
            THEN
               --issa, 02.23.2005/03.08.2005; para makita rin yung transaction na posted
                --since yung C na tran_flag magiging P once nag-run ng trial balance
                --same as GIACS211
               FOR c IN (SELECT currency_rt
                           FROM gipi_invoice
                          WHERE iss_cd = p_iss_cd
                            AND prem_seq_no = p_prem_seq_no)
               LOOP
                  v_currency_rt := c.currency_rt;
               END LOOP;

                  /* SELECT DISTINCT CONVERT_RATE
                         INTO V_CONV_RT
                  FROM GIAC_COMM_PAYTS
               WHERE ISS_CD  = :GIPI_COMM_INVOICE.ISS_CD
                   AND PREM_SEQ_NO = :GIPI_COMM_INVOICE.PREM_SEQ_NO;*/
               FOR a IN (SELECT DISTINCT convert_rate convert_rate
                                    FROM giac_comm_payts
                                   WHERE iss_cd = p_iss_cd
                                     AND prem_seq_no = p_prem_seq_no
                         UNION
                         SELECT DISTINCT convert_rt convert_rate
                                    FROM giac_ovride_comm_payts
                                   WHERE iss_cd = p_iss_cd
                                     AND prem_seq_no = p_prem_seq_no)
               LOOP
                  v_conv_rt := a.convert_rate;
               END LOOP;                                               --APRIL

               /*Modified by:    Jacq
                   Date Modified:    06/01/06
                   Modification:        added code below for GIAC_COMM_PAYTS.INPUT_VAT
               */
               v_rec.input_vat_amt_f := v_rec.input_vat_amt / v_conv_rt;
               --jacq[060606]
               v_rec.comm_amt_f := v_rec.comm_amt / v_conv_rt;
               v_rec.wtax_amt_f := v_rec.wtax_amt / v_conv_rt;
               v_rec.dsp_comm_amt := v_rec.comm_amt;
               --Vincent 020805: populate display item
               v_rec.dsp_wtax_amt := v_rec.wtax_amt;
               --Vincent 020805: populate display item
               v_rec.dsp_input_vat_amt := v_rec.input_vat_amt;

               /* judyann 06142011; input vat
               ** revert to former query; older clients have commission paid at 10% vat;
               ** divide comm paid amounts by convert rate to handle policies in foreign currencies
               */
               BEGIN
                  SELECT NVL (SUM (input_vat), 0),
                         NVL (SUM (comm_amt), 0) comm_paid,
                         --vondanix 10212014
                         NVL (SUM (wtax_amt), 0) wtax_paid --vondanix 10212014
                    INTO v_input_vat,
                         v_comm_paid,
                         v_wtax_paid
                    FROM (SELECT /*+ USE_HASH (gpci gint) */
                                   NVL
                                      (  (  (  NVL (gcid.commission_amt,
                                                    gpci.commission_amt
                                                   )
                                             * NVL (v_currency_rt, 0)
                                            )
                                          - NVL (gcpa.comm_amt, 0)
                                         )
                                       * (gint.input_vat_rate / 100),
                                       0
                                      )           --added d.currency_rt reymon
                                 + NVL (gcpa.input_vat_paid, 0) input_vat,
                                 NVL (comm_amt, 0) comm_amt,
                                 NVL (wtax_amt, 0) wtax_amt
                            --vondanix 10212014
                          FROM   gipi_comm_invoice gpci,
                                 gipi_comm_inv_dtl gcid,
                                 giis_intermediary gint,
                                 (SELECT   j.intm_no, j.iss_cd, j.prem_seq_no,
                                           
                                           /*SUM (j.comm_amt / j.convert_rate) comm_amt,
                                           SUM (j.wtax_amt / j.convert_rate) wtax_amt,
                                           SUM (j.input_vat_amt / j.convert_rate) input_vat_paid
                                           ** commented out by reymon
                                           */
                                           SUM (NVL (j.comm_amt, 0)) comm_amt,
                                           SUM (NVL (j.wtax_amt, 0)) wtax_amt,
                                           SUM
                                              (NVL (j.input_vat_amt, 0)
                                              ) input_vat_paid
                                      FROM giac_comm_payts j, giac_acctrans k
                                     WHERE j.gacc_tran_id = k.tran_id
                                       AND k.tran_flag <> 'D'
                                       AND NOT EXISTS (
                                              SELECT '1'
                                                FROM giac_reversals x,
                                                     giac_acctrans y
                                               WHERE x.reversing_tran_id =
                                                                     y.tran_id
                                                 AND y.tran_flag != 'D'
                                                 AND x.gacc_tran_id =
                                                                j.gacc_tran_id)
                                  GROUP BY intm_no, iss_cd, prem_seq_no) gcpa
                           WHERE gpci.iss_cd = gcid.iss_cd(+)
                             AND gpci.prem_seq_no = gcid.prem_seq_no(+)
                             AND gpci.intrmdry_intm_no = gcid.intrmdry_intm_no(+)
                             AND gpci.intrmdry_intm_no = gint.intm_no
                             AND gpci.iss_cd = gcpa.iss_cd(+)
                             AND gpci.prem_seq_no = gcpa.prem_seq_no(+)
                             AND gpci.intrmdry_intm_no = gcpa.intm_no(+)
                             AND gpci.iss_cd = p_iss_cd
                             AND gpci.prem_seq_no = p_prem_seq_no
                             AND gpci.intrmdry_intm_no = p_intrmdry_intm_no
                          UNION
                          SELECT /*+ USE_HASH (gpci gint) */
                                   NVL
                                      (  (  (  NVL (gcin.commission_amt,
                                                    gpci.commission_amt
                                                   )
                                             * NVL (v_currency_rt, 0)
                                            )
                                          - NVL (gcpa.comm_amt, 0)
                                         )
                                       * (gint.input_vat_rate / 100),
                                       0
                                      )           --added d.currency_rt reymon
                                 + NVL (gcpa.input_vat_paid, 0) input_vat,
                                 NVL (comm_amt, 0) comm_amt,
                                 NVL (wtax_amt, 0) wtax_amt
                            --vondanix 10212014
                          FROM   gipi_comm_invoice gpci,
                                 giac_parent_comm_invoice gcin,
                                 giis_intermediary gint,
                                 (SELECT   l.intm_no, l.iss_cd, l.prem_seq_no,
                                           
                                           /*SUM (l.comm_amt / l.convert_rt) comm_amt,
                                           SUM (l.wtax_amt / l.convert_rt) wtax_amt,
                                           SUM (l.input_vat / l.convert_rt) input_vat_paid
                                           ** commented out by reymon
                                           */
                                           SUM (NVL (l.comm_amt, 0)) comm_amt,
                                           SUM (NVL (l.wtax_amt, 0)) wtax_amt,
                                           SUM
                                              (NVL (l.input_vat, 0)
                                              ) input_vat_paid
                                      FROM giac_ovride_comm_payts l,
                                           giac_acctrans m
                                     WHERE l.gacc_tran_id = m.tran_id
                                       AND m.tran_flag <> 'D'
                                       AND NOT EXISTS (
                                              SELECT '1'
                                                FROM giac_reversals x,
                                                     giac_acctrans y
                                               WHERE x.reversing_tran_id =
                                                                     y.tran_id
                                                 AND y.tran_flag != 'D'
                                                 AND x.gacc_tran_id =
                                                                l.gacc_tran_id)
                                  GROUP BY intm_no, iss_cd, prem_seq_no) gcpa
                           WHERE gpci.iss_cd = gcin.iss_cd(+)
                             AND gpci.prem_seq_no = gcin.prem_seq_no(+)
                             AND gpci.parent_intm_no = gcin.intm_no(+)
                             AND gpci.parent_intm_no = gint.intm_no
                             AND gpci.iss_cd = gcpa.iss_cd(+)
                             AND gpci.prem_seq_no = gcpa.prem_seq_no(+)
                             --AND gpci.intrmdry_intm_no = gcpa.intm_no(+) --Deo [09.17.2014]: commented out, replace with code added below
                             AND gpci.parent_intm_no = gcpa.intm_no(+)
--Deo [09.17.2014]: added to replace code commented out above to compute correct input vat
                             AND gpci.iss_cd = p_iss_cd
                             AND gpci.prem_seq_no = p_prem_seq_no
                             AND gpci.intrmdry_intm_no = gcin.chld_intm_no);

                  /*:GIPI_COMM_INVOICE.INPUT_VAT := V_INPUT_VAT;
                  :GIPI_COMM_INVOICE.INPUT_VAT_L := V_INPUT_VAT * V_CURRENCY_RT;
                  ** Commented out by reymon
                  */
                  v_rec.input_vat_l := v_input_vat;
                  v_rec.input_vat := v_input_vat / v_currency_rt;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     IF p_iss_cd IS NOT NULL
                     THEN
                        v_rec.input_vat := 0;
                        v_rec.input_vat_l := 0;
                     END IF;
               END;

               BEGIN
                  -- commission amount and withholding tax amount in invoice at local currency
                         --reymon
                  SELECT wtax_rate
                    INTO v_wtax_rate
                    FROM giis_intermediary
                   WHERE intm_no = p_intrmdry_intm_no;

                  SELECT SUM (commission_amt), SUM (wholding_tax)
                    INTO v_comm_amt_inv, v_wtax_amt_inv
                    FROM gipi_comm_invoice
                   WHERE iss_cd = p_iss_cd
                     AND prem_seq_no = p_prem_seq_no
                     AND intrmdry_intm_no = p_intrmdry_intm_no;

                  v_rec.commission_amt_l := v_comm_amt_inv * v_currency_rt;
                  --v_outstanding_comm := v_comm_amt_inv - v_comm_paid;
                  v_outstanding_comm := (v_comm_amt_inv * v_currency_rt) - v_comm_paid; -- bonok :: 8.12.2015 :: UCPB SR 19851
                  v_outstanding_wtax :=
                                      v_outstanding_comm
                                      * (v_wtax_rate / 100);
                  v_rec.wholding_tax_l := v_outstanding_wtax + v_wtax_paid;
                  v_rec.wholding_tax_f :=
                                ROUND (v_rec.wholding_tax_l, 2)
                                / v_currency_rt;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     IF v_rec.iss_cd IS NOT NULL
                     THEN
                        v_rec.commission_amt_l := 0;
                        v_rec.wholding_tax_l := 0;
                     END IF;
               END;

               --Modified by: Jeffrey Lacatan to include data from the other joined table to display correct total;
               --include payments for override commissions
               SELECT SUM (comm_amt), SUM (wtax_amt), SUM (input_vat_amt)
                 INTO v_comm_amt, v_wtax_amt, v_input_vat_amt
                 FROM (SELECT /*+ INDEX (COMMINV_PK c) */
                              SUM (comm_amt) comm_amt,
                                                      --added optimizer hint: jerome 09-08-2006
                                                      SUM (wtax_amt) wtax_amt,
                              SUM (input_vat_amt) input_vat_amt
                         FROM giac_comm_payts b, giac_acctrans c
                        WHERE b.gacc_tran_id = c.tran_id
                          AND c.tran_flag <> 'D'
                          AND b.iss_cd = p_iss_cd
                          AND b.prem_seq_no = p_prem_seq_no
                          AND b.intm_no = p_intrmdry_intm_no
                          AND NOT EXISTS (
                                 SELECT '1'
                                   FROM giac_reversals x, giac_acctrans y
                                  WHERE x.reversing_tran_id = y.tran_id
                                    AND x.gacc_tran_id = b.gacc_tran_id
                                    AND y.tran_flag <> 'D')
                       UNION ALL                            /*alfie 03032009*/
                       SELECT SUM (comm_amt) comm_amt, SUM (wtax_amt)
                                                                     wtax_amt,
                              SUM (input_vat) input_vat_amt
                         FROM giac_ovride_comm_payts b, giac_acctrans c
                        WHERE b.gacc_tran_id = c.tran_id
                          AND c.tran_flag <> 'D'
                          AND b.iss_cd = p_iss_cd
                          AND b.prem_seq_no = p_prem_seq_no
                          AND b.chld_intm_no = p_intrmdry_intm_no
                          AND NOT EXISTS (
                                 SELECT '1'
                                   FROM giac_reversals x, giac_acctrans y
                                  WHERE x.reversing_tran_id = y.tran_id
                                    AND x.gacc_tran_id = b.gacc_tran_id
                                    AND y.tran_flag <> 'D'));

               --added fields for totals,modified formula for TOTAL(jacq,060606)
                   --modified fields to display correct total
               v_rec.total := v_comm_amt - v_wtax_amt + v_input_vat_amt;
               v_rec.total_f := v_rec.total / v_conv_rt;
               v_rec.tot_com_amt := v_comm_amt;
               v_rec.tot_com_amt_f := v_comm_amt / v_conv_rt;
               v_rec.tot_wtax_amt := v_wtax_amt;
               v_rec.tot_wtax_amt_f := v_wtax_amt / v_conv_rt;
               v_rec.tot_input_vat := v_input_vat_amt;
               v_rec.tot_input_vat_f := v_rec.tot_input_vat / v_conv_rt;
               v_comm_amt := NULL;
               v_wtax_amt := NULL;
               v_input_vat_amt := NULL;
               v_temp_net :=
                         v_rec.comm_amt - v_rec.wtax_amt + v_rec.input_vat_amt;
               --jacq[060606]added input vat in the formula
               v_rec.net_comm := v_temp_net;
               v_rec.net_comm_f := v_temp_net / v_conv_rt;
               v_rec.bal_due :=
                  (  (p_commission_amt * v_conv_rt)
                   -- U mikel 01.13.11 modify formula to display correct amount.
                   - (v_rec.wholding_tax_f * v_conv_rt
                     )        --change WHOLDING_TAX_F from WHOLDING_TAX reymon
                   + ((  (p_commission_amt * (v_input_vat_rate / 100))
                       * v_conv_rt
                      )
                     )
                   - NVL (v_rec.total, 0)
                  );
               v_rec.bal_due_f := v_rec.bal_due / v_conv_rt;
               -- U mikel 01.12.11
               v_rec.bd_input_vat_f :=
                    ROUND ((p_commission_amt * (v_input_vat_rate / 100)), 2)
                  - ROUND ((NVL (v_rec.tot_input_vat, 0) / v_conv_rt), 2);
                                                              -- U mikel 01.13.11
               /* judyann 06142011; modified formula for balances */
               v_rec.bal_due_f :=
                    (  (NVL (p_commission_amt, 0) / v_conv_rt)
                     - v_rec.wholding_tax_f
                     + v_rec.input_vat
                    )         --change WHOLDING_TAX_F from WHOLDING_TAX reymon
                  - (NVL (v_rec.total, 0) / v_conv_rt);
               v_rec.bd_com_amt_f :=
                    (NVL (p_commission_amt, 0) / v_conv_rt)
                  - ROUND ((NVL (v_rec.tot_com_amt, 0) / v_conv_rt), 2);
               v_rec.bd_wtax_amt_f :=
                    v_rec.wholding_tax_f
                  - ROUND ((NVL (v_rec.tot_wtax_amt, 0) / v_conv_rt), 2);
               v_rec.bd_input_vat_f :=
                    v_rec.input_vat
                  - ROUND ((NVL (v_rec.tot_input_vat, 0) / v_conv_rt), 2);
               v_rec.bal_due :=
                    (  v_rec.commission_amt_l
                     - v_rec.wholding_tax_l
                     + v_rec.input_vat_l
                    )
                  - (NVL (v_rec.total, 0));
               v_rec.bd_com_amt :=
                           v_rec.commission_amt_l - NVL (v_rec.tot_com_amt, 0);
               v_rec.bd_wtax_amt :=
                            v_rec.wholding_tax_l - NVL (v_rec.tot_wtax_amt, 0);
               v_rec.bd_input_vat :=
                              v_rec.input_vat_l - NVL (v_rec.tot_input_vat, 0);
            ELSE
               v_rec.branch_cd := '';                            --jen 042605
               v_rec.tran_date := '';
               v_rec.tran_flag := '';
               v_rec.tran_year := '';
               v_rec.tran_month := '';
               v_rec.tran_seq_no := '';
               v_rec.tran_class := '';
               v_rec.tran_class_no := '';
               v_rec.ref_no := '';
               v_rec.comm_amt_f := '';
               v_rec.wtax_amt_f := '';
               v_rec.net_comm_f := '';
               v_rec.input_vat_amt_f := '';                     --jacq 060606
               v_rec.dsp_comm_amt := '';
               v_rec.dsp_wtax_amt := '';
               v_rec.dsp_input_vat_amt := '';                   --jacq 060606
               v_rec.net_comm := '';
            END IF;
         END;

         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_history_records (
      p_iss_cd        gipi_comm_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_comm_invoice.prem_seq_no%TYPE,
      p_currency_cond VARCHAR
   )
      RETURN history_records_tab PIPELINED
   IS
      v_rec   history_records_type;
      v_conv  gipi_invoice.currency_rt%TYPE;
   BEGIN
      SELECT currency_rt
        INTO v_conv
        FROM gipi_invoice
            WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no;
            
      FOR i IN (SELECT b.iss_cd, b.prem_seq_no, a.intm_no, a.commission_amt,
                       a.wholding_tax, b.intm_no intm_no2,
                       b.commission_amt commission_amt2,
                       b.wholding_tax wholding_tax2, b.tran_flag tran_flag2,
                       b.delete_sw delete_sw2, b.post_date post_date2,
                       b.posted_by posted_by2, b.user_id user_id2
                  FROM giac_prev_comm_inv a, giac_new_comm_inv b
                 WHERE a.comm_rec_id = b.comm_rec_id
                   AND b.iss_cd = p_iss_cd
                   AND b.prem_seq_no = p_prem_seq_no)
      LOOP
         FOR intm IN (SELECT intm_name
                        FROM giis_intermediary
                       WHERE intm_no = i.intm_no)
         LOOP
            v_rec.dsp_intm_name := intm.intm_name;
         END LOOP;

         FOR intm2 IN (SELECT intm_name
                         FROM giis_intermediary
                        WHERE intm_no = i.intm_no2)
         LOOP
            v_rec.dsp_intm_name2 := intm2.intm_name;
         END LOOP;

         v_rec.iss_cd := i.iss_cd;
         v_rec.prem_seq_no := i.prem_seq_no;
         v_rec.intm_no := i.intm_no;
         v_rec.intm_no2 := i.intm_no2;
         v_rec.tran_flag2 := i.tran_flag2;
         v_rec.delete_sw2 := i.delete_sw2;
         v_rec.post_date2 := i.post_date2;
         v_rec.dsp_post_date2 :=
                              TO_CHAR (i.post_date2, 'MM-DD-YYYY HH:MI:SS AM');
         v_rec.posted_by2 := i.posted_by2;
         v_rec.user_id2 := i.user_id2;
         
         v_rec.commission_amt := i.commission_amt;
         v_rec.wholding_tax := i.wholding_tax;
         v_rec.commission_amt2 := i.commission_amt2;
         v_rec.wholding_tax2 := i.wholding_tax2;
         IF p_currency_cond = 'L' THEN
            v_rec.commission_amt := i.commission_amt * v_conv;
            v_rec.wholding_tax := i.wholding_tax * v_conv;
            v_rec.commission_amt2 := i.commission_amt2 * v_conv;
            v_rec.wholding_tax2 := i.wholding_tax2 * v_conv;
         END IF;
         
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_detail_records (
      p_iss_cd        gipi_comm_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_comm_invoice.prem_seq_no%TYPE,
      p_intm_no       gipi_comm_inv_peril.intrmdry_intm_no%TYPE
   )
      RETURN detail_records_tab PIPELINED
   IS
      v_rec              detail_records_type;
      v_peril_name       VARCHAR2 (30);
      v_conv             gipi_invoice.currency_rt%TYPE;
      v_wtax_rate        NUMBER;
      v_input_vat_rate   NUMBER              := 0; --added by reymon 09142012
   BEGIN
      FOR i IN (SELECT a.peril_cd, a.intrmdry_intm_no, a.premium_amt,
                       a.commission_rt, a.commission_amt, a.wholding_tax,
                       b.line_cd
                  FROM gipi_comm_inv_peril a, gipi_polbasic b
                 WHERE a.iss_cd = p_iss_cd
                   AND a.prem_seq_no = p_prem_seq_no
                   AND a.intrmdry_intm_no = p_intm_no
                   AND a.policy_id = b.policy_id)
      LOOP
         SELECT peril_name
           INTO v_peril_name
           FROM giis_peril
          WHERE peril_cd = i.peril_cd AND line_cd = i.line_cd;

         v_rec.peril_name := v_peril_name;

         SELECT currency_rt
           INTO v_conv
           FROM gipi_invoice
          WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no;

         SELECT wtax_rate, NVL (input_vat_rate, 0)
           INTO v_wtax_rate, v_input_vat_rate
           FROM giis_intermediary
          WHERE intm_no = i.intrmdry_intm_no;

         --:GIPI_COMM_INV_PERIL.NET := :GIPI_COMM_INV_PERIL.COMMISSION_AMT - :GIPI_COMM_INV_PERIL.WHOLDING_TAX;
         v_rec.prem_amt_l := i.premium_amt * v_conv;
         v_rec.prem_amt_f := i.premium_amt;
         v_rec.comm_amt_l := i.commission_amt * v_conv;
         v_rec.comm_amt_f := i.commission_amt;
         v_rec.comm_rt := i.commission_rt;
         --:GIPI_COMM_INV_PERIL.WTAX_L := :GIPI_COMM_INV_PERIL.WHOLDING_TAX * V_CONV;  reymon 09112012
         --:GIPI_COMM_INV_PERIL.NET_L := :GIPI_COMM_INV_PERIL.NET * V_CONV;
         v_rec.wtax_l := v_rec.comm_amt_l * (v_wtax_rate / 100);
         v_rec.wtax_f := v_rec.wtax_l / v_conv;
         v_rec.input_vat_l := v_rec.comm_amt_l * (v_input_vat_rate / 100);
         v_rec.input_vat_f := v_rec.input_vat_l / v_conv;
         v_rec.net_f := v_rec.comm_amt_f - v_rec.wtax_f + v_rec.input_vat_f;
         v_rec.net_l := v_rec.comm_amt_l - v_rec.wtax_l + v_rec.input_vat_l;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_comm_breakdown_records (
      p_iss_cd             gipi_comm_invoice.iss_cd%TYPE,
      p_prem_seq_no        gipi_comm_invoice.prem_seq_no%TYPE,
      p_intrmdry_intm_no   gipi_comm_invoice.intrmdry_intm_no%TYPE,
      p_currency_cond      VARCHAR
   )
      RETURN comm_breakdown_records_tab PIPELINED
   IS
      v_rec              comm_breakdown_records_type;
      v_peril_name       VARCHAR2 (30);
      v_wtax_rate        NUMBER;
      v_input_vat_rate   NUMBER                      := 0;
      v_conv             gipi_invoice.currency_rt%TYPE;
   BEGIN
      SELECT currency_rt
           INTO v_conv
           FROM gipi_invoice
          WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no;
          
      FOR i IN (SELECT SUM (a.commission_amt) a2, SUM (b.commission_amt) b2
                  FROM giac_parent_comm_invprl a,
                       gipi_comm_inv_peril b,
                       giis_peril c,
                       gipi_polbasic d
                 WHERE a.iss_cd = b.iss_cd
                   AND a.prem_seq_no = b.prem_seq_no
                   AND a.chld_intm_no = b.intrmdry_intm_no
                   AND a.peril_cd = b.peril_cd
                   AND b.policy_id = d.policy_id
                   AND b.iss_cd = p_iss_cd
                   AND b.prem_seq_no = p_prem_seq_no
                   AND b.intrmdry_intm_no = p_intrmdry_intm_no
                   AND c.peril_cd = b.peril_cd
                   AND c.line_cd = d.line_cd
                   AND b.peril_cd = c.peril_cd)
      LOOP
         v_rec.total_parent_comm_amt := NVL (i.a2, 0.00);
         v_rec.total_child_comm_amt := NVL (i.b2 - i.a2, 0.00);
         IF p_currency_cond = 'L' THEN
            v_rec.total_parent_comm_amt := NVL (i.a2, 0.00) * v_conv;
            v_rec.total_child_comm_amt := NVL (i.b2 - i.a2, 0.00) * v_conv;
         END IF;
         EXIT;
      END LOOP;

      FOR a IN (SELECT a.commission_rt a1, a.commission_amt a2,
                       b.commission_rt b1, b.commission_amt b2, c.peril_name
                  FROM giac_parent_comm_invprl a,
                       gipi_comm_inv_peril b,
                       giis_peril c,
                       gipi_polbasic d
                 WHERE a.iss_cd = b.iss_cd
                   AND a.prem_seq_no = b.prem_seq_no
                   AND a.chld_intm_no = b.intrmdry_intm_no
                   AND a.peril_cd = b.peril_cd
                   AND b.policy_id = d.policy_id
                   AND b.iss_cd = p_iss_cd
                   AND b.prem_seq_no = p_prem_seq_no
                   AND b.intrmdry_intm_no = p_intrmdry_intm_no
                   AND c.peril_cd = b.peril_cd
                   AND c.line_cd = d.line_cd
                   AND b.peril_cd = c.peril_cd)
      LOOP
         v_rec.parent_comm_rt := NVL (a.a1, 0.00);
         v_rec.parent_comm_amt := NVL (a.a2, 0.00);
         v_rec.child_comm_rt := NVL (a.b1 - a.a1, 0.00);
         v_rec.child_comm_amt := NVL (a.b2 - a.a2, 0.00);
         v_rec.dsp_peril_name := a.peril_name;
         
         IF p_currency_cond = 'L' THEN
            v_rec.parent_comm_amt := NVL (a.a2, 0.00) * v_conv;
            v_rec.child_comm_amt := NVL (a.b2 - a.a2, 0.00) * v_conv;
         END IF;
         
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_parent_comm_records (
      p_iss_cd             gipi_comm_invoice.iss_cd%TYPE,
      p_prem_seq_no        gipi_comm_invoice.prem_seq_no%TYPE,
      p_intrmdry_intm_no   gipi_comm_invoice.intrmdry_intm_no%TYPE
   )
      RETURN parent_comm_records_tab PIPELINED
   IS
      v_rec           parent_comm_records_type;
      v_parent_payt   NUMBER (16, 2);
      v_intm_name     VARCHAR2 (100);
      v_conv          NUMBER (16, 9);
      v_wtax_rate     NUMBER;
   BEGIN
      FOR i IN (SELECT intm_no, iss_cd, prem_seq_no, commission_amt
                  FROM giac_parent_comm_invoice
                 WHERE iss_cd = p_iss_cd
                   AND prem_seq_no = p_prem_seq_no
                   AND chld_intm_no = p_intrmdry_intm_no)
      LOOP
         v_rec.intm_no := i.intm_no;
         v_rec.commission_amt_f := i.commission_amt;

         BEGIN
            SELECT SUM (  NVL (comm_amt, 0)
                        - NVL (wtax_amt, 0)
                        + NVL (input_vat, 0)
                       )
              INTO v_parent_payt
              FROM giac_ovride_comm_payts a, giac_acctrans b
             WHERE a.gacc_tran_id = b.tran_id
               AND b.tran_flag <> 'D'
               AND a.iss_cd = i.iss_cd
               AND a.prem_seq_no = i.prem_seq_no
               AND a.intm_no = i.intm_no
               AND a.gacc_tran_id NOT IN (
                      SELECT x.gacc_tran_id
                        FROM giac_reversals x, giac_acctrans y
                       WHERE x.reversing_tran_id = y.tran_id
                         AND y.tran_flag <> 'D');

            v_rec.parent_payt_l := NVL (v_parent_payt, 0);
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.parent_payt_l := 0;
         END;

         BEGIN
            SELECT intm_name
              INTO v_intm_name
              FROM giis_intermediary
             WHERE intm_no = i.intm_no;

            v_rec.intm_name := v_intm_name;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.intm_name := NULL;
         END;

         BEGIN
            SELECT currency_rt
              INTO v_conv
              FROM gipi_invoice
             WHERE iss_cd = i.iss_cd AND prem_seq_no = i.prem_seq_no;

            SELECT wtax_rate
              INTO v_wtax_rate
              FROM giis_intermediary
             WHERE intm_no = i.intm_no;

            DECLARE
               v_input_vat   NUMBER (14, 2);
            BEGIN
               SELECT   NVL (c.input_vat_paid, 0)
                      + (  (  (NVL (a.commission_amt, 0) * d.currency_rt)
                            - NVL (c.comm_amt, 0)
                           )
                         * (NVL (b.input_vat_rate, 0) / 100)
                        ) input_vat               --added d.currency_rt reymon
                 INTO v_input_vat
                 FROM giac_parent_comm_invoice a,
                      giis_intermediary b,         --added by aliza 12/29/2011
                      (SELECT   j.intm_no, j.iss_cd, j.prem_seq_no,
                                SUM (j.comm_amt) comm_amt,
                                SUM (j.wtax_amt) wtax_amt,
                                SUM (j.input_vat) input_vat_paid
                           FROM giac_ovride_comm_payts j,
                                giac_acctrans k     --added by aliza 1/03/2011
                          WHERE j.gacc_tran_id = k.tran_id
                            AND k.tran_flag <> 'D'
                            AND NOT EXISTS (
                                   SELECT '1'
                                     FROM giac_reversals x, giac_acctrans y
                                    WHERE x.reversing_tran_id = y.tran_id
                                      AND y.tran_flag != 'D'
                                      AND x.gacc_tran_id = j.gacc_tran_id)
                       GROUP BY intm_no, iss_cd, prem_seq_no) c,
                      gipi_invoice d
                WHERE a.intm_no = b.intm_no
                  AND a.iss_cd = c.iss_cd(+)
                  AND a.prem_seq_no = c.prem_seq_no(+)
                  AND a.intm_no = c.intm_no(+)     --added by aliza 12/29/2011
                  AND a.iss_cd = p_iss_cd
                  AND a.prem_seq_no = p_prem_seq_no
                  AND a.chld_intm_no = p_intrmdry_intm_no
                  AND a.iss_cd = d.iss_cd
                  AND a.prem_seq_no = d.prem_seq_no;

               --added by aliza 12/29/2011
               v_rec.input_vat_l := v_input_vat;
               v_rec.input_vat_f := v_input_vat / v_conv;
            END;                                                         --end

            v_rec.commission_amt_l := v_rec.commission_amt_f * v_conv;
            v_rec.wtax_l := v_rec.commission_amt_l * (v_wtax_rate / 100);
            v_rec.wtax_f := v_rec.wtax_l / v_conv;
            v_rec.parent_payt_f := v_rec.parent_payt_l / v_conv;
            v_rec.net_due_f :=
                 (                                           --edison 09232011
                  v_rec.commission_amt_f - v_rec.wtax_f + v_rec.input_vat_f
                 )                                           --edison 09232011
               - v_rec.parent_payt_f;
            v_rec.net_due_l :=
                 (v_rec.commission_amt_l - v_rec.wtax_l + v_rec.input_vat_l
                 )
               - v_rec.parent_payt_l;
         END;

         PIPE ROW (v_rec);
      END LOOP;
   END;
/*Added by pjsantos 11/28/2016,additional findings for assured LOV GENQA 5857*/
 FUNCTION get_assd_lov(  p_find_text            VARCHAR2,
                         p_bill_iss_cd          VARCHAR2,
                         p_order_by             VARCHAR2,      
                         p_asc_desc_flag        VARCHAR2,      
                         p_first_row            NUMBER,        
                         p_last_row             NUMBER)
      RETURN assd_lov_tab PIPELINED
   IS
      v_rec        assd_lov_rec;
      TYPE cur_type IS REF CURSOR;      
      c        cur_type;                
      v_sql    VARCHAR2(32767);     
   BEGIN              
      v_sql := v_sql || 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM(SELECT *
                                    FROM  (SELECT DISTINCT ga.assd_no, ga.assd_name
                           FROM giis_assured ga, gipi_invoice gi, gipi_polbasic gp, gipi_parlist gpi
                          WHERE gi.policy_id = gp.policy_id
                            AND ga.assd_no = gpi.assd_no
                            AND gp.par_id = gpi.par_id ';
                                IF p_find_text IS NOT NULL
                                    THEN
                                        v_sql := v_sql || ' AND  (ga.assd_no LIKE '''||UPPER(p_find_text)||''' OR
                                                                    ga.assd_name LIKE '''||UPPER(p_find_text)||''') ';
                                END IF;
                                IF p_bill_iss_cd IS NOT NULL
                                    THEN
                                        v_sql := v_sql || ' AND gi.ISS_CD = '''||p_bill_iss_cd||''' ';
                                END IF;
                                                               
                                           IF p_order_by IS NOT NULL
                                              THEN
                                                IF p_order_by = 'assdNo'
                                                 THEN        
                                                  v_sql := v_sql || ' ORDER BY assd_no ';                                                
                                                END IF;    
                                                IF p_order_by = 'assdName'
                                                 THEN        
                                                  v_sql := v_sql || ' ORDER BY assd_name ';                                                
                                                END IF;                                              
                                                IF p_asc_desc_flag IS NOT NULL
                                                THEN
                                                   v_sql := v_sql || p_asc_desc_flag;
                                                ELSE
                                                   v_sql := v_sql || ' ASC '; 
                                                END IF;   
                                           ELSE
                                             v_sql := v_sql || ' ORDER BY assd_no ';                                             
                                           END IF;                            
      v_sql := v_sql || ' )) innersql) outersql) mainsql WHERE rownum_ BETWEEN '|| p_first_row ||' AND ' || p_last_row; 
   OPEN c FOR v_sql;
     LOOP
      FETCH c INTO
            v_rec.count_,
            v_rec.rownum_,
            v_rec.assd_no,
            v_rec.assd_name;          
          EXIT WHEN c%NOTFOUND;              
         PIPE ROW (v_rec);
      END LOOP;      
     CLOSE c;            
    RETURN; 
 END;
END;
/


