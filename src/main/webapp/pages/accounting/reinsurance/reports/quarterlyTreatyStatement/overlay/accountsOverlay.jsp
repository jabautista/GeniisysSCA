<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="acctsMainDiv" name="acctsMainDiv">
	<div id="acctsSubDiv" name="acctsSubDiv" class="sectionDiv" style="width: 900px; margin: 10px 2px 2px 2px;" changeTagAttr="true">
		<div id="cashAcctDiv" name="cashAcctDiv" style="width: 415px; margin: 5px 5px 5px 10px; float: left;">
			<fieldset>
				<legend><b>Cash Account</b></legend>
				<table border="0" style="margin: 5px 0 5px 5px;">
					<tr>
						<td class="rightAligned" style="width: 105px;">Previous Balance</td>
						<td><input type="text" id="txtPrevBalance" name="txtPrevBalance" class="money" errorMsg="Field must be of form 999,999,999,990.90" style="text-align:right; margin-left: 5px;" tabindex="101" /></td>
						<td class="rightAligned" style="width:40px;">as of</td>
						<td><input type="text" id="txtPrevBalanceDt" name="txtPrevBalanceDt" style="width: 80px; margin-left: 5px;" tabindex="102" /></td>
					</tr>
					<tr>
						<td class="rightAligned">Balance as above</td>
						<td><input type="text" id="txtBalanceAsAbove" name="txtBalanceAsAbove" class="money" errorMsg="Field must be of form 999,999,999,990.90" style="text-align:right; margin-left: 5px;"  tabindex="103" readonly="readonly"  /></td>
					</tr>
					<tr>
						<td class="rightAligned">Our remittance</td>
						<td><input type="text" id="txtOurRemittance" name="txtOurRemittance" class="money" errorMsg="Field must be of form 999,999,999,990.90" style="text-align:right; margin-left: 5px;"  tabindex="104" /></td>
					</tr>
					<tr>
						<td class="rightAligned">Your remittance</td>
						<td><input type="text" id="txtYourRemittance" name="txtYourRemittance" class="money" errorMsg="Field must be of form 999,999,999,990.90" style="text-align:right; margin-left: 5px;" tabindex="105" /></td>
					</tr>
					<tr>
						<td class="rightAligned">Cash Call Paid</td>
						<td><input type="text" id="txtCashCallPaid" name="txtCashCallPaid" class="money" errorMsg="Field must be of form 999,999,999,990.90" style="text-align:right; margin-left: 5px;" tabindex="106" /></td>
					</tr>
					<tr>
						<td class="rightAligned">Balance in (Our) / Your Favor</td>
						<td><input type="text" id="txtCashBalInFavor" name="txtCashBalInFavor" style="text-align:right; margin-left: 5px;" readonly="readonly" tabindex="107" /></td>
					</tr>
				</table>
			</fieldset>
		</div> <!-- end: cashAcctDiv -->
		
		<div id="reserveAcctDiv" name="reserveAcctDiv" style="width: 455px; margin: 5px 10px 5px 5px; float: left;">
			<fieldset>
				<legend><b>Reserve Account</b></legend>
				<table border="0" style="margin: 5px 0 5px 0;">
					<tr>
						<td class="rightAligned" style="width: 150px;">Previous Balance</td>
						<td><input type="text" id="txtPrevResvBalance" name="txtPrevResvBalance" class="money" errorMsg="Field must be of form 999,999,999,990.90" style="text-align:right; margin-left: 5px; width: 130px;" tabindex="201" /></td>
						<td class="rightAligned" style="width:35px;">as of</td>
						<td><input type="text" id="txtPrevResvBalDt" name="txtPrevResvBalDt" style="width: 80px; margin-left: 5px;" tabindex="202" /></td>
					</tr>
					<tr style="height:26px;"><td>&nbsp;</td></tr>
					<tr>
						<td class="rightAligned">Prem. Reserve Retained</td>
						<td><input type="text" id="txtPremResvRetndAmt" name="txtPremResvRetndAmt" style="text-align:right; margin-left: 5px;" readonly="readonly" tabindex="203" /></td>
					</tr>
					<tr>
						<td class="rightAligned">Prem. Reserve Released</td>
						<td><input type="text" id="txtPremResvRelsdAmt" name="txtPremResvRelsdAmt" style="text-align:right; margin-left: 5px;" readonly="readonly" tabindex="204" /></td>
					</tr>
					<tr style="height:26px;"><td>&nbsp;</td></tr>
					<tr>
						<td class="rightAligned" style="width: 105px;">Balance</td>
						<td><input type="text" id="txtResvBalance" name="txtResvBalance" style="text-align:right; margin-left: 5px; width: 130px;" readonly="readonly" tabindex="205" /></td>
						<td class="rightAligned" style="width:35px;">as of</td>
						<td><input type="text" id="txtResvBalanceDt" name="txtResvBalanceDt" style="width: 80px; margin-left: 5px;" tabindex="206" /></td>
					</tr>
				</table>
			</fieldset>
		</div> <!-- end: reserveAcctDiv -->
		
		<div id="userIdLastUpdateDiv" name="userIdLastUpdateDiv" class="sectionDiv" style="width:880px; border: none;">
			<table style="margin: 10px 10px 10px 230px;">
				<tr>
					<td class="rightAligned">User ID</td>
					<td><input type="text" id="txtCAUserId" name="txtCAUserId" style="margin-left: 5px;" readonly="readonly"  tabindex="301" /></td>
					<td class="rightAligned" style="width:120px;">Last Update</td>
					<td><input type="text" id="txtCALastUpdate" name="txtCALastUpdate" style="margin-left: 5px;" readonly="readonly" tabindex="302" /></td>
				</tr>
			</table>
		</div>
	</div>
	
	<div class="buttonsDiv" style="width:880px; margin: 20px 10px 10px 10px;">
		<input type="button" class="button" id="btnAcctsReturn" name="btnAcctsReturn" value="Return" style="width: 90px;" />
		<input type="button" class="button" id="btnAcctsSave" name="btnAcctsSave" value="Save" style="width: 90px;" />
	</div>
