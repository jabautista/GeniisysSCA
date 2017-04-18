<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

	<div id="warrantyAndClauseFormDiv" style="top: 10px; bottom: 10px; height: 245px;" > 
			<table align="center" border="0">
				<tr>
					<td class="rightAligned">Warranty Code</td>
					<td class="leftAligned">
						<input type="hidden" id="origWcCd" name="origWcCd" />
						<input type="hidden" id="hidWcCd" name="hidWcCd" />			
						<input type="text" id="mainWcCd" name="mainWcCd" class="required" style="width: 169px;" maxlength="4" readonly="readonly"/>
					</td>
					<td><!-- added by carlo 01-24-2015 SR-5915-->
						<input type="checkbox" id="chkActiveTag" name="chkActiveTag" class="required" disabled="disabled" style="float: left; margin-right: 5px;"/>
						<label for="chkActiveTag">Active Tag</label>
					</td>
					<td>
						<input type="checkbox" id="printSw" name="printSw" class="required" disabled="disabled" style="float: left; margin-right: 5px;"/>
						<label for="printSw">Print Text</label>
					</td><!-- end SR 5915 -->
				<tr>
					<td class="rightAligned">Warranty Title</td>
					<td colspan="5" class="leftAligned" >					
						<input type="text" id="wcTitle" name="wcTitle" class="required" style="width: 645px;" maxlength="100" readonly="readonly" />								
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Type </td>
					<td class="leftAligned" >
					<input type="hidden" id="wcSw" name="wcSw" />		
						<select id="wcSwDesc" name="wcSwDesc" style="height: 22px;" disabled="disabled">
							<option>Warranty</option>
							<option>Clause</option>
						</select>
					</td>
					<!-- <td class="rightAligned">Print Text </td>
					<td class="leftAligned" >
						<input type="checkbox" id="printSw" name="printSw" class="required" disabled="disabled"/>
					</td> comment out by carlo-->
					<input type="checkbox" id="changeTag" name="changeTag" value="Y" disabled="disabled"  readonly="readonly" style="visibility: hidden;"/>
				</tr>
				<tr>
					<td class="rightAligned">Warranty Text</td>
					<td colspan="5" class="leftAligned">
						<div style="border: 1px solid gray; width: 650px;">
							<input type="hidden" id="origWcText" name="origWcText" />
							<!-- <input type="text" id="wcText" name="wcText" style="width: 620px; border: none; height: 13px;" readonly="readonly"/>commented out by jeffdojello 05.07.2013-->
							<textarea id="wcText" name="wcText" style="width: 620px; border: none; height: 13px; resize: none;" readonly="readonly" tabindex=210></textarea> <!-- added by jeffdojello 05.07.2013 -->
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editWarrantyText"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Remarks</td>
						<td colspan="5" class="leftAligned">
							<div style="border: 1px solid gray; width: 650px;">
								<!-- <input type="text" id="remarks" name="remarks" style="width: 620px; border: none; height: 13px;" readonly="readonly"/>commented out by jeffdojello 05.07.2013-->
								<textarea id="remarks" name="remarks" style="width: 620px; border: none; height: 13px; resize: none;" readonly="readonly" tabindex=210></textarea> <!-- added by jeffdojello 05.07.2013 -->
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarksText" />
							</div>
						</td>
				</tr>
				<tr align="center">
					<td class="rightAligned">User ID</td>
						<td class="leftAligned" >
							<input type="text" id="userId" value="" readonly="readonly" style="width: 100px;"/>
						</td>
					<td colspan="2"></td>
					<td class="rightAligned" >Last Update 
						<input type="text" id="lastUpdate" value="" style="width: 155px;" readonly="readonly" />
					</td>
				</tr>
			</table>

			<div style="float:left; bottom: 10px; top: 10px; width: 100%;" align="center">
				<input type="button" class="disabledButton" style="width: 60px;" id="btnAdd" name="btnAdd" value="Add" class="disabled" disabled="disabled" />
				<input type="button" class="disabledButton" style="width: 60px;" id="btnDelete" name="btnDelete" value="Delete" class="disabled" disabled="disabled" />
			</div>
	</div>


