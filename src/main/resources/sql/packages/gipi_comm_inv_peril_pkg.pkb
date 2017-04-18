CREATE OR REPLACE PACKAGE BODY CPI.GIPI_COMM_INV_PERIL_PKG AS
/**
* Rey Jadlocon
* 08.05.2011
* invoice commission
**/
FUNCTION get_invoice_commission(p_policy_id    gipi_comm_inv_peril.policy_id%TYPE,
                                p_prem_seq_no  gipi_comm_inv_peril.prem_seq_no%TYPE,
                                p_line_cd      giis_peril.line_cd%TYPE)
                                
           RETURN invoice_commission_tab PIPELINED
         IS
           v_invoice_commission  invoice_commission_type;           
    BEGIN
         FOR i IN ( SELECT *
                     FROM (SELECT a.peril_cd, a.premium_amt, b.peril_name, a.policy_id,
                                  a.wholding_tax, a.commission_rt, a.commission_amt,
                                  (a.commission_amt - a.wholding_tax) net_com_amt, c.intm_no,
                                  c.intm_name, d.parent_intm_no, c.ref_intm_cd, --marco - changed from c to d.parent_intm_no as per mam grace (SR 17263)
                                  SUM (a.commission_amt) total_commission,
                                  SUM (a.wholding_tax) total_tax_wholding,
                                  c.intm_no|| ' - ' || c.intm_name intm_cd_name,
                                  d.share_percentage,a.prem_seq_no,d.premium_amt share_prem                                  
                             FROM gipi_comm_inv_peril a,
                                  giis_peril b,
                                  giis_intermediary c,
                                  gipi_comm_invoice d,
                                  gipi_invperil g
                            WHERE a.peril_cd = b.peril_cd
                              AND d.prem_seq_no = a.prem_seq_no
                              AND g.iss_cd = d.iss_cd
                              AND g.prem_seq_no = d.prem_seq_no
                              AND d.iss_cd = a.iss_cd
                              AND g.peril_cd = b.peril_cd
                              AND c.intm_no = d.intrmdry_intm_no
                              AND a.policy_id = p_policy_id
                              AND a.prem_seq_no = p_prem_seq_no
                              AND b.line_cd = p_line_cd
							  AND c.intm_no = a.intrmdry_intm_no
                         GROUP BY a.peril_cd,
                                  a.premium_amt,
                                  b.peril_name,
                                  a.policy_id,
                                  a.wholding_tax,
                                  a.commission_rt,
                                  a.commission_amt,
                                  c.intm_no,
                                  c.intm_name,
                                  d.parent_intm_no,
                                  c.ref_intm_cd,
                                  d.share_percentage,
                                  a.prem_seq_no,
                                  d.premium_amt ))
         LOOP
            v_invoice_commission.peril_cd               := i.peril_cd;
            v_invoice_commission.premium_amt            := i.premium_amt;
            v_invoice_commission.peril_name             := i.peril_name;
            v_invoice_commission.policy_id              := i.policy_id;
            v_invoice_commission.wholding_tax           := i.wholding_tax;
            v_invoice_commission.commission_rt          := i.commission_rt;
            v_invoice_commission.commission_amt         := i.commission_amt;
            v_invoice_commission.net_com_amt            := i.net_com_amt;
            v_invoice_commission.intm_no                := i.intm_no;
            v_invoice_commission.intm_name              := i.intm_name;
            v_invoice_commission.parent_intm_no         := i.parent_intm_no;
            v_invoice_commission.ref_intm_cd            := i.ref_intm_cd;
            v_invoice_commission.total_commission       := i.total_commission;
            v_invoice_commission.total_tax_wholding     := i.total_tax_wholding;
            v_invoice_commission.intm_cd_name           := i.intm_cd_name;
            v_invoice_commission.share_percentage       := i.share_percentage;
            v_invoice_commission.prem_seq_no            := i.prem_seq_no;
            v_invoice_commission.share_prem             := i.share_prem;
            PIPE ROW(v_invoice_commission);
        END LOOP
        
        RETURN;
