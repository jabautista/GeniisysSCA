<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>

<div id="genBinderMainDiv" name="genBinderMainDiv" style="margin-top: 1px;">
	<div id="genBinderMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="btnExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<form id="genBinderForm" name="genBinderForm">
		<div id="polInfoMainDiv">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
					<label>Policy Information</label>
					<span class="refreshers" style="margin-top: 0;">
						<label name="gro" style="margin-left: 5px;">Hide</label> 
				 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
					</span>
				</div>
			</div>
			<div class="sectionDiv" id="polInfoDiv"changeTagAttr="true">
				<table style="margin-top: 15px; margin-bottom: 10px; margin-left: 70px;">
					<tr>
						<td class="rightAligned" width="90px">Policy No.</td>
						<td class="leftAligned" width="305px">
							<%-- <div style="float: left; width: 330px; height: 27px;">
								<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 218px; border: none;" name="txtPolicyNo" id="txtPolicyNo"readonly="readonly"/>
								<input id="txtLineCd" class="required" type="text" title="Line Code" style="width: 30px;" maxlength="2"/>
							    <input id="txtSublineCd" class="" type="text" title="Subline Code" style="width: 60px;" maxlength="7"/>
							    <input id="txtIssCd" class="" type="text" title="Issue Code" style="width: 30px;" maxlength="2"/>
							    <input id="txtIssueYy" class="integerNoNegativeUnformattedNoComma" type="text" title="Issue Year" style="width: 30px; text-align: right;" maxlength="2"/>
							    <input id="txtPolSeqNo" class="integerNoNegativeUnformattedNoComma" type="text" title="Policy Sequence Number" style="width: 60px; text-align: right;" maxlength="7"/>
							    <input id="txtRenewNo" class="integerNoNegativeUnformattedNoComma" type="text" title="Renew Number" style="width: 25px; text-align: right;" maxlength="2"/>
								<img id="polNoLOV"  alt="goPolicyNo" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
							</div> --%>
							<input id="txtLineCd" class="required" type="text" title="Line Code" style="width: 30px;" maxlength="2"/>
							<input id="txtSublineCd" class="" type="text" title="Subline Code" style="width: 60px;" maxlength="7"/>
							<input id="txtIssCd" class="" type="text" title="Issue Code" style="width: 30px;" maxlength="2"/>
							<input id="txtIssueYy" class="integerNoNegativeUnformattedNoComma" type="text" title="Issue Year" style="width: 30px; text-align: right;" maxlength="2"/>
							<input id="txtPolSeqNo" class="integerNoNegativeUnformattedNoComma" type="text" title="Policy Sequence Number" style="width: 60px; text-align: right;" maxlength="7"/>
							<input id="txtRenewNo" class="integerNoNegativeUnformattedNoComma" type="text" title="Renew Number" style="width: 25px; text-align: right;" maxlength="2"/>
						</td>
						<td class="leftAligned" width="20px">
						 	<img id="polNoLOV"  alt="goPolicyNo" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />
						</td>
						<td class="rightAligned" width="90px">Endt No.</td>
						<td class="leftAligned" width="250px">
							<input type="text" id="txtEndtNo" name="txtEndtNo" style="width: 240px;" readonly="readonly" />
						</td>
					</tr>
					<tr>
						<td class="rightAligned" width="90px">Assured Name</td>
						<td class="leftAligned" width="250px" colspan="2">
							<input type="text" id="txtAssdName" name="txtAssdName" style="width: 295px;" readonly="readonly" />
						</td>
					</tr>
				</table>
				<div id="hidden" style="display: none;" changeTagAttr="true">
					<!-- POLBASIC -->
					<input type="hidden" id="txtPolicyId" name="txtPolicyId">
					<!-- <input type="hidden" id="txtLineCd" name="txtLineCd">
					<input type="hidden" id="txtSublineCd" name="txtSublineCd">
					<input type="hidden" id="txtIssCd" name="txtIssCd">
					<input type="hidden" id="txtIssueYy" name="txtIssueYy">
					<input type="hidden" id="txtPolSeqNo" name="txtPolSeqNo">
					<input type="hidden" id="txtRenewNo" name="txtRenewNo"> -->
					<input type="hidden" id="txtPolicyNo" name="txtPolicyNo">
					<input type="hidden" id="txtAssdNo" name="txtAssdNo">
					<input type="hidden" id="txtEffDate" name="txtEffDate">
					<input type="hidden" id="txtExpiryDate" name="txtExpiryDate">
					<input type="hidden" id="txtParId" name="txtParId">
					<!-- ENDTTEXT -->
					<input type="hidden" id="txtRiCd" name="txtRiCd">
					<input type="hidden" id="txtFnlBinderId" name="txtFnlBinderId">
				</div>
			</div>
		</div>
		
		<div id="riDetailsMainDiv"changeTagAttr="true">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
					<label>Reinsurance Details</label>
					<span class="refreshers" style="margin-top: 0;">
						<label name="gro" style="margin-left: 5px;">Hide</label> 
					</span>
				</div>
			</div>
			<div id="riDtlsDiv" class="sectionDiv"changeTagAttr="true">
				<div id="riDtlsListingTableGridSectionDiv" style="height: 180px; margin-left: 70px; margin-top: 20px;">
					<div id="riDtlsListingTableGrid"changeTagAttr="true"></div>
				</div>
				<div  style="margin-top: 15px; margin-bottom: 5px;  margin-left: 70px; float: left; ">
					<table>
						<tr>
							<td class="rightAligned" width="90px">Reinsurer</td>
							<td class="leftAligned" colspan="3"  width="650px">
								<div style="float: left; border: solid 1px gray; width: 648px; height: 20px;" class="withIconDiv required">
									<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 620px; border: none;" name="txtReinsurer" id="txtReinsurer" class="withIcon required" readonly="readonly"/>
									<img id="reinsurerLOV"  alt="goPolicyNo" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
								</div>
							</td>
						</tr>
						<tr>
							<td class="rightAligned" width="90px">Binder No.</td>
							<td class="leftAligned" width="250px">
								<input type="text" id="txtBinderNo" name="txtBinderNo" style="width: 240px;" readonly="readonly" />
							</td>
							<td class="rightAligned" width="140px">Binder Date</td>
							<td class="leftAligned" width="250px">
								<div id="txtBinderDateDiv" name="txtBinderDateDiv" style="float: left; width: 245px;" class="withIconDiv required">
										<input style="width: 222px;" id="txtBinderDate" name="txtBinderDate" type="text" value="" class="withIcon required" readonly="readonly"/>
										<img id="hrefBinderDate" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Binder Date" onClick="scwShow($('txtBinderDate'),this, null);"/>
									</div>
							</td>
						</tr>
						<tr>
							<td width="200px"colspan="2"><label  style="margin-left: 25px; padding: 5px;">Endorsement Text (Binder)</label></td>
						</tr>
						<tr>
							<td class="rightAligned" width="90px"></td>
							<td class="leftAligned" colspan="3"  width="642px"style="margin-left: 100px;">
								<textarea rows="9" style="width: 642px;" onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" id="txtEndtText" name="txtEndtText"></textarea>
							</td>
						</tr>
						<tr>
							<td class="rightAligned" width="90px">Remarks</td>
							<td class="leftAligned" colspan="3"  width="643px">
								<div style="border: 1px solid gray; height: 20px; width: 99.2%" changeTagAttr="true">
									<textarea onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);" id="txtRemarks" name="txtRemarks" style="width: 95.5%; border: none; height: 13px;"></textarea>
									<img class="hover" src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="buttonsDiv" style="margin-bottom: 10px">
					<input type="button" class="button" id="btnAdd" name="btnAdd" value="Add" style=" width: 80px;"/>
					<input type="button" class="button" id="btnDelete" name="btnDelete" value="Delete" style=" width: 80px;"/>
				</div>
			</div>	
	</form>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel" style=" width: 10%"/>
	<input type="button" class="button" id="btnSave" name="btnSave" value="Save" style=" width: 10%"/>
	<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style=" width: 10%"/>
