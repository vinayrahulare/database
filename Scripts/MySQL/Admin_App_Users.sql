use teladoc_eds;
-- EDS Admin App
-- Active Admin Users
SELECT a.Admin_ID, DATE(a.Effective_Start_DT) AS Effective_Start_DT, DATE(a.Effective_End_DT) AS Effective_End_DT,
CASE WHEN DATE(NOW()) >= IFNULL(a.Effective_End_DT, DATE(NOW()) + INTERVAL 1 MONTH) THEN 'Termed'
WHEN DATE(NOW()) < DATE(a.Effective_Start_DT) THEN 'Future' ELSE 'Active' END AS Active,
p.First_NM, p.Last_NM, p.User_NM, pea.Email_Address, rur.Name AS Role_NM, urr.User_Role_CD, p.Last_Session_DT
FROM admins a
INNER JOIN persons p ON p.Person_ID=a.Person_ID AND p.Exclusion_CD='IN'
INNER JOIN party_email_addresses pea ON pea.Party_ID = p.Party_ID AND pea.Exclusion_CD = 'IN'
AND pea.Party_Email_Address_ID = (SELECT Party_Email_Address_ID FROM party_email_addresses WHERE Party_ID = pea.Party_ID ORDER BY Updated_At DESC, Email_Type_CD DESC LIMIT 1)
LEFT OUTER JOIN user_role_relations urr ON urr.User_ID=a.Admin_ID AND urr.User_Type='Admin' AND urr.Exclusion_CD='IN'
LEFT OUTER JOIN ref_user_roles rur ON rur.User_Role_CD=urr.User_Role_CD
WHERE a.Exclusion_CD='IN' AND CURRENT_DATE() BETWEEN DATE(a.Effective_Start_DT) AND IFNULL(a.Effective_End_DT, '9999-12-31')
LIMIT 100000;

-- Inactive Admin Users
SELECT a.Admin_ID, DATE(a.Effective_Start_DT) AS Effective_Start_DT, DATE(a.Effective_End_DT) AS Effective_End_DT,
CASE WHEN a.Exclusion_CD<>'IN' THEN 'Void' WHEN DATE(NOW()) >= IFNULL(a.Effective_End_DT, DATE(NOW()) + INTERVAL 1 MONTH) THEN 'Termed'
WHEN DATE(NOW()) < DATE(a.Effective_Start_DT) THEN 'Future' ELSE 'Active' END AS Active,
p.First_NM, p.Last_NM, p.User_NM, pea.Email_Address, rur.Name AS Role_NM, urr.User_Role_CD, p.Last_Session_DT, a.Updated_At AS Term_DT
FROM admins a
INNER JOIN persons p ON p.Person_ID=a.Person_ID AND p.Exclusion_CD='IN'
INNER JOIN party_email_addresses pea ON pea.Party_ID = p.Party_ID AND pea.Exclusion_CD = 'IN'
AND pea.Party_Email_Address_ID = (SELECT Party_Email_Address_ID FROM party_email_addresses WHERE Party_ID = pea.Party_ID ORDER BY Updated_At DESC, Email_Type_CD DESC LIMIT 1)
LEFT OUTER JOIN user_role_relations urr ON urr.User_ID=a.Admin_ID AND urr.User_Type='Admin' -- AND urr.Exclusion_CD='IN'
LEFT OUTER JOIN ref_user_roles rur ON rur.User_Role_CD=urr.User_Role_CD
WHERE IFNULL(a.Effective_End_DT,'9999-12-31') < CURDATE() AND a.Updated_At > '2019-01-01 00:00:00'
ORDER BY a.Updated_At DESC, p.Last_NM, p.First_NM
LIMIT 100000;
