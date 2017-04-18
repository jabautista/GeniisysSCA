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
		<label>Commission Details</label>
		<span class="refreshers" style="margin-top: 0;">
			<label name="gro" style="margin-left: 5px;">Hide</label>
		</span>
	</div>
</div>
<input id="selectedNbtCommissionRtComputed" type="hidden" value=""/>
<div id="commInvoicePerilsDiv" changeTagAttr="true">
	<div class="sectionDiv" id="commDetailsDiv" name="commDetailsDiv">
		<div id="perilInfoDiv" style="margin: 10px;">
			<input type="hidden" id="txtPerilNbtCommissionRtComputed" name="txtPerilNbtCommissionRtComputed" value=""/>
			<table align="center" width="500px">					
				<tr>
					<td class="rightAligned" 	width="130px">Share Percentage</td>
					<td class="leftAligned" 	width="120px"><input type="text" id="txtSharePercentage" name="txtSharePercentage" style="width: 100px; text-align: right;" class="required" /></td>
					<td class="rightAligned" 	width="120px">Share of Premium</td>
					<td class="leftAligned" 	width="120px"><input type="text" id="txtPerilPremiumAmt" name="txtPerilPremiumAmt" readonly="readonly" style="width: 100px" class="money" value="" /></td>
				</tr>
				<tr>
					<td class="rightAligned" 	width="130px">Rate</td>
					<td class="leftAligned" 	width="120px"><input type="text" id="txtPerilCommissionRate" name="txtPerilCommissionRate" readonly="readonly" style="width: 100px;  text-align: right;" /></td> <!-- class="applyDecimalRegExp" regExpPatt="pDeci0307" min="0.00" max="100.0000000" -->
					<td class="rightAligned" 	width="120px">Withholding Tax</td>
					<td class="leftAligned" 	width="120px"><input type="text" id="txtPerilWholdingTax" name="txtPerilWholdingTax" readonly="readonly" style="width: 100px" class="money"/></td>					
				</tr>
				<tr>
					<td class="rightAligned" 	width="130px">Commission Amount </td>
					<td class="leftAligned" 	width="120px"><input type="text" id="txtPerilCommissionAmt" name="txtPerilCommissionAmt" readonly="readonly" style="width: 100px; text-align: right;"/></td> <!-- class="applyDecimalRegExp" regExpPatt="pDeci1002" min="0.00" max="9999999999.99" -->						
					<td class="rightAligned" 	width="120px">Net Commission</td>
					<td class="leftAligned" 	width="120px"><input type="text" id="txtPerilNbtCommissionAmt" name="txtPerilNbtCommissionAmt" readonly="readonly" style="width: 100px" class="money"/></td>
				</tr>
				<tr align="center" style="margin-top: 5px;">
					<td colspan=4>
						<input class="button" 		  type="button" id="btnSaveIntm" 	name="btnSaveIntm" 	 value="Add" 	style="width: 100px;" />
						<input class="disabledButton" type="button" id="btnDeleteIntm"  name="btnDeleteIntm" value="Delete" style="width: 100px;" disabled="disabled"/>
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>