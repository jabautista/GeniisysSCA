<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Pragma","no-cache");
%>
<div class="sectionDiv" style="border-top: none;" id="directTransInputVatDiv" name="directTransInputVatDiv">	
	<jsp:include page="subPages/lossesRecovListingTable.jsp"></jsp:include>
	<div>
		<table align="center" border="0" style=" margin:40px auto; margin-top:10px; margin-bottom:20px;">
			<tr>
				<td class="rightAligned" >Transaction Type</td>
				<td class="leftAligned"  >
					<input type="text" id="readOnlyTransactionTypeLossesRecov" name="readOnlyTransactionTypeLossesRecov" value="" class="required" style="width:231px; display:none;" readonly="readonly"/>
					<select id="selTransactionTypeLossesRecov" name="selTransactionTypeLossesRecov" style="width:239px;" class="required">
					<option value=""></option>
						<c:forEach var="transactionType" items="${transactionTypeList }" varStatus="ctr">
							<option value="${transactionType.rvLowValue }" typeDesc="${transactionType.rvMeaning }">${transactionType.rvLowValue } - ${transactionType.rvMeaning }</option>
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" style="width:130px">Particulars</td>
				<td class="leftAligned"  >
					<input type="text" id="txtParticularsLossesRecov" name="txtParticularsLossesRecov" style="width:231px;" value="" readonly="readonly" maxlength="500"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Share Type</td>
				<td class="leftAligned"  >
					<input type="text" id="readOnlyShareTypeLossesRecov" name="readOnlyShareTypeLossesRecov" value="" class="required" style="width:231px; display:none;" readonly="readonly"/>
					<select id="selShareTypeLossesRecov" name="selShareTypeLossesRecov" style="width:239px;" class="required">
					<option value=""></option>
						<c:forEach var="shareType" items="${shareTypeList }" varStatus="ctr">
							<option value="${shareType.rvLowValue }">${shareType.rvMeaning }</option>
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" >Policy No.</td>
				<td class="leftAligned"  >
					<input type="text" id="txtDspPolicyLossesRecov" name="txtDspPolicyLossesRecov" style="width:231px;" value="" readonly="readonly" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Reinsurer</td>
				<td class="leftAligned"  >
					<input type="text" id="readOnlyA180RiCdLossesRecov" name="readOnlyA180RiCdLossesRecov" value="" class="required" style="width:231px; display:none;" readonly="readonly"/>
					<select id="selA180RiCdLossesRecov12" name="selA180RiCdLossesRecov12" style="width:239px;" class="required">
					<option value=""></option>
						<c:forEach var="riCd" items="${reinsurer12List }" varStatus="ctr">
							<option value="${riCd.riCd }">${riCd.riName }</option>
						</c:forEach>
					</select>
					<select id="selA180RiCdLossesRecov13" name="selA180RiCdLossesRecov13" style="width:239px;" class="required">
					<option value=""></option>
						<c:forEach var="riCd" items="${reinsurer13List }" varStatus="ctr">
							<option value="${riCd.riCd }">${riCd.riName }</option>
						</c:forEach>
					</select>
					<select id="selA180RiCdLossesRecov14" name="selA180RiCdLossesRecov14" style="width:239px;" class="required"> <!-- John Dolon; 5.25.2015; SR#2569 - Issues in Losses Recoverable from RI  -->
					<option value=""></option>
						<c:forEach var="riCd" items="${reinsurer14List }" varStatus="ctr">
							<option value="${riCd.riCd }">${riCd.riName }</option>
						</c:forEach>
					</select>
					<select id="selA180RiCdLossesRecov22" name="selA180RiCdLossesRecov22" style="width:239px;" class="required">
					<option value=""></option>
						<c:forEach var="riCd" items="${reinsurer22List }" varStatus="ctr">
							<option value="${riCd.riCd }">${riCd.riName }</option>
						</c:forEach>
					</select>
					<select id="selA180RiCdLossesRecov23" name="selA180RiCdLossesRecov23" style="width:239px;" class="required">
					<option value=""></option>
						<c:forEach var="riCd" items="${reinsurer23List }" varStatus="ctr">
							<option value="${riCd.riCd }">${riCd.riName }</option>
						</c:forEach>
					</select>
					<select id="selA180RiCdLossesRecov24" name="selA180RiCdLossesRecov24" style="width:239px;" class="required"> <!-- John Dolon; 5.25.2015; SR#2569 - Issues in Losses Recoverable from RI -->
					<option value=""></option>
						<c:forEach var="riCd" items="${reinsurer24List }" varStatus="ctr">
							<option value="${riCd.riCd }">${riCd.riName }</option>
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" >Claim No.</td>
				<td class="leftAligned"  >
					<input type="text" id="txtDspClaimNoLossesRecov" name="txtDspClaimNoLossesRecov" style="width:231px;" value="" readonly="readonly" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Final Loss Advice No.</td>
				<td class="leftAligned"  style="background:none;">
					<div style="float: left;">
					<input type="text" style="width:61px;" id="txtE150LineCdLossesRecov"   	name="txtE150LineCdLossesRecov"  	value="" maxlength="2" class="required" />
					<input type="text" style="width:61px;" id="txtE150LaYyLossesRecov"   	name="txtE150LaYyLossesRecov" 		value="" maxlength="2" class="required integerNoNegativeUnformattedNoComma" errorMsg="Entered value is invalid. Valid value is from 0 to 99."/>
					<input type="text" style="width:61px;" id="txtE150FlaSeqNoLossesRecov" 	name="txtE150FlaSeqNoLossesRecov" 	value="" maxlength="5" class="required integerNoNegativeUnformattedNoComma" errorMsg="Entered value is invalid. Valid value is from 0 to 99999."/>
					</div>
					<div style="float:left; margin-left: 4px;"><img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="finalLossAdviceLossesRecDate" name="finalLossAdviceLossesRecDate" alt="Go" /></div>
				</td>
				<td class="rightAligned" >Assured Name</td>
				<td class="leftAligned"  >
					<input type="text" id="txtDspAssuredLossesRecov" name="txtDspAssuredLossesRecov" style="width:231px;" value="" readonly="readonly" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Payee Type</td>
				<td class="leftAligned"  >
					<input type="text" id="txtPayeeTypeLossesRecov" name="txtPayeeTypeLossesRecov" style="width:231px;" value="" readonly="readonly" />
				</td>
				<td>&nbsp;</td>
				<td style="margin:auto;" align="center">
					<input type="button" style="width: 150px;" id="btnCurrencyLossesRecov" class="button" value="Currency Information" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Collection Amount</td>
				<td class="leftAligned"  >
					<input type="text" id="txtCollectionAmtLossesRecov" name="txtCollectionAmtLossesRecov" value="" class="money  required" maxlength="14" style="width:231px;" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td colspan="2" style="margin:auto;" align="center">
					<input type="button" style="width: 80px;" id="btnAddLossesRecov" 	 class="button" value="Add" />
					<input type="button" style="width: 80px;" id="btnDeleteLossesRecov"  class="button" value="Delete" />
				</td>
			</tr>	
		</table>
	</div>
	<div id="currencyLossesRecovDiv" style="display: none;">
		<table border="0" align="center" style="margin:10px auto;">
			<tr>
				<td class="rightAligned" style="width: 123px;">Currency Code</td>
				<td class="leftAligned"  ><input type="text" style="width: 50px; text-align: left" id="currencyCdLossesRecov" name="currencyCdLossesRecov" value="" class="required integerNoNegativeUnformattedNoComma deleteInvalidInput" errorMsg="Entered currency code is invalid. Valid value is from 1 to 99." maxlength="2"/></td>
				<td class="rightAligned" style="width: 180px;">Convert Rate</td>
				<td class="leftAligned"  ><input type="text" style="width: 100px; text-align: right" class="moneyRate required" id="convertRateLossesRecov" name="convertRateLossesRecov" value="" maxlength="13"/></td>
			</tr>
			<tr>
				<td class="rightAligned" >Currency Description</td>
				<td class="leftAligned"  ><input type="text" style="width: 170px; text-align: left" id="currencyDescLossesRecov" name="currencyDescLossesRecov" value="" readonly="readonly"/></td>
				<td class="rightAligned" >Foreign Currency Amount</td>
				<td class="leftAligned"  ><input type="text" style="width: 170px; text-align: right" class="money required" id="foreignCurrAmtLossesRecov" name="foreignCurrAmtLossesRecov" value="" maxlength="18"/></td>
			</tr>
			<tr>
				<td width="100%" style="text-align: center;" colspan="4">
					<input type="button" style="width: 80px;" id="btnHideCurrLossesRecovDiv" class="button" value="Return"/>
				</td>
			</tr>
		</table>
	</div>	
