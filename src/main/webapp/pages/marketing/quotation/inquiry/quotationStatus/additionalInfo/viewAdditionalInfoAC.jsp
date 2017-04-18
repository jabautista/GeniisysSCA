<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div id="additionalInformationDiv" name="additionalInformationDiv" style="display: none;">
<div name="additionalInformationSectionDiv" id="additionalInformationSectionDiv" style="overflow: visible;">
	<form id="accidentAdditionalInformationForm" name="accidentAdditionalInformationForm">
		<div id="accidentAdditionalInformationDiv" align="center" class="sectionDiv" style="padding-bottom: 10px;">
			<span class="notice" id="noticePopup" name="noticePopup" style="display: none;">Saving, please wait...</span>
			<table align="center" style="margin-top: 10px;">
				<tr>
					<td class="rightAligned">No. Of Persons </td>
					<td class="leftAligned"colspan="3" >
						<input id="txtNoOfPersons" name="txtNoOfPersons" style="width: 320px;" type="text"  
						    class="integerNoNegative aiInput rightAligned" maxlength="12" tabindex="301" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Occupation </td>
					<td class="leftAligned" colspan="4">	
						<input type="hidden" id="txtPositionCd" name="txtPositionCd" />
						<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 320px;" name="txtDspOccupation" id="txtDspOccupation"  readonly="readonly" value="" tabindex="302"/>
					</td>		
				</tr>
				<tr>
					<td class="rightAligned">Destination </td>
					<td class="leftAligned"colspan="4" >
						<input id="txtDestination" name="txtDestination" style="width: 320px;" type="text"  value="" maxlength="50" class="aiInput upper" tabindex="304" readonly="readonly"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Salary </td>
					<td class="leftAligned">
						<input id="txtMonthlySalary" name="txtMonthlySalary" style="width: 100px;" type="text"  class="money aiInput" value="" maxlength="15" tabindex="305" readonly="readonly"/>
					</td>
					<td class="rightAligned">Salary Grade </td>
					<td class="leftAligned">
						<input id="txtSalaryGrade" name="txtSalaryGrade" style="width: 100px;" type="text"  value="" maxlength="3" class="aiInput upper" tabindex="311" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Date of Birth </td>
					<td class="leftAligned">
					    <div style="float:left; border: solid 1px gray; width: 106px; height: 21px; margin-right:3px;">
					    	<input style="width: 78px; border: none;" id="txtDateOfBirth" name="txtDateOfBirth" type="text" value="" readonly="readonly" tabindex="306"/>
						</div>
					</td>
					<td class="rightAligned">Age </td>
					<td class="leftAligned">
						<input style="width: 100px;" type="text" id="txtAge" name="txtAge"  value="" maxlength="3" class="integerNoNegativeUnformatted aiInput" tabindex="312" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Civil Status </td>
					<td class="leftAligned"style="width:100px; " >
						<div style="float: left; border: solid 1px gray; width: 106px; height: 21px; margin-right: 2px; margin-bottom: 2px;" class="withIconDIv">
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 78px; border: none;" name="txtCivilStatus" id="txtCivilStatus"  readonly="readonly" value="" tabindex="308"/>
						</div>
					</td>			
					<td class="rightAligned">Sex </td>
					<td class="leftAligned"style="width:100px; " >				
						<div style="float: left; border: solid 1px gray; width: 106px; height: 21px; margin-right: 2px; margin-bottom: 2px;" class="withIconDIv">
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 78px; border: none;" name="txtSex" id="txtSex"  readonly="readonly" value="" tabindex="313"/>
						</div>
					</td>		
				</tr>
				<tr>
					<td class="rightAligned">Height </td>
					<td class="leftAligned">
						<input style="width: 100px;" type="text"  id="txtHeight" name="txtHeight" maxlength="10" class="aiInput" tabindex="310" readonly="readonly"/>
					</td>
					<td class="rightAligned">Weight </td>
					<td class="leftAligned">
						<input style="width: 100px;" type="text"  id="txtWeight" name="txtWeight" maxlength="10" class="aiInput" tabindex="315" readonly="readonly"/>
					</td>
				</tr>
			</table>
		</div>
	</form>
</div>
</div>