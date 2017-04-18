CREATE OR REPLACE PACKAGE BODY CPI.giacr296b_pkg
AS
   FUNCTION get_giacr_296_b_report (
      p_as_of_date     VARCHAR2,
      p_cut_off_date   VARCHAR2,
      p_line_cd        VARCHAR2,
      p_ri_cd          VARCHAR2,
      p_user_id        VARCHAR2
   )
      RETURN report_tab PIPELINED
   IS
      v_list   report_type;
   BEGIN
      FOR i IN (SELECT   a.ri_cd, a.ri_name, a.line_cd, b.line_name,
                         a.eff_date, a.booking_date, a.binder_no,
                         a.policy_no, a.assd_name, a.fprem_amt, a.fprem_vat,
                         a.fcomm_amt, a.fcomm_vat, a.fwholding_vat,
                         a.fnet_due, a.currency_cd, a.currency_rt,
                         c.currency_desc, a.ppw
                    FROM giis_currency c,
                         giis_line b,
                         giac_outfacul_soa_ext a
                   WHERE a.currency_cd = c.main_currency_cd
                     AND a.line_cd = b.line_cd
                     AND a.cut_off_date =
                                        TO_DATE (p_cut_off_date, 'MM-DD-YYYY')
                     AND a.as_of_date = TO_DATE (p_as_of_date, 'MM-DD-YYYY')
                     AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                     AND a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND a.fnet_due <> 0
                     AND a.user_id = UPPER (p_user_id)
                ORDER BY a.ri_name,
                         b.line_name,
                         a.eff_date,
                         a.booking_date,
                         a.binder_no,
                         a.policy_no,
                         a.currency_cd,
                         a.currency_rt)
      LOOP
         BEGIN
            FOR rec IN (SELECT UPPER (param_value_v) param_value_v
                          FROM giis_parameters
                         WHERE param_name = 'COMPANY_NAME')
            LOOP
               v_list.company_name := rec.param_value_v;
            END LOOP;
         END;

         BEGIN
            FOR rec IN (SELECT UPPER (param_value_v) address
                          FROM giis_parameters
                         WHERE param_name = 'COMPANY_ADDRESS')
            LOOP
               v_list.company_address := rec.address;
            END LOOP;
         END;

         BEGIN
            v_list.as_of_cut_off :=
                  'As of '
               || TO_CHAR (TO_DATE(p_as_of_date, 'mm/dd/yyyy'), 'fmMonth DD,')
               || ' Cut-off '
               || TO_CHAR (TO_DATE(p_cut_off_date, 'mm/dd/yyyy'), 'fmMonth DD, YYYY');
         END;

         v_list.ri_name := i.ri_name;
         v_list.line_name := i.line_name;
         v_list.currency_desc := i.currency_desc;
         v_list.eff_date := i.eff_date;
         v_list.booking_date := i.booking_date;
         v_list.currency_rt := i.currency_rt;
         v_list.binder_no := i.binder_no;
         v_list.ppw := i.ppw;
         v_list.policy_no := i.policy_no;
         v_list.assd_name := i.assd_name;
         v_list.prem_amt := i.fprem_amt;
         v_list.prem_vat := i.fprem_vat;
         v_list.comm_vat := i.fcomm_vat;
         v_list.comm_amt := i.fcomm_amt;
         v_list.wholding_vat := i.fwholding_vat;
         v_list.net_due := i.fnet_due;
         
         PIPE ROW (v_list);
      END LOOP;
   END get_giacr_296_b_report;
   
   FUNCTION get_csv_cols
      RETURN csv_col_tab PIPELINED
   IS
      v_list csv_col_type;
   BEGIN
      FOR i IN (SELECT argument_name
                  FROM all_arguments
   		        WHERE owner = 'CPI'
     	             AND package_name = 'CSV_SOA'
     	             AND object_name = 'CSV_GIACR296B'
     	             AND in_out = 'OUT'
     	             AND argument_name IS NOT NULL
	           ORDER BY position)
      LOOP
         
         
         IF i.argument_name = 'RI_CD' THEN
            v_list.col_name := 'RI CODE';
         ELSIF i.argument_name = 'RI_NAME' THEN
            v_list.col_name := 'REINSURER';
         ELSIF i.argument_name = 'LINE_CD' THEN
            v_list.col_name := 'LINE CODE';
         ELSIF i.argument_name = 'LINE_NAME' THEN
            v_list.col_name := 'LINE';
         ELSIF i.argument_name = 'EFF_DATE' THEN
            v_list.col_name := 'EFF DATE';
         ELSIF i.argument_name = 'BOOKING_DATE' THEN
            v_list.col_name := 'BOOKING DATE';
         ELSIF i.argument_name = 'BINDER_NO' THEN
            v_list.col_name := 'BINDER NUMBER';
         ELSIF i.argument_name = 'POLICY_NO' THEN
            v_list.col_name := 'POLICY NUMBER';
         ELSIF i.argument_name = 'ASSD_NAME' THEN
            v_list.col_name := 'ASSURED NAME';
         ELSIF i.argument_name = 'FPREM_AMT' THEN
            v_list.col_name := 'PREMIUM AMT';
         ELSIF i.argument_name = 'FPREM_VAT' THEN
            v_list.col_name := 'VAT ON PREM';
         ELSIF i.argument_name = 'FCOMM_AMT' THEN
            v_list.col_name := 'COMMISSION AMT';
         ELSIF i.argument_name = 'FCOMM_VAT' THEN
            v_list.col_name := 'VAT ON COMM';
         ELSIF i.argument_name = 'FWHOLDING_VAT' THEN
            v_list.col_name := 'WHOLDING VAT';
         ELSIF i.argument_name = 'FNET_DUE' THEN
            v_list.col_name := 'NET DUE';            
         ELSIF i.argument_name = 'CURRENCY_CD' THEN
            v_list.col_name := 'CURRENCY CODE';
         ELSIF i.argument_name = 'CURRENCY_RT' THEN
            v_list.col_name := 'CONVERT RATE';
         ELSIF i.argument_name = 'CURRENCY_DESC' THEN
            v_list.col_name := 'CURRENCY DESC';    
         ELSE
            v_list.col_name := i.argument_name;
         END IF;   
         
         PIPE ROW(v_list);
      END LOOP;              
   END get_csv_cols;
   
END;
/


