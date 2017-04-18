CREATE OR REPLACE PACKAGE BODY CPI.GIPIS100_EXTRACT_SUMMARY IS

    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : April 29, 2013
    **  Reference By  : GIPIS100 - View Policy Information
    **  Description   : Populate the extracted summary tables (Part 1)
    */
    
    PROCEDURE populate_summary_tab_a
    (p_line_cd      IN   GIPI_POLBASIC.line_cd%TYPE,
     p_subline_cd   IN   GIPI_POLBASIC.subline_cd%TYPE,
     p_iss_cd       IN   GIPI_POLBASIC.iss_cd%TYPE,
     p_issue_yy     IN   GIPI_POLBASIC.issue_yy%TYPE,
     p_pol_seq_no   IN   GIPI_POLBASIC.pol_seq_no%TYPE,
     p_renew_no     IN   GIPI_POLBASIC.renew_no%TYPE,
     p_policy_id    OUT  GIPI_POLBASIC.policy_id%TYPE,
     p_extract_id   OUT  NUMBER,
     p_co_sw        OUT  GIPI_POLBASIC.co_insurance_sw%TYPE)IS

      v_eff_date                 GIPI_POLBASIC.eff_date%TYPE;
      v_incept_date              GIPI_POLBASIC.incept_date%TYPE;
      v_expiry_date              GIPI_POLBASIC.expiry_date%TYPE;
      v_assd_no                  GIPI_POLBASIC.assd_no%TYPE;
      v_acct_of_cd               GIPI_POLBASIC.acct_of_cd%TYPE;
      v_tsi_amt                  GIPI_POLBASIC.tsi_amt%TYPE;
      v_prem_amt                 GIPI_POLBASIC.prem_amt%TYPE;
      v_pol_flag                 GIPI_POLBASIC.pol_flag%TYPE;
      v_issue_date               GIPI_POLBASIC.issue_date%TYPE; 
      v_endt_type                GIPI_POLBASIC.endt_type%TYPE;
      v_type_cd                  GIPI_POLBASIC.type_cd%TYPE; 
      v_designation              GIPI_POLBASIC.designation%TYPE;
      v_mortg_name               GIPI_POLBASIC.mortg_name%TYPE;
      v_address1                 GIPI_POLBASIC.address1%TYPE;
      v_address2                 GIPI_POLBASIC.address2%TYPE; 
      v_address3                 GIPI_POLBASIC.address3%TYPE;  
      v_pool_pol_no              GIPI_POLBASIC.pool_pol_no%TYPE;
      v_no_of_items              GIPI_POLBASIC.no_of_items%TYPE;
      v_prov_prem_pct            GIPI_POLBASIC.prov_prem_pct%TYPE;
      v_subline_type_cd          GIPI_POLBASIC.subline_type_cd%TYPE;
      v_short_rt_percent         GIPI_POLBASIC.short_rt_percent%TYPE;
      v_auto_renew_flag          GIPI_POLBASIC.auto_renew_flag%TYPE;
      v_prorate_flag             GIPI_POLBASIC.prorate_flag%TYPE; 
      v_renew_flag               GIPI_POLBASIC.renew_flag%TYPE; 
      v_pack_pol_flag            GIPI_POLBASIC.pack_pol_flag%TYPE;
      v_prov_prem_tag            GIPI_POLBASIC.prov_prem_tag%TYPE;
      v_expiry_tag               GIPI_POLBASIC.expiry_tag%TYPE; 
      v_foreign_acc_sw           GIPI_POLBASIC.foreign_acc_sw%TYPE;
      v_invoice_sw               GIPI_POLBASIC.invoice_sw%TYPE;
      v_discount_sw              GIPI_POLBASIC.discount_sw%TYPE;
      v_subline_cd               GIPI_POLBASIC.subline_cd%TYPE;
      v_ref_pol_no               GIPI_POLBASIC.ref_pol_no%TYPE;
      v_prem_warr_tag            GIPI_POLBASIC.prem_warr_tag%TYPE;
      v_seq                      NUMBER; 
      v_co_insurance_sw          GIPI_POLBASIC.co_insurance_sw%TYPE;
      v_manual_renew_no          GIPI_POLBASIC.manual_renew_no%TYPE;
      v_with_tariff_sw           GIPI_POLBASIC.with_tariff_sw%TYPE;
      v_incept_tag               GIPI_POLBASIC.incept_tag%TYPE;   
      v_industry_cd              GIPI_POLBASIC.industry_cd%TYPE;
      v_region_cd                GIPI_POLBASIC.region_cd%TYPE;    
      v_cred_branch              GIPI_POLBASIC.cred_branch%TYPE;    
      v_acct_of_cd_sw            GIPI_POLBASIC.acct_of_cd_sw%TYPE;
      --*--
      v_line_cd                  GIPI_POLWC.line_cd%TYPE;
      v_wc_cd                    GIPI_POLWC.wc_cd%TYPE;
      v_swc_seq_no               GIPI_POLWC.swc_seq_no%TYPE;
      v_print_seq_no             GIPI_POLWC.print_seq_no%TYPE;
      v_wc_title                 GIPI_POLWC.wc_title%TYPE;
      v_wc_text01                GIPI_POLWC.wc_text01%TYPE;
      v_wc_text02                GIPI_POLWC.wc_text02%TYPE;
      v_wc_text03                GIPI_POLWC.wc_text03%TYPE;
      v_wc_text04                GIPI_POLWC.wc_text04%TYPE;
      v_wc_text05                GIPI_POLWC.wc_text05%TYPE;
      v_wc_text06                GIPI_POLWC.wc_text06%TYPE;
      v_wc_text07                GIPI_POLWC.wc_text07%TYPE;
      v_wc_text08                GIPI_POLWC.wc_text08%TYPE;
      v_wc_text09                GIPI_POLWC.wc_text09%TYPE;
      v_wc_text10                GIPI_POLWC.wc_text10%TYPE;
      v_wc_text11                GIPI_POLWC.wc_text11%TYPE;
      v_wc_text12                GIPI_POLWC.wc_text12%TYPE;
      v_wc_text13                GIPI_POLWC.wc_text13%TYPE;
      v_wc_text14                GIPI_POLWC.wc_text14%TYPE; 
      v_wc_text15                GIPI_POLWC.wc_text15%TYPE;
      v_wc_text16                GIPI_POLWC.wc_text16%TYPE;
      v_wc_text17                GIPI_POLWC.wc_text17%TYPE;
      v_wc_remarks               GIPI_POLWC.wc_remarks%TYPE;
      
      v_subline_mop              GIPI_WPOLBAS.subline_cd%TYPE; -- global subline_cd for 'MOP Subline' --
      v_subline_open             GIPI_WPOLBAS.subline_cd%TYPE; -- global subline_cd for 'Open Policy ' --
      
      v_open_policy_flag         VARCHAR2(1) := 'N';
      v_op_line_cd               GIPI_OPEN_POLICY.line_cd%TYPE;
      v_op_subline_cd            GIPI_OPEN_POLICY.op_subline_cd%TYPE;  
      v_op_iss_cd                GIPI_OPEN_POLICY.op_iss_cd%TYPE;
      v_op_pol_seqno             GIPI_OPEN_POLICY.op_pol_seqno%TYPE;   
      v_decltn_no                GIPI_OPEN_POLICY.decltn_no%TYPE;
      v_op_eff_date              GIPI_OPEN_POLICY.eff_date%TYPE;       
      v_op_issue_yy              GIPI_OPEN_POLICY.op_issue_yy%TYPE;

    BEGIN

      -- From Program Unit DETERMINE_SUBLINE_OPEN;
           
           -- to determine whether policy is an open policy
           FOR op IN (
              SELECT op_flag
                FROM giis_subline
               WHERE line_cd    = p_line_cd
                 AND subline_cd = p_subline_cd)
           LOOP
                 IF op.op_flag = 'Y' THEN
                    v_subline_mop := p_subline_cd;
                 ELSE
                    v_subline_mop := NULL;
                 END IF;
           END LOOP;
           
           -- to determine whether policy has an open policy.
           FOR op_1 IN (
              SELECT open_policy_sw
                FROM giis_subline
               WHERE line_cd    = p_line_cd
                 AND subline_cd = p_subline_cd)
           LOOP
                 IF op_1.open_policy_sw = 'Y' THEN
                    v_subline_open := p_subline_cd;
                 ELSE
                    v_subline_open := NULL; 
                 END IF;
           END LOOP;
      
      -- end-- 

      FOR pol IN (
         SELECT policy_id,  line_cd,     subline_cd, iss_cd,     issue_yy, 
                pol_seq_no, endt_iss_cd, endt_yy,    endt_seq_no, 
                renew_no,   par_id,      pol_flag,   eff_date,   incept_date,
                issue_date, expiry_date, endt_type,  assd_no,    
                type_cd,    acct_of_cd,  designation,mortg_name, address1,
                address2,   address3,    NVL(tsi_amt,0) tsi_amt,NVL(prem_amt,0) prem_amt,
                pool_pol_no, no_of_items,prov_prem_pct,subline_type_cd,
                short_rt_percent,auto_renew_flag,prorate_flag,renew_flag,pack_pol_flag,
                prov_prem_tag,expiry_tag,foreign_acc_sw,invoice_sw,discount_sw,ref_pol_no,
                prem_warr_tag, co_insurance_sw, manual_renew_no, with_tariff_sw, incept_tag,acct_of_cd_sw,
                region_cd, industry_cd, cred_branch     
           FROM GIPI_POLBASIC
          WHERE line_cd     = p_line_cd
            AND subline_cd  = p_subline_cd
            AND iss_cd      = p_iss_cd
            AND issue_yy    = p_issue_yy
            AND pol_seq_no  = p_pol_seq_no
            AND renew_no    = p_renew_no
            AND endt_seq_no = 0)
      LOOP  
           p_policy_id          :=    pol.policy_id; 
           v_subline_cd         :=    pol.subline_cd;
           v_pol_flag           :=    pol.pol_flag;           
           v_eff_date           :=    pol.eff_date;           
           v_incept_date        :=    pol.incept_date;        
           v_issue_date         :=    pol.issue_date;         
           v_expiry_date        :=    pol.expiry_date;        
           v_endt_type          :=    pol.endt_type;          
           v_assd_no            :=    pol.assd_no;            
           v_type_cd            :=    pol.type_cd;            
           v_acct_of_cd         :=    pol.acct_of_cd;         
           v_designation        :=    pol.designation;        
           v_mortg_name         :=    pol.mortg_name;         
           v_address1           :=    pol.address1;           
           v_address2           :=    pol.address2;          
           v_address3           :=    pol.address3;           
           v_tsi_amt            :=    pol.tsi_amt;            
           v_prem_amt           :=    pol.prem_amt;           
           v_pool_pol_no        :=    pol.pool_pol_no;        
           v_no_of_items        :=    pol.no_of_items;        
           v_prov_prem_pct      :=    pol.prov_prem_pct;      
           v_subline_type_cd    :=    pol.subline_type_cd;    
           v_short_rt_percent   :=    pol.short_rt_percent;   
           v_auto_renew_flag    :=    pol.auto_renew_flag;    
           v_prorate_flag       :=    pol.prorate_flag;       
           v_renew_flag         :=    pol.renew_flag;         
           v_pack_pol_flag      :=    pol.pack_pol_flag;      
           v_prov_prem_tag      :=    pol.prov_prem_tag;      
           v_expiry_tag         :=    pol.expiry_tag;          
           v_foreign_acc_sw     :=    pol.foreign_acc_sw;       
           v_invoice_sw         :=    pol.invoice_sw;        
           v_discount_sw        :=    pol.discount_sw;                     
           v_ref_pol_no         :=    pol.ref_pol_no;                     
           v_prem_warr_tag      :=    pol.prem_warr_tag;                     
           v_co_insurance_sw    :=    pol.co_insurance_sw;                     
           p_co_sw              :=    pol.co_insurance_sw;                     
           v_manual_renew_no    :=    pol.manual_renew_no;
           v_with_tariff_sw     :=    pol.with_tariff_sw;
           v_incept_tag         :=    pol.incept_tag;
           v_acct_of_cd_sw      :=    pol.acct_of_cd_sw;
               --anna061804
           v_industry_cd        :=    pol.industry_cd;    
           v_region_cd          :=    pol.region_cd;        
           v_cred_branch        :=    pol.cred_branch;    

         IF v_subline_cd = v_subline_open THEN    
            -- From Program Unit POPULATE_OPEN_POLICY
            FOR open_pol IN (
               SELECT line_cd,   op_subline_cd,  
                      op_iss_cd, op_pol_seqno,   
                      decltn_no, eff_date,       
                      op_issue_yy
                 FROM GIPI_OPEN_POLICY
                WHERE policy_id = p_policy_id)
            LOOP
              v_open_policy_flag := 'Y';
              v_op_line_cd       := NVL(open_pol.line_cd,v_op_line_cd);          
              v_op_subline_cd    := NVL(open_pol.op_subline_cd,v_op_subline_cd);      
              v_op_iss_cd        := NVL(open_pol.op_iss_cd,v_op_iss_cd);        
              v_op_pol_seqno     := NVL(open_pol.op_pol_seqno,v_op_pol_seqno);        
              v_decltn_no        := NVL(open_pol.decltn_no,v_decltn_no);        
              v_op_eff_date      := NVL(open_pol.eff_date,v_op_eff_date);                
              v_op_issue_yy      := NVL(open_pol.op_issue_yy, v_op_issue_yy);         
            END LOOP;
         END IF;     
      
         FOR endt IN (
            SELECT pol_flag,               eff_date,        incept_date, 
                   issue_date,             expiry_date,     endt_expiry_date,
                   endt_type,              assd_no,         type_cd,
                   acct_of_cd,             designation,     mortg_name,  
                   address1,               address2,        address3,
                   NVL(tsi_amt,0) tsi_amt, NVL(prem_amt,0)  prem_amt, pool_pol_no, 
                   no_of_items,            prov_prem_pct,   subline_type_cd,
                   short_rt_percent,       auto_renew_flag, prorate_flag,
                   renew_flag,             pack_pol_flag,   prov_prem_tag,
                   expiry_tag,             foreign_acc_sw,  invoice_sw,
                   discount_sw,            ref_pol_no,      policy_id,
                   incept_tag,             acct_of_cd_sw,        industry_cd,
                   region_cd,              cred_branch     
              FROM GIPI_POLBASIC     
             WHERE line_cd      = pol.line_cd
               AND subline_cd   = pol.subline_cd
               AND iss_cd       = pol.iss_cd
               AND issue_yy     = pol.issue_yy
               AND pol_seq_no   = pol.pol_seq_no
               AND renew_no     = pol.renew_no
               AND endt_seq_no != 0
               AND pol_flag    != '5'
             ORDER BY eff_date)
             
          LOOP
               v_subline_cd         :=    NVL(pol.subline_cd,v_subline_cd);
               v_pol_flag           :=    NVL(endt.pol_flag,v_pol_flag);           
               v_eff_date           :=    NVL(endt.eff_date,v_eff_date);           
               v_incept_date        :=    NVL(endt.incept_date,v_incept_date);        
               v_issue_date         :=    NVL(endt.issue_date,v_issue_date);         
               v_expiry_date        :=    NVL(endt.expiry_date,v_expiry_date);        
               v_endt_type          :=    NVL(endt.endt_type,v_endt_type);          
               v_assd_no            :=    NVL(endt.assd_no,v_assd_no);            
               v_type_cd            :=    NVL(endt.type_cd,v_type_cd);            
               v_acct_of_cd         :=    NVL(endt.acct_of_cd,v_acct_of_cd);         
               v_designation        :=    NVL(endt.designation,v_designation);        
               v_mortg_name         :=    NVL(endt.mortg_name,v_mortg_name);         
               v_address1           :=    NVL(endt.address1,v_address1);           
               v_address2           :=    NVL(endt.address2,v_address2);          
               v_address3           :=    NVL(endt.address3,v_address3);           
               v_tsi_amt            :=    v_tsi_amt  + NVL(endt.tsi_amt,0);            
               v_prem_amt           :=    v_prem_amt + NVL(endt.prem_amt,0);           
               v_pool_pol_no        :=    NVL(endt.pool_pol_no,v_pool_pol_no);        
               v_no_of_items        :=    NVL(endt.no_of_items,v_no_of_items);        
               v_prov_prem_pct      :=    NVL(endt.prov_prem_pct,v_prov_prem_pct);      
               v_subline_type_cd    :=    NVL(endt.subline_type_cd,v_subline_type_cd);    
               v_short_rt_percent   :=    NVL(endt.short_rt_percent,v_short_rt_percent);   
               v_auto_renew_flag    :=    NVL(endt.auto_renew_flag,v_auto_renew_flag);    
               v_prorate_flag       :=    NVL(endt.prorate_flag,v_prorate_flag);       
               v_renew_flag         :=    NVL(endt.renew_flag,v_renew_flag);         
               v_pack_pol_flag      :=    NVL(endt.pack_pol_flag,v_pack_pol_flag);      
               v_prov_prem_tag      :=    NVL(endt.prov_prem_tag,v_prov_prem_tag);      
               v_industry_cd        :=    NVL(endt.industry_cd,v_industry_cd);
               v_region_cd          :=    NVL(endt.region_cd,v_region_cd);
               v_cred_branch        :=    NVL(endt.cred_branch,v_cred_branch);         
               v_expiry_tag         :=    endt.expiry_tag;          
               v_foreign_acc_sw     :=    NVL(endt.foreign_acc_sw,v_foreign_acc_sw);       
               v_invoice_sw         :=    NVL(endt.invoice_sw,v_invoice_sw);        
               v_discount_sw        :=    NVL(endt.discount_sw,v_discount_sw);                     
               v_ref_pol_no         :=    NVL(endt.ref_pol_no,v_ref_pol_no);                     
               v_incept_tag         :=    endt.incept_tag;
               v_acct_of_cd_sw      :=    endt.acct_of_cd_sw;
              
              IF v_subline_cd = v_subline_open THEN
                 -- From Program Unit POPULATE_OPEN_POLICY
                FOR open_pol IN (
                   SELECT line_cd,   op_subline_cd,  
                          op_iss_cd, op_pol_seqno,   
                          decltn_no, eff_date,       
                          op_issue_yy
                     FROM GIPI_OPEN_POLICY
                    WHERE policy_id = endt.policy_id)
                LOOP
                  v_open_policy_flag := 'Y';
                  v_op_line_cd       := NVL(open_pol.line_cd,v_op_line_cd);          
                  v_op_subline_cd    := NVL(open_pol.op_subline_cd,v_op_subline_cd);      
                  v_op_iss_cd        := NVL(open_pol.op_iss_cd,v_op_iss_cd);        
                  v_op_pol_seqno     := NVL(open_pol.op_pol_seqno,v_op_pol_seqno);        
                  v_decltn_no        := NVL(open_pol.decltn_no,v_decltn_no);        
                  v_op_eff_date      := NVL(open_pol.eff_date,v_op_eff_date);                
                  v_op_issue_yy      := NVL(open_pol.op_issue_yy, v_op_issue_yy);         
                END LOOP;
              END IF;   

       
          END LOOP;

          IF v_acct_of_cd_sw = 'Y' THEN
             v_acct_of_cd := NULL;
          END IF;
           
           
          FOR SEQ IN (
               --SELECT  gixx_polbasic_extract_id_s.nextval extract_id replaced by: Nica 05.23.2013
			   SELECT  gixx_extid_seq.nextval extract_id
                 FROM  dual)
          LOOP
             p_extract_id :=  seq.extract_id; 
             EXIT;
          END LOOP;

         INSERT INTO GIXX_POLBASIC (
                   extract_id,            line_cd,               subline_cd,         iss_cd,     
                   issue_yy,              pol_seq_no,            renew_no,           
                   pol_flag,              eff_date,              incept_date,        issue_date, 
                   expiry_date,           assd_no,               type_cd,    
                   acct_of_cd,            designation,           mortg_name,         address1, 
                   address2,              address3,              tsi_amt,            prem_amt,     
                   pool_pol_no,           no_of_items,           prov_prem_pct,      subline_type_cd, 
                   short_rt_percent,      auto_renew_flag,       prorate_flag,       renew_flag,             
                   pack_pol_flag,         prov_prem_tag,         expiry_tag,         foreign_acc_sw,  
                   invoice_sw,            discount_sw,           ref_pol_no,         prem_warr_tag,
                   co_insurance_sw,       manual_renew_no,       with_tariff_sw,      incept_tag,
                   region_cd,             industry_cd,           cred_branch)    
          VALUES ( p_extract_id,          pol.line_cd,           pol.subline_cd,     pol.iss_cd,           
                   pol.issue_yy,          pol.pol_seq_no,        pol.renew_no,             
                   v_pol_flag,            v_eff_date,            v_incept_date,      v_issue_date,     
                   v_expiry_date,         v_assd_no,             v_type_cd,       
                   v_acct_of_cd,          v_designation,         v_mortg_name,       v_address1,        
                   v_address2,            v_address3,            v_tsi_amt,          v_prem_amt,
                   v_pool_pol_no,         v_no_of_items,         v_prov_prem_pct,    v_subline_type_cd, 
                   v_short_rt_percent,    v_auto_renew_flag,     v_prorate_flag,     v_renew_flag,
                   v_pack_pol_flag,       v_prov_prem_tag,       v_expiry_tag,       v_foreign_acc_sw,
                   v_invoice_sw,          v_discount_sw,         v_ref_pol_no,       v_prem_warr_tag,
                   v_co_insurance_sw,     v_manual_renew_no,     v_with_tariff_sw,   v_incept_tag,
                   v_region_cd,           v_industry_cd,         v_cred_branch); 

           v_subline_cd         :=    NULL;
           v_pol_flag           :=    NULL;
           v_eff_date           :=    NULL;
           v_incept_date        :=    NULL;
           v_issue_date         :=    NULL;
           v_expiry_date        :=    NULL;
           v_endt_type          :=    NULL;
           v_assd_no            :=    NULL;
           v_type_cd            :=    NULL;
           v_acct_of_cd         :=    NULL;
           v_designation        :=    NULL;
           v_mortg_name         :=    NULL;
           v_address1           :=    NULL;
           v_address2           :=    NULL;
           v_address3           :=    NULL;
           v_tsi_amt            :=    NULL;
           v_prem_amt           :=    NULL;
           v_pool_pol_no        :=    NULL;
           v_no_of_items        :=    NULL;
           v_prov_prem_pct      :=    NULL;
           v_subline_type_cd    :=    NULL;
           v_short_rt_percent   :=    NULL;
           v_auto_renew_flag    :=    NULL;
           v_prorate_flag       :=    NULL;
           v_renew_flag         :=    NULL;
           v_pack_pol_flag      :=    NULL;
           v_prov_prem_tag      :=    NULL;
           v_expiry_tag         :=    NULL;
           v_foreign_acc_sw     :=    NULL;
           v_invoice_sw         :=    NULL;
           v_discount_sw        :=    NULL;                     
           v_manual_renew_no    :=    NULL;                     
           v_with_tariff_sw     :=    NULL;                     
           v_incept_tag         :=    NULL;                     
           v_industry_cd        :=    NULL;                     
           v_region_cd          :=    NULL;                     
           v_cred_branch        :=    NULL;                     

          IF v_open_policy_flag = 'Y' THEN

             INSERT INTO GIXX_OPEN_POLICY(
                     extract_id,        line_cd,
                     op_subline_cd,     op_iss_cd,
                     op_pol_seqno,      decltn_no,      
                     eff_date,          op_issue_yy)
             VALUES( p_extract_id,      v_op_line_cd,  
                     v_op_subline_cd,   v_op_iss_cd, 
                     v_op_pol_seqno,    v_decltn_no,      
                     v_op_eff_date,        v_op_issue_yy);   

             v_open_policy_flag := 'N';
             v_op_line_cd     := NULL;
             v_op_subline_cd  := NULL;
             v_op_iss_cd      := NULL;
             v_op_pol_seqno   := NULL;
             v_decltn_no      := NULL;  
             v_op_eff_date    := NULL;
             v_op_issue_yy    := NULL;
          END IF;

      END LOOP;

    END;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : April 29, 2013
    **  Reference By  : GIPIS100 - View Policy Information
    **  Description   : Populate the extracted summary tables (Part 2)
    */
       
    PROCEDURE populate_summary_tab_b
        (p_extract_id   IN  NUMBER,
         p_policy_id    IN   GIPI_POLBASIC.policy_id%TYPE,
         p_line_cd      IN   GIPI_POLBASIC.line_cd%TYPE,
         p_subline_cd   IN   GIPI_POLBASIC.subline_cd%TYPE,
         p_iss_cd       IN   GIPI_POLBASIC.iss_cd%TYPE,
         p_issue_yy     IN   GIPI_POLBASIC.issue_yy%TYPE,
         p_pol_seq_no   IN   GIPI_POLBASIC.pol_seq_no%TYPE,
         p_renew_no     IN   GIPI_POLBASIC.renew_no%TYPE,
         p_co_sw        IN   GIPI_POLBASIC.co_insurance_sw%TYPE) IS
         
      v_param_line_cd   GIPI_POLBASIC.line_cd%TYPE;
         
    BEGIN
        
      FOR i IN (SELECT policy_id
                  FROM gipi_polbasic
                 WHERE line_cd = p_line_cd
                   AND subline_cd = p_subline_cd
                   AND iss_cd = p_iss_cd
                   AND issue_yy = p_issue_yy
                   AND pol_seq_no = p_pol_seq_no
                   AND renew_no = p_renew_no)
      LOOP
         
          GIPIS100_EXTRACT_SUMMARY.populate_bond(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, i.policy_id, p_extract_id);

          GIPIS100_EXTRACT_SUMMARY.populate_item(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, i.policy_id, p_extract_id, v_param_line_cd);

          GIPIS100_EXTRACT_SUMMARY.populate_open_liab(p_extract_id, i.policy_id, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);

          GIPIS100_EXTRACT_SUMMARY.populate_open_peril(p_extract_id, i.policy_id, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
        	
          GIPIS100_EXTRACT_SUMMARY.populate_cargo_carrier(p_extract_id, i.policy_id, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);  


          IF v_param_line_cd = GIISP.V('LINE_CODE_CA') AND
             p_subline_cd = GIISP.V('BANKERS BLANKET INSURANCE') THEN
             	
             GIPIS100_EXTRACT_SUMMARY.populate_bank_schedule(p_extract_id, i.policy_id, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
             
          END IF;      

          IF p_co_sw != '1' THEN
             GIPIS100_EXTRACT_SUMMARY.populate_main(p_extract_id, p_co_sw, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
          END IF;
      
      END LOOP;

    END;
        
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : April 29, 2013
    **  Reference By  : GIPIS100 - View Policy Information
    **  Description   : Populate the gixx_bond_basic table
    */
    
    PROCEDURE populate_bond 
    (p_line_cd      IN   GIPI_POLBASIC.line_cd%TYPE,
     p_subline_cd   IN   GIPI_POLBASIC.subline_cd%TYPE,
     p_iss_cd       IN   GIPI_POLBASIC.iss_cd%TYPE,
     p_issue_yy     IN   GIPI_POLBASIC.issue_yy%TYPE,
     p_pol_seq_no   IN   GIPI_POLBASIC.pol_seq_no%TYPE,
     p_renew_no     IN   GIPI_POLBASIC.renew_no%TYPE,
	 p_policy_id    IN   GIPI_POLBASIC.policy_id%TYPE,
     p_extract_id   IN   NUMBER) IS

      exist                   VARCHAR2(1) := 'N';
      exist2                  VARCHAR2(1) := 'N';
      v_policy_id             GIPI_BOND_BASIC.policy_id%TYPE;
      v_obligee_no            GIPI_BOND_BASIC.obligee_no%TYPE;
      v_prin_id               GIPI_BOND_BASIC.prin_id%TYPE;
      v_coll_flag             GIPI_BOND_BASIC.coll_flag%TYPE;
      v_clause_type           GIPI_BOND_BASIC.clause_type%TYPE;
      v_val_period_unit       GIPI_BOND_BASIC.val_period_unit%TYPE;
      v_val_period            GIPI_BOND_BASIC.val_period%TYPE;
      v_np_no                 GIPI_BOND_BASIC.np_no%TYPE;
      v_contract_dtl          GIPI_BOND_BASIC.contract_dtl%TYPE;
      v_contract_date         GIPI_BOND_BASIC.contract_date%TYPE;
      v_co_prin_sw            GIPI_BOND_BASIC.co_prin_sw%TYPE;
      v_waiver_limit          GIPI_BOND_BASIC.waiver_limit%TYPE;
      v_indemnity_text        GIPI_BOND_BASIC.indemnity_text%TYPE;
      v_bond_dtl              GIPI_BOND_BASIC.bond_dtl%TYPE;
      v_endt_eff_date         GIPI_BOND_BASIC.endt_eff_date%TYPE;
      v_remarks               GIPI_BOND_BASIC.remarks%TYPE;
      

       BEGIN
           FOR bond IN (
			  SELECT policy_id,      obligee_no,      prin_id,       coll_flag,
					 clause_type,    val_period_unit, val_period,    np_no,
					 contract_dtl,   contract_date,   co_prin_sw,    waiver_limit,
					 indemnity_text, bond_dtl,        endt_eff_date, remarks
				FROM gipi_bond_basic
			   WHERE policy_id = p_policy_id)
		   LOOP
		   		v_obligee_no         := NVL(bond.obligee_no,v_obligee_no);
				v_prin_id            := NVL(bond.prin_id,v_prin_id);
				v_coll_flag          := NVL(bond.coll_flag,v_coll_flag);
				v_clause_type        := NVL(bond.clause_type,v_clause_type);
				v_val_period_unit    := NVL(bond.val_period_unit,v_val_period_unit);
				v_val_period         := NVL(bond.val_period,v_val_period);
				v_np_no              := NVL(bond.np_no,v_np_no);
				v_contract_dtl       := NVL(bond.contract_dtl,v_contract_dtl);
				v_contract_date      := NVL(bond.contract_date,v_contract_date);
				v_co_prin_sw         := NVL(bond.co_prin_sw,v_co_prin_sw);
				v_waiver_limit       := NVL(bond.waiver_limit,v_waiver_limit);
				v_indemnity_text     := NVL(bond.indemnity_text,v_indemnity_text);
				v_bond_dtl           := NVL(bond.bond_dtl,v_bond_dtl);
				v_endt_eff_date      := NVL(bond.endt_eff_date,v_endt_eff_date);
				v_remarks            := NVL(bond.remarks,v_remarks);
			
		   		FOR bond_exist IN (
				   SELECT 'a'
					 FROM GIXX_BOND_BASIC
					WHERE extract_id = p_extract_id)
			   LOOP
				  exist2 := 'Y';
			   END LOOP; 
			   
			   IF exist2 = 'N' THEN
				  FOR pol IN (SELECT policy_id   
							 FROM GIPI_POLBASIC
							WHERE line_cd     = p_line_cd
							  AND subline_cd  = p_subline_cd
							  AND iss_cd      = p_iss_cd
							  AND issue_yy    = p_issue_yy
							  AND pol_seq_no  = p_pol_seq_no
							  AND renew_no    = p_renew_no
							  AND pol_flag    != '5'
						   ORDER BY eff_date)
				   LOOP
					  v_policy_id := pol.policy_id;
					  
					  FOR endt_bond IN (
						  SELECT policy_id,      obligee_no,      prin_id,       coll_flag,
								 clause_type,    val_period_unit, val_period,    np_no,
								 contract_dtl,   contract_date,   co_prin_sw,    waiver_limit,
								 indemnity_text, bond_dtl,        endt_eff_date, remarks
							FROM GIPI_BOND_BASIC
						   WHERE policy_id = v_policy_id)
					   LOOP
							 v_obligee_no         := NVL(endt_bond.obligee_no,v_obligee_no);
							 v_prin_id            := NVL(endt_bond.prin_id,v_prin_id);
							 v_coll_flag          := NVL(endt_bond.coll_flag,v_coll_flag);
							 v_clause_type        := NVL(endt_bond.clause_type,v_clause_type);
							 v_val_period_unit    := NVL(endt_bond.val_period_unit,v_val_period_unit);
							 v_val_period         := NVL(endt_bond.val_period,v_val_period);
							 v_np_no              := NVL(endt_bond.np_no,v_np_no);
							 v_contract_dtl       := NVL(endt_bond.contract_dtl,v_contract_dtl);
							 v_contract_date      := NVL(endt_bond.contract_date,v_contract_date);
							 v_co_prin_sw         := NVL(endt_bond.co_prin_sw,v_co_prin_sw);
							 v_waiver_limit       := NVL(endt_bond.waiver_limit,v_waiver_limit);
							 v_indemnity_text     := NVL(endt_bond.indemnity_text,v_indemnity_text);
							 v_bond_dtl           := NVL(endt_bond.bond_dtl,v_bond_dtl);
							 v_endt_eff_date      := NVL(endt_bond.endt_eff_date,v_endt_eff_date);
							 v_remarks            := NVL(endt_bond.remarks,v_remarks);
					   END LOOP;
					   
				   END LOOP;
				   
				   INSERT INTO GIXX_BOND_BASIC(
							extract_id,       obligee_no,    prin_id,    
							coll_flag,        clause_type,   val_period_unit, 
							val_period,       np_no,         contract_dtl,       
							contract_date,    co_prin_sw,    waiver_limit,       
							indemnity_text,   bond_dtl,     endt_eff_date,      
							remarks          ) 
					 VALUES(p_extract_id,     v_obligee_no,  v_prin_id,    
							v_coll_flag,      v_clause_type, v_val_period_unit, 
							v_val_period,     v_np_no,       v_contract_dtl,       
							v_contract_date,  v_co_prin_sw,  v_waiver_limit,       
							v_indemnity_text, v_bond_dtl,    v_endt_eff_date,      
							v_remarks        );
				   
			   END IF; 
	   	   END LOOP;
           
		   

       END;
       
       /*
        **  Created by    : Veronica V. Raymundo
        **  Date Created  : April 29, 2013
        **  Reference By  : GIPIS100 - View Policy Information
        **  Description   : Populate the GIXX_INVOICE table
        */
    
       PROCEDURE populate_invoice (p_extract_id   IN   NUMBER,
                                   p_policy_id    IN   GIPI_POLBASIC.policy_id%TYPE) IS

          v_iss_cd             GIPI_INVOICE.iss_cd%TYPE;
          v_prem_seq_no        GIPI_INVOICE.prem_seq_no%TYPE;
          v_item_grp           GIPI_INVOICE.item_grp%TYPE;
          v_prem_amt           GIPI_INVOICE.prem_amt%TYPE;
          v_tax_amt            GIPI_INVOICE.tax_amt%TYPE;
          v_due_date           GIPI_INVOICE.due_date%TYPE;
          v_ri_comm_amt        GIPI_INVOICE.ri_comm_amt%TYPE;
          v_currency_cd        GIPI_INVOICE.currency_cd%TYPE;
          v_currency_rt        GIPI_INVOICE.currency_rt%TYPE;
          v_other_charges      GIPI_INVOICE.other_charges%TYPE;
          v_notarial_fee       GIPI_INVOICE.notarial_fee%TYPE;
          v_ref_inv_no         GIPI_INVOICE.ref_inv_no%TYPE;
          exist                VARCHAR2(1) := 'N';
          v_exist              VARCHAR2(1) := 'N';

        BEGIN
            FOR invoice IN(
              SELECT iss_cd,      prem_seq_no,   item_grp,     prem_amt,       
                     tax_amt,     due_date,      ri_comm_amt,  currency_cd,    
                     currency_rt, other_charges, notarial_fee, ref_inv_no
                FROM GIPI_INVOICE
               WHERE policy_id = p_policy_id)
          LOOP   
            exist            := 'Y';
            v_iss_cd         := invoice.iss_cd;
            v_prem_seq_no    := invoice.prem_seq_no;
            v_item_grp       := invoice.item_grp;
            v_prem_amt       := invoice.prem_amt;
            v_tax_amt        := invoice.tax_amt;
            v_due_date       := invoice.due_date;
            v_ri_comm_amt    := invoice.ri_comm_amt;
            v_currency_cd    := invoice.currency_cd;
            v_currency_rt    := invoice.currency_rt;
            v_other_charges  := invoice.other_charges;
            v_notarial_fee   := invoice.notarial_fee;
            v_ref_inv_no     := invoice.ref_inv_no;

            FOR exist IN ( SELECT 1
                             FROM GIXX_INVOICE
                            WHERE iss_cd = v_iss_cd
                              AND prem_seq_no = v_prem_seq_no
                              AND extract_id =  p_extract_id) 
            LOOP                   
                v_exist := 'Y';
                EXIT;
            END LOOP;
            
            IF v_exist = 'N' THEN
               INSERT INTO gixx_invoice (
                     iss_cd,          prem_seq_no,    item_grp,       
                     prem_amt,        tax_amt,        ri_comm_amt,    
                     due_date,        currency_cd,    currency_rt,     
                     other_charges,   notarial_fee,   extract_id,
                     ref_inv_no)   
                    VALUES( v_iss_cd,        v_prem_seq_no,  v_item_grp,       
                     v_prem_amt,      v_tax_amt,      v_ri_comm_amt,    
                     v_due_date,      v_currency_cd,  v_currency_rt,     
                     v_other_charges, v_notarial_fee, p_extract_id,
                     v_ref_inv_no );  
               
               v_iss_cd         := NULL;
               v_prem_seq_no    := NULL;
               v_item_grp       := NULL;
               v_prem_amt       := NULL;
               v_tax_amt        := NULL;
               v_due_date       := NULL;
               v_ri_comm_amt    := NULL;
               v_currency_cd    := NULL;
               v_currency_rt    := NULL;
               v_other_charges  := NULL;
               v_notarial_fee   := NULL;
               v_ref_inv_no     := NULL;
             
               GIPIS100_EXTRACT_SUMMARY.populate_prem_collns(p_extract_id,v_iss_cd,v_prem_seq_no);
            END IF; 
          END LOOP;

        END;
        
        /*
        **  Created by    : Veronica V. Raymundo
        **  Date Created  : April 29, 2013
        **  Reference By  : GIPIS100 - View Policy Information
        **  Description   : Populate the GIAC_DIRECT_PREM_COLLNS table
        */
        
        PROCEDURE populate_prem_collns (p_extract_id  IN NUMBER,
                                        p_iss_cd      IN GIPI_INVOICE.iss_cd%TYPE,
                                        p_prem_seq_no IN GIPI_INVOICE.prem_seq_no%TYPE)IS
          
          v_gacc_tran_id               GIAC_DIRECT_PREM_COLLNS.gacc_tran_id%TYPE;
          v_transaction_type           GIAC_DIRECT_PREM_COLLNS.transaction_type%TYPE;       
          v_collection_amt             GIAC_DIRECT_PREM_COLLNS.collection_amt%TYPE;         
          v_premium_amt                GIAC_DIRECT_PREM_COLLNS.premium_amt%TYPE;            
          v_tax_amt                    GIAC_DIRECT_PREM_COLLNS.tax_amt%TYPE;                
          v_particulars                GIAC_DIRECT_PREM_COLLNS.particulars%TYPE;            
          v_currency_cd                GIAC_DIRECT_PREM_COLLNS.currency_cd%TYPE;            
          v_convert_rate               GIAC_DIRECT_PREM_COLLNS.convert_rate%TYPE;           
          v_foreign_curr_amt           GIAC_DIRECT_PREM_COLLNS.foreign_curr_amt%TYPE;       
          v_doc_no                     GIAC_DIRECT_PREM_COLLNS.doc_no%TYPE;                 
          v_colln_dt                   GIAC_DIRECT_PREM_COLLNS.colln_dt%TYPE;               
          v_inst_no                    GIAC_DIRECT_PREM_COLLNS.inst_no%TYPE;
          v_user_id                    GIAC_DIRECT_PREM_COLLNS.user_id%TYPE;                
          v_last_update                GIAC_DIRECT_PREM_COLLNS.last_update%TYPE;            
          exist                         VARCHAR2(1) := 'N';

        BEGIN
           FOR prem IN(
             SELECT transaction_type, collection_amt,   premium_amt, 
                    tax_amt,          particulars,      currency_cd,
                    convert_rate,     foreign_curr_amt, doc_no,
                    colln_dt,         inst_no,          user_id,
                    last_update,      gacc_tran_id
               FROM GIAC_DIRECT_PREM_COLLNS
              WHERE b140_iss_cd      = p_iss_cd
                AND b140_prem_seq_no = p_prem_seq_no)
           LOOP 
             exist                      := 'Y';
             v_gacc_tran_id             := prem.gacc_tran_id;
             v_transaction_type         := prem.transaction_type;       
             v_collection_amt           := NVL(prem.collection_amt,0);         
             v_premium_amt              := NVL(prem.premium_amt,0);            
             v_tax_amt                  := NVL(prem.tax_amt,0);                
             v_particulars              := prem.particulars;            
             v_currency_cd              := prem.currency_cd;            
             v_convert_rate             := prem.convert_rate;           
             v_foreign_curr_amt         := NVL(prem.foreign_curr_amt,0);       
             v_doc_no                   := prem.doc_no;                 
             v_colln_dt                 := prem.colln_dt;               
             v_inst_no                  := prem.inst_no;
             v_user_id                  := prem.user_id;                
             v_last_update              := prem.last_update;
                         
             INSERT INTO GIXX_DIRECT_PREM_COLLNS(
                     extract_id,   transaction_type, iss_cd,                 
                     prem_seq_no,  collection_amt,   premium_amt,            
                     tax_amt,      particulars,      currency_cd,            
                     convert_rate, foreign_curr_amt, doc_no,                 
                     colln_dt,     inst_no,          user_id,                
                     last_update,  gacc_tran_id)            
             VALUES( p_extract_id,   v_transaction_type, p_iss_cd,                 
                     p_prem_seq_no,  v_collection_amt,   v_premium_amt,            
                     v_tax_amt,      v_particulars,      v_currency_cd,            
                     v_convert_rate, v_foreign_curr_amt, v_doc_no,                 
                     v_colln_dt,     v_inst_no,          v_user_id,                
                     v_last_update,  v_gacc_tran_id);
                     
             v_gacc_tran_id     := NULL;
             v_transaction_type := NULL;
             v_collection_amt   := NULL;
             v_premium_amt      := NULL;
             v_tax_amt          := NULL;
             v_particulars      := NULL;
             v_currency_cd      := NULL;
             v_convert_rate     := NULL;
             v_foreign_curr_amt := NULL;
             v_doc_no           := NULL;
             v_colln_dt         := NULL;
             v_inst_no          := NULL;
             v_user_id          := NULL;
             v_last_update      := NULL;
             
            END LOOP;
            
        END;
        
                
       /*
        **  Created by    : Veronica V. Raymundo
        **  Date Created  : April 29, 2013
        **  Reference By  : GIPIS100 - View Policy Information
        **  Description   : Populate GIXX_CLAIMS table
        */
        
        PROCEDURE populate_claims (p_extract_id   IN   NUMBER,
                                   p_policy_id    IN   GIPI_POLBASIC.policy_id%TYPE) IS
                                   
           exist                VARCHAR2(1) := 'N';
           v_claim_id           GICL_CLAIMS.claim_id%TYPE;       
           v_line_cd            GICL_CLAIMS.line_cd%TYPE;        
           v_subline_cd         GICL_CLAIMS.subline_cd%TYPE;     
           v_clm_yy             GICL_CLAIMS.clm_yy%TYPE;         
           v_clm_seq_no         GICL_CLAIMS.clm_seq_no%TYPE;     
           v_iss_cd             GICL_CLAIMS.iss_cd%TYPE;         
           v_clm_stat_cd        GICL_CLAIMS.clm_stat_cd%TYPE;    
           v_clm_setl_date      GICL_CLAIMS.clm_setl_date%TYPE;  
           v_clm_file_date      GICL_CLAIMS.clm_file_date%TYPE;  
           v_loss_date          GICL_CLAIMS.loss_date%TYPE;      
           v_loss_pd_amt        GICL_CLAIMS.loss_pd_amt%TYPE;    
           v_loss_res_amt       GICL_CLAIMS.loss_res_amt%TYPE;   
           v_exp_pd_amt         GICL_CLAIMS.exp_pd_amt%TYPE;     
           v_ri_cd              GICL_CLAIMS.ri_cd%TYPE;          
           v_user_id            GICL_CLAIMS.user_id%TYPE;        
           v_entry_date         GICL_CLAIMS.entry_date%TYPE;     
           v_loss_loc1          GICL_CLAIMS.loss_loc1%TYPE;      
           v_loss_loc2          GICL_CLAIMS.loss_loc2%TYPE;      
           v_loss_loc3          GICL_CLAIMS.loss_loc3%TYPE;      
           v_in_hou_adj         GICL_CLAIMS.in_hou_adj%TYPE;     
           v_clm_control        GICL_CLAIMS.clm_control%TYPE;    
           v_clm_coop           GICL_CLAIMS.clm_coop%TYPE;       
           v_assd_no            GICL_CLAIMS.assd_no%TYPE;        
           v_pol_eff_date       GICL_CLAIMS.pol_eff_date%TYPE;   
           v_recovery_sw        GICL_CLAIMS.recovery_sw%TYPE;    
           v_csr_no             GICL_CLAIMS.csr_no%TYPE;         
           v_loss_cat_cd        GICL_CLAIMS.loss_cat_cd%TYPE;    
           v_intm_no            GICL_CLAIMS.intm_no%TYPE;        
           v_clm_amt            GICL_CLAIMS.clm_amt%TYPE;        
           v_loss_dtls          GICL_CLAIMS.loss_dtls%TYPE;     
           v_obligee_no         GICL_CLAIMS.obligee_no%TYPE;     
           v_exp_res_amt        GICL_CLAIMS.exp_res_amt%TYPE;    
           v_assured_name       GICL_CLAIMS.assured_name%TYPE;
           v_exist              VARCHAR2(1) := 'N';
           
        BEGIN

          FOR policy IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                           FROM GIPI_POLBASIC
                          WHERE policy_id = p_policy_id ) 
          LOOP
            
            FOR claims IN (SELECT 1
                             FROM GICL_CLAIMS A, GIXX_CLAIMS b
                            WHERE a.line_cd     = policy.line_cd
                              AND a.subline_cd  = policy.subline_cd
                              AND a.iss_cd      = policy.iss_cd
                              AND a.issue_yy    = policy.issue_yy
                              AND a.pol_seq_no  = policy.pol_seq_no
                              AND a.renew_no    = policy.renew_no
                              AND a.claim_id    = b.claim_id) 
            LOOP                  
                v_exist := 'Y';
                EXIT;
            END LOOP;     

            IF v_exist = 'N' THEN
               FOR clm IN (
                 SELECT claim_id,    line_cd,       subline_cd,     
                        clm_yy,      clm_seq_no,    iss_cd,         
                        clm_stat_cd, clm_setl_date, clm_file_date,  
                        loss_date,   loss_pd_amt,   loss_res_amt,   
                        exp_pd_amt,  ri_cd,         user_id,        
                        entry_date,  loss_loc1,     loss_loc2,      
                        loss_loc3,   in_hou_adj,    clm_control,    
                        clm_coop,    assd_no,       pol_eff_date,   
                        recovery_sw, csr_no,        loss_cat_cd,    
                        intm_no,     clm_amt,       loss_dtls,      
                        obligee_no,  exp_res_amt,   assured_name
                   FROM GICL_CLAIMS
                  WHERE line_cd     = policy.line_cd
                    AND subline_cd  = policy.subline_cd
                    AND iss_cd      = policy.iss_cd
                    AND issue_yy    = policy.issue_yy
                    AND pol_seq_no  = policy.pol_seq_no
                    AND renew_no    = policy.renew_no ) 
               LOOP
                 exist              := 'Y';
                 v_claim_id           := clm.claim_id;       
                 v_line_cd            := clm.line_cd;       
                 v_subline_cd         := clm.subline_cd;     
                 v_clm_yy             := clm.clm_yy;         
                 v_clm_seq_no         := clm.clm_seq_no;     
                 v_iss_cd             := clm.iss_cd;         
                 v_clm_stat_cd        := clm.clm_stat_cd;    
                 v_clm_setl_date      := clm.clm_setl_date;  
                 v_clm_file_date      := clm.clm_file_date;  
                 v_loss_date          := clm.loss_date;      
                 v_loss_pd_amt        := clm.loss_pd_amt;    
                 v_loss_res_amt       := clm.loss_res_amt;   
                 v_exp_pd_amt         := clm.exp_pd_amt;     
                 v_ri_cd              := clm.ri_cd;          
                 v_user_id            := clm.user_id;        
                 v_entry_date         := clm.entry_date;     
                 v_loss_loc1          := clm.loss_loc1;      
                 v_loss_loc2          := clm.loss_loc2;      
                 v_loss_loc3          := clm.loss_loc3;      
                 v_in_hou_adj         := clm.in_hou_adj;     
                 v_clm_control        := clm.clm_control;    
                 v_clm_coop           := clm.clm_coop;       
                 v_assd_no            := clm.assd_no;        
                 v_pol_eff_date       := clm.pol_eff_date;   
                 v_recovery_sw        := clm.recovery_sw;    
                 v_csr_no             := clm.csr_no;         
                 v_loss_cat_cd        := clm.loss_cat_cd;    
                 v_intm_no            := clm.intm_no;        
                 v_clm_amt            := clm.clm_amt;        
                 v_loss_dtls          := clm.loss_dtls;      
                 v_obligee_no         := clm.obligee_no;     
                 v_exp_res_amt        := clm.exp_res_amt;    
                 v_assured_name        := clm.assured_name;

                 INSERT INTO GIXX_CLAIMS(
                      extract_id,      claim_id,        line_cd,     subline_cd,     
                      clm_yy,          clm_seq_no,      iss_cd,      clm_stat_cd,
                      clm_setl_date,   clm_file_date,   loss_date,   loss_pd_amt, 
                      loss_res_amt,    exp_pd_amt,      ri_cd,       user_id,        
                      entry_date,      loss_loc1,       loss_loc2,   loss_loc3,
                      in_hou_adj,      clm_control,     clm_coop,    assd_no,
                      pol_eff_date,    recovery_sw,     csr_no,      loss_cat_cd,    
                      intm_no,         clm_amt,         loss_dtls,   obligee_no, 
                      exp_res_amt,     assured_name)
                     VALUES ( 
                      p_extract_id,    v_claim_id,      v_line_cd,   v_subline_cd,     
                      v_clm_yy,        v_clm_seq_no,    v_iss_cd,    v_clm_stat_cd,
                      v_clm_setl_date, v_clm_file_date, v_loss_date, v_loss_pd_amt, 
                      v_loss_res_amt,  v_exp_pd_amt,    v_ri_cd,     v_user_id,        
                      v_entry_date,    v_loss_loc1,     v_loss_loc2, v_loss_loc3,
                      v_in_hou_adj,    v_clm_control,   v_clm_coop,  v_assd_no,
                      v_pol_eff_date,  v_recovery_sw,   v_csr_no,    v_loss_cat_cd,    
                      v_intm_no,       v_clm_amt,       v_loss_dtls, v_obligee_no, 
                      v_exp_res_amt,   v_assured_name);

                   v_claim_id           := NULL;
                   v_line_cd            := NULL;
                   v_subline_cd         := NULL;
                   v_clm_yy             := NULL;
                   v_clm_seq_no         := NULL;
                   v_iss_cd             := NULL;
                   v_clm_stat_cd        := NULL;
                   v_clm_setl_date      := NULL;
                   v_clm_file_date      := NULL;
                   v_loss_date          := NULL;
                   v_loss_pd_amt        := NULL;
                   v_loss_res_amt       := NULL;
                   v_exp_pd_amt         := NULL;
                   v_ri_cd              := NULL;
                   v_user_id            := NULL;
                   v_entry_date         := NULL;
                   v_loss_loc1          := NULL;
                   v_loss_loc2          := NULL;
                   v_loss_loc3          := NULL;
                   v_in_hou_adj         := NULL;
                   v_clm_control        := NULL;
                   v_clm_coop           := NULL;
                   v_assd_no            := NULL;
                   v_pol_eff_date       := NULL;
                   v_recovery_sw        := NULL;
                   v_csr_no             := NULL;
                   v_loss_cat_cd        := NULL;
                   v_intm_no            := NULL;
                   v_clm_amt            := NULL;
                   v_loss_dtls          := NULL;
                   v_obligee_no         := NULL;
                   v_exp_res_amt        := NULL;
                   v_assured_name       := NULL;
               END LOOP;
            END IF;
          END LOOP;

        END;
        
        /*
        **  Created by    : Veronica V. Raymundo
        **  Date Created  : April 29, 2013
        **  Reference By  : GIPIS100 - View Policy Information
        **  Description   : Populate GIXX_PICTURES table
        */
        
        PROCEDURE populate_pictures (p_extract_id   IN   NUMBER,
                                     p_policy_id    IN   GIPI_POLBASIC.policy_id%TYPE) IS
           
           exist                VARCHAR2(1) := 'N';
           v_item               GIPI_PICTURES.item_no%TYPE;
           v_file               GIPI_PICTURES.FILE_NAME%TYPE;
           v_file_type          GIPI_PICTURES.FILE_TYPE%TYPE;
           v_file_ext           GIPI_PICTURES.FILE_EXT%TYPE;
           v_remarks            GIPI_PICTURES.REMARKS%TYPE;
           v_pol_file           GIPI_PICTURES.POL_FILE_NAME%TYPE;
           v_user_id            GIPI_PICTURES.user_id%TYPE; 
           v_last_update        GIPI_PICTURES.last_update%TYPE;
        BEGIN
          
          FOR pic IN (
            SELECT item_no,     file_name,  file_type, 
                   file_ext,    remarks,    pol_file_name,
                   user_id,     last_update
              FROM GIPI_PICTURES
             WHERE policy_id = p_policy_id) 
          LOOP
            v_item        := pic.item_no;
            v_file        := pic.file_name;
            v_file_type   := pic.file_type;
            v_file_ext    := pic.file_ext;
            v_remarks     := pic.remarks;
            v_pol_file    := pic.pol_file_name;
            v_user_id     := pic.user_id;    
            v_last_update := pic.last_update;
               
            INSERT INTO GIXX_PICTURES(
                 extract_id,      item_no, 
                 file_name,             file_type, 
                 file_ext,                 remarks, 
                 user_id,                 last_update, 
                 pol_file_name)
            VALUES ( 
                 p_extract_id,    v_item,
                 v_file,          v_file_type,
                 v_file_ext,      v_remarks,
                 v_user_id,       v_last_update,
                 v_pol_file);

                 v_item         := NULL;
                 v_file         := NULL;
                 v_file_type    := NULL;
                 v_file_ext     := NULL;
                 v_remarks      := NULL;
                 v_pol_file     := NULL;
                 
          END LOOP;
        END;
               
       /*
        **  Created by    : Veronica V. Raymundo
        **  Date Created  : April 29, 2013
        **  Reference By  : GIPIS100 - View Policy Information
        **  Description   : Populate gixx_deductibles table
        */
       
       PROCEDURE populate_deductibles (p_extract_id   IN   NUMBER,
                                       p_policy_id    IN   GIPI_POLBASIC.policy_id%TYPE,
                                       p_item_no      IN   GIPI_ITEM.item_no%TYPE)IS

          v_deductibles_flag      VARCHAR2(1) := 'N';
          v_ded_line_cd           GIPI_DEDUCTIBLES.ded_line_cd%TYPE;
          v_ded_subline_cd        GIPI_DEDUCTIBLES.ded_subline_cd%TYPE;
          v_ded_deductible_cd     GIPI_DEDUCTIBLES.ded_deductible_cd%TYPE;
          v_deductible_text       GIPI_DEDUCTIBLES.deductible_text%TYPE;
          v_deductible_amt        GIPI_DEDUCTIBLES.deductible_amt%TYPE;

        BEGIN
            FOR exist IN (
              SELECT 'a'
                FROM GIXX_DEDUCTIBLES
               WHERE extract_id = p_extract_id
                 AND item_no    = p_item_no)
            LOOP
               RETURN;
            END LOOP;

            FOR ded IN (
               SELECT ded_line_cd, 
                      ded_subline_cd,
                      ded_deductible_cd,
                      deductible_text,
                      deductible_amt
                 FROM GIPI_DEDUCTIBLES
                WHERE policy_id = p_policy_id
                  AND item_no   = p_item_no)
            LOOP   
              v_deductibles_flag         := 'Y'; 
              v_ded_line_cd              := NVL(ded.ded_line_cd,v_ded_line_cd);
              v_ded_subline_cd           := NVL(ded.ded_subline_cd,v_ded_subline_cd);
              v_ded_deductible_cd        := NVL(ded.ded_deductible_cd,v_ded_deductible_cd);
              v_deductible_text          := NVL(ded.deductible_text,v_deductible_text);
              v_deductible_amt           := NVL(ded.deductible_amt,v_deductible_amt) ;
            END LOOP;
                  
            IF v_deductibles_flag = 'Y' THEN 
              INSERT INTO GIXX_DEDUCTIBLES(
                      extract_id,          item_no,
                      ded_line_cd,         ded_subline_cd,
                      ded_deductible_cd,   deductible_text,
                      deductible_amt)
              VALUES( p_extract_id,        p_item_no,
                      v_ded_line_cd,       v_ded_subline_cd,
                      v_ded_deductible_cd, v_deductible_text,
                      v_deductible_amt);

              v_deductibles_flag         := 'N'; 
              v_ded_line_cd              := NULL;
              v_ded_subline_cd           := NULL;
              v_ded_deductible_cd        := NULL;
              v_deductible_text          := NULL;
              v_deductible_amt           := NULL;
            END IF;
            
        END;
        
        /*
        **  Created by    : Veronica V. Raymundo
        **  Date Created  : April 29, 2013
        **  Reference By  : GIPIS100 - View Policy Information
        **  Description   : Populate gixx_mortgagee table
        */
        
        PROCEDURE populate_mortgagee (p_extract_id IN NUMBER,
                                      p_policy_id  IN   GIPI_POLBASIC.policy_id%TYPE)
        IS

         v_iss_cd                    GIPI_MORTGAGEE.iss_cd%TYPE;
         v_mortg_cd                  GIPI_MORTGAGEE.mortg_cd%TYPE;
         v_amount                    GIPI_MORTGAGEE.amount%TYPE; 
         v_remarks                   GIPI_MORTGAGEE.remarks%TYPE;   
         v_item_no                   GIPI_MORTGAGEE.item_no%TYPE;
         v_exist                     VARCHAR2(1) := 'N';
         v_new_amount                GIXX_MORTGAGEE.amount%TYPE;
         v_old_amount                GIXX_MORTGAGEE.amount%TYPE;

        BEGIN
            
           FOR mort IN (
             SELECT iss_cd, mortg_cd, amount, remarks, item_no                   
               FROM GIPI_MORTGAGEE
              WHERE policy_id = p_policy_id
                AND NVL(delete_sw,'N') = 'N')
                
           LOOP
             v_iss_cd             := NVL(mort.iss_cd,v_iss_cd);       
             v_mortg_cd           := NVL(mort.mortg_cd,v_mortg_cd);              
             v_amount             := NVL(mort.amount,v_amount);              
             v_remarks            := NVL(mort.remarks,v_remarks);
             v_item_no            := NVL(mort.item_no,v_item_no);              
             v_exist              := 'N';    

                     
             FOR exist in (SELECT 'a'                     -- checks if combination of mortg_cd, item_no,       
                           FROM GIXX_MORTGAGEE            -- iss_cd and item_no already exists in gixx_mortgagee
                          WHERE iss_cd = v_iss_cd
                            AND extract_id = p_extract_id
                            AND item_no = v_item_no
                            AND mortg_cd = v_mortg_cd)
             LOOP
                 v_exist := 'Y';
             END LOOP;
               
             IF v_exist = 'Y' THEN

                 FOR x IN (SELECT amount
                           FROM GIXX_MORTGAGEE
                           WHERE iss_cd = v_iss_cd
                             AND extract_id = p_extract_id
                             AND item_no = v_item_no
                             AND mortg_cd = v_mortg_cd)
                 LOOP
                      
                    v_old_amount := x.amount;
                    v_new_amount := v_old_amount + v_amount;       
                 END LOOP;
                        
                   
                 UPDATE GIXX_MORTGAGEE
                   SET amount = v_new_amount
                 WHERE extract_id = p_extract_id
                   AND iss_cd = v_iss_cd
                   AND mortg_cd = v_mortg_cd
                   and item_no = v_item_no;
                        
                    v_iss_cd       := NULL;       
                    v_mortg_cd     := NULL;       
                    v_amount       := NULL;       
                    v_remarks      := NULL;
                    v_item_no      := NULL;       
         
             ELSE
                   
                INSERT INTO GIXX_MORTGAGEE(extract_id, item_no, iss_cD,                    
                                           mortg_cd, amount, remarks)                   

                                 VALUES(p_extract_id, v_item_no, v_iss_cd,                    
                                        v_mortg_cd, v_amount, v_remarks);                   
            
                v_iss_cd        := NULL;       
                v_mortg_cd      := NULL;       
                v_amount        := NULL;       
                v_remarks       := NULL;       

             END IF;
             
           END LOOP;

        END;
        
         /*
        **  Created by    : Veronica V. Raymundo
        **  Date Created  : April 29, 2013
        **  Reference By  : GIPIS100 - View Policy Information
        **  Description   : Populate gixx_grouped_items table
        */
        
         PROCEDURE populate_group_items (p_extract_id   IN   NUMBER,
                                         p_policy_id    IN   GIPI_POLBASIC.policy_id%TYPE,
                                         p_item_no      IN   GIPI_ITEM.item_no%TYPE,
                                         p_grouped_items_flag OUT VARCHAR2) IS

           v_grouped_item_no     GIPI_GROUPED_ITEMS.grouped_item_no%TYPE;
           v_grouped_item_title  GIPI_GROUPED_ITEMS.grouped_item_title%TYPE;
           v_amount_coverage     GIPI_GROUPED_ITEMS.amount_coverage%TYPE;
           v_include_tag         GIPI_GROUPED_ITEMS.include_tag%TYPE;
           v_remarks             GIPI_GROUPED_ITEMS.remarks%TYPE;
           v_line_cd             GIPI_GROUPED_ITEMS.line_cd%TYPE;
           v_subline_cd          GIPI_GROUPED_ITEMS.subline_cd%TYPE;
           v_civil_status        GIPI_GROUPED_ITEMS.CIVIL_STATUS%TYPE;    
           v_date_of_birth       GIPI_GROUPED_ITEMS.DATE_OF_BIRTH%TYPE;        
           v_age                 GIPI_GROUPED_ITEMS.AGE%TYPE;        
           v_sex                 GIPI_GROUPED_ITEMS.SEX%TYPE;        
           v_position_cd         GIPI_GROUPED_ITEMS.POSITION_CD%TYPE;        
           v_salary              GIPI_GROUPED_ITEMS.SALARY%TYPE;        
           v_salary_grade        GIPI_GROUPED_ITEMS.SALARY_GRADE%TYPE;    
           v_group_cd            GIPI_GROUPED_ITEMS.group_cd%TYPE;
           v_delete_sw           GIPI_GROUPED_ITEMS.delete_sw%TYPE; 
           exist                 VARCHAR2(1) := 'N'; 
           v_grouped_item_no1    GIPI_GROUPED_ITEMS.grouped_item_no%TYPE;     
                 
        BEGIN
          FOR grp IN ( 
            SELECT grouped_item_no, grouped_item_title, amount_coverage, include_tag,
                   remarks, line_cd, subline_cd, civil_status, date_of_birth,          
                   age, sex, position_cd, salary, salary_grade, delete_sw, group_cd
              FROM GIPI_GROUPED_ITEMS
             WHERE policy_id = p_policy_id
               AND item_no   = p_item_no
             ORDER BY grouped_item_no)
          LOOP
              v_grouped_item_no            := NVL(grp.grouped_item_no,v_grouped_item_no);
              v_grouped_item_title         := NVL(grp.grouped_item_title,v_grouped_item_title);
              v_amount_coverage            := NVL(grp.amount_coverage,0);
              v_include_tag                := NVL(grp.include_tag,v_include_tag);
              v_remarks                    := NVL(grp.remarks,v_remarks);
              v_line_cd                    := NVL(grp.line_cd,v_line_cd);
              v_subline_cd                 := NVL(grp.subline_cd,v_subline_cd);
              V_civil_status               := NVL(grp.civil_status,v_civil_status);               
              v_date_of_birth              := NVL(grp.date_of_birth,v_date_of_birth);                    
              v_age                        := NVL(grp.age,v_age);                    
              v_sex                        := NVL(grp.sex,v_sex);                    
              v_position_cd                := NVL(grp.position_cd,v_position_cd);            
              v_salary                     := NVL(grp.salary,v_salary);                 
              v_salary_grade               := NVL(grp.salary_grade,v_salary_grade);
              v_group_cd                   := NVL(grp.group_cd, v_group_cd);      --added by iris 05.09.2002     
              v_delete_sw                  := NVL(grp.delete_sw, v_delete_sw);        --added by loreen 05.26.05
              
                    
              FOR C IN (SELECT '1'
                          FROM GIXX_GROUPED_ITEMS
                         WHERE extract_id    = p_extract_id
                           AND item_no       = p_item_no
                           AND grouped_item_no = v_grouped_item_no)
              LOOP
                 v_grouped_item_no1   := v_grouped_item_no;
                 exist := 'Y';
                 EXIT;
              END LOOP;
                
              /*Modified/Added by Iris Bordey 11.10.2003
              **To fetch latest record from gipi_grouped_items before inserting
              **to extract table gixx_grouped_items*/
            IF exist = 'N' THEN
                /*rg_id     := FIND_GROUP(rg_name);
                rg_count  := GET_GROUP_ROW_COUNT(rg_id);
                IF rg_count > 1 THEN 
                    FOR x IN 2..rg_count LOOP
                      v_policy_id  := GET_GROUP_NUMBER_CELL(rg_col,x);
                      FOR endt_grp IN 
                          (SELECT grouped_item_no, grouped_item_title, amount_coverage, include_tag,
                                remarks, line_cd, subline_cd, CIVIL_STATUS, DATE_OF_BIRTH,          
                                        AGE, SEX, POSITION_CD, SALARY, SALARY_GRADE, DELETE_SW, group_cd
                           FROM gipi_grouped_items
                          WHERE policy_id = v_policy_id
                            AND item_no   = p_item_no
                            AND grouped_item_no = grp.grouped_item_no)
                      LOOP
                          v_grouped_item_no            := NVL(endt_grp.grouped_item_no,v_grouped_item_no);
                          v_grouped_item_title         := NVL(endt_grp.grouped_item_title,v_grouped_item_title);
                          v_amount_coverage            := NVL(endt_grp.amount_coverage,0);
                          v_include_tag                := NVL(endt_grp.include_tag,v_include_tag);
                          v_remarks                    := NVL(endt_grp.remarks,v_remarks);
                          v_line_cd                    := NVL(endt_grp.line_cd,v_line_cd);
                          v_subline_cd                 := NVL(endt_grp.subline_cd,v_subline_cd);
                          v_civil_status               := NVL(endt_GRP.CIVIL_STATUS,V_CIVIL_STATUS);               
                          v_date_of_birth              := NVL(endt_GRP.DATE_OF_BIRTH,V_DATE_OF_BIRTH);                    
                          v_age                        := NVL(endt_GRP.AGE,V_AGE);                    
                          v_sex                        := NVL(endt_GRP.SEX,V_SEX);                    
                          v_position_cd                := NVL(endt_GRP.POSITION_CD,V_POSITION_CD);            
                          v_salary                     := NVL(endt_GRP.SALARY,V_SALARY);                 
                          v_salary_grade               := NVL(endt_GRP.SALARY_GRADE,V_SALARY_GRADE);
                          v_group_cd                   := NVL(endt_grp.group_cd, v_group_cd);
                          v_delete_sw                  := NVL(endt_grp.delete_sw, v_delete_sw);  --added by loreen 05.26.05
                      END LOOP; 
                    END LOOP;
                END IF;*/ -- No need since parameter policy_id is based on the latest endorsement Nica 04.29.2013
               
               IF (grp.delete_sw = 'N') OR (grp.delete_sw IS NULL) THEN 
                     
                     INSERT INTO GIXX_GROUPED_ITEMS (
                       extract_id,           item_no,           grouped_item_no, 
                       grouped_item_title,   amount_coverage,   include_tag,
                       remarks,              line_cd,           subline_cd,
                       civil_status,         date_of_birth,     age,                    
                       sex,                  position_cd,       salary,                 
                       salary_grade,         group_cd,          delete_sw) 
                     VALUES( 
                       p_extract_id,         p_item_no,         v_grouped_item_no, 
                       v_grouped_item_title, v_amount_coverage, v_include_tag,
                       v_remarks,            v_line_cd,         v_subline_cd,
                       v_civil_status,       v_date_of_birth,   v_age,                    
                       v_sex,                v_position_cd,     v_salary,                 
                       v_salary_grade, v_group_cd, v_delete_sw);   
                             
                        
                        GIPIS100_EXTRACT_SUMMARY.populate_group_beneficiary(p_extract_id, p_policy_id, p_item_no, v_grouped_item_no); 
                       
                        p_grouped_items_flag := 'N'; 
                        v_grouped_item_no            := NULL;
                        v_grouped_item_title         := NULL;
                        v_include_tag                := NULL;
                        v_remarks                    := NULL;
                        v_line_cd                    := NULL;
                        v_subline_cd                 := NULL;
                        v_civil_status               := NULL;    
                        v_date_of_birth              := NULL;        
                        v_age                        := NULL;        
                        v_sex                        := NULL;        
                        v_position_cd                := NULL;        
                        v_salary                     := NULL;        
                        v_salary_grade               := NULL;        
                        v_group_cd                   := NULL; 
                        v_delete_sw                  := NULL; 
               END IF;
               EXIST := 'N';
            ELSE
              UPDATE GIXX_GROUPED_ITEMS
                 SET amount_coverage = NVL(amount_coverage,0) + nvl(v_amount_coverage,0)
               WHERE extract_id    = p_extract_id
                 AND item_no       = p_item_no
                 AND grouped_item_no = v_grouped_item_no1;
                      
                  exist := 'N';
                  v_grouped_item_no         := NULL;
                  v_grouped_item_title      := NULL;
                  v_amount_coverage         := 0;
                  v_include_tag             := NULL;
                  v_remarks                 := NULL;
                  v_line_cd                 := NULL;
                  v_subline_cd              := NULL;
                  v_civil_status            := NULL;    
                  v_date_of_birth           := NULL;        
                  v_age                     := NULL;        
                  v_sex                     := NULL;        
                  v_position_cd             := NULL;        
                  v_salary                  := NULL;        
                  v_salary_grade            := NULL;
                  v_group_cd                := NULL;
                  v_delete_sw               := NULL;
            END IF;      
          END LOOP;

        END;
        
        /*
        **  Created by    : Veronica V. Raymundo
        **  Date Created  : April 29, 2013
        **  Reference By  : GIPIS100 - View Policy Information
        **  Description   : Populate the GIXX_BENEFICIARY table
        */
        
        PROCEDURE populate_beneficiary (p_extract_id   IN   NUMBER,
                                        p_policy_id    IN   GIPI_POLBASIC.policy_id%TYPE,
                                        p_item_no      IN   GIPI_ITEM.item_no%TYPE) IS

           v_beneficiary_name       GIPI_BENEFICIARY.beneficiary_name%TYPE;
           v_beneficiary_addr       GIPI_BENEFICIARY.beneficiary_addr%TYPE;
           v_relation               GIPI_BENEFICIARY.relation%TYPE;
           v_beneficiary_no         GIPI_BENEFICIARY.beneficiary_no%TYPE; 
           v_delete_sw              GIPI_BENEFICIARY.delete_sw%TYPE;
           exist                    VARCHAR2(1) := 'N';
           
        BEGIN
                    
            FOR ben IN (
               SELECT beneficiary_name, beneficiary_addr,
                      relation,  beneficiary_no, delete_sw
                 FROM GIPI_BENEFICIARY
                WHERE policy_id = p_policy_id
                  AND item_no   = p_item_no)
            LOOP
              
              v_beneficiary_name          := NVL(ben.beneficiary_name,v_beneficiary_name) ;
              v_beneficiary_addr          := NVL(ben.beneficiary_addr,v_beneficiary_addr) ;
              v_relation                  := NVL(ben.relation,v_relation) ;
              v_beneficiary_no            := NVL(ben.beneficiary_no, v_beneficiary_no); 
              v_delete_sw                 := NVL(ben.delete_sw, v_delete_sw);

             FOR C IN (
                       SELECT 1
                         FROM GIXX_BENEFICIARY
                        WHERE extract_id     = p_extract_id
                          AND item_no        = p_item_no
                          AND beneficiary_no = v_beneficiary_no)
              LOOP
                  exist := 'Y';
              END LOOP;                
              
             IF exist = 'N' THEN
                  IF (v_delete_sw = 'N') OR (v_delete_sw IS NULL) THEN
                      
                      INSERT INTO GIXX_BENEFICIARY (
                          extract_id, item_no, beneficiary_name,
                          beneficiary_addr, relation,beneficiary_no )
                      VALUES
                        ( p_extract_id,       p_item_no, v_beneficiary_name,
                          v_beneficiary_addr, v_relation, v_beneficiary_no  );

                  --variables.beneficiary_flag := 'N';
                  v_beneficiary_name         := NULL;
                  v_beneficiary_addr         := NULL; 
                  v_relation                 := NULL;
                  v_beneficiary_no           := NULL;      
                  v_delete_sw                := NULL;    
                       
                  END IF;
                  
                  exist := 'N';
             ELSE
                  exist := 'N';
             END IF; 

         END LOOP; 

        END;
        
        /*
        **  Created by    : Veronica V. Raymundo
        **  Date Created  : April 29, 2013
        **  Reference By  : GIPIS100 - View Policy Information
        **  Description   : Populate the  GIPI_GRP_ITEMS_BENEFICIARY table
        */
        PROCEDURE populate_group_beneficiary (p_extract_id     IN   NUMBER,
                                             p_policy_id       IN   GIPI_POLBASIC.policy_id%TYPE,
                                             p_item_no         IN   GIPI_ITEM.item_no%TYPE,
                                             p_grouped_item_no IN   GIXX_GROUPED_ITEMS.grouped_item_no%TYPE) IS
          
          v_beneficiary_no      GIPI_GRP_ITEMS_BENEFICIARY.beneficiary_no%TYPE;
          v_beneficiary_name    GIPI_GRP_ITEMS_BENEFICIARY.beneficiary_name%TYPE;
          v_beneficiary_addr    GIPI_GRP_ITEMS_BENEFICIARY.beneficiary_addr%TYPE;
          v_relation            GIPI_GRP_ITEMS_BENEFICIARY.relation%TYPE;
          v_date_of_birth       GIPI_GRP_ITEMS_BENEFICIARY.date_of_birth%TYPE;        
          v_age                 GIPI_GRP_ITEMS_BENEFICIARY.age%TYPE;        
          v_civil_status        GIPI_GRP_ITEMS_BENEFICIARY.civil_status%TYPE;
          v_sex                 GIPI_GRP_ITEMS_BENEFICIARY.sex%TYPE;        
          exist                 VARCHAR2(1) := 'N'; 
          v_beneficiary_no1     GIPI_GRP_ITEMS_BENEFICIARY.beneficiary_no%TYPE;     
          
          BEGIN
              FOR bnfciary IN ( 
                  SELECT beneficiary_no, beneficiary_name, beneficiary_addr,
                         relation, date_of_birth, age, civil_status,  sex
                    FROM GIPI_GRP_ITEMS_BENEFICIARY
                   WHERE policy_id = p_policy_id
                     AND item_no   = p_item_no
                     AND grouped_item_no = p_grouped_item_no)
              LOOP
                  v_beneficiary_no             := NVL(bnfciary.beneficiary_no,v_beneficiary_no);
                  v_beneficiary_name           := NVL(bnfciary.beneficiary_name,v_beneficiary_name);
                  v_beneficiary_addr           := NVL(bnfciary.beneficiary_addr,v_beneficiary_addr);
                  v_relation                   := NVL(bnfciary.relation,v_relation);
                  v_date_of_birth              := NVL(bnfciary.date_of_birth,v_date_of_birth);                    
                  v_age                        := NVL(bnfciary.age,v_age);                    
                  v_civil_status               := NVL(bnfciary.civil_status,v_civil_status);               
                  v_sex                        := NVL(bnfciary.sex,v_sex);                    
                        
                        
                  FOR C IN (SELECT '1'
                              FROM GIXX_GRP_ITEMS_BENEFICIARY
                             WHERE extract_id      = p_extract_id
                               AND item_no         = p_item_no
                               AND grouped_item_no = p_grouped_item_no
                               AND beneficiary_no   = v_beneficiary_no)
                  LOOP
                       v_beneficiary_no1   := v_beneficiary_no;
                       EXIST := 'Y';
                       EXIT;
                  END LOOP;

                  IF exist = 'N' THEN
                       INSERT INTO GIXX_GRP_ITEMS_BENEFICIARY (
                         extract_id,           item_no,           grouped_item_no, 
                         beneficiary_no,       beneficiary_name,  beneficiary_addr,
                         relation,             date_of_birth,     age,
                         civil_status,           sex)
                       VALUES( 
                         p_extract_id,         p_item_no,         p_grouped_item_no, 
                         v_beneficiary_no,     v_beneficiary_name,v_beneficiary_addr,
                         v_relation,           v_date_of_birth,   v_age,
                         v_civil_status,       v_sex);      
                         
                      v_beneficiary_no        := NULL;
                      v_beneficiary_name      := NULL;
                      v_beneficiary_addr      := NULL;
                      v_relation              := NULL;
                      v_date_of_birth         := NULL;        
                      v_age                   := NULL;        
                      v_civil_status          := NULL;    
                      v_sex                   := NULL;        
                  END IF;
                  
              END LOOP;

          END;
          
        /*
        **  Created by    : Veronica V. Raymundo
        **  Date Created  : April 29, 2013
        **  Reference By  : GIPIS100 - View Policy Information
        **  Description   : Populate the  GIXX_CASUALTY_PERSONNEL table
        */
        
        PROCEDURE populate_personnel 
        ( p_extract_id   IN   NUMBER,
          p_policy_id    IN   GIPI_POLBASIC.policy_id%TYPE,
          p_item_no      IN   GIPI_ITEM.item_no%TYPE,
          p_line_cd      IN   GIPI_POLBASIC.line_cd%TYPE,
          p_subline_cd   IN   GIPI_POLBASIC.subline_cd%TYPE,
          p_iss_cd       IN   GIPI_POLBASIC.iss_cd%TYPE,
          p_issue_yy     IN   GIPI_POLBASIC.issue_yy%TYPE,
          p_pol_seq_no   IN   GIPI_POLBASIC.pol_seq_no%TYPE,
          p_renew_no     IN   GIPI_POLBASIC.renew_no%TYPE) IS

          v_exists           VARCHAR2(1) := 'N';
              
        BEGIN
           FOR exist IN (
             SELECT 'a'
               FROM GIXX_CASUALTY_PERSONNEL
              WHERE extract_id = p_extract_id
                AND item_no    = p_item_no)
           LOOP
                 --if records for the particular item exists then
                 --set v_exists to false to prevent from inserting to gixx_casualty_personnel
                 v_exists := 'Y';
              RETURN;
           END LOOP;
               
           IF v_exists = 'N' THEN
                 /*the script inserts all personnel records from gipi_casualty_personnel per item*/
              FOR personnel IN (SELECT DISTINCT c.personnel_no
                                  FROM GIPI_CASUALTY_PERSONNEL c,
                                       GIPI_ITEM               b, 
                                       GIPI_POLBASIC           a 
                                 WHERE 1=1 
                                   AND a.policy_id    = b.policy_id
                                   AND b.policy_id    = c.policy_id 
                                   AND b.item_no      = c.item_no
                                   AND b.item_no      = p_item_no
                                   AND a.line_cd      = p_line_cd 
                                   AND a.subline_cd   = p_subline_cd 
                                   AND a.iss_cd       = p_iss_cd 
                                   AND a.issue_yy     = p_issue_yy 
                                   AND a.pol_seq_no   = p_pol_seq_no 
                                   AND a.renew_no     = p_renew_no 
                                   AND a.pol_flag     IN ('1','2','3'))
              LOOP
                  FOR ins IN (SELECT c.personnel_no, a.eff_date, a.endt_seq_no, c.delete_sw,
                                     c.name,   c.include_tag,   c.capacity_cd,   c.amount_covered,
                                     c.remarks                 
                              FROM GIPI_CASUALTY_PERSONNEL c,
                                   GIPI_ITEM               b, 
                                   GIPI_POLBASIC           a 
                             WHERE 1=1 
                               AND a.policy_id    = b.policy_id
                               AND b.policy_id    = c.policy_id 
                               AND b.item_no      = c.item_no
                               AND b.item_no      = p_item_no
                               AND c.personnel_no = personnel.personnel_no
                               AND a.line_cd      = p_line_cd 
                               AND a.subline_cd   = p_subline_cd 
                               AND a.iss_cd       = p_iss_cd 
                               AND a.issue_yy     = p_issue_yy 
                               AND a.pol_seq_no   = p_pol_seq_no 
                               AND a.renew_no     = p_renew_no 
                               AND a.pol_flag     IN ('1','2','3')
                               AND NOT EXISTS (SELECT 'x' 
                                                 FROM GIPI_POLBASIC  x, 
                                                      GIPI_ITEM      y, 
                                                      GIPI_CASUALTY_PERSONNEL z 
                                                WHERE 1=1 
                                                  AND x.policy_id   = y.policy_id 
                                                  AND y.policy_id   = z.policy_id 
                                                  AND y.item_no     = z.item_no
                                                  AND y.item_no     = p_item_no
                                                  AND z.personnel_no= personnel.personnel_no 
                                                  --filter gipi_polbasic 
                                                  AND x.line_cd     = p_line_cd 
                                                  AND x.subline_cd  = p_subline_cd 
                                                  AND x.iss_cd      = p_iss_cd 
                                                  AND x.issue_yy    = p_issue_yy 
                                                  AND x.pol_seq_no  = p_pol_seq_no 
                                                  AND x.renew_no    = p_renew_no 
                                                  AND x.pol_flag    IN ('1','2','3') 
                                                  AND x.endt_seq_no > a.endt_seq_no 
                                                  AND NVL(x.back_stat,5) = 2) 
                             ORDER BY a.eff_date DESC)
                  LOOP
                    IF NVL(ins.delete_sw,'N') = 'N' THEN
                     INSERT INTO GIXX_CASUALTY_PERSONNEL(
                         extract_id,    item_no,       personnel_no,     name, 
                         include_tag,   capacity_cd,   amount_covered,   remarks)
                     VALUES( p_extract_id,  p_item_no,     ins.personnel_no,   ins.name, 
                         ins.include_tag, ins.capacity_cd, ins.amount_covered, ins.remarks);  
                         
                    END IF;
                      EXIT;   
                  END LOOP;
              END LOOP;   
           END IF;        

        END;
        
        /*
        **  Created by    : Veronica V. Raymundo
        **  Date Created  : April 29, 2013
        **  Reference By  : GIPIS100 - View Policy Information
        **  Description   : Populate the GIXX_MCACC table
        */
        
        PROCEDURE populate_accessory (p_extract_id   IN   NUMBER,
                                      p_policy_id    IN   GIPI_POLBASIC.policy_id%TYPE,
                                      p_item_no      IN   GIPI_ITEM.item_no%TYPE)IS

          v_accessory_cd        GIPI_MCACC.accessory_cd%TYPE;
          v_acc_amt             GIPI_MCACC.acc_amt%TYPE;

        BEGIN

          FOR exist IN (
            SELECT 'a'
              FROM GIXX_MCACC
             WHERE extract_id = p_extract_id
               AND item_no    = p_item_no)
          LOOP
             RETURN;
          END LOOP;

          FOR acc IN (
             SELECT  accessory_cd, acc_amt
               FROM GIPI_MCACC
              WHERE policy_id = p_policy_id
                AND item_no   = p_item_no)
          LOOP

             v_accessory_cd       := NVL(acc.accessory_cd,v_accessory_cd) ;
             v_acc_amt            := NVL(acc.acc_amt,v_acc_amt) ;

            INSERT INTO GIXX_MCACC(
                    extract_id,   item_no,   accessory_cd,        acc_amt)
            VALUES( p_extract_id, p_item_no, v_accessory_cd,  v_acc_amt);

            v_accessory_cd       := NULL;
            v_acc_amt            := NULL;

           END LOOP;

        END;
        
         /*
        **  Created by    : Veronica V. Raymundo
        **  Date Created  : April 29, 2013
        **  Reference By  : GIPIS100 - View Policy Information
        **  Description   : Populate the GIXX_ENGG_BASIC table
        */
        
        PROCEDURE populate_engg (p_extract_id   IN   NUMBER,
                                 p_policy_id    IN   GIPI_POLBASIC.policy_id%TYPE,
                                 p_line_cd      IN   GIPI_POLBASIC.line_cd%TYPE,
                                 p_subline_cd   IN   GIPI_POLBASIC.subline_cd%TYPE,
                                 p_iss_cd       IN   GIPI_POLBASIC.iss_cd%TYPE,
                                 p_issue_yy     IN   GIPI_POLBASIC.issue_yy%TYPE,
                                 p_pol_seq_no   IN   GIPI_POLBASIC.pol_seq_no%TYPE,
                                 p_renew_no     IN   GIPI_POLBASIC.renew_no%TYPE)IS
          
          v_exist                     VARCHAR2(1):= 'N';
          v_policy_id                 GIPI_POLBASIC.policy_id%TYPE;
          v_engg_basic_infonum        GIPI_ENGG_BASIC.engg_basic_infonum%TYPE;                 
          v_contract_proj_buss_title  GIPI_ENGG_BASIC.contract_proj_buss_title%TYPE;           
          v_site_location             GIPI_ENGG_BASIC.site_location%TYPE;                      
          v_construct_start_date      GIPI_ENGG_BASIC.construct_start_date%TYPE;               
          v_construct_end_date        GIPI_ENGG_BASIC.construct_end_date%TYPE;                 
          v_maintain_start_date       GIPI_ENGG_BASIC.maintain_start_date%TYPE;                
          v_maintain_end_date         GIPI_ENGG_BASIC.maintain_end_date%TYPE;                  
          v_weeks_test                GIPI_ENGG_BASIC.weeks_test%TYPE;                         
          v_time_excess               GIPI_ENGG_BASIC.time_excess%TYPE;                        
          v_mbi_policy_no             GIPI_ENGG_BASIC.mbi_policy_no%TYPE;                  


        BEGIN 

              FOR engg IN (
                  SELECT engg_basic_infonum, contract_proj_buss_title,       
                         site_location,      construct_start_date,           
                         construct_end_date, maintain_start_date,            
                         maintain_end_date,  weeks_test,                     
                         time_excess,        mbi_policy_no                  
                    FROM GIPI_ENGG_BASIC
                   WHERE policy_id = p_policy_id)
              LOOP
                 v_engg_basic_infonum        := NVL(engg.engg_basic_infonum,v_engg_basic_infonum);                 
                 v_contract_proj_buss_title  := NVL(engg.contract_proj_buss_title,v_contract_proj_buss_title);           
                 v_site_location             := NVL(engg.site_location,v_site_location);                      
                 v_construct_start_date      := NVL(engg.construct_start_date,v_construct_start_date);               
                 v_construct_end_date        := NVL(engg.construct_end_date,v_construct_end_date);                 
                 v_maintain_start_date       := NVL(engg.maintain_start_date,v_maintain_start_date);                
                 v_maintain_end_date         := NVL(engg.maintain_end_date,v_maintain_end_date);                  
                 v_weeks_test                := NVL(engg.weeks_test,v_weeks_test);                         
                 v_time_excess               := NVL(engg.time_excess,v_time_excess);                        
                 v_mbi_policy_no             := NVL(engg.mbi_policy_no,v_mbi_policy_no);                  
               
                FOR engg_exist IN (
                   SELECT 'a'
                     FROM GIXX_ENGG_BASIC
                    WHERE extract_id = p_extract_id)
                LOOP
                 v_exist := 'Y';
                END LOOP;
                
                IF v_exist = 'N' THEN
                
                   FOR pol IN (SELECT policy_id   
                               FROM GIPI_POLBASIC
                              WHERE line_cd     = p_line_cd
                                AND subline_cd  = p_subline_cd
                                AND iss_cd      = p_iss_cd
                                AND issue_yy    = p_issue_yy
                                AND pol_seq_no  = p_pol_seq_no
                                AND renew_no    = p_renew_no
                                AND pol_flag    != '5'
                                AND policy_id   != p_policy_id
                           ORDER BY eff_date)
                    LOOP
                        v_policy_id := pol.policy_id;
                        
                        FOR endt_bond IN (
                           SELECT engg_basic_infonum, contract_proj_buss_title,       
                                  site_location,      construct_start_date,           
                                  construct_end_date, maintain_start_date,            
                                  maintain_end_date,  weeks_test,                     
                                  time_excess,        mbi_policy_no                  
                             FROM gipi_engg_basic
                            WHERE policy_id = p_policy_id)
                         LOOP
                           v_engg_basic_infonum        := NVL(engg.engg_basic_infonum,v_engg_basic_infonum);                 
                           v_contract_proj_buss_title  := NVL(engg.contract_proj_buss_title,v_contract_proj_buss_title);           
                           v_site_location             := NVL(engg.site_location,v_site_location);                      
                           v_construct_start_date      := NVL(engg.construct_start_date,v_construct_start_date);               
                           v_construct_end_date        := NVL(engg.construct_end_date,v_construct_end_date);                 
                           v_maintain_start_date       := NVL(engg.maintain_start_date,v_maintain_start_date);                
                           v_maintain_end_date         := NVL(engg.maintain_end_date,v_maintain_end_date);                  
                           v_weeks_test                := NVL(engg.weeks_test,v_weeks_test);                         
                           v_time_excess               := NVL(engg.time_excess,v_time_excess);                        
                           v_mbi_policy_no             := NVL(engg.mbi_policy_no,v_mbi_policy_no);                  
                         END LOOP;
                         
                    END LOOP;
                  
                    INSERT INTO gixx_engg_basic(
                            engg_basic_infonum,   contract_proj_buss_title,       
                            site_location,        construct_start_date,
                            construct_end_date,   maintain_start_date,
                            maintain_end_date,    weeks_test,
                            time_excess,          mbi_policy_no,
                            extract_id) 
                    VALUES( v_engg_basic_infonum, v_contract_proj_buss_title,       
                            v_site_location,      v_construct_start_date,
                            v_construct_end_date, v_maintain_start_date,
                            v_maintain_end_date,  v_weeks_test,
                            v_time_excess,        v_mbi_policy_no,
                            p_extract_id) ;
                            
                    v_exist := 'N';       
                    v_engg_basic_infonum        := NULL;
                    v_contract_proj_buss_title  := NULL;
                    v_site_location             := NULL;
                    v_construct_start_date      := NULL;
                    v_construct_end_date        := NULL;
                    v_maintain_start_date       := NULL;
                    v_maintain_end_date         := NULL;
                    v_weeks_test                := NULL;
                    v_time_excess               := NULL;
                    v_mbi_policy_no             := NULL;
                                  
                ELSE
                    v_exist := 'N';
                END IF;  
               END LOOP; 
        END;
        
        /*
        **  Created by    : Veronica V. Raymundo
        **  Date Created  : April 29, 2013
        **  Reference By  : GIPIS100 - View Policy Information
        **  Description   : Populate the GIXX_POLWC table
        */
        
        PROCEDURE populate_wc (p_extract_id   IN   NUMBER,
                               p_policy_id    IN   GIPI_POLBASIC.policy_id%TYPE,
                               p_line_cd      IN   GIPI_POLBASIC.line_cd%TYPE,
                               p_subline_cd   IN   GIPI_POLBASIC.subline_cd%TYPE,
                               p_iss_cd       IN   GIPI_POLBASIC.iss_cd%TYPE,
                               p_issue_yy     IN   GIPI_POLBASIC.issue_yy%TYPE,
                               p_pol_seq_no   IN   GIPI_POLBASIC.pol_seq_no%TYPE,
                               p_renew_no     IN   GIPI_POLBASIC.renew_no%TYPE)IS
                              
          v_exist1           VARCHAR2(1) := 'N';
          v_change_tag       VARCHAR2(1);
          warrcla_flag       VARCHAR2(1) := 'N';
          v_policy_id        GIPI_POLBASIC.policy_id%TYPE;
          v_line_cd          GIPI_POLWC.line_cd%TYPE;
          v_wc_cd            GIPI_POLWC.wc_cd%TYPE;
          v_swc_seq_no       GIPI_POLWC.swc_seq_no%TYPE;
          v_print_seq_no     GIPI_POLWC.print_seq_no%TYPE;
          v_wc_title         GIPI_POLWC.wc_title%TYPE;
          v_wc_text01        GIPI_POLWC.wc_text01%TYPE;
          v_wc_text02        GIPI_POLWC.wc_text02%TYPE;
          v_wc_text03        GIPI_POLWC.wc_text03%TYPE;
          v_wc_text04        GIPI_POLWC.wc_text04%TYPE;
          v_wc_text05        GIPI_POLWC.wc_text05%TYPE;
          v_wc_text06        GIPI_POLWC.wc_text06%TYPE;
          v_wc_text07        GIPI_POLWC.wc_text07%TYPE;
          v_wc_text08        GIPI_POLWC.wc_text08%TYPE;
          v_wc_text09        GIPI_POLWC.wc_text09%TYPE;
          v_wc_text10        GIPI_POLWC.wc_text10%TYPE;
          v_wc_text11        GIPI_POLWC.wc_text11%TYPE;
          v_wc_text12        GIPI_POLWC.wc_text12%TYPE;
          v_wc_text13        GIPI_POLWC.wc_text13%TYPE;
          v_wc_text14        GIPI_POLWC.wc_text14%TYPE; 
          v_wc_text15        GIPI_POLWC.wc_text15%TYPE;
          v_wc_text16        GIPI_POLWC.wc_text16%TYPE;
          v_wc_text17        GIPI_POLWC.wc_text17%TYPE;
          v_wc_remarks       GIPI_POLWC.wc_remarks%TYPE;

        BEGIN
          FOR wc IN (
            SELECT line_cd, wc_cd, swc_seq_no, print_seq_no, wc_title, change_tag
              FROM GIPI_POLWC
             WHERE policy_id = p_policy_id)
          LOOP
            warrcla_flag   := 'Y';
            v_line_cd      := wc.line_cd;
            v_wc_cd        := wc.wc_cd;
            v_swc_seq_no   := wc.swc_seq_no;
            v_print_seq_no := wc.print_seq_no;
            v_wc_title     := wc.wc_title ;
            v_change_tag   := NVL(wc.change_tag,'N');
                
            IF v_change_tag = 'Y' THEN   
               BEGIN
                 SELECT wc_text01,wc_text02,wc_text03,wc_text04,
                        wc_text05,wc_text06,wc_text07,wc_text08,
                        wc_text09,wc_text10,wc_text11,wc_text12,
                        wc_text13,wc_text14,wc_text15,wc_text16,
                        wc_text17,wc_remarks
                   INTO v_wc_text01, v_wc_text02,
                        v_wc_text03, v_wc_text04,
                        v_wc_text05, v_wc_text06,
                        v_wc_text07, v_wc_text08,
                        v_wc_text09, v_wc_text10,
                        v_wc_text11, v_wc_text12,
                        v_wc_text13, v_wc_text14,
                        v_wc_text15, v_wc_text16,
                        v_wc_text17, v_wc_remarks
                   FROM GIPI_POLWC
                  WHERE policy_id  = p_policy_id
                    AND line_cd    = v_line_cd
                    AND wc_cd      = v_wc_cd
                    AND swc_seq_no = v_swc_seq_no;
               EXCEPTION 
                 WHEN NO_DATA_FOUND THEN
                   NULL;
               END;  
            ELSE    
                 BEGIN
                 SELECT wc_text01,wc_text02,wc_text03,wc_text04,
                        wc_text05,wc_text06,wc_text07,wc_text08,
                        wc_text09,wc_text10,wc_text11,wc_text12,
                        wc_text13,wc_text14,wc_text15,wc_text16,
                        wc_text17
                   INTO v_wc_text01, v_wc_text02,
                        v_wc_text03, v_wc_text04,
                        v_wc_text05, v_wc_text06,
                        v_wc_text07, v_wc_text08,
                        v_wc_text09, v_wc_text10,
                        v_wc_text11, v_wc_text12,
                        v_wc_text13, v_wc_text14,
                        v_wc_text15, v_wc_text16,
                        v_wc_text17
                   FROM GIIS_WARRCLA
                  WHERE main_wc_cd = v_wc_cd
                    AND line_cd    = v_line_cd;
               EXCEPTION 
                 WHEN NO_DATA_FOUND THEN
                   NULL;
               END; 
            END IF;
            
            FOR exist1 IN (
              SELECT 'a'
                FROM GIXX_POLWC
               WHERE extract_id = p_extract_id
                 AND line_cd    = v_line_cd
                 AND wc_cd      = v_wc_cd
                 AND swc_seq_no = v_swc_seq_no)
            LOOP
              v_exist1 := 'Y';
            END LOOP;
            
            IF v_exist1 = 'N' THEN
                FOR pol IN (SELECT policy_id   
                                       FROM GIPI_POLBASIC
                                      WHERE line_cd     = p_line_cd
                                        AND subline_cd  = p_subline_cd
                                        AND iss_cd      = p_iss_cd
                                        AND issue_yy    = p_issue_yy
                                        AND pol_seq_no  = p_pol_seq_no
                                        AND renew_no    = p_renew_no
                                        AND pol_flag    != '5'
                                        AND policy_id   != p_policy_id
                                   ORDER BY eff_date)
                LOOP
                    v_policy_id := pol.policy_id;
                    
                     BEGIN
                         SELECT NVL(wc_text01,v_wc_text01) wc_text01,
                               NVL(wc_text02,v_wc_text02) wc_text02,
                               NVL(wc_text03,v_wc_text03) wc_text03,
                               NVL(wc_text04,v_wc_text04) wc_text04,
                               NVL(wc_text05,v_wc_text05) wc_text05,
                               NVL(wc_text06,v_wc_text06) wc_text06,
                               NVL(wc_text07,v_wc_text07) wc_text07,
                               NVL(wc_text08,v_wc_text08) wc_text08,
                               NVL(wc_text09,v_wc_text09) wc_text09,
                               NVL(wc_text10,v_wc_text10) wc_text10,
                               NVL(wc_text11,v_wc_text11) wc_text11,
                               NVL(wc_text12,v_wc_text12) wc_text12,
                               NVL(wc_text13,v_wc_text13) wc_text13,
                               NVL(wc_text14,v_wc_text14) wc_text14,
                               NVL(wc_text15,v_wc_text15) wc_text15,
                               NVL(wc_text16,v_wc_text16) wc_text16,
                               NVL(wc_text17,v_wc_text17) wc_text17,
                               NVL(wc_remarks,v_wc_remarks) wc_remarks
                        INTO v_wc_text01,
                             v_wc_text02,
                             v_wc_text03,
                             v_wc_text04,
                             v_wc_text05,
                             v_wc_text06,
                             v_wc_text07,
                             v_wc_text08,
                             v_wc_text09,
                             v_wc_text10,
                             v_wc_text11,
                             v_wc_text12,
                             v_wc_text13,
                             v_wc_text14,
                             v_wc_text15,
                             v_wc_text16,
                             v_wc_text17,
                             v_wc_remarks
                        FROM gipi_polwc
                       WHERE policy_id  = v_policy_id
                         AND line_cd    = v_line_cd
                         AND wc_cd      = v_wc_cd
                         AND swc_seq_no = v_swc_seq_no;
                      
                   EXCEPTION 
                       WHEN NO_DATA_FOUND THEN
                          NULL;
                   END;
                    
                END LOOP;
            

               INSERT INTO GIXX_POLWC(
                       extract_id,             line_cd,   
                       swc_seq_no,             print_seq_no,
                       wc_title,               wc_text01, 
                       wc_text02,              wc_text03,
                       wc_text04,              wc_text05,
                       wc_text06,              wc_text07,
                       wc_text08,              wc_text09,
                       wc_text10,              wc_text11,
                       wc_text12,              wc_text13,
                       wc_text14,              wc_text15,
                       wc_text16,              wc_text17,
                       wc_remarks,             wc_cd)        
                VALUES(p_extract_id,           v_line_cd, 
                       v_swc_seq_no, v_print_seq_no,
                       v_wc_title,   v_wc_text01,
                       v_wc_text02,  v_wc_text03,
                       v_wc_text04,  v_wc_text05, 
                       v_wc_text06,  v_wc_text07,
                       v_wc_text08,  v_wc_text09, 
                       v_wc_text10,  v_wc_text11,
                       v_wc_text12,  v_wc_text13, 
                       v_wc_text14,  v_wc_text15,
                       v_wc_text16,  v_wc_text17, 
                       v_wc_remarks, v_wc_cd);
                  
               v_exist1 := 'N';
               v_wc_text01  := NULL;
               v_wc_text02  := NULL;
               v_wc_text03  := NULL;
               v_wc_text04  := NULL;
               v_wc_text05  := NULL;
               v_wc_text06  := NULL;
               v_wc_text07  := NULL;
               v_wc_text08  := NULL;
               v_wc_text09  := NULL;
               v_wc_text10  := NULL;
               v_wc_text11  := NULL;
               v_wc_text12  := NULL;
               v_wc_text13  := NULL;
               v_wc_text14  := NULL;
               v_wc_text15  := NULL;
               v_wc_text16  := NULL;
               v_wc_text17  := NULL;
               v_wc_remarks := NULL;
            END IF;
             
          END LOOP;
            

        END;
          
       /*
        **  Created by    : Veronica V. Raymundo
        **  Date Created  : April 29, 2013
        **  Reference By  : GIPIS100 - View Policy Information
        **  Description   : Populate the item additional information tables
        */
        
       PROCEDURE populate_add_item (
          p_extract_id            IN   NUMBER,
          p_policy_id             IN   GIPI_POLBASIC.policy_id%TYPE,
          p_item_no               IN   GIPI_ITEM.item_no%TYPE,
          p_subline               IN   GIPI_POLBASIC.subline_cd%TYPE,
          p_iss_cd                IN   GIPI_POLBASIC.iss_cd%TYPE,
          p_issue_yy              IN   GIPI_POLBASIC.issue_yy%TYPE,
          p_pol_seq_no            IN   GIPI_POLBASIC.pol_seq_no%TYPE,
          p_renew_no              IN   GIPI_POLBASIC.renew_no%TYPE,  
          p_line_cd               IN OUT  GIPI_POLBASIC.line_cd%TYPE,
          p_vessel_cd             IN OUT  GIPI_CARGO.vessel_cd%TYPE,
          p_geog_cd               IN OUT  GIPI_CARGO.geog_cd%TYPE,
          p_cargo_class_cd        IN OUT  GIPI_CARGO.cargo_class_cd%TYPE,
          p_bl_awb                IN OUT  GIPI_CARGO.bl_awb%TYPE,
          p_origin                IN OUT  GIPI_CARGO.origin%TYPE, 
          p_destn                 IN OUT  GIPI_CARGO.destn%TYPE,
          p_etd                   IN OUT  GIPI_CARGO.etd%TYPE,  
          p_eta                   IN OUT  GIPI_CARGO.eta%TYPE,
          p_cargo_type            IN OUT  GIPI_CARGO.cargo_type%TYPE,
          p_deduct_text           IN OUT  GIPI_CARGO.deduct_text%TYPE,
          p_pack_method           IN OUT  GIPI_CARGO.pack_method%TYPE, 
          p_tranship_origin       IN OUT  GIPI_CARGO.tranship_origin%TYPE,
          p_tranship_destination  IN OUT  GIPI_CARGO.tranship_destination%TYPE,
          p_print_tag             IN OUT  GIPI_CARGO.print_tag%TYPE,
          p_voyage_no             IN OUT  GIPI_CARGO.voyage_no%TYPE,
          p_lc_no                 IN OUT  GIPI_CARGO.lc_no%TYPE,
          v_cargo_flag            IN OUT  VARCHAR2,
          v_multi_sw              IN OUT  VARCHAR2,

          p_district_no           IN OUT  GIPI_FIREITEM.district_no%TYPE, 
          p_eq_zone               IN OUT  GIPI_FIREITEM.eq_zone%TYPE,       
          p_tarf_cd               IN OUT  GIPI_FIREITEM.tarf_cd%TYPE,            
          p_block_no              IN OUT  GIPI_FIREITEM.block_no%TYPE,                    
          p_fr_item_type          IN OUT  GIPI_FIREITEM.fr_item_type%TYPE,                     
          p_loc_risk1             IN OUT  GIPI_FIREITEM.loc_risk1%TYPE,               
          p_loc_risk2             IN OUT  GIPI_FIREITEM.loc_risk2%TYPE,                    
          p_loc_risk3             IN OUT  GIPI_FIREITEM.loc_risk3%TYPE,                        
          p_tariff_zone           IN OUT  GIPI_FIREITEM.tariff_zone%TYPE,                         
          p_typhoon_zone          IN OUT  GIPI_FIREITEM.typhoon_zone%TYPE,                         
          p_flood_zone            IN OUT  GIPI_FIREITEM.flood_zone%TYPE,               
          p_front                 IN OUT  GIPI_FIREITEM.front%TYPE,                                                        
          p_right                 IN OUT  GIPI_FIREITEM.right%TYPE,                
          p_left                  IN OUT  GIPI_FIREITEM.left%TYPE,                 
          p_rear                  IN OUT  GIPI_FIREITEM.rear%TYPE,             
          p_construction_cd       IN OUT  GIPI_FIREITEM.construction_cd%TYPE,                
          p_construction_remarks  IN OUT  GIPI_FIREITEM.construction_remarks%TYPE,                  
          p_occupancy_cd          IN OUT  GIPI_FIREITEM.occupancy_cd%TYPE,                  
          p_occupancy_remarks     IN OUT  GIPI_FIREITEM.occupancy_remarks%TYPE,
          p_fi_assignee           IN OUT  GIPI_FIREITEM.assignee%TYPE,         
          p_block_id              IN OUT  GIPI_FIREITEM.block_id%TYPE,
          p_latitude              IN OUT  GIPI_FIREITEM.latitude%TYPE,  --benjo 01.10.2017 SR-5749
          p_longitude             IN OUT  GIPI_FIREITEM.longitude%TYPE, --benjo 01.10.2017 SR-5749
          v_fireitem_flag         IN OUT  VARCHAR2,                         

          p_subline_cd            IN OUT  GIPI_VEHICLE.subline_cd%TYPE,  
          p_coc_yy                IN OUT  GIPI_VEHICLE.coc_yy%TYPE,
          p_coc_seq_no            IN OUT  GIPI_VEHICLE.coc_seq_no%TYPE,
          p_coc_serial_no         IN OUT  GIPI_VEHICLE.coc_serial_no%TYPE,   
          p_coc_type              IN OUT  GIPI_VEHICLE.coc_type%TYPE,
          p_repair_lim            IN OUT  GIPI_VEHICLE.repair_lim%TYPE,
          p_color                 IN OUT  GIPI_VEHICLE.color%TYPE,
          p_motor_no              IN OUT  GIPI_VEHICLE.motor_no%TYPE,
          p_model_year            IN OUT  GIPI_VEHICLE.model_year%TYPE,
          p_make                  IN OUT  GIPI_VEHICLE.make%TYPE,
          p_mot_type              IN OUT  GIPI_VEHICLE.mot_type%TYPE,
          p_est_value             IN OUT  GIPI_VEHICLE.est_value%TYPE,
          p_serial_no             IN OUT  GIPI_VEHICLE.serial_no%TYPE,
          p_towing                IN OUT  GIPI_VEHICLE.towing%TYPE,  
          p_assignee              IN OUT  GIPI_VEHICLE.assignee%TYPE,
          p_plate_no              IN OUT  GIPI_VEHICLE.plate_no%TYPE,
          p_subline_type_cd       IN OUT  GIPI_VEHICLE.subline_type_cd%TYPE,
          p_no_of_pass            IN OUT  GIPI_VEHICLE.no_of_pass%TYPE,
          p_tariff_zone1          IN OUT  GIPI_VEHICLE.tariff_zone%TYPE, 
          p_coc_issue_date        IN OUT  GIPI_VEHICLE.coc_issue_date%TYPE, 
          p_mv_file_no            IN OUT  GIPI_VEHICLE.mv_file_no%TYPE,   
          p_acquired_from         IN OUT  GIPI_VEHICLE.acquired_from%TYPE,   
          p_type_of_body_cd       IN OUT  GIPI_VEHICLE.type_of_body_cd%TYPE, 
          p_car_company_cd        IN OUT  GIPI_VEHICLE.car_company_cd%TYPE, 
          p_color_cd              IN OUT  GIPI_VEHICLE.color_cd%TYPE,
          p_basic_color_cd        IN OUT  GIPI_VEHICLE.basic_color_cd%TYPE,
          p_unladen_wt            IN OUT  GIPI_VEHICLE.unladen_wt%TYPE,
          v_vehicle_flag          IN OUT  VARCHAR2,
           
          p_date_of_birth         IN OUT  GIPI_ACCIDENT_ITEM.date_of_birth%TYPE,
          p_age                   IN OUT  GIPI_ACCIDENT_ITEM.age%TYPE,   
          p_civil_status          IN OUT  GIPI_ACCIDENT_ITEM.civil_status%TYPE,
          p_position_cd           IN OUT  GIPI_ACCIDENT_ITEM.position_cd%TYPE,
          p_monthly_salary        IN OUT  GIPI_ACCIDENT_ITEM.monthly_salary%TYPE,
          p_salary_grade          IN OUT  GIPI_ACCIDENT_ITEM.salary_grade%TYPE,
          p_no_of_persons         IN OUT  GIPI_ACCIDENT_ITEM.no_of_persons%TYPE,
          p_destination           IN OUT  GIPI_ACCIDENT_ITEM.destination%TYPE,
          p_height                IN OUT  GIPI_ACCIDENT_ITEM.height%TYPE,
          p_weight                IN OUT  GIPI_ACCIDENT_ITEM.weight%TYPE,
          p_sex                   IN OUT  GIPI_ACCIDENT_ITEM.sex%TYPE, 
          p_ac_class_cd           IN OUT  GIPI_ACCIDENT_ITEM.ac_class_cd%TYPE,
          p_grouped_items_flag    IN OUT  VARCHAR2,
          v_accident_item_flag    IN OUT  VARCHAR2,   

          p_vessel_cd1            IN OUT  GIPI_AVIATION_ITEM.vessel_cd%TYPE,
          p_total_fly_time        IN OUT  GIPI_AVIATION_ITEM.total_fly_time%TYPE,
          p_qualification         IN OUT  GIPI_AVIATION_ITEM.qualification%TYPE,
          p_purpose               IN OUT  GIPI_AVIATION_ITEM.purpose%TYPE,
          p_geog_limit            IN OUT  GIPI_AVIATION_ITEM.geog_limit%TYPE, 
          p_deduct_text1          IN OUT  GIPI_AVIATION_ITEM.deduct_text%TYPE,
          p_fixed_wing            IN OUT  GIPI_AVIATION_ITEM.fixed_wing%TYPE,
          p_rotor                 IN OUT  GIPI_AVIATION_ITEM.rotor%TYPE, 
          p_prev_util_hrs         IN OUT  GIPI_AVIATION_ITEM.prev_util_hrs%TYPE,
          p_est_util_hrs          IN OUT  GIPI_AVIATION_ITEM.est_util_hrs%TYPE,
          v_aviation_item_flag    IN OUT  VARCHAR2,
                                   
          p_section_line_cd       IN OUT  GIPI_CASUALTY_ITEM.section_line_cd%TYPE,
          p_section_subline_cd    IN OUT  GIPI_CASUALTY_ITEM.section_subline_cd%TYPE,
          p_capacity_cd           IN OUT  GIPI_CASUALTY_ITEM.capacity_cd%TYPE,
          p_section_or_hazard_cd  IN OUT  GIPI_CASUALTY_ITEM.section_or_hazard_cd%TYPE,
          p_property_no           IN OUT  GIPI_CASUALTY_ITEM.property_no%TYPE,
          p_property_no_type      IN OUT  GIPI_CASUALTY_ITEM.property_no_type%TYPE,
          p_location              IN OUT  GIPI_CASUALTY_ITEM.location%TYPE,
          p_conveyance_info       IN OUT  GIPI_CASUALTY_ITEM.conveyance_info%TYPE,
          p_limit_of_liability    IN OUT  GIPI_CASUALTY_ITEM.limit_of_liability%TYPE,
          p_interest_on_premises  IN OUT  GIPI_CASUALTY_ITEM.interest_on_premises%TYPE,
          p_section_or_hazard_info  IN OUT  GIPI_CASUALTY_ITEM.section_or_hazard_info%TYPE,
          p_ca_grouped_items_flag   IN OUT  VARCHAR2,
          v_casualty_item_flag      IN OUT  VARCHAR2,
                                  
          p_vessel_cd2          IN OUT  GIPI_ITEM_VES.vessel_cd%TYPE,
          p_geog_limit2         IN OUT  GIPI_ITEM_VES.geog_limit%TYPE,   
          p_deduct_text2        IN OUT  GIPI_ITEM_VES.deduct_text%TYPE,
          p_dry_date            IN OUT  GIPI_ITEM_VES.dry_date%TYPE,
          p_dry_place           IN OUT  GIPI_ITEM_VES.dry_place%TYPE,
          v_item_ves_flag       IN OUT  VARCHAR2)IS

          grp_exist              VARCHAR2(1) := 'N';
          
          param_line_cd          GIIS_LINE.line_cd%TYPE;

        BEGIN

          FOR line IN (
             SELECT line_cd, pack_pol_flag 
               FROM gipi_polbasic
              WHERE policy_id = p_policy_id)
          LOOP
            IF line.pack_pol_flag = 'Y' THEN
               FOR pline IN (
                  SELECT pack_line_cd 
                    FROM gipi_item
                   WHERE policy_id = p_policy_id
                     AND item_no   = p_item_no)
               LOOP
                 param_line_cd := pline.pack_line_cd;
                 EXIT;
               END LOOP;
             ELSE
               param_line_cd := line.line_cd;
             END IF;

          END LOOP;
          
          FOR c IN (SELECT menu_line_cd
                      FROM GIIS_LINE
                     WHERE line_cd = param_line_cd)
          LOOP
            IF c.menu_line_cd IS NOT NULL THEN
              param_line_cd := c.menu_line_cd; 
            END IF;    
          END LOOP;    
          
          IF param_line_cd = GIISP.V('LINE_CODE_MN') OR param_line_cd = 'MN' THEN--VJ 051007
            FOR cargo IN (
              SELECT vessel_cd, geog_cd,
                     bl_awb,    cargo_class_cd, 
                     origin,    deduct_text,        
                     etd,       tranship_destination,
                     eta,       cargo_type,
                     destn,     pack_method,
                     print_tag, tranship_origin,
                     voyage_no, lc_no
                FROM GIPI_CARGO
               WHERE policy_id  = p_policy_id
                 AND item_no    = p_item_no)
            LOOP
              v_cargo_flag   :=  'Y';
              
              IF cargo.vessel_cd = GIISP.V('VESSEL_CD_MULTI') THEN
                 v_multi_sw  := 'Y';
              END IF;
              
              IF v_multi_sw = 'Y' THEN
                 p_vessel_cd         :=  cargo.vessel_cd;
              ELSE
                 p_vessel_cd         :=  NVL(cargo.vessel_cd,p_vessel_cd);
              END IF;
              
              p_geog_cd              :=  NVL(cargo.geog_cd,p_geog_cd) ;
              p_cargo_class_cd       :=  NVL(cargo.cargo_class_cd,p_cargo_class_cd) ;
              p_bl_awb               :=  NVL(cargo.bl_awb,p_bl_awb) ;
              p_origin               :=  NVL(cargo.origin,p_origin) ;
              p_destn                :=  NVL(cargo.destn,p_destn) ;
              p_etd                  :=  NVL(cargo.etd,p_etd) ;  
              p_eta                  :=  NVL(cargo.eta,p_eta) ;
              p_cargo_type           :=  NVL(cargo.cargo_type,p_cargo_type) ;
              p_deduct_text          :=  NVL(cargo.deduct_text,p_deduct_text) ;
              p_pack_method          :=  NVL(cargo.pack_method,p_pack_method) ;
              p_tranship_origin      :=  NVL(cargo.tranship_origin,p_tranship_origin) ;
              p_tranship_destination :=  NVL(cargo.tranship_destination,p_tranship_destination) ;
              p_print_tag            :=  NVL(cargo.print_tag,p_print_tag) ;
              p_voyage_no            :=  NVL(cargo.voyage_no,p_voyage_no) ;
              p_lc_no                :=  NVL(cargo.lc_no,p_lc_no) ;

            END LOOP;
            
            GIPIS100_EXTRACT_SUMMARY.populate_deductibles(p_extract_id,p_policy_id,p_item_no);

          ELSIF param_line_cd = GIISP.V('LINE_CODE_AC') OR param_line_cd = 'AC' THEN --modification: added or statement Modified by: jeanette tan Date modified: 07.10.2002
            FOR accident IN (
                SELECT date_of_birth, age,    civil_status,
                       position_cd,   sex,    monthly_salary, 
                       salary_grade,  height, no_of_persons,
                       destination,   weight, ac_class_cd
                  FROM GIPI_ACCIDENT_ITEM
                 WHERE policy_id = p_policy_id
                   AND item_no   = p_item_no)
            LOOP    
              v_accident_item_flag := 'Y';  
              p_date_of_birth     := NVL(accident.date_of_birth,p_date_of_birth) ;
              p_age               := NVL(accident.age,p_age) ;   
              p_civil_status      := NVL(accident.civil_status,p_civil_status) ;
              p_position_cd       := NVL(accident.position_cd,p_position_cd) ;
              p_monthly_salary    := NVL(accident.monthly_salary,p_monthly_salary) ;
              p_salary_grade      := NVL(accident.salary_grade,p_salary_grade) ;
              p_no_of_persons     := NVL(accident.no_of_persons,p_no_of_persons) ;
              p_destination       := NVL(accident.destination,p_destination) ;
              p_height            := NVL(accident.height,p_height) ;
              p_weight            := NVL(accident.weight,p_weight) ;
              p_sex               := NVL(accident.sex,p_sex) ; 
              p_ac_class_cd       := NVL(accident.ac_class_cd,p_ac_class_cd) ;
            END LOOP;
                  
            GIPIS100_EXTRACT_SUMMARY.populate_beneficiary(p_extract_id,p_policy_id,p_item_no);
            
            GIPIS100_EXTRACT_SUMMARY.populate_group_items(p_extract_id,p_policy_id,p_item_no, p_grouped_items_flag); 
          
            GIPIS100_EXTRACT_SUMMARY.populate_deductibles(p_extract_id,p_policy_id,p_item_no);
            
          ELSIF param_line_cd = GIISP.V('LINE_CODE_AV') THEN
            FOR aviation IN (
               SELECT vessel_cd,  total_fly_time,
                      purpose,    qualification, 
                      geog_limit, deduct_text,
                      fixed_wing, prev_util_hrs,  
                      rotor,      est_util_hrs
                 FROM GIPI_AVIATION_ITEM
                WHERE policy_id = p_policy_id
                  AND item_no   = p_item_no) 
            LOOP    
              v_aviation_item_flag := 'Y';
              p_vessel_cd1       := NVL(aviation.vessel_cd,p_vessel_cd1) ;
              p_total_fly_time   := NVL(aviation.total_fly_time,p_total_fly_time) ;
              p_qualification    := NVL(aviation.qualification,p_qualification);
              p_purpose          := NVL(aviation.purpose,p_purpose) ;
              p_geog_limit       := NVL(aviation.geog_limit,p_geog_limit) ; 
              p_deduct_text1     := NVL(aviation.deduct_text,p_deduct_text1) ;
              p_fixed_wing       := NVL(aviation.fixed_wing,p_fixed_wing) ;
              p_rotor            := NVL(aviation.rotor,p_rotor) ; 
              p_prev_util_hrs    := NVL(aviation.prev_util_hrs,p_prev_util_hrs) ;
              p_est_util_hrs     := NVL(aviation.est_util_hrs,p_est_util_hrs) ;
            END LOOP;
            
            GIPIS100_EXTRACT_SUMMARY.populate_deductibles(p_extract_id,p_policy_id,p_item_no);

          ELSIF param_line_cd = GIISP.V('LINE_CODE_CA') THEN
            FOR casualty IN (
               SELECT section_line_cd, section_subline_cd,
                      capacity_cd,     section_or_hazard_cd,
                      property_no,     property_no_type,
                      location,        limit_of_liability,        
                      conveyance_info, interest_on_premises,
                      section_or_hazard_info
                 FROM GIPI_CASUALTY_ITEM
                WHERE policy_id = p_policy_id
                  AND item_no   = p_item_no) 
            LOOP    
              v_casualty_item_flag      := 'Y';
              p_section_line_cd         := NVL(casualty.section_line_cd,p_section_line_cd) ;
              p_section_subline_cd      := NVL(casualty.section_subline_cd,p_section_subline_cd) ;
              p_capacity_cd             := NVL(casualty.capacity_cd,p_capacity_cd) ;
              p_section_or_hazard_cd    := NVL(casualty.section_or_hazard_cd,p_section_or_hazard_cd) ;
              p_property_no             := NVL(casualty.property_no,p_property_no) ;
              p_property_no_type        := NVL(casualty.property_no_type,p_property_no_type) ;
              p_location                := NVL(casualty.location,p_location) ;
              p_conveyance_info         := NVL(casualty.conveyance_info,p_conveyance_info) ;
              p_limit_of_liability      := NVL(casualty.limit_of_liability,p_limit_of_liability) ;
              p_interest_on_premises    := NVL(casualty.interest_on_premises,p_interest_on_premises) ;
              p_section_or_hazard_info  := NVL(casualty.section_or_hazard_info,p_section_or_hazard_info) ;
            END LOOP;
            
            GIPIS100_EXTRACT_SUMMARY.populate_group_items(p_extract_id,p_policy_id,p_item_no, p_ca_grouped_items_flag);
            GIPIS100_EXTRACT_SUMMARY.populate_deductibles(p_extract_id,p_policy_id,p_item_no);
            GIPIS100_EXTRACT_SUMMARY.POPULATE_PERSONNEL(p_extract_id,p_policy_id,p_item_no, p_line_cd, p_subline,p_iss_cd,p_issue_yy, p_pol_seq_no,p_renew_no);
      
          ELSIF param_line_cd = GIISP.V('LINE_CODE_EN') THEN
            
            GIPIS100_EXTRACT_SUMMARY.populate_deductibles(p_extract_id,p_policy_id,p_item_no);
            
          ELSIF param_line_cd = GIISP.V('LINE_CODE_FI') THEN
            FOR fire IN (
               SELECT district_no, eq_zone,      tarf_cd,
                      block_no,    fr_item_type, construction_remarks,
                      loc_risk1,   loc_risk2,    occupancy_remarks,
                      loc_risk3,   tariff_zone,  typhoon_zone,
                      flood_zone,  front,        construction_cd,  
                      right,       left,         rear,                                  
                      occupancy_cd, assignee,block_id,
                      latitude, longitude --benjo 01.10.2017 SR-5749
                 FROM GIPI_FIREITEM
                WHERE policy_id = p_policy_id
                  AND item_no   = p_item_no)
            LOOP    
              v_fireitem_flag           := 'Y';
              p_district_no             := NVL(fire.district_no,p_district_no) ; 
              p_eq_zone                 := NVL(fire.eq_zone,p_eq_zone) ; 
              p_tarf_cd                 := NVL(fire.tarf_cd,p_tarf_cd) ;
              p_block_no                := NVL(fire.block_no,p_block_no) ;
              p_fr_item_type            := NVL(fire.fr_item_type,p_fr_item_type) ;
              p_loc_risk1               := NVL(fire.loc_risk1,p_loc_risk1) ; 
              p_loc_risk2               := NVL(fire.loc_risk2,p_loc_risk2) ; 
              p_loc_risk3               := NVL(fire.loc_risk3,p_loc_risk3) ;
              p_tariff_zone             := NVL(fire.tariff_zone,p_tariff_zone) ; 
              p_typhoon_zone            := NVL(fire.typhoon_zone,p_typhoon_zone);
              p_flood_zone              := NVL(fire.flood_zone,p_flood_zone) ; 
              p_front                   := NVL(fire.front,p_front) ;
              p_right                   := NVL(fire.right,p_right) ;
              p_left                    := NVL(fire.left,p_left) ;
              p_rear                    := NVL(fire.rear,p_rear) ;
              p_construction_cd         := NVL(fire.construction_cd,p_construction_cd) ;
              p_construction_remarks    := NVL(fire.construction_remarks,p_construction_remarks) ;
              p_occupancy_cd            := NVL(fire.occupancy_cd,p_occupancy_cd) ;
              p_occupancy_remarks       := NVL(fire.occupancy_remarks,p_occupancy_remarks) ;
              P_FI_ASSIGNEE             := NVL(FIRE.ASSIGNEE, P_FI_ASSIGNEE);
              p_block_id                := NVL(fire.block_id,p_block_id) ;
              p_latitude                := NVL(fire.latitude,p_latitude) ;   --benjo 01.10.2017 SR-5749
              p_longitude               := NVL(fire.longitude,p_longitude) ; --benjo 01.10.2017 SR-5749
            END LOOP;               
            GIPIS100_EXTRACT_SUMMARY.populate_deductibles(p_extract_id,p_policy_id,p_item_no);

          ELSIF param_line_cd = GIISP.V('LINE_CODE_MC') THEN
            FOR motor IN (
               SELECT subline_cd,  coc_yy,     coc_seq_no,  coc_serial_no,
                      coc_type,    color,      repair_lim,  motor_no,
                      model_year,  towing,     mot_type,    coc_issue_date,
                      est_value,   make,       serial_no,   assignee,    
                      plate_no,    no_of_pass, tariff_zone, subline_type_cd,
                      MV_FILE_NO, ACQUIRED_FROM, TYPE_OF_BODY_CD, CAR_COMPANY_CD,
                      color_cd, basic_color_cd, unladen_wt
                 FROM GIPI_VEHICLE
                WHERE policy_id = p_policy_id
                  AND item_no   = p_item_no)
            LOOP    
              v_vehicle_flag      := 'Y';
              p_subline_cd        := NVL(motor.subline_cd,p_subline_cd) ;  
              p_coc_yy            := NVL(motor.coc_yy,p_coc_yy) ;
              p_coc_seq_no        := NVL(motor.coc_seq_no,p_coc_seq_no) ;
              p_coc_serial_no     := NVL(motor.coc_serial_no,p_coc_serial_no) ;    
              p_coc_type          := NVL(motor.coc_type,p_coc_type) ;
              p_repair_lim        := NVL(motor.repair_lim,p_repair_lim) ;
              p_color             := NVL(motor.color,p_color) ; 
              p_motor_no          := NVL(motor.motor_no,p_motor_no) ;
              p_model_year        := NVL(motor.model_year,p_model_year);
              p_make              := NVL(motor.make,p_make) ;
              p_mot_type          := NVL(motor.mot_type,p_mot_type) ;
              p_est_value         := NVL(motor.est_value,p_est_value) ;
              p_serial_no         := NVL(motor.serial_no,p_serial_no) ;
              p_towing            := NVL(motor.towing,p_towing) ;  
              p_assignee          := NVL(motor.assignee,p_assignee) ;
              p_plate_no          := NVL(motor.plate_no,p_plate_no) ;
              p_subline_type_cd   := NVL(motor.subline_type_cd,p_subline_type_cd) ;
              p_no_of_pass        := NVL(motor.no_of_pass,p_no_of_pass) ;
              p_tariff_zone1      := NVL(motor.tariff_zone,p_tariff_zone1) ; 
              p_coc_issue_date    := NVL(motor.coc_issue_date,p_coc_issue_date) ;     
              p_mv_file_no        := NVL(motor.mv_file_no, p_mv_file_no);  
              p_acquired_from     := NVL(motor.acquired_from, p_acquired_from);
              p_type_of_body_cd   := NVL(motor.type_of_body_cd, p_type_of_body_cd);
              p_car_company_cd    := NVL(motor.car_company_cd, p_car_company_cd);
              p_color_cd          := NVL(motor.color_cd,p_color_cd) ;  
              p_basic_color_cd    := NVL(motor.basic_color_cd,p_basic_color_cd) ;  
              p_unladen_wt        := NVL(motor.unladen_wt,p_unladen_wt) ;  
            END LOOP;      
            
            GIPIS100_EXTRACT_SUMMARY.populate_deductibles(p_extract_id,p_policy_id,p_item_no);
            GIPIS100_EXTRACT_SUMMARY.populate_accessory(p_extract_id,p_policy_id,p_item_no);

          ELSIF param_line_cd = GIISP.V('LINE_CODE_MH') THEN
            FOR hull IN (
               SELECT vessel_cd,   geog_limit,
                      deduct_text, dry_date,
                      dry_place
                 FROM GIPI_ITEM_VES
                WHERE policy_id = p_policy_id
                  AND item_no   = p_item_no)
            LOOP    
              v_item_ves_flag := 'Y';
              p_vessel_cd2   := NVL(hull.vessel_cd,p_vessel_cd2) ;
              p_geog_limit2  := NVL(hull.geog_limit,p_geog_limit2) ;   
              p_deduct_text2 := NVL(hull.deduct_text,p_deduct_text2) ;
              p_dry_date     := NVL(hull.dry_date,p_dry_date) ;
              p_dry_place    := NVL(hull.dry_place,p_dry_place) ;
            END LOOP;
                  
            GIPIS100_EXTRACT_SUMMARY.populate_deductibles(p_extract_id,p_policy_id,p_item_no);
           
          END IF;
           
        END;
        
        
        /*
        **  Created by    : Veronica V. Raymundo
        **  Date Created  : April 29, 2013
        **  Reference By  : GIPIS100 - View Policy Information
        **  Description   : Populate the item information tables
        */
        
        PROCEDURE populate_item 
         (p_line_cd       IN   GIPI_POLBASIC.line_cd%TYPE,
          p_subline_cd    IN   GIPI_POLBASIC.subline_cd%TYPE,
          p_iss_cd        IN   GIPI_POLBASIC.iss_cd%TYPE,
          p_issue_yy      IN   GIPI_POLBASIC.issue_yy%TYPE,
          p_pol_seq_no    IN   GIPI_POLBASIC.pol_seq_no%TYPE,
          p_renew_no      IN   GIPI_POLBASIC.renew_no%TYPE,
          p_policy_id     IN   GIPI_POLBASIC.policy_id%TYPE,
          p_extract_id    IN   NUMBER,
          p_param_line_cd OUT  GIPI_POLBASIC.line_cd%TYPE) IS
         
          v_policy_id               GIPI_POLBASIC.policy_id%TYPE;
          v_policy_id1              GIPI_POLBASIC.policy_id%TYPE;
          v_policy_id2              GIPI_POLBASIC.policy_id%TYPE;
          v_item_group              GIPI_ITEM.item_grp%TYPE;
          v_item_no                 GIPI_ITEM.item_no%TYPE;
          v_item_title              GIPI_ITEM.item_title%TYPE;
          v_item_desc               GIPI_ITEM.item_desc%TYPE;
          v_tsi_amt                 GIPI_ITEM.tsi_amt%TYPE;
          v_prem_amt                GIPI_ITEM.prem_amt%TYPE;
          v_currency_cd             GIPI_ITEM.currency_cd%TYPE; 
          v_currency_rt             GIPI_ITEM.currency_rt%TYPE;
          v_group_cd                GIPI_ITEM.group_cd%TYPE;
          v_from_date               GIPI_ITEM.from_date%TYPE; 
          v_to_date                 GIPI_ITEM.to_date%TYPE;
          v_pack_line_cd            GIPI_ITEM.pack_line_cd%TYPE; 
          v_pack_subline_cd         GIPI_ITEM.pack_subline_cd%TYPE;
          v_discount_sw             GIPI_ITEM.discount_sw%TYPE;
          v_risk_no                 GIPI_ITEM.risk_no%TYPE;   
          v_risk_item_no            GIPI_ITEM.risk_item_no%TYPE;    
          v_switch                  VARCHAR2(1) := 'N';
          v_line_cd                 GIPI_POLBASIC.line_cd%TYPE;
          v_vessel_cd               GIPI_CARGO.vessel_cd%TYPE;
          v_geog_cd                 GIPI_CARGO.geog_cd%TYPE;
          v_cargo_class_cd          GIPI_CARGO.cargo_class_cd%TYPE;
          v_bl_awb                  GIPI_CARGO.bl_awb%TYPE;
          v_origin                  GIPI_CARGO.origin%TYPE; 
          v_destn                   GIPI_CARGO.destn%TYPE;
          v_etd                     GIPI_CARGO.etd%TYPE;  
          v_eta                     GIPI_CARGO.eta%TYPE;
          v_cargo_type              GIPI_CARGO.cargo_type%TYPE;
          v_deduct_text             GIPI_CARGO.deduct_text%TYPE;
          v_pack_method             GIPI_CARGO.pack_method%TYPE; 
          v_tranship_origin         GIPI_CARGO.tranship_origin%TYPE;
          v_tranship_destination    GIPI_CARGO.tranship_destination%TYPE;
          v_print_tag               GIPI_CARGO.print_tag%TYPE;
          v_voyage_no               GIPI_CARGO.voyage_no%TYPE;
          v_lc_no                   GIPI_CARGO.lc_no%TYPE;
          v_cargo_flag              VARCHAR2(1);
          v_multi_sw                VARCHAR2(1);

          v_district_no             GIPI_FIREITEM.district_no%TYPE; 
          v_eq_zone                 GIPI_FIREITEM.eq_zone%TYPE;       
          v_tarf_cd                 GIPI_FIREITEM.tarf_cd%TYPE;            
          v_block_no                GIPI_FIREITEM.block_no%TYPE;                    
          v_fr_item_type            GIPI_FIREITEM.fr_item_type%TYPE;                     
          v_loc_risk1               GIPI_FIREITEM.loc_risk1%TYPE;               
          v_loc_risk2               GIPI_FIREITEM.loc_risk2%TYPE;                    
          v_loc_risk3               GIPI_FIREITEM.loc_risk3%TYPE;                        
          v_tariff_zone             GIPI_FIREITEM.tariff_zone%TYPE;                         
          v_typhoon_zone            GIPI_FIREITEM.typhoon_zone%TYPE;                         
          v_flood_zone              GIPI_FIREITEM.flood_zone%TYPE;               
          v_front                   GIPI_FIREITEM.front%TYPE;                                                        
          v_right                   GIPI_FIREITEM.right%TYPE;                
          v_left                    GIPI_FIREITEM.left%TYPE;                 
          v_rear                    GIPI_FIREITEM.rear%TYPE;             
          v_construction_cd         GIPI_FIREITEM.construction_cd%TYPE;                
          v_construction_remarks    GIPI_FIREITEM.construction_remarks%TYPE;                  
          v_occupancy_cd            GIPI_FIREITEM.occupancy_cd%TYPE;                  
          v_occupancy_remarks       GIPI_FIREITEM.occupancy_remarks%TYPE;  
          v_fi_assignee             GIPI_FIREITEM.assignee%TYPE;                   
          v_block_id                GIPI_FIREITEM.block_id%TYPE; 
          v_latitude                GIPI_FIREITEM.latitude%TYPE;  --benjo 01.10.2017 SR-5749
          v_longitude               GIPI_FIREITEM.longitude%TYPE; --benjo 01.10.2017 SR-5749
          v_fireitem_flag           VARCHAR2(1);
          
          v_subline_cd              GIPI_VEHICLE.subline_cd%TYPE;  
          v_coc_yy                  GIPI_VEHICLE.coc_yy%TYPE;
          v_coc_seq_no              GIPI_VEHICLE.coc_seq_no%TYPE;
          v_coc_serial_no           GIPI_VEHICLE.coc_serial_no%TYPE;   
          v_coc_type                GIPI_VEHICLE.coc_type%TYPE;
          v_repair_lim              GIPI_VEHICLE.repair_lim%TYPE;
          v_color                   GIPI_VEHICLE.color%TYPE;
          v_motor_no                GIPI_VEHICLE.motor_no%TYPE;
          v_model_year              GIPI_VEHICLE.model_year%TYPE;
          v_make                    GIPI_VEHICLE.make%TYPE;
          v_mot_type                GIPI_VEHICLE.mot_type%TYPE;
          v_est_value               GIPI_VEHICLE.est_value%TYPE;
          v_serial_no               GIPI_VEHICLE.serial_no%TYPE;
          v_towing                  GIPI_VEHICLE.towing%TYPE;  
          v_assignee                GIPI_VEHICLE.assignee%TYPE;
          v_plate_no                GIPI_VEHICLE.plate_no%TYPE;
          v_subline_type_cd         GIPI_VEHICLE.subline_type_cd%TYPE;
          v_no_of_pass              GIPI_VEHICLE.no_of_pass%TYPE;
          v_tariff_zone1            GIPI_VEHICLE.tariff_zone%TYPE; 
          v_coc_issue_date          GIPI_VEHICLE.coc_issue_date%TYPE; 
          v_mv_file_no              GIPI_VEHICLE.mv_file_no%TYPE;
          v_acquired_from           GIPI_VEHICLE.acquired_from%TYPE;
          v_type_of_body_cd         GIPI_VEHICLE.type_of_body_cd%TYPE;
          v_car_company_cd          GIPI_VEHICLE.car_company_cd%TYPE;
          v_color_cd                GIPI_VEHICLE.color_cd%TYPE;
          v_basic_color_cd          GIPI_VEHICLE.basic_color_cd%TYPE;
          v_unladen_wt              GIPI_VEHICLE.unladen_wt%TYPE;
          v_vehicle_flag            VARCHAR2(1);
           
          v_date_of_birth           GIPI_ACCIDENT_ITEM.date_of_birth%TYPE;
          v_age                     GIPI_ACCIDENT_ITEM.age%TYPE;   
          v_civil_status            GIPI_ACCIDENT_ITEM.civil_status%TYPE;
          v_position_cd             GIPI_ACCIDENT_ITEM.position_cd%TYPE;
          v_monthly_salary          GIPI_ACCIDENT_ITEM.monthly_salary%TYPE;
          v_salary_grade            GIPI_ACCIDENT_ITEM.salary_grade%TYPE;
          v_no_of_persons           GIPI_ACCIDENT_ITEM.no_of_persons%TYPE;
          v_destination             GIPI_ACCIDENT_ITEM.destination%TYPE;
          v_height                  GIPI_ACCIDENT_ITEM.height%TYPE;
          v_weight                  GIPI_ACCIDENT_ITEM.weight%TYPE;
          v_sex                     GIPI_ACCIDENT_ITEM.sex%TYPE; 
          v_ac_class_cd             GIPI_ACCIDENT_ITEM.ac_class_cd%TYPE;
          v_grouped_items_flag      VARCHAR2(1);
          v_accident_item_flag      VARCHAR2(1);

          v_vessel_cd1              GIPI_AVIATION_ITEM.vessel_cd%TYPE;
          v_total_fly_time          GIPI_AVIATION_ITEM.total_fly_time%TYPE;
          v_qualification           GIPI_AVIATION_ITEM.qualification%TYPE;
          v_purpose                 GIPI_AVIATION_ITEM.purpose%TYPE;
          v_geog_limit              GIPI_AVIATION_ITEM.geog_limit%TYPE; 
          v_deduct_text1            GIPI_AVIATION_ITEM.deduct_text%TYPE;
          v_fixed_wing              GIPI_AVIATION_ITEM.fixed_wing%TYPE;
          v_rotor                   GIPI_AVIATION_ITEM.rotor%TYPE; 
          v_prev_util_hrs           GIPI_AVIATION_ITEM.prev_util_hrs%TYPE;
          v_est_util_hrs            GIPI_AVIATION_ITEM.est_util_hrs%TYPE;
          v_aviation_item_flag      VARCHAR2(1);
                                   
          v_section_line_cd         GIPI_CASUALTY_ITEM.section_line_cd%TYPE;
          v_section_subline_cd      GIPI_CASUALTY_ITEM.section_subline_cd%TYPE;
          v_capacity_cd             GIPI_CASUALTY_ITEM.capacity_cd%TYPE;
          v_section_or_hazard_cd    GIPI_CASUALTY_ITEM.section_or_hazard_cd%TYPE;
          v_property_no             GIPI_CASUALTY_ITEM.property_no%TYPE;
          v_property_no_type        GIPI_CASUALTY_ITEM.property_no_type%TYPE;
          v_location                GIPI_CASUALTY_ITEM.location%TYPE;
          v_conveyance_info         GIPI_CASUALTY_ITEM.conveyance_info%TYPE;
          v_limit_of_liability      GIPI_CASUALTY_ITEM.limit_of_liability%TYPE;
          v_interest_on_premises    GIPI_CASUALTY_ITEM.interest_on_premises%TYPE;
          v_section_or_hazard_info  GIPI_CASUALTY_ITEM.section_or_hazard_info%TYPE;
          v_ca_grouped_items_flag   VARCHAR2(1);
          v_casualty_item_flag      VARCHAR2(1);
                                  
          v_vessel_cd2              GIPI_ITEM_VES.vessel_cd%TYPE;
          v_geog_limit2             GIPI_ITEM_VES.geog_limit%TYPE;   
          v_deduct_text2            GIPI_ITEM_VES.deduct_text%TYPE;
          v_dry_date                GIPI_ITEM_VES.dry_date%TYPE;
          v_dry_place               GIPI_ITEM_VES.dry_place%TYPE;
          v_item_ves_flag           VARCHAR2(1);
                                     
          v_line_cd1                GIPI_ITMPERIL.line_cd%TYPE;
          v_peril_cd                GIPI_ITMPERIL.peril_cd%TYPE;
          v_tarf_cd1                GIPI_ITMPERIL.tarf_cd%TYPE;
          v_prem_rt                 GIPI_ITMPERIL.prem_rt%TYPE;
          v_tsi_amt1                GIPI_ITMPERIL.tsi_amt%TYPE;
          v_prem_amt1               GIPI_ITMPERIL.prem_amt%TYPE;
          v_comp_rem                GIPI_ITMPERIL.comp_rem%TYPE;
          v_discount_sw1            GIPI_ITMPERIL.discount_sw%TYPE;
          v_ri_comm_rate            GIPI_ITMPERIL.ri_comm_rate%TYPE;
          v_ri_comm_amt             GIPI_ITMPERIL.ri_comm_amt%TYPE;
          v_exist                   VARCHAR2(1) := 'N';
          v_exist1                  VARCHAR2(1) := 'N';
          exist1                    VARCHAR2(1) := 'N';
          mortg_exist               VARCHAR2(1) := 'N';
          
          v_iss_cd                  GIPI_MORTGAGEE.iss_cd%TYPE;
          v_mortg_cd                GIPI_MORTGAGEE.mortg_cd%TYPE;
          v_amount                  GIPI_MORTGAGEE.amount%TYPE; 
          v_remarks                 GIPI_MORTGAGEE.remarks%TYPE;   

          v_grp_grouped_item_no     GIPI_GROUPED_ITEMS.grouped_item_no%TYPE;
          v_grp_grouped_item_title  GIPI_GROUPED_ITEMS.grouped_item_title%TYPE;
          v_grp_amount_coverage     GIPI_GROUPED_ITEMS.amount_coverage%TYPE;
          v_grp_include_tag         GIPI_GROUPED_ITEMS.include_tag%TYPE;
          v_grp_remarks             GIPI_GROUPED_ITEMS.remarks%TYPE;
          v_grp_line_cd             GIPI_GROUPED_ITEMS.line_cd%TYPE;
          v_grp_subline_cd          GIPI_GROUPED_ITEMS.subline_cd%TYPE;
          v_grp_civil_status        GIPI_GROUPED_ITEMS.CIVIL_STATUS%TYPE;    
          v_grp_date_of_birth       GIPI_GROUPED_ITEMS.DATE_OF_BIRTH%TYPE;        
          v_grp_age                 GIPI_GROUPED_ITEMS.AGE%TYPE;        
          v_grp_sex                 GIPI_GROUPED_ITEMS.SEX%TYPE;        
          v_grp_position_cd         GIPI_GROUPED_ITEMS.POSITION_CD%TYPE;        
          v_grp_salary              GIPI_GROUPED_ITEMS.SALARY%TYPE;        
          v_grp_salary_grade        GIPI_GROUPED_ITEMS.SALARY_GRADE%TYPE;        
          grp_exist                 VARCHAR2(1) := 'N';
          v_mort_item_no            GIPI_MORTGAGEE.item_no%TYPE;
          
          param_line_cd             GIIS_LINE.line_cd%TYPE;
         

        BEGIN
            GIPIS100_EXTRACT_SUMMARY.populate_mortgagee(p_extract_id,p_policy_id);
            GIPIS100_EXTRACT_SUMMARY.POPULATE_INVOICE(p_extract_id, p_policy_id);
            GIPIS100_EXTRACT_SUMMARY.POPULATE_CLAIMS(p_extract_id,p_policy_id);
            GIPIS100_EXTRACT_SUMMARY.POPULATE_PICTURES(p_extract_id,p_policy_id);
           
            FOR i IN (SELECT item_no
                          FROM GIPI_ITEM
                         WHERE policy_id = p_policy_id
                        ORDER BY item_no)      
            LOOP
                  v_item_no  := i.item_no;
                  v_exist := 'N';
                         
                  FOR exist IN (
                     SELECT 'a'
                       FROM gixx_item
                      WHERE extract_id = p_extract_id
                        AND item_no    = v_item_no)
                  LOOP
                   v_exist := 'Y';
                  END LOOP;
                  
                  FOR line IN (
                     SELECT line_cd, pack_pol_flag 
                       FROM gipi_polbasic
                      WHERE policy_id = p_policy_id)
                  LOOP
                    IF line.pack_pol_flag = 'Y' THEN
                       FOR pline IN (
                          SELECT pack_line_cd 
                            FROM gipi_item
                           WHERE policy_id = p_policy_id
                             AND item_no   = v_item_no)
                       LOOP
                         param_line_cd := pline.pack_line_cd;
                         EXIT;
                       END LOOP;
                     ELSE
                       param_line_cd := line.line_cd;
                     END IF;

                  END LOOP;
                  
                  FOR c IN (SELECT menu_line_cd
                              FROM GIIS_LINE
                             WHERE line_cd = param_line_cd)
                  LOOP
                    IF c.menu_line_cd IS NOT NULL THEN
                      param_line_cd := c.menu_line_cd; 
                    END IF;    
                  END LOOP;
                  
                  p_param_line_cd := param_line_cd;
                          
                  IF v_exist = 'N' THEN
                      
                     FOR pol IN (SELECT policy_id   
                                   FROM GIPI_POLBASIC
                                  WHERE line_cd     = p_line_cd
                                    AND subline_cd  = p_subline_cd
                                    AND iss_cd      = p_iss_cd
                                    AND issue_yy    = p_issue_yy
                                    AND pol_seq_no  = p_pol_seq_no
                                    AND renew_no    = p_renew_no
                                    AND pol_flag    != '5'
                               ORDER BY eff_date)
                           
                    LOOP
                         v_policy_id := pol.policy_id;
                            
                         FOR itm IN (
                            SELECT item_no,      item_title,  item_desc,    tsi_amt,
                                   prem_amt,     currency_cd, currency_rt,  group_cd,
                                   from_date,    to_date,     pack_line_cd, pack_subline_cd,
                                   discount_sw,  item_grp,    policy_id,
                                   risk_no, risk_item_no
                              FROM GIPI_ITEM
                             WHERE policy_id = v_policy_id
                               AND item_no   = v_item_no
                          ORDER BY item_no)
                                         
                          LOOP
                              v_item_no             := itm.item_no;
                              v_policy_id           := itm.policy_id;
                              v_item_title          := NVL(itm.item_title,v_item_title) ;
                              v_item_desc           := NVL(itm.item_desc,v_item_desc) ;
                              v_tsi_amt             := NVL(itm.tsi_amt,0) ;
                              v_prem_amt            := NVL(itm.prem_amt,0) ;
                              v_currency_cd         := NVL(itm.currency_cd,v_currency_cd) ; 
                              v_currency_rt         := NVL(itm.currency_rt,v_currency_rt) ;
                              v_group_cd            := NVL(itm.group_cd,v_group_cd) ;
                              v_from_date           := NVL(itm.from_date,v_from_date) ; 
                              v_to_date             := NVL(itm.to_date,v_to_date) ;
                              v_pack_line_cd        := NVL(itm.pack_line_cd,v_pack_line_cd) ; 
                              v_pack_subline_cd     := NVL(itm.pack_subline_cd,v_pack_subline_cd) ;
                              v_discount_sw         := NVL(itm.discount_sw,v_discount_sw) ;
                              v_item_group          := NVL(itm.item_grp,v_item_group) ;
                              v_risk_no             := itm.risk_no;
                              v_risk_item_no        := itm.risk_item_no;
                          END LOOP;
                           
                    END LOOP;
                    
                    
                    INSERT INTO GIXX_ITEM (
                            extract_id,           item_no,        item_title,
                            item_desc,            tsi_amt,        prem_amt,
                            currency_cd,          currency_rt,    group_cd,
                            from_date,            to_date,        pack_line_cd,
                            pack_subline_cd,      discount_sw,    item_grp,
                            risk_no,              risk_item_no)
                    VALUES ( p_extract_id,         v_item_no,      v_item_title,
                            v_item_desc,          v_tsi_amt,      v_prem_amt,
                            v_currency_cd,        v_currency_rt,  v_group_cd,
                            v_from_date,          v_to_date,      v_pack_line_cd,
                            v_pack_subline_cd,    v_discount_sw,  v_item_group,
                            v_risk_no,            v_risk_item_no);

                      v_exist := 'N';
                      v_item_title      := NULL;
                      v_item_desc       := NULL;
                      v_tsi_amt         := NULL;
                      v_prem_amt        := NULL;
                      v_currency_cd     := NULL;
                      v_currency_rt     := NULL;
                      v_group_cd        := NULL; 
                      v_from_date       := NULL;  
                      v_to_date         := NULL;
                      v_pack_line_cd    := NULL;
                      v_pack_subline_cd := NULL; 
                      v_discount_sw     := NULL;
                      v_item_group      := NULL;
                      v_risk_no         := NULL;
                      v_risk_item_no    := NULL;
                  
                    GIPIS100_EXTRACT_SUMMARY.POPULATE_ADD_ITEM
                          ( p_extract_id,       v_policy_id,    v_item_no,  p_subline_cd,  p_iss_cd, p_issue_yy,	
                            p_pol_seq_no,       p_renew_no,     v_line_cd,	v_vessel_cd,v_geog_cd, 
                            v_cargo_class_cd,	v_bl_awb,		v_origin,   v_destn,	v_etd,			v_eta,
                            v_cargo_type,		v_deduct_text,	v_pack_method,v_tranship_origin,		v_tranship_destination,
                            v_print_tag,		v_voyage_no,	v_lc_no, 	v_cargo_flag, v_multi_sw,
                            v_district_no,		v_eq_zone,		v_tarf_cd,	v_block_no,	  v_fr_item_type,
                            v_loc_risk1,		v_loc_risk2,	v_loc_risk3,v_tariff_zone,v_typhoon_zone,v_flood_zone,
                            v_front,			v_right,		v_left,		v_rear,		  v_construction_cd,v_construction_remarks,
                            v_occupancy_cd,		v_occupancy_remarks, 		v_fi_assignee,v_block_id, v_latitude, v_longitude, v_fireitem_flag, --benjo 01.10.2017 SR-5749 added latitude, longitude
                            v_subline_cd,		v_coc_yy,		v_coc_seq_no,v_coc_serial_no,v_coc_type,	v_repair_lim,	
                            v_color,			v_motor_no,		v_model_year,v_make,		 v_mot_type,	v_est_value,
                            v_serial_no,		v_towing,		v_assignee,	v_plate_no,		 v_subline_type_cd, v_no_of_pass,
                            v_tariff_zone1,		v_coc_issue_date, v_mv_file_no, v_acquired_from,v_type_of_body_cd,  
                            V_CAR_COMPANY_CD,   v_color_cd,  v_basic_color_cd, v_unladen_wt, v_vehicle_flag, 
                            v_date_of_birth,	v_age,		 v_civil_status,	v_position_cd,	v_monthly_salary,	v_salary_grade,
                            v_no_of_persons, 	v_destination,	v_height,		v_weight,	v_sex,	v_ac_class_cd,	v_grouped_items_flag, v_accident_item_flag,
                            v_vessel_cd1,    	v_total_fly_time,v_qualification,v_purpose,	v_geog_limit,    v_deduct_text1,
                            v_fixed_wing,		v_rotor,		v_prev_util_hrs,  v_est_util_hrs, v_aviation_item_flag,
                            v_section_line_cd,	v_section_subline_cd,	v_capacity_cd,	v_section_or_hazard_cd,	v_property_no,
                            v_property_no_type,	v_location,	v_conveyance_info,	v_limit_of_liability,	v_interest_on_premises,
                            v_section_or_hazard_info, v_ca_grouped_items_flag, v_casualty_item_flag,
                            v_vessel_cd2,		v_geog_limit2,	v_deduct_text2, v_dry_date,	v_dry_place, v_item_ves_flag);
                            
                            
                            
                     IF param_line_cd = GIISP.V('LINE_CODE_AC') OR param_line_cd = 'AC' THEN --modification: added or statement Modified by: jeanette tan Date modified: 07.10.2002
                        IF v_accident_item_flag = 'Y' THEN
                           INSERT INTO GIXX_ACCIDENT_ITEM (
                               extract_id,           item_no,        date_of_birth,     age,          civil_status,   position_cd,
                               monthly_salary,       salary_grade,   no_of_persons,     destination,  height,         weight,
                               sex,                  ac_class_cd)
                             VALUES(p_extract_id,   v_item_no,      v_date_of_birth,      v_age,         v_civil_status, v_position_cd,
                              v_monthly_salary,     v_salary_grade, v_no_of_persons,      v_destination, v_height,       v_weight,
                              v_sex,                v_ac_class_cd);
                              
                              v_accident_item_flag := 'N'; 
                              v_date_of_birth    := NULL;
                              v_age              := NULL; 
                              v_civil_status     := NULL;
                              v_position_cd      := NULL;
                              v_monthly_salary   := NULL;
                              v_salary_grade     := NULL;
                              v_no_of_persons    := NULL;
                              v_destination      := NULL;
                              v_height           := NULL;
                              v_weight           := NULL;
                              v_sex              := NULL;
                              v_ac_class_cd      := NULL;
                                 
                             param_line_cd       := NULL;
                        END IF;
                       
                     ELSIF param_line_cd = GIISP.V('LINE_CODE_AV') THEN
                        
                        IF v_aviation_item_flag  = 'Y' THEN 
                           INSERT INTO GIXX_AVIATION_ITEM (
                               extract_id,           item_no,         vessel_cd,    total_fly_time,       qualification,   purpose,
                               geog_limit,           deduct_text,     fixed_wing,   rotor,                prev_util_hrs,   est_util_hrs)
                             VALUES(p_extract_id,    v_item_no,       v_vessel_cd1, v_total_fly_time,     v_qualification, v_purpose,
                               v_geog_limit,         v_deduct_text1,  v_fixed_wing,  v_rotor,              v_prev_util_hrs, v_est_util_hrs);              
                           
                           v_aviation_item_flag := 'N';
                           v_vessel_cd1       := NULL;
                           v_total_fly_time   := NULL;
                           v_qualification    := NULL;
                           v_purpose          := NULL;
                           v_geog_limit       := NULL;
                           v_deduct_text1     := NULL;
                           v_fixed_wing       := NULL;
                           v_rotor            := NULL; 
                           v_prev_util_hrs    := NULL;
                           v_est_util_hrs     := NULL;
                           param_line_cd      := NULL;
                        END IF;
                        
                     ELSIF param_line_cd = GIISP.V('LINE_CODE_CA') THEN
                        
                        IF v_casualty_item_flag = 'Y' THEN 
                            INSERT INTO gixx_casualty_item(
                            extract_id,            item_no, section_line_cd,       section_subline_cd,
                            capacity_cd,           section_or_hazard_cd,           property_no,           property_no_type,
                            location,              conveyance_info,                limit_of_liability,    interest_on_premises, section_or_hazard_info)
                            VALUES( p_extract_id,  v_item_no,                      v_section_line_cd,     v_section_subline_cd,  
                            v_capacity_cd,         v_section_or_hazard_cd,         v_property_no,         v_property_no_type,
                            v_location,            v_conveyance_info,              v_limit_of_liability,  v_interest_on_premises, v_section_or_hazard_info);
                            
                            v_casualty_item_flag := 'N';
                            v_section_line_cd         := NULL; 
                            v_section_subline_cd      := NULL; 
                            v_capacity_cd             := NULL; 
                            v_section_or_hazard_cd    := NULL;
                            v_property_no             := NULL; 
                            v_property_no_type        := NULL;
                            v_location                := NULL;
                            v_conveyance_info         := NULL;
                            v_limit_of_liability      := NULL;
                            v_interest_on_premises    := NULL;
                            v_section_or_hazard_info  := NULL;
                            param_line_cd             := NULL;
                        END IF;   
                       
                     ELSIF param_line_cd = GIISP.V('LINE_CODE_FI') THEN
                        IF v_fireitem_flag = 'Y' THEN
                          INSERT INTO GIXX_FIREITEM (
                             extract_id,           item_no,        district_no,
                             eq_zone,              tarf_cd,        block_no,
                             loc_risk1,            loc_risk2,      fr_item_type,
                             loc_risk3,            tariff_zone,    typhoon_zone,
                             front,                right,          construction_cd,
                             left,                 rear,           construction_remarks,
                             flood_zone,           occupancy_cd,   occupancy_remarks,
                             assignee,             block_id,       latitude, --benjo 01.10.2017 SR-5749
                             longitude)                                      --benjo 01.10.2017 SR-5749
                          VALUES(p_extract_id,     v_item_no,      v_district_no,
                             v_eq_zone,            v_tarf_cd,      v_block_no,
                             v_loc_risk1,          v_loc_risk2,    v_fr_item_type,
                             v_loc_risk3,          v_tariff_zone,  v_typhoon_zone,
                             v_front,              v_right,        v_construction_cd,
                             v_left,               v_rear,         v_construction_remarks,
                             v_flood_zone,         v_occupancy_cd, v_occupancy_remarks,
                             v_fi_assignee,        v_block_id,     v_latitude, --benjo 01.10.2017 SR-5749
                             v_longitude);                                     --benjo 01.10.2017 SR-5749
                
                           v_fireitem_flag         := 'N';
                           v_district_no           := NULL;
                           v_eq_zone               := NULL;
                           v_tarf_cd               := NULL;
                           v_block_no              := NULL;
                           v_loc_risk1             := NULL; 
                           v_loc_risk2             := NULL;
                           v_fr_item_type          := NULL;
                           v_loc_risk3             := NULL;
                           v_tariff_zone           := NULL;
                           v_typhoon_zone          := NULL;
                           v_front                 := NULL; 
                           v_right                 := NULL;
                           v_construction_cd       := NULL;
                           v_left                  := NULL; 
                           v_rear                  := NULL; 
                           v_construction_remarks  := NULL;
                           v_flood_zone            := NULL;
                           v_occupancy_cd          := NULL;
                           v_occupancy_remarks     := NULL;
                           v_fi_assignee           := NULL;   
                           v_block_id              := NULL;
                           v_latitude              := NULL; --benjo 01.10.2017 SR-5749
                           v_longitude             := NULL; --benjo 01.10.2017 SR-5749
                           param_line_cd           := NULL;
                        END IF;
                        
                     ELSIF param_line_cd = GIISP.V('LINE_CODE_MC') THEN
                        IF v_vehicle_flag = 'Y' THEN
                             INSERT INTO gixx_vehicle(
                                 extract_id,           item_no,        subline_cd,
                                 coc_yy,               coc_seq_no,     coc_serial_no,
                                 coc_type,             repair_lim,     color,
                                 motor_no,             model_year,     make,
                                 mot_type,             est_value,      serial_no,
                                 towing,               assignee,       plate_no,
                                 no_of_pass,           tariff_zone,    coc_issue_date,
                                 subline_type_cd,      mv_file_no,     acquired_from,
                                 type_of_body_cd,      car_company_cd, color_cd, 
                                 basic_color_cd,       unladen_wt)          
                             VALUES(p_extract_id,      v_item_no,      v_subline_cd,
                                 v_coc_yy,             v_coc_seq_no,   v_coc_serial_no,
                                 v_coc_type,           v_repair_lim,   v_color,
                                 v_motor_no,           v_model_year,   v_make,
                                 v_mot_type,           v_est_value,    v_serial_no,
                                 v_towing,             v_assignee,     v_plate_no,
                                 v_no_of_pass,         v_tariff_zone1, v_coc_issue_date,          
                                 v_subline_type_cd,    v_mv_file_no,   v_acquired_from,
                                 v_type_of_body_cd,    v_car_company_cd, v_color_cd, 
                                 v_basic_color_cd,     v_unladen_wt);

                           v_vehicle_flag     := 'N';
                           v_subline_cd       := NULL;
                           v_coc_yy           := NULL;
                           v_coc_seq_no       := NULL;
                           v_coc_serial_no    := NULL;
                           v_coc_type         := NULL; 
                           v_repair_lim       := NULL;
                           v_color            := NULL;
                           v_motor_no         := NULL;
                           v_model_year       := NULL;
                           v_make             := NULL;
                           v_mot_type         := NULL;
                           v_est_value        := NULL;
                           v_serial_no        := NULL;
                           v_towing           := NULL;
                           v_assignee         := NULL;
                           v_plate_no         := NULL;
                           v_no_of_pass       := NULL;
                           v_tariff_zone1     := NULL;
                           v_coc_issue_date   := NULL;       
                           v_subline_type_cd  := NULL;
                           v_mv_file_no       := NULL;
                           v_acquired_from    := NULL;  
                           v_type_of_body_cd  := NULL;
                           v_car_company_cd   := NULL;
                           v_color_cd         := NULL;
                           v_basic_color_cd   := NULL;
                           v_unladen_wt       := NULL;
                           param_line_cd := NULL;
                        END IF;
                                
                     ELSIF  param_line_cd = GIISP.V('LINE_CODE_MN')  OR param_line_cd = 'MN' THEN
                        IF v_cargo_flag = 'Y' THEN
                           INSERT INTO gixx_cargo (
                                 extract_id,           item_no,       vessel_cd,   geog_cd,
                                 cargo_class_cd,       bl_awb,        origin,      destn,
                                 etd, eta,             cargo_type,    tranship_destination,
                                 deduct_text,          pack_method,   print_tag,   tranship_origin,
                                 voyage_no,            lc_no) 
                           VALUES(p_extract_id, v_item_no,     v_vessel_cd, v_geog_cd,
                                 v_cargo_class_cd,     v_bl_awb,      v_origin,    v_destn,
                                 v_etd, v_eta,         v_cargo_type,  v_tranship_destination,
                                 v_deduct_text,        v_pack_method, v_print_tag, v_tranship_origin,
                                 v_voyage_no,          v_lc_no);   
                           v_multi_sw     := 'N';
                           v_cargo_flag   := 'N';
                           v_vessel_cd            := NULL;
                           v_geog_cd              := NULL;
                           v_cargo_class_cd       := NULL;
                           v_bl_awb               := NULL;  
                           v_origin               := NULL;
                           v_destn                := NULL;
                           v_etd                  := NULL;
                           v_eta                  := NULL;
                           v_cargo_type           := NULL;
                           v_tranship_destination := NULL;
                           v_deduct_text          := NULL;
                           v_pack_method          := NULL;
                           v_print_tag            := NULL;
                           v_tranship_origin      := NULL;
                           v_voyage_no            := NULL;
                           v_lc_no                := NULL;
                           param_line_cd          := NULL;
                        END IF;
                     ELSIF param_line_cd = GIISP.V('LINE_CODE_MH') THEN
                        IF v_item_ves_flag = 'Y' THEN
                           INSERT INTO gixx_item_ves(
                                extract_id,           item_no,    vessel_cd,    geog_limit,
                                deduct_text,          dry_date,   dry_place)
                           VALUES(p_extract_id, v_item_no,  v_vessel_cd2,  v_geog_limit2,
                                v_deduct_text2,       v_dry_date, v_dry_place); 
                           v_item_ves_flag := 'N';
                           v_vessel_cd2       := NULL;
                           v_geog_limit2      := NULL; 
                           v_deduct_text2     := NULL;
                           v_dry_date         := NULL;
                           v_dry_place        := NULL; 
                           param_line_cd      := NULL;
                        END IF;
                     END IF;
                     v_tsi_amt     := 0;
                     v_prem_amt    := 0; 
                  ELSE
                     v_exist := 'N';
                     --A.R.C. 12.18.2006
                     ---------------------------------------------------------------------------
                     IF param_line_cd = GIISP.V('LINE_CODE_AC') OR param_line_cd = 'AC' THEN --modification: added or statement Modified by: jeanette tan Date modified: 07.10.2002
                           v_date_of_birth    := NULL;
                           v_age              := NULL; 
                           v_civil_status     := NULL;
                           v_position_cd      := NULL;
                           v_monthly_salary   := NULL;
                           v_salary_grade     := NULL;
                           v_no_of_persons    := NULL;
                           v_destination      := NULL;
                           v_height           := NULL;
                           v_weight           := NULL;
                           v_sex              := NULL;
                           v_ac_class_cd      := NULL;
                       ELSIF param_line_cd = GIISP.V('LINE_CODE_AV') THEN
                           v_vessel_cd1       := NULL;
                           v_total_fly_time   := NULL;
                           v_qualification    := NULL;
                           v_purpose          := NULL;
                           v_geog_limit       := NULL;
                           v_deduct_text1     := NULL;
                           v_fixed_wing       := NULL;
                           v_rotor            := NULL; 
                           v_prev_util_hrs    := NULL;
                           v_est_util_hrs     := NULL;
                     ELSIF param_line_cd = GIISP.V('LINE_CODE_CA') THEN
                          v_section_line_cd         := NULL; 
                          v_section_subline_cd      := NULL; 
                          v_capacity_cd             := NULL; 
                          v_section_or_hazard_cd    := NULL;
                          v_property_no             := NULL; 
                          v_property_no_type        := NULL;
                          v_location                := NULL;
                          v_conveyance_info         := NULL;
                          v_limit_of_liability      := NULL;
                          v_interest_on_premises    := NULL;
                          v_section_or_hazard_info  := NULL;
                     ELSIF param_line_cd = GIISP.V('LINE_CODE_FI') THEN
                          v_district_no           := NULL;
                          v_eq_zone               := NULL;
                          v_tarf_cd               := NULL;
                          v_block_no              := NULL;
                          v_loc_risk1             := NULL; 
                          v_loc_risk2             := NULL;
                          v_fr_item_type          := NULL;
                          v_loc_risk3             := NULL;
                          v_tariff_zone           := NULL;
                          v_typhoon_zone          := NULL;
                          v_front                 := NULL; 
                          v_right                 := NULL;
                          v_construction_cd       := NULL;
                          v_left                  := NULL; 
                          v_rear                  := NULL; 
                          v_construction_remarks  := NULL;
                          v_flood_zone            := NULL;
                          v_occupancy_cd          := NULL;
                          v_occupancy_remarks     := NULL;
                          v_fi_assignee           := NULL;   
                          v_block_id              := NULL;
                     ELSIF param_line_cd = GIISP.V('LINE_CODE_MC') THEN
                          v_subline_cd       := NULL;
                          v_coc_yy           := NULL;
                          v_coc_seq_no       := NULL;
                          v_coc_serial_no    := NULL;
                          v_coc_type         := NULL; 
                          v_repair_lim       := NULL;
                          v_color            := NULL;
                          v_motor_no         := NULL;
                          v_model_year       := NULL;
                          v_make             := NULL;
                          v_mot_type         := NULL;
                          v_est_value        := NULL;
                          v_serial_no        := NULL;
                          v_towing           := NULL;
                          v_assignee         := NULL;
                          v_plate_no         := NULL;
                          v_no_of_pass       := NULL;
                          v_tariff_zone1     := NULL;
                          v_coc_issue_date   := NULL;       
                          v_subline_type_cd  := NULL;
                          v_mv_file_no       := NULL;
                          v_acquired_from    := NULL;  
                          v_type_of_body_cd  := NULL;
                          v_car_company_cd   := NULL;
                          v_color_cd         := NULL;
                          v_basic_color_cd   := NULL;
                          v_unladen_wt       := NULL;
                     ELSIF  param_line_cd = GIISP.V('LINE_CODE_MN') THEN
                          v_vessel_cd            := NULL;
                          v_geog_cd              := NULL;
                          v_cargo_class_cd       := NULL;
                          v_bl_awb               := NULL;  
                          v_origin               := NULL;
                          v_destn                := NULL;
                          v_etd                  := NULL;
                          v_eta                  := NULL;
                          v_cargo_type           := NULL;
                          v_tranship_destination := NULL;
                          v_deduct_text          := NULL;
                          v_pack_method          := NULL;
                          v_print_tag            := NULL;
                          v_tranship_origin      := NULL;
                          v_voyage_no            := NULL;
                          v_lc_no                := NULL;
                     ELSIF param_line_cd = GIISP.V('LINE_CODE_MH') THEN
                          v_vessel_cd2       := NULL;
                          v_geog_limit2      := NULL; 
                          v_deduct_text2     := NULL;
                          v_dry_date         := NULL;
                          v_dry_place        := NULL; 
                     END IF;
                  END IF;
                  
                   
                BEGIN
                  
                    v_policy_id := p_policy_id;
                    
                    FOR peril IN (
                       SELECT line_cd,
                              peril_cd,
                              tarf_cd,
                              prem_rt,
                              NVL(tsi_amt,0) tsi_amt,
                              NVL(prem_amt,0) prem_amt,
                              comp_rem,
                              discount_sw,
                              ri_comm_rate,  
                              NVL(ri_comm_amt,0) ri_comm_amt
                         FROM gipi_itmperil 
                        WHERE policy_id = v_policy_id
                          AND item_no   = v_item_no
                        ORDER BY item_no, peril_cd )
                   LOOP
                      v_line_cd1      := NVL(peril.line_cd,v_line_cd1) ;
                      v_peril_cd      := NVL(peril.peril_cd,v_peril_cd) ;
                      v_tarf_cd1      := NVL(peril.tarf_cd,v_tarf_cd1) ;
                      v_prem_rt       := NVL(peril.prem_rt,v_prem_rt) ;
                      v_tsi_amt1      := peril.tsi_amt;
                      v_prem_amt1     := peril.prem_amt;
                      v_comp_rem      := NVL(peril.comp_rem,v_comp_rem) ;
                      v_discount_sw1  := NVL(peril.discount_sw,v_discount_sw1) ;
                      v_ri_comm_rate  := NVL(peril.ri_comm_rate,v_ri_comm_rate) ;
                      v_ri_comm_amt   := peril.ri_comm_amt;

                     FOR peril_exist IN (
                        SELECT 'a'
                          FROM gixx_itmperil
                         WHERE extract_id = p_extract_id
                           AND item_no    = v_item_no
                           AND line_cd    = v_line_cd1
                           AND peril_cd   = v_peril_cd)
                     LOOP
                      exist1 := 'Y';
                     END LOOP;
                     
                     
                     IF exist1 = 'N' THEN              
                        FOR pol IN (SELECT policy_id   
                                   FROM GIPI_POLBASIC
                                  WHERE line_cd     = p_line_cd
                                    AND subline_cd  = p_subline_cd
                                    AND iss_cd      = p_iss_cd
                                    AND issue_yy    = p_issue_yy
                                    AND pol_seq_no  = p_pol_seq_no
                                    AND renew_no    = p_renew_no
                                    AND pol_flag    != '5'
                                    AND policy_id   != p_policy_id
                               ORDER BY eff_date)
                        LOOP
                            v_policy_id := pol.policy_id;
                            
                            FOR endt_peril IN (
                               SELECT line_cd,
                                      peril_cd,
                                      tarf_cd, 
                                      prem_rt,
                                      NVL(tsi_amt,0) tsi_amt,
                                      NVL(prem_amt,0) prem_amt,
                                      comp_rem,
                                      discount_sw,
                                      ri_comm_rate,  
                                      NVL(ri_comm_amt,0) ri_comm_amt
                                 FROM gipi_itmperil
                                WHERE policy_id = v_policy_id
                                  AND item_no   = v_item_no
                                  AND line_cd   = v_line_cd1
                                  AND peril_cd  = v_peril_cd)
                            LOOP
                              v_line_cd1      := NVL(endt_peril.line_cd,v_line_cd1) ;
                              v_peril_cd      := NVL(endt_peril.peril_cd,v_peril_cd) ;
                              v_tarf_cd1      := NVL(endt_peril.tarf_cd,v_tarf_cd1) ;
                              v_prem_rt       := NVL(endt_peril.prem_rt,v_prem_rt) ;
                              v_tsi_amt1      := v_tsi_amt1 + endt_peril.tsi_amt;
                              v_prem_amt1     := v_prem_amt1 + endt_peril.prem_amt;
                              v_comp_rem      := NVL(endt_peril.comp_rem,v_comp_rem) ;
                              v_discount_sw1  := NVL(endt_peril.discount_sw,v_discount_sw1) ;
                              v_ri_comm_rate  := NVL(endt_peril.ri_comm_rate,v_ri_comm_rate) ;
                              v_ri_comm_amt   := v_ri_comm_amt + peril.ri_comm_amt;
                            END LOOP;
                        END LOOP;
                    

                        INSERT INTO GIXX_ITMPERIL(
                                extract_id,            item_no,         line_cd,        peril_cd,
                                tarf_cd,               prem_rt,         tsi_amt,        prem_amt,
                                comp_rem,              discount_sw,     ri_comm_rate,   ri_comm_amt)
                        VALUES( p_extract_id, v_item_no, v_line_cd1,    v_peril_cd,
                                v_tarf_cd1,            v_prem_rt,       v_tsi_amt1,     v_prem_amt1,
                                v_comp_rem,            v_discount_sw1,  v_ri_comm_rate, v_ri_comm_amt);

                        exist1         := 'N';                     
                        v_tsi_amt1     := 0;
                        v_prem_amt1    := 0;
                        v_ri_comm_amt  := 0;
                        v_line_cd1     := NULL;
                        v_peril_cd     := NULL;
                        v_tarf_cd1     := NULL;
                        v_prem_rt      := NULL;
                        v_comp_rem     := NULL;
                        v_discount_sw1 := NULL;
                        v_ri_comm_rate := NULL;
                        
                     ELSE
                        exist1 := 'N';
                     END IF;
                      
                   END LOOP;
                 
                END;
                
                BEGIN
   
                    v_policy_id := p_policy_id;

                   FOR mort IN (
                        SELECT iss_cd, mortg_cd, amount, remarks                   
                          FROM GIPI_MORTGAGEE
                         WHERE policy_id = v_policy_id
                           AND item_no   = v_item_no
                           AND NVL(delete_sw,'N') = 'N')
                   LOOP
                      v_iss_cd             := NVL(mort.iss_cd,v_iss_cd);       
                      v_mortg_cd           := NVL(mort.mortg_cd,v_mortg_cd);              
                      v_remarks            := NVL(mort.remarks,v_remarks);              
                      v_amount             := mort.amount; 
                       
                     
                      FOR exist IN ( SELECT 1
                                       FROM GIXX_MORTGAGEE
                                      WHERE ITEM_NO    = v_item_no
                                        AND mortg_cd   = v_mortg_cd
                                        AND extract_id = p_extract_id)
                      LOOP
                            mortg_exist := 'Y';
                      END LOOP;
                             
                      IF mortg_exist = 'N' THEN              
                         FOR pol IN (SELECT policy_id   
                                                   FROM GIPI_POLBASIC
                                                  WHERE line_cd     = p_line_cd
                                                    AND subline_cd  = p_subline_cd
                                                    AND iss_cd      = p_iss_cd
                                                    AND issue_yy    = p_issue_yy
                                                    AND pol_seq_no  = p_pol_seq_no
                                                    AND renew_no    = p_renew_no
                                                    AND pol_flag    != '5'
                                                    AND policy_id   != p_policy_id
                                               ORDER BY eff_date)
                          LOOP
                            v_policy_id := pol.policy_id;
                                    
                            FOR mort_endt IN (
                                   SELECT Iss_cd, mortg_cd, amount, remarks                   
                                     FROM GIPI_MORTGAGEE
                                    WHERE policy_id = v_policy_id
                                      AND item_no   = v_item_no
                                      AND mortg_cd  = v_mortg_cd
                                      AND NVL(delete_sw,'N') = 'N')
                            LOOP
                                v_iss_cd      := nvl(mort_endt.iss_cd,v_iss_cd);       
                                v_mortg_cd    := nvl(mort_endt.mortg_cd,v_mortg_cd);              
                                v_remarks     := nvl(mort_endt.remarks,v_remarks);              
                                v_amount      := v_amount + mort_endt.amount;
                            END LOOP;
                          END LOOP;
                               
                         INSERT INTO GIXX_MORTGAGEE(
                                    extract_id, item_no, iss_cd, mortg_cd, amount, remarks)                   
                            VALUES( p_extract_id, v_item_no, v_iss_cd, v_mortg_cd, 
                                    v_amount, v_remarks);                   

                            mortg_exist   := 'N';
                            v_iss_cd      := NULL;       
                            v_mortg_cd    := NULL;       
                            v_amount      := 0;
                            v_remarks     := NULL;       
                      ELSE
                        mortg_exist := 'N';
                      END IF; 
                   END LOOP;
                END; 
                               
            END LOOP;
            
            BEGIN
               GIPIS100_EXTRACT_SUMMARY.populate_engg(p_extract_id, p_policy_id, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
            END;
            BEGIN --added by robert SR 20307 10.27.15 
               GIPIS100_EXTRACT_SUMMARY.populate_principal(p_extract_id, p_policy_id, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
            END;			
             BEGIN
               GIPIS100_EXTRACT_SUMMARY.populate_wc(p_extract_id, p_policy_id, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
            END; 
                
        END;
        
        /*
        **  Created by    : Veronica V. Raymundo
        **  Date Created  : April 29, 2013
        **  Reference By  : GIPIS100 - View Policy Information
        **  Description   : Populate the GIXX_OPEN_CARGO and GIXX_OPEN_LIAB tables
        */
        
        PROCEDURE POPULATE_OPEN_LIAB 
          (p_extract_id   IN   NUMBER,
           p_policy_id    IN   GIPI_POLBASIC.policy_id%TYPE,
           p_line_cd      IN   GIPI_POLBASIC.line_cd%TYPE,
           p_subline_cd   IN   GIPI_POLBASIC.subline_cd%TYPE,
           p_iss_cd       IN   GIPI_POLBASIC.iss_cd%TYPE,
           p_issue_yy     IN   GIPI_POLBASIC.issue_yy%TYPE,
           p_pol_seq_no   IN   GIPI_POLBASIC.pol_seq_no%TYPE,
           p_renew_no     IN   GIPI_POLBASIC.renew_no%TYPE) IS
          

          v_policy_id               GIPI_POLBASIC.policy_id%TYPE;
          v_policy_id1              GIPI_POLBASIC.policy_id%TYPE;
          v_policy_id2              GIPI_POLBASIC.policy_id%TYPE;
          v_exist                   VARCHAR2(1) := 'N';
          v_exist1                  VARCHAR2(1) := 'N';
          exist1                    VARCHAR2(1) := 'N';
          
          v_geog_cd                 GIPI_OPEN_LIAB.GEOG_CD%TYPE;
          v_limit_liability         GIPI_OPEN_LIAB.LIMIT_LIABILITY%TYPE; 
          v_voy_limit               GIPI_OPEN_LIAB.VOY_LIMIT%TYPE;
          v_cargo_class_cd          GIPI_OPEN_CARGO.CARGO_CLASS_CD%TYPE;


        BEGIN
            
            FOR C IN (
                SELECT geog_cd,limit_liability,voy_limit
                  FROM GIPI_OPEN_LIAB
                 WHERE policy_id = p_policy_id
                ORDER BY geog_cd)
             LOOP
                 v_geog_cd           := c.geog_cd;      
                 v_limit_liability   := NVL(c.limit_liability, v_limit_liability);      
                 v_voy_limit         := NVL(c.voy_limit, v_voy_limit); 
               
               FOR B IN (
                   SELECT geog_cd, cargo_class_cd
                     FROM GIPI_OPEN_CARGO
                    WHERE policy_id = p_policy_id
                      AND geog_cd   = c.geog_cd)
               LOOP          
                 INSERT INTO GIXX_OPEN_CARGO
                    (extract_id, geog_cd, cargo_class_cd)
                 VALUES
                    (p_extract_id, b.geog_cd, b.cargo_class_cd );
               END LOOP;  
                 
             FOR exist IN (
                 SELECT 'a'
                   FROM GIXX_OPEN_LIAB
                  WHERE extract_id = p_extract_id
                    AND geog_cd    = v_geog_cd)
              LOOP
               v_exist := 'Y';
              END LOOP;
              
              IF v_exist = 'N' THEN
              
                  FOR pol IN (SELECT policy_id   
                               FROM GIPI_POLBASIC
                              WHERE line_cd     = p_line_cd
                                AND subline_cd  = p_subline_cd
                                AND iss_cd      = p_iss_cd
                                AND issue_yy    = p_issue_yy
                                AND pol_seq_no  = p_pol_seq_no
                                AND renew_no    = p_renew_no
                                AND pol_flag    != '5'
                                AND policy_id   != p_policy_id
                           ORDER BY eff_date)
                   LOOP
                        v_policy_id := pol.policy_id;
                        
                        FOR C IN (SELECT geog_cd,limit_liability,voy_limit
                                    FROM GIPI_OPEN_LIAB
                                   WHERE policy_id = v_policy_id
                                     AND geog_cd   = v_geog_cd
                                ORDER BY geog_cd)
                       LOOP
                           v_geog_cd           := c.geog_cd;      
                           v_limit_liability   := NVL(c.limit_liability, v_limit_liability);      
                           v_voy_limit         := NVL(c.voy_limit, v_voy_limit); 
                       END LOOP; 
                        
                   END LOOP;
                      
                    INSERT INTO GIXX_OPEN_LIAB (
                          extract_id, geog_cd, limit_liability,voy_limit)
                    VALUES (p_extract_id, v_geog_cd, v_limit_liability,v_voy_limit ); 
                     
                     v_exist              := 'N';
                     v_geog_cd            := NULL;
                     v_limit_liability    := NULL;
                     v_voy_limit          := NULL;
                    
              ELSE
                 v_exist := 'N';
              END IF;     
              
           END LOOP;
             
        END;
        
        /*
        **  Created by    : Veronica V. Raymundo
        **  Date Created  : April 29, 2013
        **  Reference By  : GIPIS100 - View Policy Information
        **  Description   : Populate the GIXX_OPEN_PERIL table
        */
        
        PROCEDURE populate_open_peril     
        (p_extract_id   IN   NUMBER,
         p_policy_id    IN   GIPI_POLBASIC.policy_id%TYPE,
         p_line_cd      IN   GIPI_POLBASIC.line_cd%TYPE,
         p_subline_cd   IN   GIPI_POLBASIC.subline_cd%TYPE,
         p_iss_cd       IN   GIPI_POLBASIC.iss_cd%TYPE,
         p_issue_yy     IN   GIPI_POLBASIC.issue_yy%TYPE,
         p_pol_seq_no   IN   GIPI_POLBASIC.pol_seq_no%TYPE,
         p_renew_no     IN   GIPI_POLBASIC.renew_no%TYPE) IS


          v_policy_id               GIPI_POLBASIC.policy_id%TYPE;
          v_policy_id1              GIPI_POLBASIC.policy_id%TYPE;
          v_policy_id2              GIPI_POLBASIC.policy_id%TYPE;
          v_exist                   VARCHAR2(1) := 'N';
          v_exist1                  VARCHAR2(1) := 'N';
          exist1                    VARCHAR2(1) := 'N';
          
          v_geog_cd                 GIPI_OPEN_PERIL.geog_cd%TYPE;                        
          v_line_cd                 GIPI_OPEN_PERIL.line_cd%TYPE;                        
          v_peril_cd                GIPI_OPEN_PERIL.peril_cd%TYPE;
          v_prem_rate               GIPI_OPEN_PERIL.prem_rate%TYPE;
          
                                  
        BEGIN
         
             FOR c IN (
                SELECT geog_cd, line_cd, peril_cd, prem_rate 
                  FROM GIPI_OPEN_PERIL
                 WHERE policy_id = p_policy_id
                ORDER BY geog_cd, line_cd, peril_cd)
             LOOP
                 v_geog_cd           := c.geog_cd;  
                 v_line_cd           := c.line_cd;                    
                 v_peril_cd          := c.peril_cd; 
                 v_prem_rate         := NVL(c.prem_rate, v_prem_rate);  
            
               FOR exist IN (
                 SELECT 'a'
                   FROM GIXX_OPEN_PERIL
                  WHERE extract_id = p_extract_id
                    AND geog_cd    = v_geog_cd
                    AND line_cd    = v_line_cd         
                    AND peril_cd   = v_peril_cd)
               LOOP
                v_exist := 'Y';
               END LOOP;
              
                IF v_exist = 'N' THEN          
                    FOR pol IN (SELECT policy_id   
                                       FROM GIPI_POLBASIC
                                      WHERE line_cd     = p_line_cd
                                        AND subline_cd  = p_subline_cd
                                        AND iss_cd      = p_iss_cd
                                        AND issue_yy    = p_issue_yy
                                        AND pol_seq_no  = p_pol_seq_no
                                        AND renew_no    = p_renew_no
                                        AND pol_flag    != '5'
                                        AND policy_id   != p_policy_id
                                   ORDER BY eff_date)
                     LOOP
                         v_policy_id := pol.policy_id;
                             
                         FOR C IN (
                               SELECT geog_cd, line_cd, peril_cd, prem_rate
                                 FROM GIPI_OPEN_PERIL
                                WHERE policy_id =  v_policy_id
                                  AND geog_cd   =  v_geog_cd
                                  AND line_cd   =  v_line_cd
                                  AND peril_cd  =  v_peril_cd    
                              ORDER BY geog_cd, line_cd, peril_cd)
                         LOOP
                               v_geog_cd      := c.geog_cd;      
                               v_line_cd      := c.line_cd;                    
                               v_peril_cd     := c.peril_cd; 
                               v_prem_rate    := NVL(c.prem_rate, v_prem_rate);  
              
                         END LOOP; 
                     END LOOP;
                      
                    
                    INSERT INTO GIXX_OPEN_PERIL (
                                extract_id, geog_cd,
                                line_cd, peril_cd, prem_rate)
                       VALUES (p_extract_id, v_geog_cd,
                               v_line_cd, v_peril_cd, v_prem_rate); 
                     v_exist := 'N';
                     v_geog_cd          := NULL;
                     v_line_cd          := NULL;
                     v_peril_cd         := NULL;
                     v_prem_rate        := NULL;
                         
                ELSE
                     v_exist := 'N';
                END IF;     

                
            END LOOP;
           
        END;
        
        /*
        **  Created by    : Veronica V. Raymundo
        **  Date Created  : April 29, 2013
        **  Reference By  : GIPIS100 - View Policy Information
        **  Description   : Populate the GIXX_CARGO_CARRIER table
        */
        
        PROCEDURE populate_cargo_carrier
         (p_extract_id   IN   NUMBER,
          p_policy_id    IN   GIPI_POLBASIC.policy_id%TYPE,
          p_line_cd      IN   GIPI_POLBASIC.line_cd%TYPE,
          p_subline_cd   IN   GIPI_POLBASIC.subline_cd%TYPE,
          p_iss_cd       IN   GIPI_POLBASIC.iss_cd%TYPE,
          p_issue_yy     IN   GIPI_POLBASIC.issue_yy%TYPE,
          p_pol_seq_no   IN   GIPI_POLBASIC.pol_seq_no%TYPE,
          p_renew_no     IN   GIPI_POLBASIC.renew_no%TYPE) IS
          
          v_policy_id               GIPI_POLBASIC.policy_id%TYPE;
          v_policy_id1              GIPI_POLBASIC.policy_id%TYPE;
          v_policy_id2              GIPI_POLBASIC.policy_id%TYPE;
          v_exist                   VARCHAR2(1) := 'N';
          v_exist1                  VARCHAR2(1) := 'N';
          exist1                    VARCHAR2(1) := 'N';
          
          v_item_no                 GIPI_CARGO_CARRIER.item_no%TYPE;
          v_vessel_cd               GIPI_CARGO_CARRIER.vessel_cd%TYPE;  
          v_voy_limit               GIPI_CARGO_CARRIER.voy_limit%TYPE;  
                                  
        BEGIN   
             FOR C IN (
                SELECT item_no, vessel_cd, voy_limit 
                  FROM GIPI_CARGO_CARRIER
                 WHERE policy_id = p_policy_id
                ORDER BY item_no, vessel_cd)
             LOOP
                 v_item_no           := c.item_no;  
                 v_vessel_cd         := c.vessel_cd;                    
                 v_voy_limit         := NVL(c.voy_limit, v_voy_limit); 
                                        
                 FOR exist IN (
                     SELECT 'a'
                       FROM GIXX_CARGO_CARRIER
                      WHERE extract_id = p_extract_id
                        AND item_no    = v_item_no
                        AND vessel_cd     = v_vessel_cd)
                  LOOP
                   v_exist := 'Y';
                  END LOOP;
                  
                  IF v_exist = 'N' THEN          
                    
                     FOR pol IN (SELECT policy_id   
                                   FROM GIPI_POLBASIC
                                  WHERE line_cd     = p_line_cd
                                    AND subline_cd  = p_subline_cd
                                    AND iss_cd      = p_iss_cd
                                    AND issue_yy    = p_issue_yy
                                    AND pol_seq_no  = p_pol_seq_no
                                    AND renew_no    = p_renew_no
                                    AND pol_flag    != '5'
                                    AND policy_id   != p_policy_id
                               ORDER BY eff_date)
                     LOOP
                         v_policy_id := pol.policy_id;
                         
                         FOR C IN (
                           SELECT item_no, vessel_cd, voy_limit
                             FROM GIPI_CARGO_CARRIER
                            WHERE policy_id =  v_policy_id
                              AND item_no   =  v_item_no
                              AND vessel_cd =  v_vessel_cd
                          ORDER BY item_no, vessel_cd)
                        LOOP
                           v_item_no           := c.item_no;      
                           v_vessel_cd         := c.vessel_cd;                    
                           v_voy_limit         := NVL(c.voy_limit, v_voy_limit);  
                        END LOOP; 
                         
                     END LOOP;
                       
                    INSERT INTO GIXX_CARGO_CARRIER (
                                extract_id, item_no,
                                vessel_cd, voy_limit)
                       VALUES (p_extract_id, v_item_no,
                               v_vessel_cd, v_voy_limit);
                                
                     v_exist := 'N';
                     v_item_no             := NULL;
                     v_vessel_cd           := NULL;
                     v_voy_limit           := NULL;
                           
                  ELSE
                     v_exist := 'N';
                     
                  END IF;         
                              
             END LOOP;
                          
        END;
        
         /*
        **  Created by    : Veronica V. Raymundo
        **  Date Created  : April 29, 2013
        **  Reference By  : GIPIS100 - View Policy Information
        **  Description   : Populate the GIXX_BANK_SCHEDULE table
        */
        
       PROCEDURE populate_bank_schedule 
       (p_extract_id   IN   NUMBER,
        p_policy_id    IN   GIPI_POLBASIC.policy_id%TYPE,
        p_line_cd      IN   GIPI_POLBASIC.line_cd%TYPE,
        p_subline_cd   IN   GIPI_POLBASIC.subline_cd%TYPE,
        p_iss_cd       IN   GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy     IN   GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no   IN   GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no     IN   GIPI_POLBASIC.renew_no%TYPE) IS

        v_bank_item_no              GIXX_BANK_SCHEDULE.bank_item_no%TYPE;    
        v_bank_line_cd              GIXX_BANK_SCHEDULE.bank_line_cd%TYPE;  
        v_bank_subline_cd           GIXX_BANK_SCHEDULE.bank_subline_cd%TYPE;
        v_bank_iss_cd               GIXX_BANK_SCHEDULE.bank_iss_cd%TYPE;
        v_bank_issue_yy             GIXX_BANK_SCHEDULE.bank_issue_yy%TYPE;
        v_bank_pol_seq_no           GIXX_BANK_SCHEDULE.bank_pol_seq_no%TYPE;
        v_bank_endt_seq_nO          GIXX_BANK_SCHEDULE.bank_endt_seq_no%TYPE;
        v_bank_renew_no             GIXX_BANK_SCHEDULE.bank_renew_no%TYPE;
        v_bank_eff_date             GIXX_BANK_SCHEDULE.bank_eff_date%TYPE;
        v_bank                      GIXX_BANK_SCHEDULE.bank%TYPE;
        v_include_tag               GIXX_BANK_SCHEDULE.include_tag%TYPE;
        v_bank_address              GIXX_BANK_SCHEDULE.bank_address%TYPE;
        v_cash_in_vault             GIXX_BANK_SCHEDULE.cash_in_vault%TYPE;
        v_cash_in_transit           GIXX_BANK_SCHEDULE.cash_in_transit%TYPE;

        BEGIN
           FOR pol IN (
             SELECT policy_id, line_cd, subline_cd, iss_cd, 
                    issue_yy, pol_seq_no, renew_no
               FROM GIPI_POLBASIC
              WHERE line_cd     = p_line_cd
                AND subline_cd  = p_subline_cd
                AND iss_cd      = p_iss_cd
                AND issue_yy    = p_issue_yy
                AND pol_seq_no  = p_pol_seq_no
                AND renew_no    = p_renew_no
                AND endt_seq_no = 0)
          LOOP
            FOR bank_sched IN (
               SELECT bank_item_no,      bank_line_cd,             
                      bank_subline_cd,   bank_iss_cd,            
                      bank_issue_yy,     bank_pol_seq_no,        
                      bank_endt_seq_no,  bank_renew_no,          
                      bank_eff_date,     bank,                 
                      include_tag,       bank_address,           
                      cash_in_vault,     cash_in_transit
                 FROM GIPI_BANK_SCHEDULE
                WHERE policy_id = pol.policy_id)
            LOOP
              v_bank_item_no       := bank_sched.bank_item_no;          
              v_bank_line_cd       := bank_sched.bank_line_cd;          
              v_bank_subline_cd    := bank_sched.bank_subline_cd;      
              v_bank_iss_cd        := bank_sched.bank_iss_cd;        
              v_bank_pol_seq_no    := bank_sched.bank_pol_seq_no;        
              v_bank_renew_no      := bank_sched.bank_renew_no;        
              v_bank_endt_seq_no   := bank_sched.bank_endt_seq_no;        
              v_bank_eff_date      := bank_sched.bank_eff_date;                
              v_bank_issue_yy      := bank_sched.bank_issue_yy;         
              v_bank               := bank_sched.bank;
              v_include_tag        := bank_sched.include_tag;
              v_bank_address       := bank_sched.bank_address;         
              v_cash_in_vault      := nvl(bank_sched.cash_in_vault,0);         
              v_cash_in_transit    := nvl(bank_sched.cash_in_transit,0);         

              FOR endt IN (
                SELECT policy_id,endt_expiry_date 
                  FROM GIPI_POLBASIC
                 WHERE line_cd      = pol.line_cd
                   AND subline_cd   = pol.subline_cd
                   AND iss_cd       = pol.iss_cd
                   AND issue_yy     = pol.issue_yy
                   AND pol_seq_no   = pol.pol_seq_no
                   AND renew_no     = pol.renew_no
                   AND endt_seq_no != 0
                 ORDER BY eff_date)
              LOOP
                IF TO_CHAR(endt.endt_expiry_date,'MM-DD-YYYY HH24') >= TO_CHAR(SYSDATE,'MM-DD-YYYY HH24') THEN   
                   FOR bank_sched IN (
                     SELECT bank_item_no,      bank_line_cd,             
                            bank_subline_cd,   bank_iss_cd,            
                            bank_issue_yy,     bank_pol_seq_no,        
                            bank_endt_seq_no,  bank_renew_no,          
                            bank_eff_date,     bank,                 
                            include_tag,       bank_address,           
                            cash_in_vault,     cash_in_transit
                       FROM GIPI_BANK_SCHEDULE
                      WHERE policy_id = endt.policy_id)
                    LOOP
                      
                       v_bank_item_no       := NVL(bank_sched.bank_item_no,v_bank_item_no);          
                       v_bank_line_cd       := NVL(bank_sched.bank_line_cd,v_bank_line_cd);          
                       v_bank_subline_cd    := NVL(bank_sched.bank_subline_cd,v_bank_subline_cd);      
                       v_bank_iss_cd        := NVL(bank_sched.bank_iss_cd,v_bank_iss_cd);        
                       v_bank_pol_seq_no    := NVL(bank_sched.bank_pol_seq_no,v_bank_pol_seq_no);        
                       v_bank_renew_no      := NVL(bank_sched.bank_renew_no,v_bank_renew_no);        
                       v_bank_endt_seq_no   := NVL(bank_sched.bank_endt_seq_no,v_bank_endt_seq_no);        
                       v_bank_eff_date      := NVL(bank_sched.bank_eff_date,v_bank_eff_date);                
                       v_bank_issue_yy      := NVL(bank_sched.bank_issue_yy,v_bank_issue_yy);         
                       v_bank               := NVL(bank_sched.bank,v_bank);
                       v_include_tag        := NVL(bank_sched.include_tag,v_include_tag);
                       v_bank_address       := NVL(bank_sched.bank_address,v_bank_address);         
                       v_cash_in_vault      := NVL(bank_sched.cash_in_vault,v_cash_in_vault);         
                       v_cash_in_transit    := NVL(bank_sched.cash_in_transit,v_cash_in_transit);         
                    END LOOP;
                END IF;
              END LOOP;  

                 INSERT INTO GIXX_BANK_SCHEDULE(
                         extract_id,                  bank_item_no,          
                         bank_line_cd,             
                         bank_subline_cd,             bank_iss_cd,            
                         bank_issue_yy,               bank_pol_seq_no,        
                         bank_endt_seq_no,            bank_renew_no,          
                         bank_eff_date,               bank,                 
                         include_tag,                 bank_address,           
                         cash_in_vault,               cash_in_transit       )
                 VALUES( p_extract_id,       v_bank_item_no,          
                         v_bank_line_cd,             
                         v_bank_subline_cd,   v_bank_iss_cd,            
                         v_bank_issue_yy,     v_bank_pol_seq_no,        
                         v_bank_endt_seq_no,  v_bank_renew_no,          
                         v_bank_eff_date,     v_bank,                 
                         v_include_tag,       v_bank_address,           
                         v_cash_in_vault,     v_cash_in_transit       );   
                                              
                 v_bank_item_no       := NULL;         
                 v_bank_line_cd       := NULL;               
                 v_bank_subline_cd    := NULL;         
                 v_bank_iss_cd        := NULL;             
                 v_bank_issue_yy      := NULL;         
                 v_bank_pol_seq_no    := NULL;             
                 v_bank_endt_seq_no   := NULL;         
                 v_bank_renew_no      := NULL;              
                 v_bank_eff_date      := NULL;          
                 v_bank               := NULL;           
                 v_include_tag        := NULL;         
                 v_bank_address       := NULL;               
                 v_cash_in_vault      := NULL;         
                 v_cash_in_transit    := NULL;           

             END LOOP;
          END LOOP;
            
        END;
        
         /*
        **  Created by    : Veronica V. Raymundo
        **  Date Created  : April 29, 2013
        **  Reference By  : GIPIS100 - View Policy Information
        **  Description   : Populate the GIXX_ORIG_ITMPERIL table
        */
        
        PROCEDURE populate_co_peril 
        (p_extract_id   IN   NUMBER,
         p_line_cd      IN   GIPI_POLBASIC.line_cd%TYPE,
         p_subline_cd   IN   GIPI_POLBASIC.subline_cd%TYPE,
         p_iss_cd       IN   GIPI_POLBASIC.iss_cd%TYPE,
         p_issue_yy     IN   GIPI_POLBASIC.issue_yy%TYPE,
         p_pol_seq_no   IN   GIPI_POLBASIC.pol_seq_no%TYPE,
         p_renew_no     IN   GIPI_POLBASIC.renew_no%TYPE)

        IS
          v_item_no                 GIPI_ITEM.item_no%TYPE;
          v_line_cd                 GIPI_ITMPERIL.line_cd%TYPE;
          v_peril_cd                GIPI_ITMPERIL.peril_cd%TYPE;
          v_prem_rt                 GIPI_ITMPERIL.prem_rt%TYPE;
          v_tsi_amt                 GIPI_ITMPERIL.tsi_amt%TYPE;
          v_prem_amt                GIPI_ITMPERIL.prem_amt%TYPE;
          v_comp_rem                GIPI_ITMPERIL.comp_rem%TYPE;
          v_discount_sw             GIPI_ITMPERIL.discount_sw%TYPE;
          v_ri_comm_rate            GIPI_ITMPERIL.ri_comm_rate%TYPE;
          v_ri_comm_amt             GIPI_ITMPERIL.ri_comm_amt%TYPE;
          v_exist                   VARCHAR2(1) := 'N';
          v_insert                  VARCHAR2(1) := 'N';

        BEGIN
          FOR pol IN ( 
             SELECT policy_id, line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
               FROM GIPI_POLBASIC
              WHERE line_cd     = p_line_cd
                AND subline_cd  = p_subline_cd
                AND iss_cd      = p_iss_cd
                AND issue_yy    = p_issue_yy
                AND pol_seq_no  = p_pol_seq_no
                AND renew_no    = p_renew_no
                AND endt_seq_no = 0)
          LOOP 
             FOR itm_no IN (
               SELECT item_no
                 FROM GIXX_ITEM
                WHERE extract_id = p_extract_id)
             LOOP
                v_item_no := itm_no.item_no;
              FOR perl IN (
                SELECT peril_cd
                  FROM GIXX_ITMPERIL
                 WHERE extract_id = p_extract_id
                   AND item_no    = v_item_no
                 ORDER BY item_no, peril_cd )
              LOOP   
                v_peril_cd      := perl.peril_cd;
                v_exist         := 'N';

                FOR peril IN (
                   SELECT line_cd, prem_rt,
                          NVL(tsi_amt,0) tsi_amt,
                          NVL(prem_amt,0) prem_amt,
                          comp_rem, discount_sw, ri_comm_rate, NVL(ri_comm_amt,0) ri_comm_amt
                     FROM GIPI_ORIG_ITMPERIL 
                    WHERE policy_id = pol.policy_id
                      AND item_no   = v_item_no
                      AND peril_cd  = v_peril_cd
                    ORDER BY item_no, peril_cd )
                LOOP
                  v_exist         := 'Y';
                  v_line_cd       := NVL(peril.line_cd,v_line_cd) ;
                  v_prem_rt       := NVL(peril.prem_rt,v_prem_rt) ;
                  v_tsi_amt       := NVL(peril.tsi_amt,0);
                  v_prem_amt      := NVL(peril.prem_amt,0);
                  v_comp_rem      := NVL(peril.comp_rem,v_comp_rem) ;
                  v_discount_sw   := NVL(peril.discount_sw,v_discount_sw) ;
                  v_ri_comm_rate  := NVL(peril.ri_comm_rate,v_ri_comm_rate) ;
                  v_ri_comm_amt   := peril.ri_comm_amt;

                   FOR endt IN (
                     SELECT policy_id, endt_expiry_date
                       FROM GIPI_POLBASIC
                      WHERE line_cd      = pol.line_cd
                        AND subline_cd   = pol.subline_cd
                        AND iss_cd       = pol.iss_cd
                        AND issue_yy     = pol.issue_yy
                        AND pol_seq_no   = pol.pol_seq_no
                        AND renew_no     = pol.renew_no
                        AND endt_seq_no != 0
                      ORDER BY eff_date)
                   LOOP
                     IF TO_CHAR(endt.endt_expiry_date,'MM-DD-YYYY HH24') >= TO_CHAR(SYSDATE,'MM-DD-YYYY HH24') THEN   
                        
                         FOR endt_peril IN (
                           SELECT line_cd, prem_rt, 
                                  NVL(tsi_amt,0) tsi_amt,
                                  NVL(prem_amt,0) prem_amt,
                                  comp_rem, discount_sw, ri_comm_rate,  
                                  NVL(ri_comm_amt,0) ri_comm_amt
                             FROM GIPI_ORIG_ITMPERIL
                            WHERE policy_id = endt.policy_id
                              AND item_no   = v_item_no
                              AND line_cd   = pol.line_cd
                              AND peril_cd  = v_peril_cd)
                         LOOP
                            v_line_cd       := NVL(endt_peril.line_cd,v_line_cd) ;
                            v_prem_rt       := NVL(endt_peril.prem_rt,v_prem_rt) ;
                            v_tsi_amt       := v_tsi_amt + endt_peril.tsi_amt;
                            v_prem_amt      := v_prem_amt + endt_peril.prem_amt;
                            v_comp_rem      := NVL(endt_peril.comp_rem,v_comp_rem) ;
                            v_discount_sw   := NVL(endt_peril.discount_sw,v_discount_sw) ;
                            v_ri_comm_rate  := NVL(endt_peril.ri_comm_rate,v_ri_comm_rate) ;
                            v_ri_comm_amt   := v_ri_comm_amt + endt_peril.ri_comm_amt;
                         END LOOP; 
                   END IF;
                 END LOOP; -- END OF ENDT CURSOR --

                 INSERT INTO GIXX_ORIG_ITMPERIL(
                           extract_id,            item_no,         line_cd,        peril_cd,
                           prem_rt,               tsi_amt,         prem_amt,
                           comp_rem,              discount_sw,     ri_comm_rate,   ri_comm_amt)
                  VALUES(  p_extract_id,          v_item_no,       pol.line_cd ,   v_peril_cd,
                           v_prem_rt,             v_tsi_amt ,      v_prem_amt,
                           v_comp_rem,            v_discount_sw ,  v_ri_comm_rate, v_ri_comm_amt);
                       v_tsi_amt      := 0;
                       v_prem_amt     := 0;
                       v_ri_comm_amt  := 0;
                       v_line_cd      := NULL;
                       v_prem_rt      := NULL;
                       v_comp_rem     := NULL;
                       v_discount_sw  := NULL;
                       v_ri_comm_rate := NULL;
                END LOOP; -- END OF PERIL CURSOR --

                IF v_exist  = 'N' THEN
                   FOR endt IN (
                     SELECT policy_id, endt_expiry_date
                       FROM GIPI_POLBASIC
                      WHERE line_cd      = pol.line_cd
                        AND subline_cd   = pol.subline_cd
                        AND iss_cd       = pol.iss_cd
                        AND issue_yy     = pol.issue_yy
                        AND pol_seq_no   = pol.pol_seq_no
                        AND renew_no     = pol.renew_no
                        AND endt_seq_no != 0
                      ORDER BY eff_date)
                   LOOP
                     IF TO_CHAR(endt.endt_expiry_date,'MM-DD-YYYY HH24') >= TO_CHAR(SYSDATE,'MM-DD-YYYY HH24') THEN   
                        
                         FOR endt_peril IN (
                           SELECT line_cd, prem_rt, 
                                  NVL(tsi_amt,0) tsi_amt,
                                  NVL(prem_amt,0) prem_amt,
                                  comp_rem, discount_sw, ri_comm_rate,  
                                  NVL(ri_comm_amt,0) ri_comm_amt
                             FROM GIPI_ORIG_ITMPERIL
                            WHERE policy_id = endt.policy_id
                              AND item_no   = v_item_no
                              AND line_cd   = pol.line_cd
                              AND peril_cd  = v_peril_cd)
                         LOOP
                            v_line_cd       := NVL(endt_peril.line_cd,v_line_cd) ;
                            v_prem_rt       := NVL(endt_peril.prem_rt,v_prem_rt) ;
                            v_tsi_amt       := v_tsi_amt + endt_peril.tsi_amt;
                            v_prem_amt      := v_prem_amt + endt_peril.prem_amt;
                            v_comp_rem      := NVL(endt_peril.comp_rem,v_comp_rem) ;
                            v_discount_sw   := NVL(endt_peril.discount_sw,v_discount_sw) ;
                            v_ri_comm_rate  := NVL(endt_peril.ri_comm_rate,v_ri_comm_rate) ;
                            v_ri_comm_amt   := v_ri_comm_amt + endt_peril.ri_comm_amt;
                         END LOOP; 
                   END IF;
                 END LOOP; -- END OF ENDT CURSOR --

                 INSERT INTO GIXX_ORIG_ITMPERIL(
                           extract_id,            item_no,         line_cd,        peril_cd,
                           prem_rt,               tsi_amt,         prem_amt,
                           comp_rem,              discount_sw,     ri_comm_rate,   ri_comm_amt)
                  VALUES( p_extract_id,  v_item_no,  pol.line_cd ,   v_peril_cd,
                           v_prem_rt,             v_tsi_amt ,      v_prem_amt,
                           v_comp_rem,            v_discount_sw ,  v_ri_comm_rate, v_ri_comm_amt);
                       v_tsi_amt      := 0;
                       v_prem_amt     := 0;
                       v_ri_comm_amt  := 0;
                       v_line_cd      := NULL;
                       v_peril_cd     := NULL;
                       v_prem_rt      := NULL;
                       v_comp_rem     := NULL;
                       v_discount_sw  := NULL;
                       v_ri_comm_rate := NULL;
                       v_exist        := 'N';  
                END IF;
              END LOOP; -- END OF PERL CURSOR --
             END LOOP; -- END OF ITM_NO CURSOR --
          END LOOP; -- END OF POL CURSOR --
        END;
        
        /*
        **  Created by    : Veronica V. Raymundo
        **  Date Created  : April 29, 2013
        **  Reference By  : GIPIS100 - View Policy Information
        **  Description   : Populate the GIXX_CO_INSURER table
        */
        
        PROCEDURE populate_co_ins 
        (p_extract_id   IN   NUMBER,
         p_co_sw        IN   GIPI_POLBASIC.co_insurance_sw%TYPE,
         p_line_cd      IN   GIPI_POLBASIC.line_cd%TYPE,
         p_subline_cd   IN   GIPI_POLBASIC.subline_cd%TYPE,
         p_iss_cd       IN   GIPI_POLBASIC.iss_cd%TYPE,
         p_issue_yy     IN   GIPI_POLBASIC.issue_yy%TYPE,
         p_pol_seq_no   IN   GIPI_POLBASIC.pol_seq_no%TYPE,
         p_renew_no     IN   GIPI_POLBASIC.renew_no%TYPE) IS
         
         v_co_ri_cd         GIPI_CO_INSURER.co_ri_cd%TYPE;
         v_co_ri_shr_pct    GIPI_CO_INSURER.co_ri_shr_pct%TYPE;
         v_co_ri_prem_amt   GIPI_CO_INSURER.co_ri_prem_amt%TYPE; 
         v_co_ri_tsi_amt    GIPI_CO_INSURER.co_ri_tsi_amt%TYPE;
           
        BEGIN
         
         FOR i IN (SELECT SUM(co_ri_tsi_amt) b, 
                          SUM(co_ri_prem_amt) c, 
                          co_ri_cd, co_ri_shr_pct
                     FROM GIPI_CO_INSURER  
                    WHERE policy_id IN (SELECT policy_id 
                                          FROM GIPI_POLBASIC 
                                         WHERE line_cd = p_line_cd 
                                           AND subline_cd = p_subline_cd
                                           AND iss_cd = p_iss_cd 
                                           AND issue_yy = p_issue_yy 
                                           AND pol_seq_no = p_pol_seq_no
                                           AND renew_no = p_renew_no)
                         GROUP BY co_ri_cd, co_ri_shr_pct) 
         LOOP
            v_co_ri_prem_amt  := i.c;
            v_co_ri_tsi_amt   := i.b;
            v_co_ri_cd        := i.co_ri_cd;
            v_co_ri_shr_pct   := i.co_ri_shr_pct; 
            
            INSERT INTO GIXX_CO_INSURER (
                   extract_id,            co_ri_cd,        co_ri_shr_pct, 
                   co_ri_prem_amt,        co_ri_tsi_amt)
            VALUES (
                   p_extract_id, v_co_ri_cd, v_co_ri_shr_pct, 
                   v_co_ri_prem_amt,      v_co_ri_tsi_amt);
         END LOOP;
         --------------------------------------------------------------------
          IF p_co_sw = '2' THEN
             GIPIS100_EXTRACT_SUMMARY.populate_co_peril(p_extract_id, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
          END IF;
          
        END;
        
        /*
        **  Created by    : Veronica V. Raymundo
        **  Date Created  : April 29, 2013
        **  Reference By  : GIPIS100 - View Policy Information
        **  Description   : Populate the GIXX_MAIN_CO_INS table
        */
        
        PROCEDURE populate_main 
        (p_extract_id   IN   NUMBER,
         p_co_sw        IN   GIPI_POLBASIC.co_insurance_sw%TYPE,
         p_line_cd      IN   GIPI_POLBASIC.line_cd%TYPE,
         p_subline_cd   IN   GIPI_POLBASIC.subline_cd%TYPE,
         p_iss_cd       IN   GIPI_POLBASIC.iss_cd%TYPE,
         p_issue_yy     IN   GIPI_POLBASIC.issue_yy%TYPE,
         p_pol_seq_no   IN   GIPI_POLBASIC.pol_seq_no%TYPE,
         p_renew_no     IN   GIPI_POLBASIC.renew_no%TYPE) IS
         
         v_prem_amt         GIPI_MAIN_CO_INS.prem_amt%TYPE;
         v_tsi_amt          GIPI_MAIN_CO_INS.tsi_amt%TYPE;
         v_exist            VARCHAR2(1) := 'N';
         
        BEGIN
          FOR pol IN ( 
             SELECT policy_id, line_cd, subline_cd, 
                    iss_cd, issue_yy, pol_seq_no, renew_no
               FROM GIPI_POLBASIC
              WHERE line_cd     = p_line_cd
                AND subline_cd  = p_subline_cd
                AND iss_cd      = p_iss_cd
                AND issue_yy    = p_issue_yy
                AND pol_seq_no  = p_pol_seq_no
                AND renew_no    = p_renew_no
                AND endt_seq_no = 0)
          LOOP 
             FOR main IN (
               SELECT prem_amt, tsi_amt 
                 FROM GIPI_MAIN_CO_INS
                WHERE policy_id = pol.policy_id)
             LOOP
                v_exist    := 'Y';
                v_prem_amt := NVL(main.prem_amt,0);    
                v_tsi_amt  := NVL(main.tsi_amt,0);
             END LOOP;

             FOR endt IN (
                SELECT policy_id, endt_expiry_date
                  FROM GIPI_POLBASIC
                 WHERE line_cd      = pol.line_cd
                   AND subline_cd   = pol.subline_cd
                   AND iss_cd       = pol.iss_cd
                   AND issue_yy     = pol.issue_yy
                   AND pol_seq_no   = pol.pol_seq_no
                   AND renew_no     = pol.renew_no
                   AND endt_seq_no != 0
                 ORDER BY eff_date)
             LOOP
                IF TO_CHAR(endt.endt_expiry_date,'MM-DD-YYYY HH24') >= TO_CHAR(SYSDATE,'MM-DD-YYYY HH24') THEN   
                   FOR endt_main IN (
                     SELECT prem_amt, tsi_amt 
                       FROM GIPI_MAIN_CO_INS
                      WHERE policy_id = pol.policy_id)
                   LOOP
                     v_prem_amt := v_prem_amt + NVL(endt_main.prem_amt,0);    
                     v_tsi_amt  := v_tsi_amt  + NVL(endt_main.tsi_amt,0);
                   END LOOP;
                END IF;
             END LOOP; -- END OF ENDT CURSOR --

             IF v_exist = 'Y' THEN
               INSERT INTO GIXX_MAIN_CO_INS(
                   extract_id,   prem_amt,   tsi_amt)
               VALUES (
                   p_extract_id, v_prem_amt, v_tsi_amt);
             END IF;  
          END LOOP; -- END OF POL CURSOR --
          
          GIPIS100_EXTRACT_SUMMARY.populate_co_ins(p_extract_id, p_co_sw, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
          
        END;
		/*
        **  Created by    : Robert John Virrey
        **  Reference By  : GIPIS100 - View Policy Information
        **  Description   : Populate the GIXX_PRINCIPAL table
        */

        PROCEDURE populate_principal (
           p_extract_id   IN   NUMBER,
           p_policy_id    IN   gipi_polbasic.policy_id%TYPE,
           p_line_cd      IN   gipi_polbasic.line_cd%TYPE,
           p_subline_cd   IN   gipi_polbasic.subline_cd%TYPE,
           p_iss_cd       IN   gipi_polbasic.iss_cd%TYPE,
           p_issue_yy     IN   gipi_polbasic.issue_yy%TYPE,
           p_pol_seq_no   IN   gipi_polbasic.pol_seq_no%TYPE,
           p_renew_no     IN   gipi_polbasic.renew_no%TYPE
        )
        IS
           v_exist                VARCHAR2 (1)                             := 'N';
           v_policy_id            gipi_polbasic.policy_id%TYPE;
           v_principal_cd         gipi_principal.principal_cd%TYPE;
           v_engg_basic_infonum   gipi_principal.engg_basic_infonum%TYPE;
           v_subcon_sw            gipi_principal.subcon_sw%TYPE;
        BEGIN
           FOR prin IN (SELECT principal_cd, engg_basic_infonum, subcon_sw
                          FROM gipi_principal
                         WHERE policy_id = p_policy_id)
           LOOP
              v_principal_cd := NVL (prin.principal_cd, v_principal_cd);
              v_engg_basic_infonum :=
                                  NVL (prin.engg_basic_infonum, v_engg_basic_infonum);
              v_subcon_sw := NVL (prin.subcon_sw, v_subcon_sw);

              FOR prin_exist IN (SELECT 'a'
                                   FROM gixx_principal
                                  WHERE extract_id = p_extract_id
                                    AND principal_cd = v_principal_cd)
              LOOP
                 v_exist := 'Y';
              END LOOP;

              IF v_exist = 'N'
              THEN
                 FOR pol IN (SELECT   policy_id
                                 FROM gipi_polbasic
                                WHERE line_cd = p_line_cd
                                  AND subline_cd = p_subline_cd
                                  AND iss_cd = p_iss_cd
                                  AND issue_yy = p_issue_yy
                                  AND pol_seq_no = p_pol_seq_no
                                  AND renew_no = p_renew_no
                                  AND pol_flag != '5'
                                  AND policy_id != p_policy_id
                             ORDER BY eff_date)
                 LOOP
                    v_policy_id := pol.policy_id;

                    FOR endt_bond IN (SELECT principal_cd, engg_basic_infonum,
                                             subcon_sw
                                        FROM gipi_principal
                                       WHERE policy_id = p_policy_id
                                         AND principal_cd = v_principal_cd)
                    LOOP
                       v_principal_cd := NVL (endt_bond.principal_cd, v_principal_cd);
                       v_engg_basic_infonum :=
                                  NVL (endt_bond.engg_basic_infonum, v_engg_basic_infonum);
                       v_subcon_sw := NVL (endt_bond.subcon_sw, v_subcon_sw);
                    END LOOP;
                 END LOOP;

                 INSERT INTO gixx_principal
                           (principal_cd, engg_basic_infonum,
                            subcon_sw, extract_id
                           )
                    VALUES (v_principal_cd, v_engg_basic_infonum,
                            v_subcon_sw, p_extract_id
                           );

                 v_exist := 'N';
                 v_principal_cd := NULL;
                 v_engg_basic_infonum := NULL;
                 v_subcon_sw := NULL;
              ELSE
                 v_exist := 'N';
              END IF;
           END LOOP;
        END;
		
END GIPIS100_EXTRACT_SUMMARY;
/


