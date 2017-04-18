/**
 * #validation #peril
 * @return messageObj - containing fields (str) message and (bool) willPass
 */
function willProceedWithPerilAdd(){
	try{
		var perilCd = $F("selPerilName");
		var perilName = $("selPerilName").options[$("selPerilName").selectedIndex].getAttribute("perilName");
		var perilType = $("selPerilName").options[$("selPerilName").selectedIndex].getAttribute("perilType");
		var basicPerilCd = $("selPerilName").options[$("selPerilName").selectedIndex].getAttribute("basicPeril");
		var premiumRate = parseFloat($F("txtPerilRate").replace(/\$|\,/g,''));
		var tsiAmount =   parseFloat($F("txtTsiAmount").replace(/\$|\,/g,''));
		var premiumAmount = parseFloat($F("txtPremiumAmount").replace(/\$|\,/g,''));
		var annPremAmt = $F("txtPremiumAmount").replace(/\$|\,/g,'');
		var itemNo = parseInt(getSelectedRowId("itemRow"));
		
		if(perilName == null || perilName.blank()){
			showMessageBox("Peril name is required.", imgMessage.ERROR);
			return false;
		}else if(tsiAmount==0){
			showMessageBox("TSI Amount is required.", imgMessage.ERROR);
			return false;
		}else if(premiumAmount < tsiAmount && premiumAmount > 9999999999.99 && perilType!="A"){
			showMessageBox("Invalid Prem Amt. Value should be from <br />0.01 to 9,999,999,999.99 <br />and must not be less than TSI Amt.", imgMessage.ERROR);
			return false;
		}else if(perilType == "A" && tsiAmount>getLowestTSI(itemNo)){ // getHighestTSI // or only from ITS OWN basic peril?
			$("txtTsiAmount").value = "0.00";
			showMessageBox("TSI Amount is higher than basic peril's TSI Amount.", imgMessage.ERROR);
			return false;
		}else if(tsiAmount > 99999999999999.99){
			showMessageBox("Invalid TSI Amount. Value should be from 0.01 to 99,999,999,999,999.99.", imgMessage.ERROR);
			return false;
		}else{
			return true;
		}
	}catch(e){
		return false;
	}
}