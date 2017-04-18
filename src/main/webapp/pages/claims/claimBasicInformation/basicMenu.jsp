<div id="mainNav" name="mainNav" claimsBasicMenu = "Y">
	<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
		<ul>
			<span id="clMenus" name="clMenus" style="display: block;">
				<li><a id="clmMainBasicInformation">Basic</a>
					<ul style="width: 160px;">
						<li><a id="clmBasicInformation">Basic Information</a></li>
						<li><a id="clmRequiredDocs">Required Documents</a></li>
						<li><a id="clmBasicPrelimLossRep">Preliminary Loss Report</a></li>
						<li class="menuSeparator"></li>
						<li><a id="miniReminder" name="miniReminder">Mini Reminder</a></li>
					</ul>
				</li>	
				<li><a id="clmItemInformation">Item Information</a></li>
				<li><a id="clmReserveSetup">Reserve Setup</a>
					<ul style="width: 160px;">
						<li><a id="clmReserve">Claim Reserve</a></li>
						<li><a id="clmReservePrelimLossAdvice">Preliminary Loss Advice</a></li>
						<li><a id="clmReservePrelimLossRep">Preliminary Loss Report</a></li>
					</ul>
				</li>
				<li><a id="clmLossExpenseHist">Loss/Expense History</a>
					<ul style="width: 160px;">
						<li><a id="clmSubLossExpenseHist">Loss/Expense History</a></li>
					</ul>
				</li>
				<li><a id="clmGenAdvice">Generate Advice</a>
					<ul style="width: 160px;">
						<li><a id="clmSubGenAdvice">Generate Advice</a></li>
						<li><a id="clmGenerateBatchCSR">Batch CSR</a></li>
						<li><a id="clmGenerateSpecialCSR">Special CSR</a></li>
						<li><a id="clmGenerateFLA">Generate FLA</a></li>
						<li><a id="clmGenerateLOA">Letter of Authority</a></li>
						<li><a id="clmGenerateCashSettlement">Cash Settlement</a></li>
						<li><a id="clmGenerateFinalLossReport">Final Loss Report</a></li>
					</ul>
				</li>
				<li><a id="clmLossRecovery">Loss Recovery</a>
					<ul style="width: 180px;">
						<li><a id="clmRecoveryInformation">Recovery Information</a></li>
						<li><a id="clmRecoveryDistribution">Recovery Distribution</a></li>
						<li><a id="clmRecoveryAcctEntries">Generate Recovery Acct. Entries</a></li>
					</ul>	
				</li>
				<li><a id="clmReports">Reports</a>
					<ul style="width: 160px;">
						<li><a id="clmReportsPrintDocs">Print Documents</a></li>
					</ul>
				</li>
				<li><a id="clmViewPolInformation">View Policy Information</a></li>
				<li><a id="clmExit">Exit</a></li>
			</span>	
		</ul>
	</div>
</div>

<script>
	observeAccessibleModule(accessType.MENU, "GICLS010", "clmBasicInformation", function(){
		objCLM.dcOverrideFlag = "N"; //marco - 07.23.2014
		showClaimBasicInformation();
	});
	observeAccessibleModule(accessType.MENU, "GICLS011", "clmRequiredDocs", showClaimRequiredDocs);
	observeAccessibleModule(accessType.MENU, "GICLS029", "clmBasicPrelimLossRep", showPreliminaryLossReport);
	observeAccessibleModule(accessType.MENU, "GIUTS034", "miniReminder", showMiniReminder);
	//observeAccessibleModule(accessType.MENU, getClaimItemModuleId(objCLMGlobal.lineCd), "clmItemInformation", showClaimItemInfo); //comment out by jeffdojello 10.01.2013
	observeAccessibleModule(accessType.MENU, getClaimItemModuleId(nvl(objCLMGlobal.menuLineCd, objCLMGlobal.lineCd)), "clmItemInformation", showClaimItemInfo); //replaced by menuLineCd jeffdojello 10.01.2013
	observeAccessibleModule(accessType.MENU, "GICLS041", "clmReportsPrintDocs", printClaimsDocs); 
	observeAccessibleModule(accessType.MENU, "GICLS030", "clmSubLossExpenseHist", function(){ fromClaimMenu = "N";showLossExpenseHistory();});
	observeAccessibleModule(accessType.MENU, "GICLS032", "clmSubGenAdvice", showClaimAdvice);
	observeAccessibleModule(accessType.MENU, "GICLS043", "clmGenerateBatchCSR", showBatchCSRListing);
	observeAccessibleModule(accessType.MENU, "GICLS024", "clmReserve", showClaimReserve); 
	observeAccessibleModule(accessType.MENU, "GICLS029", "clmReservePrelimLossRep", showPreliminaryLossReport);
	observeAccessibleModule(accessType.MENU, "GICLS028", "clmReservePrelimLossAdvice", showPrelimLossAdvice);
	observeAccessibleModule(accessType.MENU, "GICLS034", "clmGenerateFinalLossReport", showFinalLossReport);
	observeAccessibleModule(accessType.MENU, "GIPIS100", "clmViewPolInformation",
		function(){
			showViewPolicyInformationPage(objCLMGlobal.policyId);
		});
	observeAccessibleModule(accessType.MENU, "GICLS025", "clmRecoveryInformation", showRecoveryInformation);
	observeAccessibleModule(accessType.MENU, "GICLS054", "clmRecoveryDistribution", showRecoveryDistribution); 
	observeAccessibleModule(accessType.MENU, "GICLS033", "clmGenerateFLA", showGenerateFLAPage);
	observeAccessibleModule(accessType.MENU, "GICLS055", "clmRecoveryAcctEntries", function() {
		objCLMGlobal.callingForm = "GICLS010"; //marco - 08.06.2015 - replaced from GICLS025
		showGenerateRecoveryAcctEntries(objCLMGlobal.claimId, null);
	});
	observeAccessibleModule(accessType.MENU, "GIACS086", "clmGenerateSpecialCSR",
	function(){
		objCLMGlobal.callingForm = "GIACS055"; 
		showOtherBranchRequests("", "Y","SCSR","Y");
	});
	
	
</script>
