<div id="dvStatusMainDiv" name="dvStatusMainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>View DV Status</label>
	   	</div>
	</div>	
	<div class="sectionDiv">
		<table style="margin: 15px auto;">
			<tr>		
				<td class="rightAligned">
					<label for="txtFundDesc">Company</label>
				</td>
				<td class="leftAligned">
					<span class="lovSpan required" style="width: 300px; margin-right: 60px;">
						<input type="text" id="txtFundDesc" name="txtFundDesc" class="required allCaps" style="width: 275px; float: left; border: none; height: 14px; margin: 0;" tabindex="100"/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchFund" alt="Go" style="float: right;"/>
					</span>
				</td>
				<td></td>
				<td class="rightAligned">
					<label for="txtBranchName">Branch</label>
				</td>
				<td class="leftAligned">
					<span class="lovSpan required" style="width: 240px;">
						<input type="text" id="txtBranchName" name="txtBranchName" class="required allCaps" style="width: 215px; float: left; border: none; height: 14px; margin: 0;" tabindex="101"/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchBranch" name="imgSearchBranch" alt="Go" style="float: right;"/>
					</span>
				</td>
			</tr>
		</table>		
	</div>
	<div class="sectionDiv" style="margin-bottom: 50px;">
		<div id="dvStatusTableDiv" style="float: left; padding: 10px 0 0 10px; width: 728px; margin: 0px;">
			<div id="dvStatusTable" style="height: 275px;"></div>
		</div>	
		<div style="float: right;  height: 290px; padding: 0px;">
			<table style="margin: 32px 8px 0 8px; padding: 0px" align="center">
				<tr>
					<td>Status</td>
				</tr>
				<tr>
					<td style="padding-top: 10px;">
						<table class="sectionDiv" style="padding-top:10px; padding-bottom:10px; width: 160px;">	
							<tr height="25px">
								<td><input type="radio" id="rdoAll" name="status" checked="checked" tabindex="200"></td>
								<td align="left"><label for="rdoAll">All</label></td>
							</tr>
							<tr height="25px">
								<td><input type="radio" id="rdoNew" name="status" tabindex="201"></td>
								<td align="left"><label for="rdoNew">New</label></td>
							</tr>
							<tr height="25px">
								<td><input type="radio" id="rdoApproved" name="status" tabindex="202"></td>
								<td align="left"><label for="rdoApproved" >Approved for Printing</label></td>
							</tr>
							<tr height="25px">
								<td><input type="radio" id="rdoPrinted" name="status" tabindex="203"></td>
								<td align="left"><label for="rdoPrinted" >Printed</label></td>
							</tr>
							<tr height="25px">
								<td><input type="radio" id="rdoCancelled" name="status" tabindex="204"></td>
								<td align="left"><label for="rdoCancelled" >Cancelled</label></td>
							</tr>
						</table>
					</td>
				</tr>		
			</table>
		</div>	
		<div class="sectionDiv" align="center" style="float: left; clear: both; margin-left: 10px; width: 900px; height: 105px; margin-top: 10px; padding: 0px;">
			<table  style="margin: 5px 5px 5px 5px;">
				<tr>
					<td class="rightAligned">Payee</td>
					<td class="leftAligned" colspan="3" style="width: 510px;"><input type="text" id="txtPayee" name="txtPayee" style="width: 510px" readonly="readonly" tabindex="300"/></td>	
				</tr>
				<tr>
					<td class="rightAligned">Particulars</td>
					<td class="leftAligned" colspan="3" style="width: 510px;">
						<div class="withIconDiv" style="float: left; width: 516px">
							<textarea type="text" id="txtParticulars" class="withIcon" style="width: 490px; resize:none;" readonly="readonly" name="txtParticulars" onkeyup="limitText(this,4000);" onkeydown="limitText(this,4000);" tabindex="301" /></textarea>
							<img id="editTxtParticulars" alt="edit" style="width: 14px; height: 14px; margin: 3px; float: right;" src="/Geniisys/images/misc/edit.png">
						</div>
					</td>	
				</tr>
				<tr>
					<td class="rightAligned">User ID</td>
					<td class="leftAligned"><input type="text" id="txtUserId" name="txtUserId" style="width: 195px;" readonly="readonly" tabindex="302"/></td>
					<td class="rightAligned">Last Update</td>
					<td class="leftAligned" style="width: 195px;"><input type="text" id="txtLastUpdate" name="txtLastUpdate" style="width: 184px;" readonly="readonly" tabindex="303"/></td>
				</tr>
			</table>
		</div >
		<div style="float: left; clear: both; width: 100%; margin: 10px; width: 900px;" align="center">
			<input type="button" class="disabledButton" id="btnHistory" name="history" value="History" style="width: 100px;" tabindex="400"/>
		</div>
