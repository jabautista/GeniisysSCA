<!-- 
Remarks		: Function Override Records TableGrid
Date		: 12.19.2012
Developer	: Shan
-->

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div class="sectionDiv" >
	<div id="functionOverrideRecordsTGDiv" style="padding: 20px 25px 20px 40px; height: 210px; width: 93%;">
		<div id="foRecordsTGDiv"></div>
	</div>
	
	<div id="foRecordsFieldsDiv" align="center" >
		<table style="margin-top: 20px;">
			<tr>
				<td>
					<input id="hidOverrideId" type="hidden" />
					<input id="hidOrigRemarks" type="hidden" />
				</td>
				<td class="leftAligned" colspan="3">
					<input id="chkApproveSw" type="checkbox" style="float: left; margin: 0 7px 0 5px;"><label for="chkApproveSw" style="margin: 0 4px 2px 2px;">Approve Switch</label>
				</td>
			</tr>	
			<tr>
				<td width="" class="rightAligned">Records for Approval</td>
				<td class="leftAligned" colspan="4">
					<input id="txtDisplay" type="text" readonly="readonly" style="width: 534px; float: left; " tabindex="201" maxlength="1000">
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Requested By</td>
				<td class="leftAligned">	
					<input id="txtRequestBy" type="text" readonly="readonly" style="width: 200px;" tabindex="202" >						
				</td>
				<td class="rightAligned">Request Date</td>
				<td class="leftAligned">
					<input id="txtRequestDate" type="text" readonly="readonly" style="width: 200px; " tabindex="203" >
				</td>		
			</tr>		
			<tr>
				<td width="" class="rightAligned">Remarks</td>
				<td class="leftAligned" colspan="4">
					<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
						<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="204"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="205"/>
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">User ID</td>
				<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="206"></td>
				<td width="" class="rightAligned" style="padding-left: 45px;">Last Update</td>
				<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="207"></td>
			</tr>	
		</table>
		
		<div style="margin: 10px;" align="center">
			<input type="button" class="button" id="btnUpdate" value="Update" tabindex="208">
		</div>
	</div>
	
	<div id="functionOverrideRecordsButtonDiv"  style="margin: 10px; padding: 10px; border-top: 1px solid #E0E0E0; margin-bottom: 0;" align="center">
		<input id="btnApproveFunctOverride" name="btnApproveFunctOverride" type="button" class="button" value="Approve" style="width: 90px;" tabindex="209">
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="210">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="211">
</div>
<script type="text/javascript">
	changeTag = 0;

	var selectedIndex = -1; //holds the selected index
	var selectedRowInfo = ""; //holds the selected row info

	var objFuncOvride = null;
	var objFunctOverrideRec = new Object();
	//objFunctOverrideRec.functOverrideRecTableGrid = JSON.parse('${functionOverrideGrid}'.replace(/\\/g, '\\\\'));
	objFunctOverrideRec.functOverrideRecList = []; //holds all the geniisys rows
	objFunctOverrideRec.functOverrideRecObjRows = objFunctOverrideRec.functOverrideRecList.rows || [];

	try {
		var functOverrideRecTableModel = {
			url : contextPath + "/GICLFunctionOverrideController?action=getGICLS183FunctionOverrideRecordsListing",
			options : {
				width : '850px',
				height : '180px',
				onCellFocus : function(element, value, x, y, id) {
					selectedIndex = y;
					selectedRowInfo = functionOverrideRecordsTableGrid.geniisysRows[y];
					objFuncOvride = functionOverrideRecordsTableGrid.geniisysRows[y];
					
					//toggleApproveFunctButton();
					setFieldValues(objFuncOvride);
					//functionOverrideRecordsTableGrid.keys.releaseKeys();
					$("txtDisplay").focus();
				},
				onRemoveRowFocus : function() {
					functionOverrideRecordsTableGrid.keys.releaseKeys();
					functionOverrideRecordsTableGrid.keys.removeFocus(functionOverrideRecordsTableGrid.keys._nCurrentFocus, true);
					//toggleApproveFunctButton();
					selectedIndex = -1;
					selectedRowInfo = null;
					setFieldValues(null);
				},
				onCellBlur : function(element, value, x, y, id) {
					observeChangeTagInTableGrid(functionOverrideRecordsTableGrid);
				},
				/*beforeSort : function() {
					//var objFunctions = functionOverrideRecordsTableGrid.getModifiedRows();
					if (checkChangesInGICLS183Remarks()) {
						showConfirmBox4("Confirmation",objCommonMessage.WITH_CHANGES, "Yes", "No","Cancel", 
								function() {
									updateFunctionOverride(false);
									functionOverrideRecordsTableGrid._refreshList();
									functionOverrideRecordsTableGrid.onRemoveRowFocus();
								}, 
								function() {
									functionOverrideRecordsTableGrid._refreshList();
									functionOverrideRecordsTableGrid.onRemoveRowFocus();
								}, 
								"");
						return false;
					} else {
						return true;
					}
				},*/
				beforeSort : function(){
					if(checkChangesInGICLS183Remarks()/*changeTag == 1*/){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
				prePager : function(){
					if(checkChangesInGICLS183Remarks()/*changeTag == 1*/){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
				checkChanges : function() {
					return (checkChangesInGICLS183Remarks()/*changeTag == 1*/ ? true : false);
				},
				masterDetailRequireSaving : function() {
					return (checkChangesInGICLS183Remarks()/*changeTag == 1*/ ? true : false);
				},
				masterDetailValidation : function() {
					return (checkChangesInGICLS183Remarks()/*changeTag == 1*/ ? true : false);
				},
				masterDetail : function() {
					return (checkChangesInGICLS183Remarks()/*changeTag == 1*/ ? true : false);
				},
				masterDetailSaveFunc : function() {
					return (checkChangesInGICLS183Remarks()/*changeTag == 1*/ ? true : false);
				},
				masterDetailNoFunc : function() {
					return (checkChangesInGICLS183Remarks()/*changeTag == 1*/ ? true : false);
				},
				onSort : function() {
					functionOverrideRecordsTableGrid.onRemoveRowFocus();
				},
				onRefresh : function() {
					functionOverrideRecordsTableGrid.onRemoveRowFocus();
				},
				toolbar : {
					elements : [ MyTableGrid.REFRESH_BTN,
							MyTableGrid.FILTER_BTN ],
					onFilter : function() {
						functionOverrideRecordsTableGrid.onRemoveRowFocus();
						disableButton("btnApproveFunctOverride");
					},
					onSave : function() {
						updateFunctionOverride(false);
						disableButton("btnApproveFunctOverride");
					}
				}
			},
			columnModel : [
					{
						id : 'recordStatus',
						width : '0px',
						visible : false,
						editor : 'checkbox'
					},
					{
						id : 'divCtrId',
						width : '0px',
						visible : false
					},
					{
						id : 'overrideId',
						width : '0px',
						visible : false
					},
					{
						id : 'approveSw',
						title: 'A',
						altTitle: 'Approve',
						width : '25px',
						align : 'center',
						editable : true,
						editor : new MyTableGrid.CellCheckbox({
							getValueOf : function(value) {
								if (value) {
									return "Y";
								} else {
									return "N";
								}
							},
							onClick: function(value, checked){
								if (checked){
									functionOverrideRecordsTableGrid.geniisysRows[selectedIndex].approveSw = "Y";
									$("chkApproveSw").checked = true;
								}else{
									functionOverrideRecordsTableGrid.geniisysRows[selectedIndex].approveSw = "N";
									$("chkApproveSw").checked = false;									
								}
								toggleApproveFunctButton();
							}
						})

					},
					{
						id : 'display',
						title : 'Records for Approval',
						width : '250px',
						titleAlign : 'center',
						visible : true,
						filterOption : true
					},
					{
						id : 'requestDate',
						title : 'Request Date',
						width : '86px',
						titleAlign : 'center',
						align : 'center',
						visible : true,
						filterOption : true,
						filterOptionType : 'formattedDate',
						type : 'date'
					},
					{
						id : 'requestBy',
						title : 'Requested By',
						width : '90px',
						titleAlign : 'center',
						visible : true,
						filterOption : true
					},
					{
						id : 'origRemarks',
						width : '0px',
						visible : false
					},
					{
						id : 'remarks',
						title : 'Remarks',
						width : '147px'
						/*titleAlign : 'center',
						editable : true,
						filterOption : true,
						maxlength : 4000,
						editor : new MyTableGrid.EditorInput(
								{
									onClick : function() {
										var coords = functionOverrideRecordsTableGrid
												.getCurrentPosition();
										var x = coords[0];
										var y = coords[1];
										var title = "Remarks ("+ functionOverrideRecordsTableGrid.geniisysRows[y].overrideId+ ")";
										showTableGridEditor(functionOverrideRecordsTableGrid, x, y, title, 4000, false);
									},
									render : function(value) {
										return unescapeHTML2(value);
									}
								})*/
					}, 
					{
						id : 'userId',
						title : 'User ID',
						width : '80px',
						titleAlign : 'center',
						visible : true,
						filterOption : true
					}, 
					{
						id : 'dspLastUpdate',
						title : 'Last Update',
						width : '130px',
						titleAlign : 'center',
						visible : true,
						filterOption : true
					} ],
			rows : objFunctOverrideRec.functOverrideRecObjRows
		};

		functionOverrideRecordsTableGrid = new MyTableGrid(functOverrideRecTableModel);
		functionOverrideRecordsTableGrid.pager = objFunctOverrideRec.functOverrideRecList;
		functionOverrideRecordsTableGrid.render(/*'functionOverrideRecordsTGDiv'*/'foRecordsTGDiv');
		functionOverrideRecordsTableGrid.afterRender = function() {
			objFunctOverrideRec.functOverrideRecList = functionOverrideRecordsTableGrid.geniisysRows;
			changeTag = 0;
		};

	} catch (e) {
		showMessageBox('Error in Function Records TableGrid: ' + e, imgMessage.ERROR);
	}

	function setFieldValues(rec){
		$("hidOverrideId").value = (rec == null ? "" : rec.overrideId);
		$("chkApproveSw").checked = (rec == null ? false : (rec.approveSw == "Y" ? true : false));
		$("txtDisplay").value = (rec == null ? "" : unescapeHTML2(rec.display));
		$("txtRequestBy").value = (rec == null ? "" : rec.requestBy);
		$("txtRequestDate").value = (rec == null ? "" : (rec.requestDate == null ? "" : dateFormat(rec.requestDate, "mm-dd-yyyy")));
		$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
		$("hidOrigRemarks").value = (rec == null ? "" : unescapeHTML2(rec.origRemarks));
		$("txtUserId").value = (rec == null ? "" : rec.userId);
		$("txtLastUpdate").value = (rec == null ? "" : rec.dspLastUpdate);
		
		$("chkApproveSw").disabled = true; //(rec == null ? true : false);
		$("txtRemarks").readOnly = (rec == null ? true : false);
		rec == null ? disableButton("btnUpdate") : enableButton("btnUpdate");
		
		objFuncOvride = rec;
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.overrideId = $F("hidOverrideId");
			obj.approveSw = $("chkApproveSw").checked ? "Y" : "N";
			obj.display = escapeHTML2($F("txtDisplay"));
			obj.requestBy = $F("txtRequestBy");
			obj.requestDate = $F("txtRequestDate");
			obj.origRemarks = escapeHTML2($F("hidOrigRemarks"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
			
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			if ($F("hidOrigRemarks") != unescapeHTML2($F("txtRemarks"))){
				objGICLS183.remarksChanged = true;
			}
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function updateRec(){
		try {			
			var fo = setRec(objFuncOvride);
			functionOverrideRecordsTableGrid.updateVisibleRowOnly(fo, selectedIndex, false);
			changeTag = 1;
			setFieldValues(null);
			functionOverrideRecordsTableGrid.keys.removeFocus(functionOverrideRecordsTableGrid.keys._nCurrentFocus, true);
			functionOverrideRecordsTableGrid.keys.releaseKeys();
			//toggleApproveFunctButton();
			changeTagFunc = function(){
				//if ($("btnApproveFunctOverride").hasClassName("disabledButton") ){
					updateFunctionOverride(false);
				/*}else{
					updateFunctionOverride(true);
				}*/
			};
		} catch(e){
			showErrorMessage("updateRec", e);
		}
	}		
	
	function toggleApproveFunctButton() {
		var approve = false;
		for ( var i = 0; i < objFunctOverrideRec.functOverrideRecList.length; i++) {
			if ($("mtgInput"+functionOverrideRecordsTableGrid._mtgId+"_3,"+i).checked){
			//if (functionOverrideRecordsTableGrid.getValueAt(functionOverrideRecordsTableGrid.getColumnIndex('approveSw'), i) == "Y") 
			//if(functionOverrideRecordsTableGrid.geniisysRows[i].approveSw == "Y")
				enableButton("btnApproveFunctOverride");
				approve = true;
				break;
			} else {
				disableButton("btnApproveFunctOverride");
			}
		}
		
		return approve;
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});	
	
	$("btnUpdate").observe("click", updateRec);
	
	observeSaveForm("btnSave", function(){
		/*if (toggleApproveFunctButton){
			updateFunctionOverride(true);
		}else{*/
			updateFunctionOverride(false);
		//}
	});
	
	setFieldValues(null);
	objGICLS183.remarksChanged = false;
</script>