<script type="text/javascript">
	
	displayValue();
	makeInputFieldUpperCase();
	initializeAll();
	var rowObj;
	var delObj;
	var deleteStatus = false;
	var addStatus = false;
	var unsavedStatus;
	var changeCounter = 0;
	objWarrClaMaintain = null;
	var row = -1;
	
	//warranties and clauses in table grid
	try{
		var row = 0;
		var objWarrClaMain = [];
		var objWarrCla = new Object();
		objWarrCla.objWarrClaListing = [];
		objWarrCla.objWarrClaMaintenance = objWarrCla.objWarrClaListing.rows || [];
		var warrClaMaintenanceTG = {
				url: contextPath+"/GIISWarrClaController?action=getGIISWarrCla",
				options: {
					width: '900px',
					height: '220px',
					id: 2,
					onCellFocus: function(element, value, x, y, id){
						row = y;
						objWarrClaMaintain = warrClaMaintenanceTableGrid.geniisysRows[y];
						populateWarrantyAndCluseMaintenanceInfo(objWarrClaMaintain);
						enableButton("btnDelete");
						$("btnAdd").value="Update";
						disableEdit();
						enableForm();
						warrClaMaintenanceTableGrid.keys.releaseKeys();
						
					},
					onRemoveRowFocus: function(){
						populateWarrantyAndCluseMaintenanceInfo(null);
						warrClaMaintenanceTableGrid.keys.removeFocus(warrClaMaintenanceTableGrid.keys._nCurrentFocus, true);
						formatAppearance();
						displayValue();
						objWarrClaMaintain = null;
		            },
		            beforeSort: function(){
		            	if (changeTag == 1){
							showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
							return false;
	                	}
	                },
	                onSort: function(){
	                	formatAppearance();
	                	displayValue();
	                },
	                prePager: function(){
		            	if (changeTag == 1){
		            		showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
							return false;
	                	} else {
	                		formatAppearance();
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
					onRefresh: function(){
		            	if (changeTag == 1){
	                		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
							return false;
	                	} else {
		                	formatAppearance();
		                	displayValue();
	                	}
					},
					toolbar: {
						elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
						onFilter: function(){
			            	if (changeTag == 1){
		                		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
								return false;
		                	} else {
		                		formatAppearance();
			                	displayValue();
		                	}
						},
					}
				},
				columnModel: [
					{   
						id: 'recordStatus',
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
						id: 'lineCd',
						width: '0',
						visible: false
					},
					{	id: 'mainWcCd',
						title: 'Warranty Code',
						titleAlign: 'left',
						width: '100px',
						visible: true,
						filterOption: true,
						sortable: true
					},
					{	id: 'wcTitle',
						title: 'Warranty Title',
						titleAlign: 'left',
						width: '178px',
						visible: true,
						filterOption: true,
						sortable: true
					},
					{	id: 'wcSwDesc',
						title: 'Type',
						titleAlign: 'left',
						width: '100px',
						visible: true,
						filterOption: true,
						sortable: true
					},
					{
						id: 'wcSw',
						width: '0',
						visible: false
					},
					{	id: 'wcText',
						title: 'Warranty Text', 
						width: '245px',
						visible: true,
						sortable: false
					},
					{
						id: 'wcText01',
						width: '0',
						visible: false
					},
					{
						id: 'wcText02',
						width: '0',
						visible: false
					},
					{
						id: 'wcText03',
						width: '0',
						visible: false
					},
					{
						id: 'wcText04',
						width: '0',
						visible: false
					},
					{
						id: 'wcText05',
						width: '0',
						visible: false
					},
					{
						id: 'wcText06',
						width: '0',
						visible: false
					},
					{
						id: 'wcText07',
						width: '0',
						visible: false
					},
					{
						id: 'wcText08',
						width: '0',
						visible: false
					},
					{
						id: 'wcText09',
						width: '0',
						visible: false
					},
					{
						id: 'wcText10',
						width: '0',
						visible: false
					},
					{
						id: 'wcText11',
						width: '0',
						visible: false
					},
					{
						id: 'wcText12',
						width: '0',
						visible: false
					},
					{
						id: 'wcText13',
						width: '0',
						visible: false
					},
					{
						id: 'wcText14',
						width: '0',
						visible: false
					},
					{
						id: 'wcText15',
						width: '0',
						visible: false
					},
					{
						id: 'wcText16',
						width: '0',
						visible: false
					},
					{
						id: 'wcText17',
						width: '0',
						visible: false
					},
				    {
				    	id: 'remarks',
				    	title: 'Remarks',
				    	width: '160px',
		            	visible: true,
		            	sortable: false
				    },
				    {	id: 'activeTag', //added by carlo
						title: 'A',
						altTitle: 'Active Tag',
						titleAlign: 'center',
						width: '20px',
						visible: true,
						align :"center",
						sortable: false,
						defaultValue: false,
						otherValue: false,
				    	editor: new MyTableGrid.CellCheckbox({
					        getValueOf: function(value){
					        	if (value){
									return "A";
				            	}else{
									return "I";	
				            	}
					        }
				    	})
					},
					{	id: 'printSw',
						title: 'P',
						altTitle: 'Print Text',
						titleAlign: 'center',
						width: '20px',
						visible: true,
						sortable: false,
						defaultValue: false,
						otherValue: false,
				    	editor: new MyTableGrid.CellCheckbox({
					        getValueOf: function(value){
					        	if (value){
									return "Y";
				            	}else{
									return "N";	
				            	}
					        }
				    	})
					},
					{	id: 'userId',
						visible: false,
						width: '0'
					},
					{	id: 'lastUpdate',				
						visible: false,
						width: '0'
					},
					{
						id: 'changeTag',
						width: '0',
						visible: false
					}
					],
				rows: objWarrCla.objWarrClaMaintenance
			};
			
			warrClaMaintenanceTableGrid = new MyTableGrid(warrClaMaintenanceTG);
			warrClaMaintenanceTableGrid.pager = objWarrCla.objWarrClaListing;
			warrClaMaintenanceTableGrid.render('warrClaMaintenanceTable');
			warrClaMaintenanceTableGrid.afterRender = function(){
				objWarrClaMain = warrClaMaintenanceTableGrid.geniisysRows;
				changeTag = 0;
			};
			
		}catch (e) {
			showErrorMessage("Warranties And Clauses Table Grid", e);
		}

	//set warranties and clauses from table grid to input types
	function populateWarrantyAndCluseMaintenanceInfo(obj){
		try{
			$("mainWcCd").value 				= obj			== null ? "" : obj.mainWcCd;
			$("origWcCd").value 				= obj			== null ? "" : obj.mainWcCd;
			$("hidWcCd").value 					= obj			== null ? "" : obj.mainWcCd;
			$("lineCd").value 					= obj			== null ? "" : obj.lineCd;
			$("wcTitle").value 					= obj			== null ? "" : unescapeHTML2(obj.wcTitle);
			$("wcSwDesc").value 				= obj			== null ? "" : obj.wcSwDesc;
			$("printSw").checked				= obj			== null ? "" : obj.printSw == 'Y' ? true : false;
			$("wcText").value 					= obj			== null ? "" : unescapeHTML2(obj.wcText);
			$("remarks").value 					= obj			== null ? "" : unescapeHTML2(obj.remarks);
			$("userId").value 					= obj 			== null ? "" : obj.userId;
			$("lastUpdate").value 				= obj 			== null ? "" : obj.lastUpdate;
			$("changeTag").checked 				= obj 			== null ? false : (obj.changeTag == 'Y' ? true : false);
			$("origWcText").value 				= obj			== null ? "" : unescapeHTML2(obj.wcText);
			$("chkActiveTag").checked		    = obj			== null ? "" : obj.activeTag == 'A' ? true : false; //carlo 01-26-2017
				
		}catch(e){
				showErrorMessage("Warranties And Clauses Table Grid", e);
		}
	}
	
	//prepare values from input to table grid
	function setWarrClaMaintenanceTableValues(func) {
		var rowObjWarrCla = new Object();
		var wcText = $("wcText").value;
		
 		rowObjWarrCla.lineCd 	= objLineMaintain.lineCd;
		rowObjWarrCla.mainWcCd 	= $("mainWcCd").value;
		rowObjWarrCla.wcTitle 	= $("wcTitle").value;
		rowObjWarrCla.wcSw 		= $("wcSwDesc").value == "Warranty" ? "W" : "C";
		rowObjWarrCla.wcSwDesc 	= $("wcSwDesc").value;
		rowObjWarrCla.printSw 	= $("printSw").checked ? "Y" : "N";
		rowObjWarrCla.wcText 	= escapeHTML2(wcText);
		rowObjWarrCla.wcText01 	= escapeHTML2(wcText.substring(0,2000));
		rowObjWarrCla.wcText02 	= escapeHTML2(wcText.substring(2000,4000)); //Modify substring value by CarloR 08.08.2016 SR 22795 -start
		rowObjWarrCla.wcText03 	= escapeHTML2(wcText.substring(4000,6000));
		rowObjWarrCla.wcText04 	= escapeHTML2(wcText.substring(6000,8000));
		rowObjWarrCla.wcText05 	= escapeHTML2(wcText.substring(8000,10000));
		rowObjWarrCla.wcText06 	= escapeHTML2(wcText.substring(10000,12000));
		rowObjWarrCla.wcText07 	= escapeHTML2(wcText.substring(12000,14000));
		rowObjWarrCla.wcText08 	= escapeHTML2(wcText.substring(14000,16000));
		rowObjWarrCla.wcText09 	= escapeHTML2(wcText.substring(16000,18000));
		rowObjWarrCla.wcText10 	= escapeHTML2(wcText.substring(18000,20000));
		rowObjWarrCla.wcText11 	= escapeHTML2(wcText.substring(20000,22000));
		rowObjWarrCla.wcText12 	= escapeHTML2(wcText.substring(22000,24000));
		rowObjWarrCla.wcText13 	= escapeHTML2(wcText.substring(24000,26000));
		rowObjWarrCla.wcText14 	= escapeHTML2(wcText.substring(26000,28000));
		rowObjWarrCla.wcText15 	= escapeHTML2(wcText.substring(28000,30000));
		rowObjWarrCla.wcText16 	= escapeHTML2(wcText.substring(30000,32000));
		rowObjWarrCla.wcText17 	= escapeHTML2(wcText.substring(32000,34000)); //end
		rowObjWarrCla.remarks   = escapeHTML2($("remarks").value);
		rowObjWarrCla.userId 	= $("userId").value;
		rowObjWarrCla.lastUpdate = $("lastUpdate").value;
		rowObjWarrCla.recordStatus = func == "Delete" ? -1 : func == "Add" ? 0 : 1;
		rowObjWarrCla.changeTag 	= $("changeTag").checked ? "Y" : "N";
		rowObjWarrCla.activeTag 	= $("chkActiveTag").checked ? "A" : "I"; //carlo 01-26-2017

		return rowObjWarrCla;
	} 

/*functions - for delete
**			- validation (saving and deleting)
**			- for update/add
**			- for save
*/

	//validate deletion of giis_warrcla row
 	function validateDelete(){
		deleteStatus = false;
		var wcType = delObj.wcSwDesc;
		new Ajax.Request(contextPath+"/GIISWarrClaController?action=validateDeleteWarrCla",{
			method: "POST",
			parameters:{
				lineCd :   delObj.lineCd,
				mainWcCd : delObj.mainWcCd,
				wcSwDesc : wcType
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				showNotice("Validating Warranties And Clauses, please wait...");
			},
			onComplete: function(response){
				hideNotice("");
				if (checkErrorOnResponse(response)){
					if (response.responseText == '1') {
						deleteStatus = true;
					} else {
						showMessageBox("Record cannot be deleted. " + wcType + " is already in use.","E");
					} 
				}
			}
		});
	} 
	
 	//checks if warranty code already exist 
	function validateAddWarrCla(){
		addStatus = false;
		rowObj  = setWarrClaMaintenanceTableValues($("btnAdd").value);
		new Ajax.Request(contextPath+"/GIISWarrClaController?action=validateAddWarrCla",{
			method: "POST",
			parameters:{
				mainWcCd: rowObj.mainWcCd,
				lineCd: rowObj.lineCd
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				showNotice("Validating Warranties and Clauses, please wait...");
			},
			onComplete: function(response){
				hideNotice("");
				if(response.responseText == '1'){
					addStatus = true;
				}else{
					customShowMessageBox("Warranties and clauses must be unique.", imgMessage.ERROR, "mainWcCd");
					if($("mainWcCd").value != ""){
						$("mainWcCd").value = $("hidWcCd").value;
					}else {
						$("mainWcCd").value = $("origWcCd").value;
					}
				}
			}
		});
	}
	
	//delete giis_warrcla row in table grid only
 	function deleteWarrCla(){
		delObj = setWarrClaMaintenanceTableValues($("btnDelete").value);
 		validateDelete(); 
		if(deleteStatus){
			objWarrClaMain.splice(row, 1, delObj);
			warrClaMaintenanceTableGrid.deleteVisibleRowOnly(row);
			warrClaMaintenanceTableGrid.onRemoveRowFocus();
			if(changeCounter == 1 && unsavedStatus == 1){
				changeTag = 0;
				changeCounter = 0;
			}else{
				changeCounter++;
				changeTag=1;
			}
		}
	} 
	
	//add/update in table grid
	function addUpdateDataInTable(){
		rowObj  = setWarrClaMaintenanceTableValues($("btnAdd").value);
		if(checkAllRequiredFieldsInDiv("warrantyAndClauseFormDiv")){
			if($("btnAdd").value != "Add"){
				objWarrClaMain.splice(row, 1, rowObj);
				warrClaMaintenanceTableGrid.updateVisibleRowOnly(rowObj, row);
				warrClaMaintenanceTableGrid.onRemoveRowFocus();
				changeTag = 1;
				changeCounter++;
			}else{
				validateAddWarrCla();
				if(addStatus){
					unsavedStatus = 1;
					objWarrClaMain.push(rowObj);
					warrClaMaintenanceTableGrid.addBottomRow(rowObj);
					warrClaMaintenanceTableGrid.onRemoveRowFocus();
					changeTag = 1;
					changeCounter++;
				}
			}
		}
	}

	//save deleted or modified rows
	function saveWarrClaDetail(){
		var objParams = new Object();
		objParams.setRows = getAddedAndModifiedJSONObjects(warrClaMaintenanceTableGrid.geniisysRows);
		objParams.delRows = getDeletedJSONObjects(warrClaMaintenanceTableGrid.geniisysRows);
		
		new Ajax.Request(contextPath+"/GIISWarrClaController",{
			method: "POST",
			parameters:{
				action : "saveWarrCla",
				parameters : JSON.stringify(objParams)
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				showNotice("Saving Warranties and Clauses, please wait...");
			},
			onComplete: function(response){
				hideNotice("");
				changeTag = 0;
				if(checkErrorOnResponse(response)) {
					if (response.responseText == "SUCCESS"){
						showMessageBox(objCommonMessage.SUCCESS, "S");
						formatAppearance();
						warrClaMaintenanceTableGrid.refresh();
					}
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
		
	}
	
/*funtions - for validation of fields
**		   - for display
*		   - button observers
*/
	
	//resets values to default
	function formatAppearance() {
		try{
			$("btnAdd").value = "Add";
			disableButton("btnDelete");
			enableEdit();
			populateWarrantyAndCluseMaintenanceInfo(null);
		}catch (e) {
			showErrorMessage("formatAppearance",e);
		}
	}
	
	//set the lastupdate and user id field *last update for display only
	function displayValue() {
		$("lastUpdate").value = dateFormat(new Date(),'mm-dd-yyyy hh:MM:ss TT');
		$("userId").value = "${PARAMETERS['USER'].userId}";
		$("printSw").checked = true;
		$("chkActiveTag").checked = true; //carlo 01-26-2017
		$("wcSwDesc").value = "Warranty";
		$("mainWcCd").focus();
	}
	
	//disables warranty code field during update
	function disableEdit() {
		$("mainWcCd").disabled = true;
	}
	
	//enables warranty code field during add
	function enableEdit(){
		$("mainWcCd").disabled = false;
	}
	
	function enableForm() {
		enableInputField("wcTitle");
		enableInputField("wcSwDesc");
		$("printSw").disabled = false;
		enableInputField("wcText");
		enableInputField("remarks");
		$("wcTitle").focus();
	}
	
	//button observers
	$("editWarrantyText").observe("click", function () {
		showOverlayEditor("wcText", 32767, $("wcText").hasAttribute("readonly"), function() {
			limitText($("wcText"),32767);
		});
	});

	$("editRemarksText").observe("click", function () {
		showOverlayEditor("remarks", 4000, $("remarks").hasAttribute("readonly"), function() {
			limitText($("remarks"),4000);
		});
	});

	$("wcText").observe("keyup", function(){
		limitText(this,32767);
	});	
	
	$("wcText").observe("keydown", function(){
		limitText(this,32767);
	});
	
	$("remarks").observe("keyup", function(){		
		limitText(this,4000);
	});	
	
	$("remarks").observe("keydown", function(){	
		limitText(this,4000);
	});
	
	$("btnAdd").observe("click", function() {
		changeTagFunc = saveWarrClaDetail;
		addUpdateDataInTable();
	});
	
 	$("btnDelete").observe("click", function() {
 		changeTagFunc = saveWarrClaDetail;
 		deleteWarrCla();
	}); 
	
	$("mainWcCd").observe("keyup", function(){
		this.value = this.value.toUpperCase();
	});
	
  	$("mainWcCd").observe("change", function(){
   		if ($("mainWcCd").value != ""){
   			validateAddWarrCla();
  			$("hidWcCd").value = $("mainWcCd").value;
  		}
	});  
 	
	$("btnSaveWarrantyAndClause").observe("click", function() {
		if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
		}else{
			saveWarrClaDetail();
		}
	});
	
	observeCancelForm("btnCancelWarrantyAndClause", saveWarrClaDetail, function(){
		warrClaMaintenanceTableGrid.keys.releaseKeys();
		changeTag = 0;
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main" , null);
	});
	
	observeCancelForm("warrantyAndClauseExit", saveWarrClaDetail, function(){
		warrClaMaintenanceTableGrid.keys.releaseKeys();
		changeTag = 0;
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main" , null);
	});
	changeTagFunc = saveWarrClaDetail; 	//Gzelle 03202014 Confirmation message (logout)
</script>