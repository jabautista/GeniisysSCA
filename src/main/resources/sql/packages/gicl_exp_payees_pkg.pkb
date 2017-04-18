CREATE OR REPLACE PACKAGE BODY CPI.GICL_EXP_PAYEES_PKG AS

   /*
   **  Created by   :  Veronica V. Raymundo
   **  Date Created :  04.11.2012
   **  Reference By : GICLS260 - Claims Information
   **  Description  : Retrieve list of GICL_EXP_PAYEES records
   */
   FUNCTION get_gicl_exp_payees(p_claim_id  IN GICL_EXP_PAYEES.claim_id%TYPE)
     RETURN gicl_exp_payees_tab PIPELINED
   IS
      v_list   gicl_exp_payees_type;
   BEGIN
      FOR i IN (SELECT  a.claim_id,     a.payee_class_cd, a.adj_company_cd, 
                        a.priv_adj_cd,  a.assign_date,    a.clm_paid,       
                        a.remarks,      a.user_id,        a.last_update    
                  FROM GICL_EXP_PAYEES a
                WHERE a.claim_id = p_claim_id)
      LOOP
         v_list.claim_id         :=  i.claim_id;    
         v_list.payee_class_cd   :=  i.payee_class_cd;
         v_list.adj_company_cd   :=  i.adj_company_cd;
         v_list.priv_adj_cd      :=  i.priv_adj_cd;
         v_list.assign_date      :=  i.assign_date;
         v_list.clm_paid         :=  i.clm_paid;
         v_list.remarks          :=  i.remarks;  
         v_list.user_id          :=  i.user_id;    
         v_list.last_update      :=  i.last_update;
         v_list.adj_company_name :=  NULL; 
         v_list.mail_addr1       :=  NULL;
         v_list.mail_addr2       :=  NULL;
         v_list.mail_addr3       :=  NULL;
         v_list.phone_no         :=  NULL;
         v_list.adj_name         :=  NULL;
         
         BEGIN
            SELECT class_desc
              INTO v_list.payee_class_desc
              FROM giis_payee_class
             WHERE payee_class_cd = i.payee_class_cd;
         EXCEPTION
              WHEN NO_DATA_FOUND THEN
                v_list.payee_class_desc :=  NULL;
          END;
         
         FOR payee IN (SELECT RTRIM(gp.payee_last_name) || 
                             DECODE(gp.payee_first_name,NULL,DECODE(gp.payee_middle_name,NULL,'',' '),', ') || 
                             RTRIM(gp.payee_first_name) || ' ' || RTRIM(gp.payee_middle_name) adj_company_name,
                             gp.mail_addr1, gp.mail_addr2, gp.mail_addr3,
                             gp.phone_no
                       FROM GIIS_PAYEES gp, 
                            GICL_EXP_PAYEES gep
                       WHERE gp.payee_no = gep.adj_company_cd
                         AND gp.payee_class_cd = gep.payee_class_cd
                         AND gep.adj_company_cd = i.adj_company_cd
                         AND gep.payee_class_cd = i.payee_class_cd
                         AND gep.claim_id = i.claim_id)
         LOOP
             v_list.adj_company_name :=  payee.adj_company_name; 
             v_list.mail_addr1       :=  payee.mail_addr1;
             v_list.mail_addr2       :=  payee.mail_addr2;
             v_list.mail_addr3       :=  payee.mail_addr3;
             v_list.phone_no         :=  payee.phone_no;
         END LOOP;
         
         PIPE ROW (v_list);
      
      END LOOP;

      RETURN;
   END;
   
   /*
   **  Created by   :  Veronica V. Raymundo
   **  Date Created :  04.11.2012
   **  Reference By : GICLS260 - Claims Information
   **  Description  : Check if records exists in GICL_EXP_PAYEES with the given claim_id
   */
   
   FUNCTION check_exist_exp_payees(p_claim_id   IN   GICL_EXP_PAYEES.claim_id%TYPE)
     RETURN VARCHAR2 AS
		
		v_exist		VARCHAR2(1) := 'N'; 	
   
   BEGIN
   	   FOR i IN (SELECT 1 
	               FROM GICL_EXP_PAYEES
	              WHERE claim_id = p_claim_id)
	   LOOP
       	  v_exist := 'Y';
		  RETURN v_exist;
	   END LOOP;
	   
	   RETURN v_exist;	 
   END;
    
END GICL_EXP_PAYEES_PKG;
/


