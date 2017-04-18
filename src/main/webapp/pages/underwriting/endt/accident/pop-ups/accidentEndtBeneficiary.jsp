<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="beneficiaryInformationInfo" class="sectionDiv" style="display: none; width:872px; background-color:white; ">
	<jsp:include page="/pages/underwriting/subPages/accidentBeneficiaryListing.jsp"></jsp:include>
	<table align="center" width="580px;" border="0">
		<tr>
			<td class="rightAligned" style="width:100px;">Name </td>
			<td class="leftAligned" colspan="3">
				<input id="bBeneficiaryNo" name="bBeneficiaryNo" type="hidden" style="width: 180px;" maxlength="5" readonly="readonly"/>
				<input id="bBeneficiaryName" name="bBeneficiaryName" type="text" style="width: 462px" maxlength="30" class="required"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width:100px;">Address </td>
			<td class="leftAligned" colspan="3">
				<input id="bBeneficiaryAddr" name="bBeneficiaryAddr" type="text" style="width: 462px" maxlength="50"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Birthday </td>
			<td class="leftAligned" >
				<div style="float:left; border: solid 1px gray; width: 186px; height: 21px; margin-right:3px;">
			    	<input style="width: 159px; border: none; float: left;" id="bDateOfBirth" name="bDateOfBirth" type="text" value="" readonly="readonly"/>
			    	<img name="accModalDate" id="hrefBeneficiaryDateOfBirth" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('bDateOfBirth'),this, null);" alt="Birthday" />
				</div>
			</td>	
			<td class="rightAligned">Age 
				<input id="bAge" name="bAge" type="text" style="width: 64px;" maxlength="3" class="integerNoNegativeUnformattedNoComma rightAligned" errorMsg="Entered Age is invalid. Valid value is from 0 to 999" readonly="readonly"/>
			</td>
			<td class="rightAligned" >Sex	
				<select id="bSex" name="bSex" style="width:106px;">
					<option value=""></option>
					<option value="F">Female</option>
					<option value="M">Male</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width:100px;">Relation </td>
			<td class="leftAligned">
				<input id="bRelation" name="bRelation" type="text" style="width: 180px;" maxlength="15"/>
			</td>
			<td class="rightAligned" >Civil Status </td>
			<td class="leftAligned">
				<select  id="bCivilStatus" name="bCivilStatus" style="width: 165px">
					<option value=""></option>
					<c:forEach var="civilStats" items="${civilStats}">
						<option value="${civilStats.rvLowValue}">${civilStats.rvMeaning}</option>
					</c:forEach>
				</select>
			</td>
		</tr>	
		<tr>
			<td>
				<input id="bGroupedItemNo" 	name="cGroupedItemNo" 	type="hidden" style="width: 215px;" value="" />
				<input id="nextItemNoBen2"  name="nextItemNoBen2"   type="hidden" style="width: 220px;" value="" readonly="readonly"/>
			</td>
		</tr>
	</table>
	<table align="center" style="margin-bottom:10px;">
		<tr>
			<td class="rightAligned" style="text-align: left; padding-left: 5px;">
				<input type="button" class="button" 		id="btnAddBeneficiary" 	name="btnAddBeneficiary" 		value="Add" 		style="width: 60px;" />
				<input type="button" class="disabledButton" id="btnDeleteBeneficiary" 	name="btnDeleteBeneficiary" 	value="Delete" 		style="width: 60px;" />
			</td>
		</tr>
	</table>
</div>

	<div id="perilDetail">
		<div id="outerDiv" name="outerDiv" style="width:872px; background-color:white;" >
			<div id="innerDiv" name="innerDiv">
				<label>Peril Information</label>
					<span class="refreshers" style="margin-top: 0;">
					<label id="showPeril" name="gro" style="margin-left: 5px;">Show</label>
				</span>
			</div>
		</div>			
		<jsp:include page="/pages/underwriting/endt/accident/pop-ups/accidentEndtPeril.jsp"></jsp:include>
	</div>

<script type="text/javascript">
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();

	$("bAge").observe("blur", function () {
		if (parseInt($F("bAge")) > 999 || parseInt($F("bAge")) < 0){
			showMessageBox("Entered Age is invalid. Valid value is from 0 to 999", imgMessage.ERROR);
			$("bAge").value ="";
			return false;
		} else{
			isNumber("bAge","Entered Age is invalid. Valid value is from 0 to 999","");
		}
		
	});
	
	$("bDateOfBirth").observe("blur", function () {
		$("bAge").value = computeAge($("bDateOfBirth").value);
		checkBday();
	});

	$("bAge").observe("blur", function () {
		if ($("bDateOfBirth").value != ""){
			if ($("bAge").value != ""){
				$("bAge").value = computeAge($("bDateOfBirth").value);
			}
		}
	});
		
	function checkBday(){
		var today = new Date();
		var bday = makeDate($F("bDateOfBirth"));

		//added by angelo
		if ($F("bDateOfBirth") == ""){
			$("bDateOfBirth").value = "01-01-1901";
		}
		
		
		if (bday>today){
			$("bDateOfBirth").value = "";
			$("bAge").value = "";
			hideNotice("");
		}	
	}

//start for perils
	
</script>