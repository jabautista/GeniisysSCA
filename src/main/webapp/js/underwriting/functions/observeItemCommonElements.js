/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	07.27.2011	mark jm			set the observer for item (common) elements
 * 	09.08.2011	mark jm			added observe for itemNo
 */
function observeItemCommonElements(){
	try{
		$("itemNo").observe("blur", function(){
			$("itemNo").value = removeLeadingZero($F("itemNo"));
			
			if(checkItemExists2($F("itemNo")) && $F("btnAddItem") == "Add"){
				customShowMessageBox("Item No. must be unique.", imgMessage.ERROR, "itemNo");
				return false;
			}
		});		
		
		$("editDesc").observe("click", function() {
			showOverlayEditor("itemDesc", 2000, $("itemDesc").hasAttribute("readonly"));
		});
		
		$("editDesc2").observe("click", function() {
			showOverlayEditor("itemDesc2", 2000, $("itemDesc2").hasAttribute("readonly"));
		});
		
		$("currency").observe("change", function(){		
			if(!($F("currency").empty())){				
				if(objFormVariables.varOldCurrencyCd != $F("currency")){
					objFormVariables.varGroupSw = "Y";				
				}				
				getRates();
				$("currFloat").value = $F("currency");
				//$("rate").readOnly = $("currency").value == 1 ? true : false;
				$("currency").value == 1 ? $("rate").setAttribute("readonly", "readonly") : $("rate").removeAttribute("readonly");
			}else{
				$("rate").value = "";
			}						
		});

		$("currency").observe("focus", function(){
			objFormVariables.varOldCurrencyCd = $F("currency");
		});
		
		$("rate").setAttribute("currencyLOV", "currency");
		$("rate").setAttribute("rateLOV", "currFloat");
		$("rate").setAttribute("hasOwnKeyUp", "Y");
		$("rate").setAttribute("hasOwnBlurUp", "Y");
		
		$("rate").observe("blur", function(){			
			var val = $("rate").value;
			
			if(isNaN(val.replace(/,/g, "")) || val.blank()){				
				$("rate").value = "";
			}else{
				if(parseFloat(val) < parseFloat($("rate").getAttribute("min")) || parseFloat(val) > parseFloat($("rate").getAttribute("max"))){					
					showWaitingMessageBox(getNumberFieldErrMsg($("rate"), true), imgMessage.ERROR, function(){
						var currencyLOV = $("rate").getAttribute("currencyLOV");
						var rateLOV = $("rate").getAttribute("rateLOV");
						
						if(currencyLOV != null){
							$("rate").value = formatToNineDecimal($(rateLOV).options[$(currencyLOV).selectedIndex].value);
						}
						
						$("rate").focus();
					});
					return false;
				}else{
					$("rate").value = (val == "" ? "" : formatTo9DecimalNoParseFloat(val));
				}
			}			
		});
		
		$("rate").observe("keyup", function(){
			var pattern = $("rate").getAttribute("regExpPatt"); 
			if(pattern.substr(0,1) == "p"){
				if($("rate").value.include("-")){				
					showWaitingMessageBox(getNumberFieldErrMsg($("rate"), true), imgMessage.ERROR, function(){
						var currencyLOV = $("rate").getAttribute("currencyLOV");
						var rateLOV = $("rate").getAttribute("rateLOV");
						
						if(currencyLOV != null){
							$("rate").value = formatToNineDecimal($(rateLOV).options[$(currencyLOV).selectedIndex].value);
						}
						
						$("rate").focus();
					});
					return false;
				}else{
					$("rate").value = ($("rate").value).match(RegExDecimal[pattern])[0];
				}		 
			}else{
				$("rate").value = ($("rate").value).match(RegExDecimal[pattern])[0];
			}			   						
		});
	}catch(e){
		showErrorMessage("observeItemCommonElements", e);
	}
}