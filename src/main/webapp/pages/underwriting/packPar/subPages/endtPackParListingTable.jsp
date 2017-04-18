<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="endtPackListingMainDiv" style="margin: 5px; display: none;">
	<jsp:include page="/pages/common/utils/toolbar.jsp"></jsp:include>
	<div class="tableHeader">
		<label style="width: 23%; text-align: left; margin-left: 20px;">Par No.</label>
		<label style="width: 12%; text-align: left;">User Id</label>
		<c:choose>
			<c:when test="${ora2010Sw eq 'Y'}">
				<label style="width: 20%; text-align: left;">Bank Reference No</label>
				<span style="width:  1%; float: left;">
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" 
						style="width: 14px; height: 14px; margin: 3px; float: right; display: none;" 
						title="Edit Remarks" alt="Edit" id="editRemarks"/>
				</span>
				<label style="width: 39%; text-align: left;">Remarks</label>
			</c:when>
			<c:otherwise>
				<span style="width:  1%; float: left;">
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" 
						style="width: 14px; height: 14px; margin: 3px; float: right; display: none;" 
						title="Edit Remarks" alt="Edit" id="editRemarks"/>
				</span>
				<label style="width: 59%; text-align: left;">Remarks</label>
			</c:otherwise>
		</c:choose>
		<input type="hidden" id="ora2010Sw" name="ora2010Sw" value="${ora2010Sw}">
		<input type="hidden" id="hiddenParType" name="hiddenParType" value="E">
	</div>

	<div id="endtPackParListTable" class="tableContainer" style="font-size: 12px;"></div>
	<div class="pager" id="pager">
		<div align="right">
		Page:
			<select id="page" name="page">
			</select> of <span id="totalPages"></span>
		</div>
	<input type="text" id="hidKeyEvents" style="width: 0; height: 0; border: none; background: transparent; z-index: -3000;"/>
	</div>
</div>

