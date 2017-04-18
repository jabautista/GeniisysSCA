<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>
<div id="paymentRequestStatusMainDiv" name="paymentRequestStatusMainDiv">
<!--  		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="paymentRequestStatusExit">Exit</a></li>
				</ul>
			</div>
		</div> -->
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>		
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
		   	<label>Payment Request Status</label>
		 </div>
	</div>
	<div id="paymentRequestStatusDetailDiv">
		<div class="sectionDiv">
			<table style="margin: 10px auto;">
				<tr>		
					<td class="rightAligned">Company</td>
					<td class="leftAligned">
						<span class="lovSpan required" style="width: 300px; margin-right: 60px;">
							<input type="text" id="txtFundDesc" name="txtFundDesc" style="width: 275px; float: left; border: none; height: 14px; margin: 0;" class="required"/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchFund" name="imgSearchFund" alt="Go" style="float: right;"/>
						</span>
					</td>
					<td></td>
					<td class="rightAligned">Branch</td>
					<td class="leftAligned">
						<span class="lovSpan required" style="width: 240px;">
							<input type="text" id="txtBranch" name="txtBranch" style="width: 215px; float: left; border: none; height: 14px; margin: 0;" class="required"/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchBranch" name="imgSearchBranch" alt="Go" style="float: right;"/>
						</span>
					</td>
				</tr>
			</table>		
		</div>	
			
		<div class="sectionDiv" style="margin-bottom: 50px;">
			<div id="paymentRequestStatusTableDiv" style="margin: 10px 0px 10px 10px; float: left; width: 728px;">
				<div id="paymentRequestStatusTable" style="height: 300px;"></div>
			</div>	
			
			<div class="" style="float: right; margin-top: 15px; width: 160px; height: 287px; margin-right: 15px;" >
				<table style="margin-top: 5px;">
					<tr>
						<td>Status</td>
					</tr>
					<tr>
						<td style="padding-top: 10px;">
							<table class="sectionDiv" style="padding-top:15px; padding-bottom:15px; width: 160px;">	
								<tr height="25px">
									<td><input type="radio" id="all" name="status" checked="checked" value="" /></td>
									<td align="left"><label for="all">All</label></td>
								</tr>
								<tr height="25px">
									<td><input type="radio" id="new" name="status" value="N" /></td>
									<td align="left"><label for="new">New</label></td>
								</tr>
								<tr height="25px">
									<td><input type="radio" id="closed" name="status" value="C" /></td>
									<td align="left"><label for="closed">Closed</label></td>
								</tr>
								<tr height="25px">
									<td><input type="radio" id="cancelled" name="status" value="X" /></td>
									<td align="left"><label for="cancelled">Cancelled</label></td>
								</tr>
							</table>
						</td>
					</tr>		
				</table>
			</div>						
			
			<div class="sectionDiv" align="center" style="float: left; clear: both; margin-left: 5px; width: 899px; height: 105px; margin-left:10px; margin-bottom:  10px; margin-top: 10px;">
				<table align="center" style="margin: 5px 5px 5px 5px">
					<tr>
						<td class="rightAligned">Payee</td>
						<td class="leftAligned" colspan="3" style="width: 510px;"><input type="text" id="txtPayee" name="txtPayee" style="width: 510px" readonly="readonly"/></td>	
					</tr>
					<tr>
						<td class="rightAligned">Particulars</td>
						<td class="leftAligned" colspan="3" style="width: 510px;">
						 <!-- edited by MArks SR-5859 11.25.2016 -->
						<div class="withIconDiv" style="float: left; width: 516px">
							<textarea type="text" id="txtParticulars" class="withIcon" style="width: 490px; resize:none;" readonly="readonly" name="txtParticulars" onkeyup="limitText(this,4000);" onkeydown="limitText(this,4000);" tabindex="301" /></textarea>
							<img id="editTxtParticulars" alt="edit" style="width: 14px; height: 14px; margin: 3px; float: right;" src="/Geniisys/images/misc/edit.png">
						</div></td>
						<!-- end -->	
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input type="text" id="txtUserId" name="txtUserId" style="width: 150px;" readonly="readonly"/></td>
						<td class="rightAligned">Last Update</td>
						<td class="rightAligned" style="width: 195px;"><input type="text" id="txtLastUpdate" name="txtLastUpdate" style="width: 195px;" readonly="readonly"/></td>
					</tr>
				</table>
			</div>
			
			<div style="clear: both; width: 100%; margin-top: 10px; margin-bottom: 10px; width: 900px;">
				<input type="button" class="button" id="btnHistory" name="history" value="History" style="width: 100px"/>
			</div>
		</div>
	</div>
