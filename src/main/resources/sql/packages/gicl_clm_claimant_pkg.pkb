CREATE OR REPLACE PACKAGE BODY CPI.GICL_CLM_CLAIMANT_PKG AS

    /*
   **  Created by   :  Veronica V. Raymundo
   **  Date Created :  04.11.2012
   **  Reference By : GICLS260 - Claims Information
   **  Description  : Retrieve list of GICL_CLM_CLAIMANT records
   */
   FUNCTION get_gicl_clm_claimant(p_claim_id   IN   GICL_CLM_CLAIMANT.claim_id%TYPE)
     RETURN gicl_clm_claimant_tab PIPELINED
   IS
      v_list   gicl_clm_claimant_type;
      
   BEGIN
      FOR i IN (SELECT a.claim_id,  a.clm_clmnt_no,   a.payee_class_cd, 
                       a.clmnt_no,  a.user_id,        a.last_update,    
                       a.clm_paid,  a.remarks,        a.mc_payee_cd    
                  FROM GICL_CLM_CLAIMANT a
                WHERE a.claim_id = p_claim_id)
      LOOP
         v_list.claim_id         :=  i.claim_id;    
         v_list.payee_class_cd   :=  i.payee_class_cd;
         v_list.clm_clmnt_no     :=  i.clm_clmnt_no;
         v_list.clmnt_no         :=  i.clmnt_no;
         v_list.clm_paid         :=  i.clm_paid;
         v_list.remarks          :=  i.remarks;  
         v_list.user_id          :=  i.user_id;    
         v_list.last_update      :=  i.last_update;
         v_list.mc_payee_cd      :=  i.mc_payee_cd; 
         v_list.payee            :=  NULL;
         v_list.mail_addr1       :=  NULL;
         v_list.mail_addr2       :=  NULL;
         v_list.mail_addr3       :=  NULL;
         v_list.phone_no         :=  NULL;
         v_list.mc_payee_name    :=  NULL;
         v_list.sdf_last_update  :=  TO_CHAR(i.last_update,'MM-DD-YYYY HH:MI:SS AM'); --added by steven 06.03.2013
         
         BEGIN
            SELECT class_desc
              INTO v_list.payee_class_desc
              FROM giis_payee_class
             WHERE payee_class_cd = i.payee_class_cd;
         EXCEPTION
              WHEN NO_DATA_FOUND THEN
                v_list.payee_class_desc :=  NULL;
         END;
         
         BEGIN
            SELECT DECODE(payee_first_name,NULL,payee_last_name, payee_last_name||', '||
	               payee_first_name ||' '||payee_middle_name) payee, 
	               phone_no, fax_no, mail_addr1, mail_addr2, mail_addr3 
              INTO v_list.payee, v_list.phone_no, v_list.fax_no, 
	               v_list.mail_addr1, v_list.mail_addr2, v_list.mail_addr3
              FROM GIIS_PAYEES 
             WHERE payee_no       = i.clmnt_no
               AND payee_class_cd = i.payee_class_cd;
         EXCEPTION
              WHEN NO_DATA_FOUND THEN
                v_list.payee      := NULL;  
                v_list.phone_no   := NULL;
                v_list.fax_no   := NULL;
                v_list.mail_addr1 := NULL;
                v_list.mail_addr2 := NULL;
                v_list.mail_addr3 := NULL;
         END;
         
         FOR mot_name IN (SELECT payee_last_name 
                            FROM GIIS_PAYEES a 
                           WHERE payee_class_cd = NVL(giacp.v('MC_PAYEE_CLASS'),a.payee_class_cd)
                             AND payee_no = i.mc_payee_cd)
         LOOP
            v_list.mc_payee_name := mot_name.payee_last_name;
            EXIT;
         END LOOP;
         
         PIPE ROW (v_list);
      
      END LOOP;

      RETURN;
   END;
    
END GICL_CLM_CLAIMANT_PKG;
/


