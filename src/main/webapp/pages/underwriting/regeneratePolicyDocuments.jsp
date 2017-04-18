<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="regeneratePolicyDocumentsMenu">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="query">Query</a></li>
				<li><a id="parExit">Exit</a></li>
			</ul>
		</div>
	</div>
</div>

<div>
	<jsp:include page="/pages/underwriting/policyPrinting.jsp"></jsp:include>
</div>

<script>
setModuleId("GIPIS091");

var objCurrentPolicy = null;
observeReloadForm("reloadForm", showRegeneratePolicyDocumentsPage);// added by irwin, 10.10.11
$("parExit").observe("click", function () {
	goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
});

$("query").observe("click", function(){
	/* Added by MarkS 05.02.2016 SR-22263 from reprintPolicyDetails.jsp */
	enableSearch("searchForPolicy");
	/* END SR-22263 */
	for (var i = 0; i < $("suAdditionalInfoDiv").childNodes.length; i++) {
		$("suAdditionalInfoDiv").childNodes[i].value = "";     
	}
	
	$$("input[name='capsField']").each(function(field){
		field.readOnly = false;
		field.value = "";
	});
	$$("input[name='intField']").each(function(field){
		field.readOnly = false;
		field.value = "";
	});
    
	objCurrentPolicy = null;
	
	$("policyId").value		= "";
	$("parId").value		= ""; // andrew - 06.1.2012
	$("policyLineCd").value = "";
	$("issCd").value 		= "";
	$("sublineCd").value 	= "";
	$("cocType").value 		= "";
	$("endtTax").value 		= "";
	$("renewNo").value 		= "";
	$("reportsDiv").innerHTML = "";
	$("forPrintsContainerDiv").innerHTML = "";
	$("parNo").readOnly = true;
	$("txtPremSeqNo").readOnly = true;
	//d.alcantara 08/16/2012
	$("abbreviated").hide();
	$("lblAbbreviated").hide();
	$("printPremium").hide();
	$("lblPrintPremium").hide();

	$("btnAddtlInfoSU").hide();
	
	// added by: Nica 09.04.2012 - to reset fields for printing documents
	manageDocTypes();
	moderateDocTypeOptions();
	$("docType").selectedIndex = 0;
	$("reportDestination").selectedIndex = 0;
	$("printerName").selectedIndex = 0;
	$("noOfCopies").selectedIndex = 0;
	$("noOfCopies").disable();
	$("selectedDocType").value = "";
	$("perTakeUp").disable();
	$("summary").disable();
	$("perTakeUp").checked = true;
	$("summary").checked = false;
	$("printerName").selectedIndex = 0;
	$("printerName").disable();
	$("btnAddPrint").value = "Add";
	$("btnDeletePrint").disable();
	$("noOfCopies").removeClassName("required");
	$("printerName").removeClassName("required");
	$("docType").show();
	$("docType").selectedIndex = 0;
	$("txtDocType").hide();
	$("txtDocType").value = "";
	$("details").hide();
	$("lblDetails").hide();
	$("details").checked = false;
	// end here Nica
	$("printPremium").checked = true; //marco - 11.20.2012
});

$("policyPrintingMainDiv").show();
</script>