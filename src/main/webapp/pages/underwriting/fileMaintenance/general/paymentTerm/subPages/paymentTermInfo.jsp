<div id="payTermInfo" style="margin-top: 85px;">
	<table align="center">	
		<tr>
			<td class="rightAligned">Payment Term</td>
			<td colspan="2" class="leftAligned"><input type="text" id="txtPaytTerms" value="" style="width: 164px;" class="required upper" maxlength="3"/>
			<input type="hidden" id="txtLastValidPaytTerms" value="" style="width: 250px;" class="required upper" maxlength="3"/></td>
			<td></td>
		</tr>
		<tr>
			<td class="rightAligned">Description</td>
			<td colspan="3" class="leftAligned"><input type="text" id="txtPaytTermsDesc" value="" style="width: 625px;" class="required" maxlength="20"/>
			<input type="hidden" id="txtLastValidPaytTermsDesc" value="" style="width: 625px;" class="required" maxlength="20"/></td>
			<input type="hidden" id="txtPreviousPaytTermsDesc" value="" style="width: 625px;" class="required" maxlength="20"/>
		</tr>
		<tr>
			<td class="rightAligned">No. of Payments</td>
			<td class="leftAligned"><input type="text" id="txtNoOfPayt" value="" style="width: 164px;" class="required integerNoNegativeUnformatted rightAligned" maxlength="2"/>
			<input type="hidden" id="txtLastValidNoOfPayts" value="" style="width: 164px;" class="required integerNoNegativeUnformatted rightAligned" maxlength="2"/></td>
			<td width="30%">
					<input id="chkOnInceptTag" type="checkbox" style="float: left; margin: 0pt; width: 13px; height: 13px; overflow: hidden;"   name="chkOnInceptTag">
					<label for="chkOnInceptTag" style="float: left; margin-left: 3px;" title="OnInceptTag">On Incept Tag</label>
			</td><td></td>
		</tr>
		<tr>
			<td class="rightAligned">No. of Days</td>
			<td class="leftAligned"><input type="text" id="txtNoOfDays" value="" class="integerNoNegativeUnformatted rightAligned" style="width: 164px;" maxlength="3"/>
			<input type="hidden" id="txtLastValidNoOfDays" value="" style="width: 164px;" class="integerNoNegativeUnformatted rightAligned" maxlength="2"/></td>
			<td width="30%">
					<input id="chkAnnualSw" type="checkbox" style="float: left; margin: 0pt; width: 13px; height: 13px; overflow: hidden;"   name="chkAnnualSw">
					<label for="chkAnnualSw" style="float: left; margin-left: 3px;" title="AnnualSw">Annual Switch</label>
			</td><td></td>
		</tr>
		<tr>
			<!-- added by gab 11.03.2015 -->
			<td class="rightAligned">No. of Payment Days</td>
			<td colspan="2" class="leftAligned"><input type="text" id="txtPaytDays" value="" style="width: 164px;" class="integerNoNegativeUnformatted rightAligned" maxlength="3"/>
			<input type="hidden" id="txtLastValidPaytDays" value="" style="width: 250px;" class="integerNoNegativeUnformatted rightAligned" maxlength="3"/></td>
			<td></td>
		</tr>
		<tr>
			<td class="rightAligned">Remarks</td>
			<td colspan="3" class="leftAligned">
				<div style="border: 1px solid gray; height: 21px; width: 630px">
					<textarea id="txtRemarks" name="txtRemarks" style="border: none; height: 13px; resize: none; width: 600px" maxlength="4000"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="EditRemark" id="editRemarksText" tabindex=206/>
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">User ID</td>
			<td class="leftAligned"><input type="text" id="txtUserId" value="" readonly="readonly" style="width: 164px;"/></td>
			<td class="rightAligned">Last Update</td>
			<td class="leftAligned"><input type="text" id="txtLastUpdate" value="" style="width: 164px;" readonly="readonly"/></td>
		</tr>
	</table>
</div>

<div align="center" style="margin-top: 15px; margin-right: 20px;">
	<input type="button" class="button" id="btnAdd" name="btnAdd" value="Add" /> 
	<input type="button" class="disabledButton" id="btnDelete" name="btnDelete" value="Delete" />
</div>

<script type="text/javascript">
	$("txtNoOfPayt").value = 1;
	$("txtLastValidNoOfPayts").value = 1;
	$("chkOnInceptTag").checked = true;
	/* $("txtUserId").value = "${PARAMETERS['USER'].userId}";
	$("txtLastUpdate").value = dateFormat(new Date(), 'mm-dd-yyyy hh:M:ss TT'); */

	/* $("editRemarksText").observe("click", function() {
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"), function() {
			limitText($("txtRemarks"),4000);
		});
	});

	$("txtRemarks").observe("keyup", function() {
		limitText(this, 4000);
	}); */

	$("editRemarksText").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtPaytTerms").focus();
	
</script>
