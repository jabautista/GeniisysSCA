CREATE OR REPLACE PACKAGE BODY CPI.GIACR250_PKG AS


    FUNCTION cf_company_nameformula RETURN VARCHAR2 IS
      v_company_name VARCHAR2(200);

    BEGIN
      SELECT param_value_v
      INTO   v_company_name
      FROM   giis_parameters
      WHERE  param_name = 'COMPANY_NAME';

      RETURN (v_company_name);

    END;

   FUNCTION populate_giacr250_records (
        p_tran_id         VARCHAR2,
        p_intm_no         VARCHAR2
       )
       RETURN giacr250_record_tab PIPELINED
    AS
       v_rec                giacr250_record_type;

    BEGIN
       FOR i IN (SELECT DISTINCT
                        gint.intm_name intm_name,
                        gcse.intm_no agent_cd,
                        gcse.gacc_tran_id,
                        get_policy_no (gpol.policy_id) policy_no,
                        gcse.comm_amt comm_amt,
                        gcse.wtax_amt wtax_amt,
                        gcse.input_vat_amt vat_amt,
                        (gcse.comm_amt + gcse.input_vat_amt - gcse.wtax_amt) net,
                        gcip.prem_seq_no,
                        gcp.comm_amt comm_paid,
                        gdpc.premium_amt,
                        goop.user_id,
                        gcse.iss_cd,
                        gass.assd_name assd_name,
                        gpol.line_cd,
                        gpol.policy_id,
                        gper.peril_sname,
                        gcip.premium_amt peril_prem_amt,
                        gcip.commission_amt peril_comm_amt,
                        gcip.commission_rt peril_comm_rt,
                        gdpc.premium_amt *
                        (gcip.premium_amt /
                        (SELECT prem_amt
                             FROM gipi_invoice
                            WHERE iss_cd = gcse.iss_cd
                              AND prem_seq_no = gcp.prem_seq_no)) partial_prem,
                        NVL(gpci.commission_rt,0) comm_rt_b,
                        NVL(gpci.commission_amt,0) ovr_comm,
                        gcip.commission_rt - NVL(gpci.commission_rt,0) child_rt,
                        (((SELECT sum(premium_amt)
                             FROM giac_order_of_payts a,
                                  giac_direct_prem_collns b
                            WHERE b.b140_iss_cd = gcse.iss_cd
                              AND b.b140_prem_seq_no = gcp.prem_seq_no
                              AND a.gacc_tran_id = gcp.gacc_tran_id
                              AND a.or_flag = 'P') *
                        (gcip.premium_amt /
                        (SELECT prem_amt
                           FROM gipi_invoice
                          WHERE iss_cd = gcse.iss_cd
                            AND prem_seq_no = gcp.prem_seq_no)))) *
                        ((gcip.commission_rt - NVL(gpci.commission_rt,0))/100) partial_comm,
                        (SELECT SUM(NVL(x.wtax_amt,0))
                           FROM giac_comm_payts x,
                                giac_acctrans   b
                          WHERE NOT EXISTS(SELECT 'X'
                                             FROM giac_reversals c,
                                                  giac_acctrans  d
                                            WHERE c.reversing_tran_id = d.tran_id
                                              AND d.tran_flag != 'D'
                                              AND c.gacc_tran_id = x.gacc_tran_id)
                            AND x.gacc_tran_id = b.tran_id
                            AND b.tran_flag   != 'D'
                            AND x.prem_seq_no  = gcip.prem_seq_no
                            AND x.iss_cd       = gcse.iss_cd
                            AND x.intm_no      = gcse.intm_no
                            AND x.gacc_tran_id >= 0) wtax,
                        (SELECT SUM(NVL(x.input_vat_amt,0))
                           FROM giac_comm_payts x,
                                giac_acctrans   b
                          WHERE NOT EXISTS(SELECT 'X'
                                             FROM giac_reversals c,
                                                  giac_acctrans  d
                                            WHERE c.reversing_tran_id = d.tran_id
                                              AND d.tran_flag != 'D'
                                              AND c.gacc_tran_id = x.gacc_tran_id)
                            AND x.gacc_tran_id = b.tran_id
                            AND b.tran_flag   != 'D'
                            AND x.prem_seq_no  = gcip.prem_seq_no
                            AND x.iss_cd       = gcse.iss_cd
                            AND x.intm_no      = gcse.intm_no
                            AND x.gacc_tran_id >= 0) input_vat
                   FROM giac_comm_slip_ext gcse,
                        gipi_comm_inv_peril gcip,
                        giis_intermediary gint,
                        gipi_polbasic gpol,
                       (SELECT nvl(sum(premium_amt),0)
                               premium_amt,
                               b140_iss_cd,
                               b140_prem_seq_no,
                               gacc_tran_id
                          FROM giac_direct_prem_collns
                         WHERE gacc_tran_id = p_tran_id
                        GROUP BY gacc_tran_id,
                                b140_iss_cd,
                                b140_prem_seq_no) gdpc,
                        giis_assured gass,
                        giis_peril gper,
                        giac_comm_payts gcp,
                        giac_acctrans gacc,
                        gipi_parlist gpar,
                        giac_order_of_payts goop,
                        giac_parent_comm_invprl gpci
                  WHERE gcse.iss_cd = gcip.iss_cd
                    AND goop.gacc_tran_id = gcp.gacc_tran_id
                    AND gcse.prem_seq_no = gcip.prem_seq_no
                    AND gcse.intm_no = gint.intm_no
                    AND gcse.prem_seq_no = gcp.prem_seq_no
                    AND gcse.iss_cd = gcp.iss_cd
                    AND gcp.gacc_tran_id = gacc.tran_id
                    AND gcse.gacc_tran_id = gcp.gacc_tran_id
                    AND gdpc.gacc_tran_id = gcse.gacc_tran_id
                    AND gdpc.b140_iss_cd = gcse.iss_cd
                    AND gdpc.b140_prem_seq_no = gcp.prem_seq_no
                    AND gacc.tran_id NOT IN (SELECT gacc_tran_id
                                               FROM giac_reversals a,
                                                    giac_acctrans  b
                                              WHERE gacc_tran_id = tran_id
                                                AND tran_flag !='D')
                    AND gcse.intm_no = gcp.intm_no
                    AND gcse.intm_no = gint.intm_no
                    AND gpol.par_id  = gpar.par_id
                    AND gcip.policy_id = gpol.policy_id
                    AND gass.assd_no = gpar.assd_no
                    AND gcip.peril_cd = gper.peril_cd
                    AND gpol.line_cd = gper.line_cd
                    AND gcse.comm_slip_tag = 'Y'
                    AND NVL(gcse.comm_slip_flag, 'N') != 'C'
                    AND gcse.intm_no = p_intm_no
                    AND gcse.or_no IS NOT NULL
                    AND gcse.gacc_tran_id = p_tran_id
                    AND gcip.intrmdry_intm_no = gpci.chld_intm_no (+)
                    AND gcip.iss_cd = gpci.iss_cd (+)
                    AND gcip.prem_seq_no = gpci.prem_seq_no (+)
                    AND gcip.peril_cd = gpci.peril_cd (+))


       LOOP
            v_rec.company_name    := cf_company_nameformula;
            v_rec.intm_name       := i.intm_name;
            v_rec.agent_cd        := i.agent_cd;
            v_rec.gacc_tran_id    := i.gacc_tran_id;
            v_rec.policy_no       := i.policy_no;
            v_rec.comm_amt        := i.comm_amt;
            v_rec.wtax_amt        := i.wtax_amt;
            v_rec.vat_amt         := i.vat_amt;
            v_rec.net             := i.net;
            v_rec.prem_seq_no     := i.prem_seq_no;
            v_rec.comm_paid       := i.comm_paid;
            v_rec.premium_amt     := i.premium_amt;
            v_rec.user_id         := i.user_id;
            v_rec.iss_cd          := i.iss_cd;
            v_rec.assd_name       := i.assd_name;
            v_rec.line_cd         := i.line_cd;
            v_rec.policy_id       := i.policy_id;
            v_rec.peril_sname     := i.peril_sname;
            v_rec.peril_prem_amt  := i.peril_prem_amt;
            v_rec.peril_comm_amt  := i.peril_comm_amt;
            v_rec.peril_comm_rt   := i.peril_comm_rt;
            v_rec.partial_prem    := i.partial_prem;
            v_rec.comm_rt_b       := i.comm_rt_b;
            v_rec.ovr_comm        := i.ovr_comm;
            v_rec.child_rt        := i.child_rt;
            v_rec.partial_comm    := i.partial_comm;
            v_rec.wtax            := i.wtax;
            v_rec.input_vat       := i.input_vat;

            PIPE ROW (v_rec);
       END LOOP;

       RETURN;
    END;

END GIACR250_PKG;
/


