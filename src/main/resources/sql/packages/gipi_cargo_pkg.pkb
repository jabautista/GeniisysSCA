CREATE OR REPLACE PACKAGE BODY CPI.GIPI_CARGO_PKG AS
  FUNCTION get_cargo_item_currency(p_extract_id 	GIXX_PARLIST.extract_id%TYPE,
  		   						   p_item_no		GIPI_CARGO.item_no%TYPE)
	RETURN VARCHAR2 IS
	v_curr_cd 		  VARCHAR2(20) := NULL;
	v_par_id		  GIXX_PARLIST.par_id%TYPE;
	v_par_status	  GIXX_PARLIST.par_status%TYPE;
  BEGIN

    BEGIN
      SELECT par_status
        INTO v_par_status
        FROM GIXX_PARLIST
       WHERE extract_id = p_extract_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL;
    END;

    BEGIN
        SELECT DECODE(v_par_status, 10, policy_id, par_id)
          INTO v_par_id
          FROM GIXX_POLBASIC
         WHERE extract_id = p_extract_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL;
    END;

    IF v_par_status != 10 THEN
        SELECT b.short_name
        INTO v_curr_cd
        FROM gipi_witem a, giis_currency b
          WHERE a.currency_cd = b.main_currency_cd
          AND a.par_id = v_par_id
          AND a.item_no = p_item_no;
         RETURN (v_curr_cd);
    ELSIF v_par_status = 10 THEN
      SELECT b.short_name
        INTO v_curr_cd
        FROM gipi_item a, giis_currency b
          WHERE a.currency_cd = b.main_currency_cd
          AND a.policy_id = v_par_id
          AND a.item_no = p_item_no;
      RETURN (v_curr_cd);
    END IF;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL;
    RETURN ('PHP');
  END get_cargo_item_currency;

  FUNCTION get_inv_value(p_extract_id     GIXX_PARLIST.extract_id%TYPE,
                              p_item_no        GIPI_CARGO.item_no%TYPE)
    RETURN VARCHAR2 IS
    v_inv_value            VARCHAR2(20) := '0.00';
    v_par_id               GIXX_PARLIST.par_id%TYPE;
    v_par_status           GIXX_PARLIST.par_status%TYPE;
  BEGIN

    BEGIN
        SELECT par_status
          INTO v_par_status
          FROM GIXX_PARLIST
         WHERE extract_id = p_extract_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
    END;

    BEGIN
        SELECT DECODE(v_par_status, 10, policy_id, par_id)
          INTO v_par_id
          FROM GIXX_POLBASIC
         WHERE extract_id = p_extract_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
    END;

    IF v_par_status != 10 THEN
        SELECT TRIM(TO_CHAR(NVL(invoice_value,0),'999,999,999,990.99'))
        INTO v_inv_value
        FROM gipi_wcargo
          WHERE par_id = v_par_id
            AND item_no = p_item_no;
         RETURN (v_inv_value);
    ELSIF v_par_status = 10 THEN
      SELECT TRIM(TO_CHAR(NVL(invoice_value,0),'999,999,999,990.99'))
        INTO v_inv_value
        FROM gipi_cargo
          WHERE policy_id = v_par_id
            AND item_no = p_item_no;
         RETURN (v_inv_value);
    END IF;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL;
    RETURN (v_inv_value);
  END get_inv_value;

  FUNCTION get_markup_rate(p_extract_id     GIXX_PARLIST.extract_id%TYPE,
                                p_item_no        GIPI_CARGO.item_no%TYPE)
    RETURN VARCHAR2 IS
    v_markup_rate          VARCHAR2(20) := '0%'; --:= '0.00';
    v_par_id               GIXX_PARLIST.par_id%TYPE;
    v_par_status           GIXX_PARLIST.par_status%TYPE;
  BEGIN

    BEGIN
        SELECT par_status
          INTO v_par_status
          FROM GIXX_PARLIST
         WHERE extract_id = p_extract_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
    END;

    BEGIN
        SELECT DECODE(v_par_status, 10, policy_id, par_id)
          INTO v_par_id
          FROM GIXX_POLBASIC
         WHERE extract_id = p_extract_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
    END;

    IF v_par_status != 10 THEN
        --SELECT TRIM(TO_CHAR(NVL(markup_rate,0),'990.99')) || '%' replaced by: Nica 09.15.2012 - to show correct number of decimal places of the stored value
		SELECT TRIM(TO_CHAR(NVL(markup_rate,0))) || '%'
        INTO v_markup_rate
        FROM gipi_wcargo
          WHERE par_id = v_par_id
            AND item_no = p_item_no;
         RETURN (v_markup_rate);
    ELSIF v_par_status = 10 THEN
      --SELECT TRIM(TO_CHAR(NVL(markup_rate,0),'990.99')) || '%'
        SELECT TRIM(TO_CHAR(NVL(markup_rate,0))) || '%'
		INTO v_markup_rate
        FROM gipi_cargo
          WHERE policy_id = v_par_id
            AND item_no = p_item_no;
         RETURN (v_markup_rate);
    END IF;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_markup_rate := '0%';
    RETURN (v_markup_rate);
  END get_markup_rate;

  FUNCTION get_inv_curr_rt(p_extract_id     GIXX_PARLIST.extract_id%TYPE,
                                p_item_no        GIPI_CARGO.item_no%TYPE)
    RETURN VARCHAR2 IS
    v_inv_curr_rt            VARCHAR2(20) := '0.00';
    v_par_id               GIXX_PARLIST.par_id%TYPE;
    v_par_status           GIXX_PARLIST.par_status%TYPE;
  BEGIN

    BEGIN
        SELECT par_id, par_status
          INTO v_par_id, v_par_status
          FROM GIXX_PARLIST
         WHERE extract_id = p_extract_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
    END;

    BEGIN
        SELECT DECODE(v_par_status, 10, policy_id, par_id)
          INTO v_par_id
          FROM GIXX_POLBASIC
         WHERE extract_id = p_extract_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
    END;

    IF v_par_status != 10 THEN
        --SELECT TRIM(TO_CHAR(NVL(inv_curr_rt,0),'990.99')) replaced by: Nica 09.15.2012 - to show correct number of decimal places of the stored value
        SELECT TRIM(TO_CHAR(NVL(inv_curr_rt,0.00)))
		INTO v_inv_curr_rt
        FROM gipi_wcargo
          WHERE par_id = v_par_id
            AND item_no = p_item_no;
         RETURN (v_inv_curr_rt);
    ELSIF v_par_status = 10 THEN
      --SELECT TRIM(TO_CHAR(NVL(inv_curr_rt,0),'990.99'))
        SELECT TRIM(TO_CHAR(NVL(inv_curr_rt,0.00)))
		INTO v_inv_curr_rt
        FROM gipi_cargo
          WHERE policy_id = v_par_id
            AND item_no = p_item_no;
         RETURN (v_inv_curr_rt);
    END IF;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_inv_curr_rt := '0.00';
    RETURN (v_inv_curr_rt);
  END get_inv_curr_rt;

  FUNCTION get_inv_currency(p_extract_id     GIXX_PARLIST.extract_id%TYPE,
                                 p_item_no        GIPI_CARGO.item_no%TYPE)
    RETURN VARCHAR2 IS
    v_curr_cd           VARCHAR2(20) := NULL;
    v_par_id          GIXX_PARLIST.par_id%TYPE;
    v_par_status      GIXX_PARLIST.par_status%TYPE;
  BEGIN

    BEGIN
        SELECT par_id, par_status
          INTO v_par_id, v_par_status
          FROM GIXX_PARLIST
         WHERE extract_id = p_extract_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
    END;

    BEGIN
        SELECT DECODE(v_par_status, 10, policy_id, par_id)
          INTO v_par_id
          FROM GIXX_POLBASIC
         WHERE extract_id = p_extract_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
    END;

    IF v_par_status != 10 THEN
        SELECT b.short_name
        INTO v_curr_cd
        FROM gipi_wcargo a, giis_currency b
          WHERE a.inv_curr_cd = b.main_currency_cd
          AND a.par_id = v_par_id
          AND a.item_no = p_item_no;
         RETURN (v_curr_cd);
    ELSIF v_par_status = 10 THEN
      SELECT b.short_name
        INTO v_curr_cd
        FROM gipi_cargo a, giis_currency b
          WHERE a.inv_curr_cd = b.main_currency_cd
          AND a.policy_id = v_par_id
          AND a.item_no = p_item_no;
      RETURN (v_curr_cd);
    END IF;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL;
    RETURN ('PHP');
  END get_inv_currency;

  FUNCTION get_agreed_value(p_extract_id     GIXX_PARLIST.extract_id%TYPE,
                                 p_item_no        GIPI_CARGO.item_no%TYPE)
    RETURN VARCHAR2 IS
    v_agreed_value       VARCHAR2(20) := '0.00';
    v_par_id          GIXX_PARLIST.par_id%TYPE;
    v_par_status      GIXX_PARLIST.par_status%TYPE;
  BEGIN

    BEGIN
        SELECT par_id, par_status
          INTO v_par_id, v_par_status
          FROM GIXX_PARLIST
         WHERE extract_id = p_extract_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
    END;

    BEGIN
        SELECT DECODE(v_par_status, 10, policy_id, par_id)
          INTO v_par_id
          FROM GIXX_POLBASIC
         WHERE extract_id = p_extract_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
    END;

    IF v_par_status != 10 THEN
        SELECT TRIM(TO_CHAR((invoice_value + (invoice_value * (markup_rate/100))) * inv_curr_rt,'999,999,999,990.99'))
        INTO v_agreed_value
        FROM gipi_wcargo
          WHERE par_id = v_par_id
            AND item_no = p_item_no;
      RETURN (v_agreed_value);
    ELSIF v_par_status = 10 THEN
      SELECT TRIM(TO_CHAR((invoice_value + (invoice_value * (markup_rate/100))) * inv_curr_rt,'999,999,999,990.99'))
        INTO v_agreed_value
        FROM gipi_cargo
          WHERE policy_id = v_par_id
            AND item_no = p_item_no;
         RETURN (v_agreed_value);
    END IF;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL;
      RETURN (v_agreed_value);
  END get_agreed_value;

