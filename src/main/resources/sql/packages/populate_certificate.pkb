CREATE OR REPLACE PACKAGE BODY CPI.POPULATE_CERTIFICATE AS
/******************************************************************************
   NAME:       POPULATE_CERTIFICATE
   PURPOSE:    For populating certificate documents

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        5/4/2011            Grace    Created this package.
******************************************************************************/

  FUNCTION Populate_Casualty_cert (p_policy_id    GIPI_POLBASIC.policy_id%TYPE)
    RETURN casualty_tab PIPELINED

  IS
       v_casualty    casualty_type;

  BEGIN

    FOR i IN (SELECT get_policy_no(A.policy_id) policy_no, E.assd_name, c.LOCATION,
                     b.item_title, G.short_name||' '||ltrim(to_char(b.tsi_amt,'99,999,999,999,999.99')) tsi_amt,
                     to_char(A.incept_date,'FMMONTH DD, YYYY')||' TO '||to_char(A.expiry_date,'FMMONTH DD, YYYY') effectivity,
                     f.mortg_name, to_char(A.issue_date,'FMMONTH DD, YYYY') issue_date,
                     To_Char(A.issue_date,'FmDdth')||' of '||To_Char(A.issue_date, 'FmMonth yyyy') issue_date_DDth, --* Added by Windell ON June 9, 2011
                     to_char(A.expiry_date,'FMMONTH DD, YYYY') expiry_date --added by gino
                FROM GIPI_POLBASIC A,
                     GIPI_ITEM b,
                     GIPI_CASUALTY_ITEM c,
                     GIPI_MORTGAGEE d,
                     GIIS_ASSURED E,
                     GIIS_MORTGAGEE f,
                     GIIS_CURRENCY G
               WHERE A.policy_id = b.policy_id
                 AND b.policy_id = c.policy_id
                 AND b.item_no = c.item_no
                 AND A.policy_id = d.policy_id(+)
                 /*AND (d.item_no = 0 OR
                      d.item_no = b.item_no)*/
                 AND A.assd_no  = E.assd_no
                 AND d.mortg_cd = f.mortg_cd(+)
                 AND b.currency_cd = G.main_currency_cd
                 AND A.policy_id = p_policy_id
              ORDER BY b.item_no asc)
    LOOP
          v_casualty.policy_no       := i.policy_no;
          v_casualty.assd_name       := i.assd_name;
          v_casualty.LOCATION        := i.LOCATION;
          v_casualty.item_title      := i.item_title;
          v_casualty.tsi_amt         := i.tsi_amt;
          v_casualty.effectivity     := i.effectivity;
          v_casualty.mortg_name      := i.mortg_name;
          v_casualty.issue_date      := i.issue_date;
          v_casualty.issue_date_DDth := i.issue_date_DDth; --* Added by Windell ON June 9, 2011
          v_casualty.expiry_date     := i.expiry_date;   --added by gino

          PIPE ROW (v_casualty);
    END LOOP;

  END Populate_Casualty_cert;


  FUNCTION Populate_Hull_cert (p_policy_id    GIPI_POLBASIC.policy_id%TYPE)
    RETURN hull_tab PIPELINED

  IS
       v_hull    hull_type;

  BEGIN

    FOR i IN (SELECT get_policy_no(A.policy_id) policy_no, E.assd_name,
                     A.address1||' '||A.address2||' '||A.address3 address,
                     G.short_name||' '||ltrim(to_char(b.tsi_amt,'99,999,999,999,999.99')) tsi_amt,
                     to_char(A.eff_date,'FMMONTH DD, YYYY') effectivity,
                     f.mortg_name, to_char(A.issue_date,'FMMONTH DD, YYYY') issue_date,
                     to_char(A.issue_date,'FmDdth')||' of '||to_char(A.issue_date,'FmMonth yyyy') issue_date_ii,--added by gino
                     h.vessel_name,
                     a.iss_cd,a.line_cd-- added by gino
                FROM GIPI_POLBASIC A,
                     GIPI_ITEM b,
                     GIPI_ITEM_VES c,
                     GIPI_MORTGAGEE d,
                     GIIS_ASSURED E,
                     GIIS_MORTGAGEE f,
                     GIIS_CURRENCY G,
                     GIIS_VESSEL h
               WHERE A.policy_id = b.policy_id
                 AND b.policy_id = c.policy_id
                 AND b.item_no = c.item_no
                 AND A.policy_id = d.policy_id(+)
                 /*AND (d.item_no = 0 OR
                      d.item_no = b.item_no)*/
                 AND A.assd_no  = E.assd_no
                 AND d.mortg_cd = f.mortg_cd(+)
                 AND b.currency_cd = G.main_currency_cd
                 AND c.vessel_cd = h.vessel_cd
                 AND A.policy_id = p_policy_id)
    LOOP
          v_hull.policy_no     := i.policy_no;
        v_hull.assd_name     := i.assd_name;
          v_hull.address      := i.address;
        v_hull.tsi_amt      := i.tsi_amt;
        v_hull.effectivity  := i.effectivity;
        v_hull.mortg_name   := i.mortg_name;
        v_hull.issue_date   := i.issue_date;
        v_hull.issue_date_ii   := i.issue_date_ii;
        v_hull.vessel_name  := i.vessel_name;
        v_hull.iss_cd  := i.iss_cd;--added by gino
        v_hull.line_cd  := i.line_cd;--added by gino
          PIPE ROW (v_hull);
    END LOOP;

  END Populate_Hull_cert;


  FUNCTION Populate_Aviation_cert (p_policy_id    GIPI_POLBASIC.policy_id%TYPE)
    RETURN aviation_tab PIPELINED

  IS
       v_aviation    aviation_type;

  BEGIN

    FOR i IN (SELECT get_policy_no(A.policy_id) policy_no, E.assd_name,
                     G.short_name||' '||ltrim(to_char(b.tsi_amt,'99,999,999,999,999.99')) tsi_amt,
                     to_char(A.eff_date,'FMMONTH DD, YYYY') effectivity,
                     i.air_desc, -- abie 06152011
                     h.year_built, h.rpc_no,
                     f.mortg_name, to_char(A.issue_date,'FMMONTH DD, YYYY') issue_date,
                     to_char(A.issue_date,'fmDdth')||' of '||to_char(A.issue_date,'FMMonth YYYY') issue_date_ii--added by gino
                FROM GIPI_POLBASIC A,
                     GIPI_ITEM b,
                     GIPI_AVIATION_ITEM c,
                     GIPI_MORTGAGEE d,
                     GIIS_ASSURED E,
                     GIIS_MORTGAGEE f,
                     GIIS_CURRENCY G,
                     GIIS_VESSEL h,
                     GIIS_AIR_TYPE i
               WHERE A.policy_id = b.policy_id
                 AND b.policy_id = c.policy_id
                 AND b.item_no = c.item_no(+)
                 AND A.policy_id = d.policy_id(+)
                 --AND (d.item_no = 0 OR
                 --     d.item_no = b.item_no)
                 AND A.assd_no  = E.assd_no
                 AND d.mortg_cd = f.mortg_cd(+)
                 AND b.currency_cd = G.main_currency_cd
                 AND c.vessel_cd = h.vessel_cd(+)
                 AND h.air_type_cd = i.air_type_cd(+) -- abie 06152011
                 AND A.policy_id = p_policy_id)
    LOOP
          v_aviation.policy_no     := i.policy_no;
        v_aviation.assd_name     := i.assd_name;
          v_aviation.tsi_amt      := i.tsi_amt;
        v_aviation.effectivity  := i.effectivity;
        v_aviation.air_desc := i.air_desc; -- ABIE 06152011
        v_aviation.year_built   := i.year_built;
        v_aviation.rpc_no       := i.rpc_no;
        v_aviation.mortg_name   := i.mortg_name;
        v_aviation.issue_date   := i.issue_date;
        v_aviation.issue_date_ii   := i.issue_date_ii;--added by gino
          PIPE ROW (v_aviation);
    END LOOP;

  END Populate_Aviation_cert;


  FUNCTION Populate_Accident_cert (p_policy_id    GIPI_POLBASIC.policy_id%TYPE)
    RETURN accident_tab PIPELINED

  IS
       v_accident    accident_type;

  BEGIN

    FOR i IN (SELECT get_policy_no(A.policy_id) policy_no, b.item_title,
                     b.item_no,             -- bmq 6/18/2011
                     A.address1||' '||A.address2||' '||A.address3 address,
                     d.position, to_char(c.date_of_birth,'FMMONTH DD, YYYY') birthday,
                     'From '||to_char(A.incept_date,'MM/DD/YYYY')||' To '||to_char(A.expiry_date,'MM/DD/YYYY') effectivity
                FROM GIPI_POLBASIC A,
                     GIPI_ITEM b,
                     GIPI_ACCIDENT_ITEM c,
                     GIIS_POSITION d
               WHERE A.policy_id = b.policy_id
                 AND b.policy_id = c.policy_id(+)
                 AND b.item_no = c.item_no(+)
                 AND c.position_cd = d.position_cd(+)
                 AND A.policy_id = p_policy_id)
    LOOP
          v_accident.policy_no     := i.policy_no;
          v_accident.item_no       := i.item_no;
        v_accident.item_title     := i.item_title;
          v_accident.address      := i.address;
        v_accident.position     := i.position;
        v_accident.birthday     := i.birthday;
        v_accident.effectivity  := i.effectivity;
          PIPE ROW (v_accident);
    END LOOP;

  END Populate_Accident_cert;

  FUNCTION Populate_Accident_cert_one (p_policy_id    GIPI_POLBASIC.policy_id%TYPE)
    RETURN accident_tab PIPELINED

  IS
       v_accident    accident_type;
       v_temp_count       number    := 0;

  BEGIN

    select count(1) into v_temp_count from gipi_item
        where policy_id = p_policy_id;

    FOR i IN (SELECT get_policy_no(A.policy_id) policy_no, b.item_title,
                     B.item_no,             -- bmq 06/18/2011
                     A.address1||' '||A.address2||' '||A.address3 address,
                     d.position, to_char(c.date_of_birth,'FMMONTH DD, YYYY') birthday,
                     'From '||to_char(A.incept_date,'MM/DD/YYYY')||' To '||to_char(A.expiry_date,'MM/DD/YYYY') effectivity
                FROM GIPI_POLBASIC A,
                     GIPI_ITEM b,
                     GIPI_ACCIDENT_ITEM c,
                     GIIS_POSITION d
               WHERE A.policy_id = b.policy_id
                 AND b.policy_id = c.policy_id(+)
                 AND b.item_no = c.item_no(+)
                 AND c.position_cd = d.position_cd(+)
                 AND A.policy_id = p_policy_id)
    LOOP

        if v_temp_count <> 1 then
          v_accident.item_title   := 'VARIOUS';
          v_accident.address      := 'VARIOUS';
          v_accident.position     := 'VARIOUS';
          v_accident.birthday     := ' ';
        else
          v_accident.item_title   := i.item_title;
          v_accident.address      := i.address;
          v_accident.position     := i.position;
          v_accident.birthday     := i.birthday;
        end if;
          v_accident.item_no       := i.item_no;
          v_accident.policy_no    := i.policy_no;
          v_accident.effectivity  := i.effectivity;
          PIPE ROW (v_accident);

    END LOOP;

  END Populate_Accident_cert_one;

  FUNCTION Populate_Engineering_cert (p_policy_id    GIPI_POLBASIC.policy_id%TYPE)
    RETURN engineering_tab PIPELINED

  IS
       v_engineering    engineering_type;

  BEGIN

    FOR i IN (SELECT get_policy_no(A.policy_id) policy_no, f.assd_name,
                     b.site_location,
                     to_char(A.incept_date,'FMMONTH DD, YYYY')||' TO '||to_char(A.expiry_date,'FMMONTH DD, YYYY') effectivity,
                     E.mortg_name,
                     to_char(A.eff_date,'FMMONTH DD, YYYY') eff_date, --added by gino
                     to_char(A.issue_date,'FMMONTH DD, YYYY') issue_date,--added by gino
                     To_Char(A.issue_date,'FmDdth')||' of '||To_Char(A.issue_date, 'FmMonth yyyy') issue_date_DDth --* Added by Windell ON June 9, 2011
                FROM GIPI_POLBASIC A,
                     GIPI_ENGG_BASIC b,
                     GIPI_MORTGAGEE c,
                     GIPI_ITEM d,
                     GIIS_MORTGAGEE E,
                     giis_assured f
               WHERE A.policy_id = b.policy_id(+)
                 AND A.policy_id = d.policy_id
                 AND A.policy_id = c.policy_id(+)
              /*   AND (c.item_no  = 0 OR
                      c.item_no  = d.item_no)   */
                 AND c.mortg_cd  = E.mortg_cd(+)
                 AND A.assd_no   = f.assd_no
                 AND A.policy_id = p_policy_id)
    LOOP
        v_engineering.policy_no     := i.policy_no;
        v_engineering.assd_name     := i.assd_name;
        v_engineering.site_location := i.site_location;
        v_engineering.effectivity   := i.effectivity;
        v_engineering.mortg_name    := i.mortg_name;
        v_engineering.eff_date    := i.eff_date; --added by gino
        v_engineering.issue_date    := i.issue_date; --added by gino
        v_engineering.issue_date_DDth := i.issue_date_DDth; --* Added by Windell ON June 9, 2011
        PIPE ROW (v_engineering);
    END LOOP;

  END Populate_Engineering_cert;


  FUNCTION Populate_Fire_cert (p_policy_id    GIPI_POLBASIC.policy_id%TYPE)
    RETURN fire_tab PIPELINED

  IS
       v_fire      fire_type;

  BEGIN
    FOR i IN (SELECT get_policy_no(A.policy_id) policy_no, f.assd_name,
                     b.loc_risk1||' '||b.loc_risk2||' '||b.loc_risk3 loc_risk,
                     to_char(A.incept_date,'FMMONTH DD, YYYY')||' TO '||to_char(A.expiry_date,'FMMONTH DD, YYYY') effectivity,
                     E.mortg_name, TO_CHAR(A.issue_date,'ddth') issue_day,
                     TO_CHAR(A.issue_date,'fmMonth yyyy') issue_month_year
                FROM GIPI_POLBASIC A,
                     GIPI_FIREITEM b,
                     GIPI_MORTGAGEE c,
                     GIPI_ITEM d,
                     GIIS_MORTGAGEE E,
                     giis_assured f
               WHERE A.policy_id = d.policy_id
                 AND d.policy_id = b.policy_id
                 AND A.policy_id = c.policy_id(+)
                 /*AND (c.item_no  = 0 OR
                      c.item_no  = d.item_no)*/
                 AND c.mortg_cd  = E.mortg_cd(+)
                 AND A.assd_no   = f.assd_no
                 AND A.policy_id = p_policy_id)
    LOOP
          v_fire.policy_no         := i.policy_no;
        v_fire.assd_name         := i.assd_name;
          v_fire.loc_risk         := i.loc_risk;
        v_fire.effectivity      := i.effectivity;
        v_fire.mortg_name       := i.mortg_name;
        v_fire.issue_day        := i.issue_day;
        v_fire.issue_month_year := i.issue_month_year;
          PIPE ROW (v_fire);
    END LOOP;

  END Populate_Fire_cert;


  FUNCTION Populate_Cargo_cert (p_policy_id    GIPI_POLBASIC.policy_id%TYPE)
    RETURN cargo_tab PIPELINED

  IS
       v_cargo      cargo_type;

  BEGIN
    FOR i IN (
        SELECT a.policy_id, get_policy_no(A.policy_id) policy_no, E.assd_name, b.item_no, b.item_title,
               d.iss_cd||'-'||d.prem_seq_no invoice,
               c.origin origin,
               c.destn destn,
               G.vestype_desc,
               h.short_name, b.tsi_amt,
               TO_CHAR(A.issue_date,'ddth') issue_day,
               TO_CHAR(A.issue_date,'fmMonth yyyy') issue_month_year
          FROM gipi_polbasic a,
               gipi_item b,
               gipi_cargo c,
               gipi_invoice d,
               giis_assured e,
               giis_vessel f,
               giis_vestype g,
               giis_currency h
         WHERE a.policy_id = b.policy_id
           AND a.policy_id = c.policy_id(+)
           AND a.policy_id = d.policy_id
           AND a.assd_no = e.assd_no(+)
           AND c.vessel_cd = f.vessel_cd(+)
           AND f.vestype_cd = g.vestype_cd(+)
           AND b.currency_cd = h.main_currency_cd(+)
           AND a.policy_id = p_policy_id)
    LOOP
        v_cargo.policy_id        := i.policy_id;
        v_cargo.item_no            := i.item_no;
          v_cargo.policy_no          := i.policy_no;
        v_cargo.assd_name          := i.assd_name;
        v_cargo.item_title          := i.item_title;
          v_cargo.invoice          := i.invoice;
        v_cargo.origin           := i.origin;
        v_cargo.destn            := i.destn;
        v_cargo.vestype_desc     := i.vestype_desc;
        v_cargo.tsi_amt          := i.tsi_amt;
        v_cargo.issue_day        := i.issue_day;
        v_cargo.issue_month_year := i.issue_month_year;
          PIPE ROW (v_cargo);
    END LOOP;

  END Populate_Cargo_cert;


  FUNCTION Populate_Itmperil (p_policy_id    GIPI_POLBASIC.policy_id%TYPE,
                              p_item_no      GIPI_ITEM.item_no%TYPE)
    RETURN itmperil_tab PIPELINED

  IS
       v_itmperil    itmperil_type;

  BEGIN

    FOR i IN (SELECT b.policy_id, b.item_no, c.peril_name, ltrim(to_char(b.tsi_amt,'99,999,999,999,999.99')) tsi_amt,
                     d.short_name, ltrim(to_char(E.prem_amt+E.tax_amt,'99,999,999,999.99')) prem_amt
                FROM GIPI_ITEM A,
                     GIPI_ITMPERIL b,
                     GIIS_PERIL c,
                     GIIS_CURRENCY d,
                     GIPI_INVOICE E
               WHERE A.policy_id   = b.policy_id
                 AND A.item_no     = b.item_no
                 AND b.line_cd     = c.line_cd
                 AND b.peril_cd    = c.peril_cd
                 AND A.currency_cd = d.main_currency_cd
                 AND A.policy_id   = E.policy_id
                 AND A.item_grp    = E.item_grp
                 AND A.policy_id   = p_policy_id
                 AND A.item_no     = p_item_no)
    LOOP
        v_itmperil.policy_id        := i.policy_id;
        v_itmperil.item_no            := i.item_no;
          v_itmperil.peril_name     := i.peril_name;
        v_itmperil.tsi_amt       := i.tsi_amt;
          v_itmperil.short_name   := i.short_name;
        v_itmperil.prem_amt     := i.prem_amt;
          PIPE ROW (v_itmperil);
    END LOOP;

  END Populate_Itmperil;


  FUNCTION Populate_text_for_Signatory (p_iss_cd    GIIS_SIGNATORY.iss_cd%TYPE,
                                        p_line_cd   GIIS_SIGNATORY.line_cd%TYPE)
        RETURN signatory_tab PIPELINED

  IS
    v_signatory    signatory_type;

  BEGIN

    FOR i IN (SELECT b.signatory, b.designation
                    ,b.res_cert_no, b.res_cert_place, b.res_cert_date
                  FROM giis_signatory A,
                        giis_signatory_names b
                 WHERE A.line_cd = p_line_cd
                     AND A.iss_cd = nvl(p_iss_cd, A.iss_cd)
                     AND NVL(A.current_signatory_sw,'N') = 'Y'
                     AND A.signatory_id = b.signatory_id
                 )
    LOOP
          v_signatory.signatory       := i.signatory;
          v_signatory.designation   := i.designation;
          v_signatory.res_cert_no   := i.res_cert_no;
        v_signatory.res_cert_place:= i.res_cert_place;
        v_signatory.res_cert_date := i.res_cert_date;
       PIPE ROW (v_signatory);

    END LOOP;

  END Populate_text_for_Signatory;


  FUNCTION get_spelled_number(p_number IN VARCHAR2)
    RETURN VARCHAR2 AS

    TYPE string_array IS TABLE OF varchar2(255);

    v_string  string_array := string_array('',
                                         ' THOUSAND ',      ' MILLION ',
                                         ' BILLION ',       ' TRILLION ',
                                         ' QUADRILLION ',   ' QUINTILLION ',
                                         ' SEXTILLION ',    ' SEPTILLION ',
                                         ' OCTILLION ',     ' NONILLION ',
                                         ' DECILLION ',     ' UNDECILLION ',
                                         ' DUODECILLION ',  ' TRIDECILLION ',
                                         ' QUADDECILLION ', ' QUINDECILLION ',
                                         ' SEXDECILLION ',  ' SEPTDECILLION ',
                                         ' OCTDECILLION ',  ' NONDECILLION ',
                                         ' DEDECILLION ');
     v_number  VARCHAR2(255);
     v_return  VARCHAR2(4000);
   BEGIN
     IF INSTR(p_number, '.') = 0 THEN
        v_number := p_number;
     ELSE
        v_number := SUBSTR(p_number, 1, INSTR(p_number, '.')-1);
     END IF;
  --
     IF v_number = '0' OR v_number IS NULL THEN
        v_return := 'zero';
     ELSE
        FOR i IN 1 .. v_string.COUNT LOOP
          EXIT WHEN v_number IS NULL;
      --
          IF (SUBSTR(v_number, LENGTH(v_number)-2, 3) <> 0) THEN
             v_return := UPPER(TO_CHAR(TO_DATE(SUBSTR(v_number, LENGTH(v_number)-2, 3), 'j'), 'jsp')) ||
                    v_string(i) || v_return;
          END IF;
          v_number := SUBSTR(v_number, 1, LENGTH(v_number)-3);
        END LOOP;
     END IF;

     -- to include decimal places.

     IF p_number LIKE '%.%' THEN
        v_number := SUBSTR(p_number, instr(p_number, '.')+1);
        v_return := v_return ||' AND';
    FOR i IN 1 .. length(v_number)
    LOOP
      exit WHEN v_number IS NULL;
      IF substr(v_number, 1, 1) = '0' THEN
        v_return := v_return ||' zero';
      ELSE
        v_return := v_return ||' '||v_number||'/100';
      END IF;
      RETURN v_return;
    END LOOP;
  ELSE
    IF v_number IS NULL THEN
        v_return := v_return||' AND 00/100';
    ELSE
      v_return := v_return||' '||v_number||'/100';
    END IF;
  RETURN v_return;
  END IF;
