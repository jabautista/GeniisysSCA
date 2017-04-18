CREATE OR REPLACE PACKAGE CPI.package_posting_pkg
/* Author: Peter M. Kaw
** Description: This package prevents all table locks during package posting.
**              All locks for sequence updating will be done before package
**              posting process. This package is used by only one module which
**              is GIPIS055a.
** History: This package was created to resolve PRF #2266 optimization.
*/
AS
    PROCEDURE get_pkg_pol_seq (p_par_id IN NUMBER);

    PROCEDURE get_pkg_prem_seq (p_par_id IN NUMBER);

    PROCEDURE get_pkg_pack_pol_seq (p_pack_par_id NUMBER);

    PROCEDURE get_company_pol_seq (
        p_pol_clm_seq           VARCHAR2,
        p_line_cd               VARCHAR2,
        p_subline_cd            VARCHAR2,
        p_iss_cd                VARCHAR2,
        p_issue_yy              NUMBER,
        p_user_id               VARCHAR2,
        p_last_upd_date         DATE,
        p_pol_seq_no      OUT   NUMBER,
        p_exist           OUT   VARCHAR2);
    
    PROCEDURE post_package_par(
        p_pack_par_id        IN gipi_parlist.pack_par_id%TYPE,
        p_msg_alert         OUT VARCHAR2);
        
    PROCEDURE post_package_per_par(
        p_pack_par_id           IN gipi_parlist.pack_par_id%TYPE,
        p_line_cd               IN gipi_parlist.line_cd%TYPE,
        p_iss_cd                IN gipi_parlist.iss_cd%TYPE,
        p_msg_alert            OUT VARCHAR2,
        p_msg_alert2           OUT VARCHAR2,
        p_msg_type             OUT VARCHAR2,-- added by andrew - 08/08/2011 
        p_cred_branch_conf      IN VARCHAR2, -- added by andrew - 08/08/2011 
        p_chk_dflt_intm_sw      IN VARCHAR2, --benjo 09.07.2016 SR-5604
        p_user_id               IN       VARCHAR2 --added by cherrie 02.14.2014
        );
            
    PROCEDURE read_into_postpar(p_msg_alert    OUT VARCHAR2);
         
    PROCEDURE post_package(
        p_pack_par_id        IN gipi_parlist.pack_par_id%TYPE,
        p_pack_policy_id     IN VARCHAR2,   
        p_back_endt          IN VARCHAR2,
        p_msg_alert         OUT VARCHAR2
        );
    
    PROCEDURE post_par_package(
        p_pack_par_id        IN gipi_parlist.pack_par_id%TYPE,
        p_pack_policy_id     IN VARCHAR2,   
        p_back_endt          IN VARCHAR2,
        p_msg_alert         OUT VARCHAR2,
        p_change_stat        IN VARCHAR2
        );    
    
    PROCEDURE COPY_PACK_POL_WINVOICE(
        p_pack_par_id           IN gipi_parlist.pack_par_id%TYPE,
        p_iss_cd                IN gipi_parlist.iss_cd%TYPE,
        p_pack_policy_id        IN VARCHAR2,
        p_msg_alert            OUT VARCHAR2
        );
        
    PROCEDURE DELETE_PACK(
        p_pack_par_id     gipi_parlist.pack_par_id%TYPE,
        p_par_type        gipi_parlist.par_type%TYPE
        );
                
    FUNCTION check_back_endt_pack(p_pack_par_id     gipi_parlist.pack_par_id%TYPE)
    RETURN VARCHAR2;
            
    TYPE cancel_msg_type IS RECORD(
        msg_alert           VARCHAR2(32000)
        );
        
    TYPE cancel_msg_tab IS TABLE OF cancel_msg_type;
       
    FUNCTION check_cancel_par_posting(p_par_id            gipi_wpolbas.par_id%TYPE)
    RETURN cancel_msg_tab PIPELINED;
     
    FUNCTION check_cancel_pack_par_posting(p_pack_par_id    gipi_parlist.pack_par_id%TYPE)
    RETURN cancel_msg_tab PIPELINED;
    
    PROCEDURE get_correct_iss_yy(p_pack_par_id      gipi_parlist.pack_par_id%TYPE); --added by John Daniel; 06.29.2016; SR-5539     
END package_posting_pkg;
/


