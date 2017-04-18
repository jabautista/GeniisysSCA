CREATE OR REPLACE PACKAGE CPI.GISMS012_PKG
AS
    TYPE user_list_lov_type IS RECORD (
        user_id     VARCHAR2(8),
        user_name   VARCHAR2(20)
    );
    TYPE user_list_lov_tab IS TABLE OF user_list_lov_type;
    
    FUNCTION get_user_list_lov(
        p_user_id   VARCHAR2
    )
        RETURN user_list_lov_tab PIPELINED;
    
    PROCEDURE populate_sms_report(
        p_from_date    IN  VARCHAR2,
        p_to_date      IN  VARCHAR2,
        p_as_of_date   IN  VARCHAR2,
        p_user         IN  VARCHAR2,
        p_rec_globe    OUT NUMBER,
        p_rec_smart    OUT NUMBER,
        p_rec_sun      OUT NUMBER,
        p_sent_globe   OUT NUMBER,
        p_sent_smart   OUT NUMBER,
        p_sent_sun     OUT NUMBER,
        p_total_rec    OUT NUMBER,
        p_total_sent   OUT NUMBER
    );
    
    PROCEDURE validate_gisms012_user(
        p_user_id      IN OUT VARCHAR2,
        p_user_name    OUT    VARCHAR2
    );
END;
/


