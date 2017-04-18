<!-- unused page
for deletion by steven 
12.12.2013 -->
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="lineMaintenanceInfo" style="margin-top: 50px;">
	<table align="center">
		<tr>
			<td class="rightAligned">Line Code</td>
			<td class="leftAligned"><input type="text" id="txtLineCode" value="" style="width: 250px;" class="required upper" maxlength="2"/></td>
			<td class="rightAligned">Menu Line Code</td>
			<td class="leftAligned" style="width: 250px;">
				<select id="dDnMenuLineCd" name="dDnMenuLineCd" style="text-align: left; width: 99%;">
					<option></option>
					<option>MC</option>
					<option>FI</option>
					<option>EN</option>
					<option>MN</option>
					<option>MH</option>
					<option>CA</option>
					<option>AC</option>
					<option>AV</option>
 				</select>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Line Name</td>
			<td class="leftAligned"><input type="text" id="txtLineName" value="" style="width: 250px;" class="required upper" maxlength="20"/></td>
			<td class="rightAligned">Recaps</td>
			<td class="leftAligned" style="width: 250px;">
				<select id="dDnRecaps" name="dDnRecaps" style="text-align: left; width: 99%;">
					<option></option>
					<c:forEach var="recaps" items="${recapsCdList}">
						<option menuLineCd="${recaps.menuLineCd}">${recaps.menuLineCd}</option>				
					</c:forEach>
 				</select>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Account Line Code</td>
			<td class="leftAligned"><input type="text" id="txtAcctLineCd" value=""  class="required integerNoNegativeUnformattedNoComma rightAligned" maxlength="2" style="width: 250px;" /></td>
			<td class="rightAligned">Minimum Prem Amt</td>
			<td class="leftAligned"><input type="text" id="txtMinPremAmt" value="" class="money rightAligned" maxlength="15" style="width: 250px;" /></td>
		</tr>
		<tr>
			<td class="rightAligned">Remarks</td>
			<td colspan="3" class="leftAligned">
				<div style="border: 1px solid gray; height: 21px; width: 99.75%">
					<textarea id="txtRemarks" name="txtRemarks" style="border: none; height: 13px; resize: none; width: 90%" maxlength="4000"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="EditRemark" id="editRemarksText" tabindex=206/>
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">
			</td>
			<td colspan="3" class="leftAligned">
				<table style="width: 100%">
					<tr>
						<td width="30%">
							<input id="chkPackage" type="checkbox" style="float: left; margin: 0pt; width: 13px; height: 13px; overflow: hidden;"   name="chkPackage">
							<label for="chkPackage" style="float: left; margin-left: 3px;" title="Package">Package</label>
						</td>
						<td width="30%">
							<input id="chkProfCommTag" type="checkbox" style="float: left; margin: 0pt; width: 13px; height: 13px; overflow: hidden;"  name="chkProfCommTag">
							<label for="chkProfCommTag" style="float: left; margin-left: 3px;" title="Profit Commission Tag">Profit Commission Tag</label>
						</td>
						<td>
							<input id="chkNonRenewal" type="checkbox" style="float: left; margin: 0pt; width: 13px; height: 13px; overflow: hidden;"  name="chkNonRenewal">
							<label for="chkNonRenewal" style="float: left; margin-left: 3px;" title="Non-Renewal">Non-Renewal</label>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
<div align="center" style="margin-top: 30px">
	<input type="button" class="button" id="btnAddLine" name="btnAddLine" value="Add" /> 
	<input type="button" class="button" id="btnDeleteLine" name="btnDeleteLine" value="Delete" />
</div>