</div>
<div id="hiddenDiv">
	<input type="hidden" id="hidTranId" name="hidTranId"/>
	<input type="hidden" id="hidStatusFlag" name="hidStatusFlag"/>
	<input type="hidden" id="hidBranchCd" name="hidBranchCd"/>
	<input type="hidden" id="hidFundCd" name="hidFundCd"/>
	<input type="hidden" id="hidDocumentCd" name="hidDocumentCd"/>
</div>
<script type="text/javascript">
	initializeAccordion();
	setModuleId("GIACS236");
	setDocumentTitle("View Payment Request Status");
	objGIACS236 = new Object();
	objGIACS236.fundCd = null;
	objGIACS236.branchCd = null;
	objGIACS236.statusFlag = null;
	objGIACS236.branch= null;
	objGIACS236.fundDesc = null;
	var otherBranch = '${otherBranch}';
	$("mainNav").hide();	//Gzelle 11.18.2013 
//	$("acExit").show();		//Gzelle 11.18.2013 

	//Payment Request Table Grid
	var jsonPaymentRequestStatus = JSON.parse('${jsonPaymentRequestStatus}');
	paymentRequestStatusTableModel = {
			url : contextPath+"/GIACInquiryController?action=showPaymentRequestStatus&refresh=1"
								+ "&fundCd=" + $F("hidFundCd")
					            + "&branchCd=" + $F("hidBranchCd")
					            + "&statusFlag=" + $F("hidStatusFlag"),
			options: {
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
				},
				width: '728px',
				height: '275px',
				onCellFocus : function(element, value, x, y, id) {
					setDetailsForm(tbgPymntReqStatus.geniisysRows[y]);		
					tbgPymntReqStatus.keys.removeFocus(tbgPymntReqStatus.keys._nCurrentFocus, true);
					tbgPymntReqStatus.keys.releaseKeys();
					enableButton("btnHistory");
				},
				onRemoveRowFocus : function(element, value, x, y, id){					
					setTbg();
				},
				prePager : function() {
					setTbg();
				},
				afterRender : function() {
					setTbg();
				},
				onSort : function() {
					setTbg();
				},
				onRowDoubleClick: function(y){
					objGIACS236.fundCd = $F("hidFundCd");
					objGIACS236.branchCd = $F("hidBranchCd");
					objGIACS236.fundDesc = $F("txtFundDesc");
					objGIACS236.branch = $F("txtBranch");
					var row = tbgPymntReqStatus.geniisysRows[y];
					//Gzelle 11.18.2013 
					var disbursement = "";
					if (row.documentCd == "BCSR" || row.documentCd == "CSR" || row.documentCd == "SCSR") {
						disbursement = "CPR";
					}else if (row.documentCd == "OFPPR") {
						disbursement = "FPP";
					}else if (row.documentCd == "CPR") {
						disbursement = "CP";
// 					}else if (row.statusFlag != "X") {
// 						disbursement = "CR";
					}else{
						disbursement = "OP";
					}
					$("mainNav").show();
					$("acExit").show();
					showDisbursementMainPage(disbursement, row.refId, otherBranch);
					objAC.paytReqStatTag = "Y";
				}
			},									
			columnModel: [
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
					id : "requestDate",
					title : "Date",
					width : '130px',
					align : 'center',
					titleAlign : 'center',
					filterOption : true,
					type: 'date',
					format: 'mm-dd-yyyy',
					titleAlign: 'center',
					filterOptionType : 'formattedDate'
				},
				{
					id : "requestNo",
					title : "Request No.",
					width : '215px',
					filterOption : true
				},
				{
					id : "department",
					title : "Department",
					width : '230px',
					filterOption : true
				},
				{
					id : "rvMeaning",
					title : "Status",
					width : '120px',
					align : 'center',
					titleAlign : 'center',
					filterOption : true
				} 
			],
			rows: jsonPaymentRequestStatus.rows
		};
	
	tbgPymntReqStatus = new MyTableGrid(paymentRequestStatusTableModel);
	tbgPymntReqStatus.pager = jsonPaymentRequestStatus;
	tbgPymntReqStatus.render('paymentRequestStatusTable');
	
	function setDetailsForm(rec){
		try{
			$("txtPayee").value 		= rec == null ? "" : unescapeHTML2(rec.payee);
			$("txtParticulars").value 	= rec == null ? "" : unescapeHTML2(rec.particulars);
			$("txtUserId").value 		= rec == null ? "" : unescapeHTML2(rec.userId);
			$("txtLastUpdate").value 	= rec == null ? "" : rec.lastUpdate;
			$("hidTranId").value		= rec == null ? "" : rec.tranId;
			$("hidStatusFlag").value	= rec == null ? "" : rec.statusFlag;
		} catch(e){
			showErrorMessage("setDetailsForm", e);
		}
	}
	
	function disableButtons(enable) {
		if (nvl(enable,false) == true){
			disableToolbarButton("btnToolbarExecuteQuery");
			disableToolbarButton("btnToolbarEnterQuery");
			disableButton("btnHistory");
			$$("input[name='status']").each(function(rdoTSFlag) {
				rdoTSFlag.disabled = true;
			});
		}else{
			$$("input[name='status']").each(function(rdoTSFlag) {
				rdoTSFlag.disabled = false;
			});				
		}
	}
	
	function setTbg() {
		setDetailsForm(null);
		tbgPymntReqStatus.keys.removeFocus(tbgPymntReqStatus.keys._nCurrentFocus, true);
		tbgPymntReqStatus.keys.releaseKeys();
		disableButton("btnHistory");
	}
	
	function executeQuery(){
		tbgPymntReqStatus.url = contextPath+"/GIACInquiryController?action=showPaymentRequestStatus&refresh=1"
				            + "&fundCd=" + $F("hidFundCd")
				            + "&branchCd=" + $F("hidBranchCd")
				            + "&statusFlag=" + $F("hidStatusFlag");
		tbgPymntReqStatus._refreshList();
		disableInputField("txtFundDesc");
		disableInputField("txtBranch");
		disableSearch("imgSearchFund");
		disableSearch("imgSearchBranch");
		enableToolbarButton("btnToolbarEnterQuery"); 
		disableButtons(false);
	}
	
	//history pop-up
	function showOverlay(action, title, error) {
		try {
			overlayPaymentRequestHistory = Overlay.show(contextPath + "/GIACInquiryController?ajax=1" + "&tranId=" + $F("hidTranId"), {
				urlContent : true,
				urlParameters : {action : action},
				title : title,
				height : 290,
				width : 475,
				draggable : true
			});
		} catch (e) {
			showErrorMessage(error, e);
		}
	}
	
	function enterQuery() {
		tbgPymntReqStatus.url = contextPath+"/GIACInquiryController?action=showPaymentRequestStatus&refresh=1";		
		tbgPymntReqStatus._refreshList();
		enableInputField("txtFundDesc");
		enableInputField("txtBranch");
		enableSearch("imgSearchFund");
		enableSearch("imgSearchBranch");
		disableButton("btnHistory");
		disableButtons(true);
		$("txtFundDesc").value = "";
		$("txtBranch").value = "";
		$("all").checked = true;
	}
	
	function formatPage() {
		if (objAC.paytReqStatTag == "Y") {
			enableToolbarButton("btnToolbarEnterQuery");
			disableButtons(false);
			$$("input[name='status']").each(function(btn) {
				if ($("hidStatusFlag").value == $(btn).value) {
					$(btn).checked = true;
				}
			});
			objAC.paytReqStatTag = null;
		}else {
			disableButtons(true);
		}
	}

	function showGIACS236InquiryFundLOV(action, fundDesc, FundCdTitle, FundDescTitle, hidFundCd, branchCd, focus) {
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {
				action : action,
				company: fundDesc.value,
				page : 1
			},
			title : "List of Funds",
			width : 370,
			height : 400,
			columnModel : [ {
				id : "fundCd",
				title : FundCdTitle,
				width : '100px'
			}, {
				id : "fundDesc",
				title : FundDescTitle,
				width : '235px'
			} ],
			draggable : true,
			autoSelectOneRecord : true,
			filterText : fundDesc.value,
			onSelect : function(row) {
				enableToolbarButton("btnToolbarEnterQuery");
				if(branchCd.value != ""){
					hidFundCd.value = row.fundCd;
					fundDesc.value = row.fundCd + " - " + row.fundDesc;
					enableToolbarButton("btnToolbarExecuteQuery");
				}else{
					hidFundCd.value = row.fundCd;
					fundDesc.value = row.fundCd + " - " + row.fundDesc;
					disableToolbarButton("btnToolbarExecuteQuery");
				}
			},
			onUndefinedRow : function(){
				customShowMessageBox("No record selected.", imgMessage.INFO, focus);
			},
			onCancel: function(){
				fundDesc.focus();
			}
		});
	}
	
	$$("input[name='status']").each(function(btn) {
		btn.observe("click", function() {
			$("hidStatusFlag").value = $F(btn).substring(0,1);
			objGIACS236.statusFlag = $("hidStatusFlag").value;
			if ($("txtFundDesc").value != null && $("txtBranch").value != "" && exec == true) {
				executeQuery();
			}
		});
	});
	
	$("txtBranch").observe("change", function() {
		$("hidBranchCd").value = null;
		enableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		showGIACSInquiryBranchLOV("GIACS236", "getGIACSInquiryBranchLOV", $("hidFundCd"), $("txtBranch"), "Code", "Description", $("hidBranchCd"), $F("txtFundDesc"), "txtBranch");
	});
	
	$("txtFundDesc").observe("change", function() {
		$("hidFundCd").value = null;
		enableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		showGIACS236InquiryFundLOV("getGIACSInquiryFundLOV", $("txtFundDesc"), "Code", "Description", $("hidFundCd"), $("txtBranch"), "txtFundDesc");
	});
	
	//search
	$("imgSearchFund").observe("click", function(){
		//enableToolbarButton("btnToolbarEnterQuery"); 	//Gzelle 11.18.2013 
		showGIACS236InquiryFundLOV("getGIACSInquiryFundLOV", $("txtFundDesc"), "Code", "Description", $("hidFundCd"), $("txtBranch"), "txtFundDesc");
	});
	
	$("imgSearchBranch").observe("click", function(){
		//enableToolbarButton("btnToolbarEnterQuery");	//Gzelle 11.18.2013 
		showGIACSInquiryBranchLOV("GIACS236","getGIACSInquiryBranchLOV",$("hidFundCd"), $("txtBranch"), "Branch Code", "Branch Name", $("hidBranchCd"), $F("txtFundDesc"), "txtBranch");
	});
	
	//Enter Query
	$("btnToolbarEnterQuery").observe("click", function() {
		//$("reloadPaymentRequestStatus").click();
		enterQuery();
	});
	
	//Execute Query
	$("btnToolbarExecuteQuery").observe("click", function() {
		if ($("txtFundDesc").value != "" && $("txtBranch").value != "") {
			exec = true;
			executeQuery();
			disableToolbarButton("btnToolbarExecuteQuery");
		}
	});
	
	//Exit
	$("btnToolbarExit").observe("click", function() {
		objAC.paytReqStatTag = null;
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
	});

