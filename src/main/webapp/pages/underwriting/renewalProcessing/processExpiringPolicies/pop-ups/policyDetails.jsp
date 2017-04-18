<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<div id="policyDetailsDiv" name="policyDetailsDiv"  changeTagAttr="true">
	<span class="notice" id="noticePopup" name="noticePopup" style="display: none;">Saving, please wait...</span>
	<form id="policyDetailsForm" name="policyDetailsForm" style="margin: auto;">
				
		<div class="sectionDiv" >
			<table align="center" style="width: 100%; margin: 10px;">
				<tr>
					<td class="rightAligned" style="width: 140px;">
						<c:if test="${packPolicyId > 0}">
							Package Policy No.
						</c:if>	
					</td>
					<td class="leftAligned">
						<c:if test="${packPolicyId > 0}">
							<span class="" style="">
								<input id="dspPackPolicyId" type="hidden" >
								<input id="dspPackLineCd" class="leftAligned upper" type="text" name="dspPackLineCd" style="width: 7%;" value="" title="Line Code" maxlength="2" readonly="readonly"/>
								<input id="dspPackSublineCd" class="leftAligned upper" type="text" name="dspPackSublineCd" style="width: 13%;" value=""  title="Subline Code"maxlength="7" readonly="readonly"/>
								<input id="dspPackIssCd" class="leftAligned upper" type="text" name="dspPackIssCd" style="width: 7%;" value=""  title="Issource Code"maxlength="2" readonly="readonly"/>
								<input id="dspPackIssueYy" class="leftAligned" type="text" name="dspPackIssueYy" style="width: 7%;" value=""  title="Year" maxlength="2" readonly="readonly"/>
								<input id="dspPackPolSeqNo" class="leftAligned" type="text" name="dspPackPolSeqNo" style="width: 13%;" value=""  title="Policy Sequence Number" maxlength="6" readonly="readonly"/>
								<input id="dspPackRenewNo" class="leftAligned" type="text" name="dspPackRenewNo" style="width: 7%;" value=""  title="Renew Number" maxlength="2" readonly="readonly"/>
							 </span>
						</c:if>		
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 140px;">Policy No.</td>
					<td class="leftAligned">
						<span class="" style="">
							<input id="basicPolicyId" type="hidden" >
							<input id="basicLineCd" class="leftAligned upper" type="text" name="basicLineCd" style="width: 7%;" value=""  title="Line Code" maxlength="2" readonly="readonly"/>
							<input id="basicSublineCd" class="leftAligned upper" type="text" name="basicSublineCd" style="width: 13%;" value=""  title="Subline Code"maxlength="7" readonly="readonly"/>
							<input id="basicIssCd" class="leftAligned upper" type="text" name="basicIssCd" style="width: 7%;" value=""  title="Issource Code"maxlength="2" readonly="readonly"/>
							<input id="basicIssueYy" class="leftAligned" type="text" name="basicIssueYy" style="width: 7%;" value=""  title="Year" maxlength="2" readonly="readonly"/>
							<input id="basicPolSeqNo" class="leftAligned" type="text" name="basicPolSeqNo" style="width: 13%;" value=""  title="Policy Sequence Number" maxlength="6" readonly="readonly"/>
							<input id="basicRenewNo" class="leftAligned" type="text" name="basicRenewNo" style="width: 7%;" value=""  title="Renew Number" maxlength="2" readonly="readonly"/>
						 </span>	
					</td>
				</tr>
			</table>
		</div>
		<div class="sectionDiv">
			<div id="innerDiv" name="innerDiv" style="background-color: #ccc">
				<label>Unsettled Accounts</label>
			</div>
			<div id="invoiceTableGrid" style="position:relative; height: 150px; margin-left: 4%; margin-top: 10px; margin-bottom: 10px; float: left"></div>
		</div>
		<div class="sectionDiv">
			<div id="innerDiv" name="innerDiv" style="background-color: #ccc">
				<label>Claims</label>
			</div>
			<div id="claimsTableGrid" style="position:relative; height: 150px; margin-left: 4%; margin-top: 10px; margin-bottom: 10px; float: left"></div>
		</div>
	</form>
</div>
<div class="buttonsDivPopup">
	<input type="button" class="button" id="btnClaimsInfo" name="btnClaimsInfo" value="Claims Information" style="width:150px;" />
	<input type="button" class="button" id="btnClose" name="btnClose" value="Close" style="width: 150px;" />
