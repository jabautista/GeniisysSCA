CREATE OR REPLACE PACKAGE BODY CPI.giri_inpolbas_pkg
AS

   /**
    **  Created by      : Niknok Orio
    **  Date Created    : 10.11.2011
    **  Reference By    : (GICLS010 - Claims Basic Information)
    **  Description     :
    **/
    PROCEDURE get_cedant(
        p_line_cd           IN      GIPI_POLBASIC.line_cd%TYPE,
        p_subline_cd        IN      GIPI_POLBASIC.subline_cd%TYPE,
        p_pol_iss_cd        IN      GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy          IN      GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no        IN      GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no          IN      GIPI_POLBASIC.renew_no%TYPE,
        p_ri_cd             OUT     giri_inpolbas.ri_cd%TYPE,
        p_dsp_ri_name       OUT     giis_reinsurer.ri_name%TYPE
        ) IS
    BEGIN
       FOR a1 IN (SELECT d070.ri_cd ri
                    FROM giri_inpolbas d070,
                         gipi_polbasic a
                   WHERE d070.policy_id = a.policy_id
                     AND a.renew_no = p_renew_no
                     AND a.pol_seq_no = p_pol_seq_no
                     AND a.issue_yy = p_issue_yy
                     AND a.iss_cd = p_pol_iss_cd
                     AND a.subline_cd = p_subline_cd
                     AND a.line_cd = p_line_cd)
       LOOP
          p_ri_cd := a1.ri;

          FOR ri IN (SELECT ri_name
                       FROM giis_reinsurer
                      WHERE ri_cd = a1.ri)
          LOOP
             p_dsp_ri_name := ri.ri_name;
          END LOOP;
          EXIT;
       END LOOP;
    END;

    /**
    **  Created by      : Marco Paolo Rebong
    **  Date Created    : 04.25.2012
    **  Reference By    : (GIPIS901A - UW Production Reports)
    **  Description     : Cedant LOV
    **/
    FUNCTION get_cedant_listing
      RETURN cedant_tab PIPELINED AS
        v_cedant            cedant_type;
    BEGIN
        FOR i IN(SELECT DISTINCT a.ri_cd,
                                 b.ri_name
                   FROM GIRI_INPOLBAS a,
                        GIIS_REINSURER b
                  WHERE a.ri_cd = b.ri_cd
                  ORDER BY ri_name)
        LOOP
            v_cedant.ri_cd := i.ri_cd;
            v_cedant.ri_name := i.ri_name;
            PIPE ROW(v_cedant);
        END LOOP;
        RETURN;
    END;

    /**
    **  Created by      : Marco Paolo Rebong
    **  Date Created    : 04.25.2012
    **  Reference By    : (GIPIS901A - UW Production Reports)
    **  Description     : Validate Cedant RI_CD
    **/
    PROCEDURE validate_cedant(
        p_ri_cd         IN      GIRI_INPOLBAS.ri_cd%TYPE,
        p_ri_name       OUT     GIIS_REINSURER.ri_name%TYPE
    )
    IS
    BEGIN
        SELECT ri_name
          INTO p_ri_name
          FROM GIIS_REINSURER
         WHERE ri_cd = p_ri_cd;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_ri_name := NULL;
    END;

END giri_inpolbas_pkg;
/


