<div  id="otherDtlsSectionDiv" class="sectionDiv" style="border: 0px;">
	<div style="width: 100%;">
		<table border="0" style="margin: 10px;" cellspacing="1"> 
			<tr>
				<td class="rightAligned" style="padding: 5px;">Owner</td>
				<td class="leftAligned"  style="width: 300px;"; colspan="3">
					<input type="text" id="mcTpClassName" value="" style="width: 60px; text-align: right;" readonly="readonly">
					<input type="text" id="mcTpPayee"  value="" style="width: 210px;" readonly="readonly">
				</td>
				<td class="rightAligned" style="padding:5px;">Basic Color</td>
				<td class="leftAligned" colspan="1">
					<input style="width: 180px;" id="mcTpBasicColor" name="mcTpBasicColor" type="text" value="" readonly="readonly" />
				</td>
			</tr>	
			<tr>
				<td class="rightAligned" style="padding:5px;">Plate No.</td>
				<td class="leftAligned"  >
					<input type="text" id="mcTpPlateNo" name="mcTpPlateNo" value="" class="upper" style="width: 90px; float: left;" readonly="readonly">
				</td>
				<td class="leftAligned" style="width:70px;">Model Year</td>
				<td>
					<input type="text" id="mcTpModelYear" name="mcTpPlateNo" value="" style="width: 90px; float: left;" readonly="readonly" class="integerNoNegativeUnformatted">		
				</td>
				<td class="rightAligned" style="padding: 5px;">Color</td>
				<td class="leftAligned" colspan="1">
					<input style="width: 180px;" id="mcTpColor" name="mcTpColor" type="text" value="" readonly="readonly" />
				</td>
			</tr>	
			<tr>
				<td class="rightAligned" style="padding: 5px;">Motor No.</td>
				<td class="leftAligned" colspan="3" >
					<input type="text" id="mcTpMotorNo" name="mcTpMotorNo" class="upper" value="" style="width: 280px; float: left;" readonly="readonly">
				</td>
				<td class="rightAligned" style="padding: 5px;">Car Company</td>
				<td class="leftAligned" colspan="1">
					<input style="width: 180px;" id="mcTpCarCompany" name="mcTpCarCompany" type="text" value="" readonly="readonly" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding: 5px;">Serial No.</td>
				<td class="leftAligned" colspan="3" >
					<input type="text" id="mcTpSerialNo" name="mcTpSerialNo" class="upper" value="" style="width: 280px; float: left;" readonly="readonly">
				</td>
				<td class="rightAligned" style="padding: 5px;">Make</td>
				<td class="leftAligned" colspan="1">
					<input style="width: 180px;" id="mcTpMakeCd" name="mcTpMakeCd" type="text" value="" readonly="readonly" />
				</td>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding: 5px;">Motor Type</td>
				<td class="leftAligned" colspan="3" >
					<input type="text" id="mcTpMotorType" name="mcTpMotorType" class="upper" value="" style="width: 280px; float: left;" readonly="readonly">
				</td>
				<td class="rightAligned" style="padding: 5px;">Engine Series</td>
				<td class="leftAligned" colspan="1">
					<input style="width: 180px;" id="mcTpEngineSeries" name="mcTpEngineSeries" type="text" value="" readonly="readonly" />
				</td>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding: 5px; width: 80px;" id="mcTpRiLabel">TP Reinsurer</td>
				<td class="leftAligned"  style="width: 600px;" colspan="7">
					<input type="text" id="mcTpRiCd" value="" style="width: 60px; text-align: right;" readonly="readonly">
					<input type="text" id="mcTpRiName"  value="" style="width: 513px;" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding: 5px;">Other Info</td>
				<td class="leftAligned" colspan="7" >
				<div style="border: 1px solid gray; height: 20px; width: 590px; margin-top: 3px;">
					<textarea style="width: 550px; border: none; height: 13px; resize:none;" id="mcTpOtherInfo" name="mcTpOtherInfo" readonly="readonly"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editMcTpOtherInfo" id="editMcTpOtherInfo"/>
				</div>
				</td>
			</tr>
		</table>
		<table border="0" style="margin: 10px; margin-top: 0px;"> 
			<tr>
				<td colspan="7"><div style="border-top: 1.25px solid #c0c0c0; margin: 10px 0;"></div></td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding: 5px; width: 80px;">Driver Name</td>
				<td class="leftAligned"  style="width: 450px;"; colspan="1">
					<input type="text" id="mcTpDriverName" value="" style="width: 430px; text-align: left;" class="upper" readonly="readonly"/>
				</td>
				<td class="rightAligned" style="padding: 5px;">Age</td>
				<td class="leftAligned" colspan="1">
					<input type="text" id="mcTpDriverAge" name="mcTpDriverAge" value="" style="width: 96px;" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding: 5px;">Occupation</td>
				<td class="leftAligned"  style="width: 450px;"; colspan="1">
					<input type="text" id="mcTpDriverOccptn" value="" style="width: 430px; text-align: left;" readonly="readonly">
				</td>
				</td>
				<td class="rightAligned" style="padding: 5px;">Sex</td>
				<td class="leftAligned" >
					<input type="text" id="mcTpSex" name="mcTpSex" value="" style="width: 96px;" readonly="readonly"/>
				</td>
			</tr>
		</table>
	</div>
	<div class="buttonsDiv" align="center" style="margin-bottom: 5px;">
		<input type="button" id="btnReturn" 	 name="btnReturn" 	   style="width: 120px;" class="button hover"  value="Return" />
	</div>