/*
**  Created by   : Menandro G.C. Robes
**  Date Created : August 10, 2010
**  Reference By : (GIPIS068 - Endorsement Marine Cargo Item Information)
**  Description  : Function to retrieve marine cargo records of policy.
*/
  FUNCTION get_gipi_cargo (p_policy_id  GIPI_CARGO.policy_id%TYPE,
                           p_item_no    GIPI_CARGO.item_no%TYPE)
    RETURN gipi_cargo_tab PIPELINED IS

    v_cargo gipi_cargo_type;

  BEGIN
    FOR j IN (
      SELECT item_no,       policy_id,   rec_flag,       print_tag,
             vessel_cd,     geog_cd,     cargo_class_cd, voyage_no,
             bl_awb,        origin,      destn,          etd,
             eta,           cargo_type,  pack_method,    tranship_origin,
             tranship_destination,       deduct_text,    lc_no,
             invoice_value, inv_curr_cd, inv_curr_rt,    markup_rate
        FROM gipi_cargo
       WHERE policy_id = p_policy_id
         AND item_no = p_item_no)
    LOOP
        v_cargo.policy_id            := j.policy_id;
        v_cargo.item_no              := j.item_no;
        v_cargo.rec_flag             := j.rec_flag;
        v_cargo.print_tag            := j.print_tag;
        v_cargo.vessel_cd            := j.vessel_cd;
        v_cargo.geog_cd              := j.geog_cd;
        v_cargo.cargo_class_cd       := j.cargo_class_cd;
        v_cargo.voyage_no            := j.voyage_no;
        v_cargo.bl_awb               := j.bl_awb;
        v_cargo.origin               := j.origin;
        v_cargo.destn                := j.destn;
        v_cargo.etd                  := j.etd;
        v_cargo.eta                  := j.eta;
        v_cargo.cargo_type           := j.cargo_type;
        v_cargo.pack_method          := j.pack_method;
        v_cargo.tranship_origin      := j.tranship_origin;
        v_cargo.tranship_destination := j.tranship_destination;
        v_cargo.deduct_text          := j.deduct_text;
        v_cargo.lc_no                := j.lc_no;
        v_cargo.invoice_value        := j.invoice_value;
        v_cargo.inv_curr_cd          := j.inv_curr_cd;
        v_cargo.inv_curr_rt          := j.inv_curr_rt;
        v_cargo.markup_rate          := j.markup_rate;
        PIPE ROW(v_cargo);
    END LOOP;
    RETURN;
  END get_gipi_cargo;

    /*
    **  Created by        : Andrew
    **  Date Created    : 05.20.2011
    **  Reference By    : (GIPIS069 - Item Information - Marine Cargo - Endorsement)
    **  Description        : Retrieves record on GIPI_CARGO based on the given policy_id and item_no
    */
    FUNCTION get_gipi_cargos1 (
       p_policy_id   IN   gipi_cargo.policy_id%TYPE,
       p_item_no     IN   gipi_cargo.item_no%TYPE
    )
       RETURN gipi_cargo_endt_tab PIPELINED
    IS
       v_gipi_cargo   gipi_cargo_endt_type;
    BEGIN
       FOR i IN (SELECT a.policy_id, a.item_no, a.rec_flag, a.print_tag,
                        a.vessel_cd, a.geog_cd, a.cargo_class_cd, a.voyage_no,
                        a.bl_awb, a.origin, a.destn, a.etd, a.eta, a.cargo_type,
                        a.deduct_text, a.pack_method, a.tranship_origin,
                        a.tranship_destination, a.lc_no, a.cpi_rec_no,
                        a.cpi_branch_cd, a.invoice_value, a.inv_curr_cd,
                        a.inv_curr_rt, a.markup_rate, b.cargo_class_desc
                   FROM gipi_cargo a, giis_cargo_class b
                  WHERE a.policy_id = p_policy_id
                    AND a.item_no = p_item_no
                    AND a.cargo_class_cd = b.cargo_class_cd)
       LOOP
          v_gipi_cargo.policy_id := i.policy_id;
          v_gipi_cargo.item_no := i.item_no;
          v_gipi_cargo.rec_flag := i.rec_flag;
          v_gipi_cargo.print_tag := i.print_tag;
          v_gipi_cargo.vessel_cd := i.vessel_cd;
          v_gipi_cargo.geog_cd := i.geog_cd;
          v_gipi_cargo.cargo_class_cd := i.cargo_class_cd;
          v_gipi_cargo.voyage_no := i.voyage_no;
          v_gipi_cargo.bl_awb := i.bl_awb;
          v_gipi_cargo.origin := i.origin;
          v_gipi_cargo.destn := i.destn;
          v_gipi_cargo.etd := i.etd;
          v_gipi_cargo.eta := i.eta;
          v_gipi_cargo.cargo_type := i.cargo_type;
          v_gipi_cargo.deduct_text := i.deduct_text;
          v_gipi_cargo.pack_method := i.pack_method;
          v_gipi_cargo.tranship_origin := i.tranship_origin;
          v_gipi_cargo.tranship_destination := i.tranship_destination;
          v_gipi_cargo.lc_no := i.lc_no;
          v_gipi_cargo.cpi_rec_no := i.cpi_rec_no;
          v_gipi_cargo.cpi_branch_cd := i.cpi_branch_cd;
          v_gipi_cargo.invoice_value := i.invoice_value;
          v_gipi_cargo.inv_curr_cd := i.inv_curr_cd;
          v_gipi_cargo.inv_curr_rt := i.inv_curr_rt;
          v_gipi_cargo.markup_rate := i.markup_rate;
          v_gipi_cargo.cargo_class_desc := i.cargo_class_desc;

          BEGIN

            SELECT cargo_type_desc
              INTO v_gipi_cargo.cargo_type_desc
              FROM giis_cargo_type
             WHERE cargo_type = i.cargo_type;

          EXCEPTION
          WHEN NO_DATA_FOUND
          THEN

            v_gipi_cargo.cargo_type_desc := '';

          END;

          PIPE ROW (v_gipi_cargo);
       END LOOP;

       RETURN;
    END get_gipi_cargos1;

    /*
    **  Created by   : Moses Calma
    **  Date Created : June  9 , 2011
    **  Reference By : (GIPIS100 - Policy Information)
    **  Description  : Retrieves information of a Cargo
    */
    FUNCTION get_cargo_info (
       p_policy_id   gipi_cargo.policy_id%TYPE,
       p_item_no     gipi_cargo.item_no%TYPE
    )
       RETURN cargo_info_tab PIPELINED
    IS
       v_cargo_info   cargo_info_type;
       v_vessel_cd   giis_vessel.vessel_cd%TYPE;
    BEGIN
       FOR i IN (SELECT policy_id, item_no, geog_cd, bl_awb, origin, etd, destn, eta,
                        pack_method, cargo_type, cargo_class_cd, tranship_origin,
                        tranship_destination, vessel_cd, voyage_no, print_tag, lc_no,
                        inv_curr_rt, invoice_value, markup_rate, deduct_text
                   FROM gipi_cargo
                  WHERE policy_id = p_policy_id
                    AND item_no = p_item_no)
       LOOP

          v_cargo_info.policy_id               := i.policy_id;
          v_cargo_info.item_no                 := i.item_no;
          v_cargo_info.bl_awb                  := i.bl_awb;
          v_cargo_info.destn                   := i.destn;
          v_cargo_info.etd                     := i.etd;
          v_cargo_info.eta                     := i.eta;
          v_cargo_info.lc_no                   := i.lc_no;
          v_cargo_info.origin                  := i.origin;
          v_cargo_info.geog_cd                 := i.geog_cd;
          v_cargo_info.vessel_cd               := i.vessel_cd;
          v_cargo_info.voyage_no               := i.voyage_no;
          v_cargo_info.print_tag               := i.print_tag;
          v_cargo_info.cargo_type              := i.cargo_type;
          v_cargo_info.pack_method             := i.pack_method;
          v_cargo_info.inv_curr_rt             := i.inv_curr_rt;
          v_cargo_info.markup_rate             := i.markup_rate;
          v_cargo_info.deduct_text             := i.deduct_text;
          v_cargo_info.invoice_value           := i.invoice_value;
          v_cargo_info.cargo_class_cd          := i.cargo_class_cd;
          v_cargo_info.tranship_origin         := i.tranship_origin;
          v_cargo_info.tranship_destination    := i.tranship_destination;

          BEGIN

            SELECT item_title
              INTO v_cargo_info.item_title
              FROM gipi_item
             WHERE policy_id = i.policy_id
               AND item_no = i.item_no;

          EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_cargo_info.item_title    := '';
          END;

          BEGIN

            SELECT geog_desc
              INTO v_cargo_info.geog_desc
              FROM giis_geog_class
             WHERE geog_cd = i.geog_cd;

          EXCEPTION
          WHEN NO_DATA_FOUND
          THEN

            v_cargo_info.geog_desc := '';

          END;

          BEGIN

            SELECT cargo_class_desc
              INTO v_cargo_info.cargo_class_desc
              FROM giis_cargo_class
             WHERE cargo_class_cd = i.cargo_class_cd;

          EXCEPTION
          WHEN NO_DATA_FOUND
          THEN

            v_cargo_info.cargo_class_desc := '';

          END;

          BEGIN

            SELECT vessel_name
              INTO v_cargo_info.vessel_name
              FROM giis_vessel
             WHERE vessel_cd = i.vessel_cd;

          EXCEPTION
          WHEN NO_DATA_FOUND
          THEN

            v_cargo_info.vessel_name := '';

          END;

          BEGIN

            SELECT cargo_type_desc
              INTO v_cargo_info.cargo_type_desc
              FROM giis_cargo_type
             WHERE cargo_type = i.cargo_type;

          EXCEPTION
          WHEN NO_DATA_FOUND
          THEN

            v_cargo_info.cargo_type_desc := '';

          END;

          BEGIN

            SELECT SUBSTR (rv_meaning, 1, 25) meaning
              INTO v_cargo_info.print_desc
              FROM cg_ref_codes
             WHERE rv_domain LIKE 'GIPI_CARGO.PRINT_TAG'
               AND rv_low_value = TO_CHAR(i.print_tag); --added to_char to match datatype by robert SR 21699 03.08.16

          EXCEPTION
          WHEN NO_DATA_FOUND
          THEN

            v_cargo_info.print_desc := '';

          END;

          BEGIN

            SELECT b.short_name
              INTO v_cargo_info.short_name
              FROM gipi_cargo a, giis_currency b
             WHERE a.inv_curr_cd = b.main_currency_cd
               AND a.policy_id = i.policy_id
               AND a.item_no = i.item_no;

          EXCEPTION
          WHEN NO_DATA_FOUND
          THEN

            v_cargo_info.short_name := '';

          END;

          BEGIN

            SELECT param_value_v
              INTO v_vessel_cd
              FROM giis_parameters
             WHERE param_name = 'VESSEL_CD_MULTI';

          EXCEPTION
          WHEN NO_DATA_FOUND
          THEN

            v_vessel_cd := '';

          END;

          IF i.vessel_cd = v_vessel_cd THEN

             v_cargo_info.multi_carrier := 'yes';

          ELSE

             v_cargo_info.multi_carrier := 'no';

          END IF;

          PIPE ROW (v_cargo_info);
       END LOOP;
    END get_cargo_info;

END GIPI_CARGO_PKG;
/