</div>	
<div class="buttonsDiv" style="float:left; width: 100%;">	
	<input type="button" style="width: 80px;" id="btnCancelRiTransLossesRecov"  name="btnCancelRiTransLossesRecov"	class="button" value="Cancel" />
	<input type="button" style="width: 80px;" id="btnSaveRiTransLossesRecov" 	name="btnSaveRiTransLossesRecov"	class="button" value="Save" />
</div> 
<script type="text/javascript">
try{
	objAC.hidObjGIACS009 = {};
	var objSearchLossAdvice = new Object();
	objAC.objLossesRecovAC009 = JSON.parse('${giacLossRiCollnsJSON}'.replace(/\\/g, '\\\\')); 

	setModuleId("GIACS009");
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	initializeAccordion();
	hideNotice("");

	//to show/generate the table listing
	showRiTransLossesRecovList(objAC.objLossesRecovAC009);

	//create observe on list
	$$("div#riTransLossesRecovTable div[name=rowRiTransLossesRecov]").each(function(row){
		loadRowMouseOverMouseOutObserver(row);
		row.observe("click", function(){
			row.toggleClassName("selectedRow");
			if (row.hasClassName("selectedRow")){
				$$("div#riTransLossesRecovTable div[name=rowRiTransLossesRecov]").each(function(r){
					if (row.getAttribute("id") != r.getAttribute("id")){
						r.removeClassName("selectedRow");
					}else{
						getDefaults();
						var id = (row.readAttribute("id")).substring(row.readAttribute("name").length);
						for(var a=0; a<objAC.objLossesRecovAC009.length; a++){
							if (objAC.objLossesRecovAC009[a].divCtrId == id){
								supplyRiTransLossesRecov(objAC.objLossesRecovAC009[a]);
							}
						}
					}	
				});
			}else{
				clearForm();
			}		
		});	
	});
	
	//currency info DIV
	$("btnCurrencyLossesRecov").observe("click",function(){
		if ($("currencyLossesRecovDiv").getStyle("display") == "none"){
			Effect.Appear($("currencyLossesRecovDiv"), {
				duration: .2
			});
		}else{
			Effect.Fade($("currencyLossesRecovDiv"), {
				duration: .2
			});
		}	
	});
	$("btnHideCurrLossesRecovDiv").observe("click",function(){
		Effect.Fade($("currencyLossesRecovDiv"), {
			duration: .2
		});	
	});

	//for transaction type
	$("selTransactionTypeLossesRecov").observe("change", function(){
		updateRiTransLossRecovLOV();
		clearFinalLossAdvice();
	});

	//for share type
	$("selShareTypeLossesRecov").observe("change", function(){
		updateRiTransLossRecovLOV();
		$(objAC.hidObjGIACS009.hidCurrReinsurer).selectedIndex = 0;
		clearFinalLossAdvice();
	});

	//for reinsurer LOV
	$("selA180RiCdLossesRecov12").observe("change", function(){
		clearFinalLossAdvice();
	});
	$("selA180RiCdLossesRecov13").observe("change", function(){
		clearFinalLossAdvice();
	});
	$("selA180RiCdLossesRecov22").observe("change", function(){
		clearFinalLossAdvice();
	});
	$("selA180RiCdLossesRecov23").observe("change", function(){
		clearFinalLossAdvice();
	});
	$("selA180RiCdLossesRecov14").observe("change", function(){ //John Dolon; 5.25.2015; SR#2569 - Issues in Losses Recoverable from RI
		clearFinalLossAdvice();
	});
	$("selA180RiCdLossesRecov24").observe("change", function(){ //John Dolon; 5.25.2015; SR#2569 - Issues in Losses Recoverable from RI
		clearFinalLossAdvice();
	});

	//for Loss Advice
	$("txtE150LineCdLossesRecov").observe("keyup",function(){
		$("txtE150LineCdLossesRecov").value = $("txtE150LineCdLossesRecov").value.toUpperCase();
	});
	$("txtE150LaYyLossesRecov").observe("blur",function(){
		if (!$F("txtE150LaYyLossesRecov").blank()){
			$("txtE150LaYyLossesRecov").value = formatNumberDigits($F("txtE150LaYyLossesRecov"),2);
		} 
	});
	$("txtE150FlaSeqNoLossesRecov").observe("blur",function(){ 
		if (!$F("txtE150FlaSeqNoLossesRecov").blank()){ 
			$("txtE150FlaSeqNoLossesRecov").value = formatNumberDigits($F("txtE150FlaSeqNoLossesRecov"),5);
		}
	});

	//for Loss Advice icon
	$("finalLossAdviceLossesRecDate").observe("click", function(){
		if (objAC.hidObjGIACS009.hidUpdateable == "N"){ //to have a disable effect on the icon
			return false;
		}	
		if ($F("selTransactionTypeLossesRecov") == ""){
			customShowMessageBox("Please select a transaction type first.", imgMessage.ERROR, "selTransactionTypeLossesRecov");
			return false;
		}else if ($F("selShareTypeLossesRecov") == ""){
			customShowMessageBox("Please select a share type first.", imgMessage.ERROR, "selShareTypeLossesRecov");
			return false;
		}else if ($F(objAC.hidObjGIACS009.hidCurrReinsurer) == ""){
			customShowMessageBox("Please select a reinsurer first.", imgMessage.ERROR, objAC.hidObjGIACS009.hidCurrReinsurer);
			return false;	
		}else{
			openSearchLossAdvice();
		}
	});

	//for Collection Amount
	var varTxtCollectionAmtLossesRecov = "";
	$("txtCollectionAmtLossesRecov").observe("focus", function(){
		varTxtCollectionAmtLossesRecov = $F("txtCollectionAmtLossesRecov");
	});	
	//onblur on collection amount
	$("txtCollectionAmtLossesRecov").observe("blur", function(){
		if ($F("txtCollectionAmtLossesRecov").blank()){
			return false;
		}	
		if (unformatCurrency("txtCollectionAmtLossesRecov") > 9999999999.99 || unformatCurrency("txtCollectionAmtLossesRecov") < -9999999999.99){
			customShowMessageBox("Entered collection amount is invalid. Valid value is from -9,999,999,999.99 to 9,999,999,999.99.", imgMessage.ERROR, "txtCollectionAmtLossesRecov");
			$("txtCollectionAmtLossesRecov").clear();
			return false;
		}

		if ($F("selTransactionTypeLossesRecov") == "1"){
			if (unformatCurrency("txtCollectionAmtLossesRecov") <= 0){
				$("txtCollectionAmtLossesRecov").value = formatCurrency(varTxtCollectionAmtLossesRecov);
	    		customShowMessageBox("Invalid value. Collection amount should be greater than zero(0).", imgMessage.ERROR, "txtCollectionAmtLossesRecov");
	    		return false;
			}	
			if (unformatCurrency("txtCollectionAmtLossesRecov") > parseFloat(objAC.hidObjGIACS009.hidWsCollectionAmt.replace(/,/g, ""))){
				$("txtCollectionAmtLossesRecov").value = formatCurrency(varTxtCollectionAmtLossesRecov);
	    		customShowMessageBox("Collection amount cannot be more than default value of "+objAC.hidObjGIACS009.hidWsCollectionAmt, imgMessage.ERROR, "txtCollectionAmtLossesRecov");
	    		return false; 
			}	
		}else{
			if (unformatCurrency("txtCollectionAmtLossesRecov") >= 0){
				$("txtCollectionAmtLossesRecov").value = formatCurrency(varTxtCollectionAmtLossesRecov);
	    		customShowMessageBox("Invalid value. Collection amount should be less than zero(0).", imgMessage.ERROR, "txtCollectionAmtLossesRecov");
	    		return false;
			}
			if (unformatCurrency("txtCollectionAmtLossesRecov") < parseFloat(objAC.hidObjGIACS009.hidWsCollectionAmt.replace(/,/g, ""))){
				$("txtCollectionAmtLossesRecov").value = formatCurrency(varTxtCollectionAmtLossesRecov);
	    		customShowMessageBox("Collection amount cannot be less than default value of "+objAC.hidObjGIACS009.hidWsCollectionAmt, imgMessage.ERROR, "txtCollectionAmtLossesRecov");
	    		return false; 
			}
		}	
		if (varTxtCollectionAmtLossesRecov != unformatCurrency("txtCollectionAmtLossesRecov") && $F("txtCollectionAmtLossesRecov").replace(/,/g, "") != ""){	
			$("foreignCurrAmtLossesRecov").value = formatCurrency(nvl(unformatCurrency("txtCollectionAmtLossesRecov"),0) / nvl(unformatCurrency("convertRateLossesRecov"),1));
		}
	});	

	//for Foreign Currency Amount
	var varForeignCurrAmtLossesRecov = "";
	$("foreignCurrAmtLossesRecov").observe("focus", function(){
		varForeignCurrAmtLossesRecov = $F("foreignCurrAmtLossesRecov");
	});	
	//onblur on Foreign Currency Amount
	$("foreignCurrAmtLossesRecov").observe("blur", function(){
		if ($F("foreignCurrAmtLossesRecov").blank()){
			return false;
		}	
		if (unformatCurrency("foreignCurrAmtLossesRecov") > 9999999999.99 || unformatCurrency("foreignCurrAmtLossesRecov") < -9999999999.99){
			customShowMessageBox("Entered foreign currency amount is invalid. Valid value is from -9,999,999,999.99 to 9,999,999,999.99.", imgMessage.ERROR, "foreignCurrAmtLossesRecov");
			$("foreignCurrAmtLossesRecov").clear();
			return false;
		}
		if ($F("selTransactionTypeLossesRecov") == "1"){
			if (unformatCurrency("foreignCurrAmtLossesRecov") <= 0){
				$("foreignCurrAmtLossesRecov").value = formatCurrency(varForeignCurrAmtLossesRecov);
	    		customShowMessageBox("Invalid value. Foreign currency amount cannot be less than or equal to zero(0).", imgMessage.ERROR, "foreignCurrAmtLossesRecov");
	    		return false;
			}	 
			if (unformatCurrency("foreignCurrAmtLossesRecov") > parseFloat(objAC.hidObjGIACS009.hidWsForeignCurrAmt.replace(/,/g, ""))){
				$("foreignCurrAmtLossesRecov").value = formatCurrency(varForeignCurrAmtLossesRecov);
	    		customShowMessageBox("Foreign currency amount cannot be more than "+objAC.hidObjGIACS009.hidWsForeignCurrAmt, imgMessage.ERROR, "foreignCurrAmtLossesRecov");
	    		return false; 
			}	
		}else{
			if (unformatCurrency("foreignCurrAmtLossesRecov") >= 0){
				$("txtCollectionAmtLossesRecov").value = formatCurrency(varTxtCollectionAmtLossesRecov);
				$("foreignCurrAmtLossesRecov").value = formatCurrency(varForeignCurrAmtLossesRecov);
	    		customShowMessageBox("Invalid value. Foreign currency amount for this transaction should be less than zero(0).", imgMessage.ERROR, "foreignCurrAmtLossesRecov");
	    		return false;
			}
			if (unformatCurrency("foreignCurrAmtLossesRecov") < parseFloat(objAC.hidObjGIACS009.hidWsForeignCurrAmt.replace(/,/g, ""))){
				$("foreignCurrAmtLossesRecov").value = formatCurrency(varForeignCurrAmtLossesRecov);
	    		customShowMessageBox("Foreign currency amount cannot be less than "+objAC.hidObjGIACS009.hidWsForeignCurrAmt, imgMessage.ERROR, "foreignCurrAmtLossesRecov");
	    		return false; 
			}
		}
		if (varTxtCollectionAmtLossesRecov != $F("foreignCurrAmtLossesRecov")){
			$("txtCollectionAmtLossesRecov").value = formatCurrency(unformatCurrency("foreignCurrAmtLossesRecov") * unformatCurrency("convertRateLossesRecov"));
		}	
	});

	//for Convert rate
	var varConvertRateLossesRecov = "";
	$("convertRateLossesRecov").observe("focus", function(){
		varConvertRateLossesRecov = $F("convertRateLossesRecov");
	});	
	//onblur on Convert rate
	$("convertRateLossesRecov").observe("blur", function(){
		if ($F("convertRateLossesRecov").blank()){
			return false;
		}	
		if (isNaN(parseFloat($F("convertRateLossesRecov")))){
			$("convertRateLossesRecov").value = varConvertRateLossesRecov;
			showMessageBox("Entered currency rate is invalid. Valid value is from 0.000000001 to 999.999999999.", imgMessage.ERROR);
			return false;
		}else if (parseFloat($F("convertRateLossesRecov")) <= 0.000000000 || parseFloat($F("convertRateLossesRecov")) >= 999.999999999){
			$("convertRateLossesRecov").value = varConvertRateLossesRecov;
			showMessageBox("Entered currency rate is invalid. Valid value is from 0.000000001 to 999.999999999.", imgMessage.ERROR);
			return false;
		}
		if (!$F("convertRateLossesRecov").blank()){	
			$("foreignCurrAmtLossesRecov").value = formatCurrency(nvl(unformatCurrency("txtCollectionAmtLossesRecov"),0) / nvl(unformatCurrency("convertRateLossesRecov"),1));
		}
	});	

	//for currency code
	var varCurrencyCdLossesRecov = "";
	$("currencyCdLossesRecov").observe("focus", function(){
		varCurrencyCdLossesRecov = $F("currencyCdLossesRecov");
	});	 
	$("currencyCdLossesRecov").observe("blur", function(){
		if ($F("currencyCdLossesRecov").blank()){
			return false;	
		}else{
			if (parseInt($F("currencyCdLossesRecov")) < 1 || parseInt($F("currencyCdLossesRecov")) > 99){
				showMessageBox("Entered currency code is invalid. Valid value is from 1 to 99.", imgMessage.ERROR);
				$("currencyCdLossesRecov").value = varCurrencyCdLossesRecov;
				return false;
			}	
		}
		if (varCurrencyCdLossesRecov != $F("currencyCdLossesRecov") && !$F("txtCollectionAmtLossesRecov").blank()){
			new Ajax.Request(contextPath+"/GIACLossRiCollnsController?action=validateCurrencyCode",{
				parameters:{
					claimId: objAC.hidObjGIACS009.hidClaimId,
					collectionAmt: unformatCurrency("txtCollectionAmtLossesRecov"),
					currencyCd: $F("currencyCdLossesRecov")
				},
				asynchronous:false,
				evalScripts:true,
				onComplete:function(response){
					var currJSON = response.responseText.evalJSON();
					if (currJSON.vMsgAlert == null || currJSON.vMsgAlert == ""){
						$("currencyDescLossesRecov").value = currJSON.dspCurrencyDesc;
						$("convertRateLossesRecov").value = formatToNineDecimal(currJSON.convertRate);
						$("currencyCdLossesRecov").value = currJSON.currencyCd;
						$("foreignCurrAmtLossesRecov").value = formatCurrency(currJSON.foreignCurrAmt);
					}else{
						showMessageBox(currJSON.vMsgAlert, imgMessage.ERROR);
						$("currencyCdLossesRecov").value = varCurrencyCdLossesRecov;
					}	
				}
			});
		}	
	});	

	//create new Object to be added on Object Array
	function setLossesRecovObject() {
		try {
			var newObj = new Object();
			newObj.recordStatus			= objAC.hidObjGIACS009.recordStatus;
			newObj.gaccTranId			= objACGlobal.gaccTranId;
			newObj.a180RiCd				= changeSingleAndDoubleQuotes2($F(objAC.hidObjGIACS009.hidCurrReinsurer));
			newObj.transactionType		= changeSingleAndDoubleQuotes2($F("selTransactionTypeLossesRecov"));
			newObj.e150LineCd			= changeSingleAndDoubleQuotes2($F("txtE150LineCdLossesRecov"));
			newObj.e150LaYy				= changeSingleAndDoubleQuotes2($F("txtE150LaYyLossesRecov"));
			newObj.e150FlaSeqNo			= changeSingleAndDoubleQuotes2($F("txtE150FlaSeqNoLossesRecov"));
			newObj.collectionAmt		= changeSingleAndDoubleQuotes2($F("txtCollectionAmtLossesRecov").replace(/,/g, ""));
			newObj.claimId				= objAC.hidObjGIACS009.hidClaimId;
			newObj.currencyCd			= changeSingleAndDoubleQuotes2($F("currencyCdLossesRecov"));
			newObj.convertRate			= changeSingleAndDoubleQuotes2($F("convertRateLossesRecov").replace(/,/g, ""));	
			newObj.foreignCurrAmt		= changeSingleAndDoubleQuotes2($F("foreignCurrAmtLossesRecov").replace(/,/g, ""));
			newObj.orPrintTag			= objAC.hidObjGIACS009.hidOrPrintTag;
			newObj.particulars			= changeSingleAndDoubleQuotes2($F("txtParticularsLossesRecov"));
			newObj.cpiRecNo				= objAC.hidObjGIACS009.hidCpiRecNo;
			newObj.cpiBranchCd			= objAC.hidObjGIACS009.hidCpiBranchCd;
			newObj.shareType			= changeSingleAndDoubleQuotes2($F("selShareTypeLossesRecov"));
			newObj.payeeType			= changeSingleAndDoubleQuotes2($F("txtPayeeTypeLossesRecov"));
			newObj.riName				= changeSingleAndDoubleQuotes2(getListTextValue(objAC.hidObjGIACS009.hidCurrReinsurer));
			newObj.currencyDesc			= changeSingleAndDoubleQuotes2($F("currencyDescLossesRecov"));
			newObj.shareTypeDesc		= changeSingleAndDoubleQuotes2(getListTextValue("selShareTypeLossesRecov"));
			newObj.transactionTypeDesc  = changeSingleAndDoubleQuotes2(getListAttributeValue("selTransactionTypeLossesRecov","typeDesc"));
			newObj.dspPolicy			= changeSingleAndDoubleQuotes2($F("txtDspPolicyLossesRecov"));
			newObj.dspClaim				= changeSingleAndDoubleQuotes2($F("txtDspClaimNoLossesRecov"));
			newObj.dspAssdName			= changeSingleAndDoubleQuotes2($F("txtDspAssuredLossesRecov"));
			newObj.wsCollectionAmt		= objAC.hidObjGIACS009.hidWsCollectionAmt;
			newObj.wsForeignCurrAmt  	= objAC.hidObjGIACS009.hidWsForeignCurrAmt;
			
			return newObj; 
		}catch(e){
			showErrorMessage("setLossesRecovObject", e);
		}
	}		
	
	//when Add/Update button click
	$("btnAddLossesRecov").observe("click", function(){
		addLossesRecov();
	});

	//function to add record
	function addLossesRecov(){
		try{
			if (objAC.hidObjGIACS009.hidUpdateable == "N"){ //to have a disable effect on the add/update
				return false;
			}
			//check required fields first
			var exists = false;
			if ($F("selTransactionTypeLossesRecov").blank()){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR , "selTransactionTypeLossesRecov");
				exists = true;
			}else if ($F("selShareTypeLossesRecov").blank()){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR , "selShareTypeLossesRecov");
				exists = true;
			}else if ($F(objAC.hidObjGIACS009.hidCurrReinsurer).blank()){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR , objAC.hidObjGIACS009.hidCurrReinsurer);
				exists = true;
			}else if ($F("txtE150LineCdLossesRecov").blank()){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR , "txtE150LineCdLossesRecov");
				exists = true;
			}else if ($F("txtE150LaYyLossesRecov").blank()){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR , "txtE150LaYyLossesRecov");
				exists = true;
			}else if ($F("txtE150FlaSeqNoLossesRecov").blank()){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR , "txtE150FlaSeqNoLossesRecov");
				exists = true;
			}else if ($F("txtCollectionAmtLossesRecov").blank()){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR , "txtCollectionAmtLossesRecov");
				exists = true;
			}else if ($F("currencyCdLossesRecov").blank()){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR , "currencyCdLossesRecov");
				exists = true;
			}else if ($F("convertRateLossesRecov").blank()){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR , "convertRateLossesRecov");
				exists = true;
			}else if ($F("foreignCurrAmtLossesRecov").blank()){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR , "foreignCurrAmtLossesRecov");
				exists = true;
			}else if (unformatCurrency("txtCollectionAmtLossesRecov") > 9999999999.99 || unformatCurrency("txtCollectionAmtLossesRecov") < -9999999999.99 || isNaN(parseFloat($F("txtCollectionAmtLossesRecov").replace(/,/g, "")))){
				customShowMessageBox("Entered collection amount is invalid. Valid value is from -9,999,999,999.99 to 9,999,999,999.99.", imgMessage.ERROR, "txtCollectionAmtLossesRecov");
				$("txtCollectionAmtLossesRecov").clear();
				exists = true;
			}else if (unformatCurrency("foreignCurrAmtLossesRecov") > 9999999999.99 || unformatCurrency("foreignCurrAmtLossesRecov") < -9999999999.99 || isNaN(parseFloat($F("foreignCurrAmtLossesRecov").replace(/,/g, "")))){
				customShowMessageBox("Entered foreign currency amount is invalid. Valid value is from -9,999,999,999.99 to 9,999,999,999.99.", imgMessage.ERROR, "foreignCurrAmtLossesRecov");
				$("foreignCurrAmtLossesRecov").clear();
				exists = true;
			}else if ($F("selTransactionTypeLossesRecov") != ""){
				if ($F("selTransactionTypeLossesRecov") == "1"){
					if (unformatCurrency("txtCollectionAmtLossesRecov") <= 0){
						$("txtCollectionAmtLossesRecov").value = formatCurrency(varTxtCollectionAmtLossesRecov);
			    		customShowMessageBox("Invalid value. Collection amount should be greater than zero(0).", imgMessage.ERROR, "txtCollectionAmtLossesRecov");
			    		exists = true;
					}	
					if (unformatCurrency("txtCollectionAmtLossesRecov") > parseFloat(objAC.hidObjGIACS009.hidWsCollectionAmt.replace(/,/g, ""))){
						$("txtCollectionAmtLossesRecov").value = formatCurrency(varTxtCollectionAmtLossesRecov);
			    		customShowMessageBox("Collection amount cannot be more than default value of "+objAC.hidObjGIACS009.hidWsCollectionAmt, imgMessage.ERROR, "txtCollectionAmtLossesRecov");
			    		exists = true;
					}	
					if (unformatCurrency("foreignCurrAmtLossesRecov") <= 0){
						$("foreignCurrAmtLossesRecov").value = formatCurrency(varForeignCurrAmtLossesRecov);
			    		customShowMessageBox("Invalid value. Foreign currency amount cannot be less than or equal to zero(0).", imgMessage.ERROR, "foreignCurrAmtLossesRecov");
			    		exists = true;
					}	 
					if (unformatCurrency("foreignCurrAmtLossesRecov") > parseFloat(objAC.hidObjGIACS009.hidWsForeignCurrAmt.replace(/,/g, ""))){
						$("foreignCurrAmtLossesRecov").value = formatCurrency(varForeignCurrAmtLossesRecov);
			    		customShowMessageBox("Foreign currency amount cannot be more than "+objAC.hidObjGIACS009.hidWsForeignCurrAmt, imgMessage.ERROR, "foreignCurrAmtLossesRecov");
			    		exists = true;
					}	
				}else {
					if (unformatCurrency("txtCollectionAmtLossesRecov") >= 0){
						$("txtCollectionAmtLossesRecov").value = formatCurrency(varTxtCollectionAmtLossesRecov);
			    		customShowMessageBox("Invalid value. Collection amount should be less than zero(0).", imgMessage.ERROR, "txtCollectionAmtLossesRecov");
			    		exists = true;
					}
					if (unformatCurrency("txtCollectionAmtLossesRecov") < parseFloat(objAC.hidObjGIACS009.hidWsCollectionAmt.replace(/,/g, ""))){
						$("txtCollectionAmtLossesRecov").value = formatCurrency(varTxtCollectionAmtLossesRecov);
			    		customShowMessageBox("Collection amount cannot be less than default value of "+objAC.hidObjGIACS009.hidWsCollectionAmt, imgMessage.ERROR, "txtCollectionAmtLossesRecov");
			    		exists = true;
					}
					if (unformatCurrency("foreignCurrAmtLossesRecov") >= 0){
						$("txtCollectionAmtLossesRecov").value = formatCurrency(varTxtCollectionAmtLossesRecov);
						$("foreignCurrAmtLossesRecov").value = formatCurrency(varForeignCurrAmtLossesRecov);
			    		customShowMessageBox("Invalid value. Foreign currency amount for this transaction should be less than zero(0).", imgMessage.ERROR, "foreignCurrAmtLossesRecov");
			    		exists = true;
					}
					if (unformatCurrency("foreignCurrAmtLossesRecov") < parseFloat(objAC.hidObjGIACS009.hidWsForeignCurrAmt.replace(/,/g, ""))){
						$("foreignCurrAmtLossesRecov").value = formatCurrency(varForeignCurrAmtLossesRecov);
			    		customShowMessageBox("Foreign currency amount cannot be less than "+objAC.hidObjGIACS009.hidWsForeignCurrAmt, imgMessage.ERROR, "foreignCurrAmtLossesRecov");
			    		exists = true;
					}
				}
			}else if (parseFloat($F("convertRateLossesRecov")) <= 0.000000000 || parseFloat($F("convertRateLossesRecov")) >= 999.999999999 || isNaN(parseFloat($F("convertRateLossesRecov").replace(/,/g, "")))){
				$("convertRateLossesRecov").value = varConvertRateLossesRecov;
				showMessageBox("Entered currency rate is invalid. Valid value is from 0.000000001 to 999.999999999.", imgMessage.ERROR);
				exists = true;
			}else if (parseInt($F("currencyCdLossesRecov")) < 1 || parseInt($F("currencyCdLossesRecov")) > 99 || isNaN(parseInt($F("currencyCdLossesRecov").replace(/,/g, "")))){
				showMessageBox("Entered currency code is invalid. Valid value is from 1 to 99.", imgMessage.ERROR);
				$("currencyCdLossesRecov").value = varCurrencyCdLossesRecov;
				exists = true;
			}	

			if (!exists){
				var newObj  = setLossesRecovObject();
				var content = prepareRiTransLossesRecov(newObj);
				if ($F("btnAddLossesRecov") == "Update"){
					//on UPDATE records
					newObj.divCtrId = getSelectedRowId("rowRiTransLossesRecov");
					$("rowRiTransLossesRecov"+newObj.divCtrId).update(content);	
					addModifiedJSONObjectAccounting(objAC.objLossesRecovAC009, newObj);
				}else{
					//on ADD records
					var tableContainer = $("riTransLossesRecovListing");
					var newDiv = new Element("div");
					newObj.divCtrId = generateDivCtrId(objAC.objLossesRecovAC009);
					addNewJSONObject(objAC.objLossesRecovAC009, newObj);
					newDiv.setAttribute("id", "rowRiTransLossesRecov"+newObj.divCtrId);
					newDiv.setAttribute("name", "rowRiTransLossesRecov");
					newDiv.addClassName("tableRow");
					newDiv.update(content);
					tableContainer.insert({bottom : newDiv});

					loadRowMouseOverMouseOutObserver(newDiv);
					newDiv.observe("click", function(){
						newDiv.toggleClassName("selectedRow");
						if (newDiv.hasClassName("selectedRow")){
							$$("div#riTransLossesRecovTable div[name=rowRiTransLossesRecov]").each(function(r){
								if (newDiv.getAttribute("id") != r.getAttribute("id")){
									r.removeClassName("selectedRow");
								}else{
									getDefaults();
									var id = (r.readAttribute("id")).substring(r.readAttribute("name").length);
									for(var a=0; a<objAC.objLossesRecovAC009.length; a++){
										if (objAC.objLossesRecovAC009[a].divCtrId == id){
											supplyRiTransLossesRecov(objAC.objLossesRecovAC009[a]);
										}
									}
								}
							});
						}else{
							clearForm();
						}	
					});

					Effect.Appear(newDiv, {
						duration: .5, 
						afterFinish: function(){
						checkTableItemInfo("riTransLossesRecovTable","riTransLossesRecovListing","rowRiTransLossesRecov");
						}
					});
				}
				clearForm();
				changeTag = 1;
			}	
		}catch(e){
			showErrorMessage("addLossesRecov", e);
		}
	}	
	objAC.hidObjGIACS009.addLossesRecov = addLossesRecov;
	
	//when DELETE button click
	$("btnDeleteLossesRecov").observe("click",function(){
		deleteLossesRecov();
	});

	//function to delete record
	function deleteLossesRecov(){
		$$("div[name='rowRiTransLossesRecov']").each(function(row){
			if (row.hasClassName("selectedRow")){
				var id = (row.readAttribute("id")).substring(row.readAttribute("name").length);
				for(var a=0; a<objAC.objLossesRecovAC009.length; a++){
					if (objAC.objLossesRecovAC009[a].divCtrId == id){
						var delObj = objAC.objLossesRecovAC009[a];
						if (delObj.orPrintTag == "Y"){
							showMessageBox("Delete not allowed. This record was created before the OR was printed.", imgMessage.ERROR);
							return false;
						}else{
							Effect.Fade(row,{
								duration: .5,
								afterFinish: function(){
									changeTag = 1;
									addDeletedJSONObjectAccounting(objAC.objLossesRecovAC009, delObj);
									row.remove();
									clearForm();
									checkTableItemInfo("riTransLossesRecovTable","riTransLossesRecovListing","rowRiTransLossesRecov");
								}
							});	
						}
					}
				}
			}
		});	
	}	

	function saveRiTransLossesRecov(){
		try{
			if (checkObjectIfChangesExist(objAC.objLossesRecovAC009)){
				var addedRows 	 = getAddedJSONObjects(objAC.objLossesRecovAC009);
				var modifiedRows = getModifiedJSONObjects(objAC.objLossesRecovAC009);
				var delRows 	 = getDeletedJSONObjects(objAC.objLossesRecovAC009);
				var setRows		 = addedRows.concat(modifiedRows);

				new Ajax.Request(contextPath+"/GIACLossRiCollnsController?action=saveLossesRecov",{
					method: "POST",
					parameters:{
						globalGaccTranId: objACGlobal.gaccTranId,
						globalGaccBranchCd: objACGlobal.branchCd,
						globalGaccFundCd: objACGlobal.fundCd,
						globalTranSource: objACGlobal.tranSource,
						globalOrFlag: objACGlobal.orFlag,
						setRows: prepareJsonAsParameter(setRows),
					 	delRows: prepareJsonAsParameter(delRows)
					},
					asynchronous: false,
					evalScripts: true,
					onCreate: function(){
						showNotice("Saving Losses Recov from RI, please wait...");
					},
					onComplete: function(response){
						hideNotice("");
						if(checkErrorOnResponse(response)) {
							if (response.responseText == "SUCCESS"){
								changeTag = 0;
								showMessageBox(objCommonMessage.SUCCESS,imgMessage.SUCCESS);
								clearObjectRecordStatus(objAC.objLossesRecovAC009); //to clear the record status on JSON Array
								clearForm();
							}else{
								showMessageBox(response.responseText, imgMessage.ERROR);
							}		
						}	
					}	 
				});	
			}else{
				showMessageBox("No changes to save." ,imgMessage.INFO);
			}		
		}catch (e) {
			showErrorMessage("saveRiTransLossesRecov", e);
		}	
	}	

	observeCancelForm("btnCancelRiTransLossesRecov", saveRiTransLossesRecov, editORInformation);
	
	//when SAVE button click
	$("btnSaveRiTransLossesRecov").observe("click",function(){
		saveRiTransLossesRecov();
	});
	
	//get the default value
	function getDefaults(){
		try{
			$("btnAddLossesRecov").value = "Update";
			enableButton("btnDeleteLossesRecov");
		}catch (e) {
			showErrorMessage("getDefaults", e);
		}
	}

	//to clear the form inputs
	function clearForm(){
		try{
			$("selTransactionTypeLossesRecov").clear();
			$("selShareTypeLossesRecov").clear();
			$("txtE150LineCdLossesRecov").clear();
			$("txtE150LaYyLossesRecov").clear();
			$("txtE150FlaSeqNoLossesRecov").clear();
			$("txtPayeeTypeLossesRecov").clear();
			$("txtCollectionAmtLossesRecov").clear();
			$("txtParticularsLossesRecov").clear();
			$("txtDspPolicyLossesRecov").clear();
			$("txtDspClaimNoLossesRecov").clear();
			$("txtDspAssuredLossesRecov").clear();
			$("currencyCdLossesRecov").clear();
			$("currencyDescLossesRecov").clear();
			$("convertRateLossesRecov").clear();
			$("foreignCurrAmtLossesRecov").clear();
			
			$("readOnlyTransactionTypeLossesRecov").clear();
			$("readOnlyTransactionTypeLossesRecov").hide();
			$("selTransactionTypeLossesRecov").show();
			$("selTransactionTypeLossesRecov").enable();
			
			$("readOnlyShareTypeLossesRecov").clear();
			$("readOnlyShareTypeLossesRecov").hide();
			$("selShareTypeLossesRecov").show();
			$("selShareTypeLossesRecov").enable();
			
			$("readOnlyA180RiCdLossesRecov").clear();
			$("readOnlyA180RiCdLossesRecov").hide();
			updateRiTransLossRecovLOV();
	
			objAC.hidObjGIACS009.hidCurrReinsurer		= "";
			objAC.hidObjGIACS009.hidOrPrintTag			= "N";
			objAC.hidObjGIACS009.hidClaimId			= "";
			objAC.hidObjGIACS009.hidCpiRecNo 			= "";
			objAC.hidObjGIACS009.hidCpiBranchCd 		= "";
			objAC.hidObjGIACS009.hidUpdateable			= "Y";
			objAC.hidObjGIACS009.hidWsCollectionAmt	= "";
			objAC.hidObjGIACS009.hidWsForeignCurrAmt	= "";
			
			$("txtE150LineCdLossesRecov").readOnly 			= true;
			$("txtE150LaYyLossesRecov").readOnly 			= true;
			$("txtE150FlaSeqNoLossesRecov").readOnly 		= true;
			$("txtCollectionAmtLossesRecov").readOnly 		= true;
			$("foreignCurrAmtLossesRecov").readOnly 		= true;
			$("currencyCdLossesRecov").readOnly 			= true;
			$("convertRateLossesRecov").readOnly 			= true;
			$("txtParticularsLossesRecov").readOnly 		= true;
			
			deselectRows("riTransLossesRecovTable","rowRiTransLossesRecov");	
			$("btnAddLossesRecov").value = "Add";
			enableButton("btnAddLossesRecov");
			if (objACGlobal.tranFlagState != 'O'){
				disableButton("btnAddLossesRecov");
			}
			disableButton("btnDeleteLossesRecov");
			computeTotalAmountInTable();
		}catch (e) {
			showErrorMessage("clearForm", e);
		}
	}	

	//to clear the form inputs for FLA
	function clearFinalLossAdvice(){
		try{
			if ($F("selTransactionTypeLossesRecov") == "" || $F("selShareTypeLossesRecov") == "" || $(objAC.hidObjGIACS009.hidCurrReinsurer).value == ""){
				$("txtE150LineCdLossesRecov").readOnly 			= true;
				$("txtE150LaYyLossesRecov").readOnly 			= true;
				$("txtE150FlaSeqNoLossesRecov").readOnly 		= true;
			}else{
				$("txtE150LineCdLossesRecov").readOnly 			= false;
				$("txtE150LaYyLossesRecov").readOnly 			= false;
				$("txtE150FlaSeqNoLossesRecov").readOnly 		= false;
			}
			$("txtE150LineCdLossesRecov").clear();
			$("txtE150LaYyLossesRecov").clear();
			$("txtE150FlaSeqNoLossesRecov").clear();
			$("txtPayeeTypeLossesRecov").clear();
			$("txtCollectionAmtLossesRecov").clear();
			$("txtParticularsLossesRecov").clear();
			$("txtDspPolicyLossesRecov").clear();
			$("txtDspClaimNoLossesRecov").clear();
			$("txtDspAssuredLossesRecov").clear();
			$("currencyCdLossesRecov").clear();
			$("currencyDescLossesRecov").clear();
			$("convertRateLossesRecov").clear();
			$("foreignCurrAmtLossesRecov").clear();
	
			objAC.hidObjGIACS009.hidClaimId			= "";
			
			$("txtCollectionAmtLossesRecov").readOnly 		= true;
			$("foreignCurrAmtLossesRecov").readOnly 		= true;
			$("currencyCdLossesRecov").readOnly 			= true;
			$("convertRateLossesRecov").readOnly 			= true;
			$("txtParticularsLossesRecov").readOnly 		= true;
		}catch (e) {
			showErrorMessage("clearFinalLossAdvice", e);
		}
	}	

	//compute the total amount in table
	function computeTotalAmountInTable(){
		try{
			var total = 0;
			var ctr = 0;
			for(var a=0; a<objAC.objLossesRecovAC009.length; a++){
				if (objAC.objLossesRecovAC009[a].recordStatus != -1){
					ctr++;
					var collectionAmt = objAC.objLossesRecovAC009[a].collectionAmt.replace(/,/g, "");	
					total = parseFloat(total) + parseFloat((collectionAmt == "" || collectionAmt == null ? 0 :collectionAmt));
				}
			}	
			if (parseInt(ctr) <= 5){
				$("lossesRecovTotalAmtMainDiv").setStyle("padding-right:2px");
			}else{
				$("lossesRecovTotalAmtMainDiv").setStyle("padding-right:19px");
			}	
			if (parseInt(ctr) > 0){
				$("lossesRecovTotalAmtMainDiv").show();
			}else{
				$("lossesRecovTotalAmtMainDiv").hide();
			}
			$("lossesRecovTotalAmtMainDiv").down("label",1).update(formatCurrency(total).truncate(30, "..."));
		}catch (e) {
			showErrorMessage("computeTotalAmountInTable", e);
		}
	}	

	function observeFLA(){
		try{
			var arr = ["txtE150LineCdLossesRecov", "txtE150LaYyLossesRecov", "txtE150FlaSeqNoLossesRecov"];
			var preValue = "";
			for (var a=0; a<arr.length; a++){
				$(arr[a]).observe("focus", function(rec){
					preValue = this.value;
				});
				$(arr[a]).observe("blur", function(rec){
					if (preValue != this.value){
						validateFLA();
					}
				});
			}
		}catch (e) {
			showErrorMessage("observeFLA", e);
		}
	}	

	function validateFLA(){
		try{
			if (!$F("txtE150LineCdLossesRecov").blank() && !$F("txtE150LaYyLossesRecov").blank() 
					&& !$F("txtE150FlaSeqNoLossesRecov").blank()){
				new Ajax.Request(contextPath+"/GIACLossRiCollnsController?action=validateFLA",{
					parameters:{	
						transactionType:$F("selTransactionTypeLossesRecov"),
						shareType:  	$F("selShareTypeLossesRecov"),
						a180RiCd:   	$F(objAC.hidObjGIACS009.hidCurrReinsurer),
						e150LineCd: 	$F("txtE150LineCdLossesRecov"),
						e150LaYy: 		$F("txtE150LaYyLossesRecov"),
						e150FlaSeqNo: 	$F("txtE150FlaSeqNoLossesRecov")
					},	
					asynchronous: false,
					evalScripts: true,
					onComplete:function(response){
						if (checkErrorOnResponse(response)){
							var fla = JSON.parse(response.responseText);
							if (changeSingleAndDoubleQuotes(fla.dspMsgAlert == null ? "" :nvl(fla.dspMsgAlert,"")) != ""){
								showMessageBox(fla.dspMsgAlert ,imgMessage.ERROR);
								clearFinalLossAdvice();
							}else{
								for (var b=0; b<objAC.objLossesRecovAC009.length; b++){
									if ($F("txtE150LineCdLossesRecov") == objAC.objLossesRecovAC009[b].e150LineCd
											&& $F("txtE150FlaSeqNoLossesRecov") == formatNumberDigits(objAC.objLossesRecovAC009[b].e150FlaSeqNo,5)
											&& $F("txtE150LaYyLossesRecov") == formatNumberDigits(objAC.objLossesRecovAC009[b].e150LaYy,2)
											&& $F(objAC.hidObjGIACS009.hidCurrReinsurer) == objAC.objLossesRecovAC009[b].a180RiCd
											&& fla.dspPayeeType == objAC.objLossesRecovAC009[b].payeeType
											&& getSelectedRowId("rowRiTransLossesRecov") != b
											&& objAC.objLossesRecovAC009[b].recordStatus != -1){
										showMessageBox("Row exists already with same Tran Id, Final Loss Advice No ,RI Code.", imgMessage.ERROR);
										clearFinalLossAdvice();
										return false;
									}	
								}	
								$("txtE150LineCdLossesRecov").value			= changeSingleAndDoubleQuotes(fla.dspLineCd == null ? "" :nvl(fla.dspLineCd,""));
								$("txtE150LaYyLossesRecov").value 			= (fla.dspLaYy == null ? "" :nvl(formatNumberDigits(fla.dspLaYy,2),""));
								$("txtE150FlaSeqNoLossesRecov").value 		= (fla.dspFlaSeqNo == null ? "" :nvl(formatNumberDigits(fla.dspFlaSeqNo,5),""));
								$("txtPayeeTypeLossesRecov").value			= changeSingleAndDoubleQuotes(fla.dspPayeeType == null ? "" :nvl(fla.dspPayeeType,""));
								$("txtCollectionAmtLossesRecov").value		= (fla.dspCollectionAmt == null ? "" :nvl(formatCurrency(fla.dspCollectionAmt),""));
								objAC.hidObjGIACS009.hidWsCollectionAmt		= $("txtCollectionAmtLossesRecov").value;
								$("txtDspPolicyLossesRecov").value			= changeSingleAndDoubleQuotes(fla.nbtPolicy == null ? "" :nvl(fla.nbtPolicy,""));
								$("txtDspClaimNoLossesRecov").value			= changeSingleAndDoubleQuotes(fla.nbtClaim == null ? "" :nvl(fla.nbtClaim,""));
								$("txtDspAssuredLossesRecov").value			= changeSingleAndDoubleQuotes(fla.dspAssdName == null ? "" :nvl(fla.dspAssdName,""));
								objAC.hidObjGIACS009.hidClaimId				= (fla.nbtClaimId == null ? "" :nvl(fla.nbtClaimId,""));
								$("foreignCurrAmtLossesRecov").value 		= (fla.dspForeignCurrAmt == null ? "" :nvl(formatCurrency(fla.dspForeignCurrAmt),""));;
								objAC.hidObjGIACS009.hidWsForeignCurrAmt		= $("foreignCurrAmtLossesRecov").value;	
								$("currencyCdLossesRecov").value 			= (fla.dspCurrencyCd == null ? "" :nvl(fla.dspCurrencyCd,""));;
								$("convertRateLossesRecov").value 			= (fla.dspConvertRate == null ? "" :nvl(formatToNineDecimal(fla.dspConvertRate),""));;
								$("currencyDescLossesRecov").value 			= changeSingleAndDoubleQuotes(fla.dspCurrencyDesc == null ? "" :nvl(fla.dspCurrencyDesc,""));;
								
								$("txtCollectionAmtLossesRecov").readOnly 		= false;
								$("foreignCurrAmtLossesRecov").readOnly 		= false;
								$("currencyCdLossesRecov").readOnly 			= false;
								$("convertRateLossesRecov").readOnly 			= false;
								$("txtParticularsLossesRecov").readOnly 		= false;
							}		
						}
					}	
				});	
			}
		}catch (e) {
			showErrorMessage("validateFLA", e);
		}
	}	

	observeFLA();
	clearForm();
	//checkTableItemInfo("riTransLossesRecovTable","riTransLossesRecovListing","rowRiTransLossesRecov");
	setDocumentTitle("Collections on Losses Recoverable from RI");
	window.scrollTo(0,0); 	
	hideNotice("");
	changeTag = 0; 
	initializeChangeTagBehavior(saveRiTransLossesRecov);
}catch(e){
	showErrorMessage("Collections on Losses Recoverable from RI page", e);
}
</script>	