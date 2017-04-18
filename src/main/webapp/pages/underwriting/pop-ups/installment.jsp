<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");	response.setHeader("Pragma", "No-Cache");
%>

<div id="installmentListingMainDiv" name="installmentListingMainDiv" style="width: 921px;">
	<div id="installmentList" style="margin: 10px;" align="center">
		<div style="width: 100%; text-align: center;" id="installmentListingTable" name="installmentListingTable">
			<div class="tableHeader" id="tableHeaderInstallment">
				<label style="width: 10%; text-align: right;">Inst. No.</label>
				<label style="width: 16%; text-align: right;">Due Date</label>
				<label style="width: 16%; text-align: right;">% Share</label>	
				<label style="width: 20%; text-align: right;">Gross Premium</label>
				<label style="width: 17%; text-align: right;">Tax</label>
				<label style="width: 18%; text-align: right;">Total Due</label>
			</div>
			
			<div class="tableContainer" id="installmentTableListingContainer" name="installmentTableListingContainer" style="display: block">
				
			</div>
			<div id="divTotals" class="tableHeader" style="width: 100%; margin-bottom: 10px;">
	 			<label style="margin-left: 35px;">Total: </label>
	 			<label id="totalSharePct" style="margin-left: 226px; text-align: right; width: 80px;" id="totalSharePct" >0</label>
	 			<label id="totalPremAmt" style="width: 13%; text-align: right; margin-left: 66px;" class="money">0</label>
	 			<label id="totalTaxAmt" style="width: 13%; text-align: right; margin-left: 35px;" class="money">0</label>
	 			<label id="totalAmountDue" style="width: 13%; text-align: right; margin-left: 44px;" class="money">0</label>
 			</div>
			
		</div>
	</div>
</div>	
<div align="center">
	<table width="45%" align="center" cellspacing="1" border="0">
		<tr>
			<td class="rightAligned" style="padding-left: 50px" >Inst No. </td>
			<td class="leftAligned">
			  	<input type="text" id="installmentInstNo" name="installmentInstNo" class="money" style="width:192px; text-align: left" readonly="readonly" />		  
		  	</td> 
		</tr>
		<tr >
			<td class="rightAligned">Due Date</td>
			<td class="leftAligned">
			  	<div style="float:left; border: solid 1px gray; width: 72.3%; height: 21px; margin-right:3px;" class="required">
			      <input type="text" style="border: none; width:86%; height: 13px;" id="installmentDueDate" name="installmentDueDate" value="" class="required" readonly="readonly" />
			      <img id="hrefDueDate2" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('installmentDueDate'),this, null);" alt="Due Date" />
			    </div>
		  	</td>
		</tr>
		<tr>
			<td class="rightAligned">Total Due </td>
			<td class="leftAligned">
			 	<input type="text" id="installmentTotalDue" name="installmentTotalDue" class="money" style="width:192px; text-align: right" readonly="readonly"/>		  
			</td>
		</tr>	
	</table>
</div>

<div class="buttonsDiv" style="float:left; width: 100%; margin-bottom: 10px;">			
	<input style="margin-left: 25px;" type="button" style="width: 100px;" id="btnInstUpdate" name="btnInstUpdate" class="disabledButton" value="Update" />
</div> 

