function addMaintainedPerils(){
	if (($F("tsiAmt") != "0") && ($F("tsiAmt") != "0.00") && ($F("tsiAmt") != "")){
		deleteItemPerilsForItemNo($F("itemNo"));
	}
	
	new Ajax.Request(contextPath+"/GIPIWItemPerilController?action=getMaintainedPerilListing",{
		method: "POST",
		evalScripts: true,
		asynchronous: true,
		parameters: {
			globalParId		: $F("globalParId"),
			globalPackParId	: $F("globalPackParId"),
			packLineCd		: $("packLineCd"),
			packSublineCd	: $("packSublineCd")
		},
		onComplete: function (response)	{
			if (checkErrorOnResponse(response)){
				var objMPerils = JSON.parse((response.responseText).replace(/\\/g, '\\\\'));
				
				for(var x=o; x<objMPerils.length; x++){
					//ADDING PERILS
					var itemNoOfPeril = $F("itemNo");
					var lineCd = objMPerils[x].lineCd;
					var perilCd = objMPerils[x].perilCd;
					var perilName = objMPerils[x].perilName;
					var perilRate = objMPerils[x].premRt == null? "0.000000000" : formatToNineDecimal(objMPerils[x].premRt);
					var tsiAmt = objMPerils[x].tsiAmt == null? "0.00" : formatCurrency(objMPerils[x].tsiAmt);
					var premAmt = objMPerils[x].premAmt == null? "0.00" : formatCurrency(objMPerils[x].premAmt);
					var compRem = "---";
					var perilType = objMPerils[x].perilType;
					var wcSw = "N";
					var tarfCd = "";
					var annTsiAmt = "";
					var annPremAmt = "";
					var prtFlag = "";
					var riCommRate = "";
					var riCommAmt = "";
					var surchargeSw = "";
					var baseAmt = objMPerils[x].baseAmt == null? "" : formatCurrency(objMPerils[x].baseAmt);
					var aggregateSw = objMPerils[x].aggregateSw == null? "" : formatCurrency(objMPerils[x].aggregateSw);
					var discountSw = "";
					var bascPerlCd = "";
					var noOfDays = objMPerils[x].noOfDays == null? "" : formatCurrency(objMPerils[x].noOfDays);
					var labelContent = 	'<label name="text" style="width: 5%; text-align: right; margin-right: 5px;" labelName="itemNo">'+itemNoOfPeril+'</label>'+
									'<label name="text" style="width: 20%; text-align: left; margin-left: 5px;">'+perilName+'</label>'+
									'<label name="text" style="width: 15%; text-align: right;" class="moneyRate">'+perilRate+'</label>'+
									'<label name="text" style="width: 15%; text-align: right; margin-left: 5px;" class="money">'+tsiAmt+'</label>'+
									'<label name="text" style="width: 15%; text-align: right; margin-left: 5px;" class="money";>'+premAmt+'</label>'+
									'<label name="text" style="width: 15%; text-align: left; margin-left: 10px;margin-right: 10px;">'+compRem+'</label>'+
									'<label style="width: 3%; text-align: right;"><span style="float: right; width: 10px; height: 10px;">-</span>'+ '</label>'+
									'<label style="width: 3%; text-align: right;"><span style="float: right; width: 10px; height: 10px;">-</span>'+ '</label>'+
									'<label style="width: 3%; text-align: right;"><span style="float: right; width: 10px; height: 10px;">-</span>'+ '</label>';
					$("addItemNo").value = itemNoOfPeril;
					$("addPerilCd").value = perilCd;
					var itemPerilTable = $("itemPerilMainDiv"); //$("parItemPerilTable");
					var itemPerilMotherDiv = $("itemPerilMotherDiv"+itemNoOfPeril);
					var isNew = false;
					if (itemPerilMotherDiv == undefined)	{
						isNew = true;
						itemPerilMotherDiv = new Element("div");
						itemPerilMotherDiv.setAttribute("id", "itemPerilMotherDiv"+itemNoOfPeril);
						itemPerilMotherDiv.setAttribute("name", "itemPerilMotherDiv");
						itemPerilMotherDiv.addClassName("tableContainer");
					}
					var newDiv = new Element("div");
					newDiv.setAttribute("id", "rowPeril"+itemNoOfPeril+perilCd);
					newDiv.setAttribute("name", "row2");
					newDiv.setAttribute("item", itemNoOfPeril);
					newDiv.setAttribute("peril", perilCd);
					newDiv.addClassName("tableRow");
					//newDiv.setStyle("display: none;");
					newDiv.update(labelContent +
						'<input type="hidden" name="perilItemNos"		value="'+itemNoOfPeril+'" />'+
						'<input type="hidden" name="perilLineCds"		value="'+lineCd+'" />'+
						'<input type="hidden" name="perilPerilNames" 	value="'+perilName+'" />'+
						'<input type="hidden" name="perilPerilCds" 		value="'+perilCd+'" />'+
						'<input type="hidden" name="perilPremRts" 		class="moneyRate" 	value="'+perilRate+'" />'+
						'<input type="hidden" name="perilTsiAmts" 		class="money" 		value="'+tsiAmt+'" />'+
						'<input type="hidden" name="perilPremAmts" 		class="money" 		value="'+premAmt+'" />'+
						'<input type="hidden" name="perilCompRems" 		value="'+compRem+'" />'+
						'<input type="hidden" name="perilPerilTypes"	value="'+perilType+'" />'+
						'<input type="hidden" name="perilWcSws"			value="'+wcSw+'" />'+
						'<input type="hidden" name="perilTarfCds" 		value="'+tarfCd+'" />'+
						'<input type="hidden" name="perilAnnTsiAmts" 	value="'+annTsiAmt+'" />'+
						'<input type="hidden" name="perilAnnPremAmts" 	value="'+annPremAmt+'" />'+
						'<input type="hidden" name="perilPrtFlags" 		value="'+prtFlag+'" />'+
						'<input type="hidden" name="perilRiCommRates" 	value="'+riCommRate+'" />'+
						'<input type="hidden" name="perilRiCommAmts" 	value="'+riCommAmt+'" />'+
						'<input type="hidden" name="perilSurchargeSws" 	value="'+surchargeSw+'" />'+
						'<input type="hidden" name="perilBaseAmts" 		value="'+baseAmt+'" />'+
						'<input type="hidden" name="perilAggregateSws" 	value="'+aggregateSw+'" />'+
						'<input type="hidden" name="perilDiscountSws" 	value="'+discountSw+'" />'+
						'<input type="hidden" name="perilBascPerlCds" 	value="'+bascPerlCd+'" />'+
						'<input type="hidden" name="perilBaseAmts" 		value="'+baseAmt+'" />'+
						'<input type="hidden" name="perilNoOfDayss" 	value="'+noOfDays+'" />');
					itemPerilMotherDiv.insert({bottom: newDiv});						
					if (isNew)	{							
						itemPerilTable.insert({bottom: itemPerilMotherDiv});
					}
					initializePerilRow(newDiv);
					$$("label[name='text']").each(function (label)	{
						if ((label.innerHTML).length > 15)    {
				            label.update((label.innerHTML).truncate(30, "..."));
				        }
					});
					Effect.Appear("rowPeril"+itemNoOfPeril+perilCd, {
						duration: .2,
						afterFinish: function () {
							clearItemPerilFields();
							$("dumPerilCd").value = "";								
							hideAllItemPerilOptions();
							selectItemPerilOptionsToShow();
							hideExistingItemPerilOptions();
							changeCheckImageColor();
							checkIfToResizePerilTable("itemPerilMainDiv", "itemPerilMotherDiv"+$F("itemNo"), "row2");
							$("itemPerilMainDiv").show();
							$("itemPerilMotherDiv"+$F("itemNo")).show();
	
						}
					});								
					$("tempPerilItemNos").value = updateTempStorage($F("tempPerilItemNos").blank() ? "" :  $F("tempPerilItemNos"), itemNoOfPeril);		
					getTotalAmounts();
				}
				$("perilRate").readOnly = true;
				$("premiumAmt").readOnly = true;
				$("varPlanAmtCh").value = "N";
				$("varPlanPerilCh").value = "Y";
				$("varPlanCreateCh").value = "Y";
			}
		}
	});
}