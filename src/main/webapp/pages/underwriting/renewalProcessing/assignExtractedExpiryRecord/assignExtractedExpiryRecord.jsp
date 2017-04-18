<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="assignExtractedExpiryRecordDiv" style="margin-bottom: 50px; float: left;">
	<div id="assignExtractedExpiryRecordExitDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="assignExtractedExpiryRecordExit">Exit</a>
					</li>
				</ul>
			</div>
		</div>
	</div>
	<%-- <jsp:include page="/pages/toolbar.jsp"></jsp:include> --%> <!-- Commented out by kenneth 01.22.2014 -->
	<div style="width: 922px;"></div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Assign Extracted Expiry Record to a New User</label>
		</div>
	</div>
	
	<div class="sectionDiv" style="padding-bottom: 10px; margin-bottom: 10px;">
		<div id="policyTableGrid" style="margin-left: 10px; height: 325px; margin-top: 20px;"></div>
		<div align="center" style="padding: 5px; padding-top: 10px;">
			<input type="button" class="button" style="width: 100px;" id="btnListAll" name="btnListAll" value="List All" tabindex="201"/> <!-- added by kenneth L. as a replacement to toolbar Execute query 01.22.2014 -->
			<input type="button" class="button" style="width: 100px;" id="btnParameter" name="btnParameter" value="Query" tabindex="202"/>	<!-- Gzelle 07092015 SR4744 UW-SPECS-2015-065 Reassignment of Extracted Policies GIEXS008_v2-->
			<!-- <input type="button" class="button" style="width: 100px;" id="btnAssignExpiry" name="btnAssignExpiry" value="Assign Expiry" tabindex="203"/>  Gzelle 07092015 moved on div below-->
		</div>
		<div class="sectionDiv" style="padding: 5px; margin-top: 5px; width: 405px; height: 65px; margin-left: 247px;">	<!-- start Gzelle 07092015 SR4744 UW-SPECS-2015-065 -->
			<label style="float: left; margin-left: 5px; margin-top: 5px; margin-bottom: 5px;">Assign Records</label><br><br>
			<div style="margin-top: 5px;">
				<input type="radio" name="rdo" id="rdoTagAll" value="T" title="Tag All" style="float: left; margin-right: 10px;" tabindex="203"/>
				<label for="rdoTagAll" tabindex="203" style="float: left; height: 20px; padding-top: 2px; padding-right: 10px;">Tag All</label>
				<input type="radio" name="rdo" id="rdoUntagAll" value="U" title="Untag All" style="float: left; margin-right: 10px;" tabindex="204"/>
				<label for="rdoUntagAll" tabindex="204" style="float: left; height: 20px; padding-top: 2px; padding-right: 10px;">Untag All</label>
				<input type="radio" name="rdo" id="rdoSelected" value="S" title="Selected Policies" style="float: left; margin-right: 10px;" tabindex="205"	checked="checked"/>
				<label for="rdoSelected" tabindex="205" style="float: left; height: 20px; padding-top: 2px; padding-right: 10px;">Selected Policies</label>
				<input type="button" class="button" style="width: 100px; padding-top: 2px;" id="btnAssignExpiry" name="btnAssignExpiry" value="Assign Expiry" tabindex="206"/>
			</div>
		</div>																											<!-- end Gzelle 07092015 SR4744 UW-SPECS-2015-065 -->
	</div>
	<div align="center">
		<input type="button" class="button" style="width: 100px;" id="btnCancel" name="btnCancel" value="Cancel" tabindex="203"/>
		<input type="button" class="button" style="width: 100px;" id="btnSave" name="btnSave" value="Save" tabindex="204"/>
	</div>
</div>

