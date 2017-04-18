<div id="leAdviceMainDiv">
	<div style="margin-top: 10px; width: 350px;">
		<table border="0" align="center" style="margin-top: 5px; margin-bottom: 5px;">
			<tr>
				<td class="leftAligned" style="width: 100px;">Advice Number</td>	
				<td class="leftAligned" > <input type="text" id="txtLEAdviceNo" name="txtLEAdviceNo" style="width: 180px;" readonly="readonly"></td>
			</tr>
			<tr>
				<td class="leftAligned" >CSR Number</td>	
				<td class="leftAligned" > <input type="text" id="txtLECSRNo" name="txtLECSRNo" style="width: 180px;" readonly="readonly"></td>
			</tr>
		</table>
	</div>
</div>
<div id="buttonsDiv" style="text-align: center; margin-bottom: 5px; margin-top: 10px;">
	<input type="button" class="button" id="btnOk" value="Return" style="width: 120px;"/>
</div>

<script type="text/javascript">
	var advice = JSON.parse('${jsonAdvice}');
	
	$("txtLEAdviceNo").value = unescapeHTML2(advice.adviceNo);
	$("txtLECSRNo").value = unescapeHTML2(advice.csrNo);
	
	$("btnOk").observe("click", function(){
		Windows.close("view_advice_canvas");
	});
</script>