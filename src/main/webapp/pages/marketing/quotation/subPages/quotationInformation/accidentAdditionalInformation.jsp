<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div id="additionalInformationDiv" name="additionalInformationDiv" style="display: none;" class="optionalInformation">
<input type="hidden" id="messageBoxVisible" 		name="messageBoxVisible" 		value="N" />
<div name="additionalInformationSectionDiv" id="additionalInformationSectionDiv" style="overflow: visible; display: none;">
	<input type="hidden" id="aiItemNo" name="aiItemNo" value=""/>
	<form id="accidentAdditionalInformationForm" name="accidentAdditionalInformationForm">
		<div id="spinLoadingDiv"></div>
	
		<div id="accidentAdditionalInformationDiv" align="center" class="sectionDiv" style="display: none;">
			<span class="notice" id="noticePopup" name="noticePopup" style="display: none;">Saving, please wait...</span>
			<table align="center" style="margin-top: 10px; margin-bottom: 10px;">
				<tr>
					<td class="rightAligned">No. Of Persons </td>
					<td class="leftAligned"colspan="3" >
						<input id="txtNoOfPerson" name="txtNoOfPerson" style="width: 320px;" type="text" tabindex="1"   
						    class="integerNoNegative aiInput" value="${gipiQuoteItemAC.noOfPerson}" errorMsg="Invalid No. of Persons. Value should be from 1 to 999,999,999,999." maxlength="15"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Occupation </td>
					<td class="leftAligned"style="width:320px; " colspan="4">				
						<select style="width: 328px;" tabindex="2" id="position" name="position" class="aiInput">
							<option value=""></option>
							<c:forEach var="positionList" items="${positionList}">
								<option value="${positionList.positionCd}"
								<c:if test="${gipiQuoteItemAC.positionCd == positionList.positionCd}">
								selected="selected"
								</c:if>
								>${positionList.position}</option>
							</c:forEach>
						</select>
					</td>		
				</tr>
				<tr>
					<td class="rightAligned">Destination </td>
					<td class="leftAligned"colspan="4" >
						<input id="txtDestination" name="txtDestination" style="width: 320px;" type="text" tabindex="3"  value="" maxlength="50" class="aiInput"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Salary </td>
					<td class="leftAligned">
						<input id="txtSalary" name="txtSalary" style="width: 100px;" type="text" tabindex="4"  class="money aiInput" value="" maxlength="13" />
					</td>
					<td class="rightAligned">Salary Grade </td>
					<td class="leftAligned">
						<input id="txtSalaryGrade" name="txtSalaryGrade" style="width: 100px;" type="text" tabindex="5" value="" maxlength="3" class="aiInput"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Date of Birth </td>
					<td class="leftAligned">
						<!-- <div>
					    	<input id="txtDateOfBirth" name="txtDateOfBirth" style="width: 74px; border: none;" type="text" value="" readonly="readonly" />
					    	<img id="hrefDateOfBirth" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="$('txtDateOfBirth').focus(); scwShow($('txtDateOfBirth'),this, null);" alt="Date of Birth" />
					    </div>  
					    -->
					    <div style="float:left; border: solid 1px gray; width: 106px; height: 21px; margin-right:3px;">
					    	<input style="width: 78px; border: none;" id="txtDateOfBirth" name="txtDateOfBirth" type="text" value="" readonly="readonly"/>
					    	<img id="hrefPersonalDateOfBirth" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtDateOfBirth'),this, null);" alt="Birthday" class="aiInput"/>
						</div>
					</td>
					<td class="rightAligned">Age </td>
					<td class="leftAligned">
						<input style="width: 100px;" type="text" tabindex="7" id="txtAge" name="txtAge"  value="" maxlength="3" class="aiInput"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Civil Status </td>
					<td class="leftAligned"style="width:100px; " >
						<select style="width: 108px;" tabindex="8" id="civilStatus" name="civilStatus" onclick="" class="aiInput">
							<option value=""></option>
							<c:forEach var="civilStatusList" items="${civilStatusList}">
								<option value="${civilStatusList.rvLowValue}"
								<c:if test="${gipiQuoteItemAC.civilStatus == civilStatusList.rvLowValue}">
								selected="selected"
								</c:if>
								>${civilStatusList.rvMeaning}</option>
							</c:forEach>
						</select>
					</td>			
					<td class="rightAligned">Sex </td>
					<td class="leftAligned"style="width:100px; " >				
						<select style="width: 108px;" tabindex="9" id="sex" name="sex" onclick="" class="aiInput">
							<option value=""></option>
							<c:forEach var="sexList" items="${sexList}">
								<option value="${sexList.rvLowValue}"
								<c:if test="${gipiQuoteItemAC.sex == sexList.rvLowValue}">
								selected="selected"
								</c:if>
								>${sexList.rvMeaning}</option>
							</c:forEach>
						</select>
					</td>		
				</tr>
				<tr>
					<td class="rightAligned">Height </td>
					<td class="leftAligned">
						<input style="width: 100px;" type="text" tabindex="10" id="height" name="height" value="${gipiQuoteItemAC.height}" maxlength="10" class="aiInput"/>
					</td>
					<td class="rightAligned">Weight </td>
					<td class="leftAligned">
						<input style="width: 100px;" type="text" tabindex="11" id="weight" name="weight" value="${gipiQuoteItemAC.weight}" maxlength="10" class="aiInput"/>
					</td>
				</tr>
			</table>
			<div style="margin-left: auto; margin-right: auto; margin-bottom: 20px;">
				<input type="button" id="aiACUpdateBtn" name="aiACUpdateBtn" value="Apply Changes" class="disabledButton"/>  <!-- edited by steven 11/7/2012 binago ko ung id niya kasi parehas siya sa ibang jsp na tinatawag dito kaya nag-eerror ung function --> 
			</div>
		</div>
	</form>