</div>

<script type="text/javascript">
	try{
		var objMcTpDtl = JSON.parse('${mcTpDtl}');
		
		function populateMcTpOtherDtls(obj){
			$("mcTpClassName").value = unescapeHTML2(obj.classDesc);
			$("mcTpPayee").value = unescapeHTML2(obj.payeeDesc);
			$("mcTpBasicColor").value = unescapeHTML2(obj.basicColorDesc);
			$("mcTpPlateNo").value = unescapeHTML2(obj.plateNo);
			$("mcTpModelYear").value = unescapeHTML2(obj.modelYear);
			$("mcTpColor").value = unescapeHTML2(obj.colorDesc);
			$("mcTpMotorNo").value = unescapeHTML2(obj.motorNo);
			$("mcTpCarCompany").value = unescapeHTML2(obj.carComDesc);
			$("mcTpSerialNo").value = unescapeHTML2(obj.serialNo);
			$("mcTpMakeCd").value = unescapeHTML2(obj.makeDesc);
			$("mcTpMotorType").value = unescapeHTML2(obj.motorTypeDesc);
			$("mcTpEngineSeries").value = unescapeHTML2(obj.engineSeries);
			$("mcTpRiCd").value = obj.riCd;
			$("mcTpRiName").value = unescapeHTML2(obj.riName);
			$("mcTpOtherInfo").value = unescapeHTML2(obj.otherInfo);
			$("mcTpDriverName").value = unescapeHTML2(obj.drvrName);
			$("mcTpDriverAge").value = obj.drvrAge;
			$("mcTpDriverOccptn").value = unescapeHTML2(obj.drvrOccDesc);
			$("mcTpSex").value  = unescapeHTML2(obj.drvrSex == "M" ? "Male" : (obj.drvrSex== "F" ? "Female" : ""));
			$("mcTpRiLabel").innerHTML = obj.tpType == "A" ? "AP Insurance Co." : "TP Reinsurer";
// 			$("editMcTpOtherInfo").hide();
		}
		
		populateMcTpOtherDtls(objMcTpDtl);
		
		$("editMcTpOtherInfo").observe("click", function(){showOverlayEditor("mcTpOtherInfo", 2000, 'true');});
		
		$("btnReturn").observe("click", function(){
			Windows.close("mc_other_dtls_canvas");
		});
		
	}catch(e){
		showErrorMessage("Claims Information- MC TP Other Details", e);
	}
	
</script>