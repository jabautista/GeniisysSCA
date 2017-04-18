<div id="polReportJCL13" style="width: 405px; float: left;">
	<table align="center" style="">
		<tr>
			<td class="rightAligned" width="100px">Case No. </td>
			<td class="leftAligned" width="">
				<input type="text" id="caseNo" name="caseNo" style="margin-left: 10px; width: 200px;" value="${caseNo}" maxlength="30"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="">Versus </td>
			<td class="leftAligned" width="">
				<input type="text" id="versusA" name="versusA" style="margin-left: 10px; width: 200px;" value="${versusA}" maxlength="30"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width=""> </td>
			<td class="leftAligned" width="">
				<input type="text" id="versusB" name="versusB" style="margin-left: 10px; width: 200px;" value="${versusB}" maxlength="30"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width=""> </td>
			<td class="leftAligned" width="">
				<input type="text" id="versusC" name="versusC" style="margin-left: 10px; width: 200px;" value="${versusC}" maxlength="30"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="">Sheriff's Location </td>
			<td class="leftAligned" width="">
				<input type="text" id="sheriffLoc" name="sheriffLoc" style="margin-left: 10px; width: 200px;" value="${sheriffLoc}" maxlength="30"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="">Issue Date </td>
			<td class="leftAligned" width="">
				<%-- <input type="text" id="dateIssued" name="dateIssued" style="margin-left: 10px; width: 200px;" value="${dateIssued}" /> --%>
				<div style="float:left; border: solid 1px gray; width: 206px; height: 21px; margin-left: 10px;">
		    		<input style="width: 178px; height: 13px; border: none;" id="dateIssued" name="dateIssued" type="text" value="${dateIssued}" readonly="readonly"/>
		    		<img id="hrefDateIssued" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('dateIssued'),this, null);" alt="dateIssued" class="hover" />
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="">Judge </td>
			<td class="leftAligned" width="">
				<input type="text" id="judge" name="judge" style="margin-left: 10px; width: 200px;" value="${judge}" maxlength="50"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="">Signatory </td>
			<td class="leftAligned" width="">
				<input type="text" id="signatory" name="signatory" style="margin-left: 10px; width: 200px;" value="${signatory}" maxlength="50"/>
			</td>
		</tr>		
	</table>
</div>
<script>
	if($F("dateIssued").trim() == ""){
		$("dateIssued").value = '${sysdate}';
	}
	observeBackSpaceOnDate("dateIssued");
	$("caseNo").focus();
</script>