//	Gzelle 11.18.2013 
//	$("acExit").stopObserving();
//	$("acExit").observe("click", function() {
//		objAC.paytReqStatTag = null;
//		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
//	});
	
	//History
	$("btnHistory").observe("click", function() {
		showOverlay("showPaymentRequestHistory", "Payment Request Status History", "Show Payment Request History");
	});	
	
	function updatePaymentRequestStatus(fundCd, branchCd, statusFlag) {
		new Ajax.Request(contextPath + "/GIACInquiryController", {
		    parameters : {action : "showPaymentRequestStatus",
		    			  fundCd : fundCd,
		    			  branchCd : branchCd,
		    			  statusFlag : statusFlag},
		    onCreate : showNotice("Retrieving Payment Request Status, please wait..."),
			onComplete : function(response){
				hideNotice();
				try {
					if(checkErrorOnResponse(response)){
						$("mainContents").update(response.responseText);
						$("txtFundDesc").value = objGIACS236.fundDesc;
						$("txtBranch").value = objGIACS236.branch;
						$("hidFundCd").value = objGIACS236.fundCd;
						$("hidBranchCd").value = objGIACS236.branchCd;
						$("hidStatusFlag").value = objGIACS236.statusFlag;
						disableInputField("txtFundDesc");
						disableInputField("txtBranch");
						disableSearch("imgSearchFund");
						disableSearch("imgSearchBranch");
						disableToolbarButton("btnToolbarExecuteQuery");
					}
				} catch(e){
					showErrorMessage("updatePaymentRequestStatus - onComplete : ", e);
				}
			} 
		});
	}
	/* added by MArks SR-5859 11.25.2016*/
	$("editTxtParticulars").observe("click", function() {
		showOverlayEditor("txtParticulars", 4000, $("txtParticulars").hasAttribute("readonly"));
	});
	/* END  */
	objGIACS236.updatePaymentRequestStatus = updatePaymentRequestStatus;
	$("btnToolbarPrint").hide();
	formatPage();
	
</script>