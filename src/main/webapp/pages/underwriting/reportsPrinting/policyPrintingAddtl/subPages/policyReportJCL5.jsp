<div id="polReportJCL5" name="polReportJCL5" style="width: 405px; float: left;">
	<table align="center" style="margin-right: 20px; float: left;">
		<tr>
			<td class="rightAligned" width="160px">Particulars </td>
			<td class="leftAligned" width="">
				<input type="text" id="partA" name="partA" style="margin-left: 10px; width: 200px;" value="${partA}" maxlength="30"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width=""> </td>
			<td class="leftAligned" width="">
				<input type="text" id="partB" name="partB" style="margin-left: 10px; width: 200px;" value="${partB}" maxlength="30" />
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width=""> </td>
			<td class="leftAligned" width="">
				<input type="text" id="partC" name="partC" style="margin-left: 10px; width: 200px;" value="${partC}" maxlength="30" />
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width=""> </td>
			<td class="leftAligned" width="">
				<input type="text" id="partD" name="partD" style="margin-left: 10px; width: 200px;" value="${partD}" maxlength="30" />
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width=""> </td>
			<td class="leftAligned" width="">
				<input type="text" id="partE" name="partE" style="margin-left: 10px; width: 200px;" value="${partE}" maxlength="30" />
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width=""> </td>
			<td class="leftAligned" width="">
				<input type="text" id="partF" name="partF" style="margin-left: 10px; width: 200px;" value="${partF}" maxlength="30" />
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="">Branch </td>
			<td class="leftAligned" width="">
				<input type="text" id="branch" name="branch" style="margin-left: 10px; width: 200px;" value="${branch}" maxlength="30"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="">Branch Location </td>
			<td class="leftAligned" width="">
				<input type="text" id="branchLoc" name="jBranchLoc" style="margin-left: 10px; width: 200px;" value="${branchLoc}" maxlength="30"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="">Judge </td>
			<td class="leftAligned" width="">
				<input type="text" id="judge" name="judge" style="margin-left: 10px; width: 200px;" value="${judge}" maxlength="50"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="">Appointing Date </td>
			<td class="leftAligned" width="">
				<%-- <input type="text" id="appDate" name="appDate" style="margin-left: 10px; width: 200px;" value="${appDate}" /> --%>
				<div style="float:left; border: solid 1px gray; width: 206px; height: 21px; margin-left: 10px;">
		    		<input style="width: 178px; height: 13px; border: none;" id="appDate" name="appDate" type="text" value="${appDate}" readonly="readonly"/>
		    		<img id="hrefAppDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('appDate'),this, null);" alt="appDate" class="hover" />
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="">Appointed Person/Guardian </td>
			<td class="leftAligned" width="">
				<input type="text" id="guardian" name=""guardian"" style="margin-left: 10px; width: 200px;" value="${guardian}"  maxlength="50"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="">Signed in the Presence Of </td>
			<td class="leftAligned" width="">
				<input type="text" id="signAJCL5" name="signAJCL5" style="margin-left: 10px; width: 200px;" value="${signAJCL5}"  maxlength="30"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width=""> </td>
			<td class="leftAligned" width="">
				<input type="text" id="signBJCL5" name="signBJCL5" style="margin-left: 10px; width: 200px;" value="${signBJCL5}"  maxlength="30"/>
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
	</table>
</div>
<script>
	if($F("dateIssued").trim() == ""){
		$("dateIssued").value = '${sysdate}';
	}
	observeBackSpaceOnDate("dateIssued");
	observeBackSpaceOnDate("appDate");
	$("partA").focus();
</script>