CREATE OR REPLACE PACKAGE BODY CPI.populate_ri_agreement_pcic_pkg AS
  FUNCTION populate_ri_agreement_pcic(
      p_fnl_binder_id         giri_binder.fnl_binder_id%TYPE
    )
      RETURN ri_agreement_pcic_tab PIPELINED AS
        v_ri_agreement_pcic  ri_agreement_pcic_type;
        v_designation        VARCHAR2(32767);
        v_signatory          VARCHAR2(32767);
        v_ri_prem_amt        giri_binder.ri_prem_amt%TYPE;
        v_ri_prem_vat        giri_binder.ri_prem_vat%TYPE;
        v_ri_comm_amt        giri_binder.ri_comm_amt%type;
        v_ri_comm_vat        giri_binder.ri_comm_vat%type;
        v_binder_date        giri_binder.binder_date%type;
        v_reinsurer_address  VARCHAR2(32767);
        --v_mail_address1      VARCHAR2(32767);
        --v_mail_address2      VARCHAR2(32767);
        --v_mail_address3      VARCHAR2(32767);
        v_ri_name            giis_reinsurer.ri_name%type;
        v_bond_type          giis_subline.subline_name%type;
        v_currency           giis_currency.short_name%type;
        v_ri_tsi_amt         gipi_item.tsi_amt%type;
        v_assd_name          giis_assured.assd_name%type;
        v_obligee_name       giis_obligee.obligee_name%type;
        v_duration           VARCHAR2(32767);
        v_tsi_amt            gipi_item.tsi_amt%type;
        v_incept_date        gipi_polbasic.incept_date%type;
        v_total              VARCHAR2(32767);
        v_currency_desc      VARCHAR2(32767);
        v_policy             VARCHAR2(32767);
        v_policy_no          VARCHAR2(32767);
        v_net                NUMBER;
        v_bond               VARCHAR2(32767);
        BEGIN
          FOR z IN(SELECT a.line_cd, b.signatory_id, b.signatory, b.designation
                     FROM giis_signatory a, giis_signatory_names b
                    WHERE a.line_cd = 'SU'
                      AND b.signatory_id = a.signatory_id)
          LOOP
            v_ri_agreement_pcic.designation := z.designation;
            v_ri_agreement_pcic.signatory   := z.signatory;
            --PIPE ROW(v_ri_agreement_pcic);
          END LOOP;

          FOR i IN(SELECT a.policy_id, c.assd_no, c.assd_name, b.ri_prem_amt,
                          b.ri_prem_vat, b.ri_comm_amt, b.ri_comm_vat, b.binder_date,
                          d.ri_name, d.mail_address1, d.mail_address2, d.mail_address3,
                          e.subline_name, f.tsi_amt, b.ri_tsi_amt, g.short_name,
			              h.obligee_name, a.incept_date, b.expiry_date, g.currency_desc
                     FROM gipi_polbasic a, giri_binder b, giis_assured c, giis_reinsurer d, giis_subline e,
			              gipi_item f, giis_currency g, giis_obligee h, gipi_bond_basic i
                    WHERE b.fnl_binder_id = p_fnl_binder_id
                      AND b.ri_cd = d.ri_cd
                      AND a.policy_id = b.policy_id
                      AND f.policy_id = a.policy_id
                      AND i.policy_id = a.policy_id
					  AND c.assd_no = a.assd_no
                      AND a.subline_cd = e.subline_cd
				      AND i.obligee_no = h.obligee_no
					  AND f.currency_cd = g.main_currency_cd)
          LOOP
            v_ri_agreement_pcic.ri_prem_amt       :=   i.ri_prem_amt;
	        v_ri_agreement_pcic.ri_prem_vat       :=   i.ri_prem_vat;
	        v_ri_agreement_pcic.ri_comm_amt       :=   i.ri_comm_amt;
	        v_ri_agreement_pcic.ri_comm_vat       :=   i.ri_comm_vat;
	        v_ri_agreement_pcic.binder_date       :=   i.binder_date;
	        v_ri_agreement_pcic.reinsurer_address :=   i.mail_address1||' '||i.mail_address2||' '||i.mail_address3;
            --v_ri_agreement_pcic.mail_address1     :=   i.mail_address1;
            --v_ri_agreement_pcic.mail_address2     :=   i.mail_address2;
            --v_ri_agreement_pcic.mail_address3     :=   i.mail_address3;
            v_ri_agreement_pcic.ri_name           :=   i.ri_name;
            v_ri_agreement_pcic.bond_type         :=   i.subline_name;
            v_ri_agreement_pcic.currency          :=   i.short_name;
            v_ri_agreement_pcic.tsi_amt           :=   i.tsi_amt;
            v_ri_agreement_pcic.assd_name         :=   i.assd_name;
            v_ri_agreement_pcic.obligee_name      :=   i.obligee_name;
            v_ri_agreement_pcic.duration          :=   TO_CHAR(i.incept_date,'Month DD, RRRR') || ' to ' || TO_CHAR(i.expiry_date,'Month DD, RRRR');
            v_ri_agreement_pcic.ri_tsi_amt        :=   i.ri_tsi_amt;
            v_ri_agreement_pcic.incept_date       :=   i.incept_date;
            v_ri_agreement_pcic.currency_desc     :=   i.currency_desc;
            v_ri_agreement_pcic.policy            :=   i.policy_id;
            v_ri_agreement_pcic.vdate             :=   LTRIM(TO_CHAR(i.binder_date,'DDth'),'0');
            v_ri_agreement_pcic.vmonth_year       :=   TO_CHAR(i.binder_date,'MonthYYYY');
            v_ri_agreement_pcic.vtsi_amt          :=   dh_util.spell(round(v_ri_agreement_pcic.tsi_amt))||' ('||v_ri_agreement_pcic.currency||LTRIM(TO_CHAR(v_ri_agreement_pcic.tsi_amt,'999,999,999,999,999.00'))||')';
	      END LOOP;

          v_ri_agreement_pcic.total := (v_ri_agreement_pcic.tsi_amt - round(v_ri_agreement_pcic.tsi_amt)) * 100;
          v_ri_agreement_pcic.policy_no := get_policy_no(v_ri_agreement_pcic.policy);
          v_ri_agreement_pcic.net := (v_ri_agreement_pcic.ri_prem_amt + v_ri_agreement_pcic.ri_prem_vat) - (v_ri_agreement_pcic.ri_comm_amt + v_ri_agreement_pcic.ri_comm_vat);
          v_ri_agreement_pcic.bond := v_ri_agreement_pcic.bond_type;

          PIPE ROW(v_ri_agreement_pcic);

        END;

END populate_ri_agreement_pcic_pkg;
/


