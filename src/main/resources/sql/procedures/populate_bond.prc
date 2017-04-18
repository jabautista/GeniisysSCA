DROP PROCEDURE CPI.POPULATE_BOND;

CREATE OR REPLACE PROCEDURE CPI.populate_bond(
    p_old_pol_id       IN  gipi_pack_polbasic.pack_policy_id%TYPE,
    p_proc_summary_sw  IN  VARCHAR2,
    p_new_par_id       IN  gipi_wopen_policy.par_id%TYPE,
    p_msg             OUT  VARCHAR2
)
IS
  exist                   VARCHAR2(1) := 'N';
  exist2                  VARCHAR2(1) := 'N';
  v_policy_id             gipi_bond_basic.policy_id%TYPE;
  v_obligee_no            gipi_bond_basic.obligee_no%TYPE;
  v_prin_id               gipi_bond_basic.prin_id%TYPE;
  v_coll_flag             gipi_bond_basic.coll_flag%TYPE;
  v_clause_type           gipi_bond_basic.clause_type%TYPE;
  v_val_period_unit       gipi_bond_basic.val_period_unit%TYPE;
  v_val_period            gipi_bond_basic.val_period%TYPE;
  v_np_no                 gipi_bond_basic.np_no%TYPE;
  v_contract_dtl          gipi_bond_basic.contract_dtl%TYPE;
  v_contract_date         gipi_bond_basic.contract_date%TYPE;
  v_co_prin_sw            gipi_bond_basic.co_prin_sw%TYPE;
  v_waiver_limit          gipi_bond_basic.waiver_limit%TYPE;
  v_indemnity_text        gipi_bond_basic.indemnity_text%TYPE;
  v_bond_dtl              gipi_bond_basic.bond_dtl%TYPE;
  v_endt_eff_date         gipi_bond_basic.endt_eff_date%TYPE;
  v_remarks               gipi_bond_basic.remarks%TYPE;
  --rg_id                   RECORDGROUP;
  rg_count                NUMBER;
  rg_name                 VARCHAR2(30) := 'GROUP_POLICY';  
  rg_col                  VARCHAR2(50) := rg_name || '.policy_id';
  item_exist              VARCHAR2(1) := 'N';
  exist1                  VARCHAR2(1) := 'N';
  
  x_line_cd             gipi_polbasic.line_cd%TYPE;
  x_subline_cd          gipi_polbasic.subline_cd%TYPE;
  x_iss_cd              gipi_polbasic.iss_cd%TYPE;
  x_issue_yy            gipi_polbasic.issue_yy%TYPE;
  x_pol_seq_no          gipi_polbasic.pol_seq_no%TYPE;
  x_renew_no            gipi_polbasic.renew_no%TYPE;
