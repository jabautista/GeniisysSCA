CREATE OR REPLACE PACKAGE CPI.gipi_insp_data_wc_pkg AS

  TYPE gipi_insp_data_wc_type IS RECORD(
  	 insp_no				  GIPI_INSP_DATA_WC.insp_no%TYPE,
	 line_cd				  GIPI_INSP_DATA_WC.line_cd%TYPE,
	 wc_cd					  GIPI_INSP_DATA_WC.wc_cd%TYPE,
	 arc_ext_data			  GIPI_INSP_DATA_WC.arc_ext_data%TYPE,
     
     dsp_wc_title             GIIS_WARRCLA.wc_title%TYPE,
     dsp_wc_text1             GIIS_WARRCLA.wc_text01%TYPE,
     dsp_wc_text2             GIIS_WARRCLA.wc_text01%TYPE,
     dsp_wc_text3             GIIS_WARRCLA.wc_text01%TYPE,
     dsp_wc_text4             GIIS_WARRCLA.wc_text01%TYPE,
     dsp_wc_text5             GIIS_WARRCLA.wc_text01%TYPE,
     dsp_wc_text6             GIIS_WARRCLA.wc_text01%TYPE,
     dsp_wc_text7             GIIS_WARRCLA.wc_text01%TYPE,
     dsp_wc_text8             GIIS_WARRCLA.wc_text01%TYPE,
     dsp_wc_text9             GIIS_WARRCLA.wc_text01%TYPE,
     dsp_wc_text10            GIIS_WARRCLA.wc_text01%TYPE,
     dsp_wc_text11            GIIS_WARRCLA.wc_text01%TYPE,
     dsp_wc_text12            GIIS_WARRCLA.wc_text01%TYPE,
     dsp_wc_text13            GIIS_WARRCLA.wc_text01%TYPE,
     dsp_wc_text14            GIIS_WARRCLA.wc_text01%TYPE,
     dsp_wc_text15            GIIS_WARRCLA.wc_text01%TYPE,
     dsp_wc_text16            GIIS_WARRCLA.wc_text01%TYPE,
     dsp_wc_text17            GIIS_WARRCLA.wc_text01%TYPE
  );
  
  TYPE gipi_insp_data_wc_table IS TABLE OF gipi_insp_data_wc_type;
  
  FUNCTION get_gipi_insp_data_wc(
  	 p_insp_no				  GIPI_INSP_DATA_WC.insp_no%TYPE
  ) RETURN gipi_insp_data_wc_table PIPELINED;
  
  PROCEDURE insert_insp_data_wc(
  	 p_insp_no				  GIPI_INSP_DATA_WC.insp_no%TYPE,
	 p_wc_cd				  GIPI_INSP_DATA_WC.wc_cd%TYPE,
	 p_arc_ext_data			  GIPI_INSP_DATA_WC.arc_ext_data%TYPE
  );
  
  PROCEDURE delete_insp_data_wc(
  	 p_insp_no				  GIPI_INSP_DATA_WC.insp_no%TYPE,
	 p_wc_cd				  GIPI_INSP_DATA_WC.wc_cd%TYPE
  );

END gipi_insp_data_wc_pkg;
/


