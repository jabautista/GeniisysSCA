<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<div id="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" >
   		<label>O.R. Information</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label name="gro" style="margin-left: 5px;">Hide</label>
	   		<label id="reloadForm" name="reloadForm">Reload Form</label>
   		</span>
   	</div>
</div>
<div class="sectionDiv" id="dcbInformationOuterDiv">
	<input type="hidden" id="gaccTranId" 				name="gaccTranId" 					value="${gacc.tranId }" />
	<input type="hidden" id="gaccGfunFundCd" 			name="gaccGfunFundCd" 				value="${gacc.gfunFundCd }" />
	<input type="hidden" id="gaccGibrBranchCd" 			name="gaccGibrBranchCd" 			value="${gacc.branchCd }" />
	<input type="hidden" id="gaccDspDCBFlag" 			name="gaccDspDCBFlag" 				value="${gacc.dcbFlag }" />
	<input type="hidden" id="gaccTranFlag" 				name="gaccTranFlag" 				value="${gacc.tranFlag }" />
	
	<div id="dcbInformationHeader" style="margin: 10px;">
		<table width="750px" align="center" cellspacing="1" border="0">
 			<tr>
				<td class="rightAligned" width="20%">Company</td>
				<td class="leftAligned" width="30%">
					<input id="gaccDspFundDesc" name="dspFundDesc" style="width: 250px;" type="text" value="${gacc.fundDesc }" readonly="readonly"/>
				</td>
				<td class="rightAligned" width="20%">Branch</td>
				<td class="leftAligned" width="30%">
					<input id="gaccDspBranchName" name="dspBranchName" style="width: 250px;" type="text" value="${gacc.branchName }" readonly="readonly"/>
				</td>
			</tr>
		</table>				
	</div>
</div>
<div class="sectionDiv" id="tranInfoOuterDiv">
	<table width="80%" align="center" style="margin-left: 110px;">
		<tr>
			<td class="rightAligned" width="12%">Tran No.</td>
			<td class="leftAligned" width="21%">
				<input id="dspTranNo" name="dspTranNo" style="width: 140px;" type="text" value="${gacc.tranYear} - ${gacc.tranMonth} - ${gacc.tranSeqNo}" readonly="readonly" />
			</td>
			<td class="rightAligned" width="15%">Tran Date</td>
			<td class="leftAligned" width="21%">
				<input id="dspTranDate" name="dspTranDate" style="width: 140px;" type="text" readonly="readonly" value="<fmt:formatDate value="${gacc.tranDate}" pattern="MM-dd-yyyy" />"/>
			</td>
			<td class="rightAligned" width="15%">Tran Flag</td>
			<td class="leftAligned" width="21%">
				<input id="dspTranFlag" name="dspTranFlag" style="width: 140px;" type="text" value="${gacc.meanTranFlag}" readonly="readonly" />
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="12%">Tran Class</td>
			<td class="leftAligned" width="21%">
				<input id="dspTranClass" name="dspTranClass" style="width: 140px;" type="text" value="${gacc.tranClass}" readonly="readonly" />
			</td>
			<td class="rightAligned" width="15%">Tran Class No.</td>
			<td class="leftAligned" width="21%">
				<input id="dspTranClassNo" name="dspTranClassNo" style="width: 140px;" type="text" value="${gacc.tranClassNo}" readonly="readonly"/>
			</td>
		</tr>
	</table>
</div>