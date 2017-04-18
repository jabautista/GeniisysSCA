<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="ajax" uri="http://ajaxtags.org/tags/ajax" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="distDateDiv" class="sectionDiv" align="center" style="margin-top: 10px; height: 380px; width: 99%;" name="statusDiv">
<div id="adjusterMainDiv" name="adjusterMainDiv">
	<div id="adjusterTableGridDiv" align="center" style="margin-bottom: 5px;">
		<div id="adjusterGridDiv" style="height: 320px; margin-top: 5px;">
			<input type="hidden" id="txtClmAdjId" />
			<div id="adjusterTableGrid" style="height: 181px; width: 770px; margin-bottom: 35px;"></div>
			<table border="0" align="center">
				<tr>
					<td class="leftAligned">Adjusting Company</td>	
					<td class="rightAligned" colspan="3">
						<input style="width: 66px;" type="text" id="txtAdjCompanyCd" name="txtAdjCompanyCd" readonly="readonly" class="required"/>
						<div style="width: 300px; float: right; margin-left: 3px;" class="required withIconDiv">
							<input style="width: 275px; float: left;" class="required withIcon" id="txtAdjCompany" name="txtAdjCompany" type="text" value="" readOnly="readonly" />
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmAdjCompany" name="oscmAdjCompany" alt="Go" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="leftAligned">Adjuster</td>
					<td class="rightAligned" colspan="3">
						<input style="width: 66px;" type="text" id="txtPrivAdjCd" name="txtPrivAdjCd" readonly="readonly"/>	
						<div style="width: 300px; float: right; margin-left: 3px;" class="withIconDiv">
							<input style="width: 275px; float: left;" class="withIcon" id="txtAdjuster" name="txtAdjuster" type="text" value="" readOnly="readonly" />  
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmAdjuster" name="oscmAdjuster" alt="Go" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="leftAligned">Date Assigned</td>
					<td>
						<div style="float: left; margin-left: 3px; width: 130px;" class="withIconDiv">
					    	<input style="width: 105px;" class="withIcon" id="txtDateAssigned" name="txtDateAssigned" type="text" readOnly="readonly"/>
					    	<img id="hrefDateAssigned" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date Assigned" />
					    </div>
					</td>
					<td class="leftAligned" style="width: 104px; text-align: right;">Date Completed</td>
					<td>
						<div style="float: left; margin-left: 3px; width: 130px;" class="withIconDiv">
					    	<input style="width: 105px;" class="withIcon" id="txtDateCompleted" name="txtDateCompleted" type="text" readOnly="readonly"/>
					    	<img id="hrefDateCompleted" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date Completed" />
					    </div>
					</td>
				</tr>
				<tr>
					<td class="leftAligned">Remarks</td>
					<td colspan="3">
						<div style="float:left; width: 377px; margin-left: 3px;" class="withIconDiv">
							<textarea onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);" id="txtRemarks" name="txtRemarks" style="width: 348px;" class="withIcon"> </textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editTxtRemarks" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="leftAligned"></td>
					<td colspan="3">
						<div>
							<label style="float: left; margin-top: -2px; margin-left: 5px; margin-right: 5px;">Surveryor</label><input type="checkbox" id="chkSurveyorTag" style="float: left;"/>
							<label style="float: left; margin-top: -2px; margin-left: 5px; margin-right: 5px;">Delete Tag</label><input type="checkbox" id="chkDeleteTag"  style="float: left;" disabled="disabled" />
							<label style="float: left; margin-top: -2px; margin-left: 5px; margin-right: 5px;">Cancel Tag</label><input type="checkbox" id="chkCancelTag"/>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>
	
	<div class="buttonsDiv" align="center" style="margin-bottom: 1px; margin-top: 15px;">
		<input type="button" id="btnAdjAdd" name="btnAdd" style="width: 80px;" class="button hover"   value="Add" />
		<input type="button" id="btnAdjDelete" name="btnDelete" style="width: 80px;" class="button hover"   value="Delete" />
		<input type="button" id="btnAdjPrint" name="btnPrint" style="width: 80px;" class="button hover"   value="Print" />
		<input type="button" id="btnAdjHistory" name="btnAdjHistory" style="width: 120px;" class="button hover"   value="Adjuster History" />
		<input type="button" id="btnAdjSave" name="btnSave" style="width: 80px;" class="button hover"   value="Save" />
		<input type="button" id="btnExit" name="btnExit" style="width: 80px;" class="button hover"   value="Return" />
	</div>
