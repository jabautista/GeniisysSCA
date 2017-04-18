<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<input type="hidden" id="selectedClientId" value="0" readonly="readonly" />
<div style="margin-top: 5px; width: 100%; display: none;" id="quotationListingTable" name="quotationListingTable">
	<div style="width: 99%;">
		<jsp:include page="/pages/common/utils/toolbar.jsp"></jsp:include>
	</div>
	<div class="tableHeader" style="width: 99%;">
		<label style="width: 28%; text-align: left; margin-left: 10px;">Quotation No.</label>
		<label style="width: 28%; text-align: left; margin-left: 10px;">Assured Name</label>
   		<label style="width: 10%; text-align: center;">Incept Date</label>
		<label style="width: 10%; text-align: center;">Expiry Date</label>
		<label style="width: 10%; text-align: center;">Validity Date</label>
		<label style="width: 10%; text-align: center;">User Id</label>
	</div>
	<div style="height: 400px; overflow-y: auto; overflow-x: hidden;" id="quoteMainDiv">
		<c:forEach var="quote" items="${gipiQuoteList}">
			<div id="row${quote.quoteId}" name="row" class="tableRow" style="width: 98.7%;">
				<input type="hidden" name="quoteId" 	value="${quote.quoteId}" />
				<input type="hidden" name="quoteNo" 	value="${quote.quoteNo}" />
				<input type="hidden" name="assdNo" 		value="${quote.assdNo}" />
				<input type="hidden" name="assdName" 	value="${quote.assdName}" />
				<input type="hidden" name="user" 		value="${quote.userId}" />
				<input type="hidden" name="reasonCd" 	value="${quote.reasonCd}" />
				<span style="width: 30%; text-align: left; float: left;"><label style="float: left; width: 100%; text-align: left; margin-left: 10px;">${quote.quoteNo}</label></span>
				<span style="width: 28.5%; text-align: left; float: left;" title="${quote.assdName}"><label style="float: left; width: 100%; text-align: left;">${quote.assdName}<c:if test="${empty quote.assdName}"> - </c:if></label></span>
	    		<span style="width: 10%; text-align: center; float: left;"><label style="float: left; width: 100%; text-align: center;"><fmt:formatDate value="${quote.inceptDate}" pattern="MM-dd-yyyy" /></label></span>
				<span style="width: 10%; text-align: center; float: left;"><label style="float: left; width: 100%; text-align: center;"><fmt:formatDate value="${quote.expiryDate}" pattern="MM-dd-yyyy" /></label></span>
				<span style="width: 10%; text-align: center; float: left;"><label style="float: left; width: 100%; text-align: center;"><fmt:formatDate value="${quote.validDate}" pattern="MM-dd-yyyy" /><c:if test="${empty quote.validDate}">-</c:if></label></span>
				<span style="width: 10%; text-align: center; float: left;" name="userId"><label style="float: left; width: 100%; text-align: center;">${quote.userId}</label></span>
			</div>
		</c:forEach>
		
		<jsp:include page="/pages/common/utils/pager.jsp"></jsp:include>
		
		<div id="quotations" name="quotations" style="display: none;">
			<json:object>
				<json:array name="quotations" var="q" items="${gipiQuoteList}">
					<json:object>
						<json:property name="quoteId" 		value="${q.quoteId}" />
						<json:property name="quoteNo" 		value="${q.quoteNo}" />
						<json:property name="assdName" 		value="${q.assdName}" />
						<json:property name="inceptDate" 	value="${q.inceptDate}" />
						<json:property name="expiryDate" 	value="${q.expiryDate}" />
						<json:property name="validDate"		value="${q.validDate}" />
						<json:property name="userId" 		value="${q.userId}" />
					</json:object>
				</json:array>
			</json:object>
		</div>
	</div>
