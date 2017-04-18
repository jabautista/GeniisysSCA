<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="ajax" uri="http://ajaxtags.org/tags/ajax" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div class="sectionDiv" style="border-top: none;" id="directClaimPaymentsDiv" name="directClaimPaymentsDiv">
	<jsp:include page="subPages/directClaimPaymentListing.jsp"></jsp:include>
	<table style="margin-top: 10px; margin-bottom:10px; margin-left: 7%;">
		<tbody>
			<tr>
				<td class="rightAligned" style="width: 130px;">Transaction Type</td>
				<td class="leftAligned" style="width: 240px;" >
					<select style="width: 215px;" id="selTransactionType" name="selTransactionType" title="Transaction Type" class="required">
						<option></option>
						<c:forEach var="transLov" items="${transactionTypeLOV}" >
							<option value="${transLov.rvLowValue}">${transLov.rvLowValue} - ${transLov.rvMeaning}</option>
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" style="width: 150px;">Claim No.</td>
				<td style="width: 240px;" class="leftAligned">
					<input type="text" id="txtClaimNumber" name="txtClaimNumber" title="Claim Number" readonly="readonly" style="width: 230px;" value=""/>
				</td>
			</tr>
			<tr>
				<%-- <td class="rightAligned">Advice No</td>
				<td class="leftAligned">
					<div style="width: 215px;">
						<input type="text" id="txtAdviceSequence" name="txtAdviceSequence" style="width: 182px;" class="required" readonly="readonly" value="" />
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="searchAdvice" />
					</div>
				</td> --%>
				<td class="rightAligned">Advice No</td>
				<td class="leftAligned">
					<input type="text" id="txtLineCd" name="capsField" class="required" style="width: 35px;" maxlength="2" value="" />
					<%-- <img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" style="width: 14px; height: 14px;" alt="Edit" id="searchLine" /> --%>
					<input type="text" id="txtIssCd" name="capsField" class="required" style="width: 35px;" maxlength="2" value="" />
					<%-- <img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" style="width: 14px; height: 14px;" alt="Edit" id="searchIss" /> --%>
					<input type="text" id="txtAdviceYear" name="txtAdviceYear" class="required" style="width: 35px;" maxlength="5" value="" />
					<%-- <img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" style="width: 14px; height: 14px;" alt="Edit" id="searchAdvYy" /> --%>
					<input type="text" id="txtAdvSeqNo" name="txtAdvSeqNo" class="required" style="width: 40px;" maxlength="6" value="" />
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" style="width: 15px; height: 15px;" alt="Edit" id="searchAdvice2" />
				</td>
				<td class="rightAligned" style="">Policy No.</td>
				<td class="leftAligned">
					<input type="text" 	id="txtPolicyNumber" name="txtPolicyNumber" title="Policy Number" readonly="readonly" style="width: 230px;" value=""/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Payee Class</td>
				<td style="width: 210px;" class="leftAligned">
					<div id="payeeClassDiv" name="payeeClassDiv">
						<!-- <select id="selPayeeClass" name="selPayeeClass" title="Payee Class" class="required" readonly="readonly"="disabled" style="width: 215px;">
							<option></option>
						</select> -->
						<input type="hidden" id="tempPolicyNo" 	name="tempPolicyNo"	value="${policyNumber}"/>
						<input type="hidden" id="tempClaimNo" 	name="tempClaimNo" 	value="${claimNumber}"/>
						<input type="hidden" id="temp"	name="temp"	value="${Name}"/>
						
						<input type="hidden" id="payeeType" name="payeeType" value="" />
						<input type="hidden" id="payeeClassCd" name="payeeClassCd" value="" />
						<input type="hidden" id="claimLossId" name="claimLossId" value="" />
						<input type="hidden" id="selectedPayee" name="selectedPayee" value="" />
						<input type="hidden" id="payeeCode" name="payeeCode" value="" />
						
						<input type="text" id="selPayeeClass2" name="selPayeeClass2" readonly="readonly" class="required" style="width: 195px;" />
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" style="width: 15px; height: 15px;" alt="Edit" id="searchPayee" />
					
					</div>
				</td>
				<td class="rightAligned">Payee</td>
				<td class="leftAligned">
					<input type="text" id="txtPayee" name="txtPayee" title="Payee" readonly="readonly" style="width: 230px;" value=""/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Peril</td>
				<td class="leftAligned">
					<input type="text" id="txtPeril" name="txtPeril" class="required" readonly="readonly" title="Peril" value="" style="width: 207px;">
					<input type="hidden" id="hidPerilCd" name="hidPerilCd" 	value=""/>
				</td>
				<td class="rightAligned">Assured Name</td>
				<td class="leftAligned">
					<input type="text" id="txtAssuredName" name="txtAssuredName" title="Assured Name" readonly="readonly" style="width: 230px;" value=""/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Disbursement Amount</td>
				<td class="leftAligned">
					<input type="text" id="txtDisbursementAmount" 	name="txtDisbursementAmount" title="Disbursement Amount" class="money required" readonly="readonly" style="width: 207px;" value="0"/>
				</td>
				<td class="rightAligned">Remarks</td>
				<td class="leftAligned">
					<div style="border: 1px solid gray; height: 20px; width: 236px;">
						<textarea onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);" title="Remarks" 
									style="width: 210px; border: none; height: 13px;" id="txtRemarks" name="txtRemarks"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Input Tax</td>
				<td class="leftAligned">
					<input type="text" id="txtInputTax" name="txtInputTax" title="Input Tax" readonly="readonly" style="width: 207px;" class="money" value="0"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Withholding Tax</td>
				<td class="leftAligned">
					<input type="text" style="width: 207px;" id="txtWithholdingTax" title="Withholding Tax" readonly="readonly" name="txtWithholdingTax" class="money" value="0"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Net Disbursement</td>
				<td class="leftAligned">
					<input type="text" style="width: 207px;" id="txtNetDisbursement" name="txtNetDisbursement" title="Net Disbursement" class="money required" readonly="readonly" value="0"/>
				</td>
			</tr>
			<tr style="display: none;">
				<td class="rightAligned">Advice No(Old)</td>
				<td class="leftAligned">
					<div style="width: 215px;">
						<input type="text" id="txtAdviceSequence" name="txtAdviceSequence" style="width: 182px;" class="required" readonly="readonly" value="" />
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="searchAdvice" />
					</div>
				</td>
			</tr>
		</tbody>
	</table>
	<div id="directClaimButtonsDiv" style=" margin-left: 210px; margin-bottom: 20px;" align="left">
		<input type="button" id="btnClaimAdvice" class="disabledButton" value="Claim Advice" />
		<input type="button" id="btnBatchClaim" class="disabledButton" value="Batch Claim Settlement" />
		<input type="button" id="btnForeignCurrencyDcp" class="button" value="Foreign Currency"/>
		<input type="button" id="btnAddDirectClaimPayment" class="button" value="Add"/>
		<input type="button" id="btnRemoveDirectClaimPayment" class="button" value="Delete"/>
	</div>
	
		<div id="directClaimCurrencyDiv" style="display: none;">
			<table border="0" align="center" style="margin:10px auto;">
				<tr>
					<td class="rightAligned" style="width: 123px;">Currency Code</td>
					<td class="leftAligned"  >
						<input type="text" style="width: 50px; text-align: left" id="dcpCurrencyCode" name="dcpCurrencyCode" value="" class="required integerNoNegativeUnformattedNoComma deleteInvalidInput" 
						errorMsg="Entered currency code is invalid. Valid value is from 1 to 99." maxlength="2"/>
					</td>
					<td class="rightAligned" style="width: 180px;">Convert Rate</td>
					<td class="leftAligned"  >
						<input type="text" style="width: 100px; text-align: right" class="moneyRate required" id="dcpConvertRate" name="dcpConvertRate" value="" maxlength="13"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" >Currency Description</td>
					<td class="leftAligned"  >
						<input type="text" style="width: 170px; text-align: left" id="dcpCurrencyDesc" name="dcpCurrencyDesc" value="" readonly="readonly"/></td>
					<td class="rightAligned" >Foreign Currency Amount</td>
					<td class="leftAligned"  >
						<input type="text" style="width: 170px; text-align: right" class="money required" id="dcpForeignCurrencyAmt" name="dcpForeignCurrencyAmt" value="" maxlength="18"/>
					</td>
				</tr>
				<tr>
					<td width="100%" style="text-align: center;" colspan="4">
						<input type="button" style="width: 80px;" id="btnHideDcpCurrencyDiv" class="button" value="Return"/>
					</td>
				</tr>
			</table>
		</div>	
	<div id="directClaimMainButton" name="directClaimMainButton" style="margin-bottom:10px;" >
		<input type="button" id="btnDirectClaimSave" class="button" value="Save"/>
		<input type="button" id="btnDirectClaimCancel" class="button" value="Cancel"/>
	</div>	
