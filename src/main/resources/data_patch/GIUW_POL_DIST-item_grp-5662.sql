BEGIN
  UPDATE giuw_pol_dist
     SET item_grp = 1
   WHERE item_grp IS NULL;
   
  COMMIT;   
END;
/