CREATE OR REPLACE PACKAGE BODY CPI.GIPI_WCARGO_CARRIER_PKG
AS
    /*
    **  Created by        : Jerome Orio
    **  Date Created     : 04.14.2010
    **  Reference By     : (GIPIS006- Item Information - Maring Cargo)
    **  Description     : Delete PAR record listing for MARINE CARGO
    */
  PROCEDURE del_gipi_wcargo_carrier(p_par_id    GIPI_WCARGO_CARRIER.par_id%TYPE,
                                      p_item_no   GIPI_WCARGO_CARRIER.item_no%TYPE)
            IS
  BEGIN
    DELETE GIPI_WCARGO_CARRIER
     WHERE PAR_ID  =  p_par_id
       AND ITEM_NO =  p_item_no;
  END;

    /*
    **  Created by        : Jerome Orio
    **  Date Created     : 04.14.2010
    **  Reference By     : (GIPIS006- Item Information - Maring Cargo)
    **  Description     : Delete PAR record listing for MARINE CARGO
    */
  PROCEDURE del_gipi_wcargo_carrier2(p_par_id    GIPI_WCARGO_CARRIER.par_id%TYPE,
                                       p_item_no   GIPI_WCARGO_CARRIER.item_no%TYPE,
                                     p_vessel_cd GIPI_WCARGO_CARRIER.vessel_cd%TYPE)
            IS
  BEGIN
    DELETE GIPI_WCARGO_CARRIER
     WHERE PAR_ID  =  p_par_id
       AND ITEM_NO =  p_item_no
       AND VESSEL_CD = p_vessel_cd;
  END;

    /*
    **  Created by        : Jerome Orio
    **  Date Created     : 04.14.2010
    **  Reference By     : (GIPIS006- Item Information - Maring Cargo)
    **  Description     :Get PAR record listing for MARINE CARGO
    */
  FUNCTION get_gipi_wcargo_carrier(p_par_id    GIPI_WCARGO_CARRIER.par_id%TYPE)
    RETURN gipi_carrier_list_tab PIPELINED IS
    v_carrier    gipi_carrier_list_type;
  BEGIN
      FOR i IN (SELECT a.par_id,            a.item_no,         a.vessel_cd,         a.vessel_limit_of_liab,
                        a.eta,            a.etd,             a.origin,                 a.destn,
                     a.delete_sw,        a.voy_limit,        a.user_id,
                     b.vessel_name,    b.plate_no,         b.motor_no,             b.serial_no
                FROM GIPI_WCARGO_CARRIER a,
                     GIIS_VESSEL b
               WHERE a.par_id = p_par_id
                 AND a.vessel_cd = b.vessel_cd)
    LOOP
      v_carrier.par_id                    := i.par_id;
      v_carrier.item_no                    := i.item_no;
      v_carrier.vessel_cd                := i.vessel_cd;
      v_carrier.vessel_limit_of_liab    := i.vessel_limit_of_liab;
      v_carrier.eta                        := i.eta;
      v_carrier.etd                        := i.etd;
      v_carrier.origin                    := i.origin;
      v_carrier.destn                    := i.destn;
      v_carrier.delete_sw                := i.delete_sw;
      v_carrier.voy_limit                := i.voy_limit;
      v_carrier.vessel_name                := i.vessel_name;
      v_carrier.plate_no                := i.plate_no;
      v_carrier.motor_no                := i.motor_no;
      v_carrier.serial_no                := i.serial_no;
      v_carrier.user_id                    := i.user_id;
      PIPE ROW(v_carrier);
    END LOOP;
    RETURN;
  END;

    /*
    **  Created by        : Jerome Orio
    **  Date Created     : 04.14.2010
    **  Reference By     : (GIPIS006- Item Information - Maring Cargo)
    **  Description     : Insert PAR record listing for MARINE CARGO CARRIER
    */
  PROCEDURE set_gipi_cargo_carrier(
                       p_par_id                   GIPI_WCARGO_CARRIER.par_id%TYPE,
                     p_item_no                      GIPI_WCARGO_CARRIER.item_no%TYPE,
                    p_vessel_cd                GIPI_WCARGO_CARRIER.vessel_cd%TYPE,
                     p_vessel_limit_of_liab     GIPI_WCARGO_CARRIER.vessel_limit_of_liab%TYPE,
                     p_eta                          GIPI_WCARGO_CARRIER.eta%TYPE,
                     p_etd                          GIPI_WCARGO_CARRIER.etd%TYPE,
                     p_origin                   GIPI_WCARGO_CARRIER.origin%TYPE,
                     p_destn                          GIPI_WCARGO_CARRIER.destn%TYPE,
                     p_delete_sw                      GIPI_WCARGO_CARRIER.delete_sw%TYPE,
                     p_voy_limit                      GIPI_WCARGO_CARRIER.voy_limit%TYPE,
                    p_user_id                   VARCHAR2
                    )
         IS
  BEGIN
    MERGE INTO GIPI_WCARGO_CARRIER
        USING dual ON (par_id       = p_par_id
                    AND item_no   = p_item_no
                    AND vessel_cd = p_vessel_cd)
        WHEN NOT MATCHED THEN
            INSERT (par_id,                       item_no,    vessel_cd,
                       vessel_limit_of_liab,     eta,         etd,
                    origin,                 destn,         delete_sw,
                    voy_limit,                user_id,    last_update)
            VALUES (p_par_id,                   p_item_no,    p_vessel_cd,
                       p_vessel_limit_of_liab, p_eta,         p_etd,
                    p_origin,                 p_destn,     p_delete_sw,
                    p_voy_limit,            p_user_id,    sysdate)
        WHEN MATCHED THEN
            UPDATE SET
                   vessel_limit_of_liab = p_vessel_limit_of_liab,
                   eta                    = p_eta,
                   etd                    = p_etd,
                   origin                = p_origin,
                   destn                = p_destn,
                   delete_sw            = p_delete_sw,
                   voy_limit            = p_voy_limit,
                   user_id                = p_user_id,
                   last_update            = sysdate;
  END set_gipi_cargo_carrier;

    /*    Date        Author            Description
    **    ==========    ===============    ============================
    **    09.21.2011    mark jm            retrieve records on gipi_wcargo_carriers based on given parameters (tablegrid version)
    **    09.23.2011    mark jm            modified sql stmt by adding nvl for columns in the left side
    */
    FUNCTION get_gipi_wcargo_carrier_tg(
        p_par_id IN gipi_wcargo_carrier.par_id%TYPE,
        p_item_no IN gipi_wcargo_carrier.item_no%TYPE,
        p_vessel_name IN VARCHAR2,
        p_plate_no IN VARCHAR2,
        p_motor_no IN VARCHAR2,
        p_serial_no IN VARCHAR2)
    RETURN gipi_carrier_list_tab PIPELINED
    IS
        v_carrier gipi_carrier_list_type;
    BEGIN
        FOR i IN (
            SELECT a.par_id,        a.item_no,        a.vessel_cd,    a.vessel_limit_of_liab,
                   a.eta,            a.etd,            a.origin,        a.destn,
                   a.delete_sw,        a.voy_limit,    a.user_id,
                   b.vessel_name,    b.plate_no,        b.motor_no,        b.serial_no
                FROM gipi_wcargo_carrier a,
                     giis_vessel b
               WHERE a.par_id = p_par_id
                 AND a.item_no = p_item_no
                 AND a.vessel_cd = b.vessel_cd
                 AND UPPER(NVL(b.vessel_name, '***')) LIKE NVL(UPPER(p_vessel_name), '%%')
                 AND UPPER(NVL(b.plate_no, '***')) LIKE NVL(UPPER(p_plate_no), '%%')
                 AND UPPER(NVL(b.motor_no, '***')) LIKE NVL(UPPER(p_motor_no), '%%')
                 AND UPPER(NVL(b.serial_no, '***')) LIKE NVL(UPPER(p_serial_no), '%%'))
        LOOP
            v_carrier.par_id                := i.par_id;
            v_carrier.item_no                := i.item_no;
            v_carrier.vessel_cd                := i.vessel_cd;
            v_carrier.vessel_limit_of_liab    := i.vessel_limit_of_liab;
            v_carrier.eta                    := i.eta;
            v_carrier.etd                    := i.etd;
            v_carrier.origin                := i.origin;
            v_carrier.destn                    := i.destn;
            v_carrier.delete_sw                := i.delete_sw;
            v_carrier.voy_limit                := i.voy_limit;
            v_carrier.vessel_name            := i.vessel_name;
            v_carrier.plate_no                := i.plate_no;
            v_carrier.motor_no                := i.motor_no;
            v_carrier.serial_no                := i.serial_no;
            v_carrier.user_id                := i.user_id;
            PIPE ROW(v_carrier);
        END LOOP;
        RETURN;
    END get_gipi_wcargo_carrier_tg;
END gipi_wcargo_carrier_pkg;
/