</div>
<script>

	var objPolDet = new Object(); 
	var selectedPolDet = null;
	var selectedPolDetRow = new Object();
	var mtgId = null;
	objPolDet.invoiceTableGrid = JSON.parse('${polDetailsGrid}'.replace(/\\/g, '\\\\'));
	objPolDet.polDet= objPolDet.invoiceTableGrid.rows || [];
	
	try {
		var polDetListingTable = {
			url: contextPath+"/GIEXExpiriesVController?action=refreshBasicDetails&packPolicyId="+'${packPolicyId}'+"&policyId="+'${policyId}',
			options: {
				width: '540px',
				height: '120px'
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
					id: 'invoiceNo',
					title: 'Invoice No.',
					width: '200',
					titleAlign: 'left',
					align: 'left',
					editable: false
				}, 
				{
					id: 'balanceDue',
					title: 'Balance Amount Due',
					width: '200',
					titleAlign: 'right',
					align: 'right',
					geniisysClass: 'money',
					editable: false
				}, 
				{
					id: 'dueDate',
					title: 'Due Date',
					type: 'date',
					width: '128',
					titleAlign: 'center',
					align: 'center',
					editable: false
				}
			],
			resetChangeTag: true,
			rows: objPolDet.polDet
		};
		polDetailsGrid = new MyTableGrid(polDetListingTable);
		polDetailsGrid.pager = objPolDet.invoiceTableGrid;
		polDetailsGrid.render('invoiceTableGrid');
	}catch(e) {
		showErrorMessage("polDetailsGrid", e);
	}
	
	var objPolClms = new Object(); 
	var selectedPolClms = null;
	var selectedPolClmsRow = new Object();
	var mtgId = null;
	objPolClms.claimsTableGrid = JSON.parse('${claimDetailsGrid}'.replace(/\\/g, '\\\\'));
	objPolClms.polClms= objPolClms.claimsTableGrid.rows || [];
	
	try {
		var polClmsListingTable = {
			url: contextPath+"/GIEXExpiriesVController?action=refreshClaimDetails&packPolicyId="+'${packPolicyId}'+"&policyId="+'${policyId}',
			options: {
				width: '540px',
				height: '120px',
				onCellFocus: function(element, value, x, y, id) {
					mtgId = polClaimsGrid._mtgId;
					selectedPolClms = y;
					if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")) {
						selectedPolClmsRow = polClaimsGrid.geniisysRows[y];
						objCLMGlobal.claimId = selectedPolClmsRow.claimId;
					}
				},
				onRemoveRowFocus : function(){
					objCLMGlobal.claimId = null;
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
					id: 'claimNo',
					title: 'Claim No.',
					width: '110',
					titleAlign: 'left',
					align: 'left',
					editable: false
				}, 
				{
					id: 'lossResAmt',
					title: 'Claim Amount',
					width: '108',
					titleAlign: 'right',
					align: 'right',
					geniisysClass: 'money',
					editable: false
				}, 
				{
					id: 'lossPdAmt',
					title: 'Paid Amount',
					width: '108',
					titleAlign: 'right',
					align: 'right',
					geniisysClass: 'money',
					editable: false
				}, 
				{
					id: 'clmFileDate',
					title: 'Filed Date',
					type: 'date',
					width: '90',
					titleAlign: 'center',
					align: 'center',
					editable: false
				},
				{
					id: 'clmStatDesc',
					title: 'Status',
					width: '108',
					titleAlign: 'left',
					align: 'left',
					editable: false
				}
			],
			resetChangeTag: true,
			rows: objPolClms.polClms
		};
		polClaimsGrid = new MyTableGrid(polClmsListingTable);
		polClaimsGrid.pager = objPolClms.claimsTableGrid;
		polClaimsGrid.render('claimsTableGrid');
	}catch(e) {
		showErrorMessage("polClaimsGrid", e);
	}
	
	function getPackDetailsHeader(){
		try{
			new Ajax.Request(contextPath+"/GIEXExpiriesVController?action=getPackDetailsHeader", {
					evalScripts: true,
					asynchronous: false,
					method: "GET",
					parameters: {
						packPolicyId: '${packPolicyId}',
						policyId: '${policyId}'
					},
					onComplete: function(response) {
						if (checkErrorOnResponse(response)) {
							var result = response.responseText.toQueryParams();
							$("basicPolicyId").value = result.basicPolicyId;
							$("basicLineCd").value = result.basicLineCd;
							$("basicSublineCd").value = result.basicSublineCd;
							$("basicIssCd").value = result.basicIssCd;
							$("basicIssueYy").value =  formatNumberDigits(result.basicIssueYy, 2);
							$("basicPolSeqNo").value =  formatNumberDigits(result.basicPolSeqNo, 7);
							$("basicRenewNo").value =  formatNumberDigits(result.basicRenewNo, 2);
							$("dspPackPolicyId").value = result.dspPolicyId;
							$("dspPackLineCd").value = result.dspLineCd;
							$("dspPackSublineCd").value = result.dspSublineCd;
							$("dspPackIssCd").value = result.dspIssCd;
							$("dspPackIssueYy").value =formatNumberDigits(result.dspIssueYy, 2);
							$("dspPackPolSeqNo").value = formatNumberDigits(result.dspPolSeqNo, 7);
							$("dspPackRenewNo").value = formatNumberDigits(result.dspRenewNo, 2);
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}
				});
		}catch(e) {
			showErrorMessage("getPackDetailsHeader", e);
		}
	}
	
	function checkPolId(){
		if( '${packPolicyId}' != 0){
			$("dspPackLineCd").disable();
			$("dspPackSublineCd").disable();
			$("dspPackIssCd").disable();
			$("dspPackIssueYy").disable();
			$("dspPackPolSeqNo").disable();
			$("dspPackRenewNo").disable();
		}
	}
	
	function checkBtnClaimsInfo(){
		if(objPolClms.polClms == ""){
			disableButton("btnClaimsInfo");
		}
	}

	$("btnClose").observe("click", function(){
		objCLMGlobal.claimId = null;
		Modalbox.hide();
	}); 
	
	/* $("btnClaimsInfo").observe("click", function(){
		if(objCLMGlobal.claimId == null){
			showMessageBox("No claims record selected.","I");
		}else{
			//call module GICLS260
		}
	});  */
	
	observeAccessibleModule(accessType.BUTTON, "GICLS260", "btnClaimsInfo",  function(){
		//showMessageBox(objCommonMessage.UNAVAILABLE_MODULE, imgMessage.INFO); // replace if the module is already available christian 01042012
		if(checkUserModule("GIEXS004")){ 		//Kenneth L. 10.21.2013
			objCLMGlobal.callingForm = "GIEXS004";
			Modalbox.hide();
			showClaimInformationMain("claimInfoDiv");
			$("processExpPolMainDiv").hide();
		}
	});
	
	getPackDetailsHeader();
	checkPolId();
	checkBtnClaimsInfo();
	
</script>