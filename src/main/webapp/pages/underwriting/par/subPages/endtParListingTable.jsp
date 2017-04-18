<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="endtParListingMainDiv" style="margin: 5px; display: none;">
	<jsp:include page="/pages/common/utils/toolbar.jsp"></jsp:include>
	<div class="tableHeader">
		<label style="width: 23%; text-align: left; margin-left: 20px;">PAR No.</label>
		<label style="width: 12%; text-align: left;">User Id</label>
		<label style="width: 60%; text-align: left;">Remarks</label>
		<input type="hidden" id="hiddenParType" name="hiddenParType" value="E" />
	</div>
	<div id="endtParListTable" class="tableContainer" style="font-size: 12px;">
		<c:forEach var="par" items="${searchResult}" varStatus="status">
			<div id="row${par.parId}" name="row" class="tableRow" rowIndex="${status.count}">
				<input type="hidden" value="${par.issCd}" />
				<input type="hidden" value="${par.parStatus}" />
			    <input type="hidden" value="${par.parNo}" />
			    <input type="hidden" value="${par.parYy}" />
			    <input type="hidden" value="${par.parType}" />
			    <input type="hidden" value="${par.remarks}" />
			    <input type="hidden" value="${par.underwriter}" />
			    <input type="hidden" value="${par.lineCd}" />
				<input type="hidden" value="${par.parId}" />
				<!-- <input type="hidden" value="${par.assdNo}" />
				<input type="hidden" value="${par.assdName}" />
				<input type="hidden" value="${par.polFlag}" />
				<input type="hidden" value="${par.opFlag}" />-->
				<label style="width: 23%; text-align: left; margin-left: 20px;">${par.parNo}</label>
				<label style="width: 12%; text-align: left;">${par.underwriter}</label>
				<label style="width: 60%; text-align: left;">${par.remarks}</label>
			</div>
		</c:forEach>
	</div>
	
	<div id="endtParListingJSON" name="endtParListingJSON" style="display: none;">
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
	<input type="text" id="hidKeyEvents" style="width: 0; height: 0; border: none; background: tranparent; z-index: -3000;"/>
</div>
<script type="text/JavaScript">	
	var rowIndex = 0;
	var rowCount = $$("div[name='row']").length;

	$$("div#endtParListTable div[name='row']").each(function (div)	{
		if ((div.down("label", 1).innerHTML).length > 30)	{
			div.down("label", 1).update((div.down("label", 1).innerHTML).truncate(30, "..."));
		}
		if ((div.down("label", 2).innerHTML).length > 70)	{
			div.down("label", 2).update((div.down("label", 2).innerHTML).truncate(70, "..."));
		}
		observeAccessibleModule(accessType.ROW, "GIPIS031", div.id, function() {
			doubleClickRow(div);
		});
		
		div.observe("click", function() {
			rowIndex = parseInt(div.getAttribute("rowIndex")) - 1;
			$("hidKeyEvents").focus();
		});
	});

	$("hidKeyEvents").observe("keyup", function(event){		
		if (event.keyCode == 13) { // when user press enter key
			fireEvent($("edit"), "click");
		} else if (event.keyCode == 35) { // when user press delete key
			fireEvent($("delete"), "click");
		}
	});
	
	$("hidKeyEvents").observe("keypress", function(event){
		if (event.keyCode == 40 && rowIndex < rowCount-1){
			fireEvent($("endtParListTable").down("div", rowIndex+1), "click");
		} else if (event.keyCode == 38 && rowIndex > 0){
			fireEvent($("endtParListTable").down("div", rowIndex-1), "click");	
		}
	});
	
	var parList = ($("endtParListingJSON").innerHTML).evalJSON();
	initializeTable("tableContainer", "row", "globalParId,globalIssCd,globalParStatus,globalParNo,globalParYy,globalParType,globalRemarks,globalUnderwriter", "");

	if (!$("pager").innerHTML.blank()) {
		initializePagination("endtParListingTable", "/GIPIPARListController?lineCd="+$F("lineCd"), "filterEndtParListing", 1);
	}

	$("filter").observe("click", function () {
		fadeElement("searchSpan", .3, null);
		toggleDisplayElement("filterSpan", .3, "appear", focusFilterText);
	});

	$("search").observe("click", function () {
		fadeElement("filterSpan", .3, null);
		toggleDisplayElement("searchSpan", .3, "appear", focusSearchText);
	});
	
	observeAccessibleModule(accessType.TOOLBUTTON, "GIPIS056", "add", showEndtParCreationPage);
	observeAccessibleModule(accessType.TOOLBUTTON, "GIPIS031", "edit", editEndtPar);

	function editEndtPar() {
		if ($F("globalParId").blank() || $F("globalIssCd").blank()) {
			showMessageBox("Please select a policy.", imgMessage.ERROR);
			return false;
		} else {
			if ($F("globalLineCd") == "SU"){
				showBondBasicInfo();
			}else{
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
			//updateEndtParParameters();
			if ($F("globalLineCd") == "SU"){
				showBondBasicInfo();
			}else{	
				showBasicInfo();
			}	
		}
	});

	$("add").observe("click", showEndtParCreationPage);
	*/
	var pkHiddenFieldId = "globalParId,globalIssCd,globalParStatus,globalParNo,globalParYy,globalParType,globalRemarks,globalUnderwriter";
	function doubleClickRow(row) {
		row.toggleClassName("selectedRow");
		if (row.hasClassName("selectedRow")) {
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
	
	try {		
		$("filterText").observe("keyup", function (evt) {
			if (evt.keyCode == 27) {
				$("filterText").clear();
				showAllRows("endtParListTable", "row");
			} else {
				var text = ($F("filterText").strip()).toUpperCase();
				for (var i=0; i<parList.parList.length; i++)	{
					if (//parList.parList[i].parId.match(text) != null || 
						parList.parList[i].parNo.toUpperCase().match(text) != null || 
						parList.parList[i].underwriter.toUpperCase().match(text) != null || 
						parList.parList[i].issCd.toUpperCase().match(text) != null)	{
						$("row"+parList.parList[i].parId).show();
					} else {
						$("row"+parList.parList[i].parId).hide();
					}
					if (!$("pager").innerHTML.blank()) {
						positionPageDiv();
					}
				}
			}
		});
	} catch (e) {
		showErrorMessage("doubleClickRow", e);
	}

	//fireEvent($("endtParListTable").down("div", 0), "click"); // andrew - 10.12.2010 - added this function call to select the first row on load
	//$("hidKeyEvents").focus();

	$("delete").observe("click", function () {
		if (getSelectedRowId("row").blank()) {
			showMessageBox("Please select an ENDT PAR.", imgMessage.ERROR);
			return false;
		} else {
			showConfirmBox("Delete PAR Confirmation", "Delete ENDT PAR No. " + $("row"+getSelectedRowId("row")).down("input", 2).value, "Yes", "No", deletePAR, "");
		}
	});

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
				lineCd: $("row"+parId).down("input", 7).value,
				userId: $("row"+parId).down("input", 6).value
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
</script>