</div>

<input type="hidden" id="claimIdAC017" name="claimIdAC017" value=""/>
<input type="hidden" id="adviceIdAC017" name="adviceIdAC017" value=""/>
<input type="hidden" id="lineCdAC017" name="lineCdAC017" value=""/>
<input type="hidden" id="issCdAC017" name="issCdAC017" value=""/>
<input type="hidden" id="yearAC017" name="yearAC017" value=""/>
<input type="hidden" id="sequenceAC017" name="sequenceAC017" value=""/>

<input type="hidden" id="varIssCd" name="varIssCd" value="${varIssCd}" />
<input type="hidden" id="varCurrencyCd" name="varCurrencyCd" value="${varCurrencyCd}" />

<input type="hidden" id="temp" name="temp" value=""/>
<input type="hidden" id="temp2" name="temp2" value=""/>

<div id="dcpAmountsDiv" name="dcpAmountsDiv">
	<input type="hidden" id="hidInputVatAmount" name="hidInputVatAmount" value="0" />
	<input type="hidden" id="hidWithholdingTaxAmount" name="hidWithholdingTaxAmount" value="0"/>
	<input type="hidden" id="hidNetDisbursementAmount" name="hidNetDisbursementAmount" value="0"/>
	
	<input type="hidden" id="totalNetDisbursementAmount" name="totalNetDisbursementAmount" value="0"/>
	<input type="hidden" id="totalInputVatAmount" name="totalInputVatAmount" value="0"/>
	<input type="hidden" id="totalWithholdingTaxAmount" name="totalWithholdingTaxAmount" value="0"/>
