<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="sublineSubmaintenanceSectionDiv" style="padding-left: 9px; padding-top: 10px;"> 
	<div id="sublineSubmaintenanceTableDiv" style="width: 100%; height: 250px;"> </div>
	<div id="sublineMaintenanceFormDiv" style="padding-bottom: 10px;">
		<table align="center">
			<tr>
				<td class="rightAligned">Subline Code</td>
				<td class="leftAligned"><input type="text" id="txtSublineCd" value="" style="width: 200px;" class="required upper" maxlength="7" tabindex="201"/></td>
				<td style="padding-left: 20px;">
					<input id="chkOpenPolDtl" type="checkbox" style="float: left; padding: 0pt; width: 13px; height: 13px; overflow: hidden;"   name="chkOpenPolDtl" tabindex="202">
					<label for="chkOpenPolDtl" style="float: left; padding-left: 3px;" title="OpenPolicyDetail">Open Policy Detail</label>
				</td>
				<td style="padding-left: 20px;">
					<input id="chkOpenPol" type="checkbox" style="float: left; padding: 0pt; width: 13px; height: 13px; overflow: hidden;"   name="chkOpenPol" tabindex="203">
					<label for="chkOpenPol" style="float: left; padding-left: 3px;" title="OpenPolicy">Open Policy</label>
				</td>
				<td style="padding-left: 20px;">
					<input id="chkPirntTag" type="checkbox" style="float: left; padding: 0pt; width: 13px; height: 13px; overflow: hidden;"   name="chkPirntTag" tabindex="204">
					<label for="chkPirntTag" style="float: left; padding-left: 3px;" title="PirntTag">Print Tag</label>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Subline Name</td>
				<td class="leftAligned"><input type="text" id="txtSublineName" value="" style="width: 200px;" class="required upper" maxlength="30"/ tabindex="205"></td>
				<td style="padding-left: 20px;">
					<input id="chkEndOfDay" type="checkbox" style="float: left; padding: 0pt; width: 13px; height: 13px; overflow: hidden;"   name="chkEndOfDay" tabindex="206">
					<label for="chkEndOfDay" style="float: left; padding-left: 3px;" title="EndOfDay">End of Day</label>
				</td>
				<td style="padding-left: 20px;">
					<input id="chkNoTax" type="checkbox" style="float: left; padding: 0pt; width: 13px; height: 13px; overflow: hidden;"   name="chkNoTax" tabindex="207">
					<label for="chkNoTax" style="float: left; padding-left: 3px;" title="NoTax">No tax</label>
				</td>
				<td style="padding-left: 20px;">
					<input id="chkExclude" type="checkbox" style="float: left; padding: 0pt; width: 13px; height: 13px; overflow: hidden;"   name="chkExclude" tabindex="208">
					<label for="chkExclude" style="float: left; padding-left: 3px;" title="Exclude">Exclude</label>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Acct Code</td>
				<td class="leftAligned"><input type="text" id="txtAccountCode" value="" style="width: 200px;" class="rightAligned required" maxlength="2"/ tabindex="209"></td>
				<td style="padding-left: 20px;">
					<input id="chkProfCommTag" type="checkbox" style="float: left; padding: 0pt; width: 13px; height: 13px; overflow: hidden;"   name="chkProfCommTag" tabindex="210">
					<label for="chkProfCommTag" style="float: left; padding-left: 3px; padding-right: 20px;" title="ProfitCommisionTag">Profit Commission Tag</label>
				</td>
				<td style="padding-left: 20px;">
					<input id="chkNonRenewal" type="checkbox" style="float: left; padding: 0pt; width: 13px; height: 13px; overflow: hidden;"   name="chkNonRenewal" tabindex="211">
					<label for="chkNonRenewal" style="float: left; padding-left: 3px; padding-right: 20px;" title="NonRenewal">Non Renewal</label>
				</td>
				<td style="padding-left: 20px;">
					<input id="chkEDSTSw" type="checkbox" style="float: left; padding: 0pt; width: 13px; height: 13px; overflow: hidden;"   name="chkEDSTSw" tabindex="212">
					<label for="chkEDSTSw" style="float: left; padding-left: 3px; padding-right: 20px;" title="EDSTSwitch">EDST Switch</label>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Cut-off Time</td>
				<td class="leftAligned"><input type="text" id="txtSublineTime" value="" style="width: 200px;" class="rightAligned" maxlength="11"  tabindex="213"/></td>
				<td style="padding-left: 20px;">
					<input id="chkEnrolleeTag" type="checkbox" style="float: left; padding: 0pt; width: 13px; height: 13px; overflow: hidden;"   name="chkEnrolleeTag" tabindex="214">
					<label for="chkEnrolleeTag" style="float: left; padding-left: 3px; padding-right: 20px;" title="EnrolleeTag">Enrollee Tag</label>
				</td>
				<td style="padding-left: 20px;"> <!--added by apollo 05.20.2015 sr#4245-->
					<input id="chkMicroSw" type="checkbox" style="float: left; padding: 0pt; width: 13px; height: 13px; overflow: hidden;"   name="chkMicroSw" tabindex="215">
					<label for="chkMicroSw" style="float: left; padding-left: 3px; padding-right: 20px;" title="Micro Insurance">Micro Insurance</label>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Minimum Premium</td>
				<td class="leftAligned"><input type="text" id="txtMinPremAmt" value="" style="width: 200px;" class="rightAligned" maxlength="19" tabindex="215"/></td>
			</tr>
			<tr>
				<td class="rightAligned">Remarks</td>
				<td colspan="3" class="leftAligned">
					<div style="border: 1px solid gray; height: 21px; width: 603px">
						<textarea id="txtRemarks" name="txtRemarks" style="border: none; height: 13px; resize: none; width: 573px" maxlength="4000"  tabindex="216"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; padding: 3px; float: right;" alt="EditRemark" id="editRemarksText" tabindex=217/>
					</div>
				</td>
			</tr>
		</table>
		
		<input type="hidden" id="hidSublineTime" name="hidSublineTime" value="" /> 
		<input type="hidden" id="hidSublineCd" name="hidSublineCd" value="" />
		<input type="hidden" id="hidAcctSublineCd" name="hidAcctSublineCd" value="" />

		<div class="buttonsDiv" style="padding-bottom: 10px;">
			<input type="button" class="button" id="btnAddSubline" name="btnAddSubline" value="Add"/>
			<input type="button" class="button" id="btnDeleteSubline" name="btnDeleteSubline" value="Delete"/>
		</div>	
	</div>
