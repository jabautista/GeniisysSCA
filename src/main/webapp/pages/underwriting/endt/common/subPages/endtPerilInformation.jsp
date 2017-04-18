<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div style="margin: 10px 15px 10px 0px;">	
	<table align="center" border="0" width="82%">
		<tr>
			<td class="rightAligned" 	width="14%" id="tdTotalItemTsiAmt">Total Item TSI Amt.</td>
			<td class="leftAligned" 	width="16%"><input type="text" class="money1" value="0" maxlength="17" id="itemTsiAmt"	name="inputTsiAmt" style="width: 96%;" readonly="readonly"/></td>
			<td class="rightAligned" 	width="18%" id="tdTotalItemPremAmt">Total Item Premium Amt.</td>
			<td class="leftAligned" 	width="16%"><input type="text" class="money1" value="0" maxlength="17" id="itemPremiumAmt"	name="inputTsiAmt" style="width: 96%;" readonly="readonly"/></td>
		</tr>
		<tr>
			<td class="rightAligned" id="tdTotalItemAnnTsiAmt">Total Item Ann. TSI Amt.</td>
			<td class="leftAligned"><input type="text" class="money1" value="0" maxlength="17" id="itemAnnTsiAmt" name="inputTsiAmt" style="width: 96%;" readonly="readonly"/></td>
			<td class="rightAligned" id="tdTotalItemAnnPremAmt">Total Item Ann. Premium Amt.</td>
			<td class="leftAligned"><input type="text" class="money1" value="0" maxlength="17" id="itemAnnPremiumAmt" name="inputTsiAmt" style="width: 96%;" readonly="readonly"/></td>
		</tr>
	</table>
</div>		
<div style="border: 1px solid #E0E0E0;">
	<div id="itemPerils" style="display: none;">
		<c:forEach var="endtPolicy" items="${endtPolicy}">
			<div id="endtPol${endtPolicy.policyId}" name="endtPol" style="display: none;">
				<input type="hidden" name="hidPolicyId"			value="${endtPolicy.policyId}" /> 
				<input type="hidden" name="hidEndtNo"			value="${endtPolicy.endtNo}" /> 
				<input type="hidden" name="hidInceptDate" 		value="${endtPolicy.inceptDate}" /> 
				<input type="hidden" name="hidEffDate" 			value="${endtPolicy.effDate}" />
				<input type="hidden" name="hidExpiryDate" 		value="${endtPolicy.expiryDate}" />
				<input type="hidden" name="hidEndtExpiryDate"	value="${endtPolicy.endtExpiryDate}" />	
											
				<c:forEach var="peril" items="${itemPerils}" varStatus="ctr">
					<c:if test="${endtPolicy.policyId eq peril.policyId}">
						<div id="rowPeril${peril.itemNo}${peril.perilCd}" policyId="${peril.policyId}" name="rowPeril" style="display: none;">
							<input type="hidden" name="hidItemNo1"			value="${peril.itemNo}" /> 
							<input type="hidden" name="hidPerilCd1"			value="${peril.perilCd}" /> 
							<input type="hidden" name="hidPerilName1" 		value="${peril.perilName}" /> 
							<input type="hidden" name="hidPremiumRate1" 	value="${peril.premiumRate}" /> 
							<input type="hidden" name="hidTsiAmount1" 		value="${peril.tsiAmount}" /> 
							<input type="hidden" name="hidAnnTsiAmount1" 	value="${peril.annTsiAmount}" />
							<input type="hidden" name="hidPremiumAmount1" 	value="${peril.premiumAmount}" /> 
							<input type="hidden" name="hidAnnPremiumAmount1" value="${peril.annPremiumAmount}" /> 
							<input type="hidden" name="hidCompRem1" 		value="${peril.compRem}" />
							<input type="hidden" name="hidDiscSum" 			value="" /> 
							<input type="hidden" name="hidRecFlag1" 		value="${peril.recFlag}" />
							<input type="hidden" name="hidBasicPerilCd1" 	value="${peril.bascPerlCd}" />
							<input type="hidden" name="hidRiCommRate1" 		value="${peril.riCommRate}" />
							<input type="hidden" name="hidRiCommAmount1" 	value="${peril.riCommAmount}" />							
							<input type="hidden" name="hidTariffCd1" 		value="${peril.tarfCd}" />
							<input type="hidden" name="hidPerilType1" 		value="${peril.perilType}" />
							<input type="hidden" name="hidNoOfDays"			value="${peril.noOfDays}" />
							<input type="hidden" name="hidBaseAmt"			value="${peril.baseAmount}" />
						</div>
					</c:if>		
				</c:forEach>																			
			</div>
		</c:forEach>
	</div>
</div>
<div id="endtPerilInformation" style="margin: 10px;">
	<div id="endtPerilTable" name="endtPerilTable">
		<div id="forDeleteDiv" name="forDeleteDiv" style="visibility: hidden; display: none;">
		</div>
		<div id="forInsertDiv" name="forInsertDiv" style="">
		</div>
		<div id="otherParamsDiv" name="otherParamsDiv" style="visibility: hidden; display: none;">
			<input type="hidden" id="delDiscSw" name="delDiscSw" value="N" />
			<input type="hidden" id="deldiscItemNos" name="deldiscItemNos" value="" /> 
			<input type="hidden" id="delDiscounts" 				name="delDiscounts" 			value="N" />
			<input type="hidden" id="delPercentTsiDeductibles" 	name="delPercentTsiDeductibles" value="N" />
			<input type="hidden" id="updateEndtTax" 			name="updateEndtTax" 			value="N" />
			<input type="hidden" id="parTsiAmount"				name="parTsiAmount"				value="0">
			<input type="hidden" id="parAnnTsiAmount"			name="parAnnTsiAmount"			value="0">
			<input type="hidden" id="parPremiumAmount"			name="parPremiumAmount"			value="0">
			<input type="hidden" id="parAnnPremiumAmount"		name="parAnnPremiumAmount"		value="0">
		</div>
		<div class="tableHeader" id="tableHeaderDiv1">
			<label style="width: 36px; text-align: center; margin-left: 3px;">Item</label> 
			<label style="width: 135px; text-align: left; margin-left: 5px;">Peril Name</label> 
			<label style="width: 132px; text-align: right; margin-left: 3px;">Premium Rate</label> 
			<label id="hdrTsi" 		  style="width: 132px; text-align: right; margin-left: 3px;">TSI Amt.</label> 
			<label id="hdrAnnTsi" 	  style="width: 132px; text-align: right; margin-left: 3px;">Ann. TSI Amt.</label> 
			<label id="hdrPremium" 	  style="width: 132px; text-align: right; margin-left: 3px;">Premium Amt.</label> 
			<label id="hdrAnnPremium" style="width: 145px; text-align: right; margin-left: 3px;">Ann. Premium Amt.</label> 
		</div>
		<div class="tableHeader" id="tableHeaderDiv2" style="display: none;">
			<label style="width: 36px; text-align: center; margin-left: 3px;">Item</label> 
			<label style="width: 135px; text-align: left; margin-left: 5px;">Peril Name</label> 
			<label style="width: 135px; text-align: right; margin-left: 3px;">RI Rate</label> 
			<label style="width: 140px; text-align: right; margin-left: 3px;">Commission Amount</label> 
			<label style="width: 140px; text-align: right; margin-left: 3px;">Premium Ceded</label>
		</div>					
		<div class="tableContainer" id="perilTableContainerDiv">						
			<c:forEach var="endtPeril" items="${endtItemPerils}" varStatus="ctr">
				<div id="rowEndtPeril${endtPeril.itemNo}${endtPeril.perilCd}" name="rowEndtPeril" class="tableRow" item="${endtPeril.itemNo}" perilCd="${endtPeril.perilCd}">
					<input type="hidden" name="hidItemNo" 		 	value="${endtPeril.itemNo}" /> 
					<input type="hidden" name="hidPerilCd" 		 	value="${endtPeril.perilCd}" /> 
					<input type="hidden" name="hidPerilName" 	 	value="${endtPeril.perilName}" /> 
					<input type="hidden" name="hidPremiumRate" 	 	value="${endtPeril.premRt}" /> 
					<input type="hidden" name="hidTsiAmount" 	 	value="${endtPeril.tsiAmt}" /> 
					<input type="hidden" name="hidAnnTsiAmount"  	value="${endtPeril.annTsiAmt}" />
					<input type="hidden" name="hidPremiumAmount" 	value="${endtPeril.premAmt}" /> 
					<input type="hidden" name="hidAnnPremiumAmount" value="${endtPeril.annPremAmt}" /> 
					<input type="hidden" name="hidRemarks" 			value="${endtPeril.compRem}" /> 
					<input type="hidden" name="hidDiscSum" 			value="${endtPeril.discSum}" /> 
					<input type="hidden" name="hidRecFlag" 			value="${endtPeril.recFlag}" />
					<input type="hidden" name="hidBasicPerilCd" 	value="${endtPeril.bascPerlCd}" />
					<input type="hidden" name="hidRiCommRate" 		value="${endtPeril.riCommRate}" />
					<input type="hidden" name="hidRiCommAmount" 	value="${endtPeril.riCommAmt}" />
					<input type="hidden" name="hidTariffCd" 		value="${endtPeril.tarfCd}" />
					<input type="hidden" name="hidPerilType" 		value="${endtPeril.perilType}" />
					<input type="hidden" name="hidNoOfDays"			value="${endtPeril.noOfDays}" />
					<input type="hidden" name="hidBaseAmt"			value="${endtPeril.baseAmt}" />					
					 
					<div id="labelDiv1">
						<label name="lblItemNo" 			style="width: 36px; text-align: center; margin-left: 3px;">${endtPeril.itemNo}</label>
						<label name="lblPerilName" 			style="width: 135px; text-align: left; margin-left: 5px;">${endtPeril.perilName}</label>
						<label name="lblPremiumRate" 		style="width: 132px; text-align: right; margin-left: 3px;">${endtPeril.premRt}</label>
						<label name="lblTsiAmount" 			style="width: 132px; text-align: right; margin-left: 3px;">${endtPeril.tsiAmt}</label>
						<label name="lblAnnTsiAmount" 		style="width: 132px; text-align: right; margin-left: 3px;">${endtPeril.annTsiAmt}</label>
						<label name="lblPremiumAmount" 		style="width: 132px; text-align: right; margin-left: 3px;">${endtPeril.premAmt}</label>
						<label name="lblAnnPremiumAmount" 	style="width: 145px; text-align: right; margin-left: 3px;">${endtPeril.annPremAmt}</label>
					</div>
					<div id="labelDiv2" style="display: none;">
						<label name="lblItemNo" 			style="width: 36px; text-align: center; margin-left: 3px;">${endtPeril.itemNo}</label>
						<label name="lblPerilName" 			style="width: 135px; text-align: left; margin-left: 5px;">${endtPeril.perilName}</label>
						<label name="lblRIRate" 			style="width: 135px; text-align: right; margin-left: 3px;">${endtPeril.riCommRate}</label>
						<label name="lblCommissionAmount" 	style="width: 140px; text-align: right; margin-left: 3px;">${endtPeril.riCommAmt}</label>
						<label name="lblPremiumCeded" 		style="width: 140px; text-align: right; margin-left: 3px;">${endtPeril.premAmt}</label>
					</div>									
					
					<input type="hidden" name="hidEndtAnnTsiAmount"  	value="${endtPeril.endtAnnTsiAmt}" />
					<input type="hidden" name="hidEndtAnnPremiumAmount" value="${endtPeril.endtAnnPremAmt}" />
					<input type="hidden" name="hidBaseAnnPremAmt" 		value="${endtPeril.baseAnnPremAmt}" />
				</div>
			</c:forEach>
		</div>
		<div id="loadingDiv" style="display: none;"></div>
	</div>
</div>
<div id="itemPerilFormDiv" style="margin-top: 10px; display: block;" changeTagAttr="true">
	<table align="center" border="0" width="82%">
		<tr>
			<td class="rightAligned" width="9%">Peril Name</td>
			<td class="leftAligned" width="18%">
				<div style="float: left; border: solid 1px gray; width: 100%; height: 21px;" class="required" >
					<input type="hidden" id="perilCd" name="perilCd" style="display: none;"/>
					<input type="hidden" id="basicPerilCd" name="basicPerilCd" style="display: none;" />					
					<input type="text" tabindex="905" style="float: left; margin-top: 0px; width: 85%; border: none;" name="txtPerilName" id="txtPerilName" readonly="readonly" value="" class="required" />
					<img id="hrefPeril" alt="goPeril" style="height: 18px;"  class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />
					<input type="hidden" id="hidPerilRecFlag" name="hidPerilRecFlag" />					
				</div>
<%-- 				<input type="hidden" id="txtPerilCd" style="width: 96%; display: none;"/>
				<input type="text" id="txtPerilDisplay" style="width: 96%; display: none;" class="required"/>
				<select name="perilCd" id="perilCd" class="required" style="width: 100%;">
					<option value=""></option>
					<optgroup label="Basic">
						<c:forEach var="peril" items="${perilsList}">
							<c:if test="${'B' eq peril.perilType}">
								<option perilType="${peril.perilType}" basicPerilCd="${peril.bascPerlCd}" dfltTsi="${peril.dfltTsi}" defaultRate="${peril.defaultRate}" defaultTag="${peril.defaultTag}" value="${peril.perilCd}">${peril.perilName}</option>										
							</c:if>																											
						</c:forEach>
					</optgroup>
					<optgroup label="Allied">
						<c:forEach var="peril" items="${perilsList}">
							<c:if test="${'A' eq peril.perilType}">
								<option perilType="${peril.perilType}" basicPerilCd="${peril.bascPerlCd}" dfltTsi="${peril.dfltTsi}" defaultRate="${peril.defaultRate}" defaultTag="${peril.defaultTag}" value="${peril.perilCd}">${peril.perilName}</option>										
							</c:if>
						</c:forEach>
					</optgroup>
				</select>
 --%>			</td>
			<td class="rightAligned" width="12%">Premium Rate</td>
			<td class="leftAligned" width="18%"><input type="text" class="percentRate required" value="0" maxlength="13" style="width: 96%;" id="inputPremiumRate" name="inputPremiumRate" message="new"/></td>
			<td rowspan="4" style="width: 14%;" id="sideButtonsTd">
				<table border="0" align="right">
					<tr align="center">
						<td><input id="btnRetrievePerils" class="disabledButton" type="button" style="width: 100%;" value="Retrieve Perils"	name="btnRetrievePerils" /></td>
					</tr>
					<tr align="center">
						<td><input id="btnDeleteDiscounts" class="disabledButton" type="button" style="width: 100%;" value="Delete Discounts" name="btnDeleteDiscounts" /></td>
					</tr>
					<tr align="center">
						<td><input id="btnCopyPeril" class="disabledButton"	type="button" style="width: 100%;" value="Copy Peril" name="btnCopyPeril" /></td>
					</tr>
					<tr align="center" id="btnCommContainer">
						<td><input id="btnCommission" class="button" type="button" style="width: 100%;" value="Commission" name="btnCommission" /></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" id="tdTsiAmt">TSI Amt.</td>
			<td class="leftAligned"><input type="text" class="money1 required" value="0" maxlength="17" id="inputTsiAmt" name="inputTsiAmt" style="width: 96%;" /></td>
			<td class="rightAligned" id="tdPremAmt">Premium Amt.</td>
			<td class="leftAligned"><input type="text" class="money1 required" value="0" maxlength="17" id="inputPremiumAmt" name="inputPremiumAmt" style="width: 96%;" /></td>
		</tr>
		<tr>
			<td class="rightAligned" id="tdAnnTsiAmt">Ann. TSI Amt.</td>
			<td class="leftAligned"><input type="text" class="money1 required" value="0" maxlength="17" id="inputAnnTsiAmt"	name="inputAnnTsiAmt" style="width: 96%;" readonly="readonly" /></td>
			<td class="rightAligned" id="tdAnnPremAmt">Ann. Premium Amt.</td>
			<td class="leftAligned"><input type="text" class="money1 required" value="0" maxlength="17" id="inputAnnPremiumAmt" name="inputAnnPremiumAmt" style="width: 96%;" readonly="readonly" /></td>
		</tr>
		<tr>
			<td class="rightAligned" id="lblRiAmtTd">Comm. Amount</td>
			<td class="leftAligned"  id="inputRiAmtTd"><input type="text" class="money1" value="0" maxlength="12" id="inputRiCommAmt" name="inputRiCommAmt" style="width: 96%;" riCommAmt="0" /></td>
			<td class="rightAligned" id="lblRiRateTd">RI Rate</td>
			<td class="leftAligned"  id="inputRiRateTd"><input type="text" class="percentRate" value="0" maxlength="12" id="inputRiCommRate" name="inputRiCommRate" style="width: 96%;" riCommRate="0"/></td>
		</tr>
		<tr>
			<td class="rightAligned" id="lblTariffCdTd">Tariff Code</td>
			<td class="leftAligned"	 id="inputTariffCdTd">
				<select name="inputPerilTariff" id="inputPerilTariff" style="width: 100%;">
					<option value=""></option>
				</select>
				<c:forEach var="peril" items="${perilsList}">							
					<select name="inputPerilTariff" id="inputPerilTariff${peril.perilCd}" style="width: 100%;">
						<option value=""></option>
						<c:forEach var="tariff" items="${perilTariffs}">
							<c:if test="${peril.perilCd eq tariff.perilCd}">
								<option tarfRate="${tariff.tarfRate}" value="${tariff.tarfCd}">
									<c:if test="${empty tariff.tarfDesc}">${tariff.tarfCd}</c:if>
									${tariff.tarfDesc}
								</option>
							</c:if>
						</c:forEach>
					</select>
				</c:forEach>							
			</td>	
			<td class="rightAligned" id="lblBaseAmtTd">Base Amount</td>
			<td class="leftAligned"  id="inputBaseAmtTd"><input type="text" class="money2" value="0" maxlength="5" id="inputBaseAmt" name="inputBaseAmt" style="width: 96%;" readonly="readonly" /></td>
			<td class="rightAligned" id="lblDaysNoTd">Number of Days</td>
			<td class="leftAligned"  id="inputDaysNoTd"><input type="text" class="" value="0" maxlength="5" id="inputNoOfDays" name="inputNoOfDays" style="width: 96%; text-align: right;" /></td>
		</tr>					
		<tr>
			<td class="rightAligned">Remarks</td>
			<td class="leftAligned" colspan="3">
				<input type="text" id="inputCompRem" name="inputCompRem" maxlength="50" style="width: 98.5%;" />
			</td>
		</tr>
		<tr>
			<td colspan="5" align="center">
				<input id="btnAddPeril" class="button" type="button" value="Add" name="btnAddPeril"	style="width: 60px; margin-top: 5px; margin-bottom: 5px;"/> 
				<input id="btnDeletePeril" class="disabledButton" type="button"	value="Delete" name="btnDeletePeril" style="width: 60px;" /> 
			</td>
		</tr>
	</table>
</div>

