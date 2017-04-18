<div style="width: 405px; float: left;">
	<table align="center" style="">
		<tr>
			<td class="rightAligned" width="130px">Register of Deeds No. </td>
			<td class="leftAligned" width="">
				<input type="text" id="regDeedNo" style="margin-left: 10px; width: 200px;" name="regDeedNo" value="${regDeedNo}"  maxlength="300"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="">Register of Deeds </td>
			<td class="leftAligned" width="">
				<input type="text" id="regDeed" style="margin-left: 10px; width: 200px;" name="regDeed" value="${regDeed}" maxlength="300"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="">Date Issued </td>
			<td class="leftAligned" width="">
				<%-- <input type="text" id="dateIssued" style="margin-left: 10px; width: 200px;" name="dateIssued" value="${dateIssued}" /> --%>
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
	$("regDeedNo").focus();
</script>