SET SERVEROUTPUT ON
BEGIN

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- professional/talent fees paid to juridical persons/individuals(lawyers, CPAs, etc.)', IND_CORP_TAG = 'I'
WHERE BIR_TAX_CD = 'WI010';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- professional/talent fees paid to juridical persons/individuals(lawyers, CPAs, etc.)', IND_CORP_TAG = 'C'
WHERE BIR_TAX_CD = 'WC010';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- professional entertainers- if the current year''s gross income does not exceed P720,000.00', IND_CORP_TAG = 'I'
WHERE BIR_TAX_CD = 'WI020';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- professional entertainers- if the current year''s gross income exceeds P720,000.00', IND_CORP_TAG = 'I'
WHERE BIR_TAX_CD = 'WI021';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- professional athletes- if the current year''s gross income does not exceed P720,000.00', IND_CORP_TAG = 'I'
WHERE BIR_TAX_CD = 'WI030';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- professional athletes- if the current year''s gross income exceeds P720,000.00', IND_CORP_TAG = 'I'
WHERE BIR_TAX_CD = 'WI031';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- movie, stage, radio, television and musical directors-  if the current year''s gross income does not exceed P720,000.00', IND_CORP_TAG = 'I'
WHERE BIR_TAX_CD = 'WI040';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- movie, stage, radio, television and musical directors-  if the current year''s gross income exceeds P720,000.00', IND_CORP_TAG = 'I'
WHERE BIR_TAX_CD = 'WI041';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- management and technical consultants', IND_CORP_TAG = 'I'
WHERE BIR_TAX_CD = 'WI050';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- bookkeeping agents and agencies', IND_CORP_TAG = 'I'
WHERE BIR_TAX_CD = 'WI060';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- insurance agents and insurance adjusters', IND_CORP_TAG = 'I'
WHERE BIR_TAX_CD = 'WI070';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- other recipient of talent fees- if the current year''s gross income does not exceed P720,000.00', IND_CORP_TAG = 'I'
WHERE BIR_TAX_CD = 'WI080';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- other recipient of talent fees- if the current year''s gross income exceeds P720,000.00', IND_CORP_TAG = 'I'
WHERE  BIR_TAX_CD = 'WI081';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- fees of directors who are not employees of the company', IND_CORP_TAG = 'I'
WHERE BIR_TAX_CD = 'WI090';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- rentals : real/personal properties, poles,satellites '||'&'||' transmission facilities, billboards', IND_CORP_TAG = 'I'
WHERE BIR_TAX_CD = 'WI100';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- rentals : real/personal properties, poles,satellites '||'&'||' transmission facilities, billboards', IND_CORP_TAG = 'C'
WHERE BIR_TAX_CD = 'WC100';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- cinematographic film rentals', IND_CORP_TAG = 'I'
WHERE BIR_TAX_CD = 'WI110';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- cinematographic film rentals', IND_CORP_TAG = 'C'
WHERE BIR_TAX_CD = 'WC110';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- prime contractors/sub-contractors', IND_CORP_TAG = 'I'
WHERE BIR_TAX_CD = 'WI120';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- prime contractors/sub-contractors', IND_CORP_TAG = 'C'
WHERE BIR_TAX_CD = 'WC120';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- income distribution to beneficiaries of estates '||'&'||' trusts', IND_CORP_TAG = 'I'
WHERE BIR_TAX_CD = 'WI130';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- gross commission or service fees of custom, insurance, stock, real estate, immigration '||'&'||' commercial brokers '||'&'||' fees of agents of professional entertainers', IND_CORP_TAG = 'I'
WHERE BIR_TAX_CD = 'WI140';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- gross commission or service fees of custom, insurance, stock, real estate, immigration '||'&'||' commercial brokers '||'&'||' fees of agents of professional entertainers', IND_CORP_TAG = 'C'
WHERE BIR_TAX_CD = 'WC140';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- payments for medical practitioners through a duly registered professional partnership', IND_CORP_TAG = 'I'
WHERE BIR_TAX_CD = 'WI141';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- payments for medical/dental /veterinary services thru hospitals/clinics/ health maintenance organizations, including direct payments to service providers', IND_CORP_TAG = 'I'
WHERE BIR_TAX_CD = 'WI151';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- payments to partners of general professional partnerships', IND_CORP_TAG = 'I'
WHERE BIR_TAX_CD = 'WI152';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- payments made by credit card companies',IND_CORP_TAG = 'I'
WHERE BIR_TAX_CD = 'WI156';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- payments made by credit card companies', IND_CORP_TAG = 'C'
WHERE BIR_TAX_CD = 'WC156';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- payments made by government offices on their local purchase of goods '||'&'||' services from local/resident suppliers', IND_CORP_TAG = 'I'
WHERE BIR_TAX_CD = 'WI157';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- payments made by government offices on their local purchase of goods '||'&'||' services from local/resident suppliers', IND_CORP_TAG = 'C'
WHERE BIR_TAX_CD = 'WC157';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- Income payments made by top 10,000 private corporations to their local/resident supplier of goods', IND_CORP_TAG = 'I'
WHERE BIR_TAX_CD = 'WI158';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- Income payments made by top 10,000 private corporations to their local/resident supplier of goods', IND_CORP_TAG = 'C'
WHERE BIR_TAX_CD = 'WC158';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- additional payments to government personnel from importers, shipping and airline companies or their agents for overtime services', IND_CORP_TAG = 'I'
WHERE BIR_TAX_CD = 'WI159';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- Income payments made by top 10,000 private corporations to their local/resident supplier of services', IND_CORP_TAG = 'I'
WHERE BIR_TAX_CD = 'WI160';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- Income payments made by top 10,000 private corporations to their local/resident supplier of services', IND_CORP_TAG = 'C'
WHERE BIR_TAX_CD = 'WC160';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- commission,rebates, discounts '||'&'||' other similar considerations paid/granted to independent '||'&'||' exclusive distributors, medical/technical '||'&'||' sales representatives '||'&'||' marketing agents '||'&'||' sub-agents of multi-level marketing companies', IND_CORP_TAG = 'I'
WHERE BIR_TAX_CD = 'WI515';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- commission,rebates, discounts '||'&'||' other similar considerations paid/granted to independent '||'&'||' exclusive distributors, medical/technical '||'&'||' sales representatives '||'&'||' marketing agents '||'&'||' sub-agents of multi-level marketing companies', IND_CORP_TAG = 'C'
WHERE BIR_TAX_CD = 'WC515';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT - Gross payments to embalmers by funeral companies', IND_CORP_TAG = 'I'
WHERE BIR_TAX_CD = 'WI530';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT - payments made by pre-need companies to funeral parlors', IND_CORP_TAG = 'I'
WHERE BIR_TAX_CD = 'WI535';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT - payments made by pre-need companies to funeral parlors', IND_CORP_TAG = 'C'
WHERE BIR_TAX_CD = 'WC535';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- Tolling fee paid to refineries', IND_CORP_TAG = 'I'
WHERE BIR_TAX_CD = 'WI540';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- Tolling fee paid to refineries', IND_CORP_TAG = 'C'
WHERE BIR_TAX_CD = 'WC540';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- Income payments made to suppliers of agricultural products', IND_CORP_TAG = 'I'
WHERE BIR_TAX_CD = 'WI610';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- Income payments made to suppliers of agricultural products', IND_CORP_TAG = 'C'
WHERE BIR_TAX_CD = 'WC610';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- Income payments on purchases of minerals, mineral products '||'&'||' quarry resources', IND_CORP_TAG = 'I'
WHERE  BIR_TAX_CD = 'WI630';

UPDATE GIAC_WHOLDING_TAXES
SET WHTAX_DESC = 'EWT- Income payments on purchases of minerals, mineral products '||'&'||' quarry resources', IND_CORP_TAG = 'C'
WHERE BIR_TAX_CD = 'WC630';

COMMIT;
END;
