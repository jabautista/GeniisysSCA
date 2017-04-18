<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
<div id="otherInformationDiv" name="otherInformationDiv" style="width: 100%; height: 100%; margin-top: 50px;">	
	<table align="center" width="580px;" border="0" style="margin-top:10px; margin-bottom:10px;">
		<tr>
			<td class="rightAligned" style="width:100px;">Birthday </td>
			<td class="leftAligned" >
				<div style="float:left; border: solid 1px gray; width: 186px; height: 21px; margin-right:3px;">
			    	<input style="width: 159px; border: none;" id="pDateOfBirth" name="pDateOfBirth" type="text" readonly="readonly" 
			    	value="<fmt:formatDate value="${dateOfBirth }" pattern="MM-dd-yyyy" />" />
			    	<img id="hrefPersonalDateOfBirth" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('pDateOfBirth'),this, null);" alt="Birthday" />
				</div>
			</td>	
			<td class="rightAligned" style="width:81px;">Sex </td>
			<td class="leftAligned" >
				<select id="pSex" name="pSex" style="width: 188px">
					<option value=""></option>
					<option value="F"
					<c:if test="${'F' == sex}">
						selected="selected"
					</c:if>
					>Female</option>
					<option value="M"
					<c:if test="${'M' == sex}">
						selected="selected"
					</c:if>
					>Male</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Age</td>
			<td class="leftAligned" >
				<input id="pAge" name="pAge" type="text" style="width: 180px; text-align:right;" maxlength="3" class="integerNoNegativeUnformattedNoComma" errorMsg="Entered Age is invalid. Valid value is from 0 to 999" readonly="readonly" value="${age}"/>
			</td>
			<td class="rightAligned" >Height</td>
			<td class="leftAligned" >
				<input id="pHeight" name="pHeight" type="text" style="width: 180px; text-align:right;" maxlength="10" value="${height}" />
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Civil Status </td>
			<td class="leftAligned">
				<select  id="pCivilStatus" name="pCivilStatus" style="width: 188px">
					<option value=""></option>
					<c:forEach var="civilStats" items="${civilStats}">
						<option value="${civilStats.rvLowValue}"
						<c:if test="${civilStats.rvLowValue == civilStatus }">
							selected="selected"
						</c:if>
						>${civilStats.rvMeaning}</option>
					</c:forEach>
				</select>
			</td>
			<td class="rightAligned" >Weight</td>
			<td class="leftAligned" >
				<input id="pWeight" name="pWeight" type="text" style="width: 180px; text-align:right;" maxlength="10" value="${weight }" />
			</td>
		</tr>	
		<tr>
			<td>
				<input type="hidden" id="groupPrintSw"  				name="groupPrintSw"   				value="${groupPrintSw }" />
				<input type="hidden" id="acClassCd" 					name="acClassCd" 					value="${acClassCd }" />
				<input type="hidden" id="levelCd" 						name="levelCd" 						value="${levelCd }" />
				<input type="hidden" id="parentLevelCd" 				name="parentLevelCd" 				value="${parentLevelCd }" />
				<input type="hidden" id="itemWitmperlExist" 			name="itemWitmperlExist" 			value="${itemWItmPerlExist }" />
				<input type="hidden" id="itemWitmperlGroupedExist"  	name="itemWitmperlGroupedExist" 	value="${itemWItmPerlGroupedExist }" />
				<input type="hidden" id="populatePerils" 				name="populatePerils" 				value="${populatePerils }" />
				<input type="hidden" id="itemWgroupedItemsExist"    	name="itemWgroupedItemsExist"       value="${itemWGroupedItemsExist }" />
				<input type="hidden" id="accidentDeleteBill"    		name="accidentDeleteBill"       	value="${accidentDeleteBill }" />
			</td>
		</tr>
	</table>