</div>
</div>
<script type="text/javascript">
	var giclClmAdjHistExist = ('${giclClmAdjHistExist}');
	var recAction = "Add";
	var currX = null;
	var currY = null;
	var adjChangeTag = 0;
	var giclClmAdjHist = [];
	initializeAll();  //added by steven 03.27.2014
	try {
		var objAdjusterArray = JSON.parse('${clmAdjusterList}'.replace(/\\/g, '\\\\'));
		objCLM.objAdjusterListTableGrid = JSON.parse('${adjusterListTableGrid}'.replace(/\\/g, '\\\\'));
		objCLM.objAdjusterList = objCLM.objAdjusterListTableGrid.rows || [];

		var row = null;
		var adjusterTableModel = {
				url: contextPath+"/GICLClmAdjusterController?action=showAdjusterListing&claimId=" + objCLMGlobal.claimId+"&refresh=1",
				options:{
					hideColumnChildTitle: true,
					title: '',
					newRowPosition: 'bottom',
					onCellFocus: function(element, value, x, y, id){
						var mtgId = adjusterListTableGrid._mtgId;
						currX = Number(x);
						currY = Number(y);
						$("btnAdjAdd").value = "Update";
						populateValues(adjusterListTableGrid.getRow(y));
						enableDisableItems("disable");
						//adjusterListTableGrid.keys.releaseKeys(); removed by robert 10.23.2013
					},
					onRemoveRowFocus: function ( x, y, element) {
						adjusterListTableGrid.keys.releaseKeys();
						removeValues();
					},
					onSort: function () {
						adjusterListTableGrid.keys.releaseKeys();
						removeValues();
					},
					postPager: function() {
						adjusterListTableGrid.keys.releaseKeys();
						removeValues();
					},
					toolbar: {
						onSave: function(){
							var ok = true;
							var addedRows 	 	= adjusterListTableGrid.getNewRowsAdded();
							var modifiedRows 	= adjusterListTableGrid.getModifiedRows();
							var delRows  	 	= adjusterListTableGrid.getDeletedRows();

							var objParameters = new Object();
							objParameters.delRows = delRows;
							objParameters.setRows = addedRows.concat(modifiedRows);
							objParameters.histRows = giclClmAdjHist;
							new Ajax.Request(contextPath+"/GICLClmAdjusterController",{
								method: "POST",
								parameters:{
									action: "saveClmAdjuster",
									claimId: 	objCLMGlobal.claimId,
									parameters: JSON.stringify(objParameters)
								},
								asynchronous: false,
								evalScripts: true,
								onCreate: function(){
									showNotice("Saving, please wait...");
								},
								onComplete: function(response){
									if(checkErrorOnResponse(response)) {
										var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
										if (res.message == "SUCCESS"){
											adjChangeTag = 0;
											ok = true;
										}else{
											showMessageBox(response.responseText, "E");
											ok = false;
										}
									}else{
										showMessageBox(response.responseText, "E");
										ok = false;
									}
								}	 
							});	
							
							return ok;
						},
						postSave: function(){
							Windows.close("claim_adjuster_view");
							/* overlayGICLS010Adjuster.close();
							delete overlayGICLS010Adjuster; */
							fireEvent($("adjusterBtn"), "click");
							showMessageBox(objCommonMessage.SUCCESS, "S");
						}	
					}
				},
				columnModel: [
					{
					    id: 'recordStatus',
					    title : '&nbsp;P',
					    altTitle: 'Print Tag',
			            width: '20',
					    sortable: false,
				   		editable: true,
					    hideSelectAllBox: true,
					    editor: new MyTableGrid.CellCheckbox({
				            getValueOf: function(value){
			            		if (value){
									return "Y";
			            		}else{
									return "N";	
			            		}	
			            	},
			            	onClick: function(value, checked){
			            		if (value == "Y"){
									var del = adjusterListTableGrid.getValueAt(adjusterListTableGrid.getColumnIndex('deleteTag'), currY);
					            	var cancel = adjusterListTableGrid.getValueAt(adjusterListTableGrid.getColumnIndex('cancelTag'), currY);
			            			if (del == "Y"){
			            				adjusterListTableGrid.uncheckRecStatus(currX,currY);
			            				showMessageBox("Adjuster/Surveyor Slip cannot be printed, adjuster already deleted.", "E");
			            				return;
			            			}	
			            			if (cancel == "Y"){
			            				adjusterListTableGrid.uncheckRecStatus(currX,currY);
			            				showMessageBox("Adjuster/Surveyor Slip cannot be printed, adjuster already cancelled.", "E");
			            				return;
			            			}	
								} 
			            	}	
			            })
					},
					
					{
						id: 'divCtrId',
						width: '0',
						visible: false
					},	
			         
					{
					    id: 'adjCompanyCd dspAdjCoName',
					    title: 'Adjusting Company',
					    width : '200px',
					    children : [
				            {
				                id : 'adjCompanyCd',
				                width: 60
				            },
				            {
				                id : 'dspAdjCoName', 
				                width: 140
				            }
						]
					},
					
					{
					    id: 'privAdjCd dspPrivAdjName',
					    title: 'Adjuster',
					    width : '200px',
					    children : [
				            {
				                id : 'privAdjCd',
				                width: 60
				            },
				            {
				                id : 'dspPrivAdjName', 
				                width: 140
				            }
						]
					},
							
					{
						id: 'assignDate',
						title: 'Date Assigned',
						width: '120px',
						sortable: true,
						align: 'left',
						visible: true
					},
					
					{
						id: 'compltDate',
						title: 'Date Completed',
						width: '120px',
						sortable: true,
						align: 'left',
						visible: true
					},

					{
						id: 'surveyorSw',
	              		title : '&nbsp;S',
	              		altTitle: 'Surveyor',
		              	width: '20',
		              	editable: false,
		              	sortable: false,
		              	visible: true,
		              	defaultValue:	false,
						otherValue:	false,
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
	              	
	              	{
		              	id: 'deleteTag',
	              		title : '&nbsp;D',
	              		altTitle: 'Delete Tag',
		              	width: '20',
		              	editable: false,
		              	sortable: false,
		              	visible: true,
		              	defaultValue:	false,
						otherValue:	false,
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

	              	{
		              	id: 'cancelTag',
	              		title : '&nbsp;C',
	              		altTitle: 'Cancel Tag',
		              	width: '20',
		              	editable: false,
		              	sortable: false,
		              	visible: true,
		              	defaultValue:	false,
						otherValue:	false,
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
		             {
					    id: 'remarks',
					    title: '',
					    width: '0',
					    visible: false
					 }, 
					 {
					    id: 'claimId',
					    title: '',
					    width: '0',
					    visible: false
					 },	
					 {
					    id: 'clmAdjId',
					    title: '',
					    width: '0',
					    visible: false
					 } 
				],
				resetChangeTag: true,
				rows: objCLM.objAdjusterList,
				id: 1
		};
	
		adjusterListTableGrid = new MyTableGrid(adjusterTableModel);
		adjusterListTableGrid.pager = objCLM.objAdjusterListTableGrid;
		adjusterListTableGrid._mtgId = 1;
		adjusterListTableGrid.render('adjusterTableGrid');
	} catch(e){
		showErrorMessage("adjuster.jsp", e);
	}

	/*
	* OBSERVE ITEMS
	*/
	
	//Remarks editor
	$("editTxtRemarks").observe("click", function () {
		showEditor("txtRemarks", 4000);
	});
	
	//Adjusting Company LOV CLICK event
	$("oscmAdjCompany").observe("click", function () {
		if ($("oscmAdjCompany").disabled == false) {
			/*setLovDtls("clmPayee", "Payee No.", "Payee Name", "List of Company");
			showClaimLOV();*/
			showAdjusterCoLOV("GICLS010");
		}
	});

	//Adjuster LOV CLICK event
	$("oscmAdjuster").observe("click", function () {
		if ($("oscmAdjuster").disabled == false) {
			/*setLovDtls("clmPayee2", "Code", "Adjuster", "List of Adjuster");
			showClaimLOV();*/
			if ($F("txtAdjCompany") == ""){
				customShowMessageBox("Please select Adjusting Company first.", "I", "txtAdjCompany");
				return;
			}	
			showAdjusterLOV(nvl(objCLMGlobal.claimId,""), $F("txtAdjCompanyCd"), "GICLS010");
		}
	});
	
	$("txtAdjCompany").observe("blur", function(){
		$("txtAdjuster").focus();
	});
	
	$("txtAdjuster").observe("blur", function(){
		if ($F('txtDateAssigned') == "" && ($F("txtAdjuster") != "" || $F("txtAdjCompany"))){
			$('txtDateAssigned').value = getCurrentDate();	
		}
	});

	//Date Assigned ICON CLICK event
	$("hrefDateAssigned").observe("click", function(){
		if ($("hrefDateAssigned").disabled == false) {
			scwShow($('txtDateAssigned'),this, null);
		}
	});

	//Date Assigned BLUR event
	$("txtDateAssigned").observe("blur", function (){
		var dspLossDate = $F("txtLossDate") != "" ? new Date($F("txtLossDate").replace(/-/g,"/")) :"";
		var dateAssigned = $F("txtDateAssigned") != "" ? new Date($F("txtDateAssigned").replace(/-/g,"/")) :"";
		var sysdate = new Date();
		if (dateAssigned > sysdate){
			customShowMessageBox("Assign Date cannot be later than the current date.", "E", "txtDateAssigned");
			$("txtDateAssigned").clear();
			return false;
		}
		if (dateAssigned < dspLossDate && dateAssigned != "" && dspLossDate != ""){
			customShowMessageBox("Assign date cannot be earlier than the loss date.", "E", "txtDateAssigned");
			$("txtDateAssigned").clear();
			return false;
		}	
	});	
	
	//Date Completed BLUR event
	observeBackSpaceOnDate("txtDateCompleted");
	$("txtDateCompleted").observe("blur", function (){
		if ($("chkCancelTag").checked == true && $F("txtDateCompleted") != ""){
			var dateCan = getClmAdjDateCancelled($F("txtAdjCompanyCd"));
			customShowMessageBox("Adjuster assignment cannot be completed. "+
					"Record is considered already cancelled "+
					"(Date cancelled: "+dateCan+").", "I", "txtDateCompleted");
			$("txtDateCompleted").clear();
			return false;
		}
		
		var dateComp = $F("txtDateCompleted") != "" ? new Date($F("txtDateCompleted").replace(/-/g,"/")) :"";
		var dateAssigned = $F("txtDateAssigned") != "" ? new Date($F("txtDateAssigned").replace(/-/g,"/")) :"";
		var sysdate = new Date();
		
		if (dateComp > sysdate){
			customShowMessageBox("Date Completed cannot be later than the current date.", "E", "txtDateCompleted");
			$("txtDateCompleted").clear();
			return false;
		} 
		if (dateComp < dateAssigned && dateAssigned != "" && dateComp != ""){
			customShowMessageBox("Date Completed cannot be earlier than the date of adjuster assigment.", "E", "txtDateCompleted");
			$("txtDateCompleted").clear();
			return false;
		}	 
	});
	
	//Date Completed ICON CLICK event
	$("hrefDateCompleted").observe("click", function(){
		scwShow($('txtDateCompleted'),this, null);
	});
	
	//Cancel TAG CHANGE event
	$("chkCancelTag").observe("change", function (){
		if ($("chkCancelTag").checked == true){
			if ($F("txtDateCompleted") != ""){
				showMessageBox("Adjuster assignment cannot be cancelled. Record is considered already completed(Date completed: " + $F("txtDateCompleted")+").", "I");
				$("chkCancelTag").checked = false;
				return false;
			}
			
			showConfirmBox("Confirm", "This adjuster will be tagged as cancelled for this claim. Do you want to continue?", "Yes", "No", 
					function(){
						//commented out by jeffdojello 12.12.2013 as per Sir Mac
						/* if (checkClmPrivAdjExist($F("txtAdjCompanyCd")) == "Y" && $F("txtPrivAdjCd") == ""){
							customShowMessageBox("Please enter Private Adjuster for "+$F("txtAdjCompany")+".", "I", "txtAdjuster");
							return false;
						}	 */
						
						if ($F('txtDateAssigned') == ""){
							$('txtDateAssigned').value = getCurrentDate();	
						}else{
							fireEvent($("txtDateAssigned"),"blur");	
						}
						
					}, 
			       	function (){
					  	$("chkCancelTag").checked = false;	
				   	});
		}	
	});

	$("btnAdjAdd").observe("click", function(){
		//commented out by jeffdojello 12.12.2013 as per Sir Mac and latest FMB
		/* if (checkClmPrivAdjExist($F("txtAdjCompanyCd")) == "Y" && $F("txtPrivAdjCd") == ""){
			customShowMessageBox("Please enter Private Adjuster for "+$F("txtAdjCompany")+".", "I", "txtAdjuster");
			return false;
		} */
		if ($F("txtAdjCompanyCd") == "" && $F("txtAdjCompany") == ""){
			customShowMessageBox(objCommonMessage.REQUIRED, "E", "txtAdjCompany");
			return;
		}	
		if ($F("btnAdjAdd") == "Add"){
			setColumnValues("add");
		}else {
			setColumnValues("Update");
		}
	}); 

	function confirmDelAdj(){
		showConfirmBox("","This record will be deleted. Do you want to continue?","Yes","No",
				function(){
					//if user cancel first create history for cancel tag
					if ($("chkCancelTag").checked == true && nvl(adjusterListTableGrid.getValueAt(adjusterListTableGrid.getColumnIndex('cancelTag'), currY),"N") == "N"){
						var hist = setAdjHist();
						hist.cancelDate = getCurrentDate();
						giclClmAdjHist.push(hist);
					}
			
					$("chkDeleteTag").checked = true;
					adjusterListTableGrid.setValueAt(($("chkSurveyorTag").checked == true ? "Y" : "N"), adjusterListTableGrid.getColumnIndex('surveyorSw'), currY, true);
					adjusterListTableGrid.setValueAt(($("chkCancelTag").checked == true ? "Y" : "N"), adjusterListTableGrid.getColumnIndex('cancelTag'), currY, true);
					adjusterListTableGrid.setValueAt(($("chkDeleteTag").checked == true ? "Y" : "N"), adjusterListTableGrid.getColumnIndex('deleteTag'), currY, true);
					var hist = setAdjHist();
					hist.deleteDate = getCurrentDate();
					giclClmAdjHist.push(hist);
					removeValues();
					adjChangeTag = 1; //added by steven 03.27.2014
				},
				"");
	}
	
	$("btnAdjDelete").observe("click", function (){
		if ($F("txtDateCompleted") != "" && currY >= 0){
			showMessageBox("Record cannot be deleted. Adjuster assignment is considered already completed (Date completed: "+$F("txtDateCompleted")+").", "E");
			return false;
		}	
		if (currY < 0){
			adjusterListTableGrid.deleteRow(currY);
			removeValues();
		}else{
			new Ajax.Request(contextPath+"/GICLClmAdjusterController",{
				parameters: {
					action: "checkBeforeDelete",
					claimId: objCLMGlobal.claimId,
					adjCompanyCd: $F("txtAdjCompanyCd")
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)) {
						res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
						if (res.countExist == 1){
							if (res.cancelSw == "N"){
								showMessageBox("Record cannot be deleted. Adjusting company is already in use as payee for Expense settlement. Record may be cancelled but the settlement history will have to be cancelled first.", "E");
								return false;
							}else if(res.cancelSw == "Y"){
								showConfirmBox("","Record already has a Cancelled Expense settlement history. Adjusting company may be cancelled instead. Do you want to cancel adjuster assignment?","Yes","No",
										function(){
											$("chkCancelTag").checked = true;
											adjusterListTableGrid.setValueAt(($("chkCancelTag").checked == true ? "Y" : "N"), adjusterListTableGrid.getColumnIndex('cancelTag'), currY, true);
											var hist = setAdjHist();
											hist.cancelDate = getCurrentDate();
											giclClmAdjHist.push(hist);
											removeValues();
										},
										"");
							}else{
								confirmDelAdj();
							}	
						}else{
							confirmDelAdj();
						}	
					}	
				}	
			});
		}	
	}); 

	/*
	* END OBSERVE ITEMS
	*/

	function enableDisableItems(action){
		if (action == "disable") {
			enableButton("btnAdjDelete");
			enableButton("btnAdjPrint");
			enableButton("btnAdjHistory");
			$("oscmAdjCompany").disabled = true;
			$("oscmAdjuster").disabled = true;
			$("hrefDateAssigned").disabled = true;
			$("oscmAdjCompany").hide();
			$("oscmAdjuster").hide();
			$("hrefDateAssigned").hide();
		}else{
			disableButton("btnAdjDelete");
			disableButton("btnAdjPrint");
			disableButton("btnAdjHistory");
			$("oscmAdjCompany").disabled = false;
			$("oscmAdjuster").disabled = false;
			$("hrefDateAssigned").disabled = false;
			$("oscmAdjCompany").show();
			$("oscmAdjuster").show();
			$("hrefDateAssigned").show();
		}
		
		if (giclClmAdjHistExist == "Y"){
			enableButton("btnAdjHistory");
		}else{
			disableButton("btnAdjHistory");
		}
	}
	
	function setAdjHist(){
		var newObj = {};
		newObj.adjHistNo		= null;
		newObj.clmAdjId 		= $F("txtClmAdjId");
		newObj.claimId			= objCLMGlobal.claimId;;
		newObj.adjCompanyCd		= $F("txtAdjCompanyCd");
		newObj.privAdjCd 		= $F("txtPrivAdjCd"); 
		newObj.assignDate 		= nvl($F("txtDateAssigned"),getCurrentDate()); 
		newObj.cancelDate		= null;
		newObj.compltDate 		= $F("txtDateCompleted"); 
		newObj.deleteDate		= null;
		return newObj;
	}	
	
	function setColumnValues(action){
		if (action == "add"){
			if ($F("txtDateAssigned") == ""){
				$("txtDateAssigned").value = getCurrentDate();	
			}	
			var newObj = {};
			newObj.claimId 			= objCLMGlobal.claimId;
			newObj.clmAdjId 		= "";//$F("txtClmAdjId"); -- removed by robert 11.29.2013; clmAdjId is automatically generated for newly added records
			newObj.adjCompanyCd 	= $F("txtAdjCompanyCd");
			newObj.privAdjCd 		= $F("txtPrivAdjCd"); 
			newObj.assignDate 		= $F("txtDateAssigned"); 
			newObj.cancelTag 		= $("chkCancelTag").checked == true ? "Y" : "N"; 
			newObj.compltDate 		= $F("txtDateCompleted"); 
			newObj.deleteTag 		= $("chkDeleteTag").checked == true ? "Y" : "N"; 
			newObj.remarks 			= escapeHTML2($F("txtRemarks"));
			newObj.surveyorSw 		= $("chkSurveyorTag").checked == true ? "Y" : "N"; 
			newObj.dspAdjCoName 	= escapeHTML2($F("txtAdjCompany"));
			newObj.dspPrivAdjName 	= escapeHTML2($F("txtAdjuster"));
			
			if(checkAdjusterDate($F("txtAdjCompanyCd"), $F("txtDateAssigned"))){ 
				adjusterListTableGrid.createNewRow(newObj);
		    	objAdjusterArray.push(newObj); 
			}else{
				showMessageBox("Adjuster / Date Assigned already exists." ,"E"); 
			}
		}else{
			if ($("chkCancelTag").checked == true && nvl(adjusterListTableGrid.getValueAt(adjusterListTableGrid.getColumnIndex('cancelTag'), currY),"N") == "N"){
				var hist = setAdjHist();
				hist.cancelDate = getCurrentDate();
				objAdjusterArraySplice(hist); 
				giclClmAdjHist.push(hist);
			}else if ($F("txtDateCompleted") != "" && $F("txtDateCompleted") != adjusterListTableGrid.getValueAt(adjusterListTableGrid.getColumnIndex('compltDate'), currY)){
				var hist = setAdjHist();
				hist.compltDate = getCurrentDate();
				objAdjusterArraySplice(hist); 
				giclClmAdjHist.push(hist);
			}else{
				var hist = setAdjHist();
				objAdjusterArraySplice(hist); 
				giclClmAdjHist.push(hist);
			}
			adjusterListTableGrid.setValueAt($F("txtDateCompleted"), adjusterListTableGrid.getColumnIndex('compltDate'), currY, true);
			adjusterListTableGrid.setValueAt(($("chkSurveyorTag").checked == true ? "Y" : "N"), adjusterListTableGrid.getColumnIndex('surveyorSw'), currY, true);
			adjusterListTableGrid.setValueAt(($("chkCancelTag").checked == true ? "Y" : "N"), adjusterListTableGrid.getColumnIndex('cancelTag'), currY, true);
			adjusterListTableGrid.setValueAt(escapeHTML2($F("txtRemarks")), adjusterListTableGrid.getColumnIndex('remarks'), currY, true);
		}	
		
		removeValues();
	}

	//to update objAdjusterArray added by christian
	function objAdjusterArraySplice(newObj){
		for(var i=0; i<objAdjusterArray.length; i++){
			if((objAdjusterArray[i].adjCompanyCd == newObj.adjCompanyCd) &&
			   (objAdjusterArray[i].assignDate == newObj.assignDate) &&
			   (objAdjusterArray[i].claimAdjId == newObj.claimAdjId)){
				newObj.cancelTag = $("chkCancelTag").checked == true ? "Y" : "N"; 
				objAdjusterArray.splice(i, 1, newObj);
			}
		}
	}
	
	function populateValues(obj){
		objCLM.variables.compltDate 	= obj.compltDate;
		$("txtAdjCompany").value 		= unescapeHTML2(obj.dspAdjCoName);
		$("txtAdjuster").value 			= unescapeHTML2(obj.dspPrivAdjName);
		$("txtDateAssigned").value 		= obj.assignDate;
		$("txtDateCompleted").value  	= obj.compltDate;
		$("txtRemarks").value 			= unescapeHTML2(obj.remarks);
		$("chkSurveyorTag").checked 	= (obj.surveyorSw == 'Y' ? true : false);
		$("chkDeleteTag").checked 		= (obj.deleteTag == 'Y' ? true : false);
		$("chkCancelTag").checked 		= (obj.cancelTag == 'Y' ? true : false);
		$("txtAdjCompanyCd").value 		= obj.adjCompanyCd;
		$("txtPrivAdjCd").value 		= obj.privAdjCd;
		$("txtClmAdjId").value 			= obj.clmAdjId;
	}

	function removeValues(){
		$("txtAdjCompany").value = null;
		$("txtAdjuster").value = null;
		$("txtDateAssigned").value = null;
		$("txtDateCompleted").value = null;
		$("txtRemarks").value = null;
		$("chkSurveyorTag").checked = false;
		$("chkDeleteTag").checked = false;
		$("chkCancelTag").checked = false;
		$("txtAdjCompanyCd").value = null;
		$("txtPrivAdjCd").value = null;
		enableDisableItems("");
		currY = null;
		currX = null;
		adjusterListTableGrid.unselectRows();
		$("btnAdjAdd").value = "Add";
		adjChangeTag = adjusterListTableGrid.getChangeTag();
	}

	$("btnAdjSave").observe("click", function ()	{
		if(adjChangeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES ,"I"); 
			return false;
		}else{
			adjusterListTableGrid.saveGrid(true);
		}
	});	

	$("btnExit").observe("click", function ()	{
		if(adjChangeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						adjusterListTableGrid.saveGrid(false);
						if (adjChangeTag == 0){
							adjusterListTableGrid.keys.releaseKeys(); //added by robert 10.24.2013
							Windows.close("claim_adjuster_view");
							showMessageBox(objCommonMessage.SUCCESS, "S");
						}
					}, 
					function(){
						adjChangeTag = 0; 
						adjusterListTableGrid.keys.releaseKeys(); //added by robert 10.24.2013
						Windows.close("claim_adjuster_view");
					},
					"");
		} else {
			adjusterListTableGrid.keys.releaseKeys(); //added by robert 10.24.2013
			Windows.close("claim_adjuster_view");
		}
	});
	
	$("btnAdjHistory").observe("click", function(){
		overlayReportsList = Overlay.show(contextPath+"/GICLClmAdjHistController", {
			urlContent: true,
			urlParameters: {action : "showClmAdjHist",
							claimId : objCLMGlobal.claimId
							},
			title: "Claim Adjuster Histrory",	
			id: "clm_adj_hist_view",
			width: 790,
			height: 410,
		    draggable: false,
		    closable: true
		});
	});
	
	function onPrintAdjuster(){
		try{
			var reports = [];
			var obj = adjusterListTableGrid._getSelectedRows();	
			
			for (var a=1; a<=obj.length; a++){
				var content = contextPath+"/PrintAdjusterController?action=populateGiclr060"
				+"&noOfCopies="+$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination")
				+"&policyId="+nvl(objCLM.basicInfo.policyId, "")
				+"&claimNo="+nvl(objCLM.basicInfo.claimNo, "")
				+"&claimId="+nvl(objCLMGlobal.claimId,"")
				+"&payeeNo="+nvl(obj[a-1].adjCompanyCd, "")
				+"&clmAdjId="+nvl(obj[a-1].clmAdjId, "")
				+"&privAdjCd="+nvl(obj[a-1].privAdjCd, "");
				
				reports.push({reportUrl : content, reportTitle : "ADJ-"+nvl(objCLM.basicInfo.claimNo, "")+"-"+nvl(obj[a-1].adjCompanyCd, "")+"-"+nvl(obj[a-1].privAdjCd, "")});

				printGenericReport2(content);
				
				if (a == obj.length){
					if("screen" == $F("selDestination")){
						showMultiPdfReport(reports); 
					}
				}
			}	

		}catch(e){
			showErrorMessage("onPrintAdjuster", e);	
		}	
	}	
	
	$("btnAdjPrint").observe("click", function(){
		var rows = adjusterListTableGrid._getSelectedRows();	
		if (rows.length == 0){
			showMessageBox("Please select adjuster/surveyor from the list.", "I");
			return false;
		}else{	
			showGenericPrintDialog("Print", onPrintAdjuster, '');
		}
	});
	
	function checkAdjusterDate(adjuster, assignDate) {
		try {
			for ( var i = 0; i < (objAdjusterArray.length); i++) {
				if (objAdjusterArray[i].cancelTag != "Y" 
					&& objAdjusterArray[i].adjCompanyCd == adjuster 
					&& objAdjusterArray[i].assignDate == assignDate) {
					return false;
				}
			}
			return true;
		} catch (e) {
			showErrorMessage("checkAdjusterDate", e);
		}
	}
	
	enableDisableItems("");
</script>	