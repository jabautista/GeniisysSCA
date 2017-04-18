CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Wcomm_Inv_Perils_Pkg AS

	FUNCTION get_gipi_wcomm_inv_perils (
		p_par_id			GIPI_WCOMM_INV_PERILS.par_id%TYPE,
		p_item_grp			GIPI_WCOMM_INV_PERILS.item_grp%TYPE,
		p_intrmdry_intm_no	GIPI_WCOMM_INV_PERILS.intrmdry_intm_no%TYPE)
	RETURN gipi_wcomm_inv_perils_tab PIPELINED
	IS

	v_wcomm			gipi_wcomm_inv_perils_type;

	BEGIN
		FOR i IN (
			SELECT a.peril_cd,       b.peril_name,	     a.item_grp,    a.takeup_seq_no,
				a.par_id,	 	 a.intrmdry_intm_no, a.premium_amt, a.commission_rt,
				a.commission_amt, a.wholding_tax,
				NVL(a.commission_amt, 0) - NVL(a.wholding_tax, 0) net_commission
			FROM GIPI_WCOMM_INV_PERILS a
				,GIIS_PERIL b
				,GIPI_PARLIST c
			WHERE a.par_id = p_par_id
			AND a.item_grp = p_item_grp
            AND a.intrmdry_intm_no = p_intrmdry_intm_no
            AND a.par_id = c.par_id
            AND a.peril_cd = b.peril_cd
            AND c.line_cd = b.line_cd)
        LOOP
            v_wcomm.peril_cd            := i.peril_cd;
            v_wcomm.peril_name            := i.peril_name;
            v_wcomm.item_grp            := i.item_grp;
            v_wcomm.takeup_seq_no        := i.takeup_seq_no;
            v_wcomm.par_id                := i.par_id;
            v_wcomm.intrmdry_intm_no    := i.intrmdry_intm_no;
            v_wcomm.premium_amt            := i.premium_amt;
            v_wcomm.commission_rt        := i.commission_rt;
            v_wcomm.commission_amt        := i.commission_amt;
            v_wcomm.wholding_tax        := i.wholding_tax;
            PIPE ROW(v_wcomm);
        END LOOP;
        RETURN;
    END get_gipi_wcomm_inv_perils;

    /**
    * Modified by: Emman 04.29.10
    * Retrieve comm invoice perils using par_id only
    */

    FUNCTION get_gipi_wcomm_inv_perils2 (
        p_par_id            GIPI_WCOMM_INV_PERILS.par_id%TYPE)
    RETURN gipi_wcomm_inv_perils_tab PIPELINED
    IS

    v_wcomm            gipi_wcomm_inv_perils_type;

    BEGIN
        FOR i IN (
            SELECT a.peril_cd,       b.peril_name,         a.item_grp,    a.takeup_seq_no,
                a.par_id,          a.intrmdry_intm_no, a.premium_amt, a.commission_rt,
                a.commission_amt, a.wholding_tax,
                NVL(a.commission_amt, 0) - NVL(a.wholding_tax, 0) net_commission
            FROM GIPI_WCOMM_INV_PERILS a
                ,GIIS_PERIL b
                ,GIPI_PARLIST c
            WHERE a.par_id = p_par_id
            AND a.par_id = c.par_id
            AND a.peril_cd = b.peril_cd
            AND c.line_cd = b.line_cd)
        LOOP
            v_wcomm.peril_cd            := i.peril_cd;
            v_wcomm.peril_name            := i.peril_name;
            v_wcomm.item_grp            := i.item_grp;
            v_wcomm.takeup_seq_no        := i.takeup_seq_no;
            v_wcomm.par_id                := i.par_id;
            v_wcomm.intrmdry_intm_no    := i.intrmdry_intm_no;
            v_wcomm.premium_amt            := i.premium_amt;
            v_wcomm.commission_rt        := i.commission_rt;
            v_wcomm.commission_amt        := i.commission_amt;
            v_wcomm.wholding_tax        := i.wholding_tax;
            PIPE ROW(v_wcomm);
        END LOOP;
        RETURN;
    END get_gipi_wcomm_inv_perils2;


    PROCEDURE set_gipi_wcomm_inv_perils (
        p_peril_cd            IN  GIPI_WCOMM_INV_PERILS.peril_cd%TYPE,
        p_item_grp            IN  GIPI_WCOMM_INV_PERILS.item_grp%TYPE,
        p_takeup_seq_no        IN  GIPI_WCOMM_INV_PERILS.takeup_seq_no%TYPE,
        p_par_id            IN  GIPI_WCOMM_INV_PERILS.par_id%TYPE,
        p_intrmdry_intm_no    IN  GIPI_WCOMM_INV_PERILS.intrmdry_intm_no%TYPE,
        p_premium_amt        IN  GIPI_WCOMM_INV_PERILS.premium_amt%TYPE,
        p_commission_rt        IN  GIPI_WCOMM_INV_PERILS.commission_rt%TYPE,
        p_commission_amt    IN  GIPI_WCOMM_INV_PERILS.commission_amt%TYPE,
        p_wholding_tax        IN  GIPI_WCOMM_INV_PERILS.wholding_tax%TYPE)
    IS
    BEGIN
        MERGE INTO GIPI_WCOMM_INV_PERILS
        USING DUAL ON (par_id        = p_par_id
                AND item_grp          = p_item_grp
                AND takeup_seq_no    = p_takeup_seq_no
                AND intrmdry_intm_no = p_intrmdry_intm_no
                AND takeup_seq_no     = p_takeup_seq_no
                AND peril_cd         = p_peril_cd)
        WHEN NOT MATCHED THEN
            INSERT ( peril_cd,           item_grp,      takeup_seq_no,   par_id,
                        intrmdry_intm_no,     premium_amt,   commission_rt,     commission_amt,   wholding_tax )
            VALUES ( p_peril_cd,         p_item_grp,    p_takeup_seq_no, p_par_id,
                        p_intrmdry_intm_no, p_premium_amt, p_commission_rt, p_commission_amt, p_wholding_tax )
        WHEN MATCHED THEN
            UPDATE SET premium_amt = p_premium_amt,
                        commission_rt = p_commission_rt,
                        commission_amt = p_commission_amt,
                        wholding_tax = p_wholding_tax;
    END set_gipi_wcomm_inv_perils;


    PROCEDURE del_gipi_wcomm_inv_perils (
        p_par_id            GIPI_WCOMM_INV_PERILS.par_id%TYPE,
        p_item_grp            GIPI_WCOMM_INV_PERILS.item_grp%TYPE,
        p_intrmdry_intm_no    GIPI_WCOMM_INV_PERILS.intrmdry_intm_no%TYPE,
        p_takeup_seq_no        GIPI_WCOMM_INV_PERILS.takeup_seq_no%TYPE,
        p_peril_cd            GIPI_WCOMM_INV_PERILS.peril_cd%TYPE) IS
    BEGIN
        DELETE FROM GIPI_WCOMM_INV_PERILS
         WHERE par_id = p_par_id
           AND item_grp = p_item_grp
           AND intrmdry_intm_no = p_intrmdry_intm_no
           AND takeup_seq_no = p_takeup_seq_no
           AND peril_cd = p_peril_cd;
    END del_gipi_wcomm_inv_perils;

    /*
    **  Modified by        : Mark JM
    **  Date Created     : 02.11.2010
    **  Reference By     : (GIPIS010 - Item Information)
    **  Description     : Delete record by supplying the par_id only
    */
    PROCEDURE del_gipi_wcomm_inv_perils1 (p_par_id    GIPI_WCOMM_INV_PERILS.par_id%TYPE)
    IS
    BEGIN
        DELETE FROM GIPI_WCOMM_INV_PERILS
         WHERE par_id = p_par_id;

    END del_gipi_wcomm_inv_perils1;

    /*
    **  Modified by        : Mark JM
    **  Date Created     : 03.23.2011
    **  Reference By     : (GIPIS095 - package Policy Items)
    **  Description     : Delete record from gipi_wcomm_inv_perils using the given parameters
    */
    PROCEDURE del_gipi_wcomm_inv_perils2 (
        p_par_id IN gipi_wcomm_inv_perils.par_id%TYPE,
        p_item_grp IN gipi_wcomm_inv_perils.item_grp%TYPE)
    IS
    BEGIN
        DELETE FROM gipi_wcomm_inv_perils
         WHERE par_id = p_par_id
           AND item_grp = p_item_grp;
    END del_gipi_wcomm_inv_perils2;

    /*
    **  Created by        : Veronica V. Raymundo
    **  Date Created     : 05.05.2011
    **  Reference By     : (GIPIS154 - Lead Policy Information)
    **  Description     : Gets premium_amt, commission_amt, commission_rt and
    **                    wholding_tax from GIPI_WCOMM_INV_PERILS table
    */

    PROCEDURE get_wcomm_inv_perils_amt_colmn
    (p_par_id       IN       GIPI_WCOMM_INV_PERILS.par_id%TYPE,
     p_item_grp     IN       GIPI_WCOMM_INV_PERILS.item_grp%TYPE,
     p_intrmdry_no  IN       GIPI_WCOMM_INV_PERILS.intrmdry_intm_no%TYPE,
     p_peril_cd     IN       GIPI_WCOMM_INV_PERILS.peril_cd%TYPE,
     p_prem_amt     OUT      GIPI_WCOMM_INV_PERILS.premium_amt%TYPE,
     p_comm_rt      OUT      GIPI_WCOMM_INV_PERILS.commission_rt%TYPE,
     p_comm_amt     OUT      GIPI_WCOMM_INV_PERILS.commission_amt%TYPE,
     p_whold_tax    OUT      GIPI_WCOMM_INV_PERILS.wholding_tax%TYPE,
     p_net_comm     OUT      NUMBER)

     IS

     BEGIN
        FOR i IN (SELECT premium_amt, commission_rt,
                         wholding_tax, commission_amt
                  FROM gipi_wcomm_inv_perils
                  WHERE par_id         = p_par_id
                  AND item_grp         = p_item_grp
                  AND intrmdry_intm_no = p_intrmdry_no
                  AND peril_cd         = p_peril_cd)

        LOOP
            p_prem_amt  := i.premium_amt;
            p_comm_rt   := i.commission_rt;
            p_comm_amt  := i.commission_amt;
            p_whold_tax := i.wholding_tax;
            p_net_comm  := NVL(i.commission_amt,0) - NVL(i.wholding_tax,0);

            RETURN;

        END LOOP;
     END;

	/*
    **  Created by   :  Emman
    **  Date Created :  06.29.2011
    **  Reference By : (Gipis085 - Invoice Commission)
    **  Description  : Gets gipi_wcomm_inv_perils records based on pack_par_id, used for package
    */
	FUNCTION get_pack_gipi_wcomm_inv_perils (
        p_pack_par_id            GIPI_PARLIST.pack_par_id%TYPE)
    RETURN gipi_wcomm_inv_perils_tab PIPELINED
    IS

    v_wcomm            gipi_wcomm_inv_perils_type;

    BEGIN
        FOR i IN (
            SELECT a.peril_cd,       b.peril_name,         a.item_grp,    a.takeup_seq_no,
                a.par_id,          a.intrmdry_intm_no, a.premium_amt, a.commission_rt,
                a.commission_amt, a.wholding_tax,
                NVL(a.commission_amt, 0) - NVL(a.wholding_tax, 0) net_commission
            FROM GIPI_WCOMM_INV_PERILS a
                ,GIIS_PERIL b
                ,GIPI_PARLIST c
            WHERE a.par_id IN (SELECT DISTINCT par_id
			 	   			   	  FROM gipi_parlist b240
								 WHERE b240.pack_par_id = p_pack_par_id)
            AND a.par_id = c.par_id
            AND a.peril_cd = b.peril_cd
            AND c.line_cd = b.line_cd)
        LOOP
            v_wcomm.peril_cd            := i.peril_cd;
            v_wcomm.peril_name            := i.peril_name;
            v_wcomm.item_grp            := i.item_grp;
            v_wcomm.takeup_seq_no        := i.takeup_seq_no;
            v_wcomm.par_id                := i.par_id;
            v_wcomm.intrmdry_intm_no    := i.intrmdry_intm_no;
            v_wcomm.premium_amt            := i.premium_amt;
            v_wcomm.commission_rt        := i.commission_rt;
            v_wcomm.commission_amt        := i.commission_amt;
            v_wcomm.wholding_tax        := i.wholding_tax;
            PIPE ROW(v_wcomm);
        END LOOP;
        RETURN;
    END get_pack_gipi_wcomm_inv_perils;
END Gipi_Wcomm_Inv_Perils_Pkg;
/