</div>
<script type="text/javaScript">
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	//initializeAddInfo();

	//if ($F("addInfoSw") == "N"){
		//initializeAddInfo();
	//} 
	
	function initializeAddInfo(){
		$("pDateOfBirth").value			= $F("hidDateOfBirth");
		$("pAge").value					= $F("hidAge");
		$("pHeight").value				= $F("hidHeight");
		$("pWeight").value				= $F("hidWeight");

		for (var x = 0; x < $("pCivilStatus").length; x++){
			if ($("pCivilStatus").options[x].value == $F("hidCivilStatus")){
				$("pCivilStatus").selectedIndex = x;
			}
		}

		for (var y = 0; y < $("pSex").length; y++){
			if ($("pSex").options[y].value == $F("hidSex")){
				$("pSex").selectedIndex = y;
			}
		}
	}
	
	function initializeAddInfo3(){
		if ($F("hidDateOfBirth") != ""){
			$("pDateOfBirth").value 	= $F("hidDateOfBirth");
		}

		if ($F("hidAge") != ""){
			$("pAge").value 			= $F("hidAge");
		}

		if ($F("hidHeight") != ""){
			$("pHeight").value			= $F("hidHeight");
		}

		if ($F("hidWeight") != ""){
			$("pWeight").value			= $F("hidWeight");
		}

		if ($F("hidCivilStatus") != ""){
			for (var x = 0; x < $("pCivilStatus").length; x++){
				if ($("pCivilStatus").options[x].value == $F("hidCivilStatus")){
					$("pCivilStatus").selectedIndex = x;
				}
			}
		}

		if ($F("hidSex") != ""){
			for (var y = 0; y < $("pSex").length; y++){
				if ($("pSex").options[y].value == $F("hidSex")){
					$("pSex").selectedIndex = y;
				}
			}
		}
	}

	function initializeAddInfo2(){
		$("hidDateOfBirth").value = $F("pDateOfBirth");
		$("hidAge").value = $F("pAge");
		$("hidCivilStatus").value = $F("pCivilStatus");
		$("hidSex").value = $F("pSex");
		$("hidHeight").value = $F("pHeight");
		$("hidWeight").value = $F("pWeight");
		
		$("hidGroupPrintSw").value = $F("groupPrintSw");
		$("hidAcClassCd").value = $F("acClassCd");
		$("hidLevelCd").value = $F("levelCd");
		$("hidParentLevelCd").value = $F("parentLevelCd");
		$("hidItemWitmperlExist").value = $F("itemWitmperlExist"); 
		$("hidItemWitmperlGroupedExist").value = $F("itemWitmperlGroupedExist"); 
		$("hidPopulatePerils").value = $F("populatePerils");
		$("hidItemWgroupedItemsExist").value = $F("itemWgroupedItemsExist"); 
		$("hidAccidentDeleteBill").value = $F("accidentDeleteBill");
	}
	
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

		$("hidDateOfBirth").value = $F("pDateOfBirth");
	});
	
	$("pAge").observe("blur", function () {
		if ($("pDateOfBirth").value != ""){
			if ($("pAge").value != ""){
				$("pAge").value = computeAge($("pDateOfBirth").value);
			}
		}

		$("hidAge").value = $F("pAge");
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

		$("hidHeight").value = $F("pHeight");
	});
	
	$("pWeight").observe("blur", function () {
		if ($("noOfPerson").value == "" && $("pWeight").value != ""){
			$("noOfPerson").value = "1";
		}

		$("hidWeight").value = $F("pWeight");
	});

	$("pCivilStatus").observe("blur", function () {
		var index = $("pCivilStatus").selectedIndex;
		$("hidCivilStatus").value = $("pCivilStatus").options[index].value;
	});

	$("pSex").observe("blur", function () {
		var index = $("pSex").selectedIndex;
		$("hidSex").value = $("pSex").options[index].value;
	});

	$("close").observe("click", function () {
		initializeAddInfo2();
		$("addInfoSw").value = "N";
	});
	
</script>