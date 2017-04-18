<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="otherInformationDiv" name="otherInformationDiv">	
	<table align="center" width="580px;" border="0" style="margin-top:10px; margin-bottom:10px;">
		<tr>
			<td class="rightAligned" style="width:100px;">Birthday </td>
			<td class="leftAligned" >
				<div style="float:left; border: solid 1px gray; width: 186px; height: 21px; margin-right:3px;">
			    	<input tabindex="2001" style="width: 159px; border: none;" id="pDateOfBirth" name="pDateOfBirth" type="text" value="" readonly="readonly"/>
			    	<img id="hrefPersonalDateOfBirth" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('pDateOfBirth'),this, null);" alt="Birthday" class="hover" />
				</div>
			</td>	
			<td class="rightAligned" style="width:81px;">Sex </td>
			<td class="leftAligned" >
				<select tabindex="2004" id="pSex" name="pSex" style="width: 188px">
					<option value=""></option>
					<option value="F">Female</option>
					<option value="M">Male</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Age</td>
			<td class="leftAligned" >
				<input tabindex="2002" id="pAge" name="pAge" type="text" style="width: 180px; text-align:right;" maxlength="3" class="integerUnformattedOnBlur" min="1" max="999" errorMsg="Entered Age is invalid. Valid value is from 1 to 999" />
			</td>
			<td class="rightAligned" >Height</td>
			<td class="leftAligned" >
				<input tabindex="2005" id="pHeight" name="pHeight" type="text" style="width: 180px; text-align:right;" maxlength="10" />
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Civil Status </td>
			<td class="leftAligned">
				<select tabindex="2003" id="pCivilStatus" name="pCivilStatus" style="width: 188px">
					<option value=""></option>
					<c:forEach var="civilStats" items="${civilStats}">
						<option value="${civilStats.rvLowValue}">${civilStats.rvMeaning}</option>
					</c:forEach>
				</select>
			</td>
			<td class="rightAligned" >Weight</td>
			<td class="leftAligned" >
				<input tabindex="2006" id="pWeight" name="pWeight" type="text" style="width: 180px; text-align:right;" maxlength="10" />
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
<script type="text/javascript">
try{
	function showPersonalAddlInfo(){
		try{
			$("showPersonalAdditionalInfo").innerHTML = $("showPersonalAdditionalInfo").innerHTML == "Hide" ? "Show" : "Hide";
			var infoDiv = $("showPersonalAdditionalInfo").up("div", 1).next().readAttribute("id");
			Effect.toggle(infoDiv, "blind", {duration: .3});
		}catch(e){
			showErrorMessage("showPersonalAddlInfo", e);
		}
	}
	
	$("showPersonalAdditionalInfo").observe("click", showPersonalAddlInfo);	
	
	$("btnPersonalAddtlInfo").observe("click", function () {
		if ($("positionCd").value == ""){
			showMessageBox("Please select an Occupation first.", imgMessage.ERROR);
			return false;
		} else{
			showPersonalAddlInfo();		
		}	
	});
	
	$("pAge").observe("focus", function(){
		objFormVariables.varAge = $F("pAge");
	});
	
	$("pAge").observe("blur", function(){
		if(!($F("pAge").empty()) && objFormVariables.varAge != $F("pAge")){
			$("pDateOfBirth").value = "";
		}
		/*
		if (parseInt($F("pAge")) > 999 || parseInt($F("pAge")) < 0){
			showMessageBox("Entered Age is invalid. Valid value is from 0 to 999", imgMessage.ERROR);
			$("pAge").value ="";
			return false;
		} else{
			isNumber("pAge","Entered Age is invalid. Valid value is from 0 to 999","");
		}
		*/		
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
	
	$("pDateOfBirth").observe("blur", function () {
		if(!($F("pDateOfBirth").empty())){
			$("pAge").value = computeAge($("pDateOfBirth").value);
			checkBday();	
		}		
	});
	
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
	
	observeChangeTagOnDate("hrefPersonalDateOfBirth", "pDateOfBirth");
	
}catch(e){
	showErrorMessage("Personal Additional Info", e);
}
</script>