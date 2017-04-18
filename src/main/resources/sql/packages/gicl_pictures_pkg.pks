CREATE OR REPLACE PACKAGE CPI.gicl_pictures_pkg
AS

    TYPE gicl_pictures_type IS RECORD(
        claim_id        gicl_pictures.claim_id%TYPE,
        item_no         gicl_pictures.item_no%TYPE,
        file_name       gicl_pictures.file_name%TYPE,
        file_ext        gicl_pictures.file_ext%TYPE,
        file_type       gicl_pictures.file_type%TYPE,
        remarks         gicl_pictures.remarks%TYPE,
        real_file_name  VARCHAR2(1000)
        );
        
    TYPE gicl_pictures_tab IS TABLE OF gicl_pictures_type;
    
    FUNCTION get_gicl_pictures(
        p_claim_id        gicl_pictures.claim_id%TYPE,
        p_item_no         gicl_pictures.item_no%TYPE
        )   
    RETURN gicl_pictures_tab PIPELINED;        

    PROCEDURE set_gicl_pictures(
        p_clm		GICL_PICTURES%ROWTYPE
    );
    
    PROCEDURE del_gicl_pictures(
        p_claim_id		gicl_pictures.claim_id%TYPE,
	    p_item_no		gicl_pictures.item_no%TYPE
    );
    
    PROCEDURE del_gicl_picture(
        p_claim_id      gicl_pictures.claim_id%TYPE,
        p_item_no       gicl_pictures.item_no%TYPE,
        p_file_name     gicl_pictures.file_name%TYPE
    );
END gicl_pictures_pkg;
/