<script type="text/javascript">
	var pageActions = {none: 0, save : 1, pager : 2, edit : 3};
	var pAction = pageActions.none;
	var rowIndex;
	var objUser = JSON.parse('${user}');
	clearObjectValues(objUWGlobal);
	getEndtPackParList(1);
	changeTag = 0;

	var addtlTools = '<label id="printQuotation" name="printQuotation" style="width:100px;">Print Quotation</label>' +
					 '<label id="saveEndtPackPar" name="saveEndtPackPar">Save</label>';

	$("delete").insert({after: addtlTools});

	function getEndtPackParList(pageNo) {
		new Ajax.Request("GIPIPackPARListController", {
			method: "GET",
			parameters: {
				action: "filterEndtPackParListing",
				pageNo: pageNo == undefined ? $F("page") : pageNo,
				keyword: $F("keyword"),
				lineCd: $F("globalLineCd")
			},
			onCreate: showLoading("endtPackParListTable", "Retrieving Endorsement Package Par List, please wait...", "100px"),
			onComplete: function (response) {
				objUWParList = response.responseText.evalJSON();				
				generateEndtPackParTable(objUWParList);
				initializeEndtPackParTable();
			}
		});
	} 

	function generateEndtPackParTable(list) {
		$("endtPackParListTable").update();
		for (var i=0; i<list.jsonArray.length; i++) {
			var parItem = list.jsonArray[i];
			if(objUser.allUserSw == 'Y' || objUser.userId == parItem.underwriter){
				var row = '<div id="row'+parItem.packParId+'" packParId="'+parItem.packParId+'" "parStatus='+parItem.parStatus+' "name="row" class="tableRow">';
				row += '<label style="width: 23%; text-align: left; margin-left: 20px;">'+parItem.parNo+'</label>';
				row += '<label style="width: 12%; text-align: left;">'+parItem.underwriter+'</label>';
				if($("ora2010Sw").value == 'Y'){
					row += '<label style="width: 20%; text-align: left;">'+(parItem.bankRefNo == null ? '-': parItem.bankRefNo.truncate(18, '...'))+'</label>';
					row += '<label style="width: 40%; text-align: left;" id="remarks'+parItem.packParId+'">'+(parItem.remarks == null ? '-': parItem.remarks.truncate(40, '...'))+'</label>';
				}else{
					row += '<label style="width: 60%; text-align: left;" id="remarks'+parItem.packParId+'">'+(parItem.remarks == null ? '-': parItem.remarks.truncate(50, '...'))+'</label>';
				}
				row += '<input type="hidden" id="hidRemarks'+parItem.packParId+'" value="'+(parItem.remarks == null ? '': parItem.remarks)+'">';
				row += '</div>';
				$("endtPackParListTable").insert({bottom: row});
			}
		}
	}

	function initializeEndtPackParTable() {
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

		$$("div.tableContainer div[name='row']").each(
			function (row){
				row.observe("mouseover", function ()	{
					row.addClassName("lightblue");
				});
				
				row.observe("mouseout", function ()	{
					row.removeClassName("lightblue");
				});

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
				observeAccessibleModule(accessType.ROW, "GIPIS031A", row.id, function() {
					doubleClickEndtPackPar(row);
				});
			}
		);		
	}

	function doubleClickEndtPackPar(row){
		row.toggleClassName("selectedRow");
		if (row.hasClassName("selectedRow")){
			packParId = row.getAttribute("packParId");
			setGlobalPackParDetails(packParId);
											
			$$("div[name='row']").each(function (r)	{
				if (row.getAttribute("id") != r.getAttribute("id"))	{
					r.removeClassName("selectedRow");
				}
			});
			editEndtPackPar();
			
		} else {
			objUWGlobal.packParId = null;
		}		
	}
	
	$("filterText").observe("keyup", function (evt) {
		if (evt.keyCode == 27) {
			$("filterText").clear();
			showAllRows("endtPackParListTable", "row");
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
					null != row.down("label", 2).innerHTML.toUpperCase().match(text) ){
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
			fireEvent($("endtPackParListTable").down("div", rowIndex+1), "click");
		} else if (event.keyCode == 38 && rowIndex > 0){
			fireEvent($("endtPackParListTable").down("div", rowIndex-1), "click");	
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

	$("printQuotation").observe("click",function(){
		if(getSelectedRowId("row").blank()){
			showMessageBox("Please select a PAR.", imgMessage.ERROR);
			return false;
		}else{
			try{
			Modalbox.show(contextPath+"/PrintPolicyController?action=showReportGenerator&reportType=policy&globalParId="
					+nvl(objUWGlobal.parId, 0)+"&globalPackParId="+nvl(objUWGlobal.packParId,0),
					{ title: "Geniisys Report Generator",
					  width: 500
					}
		    );
			}catch(e){
				showErrorMessage("endtPackParListingTable.jsp - printQuotation", e);
			}
		}
	});

	$("editRemarks").observe("click", function () {
		if (getSelectedRowId("row").blank()) {
			showMessageBox("Please select a PAR.", imgMessage.ERROR);
			return false;
		} else {
			var id= getSelectedRowId("row");
			var truncateNo = $("ora2010Sw").value == 'Y'? 40 : 50;
			var title = "Remarks: " + $("row"+id).down("label", 0).innerHTML;
			
			showParRemarksEditor(title, "hidRemarks"+id, 4000, "remarks"+id, truncateNo, id);
		}
	});

	$("saveEndtPackPar").observe("click", function(){
		if(changeTag == 0){
			showMessageBox("No changes to save.");
			return false;
		}else{
			pAction = pageActions.save;
			updateEndtPackParRemarks();
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
					showWaitingMessageBox(response.responseText, imgMessage.SUCCESS, getEndtPackParList);
				}
			}
		});
	}

	function editEndtPackPar(){
		if (objUWGlobal.packParId == null || objUWGlobal.issCd == null) {
			showMessageBox("Please select a PAR.", imgMessage.ERROR);
			return false;
		} else {
			if(nvl(objUser.allUserSw,'N')== 'Y' && (nvl(objUser.misSW,'N')== 'Y' || nvl(objUser.mgrSw,'N')== 'Y')){
				pAction = pageActions.edit;
				validateChanges(showEndtPackParBasicInfo);
			}else if(objUser.userId != objUWGlobal.underwriter){
				showMessageBox("Record created by another user cannot be accessed.", imgMessage.INFO);
			}else if(objUser.userId == objUWGlobal.underwriter){
				pAction = pageActions.edit;
				validateChanges(showEndtPackParBasicInfo);
			}
		}		
	}

	function updateEndtPackParRemarks(){
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
							showWaitingMessageBox("Record has been save successfully.", imgMessage.INFO, showEndtPackParBasicInfo);
						}else if(pAction == pageActions.pager){
							showWaitingMessageBox("Record has been save successfully.", imgMessage.INFO, getEndtPackParList);
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

	observeAccessibleModule(accessType.TOOLBUTTON, "GIPIS031A", "edit", function() {
		if (objUWGlobal.packParId == null) {
			showMessageBox("Please select a PAR.", imgMessage.ERROR);
			return false;
		} else {
			setGlobalPackParDetails(objUWGlobal.packParId);
			editEndtPackPar();
		}
	});

	observeAccessibleModule(accessType.TOOLBUTTON, "GIPIS056A", "add", showEndtPackParCreationPage);

	function validateChanges(func){
		if(changeTag == 0){
			func();
		}else if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", updateEndtPackParRemarks, func, "");		
		}
	}

	$("page").observe("change", function () {
		if(changeTag == 0){
			getEndtPackParList(this.value);
		}else if(changeTag == 1){
			pAction = pageActions.pager;
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", updateEndtPackParRemarks,
			function(){
				getEndtPackParList(this.value);
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