</div>

<script>
try{
	//modified by j.diago 09.17.2014 : replace policy number field with policy composition fields.
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	changeTag = 0;
	initializeChangeAttribute();
	disableButton("btnAdd");
	disableButton("btnDelete");
	$("hrefBinderDate").hide();
	var ref = "N";
	var giriExist = "N";
	var updateRiCd = "N";
	var initialRiCd = "";
	var editRecord = "N";
	var process = "";
	var hasPendingRecords = false;
	
	var riCd = "";
	var dspEndtText = "";
	var fnlBinderId = "";
	var remarks = "";
	var dspBinderDate = "";
	
	var objRiDtls = new Object(); 
	var selectedRiDtls = null;
	var selectedRiDtlsRow = "";
	var mtgId = null;
	objRiDtls.riDtlsListingTableGrid = JSON.parse('${riDtlsGrid}'.replace(/\\/g, '\\\\'));
	objRiDtls.riDtls = objRiDtls.riDtlsListingTableGrid.rows || [];
	
	function setRIDetails(obj) {
		try {
			$("txtRiCd").value 					= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.riCd,""))) :null;
			$("txtFnlBinderId").value 	= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.fnlBinderId,""))) :null;
			$("txtRemarks").value 			= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.remarks,""))) :null;
			$("txtReinsurer").value 		=nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.dspRiName,""))) :null;
			$("txtBinderNo").value 		= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.dspBinderNo,""))) :null;
			$("txtBinderDate").value 		= nvl(obj,null) != null ?dateFormat(obj.strDspBinderDate, "mm-dd-yyyy") :null;
			$("txtEndtText").value 			= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.dspEndtText,""))) :null;
			$("txtRemarks").value 			= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.remarks,""))) :null;
			$("txtEndtText").value 			= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.dspEndtText,""))) :null;
			$("btnAdd").value 					= obj == null ? "Add" : "Update";
			if($("txtBinderNo").value == "" && nvl(obj,null) != null){
				enableButton("btnDelete"); 
			}else{
				disableButton("btnDelete");
			}
		} catch(e) {
			showErrorMessage("setItemInfoDetails", e);
		}
	}
	
	function showAllRelatedDetails(y){
		selectedRiDtlsRow = riDtlsGrid.geniisysRows[y];
		setRIDetails(selectedRiDtlsRow);
		$("hrefBinderDate").hide();
	}
	
	try {
		var riDtlsListingTable = {
			url: contextPath+"/GIRIEndttextController?action=refreshRiDtlsListing&policyId="+objPolbasic.policyId,
			options: {
				title: '',
				width: '780px',
				height: '150px',
				onCellFocus: function(element, value, x, y, id) {
					riDtlsGrid.keys.releaseKeys();
					mtgId = riDtlsGrid._mtgId;
					selectedRiDtls = y;
					if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")) {
							showAllRelatedDetails(y);
							$("reinsurerLOV").hide();
					}
				},
				onRemoveRowFocus : function(){
					setRIDetails(null);
					selectedRiDtlsRow = null;
					$("reinsurerLOV").show();
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
					id: 'fnlBinderId',
					width: '0',
					visible: false
				},
				{	
					id: 'dspEndtText',
					width: '0',
					visible: false
				},
				{	
					id: 'remarks',
					width: '0',
					visible: false
				},
				{	
					id: 'editRecord',
					width: '0',
					visible: false
				},
				{	
					id: 'initialRiCd',
					width: '0',
					visible: false
				},
				{
					id: 'riCd',
					title: 'Reinsurer Code',
					width: '126',
					titleAlign: 'right',
					align: 'right',
					editable: false,
					sortable:	false
				},
				{
					id: 'dspRiName',
					title: 'Reinsurer Name',
					width: '300',
					titleAlign: 'left',
					editable: false,
					sortable:	false
				},
				{
					id: 'dspBinderNo',
					title: 'Binder No',
					width: '165',
					titleAlign: 'left',
					editable: false,
					sortable:	false
				},
				{
					id: 'strDspBinderDate',
					title: 'Binder Date',
					width: '165',
					titleAlign: 'center',
					align: 'center',
					editable: false,
					sortable:	false,
					renderer : function(value){
						return dateFormat(value, "mm-dd-yyyy");
					}
				},
			],
			resetChangeTag: true,
			rows: objRiDtls.riDtls
		};
		riDtlsGrid = new MyTableGrid(riDtlsListingTable);
		riDtlsGrid.pager = objRiDtls.riDtlsListingTableGrid;
		riDtlsGrid.render('riDtlsListingTableGrid');
		riDtlsGrid.afterRender = function(){
			objRiDtls.riDtls = riDtlsGrid.geniisysRows;
		};
	}catch(e) {
		showErrorMessage("riDtlsGrid", e);
	}
	
	function updateCreateEndtTextBinder(){
		try{
			new Ajax.Request(contextPath+"/GIRIEndttextController?action=updateCreateEndtTextBinder", {
					evalScripts: true,
					asynchronous: false,
					method: "GET",
					parameters: {
						policyId					: $F("txtPolicyId"),
						riCd							: riCd,
						dspEndtText			: dspEndtText,
						fnlBinderId			: fnlBinderId,
						remarks					: remarks,
						lineCd						: $F("txtLineCd"),
						effDate					: dateFormat($F("txtEffDate"),"mm-dd-yyyy"),
						expiryDate			: dateFormat($F("txtExpiryDate"),"mm-dd-yyyy"),
						dspBinderDate		: dateFormat(dspBinderDate,"mm-dd-yyyy"),
						issCd						: $F("txtIssCd"),
						initialRiCd				: initialRiCd,
						editRecord 			: editRecord
					},
					onComplete: function(response) {
						if (checkErrorOnResponse(response)) {
							if(process == "U"){
								showWaitingMessageBox("Update successful.", "S", function(){
									showGenBinderNonAffEndtPage(objPolbasic.policyId);
								});
							}else if(process == "A"){
								showWaitingMessageBox("Added successfully.", "S", function(){
									showGenBinderNonAffEndtPage(objPolbasic.policyId);
								});
							}else{
								showWaitingMessageBox("Saving successful.", "S", function(){
									if(ref == 'Y'){
										showGenBinderNonAffEndtPage(objPolbasic.policyId);
									}else{
										objPolbasic = new Object();
										changeTag = 0;
										checkChangeTagBeforeUWMain();
									}
								});
							}
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}
				});
		}catch(e) {
			showErrorMessage("updateCreateEndtTextBinder", e);
		}
	}
	
    function setPolicyInfo(row) {
		try {
			if(row != null) {
				$("txtPolicyId").value				=	row.policyId 			== null ? "" : row.policyId;
				$("txtPolicyNo").value				=	row.policyNo		== null ? "" : row.policyNo;
				$("txtEndtNo").value					=	row.endtNo 			== null ? "" : row.endtNo;
				$("txtAssdName").value			=	row.assdName 	== null ? "" : row.assdName;
				$("txtAssdNo").value					=	row.assdNo			== null ? "" : row.assdNo;
				$("txtEffDate").value					=	row.effDate 			== null ? "" : row.effDate;
				$("txtExpiryDate").value			=	row.expiryDate 	== null ? "" : row.expiryDate;
				$("txtParId").value						=	row.parId 				== null ? "" : row.parId;
				$("txtLineCd").value					=	row.lineCd 			== null ? "" : row.lineCd;
				$("txtSublineCd").value			=	row.sublineCd 		== null ? "" : row.sublineCd;
				$("txtIssCd").value						=	row.issCd 				== null ? "" : row.issCd;
				$("txtIssueYy").value					=	row.issueYy 			== null ? "" : formatNumberDigits(row.issueYy,2); //added format by j.diago 09.17.2014
				$("txtPolSeqNo").value				=	row.polSeqNo 		== null ? "" : formatNumberDigits(row.polSeqNo,7); //added format by j.diago 09.17.2014
				$("txtRenewNo").value			=	row.renewNo 		== null ? "" : formatNumberDigits(row.renewNo,2); //added format by j.diago 09.17.2014
				if($("txtPolicyId").value != ""){
					enableButton("btnAdd");
				}
			}
		} catch(e) {
			showErrorMessage("setPolicyInfo", e);
		}
	}
	setPolicyInfo(objPolbasic);
	
	function showRiGIUTS024LOV(lineCd, sublineCd, issCd, issueYy, polSeqNo, renewNo, policyId, riCd) {
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action 		: "getGIISReinsurerLOV2",
						    lineCd 			: lineCd,
						    sublineCd 		: sublineCd,
						    issCd 				: issCd,
						    issueYy			: issueYy,
						    polSeqNo 		: polSeqNo,
						    renewNo 		: renewNo,
						    policyId 			: policyId,
						    riCd 				: riCd,
						    page 				: 1},
			title: "Reinsurers",
			width: 415,
			height: 386,
			columnModel: [ 
			               {	id: "riCd",
				            	title: "RI Code",
				            	width: '100px'
			               },
			               {	id: "riName",
				            	title: "RI Name",
				            	width: '300px'
			               }
			              ],
			draggable: true,
	  		onSelect: function(row){
				$("txtRiCd").value = unescapeHTML2(row.riCd);
				$("txtReinsurer").value = unescapeHTML2(row.riName);
				if($F("txtBinderDate") == ""){
					var sysdate = new Date();
					$("txtBinderDate").value = dateFormat(sysdate,"mm-dd-yyyy");
					$("hrefBinderDate").show();
				}
				if( giriExist == "Y"){
					riDtlsGrid.setValueAt($F("txtRiCd"), riDtlsGrid.getColumnIndex("riCd"), selectedRiDtls, true);
					riDtlsGrid.setValueAt($F("txtReinsurer"), riDtlsGrid.getColumnIndex("dspRiName"), selectedRiDtls, true);
					riDtlsGrid.setValueAt("Y", riDtlsGrid.getColumnIndex("editRecord"), selectedRiDtls, true);
				}
				enableButton("btnSave");
				enableButton("btnPrint");
				enableButton("btnDelete");
	  		}
		});
	}
	
	function saveRiDtls(){
		if( giriExist == "Y"){
			var rows =   riDtlsGrid.getModifiedRows();
			for(var i=0; i<rows.length;  i++){
				riCd = rows[i].riCd;
				dspEndtText = rows[i].dspEndtText;
				fnlBinderId = rows[i].fnlBinderId;
				remarks = rows[i].remarks;
				dspBinderDate = dateFormat(rows[i].strDspBinderDate,"mm-dd-yyyy");
				initialRiCd = rows[i].initialRiCd;
				editRecord = rows[i].editRecord;
				updateCreateEndtTextBinder();	
			}
		}else{
			riCd = $F("txtRiCd");
			dspEndtText = $F("txtEndtText");
			fnlBinderId = $F("txtFnlBinderId");
			remarks = $F("txtRemarks");
			dspBinderDate = $F("txtBinderDate");
			updateCreateEndtTextBinder();
		}
	}
	
	function deleteRiDtlsGIUTS024(){
		try{
			new Ajax.Request(contextPath+"/GIRIEndttextController?action=deleteRiDtlsGIUTS024", {
					evalScripts: true,
					asynchronous: false,
					method: "GET",
					parameters: {
						riCd					: $F("txtRiCd"),
						fnlbinderId	: $F("txtFnlBinderId")
					},
					onCreate: showNotice("Deleting, please wait..."),
					onComplete: function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)) {
							showWaitingMessageBox("Deleted successfully.", "S", function(){
								showGenBinderNonAffEndtPage(objPolbasic.policyId);
							});
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}
				});
		}catch(e) {
			showErrorMessage("deleteRiDtlsGIUTS024", e);
		}
	}
	
	$("polNoLOV").observe("click", function() {
		if($F("txtLineCd") != ""){ //added by j.diago 09.17.2014
			changeTag = 1;
			showGIUTS024LOV();	
		} else {
			showMessageBox("Please enter line code first.","E");
		}
	});
	
	$("reinsurerLOV").observe("click", function(){
		if($F("txtPolicyNo") == "" ){
			showWaitingMessageBox("Please select a policy first.", "I", function(){
				showGIUTS024LOV();
			});
		}else{
			showRiGIUTS024LOV($F("txtLineCd"), $F("txtSublineCd"), $F("txtIssCd"),$F("txtIssueYy"), $F("txtPolSeqNo"), $F("txtRenewNo"), $F("txtPolicyId"), $F("txtRiCd"));
			changeTag = 1;
		}
	});
	
	$("btnExit").observe("click", function(){
			objPolbasic = new Object();
			checkChangeTagBeforeUWMain();
	});
	
	$("btnCancel").observe("click", function(){
			objPolbasic = new Object();
			checkChangeTagBeforeUWMain();
	});
	
	function createRiDtls(func){
		try {
			var riDtl 							= new Object() ;			
			riDtl.recordStatus 		= func == "Delete" ? -1 : func == "Add" ? 0 : 1;
			riDtl.riCd			 			= escapeHTML2($F("txtRiCd"));
			riDtl.dspEndtText		= escapeHTML2($F("txtEndtText"));
			riDtl.fnlBinderId  		= escapeHTML2($F("txtFnlBinderId"));
			riDtl.remarks		  		= escapeHTML2($F("txtRemarks"));
			riDtl.dspBinderDate 	=dateFormat($F("txtBinderDate"),"mm-dd-yyyy");
			riDtl.policyId				 	= escapeHTML2($F("txtPolicyId"));
			riDtl.lineCd				 	= escapeHTML2($F("txtLineCd"));
			riDtl.effDate				 	= dateFormat($F("txtEffDate"),"mm-dd-yyyy");
			riDtl.expiryDate		 	= dateFormat($F("txtExpiryDate"),"mm-dd-yyyy");
			riDtl.issCd					 	= escapeHTML2($F("txtIssCd"));
			riDtl.dspRiName          = escapeHTML2($F("txtReinsurer"));
			riDtl.dspBinderNo		= nvl(escapeHTML2($F("txtBinderNo")), "");
			return riDtl;
		} catch (e){
			showErrorMessage("createRiDtls", e);
		}			
	}
	
	$("btnAdd").observe("click", function(){
		var isComplete = checkAllRequiredFields();
		if(hasPendingRecords){
			showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
				setRIDetails(null);
			});
		}else if (isComplete == true){
			var riDtl = createRiDtls($F("btnAdd"));
			ref = 'Y';
			if($F("btnAdd") == "Add"){	
				objRiDtls.riDtls.push(riDtl);
				riDtlsGrid.addBottomRow(riDtl);
			} else {					
				riDtlsGrid.updateRowAt(riDtl, selectedRiDtls);
				$("reinsurerLOV").show();
			}
			hasPendingRecords = true;
			setRIDetails(null);
		}
	});
	
	function saveBinder(){
		var objParameters = new Object();
		
		objParameters.setItemRows= getAddedAndModifiedJSONObjects(objRiDtls.riDtls);
		objParameters.delItemRows = getDeletedJSONObjects(objRiDtls.riDtls);
		
		new Ajax.Request(contextPath+"/GIRIEndttextController?action=saveEndtTextBinder", {
			method: "POST",
			parameters:{
				parameters : JSON.stringify(objParameters)
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				showNotice("Saving , please wait...");
			},
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)) {
					if (response.responseText == "SUCCESS"){
						showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function() {
							showGenBinderNonAffEndtPage(objPolbasic.policyId);
						});
						changeTag = 0;
					}
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	$("btnSave").observe("click", function(){
			 if(changeTag == 0){
				showMessageBox("No changes to save.", imgMessage.INFO);
				return false;
			}else{
				saveBinder();
			}
	});
	
	$("btnDelete").observe("click", function(){
		if (nvl(riDtlsGrid,null) instanceof MyTableGrid);
		var riDtl = createRiDtls("Delete");
		objRiDtls.riDtls.splice(selectedRiDtls, 1, riDtl);
		riDtlsGrid.deleteVisibleRowOnly(selectedRiDtls);
		setRIDetails(null);
	});
	
	function showPrintDialog(){
		preLossRepPrintDialog = Overlay.show(contextPath+"/GIRIEndttextController", {
			urlContent : true,
			urlParameters: {
				action : "showPrintDialog"
			},
		    title: "Print",
		    height: 165,
		    width: 380,
		    draggable: true
		});
	}
	
	$("btnPrint").observe("click", function () {
		riDtlsGrid.keys.removeFocus(riDtlsGrid.keys._nCurrentFocus, true);
		riDtlsGrid.keys.releaseKeys();
		if(selectedRiDtlsRow == null || selectedRiDtlsRow == ""){
			showMessageBox("Please select a record first.", "I");
		}else{
			if(changeTag == 1){
				showMessageBox("Save changes first before pressing PRINT BUTTON.","I");
			}else{
				showPrintDialog();
			}
		}
	});
	
	$("editRemarks").observe("click", function () {
		showEditor("txtRemarks", 4000);
	});
	
	observeReloadForm("reloadForm", 
			function() {
		        objPolbasic = {}; //added by j.diago 09.17.2014 : to reload the page completely since last valid policy number is being displayed.
				showGenBinderNonAffEndtPage(objPolbasic.policyId);
	});
	
	initializeChangeTagBehavior(saveBinder);
		
	$("txtLineCd").observe("keyup",function(){
		$("txtLineCd").value = $("txtLineCd").value.toUpperCase();
	});
	
	$("txtSublineCd").observe("keyup",function(){
		$("txtSublineCd").value = $("txtSublineCd").value.toUpperCase();
	});
	
	$("txtIssCd").observe("keyup",function(){
		$("txtIssCd").value = $("txtIssCd").value.toUpperCase();
	});
	
	$("txtLineCd").focus();
}catch(e){
	showErrorMessage("GIUTS024 page", e);
}
</script>
