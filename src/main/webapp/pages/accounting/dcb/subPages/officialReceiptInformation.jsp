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
	<!-- GACC Block Fields -->
	<input type="hidden" id="gaccTranId" 				name="gaccTranId" 					value="${gacc.tranId }" />
	<input type="hidden" id="gaccGfunFundCd" 			name="gaccGfunFundCd" 				value="${gacc.gfunFundCd }" />
	<input type="hidden" id="gaccGibrBranchCd" 			name="gaccGibrBranchCd" 			value="${gacc.branchCd }" />
	<input type="hidden" id="gaccDspDCBFlag" 			name="gaccDspDCBFlag" 				value="${gacc.dcbFlag }" />
	<input type="hidden" id="gaccTranFlag" 				name="gaccTranFlag" 				value="${gacc.tranFlag }" />
	<input type="hidden" id="gaccDspGdbdSumAmount" 		name="gaccDspGdbdSumAmount" 		value="" />
	<input type="hidden" id="gaccParticulars"			name="gaccParticulars"				value="${gacc.particulars}" />
	
	<div id="dcbInformationHeader" style="margin: 10px;">
		<table width="750px" align="center" cellspacing="1" border="0">
 			<tr>
				<td class="rightAligned" style="width: 55px;">Company</td>
				<td class="leftAligned">
					<div style="border: 1px solid gray; width: 250px; height: 21px; float: left; background-color: #FFFACD">
						<input id="gaccDspFundDesc" name="gaccDspFundDesc" style="width: 224px; border: none; float: left; height: 13px;" class="required" type="text" value="${gacc.fundDesc }"/>
						<%-- <c:if test="${ora2010Sw eq 'Y'}"> --%>
						<c:if test="${gacc eq null}">
							<img style="float: right; background-color: transparent" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmGaccCompany" name="oscmGaccCompany" alt="Go" />
						</c:if>
					</div>
				</td>
				<td class="rightAligned" style="width: 103px;">Branch</td>
				<td class="leftAligned">
					<div style="border: 1px solid gray; width: 276px; height: 21px; float: left; background-color: #FFFACD">
						<input id="gaccDspBranchName" name="gaccDspBranchName" style="width: 250px; border: none; float: left; height: 13px;" class="required" type="text" value="${gacc.branchName }"/>
						<c:if test="${gacc eq null}">
							<img style="float: right; background-color: transparent" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmGaccBranch" name="oscmGaccBranch" alt="Go" />
						</c:if>
					</div>
				</td>
			</tr>
		</table>
	</div>
	
	<div class="sectionDiv" style="border-left: white; border-right: white; border-bottom: white;" id="dcbInformationDiv" style="margin-top: -2px;" changeTagAttr="true">
		<table width="900px" align="center" cellspacing="1" border="0">
			<tr>
				<td class="rightAligned" style="width: 64px;">DCB Date</td>
				<td class="leftAligned">
					<div style="border: 1px solid gray; width: 116px; height: 21px; float: left; background-color: #FFFACD">
						<input id="gaccDspDCBDate" name="gaccDspDCBDate" tranMonth="" style="width: 90px; border: none; float: left; height: 13px;" class="required" type="text" value="<fmt:formatDate value="${gacc.dcbDate}" pattern="MM-dd-yyyy" />" readonly="readonly"/> <!-- Deo [09.01.2016]: replace gacc.tranDate with gacc.dcbDate (SR-5631) -->
						<c:if test="${gacc eq null}">
							<img style="float: right; background-color: transparent" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmGaccDCBDate" name="oscmGaccDCBDate" alt="Go" />
						</c:if>
					</div>
				</td>
				<td class="rightAligned" style="width: 57px;">DCB No</td>
				<td class="leftAligned">
					<input type="text" id="gaccDspDCBYear" name="gaccDspDCBYear" style="width: 70px; text-align: right" class="required" value="${gacc.tranYear }" readonly="readonly"/>
					<input id="gaccDspDCBNo" name="gaccDspDCBNo" style="width: 80px; text-align: right" class="required" type="text" value="${gacc.tranClassNo }" />
					<c:if test="${gacc eq null}">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmGaccDCBNo" name="oscmGaccDCBNo" alt="Go" />
					</c:if>
				</td>
				<td class="rightAligned" style="width: 60px;">DCB Flag</td>
				<td class="leftAligned">
					<input type="text" id="gaccMeanDCBFlag" name="gaccMeanDCBFlag" style="width: 130px" value="${gacc.meanDCBFlag }" readonly="readonly"/>
				</td>
				<td class="rightAligned" style="width: 60px;">Tran Flag</td>
				<td class="leftAligned">
					<input type="text" id="gaccMeanTranFlag" name="gaccMeanTranFlag" style="width: 90px" class="required" value="${gacc.meanTranFlag }" readonly="readonly"/>
				</td>
			</tr>
		</table>
	</div>
</div>
<script type="text/javascript">
</script>