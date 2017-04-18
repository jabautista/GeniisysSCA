<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="hiddenDiv" name="hiddenDiv">
	<input type="hidden" id="deldiscItemNos" 	name="deldiscItemNos" value="" /> 
	<input type="hidden" id="delDiscSw" 		name="delDiscSw" value="N" /> 
	<input type="hidden" id="addItemNo" 		name="addItemNo" /> 
	<input type="hidden" id="addPerilCd" 		name="addPerilCd" /> 
	<input type="hidden" id="perilExist2" 		name="perilExist2" /> 
	<input type="hidden" id="discExists" 		name="discExists" value="${parDetails.discExists}" />
	<input type="hidden" id="perilItem" 		name="perilItem" /> 
	<input type="hidden" id="dumPerilCd" 		name="dumPerilCd" /> 
	<!--input type="hidden" id="perilTarfCd" name="perilTarfCd" /-->
	<input type="hidden" id="perilAnnTsiAmt" 	name="perilAnnTsiAmt" value="0.00" /> 
	<input type="hidden" id="perilAnnPremAmt" 	name="perilAnnPremAmt" value="0.00" /> 
	<input type="hidden" id="perilPrtFlag" 		name="perilPrtFlag" />
	<!--
		removed by emman, changed into text fields. display fields if Reinsurance (emman 05.17.2011)
	<input type="hidden" id="perilRiCommRate" name="perilRiCommRate" value="0" /> 
	<input type="hidden" id="perilRiCommAmt" name="perilRiCommAmt" value="0.00" />
		-->
	<input type="hidden" id="perilSurchargeSw" 		name="perilSurchargeSw" /> 
	<!-- input type="hidden" id="perilBaseAmt" 		name="perilBaseAmt" value="0.00"/-->
	<input type="hidden" id="perilAggregateSw" 		name="perilAggregateSw" /> 
	<input type="hidden" id="perilDiscountSw" 		name="perilDiscountSw" /> 
	<input type="hidden" id="varVPackageSw" 		name="varVPackageSw" value="N" /> 
	<input type="hidden" id="vOldPlan" 				name="vOldPlan" value="0" /> 
	<input type="hidden" id="copyPerilPageLoaded" 	name="copyPerilPageLoaded" value="N" /> 
	<input type="hidden" id="varPackPlanSw" 		name="varPackPlanSw" value="" /> 
	<input type="hidden" id="varPackPlanCd" 		name="varPackPlanCd" value="" /> 
	<input type="hidden" id="varPlanSw" 			name="varPlanSw" value="" /> 
	<input type="hidden" id="varPlanAmtCh" 			name="varPlanAmtCh" value="" /> 
	<input type="hidden" id="varPlanPerilCh" 		name="varPlanPerilCh" value="" /> 
	<input type="hidden" id="varPlanCreateCh" 		name="varPlanCreateCh" value="N" />
	<input type="hidden" id="varPlanSwUntag" 		name="varPlanSwUntag" value="N" />
	<input type="hidden" id="vOra2010Sw" 			name="vOra2010Sw" value="" /> 
	<input type="hidden" id="changedPlanChTag" 		name="changedPlanChTag" value="N" />
	<input type="hidden" id="varPerilTsiAmt" 		name="varPerilTsiAmt" value="" />
	<input type="hidden" id="ctplDfltTsiAmt" 		name="ctplDfltTsiAmt" value="${ctplDfltTsiAmt}" />
	<input type="hidden" id="ctplCd" 				name="ctplCd" value="${ctplCd}" />
</div>

<div id="perilTotalsDiv" style="margin-top: 10px;">
	<table align="center" style="width: 100%;">
		<tr>
			<td id="totalTsi" class="rightAligned" style="width: 25%;">Total TSI Amt.</td>
			<td id="totalTsiRi" class="rightAligned" style="width: 25%; display: none;">Total TSI Amt. Ceded</td>
			<td class="leftAligned" style="width: 25%;">
				<input tabindex="6000" type="text" id="perilTotalTsiAmt" class="money" readonly="readonly" style="width: 80%;" />
			</td>
			<td id="totalPrem" class="rightAligned" style="width: 15%;">Total Premium Amt.</td>
			<td id="totalPremRi" class="rightAligned" style="width: 18%; display: none;">Total Premium Amt. Ceded</td>
			<td class="leftAligned" style="width: 35%;">
				<input tabindex="6001" type="text" id="perilTotalPremAmt" class="money" readonly="readonly"	style="width: 60%;" />
			</td>
		</tr>
		<tr id="planRow" style="display: none;">
			<td class="rightAligned" style="width: 25%;">Plan</td>
			<td class="leftAligned" style="width: 25%;">
				<select tabindex="6002" id="perilPackageCd" name="perilPackageCd" style="width: 83%;">
					<option></option>
					<c:forEach var="plan" items="${plans}" varStatus="ctr">
						<option value="${plan.packBenCd}">${plan.packageCd}</option>
					</c:forEach>
				</select>
			</td>
			<td class="rightAligned" style="width: 15%;"></td>
			<td class="leftAligned" style="width: 35%;"></td>
		</tr>
	</table>
</div>

<div id="perilInformation" style="margin: 0px;">		
	<div id="parItemPerilTable" name="parItemPerilTable" style="width : 100%;">
		<div id="parItemPerilTableGridSectionDiv" class="">
			<div id="parItemPerilTableGridDiv" style="padding: 10px;">
				<div id="parItemPerilTableGrid" style="height: 0px; width: 900px;"></div>
			</div>
		</div>
	</div>				
</div>

<div id="defaultPerilDiv" name="defaultPerilDiv"><!-- default perils listing placed here in instance of pressing CREATE PERILS -->
</div>
<div id="addItemPerilContainerDiv" changeTagAttr="true">
	<table align="center">
		<tr>
			<td class="rightAligned">Peril Name</td>
			<td class="leftAligned">
				<!-- 
				<select tabindex="602" name="perilCd" id="perilCd" style="display: none;">
					<option value="" riCommRt="" perilType="" bascPerlCd="" wcSw=""></option>
					
					<c:forEach var="peril" items="${perilListing}">
						<option value="${peril.perilCd}" riCommRt="${peril.riCommRt}"
							perilType="${peril.perilType}" bascPerlCd="${peril.bascPerlCd}" defaultTsi = "${peril.defaultTsi}"
							defaultRate="${peril.defaultRate}" wcSw="${peril.wcSw}" tarfCd="${peril.tarfCd}" perilName="${peril.perilName}">${peril.perilName}</option>
					</c:forEach>
					
				</select>				
				 -->
				<div style="float: left; border: solid 1px gray; width: 212px; height: 21px; margin-right: 3px;" class="required">
					<input type="hidden" id="perilCd" name="perilCd" />
					<input type="text" tabindex="6003" style="float: left; margin-top: 0px; margin-right: 3px; width: 182px; border: none;" name="txtPerilName" id="txtPerilName" readonly="readonly" class="required" />
					<img id="hrefPeril" alt="goPeril" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
				</div> 
				<input type="hidden" id="txtPerilCd" name="txtPerilCd" /> 
				<input type="hidden" id="riCommRt" name="riCommRt" /> 
				<input type="hidden" id="perilType" name="perilType" /> 
				<input type="hidden" id="bascPerlCd" name="bascPerlCd" /> 
				<input type="hidden" id="wcSw" name="wcSw" />				 
				<input type="hidden" id="defaultRate" name="defaultRate" />
				<input type="hidden" id="defaultTsi" name="defaultTsi"/></td> 
				<td class="rightAligned">Peril Rate</td>
			<td class="leftAligned">
				<!-- 
				<input tabindex="6004" type="text" class="required"	value="" maxlength="13" style="width: 206px; text-align: right;" id="perilRate" name="perilRate" /><br />
				 -->
				<input tabindex="6004" type="text" class="required applyDecimalRegExp" regExpPatt="pDeci0309" min="0" max="999.999999999" hasOwnChange="Y" value="" maxlength="13" style="width: 206px; text-align: right;" id="perilRate" name="perilRate" /><br />
			</td>
			<td rowspan="6" style="width: 20%;">
				<table cellpadding="1" border="0" align="center">
					<tr align="center">
						<td>
							<input tabindex="6020" id="btnCreatePerils" class="disabledButton"	type="button" style="width: 100%;" value="Create Perils" name="btnCreatePerils" />
						</td>
					</tr>
					<tr align="center">
						<td>
							<input tabindex="6021" id="btnDeleteDiscounts" class="disabledButton" type="button" style="width: 100%;" value="Delete Discounts" name="btnDeleteDiscounts" />
						</td>
					</tr>
					<tr align="center">
						<td>
							<input tabindex="6022" id="btnCopyPeril" class="disabledButton"	type="button" style="width: 100%;" value="Copy Peril" name="btnCopyPeril" />
						</td>
					</tr>
					<tr align="center">
						<td style="width: 100%;">&nbsp;</td>
					</tr>
				</table>
		   </td>
		</tr>
		<tr>
			<td id="tsi" class="rightAligned">TSI Amt.</td>
			<td id="tsiRi" class="rightAligned" style="display: none;">TSI Amt. Ceded</td>
			<td class="leftAligned">
				<!-- 
				<input tabindex="6005" type="text" class="required money2" value="" maxlength="18" style="width: 206px; text-align: right;" id="perilTsiAmt" name="perilTsiAmt" /><br />
				 -->
				<input tabindex="6005" type="text" class="required applyDecimalRegExp" min="1" max="99999999999999.99" regExpPatt="nDeci1402" hasOwnChange="Y" value="" maxlength="18" style="width: 206px; text-align: right;" id="perilTsiAmt" name="perilTsiAmt" /><br />
			</td>
			<td id="prem" class="rightAligned">Premium Amt.</td>
			<td id="premRi" class="rightAligned" style="display: none;">Premium Amt. Ceded</td>
			<td class="leftAligned">
				<!-- 
				<input tabindex="6006" type="text" class="required" value="" maxlength="17" style="width: 206px; text-align: right;" id="premiumAmt" name="premiumAmt" value="${premiumAmt}" /><br />
				 -->
				<input tabindex="6006" type="text" class="required applyDecimalRegExp" min="0" max="9999999999.99" regExpPatt="nDeci1002" hasOwnChange="Y" value="" maxlength="17" style="width: 206px; text-align: right;" id="premiumAmt" name="premiumAmt" value="${premiumAmt}" /><br />
			</td>
		</tr>
		<tr id="remarks">
			<td class="rightAligned">Remarks</td>
			<td class="leftAligned" colspan="3">