<div style="display: none;">
	<table align="center" border="0" width="82%">
		<tr>			
			<td class="rightAligned" width="8%">Item No.</td>
			<td><input type="text" class="required" value="1" maxlength="17" id="itemNo" name="itemNo" style="width: 96%;" /></td>
			<td><input type="hidden" class="required" value="1" maxlength="17" id="itemNumbers" name="itemNumbers" style="width: 96%;" /></td>
			<td><input type="hidden" class="required" value="1" maxlength="17" id="tempItemNumbers" name="tempItemNumbers" style="width: 96%;" /></td>
		</tr>
		<tr>		
			<td class="rightAligned" width="8%">Inception Date</td>
			<td class="leftAligned" width="18%"><input type="text" class="required" value="0" maxlength="17" id="inceptDate" name="inceptDate" style="width: 96%;" /></td>
			<td class="rightAligned" width="8%">Expiry Date</td>
			<td class="leftAligned" width="18%"><input type="text" class="required" value="0" maxlength="17" id="expiryDate" name="expiryDate" style="width: 96%;" /></td>
		</tr>
		<tr>
			<td class="rightAligned" width="8%">Effectivity Date</td>
			<td class="leftAligned" width="18%"><input type="text" class="required" value="0" maxlength="17" id="effDate" name="effDate" style="width: 96%;" /></td>
			<td class="rightAligned" width="8%">Endt. Expiry Date</td>
			<td class="leftAligned" width="18%"><input type="text" class="required" value="0" maxlength="17" id="endtExpiryDate" name="endtExpiryDate" style="width: 96%;" /></td>
		</tr>
	</table>
</div>

<script type="text/javascript" defer="defer">
	var backEndt			= $F("globalBackEndt");	
	var itemNo			 	= $F("itemNo");
	var packLineCd			= null;
	
	var itemTsiAmount	   	 = parseFloat(computeEndtItemTsiAmount(itemNo));
	var itemPremiumAmount    = parseFloat(computeEndtItemPremiumAmount(itemNo));
	var itemAnnTsiAmount 	 = parseFloat(computeEndtItemAnnTsiAmount(itemNo));
	var itemAnnPremiumAmount = parseFloat(computeEndtItemAnnPremiumAmount(itemNo));
	
	var parPackPolFlag 		= $F("globalPackPolFlag");
	var packParId			= $F("globalPackParId");
	var parIssCd			= $F("globalIssCd"); 
	var polbasParamIssCdRi	= "RI";
	var polbasProrateFlag	= $F("globalProrateFlag");
	var polbasProvPremTag	= $F("globalProvPremTag");	
	var polbasCompSw	 	= $F("globalCompSw");
	var polbasProvPremPct	= parseFloat(($("globalProvPremPct") == null || trim($F("globalProvPremPct")) == "" ? "1" : $F("globalProvPremPct")));
	var polbasShortRate		= parseFloat($("globalShortRtPercent") == null || trim($F("globalShortRtPercent")) == "" ? "100" : $F("globalShortRtPercent"));
	var polFlag			 	 = $F("globalPolFlag");
	var polbasInceptDate	 = $F("globalInceptDate");
	var polbasExpiryDate	 = $F("globalExpiryDate");
	var polbasEffDate		 = $F("globalEffDate");
	var polbasEndtExpiryDate = $F("globalEndtExpiryDate");
	var polbasWithTariffSw	 = $F("globalWithTariffSw");
	var polbasLineMotor	 	 = $F("globalLineMotor");
	var polbasLineFire	 	 = $F("globalLineFire");
	var endtTax	 	 		 = $F("globalEndtTax");

	var perilCd			 	= null;
	var perilName		 	= null;	
	var premiumRate		 	= null;
	var tsiAmount		 	= null;
	var annTsiAmount	 	= null;
	var premiumAmount 	 	= null;
	var annPremiumAmount 	= null;
	var remarks			 	= null;
	var recFlag		 	 	= null;
	var basicPerilCd 	 	= null;
	var riCommRate			= null;
	var riCommAmount		= null;
	var tarfCd				= null;
	var discExist		 	= false;
	var perilType			= null;
	var noOfDays			= null;
	var baseAmt             = null;
	
	var toDate				= (polbasEndtExpiryDate != null && trim(polbasEndtExpiryDate) != "" ? polbasEndtExpiryDate : polbasExpiryDate);
	var fromDate			= (objGIPIWPolbas.effDate != null && trim(objGIPIWPolbas.effDate) != "" ? objGIPIWPolbas.effDate : objGIPIWPolbas.inceptDate);
	var prorate			 	= null;
	var recExist			= null;
	var incWC				= "N";
	var oneDay = 1000*60*60*24;
	var endtLineCd			= getLineCd();
	//var annTsiAmtDef = ""; //added by steven 9/14/2012 
	var itemPremAmt			= null;
	var itemAnnPremAmt		= null;
	
	var recompComm 			= 'N'; //added by robert 11.26.2013
	
	var changeIn			= "";	//Gzelle 08172015 SR4851
	togglePerilTariff("");
	initializeAll();
	initializeAllMoneyFields();
	initializeTable("tableContainer", "rowEndtPeril", "", "");
	//checkTableIfEmpty2("rowEndtPeril", "endtPerilTable");
	//checkIfToResizeTable2("perilTableContainerDiv", "rowEndtPeril");
	//setEndtItemAmounts();
	
	objGIPIWItemPeril = JSON.parse('${objEndtItemPerils}'.replace(/\\/g, "\\\\"));
	objGIPIItemPeril = JSON.parse('${objPolItemPerils}'.replace(/\\/g, "\\\\"));
	objGIPIWPolWC = new Array();
	objCurrItemPeril = new Object();
	var lineCd = getLineCd();
	
	$$("label[name='lblPerilName']").each(function(peril){
		peril.update(peril.innerHTML.truncate(19, "..."));
	});

	$$("label[name='lblPremiumRate']").each(function(rate){
		rate.innerHTML = formatToNineDecimal(rate.innerHTML);
	});

	$$("label[name='lblRIRate']").each(function(rate){
		rate.innerHTML = formatToNineDecimal(rate.innerHTML);
	});
	
	$$("input[name='hidDiscSum']").each(function(disc){
		if(0 != disc.value){
			discExist = true;
			return;
		}		
	});

	//Use money1 class in this page to allow negative value inputs
	$$("input[type='text'].money1").each(function (m) {
		m.observe("focus", function ()	{
			m.select();
			m.value = (m.value).replace(/,/g, "");
		});

		m.observe("blur", function () {
			m.value = formatCurrency(m.value);
		});

		m.value = formatCurrency(m.value == "" ? "0" : m.value);
		m.setStyle({textAlign: "right"});
	});
	
	$("btnAddPeril").observe("click", function () {	
		//fireEvent($("inputPremiumAmt"), "change"); //execute event of Premium Amount to allow recomputation of other fields by MAC 06/03/2013.
		//fireEvent commented out due to causing discrepancies with the item ann prem amt and peril ann prem amt
		var selectedRow = false;
		$$("div#itemTable .selectedRow").each(function(row){
			selectedRow = true;
		});
		//condition added by angelo to prevent inserting null value in database
		if ($F("itemNo") == "") {
			showMessageBox("Please select an item first", imgMessage.INFO);
		} else if ($("row" + $F("itemNo")) == null && selectedRow == false){		//added by Gzelle 02.28.2013 - check if there is a selected item/added item
			showMessageBox("Please select an item first.");	
		} else if(checkAllRequiredFieldsInDiv("itemPerilFormDiv") && checkAllRequiredFieldsInDiv("itemInfoMainDiv")){ // andrew - 05.14.2012 //added by steven 1/7/2013 "&& checkAllRequiredFieldsInDiv("itemInfoMainDiv")" base on SR 0011402
			var totalAnnPremAmt = 0;
			var totalAnnTsiAmt = 0;
			if ($F("btnAddPeril") == "Update") {
				if(objCurrItemPeril.perilType == "B"){
					totalAnnTsiAmt = (parseFloat(nvl($F("annTsiAmt").replace(/,/g, ""), 0)) - parseFloat(nvl($("inputTsiAmt").getAttribute("oldTsiAmt").replace(/,/g, ""), 0))) + parseFloat($F("inputTsiAmt").replace(/,/g, ""));
				}

				totalAnnPremAmt = (parseFloat($F("annPremAmt").replace(/,/g, "")) - parseFloat(nvl($("inputAnnPremiumAmt").getAttribute("oldAnnPremAmt").replace(/,/g, ""), 0))) + parseFloat($F("inputAnnPremiumAmt").replace(/,/g, ""));
				$("annPremAmt").value = totalAnnPremAmt; 
			} else {
				if(objCurrItemPeril.perilType == "B"){
					totalAnnTsiAmt = parseFloat(nvl($F("annTsiAmt").replace(/,/g, ""), 0)) + parseFloat($F("inputTsiAmt").replace(/,/g, ""));
				}
				
				totalAnnPremAmt = parseFloat($F("annPremAmt").replace(/,/g, "")) + parseFloat($F("inputAnnPremiumAmt").replace(/,/g, ""));
			}
			
			if(totalAnnTsiAmt > 99999999999999.99) {
				showWaitingMessageBox("Adding this TSI Amount will exceed the maximum Total Item Annual TSI Amount allowed for this PAR. Total Item Annual TSI Amount value must range from 0.00 to 99,999,999,999,999.99.", "I", 
						function(){
							$("inputTsiAmt").select();
							$("inputTsiAmt").focus();
						});
					return false;
			} else if(totalAnnPremAmt > 9999999999.99){
				showWaitingMessageBox("Adding this Premium Amount will exceed the maximum Total Item Annual Premium Amount allowed for this PAR. Total Item Annual Premium Amount value must range from 0.00 to 9,999,999,999.99.", "I", 
						function(){
							$("inputPremiumAmt").select();
							$("inputPremiumAmt").focus();
						});
					return false;
			}
			
			objCurrItem.recordStatus = 1;
			objCurrItem.fromDate = $F("fromDate");
			objCurrItem.toDate = $F("toDate");
			checkEndtPeril();
		}
	});

	$("btnDeletePeril").observe("click", function () {		
		deleteEndtPeril($F("itemNo"), $F("perilCd"));			
	});
	
/*
	$("btnSave").observe("click", function () {
		if (endtTax == "Y"){
			showConfirmBox("Confirm", "Saving this peril will cause to uncheck endorse tax from the basic info. screen. Would you like to continue?", "Yes", "No", uncheckEndtTax, checkEndtTax);
			return false;
		}
		setEndtParAmounts();	
		saveEndtPeril();
	});
*/

	function retrievePerilsProc(){
		new Ajax.Request(contextPath+"/GIPIWItemPerilController", {
			parameters: {action : "retrievePerils",
						 parId : $F("globalParId"),
						 itemNo : $F("itemNo")},
			onComplete: function(response){
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					var result = JSON.parse(response.responseText);
					$("tsiAmt").value = result.tsiAmt;
					$("annTsiAmt").value = result.annTsiAmt;
					$("premAmt").value = result.premAmt;
					$("annPremAmt").value = result.annPremAmt;
					showEndtPerilInfoPage();
					validateZoneType(perilCd);		//Gzelle 05252015 SR4347
				}
			}
		});
	}

	$("btnRetrievePerils").observe("click", function () {
		var executeSave = false;
		var objParameters = new Object();
		
		objParameters.setItemRows 	= getAddedAndModifiedJSONObjects(objGIPIWItem);
		objParameters.delItemRows 	= getDeletedJSONObjects(objGIPIWItem);
		objParameters.setDeductRows	= getAddedAndModifiedJSONObjects(objDeductibles);
		objParameters.delDeductRows	= getDeletedJSONObjects(objDeductibles);
		objParameters.setPerils 	= getAddedAndModifiedJSONObjects(objGIPIWItemPeril);		
		objParameters.delPerils 	= getDeletedJSONObjects(objGIPIWItemPeril);	
		
		for(attr in objParameters){
			if(objParameters[attr].length > 0){
				executeSave = true;
				break;
			}
		}

		if (executeSave){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		} else if ($F("itemNo") != "" && $("row"+$F("itemNo")) == null) {
			showWaitingMessageBox("Please add the item first.", "I", 
				function(){
					$("btnAddItem").focus();
				});
		} else if ($F("itemNo") == "" && $("row"+$F("itemNo")) != null && $("row"+$F("itemNo")).hasClassName("selectedRow")){
			showMessageBox("Please select an item first.");	
		} else {
			//if ($$("div[name='rowEndtPeril']").size() > 0){
			if (objUWParList.binderExist == "Y"){
				showMessageBox("This PAR has corresponding records in the posted tables for RI. Could not proceed.", imgMessage.ERROR);				
				return false;
			}
			if(globalNegate == "Y"){ //added if condition edgar 01/21/2015
				negateDeleteItem();
			}else{
				if (objGIPIWItemPeril.filter(function(obj){return obj.itemNo == $F("itemNo");}).length > 0){
					showConfirmBox("Confirm", 
							"Perils can only be retrieved if there are no perils inserted yet. Delete first the perils before pressing this button. Do you want to delete the perils?", 
							"Yes", 
							"No", 
							function(){
								//transferPerils($F("itemNo"), "retrieve");
								retrievePerilsProc();
							}, 
							"");
				} else {
					//transferPerils($F("itemNo"), "retrieve");
					retrievePerilsProc();
				}
			}
		}
	});
	
	$("btnDeleteDiscounts").observe("click", function () {
		showConfirmBox("Confirm", "Are you sure you want to delete all discounts for this policy?", "Yes", "No", deleteItemDiscounts, "");//changed on Yes function Kenneth L. 03.27.2014
	});

	$("btnCommission").observe("click", function () {
		showCommission(($F("btnCommission") == "Commission" ? true : false));
	});
	
	/* $("inputTsiAmt").observe("focus", function(){ //added by steven 9/14/2012
		annTsiAmtDef = this.value;
	}); */
	$("inputTsiAmt").observe("change", function(){
		var annTsiAmtTemp = parseFloat(this.value.replace(/,/g, ""));
		$("inputBaseAmt").value = "0.00";
		$("inputNoOfDays").value = "0";
	    if(objCurrItem == null) {
	    	showMessageBox("Please select an item first.");	
	    } else {	    	
	    	if(objCurrItemPeril != null) {
/* 	    		if(isNaN($F("inputTsiAmt").trim())) {
	    			showWaitingMessageBox("Invalid TSI Amount. Valid value should be from 0.01 to 99,999,999,999,999.99.", imgMessage.ERROR, 
	    					function (){
								$("inputTsiAmt").value = formatCurrency(nvl($("inputTsiAmt").readAttribute("tsiAmt"), 0));
								$("inputTsiAmt").select();
								$("inputTsiAmt").focus();
	    					});
	    			return;
	    		} */
	    			
	    		if($F("inputTsiAmt").trim() == ""){
    				showWaitingMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, 
        					function (){
    							$("inputTsiAmt").value = formatCurrency(nvl($("inputTsiAmt").readAttribute("tsiAmt"), 0));
    							$("inputTsiAmt").select();
    							$("inputTsiAmt").focus();
        					});	    			
	    		//comment out and modified to allow TSI amount less than 1 but not negative by MAC 06/04/2013.
	    		//if($F("hidPerilRecFlag") == "A" && (parseInt($F("inputTsiAmt")) <= 0 || $F("inputTsiAmt").trim() == "" || $F("inputTsiAmt") == "-" || annTsiAmtTemp > 99999999999999.99)){
	    		} else if($F("hidPerilRecFlag") == "A" && (annTsiAmtTemp < 0.01 || $F("inputTsiAmt").trim() == "" || $F("inputTsiAmt") == "-" || annTsiAmtTemp > 99999999999999.99)){
    				showWaitingMessageBox("Invalid TSI Amount. Valid value should be from 0.01 to 99,999,999,999,999.99.", imgMessage.ERROR, 
    					function (){
							$("inputTsiAmt").value = formatCurrency(nvl($("inputTsiAmt").readAttribute("tsiAmt"), 0));
							$("inputTsiAmt").select();
							$("inputTsiAmt").focus();
    					});
	    		} else if($F("inputTsiAmt") == "-" || annTsiAmtTemp > 99999999999999.99){
       				showWaitingMessageBox("Invalid TSI Amount. Valid value should be from -99,999,999,999,999.99 to 99,999,999,999,999.99.", imgMessage.ERROR, 
       					function (){
   							$("inputTsiAmt").value = formatCurrency(nvl($("inputTsiAmt").readAttribute("tsiAmt"), 0));
   							$("inputTsiAmt").select();
   							$("inputTsiAmt").focus();
       					});
    			}else{
    				computeTsi();
    				changeIn = "tsi";	//Gzelle 08172015 SR4851
    			}
			}
	    }
		//setEndtPerilAmounts(0);		
	});

