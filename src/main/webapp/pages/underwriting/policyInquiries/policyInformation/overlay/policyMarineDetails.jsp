<div>
	<table style="margin:5px auto 0px auto;">
		<tr>
			<td style="padding-right: 5px;">Survey Agent</td>
			<td style="width:75px;">
				<input type="text" id="txtSurveyAgentCd" name="txtSurveyAgentCd" style="width:90%;" readonly="readonly"/>
			</td>
			<td style="width:300px;">
				<input type="text" id="txtSurveyAgent" name="txtSurveyAgent" style="width:97%;" readonly="readonly">
			</td>
		</tr>
		<tr>
			<td style="padding-right: 5px;">Settling Agent</td>
			<td>
				<input type="text" id="txtSettlingAgentCd" name="txtSettlingAgentCd" style="width:90%;" readonly="readonly"/>
			</td>
			<td>
				<input type="text" id="txtSettlingAgent" name="txtSettlingAgent" style="width:97%;" readonly="readonly"/>
			</td>
		</tr>
		
		<tr>
			<td colspan="3">
				<div style="text-align:center;margin:10px auto 10px auto;">
					<input type="button" class="button" id="btnOk" name="btnOk" value="Ok"/>
				</div>
			</td>
		</tr>
	</table>

</div>

<script>
	
	var objMarineDetails = JSON.parse('${marineDetails}'.replace(/\\/g, '\\\\'));

	$("txtSurveyAgentCd").value  =  objMarineDetails.surveyAgentCd;
	$("txtSurveyAgent").value  =  unescapeHTML2(objMarineDetails.surveyAgent);
	$("txtSettlingAgentCd").value  =  objMarineDetails.settlingAgentCd;
	$("txtSettlingAgent").value  =  unescapeHTML2(objMarineDetails.settlingAgent);
	
	
	$("btnOk").observe("click", function(){
		overlayMarineDetails.close();
	});
</script>