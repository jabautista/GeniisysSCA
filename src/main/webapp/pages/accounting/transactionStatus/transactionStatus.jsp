<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>
<div id="mainTransactionDiv" name="mainTransactionDiv" style="height: 680px;">
	<div id="transactionStatDiv" name="transactionStatDiv">
<!-- 		<div id="mainNav" name="mainNav"> -->
<!-- 			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu"> -->
<!-- 				<ul> -->
<!-- 					<li><a id="acctgTranStatExit">Exit</a></li> -->
<!-- 				</ul> -->
<!-- 			</div> -->
<!-- 		</div> -->
		<jsp:include page="/pages/toolbar.jsp"></jsp:include>
		<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv">
				<label>View Transaction Status</label>
<!-- 				<span class="refreshers" style="margin-top: 0;">
					<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
					<label id="reloadTranStatForm" name="reloadTranStatForm">Reload Form</label>
				</span> -->
			</div>
		</div>
		<div id="transactionStatHeaderDiv">			
			<div class="sectionDiv" id="parameterDiv" style="float: left; width: 100%;">
				<table style="margin-top: 10px; margin-bottom: 10px; padding-left: 30px;">
					<tr>		
						<td class="rightAligned">Company</td>
						<td class="leftAligned">
							<span class="lovSpan required"" style="width: 400px; margin-right: 25px;">
								<input type="text" class="required" id="txtCompany" name="txtCompany" style="width: 375px; float: left; border: none; height: 14px; margin: 0;" tabindex="101"/> 
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchCompany" name="imgSearchCompany" alt="Go" style="float: right;" tabindex="102"/>
							</span>
						</td>
						<input type="hidden" id="hidFundCd" name="hidFundCd">
						<input type="hidden" id="hidCompany" name="hidCompany"/>
						<input type="hidden" id="hidBranchCd" name="hidBranchCd">
						<input type="hidden" id="hidBranch" name="hidBranch"/>
						<td class="rightAligned">Branch</td>
						<td class="leftAligned">
							<span class="lovSpan required" style="width: 300px;">
								<input type="text" class="required" id="txtBranch" name="txtBranch" style="width: 275px; float: left; border: none; height: 14px; margin: 0;" tabindex="103"/>  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchBranch" name="imgSearchBranch" alt="Go" style="float: right;" tabindex="104"/>
							</span>
						</td>
					</tr>
				</table>
			</div>
	
			<div class="sectionDiv" style="margin-bottom: 70px;">
				<div id="tStatusDiv" style="margin: 10px 0px 10px 10px; float: left;">
					<div id="transTable" style="height: 300px; width: 752px;"></div>
				</div>
			
				<div class="" align="center" style="float: left; padding-top: 10px; padding-right: 30px; margin: 10px; margin-top: 0; width: 100px; height: 287px;" >
					<table style="height: 200px; margin-left: 5px;" class="sectionDiv">
						<tr height="40px">
							<td align="center" style="padding-bottom: 0px;">Transaction Flag</td>
							<input type="hidden" id="hidTrnFlag" name="hidTrnFlag" value="" />
							<input type="hidden" id="hidTranId" name="hidTranId"/>
						</tr>
						<tr>
							<td style="padding: 5px;">
								<table class="sectionDiv" style="padding-top:10px; padding-bottom:20px; width: 110px;">	
									<tr height="49px">
										<td class="rightAligned" style="width: 30px;">
											<input type="radio" id="selectAll" name="status" value="" tabindex="201"/>
										</td>
										<td class="leftAligned"><label for="selectAll">All</label></td>
									</tr>
									<tr height="49px">
										<td class="rightAligned">
											<input type="radio" id="selectOpen" name="status" value="O" tabindex="202"/>
										</td>
										<td class="leftAligned"><label for="selectOpen">Open</label></td>
									</tr>
									<tr height="49px">
										<td class="rightAligned">
											<input type="radio" id="selectClosed" name="status" value="C" tabindex="203"/>
										</td>
										<td class="leftAligned"><label for="selectClosed">Closed</label></td>
									</tr>
									<tr height="49px">
										<td class="rightAligned">
											<input type="radio" id="selectPosted" name="status" value="P" tabindex="204"/>
										</td>
										<td class="leftAligned"><label for="selectPosted">Posted</label></td>
									</tr>
								</table>
							</td>
						</tr>		
					</table>
	 			</div>
				<div class="sectionDiv" id="transactionStatusFormDiv" style="float: left; clear: both; margin-left: 10px; margin-bottom:10px; width: 97%; height: 70px; padding-top: 5px;">
					<table style="padding-left: 30px; float: left;">
						<tr>
							<td class="rightAligned">Particulars</td>
							<td class="leftAligned" colspan="3">
								<input type="text" id="txtParticulars" name="txtParticulars" style="width: 750px" readonly="readonly" tabindex="301"/>
							</td>	
						</tr>
						<tr>
							<td class="rightAligned">User ID</td>
							<td class="leftAligned">
								<input type="text" id="txtID" name="txtID" style="width: 150px;" readonly="readonly" tabindex="302"/>
							</td>
							<td class="rightAligned">Last Update</td>
							<td class="leftAligned" style="width: 195px;">
								<input type="text" id="txtLastUpdate" name="txtLastUpdate" style="width: 195px;" readonly="readonly" tabindex="303"/>
							</td>
						</tr>
					</table>
				</div>
				<div style="width: 100%; margin-bottom: 10px;" align="center">
					<input type="button" class="disabledButton" id="btnHistory" name="btnHistory" value="History" disabled="disabled" style="width: 100px" tabindex="401"/>
					<input type="button" class="disabledButton" id="btnPrint" name="btnPrint" value="Print" disabled="disabled" style="width: 100px" tabindex="402"/>
				</div>
			</div>	
		</div>
	</div>