/* 	$("inputPremiumRate").observe("blur", function(){
		$("inputPremiumRate").value = formatToNineDecimal($F("inputPremiumRate"));
	}); */
	
	$("inputPremiumRate").observe("change", function(){
		if(objCurrItem == null) {
	    	showMessageBox("Please select an item first.");	
	    } else {
    		if(isNaN($F("inputPremiumRate").trim())) {
    			showWaitingMessageBox("Invalid Premium Rate. Valid value should be from 0.000000000 to 100.000000000.", imgMessage.ERROR, 
    					function (){
							$("inputPremiumRate").value = formatCurrency(nvl($("inputPremiumRate").readAttribute("premRt"), 0));
							$("inputPremiumRate").select();
							$("inputPremiumRate").focus();
    					});
    			return;
    		}

    		if ($F("inputPremiumRate").trim() == ""){ 
				showWaitingMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, 
					function(){
						$("inputPremiumRate").value = formatToNineDecimal(nvl($("inputPremiumRate").readAttribute("premRt"), 0));
						$("inputPremiumRate").select();
						$("inputPremiumRate").focus();
					});	
/* 			} else if(nvl($F("hidPerilRecFlag"), "A") == "A" && (formatToNineDecimal(this.value) > 100.000000000 || formatToNineDecimal(this.value) <= 0.000000000 || isNaN(this.value))) {			
				showWaitingMessageBox("Invalid Premium Rate. Valid value should be from 0.000000001 to 100.000000000.", imgMessage.ERROR, 
					function(){
						$("inputPremiumRate").value = formatToNineDecimal(nvl($("inputPremiumRate").readAttribute("premRt"), 0));
						$("inputPremiumRate").select();
						$("inputPremiumRate").focus();
					});		 */		
			} else if(formatToNineDecimal(this.value) > 100.000000000 || formatToNineDecimal(this.value) < 0.000000000 || isNaN(this.value)) {			
				showWaitingMessageBox("Invalid Premium Rate. Valid value should be from 0.000000000 to 100.000000000.", imgMessage.ERROR, 
					function(){
						$("inputPremiumRate").value = formatToNineDecimal(nvl($("inputPremiumRate").readAttribute("premRt"), 0));
						$("inputPremiumRate").select();
						$("inputPremiumRate").focus();
					});				
			} else if(objCurrItemPeril != null) {
				computePremiumRate();
				if (changeIn != "tsi") changeIn = "rate";	//Gzelle 08172015 SR4851
			}
	    }		
		//setEndtPerilAmounts(0);
	});
	
	$("inputPremiumAmt").observe("change", function(){
		var tempPremAmt = parseFloat(this.value.replace(/,/g, ""));
	    if(objCurrItem == null) {
	    	showMessageBox("Please select an item first.");	
	    } else {	    	
	    	if(objCurrItemPeril != null) {    		
	    		if($F("inputPremiumAmt").trim() == ""){
	    			showWaitingMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, 
	    					function (){
								$("inputPremiumAmt").value = formatCurrency(nvl($("inputPremiumAmt").readAttribute("premAmt"), 0));
								$("inputPremiumAmt").select();
								$("inputPremiumAmt").focus();
	    					});
	    		//comment out and modified to allow Premium less than 1 but not negative by MAC 06/04/2013.
	    		//if($F("hidPerilRecFlag") == "A" && (parseInt($F("inputPremiumAmt")) <= 0 || $F("inputPremiumAmt") == "-" || $F("inputPremiumAmt").trim() == "" || tempPremAmt > 9999999999.99)){
	    		} else if($F("hidPerilRecFlag") == "A" && (tempPremAmt < 0.00 || $F("inputPremiumAmt") == "-" || $F("inputPremiumAmt").trim() == "" || tempPremAmt > 9999999999.99)){
	    			showWaitingMessageBox("Invalid Premium Amount. Valid value should be from 0.00 to 9,999,999,999.99.", imgMessage.ERROR, 
	    					function (){
								$("inputPremiumAmt").value = formatCurrency(nvl($("inputPremiumAmt").readAttribute("premAmt"), 0));
								$("inputPremiumAmt").select();
								$("inputPremiumAmt").focus();
	    					});
					return false;
	    		} else if($F("inputPremiumAmt") == "-" || tempPremAmt > 9999999999.99){
	    			showWaitingMessageBox("Invalid Premium Amount. Value should be from -9,999,999,999.99 to 9,999,999,999.99 and must not be greater than TSI Amt.", imgMessage.ERROR,    				 
    					function (){
							$("inputPremiumAmt").value = formatCurrency(nvl($("inputPremiumAmt").readAttribute("premAmt"), 0));
							$("inputPremiumAmt").select();
							$("inputPremiumAmt").focus();
    					}); 
	    			return false; //stop from proceeding if not a valid amount by MAC 06/04/2013.
	    		//check if TSI and Premium are of same sign before proceeding in recomputation of amounts by MAC 06/03/2013.
	    		} else if ((unformatCurrency("inputTsiAmt") > 0 && unformatCurrency("inputPremiumAmt") < 0) || 
	    				  (unformatCurrency("inputTsiAmt") < 0 && unformatCurrency("inputPremiumAmt") > 0)){
	    			showWaitingMessageBox("Entered Premium Amount will result to invalid Premium Rate.", imgMessage.INFO,
	    					function (){
								$("inputPremiumAmt").value = formatCurrency(nvl($("inputPremiumAmt").readAttribute("premAmt"), 0));
								$("inputPremiumAmt").select();
								$("inputPremiumAmt").focus();
							});
	    			return false;
	    		//check if Premium is greater than TSI before proceeding in recomputation of amounts by MAC 06/03/2013.
	    		} else if (Math.abs(unformatCurrency("inputTsiAmt")) != 0 && Math.abs(unformatCurrency("inputPremiumAmt")) > Math.abs(unformatCurrency("inputTsiAmt"))){
	    			showWaitingMessageBox("Premium Rate exceeds 100%, please check your Premium Computation Conditions at Basic Information Screen.", imgMessage.INFO,
	    					function (){
								$("inputPremiumAmt").value = formatCurrency(nvl($("inputPremiumAmt").readAttribute("premAmt"), 0));
								$("inputPremiumAmt").select();
								$("inputPremiumAmt").focus();
							});
	    			return false;
	    		}else{
    				computePremium();
    				if (changeIn != "tsi") changeIn = "premium";	//Gzelle 08172015 SR4851
    			}
			}
	    }
/*			
		return;
		var tempPremRate = computePremiumRate();
		
 		if (tempPremRate > 100){
			showMessageBox("Premium Rate exceeds 100%, please check your Premium Computation Conditions at Basic Information Screen");
			if ($F("btnAddPeril") == "Add"){
				getPolPerilAmounts($F("perilCd"));
			} else {
				$$("div[name='rowEndtPeril']").each(function (row){
					if (row.hasClassName("selectedRow")){
						for(var i=0; i<objGIPIWItemPeril.length; i++) {
							if (objGIPIWItemPeril[i].itemNo == parseInt($F("itemNo").trim()) && objGIPIWItemPeril[i].perilCd == row.down("input", 1).value) {
								objCurrItemPeril = objGIPIWItemPeril[i];
								break;
							}	
						}
						setEndtPerilForm(objCurrItemPeril);
						setEndtPerilFields(objCurrItemPeril);
					}
				});	
			}
		} else {
			if(tempPremRate != 0) {//parseInt(tempPremRate) //belle 11.10.2011 to consider decimal rates (0.01)
				$("inputPremiumRate").value = formatToNineDecimal(tempPremRate); 
			}
			setEndtPerilAmounts(1);
		}
 */	});

	$("perilCd").observe("change", function(){
		setEndtPerilFields(null);
		getPolPerilAmounts($F("perilCd"));
		togglePerilTariff($F("perilCd"));
	});
	
/* 	$("inputRiCommRate").observe("focus", function() {
		riCommRate = parseFloat($F("inputRiCommRate"));
	}); */

	$("inputRiCommRate").observe("change", function() {
		if(objCurrItem == null) {
	    	showMessageBox("Please select an item first.");	
	    } else {
			if (this.value.trim() == "" || formatToNineDecimal(this.value) > 100.000000000 || formatToNineDecimal(this.value) < 0.000000000 || isNaN(this.value)) {			
					showWaitingMessageBox("Invalid RI Rate. Value should be from from 0.000000001 to 100.000000000.", imgMessage.ERROR, 
						function(){
							$("inputRiCommRate").value = formatToNineDecimal(nvl($("inputRiCommRate").readAttribute("riCommRate"), 0));
							$("inputRiCommRate").select();
							$("inputRiCommRate").focus();
						});
			} else if(objCurrItemPeril != null) {
				var tempRiCommRate = parseFloat($F("inputRiCommRate"));
				var tempPremiumAmount = parseFloat($F("inputPremiumAmt").replace(/,/g, ""));
				$("inputRiCommAmt").value = formatCurrency(tempRiCommRate*tempPremiumAmount/100);
				$("inputRiCommAmt").setAttribute("riCommAmt", $F("inputRiCommAmt"));
				$("inputRiCommRate").setAttribute("riCommRate", $F("inputRiCommRate"));
			}
	    }
	});
	
/* 	$("inputRiCommAmt").observe("focus", function() {
		riCommAmount = parseFloat($F("inputRiCommAmt").replace(/,/g, ""));
		//riCommAmount = $F("inputRiCommAmt");
	}); */
	
	$("inputRiCommAmt").observe("change", function() {
		var annCommAmtTemp = parseFloat(this.value.replace(/,/g, ""));
	    if(objCurrItem == null) {
	    	showMessageBox("Please select an item first.");	
	    } else {	    	
	    	if(objCurrItemPeril != null) {
	    		if($F("hidPerilRecFlag") == "A" && (parseInt($F("inputRiCommAmt")) <= 0 || $F("inputRiCommAmt").trim() == "" || $F("inputRiCommAmt") == "-" || annCommAmtTemp > 999999999999.99)){
    				showWaitingMessageBox("Invalid Comm. Amount. Value should be from 0.01 to 999,999,999,999.99.", imgMessage.ERROR, 
    					function (){
							$("inputRiCommAmt").value = formatCurrency(nvl($("inputRiCommAmt").readAttribute("riCommAmt"), 0));
							$("inputRiCommAmt").select();
							$("inputRiCommAmt").focus();
    					});
	    		} else if($F("inputRiCommAmt").trim() == "" || $F("inputRiCommAmt") == "-" || annCommAmtTemp > 999999999999.99){
       				showWaitingMessageBox("Invalid Comm. Amount. Value should be from -999,999,999,999.99 to 999,999,999,999.99.", imgMessage.ERROR, 
       					function (){
   							$("inputRiCommAmt").value = formatCurrency(nvl($("inputRiCommAmt").readAttribute("riCommAmt"), 0));
   							$("inputRiCommAmt").select();
   							$("inputRiCommAmt").focus();
       					});
    			}else{
    				var tempPremiumAmount = parseFloat($F("inputPremiumAmt").replace(/,/g, ""));
    				var tempRiCommAmount = parseFloat($F("inputRiCommAmt").replace(/,/g, ""));
    				var vRiCommRate = parseFloat((tempRiCommAmount*100)/tempPremiumAmount);
					
					if (vRiCommRate > 100 || vRiCommRate < 0.000000000 || isNaN(vRiCommRate)) {
						showWaitingMessageBox("Entered Comm. Amount will result to invalid RI Rate.", imgMessage.INFO, 
								function(){
		   							$("inputRiCommAmt").value = formatCurrency(nvl($("inputRiCommAmt").readAttribute("riCommAmt"), 0));
		   							$("inputRiCommAmt").select();
		   							$("inputRiCommAmt").focus();
								});
					} else {
	    				var flrRiCommAmt = Math.round(tempRiCommAmount);
	    				if((parseFloat($F("inputRiCommRate")) > 0 && !isNaN($F("inputRiCommRate"))) &&
	    					(tempRiCommAmount < (flrRiCommAmt-1) || tempRiCommAmount > flrRiCommAmt)) {
	    					showMessageBox("You can update the commission amount only to the nearest "+
	    							$("currency").options[$("currency").selectedIndex].innerHTML+": "+
	    							$("currency").options[$("currency").selectedIndex].getAttribute("shortName")+
	    							" "+(flrRiCommAmt-1)+" - "+flrRiCommAmt);
	    					$("inputRiCommAmt").value = formatCurrency(nvl($("inputRiCommAmt").readAttribute("riCommAmt"), 0));
	    					return;
	    				}
	    				$("inputRiCommRate").value = formatToNineDecimal(vRiCommRate);
	    				$("inputRiCommAmt").setAttribute("riCommAmt", $F("inputRiCommAmt"));
	    				$("inputRiCommRate").setAttribute("riCommRate", $F("inputRiCommRate"));
	    				fireEvent($("inputRiCommRate"), "change");
					}
    			}
			}
	    }
	});
	
	$("inputNoOfDays").observe("focus", function() {
		noOfDays = $F("inputNoOfDays");		
	});
	
	$("inputNoOfDays").observe("change", function() {
		this.value = parseInt($F("inputNoOfDays")); //added by steve 9/10/2012
		if($F("inputNoOfDays") != "" && isNaN($F("inputNoOfDays"))) {
			showMessageBox("Legal characters are 0-9 -+ E", imgMessage.ERROR);
			$("inputNoOfDays").value = noOfDays;
			return;
		} 
		
		var tempBaseAmt = unformatCurrencyValue($F("inputBaseAmt"));
		var tempDays = removeLeadingZero($F("inputNoOfDays"));
		if(tempBaseAmt > 0) {
			$("inputTsiAmt").value = formatCurrency(tempBaseAmt * tempDays);
			if(objCurrItem == null) {
		    	showMessageBox("Please select an item first.");	
		    } else {
		    	if(objCurrItemPeril != null) {
					computeTsi();
				}
		    }
		}
	});

	$("txtPerilName").observe("keyup", function(event){	
		if(event.keyCode == 46){ // when Delete key is pressed
			if($("rowEndtPeril"+objCurrItemPeril.itemNo+objCurrItemPeril.perilCd) != null && $("rowEndtPeril"+objCurrItemPeril.itemNo+objCurrItemPeril.perilCd).hasClassName("selectedRow")){
				$("txtPerilName").value = objCurrItemPeril.perilName;
			} else {
				setEndtPerilFields(null);
			}
		}
	});
	
	$("btnCopyPeril").observe("click", function(){
		if ($F("itemNo") == "" && $("row"+$F("itemNo")) != null && $("row"+$F("itemNo")).hasClassName("selectedRow")){
			showMessageBox("Please select an item first.");	
		} else {
			validateCopyEndtPeril();
		}
	});
	
	var recCount = $$("div[name='rowPeril']").size();	
	if (backEndt == "Y" && recCount > 0){
		showMessageBox("This is a backward endorsement, any changes made with this item peril will affect all previous endorsement that has an effectivity date later than "+ dateFormat(polbasEffDate, "mmmm dd, yyyy"));
	} 
	
	var amountLabels = new Array("lblTsiAmount", "lblAnnTsiAmount", "lblPremiumAmount", "lblAnnPremiumAmount", "lblCommissionAmount", "lblPremiumCeded");
	var amounts = $("perilTableContainerDiv").getElementsByTagName("label");
	for(var i=0; i < amounts.length; i++){
		for (var j=0; j < amountLabels.length; j++) {			
			if (amountLabels[j] == amounts[i].getAttribute("name")){
				amounts[i].innerHTML = formatCurrency(amounts[i].innerHTML);
			}	
		}		
	}
	
	$$("div[name='rowEndtPeril']").each(function (row)	{		
		row.observe("click", function () {
			//row.toggleClassName("selectedRow");
			if (row.hasClassName("selectedRow")){
				for(var i=0; i<objGIPIWItemPeril.length; i++) {
					if (objGIPIWItemPeril[i].itemNo == parseInt($F("itemNo").trim()) 
							&& objGIPIWItemPeril[i].perilCd == row.down("input", 1).value
							&& objGIPIWItemPeril[i].recordStatus != -1) {
						objCurrItemPeril = objGIPIWItemPeril[i];
						break;
					}	
				}
				
				setEndtPerilForm(objCurrItemPeril);
				setEndtPerilFields(objCurrItemPeril);
			} else {
				//objCurrItemPeril = null;
				setEndtPerilForm(null);
				setEndtPerilFields(null);
			}
		});
	});	

	if (polbasLineFire != $F("globalLineCd")){
		if (polbasParamIssCdRi != parIssCd){
			$("lblTariffCdTd").setStyle("display: none;");
			$("inputTariffCdTd").setStyle("display: none;");					
		} else {
			$("lblTariffCdTd").setStyle("visibility: hidden;");
			$("inputTariffCdTd").setStyle("visibility: hidden;");	
		}
	}
	
	if(endtLineCd == "AC") {
		$("lblTariffCdTd").setStyle("display: none;");
		$("inputTariffCdTd").setStyle("display: none;");
	} else {
		$("inputDaysNoTd").setStyle("display: none;");
		$("lblDaysNoTd").setStyle("display: none;");
		$("inputBaseAmtTd").setStyle("display: none;");
		$("lblBaseAmtTd").setStyle("display: none;");
	}
	
	if (polbasParamIssCdRi == parIssCd) {
		$("tableHeaderDiv1").down("label", 3).innerHTML = "TSI Ceded";
		$("tableHeaderDiv1").down("label", 4).innerHTML = "Ann. TSI Ceded";
		$("tableHeaderDiv1").down("label", 5).innerHTML = "Premium Ceded";
		$("tableHeaderDiv1").down("label", 6).innerHTML = "Ann. Premium Ceded";
		$("sideButtonsTd").setAttribute("rowspan", 5);	
	} else {
		$("btnCommContainer").setStyle("display: none;");
		$("lblRiAmtTd").setStyle("display: none;");
		$("lblRiRateTd").setStyle("display: none;");
		$("inputRiRateTd").setStyle("display: none;");		
		$("inputRiAmtTd").setStyle("display: none");
	}	
	
	function showCommission(bool){
		try {
			if (bool){
				$("btnCommission").value = "Return";
				$("tableHeaderDiv1").setStyle("display: none;");
				$("tableHeaderDiv2").setStyle("display: block;");
	
				$$("div[name='rowEndtPeril']").each(function(row){
					row.down("div", 0).setStyle("display: none;");
					row.down("div", 1).setStyle("display: block;");				
				});
			} else {
				$("btnCommission").value = "Commission";
				$("tableHeaderDiv1").setStyle("display: block;");
				$("tableHeaderDiv2").setStyle("display: none;");
				
				$$("div[name='rowEndtPeril']").each(function(row){
					row.down("div", 0).setStyle("display: block;");			
					row.down("div", 1).setStyle("display: none;");
				});
			}
		} catch (e){
			showErrorMessage("showCommission", e);
		}
	}

	function getEndtPerilCount(itemNo){
		var rowCount = 0;
		$$("div[name='rowEndtPeril']").each(function(row){
			if(row.down("input", 0).value == itemNo && row.getStyle("display") != "none"){
				rowCount++;	
			}
		});
		return rowCount;
	}
	
	function validateCopyEndtPeril(){
		var rowCount = getEndtPerilCount($F("itemNo"));
		if($F("recFlag") != "A"){
			showMessageBox("Copying of peril(s) is only allowed for additional item.");
			//Effect.ScrollTo("siteBanner",
				//{duration: "1"});
		} else if (rowCount == 0){
			showMessageBox("Item has no existing peril(s) to copy.");
			//Effect.ScrollTo("siteBanner",
				//{duration: "1"});
		} else {
			showSelectItem();
		}
	}

	var copyTo = null;	
	function showSelectItem() {
		var width = 400;	
		var content = '<div style="float: left; width: 100%;" align="center"><table align="center" border="0" width="100%" style="float: left; margin-top: 10px;"><tr>'+
			'<td class="rightAligned" width="50%">Copy Peril(s) to Item No.?</td>'+
			'<td class="leftAligned" width="">'+								 
			'<select id="copyTo" name="copyTo" style="width: 120px;">';
		$$("div[name='row']").each(function(row){					
			if(row.down("input", 0).name == "parIds"){
				if(row.down("input", 10).value == "A" && row.down("input", 1).value != $F("itemNo")){						
					content+='<option value="'+row.down("input", 1).value+'">'+row.down("input", 1).value+'</option>';						   		 
				}
			}					
		});
		content+='</select></td></tr></table></div>'; 
		
		Dialog.confirm(content, {
			title: "Copy Peril(s)",
			okLabel: "Ok",
			cancelLabel: "Cancel",
			onOk: function(){	
				copyTo = $F("copyTo");				 
				checkToCopy();
				return true;
			},
			onCancel: function() {
				return false;
			},
			className: "alphacube",
			width: width,
			buttonClass: "button"
		});
	}
	
	function checkToCopy(){
		var perilExist 	 = checkIfItemHasPerils("rowEndtPeril", copyTo);
		if(perilExist){							
			showConfirmBox("Confirmation", 
					"Item No. " + formatNumberDigits($F("copyTo"), 4) + " has peril(s) already, would you like to override these existing peril(s)?", 
					"Yes", 
					"No", 
					function (){
						transferPerils(copyTo, "copy");
					},
					"");
		} else {
			transferPerils(copyTo, "copy");
		}
	}

	function copyEndtPerils(){
		try {
			var tempItemNo = $F("itemNo");			
			$$("div[name='row']").each(function(row){
				if(row.down("input", 0).name == "parIds"){
					if (row.down("input", 1).value == copyTo){					
						fireEvent(row, "click");						
					}
				}
			});

			$$("div[name='rowEndtPeril']").each(function(row){	
				if(row.down("input", 0).value == tempItemNo){				
					setItemPerilVariables(row, false);
					addEndtPeril();
				}
			});
				
			copyTo = null;			
			checkTableIfEmpty2("rowEndtPeril", "endtPerilTable");
			checkIfToResizeTable2("perilTableContainerDiv", "rowEndtPeril");
			setEndtItemAmounts($F("itemNo"), objGIPIWItemPeril, objGIPIItemPeril);
		} catch (e){
			showErrorMessage("copyEndtPerils", e);
		}
	}
	
