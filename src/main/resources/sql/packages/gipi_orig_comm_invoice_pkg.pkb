CREATE OR REPLACE PACKAGE BODY CPI.GIPI_ORIG_COMM_INVOICE_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/
	PROCEDURE del_gipi_orig_comm_invoice (p_par_id 	GIPI_ORIG_COMM_INVOICE.par_id%TYPE)
	IS
	BEGIN
		DELETE FROM GIPI_ORIG_COMM_INVOICE
		 WHERE par_id  = p_par_id;
	END del_gipi_orig_comm_invoice;

    /*
    **  Created by        : Veronica V. Raymundo
    **  Date Created     : 05.04.2011
    **  Reference By     : (GIPIS154 - Lead Policy Information)
    **  Description     : Gets gipi_orig_comm_invoice records of a given par_id
    */

    FUNCTION get_gipi_orig_comm_invoice(p_par_id        GIPI_ORIG_COMM_INVOICE.par_id%TYPE)
    RETURN gipi_orig_comm_invoice_tab PIPELINED

    IS

        v_orig_comm_inv         gipi_orig_comm_invoice_type;

    BEGIN
        FOR i IN (SELECT a.par_id, a.item_grp,
                         a.intrmdry_intm_no,b.intm_name,
                         b.parent_intm_no, c.intm_name parent_intm_name,
                         a.premium_amt,a.share_percentage,
                         a.commission_amt,a.wholding_tax
                    FROM GIPI_ORIG_COMM_INVOICE a,
                         GIIS_INTERMEDIARY b,
                         GIIS_INTERMEDIARY c
                    WHERE par_id = p_par_id
                      AND a.intrmdry_intm_no = b.intm_no
                      AND b.parent_intm_no = c.intm_no(+)
                    ORDER BY a.item_grp)
        LOOP
            v_orig_comm_inv.par_id              := i.par_id;
            v_orig_comm_inv.item_grp            := i.item_grp;
            v_orig_comm_inv.intrmdry_intm_no    := i.intrmdry_intm_no;
            v_orig_comm_inv.intm_name           := i.intm_name;
            v_orig_comm_inv.parent_intm_no      := i.parent_intm_no;
            v_orig_comm_inv.parent_intm_name    := i.parent_intm_name;
            v_orig_comm_inv.premium_amt         := i.premium_amt;
            v_orig_comm_inv.share_percentage    := i.share_percentage;
            v_orig_comm_inv.commission_amt      := i.commission_amt;
            v_orig_comm_inv.wholding_tax        := i.wholding_tax;
            v_orig_comm_inv.net_comm            := NVL(i.commission_amt,0) - NVL(i.wholding_tax,0);

            GIPI_WCOMM_INVOICES_PKG.get_gipi_wcomm_inv_amt_columns(i.par_id, i.item_grp, i.intrmdry_intm_no,
                                                                   v_orig_comm_inv.share_premium_amt,
                                                                   v_orig_comm_inv.share_commission_amt,
                                                                   v_orig_comm_inv.share_share_percentage,
                                                                   v_orig_comm_inv.share_wholding_tax,
                                                                   v_orig_comm_inv.share_net_comm );
            PIPE ROW(v_orig_comm_inv);

        END LOOP;
    END;

    /*
    **  Created by        : Moses Calma
    **  Date Created      : 05.30.2011
    **  Reference By      : (GIPIS100 Lead Policy Information)
    **  Description       : Gets invoice commissions given the policy_id and item_grp
    */
    FUNCTION get_invoice_commissions (
       p_policy_id   gipi_orig_comm_invoice.policy_id%TYPE,
       p_item_grp    gipi_orig_comm_invoice.item_grp%TYPE
    )
       RETURN comm_invoice_tab PIPELINED
    IS
       v_comm_invoice   comm_invoice_type;
    BEGIN
       FOR i IN (SELECT intrmdry_intm_no, par_id, item_grp, share_percentage,
                        premium_amt, commission_amt, wholding_tax, policy_id,
                        iss_cd, prem_seq_no
                   FROM gipi_orig_comm_invoice
                  WHERE policy_id = p_policy_id AND item_grp = p_item_grp)
       LOOP
          v_comm_invoice.par_id := i.par_id;
          v_comm_invoice.item_grp := i.item_grp;
          v_comm_invoice.policy_id := i.policy_id;
          v_comm_invoice.iss_cd := i.iss_cd;
          v_comm_invoice.prem_seq_no := i.prem_seq_no;
          v_comm_invoice.full_intm_no := i.intrmdry_intm_no;
          v_comm_invoice.full_share_percentage := i.share_percentage;
          v_comm_invoice.full_premium_amt := i.premium_amt;
          v_comm_invoice.full_commission_amt := i.commission_amt;
          v_comm_invoice.full_wholding_tax := i.wholding_tax;

          BEGIN
          SELECT a.intrmdry_intm_no,
                 a.share_percentage,
                 a.premium_amt,
                 a.commission_amt,
                 a.wholding_tax
            INTO v_comm_invoice.your_intm_no,
                 v_comm_invoice.your_share_percentage,
                 v_comm_invoice.your_premium_amt,
                 v_comm_invoice.your_commission_amt,
                 v_comm_invoice.your_wholding_tax
            FROM gipi_comm_invoice a, gipi_invoice b
           WHERE a.policy_id = b.policy_id
             AND a.iss_cd = b.iss_cd
             AND a.prem_seq_no = b.prem_seq_no
             AND a.policy_id = i.policy_id
             AND b.item_grp = i.item_grp
             AND intrmdry_intm_no = i.intrmdry_intm_no;

          EXCEPTION
          WHEN NO_DATA_FOUND
          THEN

             v_comm_invoice.your_intm_no            := '';
             v_comm_invoice.your_share_percentage   := '';
             v_comm_invoice.your_premium_amt        := '';
             v_comm_invoice.your_commission_amt     := '';
             v_comm_invoice.your_wholding_tax       := '';

          END;

          BEGIN

          SELECT parent_intm_no, intm_name
            INTO v_comm_invoice.your_prnt_intm_no, v_comm_invoice.your_intm_name
            FROM giis_intermediary
           WHERE intm_no = v_comm_invoice.your_intm_no;

          EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
            v_comm_invoice.your_prnt_intm_no    := '';
            v_comm_invoice.your_intm_name       := '';
          END;

          BEGIN
          SELECT intm_name
            INTO v_comm_invoice.your_prnt_intm_name
            FROM giis_intermediary
           WHERE intm_no = v_comm_invoice.your_prnt_intm_no;

          EXCEPTION
          WHEN NO_DATA_FOUND
          THEN

            v_comm_invoice.your_prnt_intm_name  := '';

          END;

          BEGIN

          SELECT parent_intm_no, intm_name
            INTO v_comm_invoice.full_prnt_intm_no, v_comm_invoice.full_intm_name
            FROM giis_intermediary
           WHERE intm_no = i.intrmdry_intm_no;

          EXCEPTION
          WHEN NO_DATA_FOUND
          THEN

            v_comm_invoice.full_prnt_intm_no    :=  '';
            v_comm_invoice.full_intm_name       :=  '';

          END;

          BEGIN

          SELECT intm_name
            INTO v_comm_invoice.full_prnt_intm_name
            FROM giis_intermediary
           WHERE intm_no = v_comm_invoice.full_prnt_intm_no;

          EXCEPTION
          WHEN NO_DATA_FOUND
          THEN

            v_comm_invoice.full_prnt_intm_name  := '';

          END;

          v_comm_invoice.your_net_premium :=
               NVL (v_comm_invoice.your_commission_amt, 0)
             - NVL (v_comm_invoice.your_wholding_tax, 0);
          v_comm_invoice.full_net_commission :=
               NVL (v_comm_invoice.full_commission_amt, 0)
             - NVL (v_comm_invoice.full_wholding_tax, 0);

          PIPE ROW (v_comm_invoice);

       END LOOP;                            --moses 05 27 2011
    END get_invoice_commissions;

END GIPI_ORIG_COMM_INVOICE_PKG;
/


