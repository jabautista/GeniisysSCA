CREATE OR REPLACE PACKAGE CPI.GIPIS161_PKG
AS
    TYPE policy_type IS RECORD (
        policy_id         gipi_polbasic.policy_id%TYPE,
        pol_line_cd       gipi_polbasic.line_cd%TYPE,
        pol_subline_cd    gipi_polbasic.subline_cd%TYPE,
        pol_iss_cd        gipi_polbasic.iss_cd%TYPE,
        pol_issue_yy      gipi_polbasic.issue_yy%TYPE,
        pol_seq_no        gipi_polbasic.pol_seq_no%TYPE,
        pol_renew_no      gipi_polbasic.renew_no%TYPE,
        policy_no         VARCHAR2(50),
        par_id            gipi_parlist.par_id%TYPE,
        par_line_cd       gipi_parlist.line_cd%TYPE,
        par_iss_cd        gipi_parlist.iss_cd%TYPE,
        par_yy            gipi_parlist.par_yy%TYPE,
        par_seq_no        gipi_parlist.par_seq_no%TYPE,
        par_quote_seq_no  gipi_parlist.quote_seq_no%TYPE,
        par_no            VARCHAR2(50),
        endt_iss_cd       gipi_polbasic.endt_iss_cd%TYPE,
        endt_yy           gipi_polbasic.endt_yy%TYPE,
        endt_seq_no       gipi_polbasic.endt_seq_no%TYPE,
        endt_no           VARCHAR2(50),
        assd_name         VARCHAR2(508),
        pack_policy_id    gipi_polbasic.pack_policy_id%TYPE,
        pack_pol_flag     gipi_polbasic.pack_pol_flag%TYPE,
        pack_no           VARCHAR2(50)
    );

    TYPE policy_tab IS TABLE OF policy_type;

    TYPE gen_init_info_type IS RECORD(
        user_id             gipi_polgenin.user_id%TYPE,
        last_update         VARCHAR2(50),
        gen_info01          gipi_polgenin.gen_info01%TYPE,
        gen_info02          gipi_polgenin.gen_info02%TYPE,
        gen_info03          gipi_polgenin.gen_info03%TYPE,
        gen_info04          gipi_polgenin.gen_info04%TYPE,
        gen_info05          gipi_polgenin.gen_info05%TYPE,
        gen_info06          gipi_polgenin.gen_info06%TYPE,
        gen_info07          gipi_polgenin.gen_info07%TYPE,
        gen_info08          gipi_polgenin.gen_info08%TYPE,
        gen_info09          gipi_polgenin.gen_info09%TYPE,
        gen_info10          gipi_polgenin.gen_info10%TYPE,
        gen_info11          gipi_polgenin.gen_info11%TYPE,
        gen_info12          gipi_polgenin.gen_info12%TYPE,
        gen_info13          gipi_polgenin.gen_info13%TYPE,
        gen_info14          gipi_polgenin.gen_info14%TYPE,
        gen_info15          gipi_polgenin.gen_info15%TYPE,
        gen_info16          gipi_polgenin.gen_info16%TYPE,
        gen_info17          gipi_polgenin.gen_info17%TYPE,
        initial_info01      gipi_polgenin.initial_info01%TYPE,
        initial_info02      gipi_polgenin.initial_info02%TYPE,
        initial_info03      gipi_polgenin.initial_info03%TYPE,
        initial_info04      gipi_polgenin.initial_info04%TYPE,
        initial_info05      gipi_polgenin.initial_info05%TYPE,
        initial_info06      gipi_polgenin.initial_info06%TYPE,
        initial_info07      gipi_polgenin.initial_info07%TYPE,
        initial_info08      gipi_polgenin.initial_info08%TYPE,
        initial_info09      gipi_polgenin.initial_info09%TYPE,
        initial_info10      gipi_polgenin.initial_info10%TYPE,
        initial_info11      gipi_polgenin.initial_info11%TYPE,
        initial_info12      gipi_polgenin.initial_info12%TYPE,
        initial_info13      gipi_polgenin.initial_info13%TYPE,
        initial_info14      gipi_polgenin.initial_info14%TYPE,
        initial_info15      gipi_polgenin.initial_info15%TYPE,
        initial_info16      gipi_polgenin.initial_info16%TYPE,
        initial_info17      gipi_polgenin.initial_info17%TYPE
    );
    
    TYPE gen_init_info_tab IS TABLE OF gen_init_info_type;

    TYPE gen_init_info_pack_type IS RECORD(
        user_id             gipi_polgenin.user_id%TYPE,
        last_update         VARCHAR2(50),
        pack_policy_id      gipi_pack_polgenin.pack_policy_id%TYPE,
        gen_info01          gipi_pack_polgenin.gen_info01%TYPE,
        gen_info02          gipi_pack_polgenin.gen_info02%TYPE,
        gen_info03          gipi_pack_polgenin.gen_info03%TYPE,
        gen_info04          gipi_pack_polgenin.gen_info04%TYPE,
        gen_info05          gipi_pack_polgenin.gen_info05%TYPE,
        gen_info06          gipi_pack_polgenin.gen_info06%TYPE,
        gen_info07          gipi_pack_polgenin.gen_info07%TYPE,
        gen_info08          gipi_pack_polgenin.gen_info08%TYPE,
        gen_info09          gipi_pack_polgenin.gen_info09%TYPE,
        gen_info10          gipi_pack_polgenin.gen_info10%TYPE,
        gen_info11          gipi_pack_polgenin.gen_info11%TYPE,
        gen_info12          gipi_pack_polgenin.gen_info12%TYPE,
        gen_info13          gipi_pack_polgenin.gen_info13%TYPE,
        gen_info14          gipi_pack_polgenin.gen_info14%TYPE,
        gen_info15          gipi_pack_polgenin.gen_info15%TYPE,
        gen_info16          gipi_pack_polgenin.gen_info16%TYPE,
        gen_info17          gipi_pack_polgenin.gen_info17%TYPE,
        initial_info01      gipi_pack_polgenin.initial_info01%TYPE,
        initial_info02      gipi_pack_polgenin.initial_info02%TYPE,
        initial_info03      gipi_pack_polgenin.initial_info03%TYPE,
        initial_info04      gipi_pack_polgenin.initial_info04%TYPE,
        initial_info05      gipi_pack_polgenin.initial_info05%TYPE,
        initial_info06      gipi_pack_polgenin.initial_info06%TYPE,
        initial_info07      gipi_pack_polgenin.initial_info07%TYPE,
        initial_info08      gipi_pack_polgenin.initial_info08%TYPE,
        initial_info09      gipi_pack_polgenin.initial_info09%TYPE,
        initial_info10      gipi_pack_polgenin.initial_info10%TYPE,
        initial_info11      gipi_pack_polgenin.initial_info11%TYPE,
        initial_info12      gipi_pack_polgenin.initial_info12%TYPE,
        initial_info13      gipi_pack_polgenin.initial_info13%TYPE,
        initial_info14      gipi_pack_polgenin.initial_info14%TYPE,
        initial_info15      gipi_pack_polgenin.initial_info15%TYPE,
        initial_info16      gipi_pack_polgenin.initial_info16%TYPE,
        initial_info17      gipi_pack_polgenin.initial_info17%TYPE
    );
    
    TYPE gen_init_info_pack_tab IS TABLE OF gen_init_info_pack_type;

    TYPE endt_info_type IS RECORD(
        user_id             gipi_endttext.user_id%TYPE,
        last_update         VARCHAR2(50),
        endt_text01         gipi_endttext.endt_text01%TYPE,
        endt_text02         gipi_endttext.endt_text02%TYPE,
        endt_text03         gipi_endttext.endt_text03%TYPE,
        endt_text04         gipi_endttext.endt_text04%TYPE,
        endt_text05         gipi_endttext.endt_text05%TYPE,
        endt_text06         gipi_endttext.endt_text06%TYPE,
        endt_text07         gipi_endttext.endt_text07%TYPE,
        endt_text08         gipi_endttext.endt_text08%TYPE,
        endt_text09         gipi_endttext.endt_text09%TYPE,
        endt_text10         gipi_endttext.endt_text10%TYPE,
        endt_text11         gipi_endttext.endt_text11%TYPE,
        endt_text12         gipi_endttext.endt_text12%TYPE,
        endt_text13         gipi_endttext.endt_text13%TYPE,
        endt_text14         gipi_endttext.endt_text14%TYPE,
        endt_text15         gipi_endttext.endt_text15%TYPE,
        endt_text16         gipi_endttext.endt_text16%TYPE,
        endt_text17         gipi_endttext.endt_text17%TYPE
    );
    
    TYPE endt_info_tab IS TABLE OF endt_info_type;    

   FUNCTION get_policy_listing (
      p_user_id          giis_users.user_id%TYPE,
      p_pol_line_cd      gipi_polbasic.line_cd%TYPE,
      p_pol_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_pol_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no       gipi_polbasic.pol_seq_no%TYPE,
      p_pol_renew_no     gipi_polbasic.renew_no%TYPE,
      p_par_line_cd      gipi_parlist.line_cd%TYPE,
      p_par_iss_cd       gipi_parlist.iss_cd%TYPE,
      p_par_yy           gipi_parlist.par_yy%TYPE,
      p_par_seq_no       gipi_parlist.par_seq_no%TYPE,
      p_par_quote_seq_no gipi_parlist.quote_seq_no%TYPE,
      p_endt_iss_cd      gipi_polbasic.endt_iss_cd%TYPE,      
      p_endt_yy          gipi_polbasic.endt_yy%TYPE,
      p_endt_seq_no      gipi_polbasic.endt_seq_no%TYPE,
      p_assd_name        giis_assured.assd_name%TYPE
   )
      RETURN policy_tab PIPELINED;

    FUNCTION get_gen_init_info(
        p_policy_id     gipi_polbasic.policy_id%TYPE
    ) 
        RETURN gen_init_info_tab PIPELINED;     

    FUNCTION get_gen_init_pack_info(
        p_policy_id     gipi_polbasic.policy_id%TYPE
    ) 
        RETURN gen_init_info_pack_tab PIPELINED;

    FUNCTION get_endt_info(
        p_policy_id     gipi_polbasic.policy_id%TYPE
    ) 
        RETURN endt_info_tab PIPELINED;    
        
    PROCEDURE set_gen_info_gipi_polgenin(
        p_set   gipi_polgenin%ROWTYPE
    );

    PROCEDURE set_init_info_gipi_polgenin(
        p_set   gipi_polgenin%ROWTYPE
    );

    PROCEDURE set_gen_gipi_pack_polgenin(
        p_set   gipi_pack_polgenin%ROWTYPE
    );

    PROCEDURE set_init_gipi_pack_polgenin(
        p_set   gipi_pack_polgenin%ROWTYPE
    );    
    
    PROCEDURE set_endt_gipi_endt_text(
        p_set   gipi_endttext%ROWTYPE
    );                         

    FUNCTION check_package(
        p_pack_policy_id    gipi_polbasic.pack_policy_id%TYPE       
    )
        RETURN VARCHAR;
        
    FUNCTION get_policy_listing2 (
      p_user_id          giis_users.user_id%TYPE,
      p_pol_line_cd      gipi_polbasic.line_cd%TYPE,
      p_pol_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_pol_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no       gipi_polbasic.pol_seq_no%TYPE,
      p_pol_renew_no     gipi_polbasic.renew_no%TYPE,
      p_par_line_cd      gipi_parlist.line_cd%TYPE,
      p_par_iss_cd       gipi_parlist.iss_cd%TYPE,
      p_par_yy           gipi_parlist.par_yy%TYPE,
      p_par_seq_no       gipi_parlist.par_seq_no%TYPE,
      p_par_quote_seq_no gipi_parlist.quote_seq_no%TYPE,
      p_endt_iss_cd      gipi_polbasic.endt_iss_cd%TYPE,      
      p_endt_yy          gipi_polbasic.endt_yy%TYPE,
      p_endt_seq_no      gipi_polbasic.endt_seq_no%TYPE,
      p_assd_name        giis_assured.assd_name%TYPE
   )
      RETURN policy_tab PIPELINED;
      
END GIPIS161_PKG;
/


