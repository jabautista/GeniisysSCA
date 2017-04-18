CREATE OR REPLACE PACKAGE BODY CPI.Giis_Risks_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS003
  RECORD GROUP NAME: RISKS_RG
***********************************************************************************/

  FUNCTION get_risk_list(p_block_id GIIS_RISKS.block_id%TYPE)
    RETURN risk_list_tab PIPELINED IS

	v_risk         risk_list_type;

  BEGIN
    FOR i IN (
        SELECT risk_cd, risk_desc
            FROM GIIS_RISKS
           WHERE block_id = p_block_id)
    LOOP
        v_risk.risk_cd          := i.risk_cd;
        v_risk.risk_desc     := i.risk_desc;
      PIPE ROW(v_risk);
    END LOOP;

    RETURN;
  END;

  FUNCTION get_all_risk_list
    RETURN all_risk_list_tab PIPELINED IS

    v_risk         all_risk_list_type;

  BEGIN
    FOR i IN (
        SELECT risk_cd, risk_desc, block_id
            FROM GIIS_RISKS
        ORDER BY /*block_id*/risk_desc)
    LOOP
        v_risk.risk_cd          := i.risk_cd;
        v_risk.risk_desc     := i.risk_desc;
        v_risk.block_id        := i.block_id;
      PIPE ROW(v_risk);
    END LOOP;

    RETURN;
  END;

    /*
    **  Created by        : Mark JM
    **  Date Created     : 03.16.2011
    **  Reference By     : (GIPIS003 - Item Information - Fire)
    **  Description     : Returns the risk description of the given block_id and risk_cd
    */
    FUNCTION get_risk_desc(
        p_block_id IN giis_risks.block_id%TYPE,
        p_risk_cd IN giis_risks.risk_cd%TYPE)
    RETURN giis_risks.risk_desc%TYPE
    IS
        v_risk_desc giis_risks.risk_desc%TYPE;
    BEGIN
        FOR i IN (
            SELECT risk_desc
              FROM giis_risks
             WHERE block_id = p_block_id
               AND risk_cd = p_risk_cd)
        LOOP
            v_risk_desc := i.risk_desc;
        END LOOP;

        RETURN v_risk_desc;
    END get_risk_desc;

    /*
    **  Created by      : Andrew Robes
    **  Date Created    : 4.26.2011
    **  Reference By    : (GIPIS039 - Item Information - Fire - Endt)
    **  Description     : Returns the list of risks per block
    */
  FUNCTION get_risk_listing(p_block_id GIIS_RISKS.block_id%TYPE,
                         p_find_text VARCHAR2)
    RETURN risk_list_tab PIPELINED IS

	v_risk         risk_list_type;

  BEGIN
    FOR i IN (
        SELECT risk_cd, risk_desc
            FROM GIIS_RISKS
           WHERE block_id = p_block_id
             AND (UPPER(risk_desc) LIKE UPPER(NVL(p_find_text, '%%'))
              OR UPPER(risk_cd) LIKE UPPER(NVL(p_find_text, '%%')))  --added by jeffdojello 03.31.2014
         ORDER BY risk_cd)
           --ORDER BY risk_desc)
    LOOP
        v_risk.risk_cd       := i.risk_cd;
        v_risk.risk_desc     := i.risk_desc;
      PIPE ROW(v_risk);
    END LOOP;

    RETURN;
  END get_risk_listing;

END Giis_Risks_Pkg;
/


