<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>	

<div id="mortgageeMaintenanceSubSectionDiv" class= "subSectionDiv" style="height: 457px; bottom: 10px;">
	<div id="mortgageeMaintenanceTable" style="height: 230px; position:relative; left:10px; top:10px; right: 10px;" ></div>
<!-- Form -->
	<div id="mortgageeMaintenanceInfo" class="subSectionDiv" style="top:10px; bottom:10px; position:relative; height: 180px;">
	<table align="center">
		<tr>
			<td class="rightAligned">Mortgagee</td>
			<td colspan="3" class="leftAligned"><input class="required upper" type="text" id="txtMortgCd" name="txtMortgCd" style="width: 145px;" maxlength="10" readonly="readonly" tabindex="101"/>
			<input class="required upper" type="text" id="txtMortgName" name="txtMortgName" style="width: 510px;" maxlength="50" readonly="readonly" tabindex="102"/>
			<input type="hidden" id="mortgageeId" name="mortgageeId" />
			<input type="hidden" id="lastValidMortgName" name="lastValidMortgName">
			<input type="hidden" id="origMortgName" name="origMortgName">
			<input type="hidden" id="lastValidMortgCd" name="lastValidMortgCd"></td>
		</tr>
		<tr>
			<td class="rightAligned">Mail Address 1</td>
			<td class="leftAligned"><input class="required upper" type="text" id="txtMailAddr1" name="txtMailAddr1" style="width: 296px;" maxlength="50" readonly="readonly" tabindex="103"/></td>
			<td class="rightAligned">TIN</td>
			<td class="leftAligned"><input class="required upper" type="text" id="txtTIN" name="txtTIN" style="width: 250px;" maxlength="30" readonly="readonly" tabindex="106"/></td>
		</tr>
		<tr>
			<td class="rightAligned">Mail Address 2</td>
			<td class="leftAligned"><input type="text" class="upper" id="txtMailAddr2" name="txtMailAddr2" style="width: 296px;" maxlength="50" readonly="readonly" tabindex="104"/></td>
			<td class="rightAligned">Designation</td>
			<td class="leftAligned"><input type="text" class="upper" id="txtDesignation" name="txtDesignation" style="width: 250px;"  maxlength="50" readonly="readonly" tabindex="107"/></td>
		</tr>
		<tr>
			<td class="rightAligned">Mail Address 3</td>
			<td class="leftAligned"><input type="text" class="upper" id="txtMailAddr3" name="txtMailAddr3" style="width: 296px;"  maxlength="50" readonly="readonly" tabindex="105"/></td>
			<td class="rightAligned" style="width: 100px;">Contact Person</td>
			<td class="leftAligned"><input type="text" class="upper" id="txtContactPers" name="txtContactPers" style="width: 250px;"  maxlength="50" readonly="readonly" tabindex="108"/></td>
		</tr>
		<tr>
			<td class="rightAligned">Remarks</td>
			<td colspan="3" class="leftAligned">
				<div style="border: 1px solid gray; width: 673px; height: 20px;">
					<textarea id="txtRemarks" name="txtRemarks" style="width: 639px; border: none; height: 12px;" readonly="readonly" tabindex="109"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarksText" />
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">User ID</td>
			<td class="leftAligned"><input type="text" id="txtUserId" name="txtUserId" readonly="readonly" style="width: 296px;" tabindex="110"/></td>
			<td class="rightAligned" width="85">Last Update</td>
			<td class="leftAligned"><input type="text" id="txtLastUpdate" name="txtLastUpdate" readonly="readonly" style="width: 250px;" tabindex="111"/></td>
		</tr>
	</table>
	</div>
<!-- Add/Delete -->
	<div style="float:left; width: 100%; margin-top: 10px; margin-bottom: 10px;" align = "center">
		<input type="button" class="disabledButton" id="btnAddMortgagee" name="btnAddMortgagee" value="Add" disabled="disabled" tabindex="201"/>
		<input type="button" class="disabledButton" id="btnDeleteMortgagee" name="btnDeleteMortgagee" value="Delete" disabled="disabled" tabindex="202"/>
	</div>
</div>

