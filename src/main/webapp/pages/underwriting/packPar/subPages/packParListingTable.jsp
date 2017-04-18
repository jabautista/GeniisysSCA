<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div style="margin: 5px; display: none;">
	<jsp:include page="/pages/common/utils/toolbar.jsp"></jsp:include>
	
	<div class="tableHeader">
		<label style="width: 19.5%; text-align: left; margin-left: 15px;">PAR No.</label>
		<label style="width: 19%; text-align: left;"> Assured Name</label>
		<label style="width: 8%; text-align: left;">User Id</label>
		<label style="width: 20%; text-align: left;">Status</label>
		<span style="width:  1%; float: left;">
			<img src="${pageContext.request.contextPath}/images/misc/edit.png" 
				style="width: 14px; height: 14px; margin: 3px; float: right; display: none;" 
				title="Edit Remarks" alt="Edit" id="editRemarks"/>
		</span>
		<label style="width: 14%; text-align: left; margin-left: 2px;">Remarks</label>
		<c:if test="${ora2010Sw eq 'Y'}">
			<label style="width: 15%; text-align: left; margin-left: 2px;">Bank Reference No.</label>
		</c:if>
		<input type="hidden" id="ora2010Sw" name="ora2010Sw" value="${ora2010Sw}">
		<input type="hidden" id="hidPackParType" name="hidPackParType" value="P"></input>
	</div>
	<div id="packParListTable" class="tableContainer" style="font-size: 12px;"></div>
	<div class="pager" id="pager">
		<div align="right">
		Page:
			<select id="page" name="page">
			</select> of <span id="totalPages"></span>
		</div>
	</div>
	<input type="text" id="hidKeyEvents" style="width: 0; height: 0; border: none; background: tranparent; z-index: -3000;"/>
</div>

