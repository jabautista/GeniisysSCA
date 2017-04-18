<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="ObligeeMaintenanceTableGridDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="obligeeMaintenanceExit">Exit</a></li>
				</ul>
			</div>
		</div>
	<!-- </div> -->
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Obligee Information Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
		   		<label id="obligeeReloadForm" name="obligeeReloadForm">Reload Form</label>
	   		</span>
	   	</div>
	</div>

	<div id="obligeeInformationMainDiv" name="obligeeInformationMainDiv" class="sectionDiv">
		<div id="obligeeInformationDiv" name="obligeeInformationDiv" class="">
			<div id="obligeeInformationDiv" name="obligeeInformationDiv" class="">
				<div id="obligeeInformationTGDiv" name="obligeeInformationTGDiv" style="height: 320px; width: 99%; padding: 10px 10px 20px 10px;">
				
				</div>
			</div>
			
			<div id="obligeeInformationTextDiv" name="obligeeInformationTextDiv" class="" style="margin: 0;">
				<table align="center" style="margin-top: 0;">
					<tr>
						<td class="rightAligned">Obligee No.</td>
						<td colspan="3">
							<!-- <input type="text" id="txtObligeeNo" name="txtObligeeNo" hidden="true"> -->
							<input id="txtObligeeNo" name="txtObligeeNo" type="text" align="right" style="float: left; width: 200px; text-align: right; margin-right: 25px;" maxlength="6" readonly="readonly" >
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Obligee Name</td>
						<td colspan="3"><input id="txtObligeeName" name="txtObligeeName" class="required upper" type="text" style="float: left; width: 503px; height: 13px; margin: 0px;" tabindex="101" maxlength="100" ></td>
					</tr>
					<tr>
						<td class="rightAligned">Contact Person</td>
						<td colspan="3"><input id="txtObligeeContactPerson" name="txtObligeeContactPerson" class="leftAligned upper" type="text" style="float: left; width: 503px;" tabindex="102" maxlength="50" ></td>
					</tr>
					<tr>
						<td class="rightAligned">Designation</td>
						<td><input id="txtObligeeDesignation" name="txtObligeeDesignation" class="leftAligned upper" type="text" align="right" style="float: left; width: 200px; margin-right: 25px;" tabindex="103" maxlength="30" ></td>
						<td class="rightAligned">Telephone</td>
						<td><input id="txtObligeeTelephone" name="txtObligeeTelephone" class="leftAligned upper" type="text" align="right" style="float: left; width: 195px;" tabindex="104" maxlength="40" ></td>
					</tr>
					<tr>
						<td class="rightAligned">Address</td>
						<td colspan="3"><input id="txtObligeeAddress" name="txtObligeeAddress" class="leftAligned" type="text" style="float: left; width: 503px; height: 13px; margin: 0px;" tabindex="105" maxlength="50" ></td>
					</tr>
					<tr>
						<td class="rightAligned"></td>
						<td colspan="3"><input id="txtObligeeAddress2" name="txtObligeeAddress2" class="leftAligned" type="text" style="float: left; width: 503px; height: 13px; margin: 0px;" tabindex="105" maxlength="50" ></td>
					</tr>
					<tr>
						<td class="rightAligned"></td>
						<td colspan="3"><input id="txtObligeeAddress3" name="txtObligeeAddress3" class="leftAligned" type="text" style="float: left; width: 503px; height: 13px; margin: 0px;" tabindex="105" maxlength="50" ></td>
					</tr>
					<tr>
						<td class="rightAligned">Remarks</td>
						<td colspan="3">
							<div style="border: 1px solid gray; height: 20px; width: 509px;">
								<textarea id="txtObligeeRemarks" name="txtObligeeRemarks" style="width: 480px; border: none; height: 13px; margin: 0px; resize: none;" maxlength="4000" onkeyup="limitText(this,4000);" tabindex="106"/></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td><input type="text" id="txtUserId" name="txtUserId" style="width:200px;" maxlength="8" tabindex="410" readonly="readonly" /></td>
						<td class="rightAligned">Last Update</td>
						<td><input type="text" id="txtLastUpdate" name="txtLastUpdate" style="width:195px;" maxlength="8" tabindex="411" readonly="readonly" /></td>
					</tr>
				</table>
				
				<div id="obligeeInformationButtonsDiv" name="obligeeInformationButtonsDiv" class="buttonsDiv" style="margin-bottom: 10px;">
					<input id="btnAddObligee" name="btnAddObligee" type="button" class="button" value="Add" tabindex="410">
					<input id="btnDeleteObligee" name="btnDeleteObligee" type="button" class="button" value="Delete" tabindex="411">
				</div>
			</div>
		</div>
	</div>
	<div id="cancelSaveButtonsDiv" name="cancelSaveButtonsDiv" class="buttonsDiv" style="margin-bottom: 50px;">
		<input id="btnCancelObligee" name="btnCancelObligee" type="button" class="button" value="Cancel" tabindex="410">
		<input id="btnSaveObligee" name="btnSaveObligee" type="button" class="button" value="Save" tabindex="411">
	</div>
