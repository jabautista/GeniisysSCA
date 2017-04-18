CREATE OR REPLACE PACKAGE BODY CPI.giac_aging_ri_soa_details_pkg
AS

  /*
   **  Created by    : Emman
   **  Date Created  : 11.04.2010
   **  Reference By  : (GIACS026 - Direct Trans Premium Deposit)
   **  Description   : Gets the records for LOV GIPD_RI_CD
   */
   FUNCTION get_aging_ri_soa_details (p_keyword	VARCHAR2) 
     RETURN aging_ri_soa_details_tab PIPELINED
   IS
     v_rec				aging_ri_soa_details_type;
   BEGIN
     FOR i IN (SELECT a180_ri_cd, prem_seq_no, inst_no, a150_line_cd,
					  total_amount_due, total_payments, temp_payments,
					  balance_due, a020_assd_no
				 FROM giac_aging_ri_soa_details
				WHERE a180_ri_cd LIKE '%'||p_keyword||'%'
				   OR prem_seq_no LIKE '%'||p_keyword||'%'
				   or inst_no LIKE '%'||p_keyword||'%'
			 ORDER BY a180_ri_cd, prem_seq_no, inst_no)
	 LOOP
	 	 v_rec.a180_ri_cd		  			   := i.a180_ri_cd;
		 v_rec.prem_seq_no					   := i.prem_seq_no;
		 v_rec.inst_no						   := i.inst_no;
		 v_rec.a150_line_cd					   := i.a150_line_cd;
		 v_rec.total_amount_due				   := i.total_amount_due;
		 v_rec.total_payments				   := i.total_payments;
		 v_rec.temp_payments				   := i.temp_payments;
		 v_rec.balance_due					   := i.balance_due;
		 v_rec.a020_assd_no					   := i.a020_assd_no;
	 
	 	 PIPE ROW(v_rec);
	 END LOOP;
   END get_aging_ri_soa_details;

END giac_aging_ri_soa_details_pkg;
/