BEGIN    
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-21-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : POPULATE_CASUALTY program unit 
  */ 
  GET_POLICY_GROUP_RECORD(rg_name, p_old_pol_id, p_proc_summary_sw, x_line_cd, x_subline_cd, x_iss_cd, x_issue_yy, x_pol_seq_no, x_renew_no, p_msg); 
   IF NVL(p_proc_summary_sw,'N') = 'N'  THEN
    FOR b IN(SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
               FROM gipi_polbasic
              WHERE line_cd     =  x_line_cd
                AND subline_cd  =  x_subline_cd
                AND iss_cd      =  x_iss_cd
                AND issue_yy    =  to_char(x_issue_yy)
                AND pol_seq_no  =  to_char(x_pol_seq_no)
                AND renew_no    =  to_char(x_renew_no)
                AND (endt_seq_no = 0 OR 
                    (endt_seq_no > 0 AND 
                    TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                AND pol_flag In ('1','2','3')
                AND NVL(endt_seq_no,0) = 0
              ORDER BY eff_date, endt_seq_no)
     LOOP      
       v_policy_id   := b.policy_id; 
       FOR bond IN (
          SELECT obligee_no,      prin_id,       coll_flag,
                 clause_type,    val_period_unit, val_period,    np_no,
                 contract_dtl,   contract_date,   co_prin_sw,    waiver_limit,
                 indemnity_text, bond_dtl,        endt_eff_date, remarks
            FROM gipi_bond_basic
           WHERE policy_id = V_policy_id)
       LOOP
            exist := 'Y';
         v_obligee_no         := NVL(bond.obligee_no,v_obligee_no);
         v_prin_id            := NVL(bond.prin_id,v_prin_id);
         v_coll_flag          := NVL(bond.coll_flag,v_coll_flag);
         v_clause_type        := NVL(bond.clause_type,v_clause_type);
         v_val_period_unit    := NVL(bond.val_period_unit,v_val_period_unit);
         v_val_period         := NVL(bond.val_period,v_val_period);
         --v_np_no              := NVL(bond.np_no,v_contract_dtl); /*Commented by aivhie 112101*/
         v_np_no              := NVL(bond.np_no,v_np_no);/*Modified by aivhie 112101 as the above code causes an error*/
         v_contract_dtl       := NVL(bond.contract_dtl,v_contract_dtl);
         v_contract_date      := NVL(bond.contract_date,v_contract_date);
         v_co_prin_sw         := NVL(bond.co_prin_sw,v_co_prin_sw);
         v_waiver_limit       := NVL(bond.waiver_limit,v_waiver_limit);
         v_indemnity_text     := NVL(bond.indemnity_text,v_indemnity_text);
         v_bond_dtl           := NVL(bond.bond_dtl,v_bond_dtl);
         v_endt_eff_date      := NVL(bond.endt_eff_date,v_endt_eff_date);
         v_remarks            := NVL(bond.remarks,v_remarks);
         
       END LOOP;   
     END LOOP;
   ELSIF NVL(p_proc_summary_sw,'N') = 'Y'  THEN
    FOR b IN(SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
               FROM gipi_polbasic
              WHERE line_cd     =  x_line_cd
                AND subline_cd  =  x_subline_cd
                AND iss_cd      =  x_iss_cd
                AND issue_yy    =  to_char(x_issue_yy)
                AND pol_seq_no  =  to_char(x_pol_seq_no)
                AND renew_no    =  to_char(x_renew_no)
                AND (endt_seq_no = 0 OR 
                    (endt_seq_no > 0 AND 
                    TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                AND pol_flag In ('1','2','3')
              ORDER BY eff_date, endt_seq_no)
     LOOP      
       v_policy_id   := b.policy_id; 
       FOR bond IN (
          SELECT obligee_no,      prin_id,       coll_flag,
                 clause_type,    val_period_unit, val_period,    np_no,
                 contract_dtl,   contract_date,   co_prin_sw,    waiver_limit,
                 indemnity_text, bond_dtl,        endt_eff_date, remarks
            FROM gipi_bond_basic
           WHERE policy_id = V_policy_id)
       LOOP
            exist := 'Y';
         v_obligee_no         := NVL(bond.obligee_no,v_obligee_no);
         v_prin_id            := NVL(bond.prin_id,v_prin_id);
         v_coll_flag          := NVL(bond.coll_flag,v_coll_flag);
         v_clause_type        := NVL(bond.clause_type,v_clause_type);
         v_val_period_unit    := NVL(bond.val_period_unit,v_val_period_unit);
         v_val_period         := NVL(bond.val_period,v_val_period);
         --v_np_no              := NVL(bond.np_no,v_contract_dtl); /*Commented by aivhie 112101*/
         v_np_no              := NVL(bond.np_no,v_np_no);/*Modified by aivhie 112101 as the above code causes an error*/
         v_contract_dtl       := NVL(bond.contract_dtl,v_contract_dtl);
         v_contract_date      := NVL(bond.contract_date,v_contract_date);
         v_co_prin_sw         := NVL(bond.co_prin_sw,v_co_prin_sw);
         v_waiver_limit       := NVL(bond.waiver_limit,v_waiver_limit);
         v_indemnity_text     := NVL(bond.indemnity_text,v_indemnity_text);
         v_bond_dtl           := NVL(bond.bond_dtl,v_bond_dtl);
         v_endt_eff_date      := NVL(bond.endt_eff_date,v_endt_eff_date);
         v_remarks            := NVL(bond.remarks,v_remarks);
         
       END LOOP;
     END LOOP;
   END IF;
   
  IF exist = 'Y' THEN
     --CLEAR_MESSAGE;
     --MESSAGE('Copying bond basic info ...',NO_ACKNOWLEDGE);
     --SYNCHRONIZE; 
     
     INSERT INTO gipi_wbond_basic(
                 par_id,           obligee_no,    prin_id,    
                 coll_flag,        clause_type,   val_period_unit, 
                 val_period,       np_no,         contract_dtl,       
                 contract_date,    co_prin_sw,    waiver_limit,       
                 indemnity_text,   bond_dtl,      endt_eff_date,      
                 remarks) 
         VALUES( p_new_par_id,     v_obligee_no,  v_prin_id,    
                 v_coll_flag,      v_clause_type, v_val_period_unit, 
                 v_val_period,     v_np_no,       v_contract_dtl,       
                 v_contract_date,  v_co_prin_sw,  v_waiver_limit,       
                 v_indemnity_text, v_bond_dtl,    v_endt_eff_date,      
                 v_remarks);
     --CLEAR_MESSAGE;
     --MESSAGE('Copying bond info ...',NO_ACKNOWLEDGE);
     --SYNCHRONIZE;
  END IF;
END;
/


