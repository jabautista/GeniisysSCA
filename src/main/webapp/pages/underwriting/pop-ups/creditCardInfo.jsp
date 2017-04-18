<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 

<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
<div id="spinLoadingDiv"></div>
   <div id="contentsDiv" class="sectionDiv" style="width:99%">
		<div id="cardInfoDiv" name="cardInfoDiv" style="width:99%">
			<table width="100%" align="center" cellspacing="1" border="0" style="margin-left: 20px;">
 			<tr>
 				<td class="rightAligned">Card Name</td>
 				<td class="leftAligned">
 					<select style="width: 50.5%" id="selCreditCard" name="selCreditCard" class="required">
 						<option value="Bankard">Bankard</option>
 						<option value="Master Card">Master Card</option>
 						<option value="Others">Others</option>
 						<option value="Visa">Visa</option>
 					</select>
 					<input type="hidden" id="creditCardName" name="creditCardName" value="" />
 				</td>
 			</tr>
 			<tr>
 				<td><label style="float: right;">Others</label></td>
 				<td class="leftAligned">
 					<input type="text" style="text-align: left; width: 48.25%" id="others" name="others" value=""  class="required" maxlength="15"/>
 				</td>
 			</tr>
 			<tr>
 				<td class="rightAligned">Card Number</td>
 				<td class="leftAligned">
 					<input type="text" style="text-align: right; width: 48.25%" id="creditCardNo" name="creditCardNo" value=""  class="required integerNoNegativeUnformatted" maxlength="16"/>
 				</td>
 			</tr>
 			<tr>
 				<td class="rightAligned">Expiry Date </td>
 				<td class="leftAligned"> 
 				  <div style="float:left; border: solid 1px gray; width: 50%; height: 21px; margin-right:3px;" class="required">
		   				<input type="text" style="border: none; width:70%; text-align: left;  height: 13px;" id="creditCardExpiryDate" name="creditCardExpiryDate" class="required" />
		  				 <img id="hrefcardExpiryDate" style="padding-left: 7%" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('creditCardExpiryDate'),this, null);" alt="Expiry Date" />
				  </div>
 					
 				</td>
 			</tr>
 			<tr>
 				<td class="rightAligned">Approval Code</td>
 				<td class="leftAligned">
 					<input type="text" style="text-align: left; width: 48.25%" id="creditCardApprovalCd" name="creditCardApprovalCd" class="required" maxLength="7"/>
 				</td>			
 	 		</tr>
 			
 			<tr>
 			<td style="padding-left: 45%">
 				<input type="hidden" id="validSw" name="validSw" value="Y" />
 			</td>
 			<td style="padding-right: 15%">
 				<input type="button" class="button" id="btnCreditCardOk" name="btnCreditCardOk" value="Ok" style="margin-right: 1px; width: 60px; margin-left: 5px;"/>
 				<input type="button" class="button" id="btnCreditCardCancel" name="btnCreditCardCancel" value="Cancel" style="width: 60px;"/>
 			</td>
 			</tr>
 			</table>
		</div>
</div>


<script type="text/javascript">
	var expiryDate = Date.parse('${gipiWPolbas.expiryDate}');
	var effDate = Date.parse('${gipiWPolbas.effDate}');
	var endtExpiryDate = Date.parse('${gipiWPolbas.endtExpiryDate}');
	var inceptDate = Date.parse('${gipiWPolbas.inceptDate}');
	initializeAll();
	populateCardDtls();

	$("btnCreditCardCancel").observe("click", function() {
		$("selPayType").value = $("origPaytype").value;
		$("lastIndex").value = 1;
		hideOverlay();
	});

	$("btnCreditCardOk").observe("click", function(){
		var cardExpireDate = Date.parse($("creditCardExpiryDate").value);
		//if (validateCardInformation()){
		if (checkAllRequiredFieldsInDiv("cardInfoDiv")){ //added by steven 07.23.2014 remove the code above
			if (objUW.lastTakeupDueDate > cardExpireDate){
				customShowMessageBox("The card's expiry date cannot be earlier than the inception date.", imgMessage.ERROR, "creditCardExpiryDate");
				isValid = false;
			}else{
				modifyJSONCardDtls();
				$("selPayType").value = "R";
				$("lastIndex").value = 1;
				showMessageBox("Credit card information updated");
				hideOverlay();
			}		
		}
		
	});

	function validateExpiryDates(){
		var isValid = true;
		var cardExpireDate = Date.parse($("creditCardExpiryDate").value);
	    
		if  (inceptDate > cardExpireDate)  {
			customShowMessageBox("The card's expiry date cannot be earlier than the inception date.", imgMessage.ERROR, "creditCardExpiryDate");
			isValid = false;
		}else if  (inceptDate  == cardExpireDate) {
	    	customShowMessageBox("The card's expiry date cannot be the same with the inception date.", imgMessage.ERROR, "creditCardExpiryDate");
	    	isValid = false;
		}else if (expiryDate > cardExpireDate)  {
	   		showMessageBox("The card's expiry date is earlier than the PAR's expiry date.", imgMessage.INFO);
	   		isValid = false;
		}else if (expiryDate == cardExpireDate)  {
	   		showMessageBox("The card's expiry date is the same with the PAR's expiry date.", imgMessage.INFO);
	   		isValid = false;
		}else if  (endtExpiryDate > cardExpireDate)  {
	   		showMessageBox("The card's expiry date is earlier than the endorsement's expiry date.", imgMessage.INFO);
	   		isValid = false;
		}else if  (effDate > cardExpireDate)  {
	   		customShowMessageBox("The card's expiry date cannot be earlier than the endorsement's effectivity date.", imgMessage.ERROR, "creditCardExpiryDate");
	   		isValid = false;
		}

		return isValid;
	}
