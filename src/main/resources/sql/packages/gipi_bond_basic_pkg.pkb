CREATE OR REPLACE PACKAGE BODY CPI.gipi_bond_basic_pkg
AS
   /**
    **  Created by      : Niknok Orio
    **  Date Created    : 11.14.2011
    **  Reference By    : (GICLS010 - Claims Basic Information)
    **  Description     :  Bond Policy Data
    **/
    FUNCTION get_gipi_bond_basic(
        p_line_cd                    IN     GIPI_POLBASIC.line_cd%TYPE,
        p_subline_cd                 IN     GIPI_POLBASIC.subline_cd%TYPE,
        p_pol_iss_cd                 IN     GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy                   IN     GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no                 IN     GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no                   IN     GIPI_POLBASIC.renew_no%TYPE,
        p_loss_date                  IN     GICL_CLAIMS.dsp_loss_date%TYPE,
        p_expiry_date                IN     GIPI_POLBASIC.expiry_date%TYPE,
        p_pol_eff_date               IN     GICL_CLAIMS.pol_eff_date%TYPE
    ) RETURN gipi_bond_basic_tab PIPELINED IS
      v_list    gipi_bond_basic_type;
    BEGIN
        FOR i IN(SELECT a.policy_id, a.coll_flag, a.clause_type,
                        a.obligee_no, a.prin_id, a.val_period_unit,
                        a.val_period, a.np_no, a.contract_dtl,
                        a.contract_date, a.co_prin_sw, a.waiver_limit,
                        a.indemnity_text, a.bond_dtl, a.endt_eff_date,
                        a.witness_ri, a.witness_bond, a.witness_ind,
                        a.remarks, a.cpi_rec_no, a.cpi_branch_cd,
                        a.arc_ext_data ,
                        b.obligee_name,
                        c.prin_signor, c.designation,
                        d.np_name,
                        f.clause_desc,
                        g.gen_info
                   FROM gipi_bond_basic a,
                        giis_obligee b,
                        giis_prin_signtry c,
                        giis_notary_public d,
                        giis_bond_class_clause f,
                        gipi_polgenin g
                  WHERE a.obligee_no = b.obligee_no(+)
                    AND a.prin_id = c.prin_id(+)
                    AND a.np_no = d.np_no(+)
                    AND a.policy_id = g.policy_id(+)
                    AND a.clause_type = f.clause_type(+)
                    AND a.policy_id IN (SELECT policy_id    --niknok replace ko muna ung = to IN para iwas ORA-01427: single-row subquery returns more than one row  - pa resolve nalang sa future pati sa CS ver. lol
                                         FROM gipi_polbasic
                                        WHERE LINE_CD = p_line_cd
                                          AND SUBLINE_CD = p_subline_cd
                                          AND ISS_CD = p_pol_iss_cd
                                          AND ISSUE_YY= p_issue_yy
                                          AND POL_SEQ_NO = p_pol_seq_no
                                          AND RENEW_NO = p_renew_no
                                          AND pol_flag IN ('1','2','3','X')
                                          AND TRUNC(DECODE(TRUNC(eff_date),TRUNC(incept_date),p_pol_eff_date,eff_date )) <= p_loss_date
                                          AND TRUNC(DECODE(NVL(endt_expiry_date,expiry_date),expiry_date,p_expiry_date,endt_expiry_date)) >= p_loss_date))
        LOOP
            v_list.policy_id        		:= i.policy_id;
            v_list.coll_flag        		:= i.coll_flag;
            v_list.clause_type      		:= i.clause_type;
            v_list.obligee_no       		:= i.obligee_no;
            v_list.prin_id          		:= i.prin_id;
            v_list.val_period_unit  		:= i.val_period_unit;
            v_list.val_period       		:= i.val_period;
            v_list.np_no            		:= i.np_no;
            v_list.contract_dtl     		:= i.contract_dtl;
            v_list.contract_date    		:= i.contract_date;
            v_list.co_prin_sw       		:= i.co_prin_sw;
            v_list.waiver_limit     		:= i.waiver_limit;
            v_list.indemnity_text   		:= i.indemnity_text;
            v_list.bond_dtl         		:= i.bond_dtl;
            v_list.endt_eff_date    		:= i.endt_eff_date;
            v_list.witness_ri       		:= i.witness_ri;
            v_list.witness_bond     		:= i.witness_bond;
            v_list.witness_ind      		:= i.witness_ind;
            v_list.remarks          		:= i.remarks;
            v_list.cpi_rec_no       		:= i.cpi_rec_no;
            v_list.cpi_branch_cd    		:= i.cpi_branch_cd;
            v_list.arc_ext_data     		:= i.arc_ext_data;
            v_list.nbt_obligee_name         := i.obligee_name;
            v_list.nbt_prin_signor          := i.prin_signor;
            v_list.nbt_designation          := i.designation;
            v_list.nbt_np_name              := i.np_name;
            v_list.nbt_clause_desc          := i.clause_desc;
            v_list.nbt_bond_under           := i.gen_info;

            v_list.nbt_bond_amt             := 0;
            FOR amt IN (
              SELECT SUM(c.tsi_amt) tsi
                FROM gipi_polbasic a, gipi_item b, gipi_itmperil c
               WHERE c.line_cd = p_line_cd
                 AND a.policy_id = i.policy_id
                 AND a.policy_id = b.policy_id
                 AND b.policy_id = c.policy_id
                 AND b.item_no = c.item_no
                 AND a.pol_flag IN ('1','2','3','X')
                 AND TRUNC(DECODE(TRUNC(a.eff_date),TRUNC(a.incept_date),p_pol_eff_date,a.eff_date )) <= TRUNC(p_loss_date)
                 AND TRUNC(DECODE(NVL(a.endt_expiry_date,a.expiry_date),a.expiry_date,p_expiry_date,a.endt_expiry_date)) >= TRUNC(p_loss_date))
            LOOP
              v_list.nbt_bond_amt := amt.tsi;
            END LOOP;

        PIPE ROW(v_list);
       END LOOP;
    RETURN;
    END;

END gipi_bond_basic_pkg;
/


