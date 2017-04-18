<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="reassignClaimRecordDiv" style="margin-bottom: 50px; float: left;">
	<div id="reassignClaimRecordExitDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="reassignClaimRecordExit">Exit</a>
					</li>
				</ul>
			</div>
		</div>
	</div>
	<div style="width: 922px;"></div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Re-assign Claim Record</label>
		</div>
	</div>
	
	<div class="sectionDiv" style="padding-bottom: 10px;">
		<div id="claimsTableGrid" style="margin-left: 10px; margin-bottom: 10px; height: 330px; margin-top: 10px;"></div>
		<table align="center">
			<tr>
				<td class="rightAligned">Remarks</td>
				<td class="leftAligned">
					<div style="border: 1px solid gray; height: 21px; width: 750px">
						<textarea id="txtRemarks" name="txtRemarks" readonly="readonly" style="border: none; height: 13px; resize: none; width: 720px" maxlength="4000"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="EditRemark" id="editRemarksText" tabindex=206/>
					</div>
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<input type="button" class="button" style="margin-top: 10px;" id="btnReassignProcessor" name="btnReassignProcessor" value="Reassign Processor" />
				</td>
			</tr>
		</table>
	</div>
	
	<div align="center">
		<input type="button" class="button" style="width: 80px; margin-top: 10px;" id="btnCancel" name="btnCancel" value="Cancel" />
		<input type="button" class="button" style="width: 80px; margin-top: 10px;" id="btnSave" name="btnSave" value="Save" />
	</div>
	<input id="txtUserId" type="hidden" value=""/>
	<input id="txtIssCd" type="hidden" value=""/>
</div>

