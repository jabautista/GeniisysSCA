<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<div id="mainNav" name="mainNav">
	<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
		<c:choose>
			<c:when test="${not empty PARAMETERS['USER']}">
				<ul>
					<span id="acMenus" name="acMenus" style="display: block;">
						<li title="Home"><a id="home" class="menuHome" name="home"
							style="opacity: 0.8; width: 10px; background: url(${pageContext.request.contextPath}/images/main/home.png) center center no-repeat;"></a></li>
						<li id="cashReceipts"><a>Cash Receipts</a>
							<ul style="width: 160px;">
								<li><a id="enterTransactionsReceipts"
									name="enterTransactionsReceipts">Enter Transactions</a>
									<ul style="width: 160px;">
										<li><a id="generateOR" name="generateOR">Generate OR</a></li>
										<li><a id="orListing" name="orListing">OR Listing</a></li>
										<li><a id="enterManualOR" name="enterManualOR">Enter
												Manual OR</a></li>
										<li><a id="otherBranchOR" name="otherBranchOR">Other
												Branch OR</a>
											<ul style="width: 160px;">
												<li><a id="generateOtherOR" name="generateOtherOR">Generate
														OR</a></li>
												<li><a id="enterOtherManualOR"
													name="enterOtherManualOR">Enter Manual OR</a></li>
												<li><a id="cancelOtherOR" name="cancelOtherOR">Cancel
														OR</a></li>
											</ul></li>
										<li><a id="pdcPayment" name="pdcPayment">PDC Payment</a>
											<ul style="width: 180px;">
												<li><a id="acknowledgementReceipts"
													name="acknowledgementReceipts">Acknowledgment Receipt</a></li>
												<li><a id="otherBranchAPDC" name="otherBranchAPDC">Other
														Branch APDC</a></li>
												<li><a id="menuDatedChecks" name="menuDatedChecks">Dated
														Checks</a></li>
											</ul></li>
										<li><a id="postDatedChecks" name="postDatedChecks">Post dated Checks</a></li>
										<li><a id="batchOrPrinting" name="batchOrPrinting">Batch
												OR Printing</a></li>
										<li><a id="batchCommSlipPrinting"
											name="batchCommSlipPrinting">Batch Comm Slip Printing</a></li>
										<li><a id="closeDCB" name="closeDCB">Close DCB</a></li>
										<li><a id="cancelOR" name="cancelOR">Cancel OR</a></li>
									</ul></li>
								<li><a id="utilitiesReceipts" name="utilitiesReceipts">Utilities</a>
									<ul style="width: 180px;">
										<li><a id="dcbNoMaintenance" name="dcbNoMaintenance">DCB
												No. Maintenance</a></li>
										<li><a id="enterSpoiledOR" name="enterSpoiledOR">Enter
												Spoiled O.R.</a></li>
										<li><a id="menuChangePaymentMode"
											name="menuChangePaymentMode">Change Payment Mode</a></li>
									</ul></li>
								<li><a id="inquiryReceipts" name="inquiryReceipts">Inquiry</a>
									<ul style="width: 180px;">
										<li><a id="menuOrStatus" name="menuOrStatus">OR
												Status</a></li>
										<li><a id="pdcPaymentsInquiry">PDC Payments</a></li>
										<!-- pol cruz 04.19.2013  -->
									</ul></li>
								<li><a id="reportsReceipts" name="reportsReceipts">Reports</a>
									<ul style="width: 220px;">
										<li><a id="dailyCollectionReport"
											name="dailyCollectionReport">Daily Collection Report</a></li>
										<li><a id="cashReceiptRegister"
											name="cashReceiptRegister">Cash Receipts Register</a></li>
										<li><a id="pdcRegister" name="pdcRegister">PDC
												Register</a></li>
										<li><a id="premiumDeposit" name="premiumDeposit">Premium
												Deposit</a></li>
										<li><a id="premiumCollections" name="premiumCollections">Premium
												Collections</a></li>
										<li><a id="advancedPremiumPayment"
											name="advancedPremiumPayment">Advanced Premium Payment</a></li>
										<li><a id="directPremiumCollections"
											name="directPremiumCollections">Direct Premium
												Collections</a></li>
										<li><a id="officialReceiptRegister"
											name="officialReceiptRegister">Official Receipt Register</a></li>
										<li><a id="listOfBankDeposits" name="listOfBankDeposits">List
												of Bank Deposits</a></li>
										<li><a id="bookUnbookedPoliciesCollection"
											name="bookUnbookedPoliciesCollection">Collections for
												Booked/Unbooked Policies</a></li>
										<li><a id="collectionAnalysis" name="collectionAnalysis">Collection
												Analysis</a></li>
										<li><a id="schedOfAppliedComm" name="schedOfAppliedComm">Schedule
												of Applied Commission</a></li>
									</ul></li>
							</ul></li>
						<li><a id="generalDisbursements" name="generalDisbursements">General
								Disbursements</a>
							<ul style="width: 160px;">
								<li><a id="enterTransactionsDisbursements"
									name="enterTransactionsDisbursements">Enter Transactions</a>
									<ul style="width: 200px;">
										<li><a id="disbursementRequests"
											name="disbursementRequests">Disbursement Requests</a>
											<ul style="width: 175px;">
												<li><a id="claimPaymentRequests"
													name="claimPaymentRequests">Claim Payment Requests</a></li>
												<li><a id="facultativePremiumPayment"
													name="facultativePremiumPayment">Facultative Premium
														Payment</a></li>
												<li><a id="commissionPayment" name="commissionPayment">Commission
														Payment</a></li>
												<li><a id="otherPayments" name="otherPayments">Other
														Payments</a></li>
												<li><a id="cancelRequest" name="cancelRequest">Cancel
														Request</a></li>
												<li><a id=scsRequest name="scsRequest">Special
														Claim Settlement Request</a></li>
											</ul></li>
										<li><a id="otherBranchRequest" name="otherBranchRequest">Other
												Branch Requests</a>
											<ul style="width: 175px;">
												<li><a id="obrClaimPaymentRequests"
													name="obrClaimPaymentRequests">Claim Payment Requests</a></li>
												<li><a id="obrFacultativePremiumPayment"
													name="obrFacultativePremiumPayment">Facultative Premium
														Payment</a></li>
												<li><a id="obrCommissionPayment"
													name="obrCommissionPayment">Commission Payment</a></li>
												<li><a id="obrOtherPayments" name="obrOtherPayments">Other
														Payments</a></li>
												<li><a id="obrCancelRequest" name="obrCancelRequest">Cancel
														Request</a></li>
												<li><a id=obrScsRequest name="obrScsRequest">Special
														Claim Settlement Request</a></li>
											</ul></li>
										<!-- added by Kris 04.11.2013 -->
										<li><a id="menuGenerateDV" name="menuGenerateDV">Generate
												DV</a></li>
										<li><a id="menuEnterManualDV" name="menuEnterManualDV">Enter
												Manual DV</a></li>
										<li><a id="menuDVListing" name="menuDVListing">DV
												Listing</a></li>
										<li><a id="menuOtherBranchDV" name="menuOtherBranchDV">Other
												Branch DV</a>
											<ul style="width: 160px;">
												<li><a id="menuOtherBranchGenerateDV"
													name="menuOtherBranchGenerateDV">Generate DV</a></li>
												<li><a id="menuOtherBranchManualDV"
													name="menuOtherBranchManualDV">Manual DV</a></li>
												<li><a id="menuOtherBranchDVListing"
													name="menuOtherBranchDVListing">DV Listing</a></li>
												<li><a id="menuOtherBranchCancelDV"
													name="menuOtherBranchCancelDV">Cancel DV</a></li>
											</ul></li>
										<li><a id="menuCancelDV" name="menuCancelDV">Cancel
												DV</a></li>
										<li><a id="menuBatchCheckPrinting"
											name="menuBatchCheckPrinting">Batch Check Printing</a></li>
										<li><a id="checkReleaseInfo" name="checkReleaseInfo">Check
												Release Info</a></li>
										<li><a id="updateCheckStatus" name="updateCheckStatus">Update
												Check Status</a></li>
										<!-- Added by Gzelle 04152013 -->
										<li><a id="replenishmentOfRevolvingFund"
											name="replenishmentOfRevolvingFund">Replenishment of
												Revolving Fund</a></li>
									</ul></li>
								<li><a id="utilitiesDisbursements"
									name="utilitiesDisbursements">Utilities</a>
									<ul style="width: 175px;">
										<li><a id="menuModifyCommInvoice"
											name="menuModifyCommInvoice">Modify Commission Invoice</a></li>
										<li><a id="menuCopyPaymentRequest"
											name="menuCopyPaymentRequest">Copy Payment Request</a></li>
										<!-- begin Shan 05.29.2013 -->
										<li><a id="menuUpdateCheckNumber"
											name="menuUpdateCheckNumber">Update Check Number</a></li>
										<!-- end -->
									</ul></li>

								<li><a id="inquiryDisbursements"
									name="inquiryDisbursements">Inquiry</a>
									<ul style="width: 175px;">
										<li><a id="menuPaymentRequestStatus"
											name="menuPaymentRequestStatus">Payment Request Status</a></li>
										<li><a id="menuDVStatus" name="menuDVStatus">DV
												Status</a></li>
										<li><a id="menuChecksPaidPerPayee"
											name="menuChecksPaidPerPayee">Checks Paid per Payee</a></li>
										<li><a id="checksPaidPerDepartment"
											name="checksPaidPerDepartment">Checks Paid per Department</a></li>
										<li><a id="commissionInquiry" name="commissionInquiry">Commission
												Inquiry</a></li>
									</ul></li>
								<li><a id="reportsDisbursements"
									name="reportsDisbursements">Reports</a>
									<ul style="width: 175px;">
										<li><a id="paymentRequestList" name="paymentRequestList">Payment
												Request List</a></li>
										<li><a id="menuDisbursementRegister"
											name="menuDisbursementRegister">Disbursement Register</a></li>
										<li><a id="disbursementList" name="disbursementList">Disbursement
												List</a></li>
										<li><a id="menuCheckRegister" name="menuCheckRegister">Check
												Register</a></li>
										<li><a id="menuCheckReleaseReport"
											name="menuCheckReleaseReport">Check Release Report</a></li>
										<li><a id="commissionsDue" name="commissionsDue">Commissions
												Due</a></li>
										<li><a id="menuCommissionVoucher"
											name="menuCommissionVoucher">Commission Voucher</a></li>
										<li><a id="menuBatchCommVoucherPrinting" name="menuBatchCommVoucherPrinting">Batch Comm Voucher Printing</a></li>
										<li><a id="menuModifiedCommissions"
											name="menuModifiedCommissions">Modified Commissions</a></li>
										<li><a id="menuCommissionsPaidRegister" name="menuCommissionsPaidRegister">Commissions Paid</a></li>
										<li><a id="menuOverridingCommissionVoucher"
											name="menuOverridingCommissionVoucher" style="">Overriding
												Commission Voucher</a></li>
										<li><a id="menuContingentProfitCommission"
											name="menuContingentProfitCommission">Profit Commission</a></li>
										<li><a id="expenseReportPerDept"
											name="expenseReportPerDept">Expense Report per Dept</a></li>
									</ul></li>
							</ul></li>
						<li><a id="generalLedger" name="generalLedger">General
								Ledger</a>
							<ul style="width: 160px;">
								<!-- added by steven 03.18.2013 -->
								<li><a id="enterTransactionLedger"
									name="enterTransactionLedger">Enter Transaction</a>
									<ul style="width: 180px;">
										<li><a id="journalEntry" name="journalEntry">Enter
												Journal Entries</a></li>
										<li><a id="journalEntryListing"
											name="journalEntryListing">Journal Entries Listing</a></li>
										<li><a id="cancelJVListing" name="cancelJVListing">Cancel
												JV</a></li>
										<!-- added by Kris 03.20.2013 -->
										<li><a id="menuAddCreditDebitMemo"
											name="menuAddCreditDebitMemo">Enter Credit/Debit Memo</a></li>
										<li><a id="menuCreditDebitMemo"
											name="menuCreditDebitMemo">Credit/Debit Memo Listing</a></li>
										<li><a id="menuCancelCreditDebitMemo"
											name="menuCancelCreditDebitMemo">Cancel CM/DM</a></li>
									</ul></li>
								<li><a id="utilitiesLedger" name="utilitiesLedger">Utilities</a>
									<ul style="width: 100px;">
										<li><a id="copyJV" name="copyJV">Copy JV</a></li>
									</ul></li>
								<li><a id="inquiryLedger" name="inquiryLedger">Inquiry</a>
									<ul style="width: 180px;">
										<!-- added by Shan 08.22.2013 -->
										<li><a id="menuViewJournalEntries"
											name="menuViewJournalEntries">View Journal Entries</a></li>
										<!-- added by Shan 04.19.2013 -->
										<li><a id="menuGLAccountTransaction"
											name="menuGLAccountTransaction">GL Account Transaction</a></li>
										<!-- end -->
										<li><a id="menuTransactionStatus"
											name="menuTransactionStatus">Transaction Status</a></li>
									</ul></li>
								<li><a id="menuReportsLedger" name="menuReportsLedger">Reports</a>
									<ul style="width: 180px;">
										<li><a id="menuRecapsI-V" name="menuRecapsI-V">Recaps
												I - V</a></li>
										<li><a id="menuRecapsVI" name="menuRecapsVI">Recaps
												VI</a></li>
										<li><a id="menuJVRegister" name="menuJVRegister">JV
												Register</a></li>
										<li><a id="menuCreditDebitMemoReport"
											name="menuCreditDebitMemoReport">Credit/Debit Memos</a></li>
										<li><a id="menuPrintGLTransactionsReport"
											name="menuPrintGLTransactionsReport">General Ledger
												Transaction</a></li>
										<!-- added by jet 11.23.2015 AP/AR Enhancement -->
										<li><a id="printOutstandingApArAccounts"
											name="printOutstandingApArAccounts">Outstanding AP/AR Accounts</a></li>
										<!-- end -->
										<li><a id="evat" name="evat">EVAT</a></li>
										<li><a id="inputVATReport" name="inputVATReport">Input
												VAT</a></li>
										<li><a id="amlaCoveredTransaction"
											name="amlaCoveredTransaction">AMLA - Covered Transaction</a></li>
										<li><a id="taxesWithheldFromPayees"
											name="taxesWithheldFromPayees">Withholding Tax</a></li>
										<li><a id="birAlphalist" name="birAlphalist">BIR
												Alphalist</a></li>
										<li><a id="menuTrialBalance" name="menuTrialBalance">Trial
												Balance</a>
											<ul style="width: 160px;">
												<li><a id="monthlyTrialBalance"
													name="monthlyTrialBalance">Monthly Trial Balance</a></li>
												<li><a id="trialBalanceAsOf" name="trialBalanceAsOf">Trial
														Balance As Of</a></li>
												<li><a id="menuTrialBalancePerSL"
													name="menuTrialBalancePerSL">Trial Balance per SL</a></li>
											</ul></li>
										<li><a id="menuBudgetModule" name="menuBudgetModule">Budget
												Module</a>
											<ul style="width: 160px;">
												<li><a id="budgetMaintenance" name="budgetMaintenance">Budget
														Maintenance</a></li>
												<li><a id="menuBudgetProduction"
													name="menuBudgetProduction">Budget Production</a></li>
												<li><a id="menuSubsidiaryOfExpenses"
													name="menuSubsidiaryOfExpenses">Subsidiary Of Expenses</a></li>
											</ul></li>
									</ul></li>
							</ul></li>
						<li><a id="endOfMonth" name="endOfMonth">End of Month</a>
							<ul style="width: 160px;">
								<li><a id="dataChecking" name="dataChecking">Data
										Checking</a></li>
								<li><a id="batchAccountingEntry"
									name="batchAccountingEntry">Batch Accounting Entry</a></li>
								<li><a id="batchChecking" name="batchChecking">Batch
										Checking</a></li>
								<!--Gzelle 10.08.2013-->
								<li><a id="24thMethod" name="24thMethod">24th Method</a></li>
								<li><a id="acMenuBatchOS" name="acMenuBatchOS">Batch Outstanding Losses</a></li>								
								<li><a id="trialBalanceProcessing"
									name="trialBalanceProcessing">Trial Balance Processing</a></li>
								<li><a id="postEntriesToGL" name="postEntriesToGL">Post
										Entries to GL</a></li>
								<!-- shan 05.24.2013 -->
								<!--Gzelle 05.08.2013-->
								<li><a id="closeGL" name="closeGL">Close GL</a></li>
								<li><a id="endOfMonthReports" name="endOfMonthReports">Reports</a>
									<ul style="width: 200px;">
										<li><a id="batchReports" name="batchReports">Batch
												Reports</a></li>
										<li><a id="distRegisterPerTreaty"
											name="distRegisterPerTreaty">Distribution Register per
												Treaty</a></li>
										<li><a id="distRegisterPolicyPerPeril"
											name="distRegisterPolicyPerPeril">Distribution Register
												(Policy Per Peril)</a></li>
										<li><a>Intermediary Production Register</a>
											<ul style="width: 210px;">
												<li><a id="intermediaryProdPerIntm">Intermediary
														Production (per intm type)</a></li>
												<li><a id="intermediaryProdPerLine">Intermediary
														Production (per line)</a></li>
											</ul></li>
										<li><a id="prodRegisterPerPeril"
											name="prodRegisterPerPeril">Production Register per Peril</a></li>
										<li><a id="specialReports" name="specialReports">Special
												Reports</a></li>
										<li><a id="taxDetailsRegister" name="taxDetailsRegister">Tax Details Register</a></li>
										<li><a id="acMenuUwProduction" name="acMenuUwProduction">Underwriting Production</a></li>
										<li><a id="undistributedPolicies"
											name="undistributedPolicies">Undistributed Policies</a></li>
										<!-- added by robert SR 4953 10.28.15 -->
										<li><a id="batchOSPrinting"
											name="batchOSPrinting">Batch OS Loss Register</a></li>			
										<li><a id="bordereauxClaimsRegister"
											name="bordereauxClaimsRegister">Bordereaux and Claims Register</a></li>	
										<!-- end robert SR 4953 10.28.15 -->	
									</ul></li>
							</ul></li>
						<li><a id="reinsurance" name="reinsurance">Reinsurance</a>
							<ul style="width: 120px;">
								<li><a id="menuRiInquiry" name="menuRiInquiry">Inquiry</a>
									<ul style="width: 160px;">
										<li><a id="menuRiBillPayments" name="menuRiBillPayments">RI
												Bill Payments</a></li>
										<li><a id="menuRiLossesRecoverable"
											name="menuRiLossesRecoverable">Losses Recoverable</a></li>
									</ul></li>
								<li><a id="riReports" name="riReports">Reports</a>
									<ul style="width: 260px;">
										<li><a id="schedRiFacultative" name="schedRiFacultative">Schedule
												of Due to RI Facultative</a></li>
										<li><a id="schedDueFromRi" name="schedDueFromRi">Schedule
												of Due from RI</a>
											<ul style="width: 140px;">
												<li><a id="inwardBusiness" name="inwardBusiness">Inward
														Business</a></li>
												<li><a id="lossRecoverable" name="lossRecoverable">Losses
														Recoverable</a>
													<ul style="width: 140px;">
														<li><a id="lossRecovFacultative"
															name="lossRecovFacultative">Facultative</a></li>
													</ul></li>
											</ul></li>
										<li><a id="premAssumedFromFaculRi"
											name="premAssumedFromFaculRi">Premiums Assumed from
												Facultative RI</a></li>
										<li><a id="premCededToFacultativeRi"
											name="premCededToFacultativeRi">Premiums Ceded to
												Facultative RI</a></li>
										<li><a id="premDueFromFaculRiAsOf"
											name="premDueFromFaculRiAsOf">Premiums Due from
												Facultative RI as of</a></li>
										<li><a id="premCededToFacultativeRiAsOf"
											name="premCededToFacultativeRiAsOf">Premiums Ceded to
												Facultative RI as of</a></li>
										<li><a id="premCededTreaty" name="premCededTreaty">Premium
												Ceded - Treaty</a></li>
										<li><a id="quarterlyTreatyStatement"
											name="quarterlyTreatyStatement">Quarterly Treaty
												Statement</a></li>
										<li><a id="soaFaculRi" name="soaFaculRi">Statement of
												Account - Facultative RI</a></li>
										<li><a id="soaOutwardFaculRi" name="soaOutwardFaculRi">Statement Of Account - Outward
												Facultative RI</a></li>
										<li><a id="soaLossesRecoverable"
											name="soaLossesRecoverable">Statement
												Of Account - Losses Recoverable</a></li>
										<li><a id="riCommIncAndExp" name="riCommIncAndExp">RI
												Commission Income and Expense</a></li>
										<li><a id="listOfBindersAttachedToRedistRecords"
											name="listOfBindersAttachedToRedistRecords">List of Binders Attached to
												Redistributed Records</a></li>
										<li><a id="paidPoliciesWFacultative"
											name="paidPoliciesWFacultative">Paid Policies w/
												Facultative</a></li>
									</ul></li>
							</ul></li>
						<li><a id="creditAndCollection" name="creditAndCollection">Credit
								and Collection</a>
							<ul style="width: 160px;">
								<li><a id="utilitiesCredAndColl"
									name="utilitiesCredAndColl">Utilities</a>
									<ul style="width: 160px;">
										<li><a id="ageBills" name="ageBills">Age Bills</a></li>
										<li><a id="cancelledPolicies" name="cancelledPolicies">Cancelled
												Policies</a></li>
									</ul></li>
								<li><a id="inquiryBill" name="inquiryBill">Inquiry</a>
									<ul style="width: 160px;">
										<li><a id="billPayments" name="billPayments">Bill
												Payments</a></li>
										<li><a id="billPerPolicy" name="billPerPolicy">Bill
												per Policy</a></li>
										<li><a id="billsByAssdAndAge" name="billsByAssdAndAge">Bills
												by Assured and Age</a></li>
										<!-- jomsdiago 07.31.2013 -->
										<li><a id="billsByIntermediary"
											name="billsByIntermediary">Bills by Intermediary</a></li>
										<li><a id="acMenuPolicyInformation"	name="acMenuPolicyInformation">Policy Information</a></li>
									</ul></li>
								<li><a id="reports" name="reports">Reports</a>
									<ul style="width: 190px;">
										<li><a id="statementOfAccount" name="statementOfAccount">Statement
												of Account</a></li>
										<li><a id="totalCollections" name="totalCollections">Total
												Collections</a></li>
										<li><a id="agingOfCollections" name="agingOfCollections">Aging
												of Collections</a></li>
										<li><a id="billingStatement" name="billingStatement">Billing
												Statement (Salary Deduction)</a></li>
										<li><a id="agingOfPremRec" name="agingOfPremRec">Aging
												of Premium Receivables</a></li>
										<li><a id="paidPremPerIntm" name="paidPremPerIntm">Paid
												Premiums per Intermediary</a></li>
									</ul></li>
							</ul></li>
						<li><a id="uploading" name="uploading">Uploading</a>
							<ul style="width: 160px;">
								<li><a id="fileSources" name="fileSources">File Sources</a></li>
								<li><a id="convertFile" name="convertFile">Convert File</a></li>
								<li><a id="processDataListing" name="processDataListing">Process
										Data</a></li>
								<li><a id="reports" name="reports">Reports</a> <!-- Dren Niebres 10.03.2016 SR-4572/SR-4573 - Start -->	
									<ul style="width: 190px;">
										<li><a id="convertedAndUploadedFiles" name="convertedAndUploadedFiles">Converted and Uploaded Files</a></li>
										<li><a id="convertedRecordsPerStatus" name="convertedRecordsPerStatus">Converted Records Per Status</a></li>	
									</ul>								
								</li> <!-- Dren Niebres 10.03.2016 SR-4572/SR-4573 - End -->												
							</ul></li>
						<li><a id="menuMaintenance">Maintenance</a>
							<ul style="width: 195px">
								<li><a id="menuAccountingSetup">Accounting Setup</a>
									<ul style="width: 160px">
										<li><a id="menuParameter">Parameter</a>
										<li><a id="menuAgingParameters">Aging Parameter</a>
										<li><a id="menuModuleMaintenance">Module</a>
										<li><a id="menuModuleEntry">Module Entry</a>
										<li><a id="menuUserAccess">User Access</a>
											<ul style="width: 160px">
												<li><a id="menuAccountingUser">Accounting User</a></li>							
												<li><a id="menuDCBUser">DCB User</a></li>
												<li><a id="menuAccountingFunction">Accounting
														Function</a></li>						
												<li><a id="menuUserPerFunction">User per Function</a></li>
											</ul></li>
									</ul></li>
								<li><a id="menuCompany">Company</a></li>
								<li><a id="menuBranches">Branch</a></li>
								<li><a id="menuDepartment">Department</a></li>
								<li><a id="chartOfAccounts">Chart of Accounts</a></li>
								<li><a id="menuSubsidiaryLedgerType">Subsidiary Ledger
										Type</a></li>
								<li><a id="menuSubsidiaryLedger">Subsidiary Ledger</a></li>
								<li><a id="glControlAcctType">General Ledger Control Account Types</a></li><!-- Gzelle 11052015 KB#132 AP/AR ENH -->
								<li><a id="menuWithholdingTax">Withholding Tax</a></li>
								<li><a id="menuTax">Tax</a></li>
								<li><a id="menuBank">Bank</a></li>
								<li><a id="menuBankAccount">Bank Account</a></li>
								<li><a id="menuPayeeClass">Payee Class</a></li>
								<li><a id="menuClaimPayee" name="menuClaimPayee">Payee</a></li> <!-- added by robert SR 4953 10.28.15 -->
								<li><a id="menuPaymentRequestDocument">Payment Request
										Document</a></li>
								<li><a id="menuJvTran">JV Transaction Type</a></li>
								<li><a id="bookAndBankTransactions">Book and Bank
										Transactions</a></li>
								<li><a id="menuTransactionMonth">Transaction Month</a></li>
								<li><a id="menuTreatyType">Treaty Type</a></li>
								<li><a id="profitCommissionRate">Profit Commission Rate</a></li>
								<li><a id="menuSoaTitle">SOA Title</a></li>
								<li><a id="menuORPrefix">OR Prefix</a></li>
								<li><a id="docSeqLog" name="docSeqLog">Document
										Sequence Log</a>
									<ul style="width: 160px;">
										<li><a id="menuDocSeqPerBranch" name="docSeqPerBranch">Sequence
												per Branch</a></li>
										<li><a id="menuDocSeqPerUser" name="menuDocSeqPerUser">Sequence
												per User</a></li>
									</ul></li>
								<li><a id="monthEndCheckingScripts">Month-end Checking
										Scripts</a></li>
								<li><a id="monthEndReport">Month-end Report</a></li>
								<li><a id="monthEndReportDetail">Month-end Report
										Detail</a></li>
								<li><a id="menuReportDocument" name="menuReportDocument">Report Document</a></li> <!-- added by robert SR 4953 10.28.15 -->
								<li><a id="menuRepSignatory" name="menuRepSignatory">Report Document Signatory</a></li> <!-- added by robert SR 4953 10.28.15 -->
							</ul></li>
						<li><a id="acExit" name="acExit">Exit</a></li>
					</span>
					<span id="commSlipMenu" name="commSlipMenu" style="display: none">
						<li><a id="csExit" name="csExit">Exit</a></li>
					</span>
				</ul>
			</c:when>
			<c:otherwise>
				<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu"
					style="height: 25px;"></div>
			</c:otherwise>
		</c:choose>
	</div>
	<input type="hidden" id="hidIsUserDCBUser" value="${isUserDCBUser}" />
