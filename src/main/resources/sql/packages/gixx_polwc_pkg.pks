CREATE OR REPLACE PACKAGE CPI.Gixx_Polwc_Pkg AS    

    TYPE pol_doc_warranties_type IS RECORD(
        extract_id14     GIXX_POLWC.extract_id%TYPE,
        wc_wc_title      GIXX_POLWC.wc_title%TYPE,
        polwc_wc_text01  GIXX_POLWC.wc_text01%TYPE,
        polwc_wc_text02  GIXX_POLWC.wc_text02%TYPE,
        polwc_wc_text03  GIXX_POLWC.wc_text03%TYPE,
        polwc_wc_text04  GIXX_POLWC.wc_text04%TYPE,
        polwc_wc_text05  GIXX_POLWC.wc_text05%TYPE,
        polwc_wc_text06  GIXX_POLWC.wc_text06%TYPE,
        polwc_wc_text07  GIXX_POLWC.wc_text07%TYPE,
        polwc_wc_text08  GIXX_POLWC.wc_text08%TYPE,
        polwc_wc_text09  GIXX_POLWC.wc_text09%TYPE,
        polwc_wc_text10  GIXX_POLWC.wc_text10%TYPE,
        polwc_wc_text11  GIXX_POLWC.wc_text11%TYPE,
        polwc_wc_text12  GIXX_POLWC.wc_text12%TYPE,
        polwc_wc_text13  GIXX_POLWC.wc_text13%TYPE,
        polwc_wc_text14  GIXX_POLWC.wc_text14%TYPE,
        polwc_wc_text15  GIXX_POLWC.wc_text15%TYPE,
        polwc_wc_text16  GIXX_POLWC.wc_text16%TYPE,
        polwc_wc_text17  GIXX_POLWC.wc_text17%TYPE,
        warrc_wc_text01  GIIS_WARRCLA.wc_text01%TYPE,
        warrc_wc_text02  GIIS_WARRCLA.wc_text02%TYPE,
        warrc_wc_text03  GIIS_WARRCLA.wc_text03%TYPE,
        warrc_wc_text04  GIIS_WARRCLA.wc_text04%TYPE,
        warrc_wc_text05  GIIS_WARRCLA.wc_text05%TYPE,
        warrc_wc_text06  GIIS_WARRCLA.wc_text06%TYPE,
        warrc_wc_text07  GIIS_WARRCLA.wc_text07%TYPE,
        warrc_wc_text08  GIIS_WARRCLA.wc_text08%TYPE,
        warrc_wc_text09  GIIS_WARRCLA.wc_text09%TYPE,
        warrc_wc_text10  GIIS_WARRCLA.wc_text10%TYPE,
        warrc_wc_text11  GIIS_WARRCLA.wc_text11%TYPE,
        warrc_wc_text12  GIIS_WARRCLA.wc_text12%TYPE,
        warrc_wc_text13  GIIS_WARRCLA.wc_text13%TYPE,
        warrc_wc_text14  GIIS_WARRCLA.wc_text14%TYPE,
        warrc_wc_text15  GIIS_WARRCLA.wc_text15%TYPE,
        warrc_wc_text16  GIIS_WARRCLA.wc_text16%TYPE,
        warrc_wc_text17  GIIS_WARRCLA.wc_text17%TYPE,
        polwc_change_tag GIXX_POLWC.change_tag%TYPE,
        wc_wc_cd         GIXX_POLWC.wc_cd%TYPE,
        wc_print_sw      GIXX_POLWC.print_sw%TYPE
        );
    
    TYPE pol_doc_warranties_tab IS TABLE OF pol_doc_warranties_type;
    
    FUNCTION get_pol_doc_warranties RETURN pol_doc_warranties_tab PIPELINED;
	
	FUNCTION is_record_exists(p_extract_id IN GIXX_POLWC.extract_id%TYPE)
	RETURN VARCHAR2;
    
    FUNCTION get_pack_pol_doc_warranties(p_extract_id IN GIXX_POLWC.extract_id%TYPE,
                                         p_policy_id  IN GIXX_POLWC.policy_id%TYPE)
    RETURN pol_doc_warranties_tab PIPELINED;
    
    
    -- added by Kris 03.01.2013 for GIPIS101
    TYPE polwc_type IS RECORD (
        extract_id          gixx_polwc.extract_id%TYPE,
        line_cd             gixx_polwc.line_cd%TYPE,
        wc_cd               gixx_polwc.wc_cd%TYPE,
        swc_seq_no          gixx_polwc.swc_seq_no%TYPE,
        print_seq_no        gixx_polwc.print_seq_no%TYPE,
        wc_title            gixx_polwc.wc_title%TYPE,
        wc_text01           gixx_polwc.wc_text01%TYPE,
        wc_text02           gixx_polwc.wc_text02%TYPE,
        wc_text03           gixx_polwc.wc_text03%TYPE,
        wc_text04           gixx_polwc.wc_text04%TYPE,
        wc_text05           gixx_polwc.wc_text05%TYPE,
        wc_text06           gixx_polwc.wc_text06%TYPE,
        wc_text07           gixx_polwc.wc_text07%TYPE,
        wc_text08           gixx_polwc.wc_text08%TYPE,
        wc_text09           gixx_polwc.wc_text09%TYPE,
        wc_text10           gixx_polwc.wc_text10%TYPE,
        wc_text11           gixx_polwc.wc_text11%TYPE,
        wc_text12           gixx_polwc.wc_text12%TYPE,
        wc_text13           gixx_polwc.wc_text13%TYPE,
        wc_text14           gixx_polwc.wc_text14%TYPE,
        wc_text15           gixx_polwc.wc_text15%TYPE,
        wc_text16           gixx_polwc.wc_text16%TYPE,
        wc_text17           gixx_polwc.wc_text17%TYPE,
        wc_remarks          gixx_polwc.wc_remarks%TYPE,
        rec_flag            gixx_polwc.rec_flag%TYPE,
        dsp_wc_text         VARCHAR2(32767)
    );
    
    TYPE polwc_tab IS TABLE OF polwc_type;
    
    FUNCTION get_polwc (
        p_extract_id    gixx_polwc.extract_id%TYPE
    ) RETURN polwc_tab PIPELINED;
    -- end 03.01.2013 for GIPIS101


END Gixx_Polwc_Pkg;
/


