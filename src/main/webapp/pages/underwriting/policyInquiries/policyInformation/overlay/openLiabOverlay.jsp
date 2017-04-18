<div style="width:750px;margin:10px auto 10px auto">
	<div id="txtFieldsDiv" name="txtFieldsDiv" >
		<table border="0" align="center" width="700px">
			<tr>
				<td>
					<input type="hidden" id="hidPolicyId"/>
					<input type="hidden" id="hidGeogCd" name="hidGeogCd" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned" width="120px">Geography:</td>
				<td><input type="text" id="txtGeogDesc" name="txtGeogDesc" readonly="readonly" style="width:215px" /></td>
				<td class="rightAligned" width="120px">Currency:</td>
				<td><input type="text" id="txtCurrencyDesc" name="txtCurrencyDesc" readonly="readonly" style="width:215px" /></td>
			</tr>			
			<tr>
				<td class="rightAligned">Limit of Liability:</td>
				<td><input type="text" id="txtLimitLiability" name="txtLimitLiability" readonly="readonly" style="width:215px" class="rightAligned" /></td>
				<td class="rightAligned">Currency Rate:</td>
				<td><input type="text" id="txtCurrencyRate" name="txtCurrencyRate" readonly="readonly" style="width:215px" class="rightAligned" /></td>
			</tr>
			<tr>
				<td class="rightAligned">Voyage Limit:</td>
				<td colspan="3">
					<!-- <input type="text" id="txtVoyLimit" name="txtVoyLimit" readonly="readonly" style="width:100%" /> --> 
					<textarea id="txtVoyLimit" name="txtVoyLimit" rows="1" readonly="readonly" style="float: left; resize: none; width:94.5%; "></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: left;" alt="EditVoyLimit" id="editVoyLimit" class="hover" />
				</td>
			</tr>
		</table>
	</div>
	
	<div id="cargoTableGridDiv" style="height:150px;width:700px;">
			<!-- <div id="cargoListing" style="height:150px;width:700px;"></div> -->
	</div>
	
	<div id="perilTableGridDiv" style="height:150px;width:700px;">
			<!-- <div id="perilListing" style="height:150px;width:700px;"></div> -->
	</div>
	
	
	<div style="text-align:center;" >
		<input type="button" class="button" id="btnReturnOpenLiab" name="btnReturnOpenLiab" value="Ok" style="width:130px;"/>
	</div>

</div>

<script type="text/javascript" >
	try{		
		var objOpenLiab = JSON.parse('${openLiabInfo}'.replace(/\\/g,'\\\\'));	
		
		/* var objOpenCargo = new Object();
		objOpenCargo.objOpenCargoListTableGrid = JSON.parse('${openCargoList}'.replace(/\\/g, '\\\\'));
		objOpenCargo.objOpenCargoList = objOpenCargo.objOpenCargoListTableGrid.rows || []; */
	}catch(e){
		showErrorMessage("openLiabOverlay", e);
	}
	
	if(objOpenLiab != null){
		$("hidPolicyId").value = objOpenLiab.policyId;
		$("txtGeogDesc").value = objOpenLiab.geogDesc;
		$("txtCurrencyDesc").value = objOpenLiab.currencyDesc;
		$("txtLimitLiability").value = formatCurrency(nvl(objOpenLiab.limitLiability, 0));
		$("txtCurrencyRate").value = formatToNineDecimal(nvl(objOpenLiab.currencyRt, 1));
		$("txtVoyLimit").value = unescapeHTML2(objOpenLiab.voyLimit);
		$("hidGeogCd").value = objOpenLiab.geogCd;
	}
	
	$("editVoyLimit").observe("click", function () {
		showEditor("txtVoyLimit", 2000, 'true');
	});
	
	var moduleId = '${moduleId}';
	
	function initializeCargoTG(){
		if(moduleId == "GIPIS100"){
			new Ajax.Updater("cargoTableGridDiv", contextPath + "/GIPIOpenPolicyController",{
				method:"get",
				evalScripts: true,
				parameters: {
					action : "getOpenCargos",
					policyId : $F("hidPolicyId"),
					geogCd : $F("hidGeogCd"),
					moduleId : moduleId
				}
			});
		} else {
			new Ajax.Updater("cargoTableGridDiv", contextPath + "/GIXXOpenCargoController?action=getGIXXOpenCargoList",{
				method:"get",
				evalScripts: true,
				parameters: {
					extractId	:$F("hidExtractId"),
					geogCd		:$F("hidGeogCd")
				}
			});	
		}
	}

	function initializePerilTG(){
		if(moduleId == "GIPIS100"){
			new Ajax.Updater("perilTableGridDiv", contextPath + "/GIPIOpenPolicyController",{
				method:"get",
				evalScripts: true,
				parameters: {
					action : "getOpenPerils",
					policyId : $F("hidPolicyId"),
					geogCd : $F("hidGeogCd"),
					moduleId : moduleId,
					withInvoiceTag : objOpenLiab.withInvoiceTag
				}
			});
		} else {
			new Ajax.Updater("perilTableGridDiv", contextPath + "/GIXXOpenPerilController?action=getGIXXOpenPerilList",{
				method:"get",
				evalScripts: true,
				parameters: {
					extractId	:$F("hidExtractId"),
					geogCd		:$F("hidGeogCd")
				}
			});	
		}
	}
	
	showNotice("Loading, please wait...");	
	
	if('${cargoSw}' != "N"){
		initializeCargoTG();
	} else {
		$("cargoTableGridDiv").setStyle({display: "none"});
	}
	
	initializePerilTG();
	
	$("btnReturnOpenLiab").observe("click", function(){
		openLiabOverlay.close();
	});
</script>