/**
 * Makes a peril information Div Element using perilObj
 * 
 * @return
 */
function makeGIPIQuoteItemPerilRow(perilObj){
	var perilRow = new Element("div");
	var compRem = perilObj.compRem!=null ? perilObj.compRem.truncate(40, "...") : "";
	perilRow.setAttribute("id", "perilRow" + perilObj.itemNo + perilObj.perilName);
	perilRow.setAttribute("name", "perilRow");
	perilRow.setAttribute("itemNo", perilObj.itemNo);
	perilRow.setAttribute("rowCd", perilObj.itemNo);
	perilRow.setAttribute("perilkey", perilObj.itemNo + "" + perilObj.perilCd + "" + perilObj.perilName);
	perilRow.addClassName("tableRow");
	
	var content = 
	  '<label style="width: 25%; text-align: left; padding-left: 40px;">'+ unescapeHTML2(perilObj.perilName) + '</label>'+
	  '<label style="width: 10%; text-align: right;">' + formatToNineDecimal(perilObj.perilRate == "" ? "0" : perilObj.perilRate) + '</label>'+
	  '<label style="width: 13%; text-align: right;">' + formatCurrency(perilObj.tsiAmount) + '</label>'+
	  '<label style="width: 13%; text-align: right;">' + formatCurrency(perilObj.premiumAmount) + '</label>'+
	  '<label style="width: 32%; text-align: left; padding-left: 20px;">' + compRem +'</label>'+
	  '<input type="hidden" id="hidPerilCd" name="hidPerilCd" value="' + perilObj.perilCd + '"/>' +
	  '<input type="hidden" id="rowCode" name="rowCode" value="' + perilObj.itemNo + '' + perilObj.perilCd + '' + perilObj.perilName + '"/>';
	// rowCode acts as an ID for the perilObject, when it is retrieved again
	// from the perilListing
	perilRow.update(content);
	
	loadRowMouseOverMouseOutObserver(perilRow);
	
	perilRow.observe("click", function(){
		perilRow.toggleClassName("selectedRow");
		if(perilRow.hasClassName("selectedRow")){
			$("selPerilName").disable();
			$$("div[name='perilRow']").each(function(ar){
				if(perilRow.getAttribute("id") != ar.getAttribute("id")){
					ar.removeClassName("selectedRow");
					clearChangeAttribute("itemInformationDiv");
					clearChangeAttribute("perilInformationDiv");
					//checkLineCdForAddInfoDiv();
					//clearChangeAttribute("deductibleInformationSectionDiv");
				}
			});
			
			var selPerilName = $("selPerilName").options;
			var index = 0;
			var anOption = null;
			for(var d=0; d<selPerilName.length; d++){
				anOption = selPerilName[d];
				if(anOption.value == perilObj.perilCd){
					index = d;
					d = selPerilName.length; // end loop
				}
			}
			
			var aper = null;
			for(var index = 0; index < objItemPerilLov.length; index++){
				aper = objItemPerilLov[index];
				if (aper.perilCd == perilObj.perilCd){
					index = objItemPerilLov.length; // stop loop
				}
			}
			
			// selPerilName[0].text = aper.perilCd + " - " +
			// changeSingleAndDoubleQuotes(aper.perilName);
			var someText = (aper.perilType == "A")? " - Allied Peril": " - Basic Peril";
			selPerilName[0].innerHTML = aper.perilCd + " - " + changeSingleAndDoubleQuotes(aper.perilName) + someText;
			selPerilName[0].value = aper.perilCd;
			$("selPerilName").selectedIndex = 0;
			$("txtPerilRate").value = formatToNineDecimal(perilObj.perilRate); // newDiv.down("input", 2).value;
			$("txtTsiAmount").value = formatCurrency(perilObj.tsiAmount); // newDiv.down("input", 3).value;
			$("txtPremiumAmount").value = formatCurrency(perilObj.premiumAmount); // newDiv.down("input", 4).value;
			$("txtRemarks").value = perilObj.compRem; // newDiv.down("input", 5).value;
			enableButton("btnDeletePeril");
			$("btnAddPeril").value = "Update";
		}else{
			var selPerilName = $("selPerilName").options;
			selPerilName[0].value = "";
			selPerilName[0].innerHTML = "";
			$("selPerilName").enable();
			resetQuoteItemPerilForm();
			clearChangeAttribute("itemInformationDiv");
			clearChangeAttribute("perilInformationDiv");
			// checkLineCdForAddInfoDiv();
			// clearChangeAttribute("deductibleInformationSectionDiv");
		}
	});
	
	return perilRow;
}