<script type="text/javascript">
	setDocumentTitle("Re-assign Claim Record");
	setModuleId("GICLS044");
	changeTag = 0;
	reassignTag = 0;
	try {
	
		var row = 0;
		var objReassign = [];
		var objReassignClaimRecord = new Object();
		objReassignClaimRecord.reassignListing = JSON.parse('${jsonReassign}'.replace(/\\/g, '\\\\'));
		objReassignClaimRecord.reassignClaim = objReassignClaimRecord.reassignListing.rows || [];
	
		var reassignClaimTG = {
			url : contextPath + "/GICLReassignClaimRecordController?action=showReassignClaimRecord&lineCd=" + objCLMGlobal.lineCd,
			options : {
				width : '900px',
				height : '306px',
				onCellFocus : function(element, value, x, y, id) {
					row = y;
					objReassignClaim = reassignClaimRecordTableGrid.geniisysRows[y];
					$("txtRemarks").value = unescapeHTML2(reassignClaimRecordTableGrid.geniisysRows[y].remarks);
					$("txtIssCd").value = reassignClaimRecordTableGrid.geniisysRows[y].issCd;
				},
				onRemoveRowFocus : function() {
					reassignClaimRecordTableGrid.keys.releaseKeys();
					$("txtRemarks").value = "";
				},
				beforeSort : function() {
					if (changeTag == 1 ) {
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}
				},
				onSort : function() {
					reassignClaimRecordTableGrid.keys.releaseKeys();
					$("txtRemarks").value = "";
				},
				onRefresh : function(){
					reassignClaimRecordTableGrid.keys.releaseKeys();
					$("txtRemarks").value = "";
				},
				prePager : function(){
					if (changeTag == 1 ) {
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}else{
						reassignClaimRecordTableGrid.keys.releaseKeys();
						$("txtRemarks").value = "";
					}
				},
				toolbar : {
					elements : [ MyTableGrid.REFRESH_BTN,MyTableGrid.FILTER_BTN ],
					onFilter : function() {
						reassignClaimRecordTableGrid.keys.releaseKeys();
						$("txtRemarks").value = "";
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
				}
			},
			columnModel : [ 
			{
				id 				: 'recordStatus',
				width 			: '0',
				visible 		: false
			},
			{
				id 				: 'divCtrId',
				width 			: '0',
				visible		    : false
			},
			{
				id 				: 'reassignClmChk',
				width 			: '25px',
				align 			: 'center',
				title			: 'R',
				editable		: true,
				sortable		: false,
				editor 				: new MyTableGrid.CellCheckbox({
					onClick: function(value, checked) {
						if(changeTag == 1){
							showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
							if (value == "Y") {
								$("mtgInput"+reassignClaimRecordTableGrid._mtgId+"_2,"+row).checked = false;
							} else {
								$("mtgInput"+reassignClaimRecordTableGrid._mtgId+"_2,"+row).checked = true;
							}
						}else{
							checkTable();	
						}
 			    	},	
 			    	getValueOf : function(value) {
						if (value) {
							return "Y";
						} else {
							return "N";
						}
					}
				})
			},
			{
				id 				: 'claimNo',
				title 			: 'Claim Number',
				titleAlign		: 'left',
				width 			: '135px',
				visible 		: true,
				filterOption 	: true
			}, 
			{
				id 				: 'policyNo',
				title 			: 'Policy Number',
				titleAlign		: 'left',
				width 			: '150px',
				visible 		: true,
				filterOption 	: true
			}, 
			{
				id 				: 'assdName',
				title 			: 'Assured Name',
				width 			: '268px',
				visible 		: true,
				filterOption 	: true
			}, 
			{
				id 				: 'claimStatus',
				title 			: 'Claim Status',
				width 			: '80px',
				visible 		: true,
				filterOption 	: true
			}, 
			{
				id 				: 'plateNo',
				title 			: 'Plate Number',
				width 			: '100px',
				visible 		: objCLMGlobal.lineCd == "MC" || objCLMGlobal.menuLineCd == "MC" ? true : false, //modified by Cherrie - 01.20.2014 - added conditions to consider the menuLineCd
				filterOption 	: objCLMGlobal.lineCd == "MC" || objCLMGlobal.menuLineCd == "MC" ? true : false //modified by Cherrie - 01.20.2014 - added conditions to consider the menuLineCd
			},
			{
				id 				: 'inHouAdj',
				title 			: 'Claim Processor',
				width 			: '100px',
				visible 		: true,
				filterOption 	: true
			},
			{
				id 				: 'remarks',
				title 			: 'Remarks',
				width 			: '0px',
				visible 		: false
			},
			{
				id 				: 'claimId',
				title 			: 'Claim Id',
				width 			: '0px',
				visible 	 	: false
			},
			{
				id 				: 'issCd',
				title 			: 'Iss Cd',
				width 			: '0px',
				visible 		: false
			}
			],
			rows : objReassignClaimRecord.reassignClaim
		};
		reassignClaimRecordTableGrid = new MyTableGrid(reassignClaimTG);
		reassignClaimRecordTableGrid.pager = objReassignClaimRecord.reassignListing;
		reassignClaimRecordTableGrid.render('claimsTableGrid');
		reassignClaimRecordTableGrid.afterRender = function() {
			objReassign = reassignClaimRecordTableGrid.geniisysRows;
		};
	} catch (e) {
		showErrorMessage("Re-assign Claim Record", e);
	}
	
	function setReassignClaim(i) {
		var rowReassign			 	 = new Object();
		rowReassign.claimNo 		 = reassignClaimRecordTableGrid.geniisysRows[i].claimNo;
		rowReassign.policyNo 	 	 = reassignClaimRecordTableGrid.geniisysRows[i].policyNo;
		rowReassign.assdName 		 = reassignClaimRecordTableGrid.geniisysRows[i].assdName;
		rowReassign.claimStatus 	 = reassignClaimRecordTableGrid.geniisysRows[i].claimStatus;
		rowReassign.plateNo 		 = reassignClaimRecordTableGrid.geniisysRows[i].plateNo;
		rowReassign.inHouAdj 		 = $("txtUserId").value;
		rowReassign.remarks 		 = reassignClaimRecordTableGrid.geniisysRows[i].remarks;
		rowReassign.claimId			 = reassignClaimRecordTableGrid.geniisysRows[i].claimId;
		return rowReassign;
	}
	
	function updateTable(){
		for ( var i = 0; i < reassignClaimRecordTableGrid.rows.length; i++) {
			if(reassignClaimRecordTableGrid.rows[i][reassignClaimRecordTableGrid.getColumnIndex('reassignClmChk')] == 'Y') {
				rowObj = setReassignClaim(i);
				objReassign.splice(i, 1, rowObj);
				reassignClaimRecordTableGrid.updateVisibleRowOnly(rowObj, i);
			}
		}
		changeTag = 1;
	}
	
	function saveDueDateDetail() {
		var objParams = new Object();
			objParams.setRows = getAddedAndModifiedJSONObjects(objReassign);
		new Ajax.Request(contextPath + "/GICLReassignClaimRecordController?action=updateClaimRecord", {
			method : "POST",
			parameters : {
				parameters : JSON.stringify(objParams)
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response) {
				hideNotice("");
				changeTag = 0;
				if (checkErrorOnResponse(response)) {
					$("txtRemarks").value = "";
					showMessageBox(objCommonMessage.SUCCESS, "S");
					reassignTag = 0;
					reassignClaimRecordTableGrid.refresh();
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	function showUserLOVGICLS044() {
		try {
			LOV.show({
				controller 		: "ClaimsLOVController",
				urlParameters 	: {
					action 		: "getuserLOVGICLS044",
					lineCd 		: objCLMGlobal.lineCd,
					issCd 		: $("txtIssCd").value
				},
				title : "Reassign claim record to...",
				width : 405,
				height : 386,
				columnModel     : [ {
					id 			: "userId",
					title 		: "User Id",
					width 		: '80px'
				}, {
					id 			: "userName",
					title 		: "User Name",
					width 		: '310px'
				} ],
				draggable : true,
				onSelect : function(row) {
					$("txtUserId").value = row.userId;
					showConfirmBox3("CONFIRMATION MESSAGE", "Do you want to continue re-assigning these claims?", "Yes", "No", updateTable, null);
				}
			});
		} catch (e) {
			showErrorMessage("showUserLOVGICLS022", e);
		}
	}
	
	function checkTable(){
		for ( var i = 0; i < reassignClaimRecordTableGrid.rows.length; i++) {
			if(reassignClaimRecordTableGrid.rows[i][reassignClaimRecordTableGrid.getColumnIndex('reassignClmChk')] == 'Y') {
				enableButton("btnReassignProcessor");
				reassignTag = 1;
				//checkIfCanReassignClaim(); removed by jdiago | 03.25.2014 | add validation if claim number is owned by the reassignee.
				if(objReassignClaim.inHouAdj != userId){ // added by jdiago | 03.25.2014 | validate if claim number is not owned by the reassignee.
					checkIfCanReassignClaim();
				}
				break;
			}else{
				reassignTag = 0;
			}
		}
	}
	
	function checkIfCanReassignClaim() {
		new Ajax.Request(contextPath + "/GICLReassignClaimRecordController?action=checkIfCanReassignClaim", {
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response) {
				if (checkErrorOnResponse(response)) {
					if(response.responseText == 'Y'){
						reassignTag = 1;
						return true;
					}else{
						showMessageBox(response.responseText, "W");
						reassignTag = 0;
						$("mtgInput"+reassignClaimRecordTableGrid._mtgId+"_2,"+row).checked = false;	
					}
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	observeCancelForm("reassignClaimRecordExit", saveDueDateDetail, function() {
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
	});
	
	observeCancelForm("btnCancel", saveDueDateDetail, function() {
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
	});
	
	observeSaveForm("btnSave", saveDueDateDetail);
	
	$("btnReassignProcessor").observe("click", function(){
		if (reassignTag == 0) {
			showMessageBox("Please check the box of the claim you want to reassign.", "I");
		} else {
			showUserLOVGICLS044();
		}
	});
	
	$("editRemarksText").observe("click", function() {
		reassignClaimRecordTableGrid.keys.releaseKeys();
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"),
		function() {
			limitText($("txtRemarks"), 4000);
		});
	});

	$("txtRemarks").observe("keyup", function() {
		limitText(this, 4000);
	});
</script>