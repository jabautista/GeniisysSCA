<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>


<c:if test="${clmSw eq 'Y' }">
	<div id="claimListingMenu" style="display: none;">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="exit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
</c:if>
<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
   		<label id="lblModuleTitle"></label>
   			<span class="refreshers" style="margin-top: 0;">
		</span>
   	</div>
</div>
<div id="branchDisbRequestsMainDiv" name="branchDisbRequestsMainDiv" class="sectionDiv" style="border-top: none; padding-bottom: 40px;">
	<div id="gridContainerDiv" style="width: 60%; margin-top: 20px; margin-left: 20%;">
		<div id="branchDisbRequestsTableGrid" style="position:relative; height: 300px; margin-left: 10px; margin-top: 0px;"></div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel" />
	<input type="button" class="button" id="btnProceed" name="btnProceed" value="Ok" />
</div>
<script type="text/javascript">
	var objOtherBranchCurrentRec = {};
	var disbursementCd = '${disbursementCd}';
	
	
	try {
		setModuleId("GIACS055");
		setDocumentTitle("${moduleTitle}");
		//setDocumentTitle("Branch DV");
		initializeAll();
		addStyleToInputs();
		hideNotice();
		
		$("lblModuleTitle").innerHTML = '${moduleTitle}';
		
		/* modified by irwin. 7.4.2012*/
		objCLMGlobal.clmSw = "${clmSw}";
		objCLMGlobal.tranType = "${tranType}";
		objCLMGlobal.fromClaimItemInfo = "${fromClaimItemInfo}";
		
		if(nvl(objCLMGlobal.clmSw,"N") == "Y"){
			if(nvl(objCLMGlobal.fromClaimItemInfo,"N") == "Y"){
				//showClaimListing();
			}else{
				$("claimListingMenu").show();
				$("exit").observe("click", function (){
					goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");	
				});		
			}
			
			$("btnCancel").hide();
		}
		
		var objOtherBranch = JSON.parse('${jsondisbRequestOtherBranchTableGrid}');
		var otherBranchTableModel = {
				url : contextPath
						+ "/GIACOtherBranchRequestController?action=showOtherBranchTableGrid&refresh=1"
						+ "&disbursementCd="+disbursementCd+"&clmSw="+objCLMGlobal.clmSw
						+ "&tranType="+objCLMGlobal.tranType+"&fromClaimItemInfo="+objCLMGlobal.fromClaimItemInfo, // added clmSw, tranType, fromClaimItemInfo Nica 12.04.2012
				options : {
					onCellFocus : function(element, value, x, y, id) {
						objOtherBranchCurrentRec = otherBranchTableGrid.geniisysRows[y];
						objOtherBranchCurrentRec.rowIndex = y;
						otherBranchTableGrid.keys.removeFocus(otherBranchTableGrid.keys._nCurrentFocus, true);
						otherBranchTableGrid.keys.releaseKeys();
						objACGlobal.fundCd = objOtherBranchCurrentRec.gfunFundCd;
						objACGlobal.branchCd = objOtherBranchCurrentRec.branchCd;
					},
					onRemoveRowFocus : function() {
						objOtherBranchCurrentRec = {};
					},
					onRowDoubleClick : function(y){
						objGIACS002.fundCd = otherBranchTableGrid.geniisysRows[y].gfunFundCd;
						objGIACS002.branchCd = otherBranchTableGrid.geniisysRows[y].branchCd;
						
						if(nvl(objCLMGlobal.tranType,"") == "SCSR"){
							objCLMGlobal.callingForm = "GIACS086"; 
							showSpecialCSRListing(otherBranchTableGrid.geniisysRows[y].gfunFundCd,otherBranchTableGrid.geniisysRows[y].branchCd, objCLMGlobal.fromClaimItemInfo);
						} else if(objAC.fromMenu == "menuOtherBranchGenerateDV"){
							objACGlobal.fundCd = otherBranchTableGrid.geniisysRows[y].gfunFundCd;
							objACGlobal.branchCd = otherBranchTableGrid.geniisysRows[y].branchCd;
							showDisbursementVoucherPage('N', 'showGenerateDisbursementVoucher'); 					
						} else if(objAC.fromMenu == "menuOtherBranchManualDV"){
							objACGlobal.fundCd = otherBranchTableGrid.geniisysRows[y].gfunFundCd;
							objACGlobal.branchCd = otherBranchTableGrid.geniisysRows[y].branchCd;
							objGIACS002.dvTag = "M";
							showDisbursementVoucherPage('N', 'showGenerateDisbursementVoucher'); 
						} else if(objAC.fromMenu == "menuOtherBranchCancelDV"){
							objGIACS002.cancelDV = "Y";
							objACGlobal.fundCd = otherBranchTableGrid.geniisysRows[y].gfunFundCd;
							objACGlobal.branchCd = otherBranchTableGrid.geniisysRows[y].branchCd;
							showDisbursementVoucherPage('Y', 'getGIACS002DisbVoucherList'); 
						} else if(objAC.fromMenu == "menuOtherBranchDVListing"){
							objACGlobal.fundCd = otherBranchTableGrid.geniisysRows[y].gfunFundCd;
							objACGlobal.branchCd = otherBranchTableGrid.geniisysRows[y].branchCd;
							showDisbursementVoucherPage('N', 'getGIACS002DisbVoucherList'); 	
						}else{
							showDisbursementRequests(disbursementCd, otherBranchTableGrid.geniisysRows[y].branchCd);			
						}
						
					}
				},
				columnModel : [
				    {
						id : 'recordStatus',
						title : '',
						width : '0',
						visible : false
					},
					{
						id : 'divCtrId',
						width : '0',
						visible : false
					},
					{
						id : 'gfunFundCd',
						title : 'Company',
						width : '120px',
						titleAlign : 'center'
					},
					{
						id : 'branchCd',
						title : 'Branch',
						width : '80x',
						titleAlign: 'center'
					},
					{
						id : 'branchName',
						title : '',
						width : '330x',
						titleAlign: 'center',
						sortable : false
					}
				],
				rows : objOtherBranch.rows
		};
		otherBranchTableGrid = new MyTableGrid(otherBranchTableModel);
		otherBranchTableGrid.pager = objOtherBranch;
		otherBranchTableGrid.render('branchDisbRequestsTableGrid');
		
		
	} catch (e){
		showErrorMessage("otherBranchTableGridListing.jsp", e);
	}
	
	
	$("btnProceed").observe("click", function() {
		try {
			var y = objOtherBranchCurrentRec.rowIndex; //robert 12.06.2012
			if (JSON.stringify(objOtherBranchCurrentRec) == "{}"){
				showMessageBox("Please select a Branch first.");
			} else {
				//added by jeffdojello 02.17.2014
				objGIACS002.fundCd = otherBranchTableGrid.geniisysRows[y].gfunFundCd;
				objGIACS002.branchCd = otherBranchTableGrid.geniisysRows[y].branchCd;
				
				if(nvl(objCLMGlobal.tranType,"") == "SCSR"){
					objCLMGlobal.callingForm = "GIACS055"; 
					showSpecialCSRListing(otherBranchTableGrid.geniisysRows[y].gfunFundCd,otherBranchTableGrid.geniisysRows[y].branchCd, objCLMGlobal.fromClaimItemInfo);
				} else if(objAC.fromMenu == "menuOtherBranchGenerateDV"){
					objACGlobal.fundCd = otherBranchTableGrid.geniisysRows[y].gfunFundCd;
					objACGlobal.branchCd = otherBranchTableGrid.geniisysRows[y].branchCd;
					showDisbursementVoucherPage('N', 'showGenerateDisbursementVoucher'); 					
				} else if(objAC.fromMenu == "menuOtherBranchManualDV"){
					objACGlobal.fundCd = otherBranchTableGrid.geniisysRows[y].gfunFundCd;
					objACGlobal.branchCd = otherBranchTableGrid.geniisysRows[y].branchCd;
					objGIACS002.dvTag = "M";
					showDisbursementVoucherPage('N', 'showGenerateDisbursementVoucher'); 
				} else if(objAC.fromMenu == "menuOtherBranchCancelDV"){
					objGIACS002.cancelDV = "Y";
					objACGlobal.fundCd = otherBranchTableGrid.geniisysRows[y].gfunFundCd;
					objACGlobal.branchCd = otherBranchTableGrid.geniisysRows[y].branchCd;
					showDisbursementVoucherPage('Y', 'getGIACS002DisbVoucherList'); 
				} else if(objAC.fromMenu == "menuOtherBranchDVListing"){
					objACGlobal.fundCd = otherBranchTableGrid.geniisysRows[y].gfunFundCd;
					objACGlobal.branchCd = otherBranchTableGrid.geniisysRows[y].branchCd;
					showDisbursementVoucherPage('N', 'getGIACS002DisbVoucherList'); 	
				}else{
					showDisbursementRequests(disbursementCd, otherBranchTableGrid.geniisysRows[y].branchCd);			
				}	
			}
		} catch (e) {
			showErrorMessage("btnProceed", e);
		}
	});	

	$("btnCancel").observe("click", function() {
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});
	
 	$("acExit").stopObserving("click");
	$("acExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);			
		objACGlobal.callingModule = "";
		objACGlobal.disbursementCd = "";
		if(objCLMGlobal.fromMenu == "cancelRequest"){ //added by steven 06.05.2013 
			objCLMGlobal.fromMenu = "";
		}
	});
</script>