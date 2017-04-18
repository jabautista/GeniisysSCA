CREATE OR REPLACE PACKAGE BODY CPI.GIADD157_PKG
AS
    /*
   **  Created by   :  Angelo Mark Pagaduan 
   **  Date Created : 04.10.2014
   **  Reference By : 
   */

    FUNCTION cf_report_name (p_report_id  GIIS_REPORTS.report_id%TYPE) 
       RETURN GIIS_REPORTS.report_title%TYPE
    IS
       v_report_name    GIIS_REPORTS.report_title%TYPE;
    BEGIN
       SELECT report_title
         INTO v_report_name
         FROM GIIS_REPORTS
        WHERE report_id = p_report_id;
        
       RETURN (v_report_name);
    END cf_report_name;

    FUNCTION cf_company_name
       RETURN VARCHAR2
    IS
       v_company_name    GIAC_PARAMETERS.param_value_v%TYPE;
    BEGIN
       SELECT giacp.v('COMPANY_NAME')
  		 INTO v_company_name				
         FROM dual;
        
       RETURN (v_company_name);
    END cf_company_name;
    
    FUNCTION cf_company_addr
       RETURN VARCHAR2
    IS
       v_company_addr    GIAC_PARAMETERS.param_value_v%TYPE;
    BEGIN
       SELECT upper(giacp.v('COMPANY_ADDRESS'))
  		 INTO v_company_addr
         FROM dual;
       
       RETURN (v_company_addr);
    END cf_company_addr;
    
    FUNCTION cf_from_todate (p_tran_id  GIAC_COMM_FUND_EXT.gacc_tran_id%TYPE)
        RETURN VARCHAR2
    IS
       v_min_comm_slip_date GIAC_COMM_FUND_EXT.comm_slip_date%type;
	   v_max_comm_slip_date GIAC_COMM_FUND_EXT.comm_slip_date%type;
       v_from_to         VARCHAR2(50);
    BEGIN
       SELECT MIN(comm_slip_date), MAX(comm_slip_date)
         INTO v_min_comm_slip_date, v_max_comm_slip_date
         FROM GIAC_COMM_FUND_EXT
        WHERE gacc_tran_id = p_tran_id;
        
        v_from_to := 'From'||' '|| to_char(v_min_comm_slip_date,'fmMonth DD, RRRR')||' '|| 'to' ||' '||to_char(v_max_comm_slip_date,'fmMonth DD, RRRR');
        RETURN (v_from_to);
    END cf_from_todate;
        
    FUNCTION cf_intm_type_no (p_intm_no  GIIS_INTERMEDIARY.intm_no%TYPE)
        RETURN VARCHAR2
    IS
       v_parent_intm_no   GIIS_INTERMEDIARY.parent_intm_no%type;
       v_lic_tag          GIIS_INTERMEDIARY.lic_tag%type;
       v_type		      GIIS_INTERMEDIARY.intm_type%type;
       v_ptype		      GIIS_INTERMEDIARY.intm_type%type;
    BEGIN
       FOR i IN (SELECT intm_type, lic_tag, parent_intm_no
              FROM giis_intermediary
             WHERE intm_no = p_intm_no)
       LOOP
  	     v_type := i.intm_type;
  	     v_lic_tag := i.lic_tag;
  	     v_parent_intm_no := i.parent_intm_no;
       END LOOP;
       
       IF v_lic_tag = 'N' AND v_parent_intm_no IS NOT NULL THEN
          FOR p IN (SELECT intm_type
                      FROM GIIS_INTERMEDIARY
                     WHERE intm_no = v_parent_intm_no)
       LOOP
     	  v_ptype := p.intm_type;
       END LOOP;	 
          RETURN (v_ptype||'-'||v_parent_intm_no||'/'||v_type||'-'||p_intm_no);
       ELSE
          RETURN (v_type||'-'||p_intm_no); 
       END IF;
       
    END cf_intm_type_no;
    
    FUNCTION get_report_header (
        p_report_id GIIS_REPORTS.report_id%TYPE,
        p_tran_id   GIAC_COMM_FUND_EXT.gacc_tran_id%TYPE
    )   RETURN report_header_tab PIPELINED
    IS
       v_header     report_header;
    BEGIN
       v_header.company_name   := CF_COMPANY_NAME;
       v_header.company_addr   := CF_COMPANY_ADDR;
       v_header.report_name    := CF_REPORT_NAME (p_report_id);
       v_header.fromto_date    := CF_FROM_TODATE (p_tran_id);
       PIPE ROW(v_header);
    END get_report_header;
    
    FUNCTION get_report_detail (p_tran_id  GIAC_COMM_FUND_EXT.gacc_tran_id%TYPE)
        RETURN report_detail_tab PIPELINED
    IS
       v_detail     report_detail;
    BEGIN
       FOR i IN (SELECT a.comm_slip_pref||'-'||a.comm_slip_no comm_slip_no, 
                        a.comm_slip_date, 
                        a.intm_no, 
                        c.intm_name,
                        a.iss_cd||'-'||a.prem_seq_no bill_no,  
                        comm_amt, 
                        wtax_amt, 
                        input_vat_amt,
                        (comm_amt + input_vat_amt - wtax_amt) net_commission, 
                        spoiled_tag --issa
                   FROM GIAC_COMM_FUND_EXT a, GIAC_PAYT_REQUESTS_DTL b, GIIS_INTERMEDIARY c
                  WHERE a.gacc_tran_id = b.tran_id
                    AND a.intm_no = c.intm_no
                    AND b.tran_id = p_tran_id
                            --and spoiled_tag is null
               ORDER BY a.comm_slip_date, a.comm_slip_no)
        LOOP
            v_detail.comm_slip_no      := i.comm_slip_no;
            v_detail.comm_slip_date    := i.comm_slip_date;
            v_detail.intm_type_no      := CF_INTM_TYPE_NO (i.intm_no);
            v_detail.intm_name         := i.intm_name;
            v_detail.bill_no           := i.bill_no;
            v_detail.comm_amt          := i.comm_amt;
            v_detail.wtax_amt          := i.wtax_amt;
            v_detail.input_vat_amt     := i.input_vat_amt;
            v_detail.net_commission    := i.net_commission;
            v_detail.spoiled_tag       := i.spoiled_tag;
            PIPE ROW (v_detail);
        END LOOP;
    END get_report_detail;

    FUNCTION get_report_summary (p_tran_id  GIAC_COMM_FUND_EXT.gacc_tran_id%TYPE)   
        RETURN report_summary_tab PIPELINED
    IS
       v_summary              report_summary; 
       v_total_comm_amt       NUMBER(15,2) := 0;
       v_total_wtax_amt       NUMBER(15,2) := 0;
       v_total_input_vat_amt  NUMBER(15,2) := 0;
       v_total_netcomm        NUMBER(15,2) := 0;
       v_spoiled_tag          GIAC_COMM_FUND_EXT.spoiled_tag%TYPE;
    BEGIN
       FOR i IN (SELECT comm_amt, 
                        wtax_amt, 
                        input_vat_amt,
                        (comm_amt + input_vat_amt - wtax_amt) netcomm, 
                        spoiled_tag --issa
                   FROM GIAC_COMM_FUND_EXT a, GIAC_PAYT_REQUESTS_DTL b, GIIS_INTERMEDIARY c
                  WHERE a.gacc_tran_id = b.tran_id
                    AND a.intm_no = c.intm_no
                    AND b.tran_id = p_tran_id
                    AND NVL(spoiled_tag,'N') = 'N' /*is null*/  --uncomment and modified by pjsantos 12/01/2016, GENQA 5876 
               ORDER BY a.comm_slip_date, a.comm_slip_no)
       LOOP
           v_total_comm_amt           := v_total_comm_amt + i.comm_amt;
           v_total_wtax_amt           := v_total_wtax_amt + i.wtax_amt;
           v_total_input_vat_amt      := v_total_input_vat_amt + i.input_vat_amt;
           v_total_netcomm            := v_total_netcomm + i.netcomm;
           v_spoiled_tag        := i.spoiled_tag;
           
       END LOOP;
       
       v_summary.comm_amt        := v_total_comm_amt;
       v_summary.wtax_amt        := v_total_wtax_amt;
       v_summary.input_vat_amt   := v_total_input_vat_amt;
       v_summary.netcomm         := v_total_netcomm;
       v_summary.spoiled_tag     := v_spoiled_tag;
       PIPE ROW (v_summary);
       
    END get_report_summary;

    FUNCTION get_report_signatory (
        p_report_id     GIAC_DOCUMENTS.report_id%TYPE,
        p_branch_cd     GIAC_DOCUMENTS.branch_cd%TYPE
    )
        RETURN report_signatory_tab PIPELINED
    IS
        v_signatory     report_signatory;
    BEGIN
       FOR i IN (SELECT a.report_no, b.item_no, b.label, c.signatory, c.designation
                   FROM giac_documents a, giac_rep_signatory b, giis_signatory_names c 
                  WHERE a.report_no = b.report_no
                    AND a.report_id = b.report_id 
                    AND a.report_id = p_report_id
                    AND NVL(a.branch_cd, p_branch_cd) = p_branch_cd
                    AND b.signatory_id = c.signatory_id
                 MINUS
                 SELECT a.report_no, b.item_no, b.label, c.signatory, c.designation
                   FROM giac_documents a, giac_rep_signatory b, giis_signatory_names c
                  WHERE a.report_no = b.report_no
                    AND a.report_id = b.report_id
                    AND a.report_id = p_report_id
                    AND a.branch_cd IS NULL 
                    AND EXISTS (SELECT 1 
                                  FROM giac_documents
                                 WHERE report_id = p_report_id
                                   AND branch_cd = p_branch_cd)  
                   AND b.signatory_id = c.signatory_id 
                ORDER BY 2)
       LOOP
           v_signatory.report_no    := i.report_no;
           v_signatory.item_no      := i.item_no;
           v_signatory.label        := i.label;
           v_signatory.signatory    := i.signatory;
           v_signatory.designation  := i.designation;
           PIPE ROW (v_signatory);
       END LOOP;
    END get_report_signatory;    

END giadd157_pkg;
/


