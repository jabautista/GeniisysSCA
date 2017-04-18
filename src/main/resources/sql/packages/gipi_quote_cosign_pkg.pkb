CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Quote_Cosign_Pkg AS

  FUNCTION get_gipi_quote_cosign (p_quote_id   GIPI_QUOTE.quote_id%TYPE,
  		   						  p_assd_no	   GIIS_COSIGNOR_RES.assd_no%TYPE)
    RETURN gipi_quote_cosign_tab PIPELINED IS

	v_cosign 	 gipi_quote_cosign_type;

  BEGIN
    FOR i IN (
		SELECT a.quote_id,   a.cosign_id,  b.cosign_name,
			   a.indem_flag, a.bonds_flag, a.bonds_ri_flag
		  FROM GIPI_QUOTE_COSIGN a,
		  	   GIIS_COSIGNOR_RES b
		 WHERE a.quote_id = p_quote_id
		   AND b.assd_no = p_assd_no
		   AND a.cosign_id = b.cosign_id)
	LOOP
		v_cosign.quote_id                := i.quote_id;
	 	v_cosign.cosign_id        	  	 := i.cosign_id;
	 	v_cosign.cosign_name			 := i.cosign_name;
	 	v_cosign.indem_flag				 := i.indem_flag;
	 	v_cosign.bonds_flag			 	 := i.bonds_flag;
	 	v_cosign.bonds_ri_flag			 := i.bonds_ri_flag;
	  PIPE ROW(v_cosign);
	END LOOP;

    RETURN;
  END get_gipi_quote_cosign;


  FUNCTION get_gipi_quote_cosign (p_quote_id   GIPI_QUOTE.quote_id%TYPE)
    RETURN gipi_quote_cosign_tab PIPELINED IS
	v_cosign 	 gipi_quote_cosign_type;
  BEGIN
    FOR i IN (
		SELECT a.quote_id,   a.cosign_id,  b.cosign_name,
			   a.indem_flag, a.bonds_flag, a.bonds_ri_flag,
               a.assd_no
		  FROM GIPI_QUOTE_COSIGN a,
		  	   GIIS_COSIGNOR_RES b
		 WHERE a.quote_id = p_quote_id
           AND a.assd_no = b.assd_no(+)
		   AND a.cosign_id = b.cosign_id)
	LOOP
		v_cosign.quote_id                := i.quote_id;
	 	v_cosign.cosign_id        	  	 := i.cosign_id;
	 	v_cosign.cosign_name			 := i.cosign_name;
        v_cosign.cosign_name			 := i.cosign_name;
	 	v_cosign.indem_flag				 := i.indem_flag;
	 	v_cosign.bonds_flag			 	 := i.bonds_flag;
	 	v_cosign.bonds_ri_flag			 := i.bonds_ri_flag;
	  PIPE ROW(v_cosign);
	END LOOP;
    RETURN;
  END get_gipi_quote_cosign;

    /*
    **  Created by      : Jerome Orio
    **  Date Created    : 03.09.2011
    **  Reference By    : (GIIMM011 - Bond Policy Data)
    **  Description     : Delete record based on given parameters
    */
  PROCEDURE del_gipi_quote_cosign(
    p_quote_id      GIPI_QUOTE_COSIGN.quote_id%TYPE,
    p_cosign_id     GIPI_QUOTE_COSIGN.cosign_id%TYPE
    ) IS
  BEGIN
    DELETE FROM GIPI_QUOTE_COSIGN
     	  WHERE quote_id = p_quote_id
            AND cosign_id = p_cosign_id;
  END;

    /*
    **  Created by      : Jerome Orio
    **  Date Created    : 03.09.2011
    **  Reference By    : (GIIMM011 - Bond Policy Data)
    **  Description     : Insert/Update record based on given parameters
    */
  PROCEDURE set_gipi_quote_cosign(
    p_quote_id      GIPI_QUOTE_COSIGN.quote_id%TYPE,
    p_cosign_id     GIPI_QUOTE_COSIGN.cosign_id%TYPE,
    p_assd_no       GIPI_QUOTE_COSIGN.assd_no%TYPE,
    p_indem_flag    GIPI_QUOTE_COSIGN.indem_flag%TYPE,
    p_bonds_flag    GIPI_QUOTE_COSIGN.bonds_flag%TYPE,
    p_bonds_ri_flag GIPI_QUOTE_COSIGN.bonds_ri_flag%TYPE
    ) IS
  BEGIN
    MERGE INTO GIPI_QUOTE_COSIGN
		USING DUAL ON (quote_id = p_quote_id
                    AND cosign_id = p_cosign_id)
			WHEN NOT MATCHED THEN
				INSERT (quote_id,       cosign_id,
			            indem_flag,     bonds_flag,
                        bonds_ri_flag,  assd_no)
                VALUES (p_quote_id,       p_cosign_id,
			            p_indem_flag,     p_bonds_flag,
                        p_bonds_ri_flag,  p_assd_no)
            WHEN MATCHED THEN
				UPDATE SET indem_flag       = p_indem_flag,
                           bonds_flag       = p_bonds_flag,
                           bonds_ri_flag    = p_bonds_ri_flag,
                           assd_no          = p_assd_no;
  END;

END Gipi_Quote_Cosign_Pkg;
/


