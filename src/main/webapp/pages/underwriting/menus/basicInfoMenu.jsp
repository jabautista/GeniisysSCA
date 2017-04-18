<div id="parInfoMenu" style="display: none;">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="basic" name="basic">Basic</a>
					<ul style="width: 230px;">
						<li><a id="basicInfo" name="basicInfo">Basic Information</a></li>
						<li><a id="bondBasicInfo" name="bondBasicInfo">Bond Basic Information</a></li>
						<li class="menuSeparator"></li>
						<li><a id="additionalEngineeringInfo" name="additionalEngineeringInfo">Additional Engineering Information</a></li>
						<li class="menuSeparator"></li>
						<li><a id="lineSublineCoverages" name="lineSublineCoverages">Line/Subline Coverages</a></li>
						<li class="menuSeparator"></li>
						<li><a id="cargoLimitsOfLiability" name="cargoLimitsOfLiability">Cargo Limits of Liability</a></li>
						<li><a id="carrierInfo" name="carrierInfo">Carrier Information</a></li>
						<li class="menuSeparator"></li>
						<li><a id="bankCollection" name="bankCollection">Bank Collection</a></li>
						<li><a id="reqDocsSubmitted" name="reqDocsSubmitted">Required Documents Submitted</a></li>
						<li><a id="initialAcceptance" name="initialAcceptance">Initial Acceptance</a></li>
						<li><a id="collateralTransaction" name="collateralTransaction">Collateral Transaction</a></li>
						<li class="menuSeparator"></li>
						<li><a id="limitsOfLiabilities" name="limitsOfLiabilities">Limits of Liabilities</a></li>
						<li class="menuSeparator"></li>
						<li><a id="miniReminder" name="miniReminder">Mini Reminder</a></li>
						<!--<li><a id="policyPrinting" name="policyPrinting">Policy Printing</a></li>
					--></ul>
				</li>
				<li><a id="packagePolicyItems" name="packagePolicyItems" style="display: none;"> Package Policy Items</a>
					<ul style="width: 200px;">
						<li><a id="packPolItems" 	name="packPolItems">Package Policy Items</a></li>
						<li><a id="packItemMC" 		name="packItemMC">Motor Car Item Information</a></li>
						<li><a id="packItemFI" 		name="packItemFI">Fire Item Information</a></li>
						<li><a id="packItemEN" 		name="packItemEN">Engineering Item Information</a></li>
						<li><a id="packItemMN" 		name="packItemMN">Cargo Item Information</a></li>
						<li><a id="packItemMH" 		name="packItemMH">Hull Item Information</a></li>
						<li><a id="packItemCA" 		name="packItemCA">Misc. Cas. Item Information</a></li>
						<li><a id="packItemAV" 		name="packItemAV">Aviation Item Information</a></li>
						<li><a id="packItemAH" 		name="packItemAH">Accident Item Information</a></li>
						<!-- <li><a id="packItemOthers" 	name="packItemOthers">Others</a></li> -->
					</ul>
				</li>
				<li><a id="itemInfo" 	   name="itemInfo">Item Information</a></li>
				<li><a id="clauses"		   name="clauses">Clauses</a></li>
				<li><a id="bondPolicyData" name="bondPolicyData" style="display: none;">Bond Policy Data</a></li>
				<li>
					<a id="bill" 		   name="bill">Bill</a>
					<ul style="width: 160px;">
						<li>
							<a id="discountSurcharge" 		name="discountSurcharge">Discount/Surcharge</a>
						</li>
						<li>
							<a id="groupItemsPerBill" 		name="groupItemsPerBill">Group Items per Bill</a>
						</li>
						<li>
							<a id="enterBillPremiums" 		name="enterBillPremiums">Enter Bill Premiums</a>
						</li>
						<li>
							<a id="enterInvoiceCommission" 	name="enterInvoiceCommission">Enter Invoice Commission</a>
						</li>
					</ul>
				</li>
				<li><a id="coInsurance" name="coInsurance">Co-Insurance</a>
					<ul style="width: 160px;">
						<li><a id="coInsurer" 		name="coInsurer">Co-Insurer</a></li>
						<li><a id="leadPolicy" 		name="leadPolicy">Lead-Policy</a></li>
					</ul>
				</li>
				<li><a id="distribution" name="distribution">Distribution</a>
					<ul style="width: 280px;">
						<li><a id="groupPrelimDist" 		 name="groupPrelimDist">Setup Groups for Preliminary Distribution</a></li>
						<li><a id="prelimPerilDist" 		 name="prelimPerilDist">Preliminary Peril Distribution</a></li>
						<!-- <li class="menuSeparator" id="distributionMenuSeparator"></li> removed by robert SR 5053 11.11.15 -->
						<!-- <li><a id="prelimOneRiskDist" 		 name="prelimOneRiskDist">Preliminary One Risk Distribution</a></li> removed by robert SR 5053 11.11.15 -->
						<li><a id="prelimOneRiskDistTsiPrem" name="prelimOneRiskDistTsiPrem">Preliminary One-Risk Distribution</a></li> <!-- modified by robert SR 5053 11.11.15  -->
						<!-- <li><a id="prelimDistTsiPrem" 		 name="prelimDistTsiPrem">Preliminary Peril Distribution by TSI/Prem</a></li>removed by robert SR 5053 11.11.15  -->
					</ul>					
				</li>
				<li><a id="post" 	name="post">Post</a></li>
				<li><a id="print" 	name="print">Print</a>
					<ul style="width: 160px;">
						<li><a id="coverNote" 				name="coverNote">Cover Note</a></li>						
						<li><a id="samplePolicy" 			name="samplePolicy">Sample Policy</a></li>
						<!-- <li><a id="menuCertificateOfCover" 	name="menuCertificateOfCover">Request for Completion</a></li>
						<li><a id="menuAcceptanceSlip" 		name="menuAcceptanceSlip">Inspection Request</a></li> -->
					</ul>
				</li>
				<li><a id="parExit"	name="parExit">Exit</a></li>
			</ul>
			<span style="float: right; margin-top: 2px;">
				<a href="#" id="roadMap" name="roadMap"><img style="float: left;" src="${pageContext.request.contextPath}/images/misc/roadMap.png" title="Road Map" class="button hover"/></a>
			</span>
		</div>
	</div>
</div>
<script type="text/javascript">

	//$("roadMap").hide(); //uncomment this line before deployment to client because roadMap is still under testing

/*
	$$("div#parInfoMenu a").each(function(a){		
		if(!checkUserModule(a.readAttribute("moduleId"))){
			a.setStyle("background-color: #C0C0C0; color: #fff;");
			var id = a.id;
			//$(id).stopObserving("click");
			$(id).observe("click", function(){return false;});			
			//Event.stopObserving(a, "click");
		}
	});*/
	
</script>