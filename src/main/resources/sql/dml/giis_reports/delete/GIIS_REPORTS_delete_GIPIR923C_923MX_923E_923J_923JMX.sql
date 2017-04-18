DELETE FROM cpi.giis_reports
      WHERE report_id IN
               ('GIPIR923J',
                'GIPIR923E',
                'GIPIR923E_MX',
                'GIPIR923J_MX',
                'GIPIR923_MX');


COMMIT;