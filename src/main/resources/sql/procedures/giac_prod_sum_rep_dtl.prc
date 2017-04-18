DROP PROCEDURE CPI.GIAC_PROD_SUM_REP_DTL;

CREATE OR REPLACE PROCEDURE CPI.giac_prod_sum_rep_dtl
 (p_policy_id               in     giac_production_summary.policy_id%type,
  p_par_Id                  in out gipi_parlist.par_id%type,
  p_line_cd                 in out giac_production_summary.line_cd%type,
  p_subline_cd              in out giac_production_summary.subline_cd%type,
  p_iss_cd                  in out giac_production_summary.iss_Cd%type,
  p_issue_yy                in out giac_production_summary.issue_yy%type,
  p_pol_Seq_no              in out giac_production_summary.pol_Seq_no%type,
  p_endt_iss_cd             in out giac_production_summary.endt_iss_Cd%type,
  p_endt_yy                 in out giac_production_summary.endt_yy%type,
  p_endt_seq_no             in out giac_production_summary.endt_seq_no%type,
  p_renew_no                in out giac_production_summary.renew_no%type,
  p_acct_ent_date           in out giac_production_summary.acct_ent_date%type,
  p_spld_acct_ent_date      in out giac_production_summary.spld_acct_ent_Date%type,
  p_incept_date             in out giac_production_summary.incept_date%type,
  p_expiry_date             in out giac_production_summary.expiry_date%type,
  p_intm_no                 in out giac_production_summary.intm_no%type,
  p_intm_name               in out giac_production_summary.intm_name%type,
  p_intm_type               in out giac_production_summary.intm_type%type,
  p_parent_intm_no          in out giac_production_summary.parent_intm_no%type,
  p_parent_intm_name        in out giac_production_summary.parent_intm_name%type,
  p_parent_intm_type        in out giac_production_summary.parent_intm_type%type,
  p_bill_no                 in out giac_production_summary.prem_Seq_no%type,
  p_assd_no                 in out giac_production_summary.assd_no%type,
  p_assd_name               in out giac_production_summary.assd_name%type,
  p_tsi_amt                 in out giac_production_summary.tsi_amt%type,
  p_prem_amt                in out giac_production_summary.prem_amt%type,
  p_ref_pol_no              in out giac_production_summary.ref_pol_no%type  )is
--  p_tax_amt                 in out dbms_sql.number_table) is
  v_intm_no                 giac_production_summary.intm_no%type;
  v_intm_name               giac_production_summary.intm_name%type;
  v_intm_type               giac_production_summary.intm_type%type;
  v_parent_intm_no          giac_production_summary.parent_intm_no%type;
  v_parent_intm_name        giac_production_summary.parent_intm_name%type;
  v_parent_intm_type        giac_production_summary.parent_intm_type%type;
  v_bill_no                 giac_production_summary.prem_Seq_no%type;
  v_assd_no                 giac_production_summary.assd_no%type;
  v_assd_name               giac_production_summary.assd_name%type;
  v_dummy                   number;
  v_iss_Cd_ri               giac_parameters.param_value_v%type;
begin
  /* JANET ANG JULY 25,2000 TO GET POLICY DETAILS */
  DBMS_OUTPUT.PUT_LINE( 'GIAC_PROD_SUM_REP_DTL ');
  for rec in (select param_value_v from giac_parameters where param_name like 'RI_ISS_CD') loop
    v_iss_cd_ri   := rec.param_value_v;
  end loop;
  for j in (select policy_id, par_id, line_cd, subline_cd, iss_Cd, issue_yy, pol_Seq_no, endt_iss_Cd, ref_pol_no,
    endt_yy, endt_seq_no, renew_no, acct_ent_date, spld_acct_ent_date, incept_date, expiry_date, assd_no, tsi_amt, prem_amt
	from gipi_polbasic  a
	where a.policy_id = p_policy_Id ) loop
    -- to get the intm_no
	v_intm_no := null;
	for intm in (select MIN(intrmdry_intm_no) INTM_NO, parent_intm_no
	  from gipi_comm_invoice
	  where policy_Id = j.policy_Id
      and share_percentage = (select max(share_percentage)
        from gipi_comm_invoice where policy_id = j.policy_id)
      group by parent_intm_no) loop
      v_intm_no := intm.intm_no;
      v_parent_intm_no := intm.parent_intm_no;
      exit;
	end loop intm;
  for rec in (select intm_name, intm_type from giis_intermediary
	  where intm_no = v_intm_no ) loop
      v_intm_name := rec.intm_name;
      v_intm_type := rec.intm_type;
  end loop;
    -- to get the parent_intm_no
	if j.iss_cd != nvl(v_iss_cd_ri,'RI') then
       if v_parent_intm_no is null then
         v_parent_intm_no := GET_PARENT_INTM_NO(j.policy_Id);
       end if;
       for rec in (select intm_name, intm_type from giis_intermediary
	     where intm_no = v_parent_intm_no ) loop
         v_parent_intm_name := rec.intm_name;
	     v_parent_intm_type := rec.intm_type;
       end loop;
    else
	   v_parent_intm_no := null;
    end if;
    -- to get bill no
	v_bill_no := null;
	for prem in (select iss_cd, prem_seq_no, currency_rt from gipi_invoice
	  where policy_id = j.policy_Id ) loop
	  v_bill_no := v_bill_no ||'/'|| prem.prem_Seq_no;
	end loop;
    v_dummy := length(v_bill_no);
	v_bill_no := substr(v_bill_no,2,v_dummy - 1); -- to take the first slash away
    -- to get assd_no and assd_name
	v_assd_no := j.assd_no;
	if j.assd_no is null then
	  for par in (select assd_no from gipi_parlist where par_Id = j.par_Id) loop
	    v_assd_no := par.assd_no;
      end loop;
    end if;
    for assd in (select assd_name from giis_assured where assd_no = v_assd_no) loop
	  v_assd_name := assd.assd_name;
    end loop;
    p_par_Id                  := j.par_id;
    p_line_cd                 := j.line_cd;
    p_subline_cd              := j.subline_cd;
    p_iss_cd                  := j.iss_Cd;
    p_issue_yy                := j.issue_yy;
    p_pol_Seq_no              := j.pol_seq_no;
    p_endt_iss_cd             := j.endt_iss_cd;
    p_endt_yy                 := j.endt_yy;
    p_endt_seq_no             := j.endt_seq_no;
    p_renew_no                := j.renew_no;
    p_acct_ent_date           := j.acct_ent_Date;
    p_spld_acct_ent_date      := j.spld_acct_ent_date;
    p_incept_date             := j.incept_date;
    p_expiry_date             := j.expiry_date;
    p_intm_no                 := v_intm_no;
    p_intm_name               := v_intm_name;
    p_intm_type               := v_intm_type;
    p_parent_intm_no          := v_parent_intm_no;
    p_parent_intm_name        := v_parent_intm_name;
    p_parent_intm_type        := v_parent_intm_type;
    p_bill_no                 := v_bill_no;
    p_assd_no                 := v_assd_no;
    p_assd_name               := v_assd_name;
    p_prem_amt                := j.prem_amt;
    p_tsi_amt                 := j.tsi_amt;
    p_ref_pol_no              := j.ref_pol_no;
  end loop;
end;
/