</div>
<script type="text/javascript">
	var hasORFunction = '${hasORFunction}';
	var hasMOFunction = '${hasMOFunction}';
	var hasORCancellation = '${hasORCancellation}';
	userFunctionValid = JSON.parse('${userFunctionValidity}');
	
	setModuleId();
	//$("home").observe("click", function () {
	//	goToModule("/GIISUserController?action=goToHome", "Home");
	//});
	$("home").observe("mouseover", function() {
		new Effect.Opacity("home", {
			duration : 0.2,
			to : 1
		});
	});

	$("home").observe("mouseout", function() {
		new Effect.Opacity("home", {
			duration : 0.2,
			to : 0.8
		});
	});

	$("home").observe("click", function() {
		if (orListTableGrid != null)
			orListTableGrid.keys.releaseKeys();
		goToModule("/GIISUserController?action=goToHome", "Home");
	});

	// Note: For new menu function, please add '$("acExit").show();' on complete of module loading
	observeAccessibleModule(accessType.MENU, "GIACS001", "generateOR",
			function() {
				objACGlobal.orTag = null; // added by Kris 02.06.2013: reset to null if navigating from Manual OR page to sys-gen OR page
				objAC.butLabel = "Spoil OR";
				objAC.fromMenu = "generateOR";
				createORInformation();
			});
	observeAccessibleModule(accessType.MENU, "GIACS001", "enterManualOR",
			function() {
				objAC.fromMenu = "enterManualOR";
				objACGlobal.orTag = '*';
				objACGlobal.callingForm = "";
				objAC.butLabel = "Spoil OR";
				createORInformation();
			});
	observeAccessibleModule(accessType.MENU, "GIACS156", "generateOtherOR",
			function() {
				objAC.fromMenu = "generateOtherOR";
				showBranchOR(1);
			});
	observeAccessibleModule(accessType.MENU, "GIACS156", "enterOtherManualOR",
			function() {
				objAC.fromMenu = "enterOtherManualOR";
				showBranchOR(2);
			});
	observeAccessibleModule(accessType.MENU, "GIACS156", "cancelOtherOR",
			function() {
				objAC.fromMenu = "cancelOtherOR";
				showBranchOR(3);
			});
	//observeAccessibleModule(accessType.MENU, "GIACS090", "acknowledgementReceipts", showAcknowledgementReceipt);
	observeAccessibleModule(accessType.MENU, "GIACS090",
			"acknowledgementReceipts", showAcknowledgementReceiptListing); // andrew - 10.06.2011
	observeAccessibleModule(accessType.MENU, "GIACS156", "otherBranchAPDC",
			function() {
				showBranchOR("APDC");
			});
	observeAccessibleModule(accessType.MENU, "GIACS037", "enterSpoiledOR",
			showEnterSpoiledOR);
	observeAccessibleModule(accessType.MENU, "GIACS001", "orListing",
			function() {
				objAC.createORTag = null;
				updateMainContentsDiv(
						"/GIACOrderOfPaymentController?action=showORListing",
						"Retrieving OR data, please wait...");
				objAC.butLabel = "Spoil OR"; //tonio March 15, 2011
				objAC.fromMenu = "orListing"; // andrew 08.14.2012 - SR 0010292
				$("acExit").show(); // added by andrew - 02.18.2011
				hideAccountingMainMenus();
			});
	observeAccessibleModule(
			accessType.MENU,
			"GIACS001",
			"cancelOR",
			function() {
				objAC.createORTag = null;
				updateMainContentsDiv(
						"/GIACOrderOfPaymentController?action=showORListing&cancelOR=Y",
						"Retrieving OR data, please wait...");
				objAC.butLabel = "Cancel OR"; //tonio March 15, 2011
				objAC.fromMenu = "cancelOR"; // andrew 08.14.2012 - SR 0010292
				$("acExit").show(); // added by andrew - 02.18.2011
				hideAccountingMainMenus();
			});
	observeAccessibleModule(accessType.MENU, "GIACS035", "closeDCB",
			function() {
				updateMainContentsDiv(
						"/GIACAccTransController?action=showDCBListing",
						"Retrieving DCB list, please wait...");
				objAC.butLabel = "Spoil OR"; //tonio March 15, 2011
				$("acExit").show(); // added by andrew - 02.18.2011
				hideAccountingMainMenus();
			});

	/*Added by : Joms Diago*/
	observeAccessibleModule(accessType.MENU, "GIACS046", "checkReleaseInfo",
			function() {
				try {
					new Ajax.Request(contextPath + "/GIACInquiryController", {
						parameters : {
							action : "showCheckReleaseInfo"
						},
						onComplete : function(response) {
							$("mainContents").update(response.responseText);
							hideAccountingMainMenus();
							//$("acExit").show();
						}
					});
				} catch (e) {
					showErrorMessage("checkReleaseInfo", e);
				}
			});

	/*Added by : Pol Cruz*/
	observeAccessibleModule(accessType.MENU, "GIACS045",
			"menuCopyPaymentRequest", function() {
				try {
					new Ajax.Request(contextPath
							+ "/GIACDisbursementUtilitiesController", {
						parameters : {
							action : "showCopyPaymentRequest"
						},
						onComplete : function(response) {
							$("mainContents").update(response.responseText);
							hideAccountingMainMenus();
						}
					});
				} catch (e) {
					showErrorMessage("copyPaymentRequest", e);
				}
			});

	/* shan 05.29.2013 */
	observeAccessibleModule(accessType.MENU, "GIACS049",
			"menuUpdateCheckNumber", showUpdateCheckNumberPage);

	observeAccessibleModule(accessType.MENU, "GIACS333", "dcbNoMaintenance",
			function() {
				loadFilteredDCBNoMaintenance("", "", "", "", "", "No");
				$("acExit").show();
			});

	observeAccessibleModule(accessType.MENU, "GIACS016",
			"claimPaymentRequests", function() {
				objCLMGlobal.fromMenu = null;
				showDisbursementRequests('CPR');
				$("acExit").show();
			});
	observeAccessibleModule(accessType.MENU, "GIACS016",
			"facultativePremiumPayment", function() {
				objCLMGlobal.fromMenu = null;
				showDisbursementRequests('FPP');
				$("acExit").show();
			});
	observeAccessibleModule(accessType.MENU, "GIACS016", "commissionPayment",
			function() {
				objCLMGlobal.fromMenu = null;
				showDisbursementRequests('CP');
				$("acExit").show();
			});
	observeAccessibleModule(accessType.MENU, "GIACS016", "otherPayments",
			function() {
				objCLMGlobal.fromMenu = null;
				showDisbursementRequests('OP');
				$("acExit").show();
			});
	observeAccessibleModule(accessType.MENU, "GIACS016", "cancelRequest",
			function() {
				objCLMGlobal.fromMenu = "cancelRequest";
				showDisbursementRequests('CR');
				$("acExit").show();
			});
	//marco - 05.06.2013

	observeAccessibleModule(accessType.MENU, "GIACS086", "scsRequest",
			function() {
				objCLMGlobal.fromMenu = null;
				objCLMGlobal.callingForm = "GIACS086";
				objCLMGlobal.fromClaimMenu = 'N'; //added by robert 11.28.2013
				showSpecialCSRListing("", "", "N");
				$("dynamicDiv").down("div", 0).show();
				$("acExit").show();
			});

	observeAccessibleModule(accessType.MENU, "GIACS055",
			"obrClaimPaymentRequests", function() {
				objCLMGlobal.fromMenu = null;
				showOtherBranchRequests('CPR', null, null, null, "Branch Payment Request");
				$("acExit").show();
			});
	observeAccessibleModule(accessType.MENU, "GIACS055",
			"obrFacultativePremiumPayment", function() {
				objCLMGlobal.fromMenu = null;
				showOtherBranchRequests('FPP', null, null, null, "Branch Payment Request");
				$("acExit").show();
			});
	observeAccessibleModule(accessType.MENU, "GIACS055",
			"obrCommissionPayment", function() {
				objCLMGlobal.fromMenu = null;
				showOtherBranchRequests('CP', null, null, null, "Branch Payment Request");
				$("acExit").show();
			});
	observeAccessibleModule(accessType.MENU, "GIACS055", "obrOtherPayments",
			function() {
				objCLMGlobal.fromMenu = null;
				showOtherBranchRequests('OP', null, null, null, "Branch Payment Request");
				$("acExit").show();
			});
	observeAccessibleModule(accessType.MENU, "GIACS055", "obrCancelRequest",
			function() {
				objCLMGlobal.fromMenu = "cancelRequest";
				showOtherBranchRequests('CR', null, null, null, "Branch Payment Request");
				$("acExit").show();
			});

	//marco - 05.06.2013
	observeAccessibleModule(accessType.MENU, "GIACS086", "obrScsRequest",
			function() {
				objCLMGlobal.fromMenu = null;
				//objCLMGlobal.callingForm = "GIACS055"; 
				showOtherBranchRequests("", "", "SCSR", null, "Branch Payment Request");
			});

	//observeAccessibleModule(accessType.MENU, "GIACS091", "menuDatedChecks", ""/* your function here */);
	observeAccessibleModule(accessType.MENU, "GIUTS022",
			"menuChangePaymentMode", ""/* your function here */);

	// added by Kris 03.20.2013
	if (!validateUserFunc2("MM", "GIACM000")) {
		disableMenu("menuCancelCreditDebitMemo");
	}
	observeAccessibleModule(accessType.MENU, "GIACS071",
			"menuAddCreditDebitMemo", function() {
				objAC.fromMenu = "menuAddCreditDebitMemo";
				checkUserAccessGiacs("GIACS071");
				//showAddCreditDebitMemoPage('N'); // parameter determines cancelFlag
				$("acExit").show();
			});
	observeAccessibleModule(accessType.MENU, "GIACS071", "menuCreditDebitMemo",
			function() {
				objAC.fromMenu = "menuCreditDebitMemo";
				checkUserAccessGiacs("GIACS071");
				//showCreditDebitMemoPage('N'); // parameter determines cancelFlag
				$("acExit").show();
			});
	observeAccessibleModule(accessType.MENU, "GIACS071",
			"menuCancelCreditDebitMemo", function() {
				objAC.fromMenu = "menuCancelCreditDebitMemo";
				checkUserAccessGiacs("GIACS071");
				//showCreditDebitMemoPage('Y'); // parameter determines cancelFlag
				$("acExit").show();
			});
	// END 03.20.2013

	observeAccessibleModule(accessType.MENU, "GIACS235", "menuOrStatus",
			function() {
				try {
					// Created by: Lara Beltran
					// Date: Feb 1, 2013
					new Ajax.Request(contextPath + "/GIACInquiryController", {
						parameters : {
							action : "showOrStatus"
						},
						onComplete : function(response) {
							$("mainContents").update(response.responseText);
							hideAccountingMainMenus();
						}
					});
				} catch (e) {
					showErrorMessage("menuOrStatus", e);
				}
			});

	observeAccessibleModule(accessType.MENU, "GIACS092", "pdcPaymentsInquiry",
			showGIACS092); //pol cruz 04.19.2013

	observeAccessibleModule(accessType.MENU, "GIACS237", "menuDVStatus",
			function() {
				new Ajax.Request(contextPath + "/GIACInquiryController", {
					parameters : {
						action : "showDVStatus"
					},
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response) {
						hideNotice();
						$("mainContents").update(response.responseText);
						$("acExit").show();
						objAC.fromMenu = 'Y';
						;
						hideAccountingMainMenus();
					}
				});
			});

	observeAccessibleModule(accessType.MENU, "GIACS240",
			"menuChecksPaidPerPayee", showGIACS240);

	observeAccessibleModule(accessType.MENU, "GIACS241",
			"checksPaidPerDepartment", showChecksPaidPerDepartment); //Gzelle 09.19.2013
	observeAccessibleModule(accessType.MENU, "GIACS354", "batchChecking",
			showBatchChecking); //Gzelle 10.08.2013
	observeAccessibleModule(accessType.MENU, "GIACS158", "commissionsDue",
			showCommissionsDue); //Gzelle 10.23.2013

	//shan 06.27.2013
	observeAccessibleModule(accessType.MENU, "GIACS273", "disbursementList",
			function() {
				checkUserAccessGiacs("GIACS273");
			});

	observeAccessibleModule(accessType.MENU, "GIACS155",
			"menuCommissionVoucher", showGIACS155); //pol cruz 05.31.2013
	observeAccessibleModule(accessType.MENU, "GIACS251", "menuBatchCommVoucherPrinting", showGIACS251);
	observeAccessibleModule(accessType.MENU, "GIACS118", "menuDisbursementRegister", showGiacs118);
	observeAccessibleModule(
			accessType.MENU,
			"GIACS135",
			"menuCheckRegister",
			showGiacs135);
	observeAccessibleModule(
			accessType.MENU,
			"GIACS184",
			"menuCheckReleaseReport",
			function() { // Kris 07.09.2013
				new Ajax.Request(
						contextPath
								+ "/GIACGeneralDisbursementReportsController",
						{
							parameters : {
								action : "showCheckReleaseReportPage"
							},
							asynchronous : false,
							evalScripts : true,
							onCreate : function() {
								showNotice("Loading Check Release Page, please wait...");
							},
							onComplete : function(response) {
								hideNotice("");
								$("mainContents").update(response.responseText);
								hideAccountingMainMenus();
								$("acExit").show();
							}
						});
			});
	observeAccessibleModule(accessType.MENU, "GIACS413", "menuCommissionsPaidRegister", showGiacs413);

	//marco - 06.21.2013
	observeAccessibleModule(accessType.MENU, "GIACS056",
			"menuModifiedCommissions", function() {
				new Ajax.Request(contextPath + "/GIACCommPaytsController", {
					parameters : {
						action : "showModifiedCommissions"
					},
					asynchronous : false,
					evalScripts : true,
					onCreate : showNotice("Loading, please wait..."),
					onComplete : function(response) {
						hideNotice("");
						$("mainContents").update(response.responseText);
						hideAccountingMainMenus();
					}
				});
			});

	observeAccessibleModule(accessType.MENU, "GIACS503", "menuTrialBalancePerSL", showTrialBalancePerSL);
			/*function(){
				checkUserAccessGiacs("GIACS503");
			});*/

	observeAccessibleModule(accessType.MENU, "GIACS450",
			"menuBudgetProduction", function() {
				new Ajax.Request(contextPath + "/GIXXProdBudgetController", {
					parameters : {
						action : "showBudgetProduction"
					},
					asynchronous : false,
					evalScripts : true,
					onCreate : showNotice("Loading, please wait..."),
					onComplete : function(response) {
						hideNotice("");
						$("mainContents").update(response.responseText);
						hideAccountingMainMenus();
						$("acExit").show();
					}
				});
			});

	observeAccessibleModule(accessType.MENU, "GIACS512", "menuContingentProfitCommission", showContingentProfitCommission);
	observeAccessibleModule(accessType.MENU, "GIACS236",
			"menuPaymentRequestStatus", function() {
				new Ajax.Request(contextPath + "/GIACInquiryController", {
					parameters : {
						action : "showPaymentRequestStatus"
					},
					onComplete : function(response) {
						$("mainContents").update(response.responseText);
						hideAccountingMainMenus();
					}
				});
			});
	//marco - 05.04.2013 - replaced with observeAccessibleModule
	/* $("menuPaymentRequestStatus").observe("click",function(){
		// Created by: Abe Arao
		// Date: Apr. 1, 2013
		new Ajax.Request(contextPath + "/GIACInquiryController", {
			parameters : {action: "showPaymentRequestStatus"},
			onComplete : function(response){
				$("mainContents").update(response.responseText);
			}
		});
	}); */

	observeAccessibleModule(accessType.MENU, "GIACS091", "menuDatedChecks", showGiacs091);

	// Kenneth L.
	// April 20, 2013
	observeAccessibleModule(accessType.MENU, "GIUTS022",
			"menuChangePaymentMode", function() {
				new Ajax.Request(contextPath
						+ "/GIUTSChangeInPaymentTermController", {
					parameters : {
						action : "showChangeInPaymentTerm"
					},
					onComplete : function(response) {
						try {
							if (checkErrorOnResponse(response)) {
								$("dynamicDiv").update(response.responseText);
							}
						} catch (e) {
							showErrorMessage("showChangeInPaymentTerm", e);
						}
					}
				});
			});

	//added by Kris 04.30.2013
	observeAccessibleModule(accessType.MENU, "GIACS180", "statementOfAccount",
			showSOAMainPage);

	observeAccessibleModule(accessType.MENU, "GIACS231",
			"menuTransactionStatus", function() {
				checkUserAccessGiacs("GIACS231");
			});

	observeAccessibleModule(accessType.MENU, "GIACS290", "menuRecapsI-V",
			showRecapsIToV);

	observeAccessibleModule(accessType.MENU, "GIPIS203", "menuRecapsVI", showRecapsVI);
	observeAccessibleModule(accessType.MENU, "GIACS127", "menuJVRegister",
			showGIACS127);
	observeAccessibleModule(accessType.MENU, "GIACS072",
			"menuCreditDebitMemoReport", showGIACS072);
	observeAccessibleModule(accessType.MENU, "GIACS108", "evat", showGIACS108);
	observeAccessibleModule(accessType.MENU, "GIACS110",
			"taxesWithheldFromPayees", showGIACS110);
	observeAccessibleModule(accessType.MENU, "GIACS115", "birAlphalist",
			showGIACS115);
	observeAccessibleModule(accessType.MENU, "GIACS060",
			"menuPrintGLTransactionsReport", showGIACS060);
	//added by jet 11.23.2015 AP/AR Enhancement
	observeAccessibleModule(accessType.MENU, "GIACS342",
			"printOutstandingApArAccounts", showGIACS342);
	
	//added by Gzelle 04.15.2013
	observeAccessibleModule(
			accessType.MENU,
			"GIACS081",
			"replenishmentOfRevolvingFund",
			function() {
				new Ajax.Request(
						contextPath + "/GIACReplenishDvController",
						{
							parameters : {
								action : "showReplenishmentOfRevolvingFundListing"
							},
							onComplete : function(response) {
								try {
									if (checkErrorOnResponse(response)) {
										hideAccountingMainMenus();
										$("mainContents").update(
												response.responseText);
									}
								} catch (e) {
									showErrorMessage(
											"showReplenishmentOfRevolvingFundListing - onComplete : ",
											e);
								}
							}
						});

			});

	//added by ape 6-4-2013
	observeAccessibleModule(accessType.MENU, "GIACS278",
			"menuRiLossesRecoverable", function() {
				new Ajax.Request(contextPath
						+ "/GIACReinsuranceInquiryController", {
					parameters : {
						action : "viewRiLossRecoveries"
					},
					onComplete : function(response) {
						try {
							hideAccountingMainMenus();
							$("mainContents").update(response.responseText);
						} catch (e) {
							showErrorMessage(
									"viewRiLossRecoveries - onComplete : ", e);
						}
					}
				});
			});

	observeAccessibleModule(accessType.MENU, "GIACS051", "copyJV", showGIACS051);

	// shan 04.19.2013
	observeAccessibleModule(accessType.MENU, "GIACS230",
			"menuGLAccountTransaction", function() {
				showGIACS230("Y");
				$("acExit").show();
			});

	// shan 08.22.2013
	observeAccessibleModule(accessType.MENU, "GIACS070",
			"menuViewJournalEntries", function() {
				showGIACS070Page();
				//$("acExit").show();
			});

	//added by steven 03.18.2013
	if (!validateUserFunc2("JV", "GIACM000")) {
		disableMenu("cancelJVListing");
	}

	observeAccessibleModule(accessType.MENU, "GIACS003", "journalEntry",
			function() {
				objAC.fromMenu = "journalEntry";
				showJournalListing("showJournalEntries", "getJournalEntries",
						"GIACS003", null, null, null, null, null);  // andrew - 08252015 - 17425
				$("acExit").show();
			});
	observeAccessibleModule(accessType.MENU, "GIACS003", "journalEntryListing",
			function() {
				showJournalListing("showJournalListing", "getJournalEntryList",
						"GIACS003", null, null, null,
						"Retrieving Journal Entries data, please wait...",
						null,  // andrew - 08252015 - 17425
						"O");  // andrew - 08252015 - 17425
				$("acExit").show();
			});
	observeAccessibleModule(accessType.MENU, "GIACS003", "cancelJVListing",
			function() {
				showJournalListing("showJournalListing", "getCancelJVList",
						"GIACS003", null, null, null,
						"Retrieving Cancel JV data, please wait...",
						null,  // andrew - 08252015 - 17425
						"O");  // andrew - 08252015 - 17425
				$("acExit").show();
			});

	observeAccessibleModule(accessType.MENU, "GIACS353", "dataChecking",
			function() {
				showDataChecking();
			});

	observeAccessibleModule(accessType.MENU, "GIACB000",
			"batchAccountingEntry", function() {
				showBatchAccountingEntry();
			});

	observeAccessibleModule(accessType.MENU, "GIACS500",
			"trialBalanceProcessing", function() {
				showTrialBalanceProcessing();
			});

	/* added by shan 05.24.2013 */
	observeAccessibleModule(accessType.MENU, "GIACS410", "postEntriesToGL",
			function() {
				checkUserAccessGiacs("GIACS410");
			});

	observeAccessibleModule(accessType.MENU, "GIACS047", "updateCheckStatus",
			function() {
				showUpdateCheckStatus();
			});

	observeAccessibleModule(accessType.MENU, "GIACS211", "billPayments",
			function() {
				showBillPayment(null, null, null);
			});

	//added by john dolon 8.15.2013
	observeAccessibleModule(accessType.MENU, "GIACS289", "billPerPolicy",
			showBillPerPolicy);

	// jomsdiago 07.31.2013
	observeAccessibleModule(accessType.MENU, "GIACS202", "billsByAssdAndAge",
			function() {
				showGIACS202("menu", null, null, null, null, null, null);
			});

	//marco - 09.06.2013
	observeAccessibleModule(accessType.MENU, "GIACS288", "billsByIntermediary",
			function() {
				showBillsByIntermediary("N");
			});

	observeAccessibleModule(accessType.MENU, "GIPIS100", "acMenuPolicyInformation", function(){
		objGIPIS100.callingForm = "GIACS000";
		objAC.fromACMenu = "Y"; //added by robert SR 21673 03.22.2016
		showViewPolicyInformationPage();
	});	
	
	//by Kenneth L.06.20.2013
	observeAccessibleModule(accessType.MENU, "GIACS147", "premiumDeposit",
			function() {
				checkUserAccessGiacs("GIACS147");
			});

	//added by kenneth L. for aging of collections 07.02.2013
	observeAccessibleModule(accessType.MENU, "GIACS328", "agingOfCollections",
			showAgingOfCollections);

	//added by kenneth L. for paid prem per intm 07.10.2013
	observeAccessibleModule(accessType.MENU, "GIACS286", "paidPremPerIntm",
			showPaidPremiumsPerIntermediary);

	//added by kenneth L. for monthly trial balance07.18.2013
	observeAccessibleModule(accessType.MENU, "GIACS501", "monthlyTrialBalance",
			showMonthlyTrialBalance);

	//added by kenneth L. for trial balance as of - 07.25.2013
	observeAccessibleModule(accessType.MENU, "GIACS502", "trialBalanceAsOf",
			showTrialBalanceAsOf);

	//added by kenneth L. for trial balance as of - 07.25.2013
	observeAccessibleModule(accessType.MENU, "GIACS116",
			"amlaCoveredTransaction", showGiacs116);

	//added by john dolon 8.7.2013
	observeAccessibleModule(accessType.MENU, "GIACS148", "totalCollections",
			showTotalCollections);

	// BEGIN: Added by Kris 2012.10.25 || Modified by Joms 06.17.2013
	observeAccessibleModule(accessType.MENU, "GIACS284", "premiumCollections",
			showPremiumCollectionsMainPage);
	// END: Added by Kris 2012.10.25   || Modified by Joms 06.17.2013

	observeAccessibleModule(accessType.MENU, "GIACS178",
			"directPremiumCollections", showGIACS178);

	// Joms 06.19.2013
	observeAccessibleModule(accessType.MENU, "GIACS160",
			"officialReceiptRegister", showGIACS160);

	observeAccessibleModule(accessType.MENU, "GIACS281", "listOfBankDeposits",
			showGIACS281);

	// Joms 06.20.2013
	observeAccessibleModule(accessType.MENU, "GIACS104", "inputVATReport",
			showGIACS104);

	// Joms 06.25.2013
	observeAccessibleModule(accessType.MENU, "GIACS200",
			"bookUnbookedPoliciesCollection", showGIACS200);

	// Joms 06.25.2013
	observeAccessibleModule(accessType.MENU, "GIACS414", "schedOfAppliedComm",
			showGIACS414);

	// Joms 06.26.2013
	observeAccessibleModule(accessType.MENU, "GIACS057", "paymentRequestList",
			showGIACS057);

	// Joms 06.27.2013
	observeAccessibleModule(accessType.MENU, "GIACS182",
			"premCededToFacultativeRiAsOf", showGIACS182);

	// Joms 07.03.2013
	observeAccessibleModule(accessType.MENU, "GIACS329", "agingOfPremRec",
			showGIACS329);

	// Joms 07.09.2013
	observeAccessibleModule(accessType.MENU, "GIACS480", "billingStatement",
			showGIACS480);

	//added by christian 04/23/2013
	observeAccessibleModule(accessType.MENU, "GIACS408",
			"menuModifyCommInvoice", function() {
				showModifyCommInvoicePage();
				$("acExit").show();
			});
	// added by Kris 04.11.2013
	if (!validateUserFunc2("DV", "GIACM000")) {
		disableMenu("menuCancelDV");
		disableMenu("menuOtherBranchCancelDV");
	}
	objGIACS002.callingForm = "dvListing";
	observeAccessibleModule(accessType.MENU, "GIACS002", "menuGenerateDV",
			function() {
				objGIACS002.dvTag = null;
				objGIACS002.cancelDV = "N";
				objACGlobal.branchCd = "";
				objACGlobal.fundCd = "";
				objGIACS002.branchCd = "";
				objGIACS002.fundCd = "";
				objGIACS002.lineCd = "";
				showDisbursementVoucherPage('N',
						'showGenerateDisbursementVoucher');
				$("acExit").show();
			});
	observeAccessibleModule(accessType.MENU, "GIACS002", "menuDVListing",
			function() {
				objAC.fromMenu = "menuDVListing";
				objGIACS002.dvTag = null;
				showDisbursementVoucherPage('N', 'getGIACS002DisbVoucherList');
				$("acExit").show();
			});
	observeAccessibleModule(accessType.MENU, "GIACS002", "menuEnterManualDV",
			function() {
				objGIACS002.dvTag = "M";
				showDisbursementVoucherPage('N',
						'showGenerateDisbursementVoucher');
				$("acExit").show();
			});
	observeAccessibleModule(accessType.MENU, "GIACS002", "menuCancelDV",
			function() {
				objAC.fromMenu = "menuCancelDV";
				objGIACS002.cancelDV = "Y";
				objGIACS002.dvTag = null;
				showDisbursementVoucherPage('Y', 'getGIACS002DisbVoucherList');
				$("acExit").show();
			});
	observeAccessibleModule(accessType.MENU, "GIACS053", "batchOrPrinting",
			function() {
				showBatchORPrinting();
			});
	observeAccessibleModule(accessType.MENU, "GIACS250",
			"batchCommSlipPrinting", showGIACS250);
	observeAccessibleModule(accessType.MENU, "GIACS054",
			"menuBatchCheckPrinting", function() {
				showBatchCheckPrinting();
			});
	observeAccessibleModule(accessType.MENU, "GIACS055",
			"menuOtherBranchGenerateDV", function() {
				objAC.fromMenu = "menuOtherBranchGenerateDV";
				objGIACS002.cancelDV = "N";
				objGIACS002.dvTag = null;
				showOtherBranchRequests();
				$("acExit").show();
			});
	observeAccessibleModule(accessType.MENU, "GIACS055",
			"menuOtherBranchManualDV", function() {
				objGIACS002.dvTag = "M";
				objGIACS002.cancelDV = "N";
				objAC.fromMenu = "menuOtherBranchManualDV";
				showOtherBranchRequests();
				$("acExit").show();
			});
	observeAccessibleModule(accessType.MENU, "GIACS055",
			"menuOtherBranchDVListing", function() {
				objAC.fromMenu = "menuOtherBranchDVListing";
				objGIACS002.cancelDV = "N";
				objGIACS002.dvTag = null;
				showOtherBranchRequests();
				$("acExit").show();
			});
	observeAccessibleModule(accessType.MENU, "GIACS055",
			"menuOtherBranchCancelDV", function() {
				objAC.fromMenu = "menuOtherBranchCancelDV";
				objGIACS002.dvTag = null;
				showOtherBranchRequests();
				$("acExit").show();
			});

	observeAccessibleModule(accessType.MENU, "GIACS411", "closeGL", function() {
		showCloseGL();
		$("acExit").show();
	});
	// END 04.11.2013
	observeAccessibleModule(accessType.MENU, "GIARDC01",
			"dailyCollectionReport", function() {
				showDailyCollectionRep();
				$("acExit").show();
			});

	//added by Gzelle 05.08.2013
	observeAccessibleModule(accessType.MENU, "GIACS044", "24thMethod",
			function() {
				new Ajax.Request(contextPath + "/GIACDeferredController", {
					parameters : {
						action : "show24thMethod"
					},
					onCreate : function() {
						showNotice("Loading, please wait...");
					},
					onComplete : function(response) {
						try {
							hideNotice();
							if (checkErrorOnResponse(response)) {
								$("dynamicDiv").update(response.responseText);
								objGiacs044.fromMenu = true;
							}
						} catch (e) {
							showErrorMessage("show24thMethod - onComplete : ",
									e);
						}
					}
				});

			});

	observeAccessibleModule(accessType.MENU, "GICLB001", "acMenuBatchOS", function(){
		objCLMGlobal.callingForm = "GIACS000"; 
		showBatchOsLoss();
	});
	
	//added by shan 06.13.2013
	observeAccessibleModule(accessType.MENU, "GIACS117", "cashReceiptRegister",
			function() {
				checkUserAccessGiacs("GIACS117");
			});

	//added by shan 06.17.2013
	observeAccessibleModule(accessType.MENU, "GIACS093", "pdcRegister",
			function() {
				checkUserAccessGiacs("GIACS093");
			});

	//added by shan 06.18.2013
	observeAccessibleModule(accessType.MENU, "GIACS170",
			"advancedPremiumPayment", function() {
				checkUserAccessGiacs("GIACS170");
			});

	//added by shan 06.25.2013
	observeAccessibleModule(accessType.MENU, "GIACS078", "collectionAnalysis",
			function() {
				checkUserAccessGiacs("GIACS078");
			});

	$("acExit").observe(
			"click",
			function() {
				goToModule("/GIISUserController?action=goToAccounting",
						"Accounting Main", null);
			});

	//Added by mikel 06.04.2013
	observeAccessibleModule(accessType.MENU, "GIACS270", "menuRiBillPayments",
			function() {
				showRiBillPayment(null, null, null);
			});
	//end mikel

	//added by gzelle 
	//06.17.2013
	observeAccessibleModule(accessType.MENU, "GIACS171",
			"premAssumedFromFaculRi", function() {
				showPremAssumedFromFaculRi();
			});

	//07.01.2013
	observeAccessibleModule(accessType.MENU, "GIACS136", "premCededTreaty",
			function() {
				showPremCededTreaty();
			});

	observeAccessibleModule(accessType.MENU, "GIACS220",
			"quarterlyTreatyStatement", function() {
				try {
					new Ajax.Request(contextPath
							+ "/GIACReinsuranceReportsController",
							{
								method : "POST",
								parameters : {
									action : "showQuarterlyTreatyStatement"
								},
								asynchronous : false,
								evalScripts : true,
								onCreate : function() {
									showNotice("Loading, please wait...");
								},
								onComplete : function(response) {
									hideNotice();
									if (checkErrorOnResponse(response)) {
										hideAccountingMainMenus();
										$("acExit").show();
										$("mainContents").update(
												response.responseText);
									}
								}
							});
				} catch (e) {
					showErrorMessage("showQuarterlyTreatyStatementPage", e);
				}
			});

	//Added by steven 06.07.2013
	observeAccessibleModule(accessType.MENU, "GIACS106", "schedRiFacultative",
			function() {
				showSchedRiFacul();
				$("acExit").show();
			});
	observeAccessibleModule(accessType.MENU, "GIACS105", "inwardBusiness",
			function() {
				showInwardBusiness();
				$("acExit").show();
			});
	observeAccessibleModule(accessType.MENU, "GIACS119",
			"lossRecovFacultative", function() {
				showLossRecovFacultative();
				$("acExit").show();
			});
	observeAccessibleModule(accessType.MENU, "GIACS181","premCededToFacultativeRi", function() {
		showpremCededToFacultativeRi();
		$("acExit").show();
	});
	observeAccessibleModule(accessType.MENU, "GIACS183","premDueFromFaculRiAsOf", function() {
		showPremDueFromFaculRiAsOf();
		$("acExit").show();
	});

	//kenneth L. 10.11.2013
	observeAccessibleModule(accessType.MENU, "GIARPR001", "batchReports",
			function() {
				showBatchReports();
				$("acExit").show();
			});

	observeAccessibleModule(accessType.MENU, "GIACS138",
			"distRegisterPerTreaty", function() {
				showDistRegisterPerTreaty();
				$("acExit").show();
			});

	// J. Diago 09.10.2013
	observeAccessibleModule(accessType.MENU, "GIACS128",
			"distRegisterPolicyPerPeril", function() {
				showDistRegisterPolicyPerPeril();
				$("acExit").show();
			});

	observeAccessibleModule(accessType.MENU, "GIACS153",
			"intermediaryProdPerIntm", showIntermediaryProdPerIntm);
	observeAccessibleModule(accessType.MENU, "GIACS275",
			"intermediaryProdPerLine", showIntermediaryProdPerLine);

	//john dolon 08.23.2013
	observeAccessibleModule(accessType.MENU, "GIACS276", "riCommIncAndExp",
			showRiCommIncAndExp);

	//Gzelle 07.19.2013
	observeAccessibleModule(accessType.MENU, "GIACS121", "soaFaculRi",
			showStatementOfAcctFaculRi);

	//shan 07.01.2013
	observeAccessibleModule(accessType.MENU, "GIACS296", "soaOutwardFaculRi",
			showGIACS296Page);

	//shan 07.04.2013
	observeAccessibleModule(accessType.MENU, "GIACS279",
			"soaLossesRecoverable", function() {
				new Ajax.Request(contextPath
						+ "/GIACReinsuranceReportsController", {
					parameters : {
						action : "showGIACS279Page"
					},
					evalScripts : true,
					asynchronous : false,
					onCreate : showNotice("Loading, please wait..."),
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)) {
							$("dynamicDiv").update(response.responseText);
						}
					}
				});
			});

	//shan 07.23.2013
	observeAccessibleModule(accessType.MENU, "GIACS274",
			"listOfBindersAttachedToRedistRecords", function() {
				new Ajax.Request(contextPath
						+ "/GIACReinsuranceReportsController", {
					method : "POST",
					parameters : {
						action : "showGIACS274Page"
					},
					evalScripts : true,
					asynchronous : false,
					onCreate : showNotice("Loading, please wait..."),
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)) {
							$("dynamicDiv").update(response.responseText);
						}
					}
				});
			});

	observeAccessibleModule(accessType.MENU, "GIACS299",
			"paidPoliciesWFacultative", showGIACS299);

	observeAccessibleModule(accessType.MENU, "GIACS149",
			"menuOverridingCommissionVoucher", function() {
				showGIACS149Page(null, null, null, null, null, null);
			});

	observeAccessibleModule(accessType.MENU, "GIACS111",
			"prodRegisterPerPeril", function() {
				showProdRegisterPerPeril();
				$("acExit").show();
			});

	observeAccessibleModule(accessType.MENU, "GIACS601", "convertFile",
			showConvertFile);
	observeAccessibleModule(accessType.MENU, "GIACS602", "processDataListing",
			showProcessDataListing);
 	observeAccessibleModule(accessType.MENU, "GIACS605", "convertedAndUploadedFiles",
			showGIACS605); // Dren Niebres 10.03.2016 SR-4572 : Call GIACS605 Module
	observeAccessibleModule(accessType.MENU, "GIACS606", "convertedRecordsPerStatus", 
			showGIACS606); // Dren Niebres 10.03.2016 SR-4573 : Call GIACS606 Module		

	observeAccessibleModule(accessType.MENU, "GIACS151", "specialReports",
			function() {
				showSpecialReports();
				$("acExit").show();
			});

	observeAccessibleModule(accessType.MENU, "GIACS101", "taxDetailsRegister",
			function() {
				try {
					new Ajax.Request(contextPath
							+ "/GIACEndOfMonthReportsController",
							{
								method : "POST",
								parameters : {
									action : "showTaxDetailsRegister"
								},
								asynchronous : false,
								evalScripts : true,
								onCreate : function() {
									showNotice("Loading, please wait...");
								},
								onComplete : function(response) {
									hideNotice();
									if (checkErrorOnResponse(response)) {
										hideAccountingMainMenus();
										$("mainContents").update(
												response.responseText);
										$("acExit").show();
									}
								}
							});
				} catch (e) {
					showErrorMessage("showTaxDetailsRegister", e);
				}
			});

	observeAccessibleModule(accessType.MENU, "GIPIS901A", "acMenuUwProduction", function(){
		objGIPIS100.callingForm = "GIACS000";
		showUWProductionReportsMainPage();
	});
	
	observeAccessibleModule(accessType.MENU, "GIACS102",
			"undistributedPolicies", function() {
				try {
					new Ajax.Request(contextPath
							+ "/GIACEndOfMonthReportsController", {
						parameters : {
							action : "showUndistributedPolicies"
						},
						asynchronous : false,
						evalScripts : true,
						onCreate : function() {
							showNotice("Loading, please wait...");
						},
						onComplete : function(response) {
							hideNotice("");
							$("mainContents").update(response.responseText);
							hideAccountingMainMenus();
							$("acExit").show();
						}
					});
				} catch (e) {
					showErrorMessage("showUndistributedPolicies", e);
				}
			});

	observeAccessibleModule(accessType.MENU, "GIACS150", "ageBills",
			showGIACS150);
	observeAccessibleModule(accessType.MENU, "GIACS412", "cancelledPolicies",
			function() {
				try {
					new Ajax.Request(contextPath
							+ "/GIACCreditAndCollectionUtilitiesController",
							{
								method : "POST",
								parameters : {
									action : "showCancelledPolicies"
								},
								asynchronous : false,
								evalScripts : true,
								onCreate : function() {
									showNotice("Loading, please wait...");
								},
								onComplete : function(response) {
									hideNotice();
									if (checkErrorOnResponse(response)) {
										hideAccountingMainMenus();
										$("acExit").show();
										$("mainContents").update(
												response.responseText);
									}
								}
							});
				} catch (e) {
					showErrorMessage("showCancelledPolicies", e);
				}
			});

	observeAccessibleModule(accessType.MENU, "GIACS190",
			"expenseReportPerDept", function() {
				try {
					new Ajax.Request(contextPath
							+ "/GIACGeneralDisbursementReportsController",
							{
								method : "POST",
								parameters : {
									action : "showExpenseReportPerDept"
								},
								asynchronous : false,
								evalScripts : true,
								onCreate : function() {
									showNotice("Loading, please wait...");
								},
								onComplete : function(response) {
									hideNotice();
									if (checkErrorOnResponse(response)) {
										hideAccountingMainMenus();
										$("acExit").show();
										$("mainContents").update(
												response.responseText);
									}
								}
							});
				} catch (e) {
					showErrorMessage("showCancelledPolicies", e);
				}
			});

	observeAccessibleModule(accessType.MENU, "GIACS221", "commissionInquiry",
			function() {
				showCommissionInquiry(null, null, null);
			});

	/*Added for additional validation. Hides below-listed menu when user is not in GIAC_DCB_USERS -Bryan 03.10.2011*/
	if ($F("hidIsUserDCBUser") != "Y") {
		disableMenu("orListing");
		disableMenu("generateOR");
		//uncomment, manual OR menu should be disabled if user is not in GIAC_DCB_USERS
		disableMenu("enterManualOR"); //removed, to be checked in giac_functions if MO function exists (emman 05.17.2011)
		//disableMenu("generateOtherOR");
		//disableMenu("enterOtherManualOR");
	}

	if (hasMOFunction != "Y") {
		disableMenu("enterManualOR");
		disableMenu("enterOtherManualOR");
	}

	if (hasORFunction != "Y" || hasORCancellation != "Y") { //marco - 09.11.2014 - added hasORCancellation
		disableMenu("cancelOR");
		disableMenu("cancelOtherOR");
	}
	if (!validateUserFunc2("RQ", "GIACM000")) { // irwin
		disableMenu("cancelRequest");
		disableMenu("obrCancelRequest"); //added by steven 06.05.2013 
	}

	// Maintenance
	observeAccessibleModule(accessType.MENU, "GIACS311", "chartOfAccounts", showGiacs311);
	observeAccessibleModule(accessType.MENU, "GIACS310", "menuParameter",
			showGiacs301); //shan 11.25.2013
	observeAccessibleModule(accessType.MENU, "GIACS310", "menuAgingParameters",
			showGiacs310);
	observeAccessibleModule(accessType.MENU, "GIACS321", "menuModuleEntry",
			showGiacs321);
	observeAccessibleModule(accessType.MENU, "GIACS313", "menuAccountingUser",
			showGiacs313);
	observeAccessibleModule(accessType.MENU, "GIACS302", "menuCompany",
			showGiacs302);
	observeAccessibleModule(accessType.MENU, "GIACS303", "menuBranches",
			showGiacs303);
	observeAccessibleModule(accessType.MENU, "GIACS305", "menuDepartment",
			showGiacs305);
	observeAccessibleModule(accessType.MENU, "GIACS308",
			"menuSubsidiaryLedgerType", showGiacs308);
	observeAccessibleModule(accessType.MENU, "GIACS318", "menuWithholdingTax",
			showGiacs318);
	observeAccessibleModule(accessType.MENU, "GIACS320", "menuTax", showGIACS320);
	observeAccessibleModule(accessType.MENU, "GIACS307", "menuBank",
			showGiacs307);
	observeAccessibleModule(accessType.MENU, "GIACS312", "menuBankAccount",
			showGiacs312);
	observeAccessibleModule(accessType.MENU, "GIACS323", "menuJvTran",
			showGiacs323);
	observeAccessibleModule(accessType.MENU, "GIACS306",
			"menuPaymentRequestDocument", showGiacs306);
	observeAccessibleModule(accessType.MENU, "GIACS600", "fileSources",
			showFileSource);
	observeAccessibleModule(accessType.MENU, "GIACS335", "menuSoaTitle",
			showGiacs335);
	observeAccessibleModule(accessType.MENU, "GIACS355", "menuORPrefix",
			showGiacs355);
	observeAccessibleModule(accessType.MENU, "GIACS316", "menuDocSeqPerUser",
			showGiacs316);
	observeAccessibleModule(accessType.MENU, "GIISS094", "menuTreatyType",
			showGiiss094);
	observeAccessibleModule(accessType.MENU, "GIACS322", "menuDocSeqPerBranch",
			showGiacs322);
	observeAccessibleModule(accessType.MENU, "GIACS352",
			"monthEndCheckingScripts", showGiacs352);
	observeAccessibleModule(accessType.MENU, "GIACS350", "monthEndReport",
			showGiacs350);
	observeAccessibleModule(accessType.MENU, "GIACS351",
			"monthEndReportDetail", function() {
				showGiacs351("menu", null);
			});
	observeAccessibleModule(accessType.MENU, "GIACS324",
			"bookAndBankTransactions", showGiacs324);
	observeAccessibleModule(accessType.MENU, "GIACS334",
			"profitCommissionRate", showGiacs334);
	observeAccessibleModule(accessType.MENU, "GIACS314",
			"menuAccountingFunction", showGiacs314);
	observeAccessibleModule(accessType.MENU, "GIACS317", "menuModuleMaintenance",
			showGiacs317);

	// Budget Modules J. Diago 09.24.2013
	observeAccessibleModule(accessType.MENU, "GIACS510",
			"menuSubsidiaryOfExpenses", showGiacs510);
	observeAccessibleModule(accessType.MENU, "GIACS360", "budgetMaintenance",
			showGiacs360);
	
	observeAccessibleModule(accessType.MENU, "GIACS319", "menuDCBUser", showGiacs319);	//shan 12.06.2013
	observeAccessibleModule(accessType.MENU, "GIACS038", "menuTransactionMonth", showGiacs038);	//shan 12.12.2013
	observeAccessibleModule(accessType.MENU, "GIACS315", "menuUserPerFunction", showGiacs315);	//shan 12.16.2013
	observeAccessibleModule(accessType.MENU, "GIACS309", "menuSubsidiaryLedger", showGiacs309);	//shan 12.18.2013
	observeAccessibleModule(accessType.MENU, "GIACS032", "postDatedChecks", showGiacs032); //john 08.29.2014
	//added by robert SR 4953 10.28.15
	observeAccessibleModule(accessType.MENU, "GICLS202", "bordereauxClaimsRegister", function(){
		objAC.fromACMenu = "Y";
		showBordereauxClaimsRegister();
	});
	observeAccessibleModule(accessType.MENU, "GICLS207", "batchOSPrinting", function(){
				try{
					objAC.fromACMenu = "Y";
					new Ajax.Request(contextPath + "/GICLBatchOSPrintingController", {
					    parameters : {action : "showBatchOSPrinting"},
					    asynchronous: false,
						evalScripts: true,
					    onCreate : showNotice("Loading, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response)){
								$("dynamicDiv").update(response.responseText);
							}
						} 
					});
				}catch(e){
					showErrorMessage("batchOSPrinting menu:", e); 
				}	
	});
	observeAccessibleModule(accessType.MENU, "GICLS150", "menuClaimPayee", function(){
		objAC.fromACMenu = "Y";
		objCLMGlobal.callingForm = ""; 
		showMenuClaimPayeeClass(null, null);
	});
	observeAccessibleModule(accessType.MENU, "GICLS180", "menuReportDocument", function(){
		objAC.fromACMenu = "Y";
		showGICLS180();
	});
	observeAccessibleModule(accessType.MENU, "GICLS181", "menuRepSignatory", function(){
		objAC.fromACMenu = "Y";
		showGicls181();
	});
	//end robert SR 4953 10.28.15
	observeAccessibleModule(accessType.MENU, "GICLS140", "menuPayeeClass", function(){
		objAC.fromACPayee = "Y";
		showGICLS140();
	});
	
	//john 09.15.2014
	if(nvl(userFunctionValid.validTag, "N") == "N"){
		disableMenu("cancelOR");
		disableMenu("cancelOtherOR");
	}else if(nvl(userFunctionValid.validityDate, "") != "" && compareDatesIgnoreTime(Date.parse(userFunctionValid.validityDate, 'mm-dd-yyyy'), new Date()) == -1){
		disableMenu("cancelOR");
		disableMenu("cancelOtherOR");
	}else if(nvl(userFunctionValid.terminationDate, "") != "" && compareDatesIgnoreTime(Date.parse(userFunctionValid.terminationDate, 'mm-dd-yyyy'), new Date()) == 1){
		disableMenu("cancelOR");
		disableMenu("cancelOtherOR");
	}
	
	observeAccessibleModule(accessType.MENU, "GIACS340", "glControlAcctType", showGiacs340);	//Gzelle 11052015 KB#132 AP/AR ENH
</script>
<!--END MAIN NAV-->