END get_spelled_number;

FUNCTION populate_mc_cert (       ---------------------------Populate_MC_cert---------gino 5.10.11
   p_policy_id   gipi_polbasic.policy_id%TYPE--,
   --p_item_no     gipi_item.item_no%TYPE
)
   RETURN mc_tab PIPELINED
IS
   v_mc   mc_type;
BEGIN
   FOR i IN (SELECT a.policy_id, b.item_no,
                    get_policy_no (a.policy_id) policy_no, b.item_title,
                    c.assd_name, d.plate_no, e.color, d.motor_no,
                    --g.mortg_name,
                       TO_CHAR (a.issue_date, 'FmDdth')
                    || ' day of '
                    || TO_CHAR (a.issue_date, 'FmMonth, yyyy') issue_date,
                       TO_CHAR (a.incept_date,
                                'FmMonth dd, yyyy')
                    || ' - '
                    || TO_CHAR (a.expiry_date, 'FMYYYY') effectivity,
                    d.serial_no, f.mortg_cd, a.iss_cd
               FROM gipi_polbasic a,
                    gipi_item b,
                    giis_assured c,
                    gipi_vehicle d,
                    giis_mc_color e,
                    gipi_mortgagee f/*,
                    giis_mortgagee g*/
              WHERE 1 = 1
                AND a.policy_id = b.policy_id
                AND a.policy_id = f.policy_id(+)
                AND a.policy_id = d.policy_id
                --AND f.mortg_cd = g.mortg_cd(+)
                AND a.assd_no = c.assd_no
                AND d.color_cd = e.color_cd(+)
                AND b.item_no = d.item_no
                --AND a.iss_cd = f.iss_cd(+)
                AND a.policy_id = p_policy_id
                --AND b.item_no = p_item_no
                --AND a.line_cd = 'MC'
              ORDER BY b.item_no
           )
   LOOP
      v_mc.policy_id := i.policy_id;
      v_mc.item_no := i.item_no;
      v_mc.policy_no := i.policy_no;
      v_mc.item_title := i.item_title;
      v_mc.assd_name := i.assd_name;
      v_mc.plate_no := i.plate_no;
      v_mc.color := i.color;
      v_mc.motor_no := i.motor_no;
      --v_mc.mortg_name := i.mortg_name;

      BEGIN
        SELECT mortg_name INTO v_mc.mortg_name
          FROM giis_mortgagee
         WHERE mortg_cd = i.mortg_cd
           AND iss_cd = i.iss_cd;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
                NULL;
      END;

      v_mc.issue_date := i.issue_date;
      v_mc.effectivity := i.effectivity;
      v_mc.serial_no := i.serial_no;
      PIPE ROW (v_mc);
   END LOOP;