<!-- 				<input tabindex="6007" type="text" style="width: 528px;" id="compRem" name="compRem" maxlength="50" /> -->
				<div id="compRemDiv" name="compRemDiv" style="float: left; width: 525px; border: 1px solid gray; height: 22px;">
					<textarea style="float: left; height: 16px; width: 490px; margin-top: 0; border: none;" id="compRem" name="compRem" maxlength="50"  onkeyup="limitText(this,50);" tabindex="6007"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editCompRem" />
				</div>
			</td>
		</tr>
		<tr id="trRi" style="display: none;">
			<td class="rightAligned">RI Comm Rt.</td>
			<td class="leftAligned">
				<!-- 
				<input tabindex="6008" type="text" class="required percentRate" value="" maxlength="18" style="width: 206px; text-align: right;" id="perilRiCommRate" name="perilRiCommRate" /><br />
				 -->
				<!--  
				<input tabindex="6008" type="text" class="required applyDecimalRegExp" regExpPatt="pDeci0309" min="0.000000001" max="100" value="" maxlength="18" style="width: 206px; text-align: right;" id="perilRiCommRate" name="perilRiCommRate" /><br />
				-->
				<input tabindex="6008" type="text" class="required applyDecimalRegExp" regExpPatt="nDeci0309" value="" maxlength="18" style="width: 206px; text-align: right;" id="perilRiCommRate" name="perilRiCommRate" /><br /> <!-- comment out codes above, replaced with this codes : edgar 01/12/2015 -->
			</td>
			<td class="rightAligned">RI Comm Amt.</td>
			<td class="leftAligned">
				<!-- 
				<input tabindex="6009" type="text" class="required" value="" maxlength="17" style="width: 206px; text-align: right;" id="perilRiCommAmt" name="perilRiCommAmt" value="" /><br />
				 -->
				<input tabindex="6009" type="text" class="required applyDecimalRegExp" regExpPatt="nDeci1402" value="" maxlength="17" style="width: 206px; text-align: right;" id="perilRiCommAmt" name="perilRiCommAmt" value="" /><br />
			</td>
		</tr>
		<tr id="remarksRi" style="display: none;">
			<td class="rightAligned">Remarks</td>
			<td class="leftAligned" colspan="3">
<!-- 				<input tabindex="6010" type="text" style="width: 515px;" id="compRemRi" name="compRemRi" maxlength="50" /><br /> -->
				<div id="compRemRiDiv" name="compRemRiDiv" style="float: left; width: 525px; border: 1px solid gray; height: 22px;">
					<textarea style="float: left; height: 16px; width: 490px; margin-top: 0; border: none;" id="compRemRi" name="compRemRi" maxlength="50"  onkeyup="limitText(this,50);" tabindex="6010"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editCompRemRi" />
				</div>
			</td>
		</tr>
		
		<tr id="accPerilDetailsDiv" style="display: none;">
			<td class="rightAligned">Base Amount</td>
			<td class="leftAligned">
				<!-- 
				<input tabindex="6011" type="text" class="" value="" maxlength="17" style="width: 206px; text-align: right;" id="perilBaseAmt" name="perilBaseAmt" /><br />
				 -->
				<input tabindex="6011" type="text" class="applyDecimalRegExp" min="0" max="99999999999999.99" regExpPatt="nDeci1402" value="" maxlength="17" style="width: 206px; text-align: right;" id="perilBaseAmt" name="perilBaseAmt" /><br />
			</td>
			<td class="rightAligned">Number of Days</td>
			<td class="leftAligned">
				<!-- 
				<input tabindex="6012" type="text" class="" value="" maxlength="5" style="width: 206px; text-align: right;"	id="perilNoOfDays" name="perilNoOfDays" value="" /><br />
				 -->
				<input tabindex="6012" type="text" class="applyWholeNosRegExp" min="0" max="99999" regExpPatt="pDigit05" value="" maxlength="5" style="width: 206px; text-align: right;"	id="perilNoOfDays" name="perilNoOfDays" value="" /><br />
			</td>
		</tr>
		<tr id="firePerilDetailsDiv" style="display: none;">
			<td class="rightAligned">Tariff Code</td>
			<td class="leftAligned">
				<!-- 
				<input tabindex="612" type="text" class="" value="" maxlength="30"	style="width: 206px; text-align: right; display: none;"	id="perilTarfCd" name="perilTarfCd" /> 
				<select id="selPerilTarfCd" name="selPerilTarfCd" style="width: 213px; text-align: left;">
					<option value="" perilCd=""></option>
					<c:forEach var="tariff" items="${perilTariffList}" varStatus="ctr">
						<option value="${tariff.tarfCd}" perilCd="${tariff.perilCd}">${tariff.tarfCd} - ${tariff.tarfDesc}</option>
					</c:forEach>
				</select>
				 -->
				<div style="float: left; border: solid 1px gray; width: 212px; height: 21px; margin-right: 3px;">
					<input type="text" class="" value="" maxlength="30"	style="width: 206px; text-align: right; display: none;"	id="perilTarfCd" name="perilTarfCd" />
					<input type="text" tabindex="6013" style="float: left; margin-top: 0px; margin-right: 3px; width: 182px; border: none;" name="txtPerilTarfDesc" id="txtPerilTarfDesc" readonly="readonly"/>
					<img id="hrefPerilTarfCd" alt="goPerilTarfCd" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
				</div> 
			</td>
			<td class="rightAligned"></td>
			<td class="leftAligned"></td>
		</tr>
		<tr>
			<td style="margin-right: 10px;"></td>
			<td colspan="6" style="margin-left: 10px; text-align: left;">
				<input tabindex="6014" type="checkbox" id="chkAggregateSw" style="margin-left: 30px;" /> Aggregate &nbsp;&nbsp;&nbsp; 
				<input tabindex="6015" type="checkbox" id="chkSurchargeSw" style="margin-left: 30px;" disabled="disabled" /> Surcharge &nbsp;&nbsp;&nbsp; 
				<input tabindex="6016" type="checkbox" id="chkDiscountSw"  style="margin-left: 30px;" disabled="disabled" /> Discount &nbsp;&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td>
			<input type="hidden" name="hidDiscountExists" 			id="hidDiscountExists"/>
			<input type="hidden" name="tarfSw" 						id="tarfSw" value="N" />
			<input type="hidden" name="lineMotor" 					id="lineMotor" /> 
			<input type="hidden" name="lineFire" 					id="lineFire" /> 
			<input type="hidden" name="tempPerilCd" 				id="tempPerilCd" /> 
			<input type="hidden" name="tempPerilRate" 				id="tempPerilRate" /> 
			<input type="hidden" name="tempTsiAmt" 					id="tempTsiAmt" /> 
			<input type="hidden" name="tempPremAmt" 				id="tempPremAmt" /> 
			<input type="hidden" name="tempCompRem" 				id="tempCompRem" /> 
			<input type="hidden" name="issCdRi" 					id="issCdRi" value="${issCdRi}" /> 
			<input type="hidden" name="paramName" 					id="paramName" value="${paramName}" />
			<input type="hidden" name="dedItemPerilExists" 			id="dedItemPerilExists">
			<input type="hidden" name="deductiblesDeleted" 			id="deductiblesDeleted" value="N" /> 
			<input type="hidden" name="fireDeleteDeductibles" 		id="fireDeleteDeductibles" value="N" /> 
			<input type="hidden" name="dedItemPeril" 				id="dedItemPeril" value="${dedItemPeril}" /> 
			<input type="hidden" name="deductibleLevel" 			id="deductibleLevel" value="" />
			<input type="hidden" name="deleteTag" 					id="deleteTag" value="N" /> 
			<input type="hidden" name="copyPerilTag" 				id="copyPerilTag" value="N" /> 
			<input type="hidden" name="destinationItem" 			id="destinationItem" value="" />
			<input type="hidden" name="validateDedCallingElement" 	id="validateDedCallingElement" fieldInWord="" value="" /></td>
		</tr>
		<tr>
			<td colspan="4" align="center" style="margin-left: 20px;">
			<input tabindex="6017" id="btnAddItemPeril" class="button" type="button" value="Add" name="btnAddPeril" style="margin-left: 150px;" /> 
			<input tabindex="6018" id="btnDeletePeril" class="disabledButton" type="button" value="Delete" name="btnDeletePeril" /> 
			<input tabindex="6019" id="btnSaveItemPerils" name="btnSaveItemPerils" class="button" type="button" value="View JSON Perils" style="display: none;" /></td>
		</tr>
	</table>
