<div id="binderAdditionalInfoMainDiv" name="binderAdditionalInfoMainDiv">
	<div style="margin: 5px 0 1px 0; padding: 10px; border: 1px solid #E0E0E0;">
		<table>
			<tr>
				<td valign="top"><label class="rightAligned">Remarks</label></td>
				<td><textarea id="remarks" style="width: 400px; height: 100px; margin: 0 0 0 5px; resize: none;" readonly="readonly" tabindex="201"></textarea></td>
			</tr>
			<tr>
				<td></td>
				<td><input id="bndrRemarks1" name="bndrRemarks1" type="text" style="float: left; height: 13px; width: 400px; margin-left: 5px;" readonly="readonly" tabindex="202"/></td>
			</tr>
			<tr>
				<td></td>
				<td><input id="bndrRemarks2" name="bndrRemarks2" type="text" style="float: left; height: 13px; width: 400px; margin-left: 5px;" readonly="readonly" tabindex="203"/></td>
			</tr>
			<tr>
				<td></td>
				<td><input id="bndrRemarks3" name="bndrRemarks3" type="text" style="float: left; height: 13px; width: 400px; margin-left: 5px;" readonly="readonly" tabindex="204"/></td>
			</tr>
		</table>
	</div>
	
	<div style="height: 85px; padding: 10px; border: 1px solid #E0E0E0;">
		<table style="margin-left: 62px;">
			<tr>
				<td class="rightAligned">Accepted by (RI)</td>
				<td><input id="riAcceptBy" name="riAcceptBy" type="text" style="float: left; height: 13px; width: 290px; margin-left: 5px;" readonly="readonly" tabindex="301"/></td>
			</tr>
			<tr>
				<td class="rightAligned">As No (RI)</td>
				<td><input id="riAsNo" name="riAsNo" type="text" style="float: left; height: 13px; width: 290px; margin-left: 5px;" readonly="readonly" tabindex="302"/></td>
			</tr>
			<tr>
				<td class="rightAligned">Accept Date (RI)</td>
				<td><input id="riAcceptDate" name="riAcceptDate" type="text" style="float: left; height: 13px; width: 290px; margin-left: 5px;" readonly="readonly" tabindex="302"/></td>
			</tr>
		</table>
	</div>

	<div id="buttonDiv" align="center">
		<input id="btnClose" name="btnClose" class="button" value="Ok" style="width: 80px; margin: 10px 0 4px 0;" type="button" tabindex="401">
	</div>
</div>

<script type="text/javascript">
	$("remarks").focus();
	$("remarks").value = $F("hidRemarks"); 
	$("bndrRemarks1").value = $F("hidBndrRemarks1");
	$("bndrRemarks2").value = $F("hidBndrRemarks2");
	$("bndrRemarks3").value = $F("hidBndrRemarks3");
	$("riAcceptBy").value = $F("hidRiAcceptBy");
	$("riAsNo").value = $F("hidRiAsNo");
	$("riAcceptDate").value = $F("hidRiAcceptDate");

	$("btnClose").observe("click", function(){
		additionalInfoOverlay.close();
		delete additionalInfoOverlay;
	});
</script>