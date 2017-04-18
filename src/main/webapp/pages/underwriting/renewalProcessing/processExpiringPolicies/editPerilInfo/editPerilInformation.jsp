<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>

<div id="editPerilInfoMainDiv" name="editPerilInfoMainDiv" style="margin-top: 1px;">
	<div id="editPerilInfoMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="btnExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<form id="editPerilInfoForm" name="editPerilInfoForm" changeTagAttr="true">
		<div id="editPerilInfoMainDiv">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
					<label>Edit Peril Information</label>
					<span class="refreshers" style="margin-top: 0;">
						<label name="gro" style="margin-left: 5px;">Hide</label> 
				 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
					</span>
				</div>
			</div>
			<div class="sectionDiv" id="polInfoDiv"changeTagAttr="true">
				<table style="margin-top: 20px; margin-bottom: 10px; margin-left: 100px;">
					<tr>
						<td class="rightAligned" width="120px">
							<c:if test="${isPack eq 'Y'}">
								Package No.
							</c:if>	
						</td>
						<td class="leftAligned"  width="310px">
							<c:if test="${isPack eq 'Y'}">
								<input type="text" id="txtPackageNo" name="txtPackageNo" style="width: 300px;" readonly="readonly" />
							</c:if>		
						</td>
					</tr>
					<tr>
						<td class="rightAligned" width="120px">Policy No.</td>
						<td class="leftAligned" width="310px">
							<input type="text" id="txtPolicyNo" name="txtPolicyNo" style="width: 300px;" readonly="readonly" />
						</td>
					</tr>
					<tr>
						<td class="rightAligned" width="120px">Assured Name</td>
						<td class="leftAligned" width="310px">
							<input type="text" id="txtAssdName" name="txtAssdName" style="width: 300px;" readonly="readonly" />
						</td>
					</tr>
				</table>
				<div id= "subPolicyDiv" name = "subPolicyDiv" changeTagAttr="true">
					
				</div> <!-- joanne  12.16.13, for package subpolicy-->
				<div id= "itmPerilDiv" name = "itmPerilDiv" changeTagAttr="true">
					
				</div>
				<div id= "itmPerilInfoDiv" name = "itmPerilDiv"changeTagAttr="true">
					
				</div>
				<div id="hidden" style="display: none;">
					<!--  variables  -->
					<input type="hidden" id="txtIsGpa" name="txtIsGpa" value ='${isGpa}'>
					<input type="hidden" id="txtRecomputeTax" name="txtRecomputeTax">
					<input type="hidden" id="txtNewTaxExist" name="txtNewTaxExist">
					<input type="hidden" id="txtTaxSw" name="txtTaxSw">
					<input type="hidden" id="txtIssCdRi" name="txtIssCdRi">
					<input type="hidden" id="txtInitialPerilCd" name="txtInitialPerilCd">
					<!--   B240  -->
					<input type="hidden" id="txtInceptDate" name="txtInceptDate">
					<input type="hidden" id="txtB240PolicyId" name="txtB240PolicyId">
					<input type="hidden" id="txtB240PackPolicyId" name="txtB240PackPolicyId">
					<input type="hidden" id="txtAssdNo" name="txtAssdNo">
					<input type="hidden" id="txtNbtProrateFlag" name="txtNbtProrateFlag">
					<input type="hidden" id="txtEndtExpiryDate" name="txtEndtExpiryDate">
					<input type="hidden" id="txtEffDate" name="txtEffDate">
					<input type="hidden" id="txtExpiryDate" name="txtExpiryDate">
					<input type="hidden" id="txtShortRtPercent" name="txtShortRtPercent">
					<input type="hidden" id="txtProvPremPct" name="txtProvPremPct">
					<input type="hidden" id="txtProvPremTag" name="txtProvPremTag">	
					<input type="hidden" id="txtPackPolFlag" name="txtPackPolFlag">
					<input type="hidden" id="txtSummarySw" name="txtSummarySw">
					<input type="hidden" id="txtRenewFlag" name="txtRenewFlag">
					<input type="hidden" id="txtLineCd" name="txtLineCd">
					<input type="hidden" id="txtSublineCd" name="txtSublineCd">
					<input type="hidden" id="txtIssCd" name="txtIssCd">
					<input type="hidden" id="txtNbtIssueYy" name="txtNbtIssueYy">
					<input type="hidden" id="txtNbtPolSeqNo" name="txtNbtPolSeqNo">
					<input type="hidden" id="txtNbtRenewNo" name="txtNbtRenewNo">
					<input type="hidden" id="txtCompSw" name="txtCompSw">
					<!--   B480  -->
					<input type="hidden" id="txtB480ItemNo" name="txtB480ItemNo">
					<input type="hidden" id="txtB480ItemTitle" name="txtB480ItemTitle">
					<input type="hidden" id="txtB480CurrencyRt" name="txtB480CurrencyRt">
					<input type="hidden" id="txtB480AnnPremAmt" name="txtB480AnnPremAmt">
					<input type="hidden" id="txtB480AnnTsiAmt" name="txtB480AnnTsiAmt">
					<input type="hidden" id="txtB480LineCd" name="txtB480LineCd">
					<input type="hidden" id="txtB480PremAmt" name="txtB480PremAmt">
					<input type="hidden" id="txtB480SublineCd" name="txtB480SublineCd">
					<input type="hidden" id="txtB480TsiAmt" name="txtB480TsiAmt">
					<input type="hidden" id="txtB480NbtPremAmt" name="txtB480NbtPremAmt">
					<input type="hidden" id="txtB480NbtTsiAmt" name="txtB480NbtTsiAmt">
					<!--   B480  Grp  -->
					<input type="hidden" id="txtB480GrpItemNo" name="txtB480GrpItemNo">
					<input type="hidden" id="txtB480GrpItemTitle" name="txtB480GrpItemTitle">
					<input type="hidden" id="txtB480GrpGroupedItemNo" name="txtB480GrpGroupedItemNo">
					<input type="hidden" id="txtB480GrpGroupedItemTitle" name="txtB480GrpGroupedItemTitle">
					<input type="hidden" id="txtB480GrpAnnTsiAmt" name="txtB480GrpAnnTsiAmt">
					<input type="hidden" id="txtB480GrpAnnPremAmt" name="txtB480GrpAnnPremAmt">
					<input type="hidden" id="txtB480GrpLineCd" name="txtB480GrpLineCd">
					<input type="hidden" id="txtB480GrpTsiAmt" name="txtB480GrpTsiAmt">
					<input type="hidden" id="txtB480GrpPremAmt" name="txtB480GrpPremAmt">
					<input type="hidden" id="txtB480GrpNbtTsiAmt" name="txtB480GrpNbtTsiAmt">
					<input type="hidden" id="txtB480GrpNbtPremAmt" name="txtB480GrpNbtPremAmt">
				    <!--   B490  -->
					<input type="hidden" id="txtB490PerilCd" name="txtB490PerilCd">
					<input type="hidden" id="txtB490DumPerilCd" name="txtB490DumPerilCd">
					<input type="hidden" id="txtB490NbtPremRt" name="txtB490NbtPremRt">
					<input type="hidden" id="txtB490NbtTsiAmt" name="txtB490NbtTsiAmt">
					<input type="hidden" id="txtB490NbtPremAmt" name="txtB490NbtPremAmt">
					<input type="hidden" id="txtB490PolicyId" name="txtB490B490PolicyId">	
					<input type="hidden" id="txtB490ItemNo" name="txtB490ItemNo">
					<input type="hidden" id="txtB490CurrencyRt" name="txtB490CurrencyRt">
					<input type="hidden" id="txtB490ItemTitle" name="txtB490ItemTitle">
					<input type="hidden" id="txtB490LineCd" name="txtB490LineCd">
					<input type="hidden" id="txtB490SublineCd" name="txtB490SublineCd">	
					<input type="hidden" id="txtB490AnnTsiAmt" name="txtB490AnnTsiAmt">
					<input type="hidden" id="txtB490AnnPremAmt" name="txtB490AnnPremAmt">
					<input type="hidden" id="txtB490DspPerilType" name="txtB490DspPerilType">
					<input type="hidden" id="txtB490DspBascPerlCd" name="txtB490DspBascPerlCd">
					<input type="hidden" id="changePerilTag" name="changePerilTag"> <!-- joanne 02.18.14 -->
					 <!--   B490  Grp  -->
					<input type="hidden" id="txtB490GrpPerilCd" name="txtB490GrpPerilCd">
					<input type="hidden" id="txtB490GrpPolicyId" name="txtB490GrpPolicyId">
					<input type="hidden" id="txtB490GrpItemNo" name="txtB490GrpItemNo">
					<input type="hidden" id="txtB490GrpGroupedItemNo" name="txtB490GrpGroupedItemNo">
					<input type="hidden" id="txtB490GrpLineCd" name="txtB490GrpLineCd">
					<input type="hidden" id="txtB490GrpAnnTsiAmt" name="txtB490GrpAnnTsiAmt">	
					<input type="hidden" id="txtB490GrpAnnPremAmt" name="txtB490GrpAnnPremAmt">
					<input type="hidden" id="txtB490GrpAggregateSw" name="txtB490GrpAggregateSw">
					<input type="hidden" id="txtB490GrpDspPerilType" name="txtB490GrpDspPerilType">
					<input type="hidden" id="txtB490GrpDspBascPerlCd" name="txtB490GrpDspBascPerlCd">
				</div>
			</div>
		</div>
	</form>
	<div class="buttonsDiv">
		<input type="button" class="button" id="btnCrtePrls" name="btnCrtePrls" value="Create Peril(s)"/>
		<input type="button" class="button" id="btnDelPerls" name="btnDelPerls" value="Delete Peril(s)"/>
		<input type="button" class="button" id="btnEditTax" name="btnEditTax" value="Edit Tax Charges"/>
		<input type="button" class="button" id="btnEditDed" name="btnEditDed" value="Edit Deductibles"/>
		<input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel"/>
		<input type="button" class="button" id="btnSave" name="btnSave" value="Save"/>
	</div>
