<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<form id="acctgOrParametersForm" name="acctgOrParametersForm">
	<input type="hidden" name="globalGaccTranId" 		id="globalGaccTranId" 			value="54679" /> <!-- 45371,53480 orig 54519 hard code muna ung tran id -->
	<input type="hidden" name="globalGaccBranchCd" 		id="globalGaccBranchCd" 		value="" />
	<input type="hidden" name="globalGaccFundCd" 		id="globalGaccFundCd" 			value="" />
	<input type="hidden" name="globalCallingForm" 		id="globalCallingForm" 			value="" />
	<input type="hidden" name="globalCalledForm" 		id="globalCalledForm" 			value="" />
	<input type="hidden" name="globalWithPdc" 			id="globalWithPdc" 				value="" />
	<input type="hidden" name="globalTranSource" 		id="globalTranSource" 			value="" />
	<input type="hidden" name="globalDocumentName" 		id="globalDocumentName" 		value="" />
	<input type="hidden" name="globalImplSwParam" 		id="globalImplSwParam" 			value="" />
	<input type="hidden" name="globalOpTag" 			id="globalOpTag" 				value="" />
	<input type="hidden" name="globalVarTranClass" 		id="globalVarTranClass" 		value="" />
	<!--<input type="hidden" name="*globalVarTranClass" 		id="globalVarTranClass" 		value="" />
	--><input type="hidden" name="globalOrFlag"			id="globalOrFlag"				value="" />
	<input type="hidden" name="globalOrTag"				id="globalOrTag"				value="" />
	<input type="hidden" name="globalWorkflowColVal"	id="globalWorkflowColVal"		value="" />
	<input type="hidden" name="globalWorkflowEventDesc"	id="globalWorkflowEventDesc" 	value="" />
	<input type="hidden" name="globalTransaction"		id="globalTransaction"     		value="" />
	<input type="hidden" name="globalOpReqTag"			id="globalOpReqTag"     		value="" />
	<input type="hidden" name="globalCgGaccTranId"		id="globalCgGaccTranId"     	value="" />
	<input type="hidden" name="globalOrCancel"			id="globalOrCancel"    			value="" />
	<input type="hidden" name="globalTranClass"			id="globalTranClass"    		value="" />
	<input type="hidden" name="globalOverDueOveride"	id="globalOverDueOveride"   	value="N" />
	<input type="hidden" name="globalAcctgExequery"		id="globalAcctgExequery"		value="" />
	<!--<input type="hidden" name="*globalCgGaccTranId"		id="globalCgGaccTranId"     	value="" />
	<input type="hidden" name="*globalOrCancel"			id="globalOrCancel"    			value="" />
	<input type="hidden" name="*globalTranClass"			id="globalTranClass"    		value="" />
	<input type="hidden" name="*globalOverDueOveride"	id="globalOverDueOveride"   	value="N" />
	<input type="hidden" name="*globalAcctgExequery"		id="globalAcctgExequery"		value="" />
--></form>
