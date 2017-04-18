CREATE OR REPLACE PACKAGE CPI.GIUW_PERILDS_PKG
AS
    TYPE giuw_perilds_type IS RECORD (
        dist_no             GIUW_PERILDS.dist_no%TYPE,
        dist_seq_no         GIUW_PERILDS.dist_seq_no%TYPE,
        peril_cd            GIUW_PERILDS.peril_cd%TYPE,
        peril_name          GIIS_PERIL.peril_name%TYPE,
        line_cd             GIUW_PERILDS.line_cd%TYPE,
        tsi_amt             GIUW_PERILDS.tsi_amt%TYPE,
        prem_amt            GIUW_PERILDS.prem_amt%TYPE,
        ann_tsi_amt         GIUW_PERILDS.ann_tsi_amt%TYPE,
        cpi_rec_no          GIUW_PERILDS.cpi_rec_no%TYPE,
        cpi_branch_cd       GIUW_PERILDS.cpi_branch_cd%TYPE,
        arc_ext_data        GIUW_PERILDS.arc_ext_data%TYPE,
        currency_desc       GIIS_CURRENCY.CURRENCY_DESC%TYPE  --added by Halley 09.27.2013
    );
    
    TYPE giuw_perilds_tab IS TABLE OF giuw_perilds_type;

	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/
	PROCEDURE del_giuw_perilds (p_dist_no 	GIUW_PERILDS.dist_no%TYPE);
    
    /*
    **  Created by      : emman
    **  Date Created    : 08.12.2011
    **  Reference By    : (GIUTS021 - Redistribution)
    **  Description     : Retrieve records on giuw_perilds based on the given parameter
    */
    FUNCTION get_giuw_perilds (p_dist_no IN giuw_perilds.dist_no%TYPE)
      RETURN giuw_perilds_tab PIPELINED;
    
END GIUW_PERILDS_PKG;
/