<script type="text/javascript">
	
	makeInputFieldUpperCase();
	changeTag = 0;
	var delObj;
	var rowObj;
	var deleteStatus = false;
	var addStatus = false;
	var unsavedStatus;
	var changeCounter = 0;
	objMortgMaintain = null;

	try{
	
		var row = 0;
		var objMortgageeMain = [];
		var objMortgagee = new Object();
		objMortgagee.objMortgageeListing = [];
		objMortgagee.objMortgageeMaintenance = objMortgagee.objMortgageeListing.rows || [];
	
		var mortgageeListTG = {
				url: contextPath+"/GIISMortgageeController?action=showMortgageeMaintenance",
				options: {
					width: '900px',
					height: '200px',
					onCellFocus: function(element, value, x, y, id){
						row = y;
						objMortgMaintain = mortgageeListTableGrid.geniisysRows[y];
						populateMortgageeDetails(objMortgMaintain);
						forUpdate();
					},
					onRemoveRowFocus: function(){
						mortgageeListTableGrid.keys.releaseKeys();
				 		mortgageeListTableGrid.keys.removeFocus(mortgageeListTableGrid.keys._nCurrentFocus, true);
				 		clearFields();
				 		formatAppearance();
				 		displayValue();
				 		objMortgMaintain = null;
            		},	
            		beforeSort: function(){
	            		if (changeTag == 1){
							showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
							return false;
                		} else {
                			displayValue();		
               			}				
            		},	
            		prePager: function(){
	            		if (changeTag == 1){
							showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
							return false;
                		} else {
                			formatAppearance();
                			displayValue();		
               			}				
            		},
            		onSort: function(){
            			formatAppearance();
            			clearFields();
            			displayValue();
            		},
					onRefresh: function(){
	            		if (changeTag == 1){
							showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
							return false;
                		} else {
                			formatAppearance();
                			clearFields();
                			displayValue();		
               			}
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
					},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
						onFilter: function(){
		            		if (changeTag == 1){
								showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
								return false;
	                		} else {
	                			formatAppearance();
	                			clearFields();
	                			displayValue();		
	               			}
						}	
					}
				},
				columnModel: [
					{   
						id: 'recordStatus',
			    		title: '',
			    		width: '0',
			    		visible: false,
			    		editor: 'checkbox' 			
					},
					{	
						id: 'divCtrId',
						width: '0',
						visible: false
					},
					{	
						id: 'issCd',
						width: '0',
						visible: false
					},
		    		{   		
						id: 'mortgCd',
			    		title: 'Code',
					    width: '80px',
					    visible: true,
			    		filterOption: true,
			    		sortable:true
					},
					{	
						id: 'mortgName',
						title: 'Mortgagee Name',
						width: '150px',
						visible: true,
						filterOption: true,
						sortable:true
					},
					{	
						id: 'mailAddr1',
						title: 'Address 1',
						width: '90px',
						visible: true,
						filterOption: true,
						sortable:true
					},
					{	
						id: 'mailAddr2',
						title: 'Address 2',
						width: '90px',
						visible: true,
						filterOption: true,
						sortable:true
					},
					{	
						id: 'mailAddr3',
						title: 'Address 3',
						width: '90px',
						visible: true,
						filterOption: true,
						sortable:true
					},
					{	
						id: 'designation',
						title: 'Designation',
						width: '90px',
						visible: true,
						filterOption: true,
						sortable:true
					},
					{	
						id: 'tin',
						title: 'TIN',
						width: '83px',
						visible: true,
						filterOption: true,
						sortable:true
					},
					{	
						id: 'contactPers',
						title: 'Contact Per.',
						width: '88px',
						visible: true,
						filterOption: true,
						sortable:true
					},
					{	
						id: 'remarks',
						title: 'Remarks',
						width: '88px',
						visible: true,
						filterOption: true,
						sortable:true
					},
					{	
						id: 'userId',
						width: '0px',
						visible: false
					},
					{	
						id: 'lastUpdate',
						width: '0px',
						visible: false
					}
				],
				rows: objMortgagee.objMortgageeMaintenance
		};
		mortgageeListTableGrid = new MyTableGrid(mortgageeListTG);
		mortgageeListTableGrid.pager = objMortgagee.objMortgageeListing;
		mortgageeListTableGrid.render('mortgageeMaintenanceTable');
		mortgageeListTableGrid.afterRender = function(){
			objMortgageeMain = mortgageeListTableGrid.geniisysRows;
			changeTag = 0;
		};
	
		function setMortgageeObj(func){
			var objMortgagee = new Object();
			objMortgagee.issCd 			= objSourceMaintain.issCd;
			objMortgagee.mortgCd 		= escapeHTML2($("txtMortgCd").value);
			objMortgagee.mortgName 		= escapeHTML2($("txtMortgName").value);
			objMortgagee.mailAddr1 		= escapeHTML2($("txtMailAddr1").value);
			objMortgagee.mailAddr2 		= escapeHTML2($("txtMailAddr2").value);
			objMortgagee.mailAddr3 		= escapeHTML2($("txtMailAddr3").value);
			objMortgagee.tin 			= escapeHTML2($("txtTIN").value);
			objMortgagee.designation 	= escapeHTML2($("txtDesignation").value);
			objMortgagee.contactPers 	= escapeHTML2($("txtContactPers").value);
			objMortgagee.remarks 		= escapeHTML2($("txtRemarks").value);
			objMortgagee.userId 		= $("txtUserId").value;
			objMortgagee.lastUpdate		= $("txtLastUpdate").value;
			objMortgagee.recordStatus   = func == "Delete" ? -1 : func == "Add" ? 0 : 1;
			return objMortgagee;
		}
	
		function populateMortgageeDetails(obj){
			$("issCd").value 			= obj == null ? "" : obj.issCd;
			$("txtMortgCd").value 		= obj == null ? "" : unescapeHTML2(obj.mortgCd);
			$("txtMortgName").value 	= obj == null ? "" : unescapeHTML2(obj.mortgName);
			$("origMortgName").value 	= obj == null ? "" : unescapeHTML2(obj.mortgName);
			$("txtMailAddr1").value 	= obj == null ? "" : unescapeHTML2(obj.mailAddr1);
			$("txtMailAddr2").value 	= obj == null ? "" : unescapeHTML2(obj.mailAddr2);
			$("txtMailAddr3").value 	= obj == null ? "" : unescapeHTML2(obj.mailAddr3);
			$("txtTIN").value 			= obj == null ? "" : unescapeHTML2(obj.tin);
			$("txtDesignation").value 	= obj == null ? "" : unescapeHTML2(obj.designation);
			$("txtContactPers").value 	= obj == null ? "" : unescapeHTML2(obj.contactPers);
			$("txtRemarks").value 		= obj == null ? "" : unescapeHTML2(obj.remarks);
			$("txtUserId").value 		= obj == null ? "" : obj.userId;
			$("txtLastUpdate").value 	= obj == null ? "" : obj.lastUpdate;
		}
	
		function validateAddMortgageeCd() {
			addStatus = false;
			rowObj  = setMortgageeObj($("btnAddMortgagee").value);
			new Ajax.Request(contextPath + "/GIISMortgageeController", {
				method : "POST",
				parameters : {
					action : "validateAddMortgageeCd",
					issCd :   rowObj.issCd,
					mortgCd : rowObj.mortgCd
				},
				asynchronous : false,
				evalScripts : true,
				onComplete : function(response) {
					if (response.responseText == '0') {
						addStatus = true;
						$("lastValidMortgCd").value = $("txtMortgCd").value;
					} else {
						customShowMessageBox("Mortgagee code already exists.", imgMessage.INFO, "txtMortgCd");
						$("txtMortgCd").value = $("lastValidMortgCd").value;
					}
				}
			});
		}
	
		function validateAddMortgageeName() {
			addStatus = false;
			rowObj  = setMortgageeObj($("btnAddMortgagee").value);
			new Ajax.Request(contextPath + "/GIISMortgageeController", {
				method : "POST",
				parameters : {
					action : "validateAddMortgageeName",
					issCd :   rowObj.issCd,
					mortgName : rowObj.mortgName
				},
				asynchronous : false,
				evalScripts : true,
				onComplete : function(response) {
					if (response.responseText == '0') {
						addStatus = true;
						$("lastValidMortgName").value = $("txtMortgName").value;
					} else {
						if ($F("btnAddMortgagee") != "Add") {
							if ($F("txtMortgName") == $F("origMortgName")){
							} else{
								customShowMessageBox("Mortgagee name already exists.", imgMessage.INFO, "txtMortgName");
								$("txtMortgName").value = $("origMortgName").value;
							}
						} else {
							customShowMessageBox("Mortgagee name already exists.", imgMessage.INFO, "txtMortgName");
							$("txtMortgName").value = $("lastValidMortgName").value;
						}
					}
				}
			});
		}
	
		function validateDeleteMortgagee(){
			deleteStatus = false;
			new Ajax.Request(contextPath+"/GIISMortgageeController",{
				method: "POST",
				parameters:{
					action : "validateDeleteMortgagee",
					issCd :   delObj.issCd,
					mortgCd : delObj.mortgCd
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice("Validating Mortgagee, please wait...");
				},
				onComplete: function(response){
					hideNotice("");
					if (checkErrorOnResponse(response)){
						if (response.responseText == '0') {
							deleteStatus = true;
						} else {
							showMessageBox("Cannot delete record from GIIS_MORTGAGEE while dependent record(s) in "+ response.responseText +" exists." ,"E");
						}
					}
				}
			});
		}
	
 		function deleteMortgagee(){
			delObj = setMortgageeObj($("btnDeleteMortgagee").value);
	 		validateDeleteMortgagee(); 
			if(deleteStatus){
				objMortgageeMain.splice(row, 1, delObj);
				mortgageeListTableGrid.deleteVisibleRowOnly(row);
				mortgageeListTableGrid.onRemoveRowFocus();
				if(changeCounter == 1 && unsavedStatus == 1){
					changeTag = 0;
					changeCounter = 0;
				}else{
					changeCounter++;
					changeTag=1;
				}
			}
		} 
	
		function addUpdateMortgagee(){
			rowObj = setMortgageeObj($("btnAddMortgagee").value);
			if(checkAllRequiredFieldsInDiv("mortgageeMaintenanceInfo")){
				if ($F("btnAddMortgagee") != "Add") {
					objMortgageeMain.splice(row, 1, rowObj);
					mortgageeListTableGrid.updateVisibleRowOnly(rowObj, row);
					mortgageeListTableGrid.onRemoveRowFocus();
					changeTag = 1;
					changeCounter++;
				} else {
					if(addStatus){
						unsavedStatus = 1;
						objMortgageeMain.push(rowObj);
						mortgageeListTableGrid.addBottomRow(rowObj);
						mortgageeListTableGrid.onRemoveRowFocus();
						clearFields();
						changeTag = 1;
						changeCounter++;
					}
				}
			}
		}
 
 		function saveMortgagee() {
 			var objParams = new Object();
			objParams.setRows = getAddedAndModifiedJSONObjects(objMortgageeMain);
			objParams.delRows = getDeletedJSONObjects(objMortgageeMain);
			new Ajax.Request(contextPath+"/GIISMortgageeController?action=saveMortgagee",{
				method: "POST",
				parameters:{
					parameters : JSON.stringify(objParams)
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					hideNotice("");
					changeTag = 0;
					if(checkErrorOnResponse(response)) {
						if (response.responseText == "SUCCESS"){
							showMessageBox(objCommonMessage.SUCCESS, "S");
							formatAppearance();
							clearFields();
							mortgageeListTableGrid.refresh();
						}
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}
 	
		function formatAppearance() {
			try{
				$("btnAddMortgagee").value = "Add";
				disableButton("btnDeleteMortgagee");
				populateMortgageeDetails(null);
				enableForm();
				mortgageeListTableGrid.keys.releaseKeys();
			}catch (e) {
				showErrorMessage("formatAppearance",e);
			}
		}
	
		function enableForm() {
			enableInputField("txtMortgCd");
			enableInputField("txtMortgName");
			enableInputField("txtMailAddr1");
			enableInputField("txtMailAddr2");
			enableInputField("txtMailAddr3");
			enableInputField("txtTIN");
			enableInputField("txtDesignation");
			enableInputField("txtContactPers");
			enableInputField("txtRemarks"); 
			$("txtMortgCd").focus();
		   	enableButton("btnAddMortgagee");		
		}
	
		function forUpdate() {
			mortgageeListTableGrid.keys.releaseKeys();
			$("btnAddMortgagee").value="Update";
			enableButton("btnDeleteMortgagee");
			disableInputField("txtMortgCd");
			$("txtMortgName").focus();
		}
	
		function displayValue() {
			$("txtLastUpdate").value = dateFormat(new Date(),'mm-dd-yyyy hh:MM:ss TT');
			$("txtUserId").value = "${PARAMETERS['USER'].userId}";
			$("txtMortgCd").focus();
		}
	
		function clearFields(){
			$("lastValidMortgCd").value = "";
			$("lastValidMortgName").value = "";
		}
 	
		function toUpperCase() {
			this.value = this.value.toUpperCase();
		}

		$("btnAddMortgagee").observe("click", function(){
			addUpdateMortgagee();
		});
	
		$("btnDeleteMortgagee").observe("click", function(){
			deleteMortgagee();
		});
	
		$("txtMortgCd").observe("change", function(){	
			if ($("txtMortgCd").value != "") {
				validateAddMortgageeCd();	
			}
		});

		$("txtMortgName").observe("change", function(){	
			if ($("txtMortgName").value != "") {
				validateAddMortgageeName();
			}
		});
	
		$("btnSaveMortgageeMain").observe("click", function() {
			if(changeTag == 0){
				showMessageBox(objCommonMessage.NO_CHANGES, "I");
			}else{
				saveMortgagee();
			}
		});
	
		observeReloadForm("reloadForm",showMortgageeMaintenance);	
	
		observeCancelForm("btnCancelMortgageeMain", saveMortgagee, function(){
			mortgageeListTableGrid.keys.releaseKeys();
			changeTag = 0;
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main" , null);
		});
	
		observeCancelForm("mortgageeMainExit", saveMortgagee, function(){
			mortgageeListTableGrid.keys.releaseKeys();
			changeTag = 0;
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main" , null);
		});

	}catch (e) {
	 	showErrorMessage("Mortgagee Maintenance Table Grid", e); 
	}
	
</script>