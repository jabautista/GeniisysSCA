<div id="settlingSurveyMainDiv">
	<div style="margin-top: 10px; width: 623px;">
		<table border="0" align="center" style="margin-top: 5px; margin-bottom: 5px;">
			<tr>
				<td class="leftAligned" style="width: 100px;">Survey Agent</td>	
				<td class="leftAligned" > <input type="text" id="txtSurveyAgentCd" name="txtSurveyAgentCd" style="width: 80px;" readonly="readonly"></td>
				<td class="leftAligned" > <input type="text" id="txtDspSurveyName" name="txtDspSurveyName" style="width: 350px;" readonly="readonly"></td>
			</tr>
			<tr>
				<td class="leftAligned" >Settling Agent</td>	
				<td class="leftAligned" > <input type="text" id="txtSettlingAgentCd" name="txtSettlingAgentCd" style="width: 80px;" readonly="readonly"></td>
				<td class="leftAligned" > <input type="text" id="txtDspSettlingName" name="txtDspSettlingName" style="width: 350px;" readonly="readonly"></td>
			</tr>
		</table>
	</div>
</div>
<div id="buttonsDiv" style="text-align: center; margin-bottom: 5px; margin-top: 10px;">
	<input type="button" class="button" id="btnOk" value="Return" style="width: 120px;"/>
</div>
<script>

	$("txtSurveyAgentCd").value = objCLMGlobal.surveyAgentCode;
	$("txtDspSurveyName").value = unescapeHTML2(objCLMGlobal.dspSurveyName);
	$("txtSettlingAgentCd").value = objCLMGlobal.settlingAgentCode;
	$("txtDspSettlingName").value = unescapeHTML2(objCLMGlobal.dspSettlingName);
	
	$("btnOk").observe("click", function(){
		Windows.close("survey_settling_canvas");
	});
	
</script>