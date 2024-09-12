require 'logger'

logger_path = 'C:/Scripts/scanned_docs/logs.log'
storage_logger_path = 'C:/Scripts/scanned_docs/storage.log'

$logger = Logger.new(logger_path)
$storage_log = Logger.new(storage_logger_path)

def storage_logger(message = "Nuevo archivo", file_name = "")
  $storage_log.info("======================================")
  $storage_log.info(message)
  $storage_log.info(file_name)
end
