/*
 * Created By	: Bryan Joseph G. Abuluyan
 * Date			: November 22, 2010
 * Description	: adds an object to the peril listing table
 * Parameters	: obj - obj containing the item peril details
 */
function addObjToPerilTable(obj){
	try {
		var itemNoOfPeril 		= obj.itemNo;
		var lineCd 				= obj.lineCd;
		var perilCd 			= obj.perilCd;
		var perilName 			= obj.perilName;
		var perilRate 			= obj.premRt == null ? "---" : formatToNineDecimal(obj.premRt);
		var tsiAmt 				= obj.tsiAmt == null ? "---" : formatCurrency(obj.tsiAmt);
		var premAmt 			= obj.premAmt == null ? "---" : formatCurrency(obj.premAmt);
		var compRem 			= escapeHTML2(nvl(obj.compRem, "---")); 
		var perilType 			= nvl(obj.perilType, "");
		var wcSw 				= "N";
		var tarfCd 				= nvl(obj.tarfCd, "");
		var annTsiAmt 			= obj.annTsiAmt == null ? "" : formatCurrency(obj.annTsiAmt);//formatCurrency(obj.itemNo);
		var annPremAmt 			= obj.annPremAmt == null ? "" : formatCurrency(obj.annPremAmt); //formatCurrency(obj.itemNo);
		var prtFlag 			= nvl(obj.prtFlag, "");
		var riCommRate 			= obj.riCommRate == null ? "" : formatToNineDecimal(obj.riCommRate);
		var riCommAmt 			= obj.riCommAmt == null ? "" : formatCurrency(obj.riCommAmt);
		var surchargeSw 		= nvl(obj.surchargeSw, "");
		var baseAmt 			= obj.baseAmt == null ? "" : formatCurrency(obj.baseAmt);
		var aggregateSw 		= nvl(obj.aggregateSw, "");
		var discountSw 			= nvl(obj.discountSw, "");
		var bascPerlCd 			= nvl(obj.bascPerlCd, "");
		var noOfDays 			= nvl(obj.noOfDays, "");
		var labelContent = 	'<label name="text" style="width: 8%; text-align: right; margin-right: 5px;" labelName="itemNo">'+itemNoOfPeril+'</label>'+
						'<label name="textPeril" style="width: 20%; text-align: left; margin-left: 5px;">'+perilName+'</label>'+ 
						'<label name="text" style="width: 12%; text-align: right;" class="moneyRate">'+perilRate+'</label>'+
						'<label name="text" style="width: 15%; text-align: right; margin-left: 5px;" class="money">'+tsiAmt+'</label>'+
						'<label name="text" style="width: 15%; text-align: right; margin-left: 5px;" class="money";>'+premAmt+'</label>'+
						'<label name="text" style="width: 15%; text-align: left; margin-left: 10px;margin-right: 10px;">'+compRem+'</label>';
		if (aggregateSw == "Y"){
			labelContent = labelContent + '<label style="width: 3%; text-align: right;"><img name="checkedImg" style="width: 10px; height: 10px; text-align: right; display: block; margin-left: 1px; float: right;" />'+ "</label>";
		} else {
			labelContent = labelContent + '<label style="width: 3%; text-align: right;"><span style="float: right; width: 10px; height: 10px;">-</span>'+ "</label>";
		}
		if (surchargeSw == "Y"){
			labelContent = labelContent + '<label style="width: 3%; text-align: right;"><img name="checkedImg" style="width: 10px; height: 10px; text-align: right; display: block; margin-left: 1px; float: right;" />'+ "</label>";
		} else {
			labelContent = labelContent + '<label style="width: 3%; text-align: right;"><span style="float: right; width: 10px; height: 10px;">-</span>'+ "</label>";
		}
		if (discountSw == "Y"){
			labelContent = labelContent + '<label id="discountSwPeril'+itemNoOfPeril+perilCd+'" name = discountSwPeril style="width: 3%; text-align: right;"><img name="checkedImg" style="width: 10px; height: 10px; text-align: right; display: block; margin-left: 1px; float: right;" />'+ "</label>";
		} else {
			labelContent = labelContent + '<label id="discountSwPeril'+itemNoOfPeril+perilCd+'" name = discountSwPeril style="width: 3%; text-align: right;"><span style="float: right; width: 10px; height: 10px;">-</span>'+ "</label>";
		}
		var hiddenContent = 
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
			'<input type="hidden" name="perilNoOfDayss" 	value="'+noOfDays+'" />';
		if ($F("btnAddItemPeril") == "Update")	{
			$("rowPeril"+itemNoOfPeril+perilCd).update(labelContent + hiddenContent);
		} else {
			var itemPerilTable 		= $("itemPerilMainDiv"); 
			var itemPerilMotherDiv 	= $("itemPerilMotherDiv"+itemNoOfPeril);
			var isNew 				= false;
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
			newDiv.update(labelContent + hiddenContent);
			itemPerilMotherDiv.insert({bottom: newDiv});	
			if (isNew)	{	
				itemPerilTable.insert({bottom: itemPerilMotherDiv});
			}
			
			initializePerilRow(newDiv);
			Effect.Appear("rowPeril"+itemNoOfPeril+perilCd, {
				duration: .2,
				afterFinish: function () {
					hideAllItemPerilOptions();
					selectItemPerilOptionsToShow();
					hideExistingItemPerilOptions();				
					checkIfToResizePerilTable("itemPerilMainDiv", "itemPerilMotherDiv"+obj.itemNo, "row2");
					if (($$("div#itemTable .selectedRow")).length < 1){ 
						$("itemPerilMainDiv").hide();
					}else{
						if (obj.itemNo == $F("itemNo")){
							$("itemPerilMainDiv").show();
						}else {
							$("itemPerilMotherDiv"+obj.itemNo).hide();
						}
					}
				}
			});
		}
		/*
		$$("label[name='text']").each(function (label)	{
			if ((label.innerHTML).length > 15)    {
	            label.update((label.innerHTML).truncate(15, "..."));
	        }
		});
		$$("label[name='textPeril']").each(function (label)	{
			if ((label.innerHTML).length > 25)    {
	            label.update((label.innerHTML).truncate(25, "..."));
	        }
		});
		*/
		changeCheckImageColor();
		getTotalAmounts();
		clearItemPerilFields();
	} catch (e){
		showErrorMessage("addObjToPerilTable", e);
	}
}