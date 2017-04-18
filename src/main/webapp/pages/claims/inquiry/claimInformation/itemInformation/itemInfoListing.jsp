<div id="itemListingDiv" name="itemListingDiv" style="width: 100%;">
	<div id="itemListingTableGridDiv" style="padding: 10px 50px;">
		<div id="itemListingGrid" style="height: 185px; margin: 10px; margin-bottom: 5px; width: 800px;"></div>					
	</div>
</div>

<script type="text/javascript">
	var url = '${url}';
	var objClaimItem = JSON.parse('${jsonClaimItem}'.replace(/\\/g, '\\\\'));
	objClaimItem.itemListing = objClaimItem.rows || [];
	
	var claimItemTableModel = {
		url : contextPath+ url +"&claimId="+ objCLMGlobal.claimId,
		id:'ITM',
		options : {
			title : '',
			width : '800px',
			pager: {}, 
			hideColumnChildTitle: true,
			toolbar : {
				elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onRefresh : function() {
					populateItemFieldsPerLine(null);
					claimItemTableGrid.keys.removeFocus(claimItemTableGrid.keys._nCurrentFocus, true);
					claimItemTableGrid.keys.releaseKeys();
				}
			},
			onCellFocus : function(element, value, x, y, id) {
				var obj = claimItemTableGrid.geniisysRows[y];
				populateItemFieldsPerLine(obj);
				claimItemTableGrid.keys.removeFocus(claimItemTableGrid.keys._nCurrentFocus, true);
				claimItemTableGrid.keys.releaseKeys();
			},
			onRemoveRowFocus : function() {
				populateItemFieldsPerLine(null);
				claimItemTableGrid.keys.removeFocus(claimItemTableGrid.keys._nCurrentFocus, true);
				claimItemTableGrid.keys.releaseKeys();
			},
			onSort : function() {
				populateItemFieldsPerLine(null);
				claimItemTableGrid.keys.removeFocus(claimItemTableGrid.keys._nCurrentFocus, true);
				claimItemTableGrid.keys.releaseKeys();
			}
		},columnModel:[{
				id : 'recordStatus',
				title : '',
				width : '0',
				visible : false,
				editor : 'checkbox'
			},
			{
				id : 'divCtrId',
				width : '0',
				visible : false
			},
			{	id: 'itemNo',
				width: '85px',
				title: 'Item No',
				align: 'right',
				filterOption: true,
				filterOptionType: 'integerNoNegative'
			},
			{ 	id: 'itemTitle',
				align : 'left',
				title : 'Item Title',
				width : '400px',
				filterOption: true
			},
			{ 	id: 'dspCurrencyDesc',
				align : 'left',
				title : 'Currency',
				width : '180px',
				filterOption: true
			},
			{
				id: 'currencyRate',
				title: 'Rate',
				titleAlign: 'right',
				align: 'right',
			  	width: '120',
			  	geniisysClass: 'rate',
	            deciRate: 9,
			  	filterOption: true,
			  	filterOptionType: 'number'
		 	}
		],
		rows : objClaimItem.itemListing
	};
		
	claimItemTableGrid = new MyTableGrid(claimItemTableModel);
	claimItemTableGrid.pager = objClaimItem;
	claimItemTableGrid.render('itemListingGrid');
	
	function populateItemFieldsPerLine(obj){
		var lineCd =  objCLMGlobal.callingForm == "GICLS271" ? objCLMGlobal.lineCode : nvl($("menuLineCd").value, $("lineCd").value);
		
		if(lineCd == "MC" || lineCd == objLineCds.MC){
			populateMotorCarFields(obj);
		}else if(lineCd == "FI" || lineCd == objLineCds.FI){
			populateFireFields(obj);
		}else if(lineCd == "AV" || lineCd == objLineCds.AV){
			populateAviationFields(obj);
		}else if(lineCd == "CA" || lineCd == objLineCds.CA){
			populateCasualtyFields(obj);
		}else if(lineCd == "EN" || lineCd == objLineCds.EN){
			populateEngineeringFields(obj);
		}else if(lineCd == "MH" || lineCd == objLineCds.MH){
			populateMarineHullFields(obj);
		}else if(lineCd == "MN" || lineCd == objLineCds.MN){
			populateMarineCargoFields(obj);
		}else if(lineCd == "PA" || lineCd == objLineCds.PA || lineCd == "AC" || lineCd == objLineCds.AC){
			populateAccidentFields(obj);
		}else{
			populateOtherLinesFields(obj);
		}
	}
	
	function populateMotorCarFields(obj){
		$("txtItemNo").value  		= obj == null ? null : obj.itemNo;
		$("txtItemTitle").value  	= obj == null ? null : unescapeHTML2(obj.itemTitle);
		$("txtItemDesc").value  	= obj == null ? null : unescapeHTML2(obj.itemDesc);
		$("txtItemDesc2").value  	= obj == null ? null : unescapeHTML2(obj.itemDesc2);
		$("txtCurrencyCd").value 	= obj == null ? null : obj.currencyCd; 
		$("txtDspCurrencyDesc").value = obj == null ? null : unescapeHTML2(obj.dspCurrencyDesc);
		$("txtCurrencyRate").value  = obj == null ? null : formatToNthDecimal(obj.currencyRate, 9);
		$("txtPlateNo").value 		= obj == null ? null : unescapeHTML2(obj.plateNo);
		$("txtModelYear").value 	= obj == null ? null : unescapeHTML2(obj.modelYear);
		$("txtMotcarCompCd").value 	= obj == null ? null : obj.motcarCompCd;
		$("txtMotcarCompDesc").value = obj == null ? null : unescapeHTML2(obj.motcarCompDesc);
		$("txtSublineTypeCd").value = obj == null ? null : unescapeHTML2(obj.sublineTypeCd);
		$("txtSublineTypeDesc").value = obj == null ? null : unescapeHTML2(obj.sublineTypeDesc);
		$("txtMakeCd").value 		= obj == null ? null : obj.makeCd;
		$("txtMakeCdDesc").value 	= obj == null ? null : unescapeHTML2(obj.makeDesc);
		$("txtMotorNo").value 		= obj == null ? null : unescapeHTML2(obj.motorNo);
		$("txtSerialNo").value 		= obj == null ? null : unescapeHTML2(obj.serialNo);
		$("txtMotType").value 		= obj == null ? null : obj.motType;
		$("txtMotTypeDesc").value 	= obj == null ? null : unescapeHTML2(obj.motTypeDesc);
		$("txtBasicColorCd").value 	= obj == null ? null : unescapeHTML2(obj.basicColorCd);
		$("txtBasicColorDesc").value = obj == null ? null : unescapeHTML2(obj.basicColor);
		$("txtColor").value 		= obj == null ? null : unescapeHTML2(obj.color);
		$("txtColorCd").value 		= obj == null ? null : obj.colorCd;
		$("txtSeriesCd").value = obj == null ? null : obj.seriesCd;
		$("txtEngineSeries").value = obj == null ? null : unescapeHTML2(obj.engineSeries);
		$("txtTowing").value = obj == null ? null : formatCurrency(obj.towing);
		$("txtItemAssignee").value = obj == null ? null : unescapeHTML2(obj.assignee);
		$("txtMvFileNo").value = obj == null ? null : unescapeHTML2(obj.mvFileNo);
		$("txtNoOfPass").value = obj == null ? null : obj.noOfPass;
		
		// driver details
		$("txtDrvrName").value  	= obj == null ? null : unescapeHTML2(obj.drvrName);
		$("txtDrvngExp").value  	= obj == null ? null : obj.drvngExp;
		$("txtDrvrAge").value  		= obj == null ? null : obj.drvrAge;
		$("txtDrvrOccCd").value  	= obj == null ? null : unescapeHTML2(obj.drvrOccCd);
		$("txtDrvrOccDesc").value  	= obj == null ? null : unescapeHTML2(obj.drvrOccDesc);
		$("txtDrvrSex").value  		= obj == null ? null : unescapeHTML2(obj.drvrSex == "M" ? "Male" : (obj.drvrSex== "F" ? "Female" : null));
		$("txtDrvrAdd").value  		= obj == null ? null : unescapeHTML2(obj.drvrAdd);
		$("txtNationalityCd").value = obj == null ? null : unescapeHTML2(obj.nationalityCd);
		$("txtNationalityDesc").value	= obj == null ? null : unescapeHTML2(obj.nationalityDesc);
		$("txtRelation").value  	= obj == null ? null : unescapeHTML2(obj.relation);
		
		obj == null ? disableButton("btnPerilStatus")   : (nvl(obj.giclItemPerilExist, "N") == "Y" ? enableButton("btnPerilStatus"): disableButton("btnPerilStatus"));
		obj == null ? disableButton("btnThirdAdvParty") : enableButton("btnThirdAdvParty");
		obj == null ? disableButton("btnViewPictures")  : enableButton("btnViewPictures");
		obj == null ? disableButton("btnItemMortgagee") : (nvl(obj.giclMortgageeExist, "N") == "Y" ? enableButton("btnItemMortgagee"): disableButton("btnItemMortgagee"));
		
		claimPerilTableGrid.url = contextPath + "/GICLItemPerilController?action=getItemPerilGrid&claimId="+ nvl(objCLMGlobal.claimId, 0)
			 					  +"&lineCd="+(objCLMGlobal.callingForm == "GICLS271" ? objCLMGlobal.lineCode : $("lineCd").value)+"&itemNo="+(obj == null ? 0 : obj.itemNo);
		
		claimPerilTableGrid._refreshList();
	}
	
	function populateFireFields(obj){
		$("txtItemNo").value  		= obj == null ? null : obj.itemNo;
		$("txtItemTitle").value  	= obj == null ? null : unescapeHTML2(obj.itemTitle);
		$("txtItemDesc").value  	= obj == null ? null : unescapeHTML2(obj.itemDesc);
		$("txtItemDesc2").value  	= obj == null ? null : unescapeHTML2(obj.itemDesc2);
		$("txtItemAssignee").value  = obj == null ? null : unescapeHTML2(obj.assignee);
		$("txtItemLossDate").value  = obj == null ? null : /*dateFormat(obj.lossDate, "mm-dd-yyyy hh:MM TT");*/ obj.lossDateChar;  //shan 04.15.2014
		$("txtCurrencyCd").value 	= obj == null ? null : obj.currencyCd; 
		$("txtDspCurrencyDesc").value = obj == null ? null : unescapeHTML2(obj.dspCurrencyDesc);
		$("txtCurrencyRate").value  = obj == null ? null : formatToNthDecimal(obj.currencyRate, 9);
		$("txtDspTariffZone").value = obj == null ? null : unescapeHTML2(obj.dspTariffZone);
		$("txtDspItemType").value  	= obj == null ? null : unescapeHTML2(obj.dspItemType);
		$("txtTarfCd").value  		= obj == null ? null : unescapeHTML2(obj.tarfCd);
		$("txtDistrictNo").value  	= obj == null ? null : unescapeHTML2(obj.districtNo);
		$("txtBlockNo").value  		= obj == null ? null : unescapeHTML2(obj.blockNo);
		$("txtDspEqZone").value  	= obj == null ? null : unescapeHTML2(obj.dspEqZone);
		$("txtDspTyphoon").value  	= obj == null ? null : unescapeHTML2(obj.dspTyphoon);
		$("txtDspFloodZone").value  = obj == null ? null : unescapeHTML2(obj.dspFloodZone);
		$("txtLocRisk1").value  	= obj == null ? null : unescapeHTML2(obj.locRisk1);
		$("txtLocRisk2").value  	= obj == null ? null : unescapeHTML2(obj.locRisk2);
		$("txtLocRisk3").value  	= obj == null ? null : unescapeHTML2(obj.locRisk3);
		$("txtFront").value  		= obj == null ? null : unescapeHTML2(obj.front);
		$("txtRight").value  		= obj == null ? null : unescapeHTML2(obj.right);
		$("txtLeft").value  		= obj == null ? null : unescapeHTML2(obj.left);
		$("txtRear").value  		= obj == null ? null : unescapeHTML2(obj.rear);
		$("txtDspOccupancy").value  = obj == null ? null : unescapeHTML2(obj.occupancyCd);
		$("txtOccupancyRemarks").value  = obj == null ? null : unescapeHTML2(obj.occupancyRemarks);
		$("txtDspConstruction").value  	= obj == null ? null : unescapeHTML2(obj.constructionCd);
		$("txtConstructionRemarks").value = obj == null ? null : unescapeHTML2(obj.constructionRemarks);
		
		obj == null ? disableButton("btnPerilStatus")   : (nvl(obj.giclItemPerilExist, "N") == "Y" ? enableButton("btnPerilStatus"): disableButton("btnPerilStatus"));
		obj == null ? disableButton("btnViewPictures")  : enableButton("btnViewPictures");
		obj == null ? disableButton("btnItemMortgagee") : (nvl(obj.giclMortgageeExist, "N") == "Y" ? enableButton("btnItemMortgagee"): disableButton("btnItemMortgagee"));
		
		claimPerilTableGrid.url = contextPath + "/GICLItemPerilController?action=getItemPerilGrid&claimId="+ nvl(objCLMGlobal.claimId, 0)
		  						  +"&lineCd="+(objCLMGlobal.callingForm == "GICLS271" ? objCLMGlobal.lineCode : $("lineCd").value)+"&itemNo="+(obj == null ? 0 : obj.itemNo);
		claimPerilTableGrid._refreshList();
	}
	
	function populateAviationFields(obj){
		$("txtItemNo").value  			= obj == null ? null : obj.itemNo;
		$("txtItemTitle").value  		= obj == null ? null : unescapeHTML2(obj.itemTitle);
		$("txtNbtVesselName").value 	= obj == null ? null : unescapeHTML2(obj.dspVesselName);
		$("txtCurrencyRate").value  	= obj == null ? null : formatToNineDecimal(obj.currencyRate);
		$("txtCurrencyCd").value  		= obj == null ? null : obj.currencyCd;
		$("txtNbtCurrencyDesc").value  	= obj == null ? null : unescapeHTML2(obj.dspCurrencyDesc);
		$("txtNbtAirType").value  		= obj == null ? null : unescapeHTML2(obj.dspAirType);
		$("txtLossDateAV").value  		= obj == null ? null : /* formatDateToDefaultMask(obj.lossDate) */ obj.lossDate;	//shan 04.15.2014
		$("txtNbtRpcNo").value  		= obj == null ? null : unescapeHTML2(obj.dspRpcNo);
		$("txtPrevUtilHrs").value  		= obj == null ? null : obj.prevUtilHrs;
		$("txtTotalFlyTime").value  	= obj == null ? null : obj.totalFlyTime;
		$("txtEstUtilHrs").value  		= obj == null ? null : obj.estUtilHrs;
		$("txtPurpose").value  			= obj == null ? null : unescapeHTML2(obj.purpose);
		$("txtQualification").value  	= obj == null ? null : unescapeHTML2(obj.qualification);
		$("txtDeductText").value  		= obj == null ? null : unescapeHTML2(obj.deductText);
		$("txtGeogLimit").value  		= obj == null ? null : unescapeHTML2(obj.geogLimit);
		
		obj == null ? disableButton("btnPerilStatus")   : (nvl(obj.giclItemPerilExist, "N") == "Y" ? enableButton("btnPerilStatus"): disableButton("btnPerilStatus"));
		obj == null ? disableButton("btnViewPictures")  : enableButton("btnViewPictures");
		
		claimPerilTableGrid.url = contextPath + "/GICLItemPerilController?action=getItemPerilGrid&claimId="+ nvl(objCLMGlobal.claimId, 0)
		  									  +"&lineCd="+(objCLMGlobal.callingForm == "GICLS271" ? objCLMGlobal.lineCode : $("lineCd").value)+"&itemNo="+(obj == null ? 0 : obj.itemNo);
		claimPerilTableGrid._refreshList();
	}
	
	function populateCasualtyFields(obj){
		$("txtItemNo").value  			= obj == null ? null : obj.itemNo;
		$("itemTitle").value  			= obj == null ? null : unescapeHTML2(obj.itemTitle);
		$("amountCoverage").value		= obj == null ? null : formatCurrency(obj.amountCoverage);
		$("groupedItemNo").value 		= obj == null ? null : obj.groupedItemNo;
		$("groupedItemTitle").value 	= obj == null ? null : unescapeHTML2(obj.groupedItemTitle);
		$("propertyNoType").value 		= obj == null ? null : unescapeHTML2(obj.propertyNoType);
		$("propertyNo").value 			= obj == null ? null : unescapeHTML2(obj.propertyNo);
		$("currencyCd").value 			= obj == null ? null : obj.currencyCd;
		$("currencyDesc").value 		= obj == null ? null : unescapeHTML2(obj.currencyDesc);
		$("location").value 			= obj == null ? null : unescapeHTML2(obj.location);
		$("currencyRate").value 		= obj == null ? null : formatToNineDecimal(obj.currencyRate);
		$("conveyanceInfo").value 		= obj == null ? null : unescapeHTML2(obj.conveyanceInfo);
		$("capacityCd").value 			= obj == null ? null : obj.capacityCd;
		$("position").value 			= obj == null ? null : unescapeHTML2(obj.position);
		$("interestOnPremises").value 	= obj == null ? null : unescapeHTML2(obj.interestOnPremises);
		//$("sectionOrHazardTitle").value = obj == null ? null : obj.;
		$("sectionOrHazardCd").value 	= obj == null ? null : unescapeHTML2(obj.sectionOrHazardCd);
		$("limitOfLiability").value 	= obj == null ? null : unescapeHTML2(obj.limitOfLiability);
		$("sectionOrHazardInfo").value 	= obj == null ? null : unescapeHTML2(obj.sectionOrHazardInfo);
		$("lossDateCA").value 			= obj == null ? null : /*formatDateToDefaultMask(obj.lossDate)*/ obj.lossDateChar;	//shan 04.15.2014
		
		$("personnelNo").value 			= obj == null ? null : obj.personnelNo;
		$("name").value 				= obj == null ? null : unescapeHTML2(obj.name);
		$("persCapacityCd").value 		= obj == null ? null : obj.persCapacityCd;
		$("nbtPosition").value 			= obj == null ? null : unescapeHTML2(obj.nbtPosition);
		$("amountCovered").value 		= obj == null ? null : formatCurrency(obj.amountCovered);
		
		if(obj != null){
			if(obj.detail == 1){
				$("beneficiary").checked = true;
			}else{
				$("personnel").checked = true;
			}	
		}
		
		obj == null ? disableButton("btnPerilStatus")   : (nvl(obj.giclItemPerilExist, "N") == "Y" ? enableButton("btnPerilStatus"): disableButton("btnPerilStatus"));
		obj == null ? disableButton("btnViewPictures")  : enableButton("btnViewPictures");
		
		claimPerilTableGrid.url = contextPath + "/GICLItemPerilController?action=getItemPerilGrid&claimId="+ nvl(objCLMGlobal.claimId, 0)
		  									  +"&lineCd="+(objCLMGlobal.callingForm == "GICLS271" ? objCLMGlobal.lineCode : $("lineCd").value)+"&itemNo="+(obj == null ? 0 : obj.itemNo);
		claimPerilTableGrid._refreshList();
	}
	
	function populateEngineeringFields(obj){
		$("txtItemNo").value  			= obj == null ? null : obj.itemNo;
		$("txtItemTitle").value  		= obj == null ? null : unescapeHTML2(obj.itemTitle);
		$("txtItemDesc").value  		= obj == null ? null : unescapeHTML2(obj.itemDesc);
		$("txtItemDesc2").value  		= obj == null ? null : unescapeHTML2(obj.itemDesc2);
		$("txtNbtRegion").value  		= obj == null ? null : unescapeHTML2(obj.regionDesc);
		$("txtNbtProvince").value  		= obj == null ? null : unescapeHTML2(obj.provinceDesc);
		$("txtCurrencyCd").value  		= obj == null ? null : obj.currencyCd;
		$("txtNbtCurrencyDesc").value  	= obj == null ? null : unescapeHTML2(obj.currDesc);
		$("txtLossDateEN").value  		= obj == null ? null : /* formatDateToDefaultMask(obj.lossDate) */ obj.lossDateChar;	//shan 04.15.2014
		$("txtCurrencyRate").value  	= obj == null ? null : formatToNineDecimal(obj.currencyRate);
		
		obj == null ? disableButton("btnPerilStatus")   : (nvl(obj.giclItemPerilExist, "N") == "Y" ? enableButton("btnPerilStatus"): disableButton("btnPerilStatus"));
		obj == null ? disableButton("btnViewPictures")  : enableButton("btnViewPictures");
		
		claimPerilTableGrid.url = contextPath + "/GICLItemPerilController?action=getItemPerilGrid&claimId="+ nvl(objCLMGlobal.claimId, 0)
		  									  +"&lineCd="+(objCLMGlobal.callingForm == "GICLS271" ? objCLMGlobal.lineCode : $("lineCd").value)+"&itemNo="+(obj == null ? 0 : obj.itemNo);
		claimPerilTableGrid._refreshList();
	}
	
	function populateMarineHullFields(obj){
		$("txtItemNo").value  			= obj == null ? null : obj.itemNo;
		$("txtItemTitle").value  		= obj == null ? null : unescapeHTML2(obj.itemTitle);
		$("txtLossDateMH").value 		= obj == null ? null : /*dateFormat(obj.lossDate, "mm-dd-yyyy");*/ obj.lossDateChar;	//shan 04.15.2014
		$("txtVesselCd").value  		= obj == null ? null : obj.vesselCd;
		$("txtNbtVesselName").value  	= obj == null ? null : unescapeHTML2(obj.vesselName);
		$("txtCurrencyCd").value  		= obj == null ? null : obj.currencyCd;
		$("txtNbtCurrencyDesc").value  	= obj == null ? null : unescapeHTML2(obj.currencyDesc);
		$("txtNbtVesType").value  		= obj == null ? null : unescapeHTML2(obj.vestypeDesc);
		$("txtCurrencyRate").value  	= obj == null ? null : formatToNineDecimal(obj.currencyRate);
		$("txtNbtVesClass").value  		= obj == null ? null : unescapeHTML2(obj.vessClassDesc);
		$("txtNbtOldName").value  		= obj == null ? null : unescapeHTML2(obj.vesselOldName);
		$("txtNbtRegOwner").value  		= obj == null ? null : unescapeHTML2(obj.regOwner);
		$("txtNbtRegPlace").value  		= obj == null ? null : unescapeHTML2(obj.regPlace);
		$("txtNbtHullType").value  		= obj == null ? null : unescapeHTML2(obj.hullDesc);
		$("txtNbtGrossTon").value  		= obj == null ? null : obj.grossTon;
		$("txtNbtCrewNat").value  		= obj == null ? null : unescapeHTML2(obj.crewNat);
		$("txtNbtNetTon").value  		= obj == null ? null : obj.netTon;
		$("txtNbtVesLength").value  	= obj == null ? null : obj.vesselLength;
		$("txtNbtDeadwt").value  		= obj == null ? null : obj.deadweight;
		$("txtNbtVesBreadth").value  	= obj == null ? null : obj.vesselBreadth;
		$("txtNbtNoCrew").value  		= obj == null ? null : obj.noCrew;
		$("txtNbtVesDepth").value  		= obj == null ? null : obj.vesselDepth;
		$("txtDryPlace").value  		= obj == null ? null : unescapeHTML2(obj.dryPlace);
		$("txtNbtYrBuilt").value  		= obj == null ? null : obj.yearBuilt;
		$("txtDryDate").value  			= obj == null ? null : dateFormat(obj.dryDate, "mm-dd-yyyy");
		$("txtGeogLimit").value  		= obj == null ? null : unescapeHTML2(obj.geogLimit);
		$("txtDeductText").value  		= obj == null ? null : unescapeHTML2(obj.deductText);
		if(obj == null){
			$("txtNbtPropType").clear();
		}else{
			$("txtNbtPropType").value = obj.propelSw == 'S' ? 'SELF-PROPELLED' : 'NON-PROPELLED' ;
		}
		
		obj == null ? disableButton("btnPerilStatus")   : (nvl(obj.giclItemPerilExist, "N") == "Y" ? enableButton("btnPerilStatus"): disableButton("btnPerilStatus"));
		obj == null ? disableButton("btnViewPictures")  : enableButton("btnViewPictures");
		
		claimPerilTableGrid.url = contextPath + "/GICLItemPerilController?action=getItemPerilGrid&claimId="+ nvl(objCLMGlobal.claimId, 0)
		  									  +"&lineCd="+(objCLMGlobal.callingForm == "GICLS271" ? objCLMGlobal.lineCode : $("lineCd").value)+"&itemNo="+(obj == null ? 0 : obj.itemNo);
		claimPerilTableGrid._refreshList();
	}
	
	function populateMarineCargoFields(obj){
		$("txtItemNo").value  			= obj == null ? null : obj.itemNo;
		$("txtItemTitle").value  		= obj == null ? null : unescapeHTML2(obj.itemTitle);
		$("txtCurrencyCd").value  		= obj == null ? null : obj.currencyCd;
		$("txtNbtCurrencyDesc").value  	= obj == null ? null : unescapeHTML2(obj.dspCurrencyDesc);
		$("txtVesselCd").value  		= obj == null ? null : obj.vesselCd;
		$("txtNbtVesselName").value  	= obj == null ? null : unescapeHTML2(obj.vesselName);
		$("txtCurrencyRate").value  	= obj == null ? null : formatToNineDecimal(obj.currencyRate);
		$("txtGeogCd").value  			= obj == null ? null : obj.geogCd;
		$("txtNbtGeogDesc").value  		= obj == null ? null : unescapeHTML2(obj.geogDesc);
		$("txtLcNo").value  			= obj == null ? null : unescapeHTML2(obj.lcNo);
		$("txtCargoClassCd").value  	= obj == null ? null : obj.cargoClassCd;
		$("txtNbtCargoDesc").value  	= obj == null ? null : unescapeHTML2(obj.cargoClassDesc);
		$("txtBlAwb").value  			= obj == null ? null : unescapeHTML2(obj.blAwb);
		$("txtPackMethod").value  		= obj == null ? null : unescapeHTML2(obj.packMethod);
		$("txtCargoType").value  		= obj == null ? null : unescapeHTML2(obj.cargoTypeDesc);
		$("txtTranshipOrigin").value  	= obj == null ? null : unescapeHTML2(obj.transhipOrigin);
		$("txtOrigin").value  			= obj == null ? null : unescapeHTML2(obj.origin);
		$("txtTranshipDestination").value = obj == null ? null : unescapeHTML2(obj.transhipDestination);
		$("txtDestn").value  			= obj == null ? null : unescapeHTML2(obj.destn);
		$("txtVoyageNo").value  		= obj == null ? null : unescapeHTML2(obj.voyageNo);
		$("txtEtd").value  				= obj == null ? null : obj.strEtd;
		$("txtDeductText").value  		= obj == null ? null : unescapeHTML2(obj.deductText);
		$("txtEta").value  				= obj == null ? null : obj.strEta;
		$("txtLossDateMN").value  		= obj == null ? null : /* obj.lossDate */ obj.lossDate;	//shan 04.15.2014
		
		obj == null ? disableButton("btnPerilStatus")   : (nvl(obj.giclItemPerilExist, "N") == "Y" ? enableButton("btnPerilStatus"): disableButton("btnPerilStatus"));
		obj == null ? disableButton("btnViewPictures")  : enableButton("btnViewPictures");
		
		claimPerilTableGrid.url = contextPath + "/GICLItemPerilController?action=getItemPerilGrid&claimId="+ nvl(objCLMGlobal.claimId, 0)
		  									  +"&lineCd="+(objCLMGlobal.callingForm == "GICLS271" ? objCLMGlobal.lineCode : $("lineCd").value)+"&itemNo="+(obj == null ? 0 : obj.itemNo);
		claimPerilTableGrid._refreshList();
	}
	
	function populateAccidentFields(obj){
		$("txtItemNo").value  			= obj == null ? null : obj.itemNo;
		$("txtItemTitle").value  		= obj == null ? null : unescapeHTML2(obj.itemTitle);
		$("txtLevelCd").value  			= obj == null ? null : obj.levelCd;
		$("txtSalaryGrade").value  		= obj == null ? null : obj.salaryGrade;
		$("txtGroupedItemNo").value  	= obj == null ? null : obj.groupedItemNo;
		$("txtGroupedItemTitle").value  = obj == null ? null : unescapeHTML2(obj.groupedItemTitle);
		$("txtLossDateAC").value  		= obj == null ? null : /* obj.lossDate */ obj.lossDate;	//shan 04.15.2014
		$("txtCurrencyCd").value  		= obj == null ? null : obj.currencyCd;
		$("txtNbtCurrencyDesc").value  	= obj == null ? null : unescapeHTML2(obj.dspCurrency);
		$("txtDateOfBirth").value  		= obj == null ? null : /*obj.dateOfBirth;*/ formatDateToDefaultMask(obj.dateOfBirth);  //shan 04.14.2014
		$("txtCurrencyRate").value  	= obj == null ? null : formatToNineDecimal(obj.currencyRate);
		$("txtNbtCivilStat").value  	= obj == null ? null : unescapeHTML2(nvl(obj.civilStatus,obj.dspCivilStat));
		$("txtPositionCd").value  		= obj == null ? null : obj.positionCd;
		$("txtNbtPosition").value  		= obj == null ? null : unescapeHTML2(obj.dspPosition);
		$("txtDspSex").value  			= obj == null ? null : nvl(obj.sex,obj.dspSex);
		$("txtAge").value  				= obj == null ? null : obj.age;
		$("txtMonthlySalary").value		= obj == null ? null : formatCurrency(obj.monthlySalary);
		$("txtAmountCoverage").value	= obj == null ? null : formatCurrency(obj.amountCoverage);
		
		$("txtBeneficiaryNo").value  	= obj == null ? null : obj.beneficiaryNo;
		$("txtBeneficiaryName").value 	= obj == null ? null : unescapeHTML2(obj.beneficiaryName);
		$("txtBeneficiaryAddr").value  	= obj == null ? null : unescapeHTML2(obj.beneficiaryAddr);
		$("txtBenPositionCd").value  	= obj == null ? null : obj.positionCd;
		$("txtNbtBenPosition").value  	= obj == null ? null : unescapeHTML2(obj.benPosition);
		$("txtNbtCivilStatus").value  	= obj == null ? null : unescapeHTML2(obj.benCivilStatus);
		$("txtDspBenSex").value  		= obj == null ? null : obj.benSex;
		$("txtRelation").value  		= obj == null ? null : obj.benRelation;
		$("txtBenDateOfBirth").value  	= obj == null ? null : obj.benDateOfBirth;
		$("txtDspBenAge").value  		= obj == null ? null : obj.benAge;
		
		obj == null ? disableButton("btnPerilStatus")   : (nvl(obj.giclItemPerilExist, "N") == "Y" ? enableButton("btnPerilStatus"): disableButton("btnPerilStatus"));
		obj == null ? disableButton("btnViewPictures")  : enableButton("btnViewPictures");
		
		claimPerilTableGrid.url = contextPath + "/GICLItemPerilController?action=getItemPerilGrid&claimId="+ nvl(objCLMGlobal.claimId, 0)
		  									  +"&lineCd="+(objCLMGlobal.callingForm == "GICLS271" ? objCLMGlobal.lineCode : $("lineCd").value)+"&itemNo="+(obj == null ? 0 : obj.itemNo);
		claimPerilTableGrid._refreshList();
	}
	
	function populateOtherLinesFields(obj){
		$("txtItemNo").value  			= obj == null ? null : obj.itemNo;
		$("txtItemTitle").value  		= obj == null ? null : unescapeHTML2(obj.itemTitle);
		$("txtOtherInfo").value  		= obj == null ? null : obj.otherInfo;
		$("txtCurrencyCd").value  		= obj == null ? null : obj.currencyCd;
		$("txtNbtCurrencyDesc").value  	= obj == null ? null : obj.nbtCurrencyDesc;
		$("txtCurrencyRate").value  	= obj == null ? null : formatToNineDecimal(obj.currencyRate);
		$("txtLossDateOL").value  		= obj == null ? null : /* formatDateToDefaultMask(obj.lossDate) */ obj.lossDate;	//shan 04.15.2014
		
		obj == null ? disableButton("btnPerilStatus")   : (nvl(obj.giclItemPerilExist, "N") == "Y" ? enableButton("btnPerilStatus"): disableButton("btnPerilStatus"));
		obj == null ? disableButton("btnViewPictures")  : enableButton("btnViewPictures");
		
		claimPerilTableGrid.url = contextPath + "/GICLItemPerilController?action=getItemPerilGrid&claimId="+ nvl(objCLMGlobal.claimId, 0)
		  									  +"&lineCd="+(objCLMGlobal.callingForm == "GICLS271" ? objCLMGlobal.lineCode : $("lineCd").value)+"&itemNo="+(obj == null ? 0 : obj.itemNo);
		claimPerilTableGrid._refreshList();
	}

</script>