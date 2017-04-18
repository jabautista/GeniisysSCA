function initializePerilRow(row){
	row.observe("mouseover", function ()	{
		row.addClassName("lightblue");
	});
	row.observe("mouseout", function ()	{
		row.removeClassName("lightblue");
	});

	row.observe("click", function ()	{
		row.toggleClassName("selectedRow");
		var selectedRowExists = false;
		
		if ((objUWGlobal.lineCd == objLineCds.AC || objUWGlobal.menuLineCd == objLineCds.AC) && 'Y' == $F("itmperlGroupedExists")){
			showMessageBox("There are existing grouped item perils and you cannot modify, add or delete perils in current item.", imgMessage.info);
			row.removeClassName("selectedRow");
		}else {
			if (row.hasClassName("selectedRow"))	{
				$$("div[name='row2']").each(function (r)	{
					if (row.getAttribute("id") != r.getAttribute("id"))	{
						r.removeClassName("selectedRow");
						selectedRowExists = true;
					}
				});
				
				var objPeril = null;
				for (var i=0; i<objGIPIWItemPeril.length; i++){
					if (objGIPIWItemPeril[i].itemNo == row.getAttribute("item")) {
						if(objGIPIWItemPeril[i].perilCd == row.getAttribute("peril")){
							objPeril = objGIPIWItemPeril[i];
							objCurrItemPeril = objGIPIWItemPeril[i];
						}
					}
				}
				supplyItemPerilInfos(objPeril);
				togglePKFieldView("perilCd", "txtPerilName", unescapeHTML2(objPeril.perilName), selectedRowExists);
				$("btnAddItemPeril").value 		= "Update";
				enableButton("btnDeletePeril");
				showPerilTarfOption(objPeril.perilCd);
				$("perilTarfCd").show();
				$("selPerilTarfCd").hide();
				if ("Y" == $F("perilGroupExists")){
					$("chkAggregateSw").disabled = true;
					$("perilRate").readOnly = true;
					$("perilTsiAmt").readOnly = true;
					$("premiumAmt").readOnly = true;
					$("compRem").readOnly = true;
					$("perilBaseAmt").readOnly = true;
					$("perilNoOfDays").readOnly = true;
				}
			}
			else{
				try {
					$("btnAddItemPeril").value = "Add";
					disableButton("btnDeletePeril");
					togglePKFieldView("perilCd", "txtPerilName","", selectedRowExists);
					clearItemPerilFields();
					showPerilTarfOption(null);
					$("perilTarfCd").hide();
					$("selPerilTarfCd").show();
				} catch (e){
					showErrorMessage("initializePerilRow", e);
				}
			}
		}
			toggleDeductibles(3, $F("itemNo"), $F("perilCd")); // andrew - 09.22.2010 - added this line
		});
}