</div>

<script>
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	
	var recomputeTax = 'N';
	var forDelete = 'N';
	var itemNo = '';
	var groupedItemNo = '';
	var saveAction = '';
	
	objItmPerl = new Object();
	
	var perilInformationObj = new Object();
	
	if($F("txtIsGpa")== 'Y'){
		$("btnEditDed").hide();
	}
	
	objUW.expiry = JSON.parse('${b240Dtls}'.replace(/\\/g, '\\\\'));
	
	function editTaxCharges(action){
		taxChargesDetails = Overlay.show(contextPath+"/GIEXNewGroupTaxController", {
			urlContent : true,
			draggable: true,
			urlParameters: {action: action,
										  policyId: $F("txtB240PolicyId")},
		    title: "Edit Tax / Charges",
		    height: 435,
		    width: 665
		});
	}
	
	function editDeductibles(){
		deductiblesDetails = Overlay.show(contextPath+"/GIEXNewGroupDeductiblesController", {
			urlContent : true,
			draggable: true,
			urlParameters: {action: "populateDeductiblesGIEXS007",
										  policyId: $F("txtB240PolicyId")},
		    title: "Edit Deductibles",
		    height: 480,
		    width: 800
		});
	}
	
	//joanne 12.17.13, display package subpolicies
	function showPackSubPolicies(packPolicyId, summarySw){
		try {
			new Ajax.Updater("subPolicyDiv", contextPath+"/GIEXItmperilController?action=getPackSubPolicies",{
				method:"POST",
				evalScripts: true,
				asynchronous: true,
				parameters: {packPolicyId: 	packPolicyId,
							 summarySw:		summarySw //joanne 02.03.14	   					
				},
					onComplete: function(response) {
						hideNotice();
					}
			});
		} catch(e){
			showErrorMessage("showPackSubPolicies", e);
		}
	}		
	
	function showItmPerilInfo(policyId){
		try {
			new Ajax.Updater("itmPerilDiv", contextPath+"/GIEXItmperilController?action=getGIEXS007B480Info",{
				method:"POST",
				evalScripts: true,
				asynchronous: true,
				parameters: {policyId: policyId},
					onComplete: function(response) {
						hideNotice();
					}
			});
		} catch(e){
			showErrorMessage("showItmPerilInfo", e);
		}
	}
	
	function showItmPerilGrpInfo(policyId){
		try {
			new Ajax.Updater("itmPerilDiv", contextPath+"/GIEXItmperilGroupedController?action=getGIEXS007B480GrpInfo",{
				method:"POST",
				evalScripts: true,
				asynchronous: true,
				parameters: {policyId: policyId},
					onComplete: function(response) {
						hideNotice();
					}
			});
		} catch(e){
			showErrorMessage("showItmPerilGrpInfo", e);
		}
	}
	
	function showEditItmPeril(){
		try {
			new Ajax.Updater("itmPerilInfoDiv", contextPath+"/GIEXItmperilController?action=getGIEXS007B490Info",{
				method:"POST",
				evalScripts: true,
				asynchronous: true,
				parameters: {policyId: null,
										 itemNo: null},
					onComplete: function(response) {
						hideNotice();
					}
			});
		} catch(e){
			showErrorMessage("showEditItmPeril", e);
		}
	}

	function showEditItmPerilGrp(){
		try {
			new Ajax.Updater("itmPerilInfoDiv", contextPath+"/GIEXItmperilGroupedController?action=getGIEXS007B490GrpInfo",{
				method:"POST",
				evalScripts: true,
				asynchronous: true,
				parameters: {policyId: null,
										 itemNo: null},
					onComplete: function(response) {
						hideNotice();
					}
			});
		} catch(e){
			showErrorMessage("showEditItmPerilGrp", e);
		}
	}
	
	function updateButtons(action){
		if (action == 'create'){
			$("btnCrtePrls").value = 'Recreate Peril(s)';
			enableButton("btnDelPerls");
			enableButton("btnEditTax");
			enableButton("btnEditDed");
		}else{
			$("btnCrtePrls").value = 'Create Peril(s)';
			disableButton("btnDelPerls");
			disableButton("btnEditTax");
			disableButton("btnEditDed");
		}
	}
	
	/*function showPerilDetails(){
	if ($F("txtIsGpa") == 'Y'){
		showItmPerilGrpInfo($F("txtB240PolicyId"));
		showEditItmPerilGrp();
	}else{
		showItmPerilInfo($F("txtB240PolicyId"));
		showEditItmPeril();
	}
	} comment by joanne, replace by code below, add condition for package*/
	function showPerilDetails(isPack){
		if ($F("txtIsGpa") == 'Y'){
			if (isPack != null){//joanne
				showItmPerilGrpInfo(null);
			}else{
				showItmPerilGrpInfo($F("txtB240PolicyId"));
			}
			showEditItmPerilGrp();
		}else{
			if (isPack != null){ //joanne
				showItmPerilInfo(null);
			}else{
				showItmPerilInfo($F("txtB240PolicyId"));
			}
			showEditItmPeril();
		}
	}
	
	function deletePerilGIEXS007(){
		try{
			var delAction = '';
			if ($F("txtIsGpa") == 'Y'){
				delAction = "/GIEXItmperilGroupedController?action=deletePerilGrpGIEXS007";
			}else{
				delAction = "/GIEXItmperilController?action=deletePerilGIEXS007";
			}
			new Ajax.Request(contextPath+delAction, {
				method: "POST",
				parameters: {policyId: 			$F("txtB240PolicyId"),
										summarySw: 	$F("txtSummarySw"),
										lineCd: 				$F("txtLineCd"),
										sublineCd: 			$F("txtSublineCd"),
										issCd: 					$F("txtIssCd"),
										nbtIssueYy: 		$F("txtNbtIssueYy"),
										nbtPolSeqNo: 	$F("txtNbtPolSeqNo"),
										nbtRenewNo: 	$F("txtNbtRenewNo"),
										packPolFlag: 		$F("txtPackPolFlag")
				},
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						showPerilDetails();
						updateButtons('delete');
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}catch(e) {
			showErrorMessage("deletePerilGIEXS007", e);
		}
	}
	
	function createPerilGIEXS007(){
		try{
			var createAction = "";
			if($F("txtIsGpa") == "Y"){
				createAction = "/GIEXItmperilGroupedController?action=createPerilGrpGIEXS007";
			}else{
				createAction = "/GIEXItmperilController?action=createPerilGIEXS007";
			}
			new Ajax.Request(contextPath+createAction, {
				method: "POST",
				parameters: {policyId: 				$F("txtB240PolicyId"),
										packPolicyId: 		$F("txtB240PackPolicyId"),
										summarySw: 		$F("txtSummarySw"),
										lineCd: 					$F("txtLineCd"),
										sublineCd: 				$F("txtSublineCd"),
										issCd: 						$F("txtIssCd"),
										nbtIssueYy: 			$F("txtNbtIssueYy"),
										nbtPolSeqNo: 		$F("txtNbtPolSeqNo"),
										nbtRenewNo: 		$F("txtNbtRenewNo"),
										packPolFlag: 			$F("txtPackPolFlag"),
										itemNo:					itemNo,
										groupedItemNo: groupedItemNo,
										recomputeTax:	recomputeTax,
										taxSw:					$F("txtTaxSw"),
										forDelete:				forDelete
				},
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						showPerilDetails();
						updateButtons('create');
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}catch(e) {
			showErrorMessage("createPerilGIEXS007", e);
		}
	}
	
	function recreatePerilGIEXS007(){ //Added by Jerome Bautista 10.01.2015 SR 18536
		try{
			var createAction = "";
			if($F("txtIsGpa") == "Y"){
				createAction = "/GIEXItmperilGroupedController?action=createPerilGrpGIEXS007";
			}else{
				createAction = "/GIEXItmperilController?action=createPerilGIEXS007";
			}
			new Ajax.Request(contextPath+createAction, {
				method: "POST",
				parameters: {policyId: 				$F("txtB240PolicyId"),
										packPolicyId: 		$F("txtB240PackPolicyId"),
										summarySw: 		$F("txtSummarySw"),
										lineCd: 					$F("txtLineCd"),
										sublineCd: 				$F("txtSublineCd"),
										issCd: 						$F("txtIssCd"),
										nbtIssueYy: 			$F("txtNbtIssueYy"),
										nbtPolSeqNo: 		$F("txtNbtPolSeqNo"),
										nbtRenewNo: 		$F("txtNbtRenewNo"),
										packPolFlag: 			$F("txtPackPolFlag"),
										itemNo:					itemNo,
										groupedItemNo: groupedItemNo,
										recomputeTax:	recomputeTax,
										taxSw:					$F("txtTaxSw"),
										forDelete:				forDelete
				},
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if ($F("txtIsGpa") == 'Y'){
							if (isPack != null){//joanne
								showItmPerilGrpInfo(null);
							}else{
								showItmPerilGrpInfo($F("txtB240PolicyId"));
							}
							showEditItmPerilGrp();
						}else{
							if (isPack != null){ //joanne
								showItmPerilInfo(null);
							}else{
								showItmPerilInfo($F("txtB240PolicyId"));
							}
							b490Grid.url = contextPath + "/GIEXItmperilController?action=getGIEXS007B490Info&refresh=1&mode=1&policyId=&itemNo=";
							b490Grid.refresh();
							/* b490Grid.keys.removeFocus(b490Grid.keys._nCurrentFocus, true);
							b490Grid.keys.releaseKeys(); */
						}
						updateButtons('create');
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}catch(e) {
			showErrorMessage("recreatePerilGIEXS007", e);
		}
	}
	
	function deleteOldPeril(initialPerilCd, policyId, itemNo){
		try{
			new Ajax.Request(contextPath+"/GIEXItmperilController?action=deleteOldPEril", {
				method: "POST",
				parameters: {perilCd			: 		initialPerilCd,
										 policyId			:		policyId,
										 itemNo			:		itemNo}
			});
		}catch(e) {
			showErrorMessage("deleteOldPeril", e);
		}
	}
	
	function fetchItmperilDtls(){
		try {
			perilInformationObj.modItmperilDtlObj = objItmPerl.b490Grid.getModifiedRows();
			var modRows = perilInformationObj.modItmperilDtlObj;
			for(var i=0; i<modRows.length;  i++){
				var perilCd = modRows[i].perilCd;
				var initialPerilCd = modRows[i].initialPerilCd;
				var policyId = modRows[i].policyId;
				var itemNo = modRows[i].itemNo;
				if (initialPerilCd != perilCd){
					deleteOldPeril(initialPerilCd, policyId, itemNo);
				}
			}
			perilInformationObj.addItmperilDtlObj = objItmPerl.b490Grid.getNewRowsAdded().concat(modRows);
			perilInformationObj.delItmperilDtlObj = objItmPerl.b490Grid.getDeletedRows();
			
			saveAction = "/GIEXItmperilController?action=saveGIEXItmperil";
		} catch (e){
			showErrorMessage("fetchItmperilDtls", e);
		}
	}
	
	function fetchItmperilGrpDtls(){
		try {
			perilInformationObj.modItmperilDtlObj = objItmPerlGrp.b490GrpGrid.getModifiedRows();
			perilInformationObj.addItmperilDtlObj = objItmPerlGrp.b490GrpGrid.getNewRowsAdded();
			perilInformationObj.delItmperilDtlObj = objItmPerlGrp.b490GrpGrid.getDeletedRows();
			
			saveAction = "/GIEXItmperilGroupedController?action=saveGIEXItmperilGrouped";
		} catch (e){
			showErrorMessage("fetchItmperilGrpDtls", e);
		}
	}
	
	function saveAcknowledgmentReceipt(){
		new Ajax.Request(contextPath+saveAction,{
			method: "POST",
			parameters: {
				parameters: JSON.stringify(perilInformationObj),
				recomputeTax: 'N',
				taxSw: $F("txtTaxSw"),
				policyId: $F("txtB240PolicyId"),
				packPolicyId: $F("txtB240PackPolicyId"),
				summarySw: 	$F("txtSummarySw"), //joanne 07.01.14
				groupedItemNo: objItmPerl.b480Row.groupedItemNo //Added by Jerome Bautista 12.03.2015 SR 21016
			},
			evalScripts: true,
			asynchronous: false,
			onCreate: function (){
				showNotice("Saving Peril Information. Please wait...");
			},
			onSuccess: function (response){
				hideNotice("");
				if (checkErrorOnResponse(response)){
					if (response.responseText == "SUCCESS"){
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							showEditPerilInformationPage(objGIEXExpiry.packPolicyId, objGIEXExpiry.policyId);
						});
						changeTag = 0;
					}
				}
			}
		});	
	}
	
	$("btnEditTax").observe("click", function () {
		if(changeTag == 1) {
			showMessageBox("Please save changes first before pressing the EDIT TAX/CHARGES button.");
			return false;
		}else{
			if(objItmPerl.b480Row == null){
				showMessageBox("Please select an item first.", "I");
			}else if(objItmPerl.b490Row == null){
				showMessageBox("Please select a peril first.", "I");
			}else{
				editTaxCharges("getGIEXS007B880Info");
			}
		}
	});
	
	$("btnEditDed").observe("click", function () {
		if(changeTag == 1) {
			showMessageBox("Please save changes first before pressing the EDIT DEDUCTIBLES button.");
			return false;
		}else{
/* 			if(objItmPerl.b480Row == null){ // comment out by andrew - 1.9.2012
				showMessageBox("Please select an item first.", "I");
			}else if(objItmPerl.b490Row == null){
				showMessageBox("Please select a peril first.", "I");
			}else{ */
				editDeductibles();
			//}
		}
	});
	
	//added by joanne 06.30.14
	function savePerilInfo(){
		if($F("txtIsGpa") == 'Y'){
			fetchItmperilGrpDtls();
		}else{
			fetchItmperilDtls();
		}
		saveAcknowledgmentReceipt();
		$("changePerilTag").value = "N"; 
	}
	
	$("btnSave").observe("click", function () {
		//added by joanne 041514, inform that %TSI deductibles will be recomputed and updated
		if($("changePerilTag").value=="Y"){
			try{
				new Ajax.Request(contextPath+"/GIEXNewGroupDeductiblesController?action=countTsiDed", {
					method: "POST",
					parameters: {	policyId					: 	$F("txtB240PolicyId")		
					},
					evalScripts: true,
					asynchronous: false,
					onComplete: function(response){
						if(JSON.parse(response.responseText)!="0"){
							showWaitingMessageBox("Amounts of existing deductible/s based on % of TSI will be recomputed.","I",savePerilInfo);
						}else{ //marco - 09.01.2014
							savePerilInfo();
						}
					}
				});
			}catch(e) {
				showErrorMessage("countTsiDed", e);
			}
		}else{
			savePerilInfo();
		}
		/*if($F("txtIsGpa") == 'Y'){
			fetchItmperilGrpDtls();
		}else{
			fetchItmperilDtls();
		}
		saveAcknowledgmentReceipt();
		$("changePerilTag").value = "N"; //joanne 02.18.14*/
	});

	$("btnExit").observe("click", function(){
		$("changePerilTag").value = "N"; //joanne 02.18.14
		objGIEXExpiry.exitSw = "Y"; //Added by Jerome Bautista 04.22.2016 SR 21993
		showProcessExpiringPoliciesPage();
	}); 
	
	$("btnCancel").observe("click", function(){
		$("changePerilTag").value = "N"; //joanne 02.18.14
		objGIEXExpiry.exitSw = "Y"; //Added by Jerome Bautista 04.22.2016 SR 21993
		showProcessExpiringPoliciesPage();
	}); 
	
	$("btnDelPerls").observe("click", function(){
		showConfirmBox("Confirm","Are you sure that you want to delete all edited perils for this policy?","Yes","No",deletePerilGIEXS007,"");
	});
	
	$("btnCrtePrls").observe("click", function(){
		if($F("btnCrtePrls") == 'Recreate Peril(s)'){
			showConfirmBox("Confirm","Existing edited perils for this policy will be deleted and will be replaced by extracted perils for this policy. Do you want to continue?","Yes","No",recreatePerilGIEXS007,""); //Modified by Jerome Bautista 10.01.2015 SR 18536
		}else{
			createPerilGIEXS007();
		}
	});

	function setB240Info(row) {
		try {
			if(row != null) {
				$("txtPolicyNo").value 						    = row.lineCd +"-" + row.sublineCd +"-" + row.issCd  +"-" + Number(row.nbtIssueYy).toPaddedString(2)
				  													+"-" + Number(row.nbtPolSeqNo).toPaddedString(7)  +"-" + Number(row.nbtRenewNo).toPaddedString(2);
				if (row.isPack != null){
					$("txtPackageNo").value 					    = row.dspPackLineCd +"-" + row.dspPackSublineCd +"-" + row.dspPackIssCd  +"-" + Number(row.dspPackIssueYy).toPaddedString(2)
																	+"-" + Number(row.dspPackPolSeqNo).toPaddedString(7)  +"-" + Number(row.dspPackRenewNo).toPaddedString(2);
					showPackSubPolicies(row.packPolicyId,  row.summarySw); //joanne 12.18.13
					$("txtPolicyNo").value 					=null; //joanne 12.19.13 
				}
				$("txtAssdName").value						=	row.dspAssdName				== null ? "" : unescapeHTML2(row.dspAssdName);
				$("txtInceptDate").value						=	row.strInceptDate 				== null ? "" : row.strInceptDate;
				$("txtB240PolicyId").value					=	row.policyId							== null ? "" : row.policyId;
				$("txtB240PackPolicyId").value			=	row.packPolicyId 				== null ? "" : row.packPolicyId;
				$("txtAssdNo").value								=	row.assdNo 							== null ? "" : row.assdNo;
				$("txtNbtProrateFlag").value				=	row.nbtProrateFlag			== null ? "" : row.nbtProrateFlag;
				$("txtEndtExpiryDate").value				=	row.strEndtExpiryDate		== null ? "" : dateFormat(row.strEndtExpiryDate, "mm-dd-yyyy hh:MM:ss TT");
				$("txtEffDate").value								=	row.strEffDate						== null ? "" : dateFormat(row.strEffDate, "mm-dd-yyyy hh:MM:ss TT");
				$("txtExpiryDate").value						=	row.strExpiryDate				== null ? "" : dateFormat(row.strExpiryDate, "mm-dd-yyyy hh:MM:ss TT");
				$("txtShortRtPercent").value				=	row.shortRtPercent 			== null ? "" : row.shortRtPercent;
				$("txtProvPremPct").value					=	row.provPremPct 				== null ? "" : row.provPremPct;
				$("txtProvPremTag").value					=	row.provPremTag 				== null ? "" : row.provPremTag;
				$("txtPackPolFlag").value						=	row.packPolFlag					== null ? "" : row.packPolFlag;
				$("txtSummarySw").value					=	row.summarySw 				== null ? "" : row.summarySw;
				$("txtRenewFlag").value						=	row.renewFlag 					== null ? "" : row.renewFlag;
				$("txtLineCd").value							    =	row.lineCd 							== null ? "" : row.lineCd;
				$("txtSublineCd").value						=	row.sublineCd	 					== null ? "" : row.sublineCd;
				$("txtIssCd").value									=	row.issCd	 							== null ? "" : row.issCd;
				$("txtNbtIssueYy").value						=	row.nbtIssueYy					== null ? "" : row.nbtIssueYy;
				$("txtNbtPolSeqNo").value					=	row.nbtPolSeqNo				== null ? "" : row.nbtPolSeqNo;
				$("txtCompSw").value							=	row.compSw						== null ? "" : row.compSw;
				$("txtNbtRenewNo").value					=	row.nbtRenewNo				== null ? "" : row.nbtRenewNo;
				$F("txtIsGpa").value								=	row.isGpa								== null ? "" : row.isGpa; 
				$("txtTaxSw").value = 'N';
				showPerilDetails(row.isPack);//joanne
				if (row.buttonSw == 'Y'){
					$("btnCrtePrls").value = 'Recreate Peril(s)';
					enableButton("btnDelPerls");
					enableButton("btnEditTax");
					enableButton("btnEditDed");
				}else{
					$("btnCrtePrls").value = 'Create Peril(s)';
					disableButton("btnDelPerls");
					disableButton("btnEditTax");
					disableButton("btnEditDed");
				}
			}
		} catch(e) {
			showErrorMessage("setB240Info", e);
		}
	}
	setB240Info(objUW.expiry);
	
	observeReloadForm("reloadForm", function(){
		showEditPerilInformationPage(objGIEXExpiry.packPolicyId, objGIEXExpiry.policyId);
	});
	
	changeTag = 0;
	initializeChangeAttribute();

</script>