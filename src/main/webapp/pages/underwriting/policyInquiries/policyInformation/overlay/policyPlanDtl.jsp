<table style="margin:5 auto 0 auto;">
	<tr>
		<td class="rightAligned">Plan Code:</td>
		<td style="width:60px;">
			<input type="text" id="txtPlanCd" name="txtPlanCd" style="width:87%;" readonly="readonly"/>
		</td>
		<td class="rightAligned" style="width:120px;">Plan Change Tag</td>
		<td>
			<input type="checkbox" id="chkPlanChTag" name="chkPlanChTag" value="Y" readonly="readonly"/>
		</td>
	</tr>
	<tr>
		<td class="rightAligned">Plan Desc:</td>
		<td colspan="3">
			<input type="text" id="txtPlanDesc" name="txtPlanDesc" style="width:96%;" readonly="readonly"/>
		</td>
	</tr>
	<tr>
		<td colspan="4" align="center">
			<input type="button" class="button" id="btnReturn" value="Return"/>
		</td>
	</tr>
</table>

<script>

	try{
		
		var objPolPlanDtl = JSON.parse('${polPlanDtl}'.replace(/\\/g, '\\\\'));
		
	}catch(e){}
	
	if(objPolPlanDtl != null){
		
		$("txtPlanCd").value	= objPolPlanDtl.planCd;
		$("txtPlanDesc").value	= objPolPlanDtl.planDesc;
		
		if ($("chkPlanChTag").value == objPolPlanDtl.planChTag){
			$("chkPlanChTag").checked = true;
		}
	}
	
	$("btnReturn").observe("click", function(){
		overlayPlanDtl.close();
	});

</script>