<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="outerDiv">
			<label id="">Package Initial Acceptance</label> 
			<span class="refreshers" style="margin-top: 0;">
			 	<label name="gro" style="margin-left: 5px;">Hide</label> 
			 	<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	<div id="riPackParCreationSectionDiv" class="sectionDiv" style="padding-bottom: 15px; padding-top: 15px;" changeTagAttr="true">
		<table width="80%" align="center" cellspacing="1" border="0">
			<tr>
				<td class="rightAligned" style="width: 20%;">Line of Business </td>
				<td class="leftAligned" style="width: 30%;">
					<select id="packLineCd" name="packLineCd" style="width: 99%;" value="${txtLineCd}" class="required">
						<option></option>
						<c:forEach var="line" items="${lineListing}">
							<option value="${line.lineCd}" ">${line.lineName}</option>				
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" style="width: 20%;">Issuing Source </td>
				<td class="leftAligned" style="width: 30%;">
					<select id="packIssCd" name="packIssCd" style="width: 99%;" disabled="disabled" >
						<option value="${defaultIssCd }">REINSURANCE</option>
						
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 20%;">Year </td>
				<td class="leftAligned" style="width: 30%;">
					<input id="packYear" class="leftAligned required" type="text" name="packYear" style="width: 95%;" value="${year}" maxlength="2"/>
				</td>
				<td class="rightAligned" style="width: 20%;">Pack PAR Sequence No. </td>
				<td class="leftAligned" style="width: 30%;">
					<input id="packParSeqNo" class="leftAligned" type="text" name="packParSeqNo" style="width: 95%;" readonly="readonly" value="${savedPAR.parSeqNo}"/>
				</td>
			</tr>			
			<tr>
				<td class="rightAligned" style="width: 20%;">Quote Sequence No. </td>
				<td class="leftAligned" style="width: 30%;">
					<input id="packQuoteSeqNo" class="leftAligned required" type="text" name="packQuoteSeqNo" style="width: 95%;" readonly="readonly" value="00"/>
				</td>
				<td id="assdTitle" class="rightAligned" style="width: 20%;">Assured Name </td>
				<td class="leftAligned" style="width: 30%;">
					<span style="border: 1px solid gray; width: 98%; height: 21px; float: left;" class="required"> 
						<input type="text" id="assuredName" name="assuredName" style="border: none; float: left; width: 87%;" class="required" readonly="readonly" /> 
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="btnSearchPackAssuredName" name="btnSearchPackAssuredName" alt="Go" />
					</span>	
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width:20%;">Remarks </td>
				<td class="leftAligned" colspan="3" style="width: 80%;">
					<div style="border: 1px solid gray; height: 20px; width: 99%;"> <!--SR2817 lmbeltran 091115 -->
						<textarea id="packRemarks" class="leftAligned" name="packRemarks" style="width: 95%; border: none; height: 13px;"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editPackRemarks" />
					</div>
					<%-- <span id="remarksSpan" style="border: 1px solid gray; width: 585px; height: 21px; float: left;"> 
						<input type="text" id="packRemarks" name="packRemarks" style="border: none; float: left; width: 95%; background: transparent;" onKeyDown="limitText(this, 4000);" onKeyUp="limitText(this, 4000);"/> 
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" id="btnPackRemarks" name="btnPackRemarks" alt="Go" style="background: transparent;" />
					</span> --%>
				</td>
			</tr>
			
		</table>
	</div>
</div>

<script>
	var test = "${lineListing}";
	
	$("btnSearchPackAssuredName").observe("click", showAssuredListingTG /*openSearchClientModal*/);
	
	$("editPackRemarks").observe("click", function () { //SR2817 lmbeltran 091115
		showEditor("packRemarks", 4000);
	});

	$("packRemarks").observe("keyup", function () {
		limitText(this, 4000);
	});
	
	/* $("btnPackRemarks").observe("click", function () {
		showEditor("packRemarks", 4000);
	}); */
</script>