</div>


<script type="text/javascript">
	initializeAccordion();
	setModuleId("GIACS231");
	setDocumentTitle("View Transaction Status");
	executeFlag = false;
	acctgTranStat = null;
	
	
	
	var selectedObjRow = null;
		var jsonActgTransactionStatus = JSON.parse('${jsonActgTransactionStatus}');	
		transactionStatusTableModel = {
				url : contextPath+"/GIACInquiryController?action=showTransactionStatus&refresh=1",
				options: {
					toolbar: {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
						onFilter : function(){
							setDetailsForm(null);
							tbgAccountingTransactionStatus.keys.removeFocus(tbgAccountingTransactionStatus.keys._nCurrentFocus, true);
							tbgAccountingTransactionStatus.keys.releaseKeys();
							toggleButtons(false);
						}
					},
					width: '752px',
					pager: {
					},
					onCellFocus : function(element, value, x, y, id) {
						acctgTranStat = tbgAccountingTransactionStatus.geniisysRows[y];
						setDetailsForm(tbgAccountingTransactionStatus.geniisysRows[y]);					
						tbgAccountingTransactionStatus.keys.removeFocus(tbgAccountingTransactionStatus.keys._nCurrentFocus, true);
						tbgAccountingTransactionStatus.keys.releaseKeys();
						toggleButtons(true);
					},
					prePager: function(){
						setDetailsForm(null);
						tbgAccountingTransactionStatus.keys.removeFocus(tbgAccountingTransactionStatus.keys._nCurrentFocus, true);
						tbgAccountingTransactionStatus.keys.releaseKeys();
						toggleButtons(false);
					},
					onRemoveRowFocus : function(element, value, x, y, id){	
						setDetailsForm(null);
						toggleButtons(false);
					},
					onSort : function(){
						setDetailsForm(null);
						tbgAccountingTransactionStatus.keys.removeFocus(tbgAccountingTransactionStatus.keys._nCurrentFocus, true);
						tbgAccountingTransactionStatus.keys.releaseKeys();		
						toggleButtons(false);
					},
					onRefresh : function(){
						setDetailsForm(null);
						tbgAccountingTransactionStatus.keys.removeFocus(tbgAccountingTransactionStatus.keys._nCurrentFocus, true);
						tbgAccountingTransactionStatus.keys.releaseKeys();
						toggleButtons(false);
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
						id : "tranClass",
						title: "Class",
						width: '50px',
						filterOption : true
					},				
					{
						id : "tranNo",
						title: "Transaction No.",
						width: '130px',
						align: 'left',
						titleAlign: 'left',
						filterOption : true
					},
					{
						id : "tranDate",
						title: "Tran Date",
						width: '100px',
						sortable: true,
						align: 'center',
						type: 'date',
						format: 'mm-dd-yyyy',
						titleAlign: 'center',
						filterOption : true,
						filterOptionType : 'formattedDate',
					},
					{
						id : "postingDate",
						title: "Date Posted",
						width: '100px',
						sortable: true,
						align: 'center',
						type: 'date',
						format: 'mm-dd-yyyy',
						titleAlign: 'center',
						filterOption : true,
						filterOptionType : 'formattedDate',
					},
					{
						id : "refNo",
						title: "Reference No.",
						width: '200px',
						filterOption : true
					},
					{
						id : "tranFlag",
						title: "Tran Flag",
						width: '130px',
						filterOption : true
					}
					
				],
				rows: jsonActgTransactionStatus.rows
			};
		
		tbgAccountingTransactionStatus = new MyTableGrid(transactionStatusTableModel);
		tbgAccountingTransactionStatus.pager = jsonActgTransactionStatus;
		tbgAccountingTransactionStatus.render('transTable');
		
		function sortByTranFlag(){
			tbgAccountingTransactionStatus.url = contextPath+"/GIACInquiryController?action=showTransactionStatus&refresh=1&fundCd="+$F("hidFundCd")
															+"&branchCd="+$F("hidBranchCd")
															+"&tranFlagStat="+$F("hidTrnFlag");
			tbgAccountingTransactionStatus._refreshList();
			disableInputField("txtCompany");
			disableInputField("txtBranch");
			disableSearch("imgSearchCompany");
			disableSearch("imgSearchBranch");
			if (tbgAccountingTransactionStatus.geniisysRows.length == 0) {
				customShowMessageBox("Query caused no records to be retrieved. Re-enter.", imgMessage.INFO, "txtCompany");
			}
		}
		
		function setDetailsForm(rec){
			try{
				$("txtID").value 			= rec == null ? "" : rec.userId;
				$("txtLastUpdate").value 	= rec == null ? "" : rec.lastUpdate;
				$("txtParticulars").value 	= rec == null ? "" : unescapeHTML2(rec.particulars);
				$("hidTranId").value		= rec == null ? "" : rec.tranId;
			} catch(e){
				showErrorMessage("setDetailsForm", e);
			}
		}
		
		function toggleButtons(enable) {
			if (nvl(enable,false) == true){
				enableButton("btnPrint");
				enableButton("btnHistory");
				enableToolbarButton("btnToolbarPrint");
			}else {
				disableButton("btnPrint");
				disableButton("btnHistory");
				disableToolbarButton("btnToolbarExecuteQuery");
				disableToolbarButton("btnToolbarPrint");
			}
		}
	
		$$("input[name='status']").each(function(rdoTSFlag) {
			rdoTSFlag.observe("click",function() {
				$("hidTrnFlag").value = $F(rdoTSFlag);
				if ($("txtCompany").value != null && $("txtBranch").value != "" && executeFlag) {
					$("hidTrnFlag").value = $F(rdoTSFlag);
					sortByTranFlag();					
				}
			});
		});

		function clearFields(){
			try {
				$("hidFundCd").value = "";
				$("hidBranchCd").value = "";
				$("hidTrnFlag").value = "";
				$("txtCompany").value = "";
				$("txtBranch").value = "";
				
				tbgAccountingTransactionStatus.url = contextPath+"/GIACInquiryController?action=showTransactionStatus&refresh=1&fundCd="+$F("hidFundCd")
													+"&branchCd="+$F("hidBranchCd")
													+"&tranFlagStat="+$F("hidTrnFlag");
				tbgAccountingTransactionStatus._refreshList();
				
				$("selectAll").checked = true;
				$("txtCompany").focus();
				toggleButtons(false);
				disableToolbarButton("btnToolbarEnterQuery");
				enableInputField("txtCompany");
				enableInputField("txtBranch");
				enableSearch("imgSearchCompany");
				enableSearch("imgSearchBranch");
				executeFlag = false;
				setDetailsForm(null);
				tbgAccountingTransactionStatus.keys.removeFocus(tbgAccountingTransactionStatus.keys._nCurrentFocus, true);
				tbgAccountingTransactionStatus.keys.releaseKeys();
			} catch (e){
				showErrorMessage("clearFields", e);
			}
		}
		
		function showGIACInquiryGIACS231FundLOV(action, fundDesc, FundCdTitle, FundDescTitle, hidFundCd, branchCd, focus) {
			LOV.show({	//Gzelle 11.18.2013 UCPBGEN-Phase3 1277
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
// 					hidFundCd.value = row.fundCd;
// 					fundDesc.value = row.fundCd + " - " + row.fundDesc;
// 					enableToolbarButton("btnToolbarExecuteQuery");
// 					enableToolbarButton("btnToolbarEnterQuery");
						if(branchCd.value != ""){
							hidFundCd.value = row.fundCd;
							fundDesc.value = row.fundCd + " - " + row.fundDesc;
							enableToolbarButton("btnToolbarExecuteQuery");
						}else{
							hidFundCd.value = row.fundCd;
							fundDesc.value = row.fundCd + " - " + row.fundDesc;
							disableToolbarButton("btnToolbarExecuteQuery");
						}
						enableToolbarButton("btnToolbarEnterQuery");
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, focus);
				},
				onCancel: function(){
					fundDesc.focus();
				}
			});
		}
		
		//toolbar query
		$("btnToolbarEnterQuery").observe("click", function() {
			//fireEvent($("reloadTranStatForm"), "click");
			clearFields();
		});
		
		//toolbar execute query
		$("btnToolbarExecuteQuery").observe("click", function() {
			if (checkAllRequiredFieldsInDiv("parameterDiv")) {
			//if ($("txtCompany"). value != "" && $("txtBranch"). value != "") {
				executeFlag = true;
				sortByTranFlag();
			}
		});

		//toolbar exit
		$("btnToolbarExit").observe("click", function(){
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
		});
		
		//menu exit
