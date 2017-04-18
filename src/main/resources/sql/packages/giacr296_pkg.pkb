CREATE OR REPLACE PACKAGE BODY CPI.GIACR296_PKG AS

FUNCTION populate_giacr296(
    p_as_of     VARCHAR2,
    p_cut_off   VARCHAR2,
    p_ri_cd     VARCHAR2,
    p_line_cd   VARCHAR2,
    p_user      VARCHAR2
)
RETURN giacr296_tab PIPELINED AS

v_rec           giacr296_type;
v_not_exist     BOOLEAN := TRUE;
v_as_of         DATE := TO_DATE(p_as_of, 'MM/dd/YYYY');
v_cut_off       DATE := TO_DATE(p_cut_off, 'MM/dd/YYYY');
BEGIN
    FOR c IN (SELECT upper(param_value_v) param_value_v
                FROM giis_parameters
              WHERE param_name = 'COMPANY_NAME') 
    LOOP
          v_rec.company_name := c.param_value_v;
        EXIT;
    END LOOP;
    
    FOR d IN (SELECT upper(param_value_v) address            
              FROM giis_parameters 
                 WHERE param_name = 'COMPANY_ADDRESS')
    LOOP
          v_rec.company_address := d.address;
      EXIT;
    END LOOP;
        
    v_rec.as_of_cut_off := 'As of '||to_char(v_as_of,'fmMonth DD,')||
                           ' Cut-off '||to_char(v_cut_off,'fmMonth DD, YYYY');    
  
    FOR i IN (SELECT a.ri_cd, 
                     a.ri_name, 
                     a.line_cd, 
                     b.line_name,
                     a.eff_date, 
                     a.booking_date, 
                     a.binder_no,
                     a.policy_no,
                     a.assd_name,  
                     a.lprem_amt, 
                     a.lprem_vat, 
                     a.lcomm_amt, 
                     a.lcomm_vat, 
                     a.lwholding_vat, 
                     a.lnet_due,
                     a.ppw 
    FROM giis_line b, giac_outfacul_soa_ext a 
    WHERE a.line_cd = b.line_cd
      AND a.cut_off_date = v_cut_off
      AND a.as_of_date = v_as_of
      AND a.ri_cd = nvl(p_ri_cd, a.ri_cd)
      AND a.line_cd = nvl(p_line_cd,a.line_cd)
      AND a.lnet_due <> 0
      AND a.user_id = p_user
    ORDER BY  a.ri_name,  b.line_name, a.eff_date,  a.booking_date, a.binder_no, a.policy_no
    
    ) 
    LOOP
        v_not_exist         := FALSE;
        v_rec.ri_name       := i.ri_name;
        v_rec.line_name     := i.line_name;
        v_rec.eff_date      := i.eff_date;
        v_rec.booking_date  := i.booking_date;
        v_rec.binder_no     := i.binder_no;
        v_rec.ppw           := i.ppw;
        v_rec.policy_no     := i.policy_no;
        v_rec.assd_name     := i.assd_name;
        v_rec.lprem_amt     := i.lprem_amt;
        v_rec.lprem_vat     := i.lprem_vat;
        v_rec.lcomm_amt     := i.lcomm_amt;
        v_rec.lcomm_vat     := i.lcomm_vat;
        v_rec.lwholding_vat := i.lwholding_vat;
        v_rec.lnet_due      := i.lnet_due;
        PIPE ROW(v_rec);
    END LOOP;

    IF v_not_exist THEN
        v_rec.v_not_exist := 'T';
        PIPE ROW(v_rec);
    END IF;

END populate_giacr296;

FUNCTION get_csv_cols
      RETURN csv_col_tab PIPELINED
   IS
      v_list csv_col_type;
   BEGIN
      FOR i IN (SELECT argument_name
                  FROM all_arguments
   		        WHERE owner = 'CPI'
     	             AND package_name = 'CSV_SOA'
     	             AND object_name = 'CSV_GIACR296'
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
         ELSIF i.argument_name = 'LPREM_AMT' THEN
            v_list.col_name := 'PREMIUM AMT';
         ELSIF i.argument_name = 'LPREM_VAT' THEN
            v_list.col_name := 'VAT ON PREM';
         ELSIF i.argument_name = 'LCOMM_AMT' THEN
            v_list.col_name := 'COMMISSION AMT';
         ELSIF i.argument_name = 'LCOMM_VAT' THEN
            v_list.col_name := 'VAT ON COMM';
         ELSIF i.argument_name = 'LWHOLDING_VAT' THEN
            v_list.col_name := 'WHOLDING VAT';
         ELSIF i.argument_name = 'LNET_DUE' THEN
            v_list.col_name := 'NET DUE';                                       
         ELSE
            v_list.col_name := i.argument_name;
         END IF;   
         
         PIPE ROW(v_list);
      END LOOP;              
   END get_csv_cols;


END GIACR296_PKG;
/