END populate_mc_cert;       ---------Populate_MC_cert---------end gino 5.10.11

FUNCTION populate_bond_cert (p_policy_id   gipi_polbasic.policy_id%TYPE) -- start --
   RETURN bond_tab PIPELINED
IS
   v_bond   bond_type;
BEGIN
   FOR i IN (select  A.POLICY_ID, A.ISS_CD, A.LINE_CD, get_policy_no(A.policy_id) policy_no, F.assd_name,
                E.SUBLINE_NAME, G.short_name||' '||ltrim(to_char(H.BOND_TSI_AMT ,'99,999,999,999,999.99')) tsi_amt,
                A.EFF_DATE, A.EXPIRY_DATE,   B.CONTRACT_DTL,
                J.INTM_NAME, C.PRIN_SIGNOR,D.OBLIGEE_NAME, B.BOND_DTL,
                B.INDEMNITY_TEXT, B.REMARKS
                from gipi_polbasic a
                    , gipi_bond_basic b
                    , GIIS_PRIN_SIGNTRY C
                    , GIIS_OBLIGEE D
                    , GIIS_SUBLINE E
                    , GIIS_ASSURED F
                    , GIIS_CURRENCY G
                    , GIPI_INVOICE H
                    , GIPI_COMM_INVOICE I
                    , GIIS_INTERMEDIARY J
                where A.POLICY_ID = b.policy_id
                AND B.PRIN_ID = C.PRIN_ID
                AND B.OBLIGEE_NO = D.OBLIGEE_NO
                AND A.SUBLINE_CD = E.SUBLINE_CD
                AND A.ASSD_NO = F.ASSD_NO
                AND A.POLICY_ID = H.POLICY_ID
                AND h.currency_cd = G.main_currency_cd
                AND A.POLICY_ID = I.POLICY_ID
                AND I.INTRMDRY_INTM_NO = J.INTM_NO
                AND A.POLICY_ID = P_POLICY_ID
            )
   LOOP
      v_bond.policy_id := i.policy_id;
      v_bond.iss_cd := i.iss_cd;
      v_bond.line_cd := i.line_cd;
      v_bond.policy_no := i.policy_no;
      v_bond.assd_name := i.assd_name;
      v_bond.subline_name := i.subline_name;
      v_bond.tsi_amt := i.tsi_amt;
      v_bond.EFF_DATE := i.EFF_DATE;
      v_bond.EXPIRY_DATE := i.EXPIRY_DATE;
      v_bond.CONTRACT_DTL := i.CONTRACT_DTL;
      v_bond.INTM_NAME := i.INTM_NAME;
      v_bond.PRIN_SIGNOR := i.PRIN_SIGNOR;
      v_bond.OBLIGEE_NAME := i.OBLIGEE_NAME;
      v_bond.BOND_DTL := i.BOND_DTL;
      v_bond.INDEMNITY_TEXT := i.INDEMNITY_TEXT;
      v_bond.remarks        := i.remarks;

      PIPE ROW (v_bond);
   END LOOP;
