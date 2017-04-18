DROP PROCEDURE CPI.POPULATE_WCOMM_INVOICES;

CREATE OR REPLACE PROCEDURE CPI.populate_wcomm_invoices(
    p_new_par_id       IN  gipi_winvoice.par_id%TYPE,
    p_old_pol_id       IN  gipi_pack_polbasic.pack_policy_id%TYPE,
    p_proc_summary_sw  IN  VARCHAR2,
    p_dsp_line_cd      IN  giis_line_subline_coverages.line_cd%TYPE,
    p_proc_intm_no     IN  giis_intermediary.intm_no%TYPE,
    p_dsp_iss_cd       IN  giis_intm_special_rate.iss_cd%TYPE,
    p_iss_cd          OUT giis_parameters.param_value_v%TYPE,
    p_msg             OUT  VARCHAR2
) 
IS
  v_policy_id         gipi_polbasic.policy_id%TYPE;
  v_region_cd         gipi_wlocation.region_cd%TYPE;
  v_province_cd       gipi_wlocation.province_cd%TYPE;
  --rg_id               RECORDGROUP;
  rg_count            NUMBER;
  rg_name             VARCHAR2(30) := 'GROUP_POLICY';  
  rg_col              VARCHAR2(50) := rg_name || '.policy_id';
  exist               VARCHAR2(1) := 'N';
  v_item_grp          gipi_winvoice.item_grp%TYPE;
  v_share_percentage  gipi_comm_invoice.share_percentage%TYPE;
  v_premium_amt       gipi_comm_invoice.premium_amt%TYPE;
  v_commission_amt    gipi_comm_invoice.commission_amt%TYPE;
  v_wholding_tax      gipi_comm_invoice.wholding_tax%TYPE;
  v_bond_rate         gipi_comm_invoice.bond_rate%TYPE;
  v_parent_intm_no    gipi_comm_invoice.parent_intm_no%TYPE;
  
  v_line_cd           gipi_polbasic.line_cd%TYPE;
  v_subline_cd        gipi_polbasic.subline_cd%TYPE;
  v_iss_cd            gipi_polbasic.iss_cd%TYPE;
  v_issue_yy          gipi_polbasic.issue_yy%TYPE;
  v_pol_seq_no        gipi_polbasic.pol_seq_no%TYPE;
  v_renew_no          gipi_polbasic.renew_no%TYPE;
BEGIN 
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-21-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : populate_wcomm_invoices program unit 
  */
  --CHECK_POLICY_GROUP(rg_name);  
  --rg_id     := FIND_GROUP(rg_name);
  --rg_count  := GET_GROUP_ROW_COUNT(rg_id);
  --v_policy_id  := GET_GROUP_NUMBER_CELL(rg_col, 1);      
  GET_POLICY_GROUP_RECORD(rg_name, p_old_pol_id, p_proc_summary_sw, v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no, p_msg);
  IF NVL(p_proc_summary_sw,'N') = 'N'  THEN
    FOR b IN(SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
               FROM gipi_polbasic
              WHERE line_cd     =  v_line_cd
                AND subline_cd  =  v_subline_cd
                AND iss_cd      =  v_iss_cd
                AND issue_yy    =  to_char(v_issue_yy)
                AND pol_seq_no  =  to_char(v_pol_seq_no)
                AND renew_no    =  to_char(v_renew_no)
                AND (endt_seq_no = 0 OR 
                    (endt_seq_no > 0 AND 
                    TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                AND pol_flag In ('1','2','3')
                AND NVL(endt_seq_no,0) = 0
              ORDER BY eff_date, endt_seq_no)
     LOOP      
        v_policy_id   := b.policy_id;
     END LOOP;
  ELSIF NVL(p_proc_summary_sw,'N') = 'Y'  THEN
    FOR b IN(SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
               FROM gipi_polbasic
              WHERE line_cd     =  v_line_cd
                AND subline_cd  =  v_subline_cd
                AND iss_cd      =  v_iss_cd
                AND issue_yy    =  to_char(v_issue_yy)
                AND pol_seq_no  =  to_char(v_pol_seq_no)
                AND renew_no    =  to_char(v_renew_no)
                AND (endt_seq_no = 0 OR 
                    (endt_seq_no > 0 AND 
                    TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                AND pol_flag In ('1','2','3')
              ORDER BY eff_date, endt_seq_no)
     LOOP      
        v_policy_id   := b.policy_id;
     END LOOP;
  END IF;
  -- lian 103001 added prem_seq_no
  FOR A IN (SELECT item_grp, prem_seq_no
              FROM gipi_winvoice
             WHERE par_id = p_new_par_id) 
  LOOP
    v_item_grp := a.item_grp;
    FOR rec IN ( SELECT share_percentage, premium_amt,
                        commission_amt, wholding_tax,bond_rate,parent_intm_no
                   FROM gipi_comm_invoice
                  WHERE policy_id = v_policy_id
                    -- lian 103001 added the following condition to avoid the error dup_val_on_index
                     AND prem_seq_no = a.prem_seq_no) 
    LOOP
       v_share_percentage := rec.share_percentage;
       v_premium_amt      := rec.premium_amt;
       v_commission_amt   := rec.commission_amt;
       v_wholding_tax     := rec.wholding_tax;
       v_bond_rate        := rec.bond_rate;
       v_parent_intm_no   := rec.parent_intm_no;
       INSERT INTO gipi_wcomm_invoices
                    (par_id, item_grp, intrmdry_intm_no, share_percentage,
                    premium_amt, commission_amt, wholding_tax, bond_rate, parent_intm_no)
        VALUES (p_new_par_id, v_item_grp, p_proc_intm_no, 
                    nvl(v_share_percentage,0), nvl(v_premium_amt,0), nvl(v_commission_amt,0),
                    nvl(v_wholding_tax,0), nvl(v_bond_rate,0), nvl(v_parent_intm_no,0));
       populate_wcomm_invperl(p_dsp_line_cd, p_new_par_id, p_proc_intm_no, p_dsp_iss_cd, p_msg, p_iss_cd);
    END LOOP;               
    
  END LOOP;
END;
/