// 		$("acctgTranStatExit").observe("click", function(){
// 			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
// 		});
		
		//toolbar print
		$("btnToolbarPrint").observe("click", function(){
			showTranStatPrintDialog("Print Transaction Status", function() {
				objTransactionStatus.printReport();
			},"",true);
		});
		
		//button print
		$("btnPrint").observe("click", function(){
			showTranStatPrintDialog("Print Transaction Status", function() {
				objTransactionStatus.printReport();
			},"",true);
		});	
		
		//history details
		$("btnHistory").observe("click", function() {
			showHistoryOverlay("showTranStatHist", "Transaction Status History", "showTranStatHistOverlay");
		});	
		
		//company LOV
 		$("imgSearchCompany").observe("click", function() {
 			//enableToolbarButton("btnToolbarEnterQuery"); 	//Gzelle 11.18.2013 UCPBGEN-Phase3 1277
			showGIACInquiryGIACS231FundLOV("getGIACSInquiryFundLOV", $("txtCompany"), "Fund", "Fund Description", $("hidFundCd"), $("txtBranch"), "txtCompany");
		});
		
		//branch LOV
		$("imgSearchBranch").observe("click", function() {
			//enableToolbarButton("btnToolbarEnterQuery"); 	//Gzelle 11.18.2013 UCPBGEN-Phase3 1277
			showGIACSInquiryBranchLOV("GIACS231","getGIACSInquiryBranchLOV",$("hidFundCd"), $("txtBranch"), "Branch Code", "Branch Name", $("hidBranchCd"), $F("txtCompany"), "txtBranch");
		});
		
		//company lov field
		$("txtCompany").observe("change", function() {
			$("hidFundCd").value = null;
			enableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery"); 
			showGIACInquiryGIACS231FundLOV("getGIACSInquiryFundLOV", $("txtCompany"), "Fund", "Fund Description", $("hidFundCd"), $("txtBranch"), "txtCompany");
		});
		
		//branch lov field
		$("txtBranch").observe("change", function() {
			$("hidBranchCd").value = null;
			enableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
			showGIACSInquiryBranchLOV("GIACS231","getGIACSInquiryBranchLOV",$("hidFundCd"), $("txtBranch"), "Branch Code", "Branch Name", $("hidBranchCd"), $F("txtCompany"), "txtBranch");
		});
		
		//history overlay
		function showHistoryOverlay(action, title, error){
			try{
				overlayTranStatHist = Overlay.show(contextPath+"/GIACInquiryController?ajax=1"
										+"&tranId="+$F("hidTranId"), {
					urlContent: true,
					urlParameters: {action : action},
				    title: title,
				    height : 290,
					width : 475,
				    draggable: true
				});
			}catch(e){
				showErrorMessage(error, e);
			}		
		}
		
		//show print dialog
		function showTranStatPrintDialog(title, onPrintFunc, onLoadFunc, showFileOption){
			overlayTranStatPrintDialog = Overlay.show(contextPath+"/GIACInquiryController", {
				urlContent : true,
				urlParameters: {action : "showTranStatPrintDialog",
								showFileOption : showFileOption},
			    title: title,
			    height: (showFileOption ? 330 : 300),
			    width: 380,
			    draggable: true
			});
			
			overlayTranStatPrintDialog.onPrint = onPrintFunc;
			overlayTranStatPrintDialog.onLoad  = nvl(onLoadFunc,null);
		}
		
/* 		//reload form
		observeReloadForm("reloadTranStatForm", function(){
			new Ajax.Request(contextPath + "/GIACInquiryController", {
			    parameters : {action : "showTransactionStatus"},
			    onCreate : showNotice("Loading, please wait..."),
				onComplete : function(response){
					hideNotice();
					try {
						if(checkErrorOnResponse(response)){
							enableInputField("txtCompany");
							enableInputField("txtBranch");
							enableSearch("imgSearchCompany");
							enableSearch("imgSearchBranch");
							executeFlag = false;
							disableButton("btnPrint");
							disableButton("btnHistory");
							$("dynamicDiv").update(response.responseText);
						}
					} catch(e){
						showErrorMessage("showTransactionStatus - onComplete : ", e);
					}
				} 
			});
		}); */
		
		$("selectAll").checked = true;
		$("txtCompany").focus();
		toggleButtons(false);
		disableToolbarButton("btnToolbarEnterQuery");

</script>