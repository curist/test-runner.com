local fennel = require("fennel")

fennel.path = fennel.path .. ";/zip/.fnl/?.fnl"
fennel.path = fennel.path .. ";/zip/?.fnl"

fennel.install({ correlate = true })

-- Override debug.traceback with Fennel's traceback for better stack traces
-- This will provide correct line numbers from Fennel source code
debug.traceback = fennel.traceback