</div>

<script type="text/javascript">
//try{
	var enableLOVs = true;
	
	$("btnHideDcpCurrencyDiv").observe("click",function(){
		Effect.Fade($("directClaimCurrencyDiv"), {
			duration: .2
		});	
	});
	
	$("btnForeignCurrencyDcp").observe("click",function(){
		Effect.Appear($("directClaimCurrencyDiv"), {
			duration: .2
		});	
	});
	
	setModuleId("GIACS017");
	setDocumentTitle("Direct Trans - Direct Claim Payts");
	dcpJsonObjectList = new Array();
	// The list of directClaimPayments
	var dcpObjArray 			= JSON.parse('${directClaimPayments}'.replace(/\\/g, '\\\\'));
	var claimLossExpObjArray 	= JSON.parse('${claimLossExpenses}'.replace(/\\/g, '\\\\'));
	var claimsObjArray  		= JSON.parse('${claims}'.replace(/\\/g, '\\\\')); 
	var adviceObjArray  		= JSON.parse('${advices}'.replace(/\\/g, '\\\\'));
	
	var advIssCd1Obj 			= JSON.parse('${adviceIssCdLOV1}'.replace(/\\/g, '\\\\'));
	var advIssCd2Obj 			= JSON.parse('${adviceIssCdLOV2}'.replace(/\\/g, '\\\\'));
	
	function enableAdviceSearch(){
		$("searchAdvice").observe("click", function(){
			openSearchAdvice();
		});
	}
	
	$("searchAdvice").observe("click", function(){
		openSearchAdvice();
	});
	
	disableButton("btnRemoveDirectClaimPayment");
	
	$("editRemarks").observe("click", function (){
		showEditor("txtRemarks", 4000);
	});
	
	$("btnForeignCurrencyDcp").observe("click", function(){
		var params = Form.serialize("itemInformationForm");
	});
	
	$("btnAddDirectClaimPayment").observe("click", function() {
		if(isDirectClaimPaymentValid()){
			var tableContainer = $("directClaimPaymentListing");
			
			if($F("btnAddDirectClaimPayment") == "Add"){
				//var aNewDcpObject 	= makeGIACDirectClaimPaymentsObj();
				//var aNewDcpRow		= makeGIACDirectClaimPaymentRow(aNewDcpObject);
				var newDcpObject 	= createDirectClaimPaytObj();
				var newDcpRow		= getGDCPRow(newDcpObject);
				if($("dcpRow" + $F("txtAdviceSequence")) == null){
					tableContainer.insert(newDcpRow);
					dcpJsonObjectList.push(newDcpObject);
				}else{
					showMessageBox("Direct Claim Payment entry already exists" + e.message ,imgMessage.ERROR);
				}
				
				// >>>>>>>>>>>>>>>>>>>>>> the old one - start
				/* createDirectClaimPaymentRow();
				clearDcpForm(); */
				populateGDCPForm(null);
				//resizeTableToRowNum("directClaimPaymentListing", "dcpRow", 3);
				// <<<<<<<<<<<<<<<<<<<<<< end
				
				resetTableStyle("directClaimPaymentListingDiv", "directClaimPaymentListing", "dcpRow");
				computeDirectClaimPaymentSums();
				
			}else if($("btnAddDirectClaimPayment")=="Update"){
				
			}
			
			disableButton("btnClaimAdvice");
			disableButton("btnBatchClaim");
		}
	});

	/* check the no of rows inside the container
	   if it exceeds the desired number of rows, make the container scrollable
	   parameters: 
	   tableId: id of the container
	   rowName: name of the row
	   rowNos: number of rows desired
	*/
	function resizeTableToRowNum(tableId, rowName, rowNos) {
		if ($$("div#"+tableId+" div[name='"+rowName+"']").size() >= rowNos) {
		  	$(tableId).setStyle("height: "+rowNos*28+"px; overflow-y: auto; width: 103%;");
		  	$(tableId).up("div", 0).setStyle("width: 95%;");
		 } else if ($$("div#"+tableId+" div[name='"+rowName+"']").size() == 0) {
		  	$(tableId).setStyle("height: 20px;");
		 } else {
		 	var tableHeight = $$("div[name='"+rowName+"']").size()*10;
		 	if(tableHeight == 0){
		 		tableHeight = 20;
		 	}
		 	$(tableId).setStyle("height: " + tableHeight +"px; overflow: hidden;");
		 	$(tableId).up("div", 0).setStyle("width: 98%;");
		}
	}
	
	$("selTransactionType").observe("change", function() {
		if($F("selTransactionType") == "1" || $F("selTransactionType") == "2") {
			enableButton("btnClaimAdvice");
			enableButton("btnBatchClaim");
		}
	});

	$("btnRemoveDirectClaimPayment").observe("click", function(){
		$$("div[name='dcpRow']").each(function(row){
			if(row.hasClassName("selectedRow")){
				var id = row.id.substr(6);
				var objToBeDeleted = getJSONObjectAccounting(dcpJsonObjectList,id);
				var longstring = "";
				for(var propertyName in objToBeDeleted) {
					longstring+= propertyName + "==>" + objToBeDeleted[propertyName] + "\n";
				}
				objToBeDeleted.recordStatus = -1;
				Effect.Fade(row,{
					duration: .3
				});
				resizeTableToRowNum("directClaimPaymentListing", "dcpRow", 3);
			}
		});
		clearDcpForm();
		computeDirectClaimPaymentSums();
	});

	$("btnDirectClaimSave").observe("click", function(){
		try{
			if(checkObjectIfChangesExist(dcpJsonObjectList)){
				var addedRows = getAddedJSONObjects(dcpJsonObjectList);
				var modifiedRows = getModifiedJSONObjects(dcpJsonObjectList);
				var delRows 	 = getDeletedJSONObjects(dcpJsonObjectList);
				var setRows		 = addedRows.concat(modifiedRows);
				new Ajax.Request(contextPath + "/GIACDirectClaimPaymentController?action=saveDirectClaimPayments&gaccTranId=" + objACGlobal.gaccTranId, {
					asynchronous: 	false,
					evalScripts: 	true,
					parameters:{
						setRows: prepareJsonAsParameter(setRows),
					 	delRows: prepareJsonAsParameter(delRows)
					},
					onComplete: function(response){
						if(checkErrorOnResponse(response)) {
							if (response.responseText == "SUCCESS"){
								showMessageBox(response.responseText, imgMessage.SUCCESS);
								clearObjectRecordStatus(dcpJsonObjectList); //to clear the record status on JSON Array
								clearDcpForm();
							}else{
								showMessageBox(response.responseText, imgMessage.ERROR);
							}
						}
					}
				});
			}
		}catch(e){
			showErrorMessage("resizeTableToRowNum", e);
		}
	});
	
	function replacement(){
		var tableContainer = $("directClaimPaymentListing");
		for(var i = 0; i < dcpObjArray.length ; i++){
			var newRow = makeGIACDirectClaimPaymentRow(dcpObjArray[i]);
			tableContainer.insert(newRow);
		}
		//computeDirectClaimPaymentSums();
		computeDirectClaimPaytSums(dcpObjArray);
	}
	
	function loadDirectClaimPayments(){
		replacement();
		/*
		var tableContainer = $("directClaimPaymentListing");
		
		for(var i = 0; i < dcpObjArray.length ; i++){
			var newRow = new Element("div");
			newRow.setAttribute("id", 	"dcpRow" + adviceObjArray[i].adviceNo);
			newRow.setAttribute("name", "dcpRow");
			newRow.setAttribute("class","tableRow");
			var properties = "";
			var adviceNum = adviceObjArray[i].adviceNo;

			if(claimLossExpObjArray!=null){
				if(claimLossExpObjArray[0]!=null){
				}else{
				}
			}else{
			}
			
			var payee     = claimLossExpObjArray[i].payee;
			var perilCode = claimLossExpObjArray[i].perilSname;
           	var payeeVal  = dcpObjArray[i].payeeType;
   			if(payeeVal == "L"){
   	   			payeeVal = "Loss";
   	   		}else if(payeeVal == "E"){
   	   			payeeVal = "Expense";
   	   		}
   	   		
    		var payeeShrt = "";
    		if(payee.length > 14){
        		payeeShrt = payee.substr(0,13) + "...";
    		}else{
        		payeeShrt = payee;
        	}
    		
    		var aDcpObj = makeGIACDirectClaimPaymentsObj();
			properties = prepareDirectClaimPaymentContents(aDcpObj);
			dcpJsonObjectList.push(aDcpObj);
    		newRow.update(properties);
		    addDcpRowEvents(newRow);
			tableContainer.insert(newRow);
		}
		computeDirectClaimPaymentSums();
		*/
	}

	$("btnDirectClaimCancel").observe("click", function() {
		fireEvent($("acExit"), "click");
	});
	
	$("searchAdvice2").observe("click", function() {
		//showAdvSeqNoLOV(tranType, lineCd, issCd, advYear, advSeqNo, vIssCd)
		if($F("selTransactionType")=="") {
			showMessageBox("Please enter a transaction type first.", imgMessage.ERROR);
			return;
		}
		if(enableLOVs) {
			showAdvSeqNoLOV(
				$F("selTransactionType"), $F("txtLineCd"), $F("txtIssCd"),
				$F("txtAdviceYear"), $F("txtAdvSeqNo"), $F("varIssCd")
			);
		}
	});
	
	$("searchPayee").observe("click", function() {
		if($F("selTransactionType")=="" || $F("txtLineCd") == "" || $F("txtIssCd") == "" || $F("txtAdviceYear") == "") {
			showMessageBox("List of Values not available.");
		} else if(enableLOVs){
			showPayeeClassLOV($F("selTransactionType"), $F("txtLineCd"), $F("adviceIdAC017"), $F("claimIdAC017"));
		}
	});
	
	$("btnClaimAdvice").observe("click", function() {
		var contentDiv = new Element("div", {id: "modal_claim_advice"});
		var contentHTML = '<div id="modal_claim_advice"></div>';
		
		adviceOverlay = Overlay.show(contentHTML, {
			id: 'modal_dialog_advice',
			title: "Claim Advice Listing",
			width: 480,
			height: 360,
			draggable: true,
			closable: true
		});
		
		new Ajax.Updater("modal_claim_advice", contextPath+"/GIACDirectClaimPaymentController?action=showClaimAdviceModal&refresh=0&lineCd="+
				$F("txtLineCd")+"&issCd="+$F("txtIssCd")+"&adviceYear="+$F("txtAdviceYear")+"&adviceSeqNo="+$F("txtAdvSeqNo")+
				"&riIssCd="+$F("varIssCd")+"&tranType="+$F("selTransactionType"), {
			evalScripts: true,
			asynchronous: false,
			onComplete: function (response) {			
				if (!checkErrorOnResponse(response)) {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
		
	});
	
	loadDirectClaimPayments();
	hideNotice();
	initializeAllMoneyFields();
	
/* }catch(e){ // counter dcp size:
	showErrorMessage("loadDirectClaimPayments", e);
	// showMessageBox("Error in Direct Claim Payments page, "+e.message, imgMessage.ERROR);
} */
</script>