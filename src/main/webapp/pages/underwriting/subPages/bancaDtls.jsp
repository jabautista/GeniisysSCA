<div id="bancaDetailsDiv">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Bancassurance Details</label>
			<span class="refreshers" style="margin-top: 0;">
		  		<label id="showBancaDetails" name="gro" style="margin-left: 5px;">Show</label>
		   	</span>
		</div>
	</div>
	<div id="bancaDetailsInfo" class="sectionDiv" style="display: none;">
		<div id="bankPaymentDetailsSecDiv" style="margin:10px auto;">
			<table width="100%" border="0">
				<tr>
					<td class="rightAligned" width="30%">Bancassurance Type</td>
					<td class="leftAligned">
						<select id="selBancTypeCd" name="selBancTypeCd" style="width:450px;" class="required">
							<option value=""></option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Area</td>
					<td class="leftAligned">
						<select id="selAreaCd" name="selAreaCd" style="width:450px;" class="required">
							<option value=""></option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Branch</td>
					<td class="leftAligned">
						<select id="selBranchCd" name="selBranchCd" style="width:450px;" class="required">
							<option value=""></option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Manager</td>
					<td class="leftAligned">
						<input type="text" id="dspManagerCd" name="dspManagerCd" value="" readonly="readonly" style="width:50px;" class="required"/>
						<input type="text" id="dspManagerName" name="dspManagerName" value="" readonly="readonly" style="width:380px;" class="required"/>
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>	
<script type="text/javascript">
	//for Bancassurance details
	checkBancassurance();
	$("bancaTag").observe("change", function(){
		checkBancassurance();	
	});	
	$("btnBancaDetails").observe("click", function(){
		if ($("bancaTag").checked){
			if ($("showBancaDetails").innerHTML == "Show"){
				$("showBancaDetails").innerHTML = "Hide";
				$("bancaDetailsInfo").show();
				$("selBancTypeCd").focus();
				$("selBancTypeCd").scrollTo();
			}else{
				$("showBancaDetails").innerHTML = "Show";
				$("bancaDetailsInfo").hide();
			}	
		}	
	});	

	var bancTypeCdLOV = {};
	var bancAreaCdLOV = {};
	var bancBranchCdLOV = {};
	var managerCd = {};
	var globalLineCd = getLineCd(); // robert - 10.10.14
	//if ($F("globalLineCd") != "SU"){ //removed by robert
	if (globalLineCd != "SU"){
		bancTypeCdLOV = objUW.hidObjGIPIS002.bancTypeCdLOV;
		bancAreaCdLOV = objUW.hidObjGIPIS002.bancAreaCdLOV;
		bancBranchCdLOV = objUW.hidObjGIPIS002.bancBranchCdLOV;
		managerCd = objUW.hidObjGIPIS002.managerCd;
	}else{
		bancTypeCdLOV = objUW.hidObjGIPIS017.bancTypeCdLOV;
		bancAreaCdLOV = objUW.hidObjGIPIS017.bancAreaCdLOV;
		bancBranchCdLOV = objUW.hidObjGIPIS017.bancBranchCdLOV;
		managerCd = objUW.hidObjGIPIS017.managerCd;
	}
	
	updateBancTypeCdLOV(bancTypeCdLOV, ('${gipiWPolbas.bancTypeCd}'));
	updateBancAreaCdLOV(bancAreaCdLOV, ('${gipiWPolbas.areaCd}'));
	updateBancBranchCdLOV(true, bancBranchCdLOV, ('${gipiWPolbas.branchCd}'), managerCd);
	$("selAreaCd").observe("change",function(){
		//updateBancBranchCdLOV(false, bancBranchCdLOV, "", ($F("globalLineCd") != "SU" ? objUW.hidObjGIPIS002.managerCd :objUW.hidObjGIPIS017.managerCd));
		updateBancBranchCdLOV(false, bancBranchCdLOV, "", (globalLineCd != "SU" ? objUW.hidObjGIPIS002.managerCd :objUW.hidObjGIPIS017.managerCd));
	});
	$("selBranchCd").observe("change",function(){
		if ($F("selBranchCd") != ""){
			for(var a=1; a<$("selAreaCd").length; a++){
				if ($("selAreaCd").options[a].value != getListAttributeValue("selBranchCd", "areaCd")){
					$("selAreaCd").options[a].hide();
					$("selAreaCd").options[a].disabled = true;		
				}else{
					$("selAreaCd").options[a].show();
					$("selAreaCd").options[a].disabled = false;		
				}		
			}	
			$("selAreaCd").value = getListAttributeValue("selBranchCd", "areaCd");
			//updateBancBranchCdLOV(true, bancBranchCdLOV, $("selBranchCd").value, ($F("globalLineCd") != "SU" ? objUW.hidObjGIPIS002.managerCd :objUW.hidObjGIPIS017.managerCd));
			updateBancBranchCdLOV(true, bancBranchCdLOV, $("selBranchCd").value, (globalLineCd != "SU" ? objUW.hidObjGIPIS002.managerCd :objUW.hidObjGIPIS017.managerCd));
		}else{
			for(var a=0; a<$("selAreaCd").length; a++){
				$("selAreaCd").options[a].show();
				$("selAreaCd").options[a].disabled = false;		
			}	
		}		
		//if ($F("globalLineCd") != "SU"){ //removed by robert
		if (globalLineCd != "SU"){
			managerCd = objUW.hidObjGIPIS002.managerCd;
			objUW.hidObjGIPIS002.managerCd = getListAttributeValue("selBranchCd", "managerCd");
		}else{
			managerCd = objUW.hidObjGIPIS017.managerCd;
			objUW.hidObjGIPIS017.managerCd = getListAttributeValue("selBranchCd", "managerCd");
		}	
		$("dspManagerCd").value = getListAttributeValue("selBranchCd", "managerCd") == "" ? "" : getListAttributeValue("selBranchCd", "managerCd") != "null" ? getListAttributeValue("selBranchCd", "managerCd") : "";
		$("dspManagerName").value = getListAttributeValue("selBranchCd", "managerName") == "" ? "No managers for the given values." :getListAttributeValue("selBranchCd", "managerName");
	});
</script>