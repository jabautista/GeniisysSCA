<div style="width: 405px; float: left;">
	<table align="center" style="">
		<tr>
			<td class="rightAligned" width="90px">Complainant </td>
			<td class="leftAligned" width="">
				<input type="text" id="complainant" name="complainant" style="margin-left: 10px; width: 200px;" value="${complainant}" maxlength="50"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="">Versus </td>
			<td class="leftAligned" width="">
				<input type="text" id="versus" name="versus" style="margin-left: 10px; width: 200px;" value="${versus}"  maxlength="50"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="">Judge </td>
			<td class="leftAligned" width="">
				<input type="text" id="judge" name="judge" style="margin-left: 10px; width: 200px;" value="${judge}" maxlength="50"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="">Section </td>
			<td class="leftAligned" width="">
				<input type="text" id="section" name="section" style="margin-left: 10px; width: 200px;" value="${section}" maxlength="30"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="">Rule </td>
			<td class="leftAligned" width="">
				<input type="text" id="rule" name="rule" style="margin-left: 10px; width: 200px;" value="${rule}" maxlength="30"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="">Date Issued </td>
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
	$("complainant").focus();
</script>