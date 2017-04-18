<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Claim Information</label>
	   		<span class="refreshers" style="margin-top: 0;">
	   			<label name="gro" style="margin-left: 5px;">Hide</label>
	   			<label id="reloadForm" name="reloadForm">Reload Form</label>
	   		</span>
	   	</div>
</div>
<div id="claimsInfoSectionDiv" class="sectionDiv" style="height: 120px;" >
	<div id="parInfo" name="parInfoTop" style="margin: 10px;">
		<table border="0" align="center">
			<tr>
				<td class="rightAligned" id="lblClmNo">Claim Number </td>
				<td class="leftAligned" >
					<input type="text" style="width: 250px;" name="txtClaimNo" id="txtClaimNo" readonly="readonly"/>
				</td>
				<td class="rightAligned" style="width: 100px;" id="lblClmNo">Loss Category </td>
				<td class="leftAligned" >
					<input type="text" style="width: 250px;" name="txtLossCtgry" id="txtLossCtgry" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" id="lblPolNo">Policy Number </td>
				<td class="leftAligned" >
					<input type="text" style="width: 250px;" name="txtPolicyNo" id="txtPolicyNo" readonly="readonly"/>
				</td>
				<td class="rightAligned" id="lblClmNo">Loss Date </td>
				<td class="leftAligned" >
					<input type="text" style="width: 250px;" name="txtLossDate" id="txtLossDate" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" id="lblAssured">Assured Name</td>
				<td class="leftAligned" >
					<input type="text" style="width: 250px;" name="txtAssdName" id="txtAssdName" readonly="readonly"/>
				</td>	
			</tr>
		</table>
	</div>
	<input type="hidden"  id="claimId"  name="claimId" value=""/>
	<input type="hidden"  id="assdNo"   name="assdNo" value=""/> 
	<input type="hidden"  id="lineCd"   name="lineCd" value=""/> 
</div>
<script type="text/javascript">
	var objGICLClaims = JSON.parse('${objGICLClaims}');
	populateClaimInfo(objGICLClaims);
	
	function populateClaimInfo(obj){
		$("txtClaimNo").value 			= obj == null ? "" : unescapeHTML2(nvl(obj.claimNumber,obj.claimNo));
		$("txtPolicyNo").value 			= obj == null ? "" : unescapeHTML2(obj.policyNo);
		$("txtAssdName").value 			= obj == null ? "" : unescapeHTML2(obj.assuredName);
		$("txtLossCtgry").value 		= obj == null ? "" : unescapeHTML2(obj.lossCtgry) == "" ? objCLMGlobal.lossCatCd + "-" + unescapeHTML2(nvl(objCLMGlobal.lossCatDes,objCLMGlobal.dspLossCatDesc)):unescapeHTML2(obj.lossCtgry);
		$("txtLossDate").value 			= obj == null ? "" : unescapeHTML2(obj.strDspLossDate2);
		$("lineCd").value 			    = obj == null ? "" : unescapeHTML2(obj.lineCd);
		
	}
</script>
