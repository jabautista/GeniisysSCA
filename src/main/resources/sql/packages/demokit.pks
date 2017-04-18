CREATE OR REPLACE PACKAGE CPI.DemoKit as
 -- Exceptions
	Already_installed		exception;
	Used_by_others			exception;
 -- functions and Procedures
	-- RunRequired: Returns csv list of script IDs to run
	-- 		in the order Truncate, Drop, Create, Populate
	function  RunRequired return varchar2;
	-- Register: 	This function should be at the start of any "Create" or "Populate" script

	-- 		for use in DemoKit, Thus when a script has been run either by the user
	-- 		in SQL*Plus, or by the SqlRun engine, DemoKit will know that the tables have

	--		been created and populated correctly
	-- The exception Already_installed may be raised
	procedure Register	 (ScriptId	in number,
				  Version 	in number);
	-- DeRegister:  This Function should be called at the start of any drop or truncate scripts

	--		so that DemoKit knows that the tables/data has been dropped.
	procedure DeRegister	 (ScriptId 	in number);
 end DemoKit;
/