END get_invoice_commission;

    FUNCTION get_invoice_intermediaries(p_policy_id    GIPI_COMM_INV_PERIL.policy_id%TYPE,
                                        p_prem_seq_no  GIPI_COMM_INV_PERIL.prem_seq_no%TYPE,
                                        p_line_cd      GIIS_PERIL.line_cd%TYPE)
      RETURN invoice_intermediary_tab PIPELINED IS
        v_intm          invoice_intermediary_type;
    BEGIN
        FOR i IN(SELECT DISTINCT(intm_no) intm_no, intm_name, ref_intm_cd, parent_intm_no, share_percentage, share_prem,
                        policy_id, prem_seq_no
                   FROM TABLE (GIPI_COMM_INV_PERIL_PKG.get_invoice_commission (p_policy_id, p_prem_seq_no, p_line_cd)))
        LOOP
            v_intm.intm_no := i.intm_no;
            v_intm.intm_name := i.intm_name;
            v_intm.ref_intm_cd := i.ref_intm_cd;
            v_intm.parent_intm_no := i.parent_intm_no;
            v_intm.share_percentage := i.share_percentage;
            v_intm.share_prem := i.share_prem;
            v_intm.policy_id := i.policy_id;
            v_intm.prem_seq_no := i.prem_seq_no;
            
            BEGIN
                SELECT SUM(NVL(commission_amt, 0)),
                       SUM(NVL(wholding_tax, 0))
                  INTO v_intm.total_comm,
                       v_intm.total_wtax
                  FROM GIPI_COMM_INV_PERIL
                 WHERE policy_id = p_policy_id
                   AND intrmdry_intm_no = v_intm.intm_no
				   AND prem_seq_no = i.prem_seq_no; -- marco - 09.06.2012 - to limit query
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;
            END;
            
            v_intm.net_comm := NVL(v_intm.total_comm, 0) - NVL(v_intm.total_wtax, 0);
            
            PIPE ROW(v_intm);
        END LOOP;
    END;
    
    FUNCTION get_invoice_commission_dtls(p_policy_id    gipi_comm_inv_peril.policy_id%TYPE,
                                         p_prem_seq_no  gipi_comm_inv_peril.prem_seq_no%TYPE,
                                         p_line_cd      giis_peril.line_cd%TYPE,
                                         p_intm_no      gipi_comm_inv_peril.intrmdry_intm_no%TYPE)
      RETURN invoice_intermediary_dtls_tab PIPELINED IS
        v_dtls      invoice_intermediary_dtls_type;           
    BEGIN
        FOR i IN(SELECT *
                   FROM (SELECT a.peril_cd, a.premium_amt, b.peril_name, a.policy_id,
                                a.wholding_tax, a.commission_rt, a.commission_amt,
                                c.intm_no, a.prem_seq_no,
                                (a.commission_amt - a.wholding_tax) net_com_amt                                  
                           FROM gipi_comm_inv_peril a,
                                giis_peril b,
                                giis_intermediary c,
                                gipi_comm_invoice d,
                                gipi_invperil g
                          WHERE a.peril_cd = b.peril_cd
                            AND d.prem_seq_no = a.prem_seq_no
                            AND g.iss_cd = d.iss_cd
                            AND g.prem_seq_no = d.prem_seq_no
                            AND d.iss_cd = a.iss_cd
                            AND g.peril_cd = b.peril_cd
                            AND c.intm_no = d.intrmdry_intm_no
                            AND a.policy_id = p_policy_id
                            AND a.prem_seq_no = p_prem_seq_no
                            AND b.line_cd = p_line_cd
							AND c.intm_no = a.intrmdry_intm_no
                            AND a.intrmdry_intm_no = p_intm_no
                          GROUP BY a.peril_cd,
                                   a.premium_amt,
                                   b.peril_name,
                                   a.policy_id,
                                   a.wholding_tax,
                                   a.commission_rt,
                                   a.commission_amt,
                                   c.intm_no,
                                   c.intm_name,
                                   c.parent_intm_no,
                                   c.ref_intm_cd,
                                   d.share_percentage,
                                   a.prem_seq_no,
                                   d.premium_amt
                          ORDER BY a.peril_cd))
        LOOP
            v_dtls.peril_cd               := i.peril_cd;
            v_dtls.premium_amt            := i.premium_amt;
            v_dtls.peril_name             := i.peril_name;
            v_dtls.policy_id              := i.policy_id;
            v_dtls.wholding_tax           := i.wholding_tax;
            v_dtls.commission_rt          := i.commission_rt;
            v_dtls.commission_amt         := i.commission_amt;
            v_dtls.intm_no                := i.intm_no;
            v_dtls.prem_seq_no            := i.prem_seq_no;
            v_dtls.net_com_amt            := i.net_com_amt;
            PIPE ROW(v_dtls);
        END LOOP;
    END get_invoice_commission_dtls;
    
    --added by hdrtagudin 07232015 SR 19824
    FUNCTION get_bond_intermediaries(p_policy_id    GIPI_COMM_INV_PERIL.policy_id%TYPE,
                                        p_prem_seq_no  GIPI_COMM_INV_PERIL.prem_seq_no%TYPE,
                                        p_line_cd      GIIS_PERIL.line_cd%TYPE)
                                         RETURN bond_invoice_intermediary_tab PIPELINED IS
        v_intm          bond_invoice_intermediary_type;
    BEGIN
        FOR i IN(SELECT DISTINCT(intm_no) intm_no, intm_name, ref_intm_cd, parent_intm_no, share_percentage, share_prem,
                        policy_id, prem_seq_no, commission_rt, total_tax_wholding, total_commission
                   FROM TABLE (GIPI_COMM_INV_PERIL_PKG.get_invoice_commission (p_policy_id, p_prem_seq_no, p_line_cd)))
        LOOP
            v_intm.intm_no := i.intm_no;
            v_intm.intm_name := i.intm_name;
            v_intm.ref_intm_cd := i.ref_intm_cd;
            v_intm.parent_intm_no := i.parent_intm_no;
            v_intm.share_percentage := i.share_percentage;
            v_intm.share_prem := i.share_prem;
            v_intm.policy_id := i.policy_id;
            v_intm.prem_seq_no := i.prem_seq_no;
            v_intm.commission_rt := i.commission_rt;
            v_intm.total_comm := i.total_commission;
            v_intm.wholding_tax := i.total_tax_wholding;
            
            v_intm.net_comm := NVL(v_intm.total_comm, 0) - NVL(v_intm.wholding_tax, 0);
            
             BEGIN
                SELECT intm_name
                  INTO v_intm.parent_intm_name
                  FROM giis_intermediary
                 WHERE intm_no = v_intm.parent_intm_no;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;
            END;
            
            
            PIPE ROW(v_intm);
        END LOOP;
    END get_bond_intermediaries;

END GIPI_COMM_INV_PERIL_PKG;
/


