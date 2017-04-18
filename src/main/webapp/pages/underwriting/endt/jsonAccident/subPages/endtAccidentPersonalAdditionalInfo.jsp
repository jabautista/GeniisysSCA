<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="otherInformationDiv" name="otherInformationDiv">	
	<table align="center" width="580px;" border="0" style="margin-top:10px; margin-bottom:10px;">
		<tr>
			<td class="rightAligned" style="width:100px;">Birthday </td>
			<td class="leftAligned" >
				<div style="float:left; border: solid 1px gray; width: 186px; height: 21px; margin-right:3px;">
			    	<input style="width: 159px; border: none;" id="pDateOfBirth" name="pDateOfBirth" type="text" value="" readonly="readonly"/>
			    	<img id="hrefPersonalDateOfBirth" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('pDateOfBirth'),this, null);" alt="Birthday" />
				</div>
			</td>	
			<td class="rightAligned" style="width:81px;">Sex </td>
			<td class="leftAligned" >
				<select id="pSex" name="pSex" style="width: 188px">
					<option value=""></option>
					<option value="F">Female</option>
					<option value="M">Male</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Age</td>
			<td class="leftAligned" >
				<input id="pAge" name="pAge" type="text" style="width: 180px; text-align:right;" maxlength="3" class="integerNoNegativeUnformattedNoComma" errorMsg="Entered Age is invalid. Valid value is from 0 to 999" readonly="readonly"/>
			</td>
			<td class="rightAligned" >Height</td>
			<td class="leftAligned" >
				<input id="pHeight" name="pHeight" type="text" style="width: 180px; text-align:right;" maxlength="10" />
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Civil Status </td>
			<td class="leftAligned">
				<select  id="pCivilStatus" name="pCivilStatus" style="width: 188px">
					<option value=""></option>
					<c:forEach var="civilStats" items="${civilStats}">
						<option value="${civilStats.rvLowValue}">${civilStats.rvMeaning}</option>
					</c:forEach>
				</select>
			</td>
			<td class="rightAligned" >Weight</td>
			<td class="leftAligned" >
				<input id="pWeight" name="pWeight" type="text" style="width: 180px; text-align:right;" maxlength="10" />
			</td>
		</tr>	
		<tr>
			<td>
				<input type="hidden" id="groupPrintSw"  name="groupPrintSw"   	value="" />
				<input type="hidden" id="acClassCd" 	name="acClassCd" 		value="" />
				<input type="hidden" id="levelCd" 		name="levelCd" 			value="" />
				<input type="hidden" id="parentLevelCd" name="parentLevelCd" 	value="" />
				<input type="hidden" id="itemWitmperlExist" 		name="itemWitmperlExist" 			value="" />
				<input type="hidden" id="itemWitmperlGroupedExist"  name="itemWitmperlGroupedExist" 	value="" />
				<input type="hidden" id="populatePerils" name="populatePerils" value="" />
				<input type="hidden" id="itemWgroupedItemsExist"    name="itemWgroupedItemsExist"       value="" />
				<input type="hidden" id="accidentDeleteBill"    	name="accidentDeleteBill"       	value="" />
			</td>
		</tr>
	</table>
</div>
<script type="text/javaScript">
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();

	$("pAge").observe("blur", function () {
		if (parseInt($F("pAge")) > 999 || parseInt($F("pAge")) < 0){
			showMessageBox("Entered Age is invalid. Valid value is from 0 to 999", imgMessage.ERROR);
			$("pAge").value ="";
			return false;
		} else{
			isNumber("pAge","Entered Age is invalid. Valid value is from 0 to 999","");
		}
	});

	$("pDateOfBirth").observe("blur", function () {
		$("pAge").value = computeAge($("pDateOfBirth").value);
		checkBday();
	});

	$("pAge").observe("blur", function () {
		if ($("pDateOfBirth").value != ""){
			if ($("pAge").value != ""){
				$("pAge").value = computeAge($("pDateOfBirth").value);
			}
		}
	});
			
	function checkBday(){
		var today = new Date();
		var bday = makeDate($F("pDateOfBirth"));
		if (bday>today){
			$("pDateOfBirth").value = "";
			$("pAge").value = "";
			hideNotice("");
		}	
	}

	$("pHeight").observe("blur", function () {
		if ($("noOfPerson").value == "" && $("pHeight").value != ""){
			$("noOfPerson").value = "1";
		}
	});

	$("pWeight").observe("blur", function () {
		if ($("noOfPerson").value == "" && $("pWeight").value != ""){
			$("noOfPerson").value = "1";
		}
	});
	
</script>