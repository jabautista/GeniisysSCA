<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="commInvoicePerilsDiv" changeTagAttr="true">
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Commission Details</label>
			<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label>
			</span>
		</div>
	</div>
	
	<div class="sectionDiv" id="commDetailsDiv" name="commDetailsDiv">
		<div id="wcominvperTableMainDiv" name="wcominvperTableMainDiv" style="width: 921px;">
					<div class="tableHeader" id="commDetailsTableHeader" name="commDetailsTableHeader">
						<label style="width: 167px; font-size: 11px; text-align: left; margin-left: 5px;">Peril Name</label>
						<label style="width: 145px; font-size: 11px; text-align: right;">Premium Amount</label>
						<label style="width: 145px; font-size: 11px; text-align: right;">Commission Rate</label>
						<label style="width: 145px; font-size: 11px; text-align: right;">Commission Amount</label>
						<label style="width: 145px; font-size: 11px; text-align: right;">Withholding Tax</label>
						<label style="width: 145px; font-size: 11px; text-align: right;">Net Commission</label>
					</div>
					<div class="tableContainer" id="wcominvperTableContainer" name="wcominvperTableContainer"></div>
		</div>

		<div id="perilInfoDiv" style="margin: 10px; display: none">
			<input type="hidden" id="txtPerilNbtCommissionRtComputed" name="txtPerilNbtCommissionRtComputed" value=""/>
			<table align="center" width="500px">					
				<tr>
					<td class="rightAligned" 	width="130px">Peril Code/Name</td>
					<td class="leftAligned" 	colspan="3">
						<input type="text" id="txtPerilCd" 		name="txtPerilCd" readonly="readonly" style="width: 25px;" /> 
						<input type="text" id="txtPerilName" 	name="txtPerilName" readonly="readonly" style="width: 298px;"/>							
					</td>
				</tr>
				<tr>
					<td class="rightAligned" 	width="130px">Premium Amount</td>
					<td class="leftAligned" 	width="120px"><input type="text" id="txtPerilPremiumAmt" name="txtPerilPremiumAmt" readonly="readonly" style="width: 100px" class="money required" /></td>
					<td class="rightAligned" 	width="100px">Rate</td>
					<td class="leftAligned" 	width="120px"><input type="text" id="txtPerilCommissionRt" name="txtPerilPremiumAmt" readonly="readonly" style="width: 100px" class="nthDecimal2 required" nthDecimal="7" /></td>
				</tr>
				<tr>
					<td class="rightAligned" 	width="130px">Commission Amount</td>
					<td class="leftAligned" 	width="120px"><input type="text" id="txtPerilCommissionAmt" name="txtPerilCommissionAmt" readonly="readonly" style="width: 100px" class="money required" /></td>
					<td class="rightAligned" 	width="100px">Withholding Tax</td>
					<td class="leftAligned" 	width="120px"><input type="text" id="txtPerilWholdingTax" name="txtPerilWholdingTax" readonly="readonly" style="width: 100px" class="money" /></td>
				</tr>
				<tr>
					<td class="rightAligned" 	width="130px">Net Commission</td>
					<td class="leftAligned" 	width="120px"><input type="text" id="txtPerilNbtCommissionAmt" name="txtPerilNbtCommissionAmt" readonly="readonly" style="width: 100px" class="money required"/></td>						
					<td class="rightAligned"	colspan="2">&nbsp</td>
				</tr>
				<tr align="center">
					<td colspan=4>
						<input class="disabledButton" type="button" id="btnSavePeril" name="btnSavePeril" value="Update Peril" style="width: 100px;" disabled="disabled"/>
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>