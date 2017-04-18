CREATE OR REPLACE PACKAGE CPI.Gipi_Pack_WpolWC_Pkg AS

    TYPE gipi_pack_wpolwc_type IS RECORD
    (line_cd                    GIPI_PACK_WPOLWC.line_cd%TYPE,
     wc_cd                      GIPI_PACK_WPOLWC.wc_cd%TYPE,
     swc_seq_no                 GIPI_PACK_WPOLWC.swc_seq_no%TYPE,
     print_seq_no               GIPI_PACK_WPOLWC.print_seq_no%TYPE,
     wc_title                   GIPI_PACK_WPOLWC.wc_title%TYPE,
     wc_title2                  GIPI_PACK_WPOLWC.wc_title2%TYPE,
     rec_flag                   GIPI_PACK_WPOLWC.rec_flag%TYPE,
     wc_remarks                 GIPI_PACK_WPOLWC.wc_remarks%TYPE,
     print_sw                   GIPI_PACK_WPOLWC.print_sw%TYPE,
     change_tag                 GIPI_PACK_WPOLWC.change_tag%TYPE,
     pack_par_id                GIPI_PACK_WPOLWC.pack_par_id%TYPE,
     wc_text01                  GIPI_PACK_WPOLWC.wc_text01%TYPE,
     wc_text02                  GIPI_PACK_WPOLWC.wc_text02%TYPE,
     wc_text03                  GIPI_PACK_WPOLWC.wc_text03%TYPE,
     wc_text04                  GIPI_PACK_WPOLWC.wc_text04%TYPE,
     wc_text05                  GIPI_PACK_WPOLWC.wc_text05%TYPE,
     wc_text06                  GIPI_PACK_WPOLWC.wc_text06%TYPE,
     wc_text07                  GIPI_PACK_WPOLWC.wc_text07%TYPE,
     wc_text08                  GIPI_PACK_WPOLWC.wc_text08%TYPE,
     wc_text09                  GIPI_PACK_WPOLWC.wc_text09%TYPE,
     wc_text10                  GIPI_PACK_WPOLWC.wc_text10%TYPE,
     wc_text11                  GIPI_PACK_WPOLWC.wc_text11%TYPE,
     wc_text12                  GIPI_PACK_WPOLWC.wc_text12%TYPE,
     wc_text13                  GIPI_PACK_WPOLWC.wc_text13%TYPE,
     wc_text14                  GIPI_PACK_WPOLWC.wc_text14%TYPE,
     wc_text15                  GIPI_PACK_WPOLWC.wc_text15%TYPE,
     wc_text16                  GIPI_PACK_WPOLWC.wc_text16%TYPE,
     wc_text17                  GIPI_PACK_WPOLWC.wc_text17%TYPE);
    
    TYPE gipi_pack_wpolwc_tab IS TABLE OF gipi_pack_wpolwc_type;
    
    PROCEDURE set_gipi_pack_wpolwc (p_pack_wpolwc      GIPI_PACK_WPOLWC%ROWTYPE);
   
    PROCEDURE del_gipi_pack_wpolwc (p_wc_cd            GIPI_PACK_WPOLWC.wc_cd%TYPE,
                                   p_line_cd          GIPI_PACK_WPOLWC.line_cd%TYPE,
                                   p_pack_par_id      GIPI_PACK_WPOLWC.pack_par_id%TYPE);
             
    PROCEDURE del_gipi_pack_wpolwc (p_pack_par_id      GIPI_PACK_WPOLWC.pack_par_id%TYPE);
                             
END gipi_pack_wpolwc_pkg;
/