</div>
<div id="itemPerilDeductiblesDiv" style="display: none;">
	<c:forEach items="${dedItemPeril}" var="ded" varStatus="ctr">
		<input name="itemPerilDed" type="hidden" itemNo="${ded.itemNo}" perilCd="${ded.perilCd}" />
	</c:forEach>
</div>
<div id="itemPerilDetailsDiv" style="display: none;">
	<input type="hidden" name="perilGroupExists" id="perilGroupExists" value="N" />
	<input type="hidden" name="basicSw" id="basicSw" />
</div>

<script type="text/javascript" defer="defer">
	var prevPerilRate = ""; //edgar 01/12/2015
	$("prorateFlag").value = objUWParList.prorateFlag;
	
	if (objUWParList.discExists == 'Y') {
		$("hidDiscountExists").value = "Y";
		enableButton("btnDeleteDiscounts");
	}else {
		disableButton("btnDeleteDiscounts");
	}
	
	if (getLineCd() == "AC"){ 
		$("accPerilDetailsDiv").show();
		$("planRow").show();
	}

	if ((objUWGlobal.lineCd == objLineCds.FI) || ("FI" == objUWGlobal.menuLineCd)){
		$("firePerilDetailsDiv").show();
	}
	
	function getPackPlanPerils() {
		try {
			function computePerilRate(premAmt, tsiAmt) {
				var perilRate		= null;
				var shorRate		= ($("shortRatePercent") == null ? nvl(objGIPIWPolbas.shortRtPercent ,0) : $F("shortRatePercent"));
				var prorateFlag		= objUWParList.prorateFlag;
				var startDate 		= dateFormat($F("globalEffDate"), "mm-dd-yyyy");
				var endDate			= dateFormat($F("globalExpiryDate"), "mm-dd-yyyy");

				if ((premAmt == null) || (tsiAmt == null)) {
					perilRate = null;
				} else {
					if (prorateFlag == 1){
						var prorate = computeNoOfDays(startDate, endDate, nvl(objUWParList.compSw, objGIPIWPolbas.compSw))
								   /checkDuration($F("globalEffDate"),$F("globalExpiryDate"));
						perilRate = formatToNineDecimal(((premAmt/tsiAmt)/prorate) * 100);
					}else if (prorateFlag == 2){
						perilRate = formatToNineDecimal((premAmt/tsiAmt) * 100);
					}else {
						perilRate = formatToNineDecimal((premAmt/(tsiAmt * shorRate)) * 100);
					}
				}
				return perilRate;
			}
			
			var  wcTag = false;
			var wcExists = false;
			
			function continuePeril() {
				for(var x=0, length=objGIPIWItem.length; x < length; x++){
					for(var i=0, y=objGIISPackPlanPeril.length; i < y; i++){
						var objPeril 			= new Object();
						objPeril.parId 			= (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
						objPeril.itemNo 		= $F("itemNo");
						objPeril.lineCd 		= (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd"));
						objPeril.perilCd 		= objGIISPackPlanPeril[i].perilCd;
						objPeril.perilName 		= escapeHTML2(objGIISPackPlanPeril[i].perilName);
						objPeril.perilType 		= objGIISPackPlanPeril[i].perilType;
						objPeril.tarfCd 		= $F("perilTarfCd");
						
						if (objGIISPackPlanPeril[i].tsiAmt == "0") {
							showMessageBox("Invalid TSI Amount. Value should be from 0.01 to 99,999,999,999,999.99. " +
											"Please refer to Package Product Maintenance.", imgMessage.ERROR);
							return false;
						}else {
							objPeril.tsiAmt 		= objGIISPackPlanPeril[i].tsiAmt;
						}
						
						if (objGIISPackPlanPeril[i].tsiAmt != "" && objGIISPackPlanPeril[i].premAmt != "" && objGIISPackPlanPeril[i].premRt == "0") {
							objPeril.premRt 		= computePerilRate(objGIISPackPlanPeril[i].premAmt,objGIISPackPlanPeril[i].tsiAmt);
						} else {
							objPeril.premRt 		= objGIISPackPlanPeril[i].premRt == "" ? null : formatToNineDecimal(objGIISPackPlanPeril[i].premRt);
						}
						
						objPeril.premAmt 		= computePerilPremAmount(objUWParList.prorateFlag,objGIISPackPlanPeril[i].tsiAmt,objPeril.premRt);
						objPeril.annTsiAmt 		= objPeril.tsiAmt;
						objPeril.annPremAmt 	= computePerilAnnPremAmount(objPeril.tsiAmt, objPeril.premRt);
						objPeril.recFlag 		= "";
						objPeril.compRem 		= escapeHTML2(objUWParList.issCd == "RI" ? $F("compRemRi") : $F("compRem"));
						objPeril.discountSw		= objGIISPackPlanPeril[i].discountSw == true ? "Y" : "N";
						objPeril.prtFlag 		= objGIISPackPlanPeril[i].prtFlag;
						objPeril.riCommRate 	= nvl(objGIISPackPlanPeril[i].riCommRt, null);
						objPeril.riCommAmt 		= nvl($F("perilRiCommAmt").replace(/,/g , ""), null);
						objPeril.asChargeSw 	= "";
						objPeril.surchargeSw 	= objGIISPackPlanPeril[i].surchargeSw == true ? "Y" : "N";
						objPeril.noOfDays 		= nvl(objGIISPackPlanPeril[i].noOfDays, null);
						objPeril.baseAmt 		= nvl(objGIISPackPlanPeril[i].baseAmt.replace(/,/g , ""), null);
						objPeril.aggregateSw 	= objGIISPackPlanPeril[i].aggregateSw == true ? "Y" : "N";
						objPeril.bascPerlCd 	= nvl(objGIISPackPlanPeril[i].bascPerlCd, null);
						objPeril.recordStatus = 0;
						objGIPIWPolbas.planSw = "Y";
						objGIPIWPolbas.planCd = objGIPIWPolbas.planCd;
						addNewJSONObject(objGIPIWItemPeril, objPeril);		
						if (wcTag) {
							addClauseToWPolWC(objPeril);
						}else {
							if(objGIPIWItem[x].itemNo == $F("itemNo")){
								tbgItemPeril.addBottomRow(objPeril);
							}
						}
						changeTag = 1;
					}
				}
				getTotalAmounts2();
			}
			
			function checkWarrCla() {
				for(var y=0; y < objGIISPackPlanPeril.length; y++){
					for (var i=0; i<objGIISPerilClauses.length; i++){
						if (objGIISPerilClauses[i].perilCd == objGIISPackPlanPeril[y].perilCd){
							wcExists = false;
							//checks if WC is already in GIPIWPolWC
							for (var j=0; j<objGIPIWPolWC.length; j++){
								if ((objGIPIWPolWC[j].wcCd == objGIISPerilClauses[i].mainWcCd)
										&& (objGIPIWPolWC[j].recordStatus != -1)) {
									wcExists = true;
								}
							}
						}
					}
				}
				if (!wcExists){
					showConfirmBox("Warranty & Clauses", "Peril has an attached warranties and clauses, would you like"+
						" to use these as your default values on warranties and clauses?", "Yes", "No", 
						function() {
							wcTag = true;
							continuePeril();
						},
						continuePeril);
				}else {
					continuePeril();
				}
			}
			
			var hasBasicPeril = false;
			for(var y=0; y < objGIISPackPlanPeril.length; y++){
				if (objGIISPackPlanPeril[y].perilType == "B") {
					hasBasicPeril = true;
					break;
				}
			}
			
			if(hasBasicPeril){
				checkWarrCla();
			} else {
				showMessageBox("Unable to apply package plan perils. At least one basic peril must be maintained.", imgMessage.INFO);
			}
			
		} catch (e) {
			showErrorMessage("getPackPlanPerils", e);
		}
	}

	$("hrefPeril").observe("click", function(){
		if(objCurrItem != null){
			var parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : objUWParList.parId);
			var lineCd = (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : objUWGlobal.lineCd);
			var sublineCd = nvl($("sublineCd") != null ? $F("sublineCd") : null, (objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd")));
			var perilType = objGIPIWItemPeril.filter(function(o){ return nvl(o.recordStatus, 0) != -1 && parseInt(o.itemNo, 10) == $F("itemNo") ; }).length < 1 ? "B" : "";// tbgItemPeril.geniisysRows.length < 1 ? "B" : "";
			var notIn = "";

			notIn = createNotInParamInObj(objGIPIWItemPeril, function(obj){	return parseInt(obj.itemNo) == $F("itemNo") && nvl(obj.recordStatus, 0) != -1;	}, "perilCd");		
			
			function onNoFunc() {//onNoFunc
				objGIPIWPolbas.planSw = "N";
				new Ajax.Request(contextPath+"/GIPIWItemPerilController", {
					method: "POST",
					parameters : {action : "updatePlanDetails",
							 	  planSw : "N",
							 	  parId : parId},
					onCreate : showNotice("Processing, please wait..."),
					onComplete: function(response){
						hideNotice();
						if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
							objGIPIWPolbas.planSw = "N";
							objGIPIWPolbas.planChTag = "";
							objGIPIWPolbas.planCd = null;
						}
					}
				});
			}
			
			if (objGIPIWPolbas.planSw == "Y" && objFormParameters.paramOra2010Sw == "Y") {		
				if (tbgItemPeril.geniisysRows.length == 0) {
					showConfirmBox("Package Plan",
									"This is a package plan PAR record. Would you like to apply the peril/s maintained? Press YES to apply the peril/s and NO will untag the par record.",
									"Yes", "No",
									getPackPlanPerils,
									onNoFunc
					);
				}else {
					showConfirmBox("Package Plan",
							"This is a package plan PAR record. Changing the maintained perils will untag the package plan. Do you wish to continue?",
							"Yes", "No",
							function() {
								onNoFunc();
								showPerilByItemLOV(parId, objCurrItem.itemNo, lineCd, sublineCd, perilType, notIn, function(){	onChangeFunction("perilCd", "perils");	});
							}, ""
					);
				}
			}else {
				showPerilByItemLOV(parId, objCurrItem.itemNo, lineCd, sublineCd, perilType, notIn, function(){	onChangeFunction("perilCd", "perils");	});
			}
		}else{
			showMessageBox("Please select item first.", imgMessage.INFO);
			return false;
		}
		
	});

	$("hrefPerilTarfCd").observe("click", function(){
		var lineCd = (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : objUWGlobal.lineCd);

		if($F("txtPerilName").empty()){
			showMessageBox("Please select peril first.", imgMessage.INFO);
			return false;
		}else{
			showTariffByPeril(lineCd, $F("perilCd") /*$("txtPerilName").getAttribute("perilCd")*/);
		}		
	});

	function onChangeFunction(value, attribute){
		try{
			$("validateDedCallingElement").value = value;
			$("validateDedCallingElement").setAttribute("fieldInWord", attribute);
			validateParDetailsBeforeEditing();
		}catch(e){
			showErrorMessage("onChangeFunction", e);
		}
	}
	
	$("perilRate").observe("focus", function () {		
		if($F("txtPerilName").empty()){
			showMessageBox("Please select peril first.", imgMessage.INFO);
			return false;
		}
	});

	$("perilRate").observe("change", function () {		
		onChangeFunction("perilRate", "Peril Rate");
	});
	
	$("perilTsiAmt").observe("focus", function () {		
		if($F("txtPerilName").empty()){
			showMessageBox("Please select peril first.", imgMessage.INFO);
			return false;
		}
	});

	$("perilTsiAmt").observe("change", function () {		
		onChangeFunction("perilTsiAmt", "TSI Amt");
	});
	
	$("premiumAmt").observe("focus", function () {
		if($F("txtPerilName").empty()){
			showMessageBox("Please select peril first.", imgMessage.INFO);
			return false;
		}
	});

	$("premiumAmt").observe("change", function () {		
		onChangeFunction("premiumAmt", "Premium Amt");
	});

	$("compRem").observe("change",	function(){			
		onChangeFunction("compRem", "perils");
	});
	
	// added by d.alcantara, 12/06/2011
	$("perilRiCommRate").observe(/*"blur"*/ "change", function() { // replaced by: Nica 06.27.2012
		onChangeFunction("perilRiCommRate", "Comm Rate");
	});
	
	$("perilRiCommAmt").observe(/*"blur"*/"change", function() { // replaced by: Nica 06.27.2012
		onChangeFunction("perilRiCommAmt", "Comm Amt");
	});
	
	$("perilBaseAmt").observe("change", function(){
		//if(nvl($F("perilBaseAmt"), 0) != 0 && nvl($F("perilNoOfDays"), 0) != 0){ // condition replaced by: Nica 04.22.2013
		if(nvl($F("perilBaseAmt"), 0) != 0 || nvl($F("perilNoOfDays"), 0) != 0){
			onChangeFunction("perilBaseAmt", "peril");
		}
	});
	
	$("perilNoOfDays").observe("change", function(){
		//if(nvl($F("perilBaseAmt"), 0) != 0 && nvl($F("perilNoOfDays"), 0) != 0){ // condition replaced by: Nica 04.22.2013
		if(nvl($F("perilBaseAmt"), 0) != 0 || nvl($F("perilNoOfDays"), 0) != 0){
			onChangeFunction("perilNoOfDays", "peril");
		}
	});

	$("btnDeletePeril").observe("click", function ()	{
		try {
			//belle 05.22.2012 
			if (objUWParList.binderExist == "Y"){
				showMessageBox("This PAR has corresponding records in the posted tables for RI. Could not proceed.", imgMessage.ERROR);				
				return false;
			}
			
			if ($("globalWithTariffSw").value == "Y") { //added by Gzelle 12022014
				if (objDefaultPerilAmts.tariffPeril) {
					showConfirmBox("Tariff",
							"This peril is based on tariff rates. Deleting this peril will untag the 'W/ Tariff' switch."+
							" Do you want to continue?",
							"Yes", "No",
							function(){	
								objDefaultPerilAmts.updateWithTariffSw = true;	
								$("deleteTag").value = "Y";			
								onChangeFunction("delete", "delete");
								clearChangeAttribute("addItemPerilContainerDiv");
								validateZoneType($F("perilCd"),"Del");		//Gzelle 05252015 SR4347
								updateTGPager(tbgItemPeril);
							}, ""
					);
				}else {
					$("deleteTag").value = "Y";			
					onChangeFunction("delete", "delete");
					clearChangeAttribute("addItemPerilContainerDiv");
					validateZoneType($F("perilCd"),"Del");		//Gzelle 05252015 SR4347s
					updateTGPager(tbgItemPeril);
				}
				clearChangeAttribute("addItemPerilContainerDiv");		
				return false;
			}
			
			if (objGIPIWPolbas.planSw == "Y" && objFormParameters.paramOra2010Sw == "Y") {	//added by Gzelle 09262014
				showConfirmBox("Package Plan",
						"This is a package plan PAR record. Changing the maintained perils will untag the package plan. Do you wish to continue?",
						"Yes", "No",
						function(){	
							$("deleteTag").value = "Y";			
							onChangeFunction("delete", "delete");
							clearChangeAttribute("addItemPerilContainerDiv");
							validateZoneType($F("perilCd"),"Del");		//Gzelle 05252015 SR4347
							updateTGPager(tbgItemPeril);
						}, ""
				);
				clearChangeAttribute("addItemPerilContainerDiv");									
				return false;
			}
			
			//added by Gzelle 09122014
			for (var i=0; i<objGIISPerilClauses.length; i++){
				if (objGIISPerilClauses[i].perilCd == $F("perilCd")){
					var wcExists = false;
					if (!wcExists){
						showConfirmBox("Warranty & Clauses", "Peril "+ objCurrItemPeril.perilName +" has an attached warranty/clause"+
							" Deleting this peril will delete the warranty/clause. Do you want to continue?", "Yes", "No", 
							function(){	
								$("deleteTag").value = "Y";			
								onChangeFunction("delete", "delete");
								clearChangeAttribute("addItemPerilContainerDiv");
								validateZoneType($F("perilCd"),"Del");		//Gzelle 05252015 SR4347
								updateTGPager(tbgItemPeril);
							}, "");
						clearChangeAttribute("addItemPerilContainerDiv");									
						return false;
					}
				}
			}
			
			$("deleteTag").value = "Y";			
			onChangeFunction("delete", "delete");
			clearChangeAttribute("addItemPerilContainerDiv");
			validateZoneType($F("perilCd"),"Del");		//Gzelle 05252015 SR4347
			updateTGPager(tbgItemPeril);
			objUWGlobal.parItemPerilChangeTag = 1; // Apollo Cruz 09.11.2014
			
			if($("mtgPagerMsg4").down().innerHTML == "No records found"){ //added by Apollo Cruz 09.10.2014 (temp solution)
				enableButton($("btnCreatePerils"));
			} else {
				disableButton($("btnCreatePerils"));
			}
		} catch (e) {
			showErrorMessage("Delete Peril Button", e);			
		}	
	});

	function validateBeforeSave(){
		var result = false;//true;
		if ("Y" == objUWParList.discExists  && "N" == objFormMiscVariables.miscDeletePerilDiscById){
			//result = false;
			if ("Add" == $("btnAddItemPeril").value){
				showMessageBox("Adding peril is not allowed because Policy have existing discount. If you want to make any changes Please press the button for removing discounts.", "info");
			} else {// if update 
				showMessageBox("Changing perils is not allowed because Policy have existing discount. If you want to make any changes Please press the button for removing discounts.", "info");
			}
		} else if (($F("txtPerilName")=="") /*&& (0 == $("perilCd").selectedIndex)*/){
			//result = false;
			$("perilCd").focus();
			showMessageBox("Peril Name is required.", imgMessage.ERROR);
		} else if ($F("perilRate")==""){
			//result = false;
			$("perilRate").focus();
			showMessageBox("Peril Rate is required.", imgMessage.ERROR);
		} else if (($F("perilTsiAmt")=="") || (0 == parseFloat($F("perilTsiAmt")))){
			//result = false;
			$("perilTsiAmt").focus();
			showMessageBox("TSI Amount is required.", imgMessage.ERROR);
		} else if ($F("premiumAmt")==""/*  || ($F("perilType") == "B" && 0 == parseFloat($F("premiumAmt"))) */){
			//result = false;
			$("premiumAmt").focus();
			showMessageBox("Premium Amount is required.", imgMessage.ERROR);
		} else if (validatePerilTsiAmt2()){
			result = true;
		}
		
		return result;
	}
	//modified by Gzelle 07222014
	function validateTotalPARPremAmt(newPremAmt){
		try{
			var totalPARPremium = 0.00;
			var newPremValid = true;
			
			for (var i=0; i<objGIPIWItemPeril.length; i++){
				if (objGIPIWItemPeril[i].recordStatus != -1){
					var perilPremAmt = parseFloat(objGIPIWItemPeril[i].premAmt);
					var itemCurrRt = parseFloat(nvl(getObjAttrValueForItem($F("itemNo"), "currencyRate"),$F("rate")));
					if (objGIPIWItemPeril[i].perilCd != $F("perilCd")) {
						totalPARPremium = totalPARPremium + (itemCurrRt * perilPremAmt);
					}
				}
			}
			totalPARPremium = totalPARPremium + parseFloat(newPremAmt);
			if (totalPARPremium > 9999999999.99){
				newPremValid = false;
			}
			return newPremValid;
		}catch(e){
			showErrorMessage("validateTotalPARPremAmt", e);
		}		
	}
	//modified by Gzelle 07222014
	function validateTotalPARTsiAmt(newTsiAmt){
		try{
			var totalPARTsi = 0.00;
			var newTsiValid = true;
			
			for (var i=0; i<objGIPIWItemPeril.length; i++){
				if (objGIPIWItemPeril[i].recordStatus != -1){
					var perilTsiAmt = parseFloat(objGIPIWItemPeril[i].tsiAmt);
					var itemCurrRt = parseFloat(nvl(getObjAttrValueForItem($F("itemNo"), "currencyRate"),$F("rate")));
					if (objGIPIWItemPeril[i].perilCd != $F("perilCd")) {
						totalPARTsi = totalPARTsi + (itemCurrRt * perilTsiAmt);
					}
				}
			}
			totalPARTsi = totalPARTsi + parseFloat(newTsiAmt);
			if (totalPARTsi > 99999999999999.99){
				newTsiValid = false;
			}
			return newTsiValid;
		}catch(e){
			showErrorMessage("validateTotalPARTsiAmt", e);
		}		
	}
	
	//added by Gzelle 09292014
	function validatePackPlanTsiAmt(){
		try{
			var tsiChanged = false;
			if (objGIPIWPolbas.planSw == "Y" && objFormParameters.paramOra2010Sw == "Y") {
				if (objCurrItemPeril.tsiAmt != unformatCurrencyValue($F("perilTsiAmt"))){
					tsiChanged = true;
				}
			}
			return tsiChanged;
		}catch(e){
			showErrorMessage("validatePackPlanTsiAmt", e);
		}		
	}

	//added by Gzelle 12032014
	function valTariffPerils(){
		try{
			var amountsChanged = false;
			if ($("globalWithTariffSw").value == "Y" && objDefaultPerilAmts.tariffPeril) {
				if (objCurrItemPeril.tsiAmt != unformatCurrencyValue($F("perilTsiAmt"))
					||objCurrItemPeril.premAmt != unformatCurrencyValue($F("premiumAmt"))
					||objCurrItemPeril.premRt != unformatCurrencyValue($F("perilRate"))){
					amountsChanged = true;
				}
			}
			return amountsChanged;
		}catch(e){
			showErrorMessage("valTariffPerils", e);
		}		
	}
	
	function addClauseToWPolWC(newPerilObj){
		try{
			var perilCd = newPerilObj.perilCd;	//Gzelle 05252015 SR4347
			var objFilteredPerilClauses = objGIISPerilClauses.filter(function(obj){	return obj.perilCd == newPerilObj.perilCd;	});

			if(objFilteredPerilClauses.length > 0){
				var wcExists = false;

				for(var i=0, length=objFilteredPerilClauses.length; i < length; i++){
					//checks if WC is already in GIPIWPolWC
					for (var j=0; j<objGIPIWPolWC.length; j++){						
						if (objGIPIWPolWC[j].wcCd == objFilteredPerilClauses[i].mainWcCd){
							wcExists = true;
							//break;
						}
					}

					if (!wcExists){
						//fetch records from giis_warrcla then add to objWPolicyWC
						var newWCObj 			= new Object();
						
						newWCObj.parId 			= (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
						newWCObj.lineCd 		= nvl(objFilteredPerilClauses[i].lineCd, (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd")));
						newWCObj.wcCd 			= objFilteredPerilClauses[i].mainWcCd;
						newWCObj.swcSeqNo 		= 0;
						newWCObj.printSeqNo 	= 1;
						newWCObj.wcTitle 		= nvl(objFilteredPerilClauses[i].wcTitle, null);
						newWCObj.recFlag 		= "A";
						newWCObj.printSw 		= nvl(objFilteredPerilClauses[i].printSw, null);
						newWCObj.changeTag 		= "N";
						newWCObj.lastUpdate 	= null;
						newWCObj.wcSw 			= null;
						newWCObj.wcTitle2 		= null;
						newWCObj.userId 		= null;
						newWCObj.wcText 		= null;
						newWCObj.wcRemarks 		= null;
						newWCObj.recordStatus 	= 0;
						addNewJSONObject(objGIPIWPolWC, newWCObj);
					}
				}				
			}
			/*
			for (var i=0; i<objGIISPerilClauses.length; i++){
				if (objGIISPerilClauses[i].perilCd == newPerilObj.perilCd){
					var wcExists = false;
					//checks if WC is already in GIPIWPolWC
					
					for (var j=0; j<objGIPIWPolWC.length; j++){
						if (objGIPIWPolWC[j].wcCd == objGIISPerilClauses[i].mainWcCd){
							wcExists = true;
						}
					}
					if (!wcExists){
						//fetch records from giis_warrcla then add to objWPolicyWC
						var newWCObj 			= new Object();
						
						newWCObj.parId 			= (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
						newWCObj.lineCd 		= nvl(objGIISPerilClauses[i].lineCd, (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd")));
						newWCObj.wcCd 			= objGIISPerilClauses[i].mainWcCd;
						newWCObj.swcSeqNo 		= 0;
						newWCObj.printSeqNo 	= 1;
						newWCObj.wcTitle 		= nvl(objGIISPerilClauses[i].wcTitle, null);
						newWCObj.recFlag 		= "A";
						newWCObj.printSw 		= nvl(objGIISPerilClauses[i].printSw, null);
						newWCObj.changeTag 		= "N";
						newWCObj.lastUpdate 	= null;
						newWCObj.wcSw 			= null;
						newWCObj.wcTitle2 		= null;
						newWCObj.userId 		= null;
						newWCObj.wcText 		= null;
						newWCObj.wcRemarks 		= null;
						newWCObj.recordStatus 	= 0;
						addNewJSONObject(objGIPIWPolWC, newWCObj);
					}
				}
			}
			*/
			// add new record to listing
			tbgItemPeril.addBottomRow(newPerilObj);
			// add the new record to our virtual list :)
			addNewJSONObject(objGIPIWItemPeril, newPerilObj);
			// recompute total tsi and prem amounts
			getTotalAmounts2();				
			clearChangeAttribute("addItemPerilContainerDiv");
			setItemPerilForm(null);
			validateZoneType(perilCd);	//Gzelle 05252015 SR4347
		}catch(e){
			showErrorMessage("addClauseToWPolWC", e);
		}		
	}	
	
	$("btnAddItemPeril").observe("click", function(){
		try {
			if(objCurrItem == null) {
				showMessageBox("Please select an item first.", imgMessage.INFO);					
				return false;			
			}
			//belle 05.22.2012 
			if (objUWParList.binderExist == "Y"){
				showMessageBox("This PAR has corresponding records in the posted tables for RI. Could not proceed.", imgMessage.ERROR);				
				return false;
			}
			
			if (validateBeforeSave()){
				var newPerilObj		= new Object();
				var itemNoOfPeril 	= $F("itemNo");
				var lineCd 			= (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd"));
				var perilCd 		= $("perilCd").value;
				var perilName 		= $("txtPerilName");	//$F("btnAddItemPeril") == "Update" ? $F("txtPerilName"):$("perilCd").options[$("perilCd").selectedIndex].getAttribute("perilName");
				var perilRate 		= formatToNineDecimal($F("perilRate"));
				var tsiAmt 			= $F("perilTsiAmt").replace(/,/g , "");
				var premAmt 		= $F("premiumAmt").replace(/,/g , "");
				
				if (!(validateTotalPARPremAmt(premAmt))){
					$("premiumAmt").value = "";
					$("premiumAmt").focus();
					showMessageBox("Adding this Premium Amount will exceed the maximum Total Premium Allowed for this PAR. Total Premium Amount value must range from 0.00 to 9,999,999,999.99.", imgMessage.ERROR);
					return false;		//changed 999,999,999,999.99 to 9,999,999,999.99 Gzelle 07222014
				}
				if (!(validateTotalPARTsiAmt(tsiAmt))){
					$("perilTsiAmt").value = "";
					$("perilTsiAmt").focus();
					showMessageBox("Adding this TSI Amount will exceed the maximum Total TSI Allowed for this PAR. Total TSI Amount value must range from 0.00 to 99,999,999,999,999.99.", imgMessage.ERROR);
					return false;		//changed 9,999,999,999,999,999.99. to 99,999,999,999,999.99 Gzelle 07222014
				}
				
				newPerilObj = createItemPeril();
				
				if ($F("btnAddItemPeril") == "Update")	{
					if (validatePackPlanTsiAmt()) {
						showConfirmBox("Package Plan",
								"Are you sure you want to change the maintained TSI?",
								"Yes", "No",
								function() {
									objGIPIWPolbas.planChTag = "Y";
									newPerilObj.recordStatus = 1;
									updateObjPeril(objGIPIWItemPeril, newPerilObj);
									tbgItemPeril.updateVisibleRowOnly(newPerilObj, tbgItemPeril.getCurrentPosition()[1]);
								    getTotalAmounts2();
									clearChangeAttribute("addItemPerilContainerDiv");
								},
								""
						);
					}else if (valTariffPerils()){
						showConfirmBox("Tariff",
								"This peril is based on tariff rates. Changing the maintained amounts will untag the 'W/ Tariff' switch."+
								" Do you want to continue?",
								"Yes", "No",
								function(){	
									objDefaultPerilAmts.updateWithTariffSw = true;
									newPerilObj.recordStatus = 1;
									updateObjPeril(objGIPIWItemPeril, newPerilObj);
									tbgItemPeril.updateVisibleRowOnly(newPerilObj, tbgItemPeril.getCurrentPosition()[1]);
								    getTotalAmounts2();
								    setItemPerilForm(null);
								    clearChangeAttribute("addItemPerilContainerDiv");
								}, ""
						);
					}else {
						newPerilObj.recordStatus = 1;
						updateObjPeril(objGIPIWItemPeril, newPerilObj);
						tbgItemPeril.updateVisibleRowOnly(newPerilObj, tbgItemPeril.getCurrentPosition()[1]);
					    //addObjToPerilTable(newPerilObj);
					    getTotalAmounts2();
						clearChangeAttribute("addItemPerilContainerDiv");
						setItemPerilForm(null);
						//objUWGlobal.parItemPerilChangeTag = 1; // andrew - 07.25.2012- SR 10143
						//$("tempPerilItemNos").value = updateTempStorage($F("tempPerilItemNos").blank() ? "" :  $F("tempPerilItemNos"), itemNoOfPeril);
					}
				} else { //if button is add peril
					perilName = $F("txtPerilName");	//($("perilCd").options[$("perilCd").selectedIndex].getAttribute("perilName"));
					if ("Y" == objUWParList.discExists && "N" == objFormMiscVariables.miscDeletePerilDiscById){ 
						showMessageBox("Adding of new peril is not allowed because Policy have existing discount. If you want to make any changes Please press the button for removing discounts.", "error");
						return false;
					} else {
						function continueProcess(){
							// add new record to listing
							tbgItemPeril.addBottomRow(newPerilObj);
							// add the new record to our virtual list :)
							addNewJSONObject(objGIPIWItemPeril, newPerilObj);
							// recompute total tsi and prem amounts
							getTotalAmounts2();
							//validate if peril has maintained zone type for FI lines - Gzelle 05252015 SR4347
							validateZoneType(perilCd);
						}
						
						$("addItemNo").value = itemNoOfPeril;
						$("addPerilCd").value = perilCd;
						newPerilObj.recordStatus = 0;
						//objUWGlobal.parItemPerilChangeTag = 1; // andrew - 07.25.2012- SR 10143
						//addObjToPerilTable(newPerilObj);
						//addNewPerilObject(newPerilObj);
						
						//check perilClauses listing for insertion
						for (var i=0; i<objGIISPerilClauses.length; i++){
							if (objGIISPerilClauses[i].perilCd == newPerilObj.perilCd){
								var wcExists = false;
								
								//checks if WC is already in GIPIWPolWC
								for (var j=0; j<objGIPIWPolWC.length; j++){
									if ((objGIPIWPolWC[j].wcCd == objGIISPerilClauses[i].mainWcCd)
											&& (objGIPIWPolWC[j].recordStatus != -1)) {
										wcExists = true;
									}
								}
								if (!wcExists){
									showConfirmBox("Warranty & Clauses", "Peril has an attached warranties and clauses, would you like"+
										" to use these as your default values on warranties and clauses?", "Yes", "No", 
										function(){	addClauseToWPolWC(newPerilObj);	}, 
										function(){ 
											continueProcess();
											setItemPerilForm(null);
											updateTGPager(tbgItemPeril);
										});
									
									//$("tempPerilItemNos").value = updateTempStorage($F("tempPerilItemNos").blank() ? "" :  $F("tempPerilItemNos"), itemNoOfPeril);
									clearChangeAttribute("addItemPerilContainerDiv");									
									return false;
								}
							}
						}					
						
						continueProcess();
						newPerilObj = null;												
					}
					setItemPerilForm(null);
				}				
				clearChangeAttribute("addItemPerilContainerDiv");
				//setItemPerilForm(null);	commented out by Gzelle 12032014
				updateTGPager(tbgItemPeril);								
				//$("tempPerilItemNos").value = updateTempStorage($F("tempPerilItemNos").blank() ? "" :  $F("tempPerilItemNos"), itemNoOfPeril);
				objUWGlobal.parItemPerilChangeTag = 1; //Apollo Cuz 09.11.2014
			}
		} catch(e){
			showErrorMessage("Add Peril Button", e);
		}
	});
	/*
	function getDefaultPerils(){
		try {
			new Ajax.Request(contextPath+"/GIISPerilController?action=getDefaultPerils",{ //+Form.serialize("parInformationForm"),{  
				method: "POST",
				evalScripts: true,
				asynchronous: true,
				parameters: {
					parLineCd: (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd")),
					nbtSublineCd: (objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd")),
					packLineCd: $F("packLineCd"), 
					packSublineCd: $F("packSublineCd")
				},
				//onCreate: showNotice("Getting default peril values..."),
					onComplete: function(response){
						if (checkErrorOnResponse(response)){
							var objDPerils = JSON.parse(response.responseText);
							deleteAllItemPerils();
							for (var j=0; j<objGIPIWItem.length; j++){
								if(objGIPIWItem[j].recordStatus != -1){
									for (var i=0; i<objDPerils.length; i++){
										var perilCd 		= objDPerils[i].perilCd;
										var perilName 		= escapeHTML2(objDPerils[i].perilName); 
										var perilRate 		= objDPerils[i].defaultRate == null ? "0" : objDPerils[i].defaultRate;
										var tsiAmt 			= objDPerils[i].defaultTsi == null ? "0" : objDPerils[i].defaultTsi;
										var premAmt 		= null; 
										var prorateFlag 	= $F("prorateFlag");
										var perilType		= objDPerils[i].perilType;
										var riCommRate		= objDPerils[i].riCommRt == null ? "0" : objDPerils[i].riCommRt;
										
										premAmt = computePerilPremAmount(prorateFlag, objDPerils[i].defaultTsi, objDPerils[i].defaultRate);
										
										var objPeril 			= new Object();
										objPeril.parId 			= (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
										objPeril.itemNo 		= objGIPIWItem[j].itemNo;
										objPeril.lineCd 		= (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd"));
										objPeril.perilCd 		= perilCd;
										objPeril.perilName 		= perilName;
										objPeril.perilType 		= perilType;
										objPeril.tarfCd 		= null;
										objPeril.premRt 		= perilRate;
										objPeril.tsiAmt 		= tsiAmt;
										objPeril.premAmt 		= premAmt;
										objPeril.annTsiAmt 		= tsiAmt;
										objPeril.annPremAmt 	= computePerilAnnPremAmount(tsiAmt, perilRate);
										objPeril.recFlag 		= null;
										objPeril.compRem 		= null;
										objPeril.discountSw 	= "N";
										objPeril.prtFlag 		=  1;
										objPeril.riCommRate	    = riCommRate; 
										objPeril.riCommAmt 		= premAmt * (riCommRate/100);
										objPeril.asChargeSw 	= null;
										objPeril.surchargeSw 	= null;
										objPeril.noOfDays 		= null;
										objPeril.baseAmt 		= null;
										objPeril.aggregateSw 	= null;
										objPeril.bascPerlCd 	= null;
		
										addObjToPerilTable(objPeril);
										addNewPerilObject(objPeril);
										objPeril = null; 
										clearChangeAttribute("addItemPerilContainerDiv");
									}
								}
							}
						}
					}
				});
		} catch (e) {
			showErrorMessage("getDefaultPerils", e);
		}
	}
	*/
	function getDefaultPerils(){
		try{
			
			// set the crete perils flag
			objFormMiscVariables.miscCreatePerils = "Y";

			// clear the itemperil listing
			tbgItemPeril.empty();
			
			var j = objGIPIWItemPeril.length;
			
			while(j--){//apollo 09.18.2014 other peris should be removed when creating default perils
				if(objGIPIWItemPeril[j].itemNo == $F("itemNo")){
					objGIPIWItemPeril.splice(j, 1);				
				}
			}

			// add the default perils in listing
			for(var i=0, length=objGIPIWItem.length; i < length; i++){
				if(objGIPIWItem[i].itemNo == $F("itemNo")){ //Apollo 09.18.2014. only the selected item should be populated by default perils
					for(var x=0, y=objGIISPeril.length; x < y; x++){
						var perilCd 		= objGIISPeril[x].perilCd;
						var perilName 		= unescapeHTML2(objGIISPeril[x].perilName); 
						var perilRate 		= objGIISPeril[x].defaultRate == null ? "0" : objGIISPeril[x].defaultRate;
						var tsiAmt 			= objGIISPeril[x].defaultTsi == null ? "0" : objGIISPeril[x].defaultTsi;
						var premAmt 		= null; 
						var prorateFlag 	= $F("prorateFlag");
						var perilType		= objGIISPeril[x].perilType;
						var riCommRate		= objGIISPeril[x].riCommRt == null ? "0" : objGIISPeril[x].riCommRt;
						
						premAmt = computePerilPremAmount(prorateFlag, objGIISPeril[x].defaultTsi, objGIISPeril[x].defaultRate);
						
						var objPeril 			= new Object();
						objPeril.parId 			= (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
						objPeril.itemNo 		= objGIPIWItem[i].itemNo;
						objPeril.lineCd 		= (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd"));
						objPeril.perilCd 		= perilCd;
						objPeril.perilName 		= perilName;
						objPeril.perilType 		= perilType;
						objPeril.tarfCd 		= null;
						objPeril.premRt 		= perilRate;
						objPeril.tsiAmt 		= tsiAmt;
						objPeril.premAmt 		= premAmt;
						objPeril.annTsiAmt 		= tsiAmt;
						objPeril.annPremAmt 	= computePerilAnnPremAmount(tsiAmt, perilRate);
						objPeril.recFlag 		= null;
						objPeril.compRem 		= null;
						objPeril.discountSw 	= "N";
						objPeril.prtFlag 		=  1;
						objPeril.riCommRate	    = riCommRate; 
						objPeril.riCommAmt 		= premAmt * (riCommRate/100);
						objPeril.asChargeSw 	= null;
						objPeril.surchargeSw 	= null;
						objPeril.noOfDays 		= null;
						objPeril.baseAmt 		= null;
						objPeril.aggregateSw 	= null;
						objPeril.bascPerlCd 	= null;
	
						// show the newly inserted record based on the item no
						if(objGIPIWItem[i].itemNo == $F("itemNo")){
							tbgItemPeril.addBottomRow(objPeril);
						}
	
						// add the new record to our virtual list :)
						addNewJSONObject(objGIPIWItemPeril, objPeril);								
					}
				}
			}

			getTotalAmounts2();
			objUWGlobal.parItemPerilChangeTag = 1; //Apollo Cruz 09.11.2014
		}catch(e){
			showErrorMessage("getDefaultPerils", e);
		}
	}

	$("btnCreatePerils").observe("click", function() {
		if ("Y" == $F("perilGroupExists")){
			//clearItemPerilFields();
			setItemPerilForm(null);
			showMessageBox("There are existing grouped item perils and you cannot modify, add or delete perils in current item.", imgMessage.INFO);
			return false;
		}else {
			showConfirmBox("Create Perils", "Existing perils for this policy will be deleted and"+
					" will be replaced by default perils for this policy. "+
					"Do you want to continue?", "Yes", "No", function(){
						//Apollo Cruz 09.18.2014 SR 2319
						var hasBasicPeril = false;
						
						for(var x=0; x < objGIISPeril.length; x++){
							if(objGIISPeril[x].perilType == 'B'){
								hasBasicPeril = true;
								break;
							}
						}
						
						if(hasBasicPeril){
							$("btnAddItemPeril").value = "Add";
							deleteDiscounts();
							getDefaultPerils();
						} else {
							showMessageBox("Unable to create perils. At least one basic peril must be maintained.", imgMessage.INFO);
						}
						
					}, "");
		}
	});

	function showCopyPerilOverlay(){
		try{
			if (countPerilsForItem($F("itemNo")) > 0) {
				if ("Y" == $F("copyPerilPageLoaded")){
					$("itemToCopyPeril").update("");
					var selectContent = "<option value=''></option>";
					/*$$("div#parItemTableContainer div[name='rowItem']").each(function(item){
						var itemNo = item.down("input", 1).value;
						if (itemNo != $F("itemNo")){
							selectContent = selectContent + "<option value='"+itemNo+"'>"+itemNo+"</option>";
						}
					});*/
					
					/*for (var i=0; i<objGIPIWItem.length; i++){
						if (objGIPIWItem[i].recordStatus != -1){
							var itemNo = objGIPIWItem[i].itemNo;
							if (itemNo != $F("itemNo")){
								selectContent = selectContent + "<option value='"+itemNo+"'>"+itemNo+"</option>";
							}
						}
					}
					$("itemToCopyPeril").update(selectContent);*/ 
				} 
				//showOverlayContent(contextPath+"/GIPIWItemController?action=showCopyPerilItems&itemNo="+$F("itemNo"), "Copy Peril/s to Item No. ?", "", 450, 100, 450);
				showOverlayContent2(contextPath+"/GIPIWItemPerilController?action=showCopyPerilItems&itemNo="+$F("itemNo"), "Copy Peril/s to Item No. ?", 300, "");
			} else {
				showMessageBox("Item has no existing peril(s) to copy.", imgMessage.INFO);
				return false;
			}
		}catch(e){
			showErrorMessage("showCopyPerilOverlay", e);
		}		
	}

	$("btnCopyPeril").observe("click", function() {
		var fireDeductibleAlert = false;
		
		if (objUWParList.binderExist == "Y"){
			showMessageBox("This PAR has corresponding records in the posted tables for RI. Could not proceed.", imgMessage.ERROR);				
			return false;
		}
		
		if (!checkItemExists2($F("itemNo"))){
			showMessageBox("Please select an item first.", imgMessage.INFO);
			return false;
		}

		if ("Y" == $F("perilGroupExists")){
			//clearItemPerilFields();
			showMessageBox("Copying of grouped item perils is not allowed.", imgMessage.INFO);
			return false;
		}
		
		for (var i=0; i<objDeductibles.length; i++){
			if ((objDeductibles[i].deductibleType == "T") && (objDeductibles[i].recordStatus != -1) && (nvl(objDeductibles[i].itemNo, 0) == 0)){ //marco - added itemNo condition to limit searching for policy level deductibles
				fireDeductibleAlert = true;
				break;
				//return false; -- marco - 04.10.2013 - replaced with break, return statement prevents execution of codes below 
			}
		}
		
		if (!fireDeductibleAlert){
			showCopyPerilOverlay();
		} else {
			$("copyPerilTag").value = "Y";
			//showConfirmBox("Delete Deductibles", "The PAR has an existing policy level deductible based on % of TSI.  Adding a peril will delete the existing deductible. Continue?", "Ok", "Cancel", deleteDeductiblesFromPeril, clearItemPerilFields);
			//marco - 04.10.2013
			showConfirmBox("Delete Deductibles", "The PAR has an existing policy level deductible based on % of TSI.  Adding a peril will delete the existing deductible. Continue?", "Ok", "Cancel", deleteDeductiblesFromPeril, "");
		}
	});

	$("btnDeleteDiscounts").observe("click", function() {
		showConfirmBox("Delete Discounts", "Are you sure you want to delete all discounts for this policy?",
				 "Yes", "No", deleteDiscounts, "");
	});
	
	if (objUWParList.issCd == "RI"){
		$("totalTsi").hide();
		$("totalPrem").hide();
		$("tsi").hide();
		$("prem").hide();
		$("remarks").hide();

		$("totalTsiRi").show();
		$("totalPremRi").show();
		$("premRi").show();
		$("tsiRi").show();
		$("remarksRi").show();
		$("trRi").show();
	}
	
	$("editCompRem").observe("click", function(){
		showOverlayEditor("compRem", 50, $("compRem").hasAttribute("readonly"));
	});
	
	$("editCompRemRi").observe("click", function(){
		showOverlayEditor("compRemRi", 50, $("compRemRi").hasAttribute("readonly"));
	});
	
	$("perilRiCommRate").observe("click", function(){ //edgar 01/12/2015
		prevPerilRate = $("perilRiCommRate").value;
	});
	
	$("perilRiCommRate").observe("change", function(){ //edgar 01/12/2015
		if ($("perilRiCommRate").value < 0 || $("perilRiCommRate").value > 100){
			showMessageBox("Invalid. Valid value should be from 0 to 100.", imgMessage.ERROR);
			$("perilRiCommRate").value = nvl(prevPerilRate,0);
			$("perilRiCommAmt").value = formatCurrency(($F("premiumAmt")).replace(/,/g, "")*$F("perilRiCommRate")/100);
			return false;
		}
	});
	
	setItemPerilForm(null);
	
	addStyleToInputs();
	//initializeAll();
	initializeAllMoneyFields();	
</script>