</div>

<script type="text/javascript">

	var treatyCashAcct = JSON.parse('${treatyCashAcct}');
	
	function setItems2(){
		$("txtPrevBalance").value 		= formatCurrency(nvl(treatyCashAcct.prevBalance, ""));
		$("txtPrevBalanceDt").value 	= nvl(treatyCashAcct.prevBalanceDt, "");
		$("txtBalanceAsAbove").value 	= formatCurrency(nvl(treatyCashAcct.balanceAsAbove, 0));
		$("txtOurRemittance").value 	= formatCurrency(nvl(treatyCashAcct.ourRemittance, ""));
		$("txtYourRemittance").value 	= formatCurrency(nvl(treatyCashAcct.yourRemittance, ""));
		$("txtCashCallPaid").value 		= formatCurrency(nvl(treatyCashAcct.cashCallPaid, ""));
		$("txtCashBalInFavor").value 	= formatCurrency(nvl(treatyCashAcct.cashBalInFavor, 0));
		
		$("txtPrevResvBalance").value 	= formatCurrency(nvl(treatyCashAcct.prevResvBalance, ""));
		$("txtPrevResvBalDt").value 	= nvl(treatyCashAcct.prevResvBalDt, "");
		
		$("txtPremResvRetndAmt").value 	= formatCurrency(nvl(objGtqs.premResvRetndAmt, 0));
		$("txtPremResvRelsdAmt").value 	= formatCurrency(nvl(objGtqs.premResvRelsdAmt, 0));
		
		//$("txtResvBalance").value = nvl(treatyCashAcct.resvBalance, 0);
		$("txtResvBalance").value 		= formatCurrency(	parseFloat(nvl(unformatCurrency("txtPrevResvBalance"), 0)) // changed treatyCashAcct.resvBalance to $F("txtPrevResvBalance")
									  					  + parseFloat(nvl(objGtqs.premResvRetndAmt, 0)) 
									  					  - parseFloat(nvl(objGtqs.premResvRelsdAmt, 0)) );
		$("txtResvBalanceDt").value 	= nvl(treatyCashAcct.resvBalanceDt, "");
		
		$("txtCAUserId").value 			= nvl(treatyCashAcct.userId, "");
		$("txtCALastUpdate").value 		= nvl(treatyCashAcct.lastUpdate, "");
	} 
	
	function computeForCashBalInFavor(){
		if(!isNaN(nvl($F("txtPrevBalance"), 0)) && !isNaN(nvl($F("txtOurRemittance"), 0)) && !isNaN(nvl($F("txtBalanceAsAbove"), 0)) &&
				!isNaN(nvl($F("txtYourRemittance"), 0)) && !isNaN(nvl($F("txtCashCallPaid"), 0))){
			var prevBalance 	= parseFloat(nvl($F("txtPrevBalance"), 0));
			var balanceAsAbove  = parseFloat(nvl($F("txtBalanceAsAbove"), 0));
			var ourRemittance 	= parseFloat(nvl($F("txtOurRemittance"), 0));
			var yourRemittance 	= parseFloat(nvl($F("txtYourRemittance"), 0));
			var cashCallPaid 	= parseFloat(nvl($F("txtCashCallPaid"), 0));
			var cashBalInFavor = prevBalance + balanceAsAbove - ourRemittance + yourRemittance + cashCallPaid;
			$("txtCashBalInFavor").value = formatCurrency(cashBalInFavor);			
		}
	}
	
	$("txtPrevBalance").observe("change", computeForCashBalInFavor);
	$("txtOurRemittance").observe("change", computeForCashBalInFavor);
	$("txtYourRemittance").observe("change", computeForCashBalInFavor);
	$("txtCashCallPaid").observe("change", computeForCashBalInFavor);
	
	$("txtPrevResvBalance").observe("change", function(){
		if(!isNaN(nvl($F("txtPrevResvBalance"), 0)) && !isNaN(nvl($F("txtPremResvRetndAmt"), 0)) && !isNaN(nvl($F("txtPremResvRelsdAmt"), 0))){ 
			var prevResvBalance = parseFloat(nvl($F("txtPrevResvBalance"), 0));
			var premResvRetndAmt = parseFloat(nvl($F("txtPremResvRetndAmt"), 0));
			var prevResvRelsdAmt = parseFloat(nvl($F("txtPremResvRelsdAmt"), 0));
			var resvBalance = prevResvBalance + premResvRetndAmt - prevResvRelsdAmt;
			$("txtResvBalance").value = formatCurrency(resvBalance);
			$("txtResvBalanceDt").value = treatyCashAcct.resvBalanceAsOf;
		}
	});
	
	$("btnAcctsReturn").observe("click", function(){
		if(changeTag == 0){
			accountsOverlay.close();	
		} else {
			// notify user
			showConfirmBox4("Confirmation", "Do you want to save the changes you have made?", "Yes", "No", "Cancel",
							saveTreatyCashAcct, // Yes
							function(){ accountsOverlay.close(); },
							"", "Yes");
		}		
	});
	
	function saveTreatyCashAcct(){
		try {
			new Ajax.Request(contextPath + "/GIACReinsuranceReportsController",{
				method: "POST",
				parameters : {
					action				: "saveTreatyCashAcct",
					summaryId			: treatyCashAcct.summaryId,
					prevBalance			: unformatCurrency("txtPrevBalance"),
					prevBalanceDt		: $F("txtPrevBalanceDt"),
					ourRemittance		: unformatCurrency("txtOurRemittance"),
					yourRemittance		: unformatCurrency("txtYourRemittance"),
					cashCallPaid		: unformatCurrency("txtCashCallPaid"),
					cashBalInFavor		: unformatCurrency("txtCashBalInFavor"),
					prevResvBalance		: unformatCurrency("txtPrevResvBalance"),
					prevResvBalDt		: $F("txtPrevResvBalDt"),
					resvBalance			: unformatCurrency("txtResvBalance"),
					resvBalanceDt		: $F("txtResvBalanceDt")
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Saving, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						if(response.responseText == "SUCCESS"){
							showMessageBox(objCommonMessage.SUCCESS, "I");
						}
					}
				}
			});
		} catch(e){
			showErrorMessage("saveTreatyStatement: ",e);
		}
	}
	
	$("btnAcctsSave").observe("click", saveTreatyCashAcct);
	
	initializeAll();
	initializeAllMoneyFields();
	setItems2();
</script>