<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div id="additionalInformationDiv" name="additionalInformationDiv" style="display: none;">
<div name="additionalInformationSectionDiv" id="additionalInformationSectionDiv" style="overflow: visible;">
	<form id="accidentAdditionalInformationForm" name="accidentAdditionalInformationForm">
		<div id="accidentAdditionalInformationDiv" align="center" class="sectionDiv" >
			<span class="notice" id="noticePopup" name="noticePopup" style="display: none;">Saving, please wait...</span>
			<table align="center" style="margin-top: 10px;">
				<tr>
					<td class="rightAligned">No. Of Persons </td>
					<td class="leftAligned"colspan="3" >
						<input id="txtNoOfPersons" name="txtNoOfPersons" style="width: 320px;" type="text"  
						    class="integerNoNegative aiInput rightAligned" errorMsg="Invalid No. of Persons. Value should be from 1 to 999,999,999,999." maxlength="12" tabindex="301"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Occupation </td>
					<td class="leftAligned" colspan="4">	
						<div style="float: left; border: solid 1px gray; width: 326px; height: 21px; margin-right: 2px; margin-bottom: 2px;" class="withIconDIv">
							<input type="hidden" id="txtPositionCd" name="txtPositionCd" />
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 298px; border: none;" name="txtDspOccupation" id="txtDspOccupation"  readonly="readonly" value="" tabindex="302"/>
							<img id="hrefOccupation"  alt="goPolicyNo" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" tabindex="303"/>						
						</div>
					</td>		
				</tr>
				<tr>
					<td class="rightAligned">Destination </td>
					<td class="leftAligned"colspan="4" >
						<input id="txtDestination" name="txtDestination" style="width: 320px;" type="text"  value="" maxlength="50" class="aiInput upper" tabindex="304"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Salary </td>
					<td class="leftAligned">
						<input id="txtMonthlySalary" name="txtMonthlySalary" style="width: 100px;" type="text"  class="money aiInput" value="" maxlength="15" tabindex="305"/>
					</td>
					<td class="rightAligned">Salary Grade </td>
					<td class="leftAligned">
						<input id="txtSalaryGrade" name="txtSalaryGrade" style="width: 100px;" type="text"  value="" maxlength="3" class="aiInput upper" tabindex="311"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Date of Birth </td>
					<td class="leftAligned">
					    <div style="float:left; border: solid 1px gray; width: 106px; height: 21px; margin-right:3px;">
					    	<input style="width: 78px; border: none;" id="txtDateOfBirth" name="txtDateOfBirth" type="text" value="" readonly="readonly" tabindex="306"/>
					    	<img id="hrefPersonalDateOfBirth" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtDateOfBirth'),this, null);" alt="Birthday" class="aiInput" tabindex="307"/>
						</div>
					</td>
					<td class="rightAligned">Age </td>
					<td class="leftAligned">
						<input style="width: 100px;" type="text" id="txtAge" name="txtAge"  value="" maxlength="3" class="integerNoNegativeUnformatted aiInput" tabindex="312"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Civil Status </td>
					<td class="leftAligned"style="width:100px; " >
						<div style="float: left; border: solid 1px gray; width: 106px; height: 21px; margin-right: 2px; margin-bottom: 2px;" class="withIconDIv">
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 78px; border: none;" name="txtCivilStatus" id="txtCivilStatus"  readonly="readonly" value="" tabindex="308"/>
							<img id="hrefCivilStatus"  alt="goPolicyNo" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" tabindex="309"/>						
						</div>
					</td>			
					<td class="rightAligned">Sex </td>
					<td class="leftAligned"style="width:100px; " >				
						<div style="float: left; border: solid 1px gray; width: 106px; height: 21px; margin-right: 2px; margin-bottom: 2px;" class="withIconDIv">
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 78px; border: none;" name="txtSex" id="txtSex"  readonly="readonly" value="" tabindex="313"/>
							<img id="hrefSex"  alt="goPolicyNo" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" tabindex="314"/>						
						</div>
					</td>		
				</tr>
				<tr>
					<td class="rightAligned">Height </td>
					<td class="leftAligned">
						<input style="width: 100px;" type="text"  id="txtHeight" name="txtHeight" maxlength="10" class="aiInput" tabindex="310"/>
					</td>
					<td class="rightAligned">Weight </td>
					<td class="leftAligned">
						<input style="width: 100px;" type="text"  id="txtWeight" name="txtWeight" maxlength="10" class="aiInput" tabindex="315"/>
					</td>
				</tr>
			</table>
			<div class="buttonsDiv" style="margin-bottom: 10px;">
				<input type="button" id="aiUpdateBtn" name="aiUpdateBtn" value="Apply Changes" class="disabledButton" tabindex="316"/>
			</div>
		</div>
	</form>
</div>
</div>
<script>
initializeAll();
initializeAiType("aiUpdateBtn");
initializeChangeAttribute();
makeInputFieldUpperCase();

var preBday = "";
$("hrefPersonalDateOfBirth").observe("click", function () {
	preBday = $("txtDateOfBirth").value;
});

function checkBday(){
	var today = new Date();
	var ok = true;
	var bday = makeDate($F("txtDateOfBirth"));
	if (bday>today){
		showWaitingMessageBox("Date of birth should not be greater than current date", "E", function(){
			$("txtDateOfBirth").value = nvl(preBday,"");
			$("txtDateOfBirth").focus();
		});
		ok = false;
	}	
	return ok;
}

observeBackSpaceOnDate("txtDateOfBirth");
$("txtDateOfBirth").observe("blur", function () {
	if (checkBday()) $("txtAge").value = computeAge($("txtDateOfBirth").value);
});

$("txtMonthlySalary").observe("blur", function(){
	var sal = parseFloat($F("txtMonthlySalary").replace(/,/g, ""));
	if((sal<0) || (sal > 9999999999.99)){
		showWaitingMessageBox("Invalid Salary. Value should be from 0 to 9,999,999,999.99.", imgMessage.ERROR, function(){
			$("txtMonthlySalary").value = "";
			$("txtMonthlySalary").focus();
		});
	}else{
		hideNotice();
	}
});

$("hrefOccupation").observe("click", getPositionLOV);
$("hrefCivilStatus").observe("click", showCivilStatusLOV);
$("hrefSex").observe("click", showSexLOV);

$("hrefOccupation").observe("keypress", function (event) {
	if (event.keyCode == 13){
		getPositionLOV();
	}
});

$("hrefCivilStatus").observe("keypress", function (event) {
	if (event.keyCode == 13){
		showCivilStatusLOV();
	}
});

$("hrefSex").observe("keypress", function (event) {
	if (event.keyCode == 13){
		showSexLOV();
	}
});

$("hrefPersonalDateOfBirth").observe("keypress", function (event) {
	if (event.keyCode == 13){
		scwShow($('txtDateOfBirth'),this, null);
	}
});

$("aiUpdateBtn").observe("click", function(){
	objQuote.addtlInfo = 'Y'; //robert 9.28.2012
	fireEvent($("btnAddItem"), "click");
	clearChangeAttribute("additionalInformationSectionDiv");
	disableButton("aiUpdateBtn");
});

</script>