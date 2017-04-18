DROP PROCEDURE CPI.GIACS020_GET_SL_CODE_N;

CREATE OR REPLACE PROCEDURE CPI.giacs020_get_sl_code_n(
	   	  		  	    P_VAR_SL_TYPE_CD1	IN GIAC_PARAMETERS.param_name%TYPE,
						P_VAR_SL_TYPE_CD2	IN GIAC_PARAMETERS.param_name%TYPE,
 						P_VAR_SL_TYPE_CD3	IN GIAC_PARAMETERS.param_name%TYPE,
	   	  		  	    P_INTM_NO       IN NUMBER,
                        P_ASSD_NO       IN NUMBER,
                        P_ACCT_LINE_CD  IN NUMBER, 
		                P_SL_CD_C       OUT NUMBER,
                        P_SL_CD_T       OUT NUMBER,
                        P_SL_CD_I       OUT NUMBER,
                        P_GL_INTM_NO    OUT NUMBER,
                        P_GL_ASSD_NO    OUT NUMBER,
		                P_GL_ACCT_LINE_CD  OUT NUMBER)
IS
p_parent_intm_no   number;
p_acct_intm_cd	   number;
p_lic_tag	       varchar2(1);
v_loop		       boolean;
v_intm_no          number;
p_sl_cd            number;
l_sl_cd            number;
p_tran_id          GIAC_ACCTRANS.tran_id%TYPE;

/**** getting the sl_cd for the 1st item which is commission payable....***/

BEGIN
   IF p_var_sl_type_cd1 = 'LINE_SL_TYPE' THEN    
    l_sl_cd := P_acct_line_cd;
    p_sl_cd_C := l_sl_cd; 
 
   ELSIF p_var_sl_type_cd1 = 'ASSD_SL_TYPE' THEN
     p_sl_cd:= p_assd_no;   
     p_sl_cd_C := p_sl_cd; 
  
   ELSIF p_var_sl_type_cd1 = 'INTM_SL_TYPE' THEN  

     FOR i IN (SELECT a.parent_intm_no, b.acct_intm_cd, a.lic_tag
          	     FROM giis_intermediary a, giis_intm_type b
 	              WHERE a.intm_type = b.intm_type
 	                AND a.intm_no = p_intm_no)
 	   LOOP
 	   	 p_parent_intm_no := i.parent_intm_no; 
 	   	 p_acct_intm_cd := i.acct_intm_cd;
 	   	 p_lic_tag := i.lic_tag;
  	 
 	   	 FOR p IN (SELECT b.acct_intm_cd
            	     FROM giis_intermediary a, giis_intm_type b
   	              WHERE a.intm_type = b.intm_type
   	                AND a.intm_no = p_parent_intm_no)
 	     LOOP
 	     	 p_acct_intm_cd := p.acct_intm_cd;           
   	   END LOOP;	 
     END LOOP;

       IF p_parent_intm_no IS NULL THEN
          IF p_lic_tag = 'Y' THEN
		         p_sl_cd_C := p_intm_no;
        	   p_gl_intm_no := p_acct_intm_cd;
          ELSE
             p_sl_cd_C := p_intm_no; 
        	   p_gl_intm_no := p_acct_intm_cd;             
          END IF;  
       ELSE   -- with parent intm
          IF p_lic_tag = 'Y' THEN
		         p_sl_cd_C := p_intm_no;
        	   p_gl_intm_no := p_acct_intm_cd;
          ELSE
             p_sl_cd_C := p_parent_intm_no;
        	   p_gl_intm_no := p_acct_intm_cd;             
          END IF;
       END IF;
  ELSE
     p_sl_cd_C := NULL;   
  END IF;

---
---------------------------
---

