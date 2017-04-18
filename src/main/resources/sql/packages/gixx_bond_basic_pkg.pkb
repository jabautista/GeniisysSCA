CREATE OR REPLACE PACKAGE BODY CPI.GIXX_BOND_BASIC_PKG 
AS
    
    /*
    ** Created by:    Marie Kris Felipe
    ** Date Created:  March 14, 2013
    ** Reference by:  GIPIS101 - Policy Information (Summary)
    ** Description:   Retrieves basic bond information
    */
    FUNCTION get_bond_basic(
        p_extract_id        gixx_polbasic.extract_id%TYPE,
        p_policy_id         gixx_polbasic.policy_id%TYPE
    ) RETURN bond_basic_tab PIPELINED 
    IS 
        v_bond      bond_basic_type;
        v_policy_id     gixx_polbasic.policy_id%TYPE;
    BEGIN 
        v_policy_id := p_policy_id;
        
        FOR rec IN (SELECT a.extract_id,
                           a.obligee_no, 
                           a.np_no, 
                           a.prin_id, 
                           a.co_prin_sw,
                           a.bond_dtl,
                           a.indemnity_text,
                           a.coll_flag, 
                           a.waiver_limit, 
                           a.contract_date, 
                           a.contract_dtl,
                           a.clause_type
                      FROM gixx_bond_basic a
                     WHERE a.extract_id = p_extract_id)
        LOOP
            FOR b IN (SELECT obligee_name
                        FROM giis_obligee
                       WHERE obligee_no = rec.obligee_no)
            LOOP
                v_bond.obligee_name := b.obligee_name;
            END LOOP;
            
            FOR c IN (SELECT prin_signor, designation
                        FROM giis_prin_signtry
                       WHERE prin_id = rec.prin_id)
            LOOP
                v_bond.prin_signor := c.prin_signor; 
                v_bond.designation := c.designation;
            END LOOP;
            
            FOR d IN (SELECT np_name
                        FROM giis_notary_public
                       WHERE np_no = rec.np_no)
            LOOP
                v_bond.np_name := d.np_name;
            END LOOP;
            
            FOR ee IN (SELECT clause_desc
                         FROM giis_bond_class_clause
                        WHERE clause_type = rec.clause_type)
            LOOP
                v_bond.clause_desc := ee.clause_desc;
            END LOOP;
            
            FOR f IN (SELECT gen_info
                        FROM gipi_polgenin
                       WHERE policy_id = p_policy_id)
            LOOP
                v_bond.dsp_gen_info := f.gen_info;
            END LOOP;
            
            FOR gg IN (SELECT plaintiff_dtl, defendant_dtl, civil_case_no
                        FROM gipi_bond_basic
                       WHERE policy_id = p_policy_id)
            LOOP
                v_bond.plaintiff_dtl := gg.plaintiff_dtl;
                v_bond.defendant_dtl := gg.defendant_dtl;
                v_bond.civil_case_no := gg.civil_case_no;
            END LOOP; 
            
            v_bond.extract_id       := rec.extract_id;
            v_bond.policy_id        := v_policy_id;
            v_bond.obligee_no       := rec.obligee_no;
            v_bond.prin_id          := rec.prin_id;
            v_bond.coll_flag        := rec.coll_flag;
            v_bond.clause_type      := rec.clause_type;
--            v_bond.val_period_unit  := rec.val_period_unit;
--            v_bond.val_period       := rec.val_period;
--            v_bond.policy_id        := rec.policy_id;
            v_bond.np_no            := rec.np_no;
            v_bond.contract_dtl     := rec.contract_dtl;
            v_bond.contract_date    := rec.contract_date;
            v_bond.str_con_date     := TO_CHAR(rec.contract_date, 'dd-MON-yyyy');
            v_bond.co_prin_sw       := rec.co_prin_sw;
            v_bond.waiver_limit     := rec.waiver_limit;
            v_bond.indemnity_text   := rec.indemnity_text;
            v_bond.bond_dtl         := rec.bond_dtl;
--            v_bond.plaintiff_dtl    := rec.plaintiff_dtl;
--            v_bond.defendant_dtl    := rec.defendant_dtl;
--            v_bond.civil_case_no    := rec.civil_case_no;
--            v_bond.endt_eff_date    := rec.endt_eff_date;
--            v_bond.remarks          := rec.remarks;
--            v_bond.witness_ri       := rec.witness_ri;
--            v_bond.witness_bond     := rec.witness_bond;
--            v_bond.witness_ind      := rec.witness_ind;
            
            PIPE ROW(v_bond);
        END LOOP;
    END get_bond_basic;

END GIXX_BOND_BASIC_PKG;
/