<script type="text/javascript">
	var pageActions = {none: 0, save : 1, pager : 2, edit : 3};
	var pAction = pageActions.none;
	var rowIndex;
	var objUser = JSON.parse('${user}');
	clearObjectValues(objUWGlobal);
	getPackParList(1);
	changeTag = 0;
	
	var addtlTools = '<label id="cancelPackPar" name="cancelPackPar">Cancel</label>'+
					 '<label id="savePackPar">Save</label>';
					 
	$("delete").insert({after: addtlTools});
	
	function getPackParList(pageNo) {
		new Ajax.Request("GIPIPackPARListController", {
			method: "GET",
			parameters: {
				action: "filterPackParListing",
				pageNo: pageNo == undefined ? $F("page") : pageNo,
				keyword: $F("keyword"),
				lineCd: $F("globalLineCd")
			},
			onCreate: showLoading("packParListTable", "Retrieving Package Par List, please wait...", "100px"),
			onComplete: function (response) {
				objUWParList = response.responseText.evalJSON();				
				generatePackParTable(objUWParList);
				initializePackParTable();
			}
		});
	}

	function generatePackParTable(list) {
		$("packParListTable").update();
		for (var i=0; i<list.jsonArray.length; i++) {
			var parItem = list.jsonArray[i];
			if(objUser.allUserSw == 'Y' || objUser.userId == parItem.underwriter){
				var row = '<div id="row'+parItem.packParId+'" packParId="'+parItem.packParId+'" "parStatus='+parItem.parStatus+' "name="row" class="tableRow">';
				row += '<label style="width: 19.5%; text-align: left; margin-left: 15px;">'+parItem.parNo+'</label>';
				row += '<label style="width: 19%; text-align: left;" title="'+parItem.assdName+'">'+parItem.assdName.truncate(20, '...')+'</label>';
				row += '<label style="width: 8%; text-align: left;">'+parItem.underwriter+'</label>';			
				row += '<label style="width: 20%; text-align: left;">'+parItem.status+'</label>';
				row += '<label style="width: 30%; text-align: left; margin-left: 2px;" id="remarks'+parItem.packParId+'">'+(parItem.remarks == null ? '-': parItem.remarks.truncate(35, '...'))+'</label>';
				if($("ora2010Sw").value == 'Y'){
					row += '<label style="width: 15%; text-align: left; margin-left: 2px;" title="'+(parItem.bankRefNo == null ? '-': parItem.bankRefNo)+'">'+(parItem.bankRefNo == null ? '-': parItem.bankRefNo.truncate(18, '...'))+'</label>';
				}
				row += '<input type="hidden" id="hidRemarks'+parItem.packParId+'" value="'+(parItem.remarks == null ? '': changeSingleAndDoubleQuotes2(parItem.remarks))+'">';
				row += '</div>';
				$("packParListTable").insert({bottom: row});
			}
		}
	}

	function initializePackParTable() {
		$("page").update();
		if(objUWParList.noOfPages == 1){
			$("pager").hide();
		}else{
			for (var i=1; i<=objUWParList.noOfPages; i++) {
				$("page").insert({bottom: '<option value="'+i+'">'+i+'</option>'});
			}
			
			for (var i=0; i<$("page").length; i++) {
				if ($("page").options[i].value == objUWParList.pageNo) {
					$("page").options[i].selected = "selected";
				}
			}
			
			$("totalPages").update(objUWParList.noOfPages);
			positionPageDiv();
		}

		$("editRemarks").hide();
		rowIndex = 0;
		
		$$("div[name='row']").each(
			function (row)	{
				row.observe("mouseover", function ()	{
					row.addClassName("lightblue");
				});
				
				row.observe("mouseout", function ()	{
					row.removeClassName("lightblue");
				});

				if($("ora2010Sw").value == 'Y'){
					row.down("label", 4).setAttribute("style", "width: 15%; text-align: left; margin-left: 2px;");
					if((row.down("label", 4).innerHTML).length > 15){
						row.down("label", 4).update((row.down("label", 4).innerHTML).truncate(15, "..."));
				 	}
				}

				rowIndex = rowIndex + 1;
				row.setAttribute("rowIndex", rowIndex - 1);
				
				row.observe("click", function ()	{
					row.toggleClassName("selectedRow");
					rowIndex = parseInt(row.getAttribute("rowIndex"));
					$("hidKeyEvents").focus();
					if (row.hasClassName("selectedRow"))	{
						objUWGlobal.packParId = row.getAttribute("packParId");
						objUWGlobal.parNo = row.down("label", 0).innerHTML;
						objUWGlobal.parStatus = row.getAttribute("parStatus");
						
						$$("div[name='row']").each(function (r)	{
							if (row.getAttribute("id") != r.getAttribute("id"))	{
								r.removeClassName("selectedRow");
							}
						});
						$("editRemarks").show();
					} else {
						$("editRemarks").hide();
						objUWGlobal.packParId = null;
						objUWGlobal.parNo = null;
						objUWGlobal.parStatus = null;			
					}
				});

				observeAccessibleModule(accessType.ROW, "GIPIS002", row.id, function() {
					doubleClickPackPar(row);
				});
			}
		);		
	}

	function doubleClickPackPar(row){
		row.toggleClassName("selectedRow");
		if (row.hasClassName("selectedRow")){
			packParId = row.getAttribute("packParId");
			setGlobalPackParDetails(packParId);
											
			$$("div[name='row']").each(function (r)	{
				if (row.getAttribute("id") != r.getAttribute("id"))	{
					r.removeClassName("selectedRow");
				}
			});
			editPackPar();
			
		} else {
			objUWGlobal.packParId = null;
		}		
	}

	$("filterText").observe("keyup", function (evt) {
		if (evt.keyCode == 27) {
			$("filterText").clear();
			showAllRows("packParListTable", "row");
			Effect.Fade("filterSpan", {
				duration: .3
			});
		} else if (evt.keyCode == 13) {
			Effect.Fade("filterSpan", {
				duration: .3
			});
		} else {
			var text = replaceSpecialCharsInFilterText(($F("filterText").strip()).toUpperCase());
			rowIndex = 0;
			$$("div[name='row']").each(function (row) {
				if (null != row.down("label", 0).innerHTML.toUpperCase().match(text) ||
					null != row.down("label", 1).innerHTML.toUpperCase().match(text) ||
					null != row.down("label", 2).innerHTML.toUpperCase().match(text) ||
					null != row.down("label", 3).innerHTML.toUpperCase().match(text) ||
					null != row.down("label", 4).innerHTML.toUpperCase().match(text) ){
					rowIndex = rowIndex + 1;
					
					row.setAttribute("rowIndex", rowIndex - 1);
					row.show();
				} else {
					row.setAttribute("rowIndex", "");
					row.hide();
				}
				if (!$("pager").innerHTML.blank()) {
					positionPageDiv();
				}
			});
		}
	});

	$("hidKeyEvents").observe("keyup", function(event){		
		if (event.keyCode == 13) { // when user press enter key
			fireEvent($("edit"), "click");
		} else if (event.keyCode == 46) { // when user press delete key
			fireEvent($("delete"), "click");
		}
	});

	$("hidKeyEvents").observe("keypress", function(event){
		var rowCount = $$("div[name='row']").length;
		if (event.keyCode == 40 && rowIndex < rowCount-1){
			fireEvent($("packParListTable").down("div", rowIndex+1), "click");
		} else if (event.keyCode == 38 && rowIndex > 0){
			fireEvent($("packParListTable").down("div", rowIndex-1), "click");	
		}
	});

	$("delete").observe("click", function () {
		if (getSelectedRowId("row").blank()) {
			showMessageBox("Please select a PAR.", imgMessage.ERROR);
			return false;
		} else {
			checkRITablesBeforeDeletion();
		}
	});

	$("cancelPackPar").observe("click", function () {
		if (getSelectedRowId("row").blank()) {
			showMessageBox("Please select a PAR.", imgMessage.ERROR);
			return false;
		} else {
			checkRITablesBeforeCancel();
		}
	});

	$("editRemarks").observe("click", function () {
		if (getSelectedRowId("row").blank()) {
			showMessageBox("Please select a PAR.", imgMessage.ERROR);
			return false;
		} else {
			var id= getSelectedRowId("row");
			var truncateNo = $("ora2010Sw").value == 'Y'? 15 : 35;
			var title = "Remarks: " + $("row"+id).down("label", 0).innerHTML;
			
			showParRemarksEditor(title, "hidRemarks"+id, 4000, "remarks"+id, truncateNo, id);
		}
	});

	$("savePackPar").observe("click", function () {
		if (changeTag != 1) {
			showMessageBox("No changes to save.");
			return false;
		} else {
			pAction = pageActions.save;
			updatePackParRemarks();
		}
	});

	function focusHidKeyEvents(){
		$("hidKeyEvents").focus();
	}

	function checkRITablesBeforeDeletion(){
		var packParId = getSelectedRowId("row");
		var parNo = objUWGlobal.parNo;
		new Ajax.Request(contextPath+"/GIPIPackPARListController?action=checkRIBeforeDeleteCancel", {
			method: "GET",
			asynchronous: true,
			evalScripts: true,
			parameters: {
				packParId: packParId
			},
			onComplete: function (response) {
				if (checkErrorOnResponse(response)) {
					if(response.responseText == "Y"){
						showConfirmBox("Delete PAR Confirmation", "Delete PAR No. " + parNo + " ?", "Ok", "Cancel", deletePackPAR, focusHidKeyEvents);
					}else{
						showMessageBox("Cannot delete PAR since its binder is already posted.", imgMessage.ERROR);
					}
				}
			}
		});
	}

	function checkRITablesBeforeCancel(){
		var packParId = getSelectedRowId("row");
		var parNo = objUWGlobal.parNo;
		new Ajax.Request(contextPath+"/GIPIPackPARListController?action=checkRIBeforeDeleteCancel", {
			method: "GET",
			asynchronous: true,
			evalScripts: true,
			parameters: {
				packParId: packParId
			},
			onComplete: function (response) {
				if (checkErrorOnResponse(response)) {
					if(response.responseText == "Y"){
						showConfirmBox("Cancel PAR Confirmation", "Cancel PAR No. " + parNo +" ?", "Ok", "Cancel", cancelPackPAR, focusHidKeyEvents);
					}else{
						showMessageBox("Cannot cancel PAR since its binder is already posted.", imgMessage.ERROR);
					}
				}
			}
		});
	}

	function deletePackPAR() {
		var packParId = getSelectedRowId("row");
		var parNo = objUWGlobal.parNo;
		new Ajax.Request(contextPath+"/GIPIPackPARListController?action=deletePackPAR", {
			method: "GET",
			asynchronous: true,
			evalScripts: true,
			parameters: {
				packParId: packParId,
				parNo: parNo
			},
			onCreate: function() {
				showNotice("Preparing to delete PAR No. ");
			},
			onComplete: function (response) {
				$$("div[name='row']").each(function(row) {
					if(row.hasClassName("selectedRow"))  {
						row.remove();
					}	
				});
				hideNotice("");
				if (checkErrorOnResponse(response)) {
					showMessageBox(response.responseText, imgMessage.SUCCESS, getPackParList);
				}
			}
		});
	}
	
	function cancelPackPAR() {
		var packParId = getSelectedRowId("row");
		var parStatus = objUWGlobal.parStatus;
		var parNo = objUWGlobal.parNo;
		new Ajax.Request(contextPath+"/GIPIPackPARListController?action=cancelPackPAR", {
			method: "GET",
			asynchronous: true,
			evalScripts: true,
			parameters: {
				packParId: packParId,
				parNo: parNo,
				parStatus: parStatus
			},
			onCreate: function() {
				showNotice("Preparing to cancel PAR No. " + parNo);
			},
			onComplete: function (response) {
				$$("div[name='row']").each(function(row) {
					if(row.hasClassName("selectedRow"))  {
						row.remove();
					}	
				});
				hideNotice("");
				if (checkErrorOnResponse(response)) {
					showWaitingMessageBox(response.responseText, imgMessage.SUCCESS, getPackParList);
				}
			}
		});
	}

	function editPackPar(){
		if (objUWGlobal.packParId == null || objUWGlobal.issCd == null) {
			showMessageBox("Please select a PAR.", imgMessage.ERROR);
			return false;
		} else {
			if(nvl(objUser.allUserSw,'N')== 'Y' && (nvl(objUser.misSW,'N')== 'Y' || nvl(objUser.mgrSw,'N')== 'Y') && nvl('${directParOpenAccess}', 'N') == 'Y'){
				pAction = pageActions.edit;
				validateChanges(showPackParBasicInfo);
			}else if(objUser.userId != objUWGlobal.underwriter){
				showMessageBox("Record created by another user cannot be accessed.", imgMessage.INFO);
			}else if(objUser.userId == objUWGlobal.underwriter){
				pAction = pageActions.edit;
				validateChanges(showPackParBasicInfo);
			}
		}		
	}

	function updatePackParRemarks(){
		var modifiedRows = getModifiedJSONObjects(objUWParList.jsonArray);
		
		new Ajax.Request(contextPath+"/GIPIPackPARListController?action=updatePackParRemarks", {
			asynchronous: true,
			parameters:{
				updatedRows: prepareJsonAsParameter(modifiedRows)
			},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					if(response.responseText == "SUCCESS"){
						if(pAction == pageActions.save){
							showMessageBox("Record has been save successfully.");
						}else if(pAction == pageActions.edit){
							showWaitingMessageBox("Record has been save successfully.", imgMessage.INFO, showPackParBasicInfo);
						}else if(pAction == pageActions.pager){
							showWaitingMessageBox("Record has been save successfully.", imgMessage.INFO, getPackParList);
						}
						pAction = pageActions.none;
						changeTag = 0;
					}
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}

	function validateChanges(func){
		if(changeTag == 0){
			func();
		}else if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", updatePackParRemarks, func, "");		
		}
	}

	observeAccessibleModule(accessType.TOOLBUTTON, "GIPIS002", "edit", function() {
		if (objUWGlobal.packParId == null) {
			showMessageBox("Please select a PAR.", imgMessage.ERROR);
			return false;
		} else {
			setGlobalPackParDetails(objUWGlobal.packParId);
			editPackPar();
		}
	});

	observeAccessibleModule(accessType.TOOLBUTTON, "GIPIS050A", "add", function() {
		showPackPARCreationPage();		
	});

	$("page").observe("change", function () {
		if(changeTag == 0){
			getPackParList(this.value);
		}else if(changeTag == 1){
			pAction = pageActions.pager;
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", updatePackParRemarks,
			function(){
				getPackParList(this.value);
				changeTag = 0; 
			}, "");
		}
	});

	$("search").observe("click", function () {
		fadeElement("filterSpan", .3, null);
		toggleDisplayElement("searchSpan", .3, "appear", focusSearchText);
	});
	
	$("filter").observe("click", function () {
		fadeElement("searchSpan", .3, null);
		toggleDisplayElement("filterSpan", .3, "appear", focusFilterText);
	});

</script>