END populate_bond_cert;

FUNCTION populate_text_for_or (p_policy_id   gipi_polbasic.policy_id%TYPE)
   RETURN or_tab PIPELINED
IS
   v_or   or_type;
BEGIN
   FOR i IN (select  NVL(C.INST_NO, ROWNUM) ROW_NUM, get_policy_no(A.policy_id) policy_no,
                A.EFF_DATE, A.EXPIRY_DATE, TRUNC(D.OR_DATE) OR_DATE,
                DECODE(D.OR_NO, NULL, '', OR_PREF_SUF||'-'||D.OR_NO) OR_NO
                from gipi_polbasic a
                    , GIPI_INVOICE B
                    , GIAC_DIRECT_PREM_COLLNS C
                    , GIAC_ORDER_OF_PAYTS D
                where A.POLICY_ID = B.POLICY_ID
                AND B.ISS_CD = C.B140_ISS_CD(+)
                AND B.PREM_SEQ_NO = C.B140_PREM_SEQ_NO(+)
                AND C.GACC_TRAN_ID = D.GACC_TRAN_ID(+)
                AND NVL(OR_FLAG, 'P') = 'P'
                AND A.POLICY_ID = P_POLICY_ID
            )
   LOOP
      v_or.row_num := i.row_num;
      v_or.policy_no := i.policy_no;
      v_or.EFF_DATE := i.EFF_DATE;
      v_or.EXPIRY_DATE := i.EXPIRY_DATE;
      v_or.OR_DATE := i.OR_DATE;
      v_or.OR_NO := i.OR_NO;

      PIPE ROW (v_or);
   END LOOP;
END populate_text_for_or;
-- end of modification--
-- abie 06212011 --

  END POPULATE_CERTIFICATE;
/