/* 	function computePremiumRate(){
        try {
	        var tempTsiAmount 		= $F("inputTsiAmt").replace(/,/g, "");
	        var tempPremiumAmount	= $F("inputPremiumAmt").replace(/,/g, "");
	        var tempShortRate 		= (polbasShortRate < 100 ? polbasShortRate : 1);        
	        //tempTsiAmount 			= (tempTsiAmount != 0 ? tempTsiAmount : 1);	        
	        
	        var tempRate;

	        if (parseInt(tempTsiAmount) == 0 || parseInt(tempPremiumAmount) == 0){
	            tempRate = 0;
	        } else {
		        if (polbasProrateFlag == 1){
					tempRate = (parseFloat(tempPremiumAmount) * checkDuration(fromDate, toDate)) 
					  			/ (parseFloat(tempTsiAmount) * parseInt(computeNoOfDays(fromDate, toDate, polbasCompSw))) * 100;			        
			    } else if (polbasProrateFlag == 2){
					tempRate = (parseFloat(tempPremiumAmount) / parseFloat(tempTsiAmount)) * 100;
				} else {
					tempRate = (parseFloat(tempPremiumAmount) / parseFloat(tempTsiAmount) * (polbasShortRate/100)) * 100;
				}               		        

	        }
			return tempRate;
        } catch (e){
        	showErrorMessage("computePremiumRate", e);
        }	
	} */

   	function computeEndtPerilPremiumAmount(){
   	   	try {
	   		var tempTsiAmount 		= $F("inputTsiAmt").replace(/,/g, "");
	   		var tempPremiumRate 	= $F("inputPremiumRate");
	   		var tempPremiumAmount 	= 0;

	   		if (polbasProrateFlag == 1){	   			
	   			tempPremiumAmount = parseFloat(tempTsiAmount) * (parseFloat(tempPremiumRate)/100)
						   	   		* (parseInt(computeNoOfDays(dateFormat(fromDate, "mm-dd-yyyy"), dateFormat(toDate, "mm-dd-yyyy"), polbasCompSw))
									/ checkDuration(fromDate, toDate))
									* polbasProvPremPct;
	   	   	} else if (polbasProrateFlag == 2) {
		   	   	tempPremiumAmount = parseFloat(tempTsiAmount) * (parseFloat(tempPremiumRate)/100)		   				
									* polbasProvPremPct;			
	   	   	} else {
		   	   	tempPremiumAmount = parseFloat(tempTsiAmount) * (parseFloat(tempPremiumRate)/100)
		   	   						* (polbasShortRate/100)		   	   						
									* polbasProvPremPct;
	   	   	}
	   	   	
	   		return tempPremiumAmount;
   	   	} catch (e){
   	   		showErrorMessage("computeEndtPerilPremiumAmount", e);
   	   	}   		
   	}
        	
	function setDates(){
		$("inceptDate").value 		= dateFormat(polbasInceptDate, "mmmm d, yyyy");
		$("expiryDate").value 		= dateFormat(polbasExpiryDate, "mmmm d, yyyy");
		$("effDate").value 			= dateFormat(polbasEffDate, "mmmm d, yyyy");
		$("endtExpiryDate").value 	= dateFormat(polbasEndtExpiryDate, "mmmm d, yyyy");
	}

	function validateAllied(){
		try {
			var tempPerilType      = objCurrItemPeril.perilType;
			var tempBasicPerilCd   = objCurrItemPeril.bascPerlCd;
			var basicPerilExist = false;
			
			if (tempPerilType == "A"){				
				if (tempBasicPerilCd != "" && tempBasicPerilCd != null) {
					var tempBasicPerilName 	= null;				
					var tempAmt = 0;
					for(var i=0; i<objGIPIWItemPeril.length; i++){
						//edited by d.alcantara, 11-02-2011. added comparison to itemNo to retrieve the exact tsi amount
						if(objGIPIWItemPeril[i].perilCd == tempBasicPerilCd && 
								objGIPIWItemPeril[i].itemNo == $F("itemNo") &&	
								objGIPIWItemPeril[i].recordStatus != -1){
							basicPerilAmount = objGIPIWItemPeril[i].premAmt;
							basicPerilExist = true;
							tempAmt = objGIPIWItemPeril[i].annTsiAmt;
							break;
						}
					}
					
					var allowAlliedMoreThanBasic = nvl(getGiisParamValue("ALLOW_ALLIED_MORE_THAN_BASIC"), 'N'); // bonok :: 8.18.2016 :: SR FGIC-22552, RSIC-22983
					
					if (!basicPerilExist){
						tempBasicPerilName = objCurrItemPeril.basicPerilName;
						showMessageBox("Basic peril " + tempBasicPerilName + " must be added first before this peril.");
						return false;
					} else if (/* basicPerilAmount > 0 &&  */(parseFloat($F("inputAnnTsiAmt").replace(/,/g, "")) > parseFloat(/*basicPerilAmount*/tempAmt)) && allowAlliedMoreThanBasic == "N") { // bonok :: 8.18.2016 :: SR FGIC-22552, RSIC-22983 :: added allowAlliedMoreThanBasic == "N"
						showWaitingMessageBox("Ann TSI amount of this peril should be less than or equal to " + formatCurrency(tempAmt)+".", "I", 
								function(){
									$("inputTsiAmt").value    = formatCurrency(nvl($("inputTsiAmt").readAttribute("oldTsiAmt"), "0"));
									$("inputPremiumAmt").value    = formatCurrency(nvl($("inputPremiumAmt").readAttribute("oldPremAmt"), "0"));
									$("inputAnnTsiAmt").value = formatCurrency($("inputAnnTsiAmt").readAttribute("oldAnnTsiAmt"));
									$("inputAnnPremiumAmt").value = formatCurrency($("inputAnnPremiumAmt").readAttribute("oldAnnPremAmt"));
									$("inputTsiAmt").select();
									$("inputTsiAmt").focus();
								}
							);
						return false;
					}
				} else if ($$("div[name='rowEndtPeril']").size() == 0) {
					showMessageBox("Basic peril must be added first.");	
					return false;
				} else {
					var basicPerilAmount = 0;
					//var tempAmount 	     = 0; 
					
 					for(var i=0; i<objGIPIWItemPeril.length; i++){
						if(objGIPIWItemPeril[i].perilType == "B" && 
								objGIPIWItemPeril[i].itemNo == $F("itemNo") &&	
								objGIPIWItemPeril[i].recordStatus != -1 && 
								parseFloat(basicPerilAmount) < parseFloat(objGIPIWItemPeril[i].annTsiAmt)){
							basicPerilAmount = objGIPIWItemPeril[i].annTsiAmt;
						}
					}				

					if (parseFloat($F("inputAnnTsiAmt").replace(/,/g, "")) > parseFloat(basicPerilAmount) && allowAlliedMoreThanBasic == "N"){ // bonok :: 8.18.2016 :: SR FGIC-22552, RSIC-22983 :: added allowAlliedMoreThanBasic == "N" 
						showWaitingMessageBox("Ann TSI amount of this peril should be less than or equal to " + formatCurrency(basicPerilAmount)+".", "I",
								function(){
									$("inputTsiAmt").value    = formatCurrency(nvl($("inputTsiAmt").readAttribute("oldTsiAmt"), "0"));
									$("inputPremiumAmt").value    = formatCurrency(nvl($("inputPremiumAmt").readAttribute("oldPremAmt"), "0"));
									$("inputAnnTsiAmt").value = formatCurrency($("inputAnnTsiAmt").readAttribute("oldAnnTsiAmt"));
									$("inputAnnPremiumAmt").value = formatCurrency($("inputAnnPremiumAmt").readAttribute("oldAnnPremAmt"));
									$("inputTsiAmt").select();
									$("inputTsiAmt").focus();
								}
							);
						return false;						
					}
				}
			}
			
			return true;
		} catch (e) {
			showErrorMessage("validateAllied", e);
		}
	}

	function validateBackAllied(){
		try {
			new Ajax.Request(contextPath+"/GIPIWItemPerilController", {
				parameters: {action : "validateBackAllied",
							 parId : $F("globalParId"),
							 itemNo : $F("itemNo"),
							 perilCd : objCurrItemPeril.perilCd,
							 perilType : objCurrItemPeril.perilType,
							 bascPerlCd : objCurrItemPeril.bascPerlCd,
							 tsiAmt : $F("inputTsiAmt").replace(/,/g, ""),
						     premAmt : $F("inputPremiumAmt").replace(/,/g, ""),
							 existingPerils : prepareJsonAsParameter(objGIPIWItemPeril)},
				onComplete: function(response){
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						proceedCheckEndtPeril();
					}
				}
			});
		} catch(e){
			showErrorMessage("validateBackAllied", e);
		}
	}

	/**
	* @deprecated
	*/
	function validateBackEndtAllied(){
		try {
			//var tempPerilType      	= $("perilCd").options[$("perilCd").selectedIndex].getAttribute("perilType");
			//var tempBasicPerilCd   	= $("perilCd").options[$("perilCd").selectedIndex].getAttribute("basicPerilCd");
			var tempPerilType      	= objCurrItemPeril.perilType;
			var tempBasicPerilCd   	= $F("basicPerilCd");
			var tempPerilAmount		= 0;
			var basicPerilAmount 	= 0;
			var alliedPerilAmount 	= 0;
			var tempEndtNo		 	= "";		
			var tempAmount 	     	= 0;			
			
			var endtPols = $("itemPerils").getElementsByTagName("div");
			for(var i=0; i < endtPols.length; i++){
				tempEndtNo = endtPols[i].down("input", 1).value;
				if (Date.parse(endtPols[i].down("input", 3).value) < Date.parse(polbasEffDate)){							
					$$("div[policyId='"+endtPols[i].down("input", 0).value+"']").each(function(row){
						if (row.down("input", 1).value = $F("perilCd") && itemNo == row.down("input", 0).value){ //edited by d.alcantara, 06-17-2012, added itemNo to condition
							tempPerilAmount = row.down("input", 5).value;
						} 
					});		
					
					if (tempPerilType == "A"){
						if (tempBasicPerilCd != "" && tempBasicPerilCd != null) {
							//edited by d.alcantara, 03-15-2012, for SR 9112
							$$("div#perilTableContainerDiv div[name='rowEndtPeril']").each(function(row){					
								if (row.down("input", 1).value == tempBasicPerilCd){
									basicPerilAmount = row.down("input", 5).value;
								}	
							});	

							if (basicPerilAmount > 0) {
								if (parseFloat(basicPerilAmount) < (parseFloat(tempPerilAmount) + parseFloat($F("inputTsiAmt").replace(/,/g, "")))) {
									showMessageBox("Tsi Amount entered will cause the Ann TSI Amount of this peril to be greater than the basic peril attached to it in " + tempEndtNo + ".");
									$("inputTsiAmt").value    = hidTsiAmount;
									$("inputAnnTsiAmt").value = hidAnnTsiAmount;
									return false;															
								}
							}
						} else {
							// get the highest basic peril amount for allied without basic peril
							//$$("div[policyId='"+endtPols[i].down("input", 0).value+"']").each(function(row){
							$$("div#perilTableContainerDiv div[name='rowEndtPeril']").each(function(row){
								tempAmount = row.down("input", 5).value;						
								if (parseFloat(basicPerilAmount) < parseFloat(tempAmount) && row.down("input", 15).value == "B"
									 && itemNo == row.down("input", 0).value){
									basicPerilAmount = tempAmount;
								}																 
							});	
							
							if (parseFloat(basicPerilAmount) < (parseFloat(tempPerilAmount) + parseFloat($F("inputTsiAmt").replace(/,/g, "")))){
								showMessageBox("Tsi Amount entered will cause the Ann TSI Amount of this peril to be greater than one of the basic peril in "+ tempEndtNo +".");
								$("inputTsiAmt").value    = hidTsiAmount;
								$("inputAnnTsiAmt").value = hidAnnTsiAmount;
								return false;																							
							}
						} 
					} else if (tempPerilType == "B"){
						// check if an allied exist;
						$$("div[policyId='"+endtPols[i].down("input", 0).value+"']").each(function(row){
							if (row.down("input", 11).value == $F("perilCd") && itemNo == row.down("input", 0).value){
								alliedPerilAmount = row.down("input", 5).value;	
							} 																							 
						});	
						// allied exists if amount is greater than zero;
						if (alliedPerilAmount > 0){
							if ((parseFloat(tempPerilAmount) + parseFloat($F("inputTsiAmt").replace(/,/g, ""))) == 0){
								showMessageBox("This basic peril cannot be zero out because there is an existing allied peril attached to it in endt no " 
			                              		+ tempEndtNo + " which has an effecitivity date later than " 
			                              		+ dateFormat(polbasEffDate, "mmmm dd, yyyy"));
								$("inputTsiAmt").value    = hidTsiAmount;
								$("inputAnnTsiAmt").value = hidAnnTsiAmount;                          		
                          		return false;
							} else if (parseFloat(alliedPerilAmount) > (parseFloat(tempPerilAmount) + parseFloat($F("inputTsiAmt").replace(/,/g, "")))) {
								showMessageBox("TSI Amount Entered will cause the Ann TSI Amount of this peril in endt no " + tempEndtNo + " to be less than allied peril attached to it in the same endorsement.");
								$("inputTsiAmt").value    = hidTsiAmount;
								$("inputAnnTsiAmt").value = hidAnnTsiAmount;
								return false;																
							}
						} else {
							if ((parseFloat(tempPerilAmount) + parseFloat($F("inputTsiAmt").replace(/,/g, ""))) == 0){
								showMessageBox("This basic peril cannot be zero out because there is an existing allied peril in endt no " 
                              		+ tempEndtNo + " which has an effecitivity date later than " 
                              		+ dateFormat(polbasEffDate, "mmmm dd, yyyy"));
							}
                      		
							// get the highest allied peril amount of basic peril without attached allied; 
							$$("div[policyId='"+endtPols[i].down("input", 0).value+"']").each(function(row){
								tempAmount = row.down("input", 5).value;						
								if (parseFloat(alliedPerilAmount) < parseFloat(tempAmount) && row.down("input", 15).value == "A"
										&& itemNo == row.down("input", 0).value){
									alliedPerilAmount = tempAmount;
								}
							});	
							
							if (parseFloat(alliedPerilAmount) > (parseFloat(tempPerilAmount) + parseFloat($F("inputTsiAmt").replace(/,/g, "")))) {
								showMessageBox("TSI Amount Entered will cause the Ann TSI Amount of this peril in endt no " + tempEndtNo + " to be less than an allied peril in the same endorsement.");
								$("inputTsiAmt").value    = hidTsiAmount;
								$("inputAnnTsiAmt").value = hidAnnTsiAmount;
								return false;																
							}
						}							
					}					
				}
			}							
					
			return true;
		} catch (e) {
			showErrorMessage("validateBackEndtAllied", e);
		}					
	}
	
	function validateBasicPeril(){
		if(objCurrItemPeril.perilType == "B") {
			var tempTsiAmount = unformatCurrencyValue($F("inputTsiAmt"));
			var tempAlliedAmt = 0;
			
			try{
				var basicAnnTsiAmt = 0;
				var alliedAnnTsiAmt = 0;
				for(var i=0; i<objGIPIWItemPeril.length; i++){
					if(objGIPIWItemPeril[i].itemNo == $F("itemNo") 						
							&& objGIPIWItemPeril[i].recordStatus != -1 
							&& objGIPIWItemPeril[i].perilCd != $F("perilCd")
							&& objGIPIWItemPeril[i].bascPerlCd == $F("perilCd")
							&& parseFloat(basicAnnTsiAmt) < parseFloat(objGIPIWItemPeril[i].annTsiAmt)){
						basicAnnTsiAmt = objGIPIWItemPeril[i].annTsiAmt;
					}
									
	 				if(objGIPIWItemPeril[i].itemNo == $F("itemNo") 
							&& objGIPIWItemPeril[i].recordStatus != -1 
							&& objGIPIWItemPeril[i].perilCd != $F("perilCd")
							&& objGIPIWItemPeril[i].perilType == "A"
							&& nvl(objGIPIWItemPeril[i].bascPerlCd, "") == ""
							&& parseFloat(alliedAnnTsiAmt) < parseFloat(objGIPIWItemPeril[i].annTsiAmt)){
	 					alliedAnnTsiAmt = objGIPIWItemPeril[i].annTsiAmt;
					}
				}
				
				var allowAlliedMoreThanBasic = nvl(getGiisParamValue("ALLOW_ALLIED_MORE_THAN_BASIC"), 'N'); // bonok :: 8.18.2016 :: SR FGIC-22552, RSIC-22983
				
				if(basicAnnTsiAmt != 0 && parseFloat(basicAnnTsiAmt) > parseFloat($F("inputAnnTsiAmt").replace(/,/g, "")) && allowAlliedMoreThanBasic == "N"){ // bonok :: 8.18.2016 :: SR FGIC-22552, RSIC-22983 :: added allowAlliedMoreThanBasic == "N"
					showWaitingMessageBox("Ann TSI of this peril must be greater than or equal to "+formatCurrency(basicAnnTsiAmt)+".", imgMessage.ERROR,
								function(){
									$("inputTsiAmt").value    = formatCurrency(nvl($("inputTsiAmt").readAttribute("oldTsiAmt"), "0"));
									$("inputPremiumAmt").value    = formatCurrency(nvl($("inputPremiumAmt").readAttribute("oldPremAmt"), "0"));
									$("inputAnnTsiAmt").value = formatCurrency($("inputAnnTsiAmt").readAttribute("oldAnnTsiAmt"));
									$("inputAnnPremiumAmt").value = formatCurrency($("inputAnnPremiumAmt").readAttribute("oldAnnPremAmt"));
									$("inputTsiAmt").select();
									$("inputTsiAmt").focus();
								}
							);					
					return false;
				} else if(alliedAnnTsiAmt != null && parseFloat(alliedAnnTsiAmt) > parseFloat($F("inputAnnTsiAmt").replace(/,/g, ""))){
					var basicPerilsCount = 0;
					for(var i=0; i<objGIPIWItemPeril.length; i++){
						if(objGIPIWItemPeril[i].itemNo == $F("itemNo") 
								&& objGIPIWItemPeril[i].recordStatus != -1 
								&& objGIPIWItemPeril[i].perilType == "B"
								&& objGIPIWItemPeril[i].perilCd != $F("perilCd")
								&& parseFloat(alliedAnnTsiAmt) <= parseFloat(objGIPIWItemPeril[i].annTsiAmt)){
							basicPerilsCount++;
						}
					}
					
					if(basicPerilsCount == 0 && allowAlliedMoreThanBasic == "N") { // bonok :: 8.18.2016 :: SR FGIC-22552, RSIC-22983 :: added allowAlliedMoreThanBasic == "N"
						showWaitingMessageBox("Ann TSI of this peril must be greater than or equal to "+formatCurrency(alliedAnnTsiAmt)+".", imgMessage.ERROR,
								function(){
									$("inputTsiAmt").value    = formatCurrency(nvl($("inputTsiAmt").readAttribute("oldTsiAmt"), "0"));
									$("inputPremiumAmt").value    = formatCurrency(nvl($("inputPremiumAmt").readAttribute("oldPremAmt"), "0"));
									$("inputAnnTsiAmt").value = formatCurrency($("inputAnnTsiAmt").readAttribute("oldAnnTsiAmt"));
									$("inputAnnPremiumAmt").value = formatCurrency($("inputAnnPremiumAmt").readAttribute("oldAnnPremAmt"));
									$("inputTsiAmt").select();
									$("inputTsiAmt").focus();
								}
							);
						return false;
					}
				}
				return true;
			}catch(e){
				showErrorMessage("validateBasicPeril", e);
			}
		} else {
			return true;
		}
	}
	
	function setEndtParAmounts(){
		var parTsiAmount				= computeEndtParTsiAmount();
		var parPremiumAmount			= computeEndtParPremiumAmount();
		var parAnnTsiAmount				= computeEndtParAnnTsiAmount();
		var parAnnPremiumAmount			= computeEndtParAnnPremiumAmount();
		$("parTsiAmount").value 		= parTsiAmount;
		$("parAnnTsiAmount").value 		= parseFloat(parAnnTsiAmount) + parseFloat(parTsiAmount);
		$("parPremiumAmount").value 	= parPremiumAmount;
		$("parAnnPremiumAmount").value 	= parseFloat(parAnnPremiumAmount) + parseFloat(parPremiumAmount);
	}

	function computeEndtParTsiAmount(){
		try {
			var tempNum = 0;
			$$("div[name='rowEndtPeril']").each(function(row){
				if(row.down("input", 15).value != "A"){
					tempNum += parseFloat(row.down("input", 4).value.replace(/,/g, ""));
				}
			});
			
			return tempNum;
		} catch (e){
			showErrorMessage("computeEndtParTsiAmount", e);
		}	
	}

	function computeEndtParPremiumAmount(){
		try {
			var tempNum = 0;
			$$("div[name='rowEndtPeril']").each(function(row){
				tempNum += parseFloat(row.down("input", 6).value.replace(/,/g, ""));
			});
			
			return tempNum;		
		} catch (e){
			showErrorMessage("computeEndtParPremiumAmount", e);
		}		
	}

	function computeEndtParAnnTsiAmount(){		
		try {
			var tempNum = 0;
			$$("div[name='rowPeril']").each(function(row){		
				tempNum += parseFloat(row.down("input", 4).value.replace(/,/g, ""));										
			});
			
			return tempNum;
		} catch (e){
			showErrorMessage("computeEndtParAnnTsiAmount", e);
			//showMessageBox("computeEndtParAnnTsiAmount : " + e.message);
		}
	}
	
	function computeEndtParAnnPremiumAmount(){
		try {
			var tempNum = 0;
			$$("div[name='rowPeril']").each(function(row){
				tempNum += parseFloat(row.down("input", 6).value.replace(/,/g, ""));
			});
			
			return tempNum;
		} catch (e){
			showErrorMessage("computeEndtParAnnPremiumAmount", e);
		}		
	}

	//Timer is used to show loading for 1 second before transfering the perils from policy to endt.
	var secs;
	var timerID = null;
	var timerRunning = false;
	
	function initializePerilTimer(seconds, mode){
		secs = seconds;
		startTimer(mode);
	}
	
	function startTimer(mode) {		
	    if (secs==0) {
	        stopTimer(mode);
	    } else {   
	    	self.status = secs;   
	        secs=secs-1;
	        timerRunning = true;	        
	        timerID = self.setTimeout(function (){
		        	startTimer(mode);
		       }, 
		       1000);
	    }
	}

	function stopTimer(mode) {
	    if(timerRunning) {
	       clearTimeout(timerID);	        
	    }
	    $("loadingDiv").setStyle("display : none;");
	    $("loadingDiv").update("");	    
	    if (mode == "retrieve"){
	    	retrievePerils();
	    } else if (mode == "copy"){
		    copyEndtPerils();
		}
	    $("perilTableContainerDiv").setStyle("display : block;");
	    timerRunning = false;	    
	}

	//Transfer perils from existing policy to the displayed list.
	function retrievePerils(){
		try {
			var itemPerilExist = checkIfItemHasPerils("rowPeril", $F("itemNo"));
			var retrievedPerils = {};
			if (!itemPerilExist){
				showMessageBox("No perils to retrieve. The selected item has no existing perils in previous endorsements.");
			} else {
				for(var i=0, length=objGIPIItemPeril.length; i<length; i++) {
					if(objGIPIItemPeril[i].itemNo == $F("itemNo")) {
						var exists = false;
						$$("div[name='rowEndtPeril']").each(function(rowEndtPeril){
							if(objGIPIItemPeril[i].perilCd == rowEndtPeril.down("input", 1).value
								&& (objGIPIItemPeril[i].itemNo == rowEndtPeril.down("input", 0).value)){  
								exists = true;
								throw $break;
							}
						});
						if(!exists) {
							setItemPerilVarFromObj(objGIPIItemPeril[i], true);
							addEndtPeril();
						}
					}
				}
			}
			checkTableIfEmpty2("rowEndtPeril", "endtPerilTable");
			checkIfToResizeTable2("perilTableContainerDiv", "rowEndtPeril");
			setEndtItemAmounts($F("itemNo"), objGIPIWItemPeril, objGIPIItemPeril);
		} catch (e){
			showErrorMessage("retrievePerils", e);
		}
	}
	
	function setItemPerilVarFromObj(obj, boolPolicy){
		try {
			itemNo 			 	= $F("itemNo");
			perilCd			 	= obj.perilCd;
			perilName		  	= obj.perilName;			
			premiumRate		 	= obj.premiumRate;
			tsiAmount		 	= (boolPolicy ? 0 : obj.tsiAmount);
			annTsiAmount	 	= obj.annTsiAmount;
			premiumAmount 	 	= (boolPolicy ? 0 : obj.premiumAmount);
			annPremiumAmount	= obj.annPremiumAmount;
			remarks			 	= obj.compRem;
			recFlag			 	= obj.recFlag;
			basicPerilCd	 	= obj.bascPerlCd;
			riCommRate		 	= obj.riCommRate;
			riCommAmount	 	= obj.riCommAmount;
			tarfCd			 	= obj.tarfCd;
			perilType			= obj.perilType;
			noOfDays			= obj.noOfDays;
			baseAmt				= obj.baseAmount;
		} catch(e){
			showErrorMessage("setItemPerilVariables", e);
		} 
	}
	 
	//Removes the endt item perils in the list.
	//Shows the loading image.
	//Transfers the perils from the policy to the list after 1 second.
	function transferPerils(itemNo, mode){
		try {
			setEndtPerilForm(null);
			setEndtPerilFields(null);			
			$$("div[name='rowEndtPeril']").each(function(row){
				if(row.down("input", 0).value == itemNo){				
					deleteEndtPeril(itemNo, row.down("input", 1).value);
				}
			});	

			var objFilteredItemPerils = objGIPIWItemPeril.filter(function(obj){return obj.itemNo == $F("itemNo");});
			objFilteredItemPerils.each(function(b) {b.recordStatus = -1;});
			
			if (mode == "retrieve"){
		    	retrievePerils();
		    } else if (mode == "copy"){
			    copyEndtPerils();
			}
		} catch(e){
			showErrorMessage("transferPerils", e);
		}	
	}

	//Computes premium amount, tsi amount, annualized tsi, annualized premium and premium rate.
	function setEndtPerilAmounts(sw){		
		var annTsiAmt = parseFloat(nvl(annTsiAmountCopy, 0)) + parseFloat($F("inputTsiAmt").replace(/,/g, "")); // added by andrew - 05.14.2012
		if(annTsiAmt < .01 || annTsiAmt > 99999999999999.99){
			showMessageBox("Invalid TSI Amount. Valid value should be from 0.01 to 99,999,999,999,999.99.", imgMessage.ERROR); // change by steve 9/14/2012 before: "Ann TSI amount must be greater than or equal to 0.00"  
			$("inputAnnTsiAmt").writeAttribute("tempValue", annTsiAmt);
			$("inputAnnTsiAmt").value = "0.00";
			$("inputAnnPremiumAmt").value = "0.00";			
			return false;
		}
		
		$("inputAnnPremiumAmt").value 	= formatCurrency(parseFloat(nvl(annPremiumAmountCopy, 0)) + parseFloat($F("inputPremiumAmt").replace(/,/g, "")));
		$("inputAnnTsiAmt").value 		= formatCurrency(annTsiAmt);
		$("inputAnnTsiAmt").removeAttribute("tempValue");
		$("inputRiCommAmt").value		= formatCurrency((nvl($F("inputRiCommRate").replace(/,/g, ""), 0) * nvl($F("inputPremiumAmt").replace(/,/g, ""), 0)) / 100); // mark jm 10.17.2011
		if(parseFloat($F("inputPremiumRate")) == 0 
				&& parseFloat($F("inputTsiAmt")) > 0
		   		&& polbasWithTariffSw == "Y"
			   	&& polbasProrateFlag == 2
			   	&& polbasProvPremTag == "N"
				&& recFlag == "A"){			
			
			if (polbasLineMotor == $F("globalLineCd") || polbasLineFire == $F("globalLineCd")) {
				getEndtTariff();								
			}
		}
	}

	function computePremium(){
		try {
			new Ajax.Request(contextPath+"/GIPIWItemPerilController", {
					method: 'POST',
					parameters : {action: "computePremium",
							      parId: $F("globalParId"),
							      itemNo : $F("itemNo"),
							      perilCd: objCurrItemPeril.perilCd,
							      premAmt: unformatCurrency("inputPremiumAmt"), //use unformatCurrency function to pass value without comma by MAC 06/19/2013.	
							      tsiAmt: unformatCurrency("inputTsiAmt"), //use unformatCurrency function to pass value without comma by MAC 06/19/2013.	
							      //annTsiAmt: $("inputAnnTsiAmt").readAttribute("endtAnnTsiAmt"),
							      annTsiAmt: unformatCurrency("inputAnnTsiAmt"), //pass computed Annual TSI as parameter in computing Premium by MAC 06/04/2013.
								  annPremAmt : $("inputAnnPremiumAmt").readAttribute("endtAnnPremAmt"),
								  itemPremAmt : unformatCurrency("itemPremiumAmt"), //use unformatCurrency function to pass value without comma by MAC 06/19/2013.	
								  itemAnnPremAmt : unformatCurrency("itemAnnPremiumAmt"), //use unformatCurrency function to pass value without comma by MAC 06/19/2013.
								  changedTag: objCurrItem.changedTag, 
								  itemToDate: dateFormat(objCurrItem.toDate, "mm-dd-yyyy"),
								  itemFromDate: dateFormat(objCurrItem.fromDate, "mm-dd-yyyy"),								  
								  shortRtPercent: objCurrItem.shortRtPercent,
								  prorateFlag: objCurrItem.prorateFlag,
								  riCommRate : $F("inputRiCommRate"),
								  premRate:  $("inputPremiumRate").value
							  },
					onComplete : function(response){					
						try {
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){						
								var result = JSON.parse(response.responseText);
								$("inputPremiumAmt").setAttribute("premAmt", $F("inputPremiumAmt").replace(/,/g, ""));
								if(recompComm != 'Y'){ //added by robert 
									$("inputPremiumRate").value = (result.outPremRt == null ? $("inputPremiumRate").value : formatToNineDecimal(result.outPremRt));
									$("inputPremiumRate").setAttribute("premRt", (result.outPremRt == null ? $("inputPremiumRate").value : result.outPremRt));
								}
								$("inputAnnPremiumAmt").value = formatCurrency(result.outAnnPremAmt);
								$("inputAnnPremiumAmt").setAttribute("baseAnnPremAmt", result.baseAnnPremAmt);

								if (polbasParamIssCdRi == parIssCd) {
									$("inputRiCommAmt").value = formatCurrency(result.riCommAmt);
									$("inputRiCommAmt").setAttribute("riCommAmt", result.riCommAmt);								
								}
								itemPremAmt			= result.itemPremAmt;
								itemAnnPremAmt		= result.itemAnnPremAmt;
							} else {								
								$("inputPremiumAmt").value = formatCurrency($("inputPremiumAmt").readAttribute("premAmt"));
								$("inputPremiumAmt").focus();
							}
							recompComm = 'N'; //added by robert 
						} catch(e){
							showErrorMessage("computePremium - onComplete", e);
						}
					}
				});
		} catch(e){
			showErrorMessage("computePremium", e);
		}
	}
	
	function computePremiumRate(){
		try {			
			new Ajax.Request(contextPath+"/GIPIWItemPerilController", {
					method: 'POST',
					parameters : {action: "computePremiumRate",
								    parId: $F("globalParId"),
								    itemNo : $F("itemNo"),
								    perilCd: objCurrItemPeril.perilCd,
								    changedTag: objCurrItem.changedTag, 
									tsiAmt: $F("inputTsiAmt"),
									premRt: $F("inputPremiumRate"),
									annTsiAmt: $("inputAnnTsiAmt").readAttribute("endtAnnTsiAmt"),
									annPremAmt : $("inputAnnPremiumAmt").readAttribute("endtAnnPremAmt"),
									itemTsiAmt : $F("itemTsiAmt"),
									itemAnnTsiAmt :$F("itemAnnTsiAmt"),
									itemPremAmt : $F("itemPremiumAmt"),
									itemAnnPremAmt :$F("itemAnnPremiumAmt"),
									noOfDays: $F("inputNoOfDays"),
									itemToDate: dateFormat(objCurrItem.toDate, "mm-dd-yyyy"),
									itemFromDate: dateFormat(objCurrItem.fromDate, "mm-dd-yyyy"),
									itemCompSw: objCurrItem.compSw,
									recFlag : $F("hidPerilRecFlag"),
									coverageCd : (lineCd == "MC" && $("coverage") != null ? $F("coverage") : null),
									tariffZone : ((lineCd == "MC" || lineCd == "FI") && $("tariffZone") != null ? $F("tariffZone") : null),
									sublineTypeCd : (lineCd == "MC" && $("sublineType") != null ? $F("sublineType") : null),
									motType : (lineCd == "MC" && $("motorType") != null ? $F("motorType") : null),
									constructionCd : (lineCd == "FI" && $("construction") != null ? $F("construction") : null),
									tarfCd : (lineCd == "FI" && $("tarfCd") != null ? $F("tarfCd") : null)
								  },
					onComplete : function(response){
						try {
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){						
								var result = JSON.parse(response.responseText);
								
								$("inputPremiumAmt").value = formatCurrency(result.outPremAmt);
								$("inputPremiumAmt").setAttribute("premAmt", result.outPremAmt);
								$("inputPremiumRate").setAttribute("premRt", $("inputPremiumRate").value);
								$("inputAnnPremiumAmt").value = formatCurrency(result.outAnnPremAmt);
								$("inputAnnPremiumAmt").setAttribute("baseAnnPremAmt", result.baseAnnPremAmt);
								computeRiCommAmt($("inputPremiumAmt").value);//edgar 01/06/2015 : to recompute ri comm amount
								itemPremAmt = null;
								itemAnnPremAmt = null;
							} else {
								$("inputPremiumRate").value = formatToNineDecimal($("inputPremiumRate").readAttribute("premRt"));
								$("inputPremiumRate").focus();
							}
						} catch(e){
							showErrorMessage("computePremiumRate - onComplete", e);
						}
					}
				});
		} catch(e){
			showErrorMessage("computePremiumRate", e);
		}
	}	
	
	function computeTsi(){
		try {
			new Ajax.Request(contextPath+"/GIPIWItemPerilController", {
				method: 'POST',
				parameters : {action: "computeTsi",
						      parId: $F("globalParId"),
						      perilCd: objCurrItemPeril.perilCd,
						      perilType: objCurrItemPeril.perilType,
						      changedTag: objCurrItem.changedTag, 
							  tsiAmt: $F("inputTsiAmt"),
							  premRt: $F("inputPremiumRate"),
							  annTsiAmt: $("inputAnnTsiAmt").readAttribute("endtAnnTsiAmt"),
							  annPremAmt : $("inputAnnPremiumAmt").readAttribute("endtAnnPremAmt"),
							  itemTsiAmt : $F("itemTsiAmt"),
							  itemAnnTsiAmt :$F("itemAnnTsiAmt"),
							  itemPremAmt : $F("itemPremiumAmt"),
							  itemAnnPremAmt :$F("itemAnnPremiumAmt"),
							  noOfDays: /* objCurrItemPeril.noOfDays */$F("inputNoOfDays"),
							  itemToDate: objCurrItem.toDate == null ? null : dateFormat(objCurrItem.toDate, "mm-dd-yyyy"),
							  itemFromDate: objCurrItem.fromDate == null ? null : dateFormat(objCurrItem.fromDate, "mm-dd-yyyy"),
							  itemCompSw: objCurrItem.compSw
							  },
				onComplete : function(response){					
					try {
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
							var result = JSON.parse(response.responseText);
							$("inputPremiumAmt").value = formatCurrency(result.outPremAmt);
							$("inputPremiumAmt").setAttribute("premAmt", result.outPremAmt);
							$("inputTsiAmt").setAttribute("tsiAmt", $F("inputTsiAmt"));
							//$("inputAnnPremiumAmt").value = formatCurrency(result.outAnnPremAmt); //Commented out by Jerome Bautista 09.14.2015 SR 17631
							//$("inputAnnPremiumAmt").setAttribute("baseAnnPremAmt", result.baseAnnPremAmt); //Commented out by Jerome Bautista 09.14.2015 SR 17631
							$("inputAnnTsiAmt").value = formatCurrency(result.outAnnTsiAmt);
							itemPremAmt = null;
							itemAnnPremAmt = null;
							if (polbasParamIssCdRi == parIssCd) { //added by robert, recomputation is for RI only according to Sir Mac 09.17.2013
								recompComm = 'Y'; //added by robert 11.26.2013
								itemPremAmt = null;
								itemAnnPremAmt = null;
								fireEvent($("inputPremiumAmt"), "change"); //execute event of Premium Amount to allow recomputation of Commission Amount if new TSI entered is valid by MAC 06/03/2013.
							}
							
							if(validateBasicPeril()){ //Added by Jerome Bautista 09.14.2015 SR 17631
								$("inputAnnPremiumAmt").value = formatCurrency(result.outAnnPremAmt);
								$("inputAnnPremiumAmt").setAttribute("baseAnnPremAmt", result.baseAnnPremAmt);
							}
						} else {
							$("inputTsiAmt").value = formatCurrency($("inputTsiAmt").readAttribute("tsiAmt"));
							$("inputTsiAmt").focus();
						}
					} catch(e){
						showErrorMessage("computeTsi - onComplete", e);
					}
				}
			});
		} catch(e){
			showErrorMessage("computeTsi", e);
		}
	}
	
	function computeRiCommAmt(premiumAmt) {
		if (polbasParamIssCdRi == parIssCd) {
			var riCommAmt = parseFloat(nvl($F("inputRiCommRate").replace(/,/g, ""), 0))*parseFloat(nvl(premiumAmt.replace(/,/g, ""), 0))/100;
			$("inputRiCommAmt").value = formatCurrency(riCommAmt);
			$("inputRiCommAmt").setAttribute("riCommAmt", riCommAmt);								
		}
	}
	
	function getEndtTariff(){
		try {
			setCursor("wait");	
			new Ajax.Request(contextPath+"/GIPIWItemPerilController", {
				method: "GET",
				parameters: {action: 		"getEndtTariff",
							 globalParType:	$F("globalParType"),
							 globalParId:	$F("globalParId"),
							 itemNo: 		itemNo,
							 perilCd: 		$F("perilCd"),
							 tsiAmount: 	$F("inputTsiAmt").replace(/,/g, ""),
							 premiumAmount: $F("inputPremiumAmt").replace(/,/g, "")},
				onCreate: showNotice("Retrieving tariff, please wait..."),
				onComplete: function(response) {
					hideNotice("");									
 				    var resultArr = response.responseText.split("--");
 				    //$("endtPerilForm").enable();
 				   					
					if (resultArr[0] == "SUCCESS"){
						var tariff = resultArr[1]; 
						if (!isNaN(tariff) && tariff < tsiAmount){
							$("inputPremiumAmt").value = formatToNineDecimal(tariff);	
						}
					} else {
						showMessageBox(response.responseText);
					}

					setCursor("default");																
				}						
			});
		} catch (e){
			showErrorMessage("getEndtTariff", e);
		}			
	}

	function ifHasAllied(){
		try {
			var result = true;
			var tempPerilType = objCurrItemPeril.perilType;
			var tempPerilCd   = $F("perilCd");
			var alliedPerilName = null;
			var basicAlliedPerilName = null;
			var alliedTsiAmt = 0;
			
			if (tempPerilType == "B"){
				//for(var i=0; i<objGIPIWItemPeril.length; i++){
				for(var i=objGIPIWItemPeril.length-1; i>=0; i--){
					if(objGIPIWItemPeril[i].itemNo == $F("itemNo") // to check if there is an existing allied for the basic peril 
							&& objGIPIWItemPeril[i].recordStatus != -1 
							&& objGIPIWItemPeril[i].perilCd != tempPerilCd
							&& objGIPIWItemPeril[i].bascPerlCd == tempPerilCd){
						basicAlliedPerilName = objGIPIWItemPeril[i].perilName;
					}
					
					var tempAnnTsiAmt = parseFloat(objGIPIWItemPeril[i].annTsiAmt.replace(/,/g, ""));
					if(objGIPIWItemPeril[i].itemNo == $F("itemNo") // to check allied perils without specific basic peril
							&& objGIPIWItemPeril[i].recordStatus != -1 
							&& objGIPIWItemPeril[i].perilCd != tempPerilCd
							&& objGIPIWItemPeril[i].perilType == "A"
							&& objGIPIWItemPeril[i].bascPerlCd == null
							&& alliedTsiAmt < tempAnnTsiAmt){
						alliedTsiAmt = tempAnnTsiAmt;
						alliedPerilName = objGIPIWItemPeril[i].perilName;
					}
				}

				if (basicAlliedPerilName != null) {
					showMessageBox("The peril '" + basicAlliedPerilName + "' must be deleted first.");
					result = false;
				} else if(alliedPerilName != null){
					var basicPerilsCount = 0;

					for(var i=0; i<objGIPIWItemPeril.length; i++){
						var tempAnnTsiAmt = parseFloat(objGIPIWItemPeril[i].annTsiAmt.replace(/,/g, ""));						
						if(objGIPIWItemPeril[i].itemNo == $F("itemNo") 
								&& objGIPIWItemPeril[i].recordStatus != -1 
								&& objGIPIWItemPeril[i].perilType == "B"
								&& objGIPIWItemPeril[i].perilCd != $F("perilCd")
								&& tempAnnTsiAmt >= alliedTsiAmt){
							basicPerilsCount++;
						}
					}
					
					if(basicPerilsCount == 0){
						showMessageBox("The peril '" + alliedPerilName + "' must be deleted first.");
						result = false;
					}
				}
			} 
		
			return result;
		} catch (e) {
			showErrorMessage("ifHasAllied", e);
		}
	}
	
	function deleteEndtPeril(pItemNo, pPerilCd){		
		try {
			if(discExist){
				showMessageBox("Deleting of peril is not allowed because Policy have existing discount. If you want to make any changes please press the button for removing discounts.");
				return false;
			} else if (!ifHasAllied()){
				return false;
			}
			
			if(objUWGlobal.lineCd == objLineCds.AC || objUWGlobal.menuLineCd == objLineCds.AC){
				if ($F("itmperlGroupedExists") == "Y") {
					showMessageBox("There are existing grouped item perils and you cannot modify, add or delete perils in current item.", "info");
					return;
				}
			}
			
			if (objUWParList.binderExist == "Y"){
				showMessageBox("This PAR has corresponding records in the posted tables for RI. Could not proceed.", imgMessage.ERROR);		
				setEndtPerilForm(null);
				return false;
			}

			deletePerilDeductibles();
			
			//marco - 05.20.2013 - for peril level deductibles
			for(var i = 0; i < objDeductibles.length; i++){
				if(objDeductibles[i].parId == $F("globalParId") && objDeductibles[i].itemNo == pItemNo && objDeductibles[i].perilCd == pPerilCd){
					objDeductibles[i].recordStatus = -1;
				}
			}
			
			$$("div[name='rowEndtPeril']").each(function (rowEndtPeril) {				
				if (rowEndtPeril.id == "rowEndtPeril"+pItemNo+pPerilCd){
					//var itemNo        = rowEndtPeril.down("input", 0).value;
					//var perilCd       = rowEndtPeril.down("input", 1).value;
					var forDeleteDiv  = $("forDeleteDiv");
					var deleteContent = '<input type="hidden" id="delItemNo'+pItemNo+pPerilCd+'"   name="delItemNo"    value="'+ pItemNo +'" />'+
										'<input type="hidden" id="delPerilCd'+pItemNo+pPerilCd+'"  name="delPerilCd"   value="'+ pPerilCd +'" />';									
					var deleteDiv     = new Element("div");
					
					deleteDiv.setAttribute("id", "delPeril"+pItemNo+pPerilCd);
					deleteDiv.setStyle("visibility: hidden;");
					deleteDiv.update(deleteContent);
							
					forDeleteDiv.insert({bottom : deleteDiv});
	
					$$("div[name='insPeril']").each(function(div){
						var id = div.getAttribute("id");
						if(id == "insPeril"+pItemNo+pPerilCd){
							div.remove();
						}
					});

					setEndtVariables();
					Effect.Fade(rowEndtPeril, {
						duration: .5,
						afterFinish: function () {
							rowEndtPeril.remove();
							checkTableIfEmpty2("rowEndtPeril", "endtPerilTable");
							checkIfToResizeTable2("perilTableContainerDiv", "rowEndtPeril");
							setEndtItemAmounts(pItemNo, objGIPIWItemPeril, objGIPIItemPeril);
							validateZoneType(pPerilCd, "Del");	//Gzelle 05252015 SR4347
							setEndtPerilForm(null);
							setEndtPerilFields(null);
						}
					});
				}
			});
			
			
			objCurrItemPeril.recordStatus = -1;
			objCurrItem.recordStatus = 1;
			objCurrItem.fromDate = $F("fromDate");
			objCurrItem.toDate = $F("toDate");
			
			if(objCurrItemPeril.perilType == "B"){
				$("tsiAmt").value = parseFloat(nvl($F("tsiAmt").replace(/,/g, ""), 0)) - parseFloat($("inputTsiAmt").getAttribute("oldTsiAmt").replace(/,/g, ""));
				$("annTsiAmt").value = parseFloat(nvl($F("annTsiAmt").replace(/,/g, ""), 0)) - parseFloat($("inputTsiAmt").getAttribute("oldTsiAmt").replace(/,/g, ""));
			}

			$("premAmt").value = parseFloat(nvl($F("premAmt").replace(/,/g, ""), 0)) - parseFloat($("inputPremiumAmt").getAttribute("oldPremAmt").replace(/,/g, ""));
			$("annPremAmt").value = parseFloat(nvl($F("annPremAmt").replace(/,/g, ""), 0)) - parseFloat($("inputAnnPremiumAmt").getAttribute("oldBaseAnnPremAmt").replace(/,/g, ""));
			$("premAmt").value = roundNumber($F("premAmt"),2);	//Gzelle 03122015
			($$("div#perilInformationDiv [changed=changed]")).invoke("removeAttribute", "changed");		
		} catch (e) {
			showErrorMessage("deleteEndtPeril", e);
		}
	}	

	function deletePercentTsiPerilDeductibles(){
		$$("div[name='ded3']").each(function (ded) {
			if (ded.down("input", 0).value == $F("itemNo") && ded.down("input", 2).value == $F("perilCd") && ded.down("input", 10).value == 'T'){
				ded.remove();
			}
		});		
		//marco - 04.25.2013 - added to tag records for deletion
		for(var i = 0; i < objDeductibles.length; i++){
			if(objDeductibles[i].itemNo == $F("itemNo") && objDeductibles[i].perilCd == $F("perilCd") && objDeductibles[i].deductibleType == 'T'){
				objDeductibles[i].recordStatus = -1;
			}
		}
		
	}
	
	//marco - 04.25.2013 - item and par level deductibles
	function deletePercentTsiItemDeductibles(){
		var totalDedAmount2 = $("totalDedAmount2").innerHTML;
		$$("div[name='ded2']").each(function (ded) {
			if (ded.down("input", 0).value == $F("itemNo") && ded.down("input", 2).value == 0 && ded.down("input", 10).value == 'T'){
				totalDedAmount2 = parseFloat(totalDedAmount2) - parseFloat(ded.down("input", 5).value);
				ded.remove();
			}
		});	
		for(var i = 0; i < objDeductibles.length; i++){
			if(objDeductibles[i].itemNo == $F("itemNo") && objDeductibles[i].perilCd == 0 && objDeductibles[i].deductibleType == 'T'){
				objDeductibles[i].recordStatus = -1;
			}
		}
		$("totalDedAmount2").innerHTML = formatCurrency(totalDedAmount2);
	}
	function deletePercentTsiParDeductibles(){
		$$("div[name='ded1']").each(function (ded) {
			if (ded.down("input", 0).value == 0 && ded.down("input", 2).value == 0 && ded.down("input", 10).value == 'T'){
				ded.remove();
			}
		});
		for(var i = 0; i < objDeductibles.length; i++){
			if(objDeductibles[i].itemNo == 0 && objDeductibles[i].perilCd == 0 && objDeductibles[i].deductibleType == 'T'){
				objDeductibles[i].recordStatus = -1;
			}
		}
	}
	
	function deletePerilDeductibles(){
		$$("div[name='ded3']").each(function (ded) {
			if (ded.down("input", 0).value == $F("itemNo") && ded.down("input", 2).value == $F("perilCd")){
				ded.remove();
			}
		});
	}
	
	function setItemPerilVariables(row, boolPolicy){
		try {
			itemNo 			 	= $F("itemNo");
			perilCd			 	= row.down("input", 1).value;
			perilName		  	= row.down("input", 2).value;			
			premiumRate		 	= row.down("input", 3).value;
			tsiAmount		 	= (boolPolicy ? 0 : row.down("input", 4).value);
			annTsiAmount	 	= row.down("input", 5).value;
			premiumAmount 	 	= (boolPolicy ? 0 : row.down("input", 6).value);
			annPremiumAmount	= row.down("input", 7).value;
			remarks			 	= row.down("input", 8).value;
			recFlag			 	= row.down("input", 10).value;
			basicPerilCd	 	= row.down("input", 11).value;
			riCommRate		 	= row.down("input", 12).value;
			riCommAmount	 	= row.down("input", 13).value;
			tarfCd			 	= row.down("input", 14).value;
			perilType			= row.down("input", 15).value;
			noOfDays			= row.down("input", 16).value;
			baseAmt				= row.down("input", 17).value;
		} catch(e){
			showErrorMessage("setItemPerilVariables", e);
		} 
	}
	
	function validatePerilDeductibles(perilCd){
		result = false;
		$$("div[name='ded3']").each(function(ded){
			if(ded.down("input", 0).value == itemNo && ded.down("input", 2).value == perilCd && ded.down("input", 10).value == 'T'){ //marco - 04.25.2013 - added itemNo condition
				result = true;
			}
		});
		return result;
	}
	
	function setEndtVariables(){
		try {			
			itemNo			 = $F("itemNo");
			perilCd			 = $F("perilCd");
			perilName		 = objCurrItemPeril.perilName; //$("perilCd").options[$("perilCd").selectedIndex].text;
			perilType		 = objCurrItemPeril.perilType; //$("perilCd").options[$("perilCd").selectedIndex].getAttribute("perilType");
			premiumRate		 = $F("inputPremiumRate");
			tsiAmount		 = $F("inputTsiAmt").replace(/,/g, "");
			annTsiAmount	 = $F("inputAnnTsiAmt").replace(/,/g, "");
			premiumAmount 	 = $F("inputPremiumAmt").replace(/,/g, "");
			annPremiumAmount = $F("inputAnnPremiumAmt").replace(/,/g, "");
			remarks			 = escapeHTML2($F("inputCompRem"));
			basicPerilCd	 = objCurrItemPeril.bascPerlCd; //objCurrItemPeril.bascPerilCd; //$("perilCd").options[$("perilCd").selectedIndex].getAttribute("basicPerilCd");
			riCommRate		 = $F("inputRiCommRate").replace(/,/g, "");
			riCommAmount     = $F("inputRiCommAmt").replace(/,/g, ""); //parseFloat(premiumRate) * parseFloat(riCommRate) / 100; // mark jm 10.17.2011
			tarfCd			 = $F("inputPerilTariff");
			noOfDays		 = $F("inputNoOfDays");
			baseAmt			 = $F("inputBaseAmt").replace(/,/g, "");
			
			var recExist = checkIfPerilIsInPolicy(itemNo, perilCd);
			if ($F("btnAddPeril") == "Add"){
				recFlag = "A";
			} else if (recExist){
				recFlag	= "C";
			} 			
		} catch (e) {
			showErrorMessage("setEndtVariables", e);
		}		
	}

	function proceedCheckEndtPeril(){
		try {
			/*if ($F("delPercentTsiDeductibles") != "Y"){	commented out by Gzelle 08172015 SR4851
				var percentTsiDedExist = validatePerilDeductibles(perilCd);
	
				if (percentTsiDedExist){
					showConfirmBox("Confirm", "The peril has an existing deductible based on % of TSI.  Updating the peril will delete the existing deductible. Continue?", "Yes", "No", tagDeleteDeductibles, "");
					return false;
				}
			} end Gzelle 08172015 SR4851*/
	
			new Ajax.Request(contextPath+"/GIPIWItemPerilController", {
				method: "GET",
				parameters: {action: 		  		"checkEndtPeril",
							 itemNo: 		  		itemNo,
							 globalParType:			$F("globalParType"),
							 globalParId: 	  		$F("globalParId"),
							 globalLineCd: 	  		$F("globalLineCd"),
							 globalSublineCd: 		$F("globalSublineCd"),
							 perilCd:		  		perilCd,
							 premiumRate:	  		premiumRate,
							 premiumAmount:   		premiumAmount,
							 annPremiumAmount: 		annPremiumAmount,
							 tsiAmount: 			tsiAmount,
			 				 annTsiAmount:			annTsiAmount,
			 				 itemPremiumAmount: 	itemPremiumAmount,
			 				 itemAnnPremiumAmount: 	itemAnnPremiumAmount				 
							 },
				onCreate: function() {						
					setCursor("wait");										
					showNotice("Checking Endorsement Item Peril, please wait...");
				}, 
				onComplete: function (response)	{	
					checkErrorOnResponse(response);
																			
					var messageRowArr = response.responseText.split("##");				
					
					if (1 == messageRowArr.length) {						
						var messageArr = messageRowArr[0].split("@");
						addEndtPeril();
					} else {			
						for(var i=1; i < messageRowArr.length; i++){
							var messageArr = messageRowArr[i].split("@");
							var tempPerilCd = perilCd;
	
							if ("5" == messageArr[0]){
								showMessageBox(messageArr[1]);
								return false;
							}
							
							if ("1" == messageArr[0]){
								showConfirmBox("Confirm", messageArr[1], "Yes", "No", function(){
										includeWC($F("itemNo"), tempPerilCd);
									}, "");
	
								(2 == messageRowArr.length ? addEndtPeril() : "");
							}
							
							
							if ("2" == messageArr[0] || "3" == messageArr[0] || "4" == messageArr[0]){
								if ($F("delPercentTsiDeductibles") != "Y" && changeIn == "tsi"){	//Gzelle 08172015 SR4851
									showConfirmBox("Confirm", messageArr[1], "Yes", "No", tagDeleteDeductibles, "");
								} else {
									addEndtPeril();		
									changeIn = ""; //Gzelle 08172015 SR4851
								}									
							} 
	
							if ("5" == messageArr[0]){
								showMessageBox(messageArr[1]);
								return false;
							}					 								
						}							
					}
					hideNotice("");
					setCursor("default");
				}
			});
		} catch(e){
			showErrorMessage("proceedCheckEndtPeril", e);
		}
	}	
	
	function checkEndtPeril(){
		setEndtVariables();		
		try {
			if(nvl($("itmperlGroupedExists"), null) != null){ // condition added by: Nica 06.25.2012
				if ($F("itmperlGroupedExists") == "Y") {
					showMessageBox("There are existing grouped item perils and you cannot modify, add or delete perils in current item.", "info");
					return false;
				}
			}
			
			if(discExist){
				if("Add" == $F("btnAddPeril")) {
					showMessageBox("Adding of new peril is not allowed because Policy have existing discount. If you want to make any changes Please press the button for removing discounts.");
				} else if ("Update" == $F("btnAddPeril")){
					showMessageBox("Changes in the existing peril is not allowed because Policy have existing discount. If you want to make any changes Please press the button for removing discounts.");
				}
				return false;				
			} else if (polbasProrateFlag == 1 && Date.parse(objGIPIWPolbas.endtExpiryDate) <= Date.parse(objGIPIWPolbas.effDate)) {
				showMessageBox("Your endorsement expiry date is equal to or less than your effectivity date. Restricted condition.");
				return false;					
			} 
			
			//d.alcantara 07.10.2012 
			if (objUWParList.binderExist == "Y"){
				showMessageBox("This PAR has corresponding records in the posted tables for RI. Could not proceed.", imgMessage.ERROR);				
				setEndtPerilForm(null);
				return false;
			}
			
			recExist = checkIfPerilIsInPolicy(itemNo, perilCd);
			
			if($F("itemNo") == "" && $("row"+$F("itemNo")) != null && $("row"+$F("itemNo")).hasClassName("selectedRow")){
				showMessageBox("Please select an item first.");
				return false;
			} else if(perilCd == "") {
				showMessageBox("Please select a peril first.");
				$("perilCd").focus();
				return false;
			}

			var exists = false;			
			$$("div[name='rowEndtPeril']").each(function(rowEndtPeril){
				if(itemNo == rowEndtPeril.down("input", 0).value && perilCd == rowEndtPeril.down("input", 1).value){
					exists = true;
				}
			});
			
			if($("inputAnnTsiAmt").readAttribute("tempValue")){
				if(parseFloat($("inputAnnTsiAmt").readAttribute("tempValue")) < 0){
					showMessageBox("Ann TSI amount must be greater than or equal to 0.00", imgMessage.ERROR); 
					return false;
				}
			}
			
			if (exists == true && $F("btnAddPeril") == "Add"){
				showMessageBox("Peril already exists in the list.");
				$("perilCd").focus();
				return false;
			//} else if(tsiAmount <= 0 && $F("hidPerilRecFlag") == "A"){ //removed by robert GENQA SR 4826 07.29.15
			} else if(tsiAmount < 0 && $F("hidPerilRecFlag") == "A"){ //added by robert GENQA SR 4826 07.29.15
				showWaitingMessageBox("Invalid TSI Amount. Valid value should be from 0.01 to 99,999,999,999,999.99.", imgMessage.ERROR, 
    					function (){
							$("inputTsiAmt").value = formatCurrency(nvl($("inputTsiAmt").readAttribute("tsiAmt"), 0));
							$("inputTsiAmt").select();
							$("inputTsiAmt").focus();
    					});
				return false;
			} else if(tsiAmount == 0 && !recExist && /*recFlag*/ $F("hidPerilRecFlag") == "A"){  //added recFlag by robert GENQA SR 4826 07.29.15 //Deo [08.25.2016]: replace recFlag with hidPerilRecFlag (SR-22939)
				showMessageBox("TSI amount must not be equal to zero.");
				$("inputTsiAmt").focus();
				return false;
			} else if(tsiAmount <= 0 && /*recFlag*/ $F("hidPerilRecFlag") == "A" && !recExist){ //Deo [08.25.2016]: replace recFlag with hidPerilRecFlag (SR-22939)
				showMessageBox("Valid TSI Amount is required.");
				$("inputTsiAmt").value    = ($F("btnAddPeril") == "Add" ? "0.00" : hidTsiAmount);
				$("inputAnnTsiAmt").value = ($F("btnAddPeril") == "Add" ? "0.00" : hidAnnTsiAmount);
				return false;			
			} else if(premiumRate > 100){
				showMessageBox("Rate must not be greater than a hundred (100%).");
				$("inputPremiumRate").focus();
				return false;
			} else if(riCommRate > 100){
				showMessageBox("RI Rate must not be greater than a hundred (100%).");
				$("inputRiCommRate").focus();
				return false;				
			} else if(premiumAmount < 0 && /*recFlag*/ $F("hidPerilRecFlag") == "A" && !recExist){ //Deo [08.25.2016]: replace recFlag with hidPerilRecFlag (SR-22939)
				showMessageBox("Premium must not be less than zero.");				
				$("inputPremiumAmt").value    = ($F("btnAddPeril") == "Add" ? "0.00" : hidPremiumAmount);
				$("inputAnnPremiumAmt").value = ($F("btnAddPeril") == "Add" ? "0.00" : hidAnnPremiumAmount);
				return false;
			} else if (!validateAllied()){
				$("perilCd").focus();
				return false;
			} else if($F("btnAddPeril") == "Update" && !validateBasicPeril()){
				return false;
			} 

			var alliedExist = 'N';
			
			for(var i=0; i<objGIPIWItemPeril.length; i++){
				if(objGIPIWItemPeril[i].perilType == "A" ){
					alliedExist = 'Y';
				}
			}
			
			if(backEndt == "Y" && alliedExist == "Y"){
				validateBackAllied();
			} else {
				proceedCheckEndtPeril();
			}

		} catch(e){
			showErrorMessage("checkEndtPeril", e);
		}
	}
		
	function addEndtPeril() {
		try	{			
			var insId = "insPeril" + itemNo + perilCd;
			var insertContent = '<input type="hidden" name="insItemNo" 			 value="'+itemNo+'"/>'+
								'<input type="hidden" name="insPerilCd" 		 value="'+perilCd+'"/>'+
								'<input type="hidden" name="insPerilName" 		 value="'+perilName+'"/>'+
								'<input type="hidden" name="insPremiumRate" 	 value="'+parseFloat(premiumRate)+'"/>'+
						   		'<input type="hidden" name="insTsiAmount" 		 value="'+tsiAmount+'"/>'+
						   		'<input type="hidden" name="insAnnTsiAmount" 	 value="'+annTsiAmount+'"/>'+
								'<input type="hidden" name="insPremiumAmount" 	 value="'+premiumAmount+'"/>'+
								'<input type="hidden" name="insAnnPremiumAmount" value="'+annPremiumAmount+'"/>'+
								'<input type="hidden" name="insRemarks" 		 value="'+remarks+'"/>'+
								'<input type="hidden" name="insDiscSum" 		 value=""/>'+
								'<input type="hidden" name="insRecFlag" 		 value="'+recFlag+'"/>'+
								'<input type="hidden" name="insWcSw" 		 	 value="'+incWC+'"/>'+
								//'<input type="hidden" name="insBasicPerilCd" 	 value="'+basicPerilCd+'"/>'+
								'<input type="hidden" name="insRiCommRate"	 	 value="'+riCommRate+'" />'+
								'<input type="hidden" name="insRiCommAmount" 	 value="'+riCommAmount+'" />'+
								'<input type="hidden" name="insTarfCd" 	 		 value="'+tarfCd+'" />'+
								'<input type="hidden" name="insNoOfDays" 	 	 value="'+noOfDays+'" />'+
								'<input type="hidden" name="insBaseAmt"			 value="'+baseAmt+'">';
											
			var newId = "rowEndtPeril" + itemNo + perilCd;								
			var viewContent   = '<input type="hidden" name="hidItemNo" 			 value="'+itemNo+'"/>'+
								'<input type="hidden" name="hidPerilCd" 		 value="'+perilCd+'"/>'+
								'<input type="hidden" name="hidPerilName" 		 value="'+perilName+'"/>'+
								'<input type="hidden" name="hidPremiumRate" 	 value="'+premiumRate+'"/>'+
						   		'<input type="hidden" name="hidTsiAmount" 		 value="'+tsiAmount+'"/>'+
						   		'<input type="hidden" name="hidAnnTsiAmount" 	 value="'+annTsiAmount+'"/>'+ 
								'<input type="hidden" name="hidPremiumAmount" 	 value="'+premiumAmount+'"/>'+
								'<input type="hidden" name="hidAnnPremiumAmount" value="'+annPremiumAmount+'"/>'+
								'<input type="hidden" name="hidRemarks" 		 value="'+remarks+'"/>'+
								'<input type="hidden" name="hidDiscSum" 		 value=""/>'+
								'<input type="hidden" name="hidRecFlag" 		 value="'+recFlag+'"/>'+
								'<input type="hidden" name="hidBasicPerilCd" 	 value="'+basicPerilCd+'"/>'+
								'<input type="hidden" name="hidRiCommRate"	 	 value="'+riCommRate+'" />'+
								'<input type="hidden" name="hidRiCommAmount" 	 value="'+riCommAmount+'" />'+
								'<input type="hidden" name="hidTarfCd" 	 		 value="'+tarfCd+'" />'+
								'<input type="hidden" name="hidPerilType" 	     value="'+perilType+'" />'+
								'<input type="hidden" name="hidNoOfDays" 	     value="'+noOfDays+'" />'+
								'<input type="hidden" name="hidBaseAmt"			 value="'+baseAmt+'">'+
								'<div id="labelDiv1">'+
								'<label name="lblItemNo" 			style="width: 36px; text-align: center; margin-left: 3px;">'+itemNo+'</label>'+
								'<label name="lblPerilName" 		style="width: 135px; text-align: left; margin-left: 5px;">'+perilName.truncate(18, "...")+'</label>'+
								'<label name="lblPremiumRate" 		style="width: 132px;; text-align: right; margin-left: 3px;">'+formatToNineDecimal(premiumRate)+'</label>'+
						   		'<label name="lblTsiAmount" 		style="width: 132px; text-align: right; margin-left: 3px;">'+formatCurrency(tsiAmount)+'</label>'+
						   		'<label name="lblAnnTsiAmount" 		style="width: 132px; text-align: right; margin-left: 3px;">'+formatCurrency(annTsiAmount)+'</label>'+
								'<label name="lblPremiumAmount" 	style="width: 132px; text-align: right; margin-left: 3px;">'+formatCurrency(premiumAmount)+'</label>'+
								'<label name="lblAnnPremiumAmount"	style="width: 145px; text-align: right; margin-left: 3px;">'+formatCurrency(annPremiumAmount)+'</label>'+
								'</div>'+
								'<div id="labelDiv2">'+
								'<label name="lblItemNo" 			style="width: 36px; text-align: center; margin-left: 3px;">'+itemNo+'</label>'+
								'<label name="lblPerilName" 		style="width: 135px; text-align: left; margin-left: 5px;">'+perilName.truncate(18, "...")+'</label>'+
						   		'<label name="lblRIRate" 		    style="width: 135px; text-align: right; margin-left: 3px;">'+formatToNineDecimal(riCommRate)+'</label>'+
								'<label name="lblCommissionAmount" 	style="width: 140px; text-align: right; margin-left: 3px;">'+formatCurrency(riCommAmount)+'</label>'+
								'<label name="lblPremiumCeded"		style="width: 140px; text-align: right; margin-left: 3px;">'+formatCurrency(premiumAmount)+'</label>'+
								'</div>';
												
			if ($F("btnAddPeril") == "Update") {			
				$(newId).update(viewContent);
				$(newId).removeClassName("selectedRow");

				setJSONPeril(objCurrItemPeril);
				objCurrItemPeril.recordStatus = 1;

				if(objCurrItemPeril.perilType == "B"){
					$("tsiAmt").value = (parseFloat(nvl($F("tsiAmt").replace(/,/g, ""), 0)) - parseFloat(nvl($("inputTsiAmt").getAttribute("oldTsiAmt").replace(/,/g, ""), 0))) + parseFloat($F("inputTsiAmt").replace(/,/g, ""));
					$("annTsiAmt").value = (parseFloat(nvl($F("annTsiAmt").replace(/,/g, ""), 0)) - parseFloat(nvl($("inputTsiAmt").getAttribute("oldTsiAmt").replace(/,/g, ""), 0))) + parseFloat($F("inputTsiAmt").replace(/,/g, ""));
				}
				
 				if(itemAnnPremAmt != null) {
					$("premAmt").value = (parseFloat(nvl(itemPremAmt.replace(/,/g, ""), 0)) - parseFloat(nvl($("inputPremiumAmt").getAttribute("oldPremAmt").replace(/,/g, ""), 0)));
					$("annPremAmt").value = (parseFloat(nvl(itemAnnPremAmt.replace(/,/g, ""), 0)) - parseFloat(nvl($("inputAnnPremiumAmt").getAttribute("oldBaseAnnPremAmt").replace(/,/g, ""), 0)));
					itemPremAmt = null;
					itemAnnPremAmt = null;
				} else {
					var baseAnnPremAmt = ($("inputAnnPremiumAmt").hasAttribute("baseAnnPremAmt") ? $("inputAnnPremiumAmt").getAttribute("baseAnnPremAmt").replace(/,/g, "") : 0);
					$("premAmt").value = (parseFloat(nvl($F("premAmt").replace(/,/g, ""), 0)) - parseFloat(nvl($("inputPremiumAmt").getAttribute("oldPremAmt").replace(/,/g, ""), 0))) + parseFloat($F("inputPremiumAmt").replace(/,/g, ""));
					$("annPremAmt").value = (parseFloat(nvl($F("annPremAmt").replace(/,/g, ""), 0)) - parseFloat(nvl($("inputAnnPremiumAmt").getAttribute("baseAnnPremAmt").replace(/,/g, ""), 0))) + parseFloat(baseAnnPremAmt);
				}
			} else {
				if(objCurrItemPeril.perilType == "B"){
					$("tsiAmt").value = parseFloat(nvl($F("tsiAmt").replace(/,/g, ""), 0)) + parseFloat($F("inputTsiAmt").replace(/,/g, ""));
					$("annTsiAmt").value = parseFloat(nvl($F("annTsiAmt").replace(/,/g, ""), 0)) + parseFloat($F("inputTsiAmt").replace(/,/g, ""));
				}				

				if(objCurrItem.prorateFlag != "2" || objCurrItem.prorateFlag != "3") {
					if(itemAnnPremAmt != null) {
						$("premAmt").value = itemPremAmt;
						$("annPremAmt").value = itemAnnPremAmt;
						itemPremAmt = null;
						itemAnnPremAmt = null;
					} else {
						$("premAmt").value = parseFloat(nvl($F("premAmt").replace(/,/g, ""), 0)) + parseFloat(nvl($F("inputPremiumAmt").replace(/,/g, ""),0)); //NVL Added by Jerome Bautista 09.14.2015 SR 17631
						$("annPremAmt").value = parseFloat(nvl($F("annPremAmt").replace(/,/g, ""), 0)) + parseFloat(nvl($("inputAnnPremiumAmt").getAttribute("baseAnnPremAmt").replace(/,/g, ""),0)); //NVL Added by Jerome Bautista 09.14.2015 SR 17631
					}
				}

				var newRow = new Element('div');
				newRow.setAttribute("name", "rowEndtPeril");
				newRow.setAttribute("id", newId);
				newRow.setAttribute("item", itemNo);
				newRow.addClassName("tableRow");
				newRow.setStyle("display: none;");
					
				newRow.update(viewContent);					
				$("perilTableContainerDiv").insert({bottom: newRow});
				
				newRow.observe("mouseover", function ()	{
					newRow.addClassName("lightblue");
				});
				
				newRow.observe("mouseout", function ()	{
					newRow.removeClassName("lightblue");
				});
	
				newRow.observe("click", function ()	{	
					newRow.toggleClassName("selectedRow");
					if (newRow.hasClassName("selectedRow")){
						for(var i=0; i<objGIPIWItemPeril.length; i++) {
							if (objGIPIWItemPeril[i].itemNo == parseInt($F("itemNo").trim()) 
									&& objGIPIWItemPeril[i].perilCd == newRow.down("input", 1).value
									&& objGIPIWItemPeril[i].recordStatus != -1) {
								objCurrItemPeril = objGIPIWItemPeril[i];
								break;
							}	
						}

						$$("div[name='rowEndtPeril']").each(function (r)	{
							if (newRow.getAttribute("id") != r.getAttribute("id"))	{
								r.removeClassName("selectedRow");
							}
						});
						
						setEndtPerilForm(objCurrItemPeril);
						setEndtPerilFields(objCurrItemPeril);
					} else {
						setEndtPerilForm(null);
						setEndtPerilFields(null);
					}
				});
	
				Effect.Appear(newRow, {
					duration: .5, 
					afterFinish: function ()	{
						checkIfToResizeTable2("perilTableContainerDiv", "rowEndtPeril");
						checkTableIfEmpty2("rowEndtPeril", "endtPerilTable");
					}
				});
							
				var newPeril = createNewJSONPeril();
				newPeril.recordStatus = 0;
				objGIPIWItemPeril.push(newPeril);
				//addNewJSONPeril(newPeril);
			}

			setEndtItemAmounts($F("itemNo"), objGIPIWItemPeril, objGIPIItemPeril);
			var insPeril = new Element('div');
			insPeril.setAttribute("name", "insPeril");
			insPeril.setAttribute("id", insId);
			//insPeril.setStyle("visibility: hidden;");

			insPeril.update(insertContent);
			$("forInsertDiv").insert({bottom: insPeril});
			
			showCommission(($F("btnCommission") == "Commission" ? false : true));
			setEndtPerilForm(null);
			setEndtPerilFields(null);
			($$("div#perilInformationDiv [changed=changed]")).invoke("removeAttribute", "changed");		
			validateZoneType(perilCd);		//Gzelle 05252015 SR4347
		} catch (e)	{
			showErrorMessage("addEndtPeril", e);
		}
	}
	
	/* start - Gzelle 08172015 SR4851 */
	function computeDeductibleAmount(ded, minAmt, maxAmt, rangeSw, rate) {
		var deductAmount = parseFloat(unformatCurrency("inputTsiAmt")) * (parseFloat(rate) / 100);

		if (rate != null) {
			if (minAmt != null && maxAmt != null) {
				if (rangeSw == "H") {
					deductAmount = Math.min(Math.max(deductAmount, minAmt), maxAmt);
				} else if (rangeSw == "L") {
					deductAmount = Math.min(Math.max(deductAmount, minAmt), maxAmt);
				} else {
					deductAmount = maxAmt;
				}
			} else if (minAmt != null) {
				deductAmount = Math.max(deductAmount, minAmt);
			} else if (maxAmt != null) {
				deductAmount = Math.min(deductAmount, maxAmt);
			} else {
				deductAmount = parseFloat(unformatCurrency("inputTsiAmt")) * (parseFloat(rate) / 100);
			}
		} else {
			if (minAmt != null) {
				deductAmount = minAmt;
			} else if (maxAmt != null) {
				deductAmount = maxAmt;
			}
		}
		return deductAmount;
	}	
	
	function recomputePercentTsiDeductible() {
		var dedAmount = 0;
		var totalDedAmount = 0;
		
		new Ajax.Request(contextPath+"/GIISDeductibleDescController",{
			method: "POST",
			parameters: {
				action: "getAllTDedType",
				lineCd: $F("globalLineCd"), 
				sublineCd: objGIPIWPolbas.sublineCd,
				deductibleType: "T"
			},
			asynchronous : false,
			onComplete : function (response){
				if(checkErrorOnResponse(response)){
					objMaintainedDeductibles = JSON.parse(response.responseText);
					for ( var j = 0; j < objMaintainedDeductibles.maintainedDed.length; j++) {
						
						/* peril deductibles */	
						$$("div[name='ded3']").each(function (ded) {
							if (ded.down("input", 4).value == objMaintainedDeductibles.maintainedDed[j]['deductibleCd'] ) {
								if (ded.down("input", 0).value == $F("itemNo") && ded.down("input", 2).value == $F("perilCd") && ded.down("input", 10).value == 'T'){
									dedAmount = computeDeductibleAmount(ded,  objMaintainedDeductibles.maintainedDed[j]['minimumAmount'], 
																			  objMaintainedDeductibles.maintainedDed[j]['maximumAmount'], 
																			  objMaintainedDeductibles.maintainedDed[j]['rangeSw'], 
																			  objMaintainedDeductibles.maintainedDed[j]['deductibleRate']);
								
									for(var i = 0; i < objDeductibles.length; i++){
										if (objDeductibles[i].dedDeductibleCd == ded.down("input", 4).value) {
											if(objDeductibles[i].itemNo == $F("itemNo") && objDeductibles[i].perilCd == $F("perilCd") && objDeductibles[i].deductibleType == 'T'){
												objDeductibles[i].deductibleAmount = dedAmount.toString();
												objDeductibles[i].deductibleRate = objMaintainedDeductibles.maintainedDed[j]['deductibleRate'];
												objDeductibles[i].deductibleText = objMaintainedDeductibles.maintainedDed[j]['deductibleText'];
												objDeductibles[i].deductibleTitle = objMaintainedDeductibles.maintainedDed[j]['deductibleTitle'];
												objDeductibles[i].recordStatus = 1;
											}
										}
									}								
								}
							}
						});	
						
						/* item deductibles */
						totalDedAmount = $("totalDedAmount2").innerHTML.replace(/,/g, "");
						$$("div[name='ded2']").each(function (ded) {
							if (ded.down("input", 4).value == objMaintainedDeductibles.maintainedDed[j]['deductibleCd'] ) {
								if (ded.down("input", 0).value == $F("itemNo") && ded.down("input", 2).value == 0 && ded.down("input", 10).value == 'T'){
									dedAmount = computeDeductibleAmount(ded,  objMaintainedDeductibles.maintainedDed[j]['minimumAmount'], 
																			  objMaintainedDeductibles.maintainedDed[j]['maximumAmount'], 
																			  objMaintainedDeductibles.maintainedDed[j]['rangeSw'], 
																			  objMaintainedDeductibles.maintainedDed[j]['deductibleRate']);

									totalDedAmount = parseFloat(totalDedAmount) - parseFloat(ded.down("input", 5).value);
									totalDedAmount = parseFloat(totalDedAmount) + parseFloat(dedAmount);
									
									ded.down("label", 2).innerHTML = objMaintainedDeductibles.maintainedDed[j]['deductibleTitle'].truncate(25, "...");
									ded.down("label", 2).setAttribute("title", objMaintainedDeductibles.maintainedDed[j]['deductibleTitle']);
									
									ded.down("label", 3).innerHTML = objMaintainedDeductibles.maintainedDed[j]['deductibleText'].truncate(20, "...");
									ded.down("label", 3).setAttribute("title", objMaintainedDeductibles.maintainedDed[j]['deductibleText']);
									
									ded.down("label", 4).innerHTML = formatToNineDecimal(objMaintainedDeductibles.maintainedDed[j]['deductibleRate']);
									
									ded.down("label", 5).innerHTML = formatCurrency(dedAmount);
									ded.down("label", 5).setAttribute("title", formatCurrency(dedAmount));
									ded.down("input", 5).value = dedAmount;
									
									ded.removeClassName("selectedRow");
									setDeductibleForm(null, "2");
									
									for(var i = 0; i < objDeductibles.length; i++){
										if (objDeductibles[i].dedDeductibleCd == ded.down("input", 4).value) {
											if(objDeductibles[i].itemNo == $F("itemNo") && objDeductibles[i].perilCd == 0 && objDeductibles[i].deductibleType == 'T'){
												objDeductibles[i].deductibleAmount = dedAmount.toString();
												objDeductibles[i].deductibleRate = objMaintainedDeductibles.maintainedDed[j]['deductibleRate'];
												objDeductibles[i].deductibleText = objMaintainedDeductibles.maintainedDed[j]['deductibleText'];
												objDeductibles[i].deductibleTitle = objMaintainedDeductibles.maintainedDed[j]['deductibleTitle'];
												objDeductibles[i].recordStatus = 1;
											}
										}
									}
								}
							}
						});	
						$("totalDedAmount2").innerHTML = formatCurrency(totalDedAmount);
						
						/* policy deductibles */
						$$("div[name='ded1']").each(function (ded) {
							if (ded.down("input", 4).value == objMaintainedDeductibles.maintainedDed[j]['deductibleCd'] ) {
								if (ded.down("input", 0).value == 0 && ded.down("input", 2).value == 0 && ded.down("input", 10).value == 'T'){
									dedAmount = computeDeductibleAmount(ded,  objMaintainedDeductibles.maintainedDed[j]['minimumAmount'], 
																			  objMaintainedDeductibles.maintainedDed[j]['maximumAmount'], 
																			  objMaintainedDeductibles.maintainedDed[j]['rangeSw'], 
																			  objMaintainedDeductibles.maintainedDed[j]['deductibleRate']);
									
									for(var i = 0; i < objDeductibles.length; i++){
										if (objDeductibles[i].dedDeductibleCd == ded.down("input", 4).value) {
											if(objDeductibles[i].itemNo == 0 && objDeductibles[i].perilCd == 0 && objDeductibles[i].deductibleType == 'T'){
												objDeductibles[i].deductibleAmount = dedAmount.toString();
												objDeductibles[i].deductibleRate = objMaintainedDeductibles.maintainedDed[j]['deductibleRate'];
												objDeductibles[i].deductibleText = objMaintainedDeductibles.maintainedDed[j]['deductibleText'];
												objDeductibles[i].deductibleTitle = objMaintainedDeductibles.maintainedDed[j]['deductibleTitle'];
												objDeductibles[i].recordStatus = 1;
											}
										}
									}								
								}
							}
						});
					}
				}
			}							 
		});
	}
	/* end - Gzelle 08172015 SR4851 */
	
	function tagDeleteDeductibles(){
		$("delPercentTsiDeductibles").value = "Y";
		/*deletePercentTsiPerilDeductibles(); start Gzelle 08172015 SR4851
		deletePercentTsiItemDeductibles();	//marco - 04.25.2013 - added for item and policy level deductibles
		deletePercentTsiParDeductibles();	//	commented out by Gzelle 08172015 SR4815*/
		recomputePercentTsiDeductible();	//Gzelle 08172015 SR4851
		addEndtPeril();
		hideNotice("");
	}
	
	function includeWC(itemNo, perilCd){
		try {
			$("insPeril" + itemNo + perilCd).down("input", 11).value = "Y";
			var obj = new Object();
			obj.parId = $F("globalParId");
			obj.lineCd = $F("globalLineCd");
			obj.perilCd = perilCd;
			obj.recordStatus = 0;
			objGIPIWPolWC.push(obj);
		} catch(e){
			showErrorMessage("includeWC", e);
		}
	}

	function deleteItemDiscounts(){ //changed function name Kenneth L. 03.27.2014
		try {
			$("delDiscounts").value = "Y";
			disableButton("btnDeleteDiscounts");
			$$("div[name='rowEndtPeril']").each(function(row){
				var hidPremAmt 		= row.down("input", 6);
				var hidAnnPremAmt 	= row.down("input", 7);
				var hidDiscSum		= row.down("input", 9);
				var lblPremAmt		= row.down("label", 5);
				var lblAnnPremAmt	= row.down("label", 6);
					
				hidPremAmt.value 		= parseInt(hidPremAmt.value) + parseInt(hidDiscSum.value);
				hidAnnPremAmt.value 	= parseInt(hidAnnPremAmt.value) + parseInt(hidDiscSum.value);
				lblPremAmt.innerHTML 	= formatCurrency(parseInt(lblPremAmt.innerHTML) + parseInt(hidDiscSum.value));
				lblAnnPremAmt.innerHTML = formatCurrency(parseInt(lblAnnPremAmt.innerHTML) + parseInt(hidDiscSum.value));
	
				hidDiscSum.value = "0";
			});
			discExist = false;
			deleteDiscounts();	//added to delete discounts Kenneth L. 03.27.2014
		} catch (e){
			showErrorMessage("deleteDiscounts", e);
		}
	}

	function checkIfItemHasPerils(rowName, itemNo){
		var exists = false;
		$$("div[name='"+rowName+"']").each(function (row){
			if (row.down("input", 0).value == itemNo){				 				
				exists = true;
			}
		});
		return exists;
	}
	
	function checkIfPerilIsInPolicy(itemNo, perilCd){
		var exists = false;
		$$("div[name='rowPeril']").each(function (row) {
			if (row.down("input", 0).value == itemNo 
			 && row.down("input", 1).value == perilCd){				 				
				exists = true;
			}
		});		
		return exists;
	}
	
	function getNoOfDaysInYear2(year){
		try {
			var date1  = Date.parse("January 1, " + year);
			var date2  = Date.parse("December 31, " + year);
	
			var noOfDays = Math.floor((date2.getTime() - date1.getTime())/oneDay)+1;
			return noOfDays;
		} catch (e){
			showErrorMessage("getNoOfDaysInYear2", e);
		}
	}

	function uncheckEndtTax(){
		$("updateEndtTax").value = "Y";
	}

	function checkEndtTax(){
		$("updateEndtTax").value = "N";
	}
	
	function createNewJSONPeril(){
		var objPeril = new Object();

		objPeril.parId			= $F("globalParId");
		objPeril.lineCd			= $F("globalLineCd");
		objPeril.userId			= "${PARAMETERS['userId']}";
		objPeril.itemNo			= itemNo;
		objPeril.perilCd		= perilCd;
		objPeril.perilName		= perilName;
		objPeril.premRt			= premiumRate;
		objPeril.tsiAmt			= tsiAmount;
		objPeril.annTsiAmt		= annTsiAmount;
		objPeril.premAmt		= premiumAmount;
		objPeril.annPremAmt		= annPremiumAmount;
		objPeril.compRem		= remarks;
		objPeril.riCommRate		= (riCommRate == "" ? null : riCommRate);
		objPeril.riCommAmt  	= riCommAmount;
		objPeril.tarfCd			= tarfCd;
		objPeril.perilType		= perilType;
		objPeril.noOfDays		= noOfDays;
		objPeril.baseAmt		= baseAmt;
		objPeril.bascPerlCd		= basicPerilCd; // added by: Nica 05.14.2012
		objPeril.endtAnnTsiAmt	= $("inputAnnTsiAmt").readAttribute("endtAnnTsiAmt");
		objPeril.endtAnnPremAmt	= $("inputAnnPremiumAmt").readAttribute("endtAnnPremAmt");
		objPeril.baseAnnPremAmt = $("inputAnnPremiumAmt").readAttribute("baseAnnPremAmt");
		objPeril.recFlag 		= $F("hidPerilRecFlag");
		
		return objPeril;
	}
	
	/*
	* Created by	: andrew
	* Date			: October 18, 2010
	* Description	: Creates a new peril object and assign values to it
	*/
	function setJSONPeril(objPeril){
		//var objPeril = new Object();
		objPeril.parId			= $F("globalParId");
		objPeril.lineCd			= $F("globalLineCd");
		objPeril.userId			= "${PARAMETERS['userId']}";
		objPeril.itemNo			= itemNo;
		objPeril.perilCd		= perilCd;
		objPeril.perilName		= perilName;
		objPeril.premRt			= premiumRate;
		objPeril.tsiAmt			= tsiAmount;
		objPeril.annTsiAmt		= annTsiAmount;
		objPeril.premAmt		= premiumAmount;
		objPeril.annPremAmt		= annPremiumAmount;
		objPeril.compRem		= remarks;
		objPeril.riCommRate		= nvl(riCommRate, null);
		objPeril.riCommAmt  	= riCommAmount;
		objPeril.tarfCd			= tarfCd;
		objPeril.perilType		= perilType;
		objPeril.noOfDays		= noOfDays == "" ? null : noOfDays;
		objPeril.baseAmt		= baseAmt == "" ? null : baseAmt;
		objPeril.bascPerlCd		= basicPerilCd; // added by: Nica 05.14.2012
		objPeril.baseAnnPremAmt = $("inputAnnPremiumAmt").readAttribute("baseAnnPremAmt");
		//return objPeril;
	}

	/*
	* Created By 	: andrew
	* Date			: October 20, 2010
	* Description	: Adds new peril object to perils array of objects;
	*/
	function addNewJSONPeril(newObj) {
		newObj.recordStatus = 0;
		objGIPIWItemPeril.push(newObj);
	}

	/*
	* Created By 	: andrew
	* Date			: October 20, 2010
	* Description	: Adds modified peril object to perils array of objects;
	*/
	function addModifiedJSONPeril(editedObj) {
		editedObj.recordStatus = 1;		
		for (var i=0; i<objGIPIWItemPeril.length; i++) {
			if(objGIPIWItemPeril[i].itemNo == editedObj.itemNo && objGIPIWItemPeril[i].perilCd == editedObj.perilCd && objGIPIWItemPeril[i].lineCd == deletedObj.lineCd){
				objGIPIWItemPeril.splice(i, 1); // removes the object from the array of objects if existing
			}		
		}
		objGIPIWItemPeril.push(editedObj); // adds the modified object to the array;
	}

	/*
	* Created By 	: andrew
	* Date			: October 20, 2010
	* Description	: Adds deleted peril object to perils array of objects;
	*/
	function addDeletedJSONPeril(deletedObj) {
		deletedObj.recordStatus = -1;		
		for (var i=0; i<objGIPIWItemPeril.length; i++) {
			if(objGIPIWItemPeril[i].itemNo == deletedObj.itemNo && objGIPIWItemPeril[i].perilCd == deletedObj.perilCd && objGIPIWItemPeril[i].lineCd == deletedObj.lineCd){
				objGIPIWItemPeril.splice(i, 1); // removes the object from the array of objects if existing
			}
		}
		objGIPIWItemPeril.push(deletedObj); // adds the deleted object to the array;
	}

 	$("hrefPeril").observe("click", function(){ 		
		var notIn = "";
		var withPrevious = false;
		var withSelectedRow = false;
		$$("div#perilTableContainerDiv div[name='rowEndtPeril']").each(function(row){		
			if(row.hasClassName("selectedRow")){	
				withSelectedRow = true;
			} 
			if(row.getAttribute("item") == $F("itemNo")){
				if(withPrevious) notIn += ",";
				notIn += row.down("input", 1).value;
				withPrevious = true;
			}			
		});
		if(!withSelectedRow){
			notIn = (notIn != "" ? "("+notIn+")" : "");
			var perilType = null; 
			if(notIn == null || notIn == ""){
				perilType = "B";
			} 
			showEndtPerilLOV(/*objUWGlobal.lineCd*/$F("globalLineCd"), objGIPIWPolbas.sublineCd, perilType, notIn);
		}
	});
	
 	function validatePeril(perilCd, perilType){
 		try {
 			new Ajax.Request(contextPath+"/GIPIWItemPerilController", {
 					parameters : {action : "validatePeril",
 								  parId : $F("globalParId"),
 								  itemNo : $F("itemNo"),
 								  perilCd : perilCd,
 								  perilType: perilType
 								 },
 					onComplete: function(response){
 						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
 							var result = JSON.parse(response.responseText);
 							$("inputTsiAmt").value = formatCurrency(result.tsiAmt);
 							$("inputTsiAmt").setAttribute("tsiAmt", result.tsiAmt);
 							$("inputTsiAmt").setAttribute("oldTsiAmt", "0.00");
 							$("inputAnnTsiAmt").setAttribute("oldAnnTsiAmt", result.annTsiAmt);
 							$("inputAnnTsiAmt").value = formatCurrency(result.annTsiAmt);
 							$("inputAnnTsiAmt").writeAttribute("endtAnnTsiAmt", result.annTsiAmt); 							
 							$("inputPremiumRate").value = formatToNineDecimal(result.premRt);
 							$("inputPremiumRate").setAttribute("premRt", result.premRt);
 							$("inputPremiumAmt").value = formatCurrency(result.premAmt);
 							$("inputPremiumAmt").setAttribute("premAmt", result.premAmt);
 							$("inputPremiumAmt").setAttribute("oldPremAmt", "0.00");
 							$("inputAnnPremiumAmt").value = formatCurrency(result.annPremAmt);
 							$("inputAnnPremiumAmt").setAttribute("oldAnnPremAmt", result.annPremAmt);
 							$("inputAnnPremiumAmt").writeAttribute("endtAnnPremAmt", result.annPremAmt);
 							$("inputAnnPremiumAmt").setAttribute("baseAnnPremAmt", result.baseAnnPremAmt);
 							$("hidPerilRecFlag").value = result.recFlag;
 							
 							if(lineCd == "AC"){
 								$("inputBaseAmt").value = formatCurrency(result.baseAmt);
 								$("inputNoOfDays").value = result.noOfDays;
 							}
 						}
 					}
 				});
 		} catch(e){
 			showErrorMessage("validatePeril", e);
 		}
 	}
 	
 	function showEndtPerilLOV(lineCd, sublineCd, perilType, notIn){
 		LOV.show({
 			controller: "UnderwritingLOVController",
 			urlParameters: {action : "getGIISPerilLOV",
 							lineCd : lineCd,
 							sublineCd : sublineCd,
 							perilType : perilType,
 							notIn : notIn,
 							page : 1},
 			title: "Perils",
 			width: 660,
 			height: 320,
 			columnModel : [	{	id : "perilName",
 								title: "Peril Name",
 								width: '220px'
 							},
 							{	id : "perilSname",
 								title: "Short Name",
 								width: '90px'
 							},
 							{	id : "perilType",
 								title: "Type",
 								width: '90px'
 							},	
 							{	id : "basicPeril",
 								title: "Basic Peril Name",
 								width: '120px'
 							},
 							{	id : "perilCd",
 								title: "Code",
 								width: '90px'
 							},
 						],
 			draggable: true,
 			onSelect: function(row){
 				objCurrItemPeril = row;
 				$("perilCd").value = row.perilCd;
 				$("basicPerilCd").value = row.bascPerlCd;
 				$("txtPerilName").value = unescapeHTML2(row.perilName);
 				validatePeril(row.perilCd, row.perilType);
 				getRiCommRate(row.perilCd); // bonok :: 10.07.2014 :: to retrieve value of RI Rate
 			}
 		  });
 	}
 	
 	// bonok :: 10.07.2014 :: to retrieve value of RI Rate
 	function getRiCommRate(perilCd){
 		try{
 			for(var i = 0; objGIPIItemPeril.length > i; i++){
 	 			if(objGIPIItemPeril[i].perilCd == perilCd && objGIPIItemPeril[i].itemNo == $F("itemNo")){//edgar 10/20/2014 : added condition for item no to retrieve correct rate for each item
 	 				$("inputRiCommRate").value = formatToNineDecimal(objGIPIItemPeril[i].riCommRate);
 	 				$("inputRiCommRate").setAttribute("riCommRate", $F("inputRiCommRate"));
 	 				return;
 	 			}else{
 	 				$("inputRiCommRate").value = formatToNineDecimal(0);
 	 				$("inputRiCommRate").setAttribute("riCommRate", $F("inputRiCommRate"));
 	 			}
 	 		}
 		}catch(e){
 			showErrorMessage("getRiCommRate ", e);
 		}
 	}

	$("inputTsiAmt").observe("keyup", function(e) {	
		if(!(e.keyCode == 109 || e.keyCode == 173) && isNaN($F("inputTsiAmt"))) { //edited d.alcantara, 10.12.2012
			$("inputTsiAmt").value = nvl($("inputTsiAmt").readAttribute("tsiAmt"), "0.00");
		}
	});
	 	
	$("inputPremiumAmt").observe("keyup", function(e) {		
		if(!(e.keyCode == 109 || e.keyCode == 173) && isNaN($F("inputPremiumAmt"))) { //edited d.alcantara, 10.12.2012
			$("inputPremiumAmt").value = nvl($("inputPremiumAmt").readAttribute("premAmt"), "0.00");
		}
	});	

	$("inputRiCommAmt").observe("keyup", function(e) {
		if(!(e.keyCode == 109 || e.keyCode == 173) && isNaN($F("inputRiCommAmt"))) { //edited d.alcantara, 10.12.2012
			$("inputRiCommAmt").value = nvl($("inputRiCommAmt").readAttribute("riCommAmt"), "0.00");
		}
	});	
 	
	showCommission(false);
	setEndtPerilForm(null);
	setEndtPerilFields(null);
	initializeChangeTagBehavior();
	
	// moved here by jdiago 08.05.2014 : to make sure that all disabled elements will stop observing
	if("4" == polFlag || objUWGlobal.cancelTag == 'Y'){ //robert 10.09.2012 added condition for cancel tag
		showMessageBox("This is a cancellation type of endorsement, update/s of any details will not be allowed.", imgMessage.WARNING);
		checkIfCancelledEndorsement(); // added by: steven 10/08/2012 - to check if to disable fields if PAR is a cancelled endt		
	}
</script>
