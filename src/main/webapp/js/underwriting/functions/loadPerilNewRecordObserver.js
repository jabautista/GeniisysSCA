/*	Created by	: mark jm 09.16.2010
 * 	Description	: Load observer for new record created in peril
 * 	Parameter	: newDiv - div where to applied the observers
 */
function loadPerilNewRecordObserver(newDiv){
	newDiv.observe("mouseover", function ()	{
		newDiv.addClassName("lightblue");
	});
	newDiv.observe("mouseout", function ()	{
		newDiv.removeClassName("lightblue");
	});

	newDiv.observe("click", function ()	{
		newDiv.toggleClassName("selectedRow");
		if (newDiv.hasClassName("selectedRow"))	{
			try {
				$$("div[name='row2']").each(function (r)	{
					if (newDiv.getAttribute("id") != r.getAttribute("id"))	{
						r.removeClassName("selectedRow");
					}
				});

				var perilCd						= newDiv.down("input", 3).value;
				var peril 						= $("perilCd");
				var index = 0;
				for (var j=0; j<peril.length; j++){
					if (peril.options[j].value == perilCd){
						index = j;
					}
				}
				$("perilCd").selectedIndex 		= index;
				$("perilRate").value 		    = formatToNineDecimal(newDiv.down("input", 4).value);
				$("perilTsiAmt").value			= formatCurrency(newDiv.down("input", 5).value);
				$("premiumAmt").value			= formatCurrency(newDiv.down("input", 6).value);
				$("compRem").value				= changeSingleAndDoubleQuotes((newDiv.down("input", 7).value == "---")? "" : newDiv.down("input", 7).value);
				$("perilTarfCd").value			= newDiv.down("input", 10).value;
				$("perilAnnTsiAmt").value		= newDiv.down("input", 11).value;
				$("perilAnnPremAmt").value		= newDiv.down("input", 12).value;
				$("perilPrtFlag").value			= newDiv.down("input", 13).value;
				$("perilRiCommRate").value		= newDiv.down("input", 14).value;
				$("perilRiCommAmt").value		= newDiv.down("input", 15).value;
				$("perilSurchargeSw").value		= newDiv.down("input", 16).value;
				$("perilBaseAmt").value			= newDiv.down("input", 17).value;
				$("perilAggregateSw").value		= newDiv.down("input", 18).value;
				$("perilDiscountSw").value		= newDiv.down("input", 19).value;

				$("tempPerilCd").value			= $("perilCd").value;
				$("tempPerilRate").value 		= newDiv.down("input", 4).value;
				$("tempTsiAmt").value			= formatCurrency(newDiv.down("input", 5).value);
				$("tempPremAmt").value			= formatCurrency(newDiv.down("input", 6).value);
				$("tempCompRem").value			= newDiv.down("input", 7).value;

				$("btnAddItemPeril").value = "Update";

				if ("Y" == newDiv.down("input", 18).value){
					$("aggregateSw").checked = true;
				}

				enableButton("btnDeletePeril");
				} catch (e){
					showErrorMessage("loadPerilNewRecordObserver", e);
				}
			}
		else{
			try {
				clearItemPerilFields();
				$("btnAddItemPeril").value = "Add";
				disableButton("btnDeletePeril");
			} catch (e){
				showErrorMessage("loadPerilNewRecordObserver - else", e);
			}
		}
	});	
}