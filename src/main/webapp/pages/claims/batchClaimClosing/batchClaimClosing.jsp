<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="ajax" uri="http://ajaxtags.org/tags/ajax"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="batchOsLossMenu">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="btnExit">Exit</a></li>
			</ul>
		</div>
	</div>
</div>

<div id="batchClaimClosingMainDiv" name="batchClaimClosingMainDiv">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Claim Closing</label>
			<span class="refreshers" style="margin-top: 0;">
	   			<label id="reloadForm" name="reloadForm">Reload Form</label>
   			</span>
		</div>
	</div>
	<div id="batchClaimClosingDiv" class="sectionDiv" style="padding-bottom: 10px;">
		<!-- HIDDEN FIELDS -->
		<input type="hidden" id="txtClaimId" name="txtClaimId" value=""/>
		<input type="hidden" id="txtClaimStatCd" name="txtClaimStatCd" value=""/>
		<input type="hidden" id="txtClaimStatDesc" name="txtClaimStatDesc" value=""/>
		<input type="hidden" id="txtPolFlag" name="txtPolFlag" value=""/>
		
		<input type="hidden" id="txtStatusControl" name="txtStatusControl" value=""/>
		<input type="hidden" id="txtFunctionCd" name="txtFunctionCd" value=""/>
		<input type="hidden" id="txtFunctionDesc" name="txtFunctionDesc" value=""/>
		<input type="hidden" id="txtProcessTag" name="txtProcessTag" value=""/>
		
		<div id="batchClaimClosingDivOuter" style="height:310px; width:99%; margin-left: 10px;">
			<div id="batchClaimClosingTableGridSectionDiv" style="float:left; width: 82%;">
				<div id="batchClaimClosingTableGrid" style="height: 300px; padding-top:10px;"></div>
			</div>
			<div id="batchClaimClosingDivRightOuter" style="float:right; width: 15%; padding-top:10px; margin-right: 15px;">
				<div style="width: 100%;">
					<div style="float:left; width: 100%;">
						<label style="padding:2px; width: 100%; font-weight: bold; text-align:center;">Batch Option</label>
					</div>
					<div style="float:left; width: 100%; border:1px solid #E0E0E0; margin-top:8px; padding-bottom:5px;" >
						<table align="left" style="padding:5px 0 5px 10px;">
							<tr>
								<td class="leftAligned"><input type="radio" id="selectOpen" name="statusControl" value="1" checked></td>
								<td><label for="selectOpen">Open</label></td>
							</tr>
							<tr>
								<td class="leftAligned"><input type="radio" id="selectClosed" name="statusControl" value="2"></td>
								<td><label for="selectClosed">Close</label></td>
							</tr>
							<tr>
								<td class="leftAligned"><input type="radio" id="selectDenied" name="statusControl" value="3"></td>
								<td><label for="selectDenied">Deny</label></td>
							</tr>
							<tr>
								<td class="leftAligned"><input type="radio" id="selectWithdrawn" name="statusControl" value="4"></td>
								<td><label for="selectWithdrawn">Withdraw</label></td>
							</tr>
							<tr>
								<td class="leftAligned"><input type="radio" id="selectCancelled" name="statusControl" value="5"></td>
								<td><label for="selectCancelled">Cancel</label></td>
							</tr>
						</table>
					</div>
					<div style=" float:left; width: 100%; margin-top: 10px;">
						<table>
							<tr>
								<td>
									<input type="button" id="btnProcess" name="btnProcess" class="button" style="width:130px;" value="Process" disabled="disabled"/>
								</td>
							</tr>
							<tr>
								<td>
									<input type="button" id="btnUntagAll" name="btnUntagAll" class="button" style="width:130px;" value="Untag All" disabled="disabled"/>
								</td>
							</tr>
							<tr>
								<td>
									<input type="button" id="btnQuery" name="btnQuery" class="button" style="width:130px;" value="Query"/>
								</td>
							</tr>
						</table>
					</div>
					<!-- <div style="float:left; width: 100%; border:1px solid #E0E0E0; padding-bottom:10px;" >
						<label style="padding:8px 0 8px 6px; width: 100%; text-align:left;">Process:</label>
						<table align="left">
							<tr>
								<td class="leftAligned"><input type="radio" id="optTagAll" name="processTag" value="T"></td>
								<td><label for="optTagAll">Tag All</label></td>
							</tr>
							<tr>
								<td></td>
								<td><input type="checkbox" id="prntdFLA" name="generateFla" value="1" checked>w/ Printed FLAs</td>
							</tr>
							<tr>
								<td class="leftAligned"><input type="radio" id="optUntagAll" name="processTag" value="U"></td>
								<td><label for="optUntagAll">Untag All</label></td>
							</tr>
							<tr>
								<td class="leftAligned"><input type="radio" id="optSelectedClaims" name="processTag" value="S" checked></td>
								<td><label for="optSelectedClaims">Selected Claims</label></td>
							</tr>
						</table>
					</div> -->
				</div>
			</div>
		</div>
		<div id="batchClaimClosingFormDiv" style="width:90%; margin:0 auto;" changeTagAttr="true"> <!-- width:86% -->
			<table style="margin-left:25px;"> <!-- align="center"-->
				<tr>
					<td class="rightAligned">Claim Number</td>
					<td class="leftAligned">
						<input id="txtClaimNo" class="leftAligned" type="text" style="width: 313px;" name="txtClaimNo" readonly="readonly" tabindex=101/>
					</td>
					<td class="rightAligned">Policy Number</td>
					<td class="leftAligned">
						<input id="txtPolicyNo" class="leftAligned" type="text" style="width: 210px;" name="txtPolicyNo" readonly="readonly" tabindex=106/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Assured Name</td>
					<td class="leftAligned">
						<input id="txtAssdName" class="leftAligned" type="text" style="width: 313px;" name="txtAssdName" readonly="readonly" tabindex=102/>
					</td>
					<td class="rightAligned">Close Date</td>
					<td class="leftAligned">
						<input id="txtCloseDate" class="leftAligned" type="text" style="width: 210px;" name="txtCloseDate" readonly="readonly" tabindex=107/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Loss Date</td>
					<td>
						<table style="border-collapse:collapse;">
							<tr>
								<td class="leftAligned">
									<input id="txtLossDate" class="leftAligned" type="text" style="width: 145px;" name="txtLossDate" readonly="readonly" tabindex=103/>
								</td>
								<td class="rightAligned">
									<label style="width: 59px; text-align: right;">Processor</label>
								</td>
								<td class="leftAligned">
									<input id="txtProcessor" class="leftAligned" type="text" style="width: 92px;" name="txtProcessor" readonly="readonly" tabindex=110/>
								</td>
							</tr>
						</table>
					</td>
					<td class="rightAligned">System Entry Date</td>
					<td class="leftAligned">
						<input id="txtSysEntryDate" class="leftAligned" type="text" style="width: 210px;" name="txtSysEntryDate" readonly="readonly" tabindex=108/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">File Date</td>
					<td>
						<table style="border-collapse:collapse;">
							<tr>
								<td class="leftAligned">
									<input id="txtFileDate" class="leftAligned" type="text" style="width: 145px;" name="txtFileDate" readonly="readonly" tabindex=104/>
								</td>
								<td class="rightAligned">
									<label style="width: 59px; text-align: right;">User ID</label>
								</td>
								<td class="leftAligned">
									<input id="txtUserId" class="leftAligned" type="text" style="width: 92px;" name="txtUserId" readonly="readonly" tabindex=111/>
								</td>
							</tr>
						</table>
					</td>
					<td class="rightAligned">Last Update</td>
					<td class="leftAligned">
						<input id="txtLastUpdate" class="leftAligned" type="text" style="width: 210px;" name="txtLastUpdate" readonly="readonly" tabindex=109/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Remarks</td>
					<td class="leftAligned" colspan="3">
						<div style="border: 1px solid gray; height: 20px; ">
							<textarea id="txtRemarks" class="withIcon" style="width: 630px; resize: none;" name="txtRemarks" onkeyup="limitText(this,4000);" onkeydown="limitText(this,4000);" tabindex=105></textarea>
							<img id="editTxtRemarks" alt="Edit" style="width: 14px; height: 14px; margin:3px 2px 3px 3px; float: right;" src="/Geniisys/images/misc/edit.png">
						</div>
					</td>
				</tr>
				<!-- start ::: added Reason field ::: kenneth SR 5147 -->
				<tr>
					<td class="rightAligned">Reason</td>
					<td  colspan="3">
						<table style="border-collapse:collapse;">
							<tr>
								<td class="leftAligned">
									<div style="border: 1px solid gray; height: 20px; ">
										<input class="leftAligned upper" id="txtReasonCd" type="text" style="width: 125px; height: 13px; float: left; border: none; margin-top: 0px;" name="txtReasonCd" maxlength="5" lastValidValue="" tabindex=112/>
										<img id="searchReason" alt="Go" name="searchReason" src="/Geniisys/images/misc/searchIcon.png" style="width: 17px; height: 17px; float: right;">
									</div>
								</td>
								<td class="leftAligned">
									<input class="leftAligned" id="txtReasonDesc" readonly="readonly" type="text" style="width: 497px; height: 14px;" name="txtReasonDesc" lastValidValue="" tabindex=113/>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<!-- end kenneth SR 5147 -->
			</table>
		</div>
	</div>
	<div class="sectionDiv" style="padding-top:20px; margin-bottom:50px">
		<div style="width:98%; margin:0 auto;"> <!-- width:86%; -->
			<table style="margin-left:25px;"> <!--align=left-->
				<tr>
					<td class="rightAligned" style="width:120x;">Loss Reserve</td>
					<td class="leftAligned">
						<input id="txtLossReserve" class="rightAligned" type="text" style="width: 210px;" name="txtLossReserve" readonly="readonly" />
					</td>
					<td class="rightAligned" style="width:215px;">Losses Paid</td>
					<td class="leftAligned">
						<input id="txtLossesPaid" class="rightAligned" type="text" style="width: 210px;" name="txtLossesPaid" readonly="readonly" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width:120px;">Expense Reserve</td>
					<td class="leftAligned">
						<input id="txtExpReserve" class="rightAligned" type="text" style="width: 210px;" name="txtExpReserve" readonly="readonly" />
					</td>
					<td class="rightAligned" style="width:215px;">Expense Paid</td>
					<td class="leftAligned">
						<input id="txtExpPaid" class="rightAligned" type="text" style="width: 210px;" name="txtExpPaid" readonly="readonly" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned" colspan="4" height="15px">
						<label id="lblWithRecovery" style="display:none; float:none;"><b>WITH RECOVERY</b></label>
					</td>
				</tr>
			</table>
		</div>
		<div class="buttonsDiv" style="margin:0 0 18px 0;">
			<table align="center">
				<tr>
					<td><input type="button" class="button" id="btnUpdate" name=""btnUpdate"" value="Update" style="width: 90px;" /></td>
					<td><input type="button" class="button" id="btnSave" name="btnSave" value="Save" style="width: 90px;" /></td>
				</tr>
			</table>
		</div>
	</div>
