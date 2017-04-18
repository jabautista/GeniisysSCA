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

<div id="wcominvListTableGridSectionDiv" class="sectionDiv" style="height: 170px; border-bottom: white; width: 100%" align="center">
	<div id="wcominvListTableGridDiv" style="padding: 10px; border: none" align="center">
		<div id="wcominvListTableGrid" style="height: 150px; width: 800px; border: none" align="left"></div>
	</div>
</div>
<div class="sectionDiv" id="IntermediaryInfoDiv" name="IntermediaryInfoDiv" style="border-top: white; margin-top: 5px">
	<!--  
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
	-->
					
	<div style="margin: 10px; display: block">		
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
		<!-- added by Christian 8.25.2012 -->
		<input type="hidden" id="txtLicTag" 		name="txtLicTag" 			value=""/>
		<input type="hidden" id="txtSpecialRate" 	name="txtSpecialRate" 		value=""/>
		
		<!-- Other variables -->
		<input type="hidden" id="txtIntmActiveTag" 	name="txtIntmActiveTag" 	value=""/>
		
		<table align="center" width="780px" >
			<tr>
				<td class="rightAligned" 	width="300px">Intermediary No/Name</td>						
				<td class="leftAligned" 	>
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
				<td class="leftAligned" 	>
					<input type="text" id="txtDspParentIntmName" name="txtDspParentIntmName" readonly="readonly" style="width: 337px;" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned"></td>
				<td >
					<input type="checkbox" id="chkNbtRetOrig" name="chkNbtRetOrig" value="N" 
					<c:if test="${vGipiWpolnrepExist ne 'Y' }">
						style="display:none" value="N"
					</c:if>
					<c:if test="${commDetailsSize gt 0 }">
								value="Y" checked="checked" DISABLED
					</c:if>
					/>
					<c:if test="${vGipiWpolnrepExist eq 'Y' }">
						Retrieve Original Policy Comm Rates?
					</c:if>
				</td>
			</tr>
			<tr>
				<td class="rightAligned"></td>
				<td>
					<input type="checkbox" id="chkBancaCheck" name="chkBancaCheck" value="N" style="float: left;"/>
					<label id="banacassureCheckText" style="margin-left: 5px;">Bancassurance</label>
				</td>
			</tr>
			<tr>
				<td class="rightAligned"></td>
				<td>
					<input class="button" type="button" id="btnBancaBut" name="btnBancaBut" value="Bancassurance Details" style="width: 150px;"/>
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