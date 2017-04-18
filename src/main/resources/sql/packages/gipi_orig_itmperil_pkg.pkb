CREATE OR REPLACE PACKAGE BODY CPI.GIPI_ORIG_ITMPERIL_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/
	PROCEDURE del_gipi_orig_itmperil (p_par_id 	GIPI_ORIG_ITMPERIL.par_id%TYPE)
	IS
	BEGIN
		DELETE FROM GIPI_ORIG_ITMPERIL
		 WHERE par_id  = p_par_id;
	END del_gipi_orig_itmperil;

    /*
	**  Created by		: Veronica V. Raymundo
	**  Date Created 	: 04.29.2011
	**  Reference By 	: (GIPIS154 - Lead Policy Information)
	**  Description     : Retrieves records from GIPI_ORIG_ITMPERIL with
    **                   the given par_id and item_no
	*/

    FUNCTION get_gipi_orig_itmperil(p_par_id     GIPI_ORIG_ITMPERIL.par_id%TYPE,
                                    p_item_no    GIPI_ORIG_ITMPERIL.item_no%TYPE)
    RETURN gipi_orig_itmperil_tab PIPElINED

    AS

        v_orig_itmPeril        gipi_orig_itmperil_type;
        v_share_rate           NUMBER;
        v_share_prem_amt       NUMBER;
        v_share_tsi_amt        NUMBER;

    BEGIN

        FOR i IN (SELECT A.par_id,   A.item_no,   A.line_cd, A.peril_cd,
                         A.rec_flag, A.policy_id, A.prem_rt, A.prem_amt,
                         A.tsi_amt,  A.ann_prem_amt, A.ann_tsi_amt,
                         A.comp_rem, A.discount_sw,  A.ri_comm_rate,
                         A.ri_comm_amt, A.surcharge_sw, B.peril_sname, B.peril_name
            FROM GIPI_ORIG_ITMPERIL A,
                 GIIS_PERIL B
            WHERE A.par_id = p_par_id
              --AND A.item_no = p_item_no
              AND A.line_cd  = B.line_cd
              AND A.peril_cd = B.peril_cd)
        LOOP
            v_orig_itmPeril.par_id      :=    i.par_id;
            v_orig_itmPeril.item_no     :=    i.item_no;
            v_orig_itmPeril.line_cd     :=    i.line_cd;
            v_orig_itmPeril.peril_cd    :=    i.peril_cd;
            v_orig_itmPeril.rec_flag    :=    i.rec_flag;
            v_orig_itmPeril.policy_id   :=    i.policy_id;
            v_orig_itmPeril.prem_rt     :=    i.prem_rt;
            v_orig_itmPeril.prem_amt    :=    i.prem_amt;
            v_orig_itmPeril.tsi_amt     :=    i.tsi_amt;
            v_orig_itmPeril.ann_prem_amt:=    i.ann_prem_amt;
            v_orig_itmPeril.ann_tsi_amt :=	  i.ann_tsi_amt;
            v_orig_itmPeril.comp_rem	:=	  i.comp_rem;
            v_orig_itmPeril.discount_sw	:=	  i.discount_sw;
            v_orig_itmPeril.ri_comm_rate:=	  i.ri_comm_rate;
            v_orig_itmPeril.ri_comm_amt :=	  i.ri_comm_amt;
            v_orig_itmPeril.surcharge_sw:=	  i.surcharge_sw;
            v_orig_itmPeril.peril_sname :=	  i.peril_sname;
            v_orig_itmPeril.peril_name  :=	  i.peril_name ;

            GIPI_ORIG_ITMPERIL_PKG.get_share_tsi_prem_amt
                 (i.par_id,i.item_no,i.line_cd, i.peril_cd,
                 v_share_rate, v_share_prem_amt,v_share_tsi_amt);

            v_orig_itmPeril.share_prem_rate :=   v_share_rate;
            v_orig_itmPeril.share_prem_amt  :=   v_share_prem_amt;
            v_orig_itmPeril.share_tsi_amt   :=   v_share_tsi_amt;

            PIPE ROW(v_orig_itmPeril);
        END LOOP;

        RETURN;
    END;

    PROCEDURE get_share_tsi_prem_amt
        (p_par_id	            GIPI_ORIG_ITMPERIL.par_id%TYPE,
         p_item_no	            GIPI_ORIG_ITMPERIL.item_no%TYPE,
         p_line_cd              GIPI_ORIG_ITMPERIL.line_cd%TYPE,
         p_peril_cd             GIPI_ORIG_ITMPERIL.peril_cd%TYPE,
         p_share_rate      OUT  NUMBER,
         p_share_prem_amt  OUT  NUMBER,
         p_share_tsi_amt   OUT  NUMBER)

    AS

    BEGIN
      FOR amt IN (
        SELECT prem_rt, prem_amt, tsi_amt
          FROM gipi_witmperl
         WHERE par_id   = p_par_id
           AND item_no  = p_item_no
           AND line_cd  = p_line_cd
           AND peril_cd = p_peril_cd)
      LOOP
         p_share_rate      := amt.prem_rt;
         p_share_prem_amt  := amt.prem_amt;
         p_share_tsi_amt   := amt.tsi_amt;

      END LOOP;

    END;

    /*
    **  Created by      :Moses Calma
    **  Date Created    :05.17.2011
    **  Reference by    :GIPIS 100 - lead policy information
    **  Description     :Retrieves a list of gipi_orig_itmperil based on policy_id and item_no
    */
    FUNCTION get_orig_itmperil (
       p_policy_id   gipi_item.policy_id%TYPE,
       p_item_no     gipi_item.item_no%TYPE
    )
       RETURN gipi_orig_itmperil_tab2 PIPELINED
    IS
       v_orig_itmperil   gipi_orig_itmperil_type2;
       v_peril_code        giis_peril.peril_sname%TYPE;
       v_peril_desc      giis_peril.peril_name%TYPE;
    BEGIN
       FOR i IN (SELECT policy_id, par_id, item_no, line_cd, peril_cd, rec_flag,
                        tsi_amt, prem_amt, ann_prem_amt, ann_tsi_amt, comp_rem,
                        ri_comm_rate, ri_comm_amt, prem_rt,discount_sw
                   FROM gipi_orig_itmperil
                  WHERE policy_id = p_policy_id AND item_no = p_item_no)
       LOOP
          v_orig_itmperil.policy_id := i.policy_id;
          v_orig_itmperil.item_no := i.item_no;
          v_orig_itmperil.comp_rem := i.comp_rem;

          SELECT peril_sname, peril_name
            INTO v_peril_code, v_peril_desc
            FROM giis_peril
           WHERE line_cd = i.line_cd AND peril_cd = i.peril_cd;

          v_orig_itmperil.peril_desc := v_peril_desc;
          v_orig_itmperil.your_peril_code := v_peril_code;
          v_orig_itmperil.full_peril_code := v_peril_code;

          SELECT prem_rt, prem_amt,
                 tsi_amt, discount_sw
            INTO v_orig_itmperil.your_prem_rt, v_orig_itmperil.your_prem_amt,
                 v_orig_itmperil.your_tsi_amt, v_orig_itmperil.your_discount_sw
            FROM gipi_itmperil
           WHERE policy_id = i.policy_id
             AND item_no = i.item_no
             AND line_cd = i.line_cd
             AND peril_cd = i.peril_cd;

          v_orig_itmperil.full_prem_rt := i.prem_rt;
          v_orig_itmperil.full_tsi_amt := i.tsi_amt;
          v_orig_itmperil.full_prem_amt := i.prem_amt;
          v_orig_itmperil.full_discount_sw := i.discount_sw;


          SELECT SUM (prem_amt)
            INTO v_orig_itmperil.dsp_full_prem_amt
            FROM gipi_orig_itmperil
           WHERE policy_id = p_policy_id AND item_no = p_item_no;


          SELECT SUM (tsi_amt)
            INTO v_orig_itmperil.dsp_full_tsi_amt
            FROM gipi_orig_itmperil a, giis_peril b
           WHERE a.line_cd = b.line_cd
             AND a.peril_cd = b.peril_cd
             AND b.peril_type = 'B'
             AND policy_id = p_policy_id
             AND item_no = p_item_no;

          PIPE ROW (v_orig_itmperil);
       END LOOP;

       RETURN;
    END get_orig_itmperil;


END GIPI_ORIG_ITMPERIL_PKG;
/