</div>
<script type="text/javascript">
	/* Modified by : Joms Diago
	** Date Modified : 051162013
	** Description : To call giacs002 on Table Grid row double click.
	*/
	var onLOV = false;
	
	/* Joms Diago 05162013 */
	objACGlobal.previousModule = "GIACS237";
	objACGlobal.callingForm = "GIACS237";	
	objACGlobal.fromDvStatInq = 'Y'; //added by robert;
	function initGIACS237(){
		setModuleId("GIACS237");
		setDocumentTitle("View DV Status");
		try {//added by steven 10.09.2014
			if (nvl(objGIACS237.fundCd,null) == null && nvl(objGIACS237.branchCd,null) == null){
				objGIACS237 = new Object();
			}
		} catch (e){
		    if (e instanceof ReferenceError || e instanceof TypeError){
		    	objGIACS237 = new Object();
		    } 
		}
		
		if(objAC.fromMenu == 'Y'){
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");	
		} else {
			enableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
			
			if(objGlobalGIACS237.dvFlag != null){
				if(objGlobalGIACS237.dvFlag == "N")
					$("rdoNew").checked = true;
				else if(objGlobalGIACS237.dvFlag == "A")
					$("rdoApproved").checked = true;
				else if(objGlobalGIACS237.dvFlag == "P")
					$("rdoPrinted").checked = true;
				else if(objGlobalGIACS237.dvFlag == "C")
					$("rdoCancelled").checked = true;
				else
					$("rdoAll").checked = true;
			}	
		}
		
		onLOV = false;
		$("txtFundDesc").focus();
		$("btnToolbarPrint").hide();		
	}
	
	var jsonDVStatus = JSON.parse('${jsonDVStatus}');
	dvStatusTableModel = {
			url : contextPath+"/GIACInquiryController?action=showDVStatus&refresh=1"
            + "&fundCd=" + objGlobalGIACS237.fundCd
            + "&branchCd=" + objGlobalGIACS237.branchCd
            + "&dvFlag="+objGlobalGIACS237.dvFlag,
			options: {
				hideColumnChildTitle : true,
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
				},
				width: '728px',
				height: '250px',
				onCellFocus : function(element, value, x, y, id) {
 					tbgAccDVStatus.keys.removeFocus(tbgAccDVStatus.keys._nCurrentFocus, true);
 					tbgAccDVStatus.keys.releaseKeys();
 					setDetails(tbgAccDVStatus.geniisysRows[y]);
				},
				onRemoveRowFocus : function(element, value, x, y, id){	
 					setDetails(null);
 					tbgAccDVStatus.keys.removeFocus(tbgAccDVStatus.keys._nCurrentFocus, true);
 					tbgAccDVStatus.keys.releaseKeys();
				}, 
				onRowDoubleClick: function(y){
					setDetails(tbgAccDVStatus.geniisysRows[y]);
					onTGRowDoubleClick(y);
				}
			},									
			columnModel : [
				{
				    id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false
				},
				{
					id: 'divCtrId',
					width: '0',
					visible: false 
				},
				{
					id : 'dvDate',
					title : 'DV Date',
					width : '90px',
					titleAlign : 'center',
					align : 'center',
					filterOption : true,
					renderer: function(value){
						return dateFormat(value, "mm-dd-yyyy");
					},
					filterOptionType : 'formattedDate'
				},
				{
					id : 'dvPref dvNo',
					title : 'DV Number',
					children : [
						{
							id : 'dvPref',
							title : 'DV Pref',
							filterOption : true,
							width : 50
						},
						{
							id : 'dvNo',
							title : 'DV Number',
							filterOption : true,
							width : 60,
							align : 'right',
							titleAlign : 'right'
						}
					]
				},
				/* {
					id : 'dvNo',
					title : 'DV No.',
					width : '100px',
					filterOption : true				
				}, */
				{
					id : "chkDate",
					title : "Check Date",
					width : '90px',
					titleAlign : 'center',
					align : 'center',
					type : 'date',
					format: 'mm-dd-yyyy',
					/*  removed by Joms Diago 05152013, replaced with type and format option to avoid setting check date to sysdate in case it's null
						renderer: function(value){
							return dateFormat(value, "mm-dd-yyyy");
						}, 
					*/ 
					filterOption: true,
					filterOptionType : 'formattedDate'
				},
				{
					id : "reqNo",
					title : "Request No.",
					width : '153px',
					titleAlign : 'left',
					align : 'left',
					filterOption : true
				},
				{
					id : 'checkPrefSuf checkNo',
					title : 'Check Number',
					//width : '200px',
					children : [
						{
							id : 'checkPrefSuf',
							title : 'Check Pref Suf',
							filterOption : true,
							width : 60
						},
						{
							id : 'checkNo',
							title : 'Check No',
							filterOption : true,
							width : 60,
							align : 'right',
							titleAlign : 'right'
						}
					]
				},
				/* {
					id : "chkNo",
					title : "Check No.",
					width : '103px',
					filterOption : true
				}, */
				{
					id : "status",
					title : "Status",
					width : '125px',
					filterOption : true
				},
				{
					id : "lastUpdate", // bonok :: 2.1.2016 :: UCPB SR 21526
					title : "Last Update",
					width : '125px',
					filterOption: true,
					filterOptionType : 'formattedDate'
				}
			],
			rows: jsonDVStatus.rows
		};
	
	tbgAccDVStatus = new MyTableGrid(dvStatusTableModel);
	tbgAccDVStatus.pager = jsonDVStatus;
	tbgAccDVStatus.render('dvStatusTable'); 
	tbgAccDVStatus.afterRender = function(){
		setDetails(null);
		if(tbgAccDVStatus.geniisysRows.length > 0){
			//enableToolbarButton("btnToolbarPrint");
		} else{
			$("txtPayee").clear();
			$("txtParticulars").clear();
			$("txtUserId").clear();
			$("txtLastUpdate").clear();	
		}
	};
	
	
	function setDetails(rec) {
		if(rec != null){
			$("txtPayee").value = unescapeHTML2(rec.payee);
			$("txtParticulars").value = unescapeHTML2(rec.particulars);
			$("txtUserId").value = unescapeHTML2(rec.userId);
			$("txtLastUpdate").value = dateFormat(rec.lastUpdate, 'mm-dd-yyyy hh:MM:ss TT'); // bonok :: 2.3.2016 :: SR 21526 :: modified time format from HH:MM:ss TT to hh:MM:ss TT
			objGIACS237.gaccTranId = rec.gaccTranId;
			enableButton("btnHistory");
		} else {
			$("txtPayee").clear();
			$("txtParticulars").clear();
			$("txtUserId").clear();
			$("txtLastUpdate").clear();
			objGIACS237.gaccTranId = null;
			disableButton("btnHistory");
		}
	}
	
	function showStatusHistory() {
		try {
		overlayStatusHistory = 
			Overlay.show(contextPath+"/GIACInquiryController", {
				urlContent: true,
				urlParameters: {action : "showGIAC237StatusHistory",																
								ajax : "1",
								gaccTranId : objGIACS237.gaccTranId
				},
			    title: "Status History",
			    height: 250,
			    width: 500,
			    draggable: true
			});
		} catch (e) {
			showErrorMessage("overlay error: " , e);
		}
	}
	
	$("btnHistory").observe("click", showStatusHistory);

	function showFundLOV(){
		onLOV = true;
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {
				action : "getGIACS237FundLOV",
				searchString : $("txtFundDesc").value,
				page : 1,
				controlModule : "GIACS237"
			},
			title : "Valid Values for Company",
			width : 480,
			height : 386,
			columnModel : [ {
				id : "fundCd",
				title : "Code",
				width : '120px',
			}, {
				id : "fundDesc",
				title : "Description",
				width : '345px',
				renderer: function(value) {
					return unescapeHTML2(value);
				}
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			filterText:  $("txtFundDesc").value,
			onSelect : function(row) {
				$("txtFundDesc").value = unescapeHTML2(row.fundDesc);
				objGIACS237.fundCd = row.fundCd;
				$("txtBranchName").focus();
				onLOV = false;
				enableToolbarButton("btnToolbarEnterQuery");
			},
			onCancel : function () {
				$("txtFundDesc").focus();
				onLOV = false;
			},
			onUndefinedRow : function(){
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtFundDesc");
				onLOV = false;
			}
		});
	}
	
	function showBranchLOV(){
		onLOV = true;
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {
				action : "getGIACS237BranchLOV",
				searchString : $("txtBranchName").value,
				fundCd : objGIACS237.fundCd,
				page : 1,
				controlModule : "GIACS237"
			},
			title : "Valid Values for Branch",
			width : 480,
			height : 386,
			columnModel : [ {
				id : "branchCd",
				title : "Code",
				width : '120px',
			}, {
				id : "branchName",
				title : "Description",
				width : '345px',
				renderer: function(value) {
					return unescapeHTML2(value);
				}
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			filterText:  $("txtBranchName").value,
			onSelect : function(row) {
				$("txtBranchName").value = unescapeHTML2(row.branchName);
				objGIACS237.branchCd = row.branchCd; 
				onLOV = false;
				enableToolbarButton("btnToolbarEnterQuery");
				enableToolbarButton("btnToolbarExecuteQuery");
			},
			onCancel : function () {
				$("txtBranchName").focus();
				onLOV = false;
			},
			onUndefinedRow : function(){
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtBranchName");
				onLOV = false;
			}
		});
	}	
	
	function executeQuery(){
		var dvFlag = getDVFlagValue();
		$("txtFundDesc").readOnly = true;
		$("txtBranchName").readOnly = true;
		disableSearch("imgSearchFund");
		disableSearch("imgSearchBranch");
		disableToolbarButton("btnToolbarExecuteQuery");
		
		objGlobalGIACS237.dvStatusURL = "&fundCd=" + objGIACS237.fundCd + "&branchCd=" + objGIACS237.branchCd + "&dvFlag=" + dvFlag;
		objGlobalGIACS237.fieldVals.push({
			fundCd : $F("txtFundDesc"),
			branchCd : $F("txtBranchName"),
		});
		objGlobalGIACS237.fundCd = objGIACS237.fundCd;
		objGlobalGIACS237.branchCd = objGIACS237.branchCd;
		objGlobalGIACS237.dvFlag = dvFlag;
		
		tbgAccDVStatus.url = contextPath+"/GIACInquiryController?action=showDVStatus&refresh=1"
				            + "&fundCd=" + objGIACS237.fundCd
				            + "&branchCd=" + objGIACS237.branchCd
				            + "&dvFlag=" + dvFlag;
		tbgAccDVStatus._refreshList();
	}
	
	/* Joms 05162013 */
	function onTGRowDoubleClick(y){
		objACGlobal.gaccTranId = objGIACS237.gaccTranId;
		tbgAccDVStatus.keys.releaseKeys();
		showDisbursementVoucherPage("N", "getDisbVoucherInfo", "Y");
	}
	
	function resetForm(){
		setDetails(null);
		objGIACS237.fundCd = null;
		objGIACS237.branchCd = null;
		objGIACS237.gaccTranId = null;
		$("txtFundDesc").clear();
		$("txtBranchName").clear();
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		$("txtFundDesc").focus();
		$("txtFundDesc").readOnly = false;
		$("txtBranchName").readOnly = false;
		tbgAccDVStatus.url = contextPath+"/GIACInquiryController?action=showDVStatus&refresh=1";
		tbgAccDVStatus._refreshList();
		enableSearch("imgSearchFund");
		enableSearch("imgSearchBranch");
		$("rdoAll").checked = true;
	};
	
	function getDVFlagValue(){
		if($("rdoAll").checked)
			return ' ';
		else if($("rdoNew").checked)
			return 'N';
		else if($("rdoApproved").checked)
			return 'A';
		else if($("rdoPrinted").checked)
			return 'P';
		else if($("rdoCancelled").checked)
			return 'C';
		else
			return ' ';
	}
	
	function changeStatusFlag(){
		if($("txtFundDesc").readOnly){
			if(objAC.fromMenu == 'N'){
				tbgAccDVStatus.url = contextPath+"/GIACInquiryController?action=showDVStatus&refresh=1"
	            + "&fundCd=" + objGlobalGIACS237.fundCd
	            + "&branchCd=" + objGlobalGIACS237.branchCd
	            + "&dvFlag=" + getDVFlagValue();
			    tbgAccDVStatus._refreshList();
			} else {
				tbgAccDVStatus.url = contextPath+"/GIACInquiryController?action=showDVStatus&refresh=1"
	            + "&fundCd=" + objGIACS237.fundCd
	            + "&branchCd=" + objGIACS237.branchCd
	            + "&dvFlag=" + getDVFlagValue();
			    tbgAccDVStatus._refreshList();
			}
			var dvFlag = getDVFlagValue();
			objGlobalGIACS237.dvStatusURL = "&fundCd=" + objGIACS237.fundCd + "&branchCd=" + objGIACS237.branchCd + "&dvFlag=" + dvFlag;
			objGlobalGIACS237.dvFlag = dvFlag;
		}
	}
	
	$("rdoAll").observe("click", changeStatusFlag);
	$("rdoNew").observe("click", changeStatusFlag);
	$("rdoApproved").observe("click", changeStatusFlag);
	$("rdoPrinted").observe("click", changeStatusFlag);
	$("rdoCancelled").observe("click", changeStatusFlag);
	$("btnToolbarEnterQuery").observe("click", resetForm);
	
	$("imgSearchFund").observe("click", function(){
		if(onLOV || objGIACS237.fundCd != null)
			return;
		else
		showFundLOV();
	});
	
	$("txtFundDesc").observe("keypress", function(event){
		
		if(this.readOnly)
			return;
		
		if(event.keyCode == Event.KEY_RETURN){
			if(onLOV || objGIACS237.fundCd != null || $("txtFundDesc").readOnly == true)
				return;
			else
			showFundLOV();
		} else if(event.keyCode == 0 || event.keyCode == 8){
			objGIACS237.fundCd = null;
			objGIACS237.branchCd = null;
			enableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
			if(!$("txtFundDesc").readOnly)
				$("txtBranchName").clear();
		}
	});
	
	$("imgSearchBranch").observe("click", function(){
		if(onLOV || objGIACS237.branchCd != null)
			return;
		else
			showBranchLOV();
	});
	
	$("txtBranchName").observe("keypress", function(event){
		
		if(this.readOnly)
			return;
		
		if(event.keyCode == Event.KEY_RETURN){
			if(onLOV || objGIACS237.branchCd != null || $("txtBranchName").readOnly == true)
				return;
			else
				showBranchLOV();
		} else if(event.keyCode == 0 || event.keyCode == 8){
			objGIACS237.branchCd = null;
			enableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		}
	});
	
	$("btnToolbarExecuteQuery").observe("click", function() {
		if ($("txtFundDesc").value != "" && $("txtBranchName").value != "") {
			executeQuery();
		}
	}); 
	
	$("btnToolbarExit").observe("click", function() {
		objGlobalGIACS237.fundCd = null;
		objGlobalGIACS237.branchCd = null;
		objGlobalGIACS237.dvFlag = null;
		objGIACS237 = null;
		objACGlobal.previousModule = null;
		objACGlobal.callingForm = null;
		objACGlobal.fromDvStatInq = 'N'; //added by robert 11.27.2013
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
		
	});
	
	$("editTxtParticulars").observe("click", function() {
		showOverlayEditor("txtParticulars", 4000, $("txtParticulars").hasAttribute("readonly"));
	});

	$("acExit").stopObserving("click");
	$("acExit").observe("click", function(){
		objGIACS237 = null;
		objACGlobal.previousModule = null;
		objACGlobal.callingForm = null;
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
	});
	
	initializeAll();
	initGIACS237();
	$("mainNav").hide();
</script>