/**** getting the sl_cd for the 2nd item which is witholding tax....***/

  IF p_var_sl_type_cd2 = 'LINE_SL_TYPE' THEN  
     l_sl_cd := P_acct_line_cd;       
     p_sl_cd_T := l_sl_cd; 

  ELSIF  p_var_sl_type_cd2 = 'ASSD_SL_TYPE' THEN
    p_sl_cd:= p_assd_no;   
    p_sl_cd_T := p_sl_cd; 

  ELSIF p_var_sl_type_cd2 = 'INTM_SL_TYPE'  THEN 
 
     FOR i IN (SELECT a.parent_intm_no, b.acct_intm_cd, a.lic_tag
          	     FROM giis_intermediary a, giis_intm_type b
 	              WHERE a.intm_type = b.intm_type
 	                AND a.intm_no = p_intm_no)
 	   LOOP
 	   	 p_parent_intm_no := i.parent_intm_no; 
 	   	 p_acct_intm_cd := i.acct_intm_cd;
 	   	 p_lic_tag := i.lic_tag;
  	 
 	   	 FOR p IN (SELECT b.acct_intm_cd
            	     FROM giis_intermediary a, giis_intm_type b
   	              WHERE a.intm_type = b.intm_type
   	                AND a.intm_no = p_parent_intm_no)
 	     LOOP
 	     	 p_acct_intm_cd := p.acct_intm_cd;           
   	   END LOOP;	 
     END LOOP;

       IF p_parent_intm_no IS NULL THEN
          IF p_lic_tag = 'Y' THEN
		         p_sl_cd_T := p_intm_no;
        	   p_gl_intm_no := p_acct_intm_cd;
          ELSE
             p_sl_cd_T := p_intm_no; 
        	   p_gl_intm_no := p_acct_intm_cd;             
          END IF;  
       ELSE   -- with parent intm
          IF p_lic_tag = 'Y' THEN
		         p_sl_cd_T := p_intm_no;
        	   p_gl_intm_no := p_acct_intm_cd;
          ELSE
             p_sl_cd_T := p_parent_intm_no;
        	   p_gl_intm_no := p_acct_intm_cd;             
          END IF;
       END IF;
  ELSE
     p_sl_cd_T := NULL;   
  END IF;
  
------
--------------
-----


/**** getting the sl_cd for the 3rd item which is input_vat...***/

  IF p_var_sl_type_cd3 = 'LINE_SL_TYPE' THEN
     l_sl_cd := P_acct_line_cd;     
     p_sl_cd_I := l_sl_cd; 

  ELSIF p_var_sl_type_cd3 = 'ASSD_SL_TYPE' THEN
     p_sl_cd:= p_assd_no;   
     p_sl_cd_I := p_sl_cd; 

  ELSIF p_var_sl_type_cd3 = 'INTM_SL_TYPE' THEN 
     FOR i IN (SELECT a.parent_intm_no, b.acct_intm_cd, a.lic_tag
          	     FROM giis_intermediary a, giis_intm_type b
 	              WHERE a.intm_type = b.intm_type
 	                AND a.intm_no = p_intm_no)
 	   LOOP
 	   	 p_parent_intm_no := i.parent_intm_no; 
 	   	 p_acct_intm_cd := i.acct_intm_cd;
 	   	 p_lic_tag := i.lic_tag;
  	 
 	   	 FOR p IN (SELECT b.acct_intm_cd
            	     FROM giis_intermediary a, giis_intm_type b
   	              WHERE a.intm_type = b.intm_type
   	                AND a.intm_no = p_parent_intm_no)
 	     LOOP
 	     	 p_acct_intm_cd := p.acct_intm_cd;           
   	   END LOOP;	 
     END LOOP;

       IF p_parent_intm_no IS NULL THEN
          IF p_lic_tag = 'Y' THEN
		         p_sl_cd_I := p_intm_no;
        	   p_gl_intm_no := p_acct_intm_cd;
          ELSE
             p_sl_cd_I := p_intm_no; 
        	   p_gl_intm_no := p_acct_intm_cd;             
          END IF;  
       ELSE   -- with parent intm
          IF p_lic_tag = 'Y' THEN
		         p_sl_cd_I := p_intm_no;
        	   p_gl_intm_no := p_acct_intm_cd;
          ELSE
             p_sl_cd_I := p_parent_intm_no;
        	   p_gl_intm_no := p_acct_intm_cd;             
          END IF;
       END IF;
       
  ELSE
     p_sl_cd_I := NULL;   
  END IF;
  
END giacs020_get_sl_code_n;
/