<script type="text/javascript">
	initializeAll();
	setModuleId("GIEXS008");
	setDocumentTitle("Assign Extracted Expiry Record to a New User");
	changeTag = 0;
	assignTag = 0;
	vUserCheck = 0;
	params = new Object();
	mis = "N";
	assignTo = "";
	disableButton("btnAssignExpiry");
	expiryExtract = "";
	assignToUser = "";
	lineCode = "";
	issueSource = "";
	fromDate = "";
	toDate = "";
	sublineCode = "";
	intmNumber = "";
	creditingBranch = "";
	result = "";
	policy = "";
	selected = false;
	allowReassignExp = nvl('${allowReassignExp}',"N");	
	selectedRec = null;
	recToAssign = [];
	recToRemove = [];
	origExtractUsersRec = [];
	
	$$("input[name='rdo']").each(function(btn){
		btn.disabled = true;			
	});

	allSw = '${allSw}';
	misSw = '${misSw}';
	mgrSw = '${mgrSw}';
	userId = '${userId}';
	if (misSw == "Y" || mgrSw == "Y") {
		mis = "Y";
	}
	
	//start Gzelle 07092015 SR4744 UW-SPECS-2015-065
	function toggleAssignExpiryBtn() {
		if (allowReassignExp == "N") {
			if (allSw == "Y" && mis == "Y") {
				enableButton("btnAssignExpiry");
				$$("input[name='rdo']").each(function(btn){
					btn.disabled = false;			
				});
			}
		} else if (allowReassignExp == "Y") {
			if (allSw == "Y") {
				enableButton("btnAssignExpiry");
				$$("input[name='rdo']").each(function(btn){
					btn.disabled = false;			
				});
			}
		}
	}
	
	//07102015
	function loadDefaults() {
		assignExtractedExpiriesTable.url = contextPath + "/GIEXExpiriesVController?action=showAssignExtractedExpiryRecord&refresh=1&objFilter={policyNo : 0}";
		$("rdoSelected").checked = true;
		assignToUser = "";
		assignTag = 0;
		recToAssign = [];
		recToRemove = [];
		origExtractUsersRec = [];
		toggleAssignExpiryBtn();
		lineCode = "";
		issueSource = "";
		fromDate = "";
		toDate = "";
		sublineCode = "";
		intmNumber = "";
		creditingBranch = "";
	}
	//end
	
	try {
		var row = 0;
		objAssignExtractedExpiry = [];
		assignExtractedExpiry = new Object();
		assignExtractedExpiry.assignListing = [];
		assignExtractedExpiry.assignExpiry = assignExtractedExpiry.assignListing.rows || [];
		objDummyAssignRecords = [];
		
		var assignExtractedExpiriesTG = {
			url : contextPath + "/GIEXExpiriesVController?action=showAssignExtractedExpiryRecord",
			options : {
				width : '900px',
				height : '302px',
				hideColumnChildTitle : true,
				validateChangesOnPrePager : false,	//Gzelle 07132015 SR4744
				onCellFocus : function(element, value, x, y, id) {
					row = y;
					selectedRec = assignExtractedExpiriesTable.geniisysRows[y];	//Gzelle 07132015 SR4744
				},
				beforeSort : function() {
					if (changeTag == 1 && assignTag != 0) {
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}
				},
				onSort : function() {
					if (changeTag == 1 && assignTag != 0) {
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}
				},
				prePager : function() {

				},
				toolbar : {
					elements : [ MyTableGrid.REFRESH_BTN,MyTableGrid.FILTER_BTN ],
					onFilter : function() {
						if($('mtgFilterText'+assignExtractedExpiriesTable._mtgId).value == ""){
							assignExtractedExpiriesTable.url = contextPath + "/GIEXExpiriesVController?action=showAssignExtractedExpiryRecord";
						}else{ 
							assignExtractedExpiriesTable.url = contextPath + "/GIEXExpiriesVController?action=showAssignExtractedExpiryRecord&refresh=1";
							enableButton("btnParameter");
							enableButton("btnAssignExpiry");
						}
					} 
				},
				postPager : function() {
					if (assignTag == 4 || assignTag == 42) {	//Gzelle 07102015 SR4744 changed to 4 from 3
						params.assignByBatch();
					}else {	//start Gzelle 07142015 SR4744
						loadTaggedRecords();//end	
					}
				}
			},
			columnModel : [
					{
						id : 'recordStatus',
						width : '0',
						visible : false
					},
					{
						id : 'divCtrId',
						width : '0',
						visible : false
					},
					{
						id : 'nbtReassignmentSw',
						width : '25',
						title : 'R',
						align : 'center',
						altTitle : 'For Reassignment',
						editable : true,
						sortable : false,
						editor : new MyTableGrid.CellCheckbox(
								{
									onClick : function(value, checked) {
										if (changeTag == 1 && (assignTag == 2 || assignTag == 3)) {
											showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
											if (value == "Y") {
												$("mtgInput" + assignExtractedExpiriesTable._mtgId + "_2," + row).checked = false;
											} else {
												$("mtgInput" + assignExtractedExpiriesTable._mtgId + "_2," + row).checked = true;
											}
										} else {
											checkTable(value);	//Gzelle 07132015 SR4744
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
					}, {
						id : 'policyNo',
						title : 'Policy Number',
						filterOption : true,
						width : '197'
					}, {
						id : 'dspAssured',
						title : 'Assured',
						filterOption : true,
						width : '455'
					}, {
						id : 'expiryDateString',
						title : 'Expiry Date',
						titleAlign : 'center',
						align : 'center',
						filterOption : true,
						filterOptionType : 'formattedDate', //Kenneth 05.07.2014
						width : '85'
					}, {
						id : 'extractUser',
						title : 'User Id',
						filterOption : true,
						width : '88'
					}, {
						id : 'policyId',
						width : '0',
						visible : false
					}, {
						id : 'isPackage',
						width : '0',
						visible : false
					}, {
						id : 'lineCd',
						width : '0',
						visible : false
					}, {
						id : 'issCd',
						width : '0',
						visible : false
					}, {
						id : 'sublineCd',
						width : '0',
						visible : false
					}, {
						id : 'intmNo',
						width : '0',
						visible : false
					}, {
						id : 'postFlag',
						width : '0',
						visible : false
					}, {
						id : 'extractDateString',
						width : '0',
						visible : false
					} ],
			rows : assignExtractedExpiry.assignExpiry
		};
		assignExtractedExpiriesTable = new MyTableGrid(assignExtractedExpiriesTG);
		assignExtractedExpiriesTable.pager = assignExtractedExpiry.assignListing;
		assignExtractedExpiriesTable.render('policyTableGrid');
		assignExtractedExpiriesTable.afterRender = function() {
			objAssignExtractedExpiry = assignExtractedExpiriesTable.geniisysRows;
            if(assignExtractedExpiriesTable.geniisysRows.length == 0){	//added by kenneth L.
            	$("mtgPagerMsg"+assignExtractedExpiriesTable._mtgId).innerHTML = "<strong>Use Query to view record/s or press List All button to show all records.</strong>";
          	}
		};
	} catch (e) {
		showErrorMessage("Assign Extracted Expiries Table", e);
	}

	function checkTable(value) {	// start modified by Gzelle 07132015 SR4744
		var chkboxStat = value;
		var prevAssignTag = "";
		if (chkboxStat == "Y") {
			if ($("rdoUntagAll").checked) {
				$("rdoSelected").checked = true;
				selected = true;
			}
			includeInRecToAssign(selectedRec);
			prevAssignTag = assignTag;
			assignTag = 1;
			if (prevAssignTag == 4 && $("rdoSelected").checked) {	//empty array
				assignTag = 4;
				recToAssign = [];
			}
		} else {
			removeInRecToAssign(selectedRec);
			$("rdoSelected").checked = true;
			selected = true;
		}
	}
	
	function includeInRecToAssign(obj){
		var row = new Object();
		var exists = false;
		for(var i=0; i<recToAssign.length; i++) {
			if(obj.policyId == recToAssign[i].policyId && obj.isPackage == recToAssign[i].isPackage) {
				exists = true;
			}
		}
		if(!exists) {
			row.policyId = obj.policyId;
			row.origExtractUser = obj.extractUser;
			row.isPackage = obj.isPackage;	//Gzelle 09142015 SR4744
			recToAssign.push(row);	//store the records tagged
		}
		for(var b = 0; b < recToRemove.length; b++) {
			if(selectedRec.policyId == recToRemove[b].policyId && selectedRec.isPackage == recToRemove[b].isPackage) {
				recToRemove.splice(b,1);	//remove in recToRemove the tagged record
			}
		}
	}
	
	function removeInRecToAssign(obj) {
		var exists = false;
		for(var a = 0; a < recToRemove.length; a++) {
			if(obj.policyId == recToRemove[a].policyId && obj.isPackage == recToRemove[a].isPackage) {
				exists = true;
			}
		}
		if(!exists) {
			obj.nbtReassignmentSw = "N";
			recToRemove.push(obj);
		}
		
		for(var b = 0; b < recToAssign.length; b++) {
			if(selectedRec.policyId == recToAssign[b].policyId) {
				for(var a = 0; a < assignExtractedExpiriesTable.rows.length; a++) {
					if(selectedRec.policyId == assignExtractedExpiriesTable.geniisysRows[a].policyId &&
							selectedRec.isPackage == assignExtractedExpiriesTable.geniisysRows[a].isPackage) {
						$('mtgIC'+assignExtractedExpiriesTable._mtgId+'_6,'+a).innerHTML = recToAssign[b].origExtractUser;	//display the original extract user upon unchecking
						$('mtgIC'+assignExtractedExpiriesTable._mtgId+'_2,'+a).removeClassName('modifiedCell');
					}
				}
				recToAssign.splice(b,1);	//remove in recToAssign the untagged record
			}
		}
		if (!areThereRecToAssign()) {	//check if recToAssign is empty
			if (assignTag == 42 || assignTag == 4) {
				for ( var x = 0; x < origExtractUsersRec.length; x++) {
					if(selectedRec.policyId == origExtractUsersRec[x].policyId) {
						$('mtgIC'+assignExtractedExpiriesTable._mtgId+'_6,'+row).innerHTML = origExtractUsersRec[x].origExtractUser;
					}
				}
				$('mtgIC'+assignExtractedExpiriesTable._mtgId+'_2,'+row).removeClassName('modifiedCell');
			}else {
				changeTag = 0;
				assignTag = 0;
				assignExtractedExpiriesTable.clear();
			}
		}
	}
	
	function loadTaggedRecords() {
		var x = assignExtractedExpiriesTable.getColumnIndex("nbtReassignmentSw");
		var x2 = assignExtractedExpiriesTable.getColumnIndex("extractUser");
		var mtgId = assignExtractedExpiriesTable._mtgId;

		for ( var a = 0; a < assignExtractedExpiriesTable.rows.length; a++) {
			
			for ( var b = 0; b < recToAssign.length; b++) {
				if (assignExtractedExpiriesTable.geniisysRows[a].policyId == recToAssign[b].policyId &&
						assignExtractedExpiriesTable.geniisysRows[a].isPackage == recToAssign[b].isPackage){
					$('mtgInput'+mtgId+'_'+x+','+a).checked = true;
					$('mtgIC'+mtgId+'_'+x+','+a).addClassName('modifiedCell');
					$('mtgIC'+mtgId+'_'+x2+','+a).innerHTML = nvl(assignToUser,assignExtractedExpiriesTable.geniisysRows[a].extractUser);
				}
			}
		}
	}
	
	function isItInRecToRemove(obj) {
		var result = false;
		for ( var a = 0; a < recToRemove.length; a++) {
			if(obj.policyId == recToRemove[a].policyId && obj.isPackage == recToRemove[a].isPackage) {
				result = true;
			}
		}
		return result;
	}
	
	//07202015
	function areThereRecToAssign() {
		var result = false;
		if (recToAssign.length > 0) {
			result = true;
		}
		return result;
	}
	/*end Gzelle 07142015 SR4744*/

	function setassignExtractedExpiries(i) {
		var rowReassign = new Object();
		var extractUser = new Object();	//Gzelle 07212015 SR4744
		rowReassign.nbtReassignmentSw = "Y";	//Gzelle 07132015 SR4744
		rowReassign.policyNo = assignExtractedExpiriesTable.geniisysRows[i].policyNo;
		rowReassign.dspAssured = assignExtractedExpiriesTable.geniisysRows[i].dspAssured;
		rowReassign.expiryDateString = assignExtractedExpiriesTable.geniisysRows[i].expiryDateString;
		rowReassign.extractUser = nvl(assignToUser,assignExtractedExpiriesTable.geniisysRows[i].extractUser);	//Gzelle 07132015 SR4744
		rowReassign.policyId = assignExtractedExpiriesTable.geniisysRows[i].policyId;
		rowReassign.isPackage = assignExtractedExpiriesTable.geniisysRows[i].isPackage;
		$("mtgIC"+assignExtractedExpiriesTable._mtgId+"_2,"+i).addClassName("modifiedCell");	//start Gzelle 07212015 SR4744
		extractUser.origExtractUser = assignExtractedExpiriesTable.geniisysRows[i].extractUser;	
		extractUser.policyId =  assignExtractedExpiriesTable.geniisysRows[i].policyId;			
		origExtractUsersRec.push(extractUser);													//end
		return rowReassign;
	}

	function assignByBatch() {
		for ( var i = 0; i < assignExtractedExpiriesTable.rows.length; i++) {
			var line = assignExtractedExpiriesTable.geniisysRows[i].lineCd;
			var subline = assignExtractedExpiriesTable.geniisysRows[i].sublineCd;
			var issue = assignExtractedExpiriesTable.geniisysRows[i].issCd;
			var intm = assignExtractedExpiriesTable.geniisysRows[i].intmNo;
			var flag = assignExtractedExpiriesTable.geniisysRows[i].postFlag;
			var extrct = assignExtractedExpiriesTable.geniisysRows[i].extractUser;
			var ext = mis == "Y" ? extrct : userId;
			var extractDate = makeDate(assignExtractedExpiriesTable.geniisysRows[i].extractDateString);
			var expiryDate = makeDate(assignExtractedExpiriesTable.geniisysRows[i].expiryDateString);
			var dateToUse = expiryExtract == "BYEXPIRY" ? expiryDate : extractDate;
			
			if (result == "UPDATE WITHOUT DATE") {
				if (line == nvl(lineCode, line)
						&& subline == nvl(sublineCode, subline)
						&& issue == nvl(issueSource, issue)
						&& intm == nvl(intmNumber, intm) && flag == "N"
						&& extrct == ext) {
					rowObj = setassignExtractedExpiries(i);
					objAssignExtractedExpiry.splice(i, 1, rowObj);
					assignExtractedExpiriesTable.updateVisibleRowOnly(rowObj, i);
					changeTag = 1;
				}
			} else if (result == "UPDATE WITH DATE") {
				if (line == nvl(lineCode, line)
						&& subline == nvl(sublineCode, subline)
						&& issue == nvl(issueSource, issue)
						&& intm == nvl(intmNumber, intm) && flag == "N"
						&& extrct == ext && dateToUse >= makeDate(fromDate)
						&& dateToUse <= makeDate(toDate)) {
					rowObj = setassignExtractedExpiries(i);
					objAssignExtractedExpiry.splice(i, 1, rowObj);
					assignExtractedExpiriesTable.updateVisibleRowOnly(rowObj, i);
					changeTag = 1;
				}
			} else if (result == "QUERY") {		//start Gzelle 07102015 SR4744
				rowObj = setassignExtractedExpiries(i);
				if (isItInRecToRemove(rowObj)) {
					selected = true;
				} else {
					objAssignExtractedExpiry.splice(i, 1, rowObj);
					assignExtractedExpiriesTable.updateVisibleRowOnly(rowObj, i);
				}
			}									//end Gzelle 07102015 SR4744
		}
		/*start Gzelle 07142015 SR4744*/
		if (selected) {
			$("rdoSelected").checked = true;
		}else {
			$("rdoTagAll").checked = true;
		}
		/*end*/
	}

	params.assignByBatch = assignByBatch;

	function showParameterOverlay() {
		try {
			overlayParameters = Overlay.show(contextPath + "/GIEXExpiriesVController", {
				urlContent : true,
				urlParameters : {
					action : "showParameters"
				},
				title : "Enter Parameters",
				height : 300,
				width : 550,
				draggable : false	
			});
		} catch (e) {
			showErrorMessage("showParameterOverlay", e);
		}
	}
	
	/*start Gzelle 06262015 SR3935*/
	function getUserParam(statusTag) {
		var policyId = "";
		for ( var i = 0; i < assignExtractedExpiriesTable.rows.length; i++) {
			if (assignExtractedExpiriesTable.rows[i][assignExtractedExpiriesTable.getColumnIndex('nbtReassignmentSw')] == 'Y') {
				policyId = assignExtractedExpiriesTable.rows[i][assignExtractedExpiriesTable.getColumnIndex('policyId')]+","+policyId;
			}
		}
		
		if (statusTag == "2S") {	//added by Gzelle 07212015 SR4744
			for(var i=0; i<recToAssign.length; i++) {	
				policyId = recToAssign[i].policyId + "," + policyId;
			}	
		} else if (statusTag == "4S") {
			for(var i=0; i<recToRemove.length; i++) {	
				policyId = recToRemove[i].policyId + "," + policyId;
			}	
		}							//end Gzelle 07212015 SR4744
		return policyId;
	}/*end*/

	$("btnAssignExpiry").observe("click", function() {
		//if ((misSw == "Y" || mgrSw == "Y") && assignTag == 1) {	commented out Gzelle 07102015 SR4744
		if (assignTag == 1 || assignTag == 4 || assignTag == 3 ) {		//Gzelle 07102015 SR4744 
			showUserLOV();
		} else if (assignTag == 0) {
			showMessageBox("Please check the record you want to assign.", "I");
		} else if (assignTag == 2 || assignTag == 42/*|| assignTag == 3*/) {	//Gzelle 07102015 SR4744
			showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
		} else {
			customShowMessageBox("You must have MIS access or a Manager access.", imgMessage.INFO, "btnAssignExpiry");
		}
	});

	function showUserLOV() {
		try {
			var rdoStatus = "";	//start Gzelle 07312015 SR4744
			var statusTag = "";
			$$("input[name='rdo']").each(function(btn){
				if (btn.checked){
					rdoStatus = $F(btn);
				}			
			});
			statusTag = assignTag + rdoStatus;
			
			LOV.show({
				controller : "UWRenewalProcessingLOVController",	/* start - Gzelle 09162015 SR4744*/
				urlParameters : {
					action : "getGiexs008UserLov",
					search : "",
					lineCd : lineCode,
					issCd : issueSource,
					policyId : getUserParam(statusTag),			
					statusTag : statusTag,
					to : $("mtgPagerMsg1").down().innerHTML		/*end - Gzelle 07312015 SR4744 */ 
				},
				width : 490,
				height : 386,
				autoSelectOneRecord : true,
				title : "List of Extract Users", //Kenneth 05.07.2014
				filterText : "",
				columnModel : [ {
					id : "userId",
					title : "User ID",
					width : '80px'
				}, {
					id : "username",
					title : "User Name",
					width : '310px'
				}, {
					id : "userGrp",
					title : "User Group",
					width : '80px'
				} ],
				draggable : true,
				onSelect : function(row) {
					assignToUser = row.userId;
					updateTable(row.userId);
				},
				onUndefinedRow : function() {
					showMessageBox("No record selected.", imgMessage.INFO);
				}
			});
		} catch (e) {
			showErrorMessage("showUserLOV", e);
		}
	}

	function updateTable(assign) {
		var chekedNoAccess = false;
		var countRec = 0;
		if (assignTag == 1) {	/*start Gzelle 07142015 SR4744*/
			assignTag = 2;
		}else if (assignTag == 4) {
			assignTag = 42;
		}						/*end*/
		for ( var i = 0; i < assignExtractedExpiriesTable.rows.length; i++) {
			if ($("mtgInput" + assignExtractedExpiriesTable._mtgId + "_2," + i).checked == true) {
				countRec = countRec + 1;
				var line = assignExtractedExpiriesTable.geniisysRows[i].lineCd;
				var iss = assignExtractedExpiriesTable.geniisysRows[i].issCd;
				rowObj = setassignExtractedExpiries(i);
				objAssignExtractedExpiry.splice(i, 1, rowObj);
				assignExtractedExpiriesTable.updateVisibleRowOnly(rowObj, i);
			}
		}

		for ( var a = 0; a < recToAssign.length; a++) {
			recToAssign[a].extracUser = assign;
		}
	}
	
	function checkExtractUserAccess(line, iss, user) {
		new Ajax.Request(contextPath + "/GIEXExpiriesVController?action=checkExtractUserAccess", {
			parameters : {
				lineCd : line,
				issCd : iss,
				extractUser : user
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response) {
				if (checkErrorOnResponse(response)) {
					vUserCheck = JSON.parse(response.responseText);
				} else {
					showMessageBox("assignExpiry", imgMessage.ERROR);
				}
			}
		});
	}

	function assignExpiry() {
		var rdoStatus = "";	//start Gzelle 07212015 SR4744
		var statusTag = "";
		$$("input[name='rdo']").each(function(btn){
			if (btn.checked){
				rdoStatus = $F(btn);
			}			
		});
		statusTag = assignTag + rdoStatus;
		if(assignTag == 1 || assignTag == 4){	//Gzelle 07102015 SR4744 - assignTag=4 (queried)
			showMessageBox("Please assign a user.", "I");
		}else {
			if (statusTag == "2S") {	//added by Gzelle 07212015 SR4744
				for(var i=0; i<recToAssign.length; i++) {	
					policy = recToAssign[i].policyId+"*"+recToAssign[i].isPackage + "," + policy;
				}	
			} else if (statusTag == "42S") {
				for(var i=0; i<recToRemove.length; i++) {	
					policy = recToRemove[i].policyId + "," + policy;
				}	
			}							//end Gzelle 07212015 SR4744

			new Ajax.Request(contextPath + "/GIEXExpiriesVController?", {
				parameters : {
					action : "updateExpiriesByBatch",
					extractUser : assignToUser,
					fromDate : fromDate,
					toDate : toDate,
					byDate : expiryExtract,
					//misSw : mis,	Gzelle 07212015 SR4744
					lineCd : lineCode,
					sublineCd : sublineCode,
					issCd : issueSource,
					intmNo : intmNumber,
					credBranch : creditingBranch,			//start Gzelle 07212015 SR4744
					//update : result, 
					policy : policy,
					statusTag : statusTag,
					to : $("mtgPagerMsg1").down().innerHTML	//end Gzelle 07212015 SR4744
				},
				asynchronous : true,
				evalScripts : true,
				onCreate: showNotice("Loading.. Please wait.."),
				onComplete : function(response) {
					hideNotice("");
					changeTag = 0;
					if (checkErrorOnResponse(response)) {
						showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function() {	//-start Gzelle 07202015 SR4744
							fireEvent($("btnListAll"), "click");	
						});
						
						policy = "";								//end Gzelle 07202015 SR4744
					} else {
						showMessageBox("assignExpiry", imgMessage.ERROR);
					}
				}
			});
		}

	}
	
	$("btnSave").observe("click", function() {	//added by Kenneth L. 03.13.2014
		if(changeTag == 0 && assignTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES ,imgMessage.INFO);
		}else if (!areThereRecToAssign() && assignTag == 0) {		//Gzelle 07202015 SR4744
			showMessageBox(objCommonMessage.NO_CHANGES ,imgMessage.INFO);	
		}else{
			assignExpiry();
		}
	});
	
	function cancelGiexs008(){	//added by Kenneth L. 03.13.2014
		if (changeTag == 1 && assignTag != 0) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						assignExpiry();
					}, function(){
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}
	
	$("assignExtractedExpiryRecordExit").observe("click", cancelGiexs008); //added by Kenneth L. 03.13.2014
	$("btnCancel").observe("click", cancelGiexs008);
	
	$("btnListAll").observe("click", function() {
		if (changeTag == 1 && assignTag != 0) { //changed by kenneth L 03.13.2014
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return false;
		} else {
			assignTag = 0;
			$("rdoSelected").checked = true;	//Gzelle 07132015 SR4744
			recToAssign = [];	//start Gzelle 07142015 SR4744
			recToRemove = [];
			selected = false;	//end
			fireEvent($('mtgBtnClearFilter'+assignExtractedExpiriesTable._mtgId), "click");
			fireEvent($('mtgBtnOkFilter'+assignExtractedExpiriesTable._mtgId), "click");
			assignExtractedExpiriesTable.url = contextPath + "/GIEXExpiriesVController?action=showAssignExtractedExpiryRecord&refresh=1";
			assignExtractedExpiriesTable._refreshList();	//Gzelle 09152015 SR4744
			if(assignExtractedExpiriesTable.rows.length != 0){
				enableButton("btnParameter");
				//enableButton("btnAssignExpiry");	Gzelle 07302015 SR4744
			}
		}
	});

	$("btnParameter").observe("click", function() {
		if (assignTag == 2 || assignTag == 42) { //changed by kenneth L 03.13.2014 Gzelle 08052015 SR4744
			showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
		} else {
			showParameterOverlay();
		}
	});

	$("btnCancel").observe("click", function() {
		checkExtractUserAccess();
	});
	
	/*start Gzelle SR4744 */
	toggleAssignExpiryBtn();						//07092015
	
	$("rdoTagAll").observe("click", function() {	//07092015
		if(assignExtractedExpiriesTable.geniisysRows.length != 0){
			for ( var i = 0; i < assignExtractedExpiriesTable.rows.length; i++) {
				$("mtgInput"+assignExtractedExpiriesTable._mtgId+"_2,"+i).checked = true;
				$("mtgIC"+assignExtractedExpiriesTable._mtgId+"_2,"+i).addClassName("modifiedCell");
			}
			result = "QUERY";
			assignTag = 4;
		}
		recToAssign = [];
		recToRemove = [];
		selected = false;
	});	

	$("rdoUntagAll").observe("click", function() {	//07132015
		assignTag = 0;
		result = "";
		recToAssign = [];
		recToRemove = [];
		selected = false;
		assignExtractedExpiriesTable.clear();
		assignExtractedExpiriesTable.refresh();
	});	
	
	$("mtgRefreshBtn"+assignExtractedExpiriesTable._mtgId).observe("mouseup", function(){
		loadDefaults();
	});
	/*end Gzelle SR4744 */
</script>
