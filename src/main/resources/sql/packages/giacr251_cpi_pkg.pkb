CREATE OR REPLACE PACKAGE BODY CPI.GIACR251_CPI_PKG AS
       
 
    FUNCTION cf_company_nameformula RETURN VARCHAR2 IS
      v_company_name VARCHAR2(200);
     
    BEGIN
      SELECT param_value_v
      INTO   v_company_name
      FROM   giis_parameters
      WHERE  param_name = 'COMPANY_NAME';
      
      RETURN (v_company_name);
      
    END;
    
   FUNCTION populate_giacr251_records (
        p_intm_no         VARCHAR2,
        p_user_id         VARCHAR2
       )
       RETURN giacr251_record_tab PIPELINED
    AS
       v_rec                giacr251_record_type;
       
       --added by jeffdojello 01.17.2014 --------
       v_intm_name          giis_intermediary.intm_name%TYPE;
       v_parent_intm_no     giis_intermediary.intm_no%TYPE;
       
    BEGIN     
       FOR i IN (SELECT gcve.intm_no agent_cd,
                        gint.intm_name,
                        ginv.policy_id,
                        gcve.policy_no,
                        gcve.assd_no assd_no,
                        gass.assd_name,
                        gcve.iss_cd iss_cd,
                        gcve.prem_seq_no prem_seq_no,
                        SUM(NVL(gcve.prem_amt,0)) prem_amt,
                        SUM(NVL(ginv.prem_amt,0)) tot_prem,
                        SUM(NVL(gcve.commission_amt,0)) comm_amt,
                        SUM(NVL(gcve.wholding_tax,0)) wtax,
                        SUM(NVL(gcve.advances,0)) advances,
                       (SELECT SUM(NVL(input_vat,0))
                          FROM giac_comm_voucher_v
                         WHERE iss_cd = gcve.iss_cd
                           AND prem_seq_no = gcve.prem_seq_no
                           AND intm_no = gcve.intm_no) input_vat,
                       (SELECT NVL(actual_comm,0)
                          FROM giac_comm_voucher_v
                         WHERE iss_cd = gcve.iss_cd
                           AND prem_seq_no = gcve.prem_seq_no
                           AND intm_no = gcve.intm_no) actual_comm,
                       (SELECT NVL(comm_payable,0)
                          FROM giac_comm_voucher_v
                         WHERE iss_cd = gcve.iss_cd
                           AND prem_seq_no = gcve.prem_seq_no
                           AND intm_no = gcve.intm_no) comm_payable,
                        gper.peril_sname,
                        NVL(gcip.premium_amt,0) peril_prem_amt,
                        NVL(gcip.commission_rt,0) peril_comm_rt,
                        NVL(gcip.wholding_tax,0) peril_wtax_amt,
                        NVL(gpci.commission_rt,0) parent_comm_rt,
                        ROUND(SUM(NVL(gcve.commission_amt,0))*
                            ((NVL(gcip.commission_amt,0)-
                              SUM(NVL(gpci.commission_amt,0)))/
                             (NVL(gciv.commission_amt,0)-
                              SUM(NVL(gpci.commission_amt,0)))),2) peril_comm
                   FROM giac_comm_voucher_ext gcve,
                        gipi_invoice ginv,
                        giis_assured gass,
                        giis_intermediary gint,
                        gipi_comm_inv_peril gcip,
                        giac_parent_comm_invprl gpci,
                        gipi_polbasic gpol,
                        giis_peril gper,
                        gipi_comm_invoice gciv
                  WHERE 1 = 1
                    AND gcve.assd_no = gass.assd_no (+)
                    AND gcve.intm_no = NVL(p_intm_no,gcve.intm_no)
                    AND gcve.include_tag = 'Y'
                    AND gcve.user_id = p_user_id
                    AND gcve.iss_cd = ginv.iss_cd
                    AND gcve.prem_seq_no = ginv.prem_seq_no
                    AND gcve.intm_no = gint.intm_no
                    AND gcve.iss_cd = gcip.iss_cd
                    AND gcve.prem_seq_no = gcip.prem_seq_no
                    AND gcve.intm_no = gcip.intrmdry_intm_no
                    AND gcip.intrmdry_intm_no = gpci.chld_intm_no (+)
                    AND gcip.iss_cd = gpci.iss_cd (+)
                    AND gcip.prem_seq_no = gpci.prem_seq_no (+)
                    AND gcip.peril_cd = gpci.peril_cd (+)
                    AND ginv.policy_id = gpol.policy_id
                    AND gpol.line_cd = gper.line_cd
                    AND gcip.peril_cd = gper.peril_cd
                    AND gcve.iss_cd = gciv.iss_cd
                    AND gcve.prem_seq_no = gciv.prem_seq_no
                    AND gcve.intm_no = gciv.intrmdry_intm_no
                 GROUP BY gcve.intm_no,
                          gint.intm_name,
                          ginv.policy_id,
                          gcve.policy_no,
                          gcve.assd_no,
                          gass.assd_name,
                          gcve.iss_cd,
                          gcve.prem_seq_no,
                          gper.peril_sname,
                          gcip.premium_amt,
                          gcip.commission_amt,
                          gcip.commission_rt,
                          gcip.wholding_tax,
                          gpci.commission_rt,
                          gpci.commission_amt,
                          gciv.commission_amt)
                                 
       LOOP
            v_rec.company_name    := cf_company_nameformula;
            v_rec.agent_cd        := i.agent_cd;
            v_rec.policy_id       := i.policy_id;
            v_rec.policy_no       := i.policy_no;
            v_rec.assd_no         := i.assd_no;
            v_rec.assd_name       := i.assd_name;
            v_rec.iss_cd          := i.iss_cd;
            v_rec.prem_seq_no     := i.prem_seq_no;
            v_rec.prem_amt        := i.prem_amt;
            v_rec.tot_prem        := i.tot_prem;
            v_rec.comm_amt        := i.comm_amt;
            v_rec.wtax            := i.wtax;
            v_rec.advances        := i.advances;
            v_rec.input_vat       := i.input_vat;
            v_rec.actual_comm     := i.actual_comm;
            v_rec.comm_payable    := i.comm_payable;
            v_rec.peril_sname     := i.peril_sname;
            v_rec.peril_prem_amt  := i.peril_prem_amt;
            v_rec.peril_comm_rt   := i.peril_comm_rt;
            v_rec.peril_wtax_amt  := i.peril_wtax_amt;
            v_rec.parent_comm_rt  := i.parent_comm_rt;
            v_rec.peril_comm      := i.peril_comm;
            
            --------------------------added by jeffdojello 01.17.2014------------------------------------
            v_rec.bill_amt_due   := NVL(i.comm_amt,0)-NVL(i.wtax,0)+NVL(i.input_vat,0)-NVL(i.advances,0); 
            
            BEGIN
                SELECT parent_intm_no
                  INTO v_parent_intm_no
                  FROM giis_intermediary
                 WHERE intm_no = i.agent_cd;
                EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                     v_parent_intm_no := NULL; 
            END;       
            
            IF v_parent_intm_no IS NOT NULL THEN
                BEGIN
                    v_rec.agent_cd        := v_parent_intm_no;
                    
                    SELECT intm_name
                      INTO v_intm_name
                      FROM giis_intermediary
                     WHERE intm_no = v_parent_intm_no;
                   EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                     v_intm_name := i.intm_name;
                     v_rec.agent_cd        := i.agent_cd;
                END;                
                
            ELSE                
                v_intm_name :=  i.intm_name;
                v_rec.agent_cd  := i.agent_cd;
            END IF;
            
            v_rec.intm_name := v_intm_name;
            ------------------------------------------------------------------------------------------------
            
            PIPE ROW (v_rec);
       END LOOP;

       RETURN;
    END;
    
END GIACR251_CPI_PKG;
/

DROP PACKAGE BOCY CPI.GIACR251_CPI_PKG;
