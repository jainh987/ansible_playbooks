
CREATE OR REPLACE FUNCTION create_language_plpgsql() RETURNS void AS $$
DECLARE 
  cnt integer;
BEGIN
  SELECT count(*) INTO cnt FROM OpReporterDefaultConfigItem WHERE Name = 'StageDirFlushTimeout';
  IF (cnt > 0) THEN
    EXECUTE 'UPDATE OpReporterDefaultConfigItem SET StartVersion=''1.180'', EndVersion=NULL, Description=''How long (seconds) this reporter will try to flush data to Control>Center, if flushing on reporter shutdown is requested.'', ItemType=''LONG'', Value=''10'', ReporterParameterGroupType=''NORMAL'', ReporterConfigValueType=''CONFIG'' WHERE Name = ''StageDirFlushTimeout''';
  ELSE
    EXECUTE 'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name, StartVersion, EndVersion, Description, ItemType, Value, ReporterParameterGroupType, ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''), ''StageDirFlushTimeout'', ''1.180'', NULL, ''How long (seconds) this reporter will try to flush data to Control>Center, if flushing on reporter shutdown is requested.'', ''LONG'', ''10'', ''NORMAL'', ''CONFIG'')';
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION create_opreporter_config_item() RETURNS void AS $$
DECLARE 
  cnt integer;
BEGIN
  SELECT count(*) INTO cnt FROM OpConfigValue WHERE Name = 'SchemaVersion';
  IF (cnt > 0) THEN
    EXECUTE 'UPDATE OpConfigValue SET ValueTypeEnum=''STRING'', IsHidden=''Y'', Description=''Database schema number'', Value=''4.2.3'' WHERE Name=''SchemaVersion''';
  ELSE
    EXECUTE 'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''), ''SchemaVersion'', ''Database schema number'', ''STRING'', ''4.2.3'', ''Y'')';
  END IF;
END;
$$ LANGUAGE plpgsql;

-- Other parts of the file remain the same.
-- Ensure all CREATE OR REPLACE FUNCTION statements follow the correct pattern.