</div>
</div>
<script type="text/javascript">
	/*$("txtDateOfBirth").setStyle("border: none; width: 78px; margin: 0;");
	$("txtDateOfBirth").up("div", 0).setStyle("border: 1px solid gray; padding: 0; width: 106px; background: #FFFFFF;");
	$("txtDateOfBirth").observe("blur",function(){		
		if(makeDate($F("txtDateOfBirth")) > new Date() || makeDate($F("txtDateOfBirth")) > makeDate($F("acceptDt"))){			
			showMessageBox("Date of birth should not be later than system date and accept date.", imgMessage.ERROR);
			$("txtDateOfBirth").value = "";
			$("age${aiItemNo}").value = "";
		}else {
			$("age${aiItemNo}").value = computeAge($F("txtDateOfBirth"));
		}
	});*/

	addStyleToInputs();
	initializeAll();

	var preBday = "";
	$("hrefPersonalDateOfBirth").observe("click", function () {
		preBday = $("txtDateOfBirth").value;
	});
	
	function checkBday(){
		var today = new Date();
		var ok = true;
		var bday = makeDate($F("txtDateOfBirth"));
		if (bday>today){
			ok = false;
			$("txtDateOfBirth").value = nvl(preBday,"");
			//$("txtAge").value = "";
			//hideNotice("");
		}	
		return ok;
	}
	
	observeBackSpaceOnDate("txtDateOfBirth");
	$("txtDateOfBirth").observe("blur", function () {
		if (checkBday()) $("txtAge").value = computeAge($("txtDateOfBirth").value);
	});

	$("txtAge").observe("blur", function () {
		if (parseInt($F("txtAge")) > 999 || parseInt($F("txtAge")) < 0){
			showMessageBox("Entered Age is invalid. Valid value is from 0 to 999", imgMessage.ERROR);
			$("txtAge").value ="";
			return false;
		} else{
			isNumber("txtAge","Entered Age is invalid. Valid value is from 0 to 999","");
		}
	});

	$("txtNoOfPerson").observe("blur", function(){
		if (parseInt($F("txtNoOfPerson").replace(/,/g, "")) > 999999999999 || parseInt($F("txtNoOfPerson").replace(/,/g, ""))<1){
			showMessageBox("Invalid No. of Persons. Value should be from 1 to 999,999,999,999.", imgMessage.ERROR);
			$("txtNoOfPerson").value = "";
			//return false;
		}
	});

	$("txtSalary").observe("keyup", function(){
		if(!isNaN($F("txtSalary").replace(/,/g, ""))){	
			var sal = parseFloat($F("txtSalary").replace(/,/g, ""));
			if(sal<0){
				showMessageBox("Invalid Salary. Value should be from 0 to 9,999,999,999.99.", imgMessage.ERROR);
				$("txtSalary").value = sal * -1;
			}else if(sal > 9999999999.99){ 
				showMessageBox("Invalid Salary. Value should be from 0 to 9,999,999,999.99.", imgMessage.ERROR);
				$("txtSalary").value  = "";
			}else{
				hideNotice();
			}
		}
		else {
			$("txtSalary").value  = 0;
		}
	});
	
	initializeAiType("aiACUpdateBtn");
	
	$("aiACUpdateBtn").observe("click", function(){
		fireEvent($("btnAddItem"), "click");
		clearChangeAttribute("accidentAdditionalInformationDiv");
	});
	
</script>