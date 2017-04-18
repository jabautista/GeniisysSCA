CREATE OR REPLACE PACKAGE BODY CPI.GIPI_ORIG_INVPERL_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/
	PROCEDURE del_gipi_orig_invperl (p_par_id 	GIPI_ORIG_INVPERL.par_id%TYPE)
	IS
	BEGIN
		DELETE FROM GIPI_ORIG_INVPERL
		 WHERE par_id  = p_par_id;
	END del_gipi_orig_invperl;

    /*
    **  Created by        : Veronica V. Raymundo
    **  Date Created     : 05.03.2011
    **  Reference By     : (GIPIS154 - Lead Policy Information)
    **  Description     : Get gipi_orig_invperl records of a given par_id
    */

    FUNCTION get_gipi_orig_invperl(p_par_id         GIPI_ORIG_INVPERL.par_id%TYPE,
                                   p_line_cd        GIIS_PERIL.line_cd%TYPE)
    RETURN gipi_orig_invperl_tab PIPELINED

    IS

    v_orig_invperl      gipi_orig_invperl_type;

    BEGIN
        FOR i IN(SELECT a.par_id, a.item_grp,
                        a.peril_cd, b.peril_name,
                        a.tsi_amt, a.prem_amt,
                        a.policy_id, a. ri_comm_amt,
                        a.ri_comm_rt
                FROM GIPI_ORIG_INVPERL a,
                     GIIS_PERIL b
                WHERE a.par_id = p_par_id
                  AND b.line_cd = p_line_cd
                  AND a.peril_cd = b.peril_cd)

        LOOP
            v_orig_invperl.par_id       := i.par_id;
            v_orig_invperl.item_grp     := i.item_grp;
            v_orig_invperl.peril_cd     := i.peril_cd;
            v_orig_invperl.peril_name   := i.peril_name;
            v_orig_invperl.tsi_amt      := i.tsi_amt;
            v_orig_invperl.prem_amt     := i.prem_amt;
            v_orig_invperl.policy_id    := i.policy_id;
            v_orig_invperl.ri_comm_amt  := i.ri_comm_amt;
            v_orig_invperl.ri_comm_rt   := i.ri_comm_rt;

            GIPI_WINVPERL_PKG.get_prem_tsi_amt(i.par_id, i.item_grp, i.peril_cd, v_orig_invperl.share_tsi_amt,v_orig_invperl.share_prem_amt);

            PIPE ROW(v_orig_invperl);

        END LOOP;
    END;

    /*
    **  Created by        : Moses Calma
    **  Date Created      : 05.26.2011
    **  Reference By      : (GIPIS100 - Policy Information)
    **  Description       :  return inverse perils for a given policy_id and item_grp
    */
    FUNCTION get_inv_perils (
       p_policy_id   gipi_orig_invperl.policy_id%TYPE,
       p_item_grp    gipi_orig_invperl.item_grp%TYPE
    )
       RETURN inv_peril_tab PIPELINED
    IS
       v_inv_peril   inv_peril_type;
       v_line_cd     gipi_polbasic.line_cd%TYPE;
       v_peril_code  giis_peril.peril_name%TYPE;
    BEGIN
       FOR i IN (SELECT par_id, item_grp, peril_cd, tsi_amt, prem_amt, policy_id,
                        ri_comm_amt, ri_comm_rt
                   FROM gipi_orig_invperl
                  WHERE policy_id = p_policy_id AND item_grp = p_item_grp)
       LOOP
          v_inv_peril.par_id        := i.par_id;
          v_inv_peril.item_grp      := i.item_grp;
          v_inv_peril.peril_cd      := i.peril_cd;
          v_inv_peril.policy_id     := i.policy_id;
          v_inv_peril.ri_comm_rt    := i.ri_comm_rt;
          v_inv_peril.ri_comm_amt   := i.ri_comm_amt;
          v_inv_peril.full_prem_amt := i.prem_amt;
          v_inv_peril.full_tsi_amt  := i.tsi_amt;

          SELECT line_cd
            INTO v_line_cd
            FROM gipi_polbasic
           WHERE policy_id = i.policy_id;

          SELECT peril_name
            INTO v_peril_code
            FROM giis_peril
           WHERE line_cd = v_line_cd AND peril_cd = i.peril_cd;

          v_inv_peril.your_peril_code := v_peril_code;
          v_inv_peril.full_peril_code := v_peril_code;

          SELECT a.tsi_amt, a.prem_amt
            INTO v_inv_peril.your_tsi_amt, v_inv_peril.your_prem_amt
            FROM gipi_invperil a, gipi_invoice b
           WHERE a.iss_cd = b.iss_cd
             AND a.prem_seq_no = b.prem_seq_no
             AND b.policy_id = i.policy_id
             AND b.item_grp = i.item_grp
             AND a.peril_cd = i.peril_cd;

          PIPE ROW (v_inv_peril);
       END LOOP;
    END get_inv_perils;

END GIPI_ORIG_INVPERL_PKG;
/