</div>

<script type="text/javascript">
	setModuleId("GIISS017");
	setDocumentTitle("Obligee Information Maintenance");
	makeInputFieldUpperCase();
	changeTag = 0;
	
	var obligeeListSelectedIndex = -1;		// holds the selected index
	var obligeeListSelectedInfoRow = "";	// holds the selected geniisysrow
	var appUser = "${appUser}";
	
	var objObligee = new Object();
	objObligee.objObligeeListTableGrid = JSON.parse('${obligeeList}'.replace(/\\/g, '\\\\'));
	objObligee.objObligeeList = objObligee.objObligeeListTableGrid.rows || [];
	objObligee.objObligeeTbl = [];			// holds all the geniisysrows
	
	try {
		var obligeeTableModel = {
			//url: contextPath+"/GIISObligeeController?action=getObligeeListMaintenance"+"&refresh=1",
			url: contextPath+"/GIISObligeeController?action=getObligeeListMaintenance",
			id: 2,
			title: '',
			options: {
				height: '308px',
				width: '900px',
				onCellFocus: function(element, value, x, y, id){
	          		obligeeTableGrid.keys.releaseKeys();
	          		obligeeListSelectedIndex = y;
	          		obligeeListSelectedInfoRow = obligeeTableGrid.geniisysRows[y];
	          		toggleObligeeInfoButtons();
	          		populateObligeeInfoDetails(true); 
	       		 },
	       		onRemoveRowFocus: function(){
                	obligeeListSelectedIndex = -1;
                	obligeeListSelectedInfoRow = null;
                	toggleObligeeInfoButtons();
                	populateObligeeInfoDetails(false);
                	obligeeTableGrid.keys.removeFocus(obligeeTableGrid.keys._nCurrentFocus, true);
                	obligeeTableGrid.keys.releaseKeys();                	
	          	},
	          	prePager : function (){
					if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
						return false;
					}  else {
						return true;
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
				beforeSort: function(){
					if (changeTag == 1) {
						showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
						return false;
					} else {
						return true;
					}
				},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN]
				}				
			},
			columnModel: [
				{ 	id: 'recordStatus',
					width: '0px',
					visible: false,
					editor: 'checkbox'
				},
				{	id: 'divCtrId',
					width: '0px',
					visible: false
				},
				{	id: 'rowNum',
					title: 'rowNum',
					width: '0px',
					visible: false
				},
				{	id: 'rowCount',
					title: 'rowCount',
					width: '0px',
					visible: false
				},
				{	id: 'obligeeNo',
					title: 'Obligee No.',
					titleAlign: 'right',
					align: 'right',
					width: '85px',
					filterOption: true,
					filterOptionType: "integerNoNegative",
					renderer: function(value){
						return value == "" ? "" : formatNumberDigits(value, 6);
					}
				},
				{	id: 'obligeeName',
					title: 'Obligee Name',
					width: '155px',
					filterOption: true
				},
				{	id: 'contactPerson',
					title: 'Contact Person',
					width: '120px',
					filterOption: true
				},
				{	id: 'designation',
					title: 'Designation',
					width: '110px',
					filterOption: true
				},
				{	id: 'address',
					title: 'Address',
					width: '151px',
					filterOption: true 
				},
				{	id: 'phoneNo',
					title: 'Telephone',
					width: '100px',
					filterOption: true
				},
				{	id: 'remarks',
					title: 'Remarks',
					width: '135px'
				}
			],
			rows: objObligee.objObligeeList
		};
		
		obligeeTableGrid = new MyTableGrid(obligeeTableModel);
		obligeeTableGrid.pager = objObligee.objObligeeListTableGrid;
		obligeeTableGrid.render('obligeeInformationTGDiv');
		obligeeTableGrid.afterRender = function(){
			obligeeListSelectedIndex = -1; //marco - 05.02.2013
			objObligee.objObligeeTbl = obligeeTableGrid.geniisysRows;
			populateObligeeInfoDetails(false);
			toggleObligeeInfoButtons();
		}; 
	} catch(e) {
		showMessageBox("Error in Obligee Information TableGrid: " + e, imgMessage.ERROR);
	}
	
	var objGIISS017 = {};
	
	function deleteObligee(){
		try{
			changeTagFunc = saveObligee;
			var objObligeeToDelete = createObjObligee("Delete");
			objObligee.objObligeeTbl.splice(obligeeListSelectedIndex, 1, objObligeeToDelete);
			obligeeTableGrid.deleteVisibleRowOnly(obligeeListSelectedIndex);
			obligeeTableGrid.onRemoveRowFocus();
			changeTag = 1;
		}catch(e){
			showErrorMessage("deleteObligee: " +e, imgMessage.ERROR);
		}	
	}
	
	function validateObligeeNoOnDelete(){
		try{
			new Ajax.Request(contextPath+"/GIISObligeeController",{
				method: "POST",
				parameters: {
					action: "validateObligeeNoOnDelete",
					obligeeNo: $F("txtObligeeNo")
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice("Processing, please wait...");
				},
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response)){
						if(response.responseText != ""){
							if(response.responseText == "NONE"){
								deleteObligee();
							} else { //response.responseText == "GIPI_BOND_BASIC" ||  "GIPI_WBOND_BASIC"){
								showMessageBox("Cannot delete record from GIIS_OBLIGEE while dependent record(s) in " + response.responseText + " exists.", "E");								
							}
						}
					} else {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}catch(e){
			showErrorMessage("validateObligeeNoOnDelete", e);
		}		
	}
	
	function saveObligee(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		
		var objParams = new Object();
		objParams.setRows = getAddedAndModifiedJSONObjects(objObligee.objObligeeTbl);
		objParams.delRows = getDeletedJSONObjects(objObligee.objObligeeTbl);
		
		new Ajax.Request(contextPath+"/GIISObligeeController?action=saveObligee", {
			method: "POST",
			parameters: {
				parameters: JSON.stringify(objParams)
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				showNotice("Saving Obligee, please wait...");
			},
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS017.exitPage != null) {
							objGIISS017.exitPage();
						} else {
							obligeeTableGrid._refreshList();
						}
					});
					changeTag = 0;					
				}/*  else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}  */
			}
		});	
	}
	
	observeReloadForm("obligeeReloadForm", showObligeeMaintenance);
	
	function updateObjObligeeTbl(){
		try {
			for(var i = 0; i < objObligee.objObligeeTbl.length; i++){
				if(objObligee.objObligeeTbl[i].recordStatus = -1){
					objObligee.objObligeeTbl[i].recordStatus == null;
					delete objObligee.objObligeeTbl[i];
				} else {
					objObligee.objObligeeTbl[i].recordStatus == null;
				}
			}	
		} catch(e) {
			showErrorMessage("updateObjObligeeTbl", e);		
		}
	}
	
	function addObligee(){
		try {
			var currentFunction = $F("btnAddObligee");
			
			if(checkAllRequiredFieldsInDiv("obligeeInformationTextDiv")){
				changeTagFunc = saveObligee;
				var objObligeeToAdd = createObjObligee(currentFunction);
				
				if(currentFunction == "Add"){
					//objObligee.objObligeeTbl.push(objObligeeToAdd);
					//obligeeTableGrid.addBottomRow(objObligeeToAdd);
					obligeeTableGrid.addBottomRow(objObligeeToAdd);
				} else {
					//objObligee.objObligeeTbl.splice(obligeeListSelectedIndex, 1, objObligeeToAdd);
					//obligeeTableGrid.updateVisibleRowOnly(objObligeeToAdd, obligeeListSelectedIndex);
					obligeeTableGrid.updateVisibleRowOnly(objObligeeToAdd, obligeeListSelectedIndex, false);
				}
				changeTag = 1;
				obligeeTableGrid.onRemoveRowFocus();
			}
		} catch (e){
			showErrorMessage("addObligee", e);
		}
	}
	
	function createObjObligee(currentFunction){
		var newObligee = new Object();
		
		newObligee.obligeeNo = escapeHTML2($F("txtObligeeNo"));
		newObligee.obligeeName = escapeHTML2($F("txtObligeeName"));
		newObligee.contactPerson = escapeHTML2($F("txtObligeeContactPerson"));
		newObligee.designation = escapeHTML2($F("txtObligeeDesignation"));
		//marco - separate fields for address1, 2, and 3
		newObligee.address = escapeHTML2($F("txtObligeeAddress")) + " " + unescapeHTML2($F("txtObligeeAddress2")) + " " + unescapeHTML2($F("txtObligeeAddress3"));
		newObligee.address1 = escapeHTML2($F("txtObligeeAddress"));
		newObligee.address2 = escapeHTML2($F("txtObligeeAddress2"));
		newObligee.address3 = escapeHTML2($F("txtObligeeAddress3"));
		newObligee.phoneNo = escapeHTML2($F("txtObligeeTelephone"));
		newObligee.remarks = escapeHTML2($F("txtObligeeRemarks"));
		newObligee.userId = escapeHTML2(appUser);
		var lastUpdate = new Date();
		newObligee.lastUpdateStr = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
		newObligee.recordStatus = currentFunction == "Delete" ? -1 : currentFunction == "Add" ? 0 : 1;
		
		return newObligee;
	}
	
	function toggleObligeeInfoButtons(){
		if(obligeeListSelectedIndex == -1){
			$("btnAddObligee").value = "Add";
			disableButton($("btnDeleteObligee"));
		} else {
			$("btnAddObligee").value = "Update";
			enableButton($("btnDeleteObligee"));
		}
	}
	
	function populateObligeeInfoDetails(populate){
		try {
			$("txtObligeeNo").value = populate ? (obligeeTableGrid.geniisysRows[obligeeListSelectedIndex].obligeeNo == "" ? "" : formatNumberDigits(obligeeTableGrid.geniisysRows[obligeeListSelectedIndex].obligeeNo, 6)) : "";
			$("txtObligeeName").value = populate ? unescapeHTML2(obligeeTableGrid.geniisysRows[obligeeListSelectedIndex].obligeeName) : "";
			$("txtObligeeContactPerson").value = populate ? unescapeHTML2(obligeeTableGrid.geniisysRows[obligeeListSelectedIndex].contactPerson) : "";
			$("txtObligeeDesignation").value = populate ? unescapeHTML2(obligeeTableGrid.geniisysRows[obligeeListSelectedIndex].designation) : "";
			$("txtObligeeTelephone").value = populate ? unescapeHTML2(obligeeTableGrid.geniisysRows[obligeeListSelectedIndex].phoneNo) : "";
			//marco - 05.02.2013 - separate fields for address1, 2 and 3
			$("txtObligeeAddress").value = populate ? unescapeHTML2(obligeeTableGrid.geniisysRows[obligeeListSelectedIndex].address1) : "";
			$("txtObligeeAddress2").value = populate ? unescapeHTML2(obligeeTableGrid.geniisysRows[obligeeListSelectedIndex].address2) : "";
			$("txtObligeeAddress3").value = populate ? unescapeHTML2(obligeeTableGrid.geniisysRows[obligeeListSelectedIndex].address3) : "";
			$("txtObligeeRemarks").value = populate ? unescapeHTML2(obligeeTableGrid.geniisysRows[obligeeListSelectedIndex].remarks) : "";
			
			$("txtUserId").value = populate ? unescapeHTML2(obligeeTableGrid.geniisysRows[obligeeListSelectedIndex].userId) : ""; //appUser;
			$("txtLastUpdate").value = populate ? unescapeHTML2(obligeeTableGrid.geniisysRows[obligeeListSelectedIndex].lastUpdateStr) : ""; //dateFormat(new Date(), "mm-dd-yyyy h:MM:ss TT");
		} catch(e){
			showErrorMessage("populateObligeeInfoDetails", e);
		}
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}
	
	function exitPageBPD(){
		$("parInfoMenu").show();
		$("parInfoMenu").disabled = false;
		$("parInfoDiv").show();
		$("parInfoDiv").disabled = false;
		$("ObligeeMaintenanceTableGridDiv").remove();
		setModuleId("GIPIS017A");
		setDocumentTitle("Bond Policy Data");
		$("reloadForm").click(); //added by steven 10.13.2014
	}
	
	function cancelGiiss017(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						if(objUW.fromMenu == "obligee"){
							objGIISS017.exitPage = exitPage;
						} else if(objUW.fromMenu == "bondPolicyData"){
							objGIISS017.exitPage = exitPageBPD;
						}
				
						//objGIISS017.exitPage = exitPage;
						saveObligee();
					}, function(){
						//goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
						changeTag = 0;
						if(objUW.fromMenu == "obligee"){
							exitPage();
						} else if(objUW.fromMenu == "bondPolicyData"){
							exitPageBPD();
						}
					}, "");
		} else {
			//goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
			if(objUW.fromMenu == "obligee"){
				exitPage();
			} else if(objUW.fromMenu == "bondPolicyData"){
				exitPageBPD();
			}
		}
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtObligeeRemarks", 4000, $("txtObligeeRemarks").hasAttribute("readonly"));
	});
	
	$("btnDeleteObligee").observe("click", function(){
		var obligeeNo = $F("txtObligeeNo");
		
		if(obligeeNo == null || obligeeNo == "" ){
			deleteObligee();
		} else {
			validateObligeeNoOnDelete();
		}		
	});
	
	$("btnAddObligee").observe("click", function(){
		var currentFunction = $("btnAddObligee").value;

		if(currentFunction == "Add"){ 
			addObligee();
		} else if (currentFunction == "Update"){
			if(obligeeListSelectedInfoRow == "" || obligeeListSelectedInfoRow == null){
				showMessageBox("Please select an item first.", "I");
			} else {
				addObligee();
			}
		}
	});
	
	observeSaveForm("btnSaveObligee", saveObligee);
	$("btnCancelObligee").observe("click", cancelGiiss017);
	$("obligeeMaintenanceExit").stopObserving("click");
	$("obligeeMaintenanceExit").observe("click", function(){
		fireEvent($("btnCancelObligee"), "click");
	});
	$("txtObligeeName").focus();
	
	initializeAll();
	initializeAccordion();	//Added by Gzelle 05.25.2013 - for Hide/Show
</script>
