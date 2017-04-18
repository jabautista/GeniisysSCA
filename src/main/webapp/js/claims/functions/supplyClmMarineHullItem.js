/**
 * @author rey
 * @date 01.12.2011
 * @param obj
 */
function supplyClmMarineHullItem(obj){
	try{
		objCLMItem.selected				= obj == null ? {} :obj;
		objCLMItem.selItemIndex			= obj == null ? null :objCLMItem.selItemIndex;
		objCLMItem.selItemNo			= obj == null ? null :unescapeHTML2(String(nvl(obj[itemGrid.getColumnIndex('itemNo')],"")));
		$("txtItemNo").value			= obj == null ? null :unescapeHTML2(String(nvl(obj[itemGrid.getColumnIndex('itemNo')],"")));
		$("txtItemTitle").value			= obj == null ? null :unescapeHTML2(nvl(obj[itemGrid.getColumnIndex('itemTitle')],""));
		$("txtItemDesc").value			= obj == null ? null :unescapeHTML2(nvl(obj[itemGrid.getColumnIndex('itemDesc')],""));
		$("txtCurrencyCd").value		= obj == null ? null :unescapeHTML2(String(nvl(obj[itemGrid.getColumnIndex('currencyCd')],"")));
		$("txtDspCurrencyDesc").value	= obj == null ? null :unescapeHTML2(nvl(obj[itemGrid.getColumnIndex('currencyDesc')],""));
		$("txtItemDesc2").value			= obj == null ? null :unescapeHTML2(nvl(obj[itemGrid.getColumnIndex('itemDesc2')],""));
		$("txtCurencyRate").value		= obj == null ? null :unescapeHTML2(String(nvl(formatToNineDecimal(obj[itemGrid.getColumnIndex('currencyRate')]),"")));
		$("txtDryPlace").value			= obj == null ? null :unescapeHTML2(nvl(obj[itemGrid.getColumnIndex('dryPlace')],""));
		$("txtDryDate").value			= obj == null ? null :unescapeHTML2(String(nvl(dateFormat(obj[itemGrid.getColumnIndex('dryDate')],"mm-dd-yyyy"),"")));
		$("txtVesselCd").value			= obj == null ? null :unescapeHTML2(nvl(obj[itemGrid.getColumnIndex('vesselCd')],""));
		$("txtVesselName").value		= obj == null ? null :unescapeHTML2(nvl(obj[itemGrid.getColumnIndex('vesselName')],""));
		$("txtGeoLimit").value			= obj == null ? null :unescapeHTML2(nvl(obj[itemGrid.getColumnIndex('geogLimit')],""));
		$("txtVesselType").value		= obj == null ? null :unescapeHTML2(nvl(obj[itemGrid.getColumnIndex('vestypeDesc')],""));
		$("txtOldName").value			= obj == null ? null :unescapeHTML2(nvl(obj[itemGrid.getColumnIndex('vesselOldName')],""));
		$("txtVesselClass").value		= obj == null ? null :unescapeHTML2(nvl(obj[itemGrid.getColumnIndex('vessClassDesc')],""));
		//$("txtPropType").value			= obj == null ? null :unescapeHTML2(nvl(obj[itemGrid.getColumnIndex('propelSw')],""));
		$("txtRegOwner").value			= obj == null ? null :unescapeHTML2(nvl(obj[itemGrid.getColumnIndex('regOwner')],""));
		$("txtHullType").value			= obj == null ? null :unescapeHTML2(nvl(obj[itemGrid.getColumnIndex('hullDesc')]));
		$("txtRegPlace").value			= obj == null ? null :unescapeHTML2(nvl(obj[itemGrid.getColumnIndex('regPlace')],""));
		$("txtCrewNat").value			= obj == null ? null :unescapeHTML2(nvl(obj[itemGrid.getColumnIndex('crewNat')],""));
		$("txtGrossTonnage").value		= obj == null ? null :unescapeHTML2(String(nvl(obj[itemGrid.getColumnIndex('grossTon')],"")));
		$("txtVesselLength").value		= obj == null ? null :unescapeHTML2(String(nvl(obj[itemGrid.getColumnIndex('vesselLength')],"")));
		$("txtNetTonnage").value		= obj == null ? null :unescapeHTML2(String(nvl(obj[itemGrid.getColumnIndex('netTon')],"")));
		$("txtVesselBreadth").value		= obj == null ? null :unescapeHTML2(String(nvl(obj[itemGrid.getColumnIndex('vesselBreadth')],"")));
		$("txtDeadWeight").value		= obj == null ? null :unescapeHTML2(String(nvl(obj[itemGrid.getColumnIndex('deadweight')],"")));
		$("txtVesselDepth").value		= obj == null ? null :unescapeHTML2(String(nvl(obj[itemGrid.getColumnIndex('vesselDepth')],"")));
		$("txtNoOfCrew").value			= obj == null ? null :unescapeHTML2(String(nvl(obj[itemGrid.getColumnIndex('noCrew')],"")));
		$("txtYrBuilt").value			= obj == null ? null :unescapeHTML2(String(nvl(obj[itemGrid.getColumnIndex('yearBuilt')],"")));
		$("txtDeduct").value			= obj == null ? null :unescapeHTML2(nvl(obj[itemGrid.getColumnIndex('deductText')],""));
		if(obj == null){
			$("txtPropType").clear();
		}else{
			var propelSw = unescapeHTML2(nvl(obj[itemGrid.getColumnIndex('propelSw')],""));
			$("txtPropType").value = propelSw == 'S' ? 'SELF-PROPELLED' : 'NON-PROPELLED' ;
		}
		getAddtlInfos(obj);
	}catch(e){
		showErrorMessage("supplyClmMarineHullItem",e);
	}
}