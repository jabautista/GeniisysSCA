DROP PROCEDURE CPI.GPDC_PREM_POST_QUERY;

CREATE OR REPLACE PROCEDURE CPI.gpdc_prem_post_query(
	   	  		  			p_iss_cd			IN 	GIAC_PDC_PREM_COLLN.iss_cd%TYPE,
  		  					p_prem_seq_no		IN	GIAC_PDC_PREM_COLLN.prem_seq_no%TYPE,
							p_policy_no			OUT	VARCHAR2,
							p_assd_name			OUT GIIS_ASSURED.assd_name%TYPE,
							p_currency_cd		OUT GIIS_CURRENCY.main_currency_cd%TYPE)
	   IS
BEGIN 
  /*
  ** Created by: Angelo Pagaduan
  ** Date Created: February 7, 2011
  ** Reference By: (GIACS090)
  ** Description: post-query from gpdc_prem block
  */
  
  FOR a IN (SELECT rtrim(c.line_cd) || '-' || rtrim(c.subline_cd) || '-' || rtrim(c.iss_cd) || 
	   							 '-' || ltrim(to_char(c.issue_yy)) || '-' || ltrim(to_char(c.pol_seq_no)) || 
	   							 decode(c.endt_seq_no,0,NULL, '-' ||c.endt_iss_cd ||'-'||ltrim(to_char(c.endt_yy))||
	   							 '-' ||ltrim(to_char(c.endt_seq_no)) || '-' || rtrim(c.endt_type))||'-'||
	   							 ltrim(to_char(c.renew_no)) policy_no, d.assd_name 
  						FROM giis_assured d, gipi_parlist e, gipi_polbasic c, gipi_invoice b, 
       						 giac_aging_soa_details a 
 						 WHERE e.assd_no = d.assd_no 
 						 	 AND e.assd_no = d.assd_no 
   						 AND e.assd_no = d.assd_no 
   						 AND c.par_id = e.par_id 
   						 AND a.policy_id = c.policy_id 
   						 AND a.policy_id = c.policy_id 
   						 AND a.policy_id = c.policy_id 
   						 AND a.prem_seq_no = b.prem_seq_no 
   						 AND a.iss_cd = b.iss_cd 
   						 AND a.iss_cd = p_iss_cd 
   						 AND b.prem_seq_no = p_prem_seq_no)
   LOOP
   	 p_assd_name := a.assd_name;
   	 p_policy_no  := a.policy_no;
   END LOOP;
   
   FOR b IN (SELECT currency_cd
  						 FROM giis_currency a, giac_pdc_prem_colln b
 						  WHERE a.main_currency_cd = b.currency_cd 
 						  	AND b.iss_cd = p_iss_cd
 						  	AND b.prem_seq_no = p_prem_seq_no)
	 LOOP
	 	 p_currency_cd := b.currency_cd;
	 END LOOP;
END;
/