// 	function validateCardInformation(){ //remove by steven 07.23.2014
// 		var expireDate = Date.parse($("creditCardExpiryDate").value);
// 	    var dueDate = Date.parse($F("dueDate"));
// 	    var isValid = true;
	    
// 		if ($("selCreditCard").selectedIndex == 2 && $("others").value == ""){
// 			customShowMessageBox("Other credit card name is required.", imgMessage.ERROR, "others");
// 			isValid = false;
// 		}else if($("creditCardNo").value == ""){
// 			customShowMessageBox("Credit card number is required.", imgMessage.ERROR, "creditCardNo");
// 			isValid = false;
// 		}else if (isNaN($F("creditCardNo")) || parseFloat($F("creditCardNo")) < 0 || getDecimalLength($F("creditCardNo")) > 0){
// 			customShowMessageBox("Entered credit card number is invalid.", imgMessage.ERROR, "creditCardNo");
// 			isValid = false;
// 		}else if ($("creditCardExpiryDate").value == "") {
// 			customShowMessageBox("Expiry Date is required.", imgMessage.ERROR, "creditCardExpiryDate");
// 			isValid = false;
// 		/*} else if (!validateExpiryDates()){
// 			isValid = false;
// 			//customShowMessageBox("Credit expiry date cannot be earlier than last due date of payment schedule", imgMessage.ERROR, "creditCardExpiryDate");*/
// 		} else if($("creditCardApprovalCd").value == ""){
// 			customShowMessageBox("Approval code is required.", imgMessage.ERROR, "creditCardApprovalCd");
// 			isValid = false;
// 		} 
// /*
// 		if (objUW.lastTakeupDueDate > expireDate){
// 			customShowMessageBox("The Credit expiry date cannot be earlier than the last due date of the payment schedule.", imgMessage.ERROR, "creditCardExpiryDate");
// 			isValid = false;
// 		}*/

// 		return isValid;
// 	}

	function populateCardDtls(){
		var selItemGrp = $F("itemGrp");
		var selTakeup = $F("takeupSeqNo");
		
		for (var i=0; i<objUW.takeupListDtls.length; i++){
			if (objUW.takeupListDtls[i].itemGrp == selItemGrp && objUW.takeupListDtls[i].takeupSeqNo == selTakeup){
				if (objUW.takeupListDtls[i].cardName == "Master Card" || objUW.takeupListDtls[i].cardName == "Visa" || objUW.takeupListDtls[i].cardName == "Bankard"){
					$("selCreditCard").value = objUW.takeupListDtls[i].cardName;
					$("others").value = "";
					$("others").disabled = true;
					$("others").setStyle("background-color: white");
				}else {
					$("selCreditCard").selectedIndex = 2;
					$("others").disabled = false;
					$("others").setStyle("background-color:"+$("selCreditCard").getStyle("background-color"));
					$("others").value = objUW.takeupListDtls[i].cardName;
				}
				$("creditCardNo").value = objUW.takeupListDtls[i].cardNo;
				$("creditCardExpiryDate").value = objUW.takeupListDtls[i].expiryDate;
				$("creditCardApprovalCd").value = objUW.takeupListDtls[i].approvalCd;
				break;
			}
		}		
	}

	function modifyJSONCardDtls(){
		var selItemGrp = $F("itemGrp");
		var selTakeup = $F("takeupSeqNo");
		
		for (var i=0; i<objUW.takeupListDtls.length; i++){
			if (objUW.takeupListDtls[i].itemGrp == selItemGrp && objUW.takeupListDtls[i].takeupSeqNo == selTakeup){
				objUW.takeupListDtls[i].cardName	= $("selCreditCard").selectedIndex == 2 ? $F("others") : $("selCreditCard").options[$("selCreditCard").selectedIndex].value;
				objUW.takeupListDtls[i].cardNo		= parseInt($F("creditCardNo"));
				objUW.takeupListDtls[i].expiryDate	= $F("creditCardExpiryDate");
				objUW.takeupListDtls[i].approvalCd	= $F("creditCardApprovalCd");
				objUW.takeupListDtls[i].payType	= "R";
				objUW.takeupListDtls[i].recordStatus = 1;
				break;
			}
		}
	}

	$("selCreditCard").observe("change", function () {
		if ($("selCreditCard").selectedIndex == 2) {
			$("others").disabled = false;
			$("others").setStyle("background-color:"+$("selCreditCard").getStyle("background-color"));
			$("others").addClassName('required'); //added by steven 07.23.2014
		}else {
			$("others").disabled = true;
			$("others").setStyle("background-color: white");
			$("others").removeClassName('required'); //added by steven 07.23.2014
			$("others").value = "";
		}
	});

	$("creditCardExpiryDate").observe("blur", function () {
		if (this.value.trim() != "") {
			if (!validateExpiryDates()) {
				this.clear();
			}
		}
	});
</script>



	