</div>
<script type="text/JavaScript">
	<c:if test="${empty gipiQuoteList}">
		showMessageBox("No Record Found.", imgMessage.WARNING);
	</c:if>
	
	var currentUser = "${currentUser}";
	//var user2 = "${currentUser}"'

	if (!$("pager").innerHTML.blank()) {
		$("pager").setStyle("width: 98.7%;");
		$("page").observe("change", function () {
			loadQuotationList($F("page"));
		});
	}

	$("add").update("Create");

	var addtlTools = '<label id="copy" name="copy">Copy</label>'+
					 '<label id="duplicate" name="duplicate">Duplicate</label>'+
					 '<label id="deny" name="deny">Deny</label>'+
			  		// '<label id="lblPrint" name="print">Print</label>'+
			  		// '<label id="lblPreview" name="preview">Preview</label>'+
			  		 '<label id="refreshList" name="refreshList" style="width: 90px; float: right; margin-right: 2px;">Refresh List</label>'+ 
			  		 '<label id="reloadForm" name="reloadForm" style="width: 90px; float: right;">Reload Form</label>';
	
	$("delete").insert({after: addtlTools});


	$("refreshList").observe("click", function ()	{
		loadQuotationList(1);
	});

	$("add").observe("click", function ()	{
		createQuotation();
	});
	if (modules.all(function (mod) {return mod != 'GIIMM001';})) {
		$("add").hide();
	}
	
	$("edit").observe("click", function ()	{
		var toEdit;
		$$("div[name='row']").each(function (row)	{
			if (row.hasClassName("selectedRow"))	{
				toEdit = row;
			}
		});
		
		if (toEdit != null)	{
			$("quoteId").value = toEdit.down("input", 0).value;
		//	editQuotation(contextPath+"/GIPIQuotationController?action=initialQuotationListing&lineCd="+$F("lineCd")+"&lineName="+$F("lineName"));

			var quotationUser = toEdit.down("input", 4).value;
			var directParOpenAccess = "${directParOpenAccess}";
			var userId = "${userId}";
			// added validation for open par access. - irwin
			if(validateUserEntryForQuotation(userId, directParOpenAccess, quotationUser)){
				editQuotation(contextPath+"/GIPIQuotationController?action=initialQuotationListing&lineCd="+$F("lineCd")+"&lineName="+$F("lineName"));
			}

			
		}	else	{
			showQuotationListingError("Please select a quotation.");
		}
	});

	$("filter").observe("click", function ()	{
		fadeElement("searchDiv", .2, null);
		toggleDisplayElement("filterSpan", .2, "appear", focusFilterText);
	});

	$("filterText").observe("blur", function ()	{
		fadeElement("filterSpan", .2, null);
	});

	$("search").observe("click", toggleSearchDiv);
	
	$("filterText").observe("keyup", function (evt)	{
		if (evt.keyCode == 27) {
			$("filterText").clear();
			showAllRows("quotationListingTable", "row");
			/*$$("div[name='row']").each(function (div)	{
				div.show();
			});*/
		} else {
			var text = ($F("filterText").strip()).toUpperCase();
			for (var i=0; i<quotationList.quotations.length; i++)	{
				if (quotationList.quotations[i].quoteNo.toUpperCase().match(text) != null || 
					quotationList.quotations[i].assdName.toUpperCase().match(text) != null || 
					quotationList.quotations[i].inceptDate.toUpperCase().match(text) != null || 
					quotationList.quotations[i].expiryDate.toUpperCase().match(text) != null || 
					quotationList.quotations[i].validDate.toUpperCase().match(text) != null || 
					quotationList.quotations[i].userId.toUpperCase().match(text) != null)	{
					$("row"+quotationList.quotations[i].quoteId).show();
				} else {
					$("row"+quotationList.quotations[i].quoteId).hide();
				}
				if (!$("pager").innerHTML.blank()) {
					positionPageDiv();
				}
			}
		}
	});

	$("copy").observe("click", function () {
		var qId = getSelectedRowId("row");
		if (qId == "") {
			showQuotationListingError("Please select a quotation.");
			return false;
		} else {
			showConfirmBox("Copy Confirmation", 
						   "Copy Quotation No. "+$("row"+qId).down("input", 1).value+"?", 
						   "Yes", "No", continueCopyQuotation,"");  
		}
	});

	function continueCopyQuotation() {
		var qId = getSelectedRowId("row");
		//new Ajax.Updater("mainContents", contextPath+"/GIPIQuotationController?action=copyQuotation", {
		new Ajax.Request(contextPath+"/GIPIQuotationController?action=copyQuotation", {
			asynchronous: true,
			evalScripts: true,
			parameters: {
				lineName: $F("lineName"),
				lineCd: $F("lineCd"),
				quoteId: qId
			},
			onCreate: function () {
				showNotice("Copying quotation, please wait...");
			},
			onComplete: function (response) {
				if (checkErrorOnResponse(response)) {
					showMessageBox("New Quotation no. "+(response.responseText.toString().split(","))[1], imgMessage.INFO); 
					hideNotice("Done!");
					//Effect.Appear("contentsDiv", {duration: 1});
					if ("SUCCESS" == (response.responseText.toString().split(","))[0]) {
						loadQuotationList(1);
					}
				}
			}
		}); 
	} 

	$("duplicate").observe("click", function () {
		var qId = getSelectedRowId("row");
		if (qId == "") {
			showQuotationListingError("Please select a quotation.");
			return false;
		} else {
			showConfirmBox("Duplicate Confirmation", 
					   "Duplicate Quotation No. <br />"+$("row"+qId).down("input", 1).value+"?", 
					   "Yes", "No", continueDuplicateQuotation,"");
		}
	});

	function continueDuplicateQuotation() {
		var qId = getSelectedRowId("row");
		new Ajax.Request(contextPath+"/GIPIQuotationController?action=duplicateQuotation", {
		//new Ajax.Updater("mainContents", contextPath+"/GIPIQuotationController?action=duplicateQuotation", {
			asynchronous: true,
			evalScripts: true,
			parameters: {
				lineName: $F("lineName"),
				lineCd: $F("lineCd"),
				quoteId: qId
			},
			onCreate: function () {
				showNotice("Duplicating quotation, please wait...");
			},
			onComplete: function (response) {
				if (checkErrorOnResponse(response)) {
					showMessageBox("New quotation no. " +(response.responseText.toString().split(","))[1] + "", imgMessage.INFO); 
					hideNotice("Done!");
					if ("SUCCESS" == (response.responseText.toString().split(","))[0]) {
						loadQuotationList(1);
					}
			}}
		});
	}
	
	$("delete").observe("click", function () {
		var qId = getSelectedRowId("row");
		if (qId == "") {
			showQuotationListingError("Please select a quotation.");
			return false;
		} else {
			showConfirmBox("Delete Confirmation", 
					   	   "Are you sure you want to delete this record?", 
					   	   "Yes", "No", continueDeleteQuotation,"");
		}
	});

	function continueDeleteQuotation() {
		var qId = getSelectedRowId("row");
		new Ajax.Request(contextPath+"/GIPIQuotationController?action=deleteQuotation", {
			asynchronous: true,
			evalScripts: true,
			parameters: {
				quoteId: qId
			},
			onCreate: function () {
				showNotice("Deleting quotation, please wait...");
			},
			onComplete: function (response) {
				if (checkErrorOnResponse(response)) {
					hideNotice(response.responseText);
					if ("SUCCESS" == response.responseText) {
						showMessageBox("The Quotation "+$("row"+qId).down("input", 1).value+" has been deleted.", imgMessage.INFO);
						Effect.Fade("row"+qId, {
							duration: .2,
							afterFinish: function () {
								$("row"+qId).remove();
								$("quoteId").clear();
								deselectRows("quotationListingTable", "row");
								$$("input[type='button']:not([value~='Create'])").each(function (obj) {
									//disableButton(obj.readAttribute("id"));
									/*obj.disable();
									obj.removeClassName("button");
									obj.addClassName("disabledButton");*/
								});
							}
						});
					}
				}
			}
		});
		return true;
	}

	$("deny").observe("click", function () {
		var qId = getSelectedRowId("row");
		if (qId == "") {
			showQuotationListingError("Please select a quotation.");
			return false;
		}else if($("row"+qId).down("input", 4).value != currentUser){
			showQuotationListingError("Record created by another user cannot be denied.");
			return false;
		}else {
			if (nvl($("row"+qId).down("input", 5).value, "0") == "0"){
				chooseReason();
			} else {
				denyQuotation(qId);
			}
		}
	});

	function chooseReason(){
		showOverlayContent(contextPath+"/GIPIQuotationController?action=showReasons&lineCd="+$F("lineCd"), 
				"Select Reason", "", 450, 200, 10);
	}

	//Transferred to quotation.js BJGA12.22.2010
	/*function denyQuotation(qId){
		showConfirmBox("Deny Confirmation", 
			   	   "Deny Quotation No. <br />"+$("row"+qId).down("input", 1).value+"?", 
			   	   "Yes", "No", continueDenyQuotation,"");
	}

	function continueDenyQuotation(){
		var qId = getSelectedRowId("row");
		new Ajax.Request(contextPath+"/GIPIQuotationController?action=denyQuotation", {
			asynchronouse: true,
			evalScripts: true,
			parameters: {
				quoteId: qId
			},
			onCreate: function() {
				showNotice("Denying quotation, please wait...");
			},
			onComplete: function(response) {
				showMessageBox("The Quotation "+$("row"+qId).down("input", 1).value+" has been denied.", imgMessage.INFO);
				$("row"+qId).remove();
				$("quoteId").clear();
				deselectRows("quotationListingTable", "row");
			}		
		});
	}*/
	
	$("reloadForm").observe("click", createQuotationFromLineListing);

	initializeAll();
	addStyleToInputs();

	$$("div[name='row']").each(
		function (row)	{
			row.observe("mouseover", function ()	{
				row.addClassName("lightblue");
			});
			
			row.observe("mouseout", function ()	{
				row.removeClassName("lightblue");
			});
		
			row.observe("click", function ()	{
				row.toggleClassName("selectedRow");
				//var qId = getSelectedRowId("row"); //added by me
				if (row.hasClassName("selectedRow"))	{
					quoteIdToEdit = row.getAttribute("id").substring(3);
					$("quotationNo").value = quoteIdToEdit;
					objGIPIQuote.quoteId = quoteIdToEdit;
					try {
						var userIdDD = $("rqUserId");
						for (var i=0; i<userIdDD.length; i++) {
							if (userIdDD.options[i].value == row.down("label", 5).innerHTML) {
								userIdDD.selectedIndex = i;
								//throw $break;
							} 
						}
						$$("div[name='row']").each(function (r)	{
							if (row.getAttribute("id") != r.getAttribute("id"))	{
								r.removeClassName("selectedRow");
							}
						});
						
						$$("input[type='button']:not([value~='Create'])").each(function (obj) {
							/*obj.enable();
							obj.addClassName("button");
							obj.removeClassName("disabledButton");*/
							enableButton(obj.readAttribute("id"));
						});
					} catch (e) {
						showErrorMessage("quotationListingTable.jsp", e);
					}
				}	else	{
					$("quotationNo").value = 0;
					objGIPIQuote.quoteId = 0;
					quoteIdToEdit = 0;
					$("reassignQuotationForm").reset();
					
					$$("input[type='button']:not([value~='Create'])").each(function (obj) {
						if (obj.value != "Search") {
							disableButton(obj.readAttribute("id"));
							/*obj.disable();
							obj.addClassName("disabledButton");
							obj.removeClassName("button");*/
						}
					});
					/*$("btnReassignQuotation").disable();
					$("btnReassignQuotation").addClassName("disabledButton");
					$("btnReassignQuotation").removeClassName("button");*/
				}
			});

			row.observe("dblclick", function(){
				$("quoteId").value = row.down("input", 0).value;
				objGIPIQuote.quoteId = row.down("input", 0).value;
				var quotationUser = row.down("input", 4).value;
				var directParOpenAccess = "${directParOpenAccess}";
				var userId = "${userId}";		
				if(validateUserEntryForQuotation(userId, directParOpenAccess, quotationUser)){
					editQuotation(contextPath+"/GIPIQuotationController?action=initialQuotationListing&lineCd="+$F("lineCd")+"&lineName="+$F("lineName"));
				}
			});
		}
	);

	

	function validateUserEntryForQuotation(userId, directParOpenAccess, quotationUser){
		if(userId == quotationUser){
			return true;
		}else if(userId != quotationUser && directParOpenAccess == 'Y'){
			return true;
		}else if(userId != quotationUser && directParOpenAccess == 'N'){
			showMessageBox("Record created by another user cannot be accessed.", imgMessage.INFO);
			return false;
		}
	}

	$$("div[name='row']").each(function (div)	{
		if ((div.down("label", 1).innerHTML).length > 30)	{
			div.down("label", 1).update((div.down("label", 1).innerHTML).truncate(30, "..."));
		}
	});
	
	quotationList = ($("quotations").innerHTML).evalJSON();

	// position page div correctly
	
	//var product = 310 - (parseInt($$("div[name='row']").size())*30);
	//$("pager").setStyle("margin-top: "+product+"px;");

	if (fromReassignQuotation == 1) {
		$("add").hide();
		$("delete").hide();
		$("edit").hide();
		$("copy").hide();
		$("duplicate").hide();
		$("deny").hide();
	}

	var vPreview = 1;
	
</script>