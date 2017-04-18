<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" name="innerDiv">
		<label>Invoice Commission Information</label>
		<span class="refreshers" style="margin-top: 0;">
			<label name="gro" style="margin-left: 5px;">Hide</label>
		</span>
	</div>
</div>

<div class="sectionDiv" id="IntermediaryInfoDiv" name="IntermediaryInfoDiv" >
	<div id="wcominvTableMainDiv" name="wcominvTableMainDiv" style="width: 921px;">
				<div class="tableHeader" id="intmInfoTableHeader" name="intmInfoTableHeader">
					<label style="width: 167px; text-align: left; font-size: 11px; margin-left: 5px;">Intermediary Name</label>
					<label style="width: 130px; text-align: right; font-size: 11px;">Share Percentage</label>
					<label style="width: 145px; text-align: right; font-size: 11px;">Share Premium</label>
					<label style="width: 145px; text-align: right; font-size: 11px;">Total Commission</label>
					<label style="width: 145px; text-align: right; font-size: 11px;">Net Commission</label>
					<label style="width: 164px; text-align: right; font-size: 11px;">Total Withholding Tax</label>
				</div>
				<div class="tableContainer" id="wcominvTableContainer" name="wcominvTableContainer"></div>
	</div>
					
	<div style="margin: 10px;">		
		<!-- WCOMINV block variables -->
		<input type="hidden" id="txtIntmNo" 			name="txtIntmNo" 				value=""/>
		<input type="hidden" id="txtIntmName" 			name="txtIntmName" 				value=""/>
		<input type="hidden" id="txtParentIntmNo" 		name="txtParentIntmNo" 			value=""/>
		<input type="hidden" id="txtParentIntmName" 	name="txtParentIntmName" 		value=""/>
		<input type="hidden" id="txtNbtIntmType" 		name="txtNbtIntmType" 			value=""/>
		<input type="hidden" id="txtIntmNoNbt" 			name="txtIntmNoNbt" 			value=""/>
		<input type="hidden" id="txtSharePercentageNbt" name="txtSharePercentageNbt" 	value=""/>
		
		<!-- added by irwin 7.17.2012 -->
		<input type="hidden" id="txtParentIntmLicTag" 			name="txtParentIntmLicTag" 			value=""/>
		<input type="hidden" id="txtParentIntmSpecialRate" name="txtParentIntmSpecialRate" 	value=""/>
		<!-- Other variables -->
		<input type="hidden" id="txtIntmActiveTag" 	name="txtIntmActiveTag" 	value=""/>
		<!-- added by Christian 8.25.2012 -->
		<input type="hidden" id="txtLicTag" 		name="txtLicTag" 			value=""/>
		<input type="hidden" id="txtSpecialRate" 	name="txtSpecialRate" 		value=""/>
		
		<table align="center" width="780px" >
			<tr>
				<td class="rightAligned" 	width="300px">Intermediary No/Name</td>						
				<td class="leftAligned" 	colspan="3">
					<div style="border: 1px solid gray; width: 343px; height: 21px; float: left; background-color: cornsilk">
						<input type="text" style="width: 315px; float: left; border: none;" id="txtDspIntmName" name="txtDspIntmName" readonly="readonly" style="width: 290px;" class="required" value=""/>
					   	<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmIntm" name="oscmIntm" alt="Go" style="float: right;"/>
					</div>
				</td>
				<td class="leftAligned" 	width="20%">
					<input type="checkbox" id="chkLovTag" name="chkLovTag" value="UNFILTERED" /> Default Intm?
				</td>
			</tr>
			<tr>
				<td class="rightAligned" 	width="300px">Parent Intermediary No/Name</td>						
				<td class="leftAligned" 	colspan="3">
					<input type="text" id="txtDspParentIntmName" name="txtDspParentIntmName" readonly="readonly" style="width: 337px;" />
				</td>
				<td class="leftAligned" 	width="20%" style="
					<c:if test="${vOra2010Sw ne 'Y'}">
						display: none
					</c:if>
					">
					<input type="checkbox" id="chkBancaCheck" name="chkBancaCheck" value="
						<c:choose>
							<c:when test="${vOra2010Sw eq 'Y'}">
								Y
							</c:when>
							<c:otherwise>
								N
							</c:otherwise>
						</c:choose>
					" style="<c:if test="${isBancaCheckEnabled ne 'Y' }">display: none</c:if>" <c:choose>
						<c:when test="${vOra2010Sw eq 'Y' && vValidateBanca eq 'Y'}">checked</c:when>
						<c:otherwise>disabled="disabled"</c:otherwise>
					  </c:choose>/> Bancassurance
				</td>
			</tr>
			<tr>
				<td class="rightAligned" 	width="300px">Share Percentage</td>
				<td class="leftAligned" 	width="130px"><input type="text" id="txtSharePercentage" name="txtSharePercentage" style="width: 93px; text-align: right;" maxlength="11" class="required" /></td>
				<td class="rightAligned" 	width="110px">Share Premium</td>
				<td class="leftAligned" 	width="130px"><input type="text" id="txtPremiumAmt" name="txtPremiumAmt" readonly="readonly" style="width: 93px" class="money"/></td>
				<td class="leftAligned" 	width="20%">
					<input class="button" type="button" style="<c:if test="${isBancaBtnEnabled ne 'Y' }">display: none</c:if>" id="btnShowBancaDetails" name="btnShowBancaDetails" value="Bancassurance Details" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned" 	width="300px">Total Commission</td>
				<td class="leftAligned" 	width="130px"><input type="text" id="txtCommissionAmt" name="txtCommissionAmt" readonly="readonly" style="width: 93px" class="money"/></td>
				<td class="rightAligned" 	width="110px">Net Commission</td>
				<td class="leftAligned" 	width="130px"><input type="text" id="txtNetCommission" name="txtNetCommission" readonly="readonly" style="width: 93px" class="money"/></td>				
			</tr>
			<tr>
				<td class="rightAligned" 	width="300px">Total Withholding Tax</td>
				<td class="leftAligned" 	width="130px"><input type="text" id="txtWholdingTax" name="txtWholdingTax" readonly="readonly" style="width: 93px" class="money"/></td>						
				<td class="rightAligned"	width="110px">
					<input type="checkbox" id="chkNbtRetOrig" name="chkNbtRetOrig"
					<c:if test="${vGipiWpolnrepExist ne 'Y' }">
						style="display:none" value="N"
					</c:if>
					<c:if test="${commDetailsSize gt 0 }">
								value="Y" checked="checked" DISABLED
					</c:if>
					/>
				</td>
				<td class="leftAligned" 	colspan="2" >
					<c:if test="${vGipiWpolnrepExist eq 'Y' }">
						Retrieve Original Policy Comm Rates?
					</c:if>
				</td>
			</tr>
			<tr>
				<td width="750px" style="text-align: center;" colspan="5">
					<input class="button" type="button" id="btnSaveIntm" name="btnSaveIntm" value="Add" style="margin-top: 10px;"/>
					<input class="disabledButton" type="button" id="btnDeleteIntm" name="btnDeleteIntm" value="Delete" style="margin-top: 10px;" disabled="disabled"/>
				</td>
			</tr>
		</table>
	</div>
</div>

<script type="text/javascript">
	$$("label[class='money']").each(function(label) {
		label.innerHTML = formatCurrency(label.innerHTML);
	});
</script>