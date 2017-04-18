<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giacs302MainDiv" name="giacs302MainDiv" style="">
	<div id="giacs302Div">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="giacs302Exit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Company Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giacs302" name="giacs302">		
		<div class="sectionDiv">
			<div id="giisFundTableDiv" style="padding-top: 10px;">
				<div id="giisFundTable" style="height: 340px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="giisFundFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Company Code</td>
						<td class="leftAligned" colspan="3">
							<input id="txtFundCd" type="text" class="required" style="width: 200px;" tabindex="101" maxlength="3">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Description</td>
						<td class="leftAligned" colspan="3">
							<input id="txtFundDesc" type="text" class="required" style="width: 533px;" tabindex="102" maxlength="50">
						</td>
					</tr>				
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="103"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="104"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="105"></td>
						<td width="" class="rightAligned" style="padding-left: 47px">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="106"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align = "center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="107">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="108">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="109">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="110">
</div>
<script type="text/javascript">	
	setModuleId("GIACS302");
	setDocumentTitle("Company Maintenance");
	initializeAll();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiacs302(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgGIISFund.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgGIISFund.geniisysRows);
		new Ajax.Request(contextPath+"/GIISFundsController", {
			method: "POST",
			parameters : {action : "saveGiacs302",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIACS302.exitPage != null) {
							objGIACS302.exitPage();
						} else {
							tbgGIISFund._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiacs302);
	
	var objGIACS302 = {};
	var objCurrGIISFund = null;
	objGIACS302.giisFundList = JSON.parse('${jsonGIISFund}');
	objGIACS302.exitPage = null;
	
	var giisFundTable = {
			url : contextPath + "/GIISFundsController?action=showGiacs302&refresh=1",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrGIISFund = tbgGIISFund.geniisysRows[y];
					setFieldValues(objCurrGIISFund);
					tbgGIISFund.keys.removeFocus(tbgGIISFund.keys._nCurrentFocus, true);
					tbgGIISFund.keys.releaseKeys();
					$("txtFundDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGIISFund.keys.removeFocus(tbgGIISFund.keys._nCurrentFocus, true);
					tbgGIISFund.keys.releaseKeys();
					$("txtFundCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgGIISFund.keys.removeFocus(tbgGIISFund.keys._nCurrentFocus, true);
						tbgGIISFund.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
				onSort: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGIISFund.keys.removeFocus(tbgGIISFund.keys._nCurrentFocus, true);
					tbgGIISFund.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGIISFund.keys.removeFocus(tbgGIISFund.keys._nCurrentFocus, true);
					tbgGIISFund.keys.releaseKeys();
				},				
				prePager: function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
					rowIndex = -1;
					setFieldValues(null);
					tbgGIISFund.keys.removeFocus(tbgGIISFund.keys._nCurrentFocus, true);
					tbgGIISFund.keys.releaseKeys();
				},
				checkChanges: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetail: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTag == 1 ? true : false);
				}
			},
			columnModel : [
				{ 								// this column will only use for deletion
				    id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
				    width: '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},	
				{
					id : "fundCd",
					title : "Company Code",
					filterOption : true,
					width : '150px'
				},
				{
					id : 'fundDesc',
					title : 'Description',
					filterOption : true,
					width : '500px'				
				},
				{
					id : 'remarks',
					width : '0',
					visible: false				
				},
				{
					id : 'userId',
					width : '0',
					visible: false
				},
				{
					id : 'lastUpdate',
					width : '0',
					visible: false				
				}
			],
			rows : objGIACS302.giisFundList.rows
		};

		tbgGIISFund = new MyTableGrid(giisFundTable);
		tbgGIISFund.pager = objGIACS302.giisFundList;
		tbgGIISFund.render("giisFundTable");
	
	function setFieldValues(rec){
		try{
			$("txtFundCd").value = (rec == null ? "" : unescapeHTML2(rec.fundCd));
// 			$("txtFundCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.fundCd)));
			$("txtFundDesc").value = (rec == null ? "" : unescapeHTML2(rec.fundDesc));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtFundCd").readOnly = false : $("txtFundCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrGIISFund = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.fundCd = escapeHTML2($F("txtFundCd"));
			obj.fundDesc = escapeHTML2($F("txtFundDesc"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiacs302;
			var dept = setRec(objCurrGIISFund);
			if($F("btnAdd") == "Add"){
				tbgGIISFund.addBottomRow(dept);
			} else {
				tbgGIISFund.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgGIISFund.keys.removeFocus(tbgGIISFund.keys._nCurrentFocus, true);
			tbgGIISFund.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("giisFundFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i=0; i<tbgGIISFund.geniisysRows.length; i++){
						if(tbgGIISFund.geniisysRows[i].recordStatus == 0 || tbgGIISFund.geniisysRows[i].recordStatus == 1){								
							if(unescapeHTML2(tbgGIISFund.geniisysRows[i].fundCd) == $F("txtFundCd")){
								addedSameExists = true;								
							}							
						} else if(tbgGIISFund.geniisysRows[i].recordStatus == -1){
							if(unescapeHTML2(tbgGIISFund.geniisysRows[i].fundCd) == $F("txtFundCd")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same fund_cd.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIISFundsController", {
						parameters : {action : "valAddRec",
									  fundCd : $F("txtFundCd")},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addRec();
							}
						}
					});
				} else {
					addRec();
				}
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}	
	
	function deleteRec(){
		changeTagFunc = saveGiacs302;
		objCurrGIISFund.recordStatus = -1;
		tbgGIISFund.deleteRow(rowIndex);
		tbgGIISFund.geniisysRows[rowIndex].fundCd = escapeHTML2($F("txtFundCd"));
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISFundsController", {
				parameters : {action : "valDeleteRec",
							  fundCd : $F("txtFundCd")},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						deleteRec();
					}
				}
			});
		} catch(e){
			showErrorMessage("valDeleteRec", e);
		}
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");	
	}	
	
	function cancelGiacs302(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIACS302.exitPage = exitPage;
						saveGiacs302();
					}, function(){
						goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");	
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");	
		}
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtFundDesc").observe("keyup", function(){
		$("txtFundDesc").value = $F("txtFundDesc").toUpperCase();
	});
	
	$("txtFundCd").observe("keyup", function(){
		$("txtFundCd").value = $F("txtFundCd").toUpperCase();
	});
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGiacs302);
	$("btnCancel").observe("click", cancelGiacs302);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("giacs302Exit").stopObserving("click");
	$("giacs302Exit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtFundCd").focus();	
</script>