SELECT
	*,
	record::id(id) AS id,
	(SELECT status, username FROM <-ownsPlace<-user)[0] AS owner,
	(SELECT text, updated FROM $parent.description
	ORDER BY updated)[$] AS description
FROM $place;
