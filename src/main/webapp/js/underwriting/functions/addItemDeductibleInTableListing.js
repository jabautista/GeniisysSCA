/*
 * Created By	: andrew robes
 * Date			: November 8, 2010
 * Description	: Creates deductible row and add it to deductible listing
 * Parameter	: obj - object containing the deductible details
 */
function addItemDeductibleInTableListing(obj){
	try {
		var id = "2" + obj.itemNo + nvl(obj.perilCd, "0") + obj.dedDeductibleCd;
		var content =    '<input type="hidden" name="dedItemNo2" 			value="'+obj.itemNo+'" />'+
						 '<input type="hidden" name="dedPerilName2" 		value="'+obj.perilName+'" />'+ 
						 '<input type="hidden" name="dedPerilCd2" 			value="'+obj.perilCd+'" />'+
						 '<input type="hidden" name="dedTitle2" 			value="'+obj.deductibleTitle+'" />'+
						 '<input type="hidden" name="dedDeductibleCd2" 		value="'+obj.dedDeductibleCd+'" />'+
						 '<input type="hidden" name="dedAmount2"			value="'+obj.deductibleAmt+'" />'+
						 '<input type="hidden" name="dedRate2" 				value="'+obj.deductibleRate+'" />'+
						 '<input type="hidden" name="dedText2" 				value="'+obj.deductibleText+'" />'+
						 '<input type="hidden" name="dedAggregateSw2"		value="'+obj.aggregateSw+'" />'+
						 '<input type="hidden" name="dedCeilingSw2" 		value="'+obj.ceilingSw+'" />' + 
						 '<input type="hidden" name="dedDeductibleType2"	value=""'+obj.deductibleType+'" />';					 
			   content+= '<label style="width: 33px; text-align: center;">';						
				         if (obj.aggregateSw == 'Y') {
				        	 content += '<img name="checkedImg" class="printCheck" src="'+checkImgSrc+'" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 11px;  " />';
						 } else {
						     content += '<span style="width: 33px; height: 10px; text-align: left; display: block; margin-left: 3px;"></span>';
						 }
				         
			   content+= '</label>'+
						   	 '<label style="width: 70px; text-align: right; margin-right: 10px;">'+obj.itemNo+'</label>'+
							 '<label style="width: 213px; text-align: left; margin-left: 6px;" title="'+obj.deductibleTitle+'" id="dedTitle'+id+'" name="dedTitle2">'+obj.deductibleTitle.truncate(25, "...")+'</label>'+  // added id="...." name="...." - dencal25 2010-09-24
							 '<label style="width: 155px; text-align: left;  margin-left: 20px;" title="'+obj.deductibleText+'">'+obj.deductibleText.truncate(20, "...")+'</label>'+
							 '<label style="width: 119px; text-align: right;">'+(obj.deductibleRate == "" ? "-" : formatToNineDecimal(obj.deductibleRate))+'</label>'+
							 '<label style="width: 130px; text-align: right;">'+(obj.deductibleAmt == "" ? "-" : formatCurrency(obj.deductibleAmount))+'</label>'+			  					
						 '</div>';
						
		var rowDeductible = new Element('div');
		rowDeductible.setAttribute("name", "ded2");
		rowDeductible.setAttribute("id", "ded"+id);
		rowDeductible.setAttribute("item", obj.itemNo);
		rowDeductible.setAttribute("dedCd", obj.dedDeductibleCd);
		rowDeductible.setAttribute("perilCd", obj.perilCd);
		rowDeductible.addClassName("tableRow");
		
		rowDeductible.update(content);
		$("wdeductibleListing2").insert({bottom: rowDeductible});
		
		rowDeductible.observe("mouseover", function () {
			rowDeductible.addClassName("lightblue");
		});
		
		rowDeductible.observe("mouseout", function () {
			rowDeductible.removeClassName("lightblue");
		});
		
		rowDeductible.observe("click", function ()	{
			rowDeductible.toggleClassName("selectedRow");
			clickDeductibleRow(rowDeductible);
/*			if (rowDeductible.hasClassName("selectedRow"))	{
				$$("div[name='ded2']").each(function (li)	{
					if (rowDeductible.getAttribute("id") != li.getAttribute("id"))	{
						li.removeClassName("selectedRow");
					}
				});
				
				for(var i=0; i<objDeductibles.length; i++){
					if (objDeductibles[i].itemNo == rowDeductible.down("input", 0).value 
							&& objDeductibles[i].perilCd == rowDeductible.down("input", 2).value 
							&& objDeductibles[i].dedDeductibleCd == rowDeductible.down("input", 4).value){
						$("inputDeductDisplay2").value = objDeductibles[i].deductibleTitle;					
						$("inputDeductDisplay2").setAttribute("deductibleCd", objDeductibles[i].deductibleCd);
					}
				}
				
				$("inputDeductible2").hide();
				$("inputDeductDisplay2").show();
				
				setDeductibleForm(rowDeductible, 2);
			} else {
				$("inputDeductible2").show();
				$("inputDeductDisplay2").clear();
				$("inputDeductDisplay2").hide();
				setDeductibleForm(null, 2);
			}*/
		});
		
		setDeductibleForm(null, 2);
	} catch (e){
		showErrorMessage("addItemDeductibleInTableListing", e);
	}
}