</div>
<input type="hidden" id="prntdFLA" name="prntdFLA"/>
<script>
	// good luck sa magdedebug XD
	// modified by : J. Diago 03.06.2014 - This is Sparta!
	setModuleId("GICLS039");
	setDocumentTitle("Batch Claim Closing");
	initializeAll();
	
	disableButton("btnProcess");
	disableButton("btnUntagAll");
	
	var currX = null;
	var currY = null;
	var modId = '${modId}';
	var userId = '${userId}';
	var goFlag;
	
	var vOpt;
	var refreshFlag;
	
	var menuLineCd = objCLMGlobal.menuLineCd;
	$("txtStatusControl").value = '${statusControl}';
	checkUserAccess();
	
	function checkUserAccess(){
		try{
			new Ajax.Request(contextPath+"/GIACAccTransController?action=checkUserAccess2", {
				method: "POST",
				parameters: {
					moduleName: "GICLS039"
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(response.responseText == 0){
						showWaitingMessageBox('You are not allowed to access this module.', imgMessage.ERROR, 
								function(){
							goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
						});  
						
					}
				}
			});
		}catch(e){
			showErrorMessage('checkUserAccess', e);
		}
	}
	
	//start kenneth SR 5147 11.13.2015
	$("searchReason").observe("click", function() {
		batchClaimClosingTableGrid.keys.releaseKeys();
		getReasonLOV(true);
	});
	
	$("txtReasonCd").observe("change", function() {
		if (this.value != "") {
			batchClaimClosingTableGrid.keys.releaseKeys();
			getReasonLOV(false);
		} else {
			$("txtReasonCd").value = "";
			$("txtReasonCd").setAttribute("lastValidValue", "");
			$("txtReasonDesc").value = "";
			$("txtReasonDesc").setAttribute("lastValidValue", "");
		}
	});

	$("txtReasonCd").observe("focus", function() {
		batchClaimClosingTableGrid.keys.releaseKeys();
	});
	
	$("txtRemarks").observe("focus", function() {
		batchClaimClosingTableGrid.keys.releaseKeys();
	});
	//end kenneth SR 5147 11.13.2015
	
	try {
		var objTagAllClaims = [];
		var objBatchClaimArray = [];
		var objCheckBoxArray=[];
		var objBatchClaimClosing = new Object();
		//objBatchClaimClosing.objBatchClaimClosingTableGrid = JSON.parse('${batchClaimClosingListJSON}'.replace(/\\/g, '\\\\'));
		//objBatchClaimClosing.batchClaimClosingList = objBatchClaimClosing.objBatchClaimClosingTableGrid.rows || [];
		
		var tableModel = {
				url: contextPath+"/GICLClaimsController?action=refreshClaimClosingList&refresh=1&clmLineCd=-1&clmSublineCd=-1&cmlIssCd=-1&clmYy=-1&clmSeqNo=-1&statusControl="+$("txtStatusControl").value,				
				options:{
					hideColumnChildTitle: true,
					title: '',
					height: '270px',
					onCellFocus: function(element, value, x, y, id) {
						//batchClaimClosingTableGrid.keys.releaseKeys();
						currX = Number(x);
						currY = Number(y);
						var obj = batchClaimClosingTableGrid.geniisysRows[y];
						populateClaimClosing(obj);
					},
					onCellBlur: function(element, value, x, y, id) {
						batchClaimClosingTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus: function(){
						batchClaimClosingTableGrid.keys.releaseKeys();
						populateClaimClosing(null);
					},
					onSort: function () {
						batchClaimClosingTableGrid.keys.releaseKeys();
						populateClaimClosing(null);
					},
					postPager: function() {
						batchClaimClosingTableGrid.keys.releaseKeys();
						populateClaimClosing(null);
						enableDisableProcessBtn();
						//uncheckObjBatchClaimArray();
					},
					toolbar : {
						elements : [MyTableGrid.REFRESH_BTN/* , MyTableGrid.FILTER_BTN  */],
						onRefresh: function(){
							uncheckObjBatchClaimArray();
							populateClaimClosing(null);
							//$("optSelectedClaims").checked = true;
							uncheckObjBatchClaimArray();
							enableDisableProcessBtn();
							batchClaimClosingTableGrid.keys.releaseKeys();
						}/* ,
						onFilter: function(){
							batchClaimClosingTableGrid.keys.releaseKeys();
							populateClaimClosing(null);
							//$("optSelectedClaims").checked = true;
							uncheckObjBatchClaimArray();
							enableDisableProcessBtn();
						} */
					},
					onRefresh : function(){
						uncheckObjBatchClaimArray();
						populateClaimClosing(null);
						//$("optSelectedClaims").checked = true;
						uncheckObjBatchClaimArray();
						enableDisableProcessBtn();
						batchClaimClosingTableGrid.keys.releaseKeys();
					},
					beforeSort : function(){
						if(changeTag == 1){
							showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
								$("btnSave").focus();
							});
							return false;
						}
					},
					prePager: function(){
						if(changeTag == 1){
							showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
								$("btnSave").focus();
							});
							return false;
						}
						populateClaimClosing(null);
						batchClaimClosingTableGrid.keys.releaseKeys();
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
				columnModel: [
					{	id: 'recordStatus', 	
					    title: '',
					    width: '0',
					   	visible: false,
					},
					{	id: 'divCtrId',
						width: '0',
						visible: false
					},
					{
						id: 'processFlag',
					    title : '',
					    altTitle: '',
			            width: '25px',
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
			            		batchClaimClosingTableGrid.keys.releaseKeys();
			            		if(checkUserFunction("2")){
				            		if($F("txtProcessTag")=="U"){
				            			//$("optSelectedClaims").checked = true;
				            			$("txtProcessTag").value = "S";
				            			whenCheckBoxChanged(checked);
				            		}else if($F("txtProcessTag")=="T"){
				            			//$("optSelectedClaims").checked = true;
				            			$("txtProcessTag").value = "S";
				            			whenCheckBoxChanged(checked);
				            		}else{
				            			whenCheckBoxChanged(checked);
				            		}
			            		}
			            	}	
			            })
					},
					{	id: 'claimNumber',
				    	title: 'Claim Number',
		 			    width: '150px',
		 			    align: 'left',
						filterOption: true
				    },
				    {	id: 'policyNo',
				    	title: 'Policy Number',
		 			    width: '170px',
		 			    align: 'left',
						filterOption: true
				    },
				    {	id: 'assuredName',
				    	title: 'Assured Name',
		 			    width: '230px',
		 			    align: 'left',
						filterOption: true
				    },
				    {	id: 'claimStatDesc',
				    	title: 'Claim Status',
		 			    width: '100px',
		 			    align: 'left',
						filterOption: true
				    },
				    {
				    	id: 'inHouseAdjustment',
				        title : 'Processor',
				        width : '0px',
				        visible : false,
				        filterOption : true	
				    },
				    {
				    	id: 'userId2',
				        title : 'User ID',
				        width : '0px',
				        visible : false,
				        filterOption : true	
				    }
				],
				rows: []//objBatchClaimClosing.batchClaimClosingList
			};
	
		    batchClaimClosingTableGrid = new MyTableGrid(tableModel);
			batchClaimClosingTableGrid.pager = {}; //objBatchClaimClosing.objBatchClaimClosingTableGrid;
			batchClaimClosingTableGrid.render('batchClaimClosingTableGrid');
			batchClaimClosingTableGrid.afterRender = function(){ 
				objBatchClaimArray = batchClaimClosingTableGrid.geniisysRows;
				objTagAllClaims = batchClaimClosingTableGrid.pager.objTagAllClaims;
				
				for (var i=0; i<objCheckBoxArray.length; i++){
					for ( var j = 0; j < objBatchClaimArray.length; j++) {
						if (objCheckBoxArray[i].claimId == objBatchClaimArray[j].claimId) {
							 $("mtgInput1_" + batchClaimClosingTableGrid.getColumnIndex("processFlag")+ ","+j).checked = true;
						 }
					}
				}
				
				if(batchClaimClosingTableGrid.geniisysRows.length == 0){
					if(objGICLS039.querySw == "Y"){
						$("mtgPagerMsg"+batchClaimClosingTableGrid._mtgId).innerHTML = "<strong>No records found. Use Query button to view record/s.</strong>";
					} else {
						$("mtgPagerMsg"+batchClaimClosingTableGrid._mtgId).innerHTML = "<strong>Use Query button to view record/s.</strong>";
					}
				}
			};
	} catch (e) {
		showErrorMessage("batchClaimClosing.jsp",e);
	}
	
	/* GENERAL FUNCTIONS */
	function setStatusControl(){
		try {
			statusControl = $("txtStatusControl").value;
			if(statusControl=="1") {
				$("selectOpen").checked = true;
				$("txtFunctionCd").value = 'OP';
				$("txtFunctionDesc").value = 'Open Claim';
			}else if(statusControl=="2") {
				$("selectClosed").checked = true;
				$("txtFunctionCd").value = 'CD';
				$("txtFunctionDesc").value = 'Close Claim';
			}else if(statusControl=="3") {
				$("selectDenied").checked = true;
				$("txtFunctionCd").value = 'DN';
				$("txtFunctionDesc").value = 'Deny Claim';
			}else if(statusControl=="4") {
				$("selectWithdrawn").checked = true;
				$("txtFunctionCd").value = 'WD';
				$("txtFunctionDesc").value = 'Withdraw Claim';
			}else if(statusControl=="5") {
				$("selectCancelled").checked = true;
				$("txtFunctionCd").value = 'CC';
				$("txtFunctionDesc").value = 'Cancel Claim';
			}
		} catch(e) {
			showErrorMessage("setDCBFlagRadio", e);
		}
	}
	
	setStatusControl();
	
	function populateClaimClosing(obj){
		try{
			$("txtClaimId").value 			= obj == null? "" : obj.claimId;
			$("txtClaimNo").value 			= obj == null? "" : obj.claimNumber;
			$("txtPolicyNo").value 			= obj == null? "" : obj.policyNo;
			$("txtAssdName").value 			= obj == null? "" : unescapeHTML2(obj.assuredName);
			$("txtCloseDate").value 		= obj == null? "" : obj.strCloseDate;
			$("txtLossDate").value 			= obj == null? "" : obj.strLossDate;
			$("txtProcessor").value 		= obj == null? "" : unescapeHTML2(obj.inHouseAdjustment);
			$("txtSysEntryDate").value 		= obj == null? "" : obj.strEntryDate;
			$("txtFileDate").value 			= obj == null? "" : obj.strClaimFileDate2;
			$("txtUserId").value 			= obj == null? "" : obj.userId;
			$("txtLastUpdate").value 		= obj == null? "" : obj.strUserLastUpdate;
			$("txtRemarks").value 			= obj == null? "" : unescapeHTML2(obj.remarks);
			$("txtLossReserve").value 		= obj == null? "" : formatCurrency(obj.lossResAmount);
			$("txtLossesPaid").value 		= obj == null? "" : formatCurrency(obj.lossPaidAmount);
			$("txtExpReserve").value 		= obj == null? "" : formatCurrency(obj.expenseResAmount);
			$("txtExpPaid").value 			= obj == null? "" : formatCurrency(obj.expPaidAmount);
			$("txtClaimStatCd").value 		= obj == null? "" : obj.claimStatusCd;
			$("txtClaimStatDesc").value 	= obj == null? "" : obj.claimStatDesc;
			$("txtPolFlag").value 			= obj == null? "" : obj.polFlag;
			
			if(obj == null){
				currY = null;
				currX = null;
				$("editTxtRemarks").hide();
				disableButton("btnUpdate");
				$("lblWithRecovery").hide();
				//start kenneth SR 5147 11.13.2015
				disableSearch("searchReason");
				$("txtReasonCd").readOnly = true;
			   	$("txtRemarks").readOnly = true;
			    //end kenneth SR 5147 11.13.2015
			}else{
				$("editTxtRemarks").show();
				enableButton("btnUpdate");
				//start kenneth SR 5147 11.13.2015
				enableSearch("searchReason");
				$("txtReasonCd").readOnly = false;
			   	$("txtRemarks").readOnly = false;
			    //end kenneth SR 5147 11.13.2015
			  
				if(obj.withRecovery == "Y"){
					$("lblWithRecovery").show();
				}else{
					$("lblWithRecovery").hide();
				}
			}
			
			if($F("txtStatusControl") != "2") {
				//$("prntdFLA").disabled = true;
				$("prntdFLA").value = "1";
			}else{
				if($F("txtProcessTag") == "T"){
					//$("prntdFLA").enabled = true;
					$("prntdFLA").value = "1";
				}else{
					//$("prntdFLA").disabled = true;
					$("prntdFLA").value = "1";
				}
			}
			//start kenneth SR 5147 11.13.2015
			$("txtReasonCd").value 			= obj == null? "" : obj.reasonCode;
			$("txtReasonDesc").value 		= obj == null? "" : obj.reasonDesc;
			$("txtReasonCd").setAttribute("lastValidValue", unescapeHTML2($F("txtReasonCd")));
			$("txtReasonDesc").setAttribute("lastValidValue", unescapeHTML2($F("txtReasonDesc")));
			//end kenneth SR 5147 11.13.2015
		}catch(e){
			showErrorMessage("populateClaimClosing",e);
		}
	}
	
	function whenCheckBoxChanged(checked){
		try{
			if (checked){
				if($F("txtFunctionCd") == "OP"){
					if(checkClaimToOpen()){
						objBatchClaimArray[currY].recordStatus = 1;
						objCheckBoxArray.push(objBatchClaimArray[currY]);
					}else{
						batchClaimClosingTableGrid.uncheckRecStatus(currX, currY);
					}
				}else if($F("txtFunctionCd") == "CD"){
					/* if(checkClaimClosing(objBatchClaimArray[currY].claimId)){
						objBatchClaimArray[currY].recordStatus = 1;
						objCheckBoxArray.push(objBatchClaimArray[currY]);
					}else{
						batchClaimClosingTableGrid.uncheckRecStatus(currX, currY);
					} */
					checkClaimClosing(objBatchClaimArray[currY].claimId);
				}else if($F("txtFunctionCd") == "DN"){
					if(/* checkClaimDenyWithCancel() */true){
						confirmUserSelect("denying", objBatchClaimArray[currY], "S", 3, 'deny', 'denied');
					}else{
						batchClaimClosingTableGrid.uncheckRecStatus(currX, currY);
					}
				}else if($F("txtFunctionCd") == "WD"){
					if(/* checkClaimDenyWithCancel() */true){
						confirmUserSelect("withdrawing", objBatchClaimArray[currY], "S", 4, 'withdraw', 'withdrawn');
					}else{
						batchClaimClosingTableGrid.uncheckRecStatus(currX, currY);
					}
				}else if($F("txtFunctionCd") == "CC"){
					if(/* checkClaimDenyWithCancel() */true){
						confirmUserSelect("cancelling", objBatchClaimArray[currY], "S", 5, 'cancel', 'cancelled');
					}else{
						batchClaimClosingTableGrid.uncheckRecStatus(currX, currY);
					}
				}
			}else{
				for (var i=0; i<objCheckBoxArray.length; i++){
					if (objCheckBoxArray[i].claimId == objBatchClaimArray[currY].claimId) {
						objCheckBoxArray.splice(i, 1);
					 }
				}
			}
			enableDisableProcessBtn();
		}catch(e){
			showErrorMessage("whenCheckBoxChanged",e);
		}
	}
	
	/* PROCESS FUNCTIONS */
	
	function checkClaimToOpen(){
		try{
			var isValid = true;
			if($F("txtPolFlag") == "5"){
	   			showMessageBox('Claim cannot be re-opened. Policy has been spoiled.','I');
	   			isValid = false;
			}else if($F("txtPolFlag") == "4"){
	   			showMessageBox('Claim cannot be re-opened. Policy has been cancelled.','I');
	   			isValid = false;
			}
			return isValid;
		}catch(e){
			showErrorMessage("checkClaimToOpen",e);
		}
	}
	
	/* function checkClaimToOpen(claimId){
		var isValid = true;
		new Ajax.Request(contextPath+"/GICLClaimsController?action=checkClaimToOpen", {
			method: "POST",
			parameters: {
				claimId: claimId
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				var polFlag = response.responseText;

			}
		});
		return isValid;
	} */
	
	function checkClaimDenyWithCancel(){
		try{
			var isValid = true;
			var clmSetld = batchClaimClosingTableGrid.geniisysRows[currY].clmSetld;
			var adviceExist = batchClaimClosingTableGrid.geniisysRows[currY].adviceExist;
			
			if (clmSetld == "Y"){
				if (adviceExist == "Y"){
					isValid = false;
					showMessageBox('Cannot process claim. Advice has already been generated.','I');
				}
			}else{
				isValid = false;
				showMessageBox('Cannot process claim. Loss/Expense payment(s) has(have) already been made.','I');
			}
			   
			return isValid;
		}catch(e){
			showErrorMessage("checkClaimDenyWithCancel",e);
		}
	}
	
	function confirmUserSelect(type, objParameter, selectType, statusControl, action, action2){
		try{
			new Ajax.Request(contextPath+"/GICLClaimsController?action=confirmUserGICLS039", {
				method: "POST",
				parameters: {
					type: type,
					claimId: objParameter.claimId,
                    lineCd: objParameter.lineCode,
                    sublineCd: objParameter.sublineCd,
                    issCd: objParameter.issCd,
                    clmYy: objParameter.claimYy,
                    clmSeqNo: objParameter.claimSequenceNo,  
                    catastrophicCd: objParameter.catastrophicCode,
					selectType: selectType,
					statusControl: statusControl
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					var json = JSON.parse(response.responseText);
					if(json.alertMessage != null){
						if(json.alertMessage == 'LE'){
							showMessageBox('Claim cannot be ' + action2 + '. Loss/Expense payment(s) has(have) already been made.','I');
							batchClaimClosingTableGrid.uncheckRecStatus(currX, currY);
						} else if(json.alertMessage == 'AD'){
							showMessageBox('Unable to ' + action + ' claim. Advice has already been generated.','I');
							batchClaimClosingTableGrid.uncheckRecStatus(currX, currY);
						} else {
							showConfirmBox("CONFIRMATION",
									json.alertMessage, "Yes", "No", 
									function() {
										objBatchClaimArray[currY].recordStatus = 1;
										objCheckBoxArray.push(objBatchClaimArray[currY]);
										enableDisableProcessBtn();
									}, function() {
										batchClaimClosingTableGrid.uncheckRecStatus(currX, currY);
										enableDisableProcessBtn();
									});	
						}
					}else{
						objBatchClaimArray[currY].recordStatus = 1;
						objCheckBoxArray.push(objBatchClaimArray[currY]);
						enableDisableProcessBtn();
					}
				}
			});
		}catch(e){
			showErrorMessage("confirmUser",e);
		}
	}
	
	function denyWithdrawCancelClaims(statusControl){
		try{
			var objParameters = new Object();
			objParameters.addModifiedUnidentifiedCollns = getAddedAndModifiedJSONObjects(objCheckBoxArray);
			var action = '';
			var msg;
			var withCatCd = 'N';
			var listOfCatCd = '';
			var tempListOfCatCd = '';
			var arrayOfCatCd = ['9999'];
			var arrayOfCatCdLength = arrayOfCatCd.length;
			var sameTag = 'N';
			multiTag = 'N';
			
			if(objCheckBoxArray.length > 1){
				for(var i = 0; i < objCheckBoxArray.length; i++){
					if(objCheckBoxArray[i].dspCatDesc != 'INVALID'){
						for(var j = 0; j < arrayOfCatCdLength; j++){
							if(arrayOfCatCd[j] == objCheckBoxArray[i].catastrophicCode){
								sameTag = 'Y';
							}
						}
						
						arrayOfCatCd.push(objCheckBoxArray[i].catastrophicCode);
						arrayOfCatCdLength = arrayOfCatCdLength + 1;
						
						if (sameTag == 'N'){							
							withCatCd = 'Y';
							listOfCatCd = tempListOfCatCd + '<br> - '+ objCheckBoxArray[i].catastrophicCode + "-" + objCheckBoxArray[i].dspCatDesc;
							tempListOfCatCd = listOfCatCd;
						} else {
							sameTag = 'N';
						}
					}
				}
			} else {
				for(var i = 0; i < objCheckBoxArray.length; i++){
					if(objCheckBoxArray[i].dspCatDesc != 'INVALID'){
						withCatCd = 'Y';
						listOfCatCd = listOfCatCd + objCheckBoxArray[i].catastrophicCode + "-" + objCheckBoxArray[i].dspCatDesc;
					}
				}
			}
			
			
			if (objCheckBoxArray.length > 1){
				multiTag = 'Y';	
			}
			
			if(statusControl == "DN"){
				action = "denied";
				if(multiTag != "Y"){
					msg = "Are you sure you want to deny this claim?";
				} else {
					msg = "Are you sure you want to deny these claims?";
				}
			}else if(statusControl == "WD"){
				action = "withdrawn";
				if(multiTag != "Y"){
					msg = "Are you sure you want to withdraw this claim?";
				} else {
					msg = "Are you sure you want to withdraw these claims?";
				}
			}else{
				action = "cancelled";
				if(multiTag != "Y"){
					msg = "Are you sure you want to cancel this claim?";
				} else {
					msg = "Are you sure you want to cancel these claims?";
				}
			}
			
			//modified by kenneth 11.05,2015 SR 5147
			var count = 0;
			var reasonMsg;
			for(var i = 0; i < objCheckBoxArray.length; i++){
				if(objCheckBoxArray[i].reasonCode == null){
					count = count + 1;
				}
			}
			if(count >= 1 && count != objCheckBoxArray.length){
				reasonMsg = "There are no reason for some of the selected claims. Do you want to add reason?";	
			}else if(count == objCheckBoxArray.length){
				reasonMsg = "Do you want to add reason?";
			}
			
			showConfirmBox("CONFIRMATION", msg, "Yes", "No", 
					function(){
						if(count == 0){
							continueDenyWithdrawCancel();
						}else{
							showConfirmBox("CONFIRMATION", reasonMsg, "Yes", "No", 
								function(){
						        	showMessageBox("Please highlight the tagged records you want to add reason to, select the reason on the reason field LOV, press Update and then press Save button." , "I");},
						        continueDenyWithdrawCancel);
						}
					}, "");
			
			function continueDenyWithdrawCancel(){
				new Ajax.Request(contextPath + "/GICLClaimsController?action=denyWithdrawCancelClaims" , {
					method: "POST",
					parameters: {
						statusControl: statusControl,
						parameter: JSON.stringify(objParameters)
					},
					onComplete: function (response){
						hideNotice();
						if(response.responseText != null){
							if(response.responseText == "SUCCESS"){
								if(multiTag != "Y") {
									if(withCatCd == "Y"){
										showMessageBox("Claim has been " + action + ". Please redistribute all records under catastrophic event " + listOfCatCd + ".", 'S');
									} else {
										showMessageBox('Claim has been ' + action + '.', 'S');	
									}
								} else {
									if(withCatCd == "Y"){
										showMessageBox("Claims have been " + action + ". Please redistribute all records under the following catastrophic events: " + listOfCatCd, 'S');
									} else {
										showMessageBox('Claims have been ' + action + '.', 'S');	
									}
								}
							}
							doProcessAfterReOpen();
						}
					}
				});
			};
		}catch(e){
			showErrorMessage("denyWithdrawCancelClaims",e);
		}
	}
	
	
	function enableDisableProcessBtn(){
		if(objCheckBoxArray.length == 0){
			disableButton("btnProcess");
			disableButton("btnUntagAll");
		}else{
			enableButton("btnProcess");
			enableButton("btnUntagAll");
		}
	}
	
	function uncheckObjBatchClaimArray(){
		for (var i=0; i<objCheckBoxArray.length; i++){
			for ( var j = 0; j < objBatchClaimArray.length; j++) {
				if (objCheckBoxArray[i].claimId == objBatchClaimArray[j].claimId) {
					 $("mtgInput1_" + batchClaimClosingTableGrid.getColumnIndex("processFlag")+ ","+j).checked = false;
				 }
			}
		}
		objCheckBoxArray = [];
		disableButton("btnProcess");
		disableButton("btnUntagAll");
	}
	
	/*
	function checkClaimClosingXXX(){
		try{
			var isValid = false;
			var paytSw = batchClaimClosingTableGrid.geniisysRows[currY].paytSw;
			var adviceExist = batchClaimClosingTableGrid.geniisysRows[currY].adviceExist;
			var chkPayment = batchClaimClosingTableGrid.geniisysRows[currY].chkPayment;
			
			if(paytSw == "N"){
				showMessageBox('Claim cannot be closed. Loss/Expense payment(s) has(have) not yet been made.', 'I');
			}else{
				if (adviceExist == "Y"){
					isValid = true;
					if(chkPayment == "Y"){
						isValid = false;
						showMessageBox('Unable to close claim. Advice without payment exists.','I');
					}
				}
			}
			
			if($("prntdFLA").checked == true && paytSw == "Y"){
				new Ajax.Request(contextPath + "/GICLClaimsController?action=checkFlaParams" , {
					method: "POST",
					parameters: {
						claimId:  batchClaimClosingTableGrid.geniisysRows[currY].claimId
					},
					onCreate: function(){
						showNotice("please wait...");
					},
					onComplete: function (response){
						hideNotice();
						if(response.responseText == "Y"){
						}else if(response.responseText == "NO_DATA_FOUND"){
							showMessageBox('Parameter CHECK_FLA not set. There will be no FLA validation','I');
						}else if(response.responseText == "TOO_MANY_ROWS"){
							showMessageBox('Multiple instance of CHECK_FLA parameter found. There will be no FLA Validation','I');
						}
					}
				});
			}
			
			return isValid;
		}catch(e){
			showErrorMessage("checkClaimClosing",e);
		}
	} */
	
	function checkClaimClosing(claimId){
		try{
			new Ajax.Request(contextPath + "/GICLClaimsController?action=checkClaimClosing" , {
				method: "POST",
				parameters: {
					claimId: claimId,
					prntdFla: $("prntdFLA").value == '1' ? '1' : '0',
					chkTag: 'N' //hindi tagAll
				},
				onComplete: function (response){
					hideNotice();
					var json = JSON.parse(response.responseText);
					
					if(json.param == '' || json.param == null){
						showMessageBox(json.msgAlert, imgMessage.INFO);
					}
					
					if(json.batchChkbx == 'Y'){
						objBatchClaimArray[currY].recordStatus = 1;
						objCheckBoxArray.push(objBatchClaimArray[currY]);
					}else if(json.batchChkbx == 'N'){
						batchClaimClosingTableGrid.uncheckRecStatus(currX, currY);
						if(json.tagAllow == 'Y'){
							tagAllow = true;
						}else{
							showMessageBox(json.msgAlert, imgMessage.INFO);
						}
					} 				
					
					if(json.param == 'Y'){
						validateFla(claimId);
					}

					enableDisableProcessBtn();
				}
			});
		}catch(e){
			showErrorMessage("checkClaimClosing",e);
		}
	}
	
	function validateFla(claimId){
		try{
			new Ajax.Request(contextPath + "/GICLClaimsController?action=validateFlaGICLS039" , {
				method: "POST",
				parameters: {
					claimId: claimId
				},
				onComplete: function (response){
					hideNotice();
					var json = JSON.parse(response.responseText);
					
					if($F("txtProcessTag") != "T"){
						if(json.generateAll == 'Y'){
							showConfirmBoxWithInfoIcon("INFORMATION MESSAGE",
									"Generate and print all FLAs before closing this claim.", "OK", "Cancel", 
									function() {
								        checkAccessFLA(claimId);
									}, function() {
										for (var i=0; i<objCheckBoxArray.length; i++){
											if (objCheckBoxArray[i].claimId == objBatchClaimArray[currY].claimId) {
												objCheckBoxArray.splice(i, 1);
											 }
										}
										batchClaimClosingTableGrid.uncheckRecStatus(currX, currY);
									}
							);
						}
						
						if(json.printAll == 'Y'){
							showConfirmBoxWithInfoIcon("INFORMATION MESSAGE",
									"Print all FLAs before closing this claim.", "OK", "Cancel",
									function() {
										checkAccessFLA(claimId);
									}, function() {
										for (var i=0; i<objCheckBoxArray.length; i++){
											if (objCheckBoxArray[i].claimId == objBatchClaimArray[currY].claimId) {
												objCheckBoxArray.splice(i, 1);
											 }
										}
										batchClaimClosingTableGrid.uncheckRecStatus(currX, currY);
									}
							);
						}
					}else{
						if(json.printAll != 'Y' && json.generatAll != 'Y'){
							for (var i = 0; i < objTagAllClaims.length; i++) {
								if (objTagAllClaims[i].claimId == claimId) {
									objTagAllClaims[i].recordStatus = 1;
									objCheckBoxArray.push(objTagAllClaims[i]);
								}
							}
						}
						
						for (var i=0; i<objCheckBoxArray.length; i++){
							for ( var j = 0; j < objBatchClaimArray.length; j++) {
								if (objCheckBoxArray[i].claimId == objBatchClaimArray[j].claimId) {
									$("mtgInput1_" + batchClaimClosingTableGrid.getColumnIndex("processFlag")+ ","+j).checked = true;
								}
							}
						}
					}
					enableDisableProcessBtn();
				}
			});
		}catch(e){
			showErrorMessage("validateFla",e);
		}
	}
	
	function checkAccessFLA(claimId){
		try{
			new Ajax.Request(contextPath+"/GIACAccTransController?action=checkUserAccess2", {
				method: "POST",
				parameters: {
					moduleName: "GICLS033"
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(response.responseText == 0){
						showWaitingMessageBox('You are not allowed to access this module.', imgMessage.ERROR, 
						function(){
							batchClaimClosingTableGrid.uncheckRecStatus(currX, currY);
						});  
					} else {
						objCLMGlobal.claimId = claimId;
						showGenerateFLAPageGICLS039();
					}
				}
			});
		}catch(e){
			showErrorMessage('checkAccessFLA', e);
		}
	}
	
	function closeClaims(){
		try{
			var objParameters = new Object();
			var objAlertMessagetxt;
			multiTag = "N";
			if(objCheckBoxArray.length > 1) {
				objAlertMessagetxt = "Are you sure you want to close these claims?";
				multiTag = "Y";
			} else {
				objAlertMessagetxt = "Are you sure you want to close this claim?";
			}
			
			objParameters.addModifiedUnidentifiedCollns = getAddedAndModifiedJSONObjects(objCheckBoxArray);
			
			//modified by kenneth 11.05,2015 SR 5147
			var count = 0;
			var reasonMsg;
			for(var i = 0; i < objCheckBoxArray.length; i++){
				if(objCheckBoxArray[i].reasonCode == null){
					count = count + 1;
				}
			}
			if(count >= 1 && count != objCheckBoxArray.length){
				reasonMsg = "There are no reason for some of the selected claims. Do you want to add reason?";	
			}else if(count == objCheckBoxArray.length){
				reasonMsg = "Do you want to add reason?";
			}
			
			showConfirmBox("CONFIRMATION", objAlertMessagetxt, "Yes", "No", 
					function(){
						if(count == 0){
							continueClose();
						}else{
							showConfirmBox("CONFIRMATION", reasonMsg, "Yes", "No", 
								function(){
						        	showMessageBox("Please highlight the tagged records you want to add reason to, select the reason on the reason field LOV, press Update and then press Save button." , "I");},
						        continueClose);
						}
					}, "");
			
			function continueClose(){
	        	new Ajax.Request(contextPath + "/GICLClaimsController?action=closeClaims" , {
					method: "POST",
					parameters: {
						parameter: JSON.stringify(objParameters)
					},
					onComplete: function (response){
						hideNotice();
						if(response.responseText != null){
							if(response.responseText == "SUCCESS"){
								if(multiTag != "Y") {
									showMessageBox('Claim has been closed.','S');
								} else {
									showMessageBox('Claims have been closed.','S');
								}
							}
							doProcessAfterReOpen();
						}
					}
				});
	        }
			
		}catch(e){
			showErrorMessage("closeClaims",e);
		}
	}

	function openClaims(){
		try{ 
			var objParameters = new Object();
			var objAlertMessagetxt;
			
			if(objCheckBoxArray.length > 1) {
				multiTag = "Y";
			} else {
				multiTag = "N";
			}
			
			objParameters.addModifiedUnidentifiedCollns = getAddedAndModifiedJSONObjects(objCheckBoxArray);
			
			new Ajax.Request(contextPath + "/GICLClaimsController?action=openClaims" , {
				method: "POST",
				parameters: {
					parameter: JSON.stringify(objParameters)
				},
				onCreate: function(){
					showNotice("please wait...");
				},
				onComplete: function (response){
					hideNotice();
					var json = JSON.parse(response.responseText);
					if(nvl(objCheckBoxArray[0].refreshSw, "N") == "Y"){
						if(json.chkReserve == "N"){
							objAlertMessagetxt = "Changes in the policy have been made, re-opening the claim will " + 
						    	"update claim's policy information. <br><br>Are you sure you want to re-open this claim?";
						}else{
							objAlertMessagetxt = "Changes in the policy have been made, re-opening the claim will "
					             + "update claim's policy information. Some reserve records will "
					             + "be automatically redistributed."
					             + "<br><br>Are you sure you want to re-open this claim?";
						}
					}else{
						if(json.chkReserve == "N"){
							objAlertMessagetxt = "Are you sure you want to re-open this claim?";
						}else{
							objAlertMessagetxt = "Re-opening this claim will mean automatic redistribution of reserve. "
					             + "<br><br>Are you sure you want to re-open this claim?";
						}
					}
					
					if(multiTag == "Y") {
						objAlertMessagetxt = "Claims with changes made in their policies will be updated while claims with distributed reserves will undergo redistribution."
						                   + "<br><br>Are you sure you want to re-open these claims?";
					}
					
					//showConfirmBox3("CONFIRMATION",
					showConfirmBox("CONFIRMATION",
							objAlertMessagetxt, "Yes", "No",  
							function() {
								reOpenClaims();
							}, "");
					
				}
			});
		}catch(e){
			showErrorMessage("openClaims",e);
		}	
	}
	
	function reOpenClaims(){
		try{
			var objParameters = new Object();
			
			objParameters.addModifiedUnidentifiedCollns = getAddedAndModifiedJSONObjects(objCheckBoxArray);
			
			new Ajax.Request(contextPath + "/GICLClaimsController?action=reOpenClaims" , {
				method: "POST",
				parameters: {
					parameter: JSON.stringify(objParameters)
				},
				onCreate: function(){
					showNotice("please wait...");
				},
				onComplete: function (response){
					hideNotice();
					if(response.responseText == "SUCCESS"){
						if(multiTag != "Y") {
							showMessageBox('Claim has been re-opened.','S');
						} else {
							showMessageBox('Claims have been re-opened.','S');
						}
					}
					doProcessAfterReOpen();
				}
			});
		}catch(e){
			showErrorMessage("reOpenClaims",e);
		}
	}
	
	function doProcessAfterReOpen(){
		enableDisableProcessBtn();
		uncheckObjBatchClaimArray();
		batchClaimClosingTableGrid.refresh();
		objCheckBoxArray = [];
	}
		
	function updateClaimRemarks(){
		try{
			var newObj = new Object();
			var sysdate = dateFormat(new Date(), 'mm-dd-yyyy hh:MM:ss TT');
			
			newObj.claimId 			 = $F("txtClaimId");
			newObj.claimNumber 		 = $F("txtClaimNo");
			newObj.policyNo 		 = $F("txtPolicyNo");
			newObj.assuredName 		 = $F("txtAssdName");
			newObj.strLossDate 		 = $F("txtLossDate");
			newObj.strClaimFileDate2 = $F("txtFileDate");
			newObj.strCloseDate 	 = $F("txtCloseDate");
			newObj.strEntryDate 	 = $F("txtSysEntryDate");
			newObj.strUserLastUpdate = sysdate;
			newObj.inHouseAdjustment = $F("txtProcessor");
			newObj.userId			 = userId;
			newObj.remarks			 = escapeHTML2($F("txtRemarks"));
			newObj.claimStatusCd	 = $F("txtClaimStatCd");
			newObj.claimStatDesc	 = $F("txtClaimStatDesc");
			newObj.reasonCode 		 = $F("txtReasonCd");	//kenneth 11.05,2015 SR 5147
			
			for(var i=0; i<objBatchClaimArray.length; i++){
				if(( objBatchClaimArray[i].recordStatus != -1) &&(objBatchClaimArray[i].claimId == newObj.claimId)){
					newObj.recordStatus = 1;
					objBatchClaimArray.splice(i, 1, newObj);
					batchClaimClosingTableGrid.updateVisibleRowOnly(newObj, batchClaimClosingTableGrid.getCurrentPosition()[1]);
				}
			}
			changeTag = 1;
			changeTagFunc = saveBatchClaimClosing;
			populateClaimClosing(null);
			statusControl = $("txtStatusControl").value;
		}catch(e){
			showErrorMessage("updateClaimRemarks", e);
		}
	}
	
	function saveBatchClaimClosing(){
		try{
			var objParameters = new Object();
			
			objParameters.addModifiedClaims = getAddedAndModifiedJSONObjects(objBatchClaimArray);
			
			new Ajax.Request(contextPath + "/GICLClaimsController?action=saveBatchClaimClosing" , {
				method: "POST",
				parameters: {
					parameter: JSON.stringify(objParameters)
				},
				onCreate: function(){
					showNotice("Saving information, please wait...");
				},
				onComplete: function (response){
					hideNotice();
					if(nvl(response.responseText, "Saving successful.") == "Saving successful."){
						//showMessageBox(response.responseText, imgMessage.SUCCESS);
						changeTagFunc = "";
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							if(objBatchClaimClosing.exitPage != null) {
								objBatchClaimClosing.exitPage();
							} else {
								populateClaimClosing(null);
								batchClaimClosingTableGrid.refresh();
							}
							uncheckObjBatchClaimArray();	//kenneth 11.05,2015 SR 5147
						});
						changeTag = 0;
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}catch(e){
			showErrorMessage("saveBatchClaimClosing", e);
		}
	}
	/* VALIDATIONS */
	
	//Check if user is allowed to Open, Close, Withdraw, Deny or Cancel claim.
	function checkUserFunction(type){
		//type: 1 = Radio Button; 2 = Checkbox;
		var isValid = true;
		new Ajax.Request(contextPath+"/GICLClaimsController?action=checkUserFunction", {
			method: "POST",
			parameters: {
				functionCd: $F("txtFunctionCd")
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				var json = JSON.parse(response.responseText);
				//check if module exists in giac_modules
				if(json.moduleId == null){
					showWaitingMessageBox("Cannot validate if user is allowed to perform such action. " +
							"This module (GICLS039) has not been set-up in giac_modules table. " +
							"Please contact your DBA.", "E",
					function(){
						if(type=="1"){
							$("txtProcessTag").value = "S";
							//$("optSelectedClaims").checked = true;
							uncheckObjBatchClaimArray();
							enableDisableProcessBtn();
						}else if(type=="2"){
							batchClaimClosingTableGrid.uncheckRecStatus(currX, currY);
						}
					});
					isValid = false;
				}else{
					//check if function exists in giac_functions
					 if (json.functionExist == 'N'){
						 showWaitingMessageBox("Cannot continue to perform action. " +
				                  "The function to " + $F("txtFunctionDesc").toLowerCase() + "s has not been set-up in GIAC_FUNCTIONS table. " +
				                  "Please contact your system administrator.", "E",
							function(){
								if(type=="1"){
									$("txtProcessTag").value = "S";
									//$("optSelectedClaims").checked = true;
									uncheckObjBatchClaimArray();
									enableDisableProcessBtn();
								}else if(type=="2"){
									batchClaimClosingTableGrid.uncheckRecStatus(currX, currY);
								}
						 });
						 isValid = false;
					 }else{
						 //check if user is allowed to perform function
						 if (nvl(json.userValid, 'N') == 'N'){
							 showWaitingMessageBox("User is not allowed to " + nvl(json.functionName, $F("txtFunctionDesc")).toLowerCase() + "s.", "I",
								function(){
									if(type=="1"){
										$("txtProcessTag").value = "S";
										//$("optSelectedClaims").checked = true;
										uncheckObjBatchClaimArray();
										enableDisableProcessBtn();
									}else if(type=="2"){
										batchClaimClosingTableGrid.uncheckRecStatus(currX, currY);
									}
							 });
							 isValid = false; 
						 }
					 }
				}
			}
		});
		return isValid;
	}
	
	/* OBSERVE EVENTS */
	
	//CONTROL STATUS
 	$$("input[name='statusControl']").each(function(row) {
		$(row.id).observe("click", function() {
			if(row.checked == true) {
				batchClaimClosingTableGrid.keys.releaseKeys();
				if (changeTag == 1) {
					showConfirmBox4("CONFIRMATION",	objCommonMessage.WITH_CHANGES, "Yes", "No",	"Cancel", 
							function() {
						        saveBatchClaimClosing();
								$("txtStatusControl").value = row.value;
								showBatchClaimClosing(row.value);
								objCheckBoxArray = [];
								changeTag = 0;
								$(row.id).checked = true;
							},
							function() {
								$("txtStatusControl").value = row.value;
								showBatchClaimClosing(row.value);
								objCheckBoxArray = [];
								changeTag = 0;
								$(row.id).checked = true;
							}, setStatusControl);
				}else{
					$("txtStatusControl").value = row.value;
					setStatusControl();
					
					if(objGICLS039.clmLineCd != "" || objGICLS039.clmSublineCd != "" 
							|| objGICLS039.clmIssCd != "" || objGICLS039.clmYy != "" 
							|| objGICLS039.clmSeqNo != "" || objGICLS039.polIssCd != ""
							|| objGICLS039.polIssueYy != "" || objGICLS039.polSeqNo != ""
							|| objGICLS039.polRenewNo != "" || objGICLS039.assdNo != ""
							|| objGICLS039.remarks != "" //benjo 08.05.2015 UCPBGEN-SR-19632
							|| objGICLS039.searchBy != "" || objGICLS039.asOfDate != ""
							|| objGICLS039.fromDate != "" || objGICLS039.toDate != ""){
						batchClaimClosingTableGrid.url  = contextPath+"/GICLClaimsController?action=refreshClaimClosingList&userId="+userId+"&statusControl="+$F("txtStatusControl")
															+"&clmLineCd="+objGICLS039.clmLineCd+"&clmSublineCd="+objGICLS039.clmSublineCd+"&clmIssCd="+objGICLS039.clmIssCd+"&clmYy="+objGICLS039.clmYy
															+"&clmSeqNo="+objGICLS039.clmSeqNo+"&polIssCd="+objGICLS039.polIssCd+"&polIssueYy="+objGICLS039.polIssueYy+"&polSeqNo="+objGICLS039.polSeqNo
															+"&polRenewNo="+objGICLS039.polRenewNo+"&assdNo="+objGICLS039.assdNo+"&searchBy="+objGICLS039.searchBy+"&asOfDate="+objGICLS039.asOfDate
															+"&fromDate="+objGICLS039.fromDate+"&toDate="+objGICLS039.toDate+"&remarks="+encodeURIComponent(objGICLS039.remarks); //benjo 08.05.2015 UCPBGEN-SR-19632 added remarks
					}					
					
					batchClaimClosingTableGrid._refreshList();
					
					objCheckBoxArray = [];
					changeTag = 0;
					$(row.id).checked = true;
				}
			}
		});
	}); 
	
	//WHEN_RADIO_CHANGED
 	$$("input[name='processTag']").each(function(row) {
		$(row.id).observe("click", function() {
			batchClaimClosingTableGrid.keys.releaseKeys();
			if(row.id == "optUntagAll") {
				$("txtProcessTag").value = row.value;
				uncheckObjBatchClaimArray();
			}else if(row.id == "optTagAll") {
				checkUserFunction("1");
				$("txtProcessTag").value = row.value;
				uncheckObjBatchClaimArray();
				var notValid = false; 
				if ($F("txtStatusControl") == "1"){ 		//OPEN
					for (var i=0; i<objTagAllClaims.length; i++){
						if(objTagAllClaims[i].polFlag == "4" || objTagAllClaims[i].polFlag == "5"){  //checkClaimToOpen
							notValid = true;
						}else{
							objTagAllClaims[i].recordStatus = 1;
							objCheckBoxArray.push(objTagAllClaims[i]);
						}
					}
				}else if ($F("txtStatusControl") == "2"){   //CLOSE
					for (var i=0; i<objTagAllClaims.length; i++){
						if(objTagAllClaims[i].paytSw == "N" || (objTagAllClaims[i].adviceExist == "Y" && objTagAllClaims[i].chkPayment == "Y")){  //checkClaimClosing
							notValid = true;
						}else{
							validateFla(objTagAllClaims[i].claimId);
							//objTagAllClaims[i].recordStatus = 1;
							//objCheckBoxArray.push(objTagAllClaims[i]);
						}
						//checkClaimClosing(objTagAllClaims[i].claimdId)
					}
				}else{										//DENY, WITHDRAW, CANCEL
					for (var i=0; i<objTagAllClaims.length; i++){
						if(objTagAllClaims[i].clmSetld == "N" || objTagAllClaims[i].adviceExist == "Y"){ //checkClaimDenyWithCancel
							notValid = true;
						}else{
							objTagAllClaims[i].recordStatus = 1;
							objCheckBoxArray.push(objTagAllClaims[i]);
						}
					}
				}
				
				for (var i=0; i<objCheckBoxArray.length; i++){
					for ( var j = 0; j < objBatchClaimArray.length; j++) {
						if (objCheckBoxArray[i].claimId == objBatchClaimArray[j].claimId) {
							$("mtgInput1_" + batchClaimClosingTableGrid.getColumnIndex("processFlag")+ ","+j).checked = true;
						}
					}
				}
				
				var stat = ['', 'opened', 'closed', 'denied', 'withdrawn', 'cancelled'];
				
				if(notValid){
					if ($F("txtStatusControl") == "1"){ 
						showMessageBox('Some claim(s) cannot be opened. There are policy(ies) that is(are) spoiled or cancelled','I');
					}else{
						showMessageBox('Some claim(s) cannot be ' + stat[$F("txtStatusControl")] + '. Settlement Payment(s) has(have) not ' + 
	   							'yet been made or Advice without payment exists.','I');						
					}
				}	   	
			}else{
				$("txtProcessTag").value = row.value;
			}
				
			if (row.id == "optTagAll" && $F("txtStatusControl") == "2"){
				$("prntdFLA").disabled = false;
				$("prntdFLA").checked = true;
			}else{
				$("prntdFLA").disabled = true;
			}
			enableDisableProcessBtn();
		});
	});
	
 	/* $("prntdFLA").observe("click", function() {
		uncheckObjBatchClaimArray();

		for (var i=0; i<objTagAllClaims.length; i++){
			if(objTagAllClaims[i].paytSw == "N" || (objTagAllClaims[i].adviceExist == "Y" && objTagAllClaims[i].chkPayment == "Y")){  //checkClaimClosing
				notValid = true;
			}else{
				if (this.checked == false){
					objTagAllClaims[i].recordStatus = 1;
					objCheckBoxArray.push(objTagAllClaims[i]);
				}else{
					validateFla(objTagAllClaims[i].claimId);
				}
			}
		}
 		
 		for (var i=0; i<objCheckBoxArray.length; i++){
			for ( var j = 0; j < objBatchClaimArray.length; j++) {
				if (objCheckBoxArray[i].claimId == objBatchClaimArray[j].claimId) {
					$("mtgInput1_" + batchClaimClosingTableGrid.getColumnIndex("processFlag")+ ","+j).checked = true;
				}
			}
		}
 		
 		if(notValid){
			showMessageBox('Some claim(s) cannot be closed. Settlement Payment(s) has(have) not ' + 
						'yet been made or Advice without payment exists.','I');						
		}	 
	}); */
 	
	$("editTxtRemarks").observe("click", function() {
		batchClaimClosingTableGrid.keys.releaseKeys();
		//showEditor("txtRemarks", 4000);
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("btnProcess").observe("click", function(){
		if ($F("txtStatusControl") == "1"){ 
			openClaims();
		}else if ($F("txtStatusControl") == "2"){ 
			closeClaims();
		}else if ($F("txtStatusControl") == "3"){ 
			denyWithdrawCancelClaims("DN");
		}else if ($F("txtStatusControl") == "4"){ 
			denyWithdrawCancelClaims("WD");
		}else if ($F("txtStatusControl") == "5"){ 
			denyWithdrawCancelClaims("CC");
		}	
	});
	
	$("btnUpdate").observe("click", function(){
		updateClaimRemarks();		
	});
	
	function exitPage(){
		objGicls039.validateStatusTag = 'N';
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
	}
	
	$("btnExit").observe("click", function(){
		if (changeTag == 1) {
			showConfirmBox4("CONFIRMATION",
					objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function() {
				        objBatchClaimClosing.exitPage = exitPage;
						saveBatchClaimClosing();
					}, 
					exitPage, 
					"");
		} else {
			exitPage();
		}
	});
	
	var multiTag = "N";
	
	$("btnUntagAll").observe("click", function(){
		uncheckObjBatchClaimArray();
	});
	
	validateGiacParameterStatus();
	
	function validateGiacParameterStatus(){
		if(objGicls039.validateStatusTag == 'N'){
			new Ajax.Request(contextPath + "/GICLClaimsController", {
				parameters : {
			    	action : "validateGiacParameterStatus"
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						
					}
				}
			});
			
			objGicls039.validateStatusTag = 'Y';	
		}
	}
	
    observeReloadForm("reloadForm", function(){
    	objGicls039.validateStatusTag = 'N';
    	showBatchClaimClosing();
    });
	observeSaveForm("btnSave", saveBatchClaimClosing);
	
	populateClaimClosing(null);
	
	function showQueryOverlay(){
		try{
			overlayQueryClaims = Overlay.show(contextPath+"/GICLClaimsController",{
				urlContent: true,
				urlParameters: {action : "showQueryClaimsPage"},
			    title: "Query Claims",
			    height: /*280*/310, //benjo 08.05.2015 UCPBGEN-SR-19632
			    width: 470,
			    draggable: true
			});
		}catch(e){
			showErrorMessage("showQueryOverlay", e);
		}		
	}
	
	objGICLS039 = {};
	objGICLS039.clmLineCd = "";
	objGICLS039.clmSublineCd = "";
	objGICLS039.clmIssCd = "";
	objGICLS039.clmYy = "";
	objGICLS039.clmSeqNo = "";	
	objGICLS039.polLineCd = "";
	objGICLS039.polSublineCd = "";
	objGICLS039.polIssCd = "";
	objGICLS039.polIssueYy = "";
	objGICLS039.polSeqNo = "";
	objGICLS039.polRenewNo = "";	
	objGICLS039.assdNo = "";
	objGICLS039.assuredName = "";
	objGICLS039.remarks = ""; //benjo 08.05.2015 UCPBGEN-SR-19632
	objGICLS039.searchBy = "";
	objGICLS039.asOfDate = "";
	objGICLS039.fromDate = "";
	objGICLS039.toDate = "";
	
	$("btnQuery").observe("click", function () {
		if(changeTag == 1){
			showMessageBox("Please save changes first before pressing the QUERY button.","I");
		}else{
			if(batchClaimClosingTableGrid.keys){
				batchClaimClosingTableGrid.keys.removeFocus(batchClaimClosingTableGrid.keys._nCurrentFocus, true);
				batchClaimClosingTableGrid.keys.releaseKeys();
			}
			showQueryOverlay();
		}
	});
	
	fireEvent($("btnQuery"), "click");
</script>