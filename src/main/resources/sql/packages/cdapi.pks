CREATE OR REPLACE PACKAGE CPI.cdapi AS
  activity_status varchar2(1)	DEFAULT null;
  activity_warnings varchar2(1) DEFAULT null;
  app_sys_ref   number(38)      DEFAULT null;
  app_sys_name  varchar2(100)   DEFAULT null;
  app_sys_ver   number          DEFAULT null;
  app_sys_frozen boolean	DEFAULT false;
  type msg_facility_tab is table of varchar2(3)   index by binary_integer;
  type msg_code_tab     is table of number        index by binary_integer;
  type lrg_arg_tab      is table of varchar2(240) index by binary_integer;
  type med_arg_tab      is table of varchar2(64)  index by binary_integer;
  type sml_arg_tab      is table of varchar2(20)  index by binary_integer;
  apierror                      EXCEPTION;
  apiwarning                    EXCEPTION;
  internalerror                 EXCEPTION;
  -- Return state of the API
  FUNCTION initialized RETURN boolean;
  -- Return the context activity
  FUNCTION activity RETURN number;
  -- Initialize the API globals to allow operation processing
  PROCEDURE initialize(curr_app_sys_name varchar2 default null,
    curr_app_sys_ver number default null,curr_app_sys_ref number default null);
  -- Establish the context application system
  PROCEDURE set_context_appsys(curr_app_sys_name varchar2,
    curr_app_sys_ver number default null,curr_app_sys_ref number default null);
  -- Open a new activity
  PROCEDURE open_activity;
  -- Attempt to close the current activity
  PROCEDURE close_activity(act_status out varchar2);
  -- Abort the current activity
  PROCEDURE abort_activity;
  -- Validate the current activity
  PROCEDURE validate_activity(act_status out varchar2,
    act_warnings out varchar2);
  -- In certain cases it may be convenient to consolidate violations with API
  -- messages which were placed on the stack.  This routine loops through the
  -- violations currently in the CI_VIOLATIONS view and pushes each one onto
  -- the stack.
  PROCEDURE violations_to_stack;
  -- Pop the top message off the stack and decrease the stack size by 1
  PROCEDURE pop_message(msg_facility out varchar2, msg_code out number,
    arg1 out varchar2, arg2 out varchar2, arg3 out varchar2,
    arg4 out varchar2, arg5 out varchar2, arg6 out varchar2,
    arg7 out varchar2, arg8 out varchar2);
  -- Pop the top message off the stack, already formatted, and decrease the
  -- stack size by 1.  Returns the message in a varchar2 string.
  FUNCTION pop_instantiated_message RETURN varchar2;
  -- Retrieve a specific message from the stack, identified by it's depth
  -- ('stack_depth') into the stack.  Does not affect the stack.
  PROCEDURE get_message(stack_depth in binary_integer,
    msg_facility out varchar2, msg_code out number,
    arg1 out varchar2, arg2 out varchar2, arg3 out varchar2,
    arg4 out varchar2, arg5 out varchar2, arg6 out varchar2,
    arg7 out varchar2, arg8 out varchar2);
  -- Retrieve all messages currently in the stack into variable arrays.  Does
  -- not affect the stack.
  PROCEDURE get_stack(msg_facility out cdapi.msg_facility_tab,
    msg_code out cdapi.msg_code_tab,
    arg1 out cdapi.lrg_arg_tab, arg2 out cdapi.med_arg_tab,
    arg3 out cdapi.med_arg_tab, arg4 out cdapi.med_arg_tab,
    arg5 out cdapi.sml_arg_tab, arg6 out cdapi.sml_arg_tab,
    arg7 out cdapi.sml_arg_tab, arg8 out cdapi.sml_arg_tab);
  -- Remove all messages from the message stack.  'cdapi.stacksize' becomes 0.
  PROCEDURE clear_stack;
  -- Return the number of messages currently in the stack.
  FUNCTION stacksize RETURN number;
  -- Return a message complete with argument substitutions.  Currently
  -- returns the English translation.
  FUNCTION instantiate_message(msg_facility varchar2, msg_code number,
    str1 varchar2 default null, str2 varchar2 default null,
    str3 varchar2 default null, str4 varchar2 default null,
    str5 varchar2 default null, str6 varchar2 default null,
    str7 varchar2 default null, str8 varchar2 default null)
  RETURN varchar2;
  -- Return a message complete with argument substitutions but without
  -- the message code and facility
  FUNCTION instantiate_mess(msg_facility varchar2, msg_code number,
    str1 varchar2 default null, str2 varchar2 default null,
    str3 varchar2 default null, str4 varchar2 default null,
    str5 varchar2 default null, str6 varchar2 default null,
    str7 varchar2 default null, str8 varchar2 default null)
  RETURN varchar2;
  -- Return the version of the API
  FUNCTION cdapi_release RETURN varchar2;
  -- Return the version of CASE Repository used to build the API
  FUNCTION repos_release RETURN varchar2;
  -- Delete all elements which reference the element with the supplied ID
  PROCEDURE power_delete(id number);
END;
/