</div>

<script type="text/javascript">
	initializeAccordion();
	initializeAllMoneyFields();
	makeInputFieldUpperCase();
	initializeAll();
	
	setModuleId("GIISS002");
	setDocumentTitle("Subline Maintenance");
	changeTag = 0;
	deleteStatus = false;
	addStatus = false;
	var changeCounter = 0;
	var objSublineMaintain = null;
	var sublineCd = null;
	var acctSublineCd = null;
	var opSw = null;
	onExit = new Object();
	add = false;
	
	try{
		row = null;
		var objSublineMain = [];
		var objSubline = new Object();
		objSubline.objSublineListing = []; 
		objSubline.objSublineMaintenance = objSubline.objSublineListing.rows || [];
		var sublineMaintenanceTG = {
				url: contextPath+"/GIISSublineController?action=getSublineLov",
				options: {
					width: '900px',
					height: '220px',
					onCellFocus: function(element, value, x, y, id){
						row = y;
						objSublineMaintain = sublineMaintenanceTableGrid.geniisysRows[y];
						$("btnAddSubline").value = "Update";
						$("txtSublineCd").readOnly = true;
						$("txtAccountCode").readOnly = true;
						$("chkOpenPolDtl").disabled = true;
						$("chkOpenPol").disabled = true;
					    populateSublineForm(objSublineMaintain);
					  	enableButton("btnDeleteSubline");
					  	sublineMaintenanceTableGrid.keys.releaseKeys();
					},	
					onRemoveRowFocus: function(){					
						 populateSublineForm(null);
						 $("btnAddSubline").value = "Add";
						 $("txtSublineCd").readOnly = false;
						 $("txtAccountCode").readOnly = false;
						 $("chkOpenPolDtl").disabled = false;
						 $("chkOpenPol").disabled = false;
					  	 disableButton("btnDeleteSubline");
						 sublineMaintenanceTableGrid.keys.releaseKeys();
		            },
		            beforeSort: function(){
		            	if(changeTag == 1){
		            		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
							return false;
		            	}else{
		            		sublineMaintenanceTableGrid.onRemoveRowFocus();
		            	}
	                },
	                onSort: function(){
	                	if(changeTag == 1){
		            		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
							return false;
		            	}else{
		            		sublineMaintenanceTableGrid.onRemoveRowFocus();
		            	}
	                },
	                prePager : function(){
	                	if(changeTag == 1){
		            		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
							return false;
		            	}else{
		            		sublineMaintenanceTableGrid.onRemoveRowFocus();
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
						elements: [MyTableGrid.PRINT_BTN, MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
						onRefresh: function(){
							if(changeTag == 1){
			            		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
								return false;
			            	}else{
			            		sublineMaintenanceTableGrid.onRemoveRowFocus();
			            	}
						},
						onFilter: function(){
							if(changeTag == 1){
			            		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
								return false;
			            	}else{	
			            		sublineMaintenanceTableGrid.onRemoveRowFocus();
			            	}
						},
						onPrint: function(){
							showGenericPrintDialog("Print List of Sublines", printReport, "", true);
						}
					}
				},
				columnModel: [
					{   id: 'recordStatus',
					    width: '0',
					    visible: false,
					    editor: 'checkbox' 			
					},
					{	id: 'divCtrId',
						width: '0',
						visible: false
					},
					{   id: 'sublineCd',
					    title: 'Code',
					    width: '70px',
					    filterOption: true
					},
					{	id: 'sublineName',
						title: 'Subline Name',
						width: '202px',
					    filterOption: true
					},
					{	id: 'sublineTime',
						title: 'Cut-off Time',
						titleAlign: 'center',
						align: 'center',
						width: '105px',
					    filterOption: true,
					    filterOptionType : 'formattedHour'
					},
					{	id: 'acctSublineCd',
						title: 'Acct Code',
						titleAlign: 'right',
						width: '95px',
						align: 'right',
						renderer : function(value){
							return formatNumberDigits(value, 2);},
						 filterOption: true,
						 filterOptionType: 'integerNoNegative'
					},
					{	id: 'minPremAmt',
						title: 'Min. Premium',
						titleAlign: 'right',
						width: '145px',
						align: 'right',
						renderer : function(value){
							return formatCurrency(value);},
						filterOption: true,
						filterOptionType: 'integerNoNegative',
						geniisysClass: 'money'
					}/* ,
					{	id: 'remarks',
						title: 'Remarks',
						titleAlign: 'center',
						width: '105px',
					    filterOption: true
					} */,
					{//apollo cruz 05.20.2015 - sr#4245
						id: 'microSw',
						title: 'M',
						altTitle: 'Micro Insurance',
						width: '23px',
						align: 'center',
						titleAlign: 'center',
						editor : new MyTableGrid.CellCheckbox({getValueOf : function(value) {
								if (value) {
									return "Y";
								} else {
									return "N";
								}
							}
						})
					},
					{	id: 'openPolicySw',
				    	title: 'D',
				    	width: '23px',
		            	align: 'center',
		            	altTitle : 'Open Pol Dtl',
						titleAlign: 'center',
						editor : new MyTableGrid.CellCheckbox({getValueOf : function(value) {
								if (value) {
									return "Y";
								} else {
									return "N";
								}
							}
						})
				    },
				    {	id: 'opFlag',
				    	title: 'O',
				    	width: '23px',
		            	align: 'center',
		            	altTitle : 'Open Pol',
						titleAlign: 'center',
						editor : new MyTableGrid.CellCheckbox({getValueOf : function(value) {
								if (value) {
									return "Y";
								} else {
									return "N";
								}
							}
						})
				    },
				    {	id: 'alliedPrtTag',
				    	title: 'P',
				    	width: '23px',
		            	align: 'center',
		            	altTitle : 'Print Tag',
						titleAlign: 'center',
						editor : new MyTableGrid.CellCheckbox({getValueOf : function(value) {
								if (value) {
									return "Y";
								} else {
									return "N";
								}
							}
						})
				    },
				    {	id: 'timeSw',
				    	title: 'E',
				    	width: '23px',
		            	align: 'center',
		            	altTitle : 'End of Day',
						titleAlign: 'center',
						editor : new MyTableGrid.CellCheckbox({getValueOf : function(value) {
								if (value) {
									return "Y";
								} else {
									return "N";	
								}
							}
						})
				    },
				    {	id: 'noTaxSw',
				    	title: 'T',
				    	width: '23px',
		            	align: 'center',
		            	altTitle : 'No Tax',
						titleAlign: 'center',
						editor : new MyTableGrid.CellCheckbox({getValueOf : function(value) {
								if (value) {
									return "Y";
								} else {
									return "N";
								}
							}
						})
				    },
				    {	id: 'excludeTag',
				    	title: 'X',
				    	width: '23px',
		            	align: 'center',
		            	altTitle : 'Exclude',
						titleAlign: 'center',
						editor : new MyTableGrid.CellCheckbox({getValueOf : function(value) {
								if (value) {
									return "Y";
								} else {
									return "N";
								}
							}
						})
				    },
				    {	id: 'profCommTag',
				    	title: 'C',
				    	width: '23px',
		            	align: 'center',
		            	altTitle : 'Profit Comm Tag',
						titleAlign: 'center',
						editor : new MyTableGrid.CellCheckbox({getValueOf : function(value) {
								if (value) {
									return "Y";
								} else {
									return "N";
								}
							}
						})
				    },
				    {	id: 'nonRenewalTag',
				    	title: 'N',
				    	width: '23px',
		            	align: 'center',
		            	altTitle : 'Non-Renewal',
						titleAlign: 'center',
						editor : new MyTableGrid.CellCheckbox({getValueOf : function(value) {
								if (value) {
									return "Y";
								} else {
									return "N";
								}
							}
						})
				    },
				    {	id: 'edstSw',
				    	title: 'S',
				    	width: '23px',
		            	align: 'center',
		            	altTitle : 'Exclude EDST Switch',
						titleAlign: 'center',
						editor : new MyTableGrid.CellCheckbox({getValueOf : function(value) {
								if (value) {
									return "Y";
								} else {
									return "N";
								}
							}
						})
				    },
				    {	id: 'enrolleeTag',
				    	title: 'L',
				    	width: '23px',
		            	align: 'center',
		            	altTitle : 'Enrollee Tag',
						titleAlign: 'center',
						editor : new MyTableGrid.CellCheckbox({getValueOf : function(value) {
								if (value) {
									return "Y";
								} else {
									return "N";
								}
							}
						})
				    }],
				rows: objSubline.objSublineMaintenance
			};
			
			sublineMaintenanceTableGrid = new MyTableGrid(sublineMaintenanceTG);
			sublineMaintenanceTableGrid.pager = objSubline.objSublineListing;
			sublineMaintenanceTableGrid.render('sublineSubmaintenanceTableDiv');
			sublineMaintenanceTableGrid.afterRender = function(){
				objSublineMain = sublineMaintenanceTableGrid.geniisysRows;
				changeTag = 0;
			};
			
		}catch (e) {
			showErrorMessage("Subline Management Table Grid", e);
		}
		
		function populateSublineForm(obj) {
			try {
				$("txtSublineCd").value 		= obj == null ? "" : unescapeHTML2(obj.sublineCd);
				$("txtSublineName").value 		= obj == null ? "" : unescapeHTML2(obj.sublineName);
				$("txtAccountCode").value 		= obj == null ? "" : formatNumberDigits(obj.acctSublineCd, 2);
				$("txtSublineTime").value 		= obj == null ? "" : obj.sublineTime;
				$("txtMinPremAmt").value 		= obj == null ? "" : formatCurrency(obj.minPremAmt);
				$("txtRemarks").value 			= obj == null ? "" : unescapeHTML2(obj.remarks);
				$("chkOpenPolDtl").checked 		= obj == null ? "" : obj.openPolicySw == 'Y' ? true : false;
				$("chkOpenPol").checked 		= obj == null ? "" : obj.opFlag == 'Y' ? true : false;
				$("chkPirntTag").checked 		= obj == null ? "" : obj.alliedPrtTag == 'Y' ? true : false;
				$("chkEndOfDay").checked 		= obj == null ? "" : obj.timeSw == 'Y' ? true : false;
				$("chkNoTax").checked		    = obj == null ? "" : obj.noTaxSw == 'Y' ? true : false;
				$("chkExclude").checked 		= obj == null ? "" : obj.excludeTag == 'Y' ? true : false;
				$("chkProfCommTag").checked 	= obj == null ? "" : obj.profCommTag == 'Y' ? true : false;
				$("chkNonRenewal").checked 		= obj == null ? "" : obj.nonRenewalTag == 'Y' ? true : false;
				$("chkEDSTSw").checked 			= obj == null ? "" : obj.edstSw == 'Y' ? true : false;
				$("chkEnrolleeTag").checked 	= obj == null ? "" : obj.enrolleeTag == 'Y' ? true : false;
				$("chkMicroSw").checked 		= obj == null ? false : obj.microSw == 'Y' ? true : false;//apollo 05.20.2015 sr#4245
			} catch (e) {
				showErrorMessage("Populate Subline Form", e);
			}
		}
		
		function setSublineTableValues() {
			var rowObjectSubline = new Object();

			rowObjectSubline.sublineCd 		= escapeHTML2($("txtSublineCd").value);
			rowObjectSubline.sublineName 	= escapeHTML2($("txtSublineName").value);
			rowObjectSubline.acctSublineCd 	= unformatNumber($("txtAccountCode").value);
			rowObjectSubline.sublineTime 	= $("txtSublineTime").value;
			rowObjectSubline.minPremAmt 	= $("txtMinPremAmt").value == "" ? "" : unformatCurrency("txtMinPremAmt");
			rowObjectSubline.remarks 		= escapeHTML2($("txtRemarks").value);
			rowObjectSubline.openPolicySw 	= ($("chkOpenPolDtl").checked ? "Y" : "N");
			rowObjectSubline.opFlag 		= ($("chkOpenPol").checked ? "Y" : "N");
			rowObjectSubline.alliedPrtTag 	= ($("chkPirntTag").checked ? "Y" : "N");
			rowObjectSubline.timeSw 		= ($("chkEndOfDay").checked ? "Y" : "N");
			rowObjectSubline.noTaxSw 		= ($("chkNoTax").checked ? "Y" : "N");
			rowObjectSubline.excludeTag 	= ($("chkExclude").checked ? "Y" : "N");
			rowObjectSubline.profCommTag 	= ($("chkProfCommTag").checked ? "Y" : "N");
			rowObjectSubline.nonRenewalTag 	= ($("chkNonRenewal").checked ? "Y" : "N");
			rowObjectSubline.edstSw 		= ($("chkEDSTSw").checked ? "Y" : "N");
			rowObjectSubline.enrolleeTag 	= ($("chkEnrolleeTag").checked ? "Y" : "N");
			rowObjectSubline.microSw		= ($("chkMicroSw").checked ? "Y" : "N");//apollo 05.20.2015 sr#4245
			
			return rowObjectSubline;
		}
		
		function addUpdateSubline(){  
			rowObj  = setSublineTableValues($("btnAddSubline").value);
			$("hidSublineTime").value = $("txtSublineTime").value;
			if(checkAllRequiredFieldsInDiv("sublineMaintenanceFormDiv")){
				if($("btnAddSubline").value != "Add"){
					rowObj.recordStatus = 1;
					objSublineMain.splice(row, 1, rowObj);
					sublineMaintenanceTableGrid.updateVisibleRowOnly(rowObj, row);
					sublineMaintenanceTableGrid.onRemoveRowFocus();
					changeTag = 1;
					changeCounter++;
				}else{
					rowObj.recordStatus = 0;
					objSublineMain.push(rowObj);
					sublineMaintenanceTableGrid.addBottomRow(rowObj);
					sublineMaintenanceTableGrid.onRemoveRowFocus();
					changeTag = 1;
				}
			}
		}
		
		function deleteSubline() {
 			delObj = setSublineTableValues($("btnDeleteSubline").value);
 			validateDelete();
 			
 			if (deleteStatus) {
 				delObj.recordStatus = -1;
 				objSublineMain.splice(row, 1, delObj);
 				sublineMaintenanceTableGrid.deleteVisibleRowOnly(row);
 				sublineMaintenanceTableGrid.onRemoveRowFocus();
 				changeTag = 1;
 			}
 		}
		
		function validateAddSubline(){
			new Ajax.Request(contextPath+"/GIISSublineController?action=validateAddSubline"+"&lineCd="+objUW.hideGIIS002.lineCd,{
				method: "POST",
				parameters:{
					param: $("txtSublineCd").value
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice("validating Subline, please wait...");
				},
				onComplete: function(response){
					hideNotice("");
					
					if(response.responseText == 'N'){
						return true;
					}else{
						customShowMessageBox("Code must be unique.", "I", "txtSublineCd");
						$("txtSublineCd").value = "";
					}
				}
			});
 		}
		
		function validateAcctSublineCd(){
 			new Ajax.Request(contextPath+"/GIISSublineController?action=validateAcctSublineCd"+"&lineCd="+objUW.hideGIIS002.lineCd,{
				method: "POST",
				asynchronous: true,
				parameters:{
				acctSublineCd:  $("txtAccountCode").value
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice("Validating account subline code, please wait...");
				},
				onComplete: function(response){
					hideNotice("");
					if(response.responseText == 'N'){
						$("txtAccountCode").value = formatNumberDigits($("txtAccountCode").value, 2);
						return true;
					}else{
						customShowMessageBox("Acct Code must be unique.", "I", "txtAccountCode");
						$("txtAccountCode").value = "";
					}
				}
			}); 
		}
 		
 		function validateOpSw(action, open){
 			new Ajax.Request(contextPath+"/GIISSublineController?action=" + action + "&lineCd="+objUW.hideGIIS002.lineCd,{
				method: "POST",
				asynchronous: true,
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice("Validating " + open + ", please wait...");
				},
				onComplete: function(response){
					hideNotice("");
					if(response.responseText == '1'){
						showMessageBox("Only one subline can be tagged as "+ open, "I");
						if(action == "validateOpenSw"){
							$("chkOpenPolDtl").checked = false;
						}else{
							$("chkOpenPol").checked = false;
						}
					}else{
						return true;
					}
				}
			}); 
		}
		
 		function validateDelete(){
 			deleteStatus = false;
 			var objRow = objSublineMaintain || [];
 			new Ajax.Request(contextPath+"/GIISSublineController?action=valDeleteSubline"+"&lineCd="+objUW.hideGIIS002.lineCd,{
				method: "POST",
				asynchronous: true,
				parameters:{
				param:  $("txtSublineCd").value
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice("Validating Subline, please wait...");
				},
				onComplete: function(response){
					hideNotice("");
					if(response.responseText == 'N'){
						deleteStatus = true;
					}else{
						showMessageBox("Subline code cannot be deleted; already in use.", "I");
						deleteStatus = false;
					}
				}
			}); 
		}
		
 		function saveSubline() {
 			var objParams = new Object();
 			objParams.addRows = getAddedSubline(objSublineMain);
 			objParams.updateRows = getModifiedSubline(objSublineMain);
 			objParams.delRows = getDeletedJSONObjects(objSublineMain);
 			
 			new Ajax.Request(contextPath+"/GIISSublineController?action=saveSubline"+"&lineCd="+objUW.hideGIIS002.lineCd,{
 				method : "POST",
 				parameters:{
					param: JSON.stringify(objParams),
					sublineTime: $("hidSublineTime").value
				},
 				asynchronous : false,
 				evalScripts : true,
 				onCreate: function(){
					showNotice("Saving Subline, please wait...");
				},
 				onComplete : function(response) {
 					hideNotice("");
 					changeTag = 0;
 					if(checkErrorOnResponse(response)){
						showMessageBox(objCommonMessage.SUCCESS, "S");
						sublineMaintenanceTableGrid.refresh();
					};	
 				}
 			});

 		}
		
 		function getAddedSubline(objArray) {
 			var tempObjArray = new Array();
 			for(var i = 0; i<objArray.length; i++){
 				if(parseInt(objArray[i].recordStatus) == 0){
 					tempObjArray.push(objArray[i]);
 				}
 			}
 			return tempObjArray;
 		}

 		function getModifiedSubline(objArray) {
 			var tempObjArray = new Array();
 			for(var i = 0; i<objArray.length; i++){
 				if(parseInt(objArray[i].recordStatus) == 1){
 					tempObjArray.push(objArray[i]);
 				}
 			}
 			return tempObjArray;
 		}	
		
 		function checkDecimal(txtId){
 			for(var i = 0; i < txtId.length; i++){
 				if (txtId.charAt(i)=='.'){
 					return true;
 				}
 			}
 			return false;
 		}
 		
 		function checkNegative(txtId){
 			for(var i = 0; i < txtId.length; i++){
 				if (txtId.charAt(i)=='-'){
 					return true;
 				}
 			}
 			return false;
 		}
 		
 		$("sublineMaintenanceExit").observe("click", function ()	{
 			fireEvent($("btnCancelSubline"), "click");
 		});  
 		
 		$("btnDeleteSubline").observe("click",function() {
 			changeTagFunc = saveSubline;
 			deleteSubline();
		});
 		
		$("btnAddSubline").observe("click",function() {
			changeTagFunc = saveSubline;
			addUpdateSubline();
		});
		
		$("editRemarksText").observe("click", function() {
 			showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"), function() {
 				limitText($("txtRemarks"),4000);
 			});
 		});

 		$("txtRemarks").observe("keyup", function() {
 			limitText(this, 4000);
 		});
 		
		$("txtSublineCd").observe("change",function() {
			validateAddSubline();
		});
		
		$("txtAccountCode").observe("change",function() {
			if (isNaN(($("txtAccountCode").value)) || parseInt($("txtAccountCode").value) < 1 || checkDecimal($("txtAccountCode").value) || parseInt($("txtAccountCode").value) > 99) {
				customShowMessageBox("Invalid Account Code. Valid value should be from 01 to 99.", "I", "txtAccountCode");
				$("txtAccountCode").value = "";
			}else if($("txtAccountCode").value == ""){
				$("txtAccountCode").value = "";
			}else{
				validateAcctSublineCd();
			}
		});
		
		$("txtMinPremAmt").observe("change",function() {
			var minPrem = $F("txtMinPremAmt").replace(/,/g, "");
			if (isNaN(minPrem) || parseInt(minPrem) < 0 || parseFloat(minPrem) > parseFloat(9999999999.99) || checkNegative(minPrem)) {
				customShowMessageBox("Invalid  Minimum Premium. Valid value should be from 0.00 to 9,999,999,999.99.", "I", "txtMinPremAmt");
				$("txtMinPremAmt").value = "";
			}else{
				$("txtMinPremAmt").value = formatCurrency($("txtMinPremAmt").value);
			}
		});
		
		$("chkOpenPolDtl").observe("change",function() {
			validateOpSw("validateOpenSw", "open policy detail.");
		});
		
		$("chkOpenPol").observe("change",function() {
			validateOpSw("validateOpenFlag", "open policy.");
		});
		
		$("txtSublineTime").observe("change",function() {
			if($("txtSublineTime").value == ""){
				return true;
			}else{
				//isValidTime("txtSublineTime"); //Added by Jerome Bautista 05.26.2015 SR 4236
			 	if(!IsValidFilterTime($F("txtSublineTime"))){ // bonok :: 8.25.2015 :: UCPB SR 20210
					$("txtSublineTime").clear();
					$("txtSublineTime").focus();
			 	}
			}
		});
		
 		observeReloadForm("reloadForm", showSublineMaintenance);
 		observeSaveForm("btnSaveSubline", saveSubline);
 		observeCancelForm("btnCancelSubline", saveSubline, function() {
 			sublineMaintenanceTableGrid.keys.releaseKeys();
 			changeTag = 0;
 			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
 		});
 	
 		
 		function printReport(){
 			try {
 				var content = contextPath+"/MaintenanceReportsController?action=printReport"
					+"&reportId=GIPIR803"
					+"&reportTitle=List of Subline";
 				
 				if("screen" == $F("selDestination")){
 					showPdfReport(content, "List of Subline");
 				}else if($F("selDestination") == "printer"){
 					new Ajax.Request(content, {
 						parameters : {noOfCopies : $F("txtNoOfCopies"),
 							  	      printerName : $F("selPrinter")},
 						onCreate: showNotice("Processing, please wait..."),				
 						onComplete: function(response){
 							hideNotice();
 							if (checkErrorOnResponse(response)){
 								
 							}
 						}
 					});
 				}else if("file" == $F("selDestination")){
 					new Ajax.Request(content, {
 						parameters : {destination : "file",
 									  fileType : $("rdoPdf").checked ? "PDF" : "XLS"},
 						onCreate: showNotice("Generating report, please wait..."),
 						onComplete: function(response){
 							hideNotice();
 							if (checkErrorOnResponse(response)){
 								copyFileToLocal(response);
 							}
 						}
 					});
 				}else if("local" == $F("selDestination")){
 					new Ajax.Request(content, {
 						parameters : {destination : "local"},
 						onComplete: function(response){
 							hideNotice();
 							if (checkErrorOnResponse(response)){
 								var message = printToLocalPrinter(response.responseText);
 								if(message != "SUCCESS"){
 									showMessageBox(message, imgMessage.ERROR);
 								}
 							}
 						}
 					});
 				}
 			} catch (e){
 				showErrorMessage("printReport", e);
 			}
 		}
 		
</script>