<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="lpInvoiceMainDiv" name="lpInvoiceMainDiv">
	<form id="lpInvoiceForm" name="lpInvoiceForm">
		<jsp:include page="/pages/underwriting/coInsurance/leadPolicy/leadPolicyParInfo.jsp"></jsp:include> 
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label id="lpItemGrpListLabel">Item Group</label>
				<span class="refreshers" style="margin-top: 0;">
					<label id="lpGro" name="gro" style="margin-left: 5px;">Hide</label>
				</span>
			</div>
		</div>
		<div class="sectionDiv" id="lpItemGrpInvoiceInfoDiv" name="lpItemGrpInvoiceInfoDiv">
			<jsp:include page="/pages/underwriting/coInsurance/leadPolicy/leadPolicyItemGrpListing.jsp"></jsp:include>
			<input type="hidden" id="hidSelectedItemGrp" name="hidSelectedItemGrp" value=""/>
			<input type="hidden" id="hidRate" name="hidRate" value="${dspRate}"/>
			<div id="lpInvoiceInfoMainSectionDiv" class="sectionDiv" style="border-left: none; border-right: none;">
				<div id="invoiceInfoSectionDiv" name="invoiceInfoSectionDiv" class="sectionDiv" style="width: 49.7%; float: left; border-bottom: none; border-left: none; border-top: none"">
					<table align="center" border="0">
						<tr>
							<td colspan="2" align="center" style="font-weight: bolder; padding: 10px 0;">Your Share ${dspRate}</td>
						</tr>
						<tr>
							<td class="rightAligned">Ref. Invoice No:</td>
							<td class="leftAligned"><input type="text" id="lpRefInvNo" name="lpRefInvNo" style="width: 200px;" readonly="readonly"></input></td>
						</tr>
						<tr>
							<td class="rightAligned">Premium:</td>
							<td class="leftAligned"><input type="text" id="lpPremium" name="lpPremium" class="money" style="width: 200px;" readonly="readonly"></input></td>
						</tr>
						<tr>
							<td class="rightAligned">Total Tax:</td>
							<td class="leftAligned"><input type="text" id="lpTotalTax" name="lpTotalTax" class="money" style="width: 200px;" readonly="readonly"></input></td>
						</tr>
						<tr>
							<td class="rightAligned">Other Charges:</td>
							<td class="leftAligned"><input type="text" id="lpOtherCharges" name="lpOtherCharges" class="money" style="width: 200px;" readonly="readonly"></input></td>
						</tr>
						<tr>
							<td class="rightAligned">Amount Due:</td>
							<td class="leftAligned"><input type="text" id="lpAmountDue" name="lpAmountDue" class="money" style="width: 200px;" readonly="readonly"></input></td>
						</tr>
						<tr>
							<td class="rightAligned">Currency</td>
							<td class="leftAligned"><input type="text" id="lpCurrency" name="lpCurrency" style="width: 200px;" readonly="readonly"></input></td>
						</tr>
					</table>
				</div>
				<div id="invoiceInfoSectionDiv2" name="invoiceInfoSectionDiv2" class="sectionDiv" style="width: 49.7%; float: left; border: none;">
					<table align="center" border="0">
						<tr>
							<td colspan="2" align="center" style="font-weight: bolder; padding: 10px 0;"> Full Share (100%)</td>
						</tr>
						<tr>
							<td class="rightAligned">Ref. Invoice No:</td>
							<td class="leftAligned"><input type="text" id="lpFullRefInvNo" name="lpFullRefInvNo" style="width: 200px;" readonly="readonly"></input></td>
						</tr>
						<tr>
							<td class="rightAligned">Premium:</td>
							<td class="leftAligned"><input type="text" id="lpFullPremium" name="lpFullPremium" class="money" style="width: 200px;" readonly="readonly"></input></td>
						</tr>
						<tr>
							<td class="rightAligned">Total Tax:</td>
							<td class="leftAligned"><input type="text" id="lpFullTotalTax" name="lpFullTotalTax" class="money" style="width: 200px;" readonly="readonly"></input></td>
						</tr>
						<tr>
							<td class="rightAligned">Other Charges:</td>
							<td class="leftAligned"><input type="text" id="lpFullOtherCharges" name="lpFullOtherCharges" class="money" style="width: 200px;" readonly="readonly"></input></td>
						</tr>
						<tr>
							<td class="rightAligned">Amount Due:</td>
							<td class="leftAligned"><input type="text" id="lpFullAmountDue" name="lpFullAmountDue" class="money" style="width: 200px;" readonly="readonly"></input></td>
						</tr>
						<tr>
							<td class="rightAligned">Currency</td>
							<td class="leftAligned"><input type="text" id="lpFullCurrency" name="lpFullCurrency" style="width: 200px;" readonly="readonly"></input></td>
						</tr>
					</table>
				</div>
			</div>
			<div id="lpInvButtonsDiv" name="lpInvButtonsDiv" class="sectionDiv" style="border: none; margin: 10px 0;">
				<table align="center" border="0">
					<tr>
						<td><input type="button" class="button" id="lpTaxesBtn" value="Taxes"></input></td>
						<td><input type="button" class="button" id="lpPerilDistBtn" value="Peril Distribution"></input></td>
						<td><input type="button" class="button" id="lpInvCommBtn" value="Invoice Commission"></input></td>
						<td><input type="button" class="button" id="lpReturnBtn" value="Return"></input></td>
					</tr>
				</table>
			</div>
			<div id="lpTaxesDiv"  style="display: none; margin-bottom: 10px;"></div>
			<div id="lpPerilDistDiv" style="display: none; margin-bottom: 10px;"></div>
			<div id="lpInvCommDiv" style="display: none; margin-bottom: 10px;"></div>
		</div>
	</form>
</div>
<script type="text/javascript">
	initializeAll();
	initializeAccordion();

	$("lpTaxesBtn").observe("click", function(){
		loadLeadPolicyTaxesListing();
	});

	$("lpPerilDistBtn").observe("click", function(){
		loadLeadPolicyPerilDistListing();
	});

	$("lpInvCommBtn").observe("click", function(){
		loadLeadPolicyInvCommIntrmdryListing();
	});
	
	$("lpReturnBtn").observe("click", function(){Modalbox.hide();});

</script>