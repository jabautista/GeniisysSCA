<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="roadMapMainDiv" name="roadMapMainDiv" class="sectionDiv">
	<div id="roadMapDiv" name="roadMapDiv" style="margin: 20px; width: 40%; float: left;">
		<table id="roadMapTable" name="roadMapTable" cellpadding="0" cellspacing="0">
			<tr id="row1" class="roadMapRow">
				<td style="width: 25px;"></td>
				<td style="width: 15px;"></td>
				<td class="ylineCtr"><input type="button" id="rmParlist" name="rmParlist" title="PAR Listing" class="inaccessible"></td>
				<td style="width: 40px;"></td>
				<td style="width: 3.5px;"></td>
				<td style="width: 15px;"></td>
				<td></td>
				<td style="width: 40px;"></td>
				<td style="width: 3.5px;" valign="bottom" align="right"><img src="css/roadMap/images/black.png" align="bottom" style="height: 14px; width: 3px;"></td>
				<td style="width: 15px;" class="xline"></td>
				<td><input type="button" id="rmBondBasicInfo" name="rmBondBasicInfo" title="Bond Basic Information" class="inaccessible"></td>
			</tr>
			<tr></tr>
			<tr id="row2" class="roadMapRow">
				<td style="width: 25px;" valign="bottom" align="right"><img src="css/roadMap/images/black.png" align="bottom" style="height: 14px; width: 3px;"></td>
				<td style="width: 15px;" class="xline"></td>
				<td class="ylineCtr"><input type="button" id="rmBasicInfo" name="rmBasicInfo" title="Basic Information" class="inaccessible"></td>
				<td style="width: 40px;" class="xline"></td>
				<td style="width: 3.5px;" class="xline"></td>
				<td style="width: 15px;" class="xline"></td>
				<td class="xline"></td>
				<td style="width: 40px;" class="xline"></td>
				<td style="width: 3.5px;" class="yline"></td>
				<td style="width: 15px;" class="xline"></td>
				<td><input type="button" id="rmEngInfo" name="rmEngInfo" title="Engineering Information" class="inaccessible"></td>
			</tr>
			<tr id="row3" class="roadMapRow">
				<td style="width: 25px;" class="yline"></td>
				<td style="width: 15px;"></td>
				<td class="ylineCtr"></td>
				<td style="width: 40px;"></td>
				<td style="width: 3.5px;" valign="bottom" align="right"><img src="css/roadMap/images/black.png" align="bottom" style="height: 14px; width: 3px;"></td>
				<td style="width: 15px;" class="xline"></td>
				<td><input type="button" id="rmMCItem" name="rmMCItem" title="Motor Car Item Information" class="inaccessible"></td>
				<td style="width: 40px;"></td>
				<td style="width: 3.5px;" class="yline"></td>
				<td style="width: 15px;" class="xline"></td>
				<td><input type="button" id="rmLineSubCov" name="rmLineSubCov" title="Line/Subline Coverage" class="inaccessible"></td>
			</tr>
			<tr id="row4" class="roadMapRow">
				<td style="width: 25px;" class="yline"></td>
				<td style="width: 15px;"></td>
				<td class="ylineCtr"></td>
				<td style="width: 40px;"></td>
				<td style="width: 3.5px;" class="yline"></td>
				<td style="width: 15px;" class="xline"></td>
				<td><input type="button" id="rmFIItem" name="rmFIItem" title="Fire Item Information" class="inaccessible"></td>
				<td style="width: 40px;"></td>
				<td style="width: 3.5px;" class="yline"></td>
				<td style="width: 15px;" class="xline"></td>
				<td><input type="button" id="rmCarrierInfo" name="rmCarrierInfo" title="Carrier Information" class="inaccessible"></td>
			</tr>
			<tr id="row5" class="roadMapRow">
				<td style="width: 25px;" class="yline"></td>
				<td style="width: 15px;"></td>
				<td class="ylineCtr"></td>
				<td style="width: 40px;"></td>
				<td style="width: 3.5px;" class="yline"></td>
				<td style="width: 15px;" class="xline"></td>
				<td><input type="button" id="rmENItem" name="rmENItem" title="Engineering Item Information" class="inaccessible"></td>
				<td style="width: 40px;"></td>
				<td style="width: 3.5px;" class="yline"></td>
				<td style="width: 15px;" class="xline"></td>
				<td><input type="button" id="rmMNLiab" name="rmMNLiab" title="Cargo Limits of Liability" class="inaccessible"></td>
			</tr>
			<tr id="row6" class="roadMapRow">
				<td style="width: 25px;" class="yline"></td>
				<td style="width: 15px;"></td>
				<td class="ylineCtr"><input type="button" id="rmPackPolItems" name="rmPackPolItems" title="Package Policy Items" class="inaccessible"></td>
				<td style="width: 40px;" class="xline"></td>
				<td style="width: 3.5px;" class="yline"></td>
				<td style="width: 15px;" class="xline"></td>
				<td><input type="button" id="rmMNItem" name="rmMNItem" title="Cargo Item Information" class="inaccessible"></td>
				<td style="width: 40px;"></td>
				<td style="width: 3.5px;" class="yline"></td>
				<td style="width: 15px;" class="xline"></td>
				<td><input type="button" id="rmBankColl" name="rmBankColl" title="Bank Collection" class="inaccessible"></td>
			</tr>
			<tr id="row7" class="roadMapRow">
				<td style="width: 25px;" class="yline"></td>
				<td style="width: 15px;"></td>
				<td class="ylineCtr"></td>
				<td style="width: 40px;"></td>
				<td style="width: 3.5px;" class="yline"></td>
				<td style="width: 15px;" class="xline"></td>
				<td><input type="button" id="rmMHItem" name="rmMHItem" title="Marine Hull Item Information" class="inaccessible"></td>
				<td style="width: 40px;"></td>
				<td style="width: 3.5px;" class="yline"></td>
				<td style="width: 15px;" class="xline"></td>
				<td><input type="button" id="rmReqDocs" name="rmReqDocs" title="Documents Submitted" class="inaccessible"></td>
			</tr>
			<tr id="row8" class="roadMapRow">
				<td style="width: 25px;" class="yline"></td>
				<td style="width: 15px;"></td>
				<td class="ylineCtr"></td>
				<td style="width: 40px;"></td>
				<td style="width: 3.5px;" class="yline"></td>
				<td style="width: 15px;" class="xline"></td>
				<td><input type="button" id="rmCAItem" name="rmCAItem" title="Misc. Casualty Item Information" class="inaccessible"></td>
				<td style="width: 40px;"></td>
				<td style="width: 3.5px;" class="yline"></td>
				<td style="width: 15px;" class="xline"></td>
				<td><input type="button" id="rmInitAcc" name="rmInitAcc" title="Initial Acceptance" class="inaccessible"></td>
			</tr>
			<tr id="row9" class="roadMapRow">
				<td style="width: 25px;" class="yline"></td>
				<td style="width: 15px;"></td>
				<td class="ylineCtr"><input type="button" id="rmPeril" name="rmPeril" title="Peril" class="inaccessible"></td>
				<td style="width: 40px;"></td>
				<td style="width: 3.5px;" class="yline"></td>
				<td style="width: 15px;" class="xline"></td>
				<td><input type="button" id="rmAVItem" name="rmAVItem" title="Aviation Item Information" class="inaccessible"></td>
				<td style="width: 40px;"></td>
				<td style="width: 3.5px;" class="yline"></td>
				<td style="width: 15px;" class="xline"></td>
				<td><input type="button" id="rmCollTrans" name="rmCollTrans" title="Collateral Transaction" class="inaccessible"></td>
			</tr>
			<tr id="row10" class="roadMapRow">
				<td style="width: 25px;" class="yline"></td>
				<td style="width: 15px;"></td>
				<td class="ylineCtr"></td>
				<td style="width: 40px;"></td>
				<td style="width: 3.5px;" class="yline"></td>
				<td style="width: 15px;" class="xline"></td>
				<td><input type="button" id="rmACItem" name="rmACItem" title="Accident Item Information" class="inaccessible"></td>
				<td style="width: 40px;"></td>
				<td style="width: 3.5px;" valign="top" align="right"><img src="css/roadMap/images/black.png" style="height: 14px; width: 3px;"></td>
				<td style="width: 15px;" class="xline"></td>
				<td><input type="button" id="rmLimLiab" name="rmLimLiab" title="Limits of Liabilities" class="inaccessible"></td>
			</tr>
			<tr id="row11" class="roadMapRow">
				<td style="width: 25px;" class="yline"></td>
				<td style="width: 15px;" class="xline"></td>
				<td class="ylineCtr"><input type="button" id="rmWarrClause" name="rmWarrClause" title="Warranties and Clauses" class="inaccessible"></td>
				<td style="width: 40px;"></td>
				<td style="width: 3.5px;" valign="top" align="right"><img src="css/roadMap/images/black.png" style="height: 14px; width: 3px;"></td>
				<td style="width: 15px;" class="xline"></td>
				<td><input type="button" id="rmOthers" name="rmOthers" title="Others" class="inaccessible"></td>
				<td style="width: 40px;"></td>
				<td style="width: 3.5px;"></td>
				<td style="width: 15px;"></td>
				<td></td>
			</tr>
			<tr id="row12" class="roadMapRow">
				<td style="width: 25px;" class="yline"></td>
				<td style="width: 15px;" class="xline"></td>
				<td class="ylineCtr"><input type="button" id="rmBillInfo" name="rmBillInfo" title="Bill Information" class="inaccessible"></td>
				<td style="width: 40px;" class="xline"></td>
				<td style="width: 3.5px;" class="xline"></td>
				<td style="width: 15px;" class="xline"></td>
				<td class="xline"></td>
				<td style="width: 40px;" class="xline"></td>
				<td style="width: 3.5px;" valign="bottom" align="right"><img src="css/roadMap/images/black.png" align="bottom" style="height: 14px; width: 3px;"></td>
				<td style="width: 15px;" class="xline"></td>
				<td><input type="button" id="rmDiscSur" name="rmDiscSur" title="Discount/Surcharge" class="inaccessible"></td>
			</tr>
			<tr id="row13" class="roadMapRow">
				<td style="width: 25px;" class="yline"></td>
				<td style="width: 15px;"></td>
				<td class="ylineCtr"><input type="button" id="rmCoInsurance" name="rmCoInsurance" title="Co-Insurance" class="inaccessible"></td>
				<td style="width: 40px;" class="xline"></td>
				<td style="width: 3.5px;" valign="bottom" align="right"><img src="css/roadMap/images/black.png" align="bottom" style="height: 14px; width: 3px;"></td>
				<td style="width: 15px;" class="xline"></td>
				<td><input type="button" id="rmCoInsurer" name="rmCoInsurer" title="Co-Insurer" class="inaccessible"></td>
				<td style="width: 40px;"></td>
				<td style="width: 3.5px;" class="yline"></td>
				<td style="width: 15px;" class="xline"></td>
				<td><input type="button" id="rmGrpItem" name="rmGrpItem" title="Group Items per Bill" class="inaccessible"></td>
			</tr>
			<tr id="row14" class="roadMapRow">
				<td style="width: 25px;" class="yline"></td>
				<td style="width: 15px;" class="xline"></td>
				<td class="ylineCtr"><input type="button" id="rmPrelimDist" name="rmPrelimDist" title="Preliminary Distribution" class="inaccessible"></td>
				<td style="width: 40px;"></td>
				<td style="width: 3.5px;" valign="top" align="right"><img src="css/roadMap/images/black.png" style="height: 14px; width: 3px;"></td>
				<td style="width: 15px;" class="xline"></td>
				<td><input type="button" id="rmLeadPol" name="rmLeadPol" title="Lead Policy" class="inaccessible"></td>
				<td style="width: 40px;"></td>
				<td style="width: 3.5px;" class="yline"></td>
				<td style="width: 15px;" class="xline"></td>
				<td><input type="button" id="rmBillPrem" name="rmBillPrem" title="Bill Premium" class="inaccessible"></td>
			</tr>
			<tr id="row15" class="roadMapRow">
				<td style="width: 25px;" valign="top" align="right"><img src="css/roadMap/images/black.png" style="height: 14px; width: 3px;"></td>
				<td style="width: 15px;" class="xline"></td>
				<td class="ylineCtr"><input type="button" id="rmPrint" name="rmPrint" title="Print" class="inaccessible"></td>
				<td style="width: 40px;" class="xline"></td>
				<td style="width: 3.5px;" valign="bottom" align="right"><img src="css/roadMap/images/black.png" align="bottom" style="height: 14px; width: 3px;"></td>
				<td style="width: 15px;" class="xline"></td>
				<td><input type="button" id="rmSetupGrp" name="rmSetupGrp" title="Group Set up" class="inaccessible"></td>
				<td style="width: 40px;"></td>
				<td style="width: 3.5px;" valign="top" align="right"><img src="css/roadMap/images/black.png" style="height: 14px; width: 3px;"></td>
				<td style="width: 15px;" class="xline"></td>
				<td><input type="button" id="rmInvComm" name="rmInvComm" title="Invoice Commission" class="inaccessible"></td>
			</tr>
			<tr id="row16" class="roadMapRow">
				<td style="width: 25px;"></td>
				<td style="width: 15px;"></td>
				<td class="ylineCtr"></td>
				<td style="width: 40px;"></td>
				<td style="width: 3.5px;" class="yline"></td>
				<td style="width: 15px;" class="xline"></td>
				<td><input type="button" id="rmPerilDist" name="rmPerilDist" title="Peril and Distibution" class="inaccessible"></td>
				<td style="width: 40px;"></td>
				<td style="width: 3.5px;"></td>
				<td style="width: 15px;"></td>
				<td></td>
			</tr>
			<tr id="row17" class="roadMapRow">
				<td style="width: 25px;"></td>
				<td style="width: 15px;"></td>
				<td class="ylineCtr"><input type="button" id="rmPost" name="rmPost" title="Post" class="inaccessible"></td>
				<td style="width: 40px;"></td>
				<td style="width: 3.5px;" valign="top" align="right"><img src="css/roadMap/images/black.png" style="height: 14px; width: 3px;"></td>
				<td style="width: 15px;" class="xline"></td>
				<td><input type="button" id="rmOneRiskDist" name="rmOneRiskDist" title="One Risk Distribution" class="inaccessible"></td>
				<td style="width: 40px;"></td>
				<td style="width: 3.5px;" valign="bottom" align="right"><img src="css/roadMap/images/black.png" align="bottom" style="height: 14px; width: 3px;"></td>
				<td style="width: 15px;" class="xline"></td>
				<td><input type="button" id="rmDistPeril" name="rmDistPeril" title="Distribution by Peril" class="inaccessible"></td>
			</tr>
			<tr id="row18" class="roadMapRow">
				<td style="width: 25px;"></td>
				<td style="width: 15px;"></td>
				<td><input type="button" id="rmDist" name="rmDist" title="Distribution" class="inaccessible"></td>
				<td style="width: 40px;" class="xline"></td>
				<td style="width: 3.5px;" class="xline"></td>
				<td style="width: 15px;" class="xline"></td>
				<td class="xline"></td>
				<td style="width: 40px;" class="xline"></td>
				<td style="width: 3.5px;" valign="top" align="right"><img src="css/roadMap/images/black.png" style="height: 14px; width: 3px;"></td>
				<td style="width: 15px;" class="xline"></td>
				<td><input type="button" id="rmDistGrp" name="rmDistGrp" title="Distribution by Group" class="inaccessible"></td>
			</tr>
		</table>
	</div>
	<jsp:include page="/pages/underwriting/roadMap/legend.jsp"></jsp:include>
</div>

<script type="text/javascript">
	var par = JSON.parse('${jsonPAR}'.replace(/\\/g, '\\\\'));
	var wpolbas = JSON.parse('${jsonWPolbas}'.replace(/\\/g, '\\\\'));
	var moduleId = $("lblModuleId").getAttribute("moduleId");

	setRoadMapFromParStatus(par, wpolbas, "Y");	
	getExactLocation(moduleId, "Y");
	
	$("cancelRoadMap").observe("click", function(){
		winRoadMap.close();
	});
	
</script>