<script type="text/javascript">
	objUW.allowUpdateTaxEndtCancellation = '${allowUpdateTaxEndtCancellation}';	//Gzelle 07272015 SR4819
	var polFlag = objUWParList.packParId == null ? $F("globalPolFlag"): objUWGlobal.polFlag; //added by steven 1.29.2013;base on SR 0012056
	//added by steven 07.18.2014 base on the test case.
	if(parType == "E" && polFlag == "4" && objUW.allowUpdateTaxEndtCancellation == "N"){	//Gzelle 07272015 SR4819
		disableDate("hrefDueDate2");
	}
	if(nvl(polFlag, null) != null){ 
		var parType = (objUWGlobal.parType != null ? objUWGlobal.parType : $F("globalParType"));
		if(parType == "E" && polFlag == "4" && objUW.allowUpdateTaxEndtCancellation == "N"){	//Gzelle 07272015 SR4819
			disableDate("hrefDueDate2");
			$("installmentDueDate").readOnly = true;
		}
	}
		
	objUW.takeupInstallmentDtls = JSON.parse('${gipiWInstallmentJSON}'.replace(/\\/g, '\\\\'));
	function validateInstallmentDueDate(){
		var credExpiryDate = Date.parse(objUW.credExpiryDate);
		var credEffDate = Date.parse(objUW.credEffDate);
		var newDate = Date.parse($("installmentDueDate").value);	
		var isValid = true;
		var checkHigherInstNo = false;
		
		if  (newDate < credEffDate)  {
			customShowMessageBox("Due date schedule must not be earlier than the inception date of the policy.", imgMessage.ERROR, "dueDate");
			isValid = false;
			
		}else if  (newDate  > credExpiryDate && objUW.allowExpiredPolIssuance == "N") { //added allowExpiredPolIssuance by robert SR 19785 07.20.15
	    	customShowMessageBox("Due date schedule must not be later than the expiry date of the policy.", imgMessage.ERROR, "dueDate");
	    	isValid = false;
		}else{
			//added by steven 08.04.2014
			for ( var i = 0; i < objUW.takeupInstallmentDtls.length; i++) {
				if (!checkHigherInstNo && parseInt($F("installmentInstNo")) != parseInt(objUW.takeupInstallmentDtls[i].instNo)) {
					if (newDate < Date.parse(objUW.takeupInstallmentDtls[i].dueDate)) {
						customShowMessageBox("Due date must be in proper sequence.", imgMessage.ERROR, "dueDate");
				    	isValid = false;
				    	break;
					}
				}else if (checkHigherInstNo && parseInt($F("installmentInstNo")) != parseInt(objUW.takeupInstallmentDtls[i].instNo)) {
					if (newDate > Date.parse(objUW.takeupInstallmentDtls[i].dueDate)) {
						customShowMessageBox("Due date must be in proper sequence.", imgMessage.ERROR, "dueDate");
				    	isValid = false;
				    	break;
					}
				}else if(parseInt($F("installmentInstNo")) == parseInt(objUW.takeupInstallmentDtls[i].instNo)){
					checkHigherInstNo = true;
				}
				
			}
		}
		return isValid; 
	}
	
	$("btnInstUpdate").observe("click", function () { 
		var selItemGrp = $F("itemGrp");
		var selTakeup  = $F("takeupSeqNo");
		var selInstNo  = $F("installmentInstNo");
		
		if (validateInstallmentDueDate()){
			markInstallmentUpdated();
			$$("div[name='installmentDtlsRow']").each(function (r) {
				if (r.getAttribute("itmGrp") == $F("itemGrp") && r.getAttribute("takeupSeqNo") == $F("takeupSeqNo") && r.getAttribute("instNo") == selInstNo ){
					r.setAttribute("dueDate", $F("installmentDueDate") );
				}
			});
			$("row"+selItemGrp+ "" + selTakeup + "" + selInstNo).setAttribute("dueDate", $F("installmentDueDate"));
			$("lblInstallmentDueDate"+ selItemGrp + selTakeup + selInstNo).innerHTML = $F("installmentDueDate"); //added by pjd 08/29/2013 to correctly adjust margin 
			$("lblInstallmentDueDate"+ selItemGrp + selTakeup + selInstNo).next().setStyle("margin-left: 25px");//when updating from null to correct duedate in connection with SR13796 
			$$("div[name='installmentDtlsRow']").each(function (r) {
				r.removeClassName("selectedRow");
			});
			disableButton("btnInstUpdate");
			clearAllValues();
		}
	});
	
	function markInstallmentUpdated(){
		var selItemGrp = $F("itemGrp");
		var selTakeup  = $F("takeupSeqNo");
		var selInstNo  = $F("installmentInstNo");
		for (var i=0; i<objUW.takeupInstallmentDtls.length; i++){
			if (objUW.takeupInstallmentDtls[i].itemGrp == selItemGrp && objUW.takeupInstallmentDtls[i].takeupSeqNo == selTakeup && objUW.takeupInstallmentDtls[i].instNo == selInstNo) {
				objUW.takeupInstallmentDtls[i].recordStatus = 1;
				objUW.takeupInstallmentDtls[i].dueDate = $F("installmentDueDate");
				break;
			}
		}
	}
	
	function clearAllValues(){
		$("installmentInstNo").value = null;
		$("installmentDueDate").value = null;
		$("installmentTotalDue").value = null;
	}
	
	//showInstallmentDtls(objUW.takeupInstallmentDtls);
	/*
	function showInstallmentDtls(objArray){
		try {
			var itemTable = $("installmentTableListingContainer");
			
			for(var i=0; i<objArray.length; i++) {					
				var content = prepareInstallmentDtlsInfo(objArray[i]);										
				var newDiv = new Element("div");
				newDiv.setAttribute("id", "row"+objArray[i].itemGrp+ "" +objArray[i].takeupSeqNo + "" + objArray[i].instNo);
				newDiv.setAttribute("name", "installmentDtlsRow");
				newDiv.setAttribute("itmGrp", objArray[i].itemGrp);
				newDiv.setAttribute("takeupSeqNo", objArray[i].takeupSeqNo);
				newDiv.setAttribute("instNo", objArray[i].instNo);
				newDiv.setAttribute("dueDate", objArray[i].dueDate);
				newDiv.setAttribute("totalDue", objArray[i].totalDue);
				newDiv.addClassName("tableRow");
				
				newDiv.update(content);
				itemTable.insert({bottom : newDiv});
				divEvents(newDiv);
			}
			checkIfToResizeTable("installmentTableListingContainer", "installmentDtlsRow");
			checkTableIfEmpty("installmentDtlsRow", "installmentListingTable");
		} catch (e) {
			showErrorMessage("showInstallmentDtls", e);
			//showMessageBox("showInstallmentDtls : " + e.message);
		}
	}

	function prepareInstallmentDtlsInfo(obj){
		try {		
			var itemTaxInfo =   		
			  	'<label style="width: 10%; text-align: right;">'+ obj.instNo +'</label>'+
				'<label style="width: 13%; text-align: right; margin-left: 32px;">' + obj.dueDate+ '</label>' +
				'<label style="width: 13%; text-align: right; margin-left: 29px;" >' + obj.sharePct + '</label>' +
				'<label style="width: 13%; text-align: right; margin-left: 66px;">' + formatCurrency(obj.premAmt) + '</label>' +
				'<label style="width: 13%; text-align: right; margin-left: 38px;">' + formatCurrency(obj.taxAmt) + '</label>' +
				'<label style="width: 13%; text-align: right; margin-left: 48px;">' + formatCurrency(parseFloat(obj.premAmt) + parseFloat(obj.taxAmt)) + '</label>';
				
			return itemTaxInfo;
		} catch (e) {
			showErrorMessage("prepareInstallmentDtlsInfo", e);
			//showMessageBox("prepareInstallmentInfo : " + e.message);
		}
	}

	function divEvents(div) {
		div.observe("mouseover", function () {
			div.addClassName("lightblue");
		});
		
		div.observe("mouseout", function ()	{
			div.removeClassName("lightblue");
		});

		div.observe("click", function () {
			selectedRowId = div.getAttribute("id");
			div.toggleClassName("selectedRow");
			if (div.hasClassName("selectedRow"))	{
				$$("div[name='installmentDtlsRow']").each(function (r)	{
					if (div.getAttribute("id") != r.getAttribute("id"))	{
						r.removeClassName("selectedRow");
					}else{
						$("tableHeaderInstallment").setStyle("background-color:" + $("taxTableHeader").getStyle("background-color"));
						$("installmentInstNo").value = r.getAttribute("instNo");
						$("installmentDueDate").value = r.getAttribute("dueDate");
						$("installmentTotalDue").value = r.getAttribute("amountDue");
						enableButton("btnInstUpdate");
					}
			    });		
			}else{
				
			} 
		});
	}
	
	initializeAll();
	initializeAllMoneyFields();
	*/
</script>
