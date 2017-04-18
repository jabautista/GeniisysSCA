/**
 * Function to change field labels related to endt peril when RI
 * @author andrew robes
 * @date 10.10.2011
 * @returns
 */
function setEndtPerilRIFormLabels(){
	try{
		$("tdTsiAmt").innerHTML = "TSI Ceded";
		$("tdPremAmt").innerHTML = "Premium Ceded";
		$("tdAnnTsiAmt").innerHTML = "Ann. TSI Ceded";
		$("tdAnnPremAmt").innerHTML = "Ann. Premium Ceded";
		$("tdTotalItemTsiAmt").innerHTML = "Total Item TSI Ceded";
		$("tdTotalItemPremAmt").innerHTML = "Total Item Premium Ceded";
		$("tdTotalItemAnnTsiAmt").innerHTML = "Total Item Ann. TSI Ceded";
		$("tdTotalItemAnnPremAmt").innerHTML = "Total Item Ann. Premium Ceded";
	} catch (e){
		showErrorMessage("setEndtPerilRIFormLabels", e);
	}
}