<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div style="margin: 5px; display: none;">
	<jsp:include page="/pages/common/utils/toolbar.jsp"></jsp:include>
	
	<div class="tableHeader">
		<label style="width: 19.5%; text-align: left; margin-left: 15px;">PAR No.</label>
		<label style="width: 19%; text-align: left;">Assured Name</label>
		<label style="width: 8%; text-align: left;">User Id</label>
		<label style="width: 20%; text-align: left;">Status</label>
		<label style="width: 20px; margin-left: 4px; text-align: left;">Q</label>
		<label style="width: 27%; margin-left: 4px; text-align: left;">Remarks</label>
		<input type="hidden" id="hiddenParType" name="hiddenParType" value="P" />
	</div>
	<div id="parListTable" class="tableContainer" style="font-size: 12px;">
		<c:forEach var="par" items="${searchResult}">
			<div id="row${par.parId}" name="row" class="tableRow">
				<input type="hidden" value="${par.issCd}" />
				<input type="hidden" value="${par.parStatus}" />
				<input type="hidden" value="${par.parNo}" />
				<input type="hidden" value="${par.assdNo}" />
				<input type="hidden" value="${par.assdName}" />
				<input type="hidden" value="${par.polFlag}" />
				<input type="hidden" value="${par.opFlag}" />
				<input type="hidden" value="${par.underwriter}" />
				<input type="hidden" value="${par.lineCd}" />
				<input type="hidden" value="${par.parId}" />
				<input type="hidden" value="${par.quoteId}" />
				<label style="width: 19.5%; text-align: left; margin-left: 15px;">${par.parNo}</label>
				<label style="width: 19%; text-align: left;">${par.assdName}</label>
				<label style="width: 8%; text-align: left;">${par.underwriter}</label>
				<label style="width: 20%; text-align: left;">${par.status}</label>
				<label style="width: 20px; margin-left: 4px; text-align: center;">
					<c:choose>
						<c:when test="${not empty par.quoteId}">
							<img name="checkedImg" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 1px;" />
						</c:when>
						<c:otherwise>
							<span style="float: left; width: 10px; height: 10px;">-</span>
						</c:otherwise>
					</c:choose>
				</label>
				<label style="width: 27%; margin-left: 4px; text-align: left;">${par.remarks}</label>
			</div>
		</c:forEach>
	</div>
	
	<div id="parListingJSON" name="parListingJSON" style="display: none;">
		<json:object>
			<json:array name="parList" var="p" items="${searchResult}">
				<json:object>
					<json:property name="parId" 		value="${p.parId}" />
					<json:property name="parNo" 		value="${p.parNo}" />
					<json:property name="assdName" 		value="${p.assdName}" />
					<json:property name="assdNo" 		value="${p.assdNo}" />
					<json:property name="underwriter" 	value="${p.underwriter}" />
					<json:property name="status" 		value="${p.status}" />
					<json:property name="issCd" 		value="${p.issCd}" />
				</json:object>
			</json:array>
		</json:object>
	</div>
	
	<jsp:include page="/pages/common/utils/pager.jsp"></jsp:include>
