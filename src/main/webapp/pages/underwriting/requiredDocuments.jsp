
<!--
Remarks: For deletion
Date :05-11-2012
Developer: A. Azarraga
Replacement : /pages/undewriting/requiredDocumentsTableGrid.jsp
-->

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="reqDocsMainDiv" name="reqDocsMainDiv" style="margin-top: 1px; display: none;">
	<form id="reqDocsForm" name="reqDocsForm">
		<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="outerDiv">
				<label id="">Required Documents Information</label>
				<span class="refreshers" style="margin-top: 0;">
		 			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
		 			<label id="refreshList" name="refreshList" style="margin-left: 5px;">Refresh List</label>
				</span>
			</div>
		</div>
		<div id="aDiv" name="aDiv">
			<jsp:include page="/pages/underwriting/subPages/requiredDocumentsListing.jsp"></jsp:include>
			<div id="buttonsDiv" align="center" style="padding-top: 10px;">
				<div style="margin: 50px;">
					<input type="button" id="btnCancel" name="btnCancel" class="button" value="Cancel" style="margin-top: 5px; width: 100px;"/>
					<input type="button" id="btnSave" name="btnSave" class="button" value="Save" style="margin-top: 5px; width: 100px;"/>
					<br/><br/>
				</div>
			</div>
		</div>
		<div id="hiddenDetailsDiv" name="hiddenDetailsDiv">
			<!-- input type="hidden" id="expiryDate" name="expiryDate" value="<fmt:formatDate value="${expiryDate}" pattern="MM-dd-yyyy" />"/-->
		</div>
	</form>
</div>

<script type="text/javaScript">

initializeAccordion();
addStyleToInputs();
initializeAll();
initializeAllMoneyFields();
setModuleId("GIPIS029");
//initializePARBasicMenu();
//initializeChangeTagBehavior(saveReqDocsPageChanges);

$("reloadForm").observe("click", function () {
	showRequiredDocsPage();
});

$("refreshList").observe("click", function() {
	new Ajax.Updater("searchResultDocs", contextPath+"/GIPIWRequiredDocumentsController?action=reloadDocumentsTable&globalParId="+$F("globalParId")+"&globalLineCd="+$F("globalLineCd"),{
		method: "POST",
		evalScripts: true,
		asynchronous: true,
		//postBody: Form.serialize("uwParParametersForm"),
		onCreate: function(){
			showLoading("searchResultDocs", "Refreshing list...", "0px");
			clearSelected();
			clearAddDocFields();
		},
		onComplete: function () {
			
		}
	});
});

$("btnSave").observe("click", function(){
	if (("" == $("docForInsertDiv").innerHTML) && ("" == $("docForDeleteDiv").innerHTML)){
		showMessageBox("There are no changes to save.", imgMessage.INFO);
	} else {
		saveReqDocsPageChanges();
	}
});

$("btnCancel").observe("click", function(){
	//checkChangeTagBeforeCancel();
	if ($F("globalLineCd") == "SU"){
		showBondBasicInfo();
	}else{	
		showBasicInfo();
	}
});

function saveReqDocsPageChanges(){
	new Ajax.Request(contextPath+"/GIPIWRequiredDocumentsController?action=saveReqDocsPageChanges&globalParId="+$F("globalParId")+"&globalLineCd="+$F("globalLineCd"), {
		method: "POST",
		evalScripts: true,
		asynchronous: true,
		postBody: Form.serialize("reqDocsForm"),
		onCreate: function(){
			showNotice("Saving changes...");
			$("reqDocsForm").disable();
			$$("div#reqDocsMainDiv input[type='button']").each(function(btn){
				disableButton(btn.getAttribute("id"));
			});
		},
		onComplete: function (response)	{
			if (checkErrorOnResponse(response)) {
				hideNotice(response.responseText);
				$("reqDocsForm").enable();
				showMessageBox("SUCCESS.", imgMessage.SUCCESS);
				$$("div#reqDocsMainDiv input[type='button']").each(function(btn){
					enableButton(btn.getAttribute("id"));
				});
				disableButton("btnDeleteDocument");
				$$("div [name='row']").each(function(row){
					if (row.hasClassName("selectedRow")){
						enableButton("btnDeleteDocument");
					}
				});
				$("docForInsertDiv").innerHTML = "";
				$("docForDeleteDiv").innerHTML = "";
			}
		}
	});
}

function clearSelected(){
	$("selectedDocCd").value 			= "";
	$("selectedDocSw").value 			= "";
	$("selectedDateSubmitted").value 	= "";
	$("selectedDocName").value 			= "";
	$("selectedUserId").value 			= "";
	$("selectedLastUpdate").value 		= "";
	$("selectedRemarks").value 			= "";
}

function clearAddDocFields(){
	$("document").selectedIndex 		= 0;
	$("docCd").value					= "";
	$("dateSubmitted").value 			= $("currentDate").value;
	$("user").value 					= $F("defaultUser");
	$("remarks").value 					= "";
	$("postSwitch").checked 			= false;
}

</script>