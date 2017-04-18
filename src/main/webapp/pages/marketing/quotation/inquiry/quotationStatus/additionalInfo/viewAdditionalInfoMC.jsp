<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
	
<div id="additionalItemInformationDiv" name="additionalItemInformationDiv" style="display: none;">	
	<div class="sectionDiv" id="additionalItemInformation" style="margin: 0px; padding-bottom: 10px;" changeTagAttr="true" masterDetail="true" >		
		<table id="motorcarTable" width="920px" cellspacing="1" border="0">
			<tr><td><br /></td></tr>
			<tr>
				<td class="rightAligned" style="width: 120px;">Assignee</td>
				<td class="leftAligned" style="width: 185px;">
					<input type="text" style="width: 175px; padding: 2px;"	name="txtAssignee" id="txtAssignee" maxlength="30" class="aiInput upper" tabindex="301" readonly="readonly"/>
				</td>
				<td class="rightAligned">Acquired From</td>
				<td class="leftAligned" style="width: 185px;">
					<input type="text" style="width: 175px; padding: 2px;" name="txtAcquiredFrom" id="txtAcquiredFrom" maxlength="30" class="aiInput upper" tabindex="314" readonly="readonly"/>
				</td>
				<td class="rightAligned" style="width: 100px;">Motor/Eng No.</td>
				<td class="leftAligned" style="width: 190px;">
					<input type="text" style="width: 175px; padding: 2px;" name="txtMotorNo" id="txtMotorNo" maxlength="30" class="aiInput  upper" tabindex="323" readonly="readonly"/><!-- changed maxlength to 30 reymon 03312014 -->
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Origin </td>
				<td class="leftAligned">
					<input type="text" style="width: 175px; padding: 2px;" name="txtOrigin" id="txtOrigin" maxlength="50" class="aiInput upper" tabindex="302" readonly="readonly"/></td>
				<td class="rightAligned">Destination </td>
				<td class="leftAligned">
					<input type="text" style="width: 175px; padding: 2px;" name="txtDestination" id="txtDestination" maxlength="50" class="aiInput  upper" tabindex="315" readonly="readonly"/>
				</td>
				<td class="rightAligned">Type of Body </td>
				<td class="leftAligned">
					<input type="hidden" id="txtTypeOfBodyCd" name="txtTypeOfBodyCd"/>
					<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 173px;" name="txtDspTypeOfBodyCd" id="txtDspTypeOfBodyCd" readonly="readonly" value="" class="aiInput" tabindex="324"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Plate No. </td>
				<td class="leftAligned">
					<input type="text" style="width: 175px; padding: 2px;" name="txtPlateNo" id="txtPlateNo" maxlength="10" class="aiInput  upper" tabindex="303" readonly="readonly"/></td>
				<td class="rightAligned">Model Year </td>
				<td class="leftAligned">
					<input type="text" style="width: 175px; padding: 2px;" name="txtModelYear" id="txtModelYear" maxlength="4" class="aiInput  upper" tabindex="316" readonly="readonly"/></td>
				<td class="rightAligned">Car Company </td>
				<td class="leftAligned">
					<input type="hidden" id="txtCarCompanyCd" name="txtCarCompanyCd"/>
					<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 173px;" name="txtDspCarCompanyCd" id="txtDspCarCompanyCd" readonly="readonly" value="" class="aiInput" tabindex="326"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">MV File No. </td>
				<td class="leftAligned">
					<input type="text" style="width: 175px; padding: 2px;" name="txtMvFileNo" id="txtMvFileNo" maxlength="15" class="aiInput  upper" tabindex="304" readonly="readonly"/>
				</td>
				<td class="rightAligned">No. of Pass </td>
				<td class="leftAligned">
					<input type="text" style="width: 175px; padding: 2px;" name="txtNoOfPass" id="txtNoOfPass" maxlength="3" class="integerNoNegativeUnformatted aiInput" errorMessage="Invalid No. of Pass. Value should be from 1 to 999." tabindex="317" readonly="readonly"/>
				</td>
				<td class="rightAligned">Make </td>
				<td class="leftAligned">
					<input type="hidden" id="txtMakeCd" name="txtMakeCd" />
					<input type="text"  style="float: left; margin-top: 0px; margin-right: 3px; width: 173px;" name="txtMake" id="txtMake" readonly="readonly" value="" class="aiInput" tabindex="328"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Basic Color </td>
				<td class="leftAligned">
					<input type="hidden" id="basicColorCd" name="basicColorCd" />
					<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 173px;" name="basicColor" id="basicColor" readonly="readonly" value="" class="aiInput" tabindex="305"/>
				</td>
				<td class="rightAligned">Color </td>
				<td class="leftAligned">					
					<input type="hidden" id="colorCd" name="colorCd" />
					<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 173px;" name="color" id="color" readonly="readonly" value="" class="aiInput" tabindex="318"/>
				<td class="rightAligned">Engine Series </td>
				<td class="leftAligned">
					<input type="hidden" id="txtSeriesCd" name="txtSeriesCd" />
					<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 173px;" name="txtDspEngineSeries" id="txtDspEngineSeries" readonly="readonly" value="" class="aiInput" tabindex="330"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Motor Type </td>
				<td class="leftAligned">
					<input type="hidden" id="txtMotType" name="txtMotType" />
					<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 173px;" name="txtDspMotType" id="txtDspMotType" readonly="readonly" value="" class="aiInput" tabindex="307"/>
				</td>
				<td class="rightAligned">Unladen Wt. </td>
				<td class="leftAligned">
					<input type="text" style="width: 175px; padding: 2px;" name="txtUnladenWt" id="txtUnladenWt" maxlength="20" class="aiInput" tabindex="320" readonly="readonly"/>
				</td>
				<td class="rightAligned">Tow Limit </td>
				<td class="leftAligned">
					<input type="hidden"name="towing" id="towing">
					<input type="text" style="width: 175px; padding: 2px;" name="txtTowing" id="txtTowing" class="money2 aiInput" maxlength="17" min="0.00" max="99999999999999.99" errorMsg="Invalid Tow Limit. Value should be from 0.00 to 99,999,999,999,999.99" tabindex="332" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Chassis/Serial No </td>
				<td class="leftAligned">
					<input type="text" style="width: 175px; padding: 2px;" name="txtSerialNo" id="txtSerialNo" maxlength="20" class="aiInput  upper" tabindex="309" readonly="readonly"/>
				</td>
				<td class="rightAligned">Subline Type </td>
				<td class="leftAligned">
					<input type="hidden" id="txtSublineTypeCd" name="txtSublineTypeCd" />
					<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 173px;" name="txtDspSublineTypeCd" id="txtDspSublineTypeCd" readonly="readonly" value="" class="aiInput" tabindex="321"/>
				</td>
				<td class="rightAligned">Deductibles</td>
				<td class="leftAligned">
					<input type="text" style="width: 175px; padding: 2px;" name="txtDspDeductibles" id="txtDspDeductibles" class="money2 aiInput" readonly="readonly" maxlength="16" tabindex="333"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">COC No. </td>
				<td class="leftAligned" colspan="3">
					<input type="text" style="width: 10%; float: left;" name="txtCocType" id="txtCocType" maxlength="7" class="aiInput  upper" tabindex="310" readonly="readonly"/><label>-</label>
					<input type="text" style="width: 12%; float: left;" name="txtCocSerialNo" id="txtCocSerialNo" maxlength="7" class="integerNoNegativeUnformatted aiInput" tabindex="311" readonly="readonly"/><label>-</label>
					<input type="text" style="width: 8%; float: left; margin-right: 5px;" name="txtCocYy" id="txtCocYy" maxlength="2" class="integerNoNegativeUnformatted aiInput" tabindex="312" readonly="readonly"/>
					<input type="hidden" id="txtCtvTag" name="txtCtvTag" />
					<label for="chkCtv"><div title="Motorcar Trailer Vehicle Type Tag" style="margin-top: 5px;"><input type="checkbox" style="width: 10px; padding: 2px; float: left;" id="chkCtv" class="aiInput" tabindex="313" disabled="	disabled">CTV</div></label>
				</td>
				<td class="rightAligned">Repair Limit </td>
				<td class="leftAligned">
					<input type="hidden"name="txtRepairLim" id="txtRepairLim">
					<input type="text" style="width: 175px; padding: 2px;" name="txtDspRepairLim" id="txtDspRepairLim" class="money2 aiInput" readonly="readonly" maxlength="20" tabindex="334"/>
				</td>
			</tr>
		</table>
	</div>
</div>

<script type="text/javascript">
	initializeAll();
	makeInputFieldUpperCase();
</script>