</div>
<script type="text/JavaScript">
	changeCheckImageColor();
	
	$$("div[name='row']").each(function (div)	{
		if ((div.down("label", 1).innerHTML).length > 20)	{
			div.down("label", 1).update((div.down("label", 1).innerHTML).truncate(20, "..."));
		}
		if ((div.down("label", 5).innerHTML).length > 30) {
			div.down("label", 5).update((div.down("label", 5).innerHTML).truncate(30, "..."));
		}
	});

	var parList = ($("parListingJSON").innerHTML).evalJSON();

	var addtlTools = '<label id="copy" name="copy">Copy</label>'+
 					 '<label id="cancelPar" name="cancelPar">Cancel</label>'+
					 '<label id="printPar" name="printPar">Print</label>'+
					 '<label id="returnToQuotation" name="returnToQuotation" style="width: 140px;">Return to Quotation</label>';

	$("delete").insert({after: addtlTools});
	
	$("copy").observe("click", function () {
		if (getSelectedRowId("row").blank()) {
			showMessageBox("Please select a PAR.", imgMessage.ERROR);
			return false;
		} else {
			showConfirmBox("Copy PAR Confirmation", "Copy PAR No. " + $("row"+getSelectedRowId("row")).down("input", 2).value, "Yes", "No", copyPAR, "");
		}
	});

	$("delete").observe("click", function () {
		if (getSelectedRowId("row").blank()) {
			showMessageBox("Please select a PAR.", imgMessage.ERROR);
			return false;
		} else {
			showConfirmBox("Delete PAR Confirmation", "Delete PAR No. " + $("row"+getSelectedRowId("row")).down("input", 2).value, "Yes", "No", deletePAR, "");
		}
	});
	

	$("printPar").observe("click", function() {
		if (getSelectedRowId("row").blank()) {
			showMessageBox("Please select a PAR.", imgMessage.ERROR);
			return false;
		}
	});


	$("cancelPar").observe("click", function () {
		if (getSelectedRowId("row").blank()) {
			showMessageBox("Please select a PAR.", imgMessage.ERROR);
			return false;
		} else {
			showConfirmBox("Cancel PAR Confirmation", "Cancel PAR No. " + $("row"+getSelectedRowId("row")).down("input", 2).value, "Yes", "No", cancelPAR, "");
		}
	});

	function cancelPAR() {
		var parId = getSelectedRowId("row");
		var parNo = $("row"+getSelectedRowId("row")).down("input", 2).value.replace(" - ", "-");
		new Ajax.Request(contextPath+"/GIPIPARListController?action=cancelPAR", {
			method: "GET",
			asynchronous: true,
			evalScripts: true,
			parameters: {
				parId: parId,
				issCd: $("row"+parId).down("input", 0).value,
				lineCd: $("row"+parId).down("input", 8).value,
				userId: $("row"+parId).down("input", 7).value
			},
			onCreate: function() {
				showNotice("Canceling PAR No. " + parNo);
			},
			onComplete: function (response) {
				$$("div[name='row']").each(function(row) {
					if(row.hasClassName("selectedRow"))  {
						row.remove();
					}	
				});
				hideNotice("");
				if (checkErrorOnResponse(response)) {
					showMessageBox(response.responseText, imgMessage.SUCCESS);
				}
			}
		});
	}

	function copyPAR() {
		var parId = getSelectedRowId("row");
		new Ajax.Request(contextPath+"/GIPIPARListController?action=copyParList", {
			method: "GET",
			asynchronous: true,
			evalScripts: true,
			parameters: {
				parId: parId,
				origParNo: $("row"+parId).down("input", 2).value,
				issCd: $("row"+parId).down("input", 0).value,
				lineCd: $("row"+parId).down("input", 8).value,
				userId: $("row"+parId).down("input", 7).value
			},
			onCreate: function() {
				showNotice("Initializing, please wait...");
			},
			onComplete: function (response) {
				if (checkErrorOnResponse(response)) {
					hideNotice("");
					showMessageBox(response.responseText, imgMessage.SUCCESS);
				}
			}
		});

		var statusUpdater = new Ajax.PeriodicalUpdater("noticeMessage", "GIPIPARListController", {
			asynchronous: true,
			method: "GET",
			frequency: 1,
			parameters: {
				action: "getCopyParStatus",
				parId: parId
			},
			onSuccess: function (response) {
				var status = response.responseText;
				if (!status.include("ERROR")) {
					if (status.include("Successfully copied PAR")) {
						statusUpdater.stop();
						showMessageBox("Successfully copied PAR");
					}
				} else {
					statusUpdater.stop();
					hideNotice("");
					showMessageBox(status);
				}
			}
		});
	}

	function deletePAR() {
		var parId = getSelectedRowId("row");
		var parNo = $("row"+getSelectedRowId("row")).down("input", 2).value.replace(" - ", "-");
		new Ajax.Request(contextPath+"/GIPIPARListController?action=deletePAR", {
			method: "GET",
			asynchronous: true,
			evalScripts: true,
			parameters: {
				parId: parId,
				issCd: $("row"+parId).down("input", 0).value,
				lineCd: $("row"+parId).down("input", 8).value,
				userId: $("row"+parId).down("input", 7).value,
				parNo: parNo
			},
			onCreate: function() {
				showNotice("Preparing to delete PAR No. " + parNo);
			},
			onComplete: function (response) {
				$$("div[name='row']").each(function(row) {
					if(row.hasClassName("selectedRow"))  {
						row.remove();
					}	
				});
				hideNotice("");
				if (checkErrorOnResponse(response)) {
					showMessageBox(response.responseText, imgMessage.SUCCESS);
				}
			}
		});
	}

	function returnPARToQuote() {
		var parId = getSelectedRowId("row");
		var qID = $("row"+parId).down("input", 10).value;
		if(qID.blank()) {
			showMessageBox("Quotation cannot be returned...Record originated from this module", imgMessage.ERROR);
			return false;
		} else {
			new Ajax.Request(contextPath+"/GIPIPARListController?action=updateStatusFromQuote", {
				method: "POST",
				asynchronous: true,
				evalScripts: true,
				parameters: {retQuoteId: qID},
				onCreate: function() {
					showNotice("Returning PAR...");
				},
				onComplete: function (response) {
					$$("div[name='row']").each(function(row) {
						if(row.hasClassName("selectedRow"))  {
							row.remove();
						}
					});
					hideNotice("");
					if (checkErrorOnResponse(response)) {
						showMessageBox(response.responseText, imgMessage.SUCCESS);
					}
				}
			});
		}
	}

	$("returnToQuotation").observe("click", function() {
		if (getSelectedRowId("row").blank()) {
			showMessageBox("Please select a PAR.", imgMessage.ERROR);
			return false;
		} else {
			var parId = getSelectedRowId("row");
			var qID = $("row"+parId).down("input", 10).value;
			if(!(qID.blank())) {
				showConfirmBox("Return PAR to Quotation?", 
						//"Return PAR No. " + $("row"+getSelectedRowId("row")).down("input", 2).value,
						"This option will automatically delete PAR No. " + $("row"+getSelectedRowId("row")).down("input", 2).value + " as a result of Return to Quotation function. Do you want to continue?", 
						"Yes", "No", returnPARToQuote, "");
			} else {
				showMessageBox("Quotation cannot be returned...Record originated from this module", imgMessage.ERROR);
			}
		}
	});
	
	//initializeTable("tableContainer", "row", "globalParId,globalIssCd,globalParStatus,globalParNo,globalAssdNo,globalAssdName,globalPolFlag,globalOpFlag", "");
	var pkHiddenFieldId = "globalParId,globalIssCd,globalParStatus,globalParNo,globalAssdNo,globalAssdName,globalPolFlag,globalOpFlag";
	$$("div.tableContainer div[name='row']").each(
		function (row){
			row.observe("mouseover", function ()	{
				row.addClassName("lightblue");
			});
			
			row.observe("mouseout", function ()	{
				row.removeClassName("lightblue");
			});
			
			row.observe("click", function ()	{
				row.toggleClassName("selectedRow");
				if (row.hasClassName("selectedRow"))	{
					if (!pkHiddenFieldId.blank()) {
						if (pkHiddenFieldId.split(",").size() > 1) {
							var pk = pkHiddenFieldId.split(",");
							$(pk[0]).value = row.readAttribute("id").substring(3);
							$(pk[1]).value = row.down("input", 0).value;
							$(pk[2]).value = row.down("input", 1).value;
							$(pk[3]).value = row.down("input", 2).value;
							$(pk[4]).value = row.down("input", 3).value;
							$(pk[5]).value = row.down("input", 4).value;
							$(pk[6]).value = row.down("input", 5).value;
							$(pk[7]).value = row.down("input", 6).value;
						}
					}
					$$("div.tableContainer div[name='row']").each(function (r)	{
						if (r.getStyle("display")!= "none")	{
							if (row.readAttribute("id") != r.readAttribute("id")) {
								r.removeClassName("selectedRow");
							}
						}
					});
				} else {
					if (!pkHiddenFieldId.blank()) {
						if (pkHiddenFieldId.split(",").size() > 1) {
							var pk = pkHiddenFieldId.split(",");
							$(pk[0]).value = "";
							$(pk[1]).value = "";
							$(pk[2]).value = "";
							$(pk[3]).value = "";
							$(pk[4]).value = "";
							$(pk[5]).value = "";
							$(pk[6]).value = "";
							$(pk[7]).value = "";
						}
					}
				}
			});
			
			observeAccessibleModule(accessType.ROW, "GIPIS002", row.id, function() {
				doubleClickPar(row);
			});
		}
	);

	function doubleClickPar(row) {				
		row.toggleClassName("selectedRow");
		if (row.hasClassName("selectedRow"))	{
			if (!pkHiddenFieldId.blank()) {
				if (pkHiddenFieldId.split(",").size() > 1) {
					var pk = pkHiddenFieldId.split(",");
					$(pk[0]).value = row.readAttribute("id").substring(3);
					$(pk[1]).value = row.down("input", 0).value;
					$(pk[2]).value = row.down("input", 1).value;
					$(pk[3]).value = row.down("input", 2).value;
					$(pk[4]).value = row.down("input", 3).value;
					$(pk[5]).value = row.down("input", 4).value;
					$(pk[6]).value = row.down("input", 5).value;
					$(pk[7]).value = row.down("input", 6).value;
				}
			}
			$$("div.tableContainer div[name='row']").each(function (r)	{
				if (r.getStyle("display")!= "none")	{
					if (row.readAttribute("id") != r.readAttribute("id")) {
						r.removeClassName("selectedRow");
					}
				}
			});

			//updateParParameters();
			if ($F("globalLineCd") == "SU"){
				showBondBasicInfo();
			}else{	
				showBasicInfo();
			}
		} else {
			if (!pkHiddenFieldId.blank()) {
				if (pkHiddenFieldId.split(",").size() > 1) {
					var pk = pkHiddenFieldId.split(",");
					$(pk[0]).value = "";
					$(pk[1]).value = "";
					$(pk[2]).value = "";
					$(pk[3]).value = "";
					$(pk[4]).value = "";
					$(pk[5]).value = "";
					$(pk[6]).value = "";
					$(pk[7]).value = "";
				}
			}
		}
	}
	
	if (!$("pager").innerHTML.blank()) {
		initializePagination("parListingTable", "/GIPIPARListController?lineCd="+$F("globalLineCd"), "filterParListing", 1);
	}
	
	$("filter").observe("click", function ()	{
		fadeElement("searchSpan", .3, null);
		toggleDisplayElement("filterSpan", .3, "appear", focusFilterText);
	});

	$("search").observe("click", function () {
		fadeElement("filterSpan", .3, null);
		toggleDisplayElement("searchSpan", .3, "appear", focusSearchText);
	});

	observeAccessibleModule(accessType.TOOLBUTTON, "GIPIS050", "add", showPARCreationPage);
	observeAccessibleModule(accessType.TOOLBUTTON, "GIPIS002", "edit", editPar);

	function editPar(){
		if ($F("globalParId").blank() || $F("globalIssCd").blank()) {
			showMessageBox("Please select a PAR.", imgMessage.ERROR);
			return false;
		} else {
			//updateParParameters();
			if ($F("globalLineCd") == "SU"){
				showBondBasicInfo();
			} else {	
				showBasicInfo();
			}
		}		
	}
	
	/*
	$("edit").observe("click", function () {
		if ($F("globalParId").blank() || $F("globalIssCd").blank()) {
			showMessageBox("Please select a policy.", imgMessage.ERROR);
			return false;
		} else {
			//updateParParameters();
			if ($F("globalLineCd") == "SU"){
				showBondBasicInfo();
			}else{	
				showBasicInfo();
			}
		}
	});*/

	//$("add").observe("click", showPARCreationPage);
	
	try {
		$("filterText").observe("keyup", function (evt) {
			if (evt.keyCode == 27) {
				$("filterText").clear();
				showAllRows("parListTable", "row");
				Effect.Fade("filterSpan", {
					duration: .3
				});
			} else if (evt.keyCode == 13) {
				Effect.Fade("filterSpan", {
					duration: .3
				});
			} else {
				var text = ($F("filterText").strip()).toUpperCase();
				for (var i=0; i<parList.parList.length; i++)	{
					if (//parList.parList[i].parId.match(text) != null || 
						parList.parList[i].assdName.toUpperCase().match(text) != null || 
						parList.parList[i].parNo.toUpperCase().match(text) != null || 
						parList.parList[i].status.toUpperCase().match(text) != null || 
						parList.parList[i].underwriter.toUpperCase().match(text) != null || 
						parList.parList[i].issCd.toUpperCase().match(text) != null)	{
						$("row"+parList.parList[i].parId).show();
					} else {
						$("row"+parList.parList[i].parId).hide();
					}
				}
			}
			positionPageDiv();
		});
	} catch (e) {
		showErrorMessage("editPar", e);
	}

	//$("delete").insert({after: "<label id='preview' name='preview'>Preview</label><label id='printLabel' name='printLabel'>Print</label>"});
/*
	$("preview").observe("click", function () {
		var id = getSelectedRowId("row");
		if (id.blank()) {
			showMessageBox("Please select a policy first.", imgMessage.ERROR);
			return false;
		} else {
			window.open(contextPath+"/PrintPolicyController?parId="+id+"&lineName="+$F("globalLineName")+"&action=preview&"+Math.random(), "Print Policy", "location=no,toolbar=no,menubar=no");
		}
	});

	$("printLabel").observe("click", function () {
		var id = getSelectedRowId("row");
		if (id.blank()) {
			showMessageBox("Please select a policy first.", imgMessage.ERROR);
			return false;
		} else {
			window.open(contextPath+"/PrintPolicyController?parId="+id+"&lineName="+$F("globalLineName")+"&action=print&"+Math.random(), "Print Policy", "location=no,toolbar=no,menubar=no");
		}
	}); */
</script>