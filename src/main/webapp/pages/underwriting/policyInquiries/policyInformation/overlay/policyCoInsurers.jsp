<div>
	<div style="">
		<table style="margin:5px auto 0 auto;" width="566">
			<tr>
				<td class="rightAligned" style="padding-right: 5px;">Premium Amt</td>
				<td>
					<input type="text" id="txtMainCoInsPremAmt" name="txtMainCoInsPremAmt" class="rightAligned" style="width: 90%;" readonly="readonly"/>
				</td>
				<td class="rightAligned" style="padding-right: 5px;">TSI Amt</td>
				<td>
					<input type="text" id="txtMainCoInsTsiAmt" name="txtMainCoInsTsiAmt" class="rightAligned" style="width: 90%;" readonly="readonly"/>
				</td>
			</tr>
		</table>
	</div>
	
	<div id="coInsurersDiv" style="height:175px;"></div>
	
	<div style="text-align:center;">
		<input type="button" class="button" id="btnReturnFromCoIns" value="Return" style="width: 100px;"/>
	</div>
	
</div>
<script>
	var moduleId = $F("hidModuleId"); //added by Kris 03.12.2013
	try{
		var objPolicyMainCoIns = JSON.parse('${policyMainCoIns}'.replace(/\\/g, '\\\\'));
	}catch(e){
		showErrorMessage("Policy Co-Insurers", e);
	}

	
	if(objPolicyMainCoIns != null){
		$("txtMainCoInsPremAmt").value		= formatCurrency(objPolicyMainCoIns.premAmt); //modified by Kris 03.12.2013
		$("txtMainCoInsTsiAmt").value		= formatCurrency(objPolicyMainCoIns.tsiAmt);  //modified by Kris 03.12.2013
		//loadCoInsurers(objPolicyMainCoIns.policyId);
	}
	
	moduleId == "GIPIS101" ? loadCoInsurers2($F("hidExtractId")) : 
							 loadCoInsurers($("hidPolicyId").value); // modified by Kris 03.12.2013

	//button actions
	$("btnReturnFromCoIns").observe("click", function(){
		overlayCoInsurers.close();
	});
	
	//function definition
	function loadCoInsurers(policyId){
		
		new Ajax.Updater("coInsurersDiv","GIPICoInsurerController?action=getCoInsurers",{
			method:"get",
			evalScripts: true,
			parameters: {
				policyId 	: policyId
			}
					
		});
	}
	
	
	// kris 03.12.2013 : function for GIPIS101
	function loadCoInsurers2(extractId){
		new Ajax.Updater("coInsurersDiv","GIXXCoInsurerController?action=getGIXXCoInsurerList",{
			method:"get",
			evalScripts: true,
			parameters: {
				extractId 	: extractId
			}
					
		});
	}
</script>