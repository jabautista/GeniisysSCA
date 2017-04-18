<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
   		<label>Policy Information</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label name="gro" style="margin-left: 5px;">Hide</label>
	   		<label id="reloadForm" name="reloadForm">Reload Form</label>
   		</span>
   	</div>
</div>
<div class="sectionDiv" id="policyInformationDiv">
	<div id="policyInformation" style="margin: 10px;">
		<table cellspacing="2" border="0" style="margin: 10px auto;">
 			<tr>
				<td class="rightAligned" style="width: 100px;" id="lblPolNo">Policy No. </td>
				<td class="leftAligned" style="width: 350px;">
					<input type="text" id="txtPolLineCd" name="txtPolLineCd" class="required" style="float: left; width: 30px; margin-right: 3px;" maxlength="2"/>
					<input type="text" id="txtPolSublineCd" name="txtPolSublineCd" class="" style="float: left; width: 70px; margin-right: 3px;" maxlength="7"/>
					<input type="text" id="txtPolIssCd" name="txtPolIssCd" class="" style="float: left; width: 30px; margin-right: 3px;" maxlength="2"/>
					<input type="text" id="txtPolIssueYy" name="txtPolIssueYy" class="" style="float: left; width: 30px; margin-right: 3px; text-align: right;" maxlength="2"/>
					<input type="text" id="txtPolPolSeqNo" name="txtPolPolSeqNo" class="" style="float: left; width: 70px; margin-right: 3px; text-align: right;" maxlength="7"/>
					<input type="text" id="txtPolRenewNo" name="txtPolRenewNo" class="" style="float: left; width: 30px; margin-right: 3px; text-align: right;" maxlength="2"/>
					<img id="hrefPolicyNo" alt="Policy No" style="height: 20px; margin-top: 3px; cursor: pointer;" class="" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />				
					<%-- <div style="float: left; border: solid 1px gray; width: 216px; height: 20px; margin-right: 3px;">
						<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 185px; border: none; background-color: transparent;" name="txtPolicyNo" id="txtPolicyNo" readonly="readonly"/>
						<img id="hrefPolicyNo" alt="goPolicyNo" style="height: 18px; margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
					</div> --%>
				</td>
				<td class="rightAligned" style="width: 140px;">Effectivity Date</td>
				<td class="leftAligned">
					<input id="txtEffDate" name="txtEffDate" type="text" style="width: 170px;" value="" readonly="readonly" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 100px;" id="lblAssdName">Endt. No. </td>
				<td class="leftAligned">
					<input id="txtEndtNo" name="txtEndtNo" type="text" style="width: 315px;" value="" readonly="readonly" />
				</td>
				<td class="rightAligned" style="width: 140px;">Expiry Date</td>
				<td class="leftAligned">
					<input id="txtExpiryDate" name="txtExpiryDate" type="text" style="width: 170px;" value="" readonly="readonly" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 100px;" id="lblAssdName">Assured Name </td>
				<td class="leftAligned">
					<input id="txtAssdName" name="txtAssdName" type="text" style="width: 315px;" value="" readonly="readonly" />
				</td>
				<td class="rightAligned" style="width: 140px;">Redistribution Date</td>
				<td class="leftAligned">
					<div id="redistDateDiv" style="border: 1px solid gray; width: 175px; height: 21px; float: left;">
						<input id="txtRedistributionDate" name="txtRedistributionDate" type="text" style="width: 147px; float: left; border: none; background-color: transparent;" value="" readonly="readonly" />
						<img id="hrefCollnDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="$('txtRedistributionDate').focus(); scwShow($('txtRedistributionDate'),this, null);" alt="Check Date" style="display: none; margin-top: 2px; margin-left: 3px;"/>
					</div>
				</td>
			</tr>
		</table>
		<!-- Hidden fields for corresponding columns of GIPI_POLBASIC_DIST_V1 -->
		<input type="hidden" id="txtPolDistV1LineCd" name="txtPolDistV1LineCd" value="" />
	</div>
</div>
<script type="text/javascript">
	$("txtPolLineCd").observe("keyup", function(){
		$("txtPolLineCd").value = $F("txtPolLineCd").toUpperCase();
	});

	$("txtPolSublineCd").observe("keyup", function(){
		$("txtPolSublineCd").value = $F("txtPolSublineCd").toUpperCase();
	});

	$("txtPolIssCd").observe("keyup", function(){
		$("txtPolIssCd").value = $F("txtPolIssCd").toUpperCase();
	});

	$("txtPolIssueYy").observe("keyup", function(){
		if(isNaN($F("txtPolIssueYy"))){
			$("txtPolIssueYy").value = "";
		}
	});

	$("txtPolPolSeqNo").observe("keyup", function(){
		if(isNaN($F("txtPolPolSeqNo"))){
			$("txtPolPolSeqNo").value = "";
		}
	});

	$("txtPolRenewNo").observe("keyup", function(){
		if(isNaN($F("txtPolRenewNo"))){
			$("txtPolRenewNo").value = "";
		}
	});
</script>