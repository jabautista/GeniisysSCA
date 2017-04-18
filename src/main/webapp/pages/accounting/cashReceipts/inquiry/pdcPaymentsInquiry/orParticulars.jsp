<div id="orParticularsDiv" style="width:600px; margin: 0 auto;">
	<div class="sectionDiv" style="margin: 7px auto 0; padding: 5px 0;">
		<table align="center">
			<tr>
				<td class="leftAligned">Payor</td>
				<td colspan="3">
					<input type="text" id="txtPayor" readonly="readonly" style="width: 500px;" tabindex="1001"/>
				</td>
			</tr>
			<tr>
				<td class="leftAligned">Address</td>
				<td>
					<input type="text" id="txtAddress1" readonly="readonly" style="width: 250px;" tabindex="1002" />
				</td>
				<td class="leftAligned">TIN</td>
				<td class="rightAligned">
					<input type="text" id="txtTin" readonly="readonly" style="text-align: right;" tabindex="1005"/>
				</td>
			</tr>
			<tr>
				<td></td>
				<td>
					<input type="text" id="txtAddress2" readonly="readonly" style="width: 250px;" tabindex="1003" />
				</td>
				<td class="leftAligned">OR No.</td>
				<td class="rightAligned">
					<input type="text" id="txtORNo" readonly="readonly" style="text-align: right;" tabindex="1006" />
				</td>
			</tr>
			<tr>
				<td></td>
				<td>
					<input type="text" id="txtAddress3" readonly="readonly" style="width: 250px;" tabindex="1004" />
				</td>
				<td class="leftAligned">OR Date.</td>
				<td class="rightAligned">
					<input type="text" id="txtORDate" readonly="readonly" tabindex="1007"/>
				</td>
			</tr>
			<tr>
				<td class="leftAligned">Particulars</td>
				<td colspan="3">
					<input type="text" id="txtParticulars" readonly="readonly" style="width: 500px;" tabindex="1008"/>
				</td>
			</tr>
		</table>
		<center><input type="button" class="button" id="btnReturn" value="Return" style="margin-top: 5px; width: 100px;" tabindex="1009"/></center>
	</div>
</div>
<script type="text/javascript">
	try {
		
		$("txtPayor").value = unescapeHTML2(objGIACS092.payor);
		$("txtAddress1").value = unescapeHTML2(objGIACS092.address1);
		$("txtAddress2").value = unescapeHTML2(objGIACS092.address2);
		$("txtAddress3").value = unescapeHTML2(objGIACS092.address3);
		$("txtTin").value = objGIACS092.tin;
		$("txtORNo").value = objGIACS092.orNo;
		$("txtORDate").value = objGIACS092.orDate;
		$("txtParticulars").value = unescapeHTML2(objGIACS092.particulars);
		$("txtPayor").focus();
		
		$("btnReturn").observe("click", function(){
			overlayORParticulars.close();
			delete overlayORParticulars;
		});
	} catch (e) {
		showErrorMessage("Error : " , e);
	}
</script>