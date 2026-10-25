-- Prints applied migrations; used in preflight to confirm the expected base version.
select version, description, status, applied_at
from   poc_schema_migrations
order  by version;
